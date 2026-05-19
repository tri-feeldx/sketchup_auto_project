"""
=============================================================================
PHASE 2 — EXTRACTOR V4 (Vision LLM, dual-mode)
=============================================================================
Chạy page-by-page extraction với prompt tùy theo strategy:
  - grid_based: Extract member positions theo grid intersections
  - gridless_architectural: Extract walls/doors/windows theo pixel coordinates
  - hybrid: Kết hợp cả 2

Output: 3D model dict với structural members + architectural elements
=============================================================================
"""

import json
import time
from pathlib import Path

from core.llm_wrapper import call_llm
from core.pdf_utils import pdf_to_images_bytes


def extract_all_v4(pdf_path, manifest, pdf_type, classification):
    """
    Extract structural + architectural elements from all pages.
    
    Args:
        pdf_path: Path to PDF
        manifest: Output from Phase 1 scanner
        pdf_type: PDF type string
        classification: Phase 0 output
        
    Returns:
        model dict with floors, each containing structural + architectural arrays
    """
    pdf_path = Path(pdf_path)
    strategy = classification.get("strategy", "hybrid")
    print(f"\n  [EXTRACT] Extracting with strategy: {strategy}")
    
    t0 = time.time()
    
    # Get page images
    all_images = pdf_to_images_bytes(str(pdf_path), dpi=120)
    
    # Determine which pages to process
    plan_pages = manifest.get("plan_page_indices", [0])
    levels = manifest.get("levels", [])
    grid_x = manifest.get("grid_x", {"labels": [], "spacings_mm": []})
    grid_y = manifest.get("grid_y", {"labels": [], "spacings_mm": []})
    member_db = manifest.get("member_db", {})
    
    has_grid = len(grid_x.get("labels", [])) > 0 and len(grid_y.get("labels", [])) > 0
    
    floors = []
    
    for level_idx, level_info in enumerate(levels):
        page_idx = level_info.get("plan_page_index", level_idx if level_idx < len(all_images) else 0)
        
        if page_idx >= len(all_images):
            continue
        
        level_name = level_info.get("name", f"Level {level_idx}")
        elevation_z = level_info.get("elevation_mm", level_idx * 3500)
        floor_height = level_info.get("floor_height_mm", 3500)
        
        print(f"\n    Extracting {level_name} (page {page_idx + 1}/{len(all_images)})...")
        
        floor_data = _extract_floor(
            page_image=all_images[page_idx],
            page_idx=page_idx,
            level_name=level_name,
            elevation_z=elevation_z,
            floor_height=floor_height,
            grid_x=grid_x,
            grid_y=grid_y,
            member_db=member_db,
            strategy=strategy,
            has_grid=has_grid,
            pdf_type=pdf_type,
        )
        
        floor_data["level_name"] = level_name
        floor_data["elevation_z_mm"] = elevation_z
        floor_data["floor_height_mm"] = floor_height
        floor_data["page_index"] = page_idx
        
        floors.append(floor_data)
        print(f"      --> Structural: {len(floor_data.get('columns',[]))}c {len(floor_data.get('beams',[]))}b {len(floor_data.get('walls',[]))}w")
        print(f"      --> Arch: {len(floor_data.get('arch_doors',[]))}d {len(floor_data.get('arch_windows',[]))}w {len(floor_data.get('arch_stairs',[]))}st")
    
    # Roof extraction (from elevation pages if available)
    roof = _extract_roof(manifest, all_images)
    
    model = {
        "floors": floors,
        "roof": roof,
        "building_outline": _compute_building_outline(floors, manifest),
        "elapsed_s": time.time() - t0,
    }
    
    return model


def _extract_floor(page_image, page_idx, level_name, elevation_z, floor_height,
                   grid_x, grid_y, member_db, strategy, has_grid, pdf_type):
    """Extract all elements from one floor plan page."""
    
    if strategy == "grid_based" and has_grid:
        return _extract_grid_based(page_image, page_idx, level_name, elevation_z, floor_height,
                                   grid_x, grid_y, member_db)
    elif strategy == "gridless_architectural":
        return _extract_gridless(page_image, page_idx, level_name, elevation_z, floor_height)
    else:  # hybrid
        floor = _extract_grid_based(page_image, page_idx, level_name, elevation_z, floor_height,
                                    grid_x, grid_y, member_db)
        arch_floor = _extract_gridless(page_image, page_idx, level_name, elevation_z, floor_height)
        floor["arch_doors"] = arch_floor.get("arch_doors", [])
        floor["arch_windows"] = arch_floor.get("arch_windows", [])
        floor["arch_slabs"] = arch_floor.get("arch_slabs", [])
        floor["arch_stairs"] = arch_floor.get("arch_stairs", [])
        return floor


