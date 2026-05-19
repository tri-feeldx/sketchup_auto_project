"""
=============================================================================
PHASE 1 — SCANNER V4 (Vision LLM)
=============================================================================
Phân tích toàn bộ PDF → BuildingManifest.
Prompt thích ứng theo loại PDF (structural/architectural/mixed).

Output:
  - Grid system (nếu có)
  - Floor levels
  - Member types & sections
  - Page classification (plan/elevation/schedule)
  - Building outline & overall dimensions
=============================================================================
"""

import json
import time
from pathlib import Path

from core.llm_wrapper import call_llm
from core.pdf_utils import pdf_to_images_bytes


def scan_pdf_v4(pdf_path, pdf_type, classification):
    """
    Scan toàn bộ PDF và trả về manifest dict.
    
    Args:
        pdf_path: Path to PDF
        pdf_type: "structural_only" | "architectural_only" | "mixed"
        classification: Output from Phase 0
        
    Returns:
        manifest dict với building info, grid, levels, pages
    """
    pdf_path = Path(pdf_path)
    print(f"\n  [SCAN] Scanning PDF: {pdf_path.name} (type={pdf_type})")
    
    t0 = time.time()
    
    # Render all pages
    all_images = pdf_to_images_bytes(str(pdf_path), dpi=120)
    num_pages = len(all_images)
    print(f"    Total pages: {num_pages}")
    
    if not all_images:
        return _empty_manifest()
    
    # Build type-specific prompt
    prompt = _build_scan_prompt(pdf_type, classification, num_pages)
    
    try:
        response = call_llm(prompt, images=all_images)
        json_str = _extract_json(response)
        
        if json_str:
            data = json.loads(json_str)
            manifest = _normalize_manifest(data, num_pages, pdf_type)
            manifest["elapsed_s"] = time.time() - t0
            
            print(f"    [OK] Scan complete: {manifest.get('num_floors', 1)} floors, "
                  f"{len(manifest.get('grid_x', {}).get('labels', []))}x"
                  f"{len(manifest.get('grid_y', {}).get('labels', []))} grid, "
                  f"{manifest['elapsed_s']:.1f}s")
            return manifest
    except Exception as e:
        print(f"    [WARN] Scanner LLM error: {e}")
    
    return _empty_manifest()


