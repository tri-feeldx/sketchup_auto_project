"""Phase 1 test: Scale + Grid + Levels + Generate Ruby model"""
import sys
sys.path.insert(0, '.')

from core.pdf_structured_parser import PDFStructuredParser
from agents.grid_math_engine import GridMathEngine, build_grid_from_structured_pages
from pipeline_phase3 import build_per_floor_layouts, generate_ruby_phase3, parse_schedule_tables

def main():
    pdf_path = 'data/input_pdf/structural.pdf'
    output_rb = 'output/final_ruby_scripts/phase1_model.rb'
    
    print("=" * 60)
    print("PHASE 1: Scale Fix + Grid + Generate Model")
    print("=" * 60)
    
    # 1. Parse PDF
    parser = PDFStructuredParser(pdf_path)
    pages = parser.parse_all()
    plan_pages = [p for p in pages if p.page_type == "plan"]
    print(f"\nPages: {len(pages)} total ({len(plan_pages)} plan, {len([p for p in pages if p.page_type in ('elevation','section')])} elev/section, {len([p for p in pages if p.page_type == 'schedule'])} schedule)")
    
    # 2. Build grid system
    engine = GridMathEngine(pages)
    gs = engine.build()
    print(f"\nScale: X={gs.scale_x:.2f} Y={gs.scale_y:.2f} mm/pt")
    print(f"Grid X ({len(gs.grids_x)} lines): {gs.grids_x}")
    print(f"Grid Y ({len(gs.grids_y)} lines): {gs.grids_y}")
    print(f"Levels ({len(gs.levels)}):")
    for lm in gs.levels:
        print(f"  {lm.name}: z={lm.z_mm:.0f}mm")
    
    # 3. Check scale text
    for page in pages:
        if page.scale_text:
            print(f"\nScale text found on page {page.page_index}: '{page.scale_text}'")
    
    # 4. Build floor layouts
    print("\n--- Building floor layouts ---")
    layouts = build_per_floor_layouts(parser, gs, {})
    print(f"Floor layouts: {len(layouts)}")
    for fl in layouts:
        print(f"  Floor {fl.floor_index} '{fl.floor_name}': z={fl.z_bottom_mm:.0f}-{fl.z_top_mm:.0f}mm, columns={len(fl.columns)}, beams={len(fl.beams)}, walls={len(fl.walls)}")
    
    # 5. Parse member database from schedules
    print("\n[5] Parsing member database from schedules...")
    member_db = parse_schedule_tables(parser)
    print(f"  Found {len(member_db)} member specs in schedule tables")
    
    # 6. Generate Ruby script
    print(f"\n--- Generating Ruby script: {output_rb} ---")
    n_cols, n_beams = generate_ruby_phase3(layouts, member_db, gs, output_rb)
    import os
    file_size = os.path.getsize(output_rb) if os.path.exists(output_rb) else 0
    print(f"Generated: {n_cols} columns, {n_beams} beams across {len(layouts)} floors ({file_size/1024:.1f} KB)")
    print("DONE! Open SketchUp -> Ruby Console -> Load this file")
    
if __name__ == '__main__':
    main()