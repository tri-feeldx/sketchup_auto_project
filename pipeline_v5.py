"""
=============================================================================
PIPELINE V5 — Vision-First PDF to SketchUp LOD300 Pipeline
=============================================================================
Complete pipeline:
  Phase 0: PDF → Hi-res PNG rendering (VisionRenderer)
  Phase 1: Scanner V5 — Vision-first analysis (classify + extract per page)
  Phase 2: Model Builder — Synthesize multi-floor building model
  Phase 3: Ruby Generator — Generate SketchUp Ruby script (.rb)

Khắc phục toàn bộ hạn chế của V4:
  - Vision-first: Gemini nhìn TRỰC TIẾP ảnh bản vẽ 300 DPI
  - Multi-type: plan, elevation, section → type-specific analysis
  - Multi-floor: mỗi tầng có floor plan riêng
  - Domain knowledge: prompt chứa conventions bản vẽ xây dựng
=============================================================================
"""
import json
import sys
import time
import traceback
from pathlib import Path
from typing import Optional

sys.path.insert(0, str(Path(__file__).parent))

from config import OUTPUT_JSON_DIR, RUBY_OUTPUT_DIR


def run_pipeline_v5(
    pdf_path: str,
    output_name: str = "lod300_v5",
    dpi: int = 300,
    force_strategy: Optional[str] = None,
) -> dict:
    """
    Execute V5 Vision-First pipeline.

    Args:
        pdf_path: Path to PDF
        output_name: Base name for output files
        dpi: Render DPI (higher = better quality, slower)
        force_strategy: "structural", "architectural", "mixed" (optional)

    Returns:
        dict with paths, stats, and generated Ruby code
    """
    start_time = time.time()
    pdf_path = Path(pdf_path)

    print("\n" + "=" * 70)
    print("SKETCHUP AUTO PIPELINE V5 — Vision-First")
    print("=" * 70)
    print(f"  PDF: {pdf_path.name}")
    print(f"  Output: {output_name}")
    print(f"  DPI: {dpi}")
    print("=" * 70)

    # ═══════════════════════════════════════════════════════════════
    # PHASE 0: PDF CLASSIFICATION & PREVIEW
    # ═══════════════════════════════════════════════════════════════
    print("\n-- Phase 0: PDF Preview --")
    
    from core.vision_renderer import VisionRenderer
    
    renderer = VisionRenderer(pdf_path, dpi)
    meta = renderer.render_all_metadata()
    print(f"  Pages: {renderer.num_pages}")
    for m in meta:
        print(f"    Page {m['page_index']}: {m['width_mm']:.0f}x{m['height_mm']:.0f}mm "
              f"| {m['orientation']} | {m['num_drawing_paths']} paths")

    # Also try old classifier for type detection
    pdf_type = "structural-architectural"
    classification = {"pdf_type": pdf_type, "strategy": "mixed", "auto_detected": True}
    
    if force_strategy:
        pdf_type = force_strategy
        classification["pdf_type"] = pdf_type
        classification["auto_detected"] = False
        print(f"  Strategy forced: {pdf_type}")
    else:
        try:
            from agents.pdf_classifier import classify_pdf
            classification = classify_pdf(str(pdf_path))
            pdf_type = classification.get("pdf_type", pdf_type)
            print(f"  Detected: {pdf_type}")
        except Exception as e:
            print(f"  [WARN] Classification failed, using default: {e}")

    # Save classification
    class_path = Path(OUTPUT_JSON_DIR) / f"{output_name}_classification.json"
    class_path.parent.mkdir(parents=True, exist_ok=True)
    class_path.write_text(json.dumps(classification, indent=2, ensure_ascii=False), encoding="utf-8")
    print(f"  [SAVE] {class_path}")

    # ═══════════════════════════════════════════════════════════════
    # PHASE 1: SCANNER V5 — Vision-First Analysis
    # ═══════════════════════════════════════════════════════════════
    print("\n-- Phase 1: Scanner V5 — Vision-First Analysis --")
    
    from agents.scanner_v5 import ScannerV5
    
    scanner = ScannerV5(pdf_path, dpi=dpi)
    building_model = scanner.run()  # Full: render → classify → analyze → synthesize
    scanner.close()

    # Save building model
    model_path = Path(OUTPUT_JSON_DIR) / f"{output_name}_model.json"
    model_path.parent.mkdir(parents=True, exist_ok=True)
    model_path.write_text(
        json.dumps(building_model, indent=2, ensure_ascii=False),
        encoding="utf-8"
    )
    print(f"\n  [SAVE] Building model: {model_path}")

    # Save manifest (backward compat)
    manifest = _build_manifest(building_model, pdf_type)
    manifest_path = Path(OUTPUT_JSON_DIR) / f"{output_name}_manifest.json"
    manifest_path.write_text(
        json.dumps(manifest, indent=2, ensure_ascii=False),
        encoding="utf-8"
    )
    print(f"  [SAVE] Manifest: {manifest_path}")

    # ═══════════════════════════════════════════════════════════════
    # PHASE 2: MODEL VALIDATION
    # ═══════════════════════════════════════════════════════════════
    print("\n-- Phase 2: Model Validation --")
    
    stats = _validate_model(building_model)
    stats_path = Path(OUTPUT_JSON_DIR) / f"{output_name}_stats.json"
    stats_path.write_text(json.dumps(stats, indent=2, ensure_ascii=False), encoding="utf-8")
    print(f"  [SAVE] Stats: {stats_path}")
    
    print(f"  Model stats:")
    for k, v in stats.items():
        if isinstance(v, (int, float)):
            print(f"    {k}: {v}")

    # ═══════════════════════════════════════════════════════════════
    # PHASE 3: RUBY GENERATION
    # ═══════════════════════════════════════════════════════════════
    print("\n-- Phase 3: Ruby Code Generation --")
    
    ruby_code = _generate_ruby(building_model, manifest)
    
    ruby_path = Path(RUBY_OUTPUT_DIR) / f"{output_name}.rb"
    ruby_path.parent.mkdir(parents=True, exist_ok=True)
    ruby_path.write_text(ruby_code, encoding="utf-8")
    print(f"  [SAVE] Ruby script: {ruby_path}")
    print(f"  Code size: {len(ruby_code)} chars, {ruby_code.count(chr(10))} lines")

    # ═══════════════════════════════════════════════════════════════
    # SUMMARY
    # ═══════════════════════════════════════════════════════════════
    elapsed = time.time() - start_time
    print(f"\n{'=' * 70}")
    print(f"PIPELINE V5 COMPLETE — {elapsed:.1f}s")
    print(f"{'=' * 70}")
    print(f"  PDF:         {pdf_path.name}")
    print(f"  Building:    {building_model.get('building_name', '?')}")
    print(f"  Type:        {pdf_type}")
    print(f"  Floors:      {len(building_model.get('floors', []))}")
    print(f"  Total elements: {stats.get('total_elements', 0)}")
    print(f"  Ruby:        {ruby_path}")
    print(f"{'=' * 70}")

    return {
        "building_model": building_model,
        "manifest": manifest,
        "stats": stats,
        "ruby_code": ruby_code,
        "ruby_path": str(ruby_path),
        "classification": classification,
        "elapsed_seconds": elapsed,
        "output_name": output_name,
    }


