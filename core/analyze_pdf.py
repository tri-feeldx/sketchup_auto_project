"""
PDF Dimension & Grid Coordinate Extractor.

Extracts real mm coordinates for grid lines by:
1. Parsing dimension annotations from PDF text layer (e.g. "7200", "6@7200=43200")
2. Detecting scale notation (e.g. "1:100", "SCALE 1:200")
3. Detecting grid lines with OpenCV (if available)
4. Mapping grid labels (A, B, 1, 2) → cumulative mm positions

This replaces the guessed 4000 / 6000 mm default spacing.
"""

from __future__ import annotations

import re
from dataclasses import dataclass, field
from typing import Optional
import logging

log = logging.getLogger(__name__)


# ──────────────────────────────────────────────────────────────
# Data structures
# ──────────────────────────────────────────────────────────────

@dataclass
class GridCoordinates:
    """Resolved grid positions in mm, keyed by grid label."""
    x_coords: dict[str, float] = field(default_factory=dict)  # {"1": 0, "2": 7200, ...}
    y_coords: dict[str, float] = field(default_factory=dict)  # {"A": 0, "B": 6000, ...}
    scale: Optional[float] = None       # e.g. 0.01 for 1:100
    confidence: float = 0.0
    source: str = "unknown"             # "dimension_text" | "opencv" | "default"


@dataclass
class DimensionChain:
    """A sequence of dimensions found on a single axis."""
    values_mm: list[float]              # [7200, 7200, 6000, ...]
    total_mm: float
    repetition: Optional[str] = None   # "6@7200" raw string


# ──────────────────────────────────────────────────────────────
# Scale detection
# ──────────────────────────────────────────────────────────────

# Common scale notations found in structural drawings
_SCALE_PATTERNS = [
    r'1\s*:\s*(\d+)',               # "1:100", "1 : 200"
    r'SCALE\s+1\s*:\s*(\d+)',       # "SCALE 1:100"
    r'SC\s*1\s*:\s*(\d+)',          # "SC 1:100"
    r'TL\s+1\s*:\s*(\d+)',          # Vietnamese "TL 1:100"
    r'(\d+)\s*:\s*1',               # Reversed "100:1" (rare, invert)
]


def detect_scale(text: str) -> Optional[float]:
    """
    Detect drawing scale from text.  Returns the real/drawing ratio.
    e.g. "1:100" → 0.01  (1 mm on paper = 100 mm real)
    """
    for pat in _SCALE_PATTERNS:
        for m in re.finditer(pat, text, re.IGNORECASE):
            try:
                denom = int(m.group(1))
                if 1 < denom < 10000:
                    return 1.0 / denom
            except (IndexError, ValueError):
                pass
    return None


# ──────────────────────────────────────────────────────────────
# Dimension annotation parsing
# ──────────────────────────────────────────────────────────────

# Matches like: "7200", "6000", "7200 TYP", "6@7200=43200", "2x6000", "@5000"
_DIM_REPEAT = re.compile(
    r'(\d+)\s*[@x×]\s*(\d+)\s*(?:=\s*(\d+))?',  # "6@7200=43200" or "3x5000"
    re.IGNORECASE
)
_DIM_SINGLE = re.compile(
    r'\b(\d{3,6})\b'  # 3-6 digit numbers (100-999999 mm range)
)
_DIM_GRID_SPACING = re.compile(
    r'(\d{4,6})\s*(?:TYP|mm|M\b)',  # "7200 TYP", "6000 mm"
    re.IGNORECASE
)


