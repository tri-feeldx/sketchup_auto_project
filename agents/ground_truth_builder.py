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
from config import GEMINI_MODEL_PRO as _GTB_MODEL
from core.vision_renderer import VisionRenderer
from core.agent_logger import AgentLogger


_GRID_SYSTEM_PROMPT = """\
You are a senior structural detailer with 20+ years reading Australian structural drawings.

Read this structural PLAN drawing. Extract the PRIMARY STRUCTURAL GRID SYSTEM precisely.

IMPORTANT DISTINCTION:
- STRUCTURAL GRID LINES = the reference lines labeled with numbers (1,2,3...) or letters (A,B,C...)
  that form the building grid layout. Typically 3-15 lines per direction, evenly spaced 4000-15000mm.
- Do NOT confuse with individual column/pile positions (there can be 20-100+ columns).
- Grid lines are the NAMED REFERENCE LINES, not the positions of every structural member.

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
- Typical structural grid: 3-15 lines per axis, spacing 4000-15000mm
"""

_GRID_RETRY_PROMPT = """\
You are a senior structural engineer with 20+ years of BIM experience.

This is a structural PLAN drawing. I need ONLY the PRIMARY STRUCTURAL GRID LINES.

STRUCTURAL GRID LINES are:
- Labeled with sequential numbers (1, 2, 3, 4...) or letters (A, B, C, D...)
- Drawn as long dashed or dash-dot lines spanning the full building footprint
- Typically 3-15 per direction, with spacing of 4000mm to 15000mm
- Shown with circle bubbles containing the label at the ends

DO NOT return column positions, pile locations, or member centrelines.
A structural grid for a building rarely has more than 15 lines per direction.

Output JSON only:
{
  "grid_x": {"1": 0, "2": 8000, "3": 16000},
  "grid_y": {"A": 0, "B": 8000, "C": 16000},
  "footprint_x_mm": 16000,
  "footprint_y_mm": 16000,
  "confidence": 0.85
}
"""

_GRID_COUNT_HINT_PROMPT = """\
You are a senior structural engineer with 20+ years of BIM experience.

This structural PLAN drawing contains MORE grid lines than previously identified.

TASK: Extract ALL structural grid axes — including secondary and intermediate axes.

CRITICAL: The building has more columns than can fit in the previously extracted grid.
You MUST find and report ALL labeled grid lines — do not stop at the first few obvious ones.

Look for:
- All sequentially numbered axes (1, 2, 3, 4, 5, 6, 7... — may go well beyond 4)
- All lettered axes (A, B, C, D, E, F... — may go beyond D)
- Any intermediate axes with alphanumeric labels (1A, 2A, etc.)

Output JSON only:
{
  "grid_x": {"1": 0, "2": 6000, "3": 12000, "4": 18000, "5": 24000, "6": 30000},
  "grid_y": {"A": 0, "B": 6000, "C": 12000, "D": 18000, "E": 24000, "F": 30000},
  "footprint_x_mm": 30000,
  "footprint_y_mm": 30000,
  "confidence": 0.85
}
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

_ELEVATION_RL_PROMPT = """\
You are a senior structural engineer reading an Australian structural elevation drawing.

Australian drawings use RL (Reduced Level) values in AHD (Australian Height Datum).
Example: RL 414.200 means 414.200 metres above Australian Height Datum.

TASK: Find EVERY RL value annotated on this elevation drawing.
List them as-is (do NOT convert — just report the raw values you see).

Output JSON only:
{
  "rl_values": {
    "Ground Floor": 414.200,
    "Level 1": 417.700,
    "Level 2": 421.200,
    "Lower Roof": 424.600,
    "Upper Roof": 427.800
  },
  "confidence": 0.9
}

- Keys = level name (or "Level N" if unnamed)
- Values = the RL number exactly as printed on drawing
- Include ALL RL annotations — parapets, ridge, FFL, soffit
- If no RL values found, return {"rl_values": {}, "confidence": 0.1}
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