# ═══════════════════════════════════════════════════════════════════════════════
# HELPERS
# ═══════════════════════════════════════════════════════════════════════════════

def _build_manifest(model: dict, pdf_type: str) -> dict:
    """Build manifest dict from V5 building model."""
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
        "pdf_type": pdf_type,
        "version": "v5-vision-first",
    }


def _validate_model(model: dict) -> dict:
    """Validate model and compute statistics."""
    floors = model.get("floors", [])
    
    total_cols = sum(len(f.get("columns", [])) for f in floors)
    total_beams = sum(len(f.get("beams", [])) for f in floors)
    total_walls = sum(len(f.get("walls", [])) for f in floors)
    total_doors = sum(len(f.get("arch_doors", [])) for f in floors)
    total_windows = sum(len(f.get("arch_windows", [])) for f in floors)
    total_stairs = sum(len(f.get("arch_stairs", [])) for f in floors)
    total_slabs = sum(len(f.get("arch_slabs", [])) for f in floors)
    
    # Compute confidence
    confidences = []
    for f in floors:
        for key in ("columns", "beams", "walls"):
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
        "doors": total_doors,
        "windows": total_windows,
        "stairs": total_stairs,
        "slabs": total_slabs,
        "total_elements": total_cols + total_beams + total_walls + total_doors + total_windows + total_stairs + total_slabs,
        "average_confidence": round(avg_conf, 3),
        "grid_detected": len(model.get("grid_x", {}).get("labels", [])) > 0,
    }


