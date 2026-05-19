"""
=============================================================================
PASS 2 — STRUCTURAL EXTRACTOR (Vision LLM Agent)
=============================================================================
Per-page analysis: for each plan page + elevation/section pages → extract:
  - Column positions at grid intersections → (x_mm, y_mm, mark, section)
  - Beam positions along grid lines → (start, end, mark, section)
  - Slab boundaries
  - Wall positions
  - Opening locations
  - Verify heights from elevations

INPUT:  BuildingManifest (from Pass 1) + single page image bytes
OUTPUT: FloorLayout per level with complete member list
=============================================================================
"""

import json
import re
import math
from pathlib import Path
from dataclasses import dataclass, field

from core.llm_wrapper import call_llm
from agents.structural_scanner import BuildingManifest, LevelDef


# ============================================================================
# DATA STRUCTURES
# ============================================================================

@dataclass
class StructuralMember:
    """A single structural element with position and specification."""
    mark: str
    member_type: str  # column, beam, brace, wall, slab
    grid_x: int = -1
    grid_y: int = -1
    x_mm: float = 0.0
    y_mm: float = 0.0
    z_start_mm: float = 0.0
    z_end_mm: float = 0.0
    section_label: str = ""
    material: str = "Steel"
    dimensions: dict = field(default_factory=dict)
    rotation_deg: float = 0.0
    confidence: float = 0.0
    # For beams/walls: end position
    x2_mm: float = 0.0
    y2_mm: float = 0.0
    grid_x2: int = -1
    grid_y2: int = -1
    length_mm: float = 0.0


@dataclass
class FloorLayout:
    """Complete structural layout for one floor level."""
    level_name: str
    elevation_z_mm: float
    floor_height_mm: float
    page_index: int
    columns: list[StructuralMember] = field(default_factory=list)
    beams: list[StructuralMember] = field(default_factory=list)
    walls: list[StructuralMember] = field(default_factory=list)
    braces: list[StructuralMember] = field(default_factory=list)
    
    def all_members(self) -> list[StructuralMember]:
        return self.columns + self.beams + self.walls + self.braces


@dataclass
class BuildingModel:
    """Complete building model ready for code generation."""
    manifest: BuildingManifest = field(default_factory=BuildingManifest)
    floors: list[FloorLayout] = field(default_factory=list)
    
    def to_dict(self) -> dict:
        def member_dict(m: StructuralMember) -> dict:
            return {
                "mark": m.mark,
                "member_type": m.member_type,
                "grid_x": m.grid_x, "grid_y": m.grid_y,
                "x_mm": m.x_mm, "y_mm": m.y_mm,
                "z_start_mm": m.z_start_mm, "z_end_mm": m.z_end_mm,
                "section_label": m.section_label,
                "material": m.material,
                "dimensions": m.dimensions,
                "rotation_deg": m.rotation_deg,
                "confidence": m.confidence,
                "x2_mm": m.x2_mm, "y2_mm": m.y2_mm,
                "grid_x2": m.grid_x2, "grid_y2": m.grid_y2,
                "length_mm": m.length_mm,
            }
        return {
            "manifest": self.manifest.to_dict(),
            "floors": [
                {
                    "level_name": f.level_name,
                    "elevation_z_mm": f.elevation_z_mm,
                    "floor_height_mm": f.floor_height_mm,
                    "page_index": f.page_index,
                    "columns": [member_dict(c) for c in f.columns],
                    "beams": [member_dict(b) for b in f.beams],
                    "walls": [member_dict(w) for w in f.walls],
                    "braces": [member_dict(b) for b in f.braces],
                }
                for f in self.floors
            ],
        }


# ============================================================================
# EXTRACTOR AGENT
# ============================================================================