_MAX_STRUCTURAL_GRID_LINES = 20   # more than this = column positions, not grid
_MIN_STRUCTURAL_GRID_SPACING = 1200  # mm — accounts for tight bays, mezzanines, dense construction


def _axis_labels_are_sensible(grid: dict) -> bool:
    """
    Structural grid axis labels must start from a sensible origin.
    Numeric axes: must start at 1, 2, or 3 (not 7, 8, 9... — those are table row numbers).
    Alpha axes: must start at A, B, or C (not E, F... — those are unlikely real axes).
    """
    if not grid:
        return False
    keys = [str(k) for k in grid.keys()]
    numeric = [k for k in keys if k.isdigit()]
    alpha   = [k for k in keys if k.isalpha()]
    if numeric:
        min_num = int(min(numeric, key=int))
        if min_num > 3:
            return False
    if alpha:
        min_alpha = min(alpha, key=lambda k: ord(k.upper()[0]))
        if ord(min_alpha.upper()[0]) - ord('A') > 2:
            return False
    return True


def _is_valid_structural_grid(grid: dict) -> bool:
    """Return True if dict looks like a structural grid (not column position list)."""
    if not grid or len(grid) < 1:
        return False  # 0 lines = extraction failure, not partial data
    if len(grid) > _MAX_STRUCTURAL_GRID_LINES:
        return False
    try:
        vals = sorted(int(float(v)) for v in grid.values() if v is not None)
    except (ValueError, TypeError):
        return False
    spacings = [vals[i + 1] - vals[i] for i in range(len(vals) - 1)]
    if any(s < _MIN_STRUCTURAL_GRID_SPACING for s in spacings):
        return False
    return True


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

    def build(self, scanner_output: dict, cad_data: dict = None) -> dict:
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

        Args:
            scanner_output: output from ScannerV6.run()
            cad_data:       optional output from CADVectorExtractor (Stage 1.5).
                            When confidence ≥ 0.6 and ≥2 grid lines per axis,
                            the CAD-derived grid overrides the LLM-extracted grid.
        """
        page_results = scanner_output.get("page_results", {})

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
            # 1. Extract grid from plan pages — try each until we get a valid grid
            for _gp_idx in plan_pages[:3]:
                self._extract_grid(renderer, _gp_idx, facts)
                if len(facts.get("grid_x_mm") or {}) >= 3:
                    break  # found a valid grid

            # 2. Override LLM grid with exact CAD vectors when available
            self._apply_cad_grid_override(facts, cad_data)

            # 3. Extract floor heights from first ELEVATION page
            if elevation_pages:
                page_idx = elevation_pages[0]
                self._extract_elevations(renderer, page_idx, facts)
            elif len(plan_pages) > 1:
                # Some drawings embed elevations on second plan page
                self._extract_elevations(renderer, plan_pages[1], facts)

            # 3a-2. Read building_levels from scanner page_results (zero-cost, already scanned)
            if not facts.get("floor_heights_mm"):
                self._extract_levels_from_scanner_results(scanner_output, facts)

            # 3b. Forensic text fallback for floor heights when LLM elevation extraction failed
            if not facts.get("floor_heights_mm"):
                self._extract_heights_from_text(scanner_output, facts)

            # 3c. Column height clustering — when all text-based fallbacks fail
            if not facts.get("floor_heights_mm"):
                self._extract_levels_from_schedule_heights(scanner_output, facts)

            # 3d. Direct LLM query — last resort when all structural fallbacks fail
            if not facts.get("floor_heights_mm"):
                self._extract_levels_direct_llm(scanner_output, facts)

            # 4. Count columns from SCHEDULE pages
            if schedule_pages:
                self._extract_column_count(renderer, schedule_pages, facts)

            # 5. Grid sufficiency check — retry if grid has too few intersections for col_count
            self._check_grid_sufficiency(renderer, plan_pages, facts)

        finally:
            try:
                renderer.close()
            except Exception:
                pass

        self._compute_confidence(facts)
        self._print_summary(facts)

        # AgentLogger quality summary
        _log = AgentLogger("GTB")
        _log.stat("grid_x_count", len(facts.get("grid_x_mm") or {}))
        _log.stat("grid_y_count", len(facts.get("grid_y_mm") or {}))
        _log.stat("level_real",   len(facts.get("floor_heights_mm") or {}))
        _log.stat("col_expected", facts.get("col_count_expected") or 0)
        _log.stat("confidence",   facts.get("confidence", 0))
        _col_exp = facts.get("col_count_expected") or 0
        _gx = len(facts.get("grid_x_mm") or {})
        _gy = len(facts.get("grid_y_mm") or {})
        _gates = {
            "grid_x≥4":             _gx >= 4,
            "grid_y≥4":             _gy >= 4,
            "level_real≥2":         len(facts.get("floor_heights_mm") or {}) >= 2,
            "grid_covers_cols≥75%": _col_exp == 0 or (_gx * _gy) >= _col_exp * 0.75,
        }
        _log.summary(gates=_gates)

        return facts

    # ── Private helpers ──────────────────────────────────────────────────────

    def _apply_cad_grid_override(self, facts: dict, cad_data: dict) -> None:
        """
        When CAD vector extraction found a reliable structural grid (conf ≥ 0.6,
        ≥2 lines per axis, and passes structural grid validation), replace the
        LLM-derived grid with the CAD values.
        """
        if not cad_data:
            return
        cad_conf = cad_data.get("confidence", 0.0)
        if cad_conf < 0.6:
            return

        gx = cad_data.get("grid_x_mm") or {}
        gy = cad_data.get("grid_y_mm") or {}

        if len(gx) < 2 or len(gy) < 2:
            return

        # Validate: reject CAD grids that are actually column position lists
        if not _is_valid_structural_grid(gx) or not _is_valid_structural_grid(gy):
            print(f"  [GTB] CAD grid INVALID ({len(gx)}×{len(gy)} lines, "
                  f"likely column positions not grid lines) — skipping CAD override")
            return

        # Only override when CAD grid is at least as complete as the LLM grid
        llm_gx = facts.get("grid_x_mm") or {}
        llm_gy = facts.get("grid_y_mm") or {}
        if len(gx) < len(llm_gx) or len(gy) < len(llm_gy):
            print(f"  [GTB] CAD grid sparser than LLM grid "
                  f"({len(gx)}×{len(gy)} vs {len(llm_gx)}×{len(llm_gy)}) — keeping LLM")
            return

        facts["grid_x_mm"] = {str(k): int(v) for k, v in gx.items()}
        facts["grid_y_mm"] = {str(k): int(v) for k, v in gy.items()}
        facts["_grid_source"] = "cad_vector"
        facts["confidence"] = min(1.0, facts.get("confidence", 0.0) + 0.2)
        print(f"  [GTB] CAD grid override applied: "
              f"{len(gx)}×{len(gy)} lines (conf boost → "
              f"{facts['confidence']:.2f})")

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
                images=[img],
                model=_GTB_MODEL,
            )
            data = _parse_json(resp)
            if not data:
                print(f"  [GTB] WARN: grid parse failed for page {page_idx}")
                return
            if self.debug:
                print(f"  [GTB-DEBUG] Grid raw: {data}")

            gx = data.get("grid_x") or {}
            gy = data.get("grid_y") or {}

            # Validate: if LLM returned column positions instead of grid lines, retry
            gx_valid = _is_valid_structural_grid(gx) if gx else True
            gy_valid = _is_valid_structural_grid(gy) if gy else True

            if not gx_valid or not gy_valid:
                bad_axis = []
                if not gx_valid:
                    bad_axis.append(f"X={len(gx)} lines")
                if not gy_valid:
                    bad_axis.append(f"Y={len(gy)} lines")
                print(f"  [GTB] WARN: invalid grid ({', '.join(bad_axis)}) — "
                      f"looks like column positions. Retrying with stricter prompt...")
                self._extract_grid_retry(renderer, page_idx, facts)
                return

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

    def _extract_grid_retry(self, renderer: VisionRenderer, page_idx: int, facts: dict):
        """Retry grid extraction with stricter prompt when first pass returned column positions."""
        try:
            img = renderer.render_page_as_bytes(page_idx - 1, format="PNG")
            resp = call_llm(
                f"Plan page {page_idx}. Extract ONLY the structural reference GRID LINES "
                "(numbered/lettered lines, NOT individual column positions). "
                "Output valid JSON only.",
                system=_GRID_RETRY_PROMPT,
                model=_GTB_MODEL,
                images=[img]
            )
            data = _parse_json(resp)
            if not data:
                print(f"  [GTB] WARN: grid retry parse failed — no grid extracted")
                return

            gx = data.get("grid_x") or {}
            gy = data.get("grid_y") or {}

            if gx and isinstance(gx, dict) and _is_valid_structural_grid(gx):
                facts["grid_x_mm"] = _int_values(gx)
                facts["source_pages"]["grid"] = page_idx
                print(f"  [GTB] Grid X (retry): {len(gx)} lines — {facts['grid_x_mm']}")
            elif gx:
                print(f"  [GTB] WARN: retry still returned invalid X grid ({len(gx)} lines) — discarding")

            if gy and isinstance(gy, dict) and _is_valid_structural_grid(gy):
                facts["grid_y_mm"] = _int_values(gy)
                print(f"  [GTB] Grid Y (retry): {len(gy)} lines — {facts['grid_y_mm']}")
            elif gy:
                print(f"  [GTB] WARN: retry still returned invalid Y grid ({len(gy)} lines) — discarding")

        except Exception as e:
            print(f"  [GTB] WARN: grid retry failed: {e}")

    def _check_grid_sufficiency(self, renderer: VisionRenderer,
                                plan_pages: List[int], facts: dict) -> None:
        """After col_count is known, verify grid has enough intersections.
        If not, retry grid extraction with an explicit count hint to the LLM."""
        gx = facts.get("grid_x_mm") or {}
        gy = facts.get("grid_y_mm") or {}
        col_expected = facts.get("col_count_expected") or 0
        grid_intersections = len(gx) * len(gy)

        if col_expected <= 0 or not plan_pages:
            return
        if grid_intersections >= col_expected * 0.75:
            return  # Grid is adequate

        print(f"  [GTB] WARN: Grid too sparse — {len(gx)}×{len(gy)}={grid_intersections} "
              f"intersections for {col_expected} columns (need ≥{int(col_expected * 0.75)}) "
              f"— retrying with count hint")
        self._retry_grid_with_col_hint(renderer, plan_pages[0], facts, col_expected)

    def _retry_grid_with_col_hint(self, renderer: VisionRenderer, page_idx: int,
                                   facts: dict, col_count: int) -> None:
        """Retry grid extraction telling the LLM how many columns the building has."""
        try:
            img = renderer.render_page_as_bytes(page_idx - 1, format="PNG")
            nx = len(facts.get("grid_x_mm") or {})
            ny = len(facts.get("grid_y_mm") or {})
            resp = call_llm(
                f"Plan page {page_idx}. "
                f"CRITICAL: This building has {col_count} structural columns. "
                f"Previous extraction only found {nx}×{ny}={nx*ny} grid intersections "
                f"which cannot accommodate {col_count} columns. "
                f"You MUST extract more grid lines — look for ALL axes beyond the first {nx} X-axes "
                f"and {ny} Y-axes. Output valid JSON only.",
                system=_GRID_COUNT_HINT_PROMPT,
                images=[img],
                model=_GTB_MODEL,
            )
            data = _parse_json(resp)
            if not data:
                print(f"  [GTB] WARN: grid count-hint retry parse failed")
                return

            gx = data.get("grid_x") or {}
            gy = data.get("grid_y") or {}
            new_intersections = len(gx) * len(gy)
            old_intersections = (len(facts.get("grid_x_mm") or {})
                                 * len(facts.get("grid_y_mm") or {}))

            gx_ok = (_is_valid_structural_grid(gx) and _axis_labels_are_sensible(gx))
            gy_ok = (_is_valid_structural_grid(gy) and _axis_labels_are_sensible(gy))

            if (new_intersections > old_intersections and gx_ok and gy_ok):
                facts["grid_x_mm"] = _int_values(gx)
                facts["grid_y_mm"] = _int_values(gy)
                facts["source_pages"]["grid"] = page_idx
                print(f"  [GTB] Grid count-hint retry: {len(gx)}×{len(gy)}={new_intersections} "
                      f"intersections ✓ (was {old_intersections})")
            else:
                reason = ""
                if not gx_ok:
                    reason += f" X-labels={list(gx.keys())[:4]} rejected"
                if not gy_ok:
                    reason += f" Y-labels={list(gy.keys())[:4]} rejected"
                if not reason:
                    reason = f"not better than {old_intersections}"
                print(f"  [GTB] Grid count-hint retry: keeping original —{reason}")
        except Exception as e:
            print(f"  [GTB] WARN: grid count-hint retry failed: {e}")

    def _extract_elevations(self, renderer: VisionRenderer, page_idx: int, facts: dict):
        print(f"  [GTB] Extracting floor heights from elevation page {page_idx}...")
        try:
            img = renderer.render_page_as_bytes(page_idx - 1, format="PNG")
            resp = call_llm(
                f"Elevation page {page_idx}. Extract all floor level heights. "
                "Output valid JSON only.",
                system=_ELEVATION_SYSTEM_PROMPT,
                images=[img],
                model=_GTB_MODEL,
            )
            data = _parse_json(resp)
            if not data:
                print(f"  [GTB] WARN: elevation parse failed for page {page_idx}")
            else:
                if self.debug:
                    print(f"  [GTB-DEBUG] Elevation raw: {data}")

                levels = data.get("levels") or {}

                # Handle list format: [{"name": "GL", "elevation_mm": 0}, ...]
                if isinstance(levels, list):
                    levels = {
                        item.get("name") or item.get("level") or f"L{i+1}":
                        item.get("elevation_mm") or item.get("height_mm") or item.get("rl") or 0
                        for i, item in enumerate(levels) if isinstance(item, dict)
                    }

                # Filter out None/zero-confidence entries
                if isinstance(levels, dict):
                    levels = {k: v for k, v in levels.items() if v is not None}

                if levels and isinstance(levels, dict) and len(levels) >= 2:
                    # Check if values look like absolute AHD (e.g. 414200 mm) — normalise
                    vals = sorted(int(float(v)) for v in levels.values() if v is not None)
                    if vals and vals[0] > 50_000:  # absolute AHD in mm
                        base = vals[0]
                        levels = {k: int(float(v)) - base for k, v in levels.items() if v is not None}
                    facts["floor_heights_mm"] = _int_values(levels)
                    facts["source_pages"]["elevation"] = page_idx
                    print(f"  [GTB] Levels: {len(levels)} — {facts['floor_heights_mm']}")

                if data.get("floor_to_floor_mm"):
                    try:
                        facts["floor_to_floor_mm"] = int(float(data["floor_to_floor_mm"]))
                    except (ValueError, TypeError):
                        pass

            # Pass 2: scan raw LLM text for RL patterns (catches "RL 414.200" etc.)
            if not facts.get("floor_heights_mm"):
                import re as _re_el
                _RL_PAT_FB = _re_el.compile(r'RL\s*\+?\s*([\d]{1,4}\.[\d]{1,3})', _re_el.I)
                _raw_rl_fb: set = set()
                for _m in _RL_PAT_FB.finditer(str(resp)):
                    try:
                        _raw_rl_fb.add(float(_m.group(1)))
                    except ValueError:
                        pass
                if len(_raw_rl_fb) >= 2:
                    _sorted_fb = sorted(_raw_rl_fb)
                    _base_fb   = _sorted_fb[0]
                    _levels_fb: dict = {}
                    for _rv in _sorted_fb:
                        _rel_mm = int((_rv - _base_fb) * 1000)
                        if 0 <= _rel_mm <= 50_000:
                            _levels_fb[f"RL {_rv:.3f}"] = _rel_mm
                    if len(_levels_fb) >= 2:
                        facts["floor_heights_mm"] = _levels_fb
                        facts["source_pages"]["elevation"] = page_idx
                        facts["_floor_source"] = "elevation_llm_raw"
                        print(f"  [GTB] Levels from elevation raw text: {len(_levels_fb)} — {_levels_fb}")

            # Pass 3: dedicated RL-focused retry for Australian AHD drawings
            if not facts.get("floor_heights_mm"):
                self._extract_elevations_rl_retry(renderer, page_idx, img, facts)

        except Exception as e:
            print(f"  [GTB] WARN: elevation extraction failed: {e}")

    def _extract_elevations_rl_retry(self, renderer: VisionRenderer, page_idx: int,
                                      img: bytes, facts: dict) -> None:
        """Third attempt — dedicated RL/AHD prompt for Australian elevation drawings."""
        try:
            resp2 = call_llm(
                f"Page {page_idx}. Find ALL RL (Reduced Level / AHD) values on this drawing. "
                "List every annotated RL number. Output JSON only.",
                system=_ELEVATION_RL_PROMPT,
                images=[img],
                model=_GTB_MODEL,
            )
            data2 = _parse_json(resp2)
            rl_vals: dict = {}
            if data2 and isinstance(data2, dict):
                rl_vals = data2.get("rl_values") or {}
                if isinstance(rl_vals, list):
                    rl_vals = {f"L{i+1}": v for i, v in enumerate(rl_vals) if isinstance(v, (int, float))}

            # Also scrape raw numbers from the response text (e.g. "414.200", "417.700")
            import re as _re2
            _NUM_PAT = _re2.compile(r'\b([\d]{3,4}\.[\d]{1,3})\b')
            raw_nums: set = set()
            for _m in _NUM_PAT.finditer(str(resp2)):
                try:
                    raw_nums.add(float(_m.group(1)))
                except ValueError:
                    pass
            # Merge rl_vals dict values + raw scraped numbers
            all_rl: set = set()
            for v in rl_vals.values():
                if isinstance(v, (int, float)) and 1 <= v <= 9999:
                    all_rl.add(float(v))
            for v in raw_nums:
                if 100 <= v <= 9999:
                    all_rl.add(v)

            if len(all_rl) >= 2:
                sorted_rl = sorted(all_rl)
                base = sorted_rl[0]
                levels: dict = {}
                # Try to use rl_vals keys; fallback to generic names
                key_map = {float(v): k for k, v in rl_vals.items()
                           if isinstance(v, (int, float))} if rl_vals else {}
                for rv in sorted_rl:
                    rel_mm = int((rv - base) * 1000)
                    if 0 <= rel_mm <= 50_000:
                        name = key_map.get(rv, f"RL {rv:.3f}")
                        levels[name] = rel_mm
                if len(levels) >= 2:
                    facts["floor_heights_mm"] = levels
                    facts["source_pages"]["elevation"] = page_idx
                    facts["_floor_source"] = "elevation_rl_retry"
                    print(f"  [GTB] Levels from RL retry: {len(levels)} — {levels}")
        except Exception as e:
            print(f"  [GTB] WARN: RL retry failed: {e}")

    def _extract_heights_from_text(self, scanner_output: dict, facts: dict) -> None:
        """Scan all forensic page texts for floor height patterns when LLM elevation fails."""
        import re as _re_h
        page_texts = scanner_output.get("forensic", {}).get("page_texts", {})

        # --- RL (Reduced Level) handler — normalise relative to base first ---
        # Handles Australian RL values like 414.200 (3 digits, Tamworth is ~414m AHD)
        # Must normalise BEFORE filtering by range to avoid rejecting valid absolute RLs.
        _RL_PAT = _re_h.compile(r'RL\s*\+?\s*([\d]{1,3}\.[\d]{1,3})', _re_h.I)
        _raw_rl: set = set()
        for pr in scanner_output.get("page_results", {}).values():
            raw_pr = str(pr.get("_raw_text") or pr.get("raw_text") or pr.get("llm_response") or "")
            for m in _RL_PAT.finditer(raw_pr):
                try:
                    _raw_rl.add(float(m.group(1)))
                except ValueError:
                    pass
        for txt in page_texts.values():
            for m in _RL_PAT.finditer(str(txt)):
                try:
                    _raw_rl.add(float(m.group(1)))
                except ValueError:
                    pass

        found_mm: set = set()
        if len(_raw_rl) >= 2:
            _sorted_rl = sorted(_raw_rl)
            _base_rl = _sorted_rl[0]
            for _rl_val in _sorted_rl:
                _rel_mm = int((_rl_val - _base_rl) * 1000)
                if 0 <= _rel_mm <= 50000:
                    found_mm.add(_rel_mm)

        # --- General height pattern scan (FFL, AFFL, Level=, etc.) ---
        _HEIGHT_PATS = [
            (_re_h.compile(r'(?:FFL|AFFL|AFL|FFH)\s*[=:]?\s*([\d.]+)', _re_h.I), "auto"),
            (_re_h.compile(r'\+\s*([\d]{1,2}\.\d{3})'), "metres"),
            (_re_h.compile(r'(?:LEVEL|LVL|FL)\s*\d+\s*[=:]\s*\+?\s*([\d.]+)', _re_h.I), "auto"),
            (_re_h.compile(r'(?:GL|GF|GROUND)\s*[=:+]?\s*([\d.]+)', _re_h.I), "auto"),
        ]
        for pr in scanner_output.get("page_results", {}).values():
            raw = str(pr.get("_raw_text") or pr.get("raw_text") or pr.get("llm_response") or "")
            for pat, mode in _HEIGHT_PATS:
                for m in pat.finditer(raw):
                    try:
                        val = float(m.group(1))
                        mm = int(val * 1000) if (mode == "metres" or (mode == "auto" and val < 100)) else int(val)
                        if 0 <= mm <= 50000:
                            found_mm.add(mm)
                    except (ValueError, IndexError):
                        pass
        for txt in page_texts.values():
            for pat, mode in _HEIGHT_PATS:
                for m in pat.finditer(str(txt)):
                    try:
                        val = float(m.group(1))
                        mm = int(val * 1000) if (mode == "metres" or (mode == "auto" and val < 100)) else int(val)
                        if 0 <= mm <= 50000:
                            found_mm.add(mm)
                    except (ValueError, IndexError):
                        pass

        if len(found_mm) >= 2:
            sorted_mm = sorted(found_mm)
            base = sorted_mm[0]
            heights = {}
            for i, mm in enumerate(sorted_mm):
                rel = mm - base
                heights[f"L{i+1}"] = rel
            facts["floor_heights_mm"] = heights
            facts["_floor_source"] = "forensic_text"
            print(f"  [GTB] Floor heights from forensic text: {len(heights)} levels — {heights}")

    def _extract_levels_from_scanner_results(self, scanner_output: dict, facts: dict) -> None:
        """
        Read building_levels / level_elevations already extracted by the scanner.
        Zero-cost: no LLM — reads cached page_results from the scan pass.
        """
        page_results = scanner_output.get("page_results", {})
        levels: dict = {}
        for pr in page_results.values():
            raw = pr.get("building_levels") or pr.get("level_elevations") or []
            for le in raw:
                if not isinstance(le, dict):
                    continue
                name = (le.get("id") or le.get("label") or le.get("level_name") or "")
                rl = (le.get("rl_mm") or le.get("ffl_mm") or le.get("ssl_mm") or
                      le.get("elevation_mm") or 0)
                if name:
                    try:
                        levels[name] = int(float(rl))
                    except (ValueError, TypeError):
                        levels[name] = 0
        if len(levels) >= 2:
            vals = sorted(levels.values())
            if vals[0] > 50_000:  # absolute AHD mm → normalise
                base = vals[0]
                levels = {k: v - base for k, v in levels.items()}
            facts["floor_heights_mm"] = levels
            facts["_floor_source"] = "scanner_building_levels"
            print(f"  [GTB] Levels from scanner building_levels: {len(levels)} — {levels}")

    def _extract_levels_from_schedule_heights(self, scanner_output: dict, facts: dict) -> None:
        """
        Cluster column height_mm values from schedule page_results → floor-to-floor height.
        Fallback when elevation LLM and forensic text both fail to find real heights.
        """
        from collections import Counter
        heights = []
        for pr in scanner_output.get("page_results", {}).values():
            # Scanner V6 stores per-type keys ("columns") not generic "members"
            col_list = list(pr.get("columns") or []) + list(pr.get("members") or [])
            for member in col_list:
                mtype = str(member.get("type") or "column").lower()
                if mtype not in ("column", "col", ""):
                    continue
                h = (member.get("height_mm") or member.get("height")
                     or member.get("length_mm"))
                if h:
                    try:
                        val = float(h)
                        if 500 <= val <= 15000:
                            heights.append(int(val))
                    except (ValueError, TypeError):
                        pass
        if len(heights) < 3:
            return
        # Round to nearest 250mm → find dominant floor-to-floor height
        rounded = [round(h / 250) * 250 for h in heights]
        counts = Counter(rounded)
        f2f = counts.most_common(1)[0][0]
        if not (2500 <= f2f <= 6000):
            return
        n_levels = max(2, min(8, round(max(heights) / f2f) + 1))
        levels = {f"Level {i + 1}": i * f2f for i in range(n_levels)}
        facts["floor_heights_mm"] = levels
        facts["floor_to_floor_mm"] = f2f
        facts["_floor_source"] = "schedule_height_cluster"
        print(f"  [GTB] Levels from column height clustering: "
              f"{len(levels)} @ {f2f}mm f2f — {levels}")

    def _extract_levels_direct_llm(self, scanner_output: dict, facts: dict) -> None:
        """
        Last-resort: ask LLM directly for floor count + f2f height from schedule text.
        Fires only when all vision/regex/clustering fallbacks have failed.
        Cost: 1 LLM text-only call.
        """
        page_texts = scanner_output.get("forensic", {}).get("page_texts", {})
        schedule_idxs = scanner_output.get("batches", {}).get("SCHEDULE", [])
        for pg_idx in schedule_idxs[:3]:
            pt = page_texts.get(str(pg_idx)) or page_texts.get(pg_idx) or ""
            if not pt or len(pt) < 100:
                continue
            system = "You are a structural engineer reading a building schedule. Answer ONLY in JSON."
            user = (
                f"From this structural schedule:\n{pt[:3000]}\n\n"
                "How many floor levels does this building have? "
                "What is the typical floor-to-floor height in mm?\n"
                'Return JSON only: {"num_levels": 4, "floor_to_floor_mm": 3500}\n'
                "Use 0 if you cannot determine the value."
            )
            try:
                resp = call_llm(user, system=system)
                data = self._parse_json(resp)
                if not data:
                    continue
                n = int(data.get("num_levels") or 0)
                f2f = int(data.get("floor_to_floor_mm") or 0)
                if 2 <= n <= 12 and 2000 <= f2f <= 8000:
                    levels = {f"Level {i + 1}": i * f2f for i in range(n)}
                    facts["floor_heights_mm"] = levels
                    facts["floor_to_floor_mm"] = f2f
                    facts["_floor_source"] = "direct_llm_schedule"
                    print(f"  [GTB] Levels from direct LLM query: {n} levels @ {f2f}mm f2f")
                    return
            except Exception as e:
                print(f"  [GTB] WARN: _extract_levels_direct_llm page {pg_idx}: {e}")

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
