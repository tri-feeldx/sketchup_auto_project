"""
=============================================================================
PDF STRUCTURED PARSER — Zero-LLM, Programmatic Extraction Engine
=============================================================================
Extracts ALL structural data from PDF using pdfplumber + OpenCV, NO LLM Vision.
This is the foundation of the new architecture — 100% deterministic, near-zero cost.

CAPABILITIES:
  1. Text layer extraction: grid labels, dimension chains, level markers, member marks
  2. Vector/line extraction: grid lines, dimension chains, structural outlines
  3. Table detection: steel schedules, material lists
  4. Page classification: plan vs elevation vs section vs schedule

Output: StructuredPageData per page, ready for GridMathEngine consumption.
"""

import json
import re
from pathlib import Path
from dataclasses import dataclass, field
from typing import Optional

try:
    import pdfplumber
except ImportError:
    pdfplumber = None


# ============================================================================
# DATA STRUCTURES
# ============================================================================

@dataclass
class TextToken:
    """A single text element extracted from PDF."""
    text: str
    x0: float
    y0: float  # top (pdfplumber convention)
    x1: float
    y1: float  # bottom
    page: int = 0

    @property
    def cx(self) -> float:
        return (self.x0 + self.x1) / 2

    @property
    def cy(self) -> float:
        return (self.y0 + self.y1) / 2

    @property
    def width(self) -> float:
        return self.x1 - self.x0

    @property
    def height(self) -> float:
        return abs(self.y1 - self.y0)


@dataclass
class GridLabel:
    """A detected grid bubble label."""
    label: str
    axis: str  # "X" or "Y"
    px: float  # pixel/page x coordinate
    py: float  # pixel/page y coordinate
    page: int
    confidence: float = 0.8


@dataclass
class DimensionChain:
    """A dimension chain along a drawing edge."""
    axis: str  # "X" or "Y"
    values: list[float]  # list of interval values in mm (or page units)
    positions: list[float]  # cumulative positions
    unit: str = "mm"  # "mm" or "unknown"
    confidence: float = 0.9
    raw_text: str = ""


@dataclass
class LevelMarker:
    """A detected floor level marker."""
    name: str  # e.g. "FL1", "Base", "Roof"
    z_mm: float = 0.0
    py: float = 0.0  # page y position
    page: int = 0
    confidence: float = 0.8


@dataclass
class MemberMark:
    """A structural member mark found on a plan/elevation."""
    mark: str  # e.g. "C1", "B3", "W1"
    cx: float
    cy: float
    page: int
    member_type: str = "unknown"  # column, beam, wall, slab
    confidence: float = 0.8


@dataclass
class TableData:
    """An extracted table (e.g., steel schedule)."""
    headers: list[str]
    rows: list[list[str]]
    page: int
    table_type: str = "unknown"  # "steel_schedule", "material_list", etc.


@dataclass
class StructuredPageData:
    """Complete structured data for one PDF page."""
    page_index: int
    page_width: float
    page_height: float
    page_type: str = "unknown"  # plan, elevation, section, schedule, title
    all_text: list[TextToken] = field(default_factory=list)
    grid_labels: list[GridLabel] = field(default_factory=list)
    dimension_chains: list[DimensionChain] = field(default_factory=list)
    level_markers: list[LevelMarker] = field(default_factory=list)
    member_marks: list[MemberMark] = field(default_factory=list)
    tables: list[TableData] = field(default_factory=list)
    scale_text: Optional[str] = None
    drawing_title: Optional[str] = None
    raw_lines: list[dict] = field(default_factory=list)  # vector lines


# ============================================================================
# MAIN EXTRACTION ENGINE
# ============================================================================

