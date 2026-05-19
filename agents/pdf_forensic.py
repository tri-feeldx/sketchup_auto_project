"""
=============================================================================
A0: PDF FORENSIC ANALYZER V7 — Pre-LLM PDF Intelligence (UPGRADED)
=============================================================================
Extracts structural metadata from PDFs WITHOUT LLM calls:
- Page count, sizes, orientations, text extraction
- Drawing conventions (AU AS/NZS, VN TCVN, International)
- Steel grades, section types, reinforcement notation
- Grid system detection, level notation, scale detection
- Language detection, keyword richness scoring
- Schedule detection per page

Output: pdf_profile dict used by downstream agents.

Upgrades from V5:
  - Per-page text extraction with keyword context
  - Grid detection: tim "truc 1", "truc A", "grid 1", "grid A"
  - Scale detection: tim "1:100", "1:50", "1:200"
  - Language detection: VN vs EN
  - Enhanced VN keywords: TCVN, mat bang, mat dung, mat cat
  - Page-level text fingerprint for routing
  - level_ssl / level_ffl detection
=============================================================================
"""

import json
import re
from pathlib import Path
from typing import Dict, List, Optional, Tuple
from dataclasses import dataclass, field


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
    "TCVN": ["tcvn", "tieu chuan"],
    "steel": ["thep", "ct", "thep hinh"],
    "concrete": ["be tong", "btct", "be tong cot thep"],
    "column": ["cot", "c1", "c2"],
    "beam": ["dam", "d1", "d2"],
    "slab": ["san", "s1", "s2"],
    "foundation": ["mong", "m1", "m2"],
    "reinforcement": ["thep chiu luc", "thep dai", "thep mu"],
    "grid": ["truc", "truc a", "truc b", "truc 1"],
    "level": ["cao do", "cot"],
    "elevation_view": ["mat dung", "mat dung"],
    "section_view": ["mat cat"],
    "plan_view": ["mat bang"],
    "detail_view": ["chi tiet", "cau tao"],
    "schedule": ["bang thong ke", "bang tong hop", "thong ke cot thep"],
    "brick": ["gach", "xay", "tuong"],
    "wood": ["go", "van"],
    "roof": ["mai", "vi keo"],
    "stair": ["cau thang"],
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

# ── SCALE PATTERNS ──────────────────────────────────────────
SCALE_PATTERNS = [
    (r"1\s*[:=]\s*200", "1:200"),
    (r"1\s*[:=]\s*100", "1:100"),
    (r"1\s*[:=]\s*50", "1:50"),
    (r"1\s*[:=]\s*20", "1:20"),
    (r"1\s*[:=]\s*25", "1:25"),
    (r"1\s*[:=]\s*10", "1:10"),
    (r"scale\s*1\s*[:=]\s*(\d+)", None),  # capture any scale
]

# ── GRID DETECTION PATTERNS ─────────────────────────────────
GRID_X_PATTERNS = [
    r"truc\s*(\d+)",          # VN: truc 1, truc 2
    r"grid\s*(\d+)",           # EN: grid 1, grid 2
    r"gridline\s*(\d+)",       # EN: gridline 1
    r"axis\s*(\d+)",           # axis 1
]

GRID_Y_PATTERNS = [
    r"truc\s*([A-FH-NP-Z])",   # VN: truc A, truc B (exclude G/O common false positives)
    r"grid\s*([A-FH-NP-Z])",    # EN: grid A, grid B
    r"gridline\s*([A-FH-NP-Z])",
    r"axis\s*([A-FH-NP-Z])",
]

# ── LANGUAGE DETECTION MARKERS ──────────────────────────────
VN_MARKER_WORDS = [
    "bang", "dung", "cat", "cot", "dam", "san", "mong",
    "thep", "be tong", "tuong", "cua", "cau thang",
    "mat bang", "mat dung", "mat cat", "chi tiet",
    "bang thong ke", "cao do", "truc", "cot",
    "chiu luc", "thep dai", "thep mu",
]

EN_MARKER_WORDS = [
    "plan", "elevation", "section", "column", "beam", "slab", "footing",
    "steel", "concrete", "wall", "door", "window", "stair",
    "schedule", "level", "grid", "detail",
]


# ============================================================
# DATA CLASSES
# ============================================================

