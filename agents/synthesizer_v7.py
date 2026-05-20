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

        # Resolve storey heights then assign Z to all members
        levels_map = self._resolve_level_elevations(model["levels"], page_results)
        if levels_map:
            model["levels"] = self._apply_elevations_to_levels(model["levels"], levels_map)
            model["members"] = self._assign_z_to_all_members(model["members"], levels_map)

        # Upgrade grid coords from scanner-extracted grid_coords if better than PDFExtractor
        model["grid_system"] = self._upgrade_grid_from_pages(model["grid_system"], page_results)

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
        for pr in page_results:
            for le in pr.get("level_elevations", []):
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
                lvl_id = lvl.get("id") or lvl.get("name", "")
                if lvl_id and lvl_id not in seen_ids:
                    levels.append(lvl)
                    seen_ids.add(lvl_id)

        if not levels:
            levels = [
                {"id": "GROUND", "name": "Ground Floor", "height_from_datum_mm": 0, "elevation_mm": 0, "floor_to_floor_mm": 3500},
                {"id": "LEVEL_1", "name": "Level 1", "height_from_datum_mm": 3500, "elevation_mm": 3500, "floor_to_floor_mm": 3200},
                {"id": "LEVEL_2", "name": "Level 2", "height_from_datum_mm": 6700, "elevation_mm": 6700, "floor_to_floor_mm": 3200},
                {"id": "ROOF", "name": "Roof", "height_from_datum_mm": 9900, "elevation_mm": 9900, "floor_to_floor_mm": None},
            ]

        # Sort by elevation
        levels.sort(key=lambda l: l.get("height_from_datum_mm") or l.get("elevation_mm") or 0)
        return levels

    def _resolve_level_elevations(self, levels: List[dict],
                                    page_results: List[dict]) -> dict:
        """Build a map of level_id → elevation_mm, filling nulls intelligently."""
        lmap: dict = {}

        # Collect from levels list
        for lvl in levels:
            lid = lvl.get("id") or lvl.get("name", "")
            elev = lvl.get("height_from_datum_mm") or lvl.get("elevation_mm")
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
            base_lid = col.get("base_level") or col.get("level_id", "")
            top_lid = col.get("top_level", "")
            z_base = _get_elev(base_lid, 0)
            if top_lid:
                z_top = _get_elev(top_lid, z_base + DEFAULT_F2F)
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

        # Footings — snap to column XY, place at negative Z
        col_xy_map: dict = {}
        for col in members.get("columns", []):
            cid = col.get("id") or col.get("mark", "")
            if cid:
                coords = col.get("local_coordinates_mm") or {}
                x = col.get("x") or col.get("x_mm") or coords.get("x") or 0
                y = col.get("y") or col.get("y_mm") or coords.get("y") or 0
                col_xy_map[cid] = (x, y)

        for ftg in members.get("footings", []):
            if not (ftg.get("x") or ftg.get("x_mm")):
                col_ref = ftg.get("column") or ftg.get("col_id") or ftg.get("id", "")
                xy = col_xy_map.get(col_ref)
                if xy:
                    ftg["x"] = xy[0]; ftg["y"] = xy[1]

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