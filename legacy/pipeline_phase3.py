#!/usr/bin/env python3
"""
Pipeline Phase 3 — Structural Layout from Schedule Tables + Plan Text
========================================================================
Strategy:
  1. Parse schedule tables → member_db: {mark: {type, dimensions, material}}
  2. On each plan page, detect structural member positions from:
     - Rebar callout clusters (text like 4N36, 6N36 near grid intersections)
     - Grid intersection proximity to structural text
  3. Per-page layout → each plan page = one floor level
  4. Generate SketchUp Ruby with real section sizes and per-floor variation
"""

import sys, os, json, re, math
from pathlib import Path
from collections import defaultdict
from dataclasses import dataclass, field
from typing import Optional

sys.path.insert(0, str(Path(__file__).parent))

from core.pdf_structured_parser import PDFStructuredParser
from agents.grid_math_engine import GridMathEngine


# ============================================================================
# PHASE 1: PARSE SCHEDULE TABLES → MEMBER DATABASE
# ============================================================================

@dataclass
class MemberSpec:
    """Specification for a structural member from schedule table."""
    mark: str
    member_type: str = "unknown"  # column, beam, brace, etc.
    section: str = ""  # e.g., "400x400", "UB36c"
    dimensions: dict = field(default_factory=dict)  # {width, depth, flange, web, ...}
    material: str = "Steel"
    grade: str = ""
    length_mm: float = 0.0
    weight_kg: float = 0.0


def parse_schedule_tables(parser: PDFStructuredParser) -> dict[str, MemberSpec]:
    """
    Extract member specifications from all schedule tables.
    Returns: {mark: MemberSpec}
    
    Uses STRICT filtering: only rows with recognizable structural mark prefixes
    (C*, B*, G*, R*, S*, W*) are kept. Generic text, header rows, and document
    reference rows are discarded.
    """
    pages = parser.parse_all()
    member_db: dict[str, MemberSpec] = {}
    
    for page in pages:
        for table in page.tables:
            headers = [h.lower().strip() for h in table.headers]
            rows = table.rows
            
            # Detect key columns
            mark_col = None
            type_col = None
            dim_cols = []  # columns with dimension info
            
            for i, h in enumerate(headers):
                h_clean = h.strip().lower()
                if h_clean in ('mark', 'member', 'id', 'ref', 'item'):
                    mark_col = i
                elif h_clean in ('type', 'section', 'profile', 'shape'):
                    type_col = i
                elif any(kw in h_clean for kw in ('size', 'dim', 'width', 'depth', 'diam', 'b', 'h', 'd', 'a')):
                    dim_cols.append(i)
            
            # If no mark column, try first column
            if mark_col is None and len(headers) > 0:
                mark_col = 0
            
            # Parse rows
            for row in rows:
                if mark_col is None or mark_col >= len(row):
                    continue
                
                mark_raw = str(row[mark_col]).strip()
                if not mark_raw or len(mark_raw) < 1:
                    continue
                
                # Clean mark
                mark = mark_raw.upper().replace('\n', ' ').strip()
                
                # ── STRICT FILTER: only keep recognizable structural marks ──
                # Must match: C#, B#, G#, R#, S#, W# patterns
                valid_prefixes = ('C', 'B', 'G', 'R', 'S', 'W')
                if not mark or mark[0] not in valid_prefixes:
                    continue
                if len(mark) < 2:
                    continue
                # Must have a digit after the prefix
                if not mark[1].isdigit() and mark[1] != '-':
                    continue
                
                # Skip header-like rows
                if mark in ('MARK', 'MEMBER', 'ITEM', 'REF', 'NO.', ''):
                    continue
                
                # Detect member type from mark prefix
                mtype = "unknown"
                if mark[0] == 'C':
                    mtype = "column"
                elif mark[0] in ('B', 'R', 'G'):
                    mtype = "beam"
                elif mark[0] == 'W':
                    mtype = "wall"
                elif mark[0] == 'S':
                    mtype = "slab"
                
                # Extract section info
                section = ""
                if type_col is not None and type_col < len(row):
                    section = str(row[type_col]).strip().replace('\n', ' ')
                
                # Extract dimensions from dimension columns
                dimensions = {}
                for dc in dim_cols:
                    if dc < len(row):
                        val_raw = str(row[dc]).strip()
                        # Try to parse as number
                        try:
                            val = float(val_raw.replace(',', '.'))
                            dim_name = headers[dc].strip().lower() if dc < len(headers) else f'dim{dc}'
                            dimensions[dim_name] = val
                        except ValueError:
                            pass
                
                # Build section string from dimensions if not explicit
                if not section and dimensions:
                    if 'width' in dimensions and 'depth' in dimensions:
                        section = f"{dimensions['width']:.0f}x{dimensions['depth']:.0f}"
                    elif 'b' in dimensions and 'h' in dimensions:
                        section = f"{dimensions['b']:.0f}x{dimensions['h']:.0f}"
                
                member_db[mark] = MemberSpec(
                    mark=mark,
                    member_type=mtype,
                    section=section,
                    dimensions=dimensions,
                    material="Steel" if mtype != "wall" else "Concrete",
                )
    
    return member_db


