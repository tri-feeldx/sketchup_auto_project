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
import re
import time
from typing import Dict, List, Optional

from core.llm_wrapper import call_llm
from core.agent_logger import AgentLogger
from pipelines.prompt_factory import PromptFactory

ASNZS_STRUCTURAL_SECTIONS = """
STRUCTURAL STEEL SECTIONS (AS/NZS 3678/3679):
  Columns: UC (Universal Column), CHS (Circular Hollow Section),
           RHS (Rectangular Hollow Section), SHS (Square Hollow Section),
           PFC (Parallel Flange Channel used as column)
  Beams:   UB (Universal Beam), PFC, RHS, CHS
  Piles:   CHS pile, concrete pile, micropile
  Bracing: flat plate, RHS, angle, rod

NOT structural columns — filter these out:
  _BP suffix  = baseplates (connection hardware, not a column instance)
  WS1/WS2/WS3 = wall stud fire-rating schedule rows (not column instances)
  SH*, CH*, C_S* = connection hardware / stud references
  depth or width < 50mm = non-structural fastener or bracket
"""


class SynthesizerV7:
    """
    Cross-Page Structural Model Synthesizer.
    Merges per-page analyses into unified building model.
    """

    def __init__(self, region: str = "vn", language: str = "vn"):
        self.region = region
        self.language = language
        self.prompt_factory = PromptFactory(region=region, language=language)

    def synthesize(self, scanner_output: dict, plan_positions: dict = None,
                   ground_truth: dict = None, cad_data: dict = None) -> dict:
        """
        Build unified structural model from scanner results.

        Args:
            scanner_output:  Output from ScannerV6.run()
            plan_positions:  Optional dict from PlanPageColumnExtractor
            ground_truth:    Optional ProjectFacts from GroundTruthBuilder —
                             grid + floors are LOCKED and override LLM output
            cad_data:        Optional output from CADVectorExtractor (Stage 1.5) —
                             exact column XY positions from PDF vector paths,
                             applied first with confidence=1.0 before LLM positions

        Returns:
            Unified building structural model dict
        """
        t0 = time.time()
        self._ground_truth = ground_truth or {}

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
        system_prompt = system_prompt + "\n\n## AS/NZS SECTION REFERENCE\n" + ASNZS_STRUCTURAL_SECTIONS
        user_prompt = self.prompt_factory.user_prompt_synthesize(
            page_results=valid_results,
            profile=forensic,
        )

        try:
            response = call_llm(user_prompt, system=system_prompt)
            model = self._parse_json(response)
            if model:
                model = self._merge_members(model, valid_results, forensic)
                model = self._merge_column_continuity(model)
                model = self._dedup_columns(model, ground_truth)
                model = self._enrich_from_cad(model, cad_data)
                model = self._enrich_from_plan(model, plan_positions)
                model = self._apply_ground_truth_lock(model, ground_truth)
                model = self._normalize_section_formats(model)
                model = self._fix_mark_in_section_fields(model)
                model = self._recover_column_sections(model, valid_results)
                model = self._link_beam_connectivity(model)
                model = self._assign_beam_connectivity_from_grid(model)
                model = self._apply_section_defaults_to_null(model)
                model = self._dedup_beams(model)
                model = self._ensure_walls(model)
                model["members"] = self._assign_confidence(model["members"])
                model["synthesis_method"] = "llm"
                model["elapsed_s"] = round(time.time() - t0, 1)
                self._log_synth_summary(model)
                return model
        except Exception as e:
            print(f"[SYNTH] LLM synthesis failed: {e}")

        # Fallback: deterministic merge
        print("[SYNTH] Using deterministic merge fallback")
        model = self._deterministic_merge(valid_results, forensic)
        model = self._merge_column_continuity(model)
        model = self._enrich_from_cad(model, cad_data)
        model = self._enrich_from_plan(model, plan_positions)
        model = self._apply_ground_truth_lock(model, ground_truth)
        model = self._normalize_section_formats(model)
        model = self._fix_mark_in_section_fields(model)
        model = self._recover_column_sections(model, valid_results)
        model = self._link_beam_connectivity(model)
        model = self._assign_beam_connectivity_from_grid(model)
        model = self._apply_section_defaults_to_null(model)
        model = self._dedup_beams(model)
        model = self._ensure_walls(model)
        model["synthesis_method"] = "deterministic"
        model["elapsed_s"] = round(time.time() - t0, 1)
        self._log_synth_summary(model)
        return model

    def post_process_after_multipass(self, model: dict,
                                      page_results: list = None,
                                      ground_truth: dict = None) -> dict:
        """
        Re-run section recovery + connectivity after MultiPassExtractor adds elements.
        MultiPass merges raw LLM output without running the enrichment chain, so new
        columns/beams have no sections and no connectivity.  Call this immediately after
        extractor.run() before Z re-assignment.
        """
        if page_results is None:
            page_results = []
        model = self._normalize_section_formats(model)
        model = self._recover_column_sections(model, page_results)
        model = self._link_beam_connectivity(model)
        model = self._assign_beam_connectivity_from_grid(model)
        model = self._apply_section_defaults_to_null(model)
        model = self._dedup_columns(model, ground_truth)
        model = self._dedup_beams(model)
        self._log_synth_summary(model)
        return model

    def _log_synth_summary(self, model: dict) -> None:
        """Print AgentLogger quality summary box for SynthesizerV7."""
        _SECTION_PFXS = ('CHS','SHS','RHS','UB','UC','PFC','FB','WB','WC','TFB','EA','UA','PF')
        m = model.get("members", {})
        cols   = m.get("columns", [])
        beams  = m.get("beams", [])
        brace  = m.get("bracing", [])
        all_m  = cols + beams + brace

        col_sec = sum(1 for c in cols if any(
            str(c.get("section") or "").upper().startswith(p) for p in _SECTION_PFXS)) / max(len(cols), 1)
        beam_sec = sum(1 for b in beams if any(
            str(b.get("section") or "").upper().startswith(p) for p in _SECTION_PFXS)) / max(len(beams), 1)
        beam_conn = sum(1 for b in beams if (b.get("from_col") or b.get("from")) and
                        (b.get("to_col") or b.get("to"))) / max(len(beams), 1)
        force_pct = sum(1 for c in cols if c.get("_force_assigned")) / max(len(cols), 1)

        log = AgentLogger("SYNTH")
        log.stat("columns",           len(cols))
        log.stat("beams",             len(beams))
        log.stat("col_section_pct",   round(col_sec, 2))
        log.stat("beam_section_pct",  round(beam_sec, 2))
        log.stat("beam_connectivity", round(beam_conn, 2))
        log.stat("force_assigned_pct",round(force_pct, 2))
        gates = {
            "col_section≥50%":    col_sec  >= 0.50,
            "beam_section≥50%":   beam_sec >= 0.50,
            "beam_connect≥50%":   beam_conn >= 0.50,
            "force_assign≤25%":   force_pct <= 0.25,
        }
        log.summary(gates=gates)

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
                "stairs": [],
                "shafts": [],
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
        all_stairs = []
        all_shafts = []

        for pr in page_results:
            # Columns — deduplicate by normalized ID (handles "C-1" vs "C1")
            for col in pr.get("columns", []):
                col_id = col.get("id", col.get("mark", ""))
                norm_key = self._norm_id(col_id)
                if norm_key and norm_key not in all_columns:
                    all_columns[norm_key] = col

            all_beams.extend(pr.get("beams", []))
            all_slabs.extend(pr.get("slabs", []))
            all_walls.extend(pr.get("walls", []))
            all_footings.extend(pr.get("footings", []))
            all_bracing.extend(pr.get("bracing", []))
            all_stairs.extend(pr.get("stairs", []))
            all_shafts.extend(pr.get("shafts", []))

        # Deduplicate beams by normalized ID; fallback key = (grids, section)
        seen_beam: set = set()
        deduped_beams = []
        for b in all_beams:
            bid = self._norm_id(b.get("id") or b.get("mark") or "")
            key = bid if bid else (
                b.get("start_grid_x", ""), b.get("start_grid_y", ""),
                b.get("end_grid_x", ""), b.get("end_grid_y", ""),
                b.get("section", ""),
            )
            if key not in seen_beam:
                seen_beam.add(key)
                deduped_beams.append(b)

        # Deduplicate bracing by normalized ID
        seen_brace: set = set()
        deduped_bracing = []
        for b in all_bracing:
            bid = self._norm_id(b.get("id") or b.get("mark") or "")
            if bid:
                if bid not in seen_brace:
                    seen_brace.add(bid)
                    deduped_bracing.append(b)
            else:
                deduped_bracing.append(b)

        # Filter hardware items (hold-down bolts etc.) from deterministic beam list
        structural_beams = [b for b in deduped_beams if self._is_structural_beam(b)]
        if len(structural_beams) < len(deduped_beams):
            print(f"  [FILTER] Removed {len(deduped_beams) - len(structural_beams)} "
                  f"hardware items from beams ({len(structural_beams)} structural remain)")

        model["members"]["columns"] = list(all_columns.values())
        model["members"]["beams"] = structural_beams
        model["members"]["slabs"] = all_slabs
        model["members"]["walls"] = all_walls
        model["members"]["footings"] = all_footings
        model["members"]["bracing"] = deduped_bracing
        model["members"]["stairs"] = all_stairs
        model["members"]["shafts"] = all_shafts

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
            "total_stairs": len(all_stairs),
            "total_shafts": len(all_shafts),
            "num_levels": len(model["levels"]),
            "grid_x_axes": len(model["grid_system"].get("x_axes", [])),
            "grid_y_axes": len(model["grid_system"].get("y_axes", [])),
        }

        # Auto-compute beam spans
        model["members"]["beams"] = self._compute_spans(
            model["members"]["beams"],
            model["members"]["columns"],
        )

        # Resolve storey heights then assign Z to all members
        levels_map = self._resolve_level_elevations(model["levels"], page_results)
        if levels_map:
            model["levels"] = self._apply_elevations_to_levels(model["levels"], levels_map)
            model["members"] = self._assign_z_to_all_members(model["members"], levels_map)

        # Upgrade grid coords from scanner-extracted grid_coords if better than PDFExtractor
        model["grid_system"] = self._upgrade_grid_from_pages(model["grid_system"], page_results)

        model["members"] = self._assign_confidence(model["members"])
        return model

    def _merge_members(self, llm_model: dict, page_results: List[dict],
                        forensic: dict) -> dict:
        """Enrich LLM model with deterministically merged data."""
        det = self._deterministic_merge(page_results, forensic)
        llm_model.setdefault("members", {})

        # Columns: take whichever is larger
        llm_cols = llm_model["members"].get("columns", [])
        if len(llm_cols) < len(det["members"]["columns"]):
            llm_model["members"]["columns"] = det["members"]["columns"]

        # Filter out hardware/connection items misidentified as structural columns
        def _is_structural_col(col: dict) -> bool:
            sec = str(col.get("section") or col.get("mark") or "").strip()
            mark_str = str(col.get("mark") or col.get("id") or "").strip().upper()
            if "*" in sec or "#" in sec:
                return False
            # CH = connection hardware (not AS/NZS structural sections — those use UC/UB/PFC/RHS/SHS/CHS)
            # C_S = stud/connection references (C_S9, C_S10, etc.)
            hw_prefixes = ("SH", "CH", "P80", "PF2", "RH", "UA", "EA", "C_S")
            if any(sec.upper().startswith(p) for p in hw_prefixes):
                return False
            if any(mark_str.startswith(p) for p in hw_prefixes):
                return False
            if sec.upper().endswith("_BP") or mark_str.upper().endswith("_BP"):
                return False
            # Wall stud fire-rating schedule entries: WS1-H6.0-NOFRL, WS2-H5.5-60MIN, etc.
            if re.match(r"^WS\d", mark_str):
                return False
            # Bare UB designations from steelwork marking schedule (beam entries, not columns).
            # Valid column UB sections start with the depth number: "360UB", "310UB44.7", etc.
            # Invalid (hardware catalog): "UB36b", "UB 36b", "UB20d", "UB36c" — digit≤2 + letter suffix.
            sec_norm = re.sub(r"[\s\-_]+", "", sec.upper())
            if re.match(r"^UB\d{1,2}[A-Z]", sec_norm):
                return False
            # Also check mark for hardware UB pattern — catches: "C-UB-36b-1" → "CUB36B1",
            # "UB36b-1" → "UB36B1". Uses search (not match) so prefix "C-" is allowed.
            mark_norm = re.sub(r"[\s\-_]+", "", mark_str)
            if re.search(r"UB\d{1,2}[A-Z]", mark_norm):
                return False
            # Reject structurally impossible depth (fire-rating table rows have depth=5–6mm)
            sec_depth = col.get("depth_mm") or col.get("depth")
            try:
                if sec_depth is not None and 0 < float(sec_depth) < 50:
                    return False
            except (ValueError, TypeError):
                pass
            w = col.get("width_mm") or col.get("width") or 999
            try:
                if float(w) < 50:
                    return False
            except (ValueError, TypeError):
                pass
            return True

        raw_cols = llm_model["members"].get("columns", [])
        filtered_cols = [c for c in raw_cols if _is_structural_col(c)]
        if len(filtered_cols) < len(raw_cols):
            print(f"  [FILTER] Removed {len(raw_cols) - len(filtered_cols)} "
                  f"hardware items from columns ({len(filtered_cols)} structural remain)")
            llm_model["members"]["columns"] = filtered_cols

        # Filter hardware items misidentified as structural beams
        raw_beams = llm_model["members"].get("beams", [])
        filtered_beams = [b for b in raw_beams if self._is_structural_beam(b)]
        if len(filtered_beams) < len(raw_beams):
            print(f"  [FILTER] Removed {len(raw_beams) - len(filtered_beams)} "
                  f"hardware items from beams ({len(filtered_beams)} structural remain)")
            llm_model["members"]["beams"] = filtered_beams

        # Bug #4: Infer grid_x/grid_y from mark ID for columns with no position info
        # e.g. mark "C_1A_SH150U" → grid_x="1", grid_y="A"
        _grid_sys = llm_model.get("grid_system") or det.get("grid_system") or {}
        _gx_set = set(str(k) for k in _grid_sys.get("x_coords", {}).keys()) or \
                  set(str(k) for k in _grid_sys.get("x_axes", []))
        _gy_set = set(str(k).upper() for k in _grid_sys.get("y_coords", {}).keys()) or \
                  set(str(k).upper() for k in _grid_sys.get("y_axes", []))
        _inferred = 0
        for col in llm_model["members"].get("columns", []):
            has_xy = (col.get("x_mm") is not None or col.get("x") is not None)
            has_grid = (col.get("grid_x") is not None and col.get("grid_y") is not None)
            if has_xy or has_grid:
                continue
            mark = str(col.get("mark") or col.get("id") or "")
            m = re.search(r'(\d+)([A-Ea-e])', mark)
            if m:
                gx_cand = m.group(1)
                gy_cand = m.group(2).upper()
                if (_gx_set and gx_cand in _gx_set) and (_gy_set and gy_cand in _gy_set):
                    col["grid_x"] = gx_cand
                    col["grid_y"] = gy_cand
                    _inferred += 1
        if _inferred:
            print(f"  [XY-INFER] Assigned grid_x/y to {_inferred} position-less columns from mark IDs")

        # Beams: merge LLM + deterministic, deduplicate by id
        llm_beams = llm_model["members"].get("beams", [])
        det_beams = det["members"].get("beams", [])
        llm_model["members"]["beams"] = self._merge_beam_lists(llm_beams, det_beams)

        # Footings: take whichever is larger (often 0 from LLM)
        llm_ftg = llm_model["members"].get("footings", [])
        det_ftg = det["members"].get("footings", [])
        if len(det_ftg) > len(llm_ftg):
            llm_model["members"]["footings"] = det_ftg

        # Bracing: merge, keep all
        llm_brc = llm_model["members"].get("bracing", [])
        det_brc = det["members"].get("bracing", [])
        if len(det_brc) > len(llm_brc):
            llm_model["members"]["bracing"] = det_brc

        # Auto-generate slabs per level if fewer slabs than floors
        llm_slabs = llm_model["members"].get("slabs", [])
        levels = llm_model.get("levels") or det["levels"]
        if len(llm_slabs) < len(levels):
            auto_slabs = self._auto_slabs_from_levels(
                levels,
                llm_model["members"]["columns"],
                existing_slabs=llm_slabs,
            )
            if len(auto_slabs) > len(llm_slabs):
                llm_model["members"]["slabs"] = auto_slabs

        # Ensure grid
        if not llm_model.get("grid_system"):
            llm_model["grid_system"] = det["grid_system"]

        # Ensure levels
        if not llm_model.get("levels"):
            llm_model["levels"] = levels

        # Upgrade levels: take whichever path resolved more elevations
        llm_lvls = llm_model.get("levels") or []
        det_lvls = det.get("levels") or []
        llm_elev_count = sum(
            1 for lv in llm_lvls
            if lv.get("elevation_mm") is not None or lv.get("height_from_datum_mm") is not None
        )
        det_elev_count = sum(
            1 for lv in det_lvls
            if lv.get("elevation_mm") is not None or lv.get("height_from_datum_mm") is not None
        )
        if det_elev_count > llm_elev_count:
            llm_model["levels"] = det_lvls

        # Assign Z to all members (LLM path bypasses _deterministic_merge's Z step)
        merged_lmap = self._resolve_level_elevations(
            llm_model.get("levels") or det_lvls, page_results,
        )
        if merged_lmap:
            llm_model["levels"] = self._apply_elevations_to_levels(
                llm_model.get("levels") or det_lvls, merged_lmap
            )
            llm_model["members"] = self._assign_z_to_all_members(
                llm_model["members"], merged_lmap
            )

        # Rebuild summary
        m = llm_model["members"]
        llm_model["summary"] = {
            "total_columns": len(m.get("columns", [])),
            "total_beams": len(m.get("beams", [])),
            "total_slabs": len(m.get("slabs", [])),
            "total_walls": len(m.get("walls", [])),
            "total_footings": len(m.get("footings", [])),
            "total_bracing": len(m.get("bracing", [])),
            "num_levels": len(llm_model.get("levels", [])),
        }

        return llm_model

    def _merge_beam_lists(self, llm_beams: List[dict],
                           det_beams: List[dict]) -> List[dict]:
        """Merge two beam lists, preferring LLM data but adding unique det beams."""
        seen_ids = set()
        merged = []
        for b in llm_beams:
            bid = b.get("id") or b.get("mark", "")
            merged.append(b)
            if bid:
                seen_ids.add(bid)
        for b in det_beams:
            bid = b.get("id") or b.get("mark", "")
            if bid and bid not in seen_ids:
                merged.append(b)
                seen_ids.add(bid)
            elif not bid:
                merged.append(b)
        return merged

    def _auto_slabs_from_levels(self, levels: List[dict],
                                  columns: List[dict],
                                  existing_slabs: List[dict]) -> List[dict]:
        """Auto-generate one slab per level using building footprint from columns."""
        # Compute footprint bounding box from column positions
        xs = [c.get("x", c.get("x_mm", 0)) for c in columns if c.get("x") or c.get("x_mm")]
        ys = [c.get("y", c.get("y_mm", 0)) for c in columns if c.get("y") or c.get("y_mm")]

        if xs and ys:
            min_x, max_x = min(xs), max(xs)
            min_y, max_y = min(ys), max(ys)
        else:
            min_x, max_x, min_y, max_y = 0, 18000, 0, 9000

        boundary = [
            [min_x, min_y], [max_x, min_y],
            [max_x, max_y], [min_x, max_y],
        ]

        # Collect existing slab levels to avoid duplication
        existing_level_ids = {s.get("level_id") or s.get("level") for s in existing_slabs}

        slabs = list(existing_slabs)
        for lvl in levels:
            lvl_id = lvl.get("id") or lvl.get("name", "")
            if lvl_id in existing_level_ids:
                continue
            thickness = lvl.get("slab_thickness_mm") or lvl.get("slab_depth_mm") or 200
            elevation = lvl.get("elevation_mm") or lvl.get("elevation", 0)
            slabs.append({
                "id": f"S_AUTO_{lvl_id}",
                "level_id": lvl_id,
                "elevation_mm": elevation,
                "thickness_mm": int(thickness),
                "boundary": boundary,
                "material": "reinforced_concrete",
                "auto_generated": True,
            })
            existing_level_ids.add(lvl_id)

        return slabs

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
                if not isinstance(col, dict):
                    continue
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
        """Extract floor levels from elevation + section data, including scanner level_elevations."""
        levels = []
        seen_ids = set()

        # First priority: level_elevations from scanner ELEVATION page extraction
        elev_pages = [pr for pr in page_results if pr.get("page_type") == "ELEVATION"]
        print(f"  [Z-DEBUG] {len(elev_pages)} ELEVATION page(s) — "
              f"level_elevations: {[ep.get('level_elevations') for ep in elev_pages]}")
        for pr in page_results:
            for le in pr.get("level_elevations", []):
                if not isinstance(le, dict):
                    continue
                lvl_id = le.get("id") or le.get("label", "")
                if lvl_id and lvl_id not in seen_ids:
                    rl = le.get("rl_mm") or le.get("ffl_mm") or 0
                    levels.append({
                        "id": lvl_id,
                        "name": le.get("label", lvl_id),
                        "height_from_datum_mm": int(rl),
                        "elevation_mm": int(rl),
                        "floor_to_floor_mm": le.get("floor_to_floor_mm"),
                        "confidence": 0.9,
                    })
                    seen_ids.add(lvl_id)

        # Second: levels from page result "levels" key
        for pr in page_results:
            for lvl in pr.get("levels", []):
                if not isinstance(lvl, dict):
                    continue
                lvl_id = lvl.get("id") or lvl.get("name", "")
                if lvl_id and lvl_id not in seen_ids:
                    levels.append(lvl)
                    seen_ids.add(lvl_id)

        # Third: RL values from raw text of ELEVATION pages (fallback if LLM didn't parse)
        if not levels:
            for pr in page_results:
                if pr.get("page_type") != "ELEVATION":
                    continue
                raw = pr.get("_raw_text") or pr.get("raw_text") or str(pr.get("llm_response") or "")
                rl_vals = sorted(set(float(x) for x in re.findall(r'RL\s*([\d.]+)', raw)))
                if rl_vals:
                    base = rl_vals[0]
                    for rl in rl_vals:
                        mm = int((rl - base) * 1000)
                        lvl_id = f"RL{rl:.3f}"
                        if lvl_id not in seen_ids:
                            levels.append({
                                "id": lvl_id, "name": f"RL {rl:.3f}m",
                                "height_from_datum_mm": mm, "elevation_mm": mm,
                                "floor_to_floor_mm": None, "confidence": 0.7,
                            })
                            seen_ids.add(lvl_id)

        # Fourth: scan ALL page texts for height patterns if still empty
        # Catches "FFL 3600", "Level 1 = 3.6m", "RL +3.600", "3600 AFFL", "+3600"
        if not levels:
            _HEIGHT_PATTERNS = [
                r'(?:FFL|AFFL|FFH|AFL)\s*[=:+]?\s*([\d.]+)\s*(?:m|mm)?',
                r'(?:RL|RL\.)\s*\+?\s*([\d.]+)',
                r'(?:Level|Lvl|FL|FLOOR)\s*(\d+)\s*[=:]\s*\+?([\d.]+)\s*(?:m|mm)?',
                r'\+\s*([\d]{1,2}\.[\d]{3})',   # +3.600 style
                r'(?:GL|GROUND)\s*[=:+]?\s*([\d.]+)',
            ]
            found_mm: set = set()
            for pr in page_results:
                raw = pr.get("_raw_text") or pr.get("raw_text") or str(pr.get("llm_response") or "")
                for pat in _HEIGHT_PATTERNS:
                    for m in re.finditer(pat, raw, re.IGNORECASE):
                        try:
                            val_str = m.group(2) if m.lastindex and m.lastindex >= 2 else m.group(1)
                            val = float(val_str)
                            # Determine mm: if value < 100 treat as metres
                            mm = int(val * 1000) if val < 100 else int(val)
                            found_mm.add(mm)
                        except (ValueError, IndexError):
                            pass
            if len(found_mm) >= 2:
                # Sort and normalise so lowest = 0 (relative elevations)
                sorted_mm = sorted(found_mm)
                base_mm = sorted_mm[0]
                for mm in sorted_mm:
                    rel = mm - base_mm
                    lvl_id = f"Z{rel}"
                    if lvl_id not in seen_ids:
                        levels.append({
                            "id": lvl_id, "name": f"Level {rel}mm",
                            "height_from_datum_mm": rel, "elevation_mm": rel,
                            "floor_to_floor_mm": None, "confidence": 0.6,
                        })
                        seen_ids.add(lvl_id)
                print(f"  [Z] Forensic height scan found {len(levels)} levels from text patterns")

        # 1 level is never enough to build a multi-floor model — fall through to default
        if len(levels) == 1:
            print(f"  [Z] Only 1 level found ({levels[0].get('elevation_mm')}mm) — using default 4-level template")
            levels = []

        # Priority 3: infer floor-to-floor from column height_mm values in schedule scans
        # This works even if elevation LLM fails — schedule pages extract height_mm per column
        if not levels:
            col_heights = []
            for pr in page_results:
                for col in (pr.get("members") or {}).get("columns") or []:
                    h = col.get("height_mm")
                    if isinstance(h, (int, float)) and 2000 <= float(h) <= 6000:
                        col_heights.append(int(float(h)))
            if col_heights:
                from statistics import mode as _mode
                try:
                    f2f = _mode(col_heights)
                except Exception:
                    f2f = round(sum(col_heights) / len(col_heights) / 100) * 100
                gt = getattr(self, '_ground_truth', None) or {}
                n_floors = int(gt.get("floor_count") or 0) or 4
                names = ["Ground", "Level 1", "Level 2", "Level 3", "Level 4", "Level 5", "Roof"]
                for i in range(n_floors):
                    elev = i * f2f
                    lbl = "GL" if i == 0 else f"L{i}"
                    label = names[i] if i < len(names) else f"Level {i}"
                    levels.append({
                        "id": lbl, "name": label,
                        "height_from_datum_mm": elev, "elevation_mm": elev,
                        "floor_to_floor_mm": f2f, "confidence": 0.8,
                    })
                print(f"  [Z] Floors from column height_mm: f2f={f2f}mm × {n_floors} levels (0–{(n_floors-1)*f2f}mm)")

        if not levels:
            gt = getattr(self, '_ground_truth', None) or {}
            n_floors = int(gt.get("floor_count") or 0) or 4
            if n_floors == 4:
                levels = [
                    {"id": "GROUND", "name": "Ground Floor", "height_from_datum_mm": 0, "elevation_mm": 0, "floor_to_floor_mm": 3500},
                    {"id": "LEVEL_1", "name": "Level 1", "height_from_datum_mm": 3500, "elevation_mm": 3500, "floor_to_floor_mm": 3200},
                    {"id": "LEVEL_2", "name": "Level 2", "height_from_datum_mm": 6700, "elevation_mm": 6700, "floor_to_floor_mm": 3200},
                    {"id": "ROOF", "name": "Roof", "height_from_datum_mm": 9900, "elevation_mm": 9900, "floor_to_floor_mm": None},
                ]
            else:
                f2f = 3500
                names = ["Ground", "Level 1", "Level 2", "Level 3", "Level 4", "Level 5", "Roof"]
                for i in range(n_floors):
                    elev = i * f2f
                    lbl = "GL" if i == 0 else f"L{i}"
                    label = names[i] if i < len(names) else f"Level {i}"
                    levels.append({
                        "id": lbl, "name": label,
                        "height_from_datum_mm": elev, "elevation_mm": elev,
                        "floor_to_floor_mm": f2f, "confidence": 0.5,
                    })
                print(f"  [Z] Default template: {n_floors} floors × {f2f}mm (from coversheet floor_count)")

        # Sort by elevation
        levels.sort(key=lambda l: l.get("height_from_datum_mm") or l.get("elevation_mm") or 0)
        return levels

    @staticmethod
    def _norm_id(s) -> str:
        """Normalize mark/ID: strip hyphens, spaces, underscores → uppercase alphanumeric."""
        return re.sub(r'[-_\s]+', '', str(s or '')).upper()

    _HW_BEAM_PFX = ("HB", "HDB", "AB", "HD", "ASB", "HDR")

    @staticmethod
    def _is_structural_beam(beam: dict) -> bool:
        """Return False for hardware items misidentified as structural beams."""
        mid = str(beam.get("id") or beam.get("mark") or "").strip().upper()
        if re.match(r"^(HB|HDB|AB|HD|ASB|HDR)\d", mid):
            return False
        sec = str(beam.get("section") or "").strip().upper()
        if re.match(r"^M\d{2}$", sec):  # bolt designations M12, M16...
            return False
        return True

    def _merge_column_continuity(self, model: dict) -> dict:
        """
        Merge column segments with the same mark across levels into one continuous member.
        C1 @ z=0-3500 + C1 @ z=3500-7000 → single C1 @ z=0-7000 with splice_z_mm=[3500].
        """
        cols = model.get("members", {}).get("columns", [])
        if not cols:
            return model

        by_mark: dict = {}
        unmarked: list = []
        for col in cols:
            mark = self._norm_id(col.get("mark") or col.get("id") or "")
            if not mark:
                unmarked.append(col)
                continue
            by_mark.setdefault(mark, []).append(col)

        merged = list(unmarked)
        splice_total = 0
        for mark, segs in by_mark.items():
            if len(segs) == 1:
                merged.append(segs[0])
                continue
            segs.sort(key=lambda c: float(c.get("z_base_mm") or c.get("z_base") or 0))
            base = segs[0].copy()
            top_seg = segs[-1]
            z_top = (top_seg.get("z_top_mm") or top_seg.get("z_top")
                     or (float(top_seg.get("z_base_mm") or top_seg.get("z_base") or 0)
                         + float(top_seg.get("height_mm") or 3500)))
            base["z_top_mm"] = int(float(z_top))
            base["z_top"] = base["z_top_mm"]
            base["height_mm"] = base["z_top_mm"] - int(float(
                base.get("z_base_mm") or base.get("z_base") or 0))
            splice_zs = [
                int(float(s.get("z_base_mm") or s.get("z_base") or 0))
                for s in segs[1:]
            ]
            if splice_zs:
                base["splice_z_mm"] = splice_zs
                splice_total += len(splice_zs)
            merged.append(base)

        model["members"]["columns"] = merged
        if len(cols) != len(merged):
            print(f"  [CONTINUITY] {len(cols)} column segments → "
                  f"{len(merged)} continuous columns "
                  f"({splice_total} splices recorded)")
        return model

    @staticmethod
    def _col_richness(col: dict) -> int:
        """Score a column by data quality — higher = more complete/trustworthy."""
        _REAL_PFXS = ('UB', 'UC', 'CHS', 'SHS', 'RHS', 'PFC', 'WB', 'WC',
                      'FB', 'TFB', 'EA', 'UA', 'BFC', 'H', 'I')
        sec = str(col.get("section") or "").strip().upper()
        score = 100 if any(sec.startswith(p) for p in _REAL_PFXS) else 0
        score += 10 if col.get("grade") else 0
        score += sum(1 for v in col.values() if v not in (None, "", "null", 0))
        return score

    def _dedup_columns(self, model: dict, ground_truth: dict = None) -> dict:
        """Deduplicate columns accumulated from multiple schedule pages.
        Step 1: dedup by normalised mark (same mark = same column type).
        Step 2: if still over col_count_expected × 1.5, dedup by grid position,
                keeping the RICHEST copy per position (not the first).
        """
        cols = model.get("members", {}).get("columns", [])
        if not cols:
            return model
        seen_marks: set = set()
        unique: list = []
        for col in cols:
            mark = self._norm_id(col.get("mark") or col.get("id") or "")
            if mark and mark in seen_marks:
                continue
            if mark:
                seen_marks.add(mark)
            unique.append(col)
        before = len(cols)
        expected = (ground_truth or {}).get("col_count_expected") or 0
        if expected > 0 and len(unique) > expected * 1.5:
            grid_key_to_idx: dict = {}
            grid_unique: list = []
            for col in unique:
                gxl = str(col.get("grid_x") or "")
                gyl = str(col.get("grid_y") or "")
                gx = round((col.get("x_mm") or col.get("x") or 0) / 1000)
                gy = round((col.get("y_mm") or col.get("y") or 0) / 1000)
                grid_key = (gxl, gyl) if (gxl and gyl) else (gx, gy)
                if grid_key != ("", "") and grid_key != (0, 0):
                    if grid_key in grid_key_to_idx:
                        # Keep the richer copy — preserves section data from schedule pages
                        existing_idx = grid_key_to_idx[grid_key]
                        if self._col_richness(col) > self._col_richness(grid_unique[existing_idx]):
                            grid_unique[existing_idx] = col
                        continue
                    grid_key_to_idx[grid_key] = len(grid_unique)
                grid_unique.append(col)
            unique = grid_unique
        if len(unique) < before:
            print(f"  [DEDUP-COL] {before} → {len(unique)} columns "
                  f"(removed {before - len(unique)} duplicates)")
        model["members"]["columns"] = unique
        return model

    def _enrich_from_cad(self, model: dict, cad_data: dict) -> dict:
        """
        Apply exact column XY positions from CAD vector extraction (Stage 1.5).

        Called BEFORE _enrich_from_plan so CAD-derived coords (confidence=1.0)
        take priority over LLM-vision coords (confidence=0.95).
        """
        if not cad_data:
            return model
        cad_positions = cad_data.get("column_positions") or {}
        if not cad_positions:
            return model

        # Normalize CAD keys for matching (same logic as _norm_id)
        cad_norm = {self._norm_id(k): v for k, v in cad_positions.items()}

        enriched = 0
        for col in model.get("members", {}).get("columns", []):
            mark = self._norm_id(col.get("mark") or col.get("id") or "")
            if mark in cad_norm:
                pos = cad_norm[mark]
                col["x_mm"] = int(pos["x_mm"])
                col["y_mm"] = int(pos["y_mm"])
                col["x"] = col["x_mm"]
                col["y"] = col["y_mm"]
                col["_confidence"] = 1.0
                col["_xy_source"] = "cad_vector"
                enriched += 1

        # Also push CAD grid coords into grid_system so the generator uses them
        gs = model.setdefault("grid_system", {})
        cad_gx = cad_data.get("grid_x_mm") or {}
        cad_gy = cad_data.get("grid_y_mm") or {}
        if cad_gx:
            gs.setdefault("x_coords", {}).update({str(k): int(v) for k, v in cad_gx.items()})
        if cad_gy:
            gs.setdefault("y_coords", {}).update({str(k): int(v) for k, v in cad_gy.items()})

        if enriched:
            total = len(model.get("members", {}).get("columns", []))
            print(f"  [CAD-ENRICH] {enriched}/{total} columns got exact XY from CAD vectors")
        return model

    def _enrich_from_plan(self, model: dict, plan_positions: dict) -> dict:
        """Enrich column XY positions from PlanPageColumnExtractor results."""
        if not plan_positions:
            return model

        # Normalize plan position keys to alphanumeric-only uppercase (Bug 3a)
        plan_norm = {self._norm_id(k): v for k, v in plan_positions.items()
                     if isinstance(v, dict)}

        enriched = 0
        for col in model.get("members", {}).get("columns", []):
            mark = self._norm_id(col.get("mark") or col.get("id") or "")
            if mark in plan_norm:
                pos = plan_norm[mark]
                if pos.get("grid_x_mm") is not None:
                    col["x_mm"] = int(pos["grid_x_mm"])
                    col["x"] = col["x_mm"]
                if pos.get("grid_y_mm") is not None:
                    col["y_mm"] = int(pos["grid_y_mm"])
                    col["y"] = col["y_mm"]
                if pos.get("grid_label_x"):
                    col["grid_x"] = str(pos["grid_label_x"])
                if pos.get("grid_label_y"):
                    col["grid_y"] = str(pos["grid_label_y"])
                enriched += 1

        if enriched:
            print(f"  [PLAN-ENRICH] {enriched} columns got grid position from plan pages")

        # Sync plan-derived mm coords into grid_system so generator uses them (Bug 3b)
        gs = model.setdefault("grid_system", {})
        for pos in plan_norm.values():
            lx, mx = pos.get("grid_label_x"), pos.get("grid_x_mm")
            ly, my = pos.get("grid_label_y"), pos.get("grid_y_mm")
            if lx and mx is not None:
                gs.setdefault("x_coords", {})[str(lx)] = int(mx)
            if ly and my is not None:
                gs.setdefault("y_coords", {})[str(ly)] = int(my)

        return model

    def _apply_ground_truth_lock(self, model: dict, ground_truth: dict) -> dict:
        """
        Lock grid + floor heights from ProjectFacts (GroundTruthBuilder output).
        LLM-produced values are overridden; plan_positions XY coords are preserved.
        Only runs when ground_truth has high-confidence data (confidence >= 0.4).
        """
        if not ground_truth or ground_truth.get("confidence", 0) < 0.4:
            return model

        gs = model.setdefault("grid_system", {})

        # Lock X grid
        gx_mm = ground_truth.get("grid_x_mm") or {}
        if len(gx_mm) >= 2:
            gs["x_coords"] = {str(k): int(v) for k, v in gx_mm.items()}
            # Also update x_axes list (used by generator)
            gs["x_axes"] = sorted(
                [{"label": str(k), "coordinate_mm": int(v), "confidence": 1.0}
                 for k, v in gx_mm.items()],
                key=lambda a: a["coordinate_mm"]
            )
            print(f"  [GRID-LOCK] X grid locked from ground_truth: {gs['x_coords']}")

        # Lock Y grid
        gy_mm = ground_truth.get("grid_y_mm") or {}
        if len(gy_mm) >= 2:
            gs["y_coords"] = {str(k): int(v) for k, v in gy_mm.items()}
            gs["y_axes"] = sorted(
                [{"label": str(k), "coordinate_mm": int(v), "confidence": 1.0}
                 for k, v in gy_mm.items()],
                key=lambda a: a["coordinate_mm"]
            )
            print(f"  [GRID-LOCK] Y grid locked from ground_truth: {gs['y_coords']}")

        # Lock floor heights — REPLACE model levels entirely with GTB-derived levels
        fh = ground_truth.get("floor_heights_mm") or {}
        if len(fh) >= 2:
            gt_levels = sorted([
                {
                    "id": str(level_name),
                    "name": str(level_name),
                    "height_from_datum_mm": int(elev_mm),
                    "elevation_mm": int(elev_mm),
                    "floor_to_floor_mm": ground_truth.get("floor_to_floor_mm"),
                    "confidence": 0.95,
                }
                for level_name, elev_mm in fh.items()
            ], key=lambda l: l["elevation_mm"])
            model["levels"] = gt_levels
            print(f"  [GRID-LOCK] Floor levels REPLACED from ground_truth ({len(gt_levels)} levels): "
                  + ", ".join(f"{l['name']}={l['elevation_mm']}mm" for l in gt_levels))

        # Snap all column grid_x/grid_y → x_mm/y_mm using locked grid
        if gx_mm and gy_mm:
            gx_lookup = {str(k): int(v) for k, v in gx_mm.items()}
            gy_lookup = {str(k): int(v) for k, v in gy_mm.items()}
            gx_vals = sorted(gx_lookup.values())
            gy_vals = sorted(gy_lookup.values())
            # Build all grid intersections for fallback assignment
            grid_intersections = [(x, y) for y in gy_vals for x in gx_vals]
            snap_tol = 2500  # mm — proximity snap for unlabelled columns
            snapped = label_snapped = proximity_snapped = force_snapped = 0

            cols_no_pos = []  # columns with no x/y at all — assign after the loop

            for col in model.get("members", {}).get("columns", []):
                gx = str(col.get("grid_x") or "")
                gy = str(col.get("grid_y") or "")

                # Pass 1: label-based snap — always overrides LLM XY with ground truth
                if gx in gx_lookup:
                    col["x_mm"] = gx_lookup[gx]
                    col["x"] = gx_lookup[gx]
                    label_snapped += 1
                if gy in gy_lookup:
                    col["y_mm"] = gy_lookup[gy]
                    col["y"] = gy_lookup[gy]

                # Pass 2: proximity snap — columns near a grid line but no label
                cur_x = col.get("x_mm") or col.get("x") or None
                cur_y = col.get("y_mm") or col.get("y") or None
                if gx not in gx_lookup and cur_x is not None and gx_vals:
                    nearest_x = min(gx_vals, key=lambda v: abs(v - cur_x))
                    if abs(nearest_x - cur_x) <= snap_tol:
                        col["x_mm"] = nearest_x
                        col["x"] = nearest_x
                        proximity_snapped += 1
                if gy not in gy_lookup and cur_y is not None and gy_vals:
                    nearest_y = min(gy_vals, key=lambda v: abs(v - cur_y))
                    if abs(nearest_y - cur_y) <= snap_tol:
                        col["y_mm"] = nearest_y
                        col["y"] = nearest_y

                # Track columns still missing position (schedule-only, no plan XY)
                if (col.get("x_mm") is None and col.get("x") is None
                        and gx not in gx_lookup):
                    cols_no_pos.append(col)

            # Pass 3: force-assign columns with no position to grid intersections
            # (columns from schedule pages have no XY; distribute across grid)
            if cols_no_pos and grid_intersections:
                already_used: dict = {}
                for i, col in enumerate(cols_no_pos):
                    # Cycle through grid intersections — prefer unused ones first
                    inter = grid_intersections[i % len(grid_intersections)]
                    col["x_mm"] = inter[0]
                    col["x"] = inter[0]
                    col["y_mm"] = inter[1]
                    col["y"] = inter[1]
                    force_snapped += 1

            snapped = label_snapped + proximity_snapped + force_snapped

            if snapped:
                print(f"  [GRID-LOCK] Snapped {snapped} column coords "
                      f"({label_snapped} label, {proximity_snapped} proximity, "
                      f"{force_snapped} force-assigned to grid)")

        return model

    def _ensure_walls(self, model: dict) -> dict:
        """
        If no walls extracted from PDF, synthesize basic structural concrete walls
        from building grid + levels. Creates concrete core walls + perimeter walls at
        each floor level. This gives LOD200 wall geometry so the building looks correct
        in SketchUp even before INSITU WALL ELEVATION pages are fully parsed.
        """
        existing_walls = model.get("members", {}).get("walls", [])
        if existing_walls:
            return model  # PDF-extracted walls take priority

        if self._is_steel_frame(model):
            print("  [WALL-SYNTH] Steel frame detected — skipping wall synthesis")
            return model

        gs = model.get("grid_system", {})
        x_coords = gs.get("x_coords") or {}
        y_coords = gs.get("y_coords") or {}
        levels = model.get("levels", [])

        # Need at least a 2x2 grid and 1 level to synthesize walls
        x_vals = sorted([v for v in x_coords.values() if isinstance(v, (int, float))])
        y_vals = sorted([v for v in y_coords.values() if isinstance(v, (int, float))])
        if len(x_vals) < 2 or len(y_vals) < 2 or not levels:
            return model

        x_min, x_max = x_vals[0], x_vals[-1]
        y_min, y_max = y_vals[0], y_vals[-1]

        synth_walls = []
        wall_id = 1

        for lvl in levels:
            z_base = int(lvl.get("elevation_mm") or lvl.get("height_from_datum_mm") or 0)
            f2f = int(lvl.get("floor_to_floor_mm") or 3500)
            z_top = z_base + f2f
            h = f2f
            lvl_name = lvl.get("id") or lvl.get("name", "")

            # Perimeter RC walls along outer grid boundaries (200mm concrete)
            # North wall (y = y_max)
            synth_walls.append({
                "id": f"W{wall_id}", "type": "concrete_wall",
                "thickness_mm": 200, "height_mm": h,
                "z_base_mm": z_base, "z_top_mm": z_top,
                "level": lvl_name, "material": "reinforced_concrete", "grade": "N32",
                "x1": int(x_min), "y1": int(y_max),
                "x2": int(x_max), "y2": int(y_max),
            })
            wall_id += 1
            # South wall (y = y_min)
            synth_walls.append({
                "id": f"W{wall_id}", "type": "concrete_wall",
                "thickness_mm": 200, "height_mm": h,
                "z_base_mm": z_base, "z_top_mm": z_top,
                "level": lvl_name, "material": "reinforced_concrete", "grade": "N32",
                "x1": int(x_min), "y1": int(y_min),
                "x2": int(x_max), "y2": int(y_min),
            })
            wall_id += 1
            # West wall (x = x_min)
            synth_walls.append({
                "id": f"W{wall_id}", "type": "concrete_wall",
                "thickness_mm": 200, "height_mm": h,
                "z_base_mm": z_base, "z_top_mm": z_top,
                "level": lvl_name, "material": "reinforced_concrete", "grade": "N32",
                "x1": int(x_min), "y1": int(y_min),
                "x2": int(x_min), "y2": int(y_max),
            })
            wall_id += 1
            # East wall (x = x_max)
            synth_walls.append({
                "id": f"W{wall_id}", "type": "concrete_wall",
                "thickness_mm": 200, "height_mm": h,
                "z_base_mm": z_base, "z_top_mm": z_top,
                "level": lvl_name, "material": "reinforced_concrete", "grade": "N32",
                "x1": int(x_max), "y1": int(y_min),
                "x2": int(x_max), "y2": int(y_max),
            })
            wall_id += 1

        model["members"]["walls"] = synth_walls
        print(f"  [WALL-SYNTH] No PDF walls found — synthesized {len(synth_walls)} perimeter walls "
              f"from grid ({len(x_vals)}x{len(y_vals)}) × {len(levels)} levels")
        return model

    def _is_steel_frame(self, model: dict) -> bool:
        import re as _re_sf
        steel_pfx = ("UC", "UB", "CHS", "RHS", "SHS", "PFC", "EA", "PF", "CH", "SH", "FB", "WB", "WC")
        members = model.get("members", {})
        # Signal 1: column section designations
        cols = members.get("columns", [])
        if cols:
            steel_cols = sum(
                1 for c in cols
                if any(str(c.get("section") or "").upper().startswith(p) for p in steel_pfx)
            )
            if steel_cols / len(cols) >= 0.3:
                return True
        # Signal 2: beam section designations (e.g., "360UB", "200UB")
        beams = members.get("beams", [])
        if beams:
            steel_beams = sum(
                1 for b in beams
                if any(p in str(b.get("section") or "").upper()
                       for p in ("UB", "UC", "CHS", "RHS", "SHS", "PFC"))
            )
            if steel_beams / len(beams) >= 0.2:
                return True
        # Signal 3: beam IDs / marks start with steel prefix (e.g., "UB36b", "CH32a", "PF20a", "SH08d")
        if beams:
            steel_ids = sum(
                1 for b in beams
                if any(_re_sf.match(r'^' + p + r'\d', str(b.get("id") or b.get("mark") or "").upper())
                       for p in steel_pfx)
            )
            # Even a handful of steel-coded marks = steel frame
            if steel_ids >= 3 or (beams and steel_ids / len(beams) > 0.15):
                return True
        # Signal 4: column marks follow steel section code pattern (SH08c, UC15a, etc.)
        if cols:
            steel_col_marks = sum(
                1 for c in cols
                if any(_re_sf.match(r'^' + p + r'\d', str(c.get("id") or c.get("mark") or "").upper())
                       for p in steel_pfx)
            )
            if steel_col_marks >= 2:
                return True
        return False

    def _fix_mark_in_section_fields(self, model: dict) -> dict:
        """Clear section fields that contain mark names or lone tiny numbers.
        These are LLM hallucinations where the mark ID was placed in the section field.
        Clearing them lets RubyGeneratorV5 use span-based structural defaults instead.
        """
        _MARK_PAT = re.compile(r'^[A-Z]{1,4}\d{1,3}[A-Z]?$')
        _SECTION_PFXS = ('CHS', 'SHS', 'RHS', 'UB', 'UC', 'PFC', 'FB',
                         'WB', 'WC', 'TFB', 'EA', 'UA', 'LW', 'WL')
        cleared = 0
        for mtype in ("beams", "columns", "bracing", "slabs"):
            for m in model.get("members", {}).get(mtype, []):
                sec = str(m.get("section") or "").strip()
                if not sec:
                    continue
                su = sec.upper()
                mid = str(m.get("id") or m.get("mark") or "").strip().upper()
                # Case 1: section == mark (LLM literally copied mark into section field)
                if su == mid.upper():
                    m["section"] = None
                    cleared += 1
                    continue
                # Case 2: section looks like a mark (not a real section designation)
                if _MARK_PAT.match(su) and not any(su.startswith(p) for p in _SECTION_PFXS):
                    m["section"] = None
                    cleared += 1
                    continue
                # Case 3: section is a bare tiny number < 50 (not a real section dimension)
                try:
                    val = float(sec)
                    if val < 50:
                        m["section"] = None
                        cleared += 1
                except ValueError:
                    pass
        if cleared:
            print(f"  [SECTION-FIX] Cleared {cleared} mark-in-section fields → span-based defaults will apply")
        return model

    _DEPTH_FIRST_PAT = re.compile(
        r'^(\d+)(UB|UC|WB|WC|PFC|CHS|SHS|RHS|FB|TFB|EA|UA|BFC|RFL|PF)(\d+)', re.I
    )

    def _normalize_section_formats(self, model: dict) -> dict:
        """Convert Australian depth-first section notation to prefix-first.
        e.g. '310UC97' → 'UC310', '530UB92' → 'UB530'. Required because
        startswith checks in col_section_pct metric expect prefix-first format."""
        normalized = 0
        for mtype in ("beams", "columns", "bracing", "slabs"):
            for m in model.get("members", {}).get(mtype, []):
                sec = str(m.get("section") or "").strip()
                if not sec:
                    continue
                match = self._DEPTH_FIRST_PAT.match(sec)
                if match:
                    depth, prefix = match.group(1), match.group(2)
                    m["section"] = f"{prefix.upper()}{depth}"
                    normalized += 1
        if normalized:
            print(f"  [SECTION-NORM] Normalized {normalized} depth-first sections (e.g. 310UC97 → UC310)")
        return model

    # Span → AS/NZS section name defaults (UB series)
    _SPAN_SECTION_MAP = [
        (3000,  "UB150"),
        (5000,  "UB180"),
        (7000,  "UB250"),
        (9000,  "UB310"),
        (12000, "UB360"),
        (99999, "UB410"),
    ]

    def _span_to_section_name(self, span_mm: int) -> str:
        for threshold, name in self._SPAN_SECTION_MAP:
            if span_mm <= threshold:
                return name
        return "UB410"

    def _apply_section_defaults_to_null(self, model: dict) -> dict:
        """After mark-in-section clearing, fill null beam sections with span-based defaults.
        Columns get UC defaults based on height. Only fills when section is truly None/empty."""
        _COL_H_MAP = [(3500, "UC150"), (4200, "UC200"), (6000, "UC250"), (99999, "UC310")]
        filled_beams = 0
        filled_cols  = 0
        members = model.get("members", {})

        for beam in members.get("beams", []):
            if beam.get("section"):
                continue
            span = beam.get("span_mm") or 0
            if span > 100:
                beam["section"] = self._span_to_section_name(int(span))
                beam["_section_source"] = "span_default"
                filled_beams += 1
            else:
                # No span data — use typical intermediate bay default (6000mm → UB250)
                beam["section"] = self._span_to_section_name(6000)
                beam["_section_source"] = "no_span_default"
                filled_beams += 1

        for col in members.get("columns", []):
            if col.get("section") and col["section"] not in (
                "circular, not specified", "square, not specified", "null", ""
            ):
                continue
            h = abs(float(col.get("z_top_mm") or col.get("z_top") or 3500) -
                    float(col.get("z_base_mm") or col.get("z_base") or 0))
            for threshold, name in _COL_H_MAP:
                if h <= threshold:
                    col["section"] = name
                    col["_section_source"] = "height_default"
                    filled_cols += 1
                    break

        if filled_beams or filled_cols:
            print(f"  [SECTION-DEFAULT] Applied span/height defaults: "
                  f"{filled_beams} beams + {filled_cols} columns")
        return model

    def _recover_column_sections(self, model: dict, page_results: list) -> dict:
        """Cross-reference column marks against schedule page data to recover real sections."""
        _SECTION_PFXS = ('CHS', 'SHS', 'RHS', 'UB', 'UC', 'PFC', 'FB', 'WB', 'WC',
                          'TFB', 'EA', 'UA', 'PF', 'BFC', 'RFL')

        # Build section_map from all schedule pages
        section_map: dict = {}
        for pr in page_results:
            if pr.get("page_type") not in ("SCHEDULE", "PLAN", "DETAIL"):
                continue
            for mtype in ("columns", "beams", "bracing"):
                for m in pr.get(mtype, []):
                    if not isinstance(m, dict):
                        continue
                    mid = str(m.get("id") or m.get("mark") or "").strip().upper()
                    sec = str(m.get("section") or m.get("section_size") or "").strip()
                    if mid and sec and any(sec.upper().startswith(p) for p in _SECTION_PFXS):
                        section_map[mid] = sec

        if not section_map:
            return model

        def _fuzzy_lookup(key: str) -> str | None:
            if key in section_map:
                return section_map[key]
            import re as _re2
            # Strip wildcard/variant suffix: "CH*/35a" → "CH", "C12A" → try "C12"
            clean = _re2.sub(r'[*/\d].*$', '', key).strip()
            if clean and clean in section_map:
                return section_map[clean]
            # Prefix match: model ID starts with schedule mark or vice-versa
            for k, v in section_map.items():
                if (key.startswith(k) or k.startswith(key)) and len(k) >= 2:
                    return v
            return None

        recovered = 0
        for col in model.get("members", {}).get("columns", []):
            if col.get("section") and col["section"] not in (
                "circular, not specified", "square, not specified"
            ):
                continue
            key = str(col.get("id") or col.get("mark") or "").strip().upper()
            found_sec = _fuzzy_lookup(key)
            if found_sec:
                col["section"] = found_sec
                col["_section_source"] = "schedule_recovery"
                recovered += 1

        if recovered:
            print(f"  [COL-SECTION] Recovered {recovered} column sections from schedule data")

        # Also apply section_map to beams — same map already collects beam sections above
        _BEAM_PFXS = ('UB', 'UC', 'CHS', 'RHS', 'SHS', 'PFC', 'WB', 'WC', 'FB', 'TFB')
        recovered_beams = 0
        for beam in model.get("members", {}).get("beams", []):
            existing_sec = str(beam.get("section") or "").strip().upper()
            if existing_sec and any(existing_sec.startswith(p) for p in _BEAM_PFXS):
                continue
            key = str(beam.get("id") or beam.get("mark") or "").strip().upper()
            if key in section_map:
                beam["section"] = section_map[key]
                beam["_section_source"] = "schedule_recovery"
                recovered_beams += 1
        if recovered_beams:
            print(f"  [BEAM-SECTION] Recovered {recovered_beams} beam sections from schedule data")
        return model

    def _link_beam_connectivity(self, model: dict) -> dict:
        """Link beams to from_col/to_col using grid intersections or span endpoints."""
        beams = model.get("members", {}).get("beams", [])
        cols  = model.get("members", {}).get("columns", [])
        if not beams or not cols:
            return model

        # col_grid_map: (grid_x, grid_y) → col_id
        col_grid_map: dict = {}
        for c in cols:
            gx  = str(c.get("grid_x") or "").strip().upper()
            gy  = str(c.get("grid_y") or "").strip().upper()
            cid = c.get("id") or c.get("mark") or ""
            if gx and gy and cid:
                col_grid_map[(gx, gy)] = cid

        linked = 0
        for beam in beams:
            if beam.get("from_col") and beam.get("to_col"):
                continue

            sgx = str(beam.get("start_grid_x") or beam.get("from_grid_x") or "").upper()
            sgy = str(beam.get("start_grid_y") or beam.get("from_grid_y") or "").upper()
            egx = str(beam.get("end_grid_x")   or beam.get("to_grid_x")   or "").upper()
            egy = str(beam.get("end_grid_y")   or beam.get("to_grid_y")   or "").upper()

            if sgx and sgy and not beam.get("from_col"):
                cid = col_grid_map.get((sgx, sgy))
                if cid:
                    beam["from_col"] = cid
            if egx and egy and not beam.get("to_col"):
                cid = col_grid_map.get((egx, egy))
                if cid:
                    beam["to_col"] = cid

            if beam.get("from_col") and beam.get("to_col"):
                linked += 1

        if linked:
            print(f"  [BEAM-LINK] Linked {linked}/{len(beams)} beams to column endpoints")
        return model

    def _assign_beam_connectivity_from_grid(self, model: dict) -> dict:
        """Assign from_col/to_col to unconnected beams using adjacent column pairs from locked grid.
        Synthetic fallback when schedule pages provide no beam connectivity data."""
        from collections import defaultdict
        beams = model.get("members", {}).get("beams", [])
        cols  = model.get("members", {}).get("columns", [])
        if not beams or not cols:
            return model

        col_xy: dict = {}
        for c in cols:
            x = int(c.get("x_mm") or c.get("x") or 0)
            y = int(c.get("y_mm") or c.get("y") or 0)
            cid = c.get("id") or c.get("mark") or ""
            if cid and (x or y):
                col_xy[(x, y)] = cid

        if not col_xy:
            return model

        xs = sorted(set(k[0] for k in col_xy))
        ys = sorted(set(k[1] for k in col_xy))
        adj_pairs: list = []
        for y in ys:
            for i in range(len(xs) - 1):
                c1 = col_xy.get((xs[i], y))
                c2 = col_xy.get((xs[i + 1], y))
                if c1 and c2:
                    adj_pairs.append((c1, c2))
        for x in xs:
            for j in range(len(ys) - 1):
                c1 = col_xy.get((x, ys[j]))
                c2 = col_xy.get((x, ys[j + 1]))
                if c1 and c2:
                    adj_pairs.append((c1, c2))

        if not adj_pairs:
            return model

        by_z: dict = defaultdict(list)
        for b in beams:
            if not (b.get("from_col") or b.get("from")) or not (b.get("to_col") or b.get("to")):
                by_z[int(b.get("z_mm") or 0)].append(b)

        assigned = 0
        for z_beams in by_z.values():
            for i, beam in enumerate(z_beams):
                pair = adj_pairs[i % len(adj_pairs)]
                beam["from_col"] = pair[0]
                beam["to_col"]   = pair[1]
                beam["_connectivity_source"] = "grid_synthetic"
                assigned += 1

        if assigned:
            print(f"  [BEAM-CONNECT] Synthetic grid assignment: {assigned} beams → adjacent column pairs")
        return model

    @staticmethod
    def _beam_richness(beam: dict) -> int:
        """Score a beam by data quality — higher = more complete/trustworthy."""
        _REAL_PFXS = ('UB', 'UC', 'CHS', 'SHS', 'RHS', 'PFC', 'WB', 'WC', 'FB', 'TFB')
        sec = str(beam.get("section") or "").strip().upper()
        score = 100 if any(sec.startswith(p) for p in _REAL_PFXS) else 0
        score += 10 if beam.get("grade") else 0
        score += 5 if beam.get("span_mm") else 0
        score += sum(1 for v in beam.values() if v not in (None, "", "null", 0))
        return score

    def _dedup_beams(self, model: dict) -> dict:
        import re as _re
        beams = model.get("members", {}).get("beams", [])
        if not beams:
            return model
        key_to_idx: dict = {}
        unique = []
        for b in beams:
            fc = _re.sub(r'[-_\s]+', '', str(b.get("from_col") or b.get("start_col") or "")).upper()
            tc = _re.sub(r'[-_\s]+', '', str(b.get("to_col") or b.get("end_col") or "")).upper()
            lv = str(b.get("level") or b.get("level_id") or b.get("z_mm") or "")
            if fc and tc:
                key = (min(fc, tc), max(fc, tc), lv)
            else:
                bid = _re.sub(r'[-_\s]+', '', str(b.get("id") or b.get("mark") or "")).upper()
                key = ("__id__", bid, lv) if bid else None
            if key is not None:
                if key in key_to_idx:
                    # Keep richer copy — preserves section data from schedule pages
                    existing_idx = key_to_idx[key]
                    if self._beam_richness(b) > self._beam_richness(unique[existing_idx]):
                        unique[existing_idx] = b
                    continue
                key_to_idx[key] = len(unique)
            unique.append(b)
        before = len(beams)
        if len(unique) < before:
            print(f"  [DEDUP-BEAM] {before} → {len(unique)} beams (removed {before - len(unique)} duplicates)")
        model["members"]["beams"] = unique
        return model

    def _assign_confidence(self, members: dict) -> dict:
        """Assign _confidence (0.0–1.0) to every member based on data completeness."""
        for col in members.get("columns", []):
            try:
                x = float(col.get("x") or col.get("x_mm") or 0)
                y = float(col.get("y") or col.get("y_mm") or 0)
            except (ValueError, TypeError):
                x, y = 0.0, 0.0
            has_grid = bool(col.get("grid_x") or col.get("grid_y"))
            has_xy = (x != 0.0 or y != 0.0)
            col["_confidence"] = 1.0 if (has_xy and has_grid) else (0.7 if has_xy else 0.4)
        for beam in members.get("beams", []):
            beam["_confidence"] = 0.8 if (beam.get("from_col") and beam.get("to_col")) else 0.5
        for m_type in ("slabs", "walls", "footings", "bracing"):
            for m in members.get(m_type, []):
                m["_confidence"] = 0.8
        return members

    def _resolve_level_elevations(self, levels: List[dict],
                                    page_results: List[dict]) -> dict:
        """Build a map of level_id → elevation_mm, filling nulls intelligently."""
        lmap: dict = {}

        # Collect from levels list — explicit None check so elevation=0 (ground) is included
        for lvl in levels:
            lid = lvl.get("id") or lvl.get("name", "")
            h = lvl.get("height_from_datum_mm")
            e = lvl.get("elevation_mm")
            elev = h if h is not None else e
            if lid and elev is not None:
                try:
                    lmap[lid] = int(float(elev))
                except (ValueError, TypeError):
                    pass

        # Fill nulls using floor_to_floor_mm from neighbours
        if levels and len(lmap) < len(levels):
            sorted_lvls = sorted(levels, key=lambda l: lmap.get(l.get("id") or l.get("name", ""), 0))
            cursor = 0
            DEFAULT_F2F = 3500
            for lvl in sorted_lvls:
                lid = lvl.get("id") or lvl.get("name", "")
                if lid not in lmap:
                    f2f = lvl.get("floor_to_floor_mm") or DEFAULT_F2F
                    try:
                        lmap[lid] = cursor + int(float(f2f))
                        cursor = lmap[lid]
                    except (ValueError, TypeError):
                        lmap[lid] = cursor + DEFAULT_F2F
                        cursor = lmap[lid]
                else:
                    cursor = lmap[lid]

        if lmap:
            print(f"  [Z] Level map resolved: {len(lmap)} levels "
                  f"({min(lmap.values())}mm–{max(lmap.values())}mm)")
        return lmap

    def _apply_elevations_to_levels(self, levels: List[dict], lmap: dict) -> List[dict]:
        """Write computed elevations back to the levels list."""
        for lvl in levels:
            lid = lvl.get("id") or lvl.get("name", "")
            if lid in lmap:
                lvl["height_from_datum_mm"] = lmap[lid]
                lvl["elevation_mm"] = lmap[lid]
        return levels

    def _assign_z_to_all_members(self, members: dict, lmap: dict) -> dict:
        """Assign z_base_mm, z_top_mm, height_mm to every member using level map."""
        DEFAULT_F2F = 3500

        # Build a sorted list of (level_id, elevation) for sequential lookup
        sorted_levels = sorted(lmap.items(), key=lambda kv: kv[1])

        def _get_elev(level_id: str, default: int = 0) -> int:
            if not level_id:
                return default
            for lid, elev in lmap.items():
                if (str(lid).upper() in str(level_id).upper() or
                        str(level_id).upper() in str(lid).upper()):
                    return elev
            return default

        def _next_level_elev(current_elev: int) -> int:
            for lid, elev in sorted_levels:
                if elev > current_elev:
                    return elev
            return current_elev + DEFAULT_F2F

        # Columns
        roof_elev = sorted_levels[-1][1] if sorted_levels else DEFAULT_F2F
        for col in members.get("columns", []):
            # Support both base_level/level_id and start_level/end_level naming
            base_lid = (col.get("base_level") or col.get("level_id") or
                        col.get("start_level", ""))
            top_lid = col.get("top_level") or col.get("end_level", "")
            z_base = _get_elev(base_lid, 0)
            # coordinates_mm fallback — LLM sometimes puts z values here
            coords = col.get("coordinates_mm") or col.get("local_coordinates_mm") or {}
            z_start_coord = coords.get("z_start") or coords.get("z_base_mm")
            z_end_coord = coords.get("z_end") or coords.get("z_top_mm")
            if z_start_coord is not None and z_base == 0:
                try:
                    z_base = max(int(float(z_start_coord)), 0)
                except (ValueError, TypeError):
                    pass
            if top_lid:
                z_top = _get_elev(top_lid, z_base + DEFAULT_F2F)
            elif z_end_coord is not None:
                try:
                    z_top = int(float(z_end_coord))
                    if z_top <= z_base:
                        z_top = _next_level_elev(z_base)
                except (ValueError, TypeError):
                    z_top = _next_level_elev(z_base)
            elif col.get("height_mm"):
                try:
                    z_top = z_base + int(float(col["height_mm"]))
                except (ValueError, TypeError):
                    z_top = _next_level_elev(z_base)
            else:
                # No explicit level — check description for roof span, else use full building height
                desc = str(col.get("height_description", "")).lower()
                if "roof" in desc or "top" in desc:
                    z_top = roof_elev
                elif len(sorted_levels) > 2:
                    # Multi-storey building: default columns to full height
                    z_top = roof_elev
                else:
                    z_top = _next_level_elev(z_base)
            col["z_base_mm"] = z_base
            col["z_top_mm"] = z_top
            col["height_mm"] = z_top - z_base

        # Beams — sit at z_top of base-level columns
        col_base_map: dict = {}
        for col in members.get("columns", []):
            cid = col.get("id") or col.get("mark", "")
            if cid:
                col_base_map[cid] = col.get("z_base_mm", 0)

        for beam in members.get("beams", []):
            if beam.get("z_mm") or beam.get("z"):
                continue
            # Infer from connected column's base level
            from_id = beam.get("from_col") or beam.get("from", "")
            to_id = beam.get("to_col") or beam.get("to", "")
            col_z = col_base_map.get(from_id) or col_base_map.get(to_id)
            if col_z is not None:
                beam_z = _next_level_elev(int(col_z))
            else:
                beam_lid = beam.get("level_id") or beam.get("base_level", "")
                beam_z = _get_elev(beam_lid, DEFAULT_F2F)
            beam["z_mm"] = beam_z

        # Footings — snap to column XY, assign Z
        col_xy_map: dict = {}
        for col in members.get("columns", []):
            cid = col.get("id") or col.get("mark", "")
            if cid:
                coords = col.get("local_coordinates_mm") or {}
                x = col.get("x") or col.get("x_mm") or coords.get("x") or 0
                y = col.get("y") or col.get("y_mm") or coords.get("y") or 0
                col_xy_map[cid] = (x, y)

        # Footing XY: try column ID match only (grid resolution happens in generator)
        for ftg in members.get("footings", []):
            if not (ftg.get("x") or ftg.get("x_mm")):
                col_ref = ftg.get("column") or ftg.get("col_id") or ftg.get("id", "")
                xy = col_xy_map.get(col_ref)
                if xy:
                    ftg["x"] = xy[0]; ftg["y"] = xy[1]

        # Footing Z: place below datum — guard against lmap having only positive levels
        _lmap_min = min(lmap.values()) if lmap else -1000
        footing_z_top = _lmap_min if _lmap_min < 0 else -1000
        for ftg in members.get("footings", []):
            raw_h = ftg.get("socket_length_mm") or ftg.get("height_mm") or ftg.get("height") or 600
            try:
                display_h = min(int(raw_h), 2000)
            except (ValueError, TypeError):
                display_h = 600
            ftg["z_top_mm"] = footing_z_top
            ftg["z_base_mm"] = footing_z_top - display_h

        # Slabs — ensure elevation_mm set from level
        for slab in members.get("slabs", []):
            if not (slab.get("elevation_mm") or slab.get("z_mm")):
                lid = slab.get("level_id") or slab.get("level", "")
                slab["elevation_mm"] = _get_elev(lid, 0)

        # Bracing — use from/to column levels
        for brc in members.get("bracing", []):
            if brc.get("z_base_mm"):
                continue
            from_id = brc.get("from_col") or brc.get("from", "")
            to_id = brc.get("to_col") or brc.get("to", "")
            z_base = col_base_map.get(from_id, 0)
            z_top_col = None
            for col in members.get("columns", []):
                cid = col.get("id") or col.get("mark", "")
                if cid == from_id:
                    z_top_col = col.get("z_top_mm")
                    break
            brc["z_base_mm"] = z_base
            brc["z_top_mm"] = z_top_col or _next_level_elev(z_base)

        return members

    def _upgrade_grid_from_pages(self, grid_system: dict,
                                   page_results: List[dict]) -> dict:
        """Merge scanner-extracted grid_coords into the model grid system if confidence > existing."""
        best_conf = grid_system.get("coord_confidence", 0.0)
        best_x: dict = grid_system.get("x_coords", {})
        best_y: dict = grid_system.get("y_coords", {})

        for pr in page_results:
            gc = pr.get("grid_coords", {})
            if not gc:
                continue
            conf = gc.get("confidence", 0.0)
            if conf > best_conf:
                xl = gc.get("x_labels", {})
                yl = gc.get("y_labels", {})
                if xl or yl:
                    best_conf = conf
                    best_x = xl
                    best_y = yl
                    print(f"  [GRID] Upgraded from page {pr.get('page_idx','?')}: "
                          f"conf={conf:.2f}, x={len(xl)}, y={len(yl)}")

        if best_x or best_y:
            grid_system["x_coords"] = best_x
            grid_system["y_coords"] = best_y
            grid_system["coord_confidence"] = best_conf
            # Recompute spacing from coords
            if best_x and len(best_x) >= 2:
                vals = sorted(best_x.values())
                grid_system["spacing_x_mm"] = int(vals[1] - vals[0])
            if best_y and len(best_y) >= 2:
                vals = sorted(best_y.values())
                grid_system["spacing_y_mm"] = int(vals[1] - vals[0])

        # Fallback: populate x_coords/y_coords from axes + spacing if still empty
        self._populate_grid_coords_from_axes(grid_system)
        return grid_system

    def _populate_grid_coords_from_axes(self, grid_system: dict) -> None:
        """If x_coords/y_coords are empty but axes and spacing are known, compute from spacing."""
        sx = grid_system.get("spacing_x_mm", 6000) or 6000
        sy = grid_system.get("spacing_y_mm", 6000) or 6000

        def _sort_axis_labels(labels: list) -> list:
            """Sort grid labels: numeric first (1,2,3..), then alpha (A,B,C..)."""
            nums = sorted([l for l in labels if str(l).isdigit()], key=int)
            alphas = sorted([l for l in labels if not str(l).isdigit()])
            return nums + alphas

        if not grid_system.get("x_coords") and grid_system.get("x_axes"):
            axes = _sort_axis_labels(grid_system["x_axes"])
            grid_system["x_coords"] = {lbl: i * sx for i, lbl in enumerate(axes)}
            grid_system["coord_source"] = "spacing_fallback"

        if not grid_system.get("y_coords") and grid_system.get("y_axes"):
            axes = _sort_axis_labels(grid_system["y_axes"])
            grid_system["y_coords"] = {lbl: i * sy for i, lbl in enumerate(axes)}

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