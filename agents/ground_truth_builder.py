"""
=============================================================================
GROUND TRUTH BUILDER — Stage 0.6
=============================================================================
Reads the PDF ONCE at pipeline startup to establish locked ProjectFacts:
  - Grid line labels + exact mm positions (from plan scale bar)
  - Floor heights in mm (from elevation pages)
  - Expected column count (from schedule pages)
  - Building footprint dimensions

All downstream stages (synthesizer, ARR) must conform to these facts.
LLM outputs that contradict ProjectFacts are corrected, not accepted.
=============================================================================
"""

import json
import re
from typing import List, Optional

from core.llm_wrapper import call_llm
from core.vision_renderer import VisionRenderer


_GRID_SYSTEM_PROMPT = """\
You are a senior structural detailer with 20+ years reading Australian structural drawings.

Read this structural PLAN drawing. Extract the PRIMARY GRID SYSTEM precisely.

Output JSON only — no markdown, no explanation:
{
  "grid_x": {
    "1": 0,
    "2": 8000,
    "3": 16000,
    "4": 24000
  },
  "grid_y": {
    "A": 24000,
    "B": 16000,
    "C": 8000,
    "D": 0
  },
  "footprint_x_mm": 24000,
  "footprint_y_mm": 24000,
  "scale_note": "1:100 or scale bar reading",
  "confidence": 0.9
}

Rules:
- grid_x: numeric labels (1, 2, 3...) mapped to mm from origin (leftmost = 0)
- grid_y: letter labels (A, B, C...) mapped to mm from origin
- ALL values in millimetres from the grid origin
- Use the scale bar or drawing scale to convert pixel distances to mm
- If uncertain about a value, use null rather than guessing
- footprint_x_mm = distance from first to last X grid line
- footprint_y_mm = distance from first to last Y grid line
"""

_ELEVATION_SYSTEM_PROMPT = """\
You are a senior structural engineer reading a structural elevation or steelwork elevation drawing.

Extract all floor/level heights shown.

Output JSON only:
{
  "levels": {
    "Level 01": 0,
    "Level 02": 3500,
    "Level 03": 7000,
    "Roof": 10500
  },
  "floor_to_floor_mm": 3500,
  "total_height_mm": 10500,
  "confidence": 0.9
}

Rules:
- Level names must match exactly as shown on drawing
- Heights in mm from datum (ground level = 0)
- floor_to_floor_mm = typical F2F height (most common spacing)
- If using RL values: convert to mm above datum (subtract lowest RL)
- Include roof level if shown
"""

_SCHEDULE_COUNT_SYSTEM_PROMPT = """\
You are reading a structural column schedule or member schedule.

Count the total number of STRUCTURAL COLUMNS in this schedule (not beams, not hardware).

Output JSON only:
{
  "column_count": 44,
  "beam_count": 59,
  "confidence": 0.9,
  "notes": "Column schedule sheet 1 of 1"
}

Rules:
- Count only structural columns (UC, UB used as column, SHS, RHS, CHS, concrete columns)
- Exclude: base plates, connection hardware, beams, bracing, walls
- If multiple schedule pages, report count from this page only
- beam_count: total structural beams if visible
"""


def _parse_json(response: str) -> Optional[dict]:
    """Robust 3-pass JSON parser."""
    # Pass 1: direct
    try:
        d = json.loads(response.strip())
        if isinstance(d, dict):
            return d
    except (json.JSONDecodeError, ValueError):
        pass
    # Pass 2: strip markdown fences
    stripped = re.sub(r'^```(?:json)?\s*', '', response.strip(), flags=re.IGNORECASE)
    stripped = re.sub(r'\s*```\s*$', '', stripped.strip())
    try:
        d = json.loads(stripped.strip())
        if isinstance(d, dict):
            return d
    except (json.JSONDecodeError, ValueError):
        pass
    # Pass 3: extract first {...}
    m = re.search(r'\{.*\}', response, re.DOTALL)
    if m:
        try:
            d = json.loads(m.group())
            if isinstance(d, dict):
                return d
        except (json.JSONDecodeError, ValueError):
            pass
    return None


def _int_values(d: dict) -> dict:
    """Convert all leaf values to int where possible."""
    out = {}
    for k, v in d.items():
        if isinstance(v, (int, float)):
            out[str(k)] = int(round(float(v)))
        elif isinstance(v, str):
            try:
                out[str(k)] = int(round(float(v)))
            except (ValueError, TypeError):
                out[str(k)] = v
        else:
            out[str(k)] = v
    return out


