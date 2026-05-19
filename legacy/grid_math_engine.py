"""
=============================================================================
GRID MATH ENGINE — Build Grid System from Structured PDF Data (Zero-LLM)
=============================================================================
This is the HEART of the new architecture. Takes raw text/vector data from
pdf_structured_parser and builds a reliable grid system using MATH + CLUSTERING.

NO LLM Vision needed. Cost: $0. Accuracy: deterministic.

ARCHITECTURE:
  1. GridLabelClusterer: cluster grid labels by position + axis → grid lines
  2. DimensionChainResolver: parse dimension chains → mm distances
  3. GridBuilder: merge labels + dimensions → complete GridSystem
  4. ScaleDetector: compute px-to-mm ratio from known dimensions
  
OUTPUT: GridSystem with:
  - grids_x: dict[label → mm_x] (e.g., {"A": 0, "B": 6000, "C": 12000})
  - grids_y: dict[label → mm_y] (e.g., {"1": 0, "2": 4500, "3": 9000})
  - levels: list[dict] (z coordinates for each floor level)
"""

import json
import math
import re
from collections import defaultdict
from dataclasses import dataclass, field
from pathlib import Path
from typing import Optional

try:
    import numpy as np
except ImportError:
    np = None

from core.pdf_structured_parser import (
    StructuredPageData, GridLabel, DimensionChain, LevelMarker,
    MemberMark, TableData, TextToken,
)


# ============================================================================
# DATA STRUCTURES
# ============================================================================

@dataclass
class GridLine:
    """A single grid line with position."""
    label: str
    axis: str  # "X" or "Y"
    mm_position: float
    px_position: float  # page pixel position
    page: int
    confidence: float = 0.8


@dataclass
class GridSystem:
    """Complete grid system for the building."""
    # grids_x[label] = mm_position (e.g., {"A": 0, "B": 8000})
    grids_x: dict[str, float] = field(default_factory=dict)
    # grids_y[label] = mm_position  (e.g., {"1": 0, "2": 6000})
    grids_y: dict[str, float] = field(default_factory=dict)
    # All grid lines
    all_grid_lines: list[GridLine] = field(default_factory=list)
    # Scale factor: px → mm
    scale_x: float = 1.0  # mm per px
    scale_y: float = 1.0
    # Level markers
    levels: list[LevelMarker] = field(default_factory=list)
    # Metadata
    origin_offset: tuple = (0, 0)  # (offset_x_mm, offset_y_mm)
    building_bbox_mm: tuple = (0, 0, 50000, 50000)  # (x0, y0, x1, y1)
    confidence: float = 0.0


# ============================================================================
# GRID MATH ENGINE — Main Class
# ============================================================================