def parse_dimension_chains(text: str) -> list[DimensionChain]:
    """
    Extract dimension chains from PDF text layer.
    Returns a list of DimensionChain objects sorted by total length.
    """
    chains: list[DimensionChain] = []

    # 1. Repetition patterns: "6@7200=43200", "3×5000"
    for m in _DIM_REPEAT.finditer(text):
        count_str, spacing_str = m.group(1), m.group(2)
        try:
            count = int(count_str)
            spacing = int(spacing_str)
            if 2 <= count <= 20 and 500 <= spacing <= 30000:
                chains.append(DimensionChain(
                    values_mm=[float(spacing)] * count,
                    total_mm=count * spacing,
                    repetition=m.group(0),
                ))
        except ValueError:
            pass

    # 2. Typical spacing markers: "7200 TYP"
    typ_spacings: list[float] = []
    for m in _DIM_GRID_SPACING.finditer(text):
        try:
            v = int(m.group(1))
            if 500 <= v <= 30000:
                typ_spacings.append(float(v))
        except ValueError:
            pass
    if typ_spacings:
        # Most common value = the grid spacing
        from collections import Counter
        spacing = Counter(typ_spacings).most_common(1)[0][0]
        chains.append(DimensionChain(values_mm=[spacing], total_mm=spacing))

    # 3. All standalone numbers that look like grid spacings
    candidates: list[float] = []
    for m in _DIM_SINGLE.finditer(text):
        try:
            v = int(m.group(1))
            # Structural grid spacings: 1000–15000 mm are typical
            if 1000 <= v <= 15000 and v % 100 == 0:
                candidates.append(float(v))
        except ValueError:
            pass
    if candidates:
        from collections import Counter
        # Rank by frequency; most repeated value is likely grid spacing
        for val, cnt in Counter(candidates).most_common(5):
            if cnt >= 2 or (len(candidates) < 5 and cnt >= 1):
                chains.append(DimensionChain(values_mm=[val] * cnt, total_mm=val * cnt))

    # Deduplicate and sort by confidence (longer total = more reliable)
    seen: set[float] = set()
    unique: list[DimensionChain] = []
    for c in sorted(chains, key=lambda x: -x.total_mm):
        key = round(c.values_mm[0] if c.values_mm else 0)
        if key not in seen:
            seen.add(key)
            unique.append(c)
    return unique


# ──────────────────────────────────────────────────────────────
# Grid label extraction
# ──────────────────────────────────────────────────────────────

# Numeric grid labels: "1", "2", "3" (X axis convention)
_GRID_NUM = re.compile(r'(?<!\d)([1-9]\d?)(?!\d)')
# Letter grid labels: "A", "B", "C" (Y axis convention)
_GRID_ALPHA = re.compile(r'\b([A-H])\b')
# Vietnamese: "Trục 1", "Trục A"
_GRID_VN = re.compile(r'Tr[uụ]c\s+([A-H0-9]{1,2})', re.IGNORECASE)


def extract_grid_labels(text: str) -> tuple[list[str], list[str]]:
    """
    Extract grid labels from text. Returns (x_labels, y_labels).
    x_labels = numeric ('1','2','3'), y_labels = alpha ('A','B','C').
    """
    x_labels: list[str] = []
    y_labels: list[str] = []

    # Vietnamese notation
    for m in _GRID_VN.finditer(text):
        label = m.group(1).upper()
        if label.isdigit():
            x_labels.append(label)
        else:
            y_labels.append(label)

    # Standalone numbers (grid axes)
    for m in _GRID_NUM.finditer(text):
        x_labels.append(m.group(1))
    # Standalone letters
    for m in _GRID_ALPHA.finditer(text):
        y_labels.append(m.group(1))

    # Deduplicate while preserving order
    def dedup(lst: list[str]) -> list[str]:
        seen: set[str] = set()
        return [x for x in lst if x not in seen and not seen.add(x)]  # type: ignore[func-returns-value]

    x_labels = sorted(set(x_labels), key=lambda v: int(v) if v.isdigit() else 99)
    y_labels = sorted(set(y_labels))
    return x_labels, y_labels


# ──────────────────────────────────────────────────────────────
# OpenCV grid-line detection (optional, falls back gracefully)
# ──────────────────────────────────────────────────────────────

