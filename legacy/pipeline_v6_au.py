#!/usr/bin/env python3
"""
================================================================================
PIPELINE V6 AU — Australian PDF to SketchUp LOD300 (Domain-Aware)
================================================================================
Fixes 7 root causes identified in PLAN_V6_ROOT_CAUSE.md:

  R1: Level dedup — merge duplicate levels across pages
  R2: Grid spacing — detect from dimensions, not hardcoded 6000mm
  R3: Floor assignment — columns span ALL floors from bottom_z to top_z
  R4: Global coordinate system — spatial registration across pages
  R5: Element assembly — spatial clustering + dedup
  R6: Ruby generator — uses actual positions, not grid-only
  R7: Architectural features — walls, doors, windows, stairs, slabs

Pipeline phases:
  Phase 0:  Forensic — region/material/building type detection (NO LLM)
  Phase 0.5: Vision Rendering — PDF->PNG at configurable DPI  
  Phase 1:  Scanner V5 — Vision-first element extraction
  Phase 1.5: Level Dedup — merge duplicate levels across pages
  Phase 1.6: Global Assembly — spatial dedup + transform
  Phase 2:  Model Validation — structural completeness check
  Phase 3:  Ruby Generation — SketchUp .rb output (AU-aware)

Usage:
  python pipeline_v6_au.py data/input_pdf/structural.pdf
  python pipeline_v6_au.py data/input_pdf/St_Carloa_Moama.pdf lod300_moama
================================================================================
"""
import json
import sys
import time
from pathlib import Path
from typing import Optional

sys.path.insert(0, str(Path(__file__).parent))

from config import OUTPUT_JSON_DIR, RUBY_OUTPUT_DIR


# ================================================================
# MAIN ENTRY
# ================================================================

