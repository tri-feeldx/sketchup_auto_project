"""
=============================================================================
ARR-1: STRUCTURAL REVIEWER — PDF vs Model Cross-Check
=============================================================================
Reads scanner page_texts + structural model, identifies mismatches between
extracted model and the actual drawing content. Uses vision for anomaly pages.

Output:
  {
    "verdict": "OK" | "ISSUES_FOUND",
    "missing_elements": [{"type", "grid", "page", "reason"}],
    "anomaly_pages": [5, 12],
    "corrections": {"add": {etype: [...]}, "remove": {etype: [...]}},
    "confidence": 0.0–1.0,
  }
=============================================================================
"""

import json
import re
from pathlib import Path
from typing import Optional

from core.llm_wrapper import call_llm
from core.vision_renderer import VisionRenderer

MAX_TEXT_PER_PAGE = 3000
MAX_PAGES_TEXT_REVIEW = 10
MAX_VISION_PAGES = 4


class StructuralReviewer:
    """
    ARR-1: Compares extracted structural model against PDF drawings.
    Uses text-first approach, vision only for flagged anomaly pages.
    """

    def __init__(self, pdf_path: str, region: str = "au", dpi: int = 200):
        self.pdf_path = Path(pdf_path)
        self.region = region
        self.dpi = dpi

    def review(self, scanner_output: dict, structural_model: dict) -> dict:
        """
        Phase 1: Text review — free, fast.
        Phase 2: Vision review — targeted anomaly pages only.
        Returns structured corrections.
        """
        forensic = scanner_output.get("forensic", {})
        page_texts = forensic.get("page_texts", {})
        batches = scanner_output.get("batches", {})

        # Relevant pages: PLAN + SCHEDULE + ELEVATION + FOUNDATION
        relevant_page_types = ["PLAN", "SCHEDULE", "ELEVATION", "FOUNDATION", "DETAIL"]
        relevant_pages = []
        for pt in relevant_page_types:
            relevant_pages.extend(batches.get(pt, []))
        relevant_pages = list(dict.fromkeys(relevant_pages))[:MAX_PAGES_TEXT_REVIEW]

        model_summary = self._build_model_summary(structural_model)
        page_context = self._build_page_context(relevant_pages, page_texts)

        print(f"  [ARR-1] Reviewing {len(relevant_pages)} pages (text-only)...")
        text_result = self._llm_text_review(model_summary, page_context)

        if not text_result:
            return _empty_result("OK")

        anomaly_pages = text_result.get("anomaly_pages", [])[:MAX_VISION_PAGES]
        verdict = text_result.get("verdict", "OK")
        missing = text_result.get("missing_elements", [])
        corrections = text_result.get("corrections", {"add": {}, "remove": {}})

        # Phase 2: Vision confirmation for anomaly pages
        if anomaly_pages:
            print(f"  [ARR-1] Vision check on {len(anomaly_pages)} anomaly page(s): {anomaly_pages}")
            vision_result = self._vision_review(anomaly_pages, model_summary, corrections)
            if vision_result:
                # Merge additional corrections from vision pass
                for etype, items in vision_result.get("corrections", {}).get("add", {}).items():
                    corrections.setdefault("add", {}).setdefault(etype, []).extend(items)
                for etype, items in vision_result.get("corrections", {}).get("remove", {}).items():
                    corrections.setdefault("remove", {}).setdefault(etype, []).extend(items)
                missing.extend(vision_result.get("missing_elements", []))
                if vision_result.get("verdict") == "ISSUES_FOUND":
                    verdict = "ISSUES_FOUND"

        if not missing and not any(corrections.get("add", {}).values()):
            verdict = "OK"

        return {
            "verdict": verdict,
            "missing_elements": missing,
            "anomaly_pages": anomaly_pages,
            "corrections": corrections,
            "confidence": text_result.get("confidence", 0.7),
        }

    def _build_model_summary(self, model: dict) -> str:
        m = model.get("members", {})
        summary = model.get("summary", {})
        lines = [
            f"Extracted model: {summary.get('total_columns', len(m.get('columns', [])))}c "
            f"{summary.get('total_beams', len(m.get('beams', [])))}b "
            f"{summary.get('total_footings', len(m.get('footings', [])))}f "
            f"{summary.get('total_bracing', len(m.get('bracing', [])))}br",
        ]
        # Sample a few members per type for context
        for etype in ["columns", "beams", "footings", "bracing"]:
            items = m.get(etype, [])[:5]
            if items:
                sample = [
                    {k: v for k, v in e.items() if k in ("id", "mark", "section", "grade", "grid_x", "grid_y", "grid")}
                    for e in items
                ]
                lines.append(f"{etype} sample: {json.dumps(sample, ensure_ascii=False)}")
        return "\n".join(lines)

    def _build_page_context(self, pages: list, page_texts: dict) -> str:
        parts = []
        for pg in pages:
            txt = page_texts.get(str(pg)) or page_texts.get(pg) or ""
            if txt:
                parts.append(f"--- Page {pg + 1} ---\n{txt[:MAX_TEXT_PER_PAGE]}")
        return "\n\n".join(parts)

    def _llm_text_review(self, model_summary: str, page_context: str) -> Optional[dict]:
        region_hint = {
            "au": "AS/NZS: UB/UC/PFC/RHS/SHS sections, pile types PBFC/PSFC.",
            "vn": "TCVN: H/I sections, móng cọc/móng băng/móng đơn.",
            "intl": "Eurocode: IPE/HEA/HEB sections.",
        }.get(self.region, "")

        system = (
            f"You are a Senior Structural Engineer doing a BIM quality review. {region_hint}\n"
            "Compare the extracted structural model against the drawing text.\n"
            "Flag: (1) missing elements, (2) wrong sections/grades, (3) geometry inconsistencies.\n"
            "Be concise. Return ONLY valid JSON. No markdown fences."
        )
        user = (
            f"EXTRACTED MODEL:\n{model_summary}\n\n"
            f"DRAWING PAGES:\n{page_context}\n\n"
            "Return JSON:\n"
            '{"verdict":"OK"|"ISSUES_FOUND","missing_elements":[{"type":"column","grid":"A1","page":5,"reason":"..."}],'
            '"anomaly_pages":[5,12],'
            '"corrections":{"add":{"columns":[]},"remove":{"columns":[]}},'
            '"confidence":0.85}'
        )

        try:
            resp = call_llm(user, system=system)
            return _parse_json(resp)
        except Exception as e:
            print(f"    [ARR-1 WARN] Text review LLM error: {e}")
            return None

    def _vision_review(self, anomaly_pages: list, model_summary: str, prior_corrections: dict) -> Optional[dict]:
        images = []
        renderer = None
        try:
            renderer = VisionRenderer(str(self.pdf_path), dpi=self.dpi)
            for pg in anomaly_pages[:MAX_VISION_PAGES]:
                try:
                    img_bytes = renderer.render_page_as_bytes(pg, format="PNG")
                    images.append(img_bytes)
                except Exception:
                    pass
        except Exception:
            pass
        finally:
            if renderer:
                try:
                    renderer.close()
                except Exception:
                    pass

        if not images:
            return None

        system = (
            "You are a Senior Structural Engineer doing targeted visual review of flagged drawing pages.\n"
            "Look carefully at the images — these are real engineering drawings.\n"
            "Find any structural elements missing from the extracted model.\n"
            "Return ONLY valid JSON. No markdown fences."
        )
        user = (
            f"CURRENT MODEL:\n{model_summary}\n\n"
            f"PRIOR TEXT-BASED CORRECTIONS:\n{json.dumps(prior_corrections, ensure_ascii=False)}\n\n"
            f"Review these {len(images)} drawing image(s). Confirm or update the corrections.\n"
            "Return JSON:\n"
            '{"verdict":"OK"|"ISSUES_FOUND","missing_elements":[],'
            '"corrections":{"add":{},"remove":{}},"confidence":0.9}'
        )

        try:
            resp = call_llm(user, system=system, images=images)
            return _parse_json(resp)
        except Exception as e:
            print(f"    [ARR-1 WARN] Vision review LLM error: {e}")
            return None


def _empty_result(verdict: str = "OK") -> dict:
    return {
        "verdict": verdict,
        "missing_elements": [],
        "anomaly_pages": [],
        "corrections": {"add": {}, "remove": {}},
        "confidence": 1.0,
    }


def _parse_json(response: str) -> Optional[dict]:
    if not response:
        return None
    try:
        return json.loads(response)
    except json.JSONDecodeError:
        pass
    for open_c, close_c in [('{', '}'), ('[', ']')]:
        start = response.find(open_c)
        end = response.rfind(close_c)
        if start >= 0 and end > start:
            try:
                return json.loads(response[start:end + 1])
            except json.JSONDecodeError:
                pass
    return None
