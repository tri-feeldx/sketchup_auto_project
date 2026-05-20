"""
=============================================================================
A3: SYNTHESIZER V7 — Cross-Page Structural Model Builder
=============================================================================
Takes outputs from Scanner V6 (per-page results) and synthesizes them
into a single unified Building Structural Model.

Key features:
  - Merges columns, beams, slabs, walls across all plan pages
  - Resolves conflicts: schedule data > plan data for member sizes
  - Grid alignment: snaps columns to nearest grid intersection
  - Level inference from elevations + sections
  - Span calculation: auto-compute beam spans from column positions
  - Material assignment from forensic + per-page analysis
  - Loads: auto-estimate based on material & spans
  - All prompts from PromptFactory
=============================================================================
"""

import json
import time
from typing import Dict, List, Optional

from core.llm_wrapper import call_llm
from pipelines.prompt_factory import PromptFactory


class SynthesizerV7:
    """
    Cross-Page Structural Model Synthesizer.
    Merges per-page analyses into unified building model.
    """

    def __init__(self, region: str = "vn", language: str = "vn"):
        self.region = region
        self.language = language
        self.prompt_factory = PromptFactory(region=region, language=language)

    def synthesize(self, scanner_output: dict) -> dict:
        """
        Build unified structural model from scanner results.
        
        Args:
            scanner_output: Output from ScannerV6.run()
                Expected keys: forensic, page_results, batches
        
        Returns:
            Unified building structural model dict
        """
        t0 = time.time()

        forensic = scanner_output.get("forensic", {})
        page_results = scanner_output.get("page_results", {})

        # Filter out skipped pages
        valid_results = []
        for key, pr in page_results.items():
            if not pr.get("skipped") and not pr.get("error"):
                valid_results.append(pr)

        if not valid_results:
            print("[SYNTH] No valid page results — returning empty model")
            return self._empty_model(forensic)

        # Attempt LLM-based synthesis
        system_prompt = self.prompt_factory.build_full_system_prompt(
            "synthesizer",
            building_type=forensic.get("building_type", "general"),
            region=self.region,
        )
        user_prompt = self.prompt_factory.user_prompt_synthesize(
            page_results=valid_results,
            profile=forensic,
        )

        try:
            response = call_llm(user_prompt, system=system_prompt)
            model = self._parse_json(response)
            if model:
                model = self._merge_members(model, valid_results, forensic)
                model["synthesis_method"] = "llm"
                model["elapsed_s"] = round(time.time() - t0, 1)
                return model
        except Exception as e:
            print(f"[SYNTH] LLM synthesis failed: {e}")

        # Fallback: deterministic merge
        print("[SYNTH] Using deterministic merge fallback")
        model = self._deterministic_merge(valid_results, forensic)
        model["synthesis_method"] = "deterministic"
        model["elapsed_s"] = round(time.time() - t0, 1)
        return model

    # ── DETERMINISTIC MERGE (NO LLM) ────────────────────────
    def _deterministic_merge(self, page_results: List[dict],
                              forensic: dict) -> dict:
        """Merge per-page data deterministically — no LLM needed."""
        model = {
            "project": {},
            "grid_system": self._extract_grid(forensic, page_results),
            "levels": self._extract_levels(forensic, page_results),
            "members": {
                "columns": [],
                "beams": [],
                "slabs": [],
                "walls": [],
                "footings": [],
                "bracing": [],
            },
            "materials": {},
            "summary": {},
        }

        # Collect all members
        all_columns = {}
        all_beams = []
        all_slabs = []
        all_walls = []
        all_footings = []
        all_bracing = []

        for pr in page_results:
            # Columns — deduplicate by ID
            for col in pr.get("columns", []):
                col_id = col.get("id", col.get("mark", ""))
                if col_id and col_id not in all_columns:
                    all_columns[col_id] = col

            all_beams.extend(pr.get("beams", []))
            all_slabs.extend(pr.get("slabs", []))
            all_walls.extend(pr.get("walls", []))
            all_footings.extend(pr.get("footings", []))
            all_bracing.extend(pr.get("bracing", []))

        model["members"]["columns"] = list(all_columns.values())
        model["members"]["beams"] = all_beams
        model["members"]["slabs"] = all_slabs
        model["members"]["walls"] = all_walls
        model["members"]["footings"] = all_footings
        model["members"]["bracing"] = all_bracing

        # Material summary
        model["materials"] = {
            "primary": forensic.get("primary_material", "unknown"),
            "region": forensic.get("region", "unknown"),
            "building_type": forensic.get("building_type", "general"),
        }

        # Summary
        model["summary"] = {
            "total_columns": len(all_columns),
            "total_beams": len(all_beams),
            "total_slabs": len(all_slabs),
            "total_walls": len(all_walls),
            "total_footings": len(all_footings),
            "total_bracing": len(all_bracing),
            "num_levels": len(model["levels"]),
            "grid_x_axes": len(model["grid_system"].get("x_axes", [])),
            "grid_y_axes": len(model["grid_system"].get("y_axes", [])),
        }

        # Auto-compute beam spans
        model["members"]["beams"] = self._compute_spans(
            model["members"]["beams"],
            model["members"]["columns"],
        )

        return model

    def _merge_members(self, llm_model: dict, page_results: List[dict],
                        forensic: dict) -> dict:
        """Enrich LLM model with deterministically merged data."""
        det = self._deterministic_merge(page_results, forensic)

        # If LLM model has fewer columns, supplement from deterministic
        llm_cols = llm_model.get("members", {}).get("columns", [])
        if len(llm_cols) < len(det["members"]["columns"]):
            llm_model.setdefault("members", {})
            llm_model["members"]["columns"] = det["members"]["columns"]

        # Ensure grid
        if not llm_model.get("grid_system"):
            llm_model["grid_system"] = det["grid_system"]

        # Ensure levels
        if not llm_model.get("levels"):
            llm_model["levels"] = det["levels"]

        # Ensure summary
        if not llm_model.get("summary"):
            llm_model["summary"] = det["summary"]

        return llm_model

    def _extract_grid(self, forensic: dict, page_results: List[dict]) -> dict:
        """Extract grid system from forensic + page data + PDF dimension analysis."""
        grid_x_set = set()
        grid_y_set = set()

        # From forensic
        for v in forensic.get("detected_grid_x", []):
            grid_x_set.add(str(v))
        for v in forensic.get("detected_grid_y", []):
            grid_y_set.add(str(v).upper())

        # Supplement from page results
        for pr in page_results:
            for col in pr.get("columns", []):
                gx = col.get("grid_x")
                gy = col.get("grid_y")
                for v in self._flatten_grid_value(gx):
                    grid_x_set.add(v)
                for v in self._flatten_grid_value(gy, upper=True):
                    grid_y_set.add(v)

        # Clean garbage (remove list literals, non-grid strings)
        grid_x = sorted(
            [v for v in grid_x_set if self._is_valid_grid(v)],
            key=lambda v: int(v) if v.isdigit() else 999,
        )
        grid_y = sorted(
            [v for v in grid_y_set if self._is_valid_grid(v)],
        )

        # ── Try PDFDimensionExtractor for real mm coordinates ──
        x_coords: dict = {}
        y_coords: dict = {}
        coord_confidence = 0.0
        coord_source = "default"
        pdf_path = forensic.get("pdf_path") or forensic.get("file_path", "")
        if pdf_path:
            try:
                from core.analyze_pdf import PDFDimensionExtractor
                ext = PDFDimensionExtractor(pdf_path, region=self.region)
                page_texts = forensic.get("page_texts", {})
                # Try up to 3 pages for best confidence
                best_conf = 0.0
                for idx in range(min(5, len(page_texts))):
                    pt = page_texts.get(str(idx)) or page_texts.get(idx) or ""
                    gc = ext.extract_grid_coordinates(
                        page_idx=idx,
                        page_text=pt,
                        x_labels=grid_x or None,
                        y_labels=grid_y or None,
                    )
                    if gc.confidence > best_conf:
                        best_conf = gc.confidence
                        x_coords = gc.x_coords
                        y_coords = gc.y_coords
                        coord_confidence = gc.confidence
                        coord_source = gc.source
                    if gc.confidence >= 0.7:
                        break
                if coord_confidence > 0:
                    print(f"  [GRID] PDFDimensionExtractor: "
                          f"confidence={coord_confidence:.2f}, source={coord_source}")
            except Exception as e:
                print(f"  [GRID] PDFDimensionExtractor failed: {e}")

        # Spacing: derive from x_coords if available, else estimate
        if x_coords and len(x_coords) >= 2:
            vals = sorted(x_coords.values())
            spacing_x = int(vals[1] - vals[0]) if len(vals) >= 2 else self._estimate_spacing(forensic, page_results)
        else:
            spacing_x = self._estimate_spacing(forensic, page_results)

        if y_coords and len(y_coords) >= 2:
            vals = sorted(y_coords.values())
            spacing_y = int(vals[1] - vals[0]) if len(vals) >= 2 else spacing_x
        else:
            spacing_y = spacing_x

        return {
            "x_axes": grid_x,
            "y_axes": grid_y,
            "spacing_x_mm": spacing_x,
            "spacing_y_mm": spacing_y,
            "x_coords": x_coords,    # label→mm, from PDFDimensionExtractor
            "y_coords": y_coords,
            "coord_confidence": coord_confidence,
            "coord_source": coord_source,
        }

    @staticmethod
    def _flatten_grid_value(val, upper=False):
        """Flatten grid value that could be str, list, or None."""
        if val is None:
            return []
        if isinstance(val, list):
            result = []
            for v in val:
                result.extend(SynthesizerV7._flatten_grid_value(v, upper))
            return result
        s = str(val).strip()
        if not s or len(s) > 4:  # skip long garbage
            return []
        if upper:
            s = s.upper()
        return [s]

    @staticmethod
    def _is_valid_grid(v: str) -> bool:
        """Filter out obvious garbage from grid values."""
        if not v:
            return False
        # Reject Python list literals, JSON, brackets
        if any(c in v for c in '[]{}"\''):
            return False
        # Reject numbers with dots (decimals), commas
        if '.' in v or ',' in v:
            return False
        # Accept single digits, letters, or digit+letter combos (like 2A)
        if len(v) > 3:
            return False
        return bool(v.strip())

    def _extract_levels(self, forensic: dict,
                         page_results: List[dict]) -> List[dict]:
        """Extract floor levels from elevation + section data."""
        levels = []
        for pr in page_results:
            for lvl in pr.get("levels", []):
                if lvl not in levels:
                    levels.append(lvl)

        if not levels:
            levels = [
                {"name": "Foundation", "elevation_mm": 0},
                {"name": "Ground Floor", "elevation_mm": 0, "height_mm": 3500},
                {"name": "Level 1", "elevation_mm": 3500, "height_mm": 3500},
            ]

        return levels

    def _estimate_spacing(self, forensic: dict,
                           page_results: List[dict]) -> int:
        """Estimate typical grid spacing in mm."""
        # Try to find from dimensions
        for pr in page_results:
            for dim in pr.get("dimensions_visible", []):
                val = dim.get("value_mm", 0)
                if 3000 <= val <= 12000:
                    return val // max(1, len(forensic.get("detected_grid_x", [4])))

        # Default: regional typical
        if forensic.get("region") == "vn":
            return 4000
        return 6000

    def _compute_spans(self, beams: List[dict],
                        columns: List[dict]) -> List[dict]:
        """Auto-compute beam spans from column positions."""
        col_map = {c.get("id", c.get("mark", "")): c for c in columns}

        for beam in beams:
            if beam.get("span_mm"):
                continue
            from_id = beam.get("from_col", beam.get("from", ""))
            to_id = beam.get("to_col", beam.get("to", ""))
            c1 = col_map.get(from_id, {})
            c2 = col_map.get(to_id, {})
            if c1 and c2:
                x1, y1 = c1.get("x", 0), c1.get("y", 0)
                x2, y2 = c2.get("x", 0), c2.get("y", 0)
                span = int(((x2 - x1) ** 2 + (y2 - y1) ** 2) ** 0.5)
                if span > 100:
                    beam["span_mm"] = span

        return beams

    # ── JSON PARSING ────────────────────────────────────────
    def _parse_json(self, response: str):
        """Parse LLM response with recovery strategies. Returns dict, list, or None."""
        if not response:
            return None
        # Strategy 1: Direct parse
        try:
            return json.loads(response)
        except json.JSONDecodeError:
            pass

        import re
        # Strategy 2: Extract from code blocks
        m = re.search(r'```(?:json)?\s*([\s\S]*?)```', response)
        if m:
            try:
                return json.loads(m.group(1))
            except json.JSONDecodeError:
                pass

        # Strategy 3: Find outer braces or brackets
        for open_c, close_c in [('{', '}'), ('[', ']')]:
            start = response.find(open_c)
            end = response.rfind(close_c)
            if start >= 0 and end > start:
                try:
                    return json.loads(response[start:end+1])
                except json.JSONDecodeError:
                    pass

        # Strategy 4: Repair truncated JSON
        try:
            stripped = response.strip().rstrip(",. \t\n\r")
            depth_curly = stripped.count("{") - stripped.count("}")
            depth_square = stripped.count("[") - stripped.count("]")
            repair = stripped
            repair += "]" * depth_square
            repair += "}" * depth_curly
            result = json.loads(repair)
            print(f"    [SYNTH] JSON repaired (added {depth_square}] {depth_curly}}})")
            return result
        except (json.JSONDecodeError, Exception):
            pass

        # Strategy 5: Try json_repair
        try:
            from json_repair import repair_json
            return json.loads(repair_json(response))
        except Exception:
            pass

        return None

    def _empty_model(self, forensic: dict) -> dict:
        return {
            "project": {},
            "grid_system": {"x_axes": [], "y_axes": [], "spacing_x_mm": 0, "spacing_y_mm": 0},
            "levels": [],
            "members": {"columns": [], "beams": [], "slabs": [], "walls": [], "footings": [], "bracing": []},
            "materials": {"primary": forensic.get("primary_material", "unknown")},
            "summary": {},
            "synthesis_method": "empty",
            "elapsed_s": 0,
            "error": "No valid page results",
        }


# ============================================================
# PUBLIC HELPER
# ============================================================

def synthesize(scanner_output: dict, region: str = "vn") -> dict:
    """Convenience wrapper."""
    synth = SynthesizerV7(region=region)
    return synth.synthesize(scanner_output)