def _extract_grid_based(page_image, page_idx, level_name, elevation_z, floor_height,
                        grid_x, grid_y, member_db):
    """Extract structural members using grid intersections."""
    
    grid_labels_x = grid_x.get("labels", [])
    grid_labels_y = grid_y.get("labels", [])
    grid_spacings_x = grid_x.get("spacings_mm", [])
    grid_spacings_y = grid_y.get("spacings_mm", [])
    
    has_grid = len(grid_labels_x) > 0 and len(grid_labels_y) > 0
    
    member_db_json = json.dumps(member_db, indent=2) if member_db else "{}"
    
    prompt = f"""You are extracting structural members from a construction plan.

CONTEXT:
- Level: {level_name}, Elevation: z={elevation_z}mm to z={elevation_z + floor_height}mm
- Page index: {page_idx}
- Grid X: labels={grid_labels_x}, spacings={grid_spacings_x} mm
- Grid Y: labels={grid_labels_y}, spacings={grid_spacings_y} mm
- Has grid: {has_grid}
- Member database: {member_db_json}

TASKS:
1. Identify ALL columns on this plan. Each column at a grid intersection.
   - Use grid labels (e.g., "C1 at grid 1/A") if grid exists
   - Include mark (C1, C2...), section from member_db, material
   
2. Identify ALL beams connecting columns.
   - One beam between each adjacent column pair on the same grid line
   - Include mark (B1, B2...), section, span direction
   
3. Identify ANY walls shown (structural walls, shear walls)
   - Note start/end points, thickness
   
4. Identify ANY braces (X-bracing, K-bracing, V-bracing)

OUTPUT FORMAT (JSON only):
{{
  "columns": [
    {{"mark": "C1", "member_type": "column", "grid_x": 0, "grid_y": 0,
      "section_label": "400x400", "material": "Concrete", "confidence": 0.9}}
  ],
  "beams": [
    {{"mark": "B1", "member_type": "beam", "grid_x": 0, "grid_y": 0, "grid_x2": 1, "grid_y2": 0,
      "section_label": "UB305x165x40", "material": "Steel", "confidence": 0.85}}
  ],
  "walls": [
    {{"mark": "W1", "member_type": "wall",
      "grid_x": 0, "grid_y": 0, "grid_x2": 0, "grid_y2": 2,
      "section_label": "t=200mm", "material": "Concrete", "confidence": 0.8}}
  ],
  "braces": [
    {{"mark": "BR1", "member_type": "brace",
      "grid_x": 0, "grid_y": 0, "grid_x2": 1, "grid_y2": 1,
      "section_label": "CHS139.7x5.0", "material": "Steel", "confidence": 0.8}}
  ]
}}

RULES:
- grid_x and grid_y are 0-based indices into the grid labels
- For beams, grid_x/grid_y = start, grid_x2/grid_y2 = end
- Use section_label and material from member_db if available
- Set confidence based on clarity: 0.9=clearly labeled, 0.7=inferred, 0.5=uncertain
- Return ONLY the JSON object"""

    try:
        response = call_llm(prompt, images=[page_image])
        json_str = _extract_json(response)
        if json_str:
            data = json.loads(json_str)
            return _normalize_floor_data(data, grid_x, grid_y, elevation_z, floor_height, member_db)
    except Exception as e:
        print(f"      [WARN] Grid-based extraction error: {e}")
    
    return {"columns": [], "beams": [], "walls": [], "braces": [],
            "arch_doors": [], "arch_windows": [], "arch_slabs": [], "arch_stairs": []}