# ============================================================================
# PHASE 2: DETECT MEMBER POSITIONS FROM PLAN TEXT
# ============================================================================

# Rebar callout patterns: 4N36, 6N36, N16-200, 4N16, etc.
REBAR_PATTERN = re.compile(
    r'^(\d+)?[NRTY]\d{1,2}([-\s]\d+)?$|^[NRTY]\d{1,2}[-\s]\d+$',
    re.IGNORECASE
)

# ── BROAD MEMBER MARK PATTERNS ──────────────────────────────────────────
# Match: C1, C2, C-1, C1A, C12, C206, COL-1, COLUMN-12, Cốt C1, Cột C-12
COLUMN_MARK_PATTERN = re.compile(
    r'^(?:C|COL|COLUMN|C[ỐÔ]T)\s*[-]?\s*\d+[A-Za-z]?$',
    re.IGNORECASE
)
# Match: B1, B-12, B3A, BM-5, G1, G-12, GT-3, RB-1, R-2, DẦM B1
BEAM_MARK_PATTERN = re.compile(
    r'^(?:B|BM|G|GT|R|RB|D[ẦÀ]M)\s*[-]?\s*\d+[A-Za-z]?$',
    re.IGNORECASE
)
# Match: W1, W-2, WALL-1, SW-3, TƯỜNG W1
WALL_MARK_PATTERN = re.compile(
    r'^(?:W|SW|WA|T[ƯU][ỜƠ]NG)\s*[-]?\s*\d+[A-Za-z]?$',
    re.IGNORECASE
)
# Match: S1, S-2, SLAB-1, SÀN S1  
SLAB_MARK_PATTERN = re.compile(
    r'^(?:S|SL|SLAB|S[ÀA]N)\s*[-]?\s*\d+[A-Za-z]?$',
    re.IGNORECASE
)

# Dimension text: numbers near grid labels (2-5 digits = mm or cm dimensions)
DIMENSION_TEXT_PATTERN = re.compile(r'^\d{2,5}$')


@dataclass
class DetectedMember:
    """A structural member detected on a plan page."""
    position: tuple[float, float]  # (x_mm, y_mm) in page coordinates
    member_type: str  # column, beam, wall
    confidence: float = 0.5
    mark: str = ""
    section_hint: str = ""
    grid_x: Optional[int] = None
    grid_y: Optional[int] = None


