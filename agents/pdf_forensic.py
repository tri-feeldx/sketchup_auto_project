"""
PDF Forensic Analyzer — Pre-LLM PDF intelligence gathering.

Extracts structural metadata from PDFs WITHOUT using LLM calls:
- Page count, sizes, orientations
- Text extraction for keyword detection  
- Drawing conventions (Australian AS/NZS, Vietnamese TCVN, International)
- Steel grades, section types, reinforcement notation
- Grid system detection, level notation
- Schedule detection

This forensic data feeds into downstream prompts to calibrate LLM extraction.
"""

import json
from typing import Dict, List, Optional


# ============================================================
# KEYWORD DETECTORS — Expandable per region
# ============================================================

AU_KEYWORDS = {
    "steel_grade_250": ["250", "grade 250", "3678"],
    "steel_grade_300": ["300", "grade 300", "3679"],
    "steel_grade_350": ["350", "c350", "grade 350", "1163"],
    "steel_grade_450": ["450", "g450"],
    "steel_grade_500": ["500", "g500"],
    "UB_sections": ["ub"],
    "UC_sections": ["uc"],
    "PFC_sections": ["pfc"],
    "RHS_SHS": ["rhs", "shs"],
    "EA_sections": ["ea "],
    "UA_sections": ["ua "],
    "Z_purlin": ["z200", "z250", "zed"],
    "C_purlin": ["c200", "c250"],
    "bolted": ["bolt", "m20", "m24", "8.8"],
    "welded": ["weld", "e41", "e48", "fillet"],
    "AS_NZS": ["as ", "nzs", "as/nzs"],
    "AS4100": ["as4100", "as 4100"],
    "AS3600": ["as3600", "as 3600"],
    "AS4600": ["as4600", "as 4600"],
    "AS1170": ["as1170", "as 1170"],
    "concrete": ["concrete", "reinforced", "n25", "n32", "n40"],
    "reinforcement": ["n12", "n16", "n20", "n24", "n28", "n32", "r10", "r12"],
    "masonry": ["masonry", "brick", "blockwork"],
    "footing": ["footing", "pad footing", "strip footing"],
    "bracing": ["brace", "bracing", "cross brace", "chevron"],
    "purlin": ["purlin"],
    "girt": ["girt"],
    "roof": ["roof", "ridge", "eave", "fall"],
    "portal_frame": ["portal", "rafter", "knee", "haunch"],
    "column_schedule": ["column schedule", "col schedule"],
    "beam_schedule": ["beam schedule"],
    "footing_schedule": ["footing schedule"],
    "bolt_schedule": ["bolt schedule"],
    "level_rl": ["rl ", "rl=", "rl:", "reduced level", "ahd"],
    "level_ffl": ["ffl", "finished floor"],
    "level_ssl": ["ssl", "structural slab"],
}

VN_KEYWORDS = {
    "TCVN": ["tcvn", "tiêu chuẩn"],
    "steel": ["thép", "ct", "thép hình"],
    "concrete": ["bê tông", "btct", "bê tông cốt thép"],
    "column": ["cột", "c1", "c2"],
    "beam": ["dầm", "d1", "d2"],
    "reinforcement": ["Ø", "ф", "thép chịu lực", "thép đai"],
    "grid_letters": ["trục", "trục a", "trục b", "trục 1"],
    "level": ["cao độ", "cốt"],
}

INTL_KEYWORDS = {
    "ISO": ["iso", "en 199", "eurocode"],
    "steel_S235": ["s235"],
    "steel_S275": ["s275"],
    "steel_S355": ["s355"],
    "IPE_sections": ["ipe"],
    "HEA_sections": ["hea"],
    "HEB_sections": ["heb"],
}


# ============================================================
# FORENSIC RESULT CLASS
# ============================================================