def run_pipeline_v6(
    pdf_path: str,
    output_name: str = "lod300_v6",
    dpi: int = 300,
    force_region: Optional[str] = None,
    force_strategy: Optional[str] = None,
) -> dict:
    """Execute full V6 AU pipeline."""
    start_time = time.time()
    pdf_path = Path(pdf_path)

    print("\n" + "=" * 70)
    print("SKETCHUP AUTO PIPELINE V6 AU — Domain-Aware LOD300")
    print("=" * 70)
    print(f"  PDF:         {pdf_path.name}")
    print(f"  Output:      {output_name}")
    print(f"  DPI:         {dpi}")
    print("=" * 70)

    # Phase 0: Forensic
    print("\n-- Phase 0: PDF Forensic Analysis --")
    from agents.pdf_forensic import run_forensic
    forensic = run_forensic(str(pdf_path), verbose=False)
    forensic_dict = forensic.to_dict()
    
    forensic_path = Path(OUTPUT_JSON_DIR) / f"{output_name}_forensic.json"
    forensic_path.parent.mkdir(parents=True, exist_ok=True)
    forensic_path.write_text(json.dumps(forensic_dict, indent=2, ensure_ascii=False), encoding="utf-8")
    print(f"  [SAVE] Forensic: {forensic_path}")
    
    region = force_region or forensic.region
    print(f"  Region: {region} | Material: {forensic.primary_material} | "
          f"Building: {forensic.building_type} | Pages: {forensic.num_pages}")

    # Phase 0.5: Vision Rendering
    print("\n-- Phase 0.5: Vision Rendering --")
    from core.vision_renderer import VisionRenderer
    renderer = VisionRenderer(pdf_path, dpi)
    meta = renderer.render_all_metadata()
    print(f"  Pages: {renderer.num_pages}")
    for m in meta[:5]:
        print(f"    Page {m['page_index']}: {m['width_mm']:.0f}x{m['height_mm']:.0f}mm "
              f"| {m['orientation']} | {m['num_drawing_paths']} paths")
    if renderer.num_pages > 5:
        print(f"    ... +{renderer.num_pages - 5} more pages")

    # Phase 1: Scanner V5
    print("\n-- Phase 1: Scanner V5 — Vision-First Analysis --")
    classification = {
        "pdf_type": force_strategy or "structural-architectural",
        "strategy": force_strategy or "mixed",
        "auto_detected": force_strategy is None,
        "region": region,
        "forensic": forensic_dict,
    }
    from agents.scanner_v5 import ScannerV5
    scanner = ScannerV5(pdf_path, dpi=dpi)
    building_model = scanner.run()
    scanner.close()
    building_model["_forensic"] = forensic_dict
    building_model["_region"] = region
    
    # R2: Use forensic grid spacing
    if forensic.detected_grid_spacing:
        building_model["grid_spacing_detected_mm"] = forensic.detected_grid_spacing
        print(f"  [FIX R2] Forensic grid spacing: {forensic.detected_grid_spacing}mm")
    
    model_path = Path(OUTPUT_JSON_DIR) / f"{output_name}_model_raw.json"
    model_path.parent.mkdir(parents=True, exist_ok=True)
    model_path.write_text(json.dumps(building_model, indent=2, ensure_ascii=False), encoding="utf-8")
    print(f"\n  [SAVE] Raw model: {model_path}")
    n_floors = len(building_model.get("floors", []))
    n_cols = sum(len(f.get("columns", [])) for f in building_model.get("floors", []))
    n_beams = sum(len(f.get("beams", [])) for f in building_model.get("floors", []))
    print(f"  Floors: {n_floors} | Columns: {n_cols} | Beams: {n_beams}")

    # Phase 1.5: Level Dedup (R1) + Column Floor Assignment (R3)
    print("\n-- Phase 1.5: Level Dedup & Floor Assignment Fix --")
    building_model = _dedup_levels(building_model)
    building_model = _fix_column_floor_assignment(building_model)
    print(f"  [FIX R1+R3] Floors deduped: {len(building_model.get('floors', []))}")

    # Phase 1.6: Global Assembly (R4+R5)
    print("\n-- Phase 1.6: Global Assembly & Spatial Dedup --")
    building_model = _global_assembly(building_model)
    
    model_fixed_path = Path(OUTPUT_JSON_DIR) / f"{output_name}_model.json"
    model_fixed_path.write_text(json.dumps(building_model, indent=2, ensure_ascii=False), encoding="utf-8")
    print(f"  [SAVE] Fixed model: {model_fixed_path}")

    manifest = _build_manifest_v6(building_model, classification)
    manifest_path = Path(OUTPUT_JSON_DIR) / f"{output_name}_manifest.json"
    manifest_path.write_text(json.dumps(manifest, indent=2, ensure_ascii=False), encoding="utf-8")
    print(f"  [SAVE] Manifest: {manifest_path}")

    # Phase 2: Validation
    print("\n-- Phase 2: Model Validation --")
    stats = _validate_model(building_model)
    stats["region"] = region
    stats["forensic"] = {
        "primary_material": forensic.primary_material,
        "building_type": forensic.building_type,
        "has_schedules": forensic.has_schedules,
        "num_pages": forensic.num_pages,
        "detected_grid_spacing": forensic.detected_grid_spacing,
    }
    stats_path = Path(OUTPUT_JSON_DIR) / f"{output_name}_stats.json"
    stats_path.write_text(json.dumps(stats, indent=2, ensure_ascii=False), encoding="utf-8")
    print(f"  [SAVE] Stats: {stats_path}")
    for k, v in stats.items():
        if isinstance(v, (int, float)) and v > 0:
            print(f"    {k}: {v}")

    # Phase 3: Ruby Generation (R6+R7)
    print("\n-- Phase 3: Ruby Code Generation (AU-Aware) --")
    ruby_code = _generate_ruby_v6(building_model, manifest, forensic_dict)
    ruby_path = Path(RUBY_OUTPUT_DIR) / f"{output_name}.rb"
    ruby_path.parent.mkdir(parents=True, exist_ok=True)
    ruby_path.write_text(ruby_code, encoding="utf-8")
    print(f"  [SAVE] Ruby script: {ruby_path}")
    print(f"  Code size: {len(ruby_code)} chars, {ruby_code.count(chr(10))} lines")

    # Summary
    elapsed = time.time() - start_time
    print(f"\n{'=' * 70}")
    print(f"PIPELINE V6 AU COMPLETE — {elapsed:.1f}s")
    print(f"{'=' * 70}")
    print(f"  PDF:         {pdf_path.name}")
    print(f"  Region:      {region}")
    print(f"  Material:    {forensic.primary_material}")
    print(f"  Building:    {building_model.get('building_name', '?')}")
    print(f"  Floors:      {len(building_model.get('floors', []))}")
    print(f"  Elements:    {stats.get('total_elements', 0)}")
    print(f"  Grid X/Y:    {len(building_model.get('grid_x', {}).get('labels', []))}/{len(building_model.get('grid_y', {}).get('labels', []))}")
    print(f"  Ruby:        {ruby_path}")
    print(f"{'=' * 70}")

    return {
        "building_model": building_model,
        "forensic": forensic_dict,
        "manifest": manifest,
        "stats": stats,
        "ruby_code": ruby_code,
        "ruby_path": str(ruby_path),
        "classification": classification,
        "elapsed_seconds": elapsed,
        "output_name": output_name,
        "region": region,
    }


