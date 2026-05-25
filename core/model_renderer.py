"""
=============================================================================
MODEL PLAN RENDERER — Sprint 4A
=============================================================================
Renders a 2D top-down plan view PNG from a structural model using PIL.
Used for visual similarity comparison against the original drawing.
=============================================================================
"""

import io
import re


class ModelPlanRenderer:
    """
    Renders a 2D plan-view PNG from a structural model for visual comparison
    with the original PDF drawing page.
    """

    def render_plan(self, model: dict, width_px: int = 1200,
                    height_px: int = 900) -> bytes:
        """Returns PNG bytes of plan view (top-down). Empty bytes if no columns."""
        try:
            from PIL import Image, ImageDraw, ImageFont
        except ImportError:
            return b""

        members = model.get("members", {})
        cols = members.get("columns", [])
        beams = members.get("beams", [])

        if not cols:
            return b""

        xs = [float(c.get("x_mm") or c.get("x") or 0) for c in cols]
        ys = [float(c.get("y_mm") or c.get("y") or 0) for c in cols]

        margin = 80
        x_min, x_max = min(xs), max(xs)
        y_min, y_max = min(ys), max(ys)

        span_x = x_max - x_min or 1
        span_y = y_max - y_min or 1
        scale = min((width_px - 2 * margin) / span_x,
                    (height_px - 2 * margin) / span_y)

        def to_px(x_mm: float, y_mm: float):
            return (
                int(margin + (x_mm - x_min) * scale),
                int(height_px - margin - (y_mm - y_min) * scale),  # flip Y
            )

        img = Image.new("RGB", (width_px, height_px), "white")
        draw = ImageDraw.Draw(img)

        # Grid lines (light gray)
        gs = model.get("grid_system", {})
        for x_mm in gs.get("x_coords", {}).values():
            px, _ = to_px(float(x_mm), y_min)
            draw.line([(px, margin), (px, height_px - margin)],
                      fill=(200, 200, 200), width=1)
        for y_mm in gs.get("y_coords", {}).values():
            _, py = to_px(x_min, float(y_mm))
            draw.line([(margin, py), (width_px - margin, py)],
                      fill=(200, 200, 200), width=1)

        # Build mark → pixel map for beam drawing
        col_px = {}
        for c in cols:
            mark = self._norm(c)
            if mark:
                col_px[mark] = to_px(
                    float(c.get("x_mm") or c.get("x") or 0),
                    float(c.get("y_mm") or c.get("y") or 0),
                )

        # Beams (blue lines)
        for b in beams:
            p1 = col_px.get(self._norm({"id": b.get("from_col", "")}))
            p2 = col_px.get(self._norm({"id": b.get("to_col", "")}))
            if p1 and p2:
                draw.line([p1, p2], fill=(0, 100, 200), width=2)

        # Columns (black filled squares, size proportional to scale)
        col_sz = max(4, int(scale * 300 / 1000))  # 300mm column → col_sz px
        for c in cols:
            px, py = to_px(
                float(c.get("x_mm") or c.get("x") or 0),
                float(c.get("y_mm") or c.get("y") or 0),
            )
            draw.rectangle([px - col_sz, py - col_sz, px + col_sz, py + col_sz],
                            fill="black", outline="black")

        buf = io.BytesIO()
        img.save(buf, format="PNG")
        return buf.getvalue()

    @staticmethod
    def _norm(c: dict) -> str:
        s = str(c.get("id") or c.get("mark") or "")
        return re.sub(r'[-_\s]+', '', s).upper()