class GridMathEngine:
    """
    Build a complete GridSystem from structured PDF data.
    
    Strategy:
      1. Collect ALL grid labels across all plan pages
      2. Cluster labels by axis (X vs Y) using position heuristics
      3. Sort labels by page position → determine order
      4. Parse dimension chains → get mm distances
      5. Compute scale factor: px → mm
      6. Assign mm positions to each grid label
      7. Merge across multiple pages (same building, different floors)
    """

    def __init__(self, structured_pages: list[StructuredPageData]):
        self.pages = structured_pages
        self.plan_pages = [p for p in structured_pages if p.page_type == "plan"]
        self.elevation_pages = [p for p in structured_pages if p.page_type in ("elevation", "section")]
        self.schedule_pages = [p for p in structured_pages if p.page_type == "schedule"]

    def build(self) -> GridSystem:
        """Build the complete grid system."""
        gs = GridSystem()

        # 1. Collect all grid labels from plan pages
        all_labels = self._collect_grid_labels()
        
        # 2. Separate X and Y labels
        x_labels, y_labels = self._separate_axes(all_labels)
        
        # 3. Build grid lines for each axis
        x_lines = self._build_grid_lines(x_labels, "X")
        y_lines = self._build_grid_lines(y_labels, "Y")

        # 4. Compute scale from dimension chains
        scale_x, scale_y = self._compute_scale()
        gs.scale_x = scale_x
        gs.scale_y = scale_y

        # 5. Assign mm positions using dimension chains
        x_lines = self._resolve_mm_positions(x_lines, "X", scale_x)
        y_lines = self._resolve_mm_positions(y_lines, "Y", scale_y)

        # 6. Build the dict structures
        gs.grids_x = {line.label: line.mm_position for line in x_lines}
        gs.grids_y = {line.label: line.mm_position for line in y_lines}
        gs.all_grid_lines = x_lines + y_lines

        # 7. Extract levels from elevation pages
        gs.levels = self._extract_all_levels()

        # 8. Compute confidence
        gs.confidence = self._compute_confidence(x_lines, y_lines)

        # 9. Set building bounding box
        gs.building_bbox_mm = self._compute_bbox(gs)

        return gs

    # ── Collect Grid Labels ──────────────────────────────────────────────────

    def _collect_grid_labels(self) -> list[GridLabel]:
        """Collect all grid labels from all plan pages."""
        all_labels = []
        for page in self.plan_pages:
            all_labels.extend(page.grid_labels)
        
        # If no plan pages, try elevation pages (for single-axis grids)
        if not all_labels:
            for page in self.elevation_pages:
                all_labels.extend(page.grid_labels)
        
        # ── CROSS-PAGE SMART FILTER ──────────────────────────────
        # Strategy: UNION + STABILITY
        #   - Union all unique labels across pages (each floor may have different grids)
        #   - But FILTER OUT labels that are clearly dimension callouts:
        #     * Labels like '21','90' that appear on ALL pages but have different
        #       spatial neighbors on each page are dimension refs, not grid lines
        #     * Labels that appear on EVERY page AND are spatially isolated
        #       (different row group than main grid) → dimension callout
        #   - Keep labels that are PART OF THE SPATIAL CLUSTER on their page
        # ──────────────────────────────────────────────────────────
        if len(self.plan_pages) >= 2:
            # Count pages each label appears on
            label_page_counts = defaultdict(set)
            label_page_positions = defaultdict(list)  # (label,axis) -> [(page, py, px)]
            
            for label in all_labels:
                key = (label.label, label.axis)
                label_page_counts[key].add(label.page)
                label_page_positions[key].append((label.page, label.py, label.px))
            
            # ── DIMENSION CALLOUT DETECTION ───────────────────
            # Dimension labels appear on EVERY page (like real grid)
            # but float at different spatial positions on each page.
            # Real grid labels have consistent spatial position across pages.
            dimension_labels = set()
            for key, positions in label_page_positions.items():
                if len(positions) >= len(self.plan_pages):
                    # Appears on all pages — could be grid OR dimension
                    # Check spatial consistency:
                    # Real grid: same py (or px for Y) across pages (±10% page height)
                    pys = [p[1] for p in positions]
                    pxs = [p[2] for p in positions]
                    
                    # Use coefficient of variation to measure spread
                    if len(pys) >= 2:
                        mean_py = sum(pys) / len(pys)
                        if mean_py > 0:
                            cv_y = (sum((y - mean_py)**2 for y in pys) / len(pys))**0.5 / mean_py
                            # High CV = inconsistent position = likely dimension callout
                            if cv_y > 0.15:  # 15% variation threshold
                                dimension_labels.add(key)
                    
                    if len(pxs) >= 2 and key not in dimension_labels:
                        mean_px = sum(pxs) / len(pxs)
                        if mean_px > 0:
                            cv_x = (sum((x - mean_px)**2 for x in pxs) / len(pxs))**0.5 / mean_px
                            if cv_x > 0.15:
                                dimension_labels.add(key)
            
            # ── UNION FILTER ──────────────────────────────────
            # Keep labels that are NOT dimension callouts
            # AND appear on at least 1 page (union strategy)
            filtered = []
            for label in all_labels:
                key = (label.label, label.axis)
                if key not in dimension_labels:
                    filtered.append(label)
            
            all_labels = filtered
        
        return all_labels

    # ── Separate X vs Y Axes ─────────────────────────────────────────────────

    def _separate_axes(self, labels: list[GridLabel]) -> tuple[list[GridLabel], list[GridLabel]]:
        """
        Separate grid labels into X and Y axes using position heuristics.
        
        Heuristics:
        - X-axis labels typically appear near top/bottom of page
        - Y-axis labels typically appear near left/right of page
        - Letters tend to be X-axis, numbers tend to be Y-axis
        - Global clustering across all pages to determine convention
        """
        x_labels = []
        y_labels = []
        
        # Collect page dimensions for reference
        if self.plan_pages:
            avg_w = sum(p.page_width for p in self.plan_pages) / len(self.plan_pages)
            avg_h = sum(p.page_height for p in self.plan_pages) / len(self.plan_pages)
        elif self.pages:
            avg_w = sum(p.page_width for p in self.pages) / len(self.pages)
            avg_h = sum(p.page_height for p in self.pages) / len(self.pages)
        else:
            avg_w, avg_h = 595, 842  # A4 default

        # ── SPATIAL ROW-GROUPING ─────────────────────────────────
        # Strategy:
        #   Group labels by their py (Y-position) for X-axis candidates.
        #   Real grid labels form a tight horizontal row (same py),
        #   while dimension callouts float at different heights.
        #   Keep ONLY the largest row group for each axis.
        # ──────────────────────────────────────────────────────────
        
        def row_key(py_pos, tolerance=8.0):
            """Quantize a position into a row bucket."""
            return round(py_pos / tolerance) * tolerance
        
        def col_key(px_pos, tolerance=8.0):
            """Quantize a position into a column bucket."""
            return round(px_pos / tolerance) * tolerance
        
        # First pass: classify all labels and build row/col groups
        x_candidates = []  # (label, row_bucket)
        y_candidates = []  # (label, col_bucket)
        
        for label in labels:
            if label.label == "0":
                continue
            
            py = label.py
            px = label.px
            page = self._get_page(label.page)
            if page:
                ph = page.page_height
                pw = page.page_width
            else:
                ph, pw = avg_h, avg_w
            
            # Classify by position
            is_x = False
            is_y = False
            
            if label.axis == "X":
                is_x = True
            elif label.axis == "Y":
                is_y = True
            elif py < ph * 0.2 or py > ph * 0.8:
                # Near top/bottom → X axis
                is_x = True
                label.axis = "X"
            elif px < pw * 0.2 or px > pw * 0.8:
                # Near left/right → Y axis
                is_y = True
                label.axis = "Y"
            elif label.label.isalpha():
                is_x = True
                label.axis = "X"
            else:
                is_y = True
                label.axis = "Y"
            
            if is_x:
                x_candidates.append((label, row_key(py)))
            if is_y:
                y_candidates.append((label, col_key(px)))
        
        # ── ROW-GROUP FILTER for X-axis ──────────────────────
        # Keep only the largest row group (most labels at same py)
        # This eliminates dimension callouts floating at different heights.
        if x_candidates:
            row_groups = defaultdict(list)
            for label, rk in x_candidates:
                row_groups[rk].append(label)
            # Sort groups by size descending
            sorted_rows = sorted(row_groups.items(), key=lambda x: -len(x[1]))
            largest_row = sorted_rows[0][1]
            x_labels = largest_row
        else:
            x_labels = []
        
        # ── COLUMN-GROUP FILTER for Y-axis ──────────────────
        # Keep only the largest column group (most labels at same px)
        if y_candidates:
            col_groups = defaultdict(list)
            for label, ck in y_candidates:
                col_groups[ck].append(label)
            sorted_cols = sorted(col_groups.items(), key=lambda x: -len(x[1]))
            largest_col = sorted_cols[0][1]
            y_labels = largest_col
        else:
            y_labels = []

        return x_labels, y_labels

    def _get_page(self, page_index: int) -> Optional[StructuredPageData]:
        """Get StructuredPageData by page index."""
        for p in self.pages:
            if p.page_index == page_index:
                return p
        return None

    # ── Build Grid Lines ─────────────────────────────────────────────────────

    def _build_grid_lines(self, labels: list[GridLabel], axis: str) -> list[GridLine]:
        """
        Build sorted GridLine objects from labels.
        Sorts by position (X axis → px, Y axis → py).
        """
        if axis == "X":
            # Sort by px (horizontal position)
            labels_sorted = sorted(labels, key=lambda l: l.px)
        else:
            # Sort by py (vertical position), usually descending for Y
            labels_sorted = sorted(labels, key=lambda l: l.py, reverse=True)

        lines = []
        for label in labels_sorted:
            lines.append(GridLine(
                label=label.label,
                axis=axis,
                mm_position=0.0,  # will be resolved later
                px_position=label.px if axis == "X" else label.py,
                page=label.page,
                confidence=label.confidence,
            ))

        return lines

    # ── Compute Scale ────────────────────────────────────────────────────────

    def _compute_scale(self) -> tuple[float, float]:
        """
        Compute scale factor (mm per px) using multiple strategies.
        Priority: scale text > dimension chains > grid label spacing > typical

        Architectural scales:
          1:50   → 50 * 0.3528 = 17.64 mm/point
          1:100  → 100 * 0.3528 = 35.28 mm/point
          1:200  → 200 * 0.3528 = 70.56 mm/point
        Formula: scale_factor = denominator * DRAWING_SCALE_MM_PER_POINT (0.3528)
        """
        DRAWING_SCALE_MM_PER_POINT = 0.3528  # 1 point = 0.3528mm at 72 DPI

        scale_x = 1.0
        scale_y = 1.0

        # PRIORITY 1: Scale text from page (most reliable — architect wrote it!)
        # e.g., "SCALE 1:100", "TỶ LỆ 1:100", "SCALE: 1/100"
        for page in self.pages:
            if page.scale_text:
                m = re.search(r'1\s*[:/]\s*(\d+)', page.scale_text, re.IGNORECASE)
                if m:
                    denominator = int(m.group(1))
                    scale_mm_per_pt = denominator * DRAWING_SCALE_MM_PER_POINT
                    if 1 < scale_mm_per_pt < 200:
                        scale_x = scale_mm_per_pt
                        scale_y = scale_mm_per_pt
                        break

        # PRIORITY 2: Dimension chains matched to grid labels
        if scale_x <= 1.0 or scale_y <= 1.0:
            all_chains = []
            for page in self.pages:
                all_chains.extend(page.dimension_chains)

            all_labels = self._collect_grid_labels()
            x_labels = [l for l in all_labels if l.axis == "X"]
            y_labels = [l for l in all_labels if l.axis == "Y"]

            for chain in all_chains:
                if scale_x <= 1.0 and chain.axis == "X" and len(x_labels) >= 2 and chain.values:
                    x_sorted = sorted(x_labels, key=lambda l: l.px)
                    px_dist = x_sorted[-1].px - x_sorted[0].px
                    mm_dist = sum(chain.values[:len(x_labels)-1]) if len(chain.values) >= len(x_labels)-1 else sum(chain.values)
                    if px_dist > 10 and mm_dist > 0:
                        candidate = mm_dist / px_dist
                        if 1 < candidate < 200:
                            scale_x = candidate

                if scale_y <= 1.0 and chain.axis == "Y" and len(y_labels) >= 2 and chain.values:
                    y_sorted = sorted(y_labels, key=lambda l: l.py, reverse=True)
                    py_dist = abs(y_sorted[-1].py - y_sorted[0].py)
                    mm_dist = sum(chain.values[:len(y_labels)-1]) if len(chain.values) >= len(y_labels)-1 else sum(chain.values)
                    if py_dist > 10 and mm_dist > 0:
                        candidate = mm_dist / py_dist
                        if 1 < candidate < 200:
                            scale_y = candidate

        # PRIORITY 3: Grid label px spacing × 6000mm typical bay
        TYPICAL_GRID_SPACING_MM = 6000.0
        if scale_x <= 1.0 or scale_x > 200:
            all_labels = self._collect_grid_labels()
            x_labels = [l for l in all_labels if l.axis == "X"]
            x_sorted = sorted(x_labels, key=lambda l: l.px)
            if len(x_sorted) >= 2:
                px_gaps = [x_sorted[i].px - x_sorted[i-1].px for i in range(1, len(x_sorted)) if x_sorted[i].px - x_sorted[i-1].px > 5]
                if px_gaps:
                    median_gap = sorted(px_gaps)[len(px_gaps)//2]
                    if median_gap > 0:
                        scale_x = TYPICAL_GRID_SPACING_MM / median_gap

        if scale_y <= 1.0 or scale_y > 200:
            all_labels = self._collect_grid_labels()
            y_labels = [l for l in all_labels if l.axis == "Y"]
            y_sorted = sorted(y_labels, key=lambda l: l.py, reverse=True)
            if len(y_sorted) >= 2:
                px_gaps = [abs(y_sorted[i].py - y_sorted[i-1].py) for i in range(1, len(y_sorted)) if abs(y_sorted[i].py - y_sorted[i-1].py) > 5]
                if px_gaps:
                    median_gap = sorted(px_gaps)[len(px_gaps)//2]
                    if median_gap > 0:
                        scale_y = TYPICAL_GRID_SPACING_MM / median_gap

        # PRIORITY 4: Final fallback — assume 1:100 scale
        if scale_x <= 1.0 or scale_x > 200:
            scale_x = 35.28  # 1:100 typical
        if scale_y <= 1.0 or scale_y > 200:
            scale_y = 35.28

        return scale_x, scale_y

    # ── Resolve MM Positions ─────────────────────────────────────────────────

    def _resolve_mm_positions(self, lines: list[GridLine], axis: str, scale: float) -> list[GridLine]:
        """
        Assign mm positions to grid lines using dimension chains and scale.
        
        Strategy:
        1. Find corresponding dimension chain
        2. Use chain values to compute cumulative mm positions
        3. If no chain: use px spacing * scale factor
        4. Set first grid line to mm=0
        """
        if not lines:
            return lines

        # Find matching dimension chain
        chain = None
        for page in self.pages:
            for dc in page.dimension_chains:
                if dc.axis == axis and len(dc.values) >= len(lines) - 1:
                    chain = dc
                    break
            if chain:
                break

        if chain and len(chain.values) >= len(lines) - 1:
            # Use dimension chain values
            lines[0].mm_position = 0.0
            for i in range(1, len(lines)):
                lines[i].mm_position = lines[i-1].mm_position + chain.values[i-1]
                lines[i].confidence = max(lines[i].confidence, chain.confidence)
        else:
            # Use px spacing * scale
            lines[0].mm_position = 0.0
            for i in range(1, len(lines)):
                px_dist = abs(lines[i].px_position - lines[i-1].px_position)
                mm_dist = px_dist * scale
                # Round to nearest 50mm (standard grid spacing in construction)
                mm_dist_rounded = round(mm_dist / 50) * 50
                if mm_dist_rounded < 500:
                    mm_dist_rounded = round(mm_dist / 100) * 100  # try finer rounding
                lines[i].mm_position = lines[i-1].mm_position + max(mm_dist_rounded, 500)
                # Lower confidence when we're estimating
                lines[i].confidence = 0.5

        return lines

    # ── Extract Levels ───────────────────────────────────────────────────────

    def _extract_all_levels(self) -> list[LevelMarker]:
        """Extract all level markers from all elevation/section pages."""
        all_levels = []
        seen = set()

        for page in self.elevation_pages:
            for lm in page.level_markers:
                if lm.name not in seen:
                    seen.add(lm.name)
                    all_levels.append(lm)

        # If no elevation pages, check plan pages for level info
        if not all_levels:
            for page in self.plan_pages:
                for lm in page.level_markers:
                    if lm.name not in seen:
                        seen.add(lm.name)
                        all_levels.append(lm)

        # SYNTHETIC LEVEL GENERATION:
        # If still no levels found, generate from plan page count.
        # Each plan page typically represents one floor level.
        # If pages have labels with level info (e.g., "LEVEL 1", "FLOOR 2"), use those.
        # Otherwise, assign sequential floors at typical heights.
        if not all_levels and len(self.plan_pages) >= 1:
            typical_floor_height_mm = 3500.0
            level_names_from_pages = []

            for page in self.plan_pages:
                # Try to extract level from page title/label
                name = self._extract_level_name_from_page(page)
                level_names_from_pages.append(name)

            # If all names are "LEVEL N", reduce to just LEVEL N
            # If mixed or no pattern, use sequential
            for i, name in enumerate(level_names_from_pages):
                z_mm = i * typical_floor_height_mm
                all_levels.append(LevelMarker(
                    name=name,
                    z_mm=z_mm,
                    py=0,
                    page=self.plan_pages[i].page_index,
                    confidence=0.4,
                ))

        # Sort by z_mm
        all_levels.sort(key=lambda l: l.z_mm)

        return all_levels

    def _extract_level_name_from_page(self, page: StructuredPageData) -> str:
        """Try to extract a floor/level name from a plan page's text tokens."""
        # Look for patterns like "LEVEL 1", "FLOOR 2", "1F", "2ND FLOOR"
        # Also Vietnamese patterns: "TẦNG 1", "LẦU 1"
        level_keywords = [
            r'(?:LEVEL|FLOOR|LVL|FL)\s*[-:.]?\s*(\d+)',
            r'(\d+)(?:ST|ND|RD|TH)\s*(?:FLOOR|FL)',
            r'(?:TẦNG|LẦU|TANG|LAU)\s*(\d+)',
            r'(?:BASEMENT|BSMT|BM|HẦM)\s*(\d+)',
            r'(?:ROOF|MÁI|MAI)',
            r'(?:GROUND|GRND|TRỆT|TRET)',
        ]

        # Collect all text tokens sorted by position
        texts = sorted(page.text_tokens, key=lambda t: (t.py, t.px))

        for token in texts:
            text = token.text.strip().upper()
            for pattern in level_keywords:
                m = re.search(pattern, text)
                if m:
                    groups = m.groups()
                    if groups and groups[0]:
                        # Has a number
                        try:
                            n = int(groups[0])
                            if 'BASEMENT' in text or 'BSMT' in text or 'HẦM' in text:
                                return f"B{n}"
                            elif 'ROOF' in text or 'MÁI' in text:
                                return f"ROOF"
                            else:
                                return f"LEVEL {n}"
                        except ValueError:
                            pass
                    else:
                        # No number — ground or roof
                        if 'ROOF' in text or 'MÁI' in text:
                            return "ROOF"
                        elif 'GROUND' in text or 'GRND' in text or 'TRỆT' in text:
                            return "GROUND"
                        else:
                            return text[:20]

        # For page groups: pages 0-2 = site plan, pages 3-5 = ground floor, etc.
        # When unclear, use sequential
        return f"LEVEL {page.page_index + 1}"

    # ── Confidence Score ─────────────────────────────────────────────────────

    def _compute_confidence(self, x_lines: list[GridLine], y_lines: list[GridLine]) -> float:
        """Compute overall confidence of the grid system."""
        all_lines = x_lines + y_lines
        if not all_lines:
            return 0.0
        return sum(line.confidence for line in all_lines) / len(all_lines)

    # ── Building Bounding Box ────────────────────────────────────────────────

    def _compute_bbox(self, gs: GridSystem) -> tuple:
        """Compute building bounding box in mm."""
        if gs.grids_x and gs.grids_y:
            x0 = min(gs.grids_x.values())
            x1 = max(gs.grids_x.values()) if len(gs.grids_x) > 1 else x0 + 50000
            y0 = min(gs.grids_y.values())
            y1 = max(gs.grids_y.values()) if len(gs.grids_y) > 1 else y0 + 50000
            return (x0, y0, x1, y1)
        
        if gs.grids_x:
            vals = sorted(gs.grids_x.values())
            return (min(vals), 0, max(vals) + (vals[-1]-vals[0] if len(vals) > 1 else 30000), 50000)
        
        return (0, 0, 50000, 50000)


# ============================================================================
# ADVANCED FEATURES
# ============================================================================

class MultiPageGridMerger:
    """
    Merge grid systems from multiple plan pages (different floor levels).
    Handles buildings where grid may shift between floors.
    """

    @staticmethod
    def merge(grids: list[GridSystem]) -> GridSystem:
        """Merge multiple grid systems into one unified system."""
        if not grids:
            return GridSystem()
        
        if len(grids) == 1:
            return grids[0]

        merged = GridSystem()

        # Merge grid labels — take the union
        all_x = {}
        all_y = {}
        for gs in grids:
            all_x.update(gs.grids_x)
            all_y.update(gs.grids_y)

        # Sort and assign consistent positions
        # For X: sort alphabetically (or by position if same prefix)
        merged.grids_x = dict(sorted(all_x.items()))
        merged.grids_y = dict(sorted(all_y.items()))

        # Merge grid lines
        for gs in grids:
            merged.all_grid_lines.extend(gs.all_grid_lines)

        # Average scale
        merged.scale_x = sum(gs.scale_x for gs in grids) / len(grids)
        merged.scale_y = sum(gs.scale_y for gs in grids) / len(grids)

        # Merge levels (deduplicated)
        seen = set()
        for gs in grids:
            for level in gs.levels:
                if level.name not in seen:
                    seen.add(level.name)
                    merged.levels.append(level)

        # Merge bounding box
        all_bbox = [gs.building_bbox_mm for gs in grids]
        merged.building_bbox_mm = (
            min(b[0] for b in all_bbox),
            min(b[1] for b in all_bbox),
            max(b[2] for b in all_bbox),
            max(b[3] for b in all_bbox),
        )

        # Average confidence
        merged.confidence = sum(gs.confidence for gs in grids) / len(grids)

        return merged


# ============================================================================
# SCHEDULE-TO-GRID MATCHER
# ============================================================================

class ScheduleGridMatcher:
    """
    Match schedule entries to grid positions.

    For each schedule row:
      - Parse grid reference column (e.g., "1-A" or "Grid A-1")
      - Look up in GridSystem.grids_x and grids_y
      - Return (x_mm, y_mm) for that member
    """

    GRID_REF_PATTERNS = [
        # Number-Letter: "1/A", "2-B", "1-A"
        re.compile(r'(\d+)\s*[-/]\s*([A-Za-z]+)'),
        # Letter-Number: "A/1", "B-2"
        re.compile(r'([A-Za-z]+)\s*[-/]\s*(\d+)'),
        # Combined: "Grid 1-A", "Grid A1"
        re.compile(r'(?:GRID\s*)?(\d+)\s*[-/\s]\s*([A-Za-z]+)'),
    ]

    GRID_REF_COLUMNS = [
        "grid", "grid reference", "grid ref", "grid loc", "location",
        "trục", "vị trí",
    ]

    @classmethod
    def match_schedule_to_grid(
        cls,
        schedule_rows: list[dict],
        grid_system: GridSystem,
    ) -> list[dict]:
        """
        For each schedule row, find its grid position.
        Returns the rows enriched with grid_x_mm and grid_y_mm.
        """
        results = []
        for row in schedule_rows:
            row = dict(row)
            grid_ref = cls._find_grid_ref(row)
            
            if grid_ref:
                x_mm, y_mm = cls._resolve_grid_ref(grid_ref, grid_system)
                row["grid_x_mm"] = x_mm
                row["grid_y_mm"] = y_mm
                row["grid_confirmed"] = True
            else:
                row["grid_x_mm"] = None
                row["grid_y_mm"] = None
                row["grid_confirmed"] = False

            results.append(row)
        return results

    @classmethod
    def _find_grid_ref(cls, row: dict) -> Optional[str]:
        """Find grid reference in a schedule row."""
        # Check known column names first
        for col in cls.GRID_REF_COLUMNS:
            if col in row:
                return row[col]
            # Case-insensitive
            for key in row:
                if key.lower().strip() == col:
                    return row[key]

        # Search all values for grid pattern
        for key, value in row.items():
            if isinstance(value, str):
                for pattern in cls.GRID_REF_PATTERNS:
                    m = pattern.match(value.strip())
                    if m:
                        return value.strip()

        return None

    @classmethod
    def _resolve_grid_ref(cls, grid_ref: str, grid_system: GridSystem) -> tuple[Optional[float], Optional[float]]:
        """
        Resolve a grid reference string to mm coordinates.
        e.g., "1/A" → (grids_x["A"], grids_y["1"])
        """
        grid_ref = grid_ref.strip().upper()

        for pattern in cls.GRID_REF_PATTERNS:
            m = pattern.match(grid_ref)
            if m:
                groups = m.groups()
                if len(groups) >= 2:
                    a, b = groups[0], groups[1]

                    # Determine which is X (letter) and which is Y (number)
                    if a.isdigit() and b.isalpha():
                        y_label, x_label = a, b
                    elif a.isalpha() and b.isdigit():
                        x_label, y_label = a, b
                    else:
                        # Fallback: try both
                        x_mm = grid_system.grids_x.get(a.upper(), grid_system.grids_x.get(b.upper()))
                        y_mm = grid_system.grids_y.get(b, grid_system.grids_y.get(a))
                        return x_mm, y_mm

                    x_mm = grid_system.grids_x.get(x_label.upper())
                    y_mm = grid_system.grids_y.get(y_label)
                    return x_mm, y_mm
                break

        return None, None


# ============================================================================
# CONVENIENCE FUNCTION
# ============================================================================

def build_grid_from_structured_pages(structured_pages: list[StructuredPageData]) -> GridSystem:
    """One-liner to build a complete grid system from structured pages."""
    engine = GridMathEngine(structured_pages)
    return engine.build()


def build_grid_from_pdf(pdf_path: str) -> GridSystem:
    """Build grid system directly from PDF path."""
    from core.pdf_structured_parser import PDFStructuredParser
    parser = PDFStructuredParser(pdf_path)
    pages = parser.parse_all()
    engine = GridMathEngine(pages)
    return engine.build()