# ================================================================
# R1: LEVEL DEDUP
# ================================================================

def _dedup_levels(model: dict) -> dict:
    """Merge duplicate levels by elevation proximity (500mm tolerance)."""
    floors = model.get("floors", [])
    if len(floors) <= 1:
        return model
    
    tolerance_mm = 500
    merged = []
    used = set()
    
    for i, f1 in enumerate(floors):
        if i in used:
            continue
        z1 = f1.get("elevation_mm", f1.get("z_start_mm", 0))
        cluster = [f1]
        used.add(i)
        for j, f2 in enumerate(floors):
            if j in used:
                continue
            z2 = f2.get("elevation_mm", f2.get("z_start_mm", 0))
            if abs(z1 - z2) < tolerance_mm:
                cluster.append(f2)
                used.add(j)
        best = max(cluster, key=lambda f: (
            len(f.get("columns", [])) + len(f.get("beams", [])) + len(f.get("walls", []))
        ))
        for other in cluster:
            if other is best:
                continue
            for key in ("columns", "beams", "walls", "arch_doors", "arch_windows", "arch_stairs"):
                best.setdefault(key, []).extend(other.get(key, []))
        merged.append(best)
    
    merged.sort(key=lambda f: f.get("elevation_mm", f.get("z_start_mm", 0)))
    model["floors"] = merged
    model["num_floors"] = len(merged)
    print(f"  [R1] Dedup: {len(floors)} -> {len(merged)} levels")
    return model


# ================================================================
# R3: COLUMN FLOOR ASSIGNMENT
# ================================================================

def _fix_column_floor_assignment(model: dict) -> dict:
    """Columns span ALL floors from bottom_z to top_z."""
    floors = model.get("floors", [])
    if len(floors) <= 1:
        return model
    
    all_cols = []
    for floor in floors:
        for col in floor.get("columns", []):
            all_cols.append(col)
    if not all_cols:
        return model
    
    all_elevations = [f.get("elevation_mm", f.get("z_start_mm", 0)) for f in floors]
    min_z = min(all_elevations)
    max_z = max(all_elevations)
    max_fh = max([f.get("floor_height_mm", 3500) for f in floors], default=3500)
    roof_z = max_z + max_fh
    
    deduped = _spatial_dedup(all_cols, tolerance_mm=1000)
    for col in deduped:
        col["bottom_z"] = min_z
        col["top_z"] = roof_z
        col["height_mm"] = roof_z - min_z
        col["continuous"] = True
    
    for floor in floors:
        floor["columns"] = deduped
    
    model["_deduped_columns"] = deduped
    print(f"  [R3] Column fix: {len(all_cols)} raw -> {len(deduped)} unique spanning z={min_z}-{roof_z}mm")
    return model


# ================================================================
# R4+R5: GLOBAL ASSEMBLY & SPATIAL DEDUP
# ================================================================

