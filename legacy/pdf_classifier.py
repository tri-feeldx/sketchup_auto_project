"""
=============================================================================
PHASE 0 — PDF CLASSIFIER (Vision LLM)
=============================================================================
Gửi vài trang đầu cho Vision LLM để phân loại PDF type.
Quyết định strategy cho toàn bộ pipeline.

PDF Types:
  - structural_only: grid system + schedule tables + steel sections
  - architectural_only: walls, rooms, doors, windows, no grid
  - mixed: cả structural + architectural (phổ biến trong shop drawing)

Output: classification dict với type + features + strategy suggestion
=============================================================================
"""

import json
import time
from pathlib import Path
from typing import Optional

from core.llm_wrapper import call_llm
from core.pdf_utils import pdf_to_images_bytes


def classify_pdf(pdf_path):
    """
    Phân loại PDF bằng Vision LLM.
    
    Args:
        pdf_path: Path to PDF file
        
    Returns:
        dict: {
            "pdf_type": "structural_only" | "architectural_only" | "mixed",
            "strategy": "grid_based" | "gridless_architectural" | "hybrid",
            "features": ["grid_lines", "schedule_tables", ...],
            "has_grid": bool,
            "has_schedule": bool,
            "has_walls": bool,
            "has_dimensions": bool,
            "confidence": float,
            "auto_detected": true
        }
    """
    pdf_path = Path(pdf_path)
    print(f"\n  [CLASSIFY] Classifying PDF: {pdf_path.name}")
    
    t0 = time.time()
    
    # Render first 3 pages (or fewer) as images
    page_images = pdf_to_images_bytes(str(pdf_path), dpi=120)
    sample_pages = page_images[:min(3, len(page_images))]
    
    if not sample_pages:
        return _fallback_classification()
    
    prompt = """You are a construction drawing expert. Analyze these PDF pages and classify the type of building drawing.

Determine the PDF TYPE from these categories:
1. "structural_only" — Contains ONLY structural elements: 
   - Grid lines (A, B, C / 1, 2, 3)
   - Column/beam schedules (tables with section labels like UB305x165x40, H300x300)
   - Member marks (C1, B1, etc.)
   - No architectural walls, rooms, doors, or windows
   - Typical for structural steel drawings, foundation plans

2. "architectural_only" — Contains ONLY architectural elements:
   - Walls (thick lines, hatched)
   - Room names, room areas
   - Doors (arc symbols, swing indicators)
   - Windows (thin lines with multiple panes)
   - Stairs (step lines)
   - Dimension lines without grid labels
   - No structural member schedules
   - Typical for floor plans, house plans

3. "mixed" — Contains BOTH structural and architectural:
   - Grid lines AND room layouts
   - Column positions within wall layouts
   - Both member schedules and door/window schedules
   - Typical for shop drawings, construction documents

FEATURES to detect (answer YES/NO for each):
- grid_lines: Are there labeled grid lines (A, B, 1, 2)?
- schedule_tables: Are there structured tables with type/size columns?
- walls_hatched: Are walls shown as hatched/filled bands?
- door_symbols: Are there door swing arcs visible?
- window_symbols: Are there window symbols (thin rectangles in walls)?
- dimension_lines: Are there dimension chains with numbers?
- room_labels: Are rooms named/labeled?
- steel_sections: Are steel section IDs like "UB", "UC", "H", "W" visible?
- elevation_marks: Are there elevation height markers (±0.000, +3.500)?
- floor_levels: Are multiple floor levels indicated?

Return ONLY valid JSON:
{
  "pdf_type": "structural_only|architectural_only|mixed",
  "features": ["grid_lines", "schedule_tables", ...],
  "has_grid": true/false,
  "has_schedule": true/false,
  "has_walls": true/false,
  "has_dimensions": true/false,
  "building_stories": number_of_floors_seen,
  "primary_language": "en|vi|other",
  "confidence": 0.0-1.0
}

CRITICAL: Return EXACTLY the JSON object. No markdown, no explanation."""

    try:
        response = call_llm(prompt, images=sample_pages)
        json_str = _extract_json(response)
        
        if json_str:
            data = json.loads(json_str)
            classification = {
                "pdf_type": data.get("pdf_type", "mixed"),
                "strategy": _type_to_strategy(data.get("pdf_type", "mixed")),
                "features": data.get("features", []),
                "has_grid": data.get("has_grid", False),
                "has_schedule": data.get("has_schedule", False),
                "has_walls": data.get("has_walls", False),
                "has_dimensions": data.get("has_dimensions", False),
                "building_stories": data.get("building_stories", 1),
                "primary_language": data.get("primary_language", "en"),
                "confidence": data.get("confidence", 0.7),
                "auto_detected": True,
                "elapsed_s": time.time() - t0,
            }
            print(f"    [OK] Classified as: {classification['pdf_type']} (strategy: {classification['strategy']}, {classification['elapsed_s']:.1f}s)")
            return classification
    except Exception as e:
        print(f"    [WARN] Classification LLM error: {e}")
    
    return _fallback_classification()


def _type_to_strategy(pdf_type: str) -> str:
    """Map PDF type to extraction strategy."""
    mapping = {
        "structural_only": "grid_based",
        "architectural_only": "gridless_architectural",
        "mixed": "hybrid",
    }
    return mapping.get(pdf_type, "hybrid")


def _fallback_classification() -> dict:
    """Conservative fallback — assume mixed."""
    return {
        "pdf_type": "mixed",
        "strategy": "hybrid",
        "features": [],
        "has_grid": False,
        "has_schedule": False,
        "has_walls": True,
        "has_dimensions": True,
        "building_stories": 1,
        "primary_language": "en",
        "confidence": 0.3,
        "auto_detected": False,
        "fallback": True,
    }


def _extract_json(text: str) -> Optional[str]:
    """Extract JSON from LLM response."""
    text = text.strip()
    if text.startswith("```"):
        lines = text.split("\n")
        if lines[0].startswith("```"):
            lines = lines[1:]
        if lines and lines[-1].strip().startswith("```"):
            lines = lines[:-1]
        text = "\n".join(lines)
    
    try:
        json.loads(text)
        return text
    except json.JSONDecodeError:
        import re
        match = re.search(r'\{.*\}', text, re.DOTALL)
        return match.group() if match else None