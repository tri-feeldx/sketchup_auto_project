import sys
from core.pdf_structured_parser import PDFStructuredParser
from agents.grid_math_engine import GridMathEngine

PDF = "data/input_pdf/structural.pdf"
print("Parsing PDF...")
parser = PDFStructuredParser(PDF)
pages = parser.parse_all()

print(f"\nTotal pages: {len(pages)}")
print(f"{'Idx':>4} {'Type':<12} {'#Lines':>8} {'#Grid':>6} {'#Text':>6} {'Title'}")
print("-" * 80)

type_counts = {}
for p in pages:
    type_counts[p.page_type] = type_counts.get(p.page_type, 0) + 1
    title = p.drawing_title or ""
    if len(title) > 40:
        title = title[:40] + "..."
    print(f"{p.page_index:>4} {p.page_type:<12} {len(p.raw_lines):>8} {len(p.grid_labels):>6} {len(p.all_text):>6} {title}")

print(f"\n--- SUMMARY ---")
for t, c in sorted(type_counts.items()):
    print(f"  {t}: {c} pages")

# Grid
print("\n--- GRID ---")
grid_engine = GridMathEngine(pages)
grid_system = grid_engine.build()
print(f"  X-axis grids: {len(grid_system.grids_x)}")
print(f"  Y-axis grids: {len(grid_system.grids_y)}")
print(f"  Levels: {len(grid_system.levels)}")
for lvl in grid_system.levels:
    print(f"    {lvl.name}: Z={lvl.z_mm:.0f}")