def _global_assembly(model: dict) -> dict:
    """Transform to global coords, dedup by spatial position."""
    floors = model.get("floors", [])
    grid_x = model.get("grid_x", {})
    grid_y = model.get("grid_y", {})
    
    x_labels = grid_x.get("labels", [])
    y_labels = grid_y.get("labels", [])
    x_spacings = grid_x.get("spacings_mm", [6000] * len(x_labels))
    y_spacings = grid_y.get("spacings_mm", [6000] * len(y_labels))
    
    x_cum = _cumulative_positions(x_labels, x_spacings)
    y_cum = _cumulative_positions(y_labels, y_spacings)
    model["_global_grid_positions"] = {"x": x_cum, "y": y_cum}
    model["_global_origin"] = {"x": 0, "y": 0, "z": 0}
    
    for floor in floors:
        for col in floor.get("columns", []):
            gx = col.get("grid_x", "")
            gy = col.get("grid_y", "")
            if gx in x_cum and gy in y_cum:
                if "x_mm" not in col or col.get("x_mm", 0) == 0:
                    col["x_mm"] = x_cum[gx]
                    col["y_mm"] = y_cum[gy]
        floor["columns"] = _spatial_dedup(floor.get("columns", []), tolerance_mm=500)
    
    print(f"  [R4+R5] Global coords: {len(x_cum)} X-axes, {len(y_cum)} Y-axes")
    return model


def _cumulative_positions(labels: list, spacings: list) -> dict:
    pos = 0
    result = {}
    for i, label in enumerate(labels):
        result[label] = pos
        pos += spacings[i] if i < len(spacings) else (spacings[-1] if spacings else 6000)
    return result


def _spatial_dedup(elements: list, tolerance_mm: float = 500) -> list:
    if not elements:
        return []
    elements.sort(key=lambda e: (
        round(e.get("x_mm", 0) / tolerance_mm) * tolerance_mm,
        round(e.get("y_mm", 0) / tolerance_mm) * tolerance_mm,
    ))
    deduped = []
    for elem in elements:
        x = elem.get("x_mm", 0)
        y = elem.get("y_mm", 0)
        found = False
        for existing in deduped:
            ex = existing.get("x_mm", 0)
            ey = existing.get("y_mm", 0)
            if abs(x - ex) < tolerance_mm and abs(y - ey) < tolerance_mm:
                if elem.get("confidence", 0) > existing.get("confidence", 0):
                    existing.update(elem)
                found = True
                break
        if not found:
            deduped.append(dict(elem))
    return deduped


# ================================================================
# HELPERS
# ================================================================

def _build_manifest_v6(model: dict, classification: dict) -> dict:
    return {
        "building_name": model.get("building_name", "Building"),
        "building_type": model.get("building_type", "unknown"),
        "num_floors": model.get("num_floors", 1),
        "total_height_mm": model.get("total_height_mm", 3500),
        "grid_x": model.get("grid_x", {"labels": [], "spacings_mm": []}),
        "grid_y": model.get("grid_y", {"labels": [], "spacings_mm": []}),
        "scale_x_mm_per_px": model.get("scale_x_mm_per_px", 3.0),
        "scale_confidence": model.get("scale_confidence", 0.7),
        "levels": model.get("levels", []),
        "plan_page_indices": model.get("plan_page_indices", []),
        "elevation_page_indices": model.get("elevation_page_indices", []),
        "schedule_page_indices": model.get("schedule_page_indices", []),
        "member_db": model.get("member_db", {}),
        "wall_types": model.get("wall_types", []),
        "door_types": model.get("door_types", []),
        "window_types": model.get("window_types", []),
        "building_outline": model.get("building_outline", {}),
        "page_classifications": model.get("page_classifications", {}),
        "num_pages": model.get("num_pages", 1),
        "pdf_type": classification.get("pdf_type", "structural"),
        "region": classification.get("region", "unknown"),
        "version": "v6-au-domain-aware",
        "global_grid_positions": model.get("_global_grid_positions", {}),
        "deduped_columns_count": len(model.get("_deduped_columns", [])),
    }


