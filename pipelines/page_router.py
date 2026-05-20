"""
=============================================================================
A1: PAGE ROUTER V7 — Smart Page Classification & Routing
=============================================================================
Determines page type (plan/elevation/section/schedule/detail/title)
from forensic data + page text, then routes each page to the
appropriate scanner prompt. V7 UPGRADED.

Key improvements:
  - VN + EN keyword-aware routing
  - Schedule detection (bang thong ke, schedule, table)
  - Title page detection (first page, low text, no structural content)
  - Detail page detection (chi tiet, detail, enlarged)
  - Multipage batching (group similar pages)
  - Priority scoring for conflicting hints
=============================================================================
"""

import re
from dataclasses import dataclass, field
from typing import Dict, List, Optional, Tuple


# ============================================================
# ROUTE TYPES
# ============================================================

PAGE_TYPES = [
    "TITLE",       # Cover / drawing index / general notes
    "PLAN",        # Floor plan, roof plan, foundation plan
    "ELEVATION",   # Elevation view
    "SECTION",     # Cross section, longitudinal section
    "SCHEDULE",    # Table / bill of quantities
    "DETAIL",      # Connection detail, enlarged detail
    "FOUNDATION",  # Foundation plan, pile layout, footing details
    "UNKNOWN",     # Cannot determine
]

# Priority order for conflicting hints
TYPE_PRIORITY = {
    "SCHEDULE": 10,   # Schedule is unambiguous (tabular data)
    "TITLE": 9,       # Title page if no structural content
    "FOUNDATION": 7,  # Foundation plans are unambiguous structural pages
    "PLAN": 6,
    "ELEVATION": 5,
    "SECTION": 5,
    "DETAIL": 4,
    "UNKNOWN": 0,
}

# ============================================================
# KEYWORD SCORING PER PAGE TYPE — VN + EN
# ============================================================

VN_PLAN_KEYWORDS = [
    "mat bang", "mat bang tang", "mat bang mai", "mat bang mong",
    "bang bo tri", "so do", "so do bo tri", "mat bang ket cau",
    "mat bang cot", "mat bang dam",
]

VN_ELEVATION_KEYWORDS = [
    "mat dung", "mat dung truc", "mat dung chinh", "mat dung ben",
    "dung", "mat ben", "hinh chieu dung",
]

VN_SECTION_KEYWORDS = [
    "mat cat", "mat cat a", "mat cat b", "mat cat c", "mat cat d",
    "cat doc", "cat ngang", "cat ", "mat cat dien hinh",
]

VN_SCHEDULE_KEYWORDS = [
    "bang thong ke", "bang tong hop", "thong ke", "bang tinh",
    "bang tinh toan", "bang thong ke thep", "bang thong ke cot",
    "bang thong ke dam", "bang thong ke mong",
    "lich trinh", "bang tieu chuan",
]

VN_DETAIL_KEYWORDS = [
    "chi tiet", "cau tao", "mat cat chi tiet", "chi tiet lien ket",
    "chi tiet chan cot", "chi tiet dam", "chi tiet mong",
    "chi tiet san", "ban ve chi tiet",
]

VN_TITLE_KEYWORDS = [
    "ban ve", "ho so", "thuyet minh", "tong mat bang",
    "danh muc ban ve", "bang ve", "trang bia",
    "ho so thiet ke", "thuyet minh tinh toan",
]

EN_PLAN_KEYWORDS = [
    "plan", "floor plan", "ground floor", "first floor",
    "roof plan", "foundation plan", "layout plan",
    "structural plan", "framing plan", "general arrangement",
]

EN_ELEVATION_KEYWORDS = [
    "elevation", "north elevation", "south elevation",
    "east elevation", "west elevation", "front elevation",
    "rear elevation", "side elevation",
]

EN_SECTION_KEYWORDS = [
    "section", "cross section", "longitudinal section",
    "typical section", "building section", "wall section",
]

EN_SCHEDULE_KEYWORDS = [
    "schedule", "table", "bill of", "list of",
    "column schedule", "beam schedule", "footing schedule",
    "bolt schedule", "reinforcement schedule", "bracing schedule",
    "material list", "takeoff",
]

