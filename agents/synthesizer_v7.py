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
        """Extract grid system from forensic + page data."""
        grid_x = forensic.get("detected_grid_x", [])
        grid_y = forensic.get("detected_grid_y", [])

        # Supplement from page results
        for pr in page_results:
            for col in pr.get("columns", []):
                gx = col.get("grid_x", "")
                gy = col.get("grid_y", "")
                if gx and str(gx) not in grid_x:
                    grid_x.append(str(gx))
                if gy and str(gy).upper() not in grid_y:
                    grid_y.append(str(gy).upper())

        return {
            "x_axes": sorted(grid_x, key=lambda v: int(v) if v.isdigit() else 999),
            "y_axes": sorted(grid_y),
            "spacing_x_mm": self._estimate_spacing(forensic, page_results),
            "spacing_y_mm": self._estimate_spacing(forensic, page_results),
        }

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
    def _parse_json(self, response: str) -> Optional[dict]:
        """Parse LLM response with recovery strategies."""
        if not response:
            return None
        try:
            return json.loads(response)
        except json.JSONDecodeError:
            pass
        import re
        m = re.search(r'```(?:json)?\s*([\s\S]*?)```', response)
        if m:
            try:
                return json.loads(m.group(1))
            except json.JSONDecodeError:
                pass
        brace_start = response.find('{')
        brace_end = response.rfind('}')
        if brace_start >= 0 and brace_end > brace_start:
            try:
                return json.loads(response[brace_start:brace_end+1])
            except json.JSONDecodeError:
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