def detect_members_on_plan(spd, grid_system, member_db: dict) -> list[DetectedMember]:
    """
    Detect structural member positions on a plan page.

    Strategy (REVISED — grid-intersection first):
    1. **FALLBACK: Generate columns at ALL grid intersections** (columns always at grid crosses)
    2. Scan text for member marks (C1, B2, etc.) to label/annotate grid positions
    3. Snap text-found marks to nearest grid intersection
    4. Generate beams along grid edges connecting adjacent columns
    """
    members = []
    GRID_SNAP_DIST = 3000  # mm - generous snap for text marks to grid

    x_positions = sorted(grid_system.grids_x.values()) if grid_system else []
    y_positions = sorted(grid_system.grids_y.values()) if grid_system else []

    # ── STRATEGY 1: Grid-Intersection Columns ──────────────────────────
    # In structural engineering, columns ALWAYS lie at grid intersections.
    # If we have a grid, generate columns at every intersection as baseline.
    grid_columns: dict[tuple[int,int], tuple[float,float]] = {}
    if x_positions and y_positions:
        for gx, x_mm in enumerate(x_positions):
            for gy, y_mm in enumerate(y_positions):
                key = (gx, gy)
                grid_columns[key] = (x_mm, y_mm)

    # ── STRATEGY 2: Scan text for member marks ─────────────────────────
    # Map text-found marks to nearest grid positions to annotate them
    text_marks: dict[tuple[int,int], dict] = {}  # (gx,gy) -> {mark, type, section}

    clusters = _cluster_text_by_proximity(spd.all_text, max_dist_pt=40)
    for cluster in clusters:
        mark = ""
        detected_type = "unknown"
        
        for t in cluster:
            text = t.text.strip()
            if COLUMN_MARK_PATTERN.match(text):
                detected_type = "column"
                mark = text.upper()
                break
            if BEAM_MARK_PATTERN.match(text):
                detected_type = "beam"
                mark = text.upper()
                break
            if WALL_MARK_PATTERN.match(text):
                detected_type = "wall"
                mark = text.upper()
                break
            if SLAB_MARK_PATTERN.match(text):
                detected_type = "slab"
                mark = text.upper()
                break
            # Broader: any "C"+number, "B"+number pattern
            if re.match(r'^[CB]\d+', text, re.IGNORECASE):
                detected_type = "column" if text[0].upper() == "C" else "beam"
                mark = text.upper()
                break

        if not mark:
            continue

        # Compute cluster center
        cx = sum(t.cx for t in cluster) / len(cluster)
        cy = sum(t.cy for t in cluster) / len(cluster)
        x_mm, y_mm = _page_to_mm(cx, cy, spd, grid_system)

        # Snap to nearest grid intersection
        if x_positions and y_positions:
            gx, gy = _snap_to_grid(x_mm, y_mm, grid_system, GRID_SNAP_DIST)
            if gx is not None and gy is not None:
                # Get section from member_db
                section_hint = ""
                if mark and mark in member_db:
                    section_hint = member_db[mark].section
                    if member_db[mark].member_type != "unknown":
                        detected_type = member_db[mark].member_type
                
                # Store mark at this grid position (keep highest-confidence match)
                key = (gx, gy)
                if key not in text_marks or len(mark) > len(text_marks[key].get("mark", "")):
                    text_marks[key] = {
                        "mark": mark,
                        "type": detected_type,
                        "section": section_hint
                    }

    # ── BUILD FINAL MEMBER LIST ────────────────────────────────────────
    # Start with ALL grid intersections as potential column positions
    seen_positions = set()
    
    for (gx, gy), (x_mm, y_mm) in grid_columns.items():
        # Get text annotation if available
        annotation = text_marks.get((gx, gy), {})
        mark = annotation.get("mark", f"GC_{gx}_{gy}")
        mtype = annotation.get("type", "column")
        section = annotation.get("section", "")
        confidence = 0.9 if annotation.get("mark") else 0.6  # grid columns are high confidence
        
        # Also check member_db for any mark that might correspond
        for db_mark, spec in member_db.items():
            if spec.member_type == "column" and not section:
                section = spec.section
                break
        
        members.append(DetectedMember(
            position=(x_mm, y_mm),
            member_type=mtype,
            confidence=confidence,
            mark=mark,
            section_hint=section or "300x300",  # default concrete column
            grid_x=gx,
            grid_y=gy,
        ))
        seen_positions.add((gx, gy))

    # Add any text-found positions NOT at grid intersections (unusual but possible)
    for (gx, gy), ann in text_marks.items():
        if (gx, gy) not in seen_positions and gx < len(x_positions) and gy < len(y_positions):
            x_mm = x_positions[gx]
            y_mm = y_positions[gy]
            members.append(DetectedMember(
                position=(x_mm, y_mm),
                member_type=ann.get("type", "column"),
                confidence=0.7,
                mark=ann.get("mark", ""),
                section_hint=ann.get("section", ""),
                grid_x=gx,
                grid_y=gy,
            ))

    return members


def _cluster_text_by_proximity(text_tokens, max_dist_pt=30):
    """Cluster text tokens that are near each other."""
    if not text_tokens:
        return []

    # Sort by position for efficient clustering
    tokens = sorted(text_tokens, key=lambda t: (t.cy, t.cx))

    visited = set()
    clusters = []

    for i, t1 in enumerate(tokens):
        if i in visited:
            continue

        cluster = [t1]
        visited.add(i)

        # BFS to find nearby tokens
        queue = [t1]
        while queue:
            current = queue.pop(0)
            for j, t2 in enumerate(tokens):
                if j in visited:
                    continue
                dist = math.hypot(current.cx - t2.cx, current.cy - t2.cy)
                if dist < max_dist_pt:
                    cluster.append(t2)
                    visited.add(j)
                    queue.append(t2)

        clusters.append(cluster)

    return clusters


