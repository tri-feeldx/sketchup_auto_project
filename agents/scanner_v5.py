"""
=============================================================================
PHASE 1 — SCANNER V5 (Vision-First Multi-Pass)
=============================================================================
Phân tích PDF bằng Gemini Vision => Building Model.
Khác biệt so với V4:
  - Dùng VisionRenderer 300 DPI (không phải pdf_to_images_bytes 120 DPI)
  - Phan tích page-by-page (không gửi tất cả anh 1 lần => tránh timeout)
  - Page Classification => Page Analysis => Cross-Page Synthesis
  - Hỗ trợ PDF đa dạng: structural, architectural, mixed, multi-story
=============================================================================
"""

import json
import time
import re
from pathlib import Path
from typing import Optional

from core.llm_wrapper import call_llm
from core.vision_renderer import VisionRenderer


class ScannerV5:
    """
    Vision-First Multi-Pass Scanner.
    
    Pipeline:
      1. Render all pages at 300 DPI via VisionRenderer
      2. PASS 1: Classify each page (plan/elevation/section/schedule/title)
      3. PASS 2: Analyze each page independently => extract elements
      4. PASS 3: Cross-page synthesis => merge into unified building model
    """
    
    def __init__(self, pdf_path: str | Path, dpi: int = 200):
        self.pdf_path = Path(pdf_path)
        self.dpi = dpi
        self.renderer: Optional[VisionRenderer] = None
        self._open()
    
    def _open(self):
        """Open PDF and renderer."""
        self.renderer = VisionRenderer(str(self.pdf_path), dpi=self.dpi)
    
    def close(self):
        """Close renderer."""
        if self.renderer:
            self.renderer.close()
            self.renderer = None
    
    def run(self) -> dict:
        """
        Run full V5 scanning pipeline.
        
        Returns:
            Building model dict with floors, elements, grid, levels.
        """
        t0 = time.time()
        num_pages = self.renderer.num_pages
        print(f"\n  [SCAN V5] {num_pages} pages @ {self.dpi} DPI")
        
        if num_pages == 0:
            return self._empty_model()
        
        # ============================================================
        # PASS 1: PAGE CLASSIFICATION (1 LLM call, all pages thumbnail)
        # ============================================================
        print("  [PASS 1] Classifying pages...")
        page_classes = self._classify_pages(num_pages)
        
        # ============================================================
        # PASS 2: PER-PAGE ANALYSIS (1 LLM call per plan/elevation page)
        # ============================================================
        print("  [PASS 2] Analyzing pages...")
        page_results = self._analyze_pages(page_classes, num_pages)
        
        # ============================================================
        # PASS 3: CROSS-PAGE SYNTHESIS
        # ============================================================
        print("  [PASS 3] Synthesizing building model...")
        building_model = self._synthesize(page_classes, page_results, num_pages)
        
        elapsed = time.time() - t0
        building_model["elapsed_s"] = elapsed
        building_model["num_pages"] = num_pages
        building_model["page_classifications"] = page_classes
        
        n_floors = len(building_model.get("floors", []))
        n_cols = sum(len(f.get("columns", [])) for f in building_model.get("floors", []))
        n_beams = sum(len(f.get("beams", [])) for f in building_model.get("floors", []))
        n_walls = sum(len(f.get("walls", [])) for f in building_model.get("floors", []))
        
        print(f"    [OK] V5 Complete: {n_floors} floors, {n_cols} cols, "
              f"{n_beams} beams, {n_walls} walls, {elapsed:.1f}s")
        
        return building_model
    
    # ============================================================
    # PASS 1: CLASSIFY
    # ============================================================
    def _classify_pages(self, num_pages: int) -> dict:
        """Classify each page using a single LLM call with thumbnails."""
        if num_pages > 8:
            return self._classify_pages_batched(num_pages)
        
        thumbnails = []
        for i in range(num_pages):
            thumb_bytes = self.renderer.render_page_as_bytes(i, format="JPEG")
            thumbnails.append(thumb_bytes)
        
        meta = [self.renderer.get_page_metadata(i) for i in range(num_pages)]
        meta_text = "\n".join(
            f"Page {i}: {m['width_mm']:.0f}x{m['height_mm']:.0f}mm {m['orientation']}, "
            f"{m['num_text_blocks']} text blocks"
            for i, m in enumerate(meta)
        )
        
        prompt = f"""You are an architectural/structural drawing classifier.

Below are thumbnail images of {num_pages} pages from a construction PDF, plus metadata.

**Page Metadata:**
{meta_text}

**Task:** Classify each page into one of these categories:
- "plan" - floor plan, layout plan, framing plan
- "elevation" - building elevation, facade view
- "section" - cross-section, section view
- "schedule" - table of members, doors, windows, finishes
- "detail" - construction detail, connection detail
- "title" - title page, cover sheet
- "general_note" - general notes, specifications text
- "other" - none of the above

Also identify:
- Which pages are plan pages? => list their indices
- Which pages are elevation pages? => list their indices
- Which pages contain schedules/tables? => list their indices
- How many floors/levels are shown across all plans?

Return JSON:
{{
  "classifications": {{"0": "plan", "1": "elevation", "2": "schedule", ...}},
  "plan_page_indices": [0, 1],
  "elevation_page_indices": [2, 3],
  "schedule_page_indices": [4],
  "num_floors_visible": 2,
  "has_grid": true,
  "has_dimensions": true,
  "primary_material": "steel" or "concrete" or "mixed" or "unknown",
  "building_type_guess": "industrial" or "commercial" or "residential" or "warehouse" or "other"
}}

Return ONLY valid JSON, no markdown, no explanation."""

        try:
            response = call_llm(prompt, images=thumbnails)
            data = self._parse_json(response)
            if data:
                return data
        except Exception as e:
            print(f"    [WARN] Classification failed: {e}")
        
        return {
            "classifications": {str(i): "plan" for i in range(num_pages)},
            "plan_page_indices": list(range(num_pages)),
            "elevation_page_indices": [],
            "schedule_page_indices": [],
            "num_floors_visible": 1,
            "has_grid": False,
            "has_dimensions": False,
            "primary_material": "unknown",
            "building_type_guess": "other",
        }
    
    def _classify_pages_batched(self, num_pages: int) -> dict:
        """Classify pages in batches of 6 for large PDFs."""
        batch_size = 6
        all_classifications = {}
        all_plans = []
        all_elev = []
        all_sched = []
        
        for batch_start in range(0, num_pages, batch_size):
            batch_end = min(batch_start + batch_size, num_pages)
            batch_indices = list(range(batch_start, batch_end))
            
            thumbnails = []
            for i in batch_indices:
                thumb_bytes = self.renderer.render_page_as_bytes(i, format="JPEG")
                thumbnails.append(thumb_bytes)
            
            meta = [self.renderer.get_page_metadata(i) for i in batch_indices]
            meta_text = "\n".join(
                f"Page {i}: {m['width_mm']:.0f}x{m['height_mm']:.0f}mm {m['orientation']}"
                for i, m in zip(batch_indices, meta)
            )
            
            prompt = f"""Classify these {len(batch_indices)} pages (indices {batch_indices[0]} to {batch_indices[-1]}) from a construction PDF.

**Page Metadata:**
{meta_text}

**Categories:** "plan", "elevation", "section", "schedule", "detail", "title", "general_note", "other"

Return JSON:
{{"classifications": {{"{batch_indices[0]}": "plan", ...}}}}

Return ONLY valid JSON, no markdown."""

            try:
                response = call_llm(prompt, images=thumbnails)
                data = self._parse_json(response)
                if data and "classifications" in data:
                    all_classifications.update(data["classifications"])
            except Exception as e:
                print(f"    [WARN] Batch {batch_start} failed: {e}")
                for i in batch_indices:
                    all_classifications[str(i)] = "unknown"
        
        for k, v in all_classifications.items():
            idx = int(k)
            if v == "plan":
                all_plans.append(idx)
            elif v == "elevation":
                all_elev.append(idx)
            elif v == "schedule":
                all_sched.append(idx)
        
        return {
            "classifications": all_classifications,
            "plan_page_indices": sorted(all_plans),
            "elevation_page_indices": sorted(all_elev),
            "schedule_page_indices": sorted(all_sched),
            "num_floors_visible": max(1, len(all_plans)),
            "has_grid": False,
            "has_dimensions": False,
            "primary_material": "unknown",
            "building_type_guess": "other",
        }
    
    # ============================================================
    # PASS 2: ANALYZE EACH PAGE
    # ============================================================
    def _analyze_pages(self, page_classes: dict, num_pages: int) -> dict:
        """Analyze plan and elevation pages with high-res vision."""
        plan_indices = page_classes.get("plan_page_indices", [])
        elev_indices = page_classes.get("elevation_page_indices", [])
        
        results = {}
        
        for idx in plan_indices:
            print(f"    Analyzing plan page {idx}...")
            result = self._analyze_plan_page(idx, num_pages)
            if result:
                results[str(idx)] = result
        
        for idx in elev_indices[:3]:
            print(f"    Analyzing elevation page {idx}...")
            result = self._analyze_elevation_page(idx)
            if result:
                results[str(idx)] = result
        
        return results
    
    def _analyze_plan_page(self, page_idx: int, total_pages: int) -> Optional[dict]:
        """Analyze a single plan page with high-res image."""
        try:
            img_bytes = self.renderer.render_page_as_bytes(page_idx, format="PNG")
            meta = self.renderer.get_page_metadata(page_idx)
            text_blocks = self.renderer.get_all_text(page_idx)
            text_context = "\n".join(b["text"] for b in text_blocks[:20] if b["text"])
        except Exception as e:
            print(f"      [ERR] Render failed: {e}")
            return None
        
        text_lower = text_context.lower()
        has_steel = any(w in text_lower for w in ["ub", "uc", "rhs", "shs", "steel", "column", "beam", "brace"])
        has_concrete = any(w in text_lower for w in ["rc", "reinforced", "concrete", "rebar"])
        has_arch = any(w in text_lower for w in ["door", "window", "room", "wall", "bedroom", "kitchen", "living"])
        
        if has_arch and not (has_steel or has_concrete):
            analysis_type = "architectural"
        elif (has_steel or has_concrete) and not has_arch:
            analysis_type = "structural"
        else:
            analysis_type = "mixed"
        
        prompt = f"""You are analyzing a {analysis_type} plan drawing (page {page_idx + 1} of {total_pages}).

**Page Info:**
- Size: {meta['width_mm']:.0f} x {meta['height_mm']:.0f} mm
- Orientation: {meta['orientation']}

**Visible Text on Page:**
{text_context[:2000]}

**Task:** Extract ALL structural and architectural elements visible on this plan.

For each element, estimate its position in millimeters from the bottom-left corner of the drawing.
Coordinate system:
- X: horizontal (left to right)
- Y: vertical (bottom to top)
- Origin (0,0) at bottom-left of the drawing

**Structural Elements to Extract:**
- Columns: position (x,y), approximate size (width, depth in mm), mark/label if visible
- Beams: between columns, span direction, approximate section

**Architectural Elements to Extract (if visible):**
- Walls: as line segments with start (x1,y1) and end (x2,y2) points, thickness in mm
- Doors: position on wall, width, type
- Windows: position on wall, width, sill height
- Stairs: location polygon, direction
- Rooms: name, area polygon

**IMPORTANT:**
- If no scale bar is visible, estimate based on typical dimensions (e.g., column spacing 4000-8000mm, door width 900mm)
- Set confidence based on how clearly elements are visible
- If you're unsure about exact positions, provide your best estimate and set lower confidence

Return JSON:
{{
  "page_index": {page_idx},
  "analysis_type": "{analysis_type}",
  "estimated_scale": "1:100",
  "columns": [
    {{"id": "C1", "x": 1000, "y": 2000, "width_mm": 200, "depth_mm": 200, "mark": "C1", "confidence": 0.8}}
  ],
  "beams": [
    {{"id": "B1", "from_col": "C1", "to_col": "C2", "section_guess": "UB305", "confidence": 0.6}}
  ],
  "walls": [
    {{"id": "W1", "x1": 0, "y1": 0, "x2": 6000, "y2": 0, "thickness_mm": 200, "type": "external", "confidence": 0.7}}
  ],
  "doors": [
    {{"id": "D1", "wall_id": "W1", "position_on_wall_mm": 2000, "width_mm": 900, "type": "single_swing", "confidence": 0.6}}
  ],
  "windows": [
    {{"id": "WIN1", "wall_id": "W2", "position_on_wall_mm": 1500, "width_mm": 2000, "sill_height_mm": 900, "confidence": 0.6}}
  ],
  "stairs": [
    {{"id": "ST1", "polygon": [[3000,0],[3000,3000],[5000,3000],[5000,0]], "direction": "up", "confidence": 0.5}}
  ],
  "rooms": [
    {{"id": "R1", "name": "Living Room", "polygon": [[0,0],[6000,0],[6000,5000],[0,5000]], "area_m2": 30.0, "confidence": 0.5}}
  ],
  "dimensions_visible": [
    {{"type": "overall_width", "value_mm": 12000}},
    {{"type": "overall_depth", "value_mm": 10000}}
  ],
  "grid_visible": false,
  "grid_labels": [],
  "notes": "any observations about this page"
}}

Return ONLY valid JSON, no markdown, no explanation."""

        try:
            response = call_llm(prompt, images=[img_bytes])
            data = self._parse_json(response)
            if data:
                data["page_index"] = page_idx
                return data
        except Exception as e:
            print(f"      [WARN] Analysis failed: {e}")
        
        return {"page_index": page_idx, "error": "LLM analysis failed", "columns": [], "beams": [], "walls": []}
    
    def _analyze_elevation_page(self, page_idx: int) -> Optional[dict]:
        """Analyze an elevation page for height and level info."""
        try:
            img_bytes = self.renderer.render_page_as_bytes(page_idx, format="PNG")
            meta = self.renderer.get_page_metadata(page_idx)
        except Exception:
            return None
        
        prompt = f"""You are analyzing a building elevation drawing.

**Page Info:**
- Size: {meta['width_mm']:.0f} x {meta['height_mm']:.0f} mm

**Task:** Extract vertical level information.

Return JSON:
{{
  "page_index": {page_idx},
  "levels": [
    {{"name": "Ground Floor", "elevation_mm": 0, "height_above_ground_mm": 3500}},
    {{"name": "Level 1", "elevation_mm": 3500, "height_above_ground_mm": 3500}}
  ],
  "total_building_height_mm": 7000,
  "roof_type": "flat" or "gable" or "hip" or "other",
  "notes": "observations"
}}

Return ONLY valid JSON, no markdown, no explanation."""

        try:
            response = call_llm(prompt, images=[img_bytes])
            data = self._parse_json(response)
            if data:
                return data
        except Exception as e:
            print(f"      [WARN] Elevation analysis failed: {e}")
        
        return {"page_index": page_idx, "levels": [], "error": "failed"}
    
    # ============================================================
    # PASS 3: SYNTHESIS
    # ============================================================
    def _synthesize(self, page_classes: dict, page_results: dict, num_pages: int) -> dict:
        """Synthesize all page results into a unified building model."""
        
        all_columns = []
        all_beams = []
        all_walls = []
        all_doors = []
        all_windows = []
        all_stairs = []
        all_rooms = []
        all_levels = []
        
        plan_indices = page_classes.get("plan_page_indices", [])
        
        for idx in plan_indices:
            key = str(idx)
            if key not in page_results:
                continue
            pr = page_results[key]
            
            for col in pr.get("columns", []):
                col["source_page"] = idx
                all_columns.append(col)
            for beam in pr.get("beams", []):
                beam["source_page"] = idx
                all_beams.append(beam)
            for wall in pr.get("walls", []):
                wall["source_page"] = idx
                all_walls.append(wall)
            for door in pr.get("doors", []):
                door["source_page"] = idx
                all_doors.append(door)
            for win in pr.get("windows", []):
                win["source_page"] = idx
                all_windows.append(win)
            for stair in pr.get("stairs", []):
                stair["source_page"] = idx
                all_stairs.append(stair)
            for room in pr.get("rooms", []):
                room["source_page"] = idx
                all_rooms.append(room)
        
        # ── FIX #1: LEVEL DEDUP ──────────────────────────────────
        # Merge duplicate levels by name + elevation proximity
        elev_indices = page_classes.get("elevation_page_indices", [])
        for idx in elev_indices:
            key = str(idx)
            if key in page_results:
                for lvl in page_results[key].get("levels", []):
                    all_levels.append(lvl)
        
        # Dedup: group by normalized name, then by elevation proximity (±500mm)
        deduped_levels = []
        seen_names = {}
        for lvl in all_levels:
            name = lvl.get("name", "").strip().lower()
            elev = lvl.get("elevation_mm", 0)
            # Normalize common name variants
            norm_name = name.replace("level", "").replace("floor", "").replace(" ", "").replace("_", "")
            if norm_name in ("ground", "g", "gf", "0", "00"):
                norm_name = "ground"
            
            key_name = norm_name
            if key_name in seen_names:
                # Check if elevation is close to existing (within 500mm)
                existing = seen_names[key_name]
                if abs(existing["elevation_mm"] - elev) < 500:
                    # Merge: take the one with more info
                    if len(lvl.get("name", "")) > len(existing.get("name", "")):
                        existing["name"] = lvl.get("name", existing["name"])
                    if lvl.get("floor_height_mm", 0) > existing.get("floor_height_mm", 0):
                        existing["floor_height_mm"] = lvl.get("floor_height_mm", existing["floor_height_mm"])
                    continue
                else:
                    # Same name but different elevation → make unique key
                    key_name = f"{norm_name}_{elev}"
            
            if key_name not in seen_names:
                seen_names[key_name] = dict(lvl)
                deduped_levels.append(lvl)
        
        all_levels = deduped_levels
        
        if not all_levels:
            num_floors = page_classes.get("num_floors_visible", len(plan_indices))
            if num_floors < 1:
                num_floors = 1
            for i in range(num_floors):
                all_levels.append({
                    "name": f"Level {i}" if i > 0 else "Ground Floor",
                    "elevation_mm": i * 3500,
                    "floor_height_mm": 3500,
                })
        
        # Sort levels by elevation ascending
        all_levels.sort(key=lambda l: l.get("elevation_mm", 0))
        
        # ── FIX #2: FLOOR ASSIGNMENT — columns belong to ALL floors ──
        num_floors = max(1, len(all_levels))
        total_height = sum(lvl.get("floor_height_mm", 3500) for lvl in all_levels)
        base_elevations = []
        cumulative = 0
        for lvl in all_levels:
            base_elevations.append(cumulative)
            cumulative += lvl.get("floor_height_mm", 3500)
        
        floors = []
        for floor_idx in range(num_floors):
            lvl = all_levels[floor_idx]
            elev = base_elevations[floor_idx]
            fh = lvl.get("floor_height_mm", 3500)
            
            # ── FIX #2: Assign columns that span THIS floor ──
            # A column spans this floor if its z-range overlaps with [elev, elev+fh]
            floor_cols = []
            for col in all_columns:
                col_bottom = col.get("z_bottom_mm", 0)
                col_top = col.get("z_top_mm", total_height)
                # Overlap: col spans this floor level
                if col_bottom < (elev + fh) and col_top > elev:
                    col_copy = dict(col)
                    col_copy["floor_elevation"] = elev
                    floor_cols.append(col_copy)
            
            # If no columns have z info, fall back to ALL columns
            if not floor_cols and all_columns:
                floor_cols = [dict(c) for c in all_columns]
            
            # Beams, walls per floor (still page-based but with all pages as fallback)
            plan_per_floor = max(1, len(plan_indices) // num_floors)
            start_page = floor_idx * plan_per_floor
            end_page = min(start_page + plan_per_floor, len(plan_indices))
            floor_plan_pages = plan_indices[start_page:end_page]
            if not floor_plan_pages and plan_indices:
                floor_plan_pages = [plan_indices[min(floor_idx, len(plan_indices)-1)]]
            
            floor_beams = [b for b in all_beams if b.get("source_page") in floor_plan_pages]
            floor_walls = [w for w in all_walls if w.get("source_page") in floor_plan_pages]
            floor_doors = [d for d in all_doors if d.get("source_page") in floor_plan_pages]
            floor_wins = [w for w in all_windows if w.get("source_page") in floor_plan_pages]
            floor_stairs = [s for s in all_stairs if s.get("source_page") in floor_plan_pages]
            
            floors.append({
                "name": lvl.get("name", f"Level {floor_idx}"),
                "elevation_mm": elev,
                "floor_height_mm": fh,
                "plan_page_indices": floor_plan_pages,
                "columns": floor_cols,
                "beams": floor_beams,
                "walls": floor_walls,
                "arch_doors": floor_doors,
                "arch_windows": floor_wins,
                "arch_stairs": floor_stairs,
            })
        
        # ── FIX #3: SCALE & GRID DETECTION ───────────────────────
        scale_mm_per_px = 3.0
        scale_confidence = 0.3
        
        for key, pr in page_results.items():
            for dim in pr.get("dimensions_visible", []):
                if dim.get("type") == "overall_width" and dim.get("value_mm"):
                    meta = self.renderer.get_page_metadata(int(key))
                    if meta:
                        approx_scale = dim["value_mm"] / meta["rendered_width_px"]
                        if 2.0 < approx_scale < 10.0:
                            scale_mm_per_px = approx_scale
                            scale_confidence = 0.6
        
        grid_x = {"labels": [], "spacings_mm": []}
        grid_y = {"labels": [], "spacings_mm": []}
        
        # ── FIX #3: Infer grid spacing from column positions ──
        for key, pr in page_results.items():
            if pr.get("grid_visible") and pr.get("grid_labels"):
                labels = pr["grid_labels"]
                x_labels = [l for l in labels if l.replace("-", "").replace(".", "").isdigit()]
                y_labels = [l for l in labels if l.isalpha()]
                if x_labels:
                    grid_x["labels"] = x_labels
                    grid_x["spacings_mm"] = [6000] * len(x_labels)
                    # Try to detect real spacing from column x-positions
                    col_xs = sorted(set(c.get("x_mm", 0) for c in all_columns if c.get("x_mm")))
                    if len(col_xs) >= 2:
                        diffs = [col_xs[i+1] - col_xs[i] for i in range(len(col_xs)-1)]
                        if diffs:
                            from statistics import median
                            real_spacing = median(diffs)
                            if 2000 < real_spacing < 12000:
                                grid_x["spacings_mm"] = [round(real_spacing)] * len(x_labels)
                if y_labels:
                    grid_y["labels"] = y_labels
                    grid_y["spacings_mm"] = [6000] * len(y_labels)
                    col_ys = sorted(set(c.get("y_mm", 0) for c in all_columns if c.get("y_mm")))
                    if len(col_ys) >= 2:
                        diffs = [col_ys[i+1] - col_ys[i] for i in range(len(col_ys)-1)]
                        if diffs:
                            from statistics import median
                            real_spacing = median(diffs)
                            if 2000 < real_spacing < 12000:
                                grid_y["spacings_mm"] = [round(real_spacing)] * len(y_labels)
                break
        
        member_db = {}
        for col in all_columns:
            mark = col.get("mark", "")
            if mark and mark not in member_db:
                member_db[mark] = {
                    "type": "column",
                    "section": col.get("section_guess", "unknown"),
                    "width_mm": col.get("width_mm", 200),
                    "depth_mm": col.get("depth_mm", 200),
                }
        for beam in all_beams:
            mark = beam.get("mark", "")
            if mark and mark not in member_db:
                member_db[mark] = {
                    "type": "beam",
                    "section": beam.get("section_guess", "unknown"),
                }
        
        building_outline = {}
        if all_walls:
            xs = []
            ys = []
            for w in all_walls:
                for pt in [(w.get("x1", 0), w.get("y1", 0)), (w.get("x2", 0), w.get("y2", 0))]:
                    if pt[0] and pt[1]:
                        xs.append(pt[0])
                        ys.append(pt[1])
            if xs and ys:
                building_outline = {
                    "min_x": min(xs), "max_x": max(xs),
                    "min_y": min(ys), "max_y": max(ys),
                    "width_mm": max(xs) - min(xs),
                    "depth_mm": max(ys) - min(ys),
                }
        
        return {
            "building_name": page_classes.get("building_name", "Building"),
            "building_type": page_classes.get("building_type_guess", "other"),
            "num_floors": len(floors),
            "total_height_mm": sum(f["floor_height_mm"] for f in floors),
            "grid_x": grid_x,
            "grid_y": grid_y,
            "scale_x_mm_per_px": scale_mm_per_px,
            "scale_confidence": scale_confidence,
            "levels": all_levels,
            "floors": floors,
            "plan_page_indices": page_classes.get("plan_page_indices", []),
            "elevation_page_indices": page_classes.get("elevation_page_indices", []),
            "schedule_page_indices": page_classes.get("schedule_page_indices", []),
            "member_db": member_db,
            "wall_types": [],
            "door_types": [],
            "window_types": [],
            "building_outline": building_outline,
            "version": "v5-vision-multi-pass",
        }
    
    # ============================================================
    # HELPERS
    # ============================================================
    def _parse_json(self, text: str) -> Optional[dict]:
        """Extract JSON from LLM response."""
        if not text:
            return None
        text = text.strip()
        
        if text.startswith("```"):
            lines = text.split("\n")
            if lines[0].startswith("```"):
                lines = lines[1:]
            if lines and lines[-1].strip().startswith("```"):
                lines = lines[:-1]
            text = "\n".join(lines)
        
        try:
            return json.loads(text)
        except (json.JSONDecodeError, ValueError):
            match = re.search(r'\{.*\}', text, re.DOTALL)
            if match:
                try:
                    return json.loads(match.group())
                except (json.JSONDecodeError, ValueError):
                    pass
            return None
    
    def _empty_model(self) -> dict:
        """Return empty/fallback model."""
        return {
            "building_name": "Unknown",
            "building_type": "unknown",
            "num_floors": 1,
            "total_height_mm": 3500,
            "grid_x": {"labels": [], "spacings_mm": []},
            "grid_y": {"labels": [], "spacings_mm": []},
            "scale_x_mm_per_px": 3.0,
            "scale_confidence": 0.0,
            "levels": [{"name": "Level 1", "elevation_mm": 0, "floor_height_mm": 3500}],
            "floors": [{
                "name": "Level 1",
                "elevation_mm": 0,
                "floor_height_mm": 3500,
                "plan_page_indices": [],
                "columns": [],
                "beams": [],
                "walls": [],
                "arch_doors": [],
                "arch_windows": [],
                "arch_stairs": [],
            }],
            "plan_page_indices": [],
            "elevation_page_indices": [],
            "schedule_page_indices": [],
            "member_db": {},
            "wall_types": [],
            "door_types": [],
            "window_types": [],
            "building_outline": {},
            "page_classifications": {},
            "num_pages": 0,
            "version": "v5-fallback",
        }