def _validate_model(model: dict) -> dict:
    floors = model.get("floors", [])
    total_cols = sum(len(f.get("columns", [])) for f in floors)
    total_beams = sum(len(f.get("beams", [])) for f in floors)
    total_walls = sum(len(f.get("walls", [])) for f in floors)
    total_doors = sum(len(f.get("arch_doors", [])) for f in floors)
    total_windows = sum(len(f.get("arch_windows", [])) for f in floors)
    total_stairs = sum(len(f.get("arch_stairs", [])) for f in floors)
    total_slabs = sum(1 for f in floors if f.get("slab", {}).get("polygon"))
    total_bracing = sum(len(f.get("bracing", [])) for f in floors)
    total_footings = len(model.get("footings", []))
    
    confidences = []
    for f in floors:
        for key in ("columns", "beams", "walls", "bracing", "footings"):
            for item in f.get(key, []):
                conf = item.get("confidence", 0)
                if conf:
                    confidences.append(conf)
    avg_conf = sum(confidences) / len(confidences) if confidences else 0.0
    
    return {
        "num_floors": len(floors),
        "total_height_mm": model.get("total_height_mm", 0),
        "columns": total_cols,
        "beams": total_beams,
        "walls": total_walls,
        "bracing": total_bracing,
        "footings": total_footings,
        "doors": total_doors,
        "windows": total_windows,
        "stairs": total_stairs,
        "slabs": total_slabs,
        "total_elements": (total_cols + total_beams + total_walls + total_doors +
                          total_windows + total_stairs + total_slabs + total_bracing +
                          total_footings),
        "average_confidence": round(avg_conf, 3),
        "grid_detected": len(model.get("grid_x", {}).get("labels", [])) > 0,
    }


def _generate_ruby_v6(model: dict, manifest: dict, forensic: dict = None) -> str:
    """Generate SketchUp Ruby script (V6 AU-aware)."""
    try:
        from agents.ruby_generator_v4 import generate_ruby_v4
        return generate_ruby_v4(model, manifest)
    except ImportError:
        return _generate_ruby_fallback_v6(model, manifest, forensic)