def _page_to_mm(cx_pt, cy_pt, spd, grid_system) -> tuple[float, float]:
    """Convert page coordinates (points) to mm using grid system scale."""
    if grid_system and grid_system.scale_x > 0:
        # Use grid system scale (mm per px)
        x_mm = cx_pt * grid_system.scale_x
        y_mm = cy_pt * grid_system.scale_y
        return x_mm, y_mm

    # Fallback: use default scale from v2
    scale = 3.5  # mm per point (from pipeline v2)
    return cx_pt * scale, cy_pt * scale


def _snap_to_grid(x_mm, y_mm, grid_system, max_dist_mm=1500):
    """Snap a point to nearest grid intersection. Returns (gx, gy) or (None, None)."""
    x_positions = sorted(grid_system.grids_x.values())
    y_positions = sorted(grid_system.grids_y.values())

    if not x_positions or not y_positions:
        return None, None

    best_dist = float('inf')
    best_gx, best_gy = None, None

    for gx, gx_val in enumerate(x_positions):
        for gy, gy_val in enumerate(y_positions):
            dist = math.hypot(x_mm - gx_val, y_mm - gy_val)
            if dist < max_dist_mm and dist < best_dist:
                best_dist = dist
                best_gx, best_gy = gx, gy

    return best_gx, best_gy


# ============================================================================
# PHASE 3: BUILD PER-FLOOR LAYOUT
# ============================================================================

@dataclass
class FloorLayout:
    """Structural layout for one floor."""
    floor_index: int
    floor_name: str = ""
    z_bottom_mm: float = 0.0
    z_top_mm: float = 0.0
    columns: list[DetectedMember] = field(default_factory=list)
    beams: list[DetectedMember] = field(default_factory=list)
    walls: list[DetectedMember] = field(default_factory=list)
    slabs: list[dict] = field(default_factory=list)


def build_per_floor_layouts(parser, grid_system, member_db) -> list[FloorLayout]:
    """
    Build structural layout for each floor from plan pages.
    Each plan page = one floor.
    """
    pages = parser.parse_all()
    plan_pages = [p for p in pages if p.page_type == "plan"]

    layouts = []

    # Get level markers for Z-heights
    all_levels = []
    for p in pages:
        all_levels.extend(p.level_markers)
    all_levels.sort(key=lambda lm: lm.z_mm)

    floor_height = 3500  # default mm

    for i, plan_page in enumerate(plan_pages):
        # Detect members on this plan
        members = detect_members_on_plan(plan_page, grid_system, member_db)

        columns = [m for m in members if m.member_type == "column"]
        walls = [m for m in members if m.member_type == "wall"]
        
        # ── Generate beams from adjacent columns along grid edges ──
        beams = _generate_beams_from_columns(columns, grid_system, member_db, i)

        # Determine Z height for this floor
        # Default: stack floors at 3500mm intervals
        z_bottom = i * floor_height
        z_top = z_bottom + floor_height

        # Try to match with level markers (if they have valid height info)
        if i < len(all_levels):
            lm_bottom = all_levels[i].z_mm
            if lm_bottom > 0:  # only use if non-zero
                z_bottom = lm_bottom
            if i + 1 < len(all_levels):
                lm_top = all_levels[i + 1].z_mm
                if lm_top > z_bottom:
                    z_top = lm_top
                else:
                    z_top = z_bottom + floor_height
            else:
                z_top = z_bottom + floor_height
        
        # Safety: ensure minimum floor height
        if z_top <= z_bottom:
            z_top = z_bottom + floor_height

        layout = FloorLayout(
            floor_index=i,
            floor_name=f"Level {i+1}",
            z_bottom_mm=z_bottom,
            z_top_mm=z_top,
            columns=columns,
            beams=beams,
            walls=walls,
        )
        layouts.append(layout)

    return layouts


