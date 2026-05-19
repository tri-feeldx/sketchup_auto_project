import sys
sys.path.insert(0, '.')
from core.pdf_structured_parser import PDFStructuredParser
from agents.grid_math_engine import GridMathEngine

pdf_path = 'data/input_pdf/structural.pdf'
print('Parsing...')
parser = PDFStructuredParser(pdf_path)
pages = parser.parse_all()

# Show grid labels per page
for p in pages:
    if p.page_type == 'plan':
        print(f'Page {p.page_index} ({p.page_type}): grid labels = {[(g.label, g.axis) for g in p.grid_labels]}')

engine = GridMathEngine(pages)
gs = engine.build()

print(f'\nGridX ({len(gs.grids_x)}): {list(gs.grids_x.keys())}')
print(f'GridY ({len(gs.grids_y)}): {list(gs.grids_y.keys())}')
print(f'Levels: {[(l.name, l.z_mm) for l in gs.levels]}')
print(f'Scale: X={gs.scale_x:.3f} Y={gs.scale_y:.3f}')
print(f'Confidence: {gs.confidence:.3f}')
print(f'BBox: {gs.building_bbox_mm}')
print('DONE')