EN_DETAIL_KEYWORDS = [
    "detail", "connection detail", "typical detail",
    "enlarged detail", "standard detail", "base plate detail",
    "apex detail", "eaves detail", "splice detail",
]

EN_TITLE_KEYWORDS = [
    "drawing list", "sheet index", "general notes",
    "cover sheet", "title page", "drawing register",
    "project notes", "specification",
]

VN_FOUNDATION_KEYWORDS = [
    "mat bang mong", "mong coc", "mong bang", "mong don",
    "mong raft", "cap mong", "do sau mong", "cao do mong",
    "coc khoan nhoi", "coc ep", "coc be tong",
    "mat cat mong", "nen mong",
]

EN_FOUNDATION_KEYWORDS = [
    # High-specificity terms (weight +4 in scorer)
    "foundation plan", "pile layout", "pile schedule", "bored pile", "pbfc", "psfc",
    # Medium-specificity terms (weight +2 in scorer)
    "pile cap", "footing schedule", "strip footing", "pad footing", "raft foundation",
    "pile detail", "footing detail", "pile cap detail",
    "existing ground level", "pile depth", "founding level", "underside of footing",
    # Pile-specific diameter patterns only (e.g. 600 dia, 1200 dia)
    "600 dia", "900 dia", "1200 dia", "1500 dia", "2400 dia",
]

# High-specificity foundation terms that get +4 weight
EN_FOUNDATION_HIGH = {
    "foundation plan", "pile layout", "pile schedule", "bored pile", "pbfc", "psfc",
}

# ── Structural keywords (appear on non-title pages) ────────
STRUCTURAL_KEYWORDS = [
    "column", "beam", "slab", "footing", "steel", "concrete",
    "bolt", "weld", "reinforcement", "bracing", "purlin", "girt",
    "cot", "dam", "san", "mong", "thep", "be tong", "bu long",
    "han", "gia co", "xuat xuong", "cao do", "rl", "ffl",
    "ub ", "uc ", "pfc", "rhs", "shs", "n12", "n16", "n20",
]

# ── Dimension keywords (appear on structural pages) ────────
DIMENSION_KEYWORDS = [
    r"\d{3,5}\s*mm", r"\d{2,4}x\d{2,4}", r"\d+\s*x\s*\d+",
    r"diameter|width|height|length|depth|thickness",
]


# ============================================================
# PAGE ROUTER CLASS
# ============================================================

@dataclass
class RoutedPage:
    """Result of routing a single page."""
    page_idx: int
    page_type: str  # TITLE / PLAN / ELEVATION / SECTION / SCHEDULE / DETAIL / UNKNOWN
    confidence: float  # 0.0 - 1.0
    scores: Dict[str, int] = field(default_factory=dict)
    text_preview: str = ""


