"""
=============================================================================
VISION RENDERER — PDF → High-Resolution Images for AI Analysis
=============================================================================
Converts PDF pages to 300 DPI PNG images suitable for Gemini Vision API.
Extracts metadata: page dimensions, orientation, vector line count.
=============================================================================
"""
import fitz  # PyMuPDF
import io
import json
import re
from pathlib import Path
from typing import Optional
from PIL import Image


class VisionRenderer:
    """
    Renders PDF pages as high-resolution images for AI vision analysis.
    
    CAD-generated PDFs contain vector graphics (lines, arcs, hatches).
    Text extraction alone loses ~95% of information. Vision-first approach
    sends the actual drawing image to Gemini for analysis.
    """
    
    def __init__(self, pdf_path: str | Path, dpi: int = 300):
        self.pdf_path = Path(pdf_path)
        self.dpi = dpi
        self.doc: Optional[fitz.Document] = None
        self._open()
    
    def _open(self):
        """Open PDF document."""
        self.doc = fitz.open(str(self.pdf_path))
    
    @property
    def num_pages(self) -> int:
        return len(self.doc) if self.doc else 0
    
    def render_page_as_pil(self, page_idx: int) -> Image.Image:
        """Render a single page as PIL Image at configured DPI."""
        if not self.doc or page_idx >= self.num_pages:
            raise ValueError(f"Invalid page index: {page_idx}")
        
        page = self.doc[page_idx]
        # Calculate zoom factor for desired DPI (PDF default is 72 DPI)
        zoom = self.dpi / 72.0
        mat = fitz.Matrix(zoom, zoom)
        
        pix = page.get_pixmap(matrix=mat)
        
        # Convert to PIL Image
        if pix.n >= 4:
            img = Image.frombytes("RGBA", (pix.width, pix.height), pix.samples)
            # Convert to RGB (remove alpha for Gemini API)
            background = Image.new("RGB", img.size, (255, 255, 255))
            background.paste(img, mask=img.split()[3])
            img = background
        else:
            img = Image.frombytes("RGB", (pix.width, pix.height), pix.samples)
        
        return img
    
    def render_page_as_bytes(self, page_idx: int, format: str = "PNG") -> bytes:
        """Render a page as PNG bytes for API submission."""
        img = self.render_page_as_pil(page_idx)
        buf = io.BytesIO()
        img.save(buf, format=format)
        return buf.getvalue()
    
    def render_page_to_file(self, page_idx: int, output_path: str | Path):
        """Render a page and save as PNG file."""
        img = self.render_page_as_pil(page_idx)
        Path(output_path).parent.mkdir(parents=True, exist_ok=True)
        img.save(str(output_path), "PNG")
    
    def get_page_metadata(self, page_idx: int, include_drawings: bool = False) -> dict:
        """Extract page geometric metadata for AI context.
        
        Args:
            page_idx: Page index
            include_drawings: If True, count drawing paths (SLOW on CAD PDFs - 
                              can freeze for minutes on pages with 50K+ paths).
                              Default False for fast metadata extraction.
        """
        if not self.doc or page_idx >= self.num_pages:
            return {}
        
        page = self.doc[page_idx]
        rect = page.rect
        
        # Fast path: only get text blocks (drawings are expensive on CAD PDFs)
        text_blocks = page.get_text("blocks")
        
        num_paths = 0
        if include_drawings:
            # WARNING: get_drawings() parses ALL vector geometry - VERY SLOW
            # on CAD-generated PDFs with thousands of line segments.
            # Only use for debugging single pages.
            try:
                paths = page.get_drawings()
                num_paths = len(paths)
            except Exception:
                num_paths = -1  # signal error
        
        return {
            "page_index": page_idx,
            "width_pt": rect.width,
            "height_pt": rect.height,
            "width_mm": rect.width * 25.4 / 72,
            "height_mm": rect.height * 25.4 / 72,
            "orientation": "landscape" if rect.width > rect.height else "portrait",
            "num_drawing_paths": num_paths,
            "num_text_blocks": len(text_blocks),
            "rendered_width_px": int(rect.width * self.dpi / 72),
            "rendered_height_px": int(rect.height * self.dpi / 72),
            "dpi": self.dpi,
        }
    
    def render_all_metadata(self) -> list[dict]:
        """Get metadata for all pages."""
        return [self.get_page_metadata(i) for i in range(self.num_pages)]
    
    def render_all_pages(self, output_dir: str | Path) -> list[Path]:
        """Render all pages to PNG files. Returns list of output paths."""
        output_dir = Path(output_dir)
        output_dir.mkdir(parents=True, exist_ok=True)
        
        paths = []
        for i in range(self.num_pages):
            out_path = output_dir / f"page_{i:03d}.png"
            self.render_page_to_file(i, out_path)
            paths.append(out_path)
        
        return paths
    
    def get_drawing_data(self, page_idx: int) -> list[dict]:
        """
        Extract raw vector drawing data from a page.
        Returns list of paths with their geometry for AI context enrichment.
        """
        if not self.doc or page_idx >= self.num_pages:
            return []
        
        page = self.doc[page_idx]
        drawings = page.get_drawings()
        
        drawing_data = []
        for i, d in enumerate(drawings):
            # Extract key geometric info
            items = []
            for item in d.get("items", []):
                if item[0] == "l":  # line
                    items.append({
                        "type": "line",
                        "start": list(item[1]),
                        "end": list(item[2])
                    })
                elif item[0] == "c":  # curve
                    items.append({
                        "type": "curve",
                        "start": list(item[1]),
                        "end": list(item[2]),
                        "control": list(item[3])
                    })
                elif item[0] == "re":  # rectangle
                    items.append({
                        "type": "rect",
                        "rect": list(item[1])
                    })
            
            if items:
                drawing_data.append({
                    "index": i,
                    "fill": d.get("fill"),
                    "color": d.get("color"),
                    "width": d.get("width"),
                    "rect": list(d.get("rect", [])),
                    "num_items": len(items),
                    "items": items[:50],  # Limit to 50 items per path
                })
        
        return drawing_data
    
    def get_all_text(self, page_idx: int) -> list[dict]:
        """Extract text with positions for AI context."""
        if not self.doc or page_idx >= self.num_pages:
            return []
        
        page = self.doc[page_idx]
        text_blocks = page.get_text("blocks")
        
        blocks = []
        for b in text_blocks:
            blocks.append({
                "x0": b[0], "y0": b[1], "x1": b[2], "y1": b[3],
                "text": b[4].strip()[:200],  # Limit text length
                "block_type": "text" if b[6] == 0 else "image"
            })
        
        return blocks
    
    def build_ai_context(self, page_idx: int) -> dict:
        """
        Build comprehensive context dict for AI analysis.
        Includes metadata, drawing summary, and text blocks.
        """
        meta = self.get_page_metadata(page_idx)
        text_blocks = self.get_all_text(page_idx)
        
        # Summarize drawings
        drawings = self.get_drawing_data(page_idx)
        total_items = sum(d["num_items"] for d in drawings)
        line_count = sum(1 for d in drawings for item in d["items"] if item["type"] == "line")
        rect_count = sum(1 for d in drawings for item in d["items"] if item["type"] == "rect")
        curve_count = sum(1 for d in drawings for item in d["items"] if item["type"] == "curve")
        
        return {
            "metadata": meta,
            "drawing_summary": {
                "total_paths": len(drawings),
                "total_items": total_items,
                "lines": line_count,
                "rectangles": rect_count,
                "curves": curve_count,
            },
            "text_blocks": text_blocks[:30],  # Top 30 text blocks
            "raw_text": " ".join(b["text"] for b in text_blocks if b["text"])[:3000],
        }
    
    def close(self):
        """Close PDF document."""
        if self.doc:
            self.doc.close()
            self.doc = None
    
    def __enter__(self):
        return self
    
    def __exit__(self, *args):
        self.close()


def render_pdf_for_vision(pdf_path: str | Path, output_dir: str | Path = None, dpi: int = 300) -> dict:
    """
    Convenience function: render entire PDF for vision analysis.
    
    Returns dict with:
        - rendered_pages: list of PNG file paths
        - metadata: list of page metadata
        - context: list of AI context dicts per page
    """
    pdf_path = Path(pdf_path)
    if output_dir is None:
        output_dir = pdf_path.parent / f"{pdf_path.stem}_rendered"
    
    with VisionRenderer(pdf_path, dpi) as renderer:
        # Render all pages
        png_paths = renderer.render_all_pages(output_dir)
        
        # Collect metadata
        meta_list = renderer.render_all_metadata()
        
        # Build AI context
        contexts = [renderer.build_ai_context(i) for i in range(renderer.num_pages)]
        
        return {
            "pdf_path": str(pdf_path),
            "num_pages": renderer.num_pages,
            "dpi": dpi,
            "rendered_pages": [str(p) for p in png_paths],
            "metadata": meta_list,
            "context": contexts,
        }