class PDFStructuredParser:
    """
    Programmatic PDF parser that extracts ALL structural data without LLM.
    
    Usage:
        parser = PDFStructuredParser("drawing.pdf")
        pages = parser.parse_all()
        for page in pages:
            print(f"Page {page.page_index}: {page.page_type}")
            print(f"  Grid labels: {page.grid_labels}")
            print(f"  Dim chains: {page.dimension_chains}")
            print(f"  Level markers: {page.level_markers}")
    """

    def __init__(self, pdf_path: str):
        self.pdf_path = pdf_path
        self.pages: list[StructuredPageData] = []
        if pdfplumber is None:
            raise ImportError("pdfplumber is required. Install with: pip install pdfplumber")

    def parse_all(self) -> list[StructuredPageData]:
        """Parse all pages of the PDF."""
        self.pages = []  # Clear to prevent double-append on re-call
        with pdfplumber.open(self.pdf_path) as pdf:
            for i, page in enumerate(pdf.pages):
                spd = self._parse_page(page, i)
                self.pages.append(spd)
        return self.pages

    def _parse_page(self, page, page_index: int) -> StructuredPageData:
        """Parse a single PDF page comprehensively."""
        pw = float(page.width)
        ph = float(page.height)

        spd = StructuredPageData(
            page_index=page_index,
            page_width=pw,
            page_height=ph,
        )

        # 1. Extract ALL text tokens
        spd.all_text = self._extract_text_tokens(page, page_index)

        # 2. Extract vector lines (grid lines, dimension lines)
        spd.raw_lines = self._extract_lines(page)

        # 3. Classify page type
        spd.page_type = self._classify_page(spd)

        # 4. Extract grid labels
        spd.grid_labels = self._extract_grid_labels(spd)

        # 5. Extract dimension chains
        spd.dimension_chains = self._extract_dimension_chains(spd)

        # 6. Extract level markers (for elevation/section pages)
        if spd.page_type in ("elevation", "section"):
            spd.level_markers = self._extract_level_markers(spd)

        # 7. Extract member marks (for plan pages)
        if spd.page_type == "plan":
            spd.member_marks = self._extract_member_marks(spd)

        # 8. Extract tables (for schedule pages)
        if spd.page_type == "schedule":
            spd.tables = self._extract_tables(page, page_index)

        # 9. Detect scale
        spd.scale_text = self._detect_scale(spd)

        # 10. Detect drawing title
        spd.drawing_title = self._detect_title(spd)

        return spd

    # ── Text Token Extraction ─────────────────────────────────────────────────

    def _extract_text_tokens(self, page, page_index: int) -> list[TextToken]:
        """Extract all text tokens from a page."""
        tokens = []
        try:
            words = page.extract_words(
                keep_blank_chars=False,
                x_tolerance=2,
                y_tolerance=2,
                extra_attrs=["fontname", "size"],
            )
            for w in words:
                tokens.append(TextToken(
                    text=str(w.get("text", "")).strip(),
                    x0=float(w.get("x0", 0)),
                    y0=float(w.get("top", 0)),
                    x1=float(w.get("x1", 0)),
                    y1=float(w.get("bottom", 0)),
                    page=page_index,
                ))
        except Exception:
            pass
        return tokens

    # ── Line Extraction ──────────────────────────────────────────────────────

    def _extract_lines(self, page) -> list[dict]:
        """Extract vector lines from the page."""
        lines = []
        try:
            for obj in page.lines:
                lines.append({
                    "x0": float(obj["x0"]),
                    "y0": float(obj["top"]),
                    "x1": float(obj["x1"]),
                    "y1": float(obj["bottom"]),
                    "width": float(obj.get("linewidth", 1)),
                })
        except Exception:
            # Fallback: try edges from rectangles
            try:
                for rect in page.rects:
                    x0, y0, x1, y1 = float(rect["x0"]), float(rect["top"]), float(rect["x1"]), float(rect["bottom"])
                    lines.append({"x0": x0, "y0": y0, "x1": x1, "y1": y0, "width": 1})
                    lines.append({"x0": x1, "y0": y0, "x1": x1, "y1": y1, "width": 1})
                    lines.append({"x0": x1, "y0": y1, "x1": x0, "y1": y1, "width": 1})
                    lines.append({"x0": x0, "y0": y1, "x1": x0, "y1": y0, "width": 1})
            except Exception:
                pass
        return lines

    # ── Page Classification ──────────────────────────────────────────────────

    def _classify_page(self, spd: StructuredPageData) -> str:
        """Classify page as plan, elevation, section, schedule, or unknown."""
        all_text_lower = " ".join(t.text.lower() for t in spd.all_text)
        num_lines = len(spd.raw_lines)
        
        # ── LINE DENSITY HEURISTIC ──
        # Drawing pages (plan, elevation, section) have MANY vector lines.
        # Schedule pages are text-heavy tables with few lines (<2000).
        # Pages with >3000 lines are DEFINITELY drawing pages, not schedules.
        IS_DRAWING_PAGE = num_lines > 3000
        IS_LIKELY_DRAWING = num_lines > 1000
        
        # Strong schedule indicators — only apply if NOT a drawing page
        schedule_keywords = [
            "steel schedule", "member schedule", "bill of materials",
            "bảng thép", "bảng kê", "danh sách", "quantity", "length",
            "section", "mark", "weight", "grade",
        ]
        schedule_score = sum(1 for kw in schedule_keywords if kw in all_text_lower)
        
        # If high line density, it's a drawing — skip schedule classification
        if not IS_DRAWING_PAGE:
            if schedule_score >= 3:
                return "schedule"
            if schedule_score >= 1 and self._has_table_structure(spd):
                return "schedule"

        # Elevation/section indicators
        elev_keywords = [
            "elevation", "mặt đứng", "mặt cắt",
            "rl", "ffl", "top of", "finished floor",
            "cốt", "cao độ",
        ]
        elev_score = sum(1 for kw in elev_keywords if kw in all_text_lower)
        
        # Section-specific
        if "section" in all_text_lower or "mặt cắt" in all_text_lower or "chi tiết" in all_text_lower:
            if IS_LIKELY_DRAWING:
                return "section"

        # Plan indicators (only count the STRONG indicators for plan classification)
        # "column", "beam", "cột", "dầm",... appear on schedules too — only use for plan if drawing page
        strong_plan_keywords = ["plan", "floor plan", "mặt bằng", "layout", "grid", "trục", "sàn", "tầng", "foundation", "móng", "deck"]
        weak_plan_keywords = ["column", "beam", "cột", "dầm"]  # can appear on schedules/elevations too
        strong_plan_score = sum(1 for kw in strong_plan_keywords if kw in all_text_lower)
        weak_plan_score = sum(1 for kw in weak_plan_keywords if kw in all_text_lower)
        
        # Has grid labels? Strongest plan indicator
        has_grid = len(spd.grid_labels) >= 2
        
        # Ridge/eave keywords → likely elevation
        if any(kw in all_text_lower for kw in ["ridge", "eave", "mái", "roof"]):
            if IS_LIKELY_DRAWING:
                return "elevation"

        if elev_score > strong_plan_score + weak_plan_score and IS_LIKELY_DRAWING:
            return "elevation"
        
        # PLAN classification — requires STRONG evidence with drawing confirmation
        # 1. Explicit "plan"/"mặt bằng" keywords on a drawing page → plan
        # 2. Grid labels on a drawing page → plan (grid systems are on plans)
        # 3. "trục" (grid in Vietnamese) + drawing page → plan
        if (strong_plan_score >= 1 or has_grid) and IS_DRAWING_PAGE:
            return "plan"
        
        # Anything with weak plan keywords but no drawing structure → likely schedule or unknown
        if weak_plan_score > 0 and not IS_DRAWING_PAGE:
            # Could be a schedule page listing columns/beams
            return "schedule"
        
        # If many lines but no clear classification → could be detail/elevation, not automatically plan
        if IS_DRAWING_PAGE:
            if any(kw in all_text_lower for kw in ["cột", "dầm", "column", "beam"]) and strong_plan_score >= 1:
                return "plan"
            else:
                return "elevation"  # default drawing pages to elevation (safer than plan)

        if "title" in all_text_lower or "cover" in all_text_lower:
            return "title"

        return "unknown"

    def _has_table_structure(self, spd: StructuredPageData) -> bool:
        """Check if page has tabular structure (rows with aligned text)."""
        # Check for horizontal alignment of text (same y for multiple tokens)
        y_buckets = {}
        for t in spd.all_text:
            y_key = round(t.cy, -1)  # Round to 10pt
            y_buckets.setdefault(y_key, []).append(t)
        
        # Multiple rows with 3+ columns → likely a table
        row_count = sum(1 for tokens in y_buckets.values() if len(tokens) >= 3)
        return row_count >= 4

    # ── Grid Label Extraction ────────────────────────────────────────────────

    # Grid label patterns
    GRID_LETTER_PATTERN = re.compile(r'^[A-Za-z]$')  # Single letter
    GRID_NUMBER_PATTERN = re.compile(r'^\d{1,2}$')   # 1-2 digit number (grid IDs, not dimensions)
    GRID_VIET_PATTERN = re.compile(r'^TR[UỤ]C\s*[A-Za-z0-9]', re.IGNORECASE)
    
    # Noise patterns: words that look like grid labels but are NOT
    NOISE_WORDS = {'REV', 'NO', 'DWG', 'DR', 'ST', 'TTW', 'DAB', 'PH', 'JO', 'SSO', 'NSW',
                   'PM', 'AM', 'RL', 'FFL', 'TOC', 'NTS', 'A1', 'A2', 'A3', 'A0', 'P1', 'P2'}

    @staticmethod
    def _is_vertical_text_cluster(token, all_tokens, max_neighbor_dist=20):
        """
        Detect if a token is part of a vertical text cluster (like title block revision letters).
        Vertical text has neighbors stacked above/below within a narrow horizontal band.
        Returns number of vertical neighbors (0 = isolated).
        """
        cx, cy = token.cx, token.cy
        neighbors = 0
        for other in all_tokens:
            if other is token:
                continue
            # Same narrow X band, stacked vertically
            if abs(other.cx - cx) < max_neighbor_dist and 5 < abs(other.cy - cy) < 30:
                neighbors += 1
        return neighbors

    def _extract_grid_labels(self, spd: StructuredPageData) -> list[GridLabel]:
        """
        Extract grid bubble labels from text layer.
        
        Strategy (revised):
        - Grid labels are ISOLATED single characters/numbers near page borders
        - Filter OUT: vertical text clusters (title blocks), multi-word text, known noise words
        - Grid labels are evenly spaced along an axis (not randomly clustered)
        - Use spacing regularity to validate candidates
        """
        labels = []
        pw, ph = spd.page_width, spd.page_height

        # Pre-filter: build noise exclusion list from title block text
        # Title blocks typically have dense text at page bottom
        titleblock_tokens = set()
        for t in spd.all_text:
            text = t.text.strip().upper()
            # Mark tokens in title block area (bottom 8% of page with dense text)
            if t.cy > ph * 0.92:
                titleblock_tokens.add(id(t))

        x_candidates: list[tuple[str, float, float, float]] = []  # (label, cx, cy, score)
        y_candidates: list[tuple[str, float, float, float]] = []

        for t in spd.all_text:
            if id(t) in titleblock_tokens:
                continue
                
            text = t.text.strip()
            cx, cy = t.cx, t.cy

            # Skip multi-word text, long text, empty
            if len(text) > 3 or len(text) == 0:
                continue
            
            # Skip known noise words
            if text.upper() in self.NOISE_WORDS:
                continue

            # Skip vertical text clusters (title block columns)
            if len(text) == 1 and self._is_vertical_text_cluster(t, spd.all_text) >= 3:
                continue

            # ── Check border regions ──
            # TOP border: X-axis grid labels (typically letters, but can be numbers)
            # BOTTOM border: X-axis grid labels (same, but exclude title block zone)
            near_top = cy < ph * 0.12
            near_bot = ph * 0.85 < cy < ph * 0.92  # exclude extreme bottom (title block)
            
            # LEFT/RIGHT border: Y-axis grid labels (typically numbers, but can be letters)
            near_left = cx < pw * 0.12
            near_right = cx > pw * 0.88

            is_grid_char = (self.GRID_LETTER_PATTERN.match(text) and len(text) == 1)
            is_grid_num = (self.GRID_NUMBER_PATTERN.match(text) and 1 <= len(text) <= 2)

            if not (is_grid_char or is_grid_num):
                continue

            if near_top or near_bot:
                # X-axis: prefer single letters at top/bottom
                score = 1.0
                if is_grid_char:
                    score = 1.2  # letters are strong X-axis signal
                elif is_grid_num:
                    # Numbers at top/bottom: check if they look like grid IDs (small numbers)
                    try:
                        val = int(text)
                        if val <= 20:
                            score = 0.9  # likely grid number
                        else:
                            score = 0.0  # >20 → definitely dimension callout, SKIP
                    except ValueError:
                        score = 0.5
                if score > 0:
                    x_candidates.append((text.upper() if is_grid_char else text, cx, cy, score))

            if near_left or near_right:
                # Y-axis
                score = 1.0
                if is_grid_num:
                    try:
                        val = int(text)
                        if val <= 9:
                            score = 1.2  # strong Y-axis signal (grids rarely have >9)
                        elif val <= 20:
                            score = 0.4  # weak — could be dimension
                        else:
                            score = 0.0  # definitely dimension callout, skip
                    except ValueError:
                        score = 0.8
                elif is_grid_char:
                    score = 0.8
                if score > 0:
                    y_candidates.append((text.upper() if is_grid_char else text, cx, cy, score))

            # ── EXPANDED Y-AXIS DETECTION ──
            # Y-axis grid labels can appear in the MIDDLE zone of the page
            # (not just extreme left/right). They form a vertical column of
            # isolated single characters along the left or right side.
            mid_left = pw * 0.12 <= cx < pw * 0.30
            mid_right = pw * 0.70 < cx <= pw * 0.88
            if (mid_left or mid_right) and not near_top and not near_bot:
                score = 0.0
                if is_grid_char:
                    # Single letter in mid-left/right zone → strong Y-axis
                    score = 0.9
                elif is_grid_num:
                    try:
                        val = int(text)
                        if val <= 9:
                            score = 0.7
                        elif val <= 20:
                            score = 0.3
                        else:
                            score = 0.0
                    except ValueError:
                        score = 0.5
                if score > 0:
                    y_candidates.append((text.upper() if is_grid_char else text, cx, cy, score))

        # ── Filter by spatial regularity ──
        # Grid labels on the same axis should be roughly evenly spaced
        x_candidates = self._filter_by_spacing(x_candidates, axis="x", pw=pw)
        y_candidates = self._filter_by_spacing(y_candidates, axis="y", ph=ph)

        # Also check Vietnamese "Trục A" style labels
        for t in spd.all_text:
            text = t.text.strip().upper()
            if text.startswith("TRỤC") or text.startswith("TRUC"):
                for t2 in spd.all_text:
                    if abs(t2.cy - t.cy) < 15 and abs(t2.cx - t.cx - t.width) < 50:
                        label = t2.text.strip()
                        if self.GRID_LETTER_PATTERN.match(label) or (self.GRID_NUMBER_PATTERN.match(label) and len(label) <= 2):
                            if t.cy < ph * 0.15 or t.cy > ph * 0.85:
                                x_candidates.append((label.upper() if label.isalpha() else label, t2.cx, t2.cy, 1.0))
                            else:
                                y_candidates.append((label.upper() if label.isalpha() else label, t2.cx, t2.cy, 1.0))

        # Deduplicate and build GridLabel objects
        seen_x, seen_y = set(), set()
        for label, cx, cy, score in sorted(x_candidates, key=lambda v: v[1]):
            if label not in seen_x:
                seen_x.add(label)
                labels.append(GridLabel(label=label, axis="X", px=cx, py=cy, page=spd.page_index))

        for label, cx, cy, score in sorted(y_candidates, key=lambda v: v[2]):
            if label not in seen_y and label not in seen_x:
                seen_y.add(label)
                labels.append(GridLabel(label=label, axis="Y", px=cx, py=cy, page=spd.page_index))

        return labels

    @staticmethod
    def _filter_by_spacing(candidates: list, axis: str, pw: float = 0, ph: float = 0) -> list:
        """
        Filter candidates by spatial regularity.
        Real grid lines are roughly evenly spaced; noise is randomly distributed.
        Returns filtered list.
        """
        if len(candidates) <= 2:
            return candidates
        
        # Sort by position
        sort_idx = 1 if axis == "x" else 2
        sorted_cands = sorted(candidates, key=lambda v: v[sort_idx])
        
        # Compute gaps
        gaps = []
        for i in range(1, len(sorted_cands)):
            gap = sorted_cands[i][sort_idx] - sorted_cands[i-1][sort_idx]
            gaps.append(gap)
        
        if not gaps:
            return candidates
        
        median_gap = sorted(gaps)[len(gaps) // 2] if gaps else 100
        
        # Filter: keep candidates that have at least one neighbor within 2x median gap
        filtered = []
        for i, cand in enumerate(sorted_cands):
            pos = cand[sort_idx]
            keep = False
            if i > 0 and abs(pos - sorted_cands[i-1][sort_idx]) < median_gap * 2.5:
                keep = True
            if i < len(sorted_cands) - 1 and abs(pos - sorted_cands[i+1][sort_idx]) < median_gap * 2.5:
                keep = True
            if keep or len(sorted_cands) <= 3:
                filtered.append(cand)
        
        return filtered

    # ── Dimension Chain Extraction ────────────────────────────────────────────

    def _extract_dimension_chains(self, spd: StructuredPageData) -> list[DimensionChain]:
        """
        Extract dimension chains from text near page borders.
        
        Looks for consecutive numbers (typically 3-5 digits for mm, or 1-2 digits for m)
        along the page edges that represent grid spacing.
        """
        chains = []
        pw, ph = spd.page_width, spd.page_height

        for axis, is_x in [("X", True), ("Y", False)]:
            border_tokens = []

            for t in spd.all_text:
                # Look for numeric text
                text = t.text.strip()
                if not re.match(r'^\d{1,5}(?:\.\d+)?$', text):
                    continue

                if is_x:
                    # X-axis: near top or bottom border
                    if t.cy < ph * 0.12 or t.cy > ph * 0.88:
                        border_tokens.append((t.cx, text))
                else:
                    # Y-axis: near left or right border
                    if t.cx < pw * 0.12 or t.cx > pw * 0.88:
                        border_tokens.append((t.cy, text))

            if not border_tokens:
                continue

            # Sort by position
            border_tokens.sort(key=lambda v: v[0])

            # Find consecutive dimension chain
            # Strategy: look for clusters of numbers that are evenly spaced
            # and have values in the range 1000-15000 (typical mm) or 1-15 (meters)
            values = []
            positions = []

            for pos, text in border_tokens:
                try:
                    val = float(text)
                except ValueError:
                    continue

                # Determine unit
                if val < 100 and val > 0.1:
                    # Meters → convert to mm
                    val_mm = val * 1000
                elif val >= 100:
                    val_mm = val
                else:
                    continue

                # Filter unrealistic values
                if val_mm < 500 or val_mm > 50000:
                    continue

                values.append(val_mm)
                positions.append(pos)

            # Cluster: consecutive dimension chain values should be evenly spaced
            if len(values) >= 2:
                # Build cumulative positions
                cum_positions = [0.0]
                for v in values:
                    cum_positions.append(cum_positions[-1] + v)

                chains.append(DimensionChain(
                    axis=axis,
                    values=values,
                    positions=cum_positions,
                    unit="mm",
                    confidence=0.7 if len(values) >= 3 else 0.4,
                    raw_text=", ".join(str(v) for v in values),
                ))

        return chains

    # ── Level Marker Extraction ───────────────────────────────────────────────

    LEVEL_PATTERNS = [
        (re.compile(r'^(?:RL|EL|FFL|TOS|FL|LEVEL)\s*[:\s]?\s*([\d.]+)', re.IGNORECASE), "number_in_label"),
        (re.compile(r'^(BASE|GROUND|GND|FOUNDATION)$', re.IGNORECASE), "base"),
        (re.compile(r'^(FL\s*\d+|LEVEL\s*\d+|TẦNG\s*\d+)$', re.IGNORECASE), "floor"),
        (re.compile(r'^(ROOF|MÁI|PARAPET|RIDGE|EAVE|HAUNCH|APEX)$', re.IGNORECASE), "roof"),
        (re.compile(r'^C[ỐÔ]T\s*([\d.]+)', re.IGNORECASE), "viet_level"),
    ]

    def _extract_level_markers(self, spd: StructuredPageData) -> list[LevelMarker]:
        """Extract floor level markers from elevation/section pages."""
        markers = []
        seen_names = set()

        for t in spd.all_text:
            text = t.text.strip()
            if not text:
                continue

            for pattern, marker_type in self.LEVEL_PATTERNS:
                m = pattern.match(text)
                if not m:
                    continue

                if marker_type == "number_in_label":
                    try:
                        z_val = float(m.group(1))
                        if z_val < 100:
                            z_val *= 1000  # meters → mm
                    except ValueError:
                        continue
                    name = text
                    z_mm = z_val

                elif marker_type == "base":
                    name = text.upper()
                    z_mm = 0.0

                elif marker_type in ("floor",):
                    name = text.upper()
                    if name not in seen_names:
                        z_mm = 0.0  # Will be resolved later
                    else:
                        continue

                elif marker_type == "roof":
                    name = text.upper()
                    z_mm = 0.0  # Will be resolved later

                elif marker_type == "viet_level":
                    try:
                        z_val = float(m.group(1))
                        if z_val < 100:
                            z_val *= 1000
                    except ValueError:
                        z_val = 0.0
                    name = f"CỐT {z_val:.0f}"
                    z_mm = z_val

                else:
                    continue

                if name not in seen_names:
                    seen_names.add(name)
                    markers.append(LevelMarker(
                        name=name,
                        z_mm=z_mm,
                        py=t.cy,
                        page=spd.page_index,
                        confidence=0.9,
                    ))
                break  # Only match first pattern

        # Sort by Y position (top of page = highest elevation typically)
        markers.sort(key=lambda m: m.py)

        # Resolve z_mm for levels without explicit heights
        self._resolve_level_heights(markers, spd)

        return markers

    def _resolve_level_heights(self, markers: list[LevelMarker], spd: StructuredPageData):
        """
        Resolve z_mm for level markers that don't have explicit heights.
        Strategy: estimate from position on page, or use typical floor heights.
        """
        # Find any marker with explicit z_mm to use as reference
        ref_marker = None
        for m in markers:
            if m.z_mm > 0:
                ref_marker = m
                break

        if ref_marker:
            # Scale based on Y position relative to reference
            ref_y = ref_marker.py
            ref_z = ref_marker.z_mm
            # Typical scale: 100pt = 3000mm (one floor)
            scale = 30  # mm per pt (rough estimate)
            
            for m in markers:
                if m.z_mm == 0 and m.py != ref_y:
                    dy = ref_y - m.py
                    m.z_mm = ref_z + dy * scale
        else:
            # No reference — use typical floor heights
            typical_floor = 3500  # mm
            base_y = max(m.py for m in markers) if markers else 0
            for i, m in enumerate(markers):
                dy = base_y - m.py
                m.z_mm = round(dy / 100) * typical_floor if dy > 10 else 0

        # Round to nearest 50mm
        for m in markers:
            m.z_mm = round(m.z_mm / 50) * 50

    # ── Member Mark Extraction (for plan pages) ───────────────────────────────

    MEMBER_MARK_PATTERN = re.compile(
        r'^([CBRWS]\d+[a-z]*|[A-Z]{1,2}\d+)$', re.IGNORECASE
    )

    def _extract_member_marks(self, spd: StructuredPageData) -> list[MemberMark]:
        """Extract structural member marks from plan pages."""
        marks = []
        seen = set()

        for t in spd.all_text:
            text = t.text.strip()
            if not text:
                continue

            m = self.MEMBER_MARK_PATTERN.match(text)
            if m:
                mark = m.group(1).upper()
                if mark not in seen:
                    seen.add(mark)
                    # Infer type from prefix
                    mtype = "unknown"
                    prefix = mark[0].upper() if mark else ""
                    if prefix == "C":
                        mtype = "column"
                    elif prefix == "B" or prefix == "R":
                        mtype = "beam"
                    elif prefix == "W":
                        mtype = "wall"
                    elif prefix == "S":
                        mtype = "slab"

                    marks.append(MemberMark(
                        mark=mark,
                        cx=t.cx,
                        cy=t.cy,
                        page=spd.page_index,
                        member_type=mtype,
                    ))

        return marks

    # ── Table Extraction ─────────────────────────────────────────────────────

    def _extract_tables(self, page, page_index: int) -> list[TableData]:
        """Extract tables from schedule pages."""
        tables = []
        try:
            extracted = page.extract_tables({
                "vertical_strategy": "lines",
                "horizontal_strategy": "lines",
            })
            if extracted:
                for i, table in enumerate(extracted):
                    if table and len(table) >= 2:  # need at least header + 1 row
                        # Clean up cells
                        clean_rows = []
                        for row in table:
                            clean_row = [
                                str(cell).strip() if cell else ""
                                for cell in row
                            ]
                            if any(clean_row):  # skip empty rows
                                clean_rows.append(clean_row)

                        if len(clean_rows) >= 2:
                            headers = clean_rows[0]
                            rows = clean_rows[1:]
                            tables.append(TableData(
                                headers=headers,
                                rows=rows,
                                page=page_index,
                                table_type=self._classify_table(headers),
                            ))
        except Exception:
            pass
        return tables

    def _classify_table(self, headers: list[str]) -> str:
        """Classify table type from headers."""
        headers_str = " ".join(h.lower() for h in headers)
        if any(kw in headers_str for kw in ["mark", "member", "section", "length", "weight"]):
            return "steel_schedule"
        if any(kw in headers_str for kw in ["material", "grade", "qty", "quantity"]):
            return "material_list"
        return "unknown"

    # ── Scale Detection ──────────────────────────────────────────────────────

    def _detect_scale(self, spd: StructuredPageData) -> Optional[str]:
        """Detect drawing scale from text annotations."""
        scale_pattern = re.compile(r'(?:SCALE|SC|TL|TỈ LỆ)\s*[:\s]*\s*1\s*[:/]\s*(\d+)', re.IGNORECASE)
        for t in spd.all_text:
            m = scale_pattern.search(t.text)
            if m:
                return f"1:{m.group(1)}"
        return None

    # ── Title Detection ──────────────────────────────────────────────────────

    def _detect_title(self, spd: StructuredPageData) -> Optional[str]:
        """Detect drawing title (usually largest text near top)."""
        # Find largest text near top 20% of page
        top_tokens = [t for t in spd.all_text if t.cy < spd.page_height * 0.2]
        if top_tokens:
            # Return longest non-numeric text
            candidates = sorted(
                [t for t in top_tokens if len(t.text) > 5],
                key=lambda t: len(t.text),
                reverse=True,
            )
            if candidates:
                return candidates[0].text
        return None


# ============================================================================
# CONVENIENCE FUNCTIONS
# ============================================================================

def extract_all_structured_data(pdf_path: str) -> dict:
    """
    Extract all structured data from a PDF and return as a dict
    suitable for consumption by grid_math_engine and other agents.
    
    Returns:
    {
        "filename": str,
        "num_pages": int,
        "pages": [StructuredPageData (as dict), ...],
        "global_summary": {
            "plan_pages": [int, ...],
            "elevation_pages": [int, ...],
            "schedule_pages": [int, ...],
            "total_grid_labels": int,
            "total_dimension_chains": int,
            "total_level_markers": int,
        }
    }
    """
    parser = PDFStructuredParser(pdf_path)
    pages = parser.parse_all()

    # Build global summary
    plan_pages = []
    elevation_pages = []
    schedule_pages = []

    for p in pages:
        if p.page_type == "plan":
            plan_pages.append(p.page_index)
        elif p.page_type in ("elevation", "section"):
            elevation_pages.append(p.page_index)
        elif p.page_type == "schedule":
            schedule_pages.append(p.page_index)

    # Serialize pages to dict
    pages_dict = [_structured_page_to_dict(p) for p in pages]

    return {
        "filename": Path(pdf_path).name,
        "num_pages": len(pages),
        "pages": pages_dict,
        "global_summary": {
            "plan_pages": plan_pages,
            "elevation_pages": elevation_pages,
            "schedule_pages": schedule_pages,
            "total_grid_labels": sum(len(p.grid_labels) for p in pages),
            "total_dimension_chains": sum(len(p.dimension_chains) for p in pages),
            "total_level_markers": sum(len(p.level_markers) for p in pages),
        },
    }


def _structured_page_to_dict(spd: StructuredPageData) -> dict:
    """Convert StructuredPageData to JSON-serializable dict."""
    return {
        "page_index": spd.page_index,
        "page_width": spd.page_width,
        "page_height": spd.page_height,
        "page_type": spd.page_type,
        "all_text_count": len(spd.all_text),
        "grid_labels": [
            {"label": g.label, "axis": g.axis, "px": g.px, "py": g.py,
             "page": g.page, "confidence": g.confidence}
            for g in spd.grid_labels
        ],
        "dimension_chains": [
            {"axis": dc.axis, "values": dc.values, "positions": dc.positions,
             "unit": dc.unit, "confidence": dc.confidence, "raw_text": dc.raw_text}
            for dc in spd.dimension_chains
        ],
        "level_markers": [
            {"name": lm.name, "z_mm": lm.z_mm, "py": lm.py,
             "page": lm.page, "confidence": lm.confidence}
            for lm in spd.level_markers
        ],
        "member_marks": [
            {"mark": mm.mark, "cx": mm.cx, "cy": mm.cy,
             "page": mm.page, "member_type": mm.member_type, "confidence": mm.confidence}
            for mm in spd.member_marks
        ],
        "tables": [
            {"headers": t.headers, "rows": t.rows,
             "page": t.page, "table_type": t.table_type}
            for t in spd.tables
        ],
        "scale_text": spd.scale_text,
        "drawing_title": spd.drawing_title,
        "raw_lines_count": len(spd.raw_lines),
    }