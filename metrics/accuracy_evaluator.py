"""
=============================================================================
ACCURACY EVALUATOR — Composite Quality Metric for LOD300/350
=============================================================================
Primary metric: composite_score = 0.40 × recall + 0.60 × geometry_score

  recall     = weighted element count vs schedule (presence only)
  geometry   = avg(section_rate, beam_connectivity, col_xy_quality)
               section_rate:     % of members with real steel section names
               beam_connectivity: % of beams with from_col/to_col filled
               col_xy_quality:   % of columns not force-assigned to grid

Grade: A≥85  B≥70  C≥55  F<55 (based on composite, not recall alone)
Target: composite ≥ 70% (was recall ≥ 90% — that was misleadingly easy to pass)
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
            recall_ratio = weighted_sum / weight_total
        else:
            # No schedule data — use element presence heuristic
            present_types = sum(1 for t in ELEMENT_TYPES if extracted.get(t, 0) > 0)
            recall_ratio = present_types / len(ELEMENT_TYPES)

        recall_pct = round(recall_ratio * 100, 1)

        # Geometry quality — 3 sub-scores
        quality_detail = self._geometry_quality(members)
        geometry_score = quality_detail["geometry_score"]
        geometry_pct   = round(geometry_score * 100, 1)

        # Composite score — geometry weighted 60%, recall 40%
        composite = 0.40 * recall_ratio + 0.60 * geometry_score
        composite_pct = round(composite * 100, 1)

        # Grade based on composite (not recall alone)
        if composite_pct >= 85:
            grade = "A"
        elif composite_pct >= 70:
            grade = "B"
        elif composite_pct >= 55:
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
            "overall_score": composite_pct,   # PRIMARY — composite quality
            "recall_score":  recall_pct,       # element count recall
            "spatial_pct":   geometry_pct,     # geometry quality
            "spatial_score": geometry_pct,     # alias (backward compat)
            "grade":         grade,
            "target_met":    composite_pct >= 70,
            "per_type":      per_type,
            "gaps":          sorted(gaps, key=lambda g: g["recall"]),
            "extracted_total": sum(extracted.values()),
            "has_schedule_reference": bool(schedule_counts),
            "quality_detail": quality_detail,
        }

    def _geometry_quality(self, members: dict) -> dict:
        """
        Geometry quality — 3 sub-scores:
          1. col_xy_quality:     % of columns not force-assigned to grid (real XY)
          2. section_rate:       % of ALL members with real steel section prefixes
          3. beam_connectivity:  % of beams with from_col/to_col filled

        Returns dict with individual scores + weighted geometry_score.
        """
        cols   = members.get("columns", [])
        beams  = members.get("beams", [])
        brace  = members.get("bracing", [])
        _SECTION_PFXS = ('CHS', 'SHS', 'RHS', 'UB', 'UC', 'PFC', 'FB', 'WB', 'WC',
                          'TFB', 'EA', 'UA', 'PF', 'BFC', 'RFL')

        # Sub-score 1: column XY quality
        col_xy = (
            sum(1 for c in cols if not c.get("_force_assigned") and c.get("_confidence", 0) >= 0.7)
            / len(cols)
        ) if cols else 1.0

        # Sub-score 2: section realism
        all_members = cols + beams + brace
        col_sec = (
            sum(1 for c in cols if any(str(c.get("section") or "").upper().startswith(p) for p in _SECTION_PFXS))
            / len(cols)
        ) if cols else 0.0
        beam_sec = (
            sum(1 for b in beams if any(str(b.get("section") or "").upper().startswith(p) for p in _SECTION_PFXS))
            / len(beams)
        ) if beams else 0.0
        section_rate = (
            sum(1 for m in all_members if any(str(m.get("section") or "").upper().startswith(p) for p in _SECTION_PFXS))
            / len(all_members)
        ) if all_members else 0.0

        # Sub-score 3: beam connectivity
        beam_conn = (
            sum(1 for b in beams if (b.get("from_col") or b.get("from")) and (b.get("to_col") or b.get("to")))
            / len(beams)
        ) if beams else 0.0

        # Weighted geometry score: connectivity matters most, then sections, then XY
        geometry_score = (
            0.30 * col_xy +
            0.40 * section_rate +
            0.30 * beam_conn
        )

        return {
            "geometry_score":    round(geometry_score, 3),
            "col_xy_quality":    round(col_xy, 3),
            "col_section_pct":   round(col_sec, 3),
            "beam_section_pct":  round(beam_sec, 3),
            "section_rate":      round(section_rate, 3),
            "beam_connectivity": round(beam_conn, 3),
        }

    def _spatial_accuracy(self, members: dict) -> float:
        """Backward-compat wrapper."""
        return self._geometry_quality(members)["geometry_score"]

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
        composite = result.get("overall_score", 0)
        recall    = result.get("recall_score", result.get("overall_score", 0))
        spatial   = result.get("spatial_pct",  result.get("spatial_score", 0))
        qd        = result.get("quality_detail", {})

        lines = [
            f"Composite Score: {composite}% (Grade {result['grade']}) "
            f"{'✅ TARGET MET' if result['target_met'] else '❌ Below 70%'}",
            f"  = 40% × Recall({recall}%) + 60% × Geometry({spatial}%)",
            f"",
            f"Geometry breakdown:",
            f"  col_section:     {qd.get('col_section_pct',0)*100:.0f}%  (target ≥50%)",
            f"  beam_section:    {qd.get('beam_section_pct',0)*100:.0f}%  (target ≥50%)",
            f"  beam_connect:    {qd.get('beam_connectivity',0)*100:.0f}%  (target ≥50%)",
            f"  col_xy_quality:  {qd.get('col_xy_quality',0)*100:.0f}%  (target ≥75%)",
            f"",
            f"Recall Score:    {recall}% — element count vs schedule",
            f"",
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

        if result.get("gaps"):
            lines.append("")
            lines.append("Gaps (recall < 70%):")
            for g in result["gaps"]:
                lines.append(f"  ⚠ {g['type']}: recall={g['recall']*100:.0f}%, deficit={g['deficit']}")

        return "\n".join(lines)