@dataclass
class PageForensic:
    """Per-page forensic fingerprint."""
    page_idx: int = 0
    width_mm: float = 0.0
    height_mm: float = 0.0
    orientation: str = "PORTRAIT"
    text: str = ""
    first_line: str = ""
    text_length: int = 0
    # Keyword categories
    has_grid_numbers: bool = False
    has_grid_letters: bool = False
    has_dimensions: bool = False
    has_steel_sections: bool = False
    has_concrete: bool = False
    has_levels: bool = False
    detected_scales: List[str] = field(default_factory=list)
    # Content hints
    likely_plan: bool = False
    likely_elevation: bool = False
    likely_section: bool = False
    likely_schedule: bool = False
    likely_detail: bool = False
    likely_title: bool = False

    def to_dict(self) -> dict:
        return {
            "page_idx": self.page_idx,
            "width_mm": self.width_mm,
            "height_mm": self.height_mm,
            "orientation": self.orientation,
            "text": self.text,
            "text_length": self.text_length,
            "first_line": self.first_line[:120],
            "has_grid_numbers": self.has_grid_numbers,
            "has_grid_letters": self.has_grid_letters,
            "has_dimensions": self.has_dimensions,
            "has_steel_sections": self.has_steel_sections,
            "has_concrete": self.has_concrete,
            "has_levels": self.has_levels,
            "detected_scales": self.detected_scales,
            "likely_plan": self.likely_plan,
            "likely_elevation": self.likely_elevation,
            "likely_section": self.likely_section,
            "likely_schedule": self.likely_schedule,
            "likely_detail": self.likely_detail,
            "likely_title": self.likely_title,
        }


@dataclass
class ForensicResult:
    """Structured forensic analysis result — V7 UPGRADED."""
    pdf_path: str = ""
    num_pages: int = 0
    pages: List[Dict] = field(default_factory=list)
    page_forensics: List[PageForensic] = field(default_factory=list)
    all_text: str = ""
    keywords: Dict[str, bool] = field(default_factory=dict)
    keyword_scores: Dict[str, int] = field(default_factory=dict)
    region: str = "unknown"
    detected_language: str = "unknown"
    primary_material: str = "unknown"
    building_type: str = "unknown"
    has_schedules: bool = False
    has_plans: bool = False
    has_elevations: bool = False
    has_sections: bool = False
    has_details: bool = False
    drawing_size: str = "A1"
    estimated_scale_plans: str = "1:100"
    estimated_scale_details: str = "1:20"
    detected_scales: List[str] = field(default_factory=list)
    detected_grid_x: List[str] = field(default_factory=list)
    detected_grid_y: List[str] = field(default_factory=list)
    page_texts: List[str] = field(default_factory=list)
    region_confidence: float = 0.0

    def to_dict(self) -> dict:
        return {
            "pdf_path": self.pdf_path,
            "num_pages": self.num_pages,
            "pages": [pf.to_dict() for pf in self.page_forensics] or self.pages,
            "keywords": self.keywords,
            "keyword_scores": self.keyword_scores,
            "region": self.region,
            "detected_language": self.detected_language,
            "region_confidence": self.region_confidence,
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
            "detected_scales": self.detected_scales,
            "detected_grid_x": self.detected_grid_x,
            "detected_grid_y": self.detected_grid_y,
        }


# ============================================================
# MAIN ANALYZER V7
# ============================================================