class StructuralExtractor:
    """
    Pass 2: Per-plan-page extraction via Vision LLM.
    """
    
    def __init__(self, manifest: BuildingManifest, pdf_path: str | Path):
        self.manifest = manifest
        self.pdf_path = Path(pdf_path)
        self.model = BuildingModel(manifest=manifest)
    
    def extract_all_floors(self) -> BuildingModel:
        """Extract all floor layouts from plan pages."""
        from core.pdf_utils import pdf_to_images_bytes
        
        all_images = pdf_to_images_bytes(str(self.pdf_path), dpi=150)
        
        for level in self.manifest.levels:
            if level.plan_page_index < 0 or level.plan_page_index >= len(all_images):
                print(f"  ⚠ No valid plan page for {level.name}, skipping")
                continue
            
            print(f"\n  Extracting {level.name} (page {level.plan_page_index})...")
            floor = self._extract_one_floor(level, all_images)
            self.model.floors.append(floor)
            
            n_cols = len(floor.columns)
            n_beams = len(floor.beams)
            n_walls = len(floor.walls)
            print(f"    ✓ {n_cols} columns + {n_beams} beams + {n_walls} walls")
        
        return self.model
    
    def _extract_one_floor(self, level: LevelDef, all_images: list[bytes]) -> FloorLayout:
        """Extract structural members from a single plan page."""
        page_img = all_images[level.plan_page_index]
        
        prompt = self._build_extract_prompt(level)
        response = call_llm(prompt, images=[page_img])
        
        return self._parse_floor_response(response, level)
    
    def _build_grid_context(self) -> str:
        """Build grid system description for the prompt."""
        mx = self.manifest.grid_x
        my = self.manifest.grid_y
        
        x_pos_lines = []
        cum = 0.0
        for i, s in enumerate(mx.spacings_mm):
            label = mx.labels[i] if i < len(mx.labels) else str(i+1)
            x_pos_lines.append(f"  Grid {label}: x={cum:.0f}mm")
            cum += s
        
        y_pos_lines = []
        cum = 0.0
        for i, s in enumerate(my.spacings_mm):
            label = my.labels[i] if i < len(my.labels) else chr(65+i)
            y_pos_lines.append(f"  Grid {label}: y={cum:.0f}mm")
            cum += s
        
        x_lines = f"Grid X ({len(mx.labels)} lines): {', '.join(mx.labels)}\nSpacings X: {mx.spacings_mm} mm\nPositions X:\n" + "\n".join(x_pos_lines) if x_pos_lines else "  (none)"
        y_lines = f"Grid Y ({len(my.labels)} lines): {', '.join(my.labels)}\nSpacings Y: {my.spacings_mm} mm\nPositions Y:\n" + "\n".join(y_pos_lines) if y_pos_lines else "  (none)"
        
        return x_lines + "\n\n" + y_lines
    
    def _build_member_db_context(self) -> str:
        """Build member database description."""
        if not self.manifest.member_db:
            return "No member schedule found. Use default sections (columns: 300x300 Concrete, beams: UB305x165x40 Steel)."
        
        lines = []
        for mark, spec in self.manifest.member_db.items():
            lines.append(f"  {mark}: {spec.member_type}, {spec.section_label}, {spec.material}")
        return "Member Database (use these marks/sections when visible on plan):\n" + "\n".join(lines)
    
    def _build_extract_prompt(self, level: LevelDef) -> str:
        grid_ctx = self._build_grid_context()
        member_ctx = self._build_member_db_context()
        
        return f"""You are a STRUCTURAL ENGINEER extracting member positions from a floor plan.

FLOOR: {level.name}
ELEVATION Z: {level.elevation_mm} mm
FLOOR HEIGHT: {level.floor_height_mm} mm

{grid_ctx}

{member_ctx}

## TASK
Analyze this plan page image and extract ALL structural members:

1. **COLUMNS**: At which grid intersections do columns exist? 
   - Grid indices are 0-based (grid_x=0 means first X grid line)
   - Include mark (e.g., C1, C2) if visible near intersection
   - Use member_database section if mark matches

2. **BEAMS**: Which grid edges have beams?
   - Beams run BETWEEN adjacent grid intersections along X or Y direction
   - (grid_x, grid_y) → (grid_x2, grid_y2)
   - Beams are typically on grid lines (either same grid_x or same grid_y)

3. **WALLS**: Any structural walls? Give start/end grid positions and thickness.

## OUTPUT — Return ONLY valid JSON:
```json
{{
  "columns": [
    {{"mark": "C1", "grid_x": 0, "grid_y": 0, "section": "400x400", "confidence": 0.95}}
  ],
  "beams": [
    {{"mark": "B1", "grid_x": 0, "grid_y": 0, "grid_x2": 1, "grid_y2": 0, "section": "UB305x165x40", "confidence": 0.9}}
  ],
  "walls": [
    {{"mark": "W1", "grid_x": 0, "grid_y": 0, "grid_x2": 0, "grid_y2": 1, "thickness_mm": 200}}
  ]
}}
```

RULES:
1. Grid coordinates use 0-based INDEX.
2. Columns exist at grid intersections (grid_x, grid_y).
3. Beams connect adjacent grid intersections along X or Y.
4. Include ALL columns/beams visible on this plan page.
5. Return ONLY the JSON object, no markdown, no extra text."""

    def _parse_floor_response(self, response: str, level: LevelDef) -> FloorLayout:
        """Parse LLM JSON response into FloorLayout."""
        json_str = self._extract_json(response)
        
        floor = FloorLayout(
            level_name=level.name,
            elevation_z_mm=level.elevation_mm,
            floor_height_mm=level.floor_height_mm,
            page_index=level.plan_page_index,
        )
        
        if not json_str:
            print(f"    ⚠ No JSON in response for {level.name}")
            return floor
        
        try:
            data = json.loads(json_str)
        except json.JSONDecodeError:
            print(f"    ⚠ Failed to parse JSON for {level.name}")
            return floor
        
        # Compute grid positions
        x_positions = BuildingManifest._cumulative_positions(self.manifest.grid_x)
        y_positions = BuildingManifest._cumulative_positions(self.manifest.grid_y)
        
        def mm_at(gx: int, gy: int) -> tuple[float, float]:
            x = x_positions[gx] if 0 <= gx < len(x_positions) else gx * 6000.0
            y = y_positions[gy] if 0 <= gy < len(y_positions) else gy * 6000.0
            return x, y
        
        # ── Columns ──
        for c_data in data.get("columns", []):
            gx = c_data.get("grid_x", -1)
            gy = c_data.get("grid_y", -1)
            if gx < 0 or gy < 0:
                continue
            
            x_mm, y_mm = mm_at(gx, gy)
            mark = c_data.get("mark", f"GC_{gx}_{gy}")
            section = c_data.get("section", "")
            
            if mark in self.manifest.member_db:
                ms = self.manifest.member_db[mark]
                section = ms.section_label
                mat = ms.material
                dims = dict(ms.dimensions)
            else:
                mat = "Concrete"
                dims = {}
                if not section:
                    section = "300x300"
            
            floor.columns.append(StructuralMember(
                mark=mark,
                member_type="column",
                grid_x=gx, grid_y=gy,
                x_mm=x_mm, y_mm=y_mm,
                z_start_mm=level.elevation_mm,
                z_end_mm=level.elevation_mm + level.floor_height_mm,
                section_label=section,
                material=mat,
                dimensions=dims,
                confidence=c_data.get("confidence", 0.7),
            ))
        
        # ── Beams ──
        for b_data in data.get("beams", []):
            gx = b_data.get("grid_x", -1)
            gy = b_data.get("grid_y", -1)
            gx2 = b_data.get("grid_x2", -1)
            gy2 = b_data.get("grid_y2", -1)
            if gx < 0 or gy < 0 or gx2 < 0 or gy2 < 0:
                continue
            
            x1, y1 = mm_at(gx, gy)
            x2, y2 = mm_at(gx2, gy2)
            mark = b_data.get("mark", f"GB_{gx}_{gy}_{gx2}_{gy2}")
            section = b_data.get("section", "")
            
            if mark in self.manifest.member_db:
                ms = self.manifest.member_db[mark]
                section = ms.section_label
                mat = ms.material
                dims = dict(ms.dimensions)
            else:
                mat = "Steel"
                dims = {}
                if not section:
                    section = "UB305x165x40"
            
            dx = x2 - x1
            dy = y2 - y1
            length = math.sqrt(dx*dx + dy*dy)
            rotation = math.degrees(math.atan2(dy, dx)) if length > 1 else 0
            
            floor.beams.append(StructuralMember(
                mark=mark,
                member_type="beam",
                grid_x=gx, grid_y=gy,
                x_mm=x1, y_mm=y1,
                x2_mm=x2, y2_mm=y2,
                grid_x2=gx2, grid_y2=gy2,
                z_start_mm=level.elevation_mm + level.floor_height_mm - 400,
                z_end_mm=level.elevation_mm + level.floor_height_mm,
                section_label=section,
                material=mat,
                dimensions=dims,
                rotation_deg=rotation,
                length_mm=length,
                confidence=b_data.get("confidence", 0.7),
            ))
        
        # ── Walls ──
        for w_data in data.get("walls", []):
            gx = w_data.get("grid_x", -1)
            gy = w_data.get("grid_y", -1)
            gx2 = w_data.get("grid_x2", -1)
            gy2 = w_data.get("grid_y2", -1)
            if gx < 0 or gy < 0:
                continue
            
            x1, y1 = mm_at(gx, gy)
            x2 = x_positions[gx2] if 0 <= gx2 < len(x_positions) else x1
            y2 = y_positions[gy2] if 0 <= gy2 < len(y_positions) else y1
            thickness = w_data.get("thickness_mm", 200)
            
            dx = x2 - x1
            dy = y2 - y1
            length = math.sqrt(dx*dx + dy*dy)
            
            floor.walls.append(StructuralMember(
                mark=w_data.get("mark", f"W_{gx}_{gy}"),
                member_type="wall",
                grid_x=gx, grid_y=gy,
                x_mm=x1, y_mm=y1,
                x2_mm=x2, y2_mm=y2,
                grid_x2=gx2 if gx2 >= 0 else gx,
                grid_y2=gy2 if gy2 >= 0 else gy,
                z_start_mm=level.elevation_mm,
                z_end_mm=level.elevation_mm + level.floor_height_mm,
                section_label=f"t={thickness}mm",
                material="Concrete",
                dimensions={"thickness": thickness},
                length_mm=length,
                confidence=w_data.get("confidence", 0.6),
            ))
        
        return floor
    
    @staticmethod
    def _extract_json(text: str) -> str | None:
        """Extract JSON string from LLM response (handles markdown fences)."""
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
            match = re.search(r'\{.*\}', text, re.DOTALL)
            return match.group() if match else None