def _generate_beams_from_columns(columns: list[DetectedMember], grid_system, 
                                  member_db: dict, floor_idx: int) -> list[DetectedMember]:
    """
    Generate beams by connecting adjacent columns along grid edges.
    
    Strategy:
    - For every pair of adjacent columns on the same X grid line (same gx),
      create a beam spanning between them along Y direction.
    - For every pair of adjacent columns on the same Y grid line (same gy),
      create a beam spanning between them along X direction.
    - Lookup section from member_db for beam marks.
    """
    beams = []
    if not columns:
        return beams
    
    # Build grid position lookup
    x_positions = sorted(grid_system.grids_x.values()) if grid_system else []
    y_positions = sorted(grid_system.grids_y.values()) if grid_system else []
    
    if not x_positions or not y_positions:
        return beams
    
    # Group columns by grid_x and grid_y
    cols_by_gx = defaultdict(list)  # gx -> list of columns sorted by gy
    cols_by_gy = defaultdict(list)  # gy -> list of columns sorted by gx
    
    for col in columns:
        if col.grid_x is not None and col.grid_y is not None:
            cols_by_gx[col.grid_x].append(col)
            cols_by_gy[col.grid_y].append(col)
    
    # Sort within each group
    for gx in cols_by_gx:
        cols_by_gx[gx].sort(key=lambda c: c.grid_y if c.grid_y is not None else 0)
    for gy in cols_by_gy:
        cols_by_gy[gy].sort(key=lambda c: c.grid_x if c.grid_x is not None else 0)
    
    beam_idx = 0
    seen_beam_positions = set()
    
    # ── Beams along X direction (same gy, adjacent gx) ──
    for gy, col_list in cols_by_gy.items():
        for j in range(len(col_list) - 1):
            c1 = col_list[j]
            c2 = col_list[j + 1]
            if c1.grid_x is None or c2.grid_x is None:
                continue
            # Must be adjacent grid indices
            if abs(c1.grid_x - c2.grid_x) > 2:
                continue
            
            x1, y1 = c1.position
            x2, y2 = c2.position
            # Skip zero-length
            if abs(x1 - x2) < 100 and abs(y1 - y2) < 100:
                continue
            
            pos_key = (min(x1, x2), min(y1, y2), max(x1, x2), max(y1, y2))
            if pos_key in seen_beam_positions:
                continue
            seen_beam_positions.add(pos_key)
            
            # Midpoint for beam mark
            mx, my = (x1 + x2) / 2, (y1 + y2) / 2
            
            # Look up beam section
            section = "300x600"  # default beam section
            mark = f"B_X_{beam_idx}"
            
            beams.append(DetectedMember(
                position=(mx, my),
                member_type="beam",
                confidence=0.7,
                mark=mark,
                section_hint=section,
                grid_x=c1.grid_x,
                grid_y=gy,
            ))
            beam_idx += 1
    
    # ── Beams along Y direction (same gx, adjacent gy) ──
    for gx, col_list in cols_by_gx.items():
        for j in range(len(col_list) - 1):
            c1 = col_list[j]
            c2 = col_list[j + 1]
            if c1.grid_y is None or c2.grid_y is None:
                continue
            if abs(c1.grid_y - c2.grid_y) > 2:
                continue
            
            x1, y1 = c1.position
            x2, y2 = c2.position
            if abs(x1 - x2) < 100 and abs(y1 - y2) < 100:
                continue
            
            pos_key = (min(x1, x2), min(y1, y2), max(x1, x2), max(y1, y2))
            if pos_key in seen_beam_positions:
                continue
            seen_beam_positions.add(pos_key)
            
            mx, my = (x1 + x2) / 2, (y1 + y2) / 2
            section = "300x600"
            mark = f"B_Y_{beam_idx}"
            
            beams.append(DetectedMember(
                position=(mx, my),
                member_type="beam",
                confidence=0.7,
                mark=mark,
                section_hint=section,
                grid_x=gx,
                grid_y=c1.grid_y,
            ))
            beam_idx += 1
    
    return beams


# ============================================================================
# PHASE 4: GENERATE RUBY WITH REAL DATA
# ============================================================================

