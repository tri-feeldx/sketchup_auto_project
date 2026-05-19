"""
=============================================================================
PASS 3 — RUBY GENERATOR (Template Engine)
=============================================================================
Generates a complete SketchUp Ruby script (.rb) from BuildingModel JSON.
Pure template-based generation — NO LLM calls.
Handles columns, beams, walls, braces with correct:
  - XYZ coordinates from grid positions
  - Section dimensions from member database
  - Layers, materials, IFC attributes
  - Push-pull extrusion for columns, rotation for beams

INPUT:  BuildingModel (from Pass 2)
OUTPUT: lod300_v3.rb — Ready to run in SketchUp Ruby Console
=============================================================================
"""

import math
from pathlib import Path
from dataclasses import dataclass

from agents.structural_extractor import BuildingModel, FloorLayout, StructuralMember


# ============================================================================
# STEEL SECTION LOOKUP (kept from original system)
# ============================================================================

STEEL_SECTIONS = {
    # UB Sections (Universal Beams)
    "UB152x152x23":  {"depth": 152.4, "width": 152.2, "flange": 6.8, "web": 5.8},
    "UB152x152x30":  {"depth": 157.6, "width": 152.9, "flange": 9.4, "web": 6.5},
    "UB178x102x19":  {"depth": 177.8, "width": 101.2, "flange": 7.9, "web": 4.8},
    "UB203x102x23":  {"depth": 203.2, "width": 101.8, "flange": 9.3, "web": 5.4},
    "UB203x133x25":  {"depth": 203.2, "width": 133.2, "flange": 7.8, "web": 5.7},
    "UB203x133x30":  {"depth": 206.8, "width": 133.9, "flange": 9.6, "web": 6.4},
    "UB254x102x22":  {"depth": 254.0, "width": 101.6, "flange": 8.0, "web": 5.7},
    "UB254x102x25":  {"depth": 257.2, "width": 101.9, "flange": 8.4, "web": 6.0},
    "UB254x102x28":  {"depth": 260.4, "width": 102.2, "flange": 10.0, "web": 6.3},
    "UB254x146x31":  {"depth": 251.4, "width": 146.1, "flange": 8.6, "web": 6.0},
    "UB254x146x37":  {"depth": 256.0, "width": 146.4, "flange": 10.9, "web": 6.3},
    "UB254x146x43":  {"depth": 259.6, "width": 147.3, "flange": 12.7, "web": 7.2},
    "UB305x102x25":  {"depth": 305.1, "width": 101.6, "flange": 8.0, "web": 5.8},
    "UB305x102x28":  {"depth": 308.7, "width": 101.8, "flange": 8.8, "web": 6.0},
    "UB305x102x33":  {"depth": 312.7, "width": 102.4, "flange": 10.8, "web": 6.6},
    "UB305x127x37":  {"depth": 304.4, "width": 123.4, "flange": 10.7, "web": 7.1},
    "UB305x127x42":  {"depth": 307.2, "width": 124.3, "flange": 12.1, "web": 8.0},
    "UB305x127x48":  {"depth": 311.0, "width": 125.3, "flange": 14.0, "web": 9.0},
    "UB305x165x40":  {"depth": 303.4, "width": 165.0, "flange": 10.2, "web": 6.0},
    "UB305x165x46":  {"depth": 306.6, "width": 165.7, "flange": 11.8, "web": 6.7},
    "UB305x165x54":  {"depth": 310.4, "width": 166.9, "flange": 13.7, "web": 7.9},
    "UB356x127x33":  {"depth": 349.0, "width": 125.4, "flange": 8.5, "web": 6.0},
    "UB356x127x39":  {"depth": 353.4, "width": 126.0, "flange": 10.7, "web": 6.6},
    "UB356x171x45":  {"depth": 351.4, "width": 171.1, "flange": 9.7, "web": 7.0},
    "UB356x171x51":  {"depth": 355.0, "width": 171.5, "flange": 11.5, "web": 7.4},
    "UB356x171x57":  {"depth": 358.0, "width": 172.2, "flange": 13.0, "web": 8.1},
    "UB406x140x39":  {"depth": 398.0, "width": 141.8, "flange": 8.6, "web": 6.4},
    "UB406x140x46":  {"depth": 403.2, "width": 142.2, "flange": 11.2, "web": 6.8},
    "UB406x178x54":  {"depth": 402.6, "width": 177.7, "flange": 10.9, "web": 7.7},
    "UB406x178x60":  {"depth": 406.4, "width": 177.9, "flange": 12.8, "web": 7.9},
    "UB406x178x67":  {"depth": 409.4, "width": 178.8, "flange": 14.3, "web": 8.8},
    "UB457x152x52":  {"depth": 449.8, "width": 152.4, "flange": 10.9, "web": 7.6},
    "UB457x152x60":  {"depth": 454.6, "width": 152.9, "flange": 13.3, "web": 8.1},
    "UB457x152x67":  {"depth": 458.0, "width": 153.8, "flange": 15.0, "web": 9.0},
    "UB457x152x74":  {"depth": 462.0, "width": 154.4, "flange": 17.0, "web": 9.6},
    "UB457x191x67":  {"depth": 453.4, "width": 189.9, "flange": 12.7, "web": 8.5},
    "UB457x191x74":  {"depth": 457.0, "width": 190.4, "flange": 14.5, "web": 9.0},
    "UB457x191x82":  {"depth": 460.0, "width": 191.3, "flange": 16.0, "web": 9.9},
    "UB533x210x82":  {"depth": 528.3, "width": 208.8, "flange": 13.2, "web": 9.6},
    "UB533x210x92":  {"depth": 533.1, "width": 209.3, "flange": 15.6, "web": 10.1},
    "UB533x210x101": {"depth": 536.7, "width": 210.0, "flange": 17.4, "web": 10.8},
    "UB610x229x101": {"depth": 602.6, "width": 227.6, "flange": 14.8, "web": 10.5},
    "UB610x229x113": {"depth": 607.6, "width": 228.2, "flange": 17.3, "web": 11.1},
    "UB610x229x125": {"depth": 612.2, "width": 229.0, "flange": 19.6, "web": 11.9},
    "UB610x229x140": {"depth": 617.2, "width": 230.2, "flange": 22.1, "web": 13.1},
    "UB686x254x125": {"depth": 677.9, "width": 253.0, "flange": 16.2, "web": 11.7},
    "UB686x254x140": {"depth": 683.5, "width": 253.7, "flange": 19.0, "web": 12.4},
    "UB686x254x152": {"depth": 687.5, "width": 254.5, "flange": 21.0, "web": 13.2},
    "UB686x254x170": {"depth": 692.9, "width": 255.8, "flange": 23.7, "web": 14.3},
    # UC Sections (Universal Columns)
    "UC152x152x23":  {"depth": 152.4, "width": 152.2, "flange": 6.8, "web": 5.8},
    "UC152x152x30":  {"depth": 157.6, "width": 152.9, "flange": 9.4, "web": 6.5},
    "UC152x152x37":  {"depth": 161.8, "width": 154.4, "flange": 11.5, "web": 8.0},
    "UC203x203x46":  {"depth": 203.2, "width": 203.6, "flange": 11.0, "web": 7.2},
    "UC203x203x52":  {"depth": 206.2, "width": 204.3, "flange": 12.5, "web": 7.9},
    "UC203x203x60":  {"depth": 209.6, "width": 205.2, "flange": 14.2, "web": 9.4},
    "UC203x203x71":  {"depth": 215.8, "width": 206.4, "flange": 17.3, "web": 10.0},
    "UC254x254x73":  {"depth": 254.1, "width": 254.6, "flange": 14.2, "web": 8.6},
    "UC254x254x89":  {"depth": 260.3, "width": 256.3, "flange": 17.3, "web": 10.3},
    "UC254x254x107": {"depth": 266.7, "width": 258.8, "flange": 20.5, "web": 12.8},
    "UC305x305x97":  {"depth": 307.9, "width": 305.3, "flange": 15.4, "web": 9.9},
    "UC305x305x118": {"depth": 314.5, "width": 307.4, "flange": 18.7, "web": 12.0},
    "UC305x305x137": {"depth": 320.5, "width": 309.2, "flange": 21.7, "web": 13.8},
    "UC305x305x158": {"depth": 327.1, "width": 311.2, "flange": 25.0, "web": 15.8},
    "UC356x368x129": {"depth": 355.6, "width": 368.6, "flange": 17.5, "web": 10.4},
    "UC356x368x153": {"depth": 362.0, "width": 370.5, "flange": 20.7, "web": 12.3},
    "UC356x368x177": {"depth": 368.2, "width": 372.6, "flange": 23.8, "web": 14.4},
    "UC356x368x202": {"depth": 374.6, "width": 374.7, "flange": 27.0, "web": 16.5},
}