class GroundTruthBuilder:
    """
    Reads PDF plan + elevation pages ONCE to establish locked ProjectFacts.
    Call build() early in the pipeline; pass result to synthesizer + ARR.
    """

    def __init__(self, pdf_path: str, region: str = "au", language: str = "en",
                 debug: bool = False):
        self.pdf_path = str(pdf_path)
        self.region = region
        self.language = language
        self.debug = debug

    def build(self, scanner_output: dict) -> dict:
        """
        Returns ProjectFacts dict (all values locked — downstream must not override):
        {
            "grid_x_mm":          {"1": 0, "2": 8000, ...},
            "grid_y_mm":          {"A": 24000, "B": 16000, ...},
            "floor_heights_mm":   {"Level 01": 0, "Level 02": 3500, ...},
            "floor_to_floor_mm":  3500,
            "col_count_expected": 44,
            "footprint_x_mm":     24000,
            "footprint_y_mm":     24000,
            "confidence":         0.85,
            "source_pages":       {"grid": 4, "elevation": 7, "schedule": 24}
        }
        """
        page_results = scanner_output.get("page_results", {})
        routing = scanner_output.get("routing_summary", {})

        plan_pages = self._find_pages(page_results, "PLAN")
        elevation_pages = self._find_pages(page_results, "ELEVATION")
        schedule_pages = self._find_pages(page_results, "SCHEDULE")

        print(f"  [GTB] Plan pages: {plan_pages} | "
              f"Elevation: {elevation_pages} | Schedule: {schedule_pages}")

        facts: dict = {
            "grid_x_mm": {},
            "grid_y_mm": {},
            "floor_heights_mm": {},
            "floor_to_floor_mm": 3500,
            "col_count_expected": None,
            "footprint_x_mm": None,
            "footprint_y_mm": None,
            "confidence": 0.0,
            "source_pages": {}
        }

        renderer = VisionRenderer(self.pdf_path, dpi=300)
        try:
            # 1. Extract grid from first PLAN page
            if plan_pages:
                page_idx = plan_pages[0]
                self._extract_grid(renderer, page_idx, facts)

            # 2. Extract floor heights from first ELEVATION page
            if elevation_pages:
                page_idx = elevation_pages[0]
                self._extract_elevations(renderer, page_idx, facts)
            elif len(plan_pages) > 1:
                # Some drawings embed elevations on second plan page
                self._extract_elevations(renderer, plan_pages[1], facts)

            # 3. Count columns from SCHEDULE pages
            if schedule_pages:
                self._extract_column_count(renderer, schedule_pages, facts)

        finally:
            try:
                renderer.close()
            except Exception:
                pass

        self._compute_confidence(facts)
        self._print_summary(facts)
        return facts

    # ── Private helpers ──────────────────────────────────────────────────────

    def _find_pages(self, page_results: dict, page_type: str) -> List[int]:
        return sorted([
            int(k) for k, v in page_results.items()
            if isinstance(v, dict) and v.get("page_type") == page_type
        ])

    def _extract_grid(self, renderer: VisionRenderer, page_idx: int, facts: dict):
        print(f"  [GTB] Extracting grid from plan page {page_idx}...")
        try:
            img = renderer.render_page_as_bytes(page_idx - 1, format="PNG")
            resp = call_llm(
                f"Plan page {page_idx}. Extract the structural grid system precisely. "
                "Output valid JSON only.",
                system=_GRID_SYSTEM_PROMPT,
                images=[img]
            )
            data = _parse_json(resp)
            if not data:
                print(f"  [GTB] WARN: grid parse failed for page {page_idx}")
                return
            if self.debug:
                print(f"  [GTB-DEBUG] Grid raw: {data}")

            gx = data.get("grid_x") or {}
            gy = data.get("grid_y") or {}

            if gx and isinstance(gx, dict):
                facts["grid_x_mm"] = _int_values(gx)
                facts["source_pages"]["grid"] = page_idx
                print(f"  [GTB] Grid X: {len(gx)} lines — {facts['grid_x_mm']}")

            if gy and isinstance(gy, dict):
                facts["grid_y_mm"] = _int_values(gy)
                print(f"  [GTB] Grid Y: {len(gy)} lines — {facts['grid_y_mm']}")

            if data.get("footprint_x_mm"):
                try:
                    facts["footprint_x_mm"] = int(float(data["footprint_x_mm"]))
                except (ValueError, TypeError):
                    pass
            if data.get("footprint_y_mm"):
                try:
                    facts["footprint_y_mm"] = int(float(data["footprint_y_mm"]))
                except (ValueError, TypeError):
                    pass

        except Exception as e:
            print(f"  [GTB] WARN: grid extraction failed: {e}")

    def _extract_elevations(self, renderer: VisionRenderer, page_idx: int, facts: dict):
        print(f"  [GTB] Extracting floor heights from elevation page {page_idx}...")
        try:
            img = renderer.render_page_as_bytes(page_idx - 1, format="PNG")
            resp = call_llm(
                f"Elevation page {page_idx}. Extract all floor level heights. "
                "Output valid JSON only.",
                system=_ELEVATION_SYSTEM_PROMPT,
                images=[img]
            )
            data = _parse_json(resp)
            if not data:
                print(f"  [GTB] WARN: elevation parse failed for page {page_idx}")
                return
            if self.debug:
                print(f"  [GTB-DEBUG] Elevation raw: {data}")

            levels = data.get("levels") or {}
            if levels and isinstance(levels, dict):
                facts["floor_heights_mm"] = _int_values(levels)
                facts["source_pages"]["elevation"] = page_idx
                print(f"  [GTB] Levels: {len(levels)} — {facts['floor_heights_mm']}")

            if data.get("floor_to_floor_mm"):
                try:
                    facts["floor_to_floor_mm"] = int(float(data["floor_to_floor_mm"]))
                except (ValueError, TypeError):
                    pass

        except Exception as e:
            print(f"  [GTB] WARN: elevation extraction failed: {e}")

    def _extract_column_count(self, renderer: VisionRenderer, schedule_pages: List[int],
                               facts: dict):
        """Try schedule pages until we get a plausible column count."""
        for page_idx in schedule_pages[:3]:  # check first 3 schedule pages max
            print(f"  [GTB] Counting columns from schedule page {page_idx}...")
            try:
                img = renderer.render_page_as_bytes(page_idx - 1, format="PNG")
                resp = call_llm(
                    f"Schedule page {page_idx}. Count structural columns in this schedule. "
                    "Output valid JSON only.",
                    system=_SCHEDULE_COUNT_SYSTEM_PROMPT,
                    images=[img]
                )
                data = _parse_json(resp)
                if not data:
                    continue
                count = data.get("column_count")
                if count is not None:
                    try:
                        count = int(float(count))
                        if 4 <= count <= 500:  # sanity range
                            if facts["col_count_expected"] is None or count > facts["col_count_expected"]:
                                facts["col_count_expected"] = count
                                facts["source_pages"]["schedule"] = page_idx
                                print(f"  [GTB] Column count: {count} (from page {page_idx})")
                    except (ValueError, TypeError):
                        pass
            except Exception as e:
                print(f"  [GTB] WARN: schedule count failed page {page_idx}: {e}")

    def _compute_confidence(self, facts: dict):
        score = 0.0
        if facts["grid_x_mm"] and len(facts["grid_x_mm"]) >= 2:
            score += 0.4
        if facts["grid_y_mm"] and len(facts["grid_y_mm"]) >= 2:
            score += 0.2
        if facts["floor_heights_mm"] and len(facts["floor_heights_mm"]) >= 2:
            score += 0.2
        if facts["col_count_expected"] is not None:
            score += 0.2
        facts["confidence"] = round(score, 2)

    def _print_summary(self, facts: dict):
        conf = facts["confidence"]
        grade = "HIGH" if conf >= 0.8 else ("MEDIUM" if conf >= 0.5 else "LOW")
        print(f"  [GTB] ProjectFacts confidence={conf:.0%} ({grade})")
        if facts["grid_x_mm"]:
            xs = sorted(facts["grid_x_mm"].items(), key=lambda kv: kv[1])
            print(f"  [GTB]   Grid X ({len(xs)} lines): "
                  + " | ".join(f"{k}={v}mm" for k, v in xs))
        if facts["grid_y_mm"]:
            ys = sorted(facts["grid_y_mm"].items(), key=lambda kv: kv[1])
            print(f"  [GTB]   Grid Y ({len(ys)} lines): "
                  + " | ".join(f"{k}={v}mm" for k, v in ys))
        if facts["floor_heights_mm"]:
            print(f"  [GTB]   Floors: {facts['floor_heights_mm']}")
        if facts["col_count_expected"] is not None:
            print(f"  [GTB]   Expected columns: {facts['col_count_expected']}")