def _extract_gridless(page_image, page_idx, level_name, elevation_z, floor_height):
    """Extract architectural elements (no grid assumed)."""
    
    prompt = f"""You are an architectural analyst extracting building elements from a floor plan.

CONTEXT:
- Level: {level_name}, Elevation: z={elevation_z}mm to z={elevation_z + floor_height}mm

TASKS:
1. DOORS: Identify all door symbols (arcs/swings in walls).
   Extract: position (x,y mm relative), door type (single_swing/double/sliding),
   width, height, swing direction.
   
2. WINDOWS: Identify all window symbols (thin rectangles in walls).
   Extract: position, type (sliding/casement/fixed), width, height, sill height.
   
3. STAIRS: Identify stair symbols (parallel step lines, arrow).
   Extract: position, type (straight/L-shaped/U-shaped/spiral),
   width, total rise, number of risers, direction.
   
4. SLABS: Identify floor outline (the bounded area).
   Extract: boundary as array of 4 corner points in mm.

OUTPUT FORMAT (JSON only):
{{
  "arch_doors": [
    {{"mark": "D1", "type": "single_swing", "width_mm": 900, "height_mm": 2100,
      "position": {{"x": 3000, "y": 0}}, "direction": "inward", "confidence": 0.85}}
  ],
  "arch_windows": [
    {{"mark": "WIN1", "type": "sliding", "width_mm": 2000, "height_mm": 1500,
      "sill_height_mm": 900, "position": {{"x": 5000, "y": 0}}, "confidence": 0.85}}
  ],
  "arch_stairs": [
    {{"mark": "ST1", "type": "straight", "width_mm": 1000,
      "rise_mm": {floor_height}, "run_mm": 4000, "num_risers": 20,
      "position": {{"x": 1000, "y": 3000}}, "confidence": 0.8}}
  ],
  "arch_slabs": [
    {{"level_name": "{level_name}", "thickness_mm": 200, "z_mm": {elevation_z},
      "boundary_points": [[0,0], [12000,0], [12000,10000], [0,10000]]}}
  ]
}}

Return ONLY the JSON object."""

    try:
        response = call_llm(prompt, images=[page_image])
        json_str = _extract_json(response)
        if json_str:
            floor_data = json.loads(json_str)
            floor_data.setdefault("columns", [])
            floor_data.setdefault("beams", [])
            floor_data.setdefault("walls", [])
            floor_data.setdefault("braces", [])
            floor_data.setdefault("arch_doors", [])
            floor_data.setdefault("arch_windows", [])
            floor_data.setdefault("arch_slabs", [])
            floor_data.setdefault("arch_stairs", [])
            return floor_data
    except Exception as e:
        print(f"      [WARN] Gridless extraction error: {e}")
    
    return {"columns": [], "beams": [], "walls": [], "braces": [],
            "arch_doors": [], "arch_windows": [], "arch_slabs": [], "arch_stairs": []}


def _normalize_floor_data(data, grid_x, grid_y, elevation_z, floor_height, member_db):
    """Compute real-world coordinates from grid indices."""
    spacings_x = grid_x.get("spacings_mm", [])
    spacings_y = grid_y.get("spacings_mm", [])
    num_x = len(grid_x.get("labels", []))
    num_y = len(grid_y.get("labels", []))
    
    def _grid_to_mm(gx, gy):
        """Convert grid indices to mm coordinates."""
        x = sum(spacings_x[:gx]) if gx < len(spacings_x) + 1 else gx * 3000
        y = sum(spacings_y[:gy]) if gy < len(spacings_y) + 1 else gy * 3000
        return x, y
    
    processed = {
        "columns": [],
        "beams": [],
        "walls": [],
        "braces": [],
        "arch_doors": data.get("arch_doors", []),
        "arch_windows": data.get("arch_windows", []),
        "arch_slabs": data.get("arch_slabs", []),
        "arch_stairs": data.get("arch_stairs", []),
    }
    
    # Process columns
    for col in data.get("columns", []):
        gx = col.get("grid_x", 0)
        gy = col.get("grid_y", 0)
        x_mm, y_mm = _grid_to_mm(gx, gy)
        
        mark = col.get("mark", f"C{len(processed['columns'])+1}")
        member_info = member_db.get(mark, {})
        
        processed["columns"].append({
            "mark": mark,
            "member_type": "column",
            "grid_x": gx,
            "grid_y": gy,
            "x_mm": x_mm,
            "y_mm": y_mm,
            "z_start_mm": elevation_z,
            "z_end_mm": elevation_z + floor_height,
            "section_label": col.get("section_label") or member_info.get("section", "400x400"),
            "material": col.get("material") or member_info.get("material", "Concrete"),
            "confidence": col.get("confidence", 0.7),
        })
    
    # Process beams
    for beam in data.get("beams", []):
        gx1, gy1 = beam.get("grid_x", 0), beam.get("grid_y", 0)
        gx2, gy2 = beam.get("grid_x2", gx1 + 1), beam.get("grid_y2", gy1)
        x1, y1 = _grid_to_mm(gx1, gy1)
        x2, y2 = _grid_to_mm(gx2, gy2)
        length = ((x2 - x1)**2 + (y2 - y1)**2)**0.5
        
        mark = beam.get("mark", f"B{len(processed['beams'])+1}")
        member_info = member_db.get(mark, {})
        
        processed["beams"].append({
            "mark": mark,
            "member_type": "beam",
            "grid_x": gx1, "grid_y": gy1,
            "grid_x2": gx2, "grid_y2": gy2,
            "x_mm": x1, "y_mm": y1,
            "x2_mm": x2, "y2_mm": y2,
            "z_start_mm": elevation_z + floor_height - 400,
            "z_end_mm": elevation_z + floor_height,
            "section_label": beam.get("section_label") or member_info.get("section", "UB305x165x40"),
            "material": beam.get("material") or member_info.get("material", "Steel"),
            "length_mm": length,
            "confidence": beam.get("confidence", 0.7),
        })
    
    # Process walls
    for wall in data.get("walls", []):
        gx1, gy1 = wall.get("grid_x", 0), wall.get("grid_y", 0)
        gx2, gy2 = wall.get("grid_x2", gx1), wall.get("grid_y2", gy1 + 1)
        x1, y1 = _grid_to_mm(gx1, gy1)
        x2, y2 = _grid_to_mm(gx2, gy2)
        length = ((x2 - x1)**2 + (y2 - y1)**2)**0.5
        
        processed["walls"].append({
            "mark": wall.get("mark", f"W{len(processed['walls'])+1}"),
            "member_type": "wall",
            "x_mm": x1, "y_mm": y1,
            "x2_mm": x2, "y2_mm": y2,
            "z_start_mm": elevation_z,
            "z_end_mm": elevation_z + floor_height,
            "section_label": wall.get("section_label", "t=200mm"),
            "material": wall.get("material", "Concrete"),
            "dimensions": {"thickness": wall.get("dimensions", {}).get("thickness", 200)},
            "length_mm": length,
            "confidence": wall.get("confidence", 0.7),
        })
    
    # Process braces
    for brace in data.get("braces", []):
        gx1, gy1 = brace.get("grid_x", 0), brace.get("grid_y", 0)
        gx2, gy2 = brace.get("grid_x2", gx1 + 1), brace.get("grid_y2", gy1 + 1)
        x1, y1 = _grid_to_mm(gx1, gy1)
        x2, y2 = _grid_to_mm(gx2, gy2)
        
        processed["braces"].append({
            "mark": brace.get("mark", f"BR{len(processed['braces'])+1}"),
            "member_type": "brace",
            "x_mm": x1, "y_mm": y1, "x2_mm": x2, "y2_mm": y2,
            "z_start_mm": elevation_z,
            "z_end_mm": elevation_z + floor_height,
            "section_label": brace.get("section_label", "CHS139.7x5.0"),
            "material": brace.get("material", "Steel"),
            "confidence": brace.get("confidence", 0.7),
        })
    
    return processed