def _generate_ruby_fallback_v6(model: dict, manifest: dict, forensic: dict = None) -> str:
    """
    R6+R7: Ruby generator with actual positions + AU section library + architectural features.
    """
    region = (forensic or {}).get("region", "unknown")
    material = (forensic or {}).get("primary_material", "unknown")
    building_name = model.get("building_name", "Building")
    
    lines = []
    lines.append("# " + "=" * 66)
    lines.append(f"# LOD300 Model - {building_name}")
    lines.append(f"# Pipeline V6 AU (Domain-Aware) | Region: {region} | Material: {material}")
    lines.append("# " + "=" * 66)
    lines.append("")
    lines.append("model = Sketchup.active_model")
    lines.append("model.start_operation('LOD300 V6 Import', true)")
    lines.append("ents = model.active_entities")
    lines.append("layers = model.layers")
    lines.append("")
    
    # AU Section Library
    lines.append("# -- AU Section Library (AS/NZS 3679.1) --")
    lines.append("module AUSection")
    lines.append("  SECTIONS = {")
    lines.append("    'UB150'  => [150, 75, 7.0, 5.0],")
    lines.append("    'UB200'  => [200, 100, 8.5, 5.6],")
    lines.append("    'UB250'  => [250, 125, 12.5, 7.5],")
    lines.append("    'UB310'  => [310, 165, 11.8, 7.2],")
    lines.append("    'UB360'  => [360, 170, 13.0, 8.0],")
    lines.append("    'UC150'  => [150, 150, 11.5, 7.0],")
    lines.append("    'UC200'  => [200, 200, 15.0, 9.0],")
    lines.append("    'UC250'  => [250, 250, 17.0, 10.0],")
    lines.append("    'UC310'  => [310, 305, 21.4, 12.7],")
    lines.append("    'PFC150' => [150, 75, 10.0, 6.0],")
    lines.append("    'PFC200' => [200, 75, 12.0, 6.0],")
    lines.append("    'PFC300' => [300, 90, 16.0, 8.0],")
    lines.append("  }")
    lines.append("  def self.get(spec); SECTIONS[spec] || [200, 100, 10, 6]; end")
    lines.append("end")
    lines.append("")
    
    # Layers
    lines.append("# -- Layers --")
    layer_names = [
        "STRUCT-Columns", "STRUCT-Beams", "STRUCT-Bracing",
        "STRUCT-Footings", "STRUCT-Slabs",
        "ARCH-Walls", "ARCH-Doors", "ARCH-Windows",
    ]
    for ln in layer_names:
        lines.append(f'layers.add("{ln}") unless layers["{ln}"]')
    lines.append("")
    
    # Materials
    lines.append("def _mat(name, r=128, g=128, b=128)")
    lines.append("  model = Sketchup.active_model")
    lines.append("  m = model.materials[name] || model.materials.add(name)")
    lines.append("  m.color = Sketchup::Color.new(r, g, b) unless m.color")
    lines.append("  m")
    lines.append("end")
    lines.append("")
    lines.append("STEEL = _mat('Steel', 180, 180, 190)")
    lines.append("CONCRETE = _mat('Concrete', 200, 195, 185)")
    lines.append("WALL_MAT = _mat('Wall', 220, 215, 205)")
    lines.append("")
    
    # Process floors
    floors = model.get("floors", [])
    lines.append(f"# -- {len(floors)} Floor(s) --")
    
    for fi, floor in enumerate(floors):
        fname = floor.get("name", f"Floor {fi}")
        z_start = floor.get("elevation_mm", floor.get("z_start_mm", fi * 3500))
        fheight = floor.get("floor_height_mm", 3500)
        z_end = z_start + fheight
        
        lines.append(f"# == Floor {fi}: {fname} (z={z_start}-{z_end}mm) ==")
        
        # Columns at actual positions (R6 FIX)
        cols = floor.get("columns", [])
        for col in cols:
            x = col.get("x_mm", 0)
            y = col.get("y_mm", 0)
            w = col.get("width_mm", 200)
            d = col.get("depth_mm", 200)
            h = col.get("height_mm", fheight)
            mark = col.get("mark", "C?")
            section = col.get("section", "UC200")
            
            lines.append(f"# Column {mark} {section}")
            lines.append(f"dims = AUSection.get('{section}')")
            lines.append(f"dc, wc = dims[0], dims[1]")
            lines.append(f"g = ents.add_group; g.name = '{mark}'")
            lines.append(f"g.layer = layers['STRUCT-Columns']")
            lines.append(f"pts = [[{x},{y},{z_start}],[{x}+dc,{y},{z_start}],[{x}+dc,{y}+wc,{z_start}],[{x},{y}+wc,{z_start}]]")
            lines.append(f"face = g.entities.add_face(pts); face.pushpull({h})")
            lines.append(f"g.material = STEEL")
        
        # Beams (R6 FIX)
        beams = floor.get("beams", [])
        for beam in beams:
            x1 = beam.get("x1_mm", beam.get("x_mm", 0))
            y1 = beam.get("y1_mm", beam.get("y_mm", 0))
            x2 = beam.get("x2_mm", x1 + 6000)
            y2 = beam.get("y2_mm", y1)
            bd = beam.get("depth_mm", 300)
            bw = beam.get("width_mm", 150)
            mark = beam.get("mark", "B?")
            section = beam.get("section", "UB310")
            z_beam_bot = z_end - bd
            
            lines.append(f"# Beam {mark} {section}")
            lines.append(f"dims = AUSection.get('{section}')")
            lines.append(f"bd, bw = dims[0], dims[1]")
            lines.append(f"g = ents.add_group; g.name = '{mark}'")
            lines.append(f"g.layer = layers['STRUCT-Beams']")
            lines.append(f"pts = [[{x1},{y1},{z_beam_bot}],[{x2},{y2},{z_beam_bot}],[{x2},{y2}+bw,{z_beam_bot}],[{x1},{y1}+bw,{z_beam_bot}]]")
            lines.append(f"face = g.entities.add_face(pts); face.pushpull(bd)")
            lines.append(f"g.material = STEEL")
        
        # Walls (R7 FIX)
        walls = floor.get("walls", [])
        for wall in walls:
            wx1 = wall.get("x1_mm", 0)
            wy1 = wall.get("y1_mm", 0)
            wx2 = wall.get("x2_mm", 6000)
            wy2 = wall.get("y2_mm", 0)
            wt = wall.get("thickness_mm", 200)
            wh = wall.get("height_mm", fheight)
            wmark = wall.get("mark", "W?")
            
            lines.append(f"g = ents.add_group; g.name = '{wmark}'")
            lines.append(f"g.layer = layers['ARCH-Walls']")
            lines.append(f"pts = [[{wx1},{wy1},{z_start}],[{wx2},{wy2},{z_start}],[{wx2},{wy2}+{wt},{z_start}],[{wx1},{wy1}+{wt},{z_start}]]")
            lines.append(f"face = g.entities.add_face(pts); face.pushpull({wh})")
            lines.append(f"g.material = WALL_MAT")
        
        # Slab (R7 FIX)
        slab_outline = floor.get("slab", {}).get("polygon", [])
        if not slab_outline:
            outline_data = model.get("building_outline", {})
            bw = outline_data.get("width_mm", 24000)
            bd = outline_data.get("depth_mm", 21000)
            slab_outline = [[0, 0], [bw, 0], [bw, bd], [0, bd]]
        
        thickness = floor.get("slab", {}).get("thickness_mm", 150)
        pts_str = ", ".join(f"[{p[0]},{p[1]},{z_start}]" for p in slab_outline)
        lines.append(f"# Slab: {thickness}mm")
        lines.append(f"g = ents.add_group; g.name = 'Slab_{fname}'")
        lines.append(f"g.layer = layers['STRUCT-Slabs']")
        lines.append(f"pts = [{pts_str}]")
        lines.append(f"face = g.entities.add_face(pts); face.pushpull(-{thickness})")
        lines.append(f"g.material = CONCRETE")
        lines.append("")
    
    # Footings (R7 FIX)
    footings = model.get("footings", [])
    if footings:
        lines.append(f"# -- {len(footings)} Footings --")
        for ft in footings:
            fx = ft.get("x_mm", 0)
            fy = ft.get("y_mm", 0)
            fs = ft.get("size_mm", [1200, 1200])
            fw, fd = fs[0], fs[1] if len(fs) > 1 else fs[0]
            fz_top = ft.get("rl_top_mm", 0)
            fz_bot = fz_top - ft.get("depth_mm", 400)
            
            lines.append(f"g = ents.add_group; g.name = '{ft.get('mark','F?')}'")
            lines.append(f"g.layer = layers['STRUCT-Footings']")
            lines.append(f"pts = [[{fx},{fy},{fz_bot}],[{fx+fw},{fy},{fz_bot}],[{fx+fw},{fy+fd},{fz_bot}],[{fx},{fy+fd},{fz_bot}]]")
            lines.append(f"face = g.entities.add_face(pts); face.pushpull({ft.get('depth_mm', 400)})")
            lines.append(f"g.material = CONCRETE")
    
    lines.append("model.commit_operation")
    lines.append('UI.messagebox("LOD300 V6 AU imported!")')
    lines.append("")
    
    return "\n".join(lines)


# ================================================================
# CLI
# ================================================================

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python pipeline_v6_au.py <pdf_path> [output_name]")
        pdf_dir = Path("data/input_pdf")
        if pdf_dir.exists():
            print("\nAvailable PDFs:")
            for f in sorted(pdf_dir.glob("*.pdf")):
                print(f"  {f}")
        sys.exit(1)

    pdf = sys.argv[1]
    out = sys.argv[2] if len(sys.argv) > 2 else "lod300_v6"
    result = run_pipeline_v6(pdf, output_name=out)
    print(f"\nDone! Ruby: {result['ruby_path']}")