class PageRouter:
    """
    Smart page router — classifies PDF pages by type
    using forensic data + keyword scoring. V7 UPGRADED.
    """

    def __init__(self):
        pass

    def route_all(self, page_forensics: List[Dict],
                  profile: Optional[Dict] = None) -> List[RoutedPage]:
        """
        Route all pages from forensic data.
        page_forensics: list of PageForensic.to_dict() or similar dicts
        """
        results = []
        for pf in page_forensics:
            routed = self._route_one(pf, profile)
            results.append(routed)
        return results

    def _route_one(self, pf: Dict, profile: Optional[Dict] = None) -> RoutedPage:
        """Classify a single page."""
        page_idx = pf.get("page_idx", 0)
        text = pf.get("text", "")
        text_lower = text.lower()
        text_length = pf.get("text_length", len(text))

        # Score each type
        scores = {
            "TITLE": self._score_title(pf, text_lower, text_length),
            "PLAN": self._score_plan(text_lower),
            "ELEVATION": self._score_elevation(text_lower),
            "SECTION": self._score_section(text_lower),
            "SCHEDULE": self._score_schedule(text_lower),
            "DETAIL": self._score_detail(text_lower),
            "FOUNDATION": self._score_foundation(text_lower),
        }

        # Apply structural presence bonus
        struct_count = sum(1 for kw in STRUCTURAL_KEYWORDS if kw in text_lower)
        dim_count = sum(1 for pat in DIMENSION_KEYWORDS if re.search(pat, text_lower))
        has_structural = struct_count >= 3 or dim_count >= 2

        if not has_structural:
            scores["TITLE"] += 5  # Boost title if no structural content

        # Add forensic hints
        if pf.get("likely_plan"):
            scores["PLAN"] += 3
        if pf.get("likely_elevation"):
            scores["ELEVATION"] += 3
        if pf.get("likely_section"):
            scores["SECTION"] += 3
        if pf.get("likely_schedule"):
            scores["SCHEDULE"] += 3
        if pf.get("likely_detail"):
            scores["DETAIL"] += 3
        if pf.get("likely_title"):
            scores["TITLE"] += 3
        if pf.get("likely_foundation"):
            scores["FOUNDATION"] += 3

        # Foundation supersedes PLAN only when very strong foundation signals
        if scores["FOUNDATION"] >= 8 and scores["PLAN"] > 0:
            scores["PLAN"] = max(0, scores["PLAN"] - 2)

        # Determine best type with priority tiebreaker
        best_type = "UNKNOWN"
        best_score = 0
        for ptype, score in sorted(scores.items(),
                                    key=lambda x: (-x[1], -TYPE_PRIORITY.get(x[0], 0))):
            if score > best_score:
                best_score = score
                best_type = ptype

        # Calculate confidence
        total = sum(scores.values()) or 1
        confidence = round(best_score / total, 2)

        routed = RoutedPage(
            page_idx=page_idx,
            page_type=best_type if best_score >= 2 else "UNKNOWN",
            confidence=confidence,
            scores=scores,
            text_preview=text[:200] if text else "",
        )
        return routed

    # ── SCORING FUNCTIONS ───────────────────────────────────
    def _score_title(self, pf: Dict, text_lower: str, text_length: int) -> int:
        """Score likelihood this is a title/cover page."""
        score = 0

        # First page bias
        if pf.get("page_idx", 0) == 0:
            score += 2

        # Very short text
        if text_length < 80:
            score += 4
        elif text_length < 200:
            score += 2

        # VN title keywords
        score += sum(2 for kw in VN_TITLE_KEYWORDS if kw in text_lower)

        # EN title keywords
        score += sum(2 for kw in EN_TITLE_KEYWORDS if kw in text_lower)

        # No structural content
        struct_count = sum(1 for kw in STRUCTURAL_KEYWORDS if kw in text_lower)
        if struct_count == 0:
            score += 3

        return score

    def _score_plan(self, text_lower: str) -> int:
        """Score likelihood this is a floor plan."""
        score = 0

        # VN plan keywords
        for kw in VN_PLAN_KEYWORDS:
            if kw in text_lower:
                score += 3 if "mat bang" in kw else 2

        # EN plan keywords
        for kw in EN_PLAN_KEYWORDS:
            score += 2 if kw in text_lower else 0

        # Grid presence (plans have grid coordinates)
        if re.search(r"(?:truc|grid|gridline|axis)\s*\d+", text_lower):
            score += 2
        if re.search(r"(?:truc|grid|gridline|axis)\s*[A-Z]", text_lower):
            score += 2

        return score

    def _score_elevation(self, text_lower: str) -> int:
        """Score likelihood this is an elevation view."""
        score = 0

        for kw in VN_ELEVATION_KEYWORDS:
            if kw in text_lower:
                score += 3 if "mat dung" in kw else 2

        for kw in EN_ELEVATION_KEYWORDS:
            score += 2 if kw in text_lower else 0

        # Height/elevation indicators
        if re.search(r"(?:rl|ffl|ssl|cao do|elevation|height)\s*[=:]\s*\d+", text_lower):
            score += 2

        # Bracing is primarily visible on elevation views
        if any(kw in text_lower for kw in [
            "bracing", "x-brace", "x brace", "k-brace", "k brace",
            "wind brace", "knee brace", "flat bar brace", "giằng chéo", "giang cheo",
        ]):
            score += 4

        return score

    def _score_section(self, text_lower: str) -> int:
        """Score likelihood this is a section view."""
        score = 0

        for kw in VN_SECTION_KEYWORDS:
            if kw in text_lower:
                score += 3 if "mat cat" in kw else 2

        for kw in EN_SECTION_KEYWORDS:
            score += 2 if kw in text_lower else 0

        return score

    def _score_schedule(self, text_lower: str) -> int:
        """Score likelihood this is a schedule/table."""
        score = 0

        for kw in VN_SCHEDULE_KEYWORDS:
            score += 4 if kw in text_lower else 0

        for kw in EN_SCHEDULE_KEYWORDS:
            score += 4 if kw in text_lower else 0

        # Tabular indicators
        if "|" in text_lower or "\t" in text_lower:
            score += 2
        if re.search(r"\b(?:no\.|item|mark|qty|quantity|weight|grade)\b", text_lower):
            score += 1

        return score

    def _score_detail(self, text_lower: str) -> int:
        """Score likelihood this is a detail drawing."""
        score = 0

        for kw in VN_DETAIL_KEYWORDS:
            score += 3 if kw in text_lower else 0

        for kw in EN_DETAIL_KEYWORDS:
            score += 3 if kw in text_lower else 0

        # Detail scale indicators (large scale = detail)
        if re.search(r"1\s*[:=]\s*(?:1|2|5|10|20|25)", text_lower):
            score += 2

        return score

    def _score_foundation(self, text_lower: str) -> int:
        """Score likelihood this is a foundation/pile layout page."""
        score = 0

        for kw in VN_FOUNDATION_KEYWORDS:
            score += 4 if kw in text_lower else 0

        for kw in EN_FOUNDATION_KEYWORDS:
            # High-specificity terms get +4, medium-specificity get +2
            score += 4 if kw in EN_FOUNDATION_HIGH and kw in text_lower else (
                2 if kw in text_lower else 0
            )

        # Pile-specific diameter patterns — require pile/bore context, not generic "dia"
        if re.search(r"(?:\d{3,4})\s*(?:dia|diameter)\s*(?:pile|bore|coc|mong)", text_lower):
            score += 3
        if re.search(r"(?:600|900|1200|1500|2400)\s*(?:dia|mm\s*dia)", text_lower):
            score += 3

        # NGL only counts when combined with pile/footing context
        if re.search(r"ngl", text_lower) and re.search(r"(?:pile|footing|mong|coc)", text_lower):
            score += 2
        if re.search(r"founding level|underside of footing", text_lower):
            score += 2

        # Pile cap reference
        if re.search(r"pc\d+|pile\s*cap|cap\s*type", text_lower):
            score += 3

        return score

    # ── BATCHING ────────────────────────────────────────────
    def batch_pages(self, routed_pages: List[RoutedPage]) -> Dict[str, List[int]]:
        """
        Group pages by type for batched LLM scanning.
        Returns dict mapping type -> list of page indices.
        """
        batches: Dict[str, List[int]] = {}
        for rp in routed_pages:
            ptype = rp.page_type
            if ptype not in batches:
                batches[ptype] = []
            batches[ptype].append(rp.page_idx)
        return batches

    def get_summary(self, routed_pages: List[RoutedPage]) -> Dict:
        """Generate a summary of page routing results."""
        summary = {
            "total_pages": len(routed_pages),
            "types": {},
            "unknown_count": 0,
        }
        for rp in routed_pages:
            pt = rp.page_type
            if pt not in summary["types"]:
                summary["types"][pt] = []
            summary["types"][pt].append({
                "page_idx": rp.page_idx,
                "confidence": rp.confidence,
                "preview": rp.text_preview[:80],
            })
        summary["unknown_count"] = len(summary["types"].get("UNKNOWN", []))
        return summary


# ============================================================
# PUBLIC HELPER
# ============================================================

def route_pages(page_forensics: List[Dict], profile: Optional[Dict] = None) -> Dict:
    """Convenience wrapper: route all pages and return summary dict."""
    router = PageRouter()
    routed = router.route_all(page_forensics, profile)
    batches = router.batch_pages(routed)
    summary = router.get_summary(routed)
    return {
        "routed_pages": [
            {
                "page_idx": r.page_idx,
                "page_type": r.page_type,
                "confidence": r.confidence,
                "scores": r.scores,
            }
            for r in routed
        ],
        "batches": batches,
        "summary": summary,
    }