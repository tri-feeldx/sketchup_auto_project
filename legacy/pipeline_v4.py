"""
=============================================================================
PIPELINE V4 — Adaptive Architecture Pipeline
=============================================================================
Phase 0: PDF Classifier → xác định loại bản vẽ
Phase 1: Scanner V4 → prompt thích ứng theo loại PDF
Phase 2: Extractor V4 → dual-mode (grid + gridless)
Phase 3: Ruby Generator V4 → unified structural + architectural .rb

Khắc phục triệt để vấn đề "chỉ giống 1%" của V3:
  - Gridless extraction cho bản vẽ kiến trúc không có grid system
  - Architectural elements (doors, windows, stairs, slabs, roof)
  - PDF type auto-detection → chọn strategy phù hợp
=============================================================================
"""

import json
import sys
import time
from pathlib import Path
from typing import Optional

sys.path.insert(0, str(Path(__file__).parent))

from config import OUTPUT_JSON_DIR, RUBY_OUTPUT_DIR


def run_pipeline_v4(
    pdf_path: str,
    output_name: str = "lod300_v4",
    force_strategy: Optional[str] = None,
) -> dict:
    """
    Execute complete V4 Adaptive pipeline.

    Args:
        pdf_path: Path to PDF file (structural, architectural, or mixed)
        output_name: Base name for output files
        force_strategy: Override auto-detection: "structural", "architectural", "mixed"

    Returns:
        dict with paths, stats, and test .rb content
    """
    start_time = time.time()
    pdf_path = Path(pdf_path)

    print("\n" + "=" * 70)
    print("SKETCHUP AUTO PIPELINE V4 - Adaptive Architecture")
    print("=" * 70)
    print(f"PDF: {pdf_path.name}")
    print(f"Output: {output_name}")
    print("=" * 70)

    # ═══════════════════════════════════════════════════════════════
    # PHASE 0: PDF CLASSIFICATION
    # ═══════════════════════════════════════════════════════════════
    print("\n-- Phase 0: PDF Classification --")
    
    from agents.pdf_classifier import classify_pdf
    
    if force_strategy:
        pdf_type = force_strategy
        classification = {"pdf_type": pdf_type, "strategy": force_strategy, "auto_detected": False}
        print(f"  Strategy forced: {pdf_type}")
    else:
        classification = classify_pdf(str(pdf_path))
        pdf_type = classification["pdf_type"]
        print(f"  Detected: {pdf_type} | Features: {classification.get('features', [])}")
    
    # Save classification
    class_path = Path(OUTPUT_JSON_DIR) / f"{output_name}_classification.json"
    class_path.parent.mkdir(parents=True, exist_ok=True)
    class_path.write_text(json.dumps(classification, indent=2, ensure_ascii=False), encoding="utf-8")

    # ═══════════════════════════════════════════════════════════════
    # PHASE 1: SCANNER V4
    # ═══════════════════════════════════════════════════════════════
    print("\n-- Phase 1: Scanner V4 --")
    
    from agents.scanner_v4 import scan_pdf_v4
    
    manifest = scan_pdf_v4(str(pdf_path), pdf_type, classification)
    
    manifest_path = Path(OUTPUT_JSON_DIR) / f"{output_name}_manifest.json"
    manifest_path.write_text(
        json.dumps(manifest, indent=2, ensure_ascii=False),
        encoding="utf-8"
    )
    print(f"  [SAVE] Manifest saved: {manifest_path}")

    # ═══════════════════════════════════════════════════════════════
    # PHASE 2: EXTRACTOR V4
    # ═══════════════════════════════════════════════════════════════
    print("\n-- Phase 2: Extractor V4 --")
    
    from agents.extractor_v4 import extract_all_v4
    
    model = extract_all_v4(str(pdf_path), manifest, pdf_type, classification)
    
    model_path = Path(OUTPUT_JSON_DIR) / f"{output_name}_model.json"
    model_path.parent.mkdir(parents=True, exist_ok=True)
    model_path.write_text(
        json.dumps(model, indent=2, ensure_ascii=False),
        encoding="utf-8"
    )
    print(f"  [SAVE] Model saved: {model_path}")

    # ═══════════════════════════════════════════════════════════════
    # PHASE 3: RUBY GENERATOR V4
    # ═══════════════════════════════════════════════════════════════
    print("\n-- Phase 3: Ruby Generator V4 --")
    
    from agents.ruby_generator_v4 import generate_ruby_v4
    
    ruby_code = generate_ruby_v4(model, manifest)
    
    ruby_path = Path(RUBY_OUTPUT_DIR) / f"{output_name}.rb"
    ruby_path.parent.mkdir(parents=True, exist_ok=True)
    ruby_path.write_text(ruby_code, encoding="utf-8")
    print(f"  [SAVE] Ruby saved: {ruby_path} ({len(ruby_code):,} bytes)")

    # ═══════════════════════════════════════════════════════════════
    # SUMMARY
    # ═══════════════════════════════════════════════════════════════
    elapsed = time.time() - start_time
    
    # Count members
    total_structural = sum(
        len(f.get("columns", [])) + len(f.get("beams", [])) + 
        len(f.get("walls", [])) + len(f.get("braces", []))
        for f in model.get("floors", [])
    )
    total_arch = sum(
        len(f.get("arch_doors", [])) + len(f.get("arch_windows", [])) + 
        len(f.get("arch_slabs", [])) + len(f.get("arch_stairs", []))
        for f in model.get("floors", [])
    )
    
    print(f"\n{'=' * 70}")
    print(f"PIPELINE V4 COMPLETE — {elapsed:.1f}s")
    print(f"{'=' * 70}")
    print(f"  PDF Type: {pdf_type}")
    print(f"  Strategy: {classification.get('strategy', 'unknown')}")
    print(f"  Floors: {len(model.get('floors', []))}")
    print(f"  Structural members: {total_structural}")
    print(f"  Architectural elements: {total_arch}")
    print(f"  Total: {total_structural + total_arch}")
    print(f"  Ruby output: {ruby_path}")
    print(f"  Ruby size: {ruby_path.stat().st_size:,} bytes")
    print(f"{'=' * 70}")

    return {
        "success": True,
        "elapsed_s": elapsed,
        "pdf_type": pdf_type,
        "strategy": classification.get("strategy", "unknown"),
        "classification_path": str(class_path),
        "manifest_path": str(manifest_path),
        "model_path": str(model_path),
        "ruby_path": str(ruby_path),
        "ruby_code": ruby_code,
        "total_members": total_structural + total_arch,
        "num_floors": len(model.get("floors", [])),
    }


