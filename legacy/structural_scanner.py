"""
=============================================================================
PASS 1 — STRUCTURAL SCANNER (Vision LLM Agent)
=============================================================================
Analyzes ALL pages of a structural PDF in ONE multimodal LLM call to produce
a complete building manifest. Uses Gemini Vision to "see" drawings like an
engineer — no brittle regex or pixel math.

INPUT:  List of PNG image bytes (one per page)
OUTPUT: building_manifest.json with:
  - page classification (plan / elevation / section / schedule)
  - grid system (X labels + spacings, Y labels + spacings)
  - level markers (name + z elevation for each floor)
  - scale (px → mm)
  - schedule tables → member database
  - building type hint (low-rise, high-rise, industrial, etc.)
=============================================================================
"""

import json
import re
from pathlib import Path
from dataclasses import dataclass, field

from core.llm_wrapper import call_llm
from core.pdf_utils import pdf_to_images_bytes


# ============================================================================
# DATA STRUCTURES
# ============================================================================

@dataclass
class GridAxis:
    """One axis of the grid system."""
    labels: list[str] = field(default_factory=list)
    spacings_mm: list[float] = field(default_factory=list)
    total_span_mm: float = 0.0


@dataclass
class LevelDef:
    """A floor level definition."""
    name: str
    elevation_mm: float
    plan_page_index: int = -1
    floor_height_mm: float = 3500.0


@dataclass
class MemberSpec:
    """Single structural member spec from schedule."""
    mark: str
    member_type: str
    section_label: str
    dimensions: dict = field(default_factory=dict)
    material: str = "Steel"
    length_mm: float = 0.0


@dataclass
class BuildingManifest:
    """Complete building data extracted from all PDF pages."""
    building_name: str = ""
    building_type: str = "multi-storey"
    num_floors: int = 1
    total_height_mm: float = 3500.0
    
    scale_x_mm_per_px: float = 0.0
    scale_y_mm_per_px: float = 0.0
    scale_confidence: float = 0.0
    
    grid_x: GridAxis = field(default_factory=GridAxis)
    grid_y: GridAxis = field(default_factory=GridAxis)
    
    levels: list[LevelDef] = field(default_factory=list)
    
    plan_page_indices: list[int] = field(default_factory=list)
    elevation_page_indices: list[int] = field(default_factory=list)
    section_page_indices: list[int] = field(default_factory=list)
    schedule_page_indices: list[int] = field(default_factory=list)
    
    member_db: dict[str, MemberSpec] = field(default_factory=dict)
    raw_llm_response: str = ""
    
    def to_dict(self) -> dict:
        return {
            "building_name": self.building_name,
            "building_type": self.building_type,
            "num_floors": self.num_floors,
            "total_height_mm": self.total_height_mm,
            "scale": {
                "x_mm_per_px": self.scale_x_mm_per_px,
                "y_mm_per_px": self.scale_y_mm_per_px,
                "confidence": self.scale_confidence,
            },
            "grid_x": {
                "labels": self.grid_x.labels,
                "spacings_mm": self.grid_x.spacings_mm,
                "positions_mm": self._cumulative_positions(self.grid_x),
                "total_span_mm": self.grid_x.total_span_mm,
            },
            "grid_y": {
                "labels": self.grid_y.labels,
                "spacings_mm": self.grid_y.spacings_mm,
                "positions_mm": self._cumulative_positions(self.grid_y),
                "total_span_mm": self.grid_y.total_span_mm,
            },
            "levels": [
                {
                    "name": l.name,
                    "elevation_mm": l.elevation_mm,
                    "plan_page_index": l.plan_page_index,
                    "floor_height_mm": l.floor_height_mm,
                }
                for l in self.levels
            ],
            "plan_page_indices": self.plan_page_indices,
            "elevation_page_indices": self.elevation_page_indices,
            "section_page_indices": self.section_page_indices,
            "schedule_page_indices": self.schedule_page_indices,
            "member_db": {
                k: {
                    "mark": v.mark,
                    "member_type": v.member_type,
                    "section_label": v.section_label,
                    "dimensions": v.dimensions,
                    "material": v.material,
                    "length_mm": v.length_mm,
                }
                for k, v in self.member_db.items()
            },
        }
    
    @staticmethod
    def _cumulative_positions(axis: GridAxis) -> list[float]:
        pos = [0.0]
        for s in axis.spacings_mm:
            pos.append(pos[-1] + s)
        return pos