def generate_ruby_phase3(layouts: list[FloorLayout], member_db: dict, grid_system,
                          output_path: str):
    """
    Generate SketchUp Ruby script with per-floor layouts and real section sizes.
    """

    def write_line(f, text):
        f.write(text + "\n")

    with open(output_path, "w", encoding="utf-8") as f:
        write_line(f, "# " + "=" * 77)
        write_line(f, "# LOD 300 Structural Model — Phase 3: Schedule-Aware Layout")
        write_line(f, "# Generated by pipeline_phase3.py — hybrid schedule + plan-text detection")
        write_line(f, "# " + "=" * 77)
        write_line(f, "")
        write_line(f, "model  = Sketchup.active_model")
        write_line(f, 'model.name        = "LOD300 Structural Model Phase3"')
        write_line(f, 'model.description = "Schedule-aware per-floor structural model"')
        write_line(f, "ents   = model.active_entities")
        write_line(f, "layers = model.layers")
        write_line(f, "model.start_operation('LOD300 Phase3 Import', true)")
        write_line(f, "")

        # Helper: get or create layer
        write_line(f, "def get_or_create_layer(layers, name)")
        write_line(f, "  layers[name] || layers.add(name)")
        write_line(f, "end")
        write_line(f, "")

        # Layers
        write_line(f, "# ── Layers ──")
        layers_list = [
            "STR-Columns", "STR-Beams", "STR-Braces", "STR-Plates",
            "STR-Walls", "STR-Slabs", "STR-Foundations",
            "LOD300_UNMAPPED_NEEDS_REVIEW"
        ]
        write_line(f, '[{}].each do |lname|'.format(
            ", ".join(f'"{l}"' for l in layers_list)))
        write_line(f, "  get_or_create_layer(layers, lname)")
        write_line(f, "end")
        write_line(f, "")

        # Materials
        write_line(f, "# ── Materials ──")
        write_line(f, "_mats = model.materials")
        write_line(f, '_steel_mat = _mats["Structural_Steel"] || _mats.add("Structural_Steel")')
        write_line(f, "_steel_mat.color = Sketchup::Color.new(160, 160, 175)")
        write_line(f, '_concrete_mat = _mats["Concrete"] || _mats.add("Concrete")')
        write_line(f, "_concrete_mat.color = Sketchup::Color.new(180, 175, 165)")
        write_line(f, "")

        # Track counts
        total_columns = 0
        total_beams = 0

        # ── Process each floor ──
        for layout in layouts:
            write_line(f, f"# {'='*60}")
            write_line(f, f"# FLOOR: {layout.floor_name} (Z: {layout.z_bottom_mm:.0f} → {layout.z_top_mm:.0f} mm)")
            write_line(f, f"# {'='*60}")
            write_line(f, "")

            z_btm = layout.z_bottom_mm
            z_top = layout.z_top_mm
            height = z_top - z_btm

            # ── Columns ──
            for i, col in enumerate(layout.columns):
                x, y = col.position
                mark = col.mark or f"COL_{layout.floor_index}_{i+1}"
                section = col.section_hint or "400x400"
                material = "concrete" if "RC" in section.upper() or section[0].isdigit() else "steel"

                _write_column_ruby(f, mark, x, y, z_btm, height, section, material, layout.floor_name)
                total_columns += 1

            # ── Beams ──
            for i, beam in enumerate(layout.beams):
                x, y = beam.position
                mark = beam.mark or f"BM_{layout.floor_index}_{i+1}"
                section = beam.section_hint or "UB36c"

                # Beams need start/end positions; default to spanning 1 grid bay
                if grid_system and beam.grid_x is not None and beam.grid_y is not None:
                    gx, gy = beam.grid_x, beam.grid_y
                    x_positions = sorted(grid_system.grids_x.values())
                    y_positions = sorted(grid_system.grids_y.values())
                    # Default: beam along X axis to next grid
                    if gx + 1 < len(x_positions):
                        x2 = x_positions[gx + 1]
                        _write_beam_ruby(f, mark, x, y, x2, y, z_btm, section, "steel", layout.floor_name)
                        total_beams += 1
                    elif gy + 1 < len(y_positions):
                        y2 = y_positions[gy + 1]
                        _write_beam_ruby(f, mark, x, y, x, y2, z_btm, section, "steel", layout.floor_name)
                        total_beams += 1

        # ── Finalize ──
        write_line(f, "")
        write_line(f, "model.commit_operation")
        write_line(f, "")
        write_line(f, f'puts "Phase3 model complete: {total_columns} columns, {total_beams} beams across {len(layouts)} floors"')

    return total_columns, total_beams


