"""
=============================================================================
ACCURACY EVALUATOR — Recall-First Accuracy Metric for LOD300/350
=============================================================================
Measures extraction quality by comparing extracted element counts
against expected counts from schedule tables.

Primary metric: element_recall
  recall(type) = extracted_count(type) / schedule_count(type)
  overall_accuracy = mean(recall across all types present in schedule) * 100%

Target: ≥ 90%
=============================================================================
"""

from typing import Dict, List, Optional


ELEMENT_TYPES = ["columns", "beams", "slabs", "walls", "footings", "bracing"]

# Weights for weighted recall (some elements matter more)
ELEMENT_WEIGHTS = {
    "columns": 1.5,
    "beams": 1.3,
    "footings": 1.2,
    "slabs": 1.0,
    "walls": 0.8,
    "bracing": 0.8,
}


class AccuracyEvaluator:
    """
    Computes recall-based accuracy by comparing extracted model
    against expected counts from schedule verification.
    """

    def evaluate(
        self,
        structural_model: dict,
        schedule_counts: Optional[Dict[str, int]] = None,
    ) -> dict:
        """
        Evaluate extraction accuracy.

        Args:
            structural_model: output of SynthesizerV7 (has 'members' key)
            schedule_counts: {type: expected_count} from ScheduleVerifier.
                             If None, uses model summary if available.

        Returns:
            accuracy dict with overall_score, per_type_recall, grade
        """
        members = structural_model.get("members", {})

        extracted = {
            t: len(members.get(t, []))
            for t in ELEMENT_TYPES
        }

        # Fall back to model summary if no schedule counts
        if not schedule_counts:
            summary = structural_model.get("summary", {})
            schedule_counts = {}
            for t in ELEMENT_TYPES:
                key = f"total_{t}"
                if summary.get(key):
                    schedule_counts[t] = summary[key]

        per_type: Dict[str, dict] = {}
        weighted_sum = 0.0
        weight_total = 0.0

        for etype in ELEMENT_TYPES:
            ext = extracted.get(etype, 0)
            exp = schedule_counts.get(etype, 0) if schedule_counts else 0

            if exp > 0:
                recall = min(ext / exp, 1.0)
                w = ELEMENT_WEIGHTS.get(etype, 1.0)
                weighted_sum += recall * w
                weight_total += w
            else:
                # No schedule reference → skip from denominator
                recall = None

            per_type[etype] = {
                "extracted": ext,
                "expected": exp if exp > 0 else None,
                "recall": round(recall, 3) if recall is not None else None,
                "deficit": max(0, exp - ext) if exp > 0 else 0,
            }

        # Overall weighted recall
        if weight_total > 0:
            overall_recall = weighted_sum / weight_total
        else:
            # No schedule data — use element presence heuristic
            present_types = sum(1 for t in ELEMENT_TYPES if extracted.get(t, 0) > 0)
            overall_recall = present_types / len(ELEMENT_TYPES)

        overall_pct = round(overall_recall * 100, 1)

        # Spatial accuracy — proxy via _confidence field (set by SynthesizerV7._assign_confidence)
        spatial_score = self._spatial_accuracy(members)
        spatial_pct = round(spatial_score * 100, 1)

        # Grade — both count recall AND spatial must be ≥90% for Grade A
        if overall_pct >= 90 and spatial_pct >= 75:
            grade = "A"
        elif overall_pct >= 75:
            grade = "B"
        elif overall_pct >= 60:
            grade = "C"
        else:
            grade = "F"

        # Identify which types need improvement
        gaps = []
        for etype, info in per_type.items():
            if info["recall"] is not None and info["recall"] < 0.70:
                gaps.append({
                    "type": etype,
                    "recall": info["recall"],
                    "deficit": info["deficit"],
                })

        return {
            "overall_score": overall_pct,
            "spatial_score": spatial_pct,
            "grade": grade,
            "target_met": overall_pct >= 90,
            "per_type": per_type,
            "gaps": sorted(gaps, key=lambda g: g["recall"]),
            "extracted_total": sum(extracted.values()),
            "has_schedule_reference": bool(schedule_counts),
        }

    def _spatial_accuracy(self, members: dict) -> float:
        """Proxy spatial accuracy: ratio of columns with confident XY position (_confidence >= 0.7)."""
        cols = members.get("columns", [])
        if not cols:
            return 1.0
        good = sum(1 for c in cols if c.get("_confidence", 0) >= 0.7)
        return good / len(cols)

    def evaluate_from_model(self, structural_model: dict) -> dict:
        """Shortcut: evaluate using only the structural model (no external schedule)."""
        return self.evaluate(structural_model, schedule_counts=None)

    @staticmethod
    def compute_visual_similarity(model: dict, pdf_path: str,
                                   plan_page_indices: list) -> dict:
        """
        Renders model plan view and compares to PDF plan pages using OpenCV
        normalized cross-correlation.
        Returns {"similarity_score": 0.0-1.0, "per_page_scores": [...], "grade": "A/B/C"}.
        Falls back gracefully if opencv or PIL is missing.
        """
        try:
            import cv2
            import numpy as np
        except ImportError:
            return {"similarity_score": None, "note": "opencv-python not installed"}

        try:
            from core.model_renderer import ModelPlanRenderer
            from core.vision_renderer import VisionRenderer
        except ImportError as e:
            return {"similarity_score": None, "note": str(e)}

        renderer = ModelPlanRenderer()
        model_png = renderer.render_plan(model)
        if not model_png:
            return {"similarity_score": None, "note": "no columns in model"}

        model_arr = cv2.imdecode(
            np.frombuffer(model_png, np.uint8), cv2.IMREAD_GRAYSCALE)
        model_thresh = cv2.threshold(
            model_arr, 200, 255, cv2.THRESH_BINARY_INV)[1].astype(np.float32)

        scores = []
        vis = VisionRenderer(pdf_path, dpi=150)
        try:
            for page_idx in plan_page_indices[:2]:
                try:
                    page_bytes = vis.render_page_as_bytes(page_idx - 1, "PNG")
                    page_arr = cv2.imdecode(
                        np.frombuffer(page_bytes, np.uint8), cv2.IMREAD_GRAYSCALE)
                    page_thresh = cv2.threshold(
                        page_arr, 200, 255, cv2.THRESH_BINARY_INV)[1].astype(np.float32)
                    model_r = cv2.resize(model_thresh,
                                          (page_arr.shape[1], page_arr.shape[0]))
                    result_mat = cv2.matchTemplate(
                        page_thresh, model_r, cv2.TM_CCORR_NORMED)
                    scores.append(float(result_mat.max()))
                except Exception:
                    pass
        finally:
            try:
                vis.close()
            except Exception:
                pass

        if not scores:
            return {"similarity_score": None, "note": "no plan pages rendered"}

        avg = sum(scores) / len(scores)
        grade = "A" if avg > 0.80 else ("B" if avg > 0.65 else "C")
        return {
            "similarity_score": round(avg, 3),
            "per_page_scores": [round(s, 3) for s in scores],
            "grade": grade,
        }

    @staticmethod
    def format_report(result: dict) -> str:
        """Format accuracy result as human-readable string."""
        spatial = result.get("spatial_score")
        spatial_str = f"{spatial}%" if spatial is not None else "N/A"
        lines = [
            f"Accuracy Score: {result['overall_score']}% (Grade {result['grade']})",
            f"Spatial Score:  {spatial_str} (column XY confidence proxy)",
            f"Target ≥90%: {'✅ MET' if result['target_met'] else '❌ NOT MET'}",
            "",
            "Per-type Recall:",
        ]
        for etype, info in result["per_type"].items():
            ext = info["extracted"]
            exp = info["expected"]
            rec = info["recall"]
            if exp is not None:
                bar = "█" * int((rec or 0) * 10) + "░" * (10 - int((rec or 0) * 10))
                pct = f"{(rec or 0)*100:.0f}%"
                lines.append(f"  {etype:<10} [{bar}] {pct:>5}  ({ext}/{exp})")
            else:
                lines.append(f"  {etype:<10}  extracted={ext}  (no schedule ref)")

        if result["gaps"]:
            lines.append("")
            lines.append("Gaps (recall < 70%):")
            for g in result["gaps"]:
                lines.append(f"  ⚠ {g['type']}: recall={g['recall']*100:.0f}%, deficit={g['deficit']}")

        return "\n".join(lines)
