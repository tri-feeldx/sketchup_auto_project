"""Debug script: dump page tokens from structural.pdf"""
import sys
sys.path.insert(0, '.')
from core.pdf_structured_parser import PDFStructuredParser

pdf_path = 'data/input_pdf/structural.pdf'
parser = PDFStructuredParser(pdf_path)
pages = parser.parse_all()

plan_pages = [p for p in pages if p.page_type == 'plan']
print(f'Plan pages: {len(plan_pages)}')

for p in plan_pages:
    print(f'\n=== PAGE {p.page_index} ({p.page_width}x{p.page_height}) tokens={len(p.all_text)} ===')
    for t in sorted(p.all_text, key=lambda t: (t.cy, t.cx)):
        border = ''
        if t.cy < p.page_height * 0.15:
            border = 'TOP'
        elif t.cy > p.page_height * 0.85:
            border = 'BOT'
        if t.cx < p.page_width * 0.15:
            border += '-LEFT'
        elif t.cx > p.page_width * 0.85:
            border += '-RIGHT'
        if border:
            print(f'  [{t.cx:7.0f},{t.cy:7.0f}] "{t.text:20s}" {border}')

# Also dump schedule page for column data
for p in pages:
    if p.page_type == 'schedule' and 'C1' in str(p.all_text):
        print(f'\n=== SCHEDULE PAGE {p.page_index} ===')
        for t in sorted(p.all_text, key=lambda t: (t.cy, t.cx))[:30]:
            print(f'  [{t.cx:7.0f},{t.cy:7.0f}] "{t.text:20s}"')
        break