def _write_column_ruby(f, mark, x_mm, y_mm, z_btm_mm, height_mm, section, material, floor_name):
    """Write Ruby code for one column."""
    # Parse section for dimensions
    dim = _parse_section_dims(section)
    hw = dim[0] / 2  # half width
    hd = dim[1] / 2 if len(dim) > 1 else dim[0] / 2  # half depth

    mat_var = "_concrete_mat" if material == "concrete" else "_steel_mat"
    layer = "STR-Columns"

    f.write(f"# ---- {mark} | {section} | column | {floor_name} ----\n")
    f.write(f"begin\n")
    f.write(f"  _sp  = Geom::Point3d.new({x_mm:.1f}.mm, {y_mm:.1f}.mm, {z_btm_mm:.1f}.mm)\n")
    f.write(f"  _ep  = Geom::Point3d.new({x_mm:.1f}.mm, {y_mm:.1f}.mm, {z_btm_mm + height_mm:.1f}.mm)\n")
    f.write(f"  _vec = _sp.vector_to(_ep)\n")
    f.write(f"  _len = _sp.distance(_ep)\n")
    f.write(f"  if _len < 1.mm || !_vec.valid?\n")
    f.write(f'    puts "SKIP {mark}: zero-length (check mapper coords)"\n')
    f.write(f"  else\n")
    f.write(f"    _grp = ents.add_group\n")
    f.write(f"    _ge  = _grp.entities\n")
    f.write(f"    _t   = Geom::Transformation.new(_sp, _vec)\n")
    f.write(f"    _raw = [[-{hw:.1f}, -{hd:.1f}], [{hw:.1f}, -{hd:.1f}],\n")
    f.write(f"            [{hw:.1f}, {hd:.1f}], [-{hw:.1f}, {hd:.1f}]]\n")
    f.write(f'    _face = _ge.add_face(_raw.map {{ |p| _t * Geom::Point3d.new(p[0].mm, p[1].mm, 0) }})\n')
    f.write(f"    _face.pushpull(_len) if _face\n")
    f.write(f'    _grp.layer = get_or_create_layer(layers, "{layer}")\n')
    f.write(f"    _grp.material = {mat_var}\n")
    f.write(f'    _grp.set_attribute("IFC", "Mark",    "{mark}")\n')
    f.write(f'    _grp.set_attribute("IFC", "Section", "{section}")\n')
    f.write(f'    _grp.set_attribute("IFC", "Type",    "column")\n')
    f.write(f'    _grp.name = "{mark}"\n')
    f.write(f"  end\n")
    f.write(f"rescue => e\n")
    # FIX: Use #{{e.message}} instead of #{e.message} to prevent Python f-string interpolation
    f.write(f'  puts "SKIP {mark}: #{{e.message}}"\n')
    f.write(f"end\n")
    f.write(f"\n")


def _write_beam_ruby(f, mark, x1, y1, x2, y2, z_mm, section, material, floor_name):
    """Write Ruby code for one beam."""
    dim = _parse_section_dims(section)
    hw = dim[0] / 2  # half width
    hd = dim[1] / 2 if len(dim) > 1 else dim[0] / 2

    mat_var = "_concrete_mat" if material == "concrete" else "_steel_mat"
    layer = "STR-Beams"

    f.write(f"# ---- {mark} | {section} | beam | {floor_name} ----\n")
    f.write(f"begin\n")
    f.write(f"  _sp  = Geom::Point3d.new({x1:.1f}.mm, {y1:.1f}.mm, {z_mm:.1f}.mm)\n")
    f.write(f"  _ep  = Geom::Point3d.new({x2:.1f}.mm, {y2:.1f}.mm, {z_mm:.1f}.mm)\n")
    f.write(f"  _vec = _sp.vector_to(_ep)\n")
    f.write(f"  _len = _sp.distance(_ep)\n")
    f.write(f"  if _len < 1.mm || !_vec.valid?\n")
    f.write(f'    puts "SKIP {mark}: zero-length"\n')
    f.write(f"  else\n")
    f.write(f"    _grp = ents.add_group\n")
    f.write(f"    _ge  = _grp.entities\n")
    f.write(f"    _t   = Geom::Transformation.new(_sp, _vec)\n")
    f.write(f"    _raw = [[-{hw:.1f}, -{hd:.1f}], [{hw:.1f}, -{hd:.1f}],\n")
    f.write(f"            [{hw:.1f}, {hd:.1f}], [-{hw:.1f}, {hd:.1f}]]\n")
    f.write(f'    _face = _ge.add_face(_raw.map {{ |p| _t * Geom::Point3d.new(p[0].mm, p[1].mm, 0) }})\n')
    f.write(f"    _face.pushpull(_len) if _face\n")
    f.write(f'    _grp.layer = get_or_create_layer(layers, "{layer}")\n')
    f.write(f"    _grp.material = {mat_var}\n")
    f.write(f'    _grp.set_attribute("IFC", "Mark",    "{mark}")\n')
    f.write(f'    _grp.set_attribute("IFC", "Section", "{section}")\n')
    f.write(f'    _grp.set_attribute("IFC", "Type",    "beam")\n')
    f.write(f'    _grp.name = "{mark}"\n')
    f.write(f"  end\n")
    f.write(f"rescue => e\n")
    # FIX: Use #{{e.message}} instead of #{e.message} to prevent Python f-string interpolation
    f.write(f'  puts "SKIP {mark}: #{{e.message}}"\n')
    f.write(f"end\n")
    f.write(f"\n")