# ============================================================================
# RUBY CODE GENERATOR
# ============================================================================

class RubyGeneratorV3:
    """
    Generate SketchUp Ruby script from BuildingModel.
    Pure template-based — zero LLM.
    """
    
    def __init__(self, model: BuildingModel):
        self.model = model
        self.lines: list[str] = []
        self.indent = 0
    
    def generate(self) -> str:
        """Generate complete Ruby script."""
        self.lines = []
        
        self._emit_header()
        self._emit_setup()
        self._emit_layers()
        self._emit_materials()
        self._emit_helpers()
        
        for floor in self.model.floors:
            self._emit_floor_section(floor)
        
        self._emit_footer()
        
        return "\n".join(self.lines)
    
    def save(self, path: str | Path) -> Path:
        """Generate and save to file."""
        path = Path(path)
        code = self.generate()
        path.write_text(code, encoding="utf-8")
        print(f"  ✓ Ruby script saved: {path} ({len(code):,} bytes)")
        return path
    
    # ── Emitters ──
    
    def _emit(self, line: str = ""):
        prefix = "  " * self.indent
        self.lines.append(prefix + line if line else "")
    
    def _emit_header(self):
        m = self.model.manifest
        self._emit("# " + "=" * 75)
        self._emit(f"# LOD 300 Structural Model — {m.building_name}")
        self._emit(f"# Generated by SketchUp Auto Pipeline V3 (Vision LLM)")
        self._emit(f"# Building: {m.building_type} | {m.num_floors} floors | {m.total_height_mm/1000:.1f}m total height")
        self._emit(f"# Grid: {len(m.grid_x.labels)}x{len(m.grid_y.labels)} | Scale: {m.scale_x_mm_per_px:.2f} mm/px")
        self._emit(f"# Member DB: {len(m.member_db)} entries from schedule")
        self._emit("# " + "=" * 75)
        self._emit()
    
    def _emit_setup(self):
        m = self.model.manifest
        self._emit("model  = Sketchup.active_model")
        self._emit(f"model.name        = \"{m.building_name or 'LOD300 Structural Model'}\"")
        self._emit(f"model.description = \"{m.building_type} | {m.num_floors} floors | Vision LLM V3\"")
        self._emit("ents   = model.active_entities")
        self._emit("layers = model.layers")
        self._emit("model.start_operation('LOD300 V3 Import', true)")
        self._emit()
    
    def _emit_layers(self):
        self._emit("# ── Layers ──")
        layers = [
            "STR-Columns", "STR-Beams", "STR-Braces", "STR-Walls", 
            "STR-Slabs", "STR-Foundations", "STR-Connections",
            "LOD300_UNMAPPED_NEEDS_REVIEW"
        ]
        self._emit("[")
        for name in layers:
            self._emit(f'  "{name}",')
        self._emit("].each do |lname|")
        self._emit("  layers[lname] || layers.add(lname)")
        self._emit("end")
        self._emit()
    
    def _emit_materials(self):
        self._emit("# ── Materials ──")
        self._emit("_mats = model.materials")
        self._emit()
        # Steel
        self._emit("_steel_mat = _mats[\"Structural_Steel\"] || _mats.add(\"Structural_Steel\")")
        self._emit("_steel_mat.color = Sketchup::Color.new(160, 160, 175)")
        self._emit()
        # Concrete
        self._emit("_concrete_mat = _mats[\"Concrete\"] || _mats.add(\"Concrete\")")
        self._emit("_concrete_mat.color = Sketchup::Color.new(180, 175, 165)")
        self._emit()
        # Composite
        self._emit("_composite_mat = _mats[\"Composite\"] || _mats.add(\"Composite\")")
        self._emit("_composite_mat.color = Sketchup::Color.new(200, 190, 140)")
        self._emit()
    
    def _emit_helpers(self):
        self._emit("# ── Helper: get material by name ──")
        self._emit("def _mat_for(material_name)")
        self._emit("  case material_name.downcase")
        self._emit("  when \"steel\" then _steel_mat")
        self._emit("  when \"concrete\" then _concrete_mat")
        self._emit("  when \"composite\" then _composite_mat")
        self._emit("  else _steel_mat")
        self._emit("  end")
        self._emit("end")
        self._emit()
        self._emit("# ── Helper: IFC attributes ──")
        self._emit("def _set_ifc(grp, mark, section, mtype)")
        self._emit("  grp.set_attribute(\"IFC\", \"Mark\",    mark)")
        self._emit("  grp.set_attribute(\"IFC\", \"Section\", section)")
        self._emit("  grp.set_attribute(\"IFC\", \"Type\",    mtype)")
        self._emit("  grp.name = mark")
        self._emit("end")
        self._emit()
    
    def _emit_floor_section(self, floor: FloorLayout):
        z_start = floor.elevation_z_mm
        z_end = floor.elevation_z_mm + floor.floor_height_mm
        
        self._emit(f"# {'=' * 72}")
        self._emit(f"# FLOOR: {floor.level_name} (Z: {z_start:.0f} → {z_end:.0f} mm)")
        self._emit(f"# {'=' * 72}")
        self._emit()
        
        # Columns first
        if floor.columns:
            self._emit(f"# ── Columns ({len(floor.columns)} members) ──")
            self._emit()
            for col in floor.columns:
                self._emit_column(col)
        
        # Beams
        if floor.beams:
            self._emit(f"# ── Beams ({len(floor.beams)} members) ──")
            self._emit()
            for beam in floor.beams:
                self._emit_beam(beam)
        
        # Walls
        if floor.walls:
            self._emit(f"# ── Walls ({len(floor.walls)} members) ──")
            self._emit()
            for wall in floor.walls:
                self._emit_wall(wall)
        
        # Braces
        if floor.braces:
            self._emit(f"# ── Braces ({len(floor.braces)} members) ──")
            self._emit()
            for brace in floor.braces:
                self._emit_brace(brace)
        
        self._emit()
    
    def _emit_column(self, col: StructuralMember):
        mark = col.mark
        section = col.section_label
        mat_name = col.material or "Steel"
        z_start = col.z_start_mm
        z_end = col.z_end_mm
        x, y = col.x_mm, col.y_mm
        
        # Parse section dimensions
        bw, bd = self._parse_rect_section(section)
        
        self._emit(f"# ---- {mark} | {section} | column | {col.confidence:.0%} ----")
        self._emit("begin")
        self._emit(f"  _sp  = Geom::Point3d.new({x:.1f}.mm, {y:.1f}.mm, {z_start:.1f}.mm)")
        self._emit(f"  _ep  = Geom::Point3d.new({x:.1f}.mm, {y:.1f}.mm, {z_end:.1f}.mm)")
        self._emit("  _vec = _sp.vector_to(_ep)")
        self._emit("  _len = _sp.distance(_ep)")
        self._emit("  if _len < 1.mm || !_vec.valid?")
        self._emit(f'    puts "SKIP {mark}: zero-length (check coords)"')
        self._emit("  else")
        self._emit("    _grp = ents.add_group")
        self._emit("    _ge  = _grp.entities")
        self._emit("    _t   = Geom::Transformation.new(_sp, _vec)")
        hw = bw / 2.0
        hd = bd / 2.0
        self._emit(f"    _raw = [[{-hw:.1f}, {-hd:.1f}], [{hw:.1f}, {-hd:.1f}],")
        self._emit(f"            [{hw:.1f}, {hd:.1f}], [{-hw:.1f}, {hd:.1f}]]")
        self._emit("    _face = _ge.add_face(_raw.map { |p| _t * Geom::Point3d.new(p[0].mm, p[1].mm, 0) })")
        self._emit("    _face.pushpull(_len) if _face")
        self._emit(f"    _grp.layer = layers[\"STR-Columns\"] || layers.add(\"STR-Columns\")")
        self._emit(f"    _grp.material = _mat_for(\"{mat_name}\")")
        self._emit(f'    _set_ifc(_grp, "{mark}", "{section}", "column")')
        self._emit("  end")
        self._emit("rescue => e")
        self._emit(f'  puts "SKIP {mark}: #{{e.message}}"')
        self._emit("end")
        self._emit()
    
    def _emit_beam(self, beam: StructuralMember):
        mark = beam.mark
        section = beam.section_label
        mat_name = beam.material or "Steel"
        x1, y1 = beam.x_mm, beam.y_mm
        x2, y2 = beam.x2_mm, beam.y2_mm
        z_bot = beam.z_start_mm
        z_top = beam.z_end_mm
        rotation = beam.rotation_deg
        
        # Parse section
        bw, bd = self._parse_rect_section(section)
        # For beams, depth is the vertical dimension
        beam_depth = max(bw, bd)
        beam_width = min(bw, bd)
        
        self._emit(f"# ---- {mark} | {section} | beam | {beam.length_mm:.0f}mm | {beam.confidence:.0%} ----")
        self._emit("begin")
        self._emit(f"  _sp  = Geom::Point3d.new({x1:.1f}.mm, {y1:.1f}.mm, {z_bot:.1f}.mm)")
        self._emit(f"  _ep  = Geom::Point3d.new({x2:.1f}.mm, {y2:.1f}.mm, {z_bot:.1f}.mm)")
        self._emit("  _vec = _sp.vector_to(_ep)")
        self._emit("  _len = _sp.distance(_ep)")
        self._emit("  if _len < 1.mm || !_vec.valid?")
        self._emit(f'    puts "SKIP {mark}: zero-length"')
        self._emit("  else")
        self._emit("    _grp = ents.add_group")
        self._emit("    _ge  = _grp.entities")
        self._emit("    _t   = Geom::Transformation.new(_sp, _vec)")
        hw = beam_width / 2.0
        hd = beam_depth / 2.0
        self._emit(f"    _raw = [[{-hw:.1f}, {-hd:.1f}], [{hw:.1f}, {-hd:.1f}],")
        self._emit(f"            [{hw:.1f}, {hd:.1f}], [{-hw:.1f}, {hd:.1f}]]")
        self._emit("    _face = _ge.add_face(_raw.map { |p| _t * Geom::Point3d.new(p[0].mm, p[1].mm, 0) })")
        self._emit("    _face.pushpull(_len) if _face")
        # Beam group rotation
        self._emit(f"    _grp.layer = layers[\"STR-Beams\"] || layers.add(\"STR-Beams\")")
        self._emit(f"    _grp.material = _mat_for(\"{mat_name}\")")
        self._emit(f'    _set_ifc(_grp, "{mark}", "{section}", "beam")')
        self._emit("  end")
        self._emit("rescue => e")
        self._emit(f'  puts "SKIP {mark}: #{{e.message}}"')
        self._emit("end")
        self._emit()
    
    def _emit_wall(self, wall: StructuralMember):
        mark = wall.mark
        thickness = wall.dimensions.get("thickness", 200)
        mat_name = wall.material or "Concrete"
        x1, y1 = wall.x_mm, wall.y_mm
        x2, y2 = wall.x2_mm, wall.y2_mm
        z_start = wall.z_start_mm
        z_end = wall.z_end_mm
        length = wall.length_mm or 1000
        
        self._emit(f"# ---- {mark} | wall | t={thickness}mm | L={length:.0f}mm ----")
        self._emit("begin")
        self._emit(f"  _sp  = Geom::Point3d.new({x1:.1f}.mm, {y1:.1f}.mm, {z_start:.1f}.mm)")
        self._emit(f"  _ep  = Geom::Point3d.new({x2:.1f}.mm, {y2:.1f}.mm, {z_start:.1f}.mm)")
        self._emit(f"  _ep2 = Geom::Point3d.new({x2:.1f}.mm, {y2:.1f}.mm, {z_end:.1f}.mm)")
        self._emit("  _vec_span = _sp.vector_to(_ep)")
        self._emit("  _vec_h = Geom::Vector3d.new(0, 0, _ep2.z - _sp.z)")
        self._emit("  _len = _sp.distance(_ep)")
        self._emit("  if _len < 1.mm || !_vec_span.valid?")
        self._emit(f'    puts "SKIP {mark}: zero-length"')
        self._emit("  else")
        self._emit("    _grp = ents.add_group")
        self._emit("    _ge  = _grp.entities")
        self._emit("    _t   = Geom::Transformation.new(_sp, _vec_span)")
        ht = thickness / 2.0
        self._emit(f"    _raw = [[{-ht:.1f}, {-len/2:.1f}], [{ht:.1f}, {-len/2:.1f}],")
        self._emit(f"            [{ht:.1f}, {len/2:.1f}], [{-ht:.1f}, {len/2:.1f}]]")
        self._emit("    _face = _ge.add_face(_raw.map { |p| _t * Geom::Point3d.new(p[0].mm, p[1].mm, 0) })")
        self._emit(f"    _face.pushpull({z_end - z_start:.1f}.mm) if _face")
        self._emit(f"    _grp.layer = layers[\"STR-Walls\"] || layers.add(\"STR-Walls\")")
        self._emit(f"    _grp.material = _mat_for(\"{mat_name}\")")
        self._emit(f'    _set_ifc(_grp, "{mark}", "t={thickness}", "wall")')
        self._emit("  end")
        self._emit("rescue => e")
        self._emit(f'  puts "SKIP {mark}: #{{e.message}}"')
        self._emit("end")
        self._emit()
    
    def _emit_brace(self, brace: StructuralMember):
        # Braces are diagonal members — similar to beams
        self._emit_beam(brace)
    
    def _emit_footer(self):
        self._emit("# ── Finalize ──")
        self._emit("model.commit_operation")
        self._emit('puts "LOD300 V3 Model import complete."')
        self._emit()
        # Print summary
        total_cols = sum(len(f.columns) for f in self.model.floors)
        total_beams = sum(len(f.beams) for f in self.model.floors)
        total_walls = sum(len(f.walls) for f in self.model.floors)
        self._emit(f'puts "  Floors: {len(self.model.floors)}"')
        self._emit(f'puts "  Columns: {total_cols}"')
        self._emit(f'puts "  Beams: {total_beams}"')
        self._emit(f'puts "  Walls: {total_walls}"')
        self._emit(f'puts "  Total members: {total_cols + total_beams + total_walls}"')
    
    # ── Section Parsing ──
    
    def _parse_rect_section(self, section_label: str) -> tuple[float, float]:
        """Parse section label → (width, depth) in mm.
        Handles:
          - "400x400" → (400, 400)
          - "300x600" → (300, 600) 
          - "UB305x165x40" → lookup table
          - "UC203x203x46" → lookup table
          - "H300x300x10x15" → (300, 300)
        """
        # Try steel lookup first
        if section_label in STEEL_SECTIONS:
            s = STEEL_SECTIONS[section_label]
            return s["width"], s["depth"]
        
        # Try rectangular pattern "WxH" or "WxHx..."
        import re
        m = re.match(r'(\d+)\s*x\s*(\d+)', section_label)
        if m:
            w = float(m.group(1))
            h = float(m.group(2))
            return w, h
        
        # Try "t=XXX" (wall thickness)
        m = re.match(r't\s*=\s*(\d+)', section_label)
        if m:
            t = float(m.group(1))
            return t, t
        
        # Default
        return 300.0, 300.0


# ============================================================================
# CONVENIENCE
# ============================================================================

def generate_ruby(model: BuildingModel, output_path: str | Path = None) -> str:
    """Generate Ruby script from BuildingModel."""
    gen = RubyGeneratorV3(model)
    code = gen.generate()
    if output_path:
        gen.save(output_path)
    return code