def _build_scan_prompt(pdf_type, classification, num_pages):
    """Build type-specific scanning prompt."""
    
    base_prompt = f"""You are an expert structural/architectural engineer analyzing a {num_pages}-page PDF drawing set.

This PDF is classified as: **{pdf_type}**

Analyze ALL pages and return a complete building manifest in JSON.

IMPORTANT RULES:
1. Look at EVERY page. Classify each page as: "plan", "elevation", "section", "schedule", "detail", "title", "other"
2. Extract grid system ONLY if visible (labeled A, B, C... and 1, 2, 3... lines)
3. Identify ALL floor levels with their elevations
4. For structural: extract column/beam marks, section labels, material types
5. For architectural: extract wall types, room names, door/window positions"""

    if pdf_type == "structural_only":
        prompt = base_prompt + """

FOCUS AREAS for structural drawings:
- GRID: Column grid labels (X: 1,2,3... and Y: A,B,C...), grid spacings in mm
- LEVELS: Each floor elevation (e.g., Ground: 0mm, Level 1: 3500mm, etc.)
- SCHEDULE: Member schedule tables → extract mark, section, material for each entry
- MEMBERS PER FLOOR: Count and list columns/beams/braces on each plan page
- SECTIONS: Typical steel sections (UB, UC, RHS, SHS, H, W, CHS)
- DIMENSIONS: Look for dimension lines to determine scale and real-world sizes

JSON FORMAT:
{
  "building_name": "Building Name from title block",
  "building_type": "industrial|commercial|residential|warehouse|other",
  "num_floors": number,
  "total_height_mm": number,
  "grid_x": {"labels": ["1","2","3"], "spacings_mm": [6000,6000]},
  "grid_y": {"labels": ["A","B","C"], "spacings_mm": [5000,5000]},
  "scale_x_mm_per_px": estimated_number,
  "scale_confidence": 0.0-1.0,
  "levels": [
    {"name": "Ground Floor", "elevation_mm": 0, "floor_height_mm": 3500, "plan_page_index": 0}
  ],
  "plan_page_indices": [0, 1, 2],
  "elevation_page_indices": [3],
  "schedule_page_indices": [4, 5],
  "member_db": {
    "C1": {"type": "column", "section": "UC203x203x46", "material": "Steel", "grade": "S355"},
    "B1": {"type": "beam", "section": "UB305x165x40", "material": "Steel", "grade": "S355"}
  },
  "page_classifications": {"0": "plan", "1": "plan", "2": "schedule"}
}
"""
    elif pdf_type == "architectural_only":
        prompt = base_prompt + """

FOCUS AREAS for architectural drawings:
- WALLS: Wall positions, thicknesses, lengths. Extract as lines with start/end points.
- ROOMS: Room names, areas, functions (living, kitchen, bedroom, bathroom, etc.)
- DOORS: Door types (single swing, double, sliding), widths (900mm typical), positions on walls
- WINDOWS: Window types, widths, sill heights (900mm typical), positions on walls
- STAIRS: Stair locations, directions, number of steps, rise/run dimensions
- SLABS/FLOORS: Floor outline boundary at each level, slab thickness
- ROOF: Roof type (flat, gable, hip), eaves elevation, slope
- LEVELS: Each floor level elevation (e.g., Ground: 0mm, Level 1: 3500mm)
- NO GRID SYSTEM expected — use dimensional references instead
- DIMENSIONS: Extract building overall width, depth, and floor-to-floor heights

JSON FORMAT:
{
  "building_name": "Building Name",
  "building_type": "house|apartment|villa|office|other",
  "num_floors": number,
  "total_height_mm": number,
  "grid_x": {"labels": [], "spacings_mm": []},
  "grid_y": {"labels": [], "spacings_mm": []},
  "scale_confidence": 0.0-1.0,
  "levels": [
    {"name": "Ground Floor", "elevation_mm": 0, "floor_height_mm": 3500, "plan_page_index": 0}
  ],
  "plan_page_indices": [0],
  "elevation_page_indices": [1, 2, 3],
  "wall_types": [
    {"type": "External-200", "thickness_mm": 200, "material": "Brick", "description": "External bearing wall"}
  ],
  "door_types": [
    {"type": "D1", "width_mm": 900, "height_mm": 2100, "style": "single_swing"}
  ],
  "window_types": [
    {"type": "W1", "width_mm": 2000, "height_mm": 1500, "sill_height_mm": 900, "style": "sliding"}
  ],
  "building_outline": {"width_mm": 12000, "depth_mm": 10000},
  "page_classifications": {"0": "plan", "1": "elevation"}
}
"""
    else:  # mixed
        prompt = base_prompt + """

FOCUS AREAS for mixed (shop drawing / construction) documents:
- GRID: Column grid labels if present (may be partial)
- STRUCTURAL MEMBERS: Columns, beams, braces with section references
- ARCHITECTURAL ELEMENTS: Walls, doors, windows, rooms if shown
- SCHEDULES: Both member schedules AND door/window schedules
- LEVELS: Floor elevations with both structural and architectural info
- DIMENSIONS: Grid spacings AND overall building dimensions

JSON FORMAT:
{
  "building_name": "Building Name",
  "building_type": "mixed_use|commercial|industrial|residential",
  "num_floors": number,
  "total_height_mm": number,
  "grid_x": {"labels": ["1","2","3"], "spacings_mm": [6000,6000]},
  "grid_y": {"labels": ["A","B","C"], "spacings_mm": [5000,5000]},
  "scale_x_mm_per_px": estimated_number,
  "scale_confidence": 0.0-1.0,
  "levels": [
    {"name": "Ground Floor", "elevation_mm": 0, "floor_height_mm": 3500, "plan_page_index": 0}
  ],
  "plan_page_indices": [0, 1],
  "elevation_page_indices": [2, 3],
  "schedule_page_indices": [4],
  "member_db": {
    "C1": {"type": "column", "section": "400x400mm", "material": "RC"},
    "B1": {"type": "beam", "section": "UB305x165x40", "material": "Steel"}
  },
  "wall_types": [{"type": "External", "thickness_mm": 200}],
  "door_types": [{"type": "D1", "width_mm": 900}],
  "window_types": [{"type": "W1", "width_mm": 2000}],
  "building_outline": {"width_mm": 15000, "depth_mm": 12000},
  "page_classifications": {"0": "plan", "1": "plan", "2": "elevation", "3": "schedule"}
}

Return ONLY the JSON object. No markdown, no explanation."""
    
    return prompt


