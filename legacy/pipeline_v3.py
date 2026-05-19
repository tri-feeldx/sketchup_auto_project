"""
=============================================================================
PIPELINE V3 — Vision LLM Structural Pipeline
=============================================================================
PDF → Pass 1 (Scanner) → Pass 2 (Extractor) → Pass 3 (Ruby Generator) → .rb

Revolution over V1/V2:
  - Pass 1: Gemini 2.5 Flash scans ALL pages at once → BuildingManifest
  - Pass 2: Vision LLM extracts members per plan page → BuildingModel
  - Pass 3: Pure template Ruby generation (zero LLM) → .rb file

This eliminates ALL brittle regex/pixel-parsing from V1/V2.
=============================================================================
"""

import json
import sys
import time
from pathlib import Path

# Add project root to path
sys.path.insert(0, str(Path(__file__).parent))

from config import OUTPUT_JSON_DIR, RUBY_OUTPUT_DIR
from agents.structural_scanner import StructuralScanner, BuildingManifest
from agents.structural_extractor import StructuralExtractor, BuildingModel
from agents.ruby_generator_v3 import RubyGeneratorV3


def run_pipeline(pdf_path: str, output_name: str = "lod300_v3") -> dict:
    """
    Execute complete V3 pipeline.
    
    Args:
        pdf_path: Path to structural PDF
        output_name: Base name for output files
        
    Returns:
        dict with paths and stats
    """
    start_time = time.time()
    pdf_path = Path(pdf_path)
    
    print("\n" + "=" * 70)
    print("SKETCHUP AUTO PIPELINE V3 — Vision LLM Architecture")
    print("=" * 70)
    print(f"PDF: {pdf_path.name}")
    print(f"Output: {output_name}")
    print("=" * 70)
    
    # ═══════════════════════════════════════════════════════════════
    # PASS 1: SCAN — Vision LLM analyzes ALL pages
    # ═══════════════════════════════════════════════════════════════
    scanner = StructuralScanner(pdf_path)
    manifest = scanner.scan()
    
    # Save manifest
    manifest_path = Path(OUTPUT_JSON_DIR) / f"{output_name}_manifest.json"
    manifest_path.parent.mkdir(parents=True, exist_ok=True)
    manifest_path.write_text(
        json.dumps(manifest.to_dict(), indent=2, ensure_ascii=False),
        encoding="utf-8"
    )
    print(f"\n  💾 Manifest saved: {manifest_path}")
    
    # Validate manifest
    errors = validate_manifest(manifest)
    if errors:
        print(f"\n  ⚠ Manifest validation warnings:")
        for e in errors:
            print(f"      - {e}")
    
    # ═══════════════════════════════════════════════════════════════
    # PASS 2: EXTRACT — Per-page member extraction
    # ═══════════════════════════════════════════════════════════════
    extractor = StructuralExtractor(manifest, pdf_path)
    model = extractor.extract_all_floors()
    
    # Save model
    model_path = Path(OUTPUT_JSON_DIR) / f"{output_name}_model.json"
    model_path.write_text(
        json.dumps(model.to_dict(), indent=2, ensure_ascii=False),
        encoding="utf-8"
    )
    print(f"\n  💾 Model saved: {model_path}")
    
    # ═══════════════════════════════════════════════════════════════
    # PASS 3: GENERATE — Pure template Ruby code
    # ═══════════════════════════════════════════════════════════════
    generator = RubyGeneratorV3(model)
    ruby_path = Path(RUBY_OUTPUT_DIR) / f"{output_name}.rb"
    ruby_path.parent.mkdir(parents=True, exist_ok=True)
    generator.save(ruby_path)
    
    # ═══════════════════════════════════════════════════════════════
    # SUMMARY
    # ═══════════════════════════════════════════════════════════════
    elapsed = time.time() - start_time
    total_members = sum(
        len(f.columns) + len(f.beams) + len(f.walls) + len(f.braces)
        for f in model.floors
    )
    
    print(f"\n{'=' * 70}")
    print(f"PIPELINE V3 COMPLETE — {elapsed:.1f}s")
    print(f"{'=' * 70}")
    print(f"  Building: {manifest.building_name}")
    print(f"  Type: {manifest.building_type}")
    print(f"  Floors: {len(model.floors)}")
    print(f"  Total members: {total_members}")
    print(f"    - Columns: {sum(len(f.columns) for f in model.floors)}")
    print(f"    - Beams:   {sum(len(f.beams) for f in model.floors)}")
    print(f"    - Walls:   {sum(len(f.walls) for f in model.floors)}")
    print(f"    - Braces:  {sum(len(f.braces) for f in model.floors)}")
    print(f"  Grid: {len(manifest.grid_x.labels)}x{len(manifest.grid_y.labels)}")
    print(f"  Member DB entries: {len(manifest.member_db)}")
    print(f"  Ruby output: {ruby_path}")
    print(f"  Ruby size: {ruby_path.stat().st_size:,} bytes")
    print(f"{'=' * 70}")
    
    return {
        "success": True,
        "elapsed_s": elapsed,
        "manifest_path": str(manifest_path),
        "model_path": str(model_path),
        "ruby_path": str(ruby_path),
        "total_members": total_members,
        "num_floors": len(model.floors),
        "grid_size": f"{len(manifest.grid_x.labels)}x{len(manifest.grid_y.labels)}",
        "member_db_size": len(manifest.member_db),
    }


def validate_manifest(manifest: BuildingManifest) -> list[str]:
    """Validate manifest completeness."""
    errors = []
    
    if not manifest.grid_x.labels:
        errors.append("No grid X labels found — plans may be missing")
    if not manifest.grid_y.labels:
        errors.append("No grid Y labels found — plans may be missing")
    if not manifest.levels:
        errors.append("No levels extracted — check elevation pages")
    if not manifest.plan_page_indices:
        errors.append("No plan pages identified — check page classification")
    if manifest.scale_confidence < 0.3:
        errors.append(f"Low scale confidence ({manifest.scale_confidence:.0%}) — verify dimensions")
    if len(manifest.grid_x.labels) < 2:
        errors.append("Grid X has <2 lines — insufficient for building")
    if len(manifest.grid_y.labels) < 2:
        errors.append("Grid Y has <2 lines — insufficient for building")
    
    return errors


# ═══════════════════════════════════════════════════════════════════
# CLI Entry Point
# ═══════════════════════════════════════════════════════════════════

if __name__ == "__main__":
    import argparse
    
    parser = argparse.ArgumentParser(description="Pipeline V3 — Vision LLM PDF to SketchUp")
    parser.add_argument("pdf", help="Path to structural PDF file")
    parser.add_argument("--name", "-n", default="lod300_v3", help="Output name prefix")
    parser.add_argument("--skip-cache", action="store_true", help="Skip LLM cache")
    
    args = parser.parse_args()
    
    if args.skip_cache:
        from config import LLM_CACHE_ENABLED
        # We can't easily toggle at runtime, but we can warn
        print("Note: Cache is enabled by default. Set LLM_CACHE_ENABLED=False in config.py to disable.")
    
    result = run_pipeline(args.pdf, args.name)
    
    if result["success"]:
        print(f"\n✅ Done! Ruby script ready at: {result['ruby_path']}")
        print(f"   Open SketchUp → Window → Ruby Console → Load this file.")
    else:
        print(f"\n❌ Pipeline failed")
        sys.exit(1)