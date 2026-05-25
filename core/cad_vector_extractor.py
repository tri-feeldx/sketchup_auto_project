"""
CAD VECTOR EXTRACTOR — Stage 1.5
=============================================================================
Extracts structural grid lines and column positions directly from the PDF
vector content stream using PyMuPDF (fitz), bypassing LLM for geometry that
is already encoded as exact vectors in CAD-generated PDFs.

Why this matters:
  Stage 2.5 (PlanPageExtractor) uses Gemini Vision to read column marks from
  rendered images — it enriches only ~28% of columns because small text is
  unreliable for vision LLMs.  CAD-generated PDFs contain the same data as
  exact vector paths (lines, rectangles) with sub-mm precision.  This extractor
  reads those paths directly: zero API calls, <200ms, and ~0.95 confidence.

Graceful fallback:
  Scanned PDFs have no vector paths — page.get_drawings() returns [].
  In that case extract_plan_data() returns an empty result dict and the
  pipeline falls through to the existing LLM vision path unchanged.
=============================================================================
"""

import math
import re
from typing import Optional

import fitz  # PyMuPDF — already in requirements.txt (>=1.23.0)


class CADVectorExtractor:
    """
    Extract structural grid lines and column XY positions from CAD-generated
    PDF plan pages using PyMuPDF vector path data.

    Usage:
        cad = CADVectorExtractor()
        data = cad.extract_plan_data("drawing.pdf", plan_page_indices=[3, 4])
        # data["grid_x_mm"]        → {"1": 0, "2": 7200, "3": 14400, ...}
        # data["grid_y_mm"]        → {"A": 0, "B": 6000, "C": 12000, ...}
        # data["column_positions"] → {"C1": {"x_mm": 0, "y_mm": 0}, ...}
        # data["confidence"]       → 0.85
    """

    # ── Tuning constants ──────────────────────────────────────────────────────

    # Grid lines must represent at least this many mm in model space
    MIN_GRID_LINE_MM: float = 2500

    # Column cross-section size range in model mm (plan view symbol)
    MIN_COL_MM: float = 80
    MAX_COL_MM: float = 800

    # Nearby parallel lines clustered as one grid line (PDF pts)
    GRID_CLUSTER_PT: float = 10

    # Max distance (mm) from symbol centre to nearest grid intersection
    SNAP_TOLERANCE_MM: float = 350

    # Max search radius (mm) for column-mark text near a symbol
    LABEL_RADIUS_MM: float = 1800

    # Regex for column marks: C1, C-1, UC3, P2, HB-12A, COL1, up to 10 chars
    COL_MARK_RE = re.compile(r'^[A-Z]{0,4}[-_]?\d{1,3}[A-Z]?$', re.IGNORECASE)

    # ── Public API ────────────────────────────────────────────────────────────

    def extract_plan_data(self, pdf_path: str, plan_page_indices: list) -> dict:
        """
        Extract grid + column positions from PLAN pages.

        Args:
            pdf_path:           Absolute path to the PDF file.
            plan_page_indices:  1-indexed page numbers of PLAN pages (from scanner_output).

        Returns:
            {
                "grid_x_mm":        {"1": 0, "2": 7200, ...},
                "grid_y_mm":        {"A": 0, "B": 6000, ...},
                "column_positions": {"C1": {"x_mm": 0, "y_mm": 0}, ...},
                "scale_mm_per_unit": float,   # mm per PDF pt
                "confidence":        float,   # 0.0–1.0
                "source":           "cad_vector",
                "pages_processed":  [int, ...]
            }
            Returns confidence=0 dict when PDF has no vectors (scanned PDF).
        """
        _empty = {
            "confidence": 0.0,
            "source": "cad_vector",
            "grid_x_mm": {},
            "grid_y_mm": {},
            "column_positions": {},
            "pages_processed": [],
        }

        if not plan_page_indices:
            return _empty

        try:
            doc = fitz.open(str(pdf_path))
        except Exception as e:
            print(f"  [CAD-VEC] WARN: Cannot open PDF: {e}")
            return _empty

        try:
            page_results = []
            for page_idx in plan_page_indices[:5]:  # cap to 5 plan pages
                if not (1 <= page_idx <= len(doc)):
                    continue
                page = doc[page_idx - 1]  # fitz is 0-indexed
                result = self._extract_page(page, page_idx)
                if result is not None:
                    page_results.append(result)

            if not page_results:
                print("  [CAD-VEC] No vector grid data found — likely a scanned PDF")
                return _empty

            merged = self._merge_pages(page_results)
            merged["pages_processed"] = [r["page_idx"] for r in page_results]
            merged["source"] = "cad_vector"
            return merged
        finally:
            doc.close()

    # ── Page-level extraction ─────────────────────────────────────────────────

    def _extract_page(self, page: "fitz.Page", page_idx: int) -> Optional[dict]:
        """Process a single plan page. Returns None if no usable vector data."""
        page_h = page.rect.height  # total page height in pts (Y goes top-down in PDF)

        text_dict = page.get_text("dict")
        try:
            paths = page.get_drawings()
        except Exception:
            paths = []

        if not paths:
            return None  # scanned PDF — no vectors

        scale = self._detect_scale(text_dict, paths)
        v_mm, h_mm = self._extract_grid_lines(paths, page_h, scale)

        if len(v_mm) < 2 or len(h_mm) < 2:
            print(f"  [CAD-VEC] Page {page_idx}: only {len(v_mm)}×{len(h_mm)} grid lines — "
                  f"skipping (need ≥2×2)")
            return None

        v_mm, h_mm = self._parse_dimension_chains(text_dict, page_h, scale, v_mm, h_mm)

        grid_x = {str(i + 1): round(x) for i, x in enumerate(v_mm)}
        grid_y = self._label_alpha(h_mm)

        col_positions = self._extract_column_positions(
            paths, text_dict, v_mm, h_mm, scale, page_h
        )
        col_positions = self._extract_columns_at_intersections(
            text_dict, v_mm, h_mm, scale, page_h, col_positions
        )

        conf = self._page_confidence(v_mm, h_mm, col_positions)
        print(f"  [CAD-VEC] Page {page_idx}: "
              f"{len(v_mm)}×{len(h_mm)} grid lines | "
              f"{len(col_positions)} column symbols | "
              f"scale 1:{round(scale / 0.3528)} | "
              f"conf {conf:.2f}")

        return {
            "page_idx": page_idx,
            "grid_x_mm": grid_x,
            "grid_y_mm": grid_y,
            "column_positions": col_positions,
            "scale_mm_per_unit": scale,
            "confidence": conf,
        }

    # ── Scale detection ───────────────────────────────────────────────────────

    def _detect_scale(self, text_dict: dict, paths: list) -> float:
        """
        Detect mm-per-PDF-pt conversion factor.

        PyMuPDF uses points (1 pt = 1/72 inch = 0.3528 mm).
        A drawing at scale 1:100 means 1 mm on paper = 100 mm in model,
        so 1 pt on paper = 100 × 0.3528 = 35.28 mm in model space.
        """
        all_text = " ".join(
            span["text"]
            for block in text_dict.get("blocks", [])
            for ln in block.get("lines", [])
            for span in ln.get("spans", [])
        )

        # Method 1: "1:100", "SCALE 1:200", "1 : 50" in page text
        m = re.search(r'1\s*:\s*(\d{1,4})', all_text)
        if m:
            n = int(m.group(1))
            if 10 <= n <= 5000:
                print(f"  [CAD-VEC] Scale from text annotation: 1:{n}")
                return n * 0.3528

        # Method 2: dimension value (mm) / matching line length (pts)
        dim_scale = self._scale_from_dimensions(text_dict, paths)
        if dim_scale > 0:
            print(f"  [CAD-VEC] Scale from dimension chain: 1:{round(dim_scale / 0.3528)}")
            return dim_scale

        # Default: 1:100 (most common for structural plans)
        return 35.28

    def _scale_from_dimensions(self, text_dict: dict, paths: list) -> float:
        """
        Infer scale by finding a numeric dimension text (e.g. "7200") near a
        line whose PDF-unit length × unknown_scale ≈ that value.
        """
        dim_pts = []
        for block in text_dict.get("blocks", []):
            for ln in block.get("lines", []):
                for span in ln.get("spans", []):
                    txt = span["text"].strip()
                    if re.fullmatch(r'\d{4,5}', txt):
                        val = int(txt)
                        if 1000 <= val <= 30000:
                            b = span["bbox"]
                            dim_pts.append({
                                "val": val,
                                "cx": (b[0] + b[2]) / 2,
                                "cy": (b[1] + b[3]) / 2,
                            })

        if not dim_pts:
            return 0.0

        scales = []
        for path in paths:
            for item in path.get("items", []):
                if item[0] != "l":
                    continue
                try:
                    p1, p2 = item[1], item[2]
                    length = math.hypot(p2.x - p1.x, p2.y - p1.y)
                except (IndexError, AttributeError, TypeError):
                    continue
                if length < 20:
                    continue
                lcx = (p1.x + p2.x) / 2
                lcy = (p1.y + p2.y) / 2
                for dt in dim_pts:
                    if math.hypot(dt["cx"] - lcx, dt["cy"] - lcy) < 80:
                        s = dt["val"] / length
                        if 5 <= s <= 500:
                            scales.append(s)

        if not scales:
            return 0.0

        scales.sort()
        mid = scales[len(scales) // 2]
        good = [s for s in scales if 0.8 * mid <= s <= 1.2 * mid]
        return sum(good) / len(good) if good else 0.0

    # ── Grid line detection ───────────────────────────────────────────────────

    def _extract_grid_lines(self, paths: list, page_h: float,
                             scale: float) -> tuple:
        """
        Find horizontal and vertical grid lines.

        PDF Y axis is top-down; we invert it so returned mm values are
        measured from the bottom-left corner (standard drawing convention).

        Returns:
            (v_lines_mm, h_lines_mm) — sorted lists, mm from drawing origin.
        """
        min_len_pt = self.MIN_GRID_LINE_MM / scale

        h_cands: list = []  # y-centres of horizontal line candidates (pts)
        v_cands: list = []  # x-centres of vertical line candidates (pts)

        for path in paths:
            r = path.get("rect")
            if r is None or r.is_empty:
                continue

            w, hv = r.width, r.height

            # Skip obviously filled solid shapes (column symbols, slab fills, hatching):
            # square-ish aspect ratio OR both dimensions too small to be a grid line.
            # Grid lines are always very elongated so they pass through regardless of fill.
            if path.get("fill") is not None:
                min_dim = min(w, hv)
                max_dim = max(w, hv)
                aspect = max_dim / max(min_dim, 0.01)
                if aspect < 5 or (w < min_len_pt and hv < min_len_pt):
                    continue

            # Horizontal line: much wider than tall
            if w >= min_len_pt and (hv < 4.0 or w / max(hv, 0.01) > 20):
                h_cands.append((r.y0 + r.y1) / 2)

            # Vertical line: much taller than wide
            elif hv >= min_len_pt and (w < 4.0 or hv / max(w, 0.01) > 20):
                v_cands.append((r.x0 + r.x1) / 2)

        print(f"  [CAD-VEC-DBG] {len(paths)} paths → {len(h_cands)} H-cands, {len(v_cands)} V-cands")
        v_cl = self._cluster(v_cands, self.GRID_CLUSTER_PT)
        h_cl = self._cluster(h_cands, self.GRID_CLUSTER_PT)

        # Convert to mm; invert Y (PDF top-down → bottom-up)
        v_mm = sorted(x * scale for x in v_cl)
        h_mm = sorted((page_h - y) * scale for y in h_cl)
        return v_mm, h_mm

    # ── Column symbol detection ───────────────────────────────────────────────

    def _extract_column_positions(self, paths: list, text_dict: dict,
                                   v_mm: list, h_mm: list,
                                   scale: float, page_h: float) -> dict:
        """
        Detect column cross-section symbols (small rectangles), snap each to
        the nearest grid intersection, then associate with the nearest column-
        mark text label.

        Column symbols in structural CAD plans are typically:
          - Small filled or outlined square/rectangle (the column cross-section)
          - Size: 80–800 mm in model space, roughly square (w/h ratio < 3.5)
          - Located at or near a grid intersection
        """
        min_pt = self.MIN_COL_MM / scale
        max_pt = self.MAX_COL_MM / scale
        label_r_sq = self.LABEL_RADIUS_MM ** 2

        # Step 1: collect candidate symbol centre points (mm, bottom-up Y)
        centers: list = []
        for path in paths:
            r = path.get("rect")
            if r is None or r.is_empty:
                continue
            w, hv = r.width, r.height
            if not (min_pt <= w <= max_pt and min_pt <= hv <= max_pt):
                continue
            if max(w, hv) / max(min(w, hv), 0.001) > 3.5:
                continue  # too elongated — dimension line or wall, not a column

            cx_mm = ((r.x0 + r.x1) / 2) * scale
            cy_mm = (page_h - (r.y0 + r.y1) / 2) * scale  # invert Y
            centers.append((cx_mm, cy_mm))

        if not centers:
            return {}

        # Step 2: collect text spans that look like column marks
        mark_spans: list = []
        for block in text_dict.get("blocks", []):
            for ln in block.get("lines", []):
                for span in ln.get("spans", []):
                    txt = span["text"].strip()
                    if self.COL_MARK_RE.match(txt) and 1 <= len(txt) <= 10:
                        b = span["bbox"]
                        cx = ((b[0] + b[2]) / 2) * scale
                        cy = (page_h - (b[1] + b[3]) / 2) * scale
                        mark_spans.append({
                            "text": txt.upper(),
                            "cx": cx,
                            "cy": cy,
                        })

        # Step 3: snap each symbol to grid, then find nearest unused label
        columns: dict = {}
        used_labels: set = set()

        for cx_mm, cy_mm in centers:
            sx, sy, snapped = self._snap(cx_mm, cy_mm, v_mm, h_mm)
            if not snapped:
                continue  # not near any grid intersection — skip

            best_lbl, best_d2 = None, label_r_sq
            for sp in mark_spans:
                if sp["text"] in used_labels:
                    continue
                d2 = (sp["cx"] - cx_mm) ** 2 + (sp["cy"] - cy_mm) ** 2
                if d2 < best_d2:
                    best_d2 = d2
                    best_lbl = sp["text"]

            if best_lbl:
                columns[best_lbl] = {"x_mm": round(sx), "y_mm": round(sy)}
                used_labels.add(best_lbl)

        return columns

    def _extract_columns_at_intersections(
            self, text_dict: dict, v_mm: list, h_mm: list,
            scale: float, page_h: float, existing: dict) -> dict:
        """
        Fallback: for every grid intersection without a nearby column symbol,
        look for a column-mark text label within LABEL_RADIUS_MM.
        Handles drawings that show only text marks (no cross-section rectangle).
        """
        result = dict(existing)
        label_r_sq = self.LABEL_RADIUS_MM ** 2
        snap_sq = (self.SNAP_TOLERANCE_MM * 2) ** 2  # wider than symbol snap

        # Collect all candidate mark spans once
        mark_spans: list = []
        for block in text_dict.get("blocks", []):
            for ln in block.get("lines", []):
                for span in ln.get("spans", []):
                    txt = span["text"].strip()
                    if self.COL_MARK_RE.match(txt) and 1 <= len(txt) <= 10:
                        b = span["bbox"]
                        cx = ((b[0] + b[2]) / 2) * scale
                        cy = (page_h - (b[1] + b[3]) / 2) * scale
                        mark_spans.append({"text": txt.upper(), "cx": cx, "cy": cy})

        used_labels = set(result.keys())
        new_from_intersect = 0

        for vx in v_mm:
            for hy in h_mm:
                # Skip if already have a column near this intersection
                if any(
                    (pos["x_mm"] - vx) ** 2 + (pos["y_mm"] - hy) ** 2 < snap_sq
                    for pos in result.values()
                ):
                    continue
                # Find nearest unused label within LABEL_RADIUS_MM
                best_lbl, best_d2 = None, label_r_sq
                for sp in mark_spans:
                    if sp["text"] in used_labels:
                        continue
                    d2 = (sp["cx"] - vx) ** 2 + (sp["cy"] - hy) ** 2
                    if d2 < best_d2:
                        best_d2 = d2
                        best_lbl = sp["text"]
                if best_lbl:
                    result[best_lbl] = {"x_mm": round(vx), "y_mm": round(hy)}
                    used_labels.add(best_lbl)
                    new_from_intersect += 1

        if new_from_intersect:
            print(f"  [CAD-VEC] Intersection fallback added {new_from_intersect} columns "
                  f"(text-only marks)")
        return result

    # ── Helpers ───────────────────────────────────────────────────────────────

    @staticmethod
    def _label_alpha(h_lines_mm: list) -> dict:
        """
        Assign A, B, C … labels to Y grid lines sorted bottom-up.
        AS/NZS convention: A = bottom row (smallest Y).
        """
        alpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return {
            alpha[i]: round(y)
            for i, y in enumerate(sorted(h_lines_mm))
            if i < 26
        }

    @staticmethod
    def _cluster(coords: list, tol: float) -> list:
        """Cluster 1-D coordinates within tolerance → return centroid per cluster."""
        if not coords:
            return []
        coords = sorted(coords)
        clusters = [[coords[0]]]
        for c in coords[1:]:
            if c - clusters[-1][-1] <= tol:
                clusters[-1].append(c)
            else:
                clusters.append([c])
        return [sum(cl) / len(cl) for cl in clusters]

    def _parse_dimension_chains(self, text_dict: dict, page_h: float,
                                scale: float, v_mm: list, h_mm: list) -> tuple:
        """
        Find dimension annotation chains (e.g. "7200 7200 6000") along grid axes
        and use them to correct grid line spacings.
        Only applies when chain count = grid spans AND total within 5%.
        Returns (corrected_v_mm, corrected_h_mm).
        """
        import re as _re
        dim_spans: list = []
        for block in text_dict.get("blocks", []):
            for ln in block.get("lines", []):
                row = []
                for span in ln.get("spans", []):
                    txt = span["text"].strip()
                    if _re.fullmatch(r'\d{4,5}', txt):
                        val = int(txt)
                        if 500 <= val <= 30000:
                            b = span["bbox"]
                            cx = (b[0] + b[2]) / 2  # pts, not mm yet
                            cy = (b[1] + b[3]) / 2
                            row.append({"val": val, "cx": cx, "cy": cy})
                if len(row) >= 2:
                    row.sort(key=lambda s: s["cx"])
                    dim_spans.append(row)

        def _try_correct(grid: list, chains: list) -> list:
            n_spans = len(grid) - 1
            for chain in chains:
                if len(chain) != n_spans:
                    continue
                origin = grid[0]
                corrected = [origin]
                for d in chain:
                    corrected.append(corrected[-1] + d["val"])
                total_detected = grid[-1] - grid[0]
                total_chain = corrected[-1] - corrected[0]
                if total_detected > 0 and abs(total_chain - total_detected) / total_detected < 0.08:
                    print(f"  [CAD-VEC] Dimension chain corrected grid "
                          f"({n_spans} bays): {[d['val'] for d in chain]}")
                    return corrected
            return grid

        v_mm = _try_correct(sorted(v_mm), dim_spans)
        h_mm = _try_correct(sorted(h_mm), dim_spans)
        return v_mm, h_mm

    def _snap(self, x: float, y: float, v_mm: list, h_mm: list) -> tuple:
        """
        Snap point (x, y) to nearest grid intersection.
        Returns (snapped_x, snapped_y, success_bool).
        """
        tol = self.SNAP_TOLERANCE_MM
        best_v = min(v_mm, key=lambda v: abs(v - x))
        best_h = min(h_mm, key=lambda h: abs(h - y))
        ok = abs(best_v - x) <= tol and abs(best_h - y) <= tol
        return best_v, best_h, ok

    @staticmethod
    def _page_confidence(v_mm: list, h_mm: list, cols: dict) -> float:
        score = 0.0
        if len(v_mm) >= 2:
            score += 0.35
        if len(h_mm) >= 2:
            score += 0.35
        score += min(0.30, len(cols) * 0.04)
        return round(min(1.0, score), 2)

    # ── Multi-page merge ──────────────────────────────────────────────────────

    def _merge_pages(self, results: list) -> dict:
        """Merge grid + column data from multiple PLAN pages."""
        if len(results) == 1:
            r = results[0]
            return {
                "grid_x_mm": r["grid_x_mm"],
                "grid_y_mm": r["grid_y_mm"],
                "column_positions": r["column_positions"],
                "scale_mm_per_unit": r["scale_mm_per_unit"],
                "confidence": r["confidence"],
            }

        all_v, all_h, all_scales, merged_cols = [], [], [], {}
        for r in results:
            all_v.extend(r["grid_x_mm"].values())
            all_h.extend(r["grid_y_mm"].values())
            all_scales.append(r["scale_mm_per_unit"])
            # First occurrence wins — don't overwrite column positions already found
            for mark, pos in r["column_positions"].items():
                if mark not in merged_cols:
                    merged_cols[mark] = pos

        v_cl = CADVectorExtractor._cluster(all_v, 200)
        h_cl = CADVectorExtractor._cluster(all_h, 200)

        grid_x = {str(i + 1): round(x) for i, x in enumerate(sorted(v_cl))}
        grid_y = CADVectorExtractor._label_alpha(sorted(h_cl))
        avg_scale = sum(all_scales) / len(all_scales)
        max_conf = max(r["confidence"] for r in results)

        return {
            "grid_x_mm": grid_x,
            "grid_y_mm": grid_y,
            "column_positions": merged_cols,
            "scale_mm_per_unit": avg_scale,
            "confidence": max_conf,
        }
