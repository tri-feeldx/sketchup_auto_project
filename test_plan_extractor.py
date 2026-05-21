"""
Standalone test for PlanPageColumnExtractor (Tier 2C).
Loads cached scanner output — no re-scan needed (~30s vs 6 min).

Run from project root:
    python test_plan_extractor.py           # normal
    python test_plan_extractor.py --debug   # print raw LLM response on parse failure
"""
import json
import sys
from pathlib import Path
from collections import Counter

ROOT = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT))

SCANNER_OUTPUT_PATH = ROOT / "output" / "v8" / "Structural_scanner_output.json"
PDF_PATH = ROOT / "Structural.pdf"

# ── 1. Load cached scanner output ────────────────────────────────────────────
print("Loading cached scanner output...")
with open(SCANNER_OUTPUT_PATH, encoding="utf-8") as f:
    scanner_output = json.load(f)

page_results = scanner_output.get("page_results", {})
print(f"Total scanned pages in cache: {len(page_results)}")

plan_pages = [k for k, v in page_results.items()
              if (v or {}).get("page_type") == "PLAN"]

if plan_pages:
    print(f"PLAN pages found: {sorted(plan_pages, key=lambda x: int(x))}")
else:
    print("PLAN pages found: NONE — extractor will skip")
    print("\n  All page types in cache:")
    types = Counter((v or {}).get("page_type", "?") for v in page_results.values())
    for t, n in sorted(types.items()):
        print(f"    {t}: {n}")
    sys.exit(1)

# ── 2. Confirm PDF exists ─────────────────────────────────────────────────────
if not PDF_PATH.exists():
    print(f"\n❌ PDF not found at: {PDF_PATH}")
    print("   Update PDF_PATH in this script to point to Structural.pdf")
    sys.exit(1)

# ── 3. Run the extractor ──────────────────────────────────────────────────────
debug = "--debug" in sys.argv
print(f"\nRunning PlanPageColumnExtractor on {len(plan_pages)} PLAN page(s)"
      f"{' [DEBUG MODE]' if debug else ''}...")
from agents.plan_page_extractor import PlanPageColumnExtractor

extractor = PlanPageColumnExtractor(str(PDF_PATH), region="au", language="en", debug=debug)
positions = extractor.run(scanner_output)

# ── 4. Print results ──────────────────────────────────────────────────────────
print(f"\n{'='*60}")
print(f"RESULT: {len(positions)} column positions extracted")
print('='*60)
if positions:
    for mark in sorted(positions):
        p = positions[mark]
        gx = p.get("grid_label_x", "?")
        gy = p.get("grid_label_y", "?")
        xmm = p.get("grid_x_mm", "?")
        ymm = p.get("grid_y_mm", "?")
        print(f"  {mark:<8} grid({gx},{gy})  ->  x={xmm}mm  y={ymm}mm")
else:
    print("  No positions extracted.")
    print("  Possible causes:")
    print("    - LLM response not valid JSON (check _parse in plan_page_extractor.py)")
    print("    - Column marks not clearly visible on plan pages")
    print("    - PDF rendered at wrong resolution")

# ── 5. Verdict ────────────────────────────────────────────────────────────────
print(f"\n{'='*60}")
EXPECTED = 44
found = len(positions)
if found >= EXPECTED * 0.8:
    print(f"PASS -- {found} positions extracted (expected ~{EXPECTED})")
    print("   Tier 2C is working. Run full pipeline to verify enrichment.")
elif found > 0:
    print(f"PARTIAL -- {found}/{EXPECTED} columns found.")
    print("   Check if all PLAN pages were read and scale is correct.")
else:
    print(f"FAIL -- 0 positions.")
    if not debug:
        print("   Tip: run with --debug to see raw LLM response")