def detect_grid_lines_opencv(image_bytes: bytes, dpi: int = 200) -> tuple[list[float], list[float]]:
    """
    Detect grid lines from a rendered page image using OpenCV.
    Returns (x_positions_mm, y_positions_mm) — pixel positions converted to mm.
    Pixels are in DPI-space; 1 px = 25.4/dpi mm.
    """
    try:
        import cv2
        import numpy as np
        from PIL import Image
        import io

        px_to_mm = 25.4 / dpi

        img = Image.open(io.BytesIO(image_bytes)).convert("L")
        arr = np.array(img)
        # Binarize
        _, binary = cv2.threshold(arr, 200, 255, cv2.THRESH_BINARY_INV)

        # Detect horizontal lines (grid Y)
        h_kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (arr.shape[1] // 3, 1))
        h_lines = cv2.morphologyEx(binary, cv2.MORPH_OPEN, h_kernel)
        h_contours, _ = cv2.findContours(h_lines, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
        y_px: list[float] = []
        for cnt in h_contours:
            y_center = cv2.boundingRect(cnt)[1]
            y_px.append(float(y_center))

        # Detect vertical lines (grid X)
        v_kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (1, arr.shape[0] // 3))
        v_lines = cv2.morphologyEx(binary, cv2.MORPH_OPEN, v_kernel)
        v_contours, _ = cv2.findContours(v_lines, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
        x_px: list[float] = []
        for cnt in v_contours:
            x_center = cv2.boundingRect(cnt)[0]
            x_px.append(float(x_center))

        x_mm = sorted(set(round(px * px_to_mm) for px in x_px))
        y_mm = sorted(set(round(px * px_to_mm) for px in y_px))
        return x_mm, y_mm

    except ImportError:
        log.debug("OpenCV not available — skipping grid line detection")
        return [], []
    except Exception as e:
        log.debug(f"OpenCV grid detection failed: {e}")
        return [], []


# ──────────────────────────────────────────────────────────────
# Main extractor class
# ──────────────────────────────────────────────────────────────

class PDFDimensionExtractor:
    """
    Extracts grid coordinates from a PDF file.

    Usage:
        ext = PDFDimensionExtractor("drawing.pdf")
        coords = ext.extract_grid_coordinates(page_idx=0)
        # coords.x_coords → {"1": 0, "2": 7200, "3": 14400, ...}
        # coords.y_coords → {"A": 0, "B": 6000, "C": 12000, ...}
    """

    # Default regional grid spacings (mm) used as fallback
    _DEFAULT_SPACINGS = {
        "au": (7200.0, 6000.0),    # Australian industrial/commercial
        "vn": (4000.0, 4000.0),    # Vietnamese residential
        "intl": (6000.0, 6000.0),  # International
    }

    def __init__(self, pdf_path: str, region: str = "au"):
        self.pdf_path = pdf_path
        self.region = region.lower()

    def extract_grid_coordinates(
        self,
        page_idx: int = 0,
        page_text: str = "",
        image_bytes: Optional[bytes] = None,
        dpi: int = 200,
        x_labels: Optional[list[str]] = None,
        y_labels: Optional[list[str]] = None,
    ) -> GridCoordinates:
        """
        Extract grid coordinates for a given page.

        Args:
            page_idx:    PDF page index (0-based)
            page_text:   Pre-extracted text for this page
            image_bytes: Rendered page image (PNG/JPEG bytes) — enables OpenCV
            dpi:         DPI of the rendered image
            x_labels:    Known X-axis grid labels (override auto-detect)
            y_labels:    Known Y-axis grid labels (override auto-detect)
        """
        text = page_text or self._read_page_text(page_idx)

        # Detect scale
        scale = detect_scale(text)

        # Extract labels
        if x_labels is None or y_labels is None:
            _x, _y = extract_grid_labels(text)
            x_labels = x_labels or _x
            y_labels = y_labels or _y

        # Parse dimension chains
        chains = parse_dimension_chains(text)

        # Try OpenCV grid detection if image provided
        x_mm_cv, y_mm_cv = [], []
        if image_bytes:
            x_mm_cv, y_mm_cv = detect_grid_lines_opencv(image_bytes, dpi)

        # Resolve X spacings → cumulative coordinates
        x_coords = self._assign_coords(x_labels, chains, x_mm_cv, axis="x")
        y_coords = self._assign_coords(y_labels, chains, y_mm_cv, axis="y")

        # Compute confidence
        confidence = self._confidence(x_coords, y_coords, scale, chains, x_mm_cv)

        return GridCoordinates(
            x_coords=x_coords,
            y_coords=y_coords,
            scale=scale,
            confidence=confidence,
            source="dimension_text" if chains else ("opencv" if x_mm_cv else "default"),
        )

    # ── Internals ──────────────────────────────────────────

    def _read_page_text(self, page_idx: int) -> str:
        """Read text from PDF page using PyMuPDF."""
        try:
            import fitz
            with fitz.open(self.pdf_path) as doc:
                if page_idx < len(doc):
                    return doc[page_idx].get_text()
        except Exception as e:
            log.debug(f"fitz read page {page_idx}: {e}")
        return ""

    def _assign_coords(
        self,
        labels: list[str],
        chains: list[DimensionChain],
        cv_positions_mm: list[float],
        axis: str,
    ) -> dict[str, float]:
        """
        Assign cumulative mm coordinates to each label.
        Priority: OpenCV detected positions > dimension chains > default spacing.
        """
        if not labels:
            return {}

        n = len(labels)

        # 1. Use OpenCV positions if they match the label count
        if cv_positions_mm and abs(len(cv_positions_mm) - n) <= 1:
            positions = sorted(cv_positions_mm)[:n]
            # Normalize so first grid = 0
            base = positions[0]
            return {lbl: round(positions[i] - base) for i, lbl in enumerate(labels)}

        # 2. Use dimension chain to compute spacings
        spacing = self._best_spacing(chains, n)

        # 3. Fall back to regional default
        if spacing is None:
            def_x, def_y = self._DEFAULT_SPACINGS.get(self.region, (6000.0, 6000.0))
            spacing = def_x if axis == "x" else def_y

        return {lbl: round(i * spacing) for i, lbl in enumerate(labels)}

    def _best_spacing(self, chains: list[DimensionChain], n_grids: int) -> Optional[float]:
        """
        Pick the best single spacing value from parsed dimension chains.
        Prefers values that divide evenly into the expected grid count.
        """
        if not chains:
            return None
        # Use the most dominant (first, largest total) chain's unit spacing
        for chain in chains:
            if chain.values_mm:
                s = chain.values_mm[0]
                if 500 <= s <= 30000:
                    return s
        return None

    def _confidence(
        self,
        x_coords: dict,
        y_coords: dict,
        scale: Optional[float],
        chains: list[DimensionChain],
        cv_x: list[float],
    ) -> float:
        score = 0.0
        if x_coords:
            score += 0.25
        if y_coords:
            score += 0.25
        if scale:
            score += 0.2
        if chains:
            score += 0.2
        if cv_x:
            score += 0.1
        return round(score, 2)


# ──────────────────────────────────────────────────────────────
# Convenience function
# ──────────────────────────────────────────────────────────────

def extract_grid_from_pdf(
    pdf_path: str,
    region: str = "au",
    x_labels: Optional[list[str]] = None,
    y_labels: Optional[list[str]] = None,
) -> GridCoordinates:
    """
    Extract grid coordinates from the first plan page of a PDF.
    Returns GridCoordinates with x_coords and y_coords dicts.
    """
    ext = PDFDimensionExtractor(pdf_path, region=region)
    # Try first 5 pages, use the one with highest confidence
    best: Optional[GridCoordinates] = None
    for idx in range(5):
        try:
            coords = ext.extract_grid_coordinates(
                page_idx=idx,
                x_labels=x_labels,
                y_labels=y_labels,
            )
            if best is None or coords.confidence > best.confidence:
                best = coords
            if coords.confidence >= 0.7:
                break
        except Exception:
            continue
    return best or GridCoordinates(source="default")


if __name__ == "__main__":
    import sys
    if len(sys.argv) < 2:
        print("Usage: python analyze_pdf.py <pdf_path> [region]")
        sys.exit(1)
    path = sys.argv[1]
    reg = sys.argv[2] if len(sys.argv) > 2 else "au"
    result = extract_grid_from_pdf(path, region=reg)
    print(f"Scale:      {result.scale}")
    print(f"Confidence: {result.confidence}")
    print(f"Source:     {result.source}")
    print(f"X grids:    {result.x_coords}")
    print(f"Y grids:    {result.y_coords}")