# ============================================================================
# SCANNER AGENT
# ============================================================================

class StructuralScanner:
    """
    Pass 1: Scan all PDF pages using Vision LLM → BuildingManifest.
    """
    
    MAX_PAGES_PER_CALL = 30
    
    def __init__(self, pdf_path: str | Path):
        self.pdf_path = Path(pdf_path)
        self.manifest = BuildingManifest()
    
    def scan(self) -> BuildingManifest:
        print(f"\n{'='*60}")
        print(f"PASS 1: STRUCTURAL SCANNER (Vision LLM)")
        print(f"{'='*60}")
        print(f"PDF: {self.pdf_path.name}")
        
        images = pdf_to_images_bytes(str(self.pdf_path), dpi=150)
        print(f"  Rendered {len(images)} pages to images")
        
        prompt = self._build_scan_prompt(len(images))
        
        print(f"  Calling Gemini 2.5 Flash with {len(images)} images...")
        response = call_llm(prompt, images=images)
        self.manifest.raw_llm_response = response
        
        self._parse_llm_response(response)
        
        print(f"\n  ✓ Building: {self.manifest.building_name}")
        print(f"  ✓ Type: {self.manifest.building_type}")
        print(f"  ✓ Floors: {self.manifest.num_floors}")
        print(f"  ✓ Grid X: {len(self.manifest.grid_x.labels)} lines")
        print(f"  ✓ Grid Y: {len(self.manifest.grid_y.labels)} lines")
        print(f"  ✓ Levels: {len(self.manifest.levels)}")
        for lv in self.manifest.levels[:5]:
            print(f"      {lv.name}: z={lv.elevation_mm/1000:.2f}m")
        if len(self.manifest.levels) > 5:
            print(f"      ... and {len(self.manifest.levels)-5} more")
        print(f"  ✓ Member DB: {len(self.manifest.member_db)} entries")
        print(f"  ✓ Pages - Plan:{self.manifest.plan_page_indices} Elev:{self.manifest.elevation_page_indices} Sect:{self.manifest.section_page_indices} Sched:{self.manifest.schedule_page_indices}")
        
        return self.manifest
    
    def _build_scan_prompt(self, num_pages: int) -> str:
        return f"""You are a PRINCIPAL STRUCTURAL ENGINEER analyzing a complete set of structural drawings.

Below are {num_pages} pages from a structural PDF. Analyze ALL pages carefully and return a COMPLETE building analysis in JSON format.

## STEP 1: CLASSIFY EACH PAGE (0 to {num_pages-1})
Determine its type: "plan", "elevation", "section", "schedule", "detail", or "other"

## STEP 2: EXTRACT GRID SYSTEM
From plan pages, read the structural grid:
- Grid X (horizontal, typically numbers 1,2,3...): ALL labels + center-to-center spacing in mm
- Grid Y (vertical, typically letters A,B,C...): ALL labels + spacing in mm

## STEP 3: EXTRACT LEVELS
From elevation/section pages, read EVERY floor level:
- Name, elevation Z in mm from ground
- Typical floor-to-floor height in mm

## STEP 4: SCALE
Look for scale bars, dimension lines with numeric values, or "SCALE 1:XXX" text. Compute mm_per_pixel.

## STEP 5: SCHEDULE EXTRACTION
From schedule/table pages, extract ALL structural members with mark, type, section size, material, dimensions.

## OUTPUT: Return ONLY valid JSON (no markdown fences, no explanations):

{{
  "building_name": "string",
  "building_type": "low-rise|mid-rise|high-rise|industrial|single-storey",
  "num_floors": integer,
  "typical_floor_height_mm": number,
  "total_height_mm": number,
  "scale": {{"mm_per_pixel": number, "confidence": 0.0-1.0}},
  "grid_x": {{"labels": ["1","2","3"], "spacings_mm": [6000,6000]}},
  "grid_y": {{"labels": ["A","B","C"], "spacings_mm": [8000,8000]}},
  "levels": [{{"name": "Level 1", "elevation_mm": 0, "plan_page_index": 0, "floor_height_mm": 3500}}],
  "pages": {{"plan": [0,2], "elevation": [1], "section": [3], "schedule": [4]}},
  "member_database": {{
    "C1": {{"type": "column", "section": "400x400", "material": "Concrete", "dimensions": {{"width":400,"depth":400}}}},
    "B1": {{"type": "beam", "section": "UB305x165x40", "material": "Steel", "dimensions": {{"depth":304,"width":165,"flange":10.2,"web":6.1}}}}
  }}
}}

RULES:
1. Return ONLY the JSON object.
2. All numbers in MILLIMETERS.
3. Grid labels EXACTLY as shown on drawings.
4. Include ALL floor levels from elevation.
5. Extract EVERY row from schedule tables.
6. Use null for unknown values (not 0)."""

    def _parse_llm_response(self, response: str) -> None:
        json_str = response.strip()
        
        if json_str.startswith("```"):
            lines = json_str.split("\n")
            if lines[0].startswith("```"):
                lines = lines[1:]
            if lines and lines[-1].strip().startswith("```"):
                lines = lines[:-1]
            json_str = "\n".join(lines)
        
        try:
            data = json.loads(json_str)
        except json.JSONDecodeError:
            match = re.search(r'\{.*\}', response, re.DOTALL)
            if match:
                try:
                    data = json.loads(match.group())
                except json.JSONDecodeError:
                    print(f"  ⚠ Failed to parse LLM response as JSON")
                    print(f"  Preview: {response[:500]}...")
                    return
            else:
                print(f"  ⚠ No JSON found in LLM response")
                return
        
        m = self.manifest
        m.building_name = data.get("building_name", "")
        m.building_type = data.get("building_type", "multi-storey")
        m.num_floors = data.get("num_floors", 1)
        m.total_height_mm = data.get("total_height_mm", 3500.0)
        
        scale = data.get("scale", {})
        m.scale_x_mm_per_px = scale.get("mm_per_pixel", 0.0)
        m.scale_y_mm_per_px = scale.get("mm_per_pixel", 0.0)
        m.scale_confidence = scale.get("confidence", 0.0)
        
        gx = data.get("grid_x", {})
        m.grid_x.labels = gx.get("labels", [])
        m.grid_x.spacings_mm = gx.get("spacings_mm", [])
        m.grid_x.total_span_mm = sum(m.grid_x.spacings_mm)
        
        gy = data.get("grid_y", {})
        m.grid_y.labels = gy.get("labels", [])
        m.grid_y.spacings_mm = gy.get("spacings_mm", [])
        m.grid_y.total_span_mm = sum(m.grid_y.spacings_mm)
        
        typical_h = data.get("typical_floor_height_mm", 3500.0)
        for lv_data in data.get("levels", []):
            lv = LevelDef(
                name=lv_data.get("name", ""),
                elevation_mm=lv_data.get("elevation_mm", 0),
                plan_page_index=lv_data.get("plan_page_index", -1),
                floor_height_mm=lv_data.get("floor_height_mm", typical_h),
            )
            m.levels.append(lv)
        
        pages = data.get("pages", {})
        m.plan_page_indices = pages.get("plan", [])
        m.elevation_page_indices = pages.get("elevation", [])
        m.section_page_indices = pages.get("section", [])
        m.schedule_page_indices = pages.get("schedule", [])
        
        member_db = data.get("member_database", {})
        for mark, spec in member_db.items():
            ms = MemberSpec(
                mark=mark,
                member_type=spec.get("type", "unknown"),
                section_label=spec.get("section", ""),
                dimensions=spec.get("dimensions", {}),
                material=spec.get("material", "Steel"),
                length_mm=spec.get("length_mm", 0.0),
            )
            m.member_db[mark] = ms