class ForensicResult:
    """Structured forensic analysis result."""

    def __init__(self, pdf_path: str):
        self.pdf_path = pdf_path
        self.num_pages: int = 0
        self.pages: List[Dict] = []
        self.all_text: str = ""
        self.keywords: Dict[str, bool] = {}
        self.region: str = "unknown"
        self.primary_material: str = "unknown"
        self.building_type: str = "unknown"
        self.has_schedules: bool = False
        self.has_plans: bool = False
        self.has_elevations: bool = False
        self.has_sections: bool = False
        self.has_details: bool = False
        self.drawing_size: str = "A1"
        self.estimated_scale_plans: str = "1:100"
        self.estimated_scale_details: str = "1:20"
        self.page_texts: List[str] = []

    def to_dict(self) -> dict:
        return {
            "pdf_path": self.pdf_path,
            "num_pages": self.num_pages,
            "pages": self.pages,
            "keywords": self.keywords,
            "region": self.region,
            "primary_material": self.primary_material,
            "building_type": self.building_type,
            "has_schedules": self.has_schedules,
            "has_plans": self.has_plans,
            "has_elevations": self.has_elevations,
            "has_sections": self.has_sections,
            "has_details": self.has_details,
            "drawing_size": self.drawing_size,
            "estimated_scale_plans": self.estimated_scale_plans,
            "estimated_scale_details": self.estimated_scale_details,
        }


# ============================================================
# MAIN ANALYZER
# ============================================================

