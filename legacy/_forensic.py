"""Forensic analysis of Australian PDFs."""
import fitz, json, os

for name in ['structural.pdf', 'St_Carloa_Moama.pdf']:
    path = f'data/input_pdf/{name}'
    doc = fitz.open(path)
    print(f'=== {name} ===')
    print(f'Pages: {len(doc)}')

    all_texts = []
    for i in range(len(doc)):
        page = doc[i]
        text = page.get_text()
        all_texts.append(text)
        w, h = page.rect.width, page.rect.height
        wmm, hmm = w * 0.3528, h * 0.3528
        orientation = "LANDSCAPE" if w > h else "PORTRAIT"
        first_line = text.strip().split('\n')[0] if text.strip() else "(empty)"
        print(f'  P{i}: {orientation:10s} {wmm:.0f}x{hmm:.0f}mm | {first_line[:100]}')

    # Detect keywords
    full = '\n'.join(all_texts).lower()
    kw = {
        "steel_grade_250": "250" in full or "grade 250" in full,
        "steel_grade_300": "300" in full or "grade 300" in full,
        "steel_grade_350": "350" in full or "grade 350" in full,
        "UB_sections": "ub" in full,
        "UC_sections": "uc" in full,
        "PFC_sections": "pfc" in full,
        "RHS_SHS": "rhs" in full or "shs" in full,
        "bolted": "bolt" in full,
        "welded": "weld" in full,
        "AS_NZS": "as " in full or "nzs" in full or "as/nzs" in full,
        "AS4100": "as4100" in full or "as 4100" in full,
        "AS3600": "as3600" in full or "as 3600" in full,
        "grid_numbers": bool([w for w in full.split() if w.isdigit() and 1 <= int(w) <= 20]),
        "grid_letters": bool([w for w in full.split() if len(w) == 1 and w.isalpha() and w.lower() in 'abcdefgh']),
        "storey_levels": "level" in full or "storey" in full or "rl " in full,
        "footing": "footing" in full or "pad" in full,
        "bracing": "brace" in full or "bracing" in full,
        "purlin": "purlin" in full,
        "girt": "girt" in full,
        "concrete": "concrete" in full or "reinforced" in full,
        "masonry": "masonry" in full or "brick" in full,
        "roof": "roof" in full,
        "column_schedule": "column schedule" in full or "col schedule" in full,
        "beam_schedule": "beam schedule" in full,
        "footing_schedule": "footing schedule" in full,
    }

    print(f'\n  KEYWORDS detected:')
    for k, v in kw.items():
        if v:
            print(f'    [YES] {k}')
    print()

    doc.close()