def _extract_roof(manifest, all_images):
    """Extract roof info from elevation pages."""
    roof = {
        "type": "flat",
        "eaves_z_mm": manifest.get("total_height_mm", 3500),
        "ridge_z_mm": manifest.get("total_height_mm", 3500),
        "slope_degrees": 0,
    }
    
    # Try elevation pages for roof info
    elev_pages = manifest.get("elevation_page_indices", [])
    if elev_pages and elev_pages[0] < len(all_images):
        try:
            prompt = """Analyze this elevation drawing and extract ROOF information.
Return ONLY JSON: {"type": "flat|gable|hip|shed", "eaves_z_mm": number, "ridge_z_mm": number, "slope_degrees": number}"""
            response = call_llm(prompt, images=[all_images[elev_pages[0]]])
            json_str = _extract_json(response)
            if json_str:
                roof = json.loads(json_str)
        except Exception:
            pass
    
    return roof


def _compute_building_outline(floors, manifest):
    """Compute overall building dimensions."""
    outline = manifest.get("building_outline", {})
    
    if not outline:
        max_x = max_y = 0
        for floor in floors:
            for col in floor.get("columns", []):
                max_x = max(max_x, col.get("x_mm", 0) + 3000)
                max_y = max(max_y, col.get("y_mm", 0) + 3000)
            for wall in floor.get("walls", []):
                max_x = max(max_x, wall.get("x_mm", 0), wall.get("x2_mm", 0))
                max_y = max(max_y, wall.get("y_mm", 0), wall.get("y2_mm", 0))
        
        outline = {
            "overall_width_mm": max_x if max_x > 0 else 12000,
            "overall_depth_mm": max_y if max_y > 0 else 10000,
            "overall_height_mm": manifest.get("total_height_mm", 7000),
        }
    
    return outline


def _extract_json(text):
    """Extract JSON from LLM response."""
    text = text.strip()
    if text.startswith("```"):
        lines = text.split("\n")
        if lines and lines[0].startswith("```"):
            lines = lines[1:]
        if lines and lines[-1].strip().startswith("```"):
            lines = lines[:-1]
        text = "\n".join(lines)
    
    try:
        json.loads(text)
        return text
    except (json.JSONDecodeError, ValueError):
        import re
        match = re.search(r'\{.*\}', text, re.DOTALL)
        return match.group() if match else None