def _generate_ruby(model: dict, manifest: dict) -> str:
    """Generate SketchUp Ruby script from building model."""
    try:
        from agents.ruby_generator_v4 import generate_ruby_v4
        return generate_ruby_v4(model, manifest)
    except ImportError:
        return _generate_ruby_fallback(model, manifest)


def _generate_ruby_fallback(model: dict, manifest: dict) -> str:
    """Minimal Ruby generator fallback."""
    lines = []
    lines.append("# ═══════════════════════════════════════════════════════════")
    lines.append(f"# LOD300 Model — {model.get('building_name', 'Building')}")
    lines.append("# Generated by Pipeline V5 (Vision-First)")
    lines.append("# ═══════════════════════════════════════════════════════════")
    lines.append("")
    lines.append("model = Sketchup.active_model")
    lines.append("model.start_operation('LOD300 V5 Import', true)")
    lines.append("ents = model.active_entities")
    lines.append("layers = model.layers")
    lines.append("")
    lines.append("# Create layers")
    layer_names = [
        "STRUCT-Columns", "STRUCT-Beams", "STRUCT-Slabs",
        "ARCH-Walls", "ARCH-Doors", "ARCH-Windows", "ARCH-Stairs",
        "ARCH-Roof",
    ]
    for ln in layer_names:
        lines.append(f'layers.add("{ln}") unless layers["{ln}"]')
    lines.append("")
    lines.append("def _mat(name)")  
    lines.append("  model = Sketchup.active_model")
    lines.append("  m = model.materials[name] || model.materials.add(name)")
    lines.append("  m")
    lines.append("end")
    lines.append("")
    
    # Process floors
    floors = model.get("floors", [])
    lines.append(f"# ── {len(floors)} Floor(s) ──")
    lines.append("")
    
    for fi, floor in enumerate(floors):
        fname = floor.get("name", f"Floor {fi}")
        z_start = floor.get("elevation_mm", fi * 3500)
        z_end = z_start + floor.get("floor_height_mm", 3500)
        
        lines.append(f"# ══ Floor {fi}: {fname} (z={z_start}-{z_end}mm) ══")
        lines.append("")
        
        # Columns
        cols = floor.get("columns", [])
        if cols:
            lines.append(f"# Columns ({len(cols)})")
            for col in cols:
                mark = col.get("mark", col.get("id", f"C{cols.index(col)+1}"))
                x = col.get("x_mm", 0)
                y = col.get("y_mm", 0)
                w = col.get("width_mm", col.get("section_width_mm", 400))
                d = col.get("depth_mm", col.get("section_depth_mm", 400))
                zs = col.get("floor_elevation", col.get("z_start_mm", z_start))
                ze = col.get("z_top_mm", col.get("z_end_mm", zs + floor.get("floor_height_mm", 3500)))
                mat = col.get("material", "Steel")
                lines.append(f"# {mark} | {w}x{d}mm | {mat}")
                lines.append("begin")
                lines.append("  _g = ents.add_group; _e = _g.entities")
                lines.append(f"  _pts = [")
                lines.append(f"    Geom::Point3d.new({x}.mm, {y}.mm, {zs}.mm),")
                lines.append(f"    Geom::Point3d.new({x+w}.mm, {y}.mm, {zs}.mm),")
                lines.append(f"    Geom::Point3d.new({x+w}.mm, {y+d}.mm, {zs}.mm),")
                lines.append(f"    Geom::Point3d.new({x}.mm, {y+d}.mm, {zs}.mm)")
                lines.append("  ]")
                lines.append("  _f = _e.add_face(_pts)")
                lines.append(f"  _f.pushpull({ze-zs}.mm) if _f")
                lines.append(f'  _g.layer = layers["STRUCT-Columns"]')
                lines.append(f'  _g.material = _mat("{mat}")')
                lines.append("rescue => e")
                lines.append(f'  puts "SKIP {mark}: #{{e.message}}"')
                lines.append("end")
                lines.append("")
        
        # Beams
        beams = floor.get("beams", [])
        if beams:
            lines.append(f"# Beams ({len(beams)})")
            for beam in beams:
                mark = beam.get("mark", beam.get("id", f"B{beams.index(beam)+1}"))
                x1, y1 = beam.get("x_mm", 0), beam.get("y_mm", 0)
                x2, y2 = beam.get("x2_mm", 6000), beam.get("y2_mm", 0)
                zs = beam.get("z_start_mm", z_end - floor.get("floor_height_mm", 3500))
                ze = beam.get("z_end_mm", z_end)
                bm = beam.get("material", "Steel")
                sw = beam.get("width_mm", beam.get("section_width_mm", 200))
                sd = beam.get("depth_mm", beam.get("section_depth_mm", 300))
                lines.append(f"# {mark} | ({x1},{y1})->({x2},{y2}) | {bm} | {sw}x{sd}")
                lines.append("begin")
                lines.append("  _g = ents.add_group; _e = _g.entities")
                lines.append(f"  _p1 = Geom::Point3d.new({x1}.mm, {y1}.mm, {zs}.mm)")
                lines.append(f"  _p2 = Geom::Point3d.new({x2}.mm, {y2}.mm, {zs}.mm)")
                lines.append("  _line = _e.add_line(_p1, _p2)")
                lines.append("  if _line")
                lines.append("    _v = _p1.vector_to(_p2)")
                lines.append("    _t = Geom::Transformation.new(_p1, _v)")
                lines.append(f"    _rpts = [[-{sw/2}, -{sd/2}], [{sw/2}, -{sd/2}], [{sw/2}, {sd/2}], [-{sw/2}, {sd/2}]]")
                lines.append("    _r3d = _rpts.map{|p| _t * Geom::Point3d.new(p[0].mm, p[1].mm, 0)}")
                lines.append("    _f = _e.add_face(_r3d)")
                lines.append("    _f.pushpull(_line.length) if _f")
                lines.append("  end")
                lines.append(f'  _g.layer = layers["STRUCT-Beams"]')
                lines.append(f'  _g.material = _mat("{bm}")')
                lines.append("rescue => e")
                lines.append(f'  puts "SKIP {mark}: #{{e.message}}"')
                lines.append("end")
                lines.append("")
        
        # Walls
        walls = floor.get("walls", [])
        if walls:
            lines.append(f"# Walls ({len(walls)})")
            for wall in walls:
                mark = wall.get("mark", wall.get("id", f"W{walls.index(wall)+1}"))
                x1 = wall.get("x1", wall.get("x_mm", 0))
                y1 = wall.get("y1", wall.get("y_mm", 0))
                x2 = wall.get("x2", wall.get("x2_mm", 0))
                y2 = wall.get("y2", wall.get("y2_mm", 3000))
                th = wall.get("thickness_mm", wall.get("thickness", 200))
                wz_start = wall.get("z_start_mm", z_start)
                wz_end = wall.get("z_end_mm", z_end)
                import math
                dx_w = float(x2) - float(x1)
                dy_w = float(y2) - float(y1)
                ll_w = math.sqrt(dx_w*dx_w + dy_w*dy_w) or 1.0
                nx, ny = -dy_w/ll_w, dx_w/ll_w
                ox, oy = nx * float(th), ny * float(th)
                lines.append(f"# {mark} | ({x1},{y1})->({x2},{y2}) | th={th}mm")
                lines.append("begin")
                lines.append("  _g = ents.add_group; _e = _g.entities")
                lines.append(f"  _p1 = Geom::Point3d.new({x1}.mm, {y1}.mm, {wz_start}.mm)")
                lines.append(f"  _p2 = Geom::Point3d.new({x2}.mm, {y2}.mm, {wz_start}.mm)")
                lines.append(f"  _p3 = Geom::Point3d.new({x2+ox}.mm, {y2+oy}.mm, {wz_start}.mm)")
                lines.append(f"  _p4 = Geom::Point3d.new({x1+ox}.mm, {y1+oy}.mm, {wz_start}.mm)")
                lines.append("  _f = _e.add_face(_p1, _p2, _p3, _p4)")
                lines.append(f"  _f.pushpull({wz_end - wz_start}.mm) if _f")
                lines.append(f'  _g.layer = layers["ARCH-Walls"]')
                lines.append(f'  _g.material = _mat("Concrete")')
                lines.append("rescue => e")
                lines.append(f'  puts "SKIP {mark}: #{{e.message}}"')
                lines.append("end")
                lines.append("")
        
        # Doors
        doors = floor.get("arch_doors", [])
        if doors:
            for door in doors:
                mark = door.get("mark", door.get("id", "D1"))
                pos = door.get("position", door.get("position_mm", {"x": 0, "y": 0}))
                if isinstance(pos, dict):
                    px, py = pos.get("x", 0), pos.get("y", 0)
                else:
                    px, py = 0, 0
                w = door.get("width_mm", 900)
                h = door.get("height_mm", 2100)
                lines.append(f"# {mark} | door | {w}x{h}mm")
                lines.append("begin")
                lines.append("  _g = ents.add_group; _e = _g.entities")
                lines.append(f"  _p1 = Geom::Point3d.new({px}.mm, {py}.mm, {z_start}.mm)")
                lines.append(f"  _p2 = Geom::Point3d.new({px+w}.mm, {py}.mm, {z_start}.mm)")
                lines.append(f"  _p3 = Geom::Point3d.new({px+w}.mm, {py}.mm, {z_start+h}.mm)")
                lines.append(f"  _p4 = Geom::Point3d.new({px}.mm, {py}.mm, {z_start+h}.mm)")
                lines.append("  _f = _e.add_face(_p1, _p2, _p3, _p4)")
                lines.append("  _f.pushpull(-100.mm) if _f")
                lines.append(f'  _g.layer = layers["ARCH-Doors"]')
                lines.append(f'  _g.material = _mat("Wood")')
                lines.append("rescue => e")
                lines.append(f'  puts "SKIP {mark}: #{{e.message}}"')
                lines.append("end")
                lines.append("")
        
        # Windows
        windows = floor.get("arch_windows", [])
        if windows:
            for wnd in windows:
                mark = wnd.get("mark", wnd.get("id", "W1"))
                pos = wnd.get("position", wnd.get("position_mm", None))
                if isinstance(pos, dict):
                    px, py = pos.get("x", 0), pos.get("y", 0)
                else:
                    px = wnd.get("x_mm", 0)
                    py = wnd.get("y_mm", 0)
                w = wnd.get("width_mm", 2000)
                h = wnd.get("height_mm", 1500)
                sill = wnd.get("sill_height_mm", 900)
                wz = z_start + sill
                lines.append(f"# {mark} | window | {w}x{h}mm | sill={sill}")
                lines.append("begin")
                lines.append("  _g = ents.add_group; _e = _g.entities")
                lines.append(f"  _p1 = Geom::Point3d.new({px}.mm, {py}.mm, {wz}.mm)")
                lines.append(f"  _p2 = Geom::Point3d.new({px+w}.mm, {py}.mm, {wz}.mm)")
                lines.append(f"  _p3 = Geom::Point3d.new({px+w}.mm, {py}.mm, {wz+h}.mm)")
                lines.append(f"  _p4 = Geom::Point3d.new({px}.mm, {py}.mm, {wz+h}.mm)")
                lines.append("  _f = _e.add_face(_p1, _p2, _p3, _p4)")
                lines.append("  _f.pushpull(-100.mm) if _f")
                lines.append(f'  _g.layer = layers["ARCH-Windows"]')
                lines.append('  _g.material = _mat("Glass")')
                lines.append("rescue => e")
                lines.append(f'  puts "SKIP {mark}: #{{e.message}}"')
                lines.append("end")
                lines.append("")
        
        # Stairs
        stairs = floor.get("arch_stairs", [])
        if stairs:
            for st in stairs:
                mark = st.get("mark", st.get("id", "ST1"))
                pos = st.get("position", st.get("position_mm", None))
                if isinstance(pos, dict):
                    px, py = pos.get("x", 0), pos.get("y", 0)
                else:
                    px = st.get("x_mm", 0)
                    py = st.get("y_mm", 0)
                width = st.get("width_mm", 1000)
                n_steps = st.get("num_risers", st.get("num_steps", 16))
                rise = st.get("riser_mm", st.get("rise_total_mm", 3500) / max(n_steps, 1))
                run = st.get("tread_mm", st.get("run_total_mm", 4000) / max(n_steps, 1))
                sz_start = z_start
                lines.append(f"# {mark} | stair | {n_steps} steps | w={width}mm")
                lines.append("begin")
                lines.append("  _g = ents.add_group; _e = _g.entities")
                for s in range(min(n_steps, 30)):
                    sz = sz_start + s * rise
                    sy = py + s * run
                    lines.append(f"  _p1 = Geom::Point3d.new({px}.mm, {sy}.mm, {sz}.mm)")
                    lines.append(f"  _p2 = Geom::Point3d.new({px+width}.mm, {sy}.mm, {sz}.mm)")
                    lines.append(f"  _p3 = Geom::Point3d.new({px+width}.mm, {sy+run}.mm, {sz}.mm)")
                    lines.append(f"  _p4 = Geom::Point3d.new({px}.mm, {sy+run}.mm, {sz}.mm)")
                    lines.append("  _f = _e.add_face(_p1, _p2, _p3, _p4)")
                    lines.append(f"  _f.pushpull({rise}.mm) if _f")
                lines.append(f'  _g.layer = layers["ARCH-Stairs"]')
                lines.append('  _g.material = _mat("Concrete")')
                lines.append("rescue => e")
                lines.append(f'  puts "SKIP {mark}: #{{e.message}}"')
                lines.append("end")
                lines.append("")
    
    # Roof
    roof = model.get("roof", {})
    if roof:
        outline = model.get("building_outline", {})
        w = outline.get("overall_width_mm", 12000)
        d = outline.get("overall_depth_mm", 10000)
        rtype = roof.get("type", "flat")
        eaves_z = roof.get("eaves_z_mm", model.get("total_height_mm", 3500))
        ridge_z = roof.get("ridge_z_mm", eaves_z + 2000)
        lines.append(f"# ── Roof ({rtype}) ──")
        lines.append("begin")
        lines.append("  _g = ents.add_group; _e = _g.entities")
        if rtype in ("gable", "hip"):
            lines.append(f"  _p1 = Geom::Point3d.new(0, 0, {eaves_z}.mm)")
            lines.append(f"  _p2 = Geom::Point3d.new({w}.mm, 0, {eaves_z}.mm)")
            lines.append(f"  _p3 = Geom::Point3d.new({w/2}.mm, {d/2}.mm, {ridge_z}.mm)")
            lines.append("  _e.add_face(_p1, _p2, _p3)")
        else:
            lines.append(f"  _p1 = Geom::Point3d.new(0, 0, {eaves_z}.mm)")
            lines.append(f"  _p2 = Geom::Point3d.new({w}.mm, 0, {eaves_z}.mm)")
            lines.append(f"  _p3 = Geom::Point3d.new({w}.mm, {d}.mm, {eaves_z}.mm)")
            lines.append(f"  _p4 = Geom::Point3d.new(0, {d}.mm, {eaves_z}.mm)")
            lines.append("  _f = _e.add_face(_p1, _p2, _p3, _p4)")
            lines.append("  _f.pushpull(200.mm) if _f")
        lines.append(f'  _g.layer = layers["ARCH-Roof"]')
        lines.append("rescue => e")
        lines.append('  puts "SKIP roof: #{e.message}"')
        lines.append("end")
        lines.append("")
    
    # Footer
    lines.append("# ── Finalize ──")
    lines.append("model.commit_operation")
    lines.append('puts "LOD300 V5 Model import complete."')
    lines.append("")
    
    total_cols = sum(len(f.get("columns", [])) for f in floors)
    total_beams = sum(len(f.get("beams", [])) for f in floors)
    total_walls = sum(len(f.get("walls", [])) for f in floors)
    total_doors = sum(len(f.get("arch_doors", [])) for f in floors)
    total_wins = sum(len(f.get("arch_windows", [])) for f in floors)
    total_stairs = sum(len(f.get("arch_stairs", [])) for f in floors)
    
    lines.append(f'puts "  Floors: {len(floors)}"')
    lines.append(f'puts "  Columns: {total_cols}"')
    lines.append(f'puts "  Beams: {total_beams}"')
    lines.append(f'puts "  Walls: {total_walls}"')
    lines.append(f'puts "  Doors: {total_doors}"')
    lines.append(f'puts "  Windows: {total_wins}"')
    lines.append(f'puts "  Stairs: {total_stairs}"')
    total = total_cols + total_beams + total_walls + total_doors + total_wins + total_stairs
    lines.append(f'puts "  Total: {total} elements"')
    lines.append('puts "  Pipeline: V5 Vision-First"')
    
    return "\n".join(lines)


# ═══════════════════════════════════════════════════════════════════════════════
# CLI ENTRYPOINT
# ═══════════════════════════════════════════════════════════════════════════════

if __name__ == "__main__":
    import argparse
    
    parser = argparse.ArgumentParser(description="Pipeline V5 — PDF to SketchUp LOD300")
    parser.add_argument("pdf", help="Path to PDF file")
    parser.add_argument("-o", "--output", default="lod300_v5", help="Output name prefix")
    parser.add_argument("--dpi", type=int, default=300, help="Render DPI (default: 300)")
    parser.add_argument("--strategy", choices=["structural", "architectural", "mixed"],
                        help="Force PDF type strategy")
    
    args = parser.parse_args()
    
    result = run_pipeline_v5(
        args.pdf,
        output_name=args.output,
        dpi=args.dpi,
        force_strategy=args.strategy,
    )
    
    print(f"\n✓ Pipeline complete. Ruby script: {result['ruby_path']}")