class PDFForensicAnalyzer:
    """Pre-LLM PDF analysis — extract structural metadata."""

    def __init__(self, pdf_path: str):
        self.pdf_path = pdf_path
        self.result = ForensicResult(pdf_path)

    def analyze(self) -> ForensicResult:
        """Run full forensic analysis."""
        self._extract_pages()
        self._detect_keywords()
        self._derive_region()
        self._derive_material()
        self._derive_building_type()
        self._derive_has_types()
        return self.result

    def _extract_pages(self):
        try:
            import fitz
        except ImportError:
            print("[FORENSIC] PyMuPDF not available, skipping page extraction")
            return

        doc = fitz.open(self.pdf_path)
        self.result.num_pages = len(doc)
        all_texts = []

        for i in range(len(doc)):
            page = doc[i]
            text = page.get_text()
            all_texts.append(text)
            w_pt, h_pt = page.rect.width, page.rect.height
            w_mm, h_mm = w_pt * 0.3528, h_pt * 0.3528
            orientation = "LANDSCAPE" if w_pt > h_pt else "PORTRAIT"
            first_line = text.strip().split("\n")[0] if text.strip() else "(empty)"

            self.result.pages.append({
                "index": i,
                "width_mm": round(w_mm, 0),
                "height_mm": round(h_mm, 0),
                "orientation": orientation,
                "first_text": first_line[:100],
            })
            self.result.page_texts.append(text)

        self.result.all_text = "\n".join(all_texts).lower()
        doc.close()

        if self.result.pages:
            first = self.result.pages[0]
            w, h = first["width_mm"], first["height_mm"]
            if 800 < w < 900 and 550 < h < 620:
                self.result.drawing_size = "A1"
            elif 1100 < w < 1220 and 800 < h < 860:
                self.result.drawing_size = "A0"
            elif 400 < w < 440 and 280 < h < 310:
                self.result.drawing_size = "A3"
            else:
                self.result.drawing_size = f"{w:.0f}x{h:.0f}mm"

    def _detect_keywords(self):
        full = self.result.all_text
        au_hits = self._detect(full, AU_KEYWORDS)
        vn_hits = self._detect(full, VN_KEYWORDS)
        intl_hits = self._detect(full, INTL_KEYWORDS)
        self.result.keywords = {**au_hits, **vn_hits, **intl_hits}

    def _detect(self, text: str, keyword_map: dict) -> dict:
        hits = {}
        for key, patterns in keyword_map.items():
            hits[key] = any(p in text for p in patterns)
        return hits

    def _derive_region(self):
        k = self.result.keywords
        au_score = sum([
            k.get("AS_NZS", False), k.get("AS4100", False), k.get("AS3600", False),
            k.get("level_rl", False), k.get("UB_sections", False),
            k.get("portal_frame", False), k.get("purlin", False),
        ])
        vn_score = sum([
            k.get("TCVN", False), k.get("concrete", False) and k.get("reinforcement", False),
        ])
        intl_score = sum([k.get("ISO", False)])
        if au_score >= 3:
            self.result.region = "au"
        elif vn_score >= 2:
            self.result.region = "vn"
        elif intl_score >= 1:
            self.result.region = "intl"
        elif k.get("AS_NZS", False) or k.get("UB_sections", False):
            self.result.region = "au"
        else:
            self.result.region = "unknown"

    def _derive_material(self):
        k = self.result.keywords
        is_steel = (
            k.get("UB_sections", False) or k.get("UC_sections", False) or
            k.get("PFC_sections", False) or k.get("RHS_SHS", False) or
            k.get("EA_sections", False) or k.get("Z_purlin", False) or
            k.get("portal_frame", False) or k.get("bolted", False)
        )
        is_concrete = (
            k.get("concrete", False) or k.get("reinforcement", False) or
            k.get("masonry", False) or k.get("footing", False)
        )
        if is_steel and is_concrete:
            self.result.primary_material = "mixed"
        elif is_steel:
            self.result.primary_material = "steel"
        elif is_concrete:
            self.result.primary_material = "concrete"
        else:
            text = self.result.all_text
            if "steel" in text or "ub" in text or "universal" in text:
                self.result.primary_material = "steel"
            elif "concrete" in text or "reinforc" in text:
                self.result.primary_material = "concrete"
            else:
                self.result.primary_material = "unknown"

    def _derive_building_type(self):
        k = self.result.keywords
        text = self.result.all_text
        if k.get("portal_frame", False) or "portal" in text:
            self.result.building_type = "portal_frame"
        elif "multi" in text or any(f"level {i}" in text for i in range(1, 10)):
            self.result.building_type = "multi_storey"
        elif "warehouse" in text or "shed" in text or "factory" in text:
            self.result.building_type = "industrial"
        elif "residential" in text or "unit" in text or "apartment" in text:
            self.result.building_type = "residential"
        elif "school" in text or "classroom" in text:
            self.result.building_type = "educational"
        else:
            if self.result.num_pages >= 20:
                self.result.building_type = "commercial_industrial"
            elif self.result.num_pages >= 8:
                self.result.building_type = "multi_storey"
            else:
                self.result.building_type = "small_building"

    def _derive_has_types(self):
        k = self.result.keywords
        self.result.has_schedules = (
            k.get("column_schedule", False) or k.get("beam_schedule", False) or
            k.get("footing_schedule", False) or k.get("bolt_schedule", False)
        )
        text = self.result.all_text
        self.result.has_plans = any(
            w in text for w in ["plan", "ground floor", "first floor", "floor plan",
                               "framing plan", "footing plan", "roof plan"]
        )
        self.result.has_elevations = any(
            w in text for w in ["elevation", "section a", "section b",
                               "north elevation", "south elevation"]
        )
        self.result.has_sections = any(
            w in text for w in ["section", "detail a", "detail b", "typical detail"]
        )
        self.result.has_details = any(
            w in text for w in ["detail", "connection", "splice", "base plate",
                               "stiffener", "hold down"]
        )

    def print_report(self):
        r = self.result
        print(f"\n{'='*60}")
        print(f"FORENSIC REPORT: {self.pdf_path}")
        print(f"{'='*60}")
        print(f"  Pages: {r.num_pages}")
        print(f"  Region: {r.region.upper()}")
        print(f"  Material: {r.primary_material}")
        print(f"  Building: {r.building_type}")
        print(f"  Drawing Size: {r.drawing_size}")
        print(f"  Has Plans: {r.has_plans}")
        print(f"  Has Elevations: {r.has_elevations}")
        print(f"  Has Sections: {r.has_sections}")
        print(f"  Has Details: {r.has_details}")
        print(f"  Has Schedules: {r.has_schedules}")
        print(f"\n  Keywords Detected:")
        for k, v in sorted(r.keywords.items()):
            if v:
                print(f"    [YES] {k}")
        print(f"{'='*60}\n")


def run_forensic(pdf_path: str, verbose: bool = True) -> ForensicResult:
    """Quick one-shot forensic analysis."""
    analyzer = PDFForensicAnalyzer(pdf_path)
    result = analyzer.analyze()
    if verbose:
        analyzer.print_report()
    return result


__all__ = [
    "PDFForensicAnalyzer",
    "ForensicResult",
    "run_forensic",
    "AU_KEYWORDS",
    "VN_KEYWORDS",
    "INTL_KEYWORDS",
]