# ═══════════════════════════════════════════════════════════════════
# TEST MODE: Generate sample .rb from mock data
# ═══════════════════════════════════════════════════════════════════

def generate_test_rb(output_name: str = "test_v4_sample") -> str:
    """
    Generate a test .rb file with sample building data.
    No LLM calls — pure template output for immediate testing.
    """
    from agents.ruby_generator_v4 import generate_ruby_v4
    
    # Mock manifest
    manifest = {
        "building_name": "Test Building V4",
        "building_type": "mixed_use",
        "num_floors": 2,
        "total_height_mm": 7000,
        "grid_x": {"labels": ["1", "2", "3"], "spacings_mm": [6000, 6000]},
        "grid_y": {"labels": ["A", "B", "C"], "spacings_mm": [5000, 5000]},
        "scale_x_mm_per_px": 3.0,
        "member_db": {},
        "levels": [
            {"name": "Ground Floor", "elevation_mm": 0, "floor_height_mm": 3500, "plan_page_index": 0},
            {"name": "First Floor", "elevation_mm": 3500, "floor_height_mm": 3500, "plan_page_index": 1},
        ],
        "plan_page_indices": [0, 1],
        "scale_confidence": 0.8,
    }
    
    # Mock model with both structural and architectural elements
    model = {
        "floors": [
            {
                "level_name": "Ground Floor",
                "elevation_z_mm": 0,
                "floor_height_mm": 3500,
                "page_index": 0,
                # Structural
                "columns": [
                    {"mark": "C1", "member_type": "column", "grid_x": 0, "grid_y": 0,
                     "x_mm": 0, "y_mm": 0, "z_start_mm": 0, "z_end_mm": 3500,
                     "section_label": "400x400", "material": "Concrete", "confidence": 0.9},
                    {"mark": "C2", "member_type": "column", "grid_x": 2, "grid_y": 0,
                     "x_mm": 12000, "y_mm": 0, "z_start_mm": 0, "z_end_mm": 3500,
                     "section_label": "400x400", "material": "Concrete", "confidence": 0.9},
                    {"mark": "C3", "member_type": "column", "grid_x": 0, "grid_y": 2,
                     "x_mm": 0, "y_mm": 10000, "z_start_mm": 0, "z_end_mm": 3500,
                     "section_label": "400x400", "material": "Concrete", "confidence": 0.85},
                    {"mark": "C4", "member_type": "column", "grid_x": 2, "grid_y": 2,
                     "x_mm": 12000, "y_mm": 10000, "z_start_mm": 0, "z_end_mm": 3500,
                     "section_label": "400x400", "material": "Concrete", "confidence": 0.85},
                ],
                "beams": [
                    {"mark": "B1", "member_type": "beam", "grid_x": 0, "grid_y": 0, "grid_x2": 2, "grid_y2": 0,
                     "x_mm": 0, "y_mm": 0, "x2_mm": 12000, "y2_mm": 0,
                     "z_start_mm": 3100, "z_end_mm": 3500,
                     "section_label": "UB305x165x40", "material": "Steel", "length_mm": 12000, "confidence": 0.85},
                    {"mark": "B2", "member_type": "beam", "grid_x": 0, "grid_y": 2, "grid_x2": 2, "grid_y2": 2,
                     "x_mm": 0, "y_mm": 10000, "x2_mm": 12000, "y2_mm": 10000,
                     "z_start_mm": 3100, "z_end_mm": 3500,
                     "section_label": "UB305x165x40", "material": "Steel", "length_mm": 12000, "confidence": 0.85},
                    {"mark": "B3", "member_type": "beam", "grid_x": 0, "grid_y": 0, "grid_x2": 0, "grid_y2": 2,
                     "x_mm": 0, "y_mm": 0, "x2_mm": 0, "y2_mm": 10000,
                     "z_start_mm": 3100, "z_end_mm": 3500,
                     "section_label": "UB356x171x51", "material": "Steel", "length_mm": 10000, "confidence": 0.85},
                    {"mark": "B4", "member_type": "beam", "grid_x": 2, "grid_y": 0, "grid_x2": 2, "grid_y2": 2,
                     "x_mm": 12000, "y_mm": 0, "x2_mm": 12000, "y2_mm": 10000,
                     "z_start_mm": 3100, "z_end_mm": 3500,
                     "section_label": "UB356x171x51", "material": "Steel", "length_mm": 10000, "confidence": 0.85},
                ],
                "walls": [
                    {"mark": "W1", "member_type": "wall",
                     "x_mm": 0, "y_mm": 0, "x2_mm": 0, "y2_mm": 10000,
                     "z_start_mm": 0, "z_end_mm": 3500,
                     "section_label": "t=200mm", "material": "Concrete",
                     "dimensions": {"thickness": 200}, "length_mm": 10000, "confidence": 0.8},
                    {"mark": "W2", "member_type": "wall",
                     "x_mm": 12000, "y_mm": 0, "x2_mm": 12000, "y2_mm": 10000,
                     "z_start_mm": 0, "z_end_mm": 3500,
                     "section_label": "t=200mm", "material": "Concrete",
                     "dimensions": {"thickness": 200}, "length_mm": 10000, "confidence": 0.8},
                    {"mark": "W3", "member_type": "wall",
                     "x_mm": 0, "y_mm": 10000, "x2_mm": 12000, "y2_mm": 10000,
                     "z_start_mm": 0, "z_end_mm": 3500,
                     "section_label": "t=200mm", "material": "Concrete",
                     "dimensions": {"thickness": 200}, "length_mm": 12000, "confidence": 0.8},
                ],
                "braces": [],
                # Architectural
                "arch_doors": [
                    {"mark": "D1", "type": "single_swing", "width_mm": 900, "height_mm": 2100,
                     "position": {"x": 3000, "y": 0}, "wall_grid_ref": "1/A-B", "confidence": 0.9},
                    {"mark": "D2", "type": "double_swing", "width_mm": 1600, "height_mm": 2100,
                     "position": {"x": 12000, "y": 5000}, "wall_grid_ref": "3/A-B", "confidence": 0.85},
                ],
                "arch_windows": [
                    {"mark": "WIN1", "type": "sliding", "width_mm": 2000, "height_mm": 1500,
                     "sill_height_mm": 900,
                     "position": {"x": 5000, "y": 0}, "wall_grid_ref": "1-2/A", "confidence": 0.85},
                    {"mark": "WIN2", "type": "sliding", "width_mm": 2000, "height_mm": 1500,
                     "sill_height_mm": 900,
                     "position": {"x": 9000, "y": 0}, "wall_grid_ref": "2-3/A", "confidence": 0.85},
                    {"mark": "WIN3", "type": "fixed", "width_mm": 1200, "height_mm": 1200,
                     "sill_height_mm": 1000,
                     "position": {"x": 0, "y": 3000}, "wall_grid_ref": "1/A-B", "confidence": 0.8},
                ],
                "arch_slabs": [
                    {"level_name": "Ground Floor", "thickness_mm": 200, "z_mm": 0,
                     "boundary_points": [[0,0], [12000,0], [12000,10000], [0,10000]]},
                ],
                "arch_stairs": [],
            },
            {
                "level_name": "First Floor",
                "elevation_z_mm": 3500,
                "floor_height_mm": 3500,
                "page_index": 1,
                # Structural
                "columns": [
                    {"mark": "C1", "member_type": "column", "grid_x": 0, "grid_y": 0,
                     "x_mm": 0, "y_mm": 0, "z_start_mm": 3500, "z_end_mm": 7000,
                     "section_label": "400x400", "material": "Concrete", "confidence": 0.9},
                    {"mark": "C2", "member_type": "column", "grid_x": 2, "grid_y": 0,
                     "x_mm": 12000, "y_mm": 0, "z_start_mm": 3500, "z_end_mm": 7000,
                     "section_label": "400x400", "material": "Concrete", "confidence": 0.9},
                    {"mark": "C3", "member_type": "column", "grid_x": 0, "grid_y": 2,
                     "x_mm": 0, "y_mm": 10000, "z_start_mm": 3500, "z_end_mm": 7000,
                     "section_label": "400x400", "material": "Concrete", "confidence": 0.85},
                    {"mark": "C4", "member_type": "column", "grid_x": 2, "grid_y": 2,
                     "x_mm": 12000, "y_mm": 10000, "z_start_mm": 3500, "z_end_mm": 7000,
                     "section_label": "400x400", "material": "Concrete", "confidence": 0.85},
                ],
                "beams": [
                    {"mark": "B5", "member_type": "beam", "grid_x": 0, "grid_y": 0, "grid_x2": 2, "grid_y2": 0,
                     "x_mm": 0, "y_mm": 0, "x2_mm": 12000, "y2_mm": 0,
                     "z_start_mm": 6600, "z_end_mm": 7000,
                     "section_label": "UB305x165x40", "material": "Steel", "length_mm": 12000, "confidence": 0.85},
                    {"mark": "B6", "member_type": "beam", "grid_x": 0, "grid_y": 2, "grid_x2": 2, "grid_y2": 2,
                     "x_mm": 0, "y_mm": 10000, "x2_mm": 12000, "y2_mm": 10000,
                     "z_start_mm": 6600, "z_end_mm": 7000,
                     "section_label": "UB305x165x40", "material": "Steel", "length_mm": 12000, "confidence": 0.85},
                ],
                "walls": [],
                "braces": [],
                # Architectural
                "arch_doors": [
                    {"mark": "D3", "type": "single_swing", "width_mm": 900, "height_mm": 2100,
                     "position": {"x": 6000, "y": 0}, "wall_grid_ref": "1-2/A", "confidence": 0.85},
                ],
                "arch_windows": [
                    {"mark": "WIN4", "type": "sliding", "width_mm": 1800, "height_mm": 1500,
                     "sill_height_mm": 900,
                     "position": {"x": 3000, "y": 10000}, "wall_grid_ref": "1-2/C", "confidence": 0.8},
                ],
                "arch_slabs": [
                    {"level_name": "First Floor", "thickness_mm": 200, "z_mm": 3500,
                     "boundary_points": [[0,0], [12000,0], [12000,10000], [0,10000]]},
                ],
                "arch_stairs": [
                    {"mark": "ST1", "type": "straight", "width_mm": 1000, "rise_mm": 3500,
                     "run_mm": 4000, "num_risers": 20,
                     "position": {"x": 1000, "y": 3000}, "direction": "up", "confidence": 0.85},
                ],
            },
        ],
        "roof": {
            "type": "flat",
            "eaves_z_mm": 7000,
            "ridge_z_mm": 7000,
            "slope_degrees": 0,
        },
        "building_outline": {
            "overall_width_mm": 12000,
            "overall_depth_mm": 10000,
            "overall_height_mm": 7000,
        },
    }

    ruby_code = generate_ruby_v4(model, manifest)

    ruby_path = Path(RUBY_OUTPUT_DIR) / f"{output_name}.rb"
    ruby_path.parent.mkdir(parents=True, exist_ok=True)
    ruby_path.write_text(ruby_code, encoding="utf-8")
    
    print(f"\n[OK] Test .rb generated: {ruby_path} ({len(ruby_code):,} bytes)")
    print(f"   Structural: columns + beams + walls")
    print(f"   Architectural: doors + windows + stairs + slabs + roof")
    print(f"   Open SketchUp -> Window -> Ruby Console -> load '{ruby_path}'")
    
    return str(ruby_path)


# ═══════════════════════════════════════════════════════════════════
# CLI
# ═══════════════════════════════════════════════════════════════════

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="Pipeline V4 — Adaptive PDF to SketchUp")
    parser.add_argument("pdf", nargs="?", help="Path to PDF file (omit for test mode)")
    parser.add_argument("--name", "-n", default="lod300_v4", help="Output name prefix")
    parser.add_argument("--strategy", "-s", choices=["structural", "architectural", "mixed"],
                        help="Force strategy (skip auto-detection)")
    parser.add_argument("--test", action="store_true", help="Generate test .rb with mock data")
    parser.add_argument("--skip-cache", action="store_true", help="Skip LLM cache (for fresh runs)")

    args = parser.parse_args()

    if args.test:
        generate_test_rb(args.name)
    elif args.pdf:
        result = run_pipeline_v4(args.pdf, args.name, force_strategy=args.strategy)
        if result["success"]:
            print(f"\n[OK] Done! Ruby script: {result['ruby_path']}")
        else:
            print(f"\n[FAIL] Pipeline failed")
            sys.exit(1)
    else:
        print("No PDF provided. Running test mode...")
        generate_test_rb(args.name)