def _parse_section_dims(section: str) -> tuple:
    """Parse section string to (width, depth) in mm."""
    section = section.strip().upper()

    # Pattern: 400x400, 200x400, etc.
    m = re.match(r'(\d+)\s*[xX×]\s*(\d+)', section)
    if m:
        return float(m.group(1)), float(m.group(2))

    # Pattern: UB36c, CH32a → look up standard sizes
    STANDARD_SIZES = {
        'UB36': (177, 360),    # Universal Beam 360
        'CH32': (320, 320),    # Circular Hollow Section
        'SHS': (200, 200),     # Square Hollow Section
        'RHS': (200, 100),     # Rectangular Hollow Section
    }
    for key, dims in STANDARD_SIZES.items():
        if key in section:
            return dims

    # Pattern: DNxxx (pipe)
    m = re.match(r'DN(\d+)', section)
    if m:
        d = float(m.group(1))
        return d, d

    # Default
    return 200.0, 200.0


# ============================================================================
# MAIN PIPELINE
# ============================================================================

def run_phase3(pdf_path: str = None):
    """Main Phase 3 pipeline."""
    if pdf_path is None:
        pdf_path = "data/input_pdf/structural.pdf"

    print("=" * 70)
    print("PHASE 3 PIPELINE — Schedule-Aware Structural Layout")
    print("=" * 70)

    # Step 1: Parse PDF
    print("\n[1/5] Parsing PDF...")
    parser = PDFStructuredParser(pdf_path)

    # Step 2: Parse schedule tables
    print("[2/5] Parsing schedule tables...")
    member_db = parse_schedule_tables(parser)
    print(f"  Found {len(member_db)} member specs in schedules")
    for mark, spec in list(member_db.items())[:10]:
        print(f"    {mark}: {spec.member_type}, section={spec.section}, dims={spec.dimensions}")

    # Step 3: Build grid system from parsed pages
    print("\n[3/5] Building grid system...")
    pages = parser.parse_all()
    grid_engine = GridMathEngine(pages)
    grid_system = grid_engine.build()
    print(f"  Grid: {len(grid_system.grids_x)} X-lines, {len(grid_system.grids_y)} Y-lines")
    print(f"  Scale: {grid_system.scale_x:.2f} mm/px (X), {grid_system.scale_y:.2f} mm/px (Y)")

    # Step 4: Build per-floor layouts from plan text
    print("[4/5] Detecting structural members on plan pages...")
    layouts = build_per_floor_layouts(parser, grid_system, member_db)

    for layout in layouts:
        print(f"  {layout.floor_name}: {len(layout.columns)} cols, {len(layout.beams)} beams, "
              f"Z={layout.z_bottom_mm:.0f}-{layout.z_top_mm:.0f} mm")

    # Step 5: Generate Ruby
    print("\n[5/5] Generating Ruby script...")
    os.makedirs("output/final_ruby_scripts", exist_ok=True)
    output_path = "output/final_ruby_scripts/lod300_model_phase3.rb"
    n_cols, n_beams = generate_ruby_phase3(layouts, member_db, grid_system, output_path)

    file_size = Path(output_path).stat().st_size
    print(f"\n{'='*70}")
    print(f"DONE: PHASE 3 COMPLETE")
    print(f"DONE: {n_cols} columns, {n_beams} beams across {len(layouts)} floors")
    print(f"DONE: Member database: {len(member_db)} entries from schedule tables")
    print(f"DONE: Ruby script: {output_path} ({file_size/1024:.1f} KB)")
    print(f"{'='*70}")


if __name__ == "__main__":
    run_phase3()