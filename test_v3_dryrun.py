"""Dry-run test for Pipeline V3 — generate minimal Ruby without LLM."""
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))

from agents.structural_scanner import BuildingManifest, GridAxis, LevelDef, MemberSpec
from agents.structural_extractor import BuildingModel, FloorLayout, StructuralMember
from agents.ruby_generator_v3 import RubyGeneratorV3

def main():
    print("=== Building test manifest ===")
    manifest = BuildingManifest(
        building_name='Test_Building',
        building_type='multi-storey',
        num_floors=2,
        total_height_mm=7000,
        scale_x_mm_per_px=3.0,
        scale_y_mm_per_px=3.0,
        scale_confidence=0.6,
        grid_x=GridAxis(labels=['A','B','C'], spacings_mm=[6000,6000], total_span_mm=12000),
        grid_y=GridAxis(labels=['1','2','3','4'], spacings_mm=[6000,6000,6000], total_span_mm=18000),
        levels=[
            LevelDef(name='Base', elevation_mm=0, plan_page_index=0, floor_height_mm=3500),
            LevelDef(name='FL1', elevation_mm=3500, plan_page_index=0, floor_height_mm=3500),
        ],
        plan_page_indices=[0],
        member_db=[
            MemberSpec(mark='C1', member_type='column', section_label='UC203x203x46',
                       dimensions={'depth_mm':203,'width_mm':203}, material='Steel'),
            MemberSpec(mark='B1', member_type='beam', section_label='UB305x165x40',
                       dimensions={'depth_mm':303,'width_mm':165}, material='Steel'),
        ],
    )

    print("=== Building floors ===")
    floors = []
    for lvl in manifest.levels:
        f = FloorLayout(level_name=lvl.name, elevation_z_mm=lvl.elevation_mm,
                        floor_height_mm=lvl.floor_height_mm, page_index=0)
        # Columns at 4 corners
        for gx, gy in [(0,0),(0,3),(2,0),(2,3)]:
            f.columns.append(StructuralMember(
                mark=f'C_{manifest.grid_x.labels[gx]}{manifest.grid_y.labels[gy]}',
                member_type='column',
                grid_x=gx, grid_y=gy,
                x_mm=gx*6000.0, y_mm=gy*6000.0,
                z_start_mm=lvl.elevation_mm,
                z_end_mm=lvl.elevation_mm + lvl.floor_height_mm,
                section_label='UC203x203x46', material='Steel',
                dimensions={'depth_mm':203,'width_mm':203}, confidence=0.85
            ))
        # Beams along grid 1
        for gy in range(3):
            f.beams.append(StructuralMember(
                mark=f'B_G1_{gy}',
                member_type='beam',
                grid_x=0, grid_y=gy, grid_x2=0, grid_y2=gy+1,
                x_mm=0, y_mm=gy*6000.0, x2_mm=0, y2_mm=(gy+1)*6000.0,
                z_start_mm=lvl.elevation_mm, z_end_mm=lvl.elevation_mm,
                section_label='UB305x165x40', material='Steel',
                dimensions={'depth_mm':303,'width_mm':165},
                length_mm=6000, confidence=0.8
            ))
        floors.append(f)

    model = BuildingModel(manifest=manifest, floors=floors)
    print(f"  Floors: {len(model.floors)}")
    for f in model.floors:
        print(f"    {f.level_name}: {len(f.columns)} cols, {len(f.beams)} beams")

    print("\n=== Generating Ruby ===")
    gen = RubyGeneratorV3(model)
    code = gen.generate()
    print(f"  Generated {len(code)} chars, {code.count(chr(10))} lines")

    out = Path('output/final_ruby_scripts/lod300_v3_test.rb')
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(code, encoding='utf-8')
    print(f"  Saved: {out} ({out.stat().st_size} bytes)")

    # Verify key patterns
    checks = {
        'model = Sketchup': 1,
        'STR-Columns': 8,  # 2 floors × 4 cols
        'STR-Beams': 6,    # 2 floors × 3 beams
        'UC203x203': 8,
        'UB305x165': 6,
        'pushpull': 14,    # per member
        'IFC': 28,         # 3 per member × (8+6)
    }
    print("\n=== Verification ===")
    all_ok = True
    for pat, expected in checks.items():
        actual = code.count(pat)
        status = "OK" if actual == expected else f"MISMATCH (got {actual})"
        if actual != expected:
            all_ok = False
        print(f"  {pat}: {status}")

    if all_ok:
        print("\n*** ALL CHECKS PASSED ***")
    else:
        print("\n*** SOME CHECKS FAILED ***")

    # Print first 50 lines
    print("\n=== First 60 lines of output ===")
    for i, line in enumerate(code.split('\n')[:60]):
        print(f"  {i+1:3d}: {line}")

if __name__ == '__main__':
    main()