def _normalize_manifest(data, num_pages, pdf_type):
    """Ensure all required fields exist with sensible defaults."""
    manifest = {
        "building_name": data.get("building_name", "Unnamed Building"),
        "building_type": data.get("building_type", "unknown"),
        "num_floors": data.get("num_floors", 1),
        "total_height_mm": data.get("total_height_mm", 3500),
        "grid_x": data.get("grid_x", {"labels": [], "spacings_mm": []}),
        "grid_y": data.get("grid_y", {"labels": [], "spacings_mm": []}),
        "scale_x_mm_per_px": data.get("scale_x_mm_per_px", 3.0),
        "scale_confidence": data.get("scale_confidence", 0.5),
        "levels": data.get("levels", []),
        "plan_page_indices": data.get("plan_page_indices", []),
        "elevation_page_indices": data.get("elevation_page_indices", []),
        "schedule_page_indices": data.get("schedule_page_indices", []),
        "member_db": data.get("member_db", {}),
        "wall_types": data.get("wall_types", []),
        "door_types": data.get("door_types", []),
        "window_types": data.get("window_types", []),
        "building_outline": data.get("building_outline", {}),
        "page_classifications": data.get("page_classifications", {}),
        "num_pages": num_pages,
        "pdf_type": pdf_type,
    }
    
    # Default levels if empty
    if not manifest["levels"] and not manifest["plan_page_indices"]:
        manifest["levels"] = [
            {"name": "Ground Floor", "elevation_mm": 0, "floor_height_mm": 3500, "plan_page_index": 0}
        ]
        manifest["plan_page_indices"] = [0]
    
    # Ensure levels have plan_page_index
    for i, level in enumerate(manifest["levels"]):
        if "plan_page_index" not in level:
            plan_pages = manifest["plan_page_indices"]
            level["plan_page_index"] = plan_pages[i] if i < len(plan_pages) else 0
    
    return manifest


def _empty_manifest():
    """Empty/fallback manifest."""
    return {
        "building_name": "Unknown Building",
        "building_type": "unknown",
        "num_floors": 1,
        "total_height_mm": 3500,
        "grid_x": {"labels": [], "spacings_mm": []},
        "grid_y": {"labels": [], "spacings_mm": []},
        "scale_x_mm_per_px": 3.0,
        "scale_confidence": 0.0,
        "levels": [{"name": "Level 1", "elevation_mm": 0, "floor_height_mm": 3500, "plan_page_index": 0}],
        "plan_page_indices": [0],
        "elevation_page_indices": [],
        "schedule_page_indices": [],
        "member_db": {},
        "wall_types": [],
        "door_types": [],
        "window_types": [],
        "building_outline": {},
        "page_classifications": {"0": "plan"},
        "num_pages": 1,
        "pdf_type": "unknown",
        "fallback": True,
    }


def _extract_json(text):
    """Extract JSON from LLM response text."""
    text = text.strip()
    if text.startswith("```"):
        lines = text.split("\n")
        if lines[0].startswith("```"):
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