class PDFForensicAnalyzer:
    """Pre-LLM PDF analysis — extract structural metadata. V7 UPGRADED."""

    def __init__(self, pdf_path: str):
        self.pdf_path = pdf_path
        self.result = ForensicResult(pdf_path=pdf_path)

    def analyze(self) -> ForensicResult:
        """Run full forensic analysis V7."""
        self._extract_pages()
        self._analyze_page_forensics()
        self._detect_keywords()
        self._detect_language()
        self._derive_region()
        self._derive_material()
        self._derive_building_type()
        self._derive_has_types()
        self._detect_scales()
        self._detect_grids()
        return self.result

    # ── STAGE 1: PAGE EXTRACTION ────────────────────────────
    def _extract_pages(self):
        try:
            import fitz  # PyMuPDF
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

            pf = PageForensic(
                page_idx=i,
                width_mm=round(w_mm, 0),
                height_mm=round(h_mm, 0),
                orientation=orientation,
                text=text,
                first_line=first_line[:120],
                text_length=len(text.strip()),
            )
            self.result.page_forensics.append(pf)

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

        # Determine drawing size
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

    # ── STAGE 2: PER-PAGE FORENSICS ─────────────────────────
    def _analyze_page_forensics(self):
        """Per-page keyword analysis for routing hints."""
        # VN content keywords
        vn_plan_words = ["mat bang", "mat bang tang", "bang bo tri", "so do"]
        vn_elevation_words = ["mat dung", "mat dung truc", "dung"]
        vn_section_words = ["mat cat", "mat cat a", "mat cat b", "cat doc", "cat ngang"]
        vn_schedule_words = ["bang thong ke", "bang tong hop", "thong ke", "bang tinh"]
        vn_detail_words = ["chi tiet", "cau tao", "mat cat chi tiet"]
        vn_title_words = ["ban ve", "ho so", "thuyet minh", "tong mat bang"]

        en_plan_words = ["plan", "floor plan", "ground floor", "layout"]
        en_elevation_words = ["elevation", "north elevation", "south elevation"]
        en_section_words = ["section", "cross section", "longitudinal section"]
        en_schedule_words = ["schedule", "table", "bill of", "list of"]
        en_detail_words = ["detail", "connection detail", "typical detail"]
        en_title_words = ["drawing list", "sheet index", "general notes"]

        concrete_words = ["concrete", "reinforced", "be tong", "btct", "cot thep"]
        level_words = ["rl ", "ffl", "ssl", "cao do", "cot ", "level"]

        for pf in self.result.page_forensics:
            t = pf.text.lower()

            # Grid detection
            pf.has_grid_numbers = bool(re.search(r"(?:truc|grid|gridline|axis)\s*\d+", t, re.IGNORECASE))
            pf.has_grid_letters = bool(re.search(r"(?:truc|grid|gridline|axis)\s*[A-FH-NP-Z]", t, re.IGNORECASE))

            # Dimensions
            pf.has_dimensions = bool(re.search(r"\d{3,5}\s*(?:mm|m|mm)", t))

            # Steel sections
            steel_pats = ["ub", "uc", "pfc", "rhs", "shs", "chs", "zb", "zc", "thep hinh"]
            pf.has_steel_sections = any(p in t for p in steel_pats)

            # Concrete
            pf.has_concrete = any(w in t for w in concrete_words)

            # Levels
            pf.has_levels = any(w in t for w in level_words)

            # Scale detection per page
            for pat, label in SCALE_PATTERNS:
                m = re.search(pat, t, re.IGNORECASE)
                if m:
                    scale_val = label if label else f"1:{m.group(1)}"
                    if scale_val not in pf.detected_scales:
                        pf.detected_scales.append(scale_val)

            # Content type hints - VN
            if any(w in t for w in vn_plan_words):
                pf.likely_plan = True
            if any(w in t for w in vn_elevation_words):
                pf.likely_elevation = True
            if any(w in t for w in vn_section_words):
                pf.likely_section = True
            if any(w in t for w in vn_schedule_words):
                pf.likely_schedule = True
            if any(w in t for w in vn_detail_words):
                pf.likely_detail = True
            if any(w in t for w in vn_title_words):
                pf.likely_title = True

            # Content type hints - EN (override/add)
            if any(w in t for w in en_plan_words):
                pf.likely_plan = True
            if any(w in t for w in en_elevation_words):
                pf.likely_elevation = True
            if any(w in t for w in en_section_words):
                pf.likely_section = True
            if any(w in t for w in en_schedule_words):
                pf.likely_schedule = True
            if any(w in t for w in en_detail_words):
                pf.likely_detail = True
            if any(w in t for w in en_title_words):
                pf.likely_title = True

            # Empty page or very short -> likely title/cover
            if pf.text_length < 80 and not pf.likely_plan and not pf.likely_section:
                pf.likely_title = True

    # ── STAGE 3: KEYWORD DETECTION ──────────────────────────
    def _detect_keywords(self):
        t = self.result.all_text
        scores = {}

        for kw_set, name in [(AU_KEYWORDS, "AU"), (VN_KEYWORDS, "VN"), (INTL_KEYWORDS, "INTL")]:
            for key, patterns in kw_set.items():
                count = sum(1 for pat in patterns if pat in t)
                if count > 0:
                    self.result.keywords[f"{name}_{key}"] = True
                    scores[f"{name}_{key}"] = count
                else:
                    self.result.keywords[f"{name}_{key}"] = False
                    scores[f"{name}_{key}"] = 0

        self.result.keyword_scores = scores

    # ── STAGE 4: LANGUAGE DETECTION ─────────────────────────
    def _detect_language(self):
        t = self.result.all_text
        vn_count = sum(1 for w in VN_MARKER_WORDS if w in t)
        en_count = sum(1 for w in EN_MARKER_WORDS if w in t)

        if vn_count > en_count and vn_count >= 2:
            self.result.detected_language = "vn"
        elif en_count > vn_count and en_count >= 2:
            self.result.detected_language = "en"
        else:
            self.result.detected_language = "vn" if vn_count > 0 else "unknown"

    # ── STAGE 5: REGION DERIVATION ──────────────────────────
    def _derive_region(self):
        au_score = sum(
            v for k, v in self.result.keyword_scores.items() if k.startswith("AU_")
        )
        vn_score = sum(
            v for k, v in self.result.keyword_scores.items() if k.startswith("VN_")
        )
        intl_score = sum(
            v for k, v in self.result.keyword_scores.items() if k.startswith("INTL_")
        )

        scores = {"au": au_score, "vn": vn_score, "intl": intl_score}
        best = max(scores, key=scores.get)
        best_score = scores[best]

        if best_score >= 2:
            self.result.region = best
            total = au_score + vn_score + intl_score or 1
            self.result.region_confidence = round(best_score / total, 2)
        else:
            # Fallback: use language
            if self.result.detected_language == "vn":
                self.result.region = "vn"
                self.result.region_confidence = 0.5
            elif self.result.detected_language == "en":
                self.result.region = "au"
                self.result.region_confidence = 0.3

    # ── STAGE 6: MATERIAL DERIVATION ────────────────────────
    def _derive_material(self):
        t = self.result.all_text
        steel_count = sum(
            v for k, v in self.result.keyword_scores.items()
            if "steel" in k and not k.startswith("INTL")
        )
        concrete_count = sum(
            v for k, v in self.result.keyword_scores.items() if "concrete" in k
        )
        if steel_count > concrete_count * 1.5:
            self.result.primary_material = "steel"
        elif concrete_count > steel_count * 1.5:
            self.result.primary_material = "concrete"
        elif steel_count > 0 or concrete_count > 0:
            self.result.primary_material = "composite"
        else:
            self.result.primary_material = "unknown"

    # ── STAGE 7: BUILDING TYPE ──────────────────────────────
    def _derive_building_type(self):
        t = self.result.all_text
        if any(w in t for w in ["portal", "shed", "warehouse", "nha xuong", "nha thep"]):
            self.result.building_type = "portal_frame"
        elif any(w in t for w in ["residential", "apartment", "chung cu", "nha o"]):
            self.result.building_type = "residential"
        elif any(w in t for w in ["office", "commercial", "van phong"]):
            self.result.building_type = "commercial"
        elif any(w in t for w in ["factory", "plant", "nha may"]):
            self.result.building_type = "industrial"
        else:
            self.result.building_type = "general"

    # ── STAGE 8: HAS-TYPE FLAGS ─────────────────────────────
    def _derive_has_types(self):
        self.result.has_plans = any(pf.likely_plan for pf in self.result.page_forensics)
        self.result.has_elevations = any(pf.likely_elevation for pf in self.result.page_forensics)
        self.result.has_sections = any(pf.likely_section for pf in self.result.page_forensics)
        self.result.has_schedules = any(pf.likely_schedule for pf in self.result.page_forensics)
        self.result.has_details = any(pf.likely_detail for pf in self.result.page_forensics)

    # ── STAGE 9: SCALE DETECTION ────────────────────────────
    def _detect_scales(self):
        t = self.result.all_text
        seen = set()
        for pat, label in SCALE_PATTERNS:
            for m in re.finditer(pat, t, re.IGNORECASE):
                scale_val = label if label else f"1:{m.group(1)}"
                if scale_val not in seen:
                    seen.add(scale_val)
                    self.result.detected_scales.append(scale_val)

        # Estimate defaults based on region
        if not self.result.detected_scales:
            if self.result.region == "vn":
                self.result.estimated_scale_plans = "1:100"
                self.result.estimated_scale_details = "1:25"
            else:
                self.result.estimated_scale_plans = "1:100"
                self.result.estimated_scale_details = "1:20"
        else:
            # Use smallest detected for details, largest for plans
            nums = []
            for s in self.result.detected_scales:
                try:
                    nums.append(int(s.split(":")[1]))
                except (IndexError, ValueError):
                    pass
            if nums:
                self.result.estimated_scale_plans = f"1:{max(nums)}"
                self.result.estimated_scale_details = f"1:{min(nums)}"

    # ── STAGE 10: GRID DETECTION ────────────────────────────
    def _detect_grids(self):
        t = self.result.all_text
        grid_x = set()
        grid_y = set()

        for pat in GRID_X_PATTERNS:
            for m in re.finditer(pat, t, re.IGNORECASE):
                grid_x.add(m.group(1))

        for pat in GRID_Y_PATTERNS:
            for m in re.finditer(pat, t, re.IGNORECASE):
                grid_y.add(m.group(1).upper())

        self.result.detected_grid_x = sorted(grid_x, key=lambda x: int(x) if x.isdigit() else 999)
        self.result.detected_grid_y = sorted(grid_y)


# ============================================================
# PUBLIC HELPER
# ============================================================

def quick_forensic(pdf_path: str) -> dict:
    """Run forensic analysis and return dict. Convenience wrapper."""
    analyzer = PDFForensicAnalyzer(pdf_path)
    result = analyzer.analyze()
    return result.to_dict()
