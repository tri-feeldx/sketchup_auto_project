"""
=============================================================================
PHASE 3 — RUBY GENERATOR V4 (Template Engine)
=============================================================================
Generates complete SketchUp Ruby .rb script from model dict + manifest.
Handles:
  - Structural: columns, beams, walls, braces  (grid-based)
  - Architectural: doors, windows, stairs, slabs, roof  (NEW)
  - Layers, materials, IFC attributes
  - Group-based construction with push-pull extrusion

INPUT:  model dict (from extractor_v4) + manifest dict (from scanner_v4)
OUTPUT: .rb string ready for SketchUp Ruby Console
=============================================================================
"""

import math
import re
from pathlib import Path

# Import steel section DB from V3
from agents.ruby_generator_v3 import STEEL_SECTIONS


class RubyGeneratorV4:
    """Generate SketchUp Ruby script from V4 model dict."""

    def __init__(self, model: dict, manifest: dict):
        self.model = model
        self.manifest = manifest
        self.lines: list[str] = []
        self.indent = 0

    # ── PUBLIC ─────────────────────────────────────────────────

    def generate(self) -> str:
        """Generate complete Ruby script."""
        self.lines = []
        self._emit_header()
        self._emit_setup()
        self._emit_layers()
        self._emit_materials()
        self._emit_helpers()

        for floor in self.model.get("floors", []):
            self._emit_floor(floor)

        self._emit_roof()
        self._emit_footer()
        return "\n".join(self.lines)

    def save(self, path: str | Path) -> Path:
        """Generate and save to file."""
        path = Path(path)
        code = self.generate()
        path.write_text(code, encoding="utf-8")
        print(f"  [OK] Ruby V4 script saved: {path} ({len(code):,} bytes)")
        return path

    # ── LOW-LEVEL ─────────────────────────────────────────────

    def _emit(self, line: str = ""):
        prefix = "  " * self.indent
        self.lines.append(prefix + line if line else "")

    # ── HEADER ────────────────────────────────────────────────

    def _emit_header(self):
        m = self.manifest
        name = m.get("building_name", "LOD300 Model")
        btype = m.get("building_type", "unknown")
        nf = m.get("num_floors", 1)
        h = m.get("total_height_mm", 3500)
        self._emit("# " + "=" * 75)
        self._emit(f"# LOD 300 Structural Model — {name}")
        self._emit(f"# Pipeline V4 (Vision LLM + Gridless)")
        self._emit(f"# Building: {btype} | {nf} floors | {h/1000:.1f}m total height")
        self._emit("# " + "=" * 75)
        self._emit()

    def _emit_setup(self):
        m = self.manifest
        name = m.get("building_name", "LOD300 Model")
        btype = m.get("building_type", "unknown")
        nf = m.get("num_floors", 1)
        self._emit("model  = Sketchup.active_model")
        self._emit(f'model.name        = "{name}"')
        self._emit(f'model.description = "{btype} | {nf} floors | V4 Pipeline"')
        self._emit("ents   = model.active_entities")
        self._emit("layers = model.layers")
        self._emit("model.start_operation('LOD300 V4 Import', true)")
        self._emit()

    # ── LAYERS ─────────────────────────────────────────────────

    def _emit_layers(self):
        self._emit("# ── Layers ──")
        layers = [
            "STR-Columns", "STR-Beams", "STR-Braces", "STR-Walls",
            "STR-Slabs", "ARCH-Doors", "ARCH-Windows", "ARCH-Stairs",
            "ARCH-Roof", "LOD300_REVIEW"
        ]
        self._emit("[")
        for name in layers:
            self._emit(f'  "{name}",')
        self._emit("].each do |lname|")
        self._emit("  layers[lname] || layers.add(lname)")
        self._emit("end")
        self._emit()

    # ── MATERIALS ──────────────────────────────────────────────

    def _emit_materials(self):
        self._emit("# ── Materials ──")
        self._emit("_mats = model.materials")
        self._emit()
        mats = {
            "_steel_mat": ("Structural_Steel", (160, 160, 175)),
            "_concrete_mat": ("Concrete", (180, 175, 165)),
            "_glass_mat": ("Glass", (180, 220, 240, 140)),
            "_wood_mat": ("Wood", (160, 120, 70)),
        }
        for var, (name, color) in mats.items():
            r, g, b = color[0], color[1], color[2]
            a = color[3] if len(color) == 4 else 255
            self._emit(f'{var} = _mats["{name}"] || _mats.add("{name}")')
            self._emit(f'{var}.color = Sketchup::Color.new({r}, {g}, {b}, {a})')
            self._emit()

    # ── HELPERS ────────────────────────────────────────────────

    def _emit_helpers(self):
        self._emit("# ── Material lookup ──")
        self._emit("def _mat_for(mname)")
        self._emit("  case mname.downcase")
        self._emit('  when "steel" then _steel_mat')
        self._emit('  when "concrete", "rc" then _concrete_mat')
        self._emit('  when "glass", "window" then _glass_mat')
        self._emit('  when "wood", "timber" then _wood_mat')
        self._emit("  else _steel_mat")
        self._emit("  end")
        self._emit("end")
        self._emit()
        self._emit("# ── IFC attributes ──")
        self._emit("def _set_ifc(grp, mark, section, mtype)")
        self._emit('  grp.set_attribute("IFC", "Mark",    mark)')
        self._emit('  grp.set_attribute("IFC", "Section", section)')
        self._emit('  grp.set_attribute("IFC", "Type",    mtype)')
        self._emit("  grp.name = mark")
        self._emit("end")
        self._emit()
        self._emit("# ── Create rectangle at transform ──")
        self._emit("def _add_rect(_ge, _t, hw, hd)")
        self._emit("  _raw = [[-hw, -hd], [hw, -hd], [hw, hd], [-hw, hd]]")
        self._emit("  _face = _ge.add_face(_raw.map { |p| _t * Geom::Point3d.new(p[0].mm, p[1].mm, 0) })")
        self._emit("  _face")
        self._emit("end")
        self._emit()

    # ── FLOOR ──────────────────────────────────────────────────

    def _emit_floor(self, floor: dict):
        name = floor.get("level_name", "Level")
        z_start = floor.get("elevation_z_mm", 0)
        z_end = z_start + floor.get("floor_height_mm", 3500)

        self._emit(f"# {'=' * 70}")
        self._emit(f"# FLOOR: {name}  (Z: {z_start:.0f} -> {z_end:.0f} mm)")
        self._emit(f"# {'=' * 70}")
        self._emit()

        # ── SLAB ──
        self._emit(f"# ── Slab ──")
        slabs = floor.get("arch_slabs", []) or floor.get("slabs", [])
        for sl in slabs:
            self._emit_slab(sl, z_start, name)

        # ── COLUMNS ──
        cols = floor.get("columns", [])
        if cols:
            self._emit(f"# ── Columns ({len(cols)}) ──")
            for c in cols:
                self._emit_member(c, "column", "STR-Columns")
            self._emit()

        # ── BEAMS ──
        beams = floor.get("beams", [])
        if beams:
            self._emit(f"# ── Beams ({len(beams)}) ──")
            for b in beams:
                self._emit_member(b, "beam", "STR-Beams")
            self._emit()

        # ── WALLS ──
        walls = floor.get("walls", [])
        if walls:
            self._emit(f"# ── Walls ({len(walls)}) ──")
            for w in walls:
                self._emit_member(w, "wall", "STR-Walls")
            self._emit()

        # ── BRACES ──
        braces = floor.get("braces", [])
        if braces:
            self._emit(f"# ── Braces ({len(braces)}) ──")
            for br in braces:
                self._emit_member(br, "brace", "STR-Braces")
            self._emit()

        # ── ARCHITECTURAL DOORS ──
        doors = floor.get("arch_doors", [])
        if doors:
            self._emit(f"# ── Doors ({len(doors)}) ──")
            for d in doors:
                self._emit_door(d, z_start)
            self._emit()

        # ── ARCHITECTURAL WINDOWS ──
        windows = floor.get("arch_windows", [])
        if windows:
            self._emit(f"# ── Windows ({len(windows)}) ──")
            for w in windows:
                self._emit_window(w, z_start)
            self._emit()

        # ── STAIRS ──
        stairs = floor.get("arch_stairs", [])
        if stairs:
            self._emit(f"# ── Stairs ({len(stairs)}) ──")
            for st in stairs:
                self._emit_stair(st, z_start)
            self._emit()

        self._emit()

    # ── STRUCTURAL MEMBER EMITTER ──────────────────────────────

    def _emit_member(self, m: dict, mtype: str, layer: str):
        mark = m.get("mark", f"{mtype[:3].upper()}")
        section = m.get("section_label", "400x400")
        mat = m.get("material", "Steel")
        conf = m.get("confidence", 0.5)

        if mtype == "column":
            x, y = m.get("x_mm", 0), m.get("y_mm", 0)
            z1, z2 = m.get("z_start_mm", 0), m.get("z_end_mm", 3500)
            bw, bd = self._section_dims(section)
            self._emit(f"# {mark} | {section} | col | conf={conf:.0%}")
            self._emit("begin")
            self._emit(f"  _sp  = Geom::Point3d.new({x:.1f}.mm, {y:.1f}.mm, {z1:.1f}.mm)")
            self._emit(f"  _ep  = Geom::Point3d.new({x:.1f}.mm, {y:.1f}.mm, {z2:.1f}.mm)")
            self._emit("  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)")
            self._emit("  if _len < 1.mm || !_vec.valid?")
            self._emit(f'    puts "SKIP {mark}: zero-length"')
            self._emit("  else")
            self._emit("    _grp = ents.add_group; _ge  = _grp.entities")
            self._emit("    _t   = Geom::Transformation.new(_sp, _vec)")
            self._emit(f"    _face = _add_rect(_ge, _t, {bw/2:.1f}, {bd/2:.1f})")
            self._emit("    _face.pushpull(_len) if _face")
            self._emit(f'    _grp.layer = layers["{layer}"]')
            self._emit(f'    _grp.material = _mat_for("{mat}")')
            self._emit(f'    _set_ifc(_grp, "{mark}", "{section}", "column")')
            self._emit("  end")
            self._emit("rescue => e")
            self._emit(f'  puts "SKIP {mark}: #{{e.message}}"')
            self._emit("end")
            self._emit()

        elif mtype == "beam":
            x1, y1 = m.get("x_mm", 0), m.get("y_mm", 0)
            x2, y2 = m.get("x2_mm", 3000), m.get("y2_mm", 0)
            z_bot = m.get("z_start_mm", 3100)
            bw, bd = self._section_dims(section)
            beam_w = min(bw, bd)
            beam_d = max(bw, bd)
            self._emit(f"# {mark} | {section} | beam | conf={conf:.0%}")
            self._emit("begin")
            self._emit(f"  _sp  = Geom::Point3d.new({x1:.1f}.mm, {y1:.1f}.mm, {z_bot:.1f}.mm)")
            self._emit(f"  _ep  = Geom::Point3d.new({x2:.1f}.mm, {y2:.1f}.mm, {z_bot:.1f}.mm)")
            self._emit("  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)")
            self._emit("  if _len < 1.mm || !_vec.valid?")
            self._emit(f'    puts "SKIP {mark}: zero-length"')
            self._emit("  else")
            self._emit("    _grp = ents.add_group; _ge  = _grp.entities")
            self._emit("    _t   = Geom::Transformation.new(_sp, _vec)")
            self._emit(f"    _face = _add_rect(_ge, _t, {beam_w/2:.1f}, {beam_d/2:.1f})")
            self._emit("    _face.pushpull(_len) if _face")
            self._emit(f'    _grp.layer = layers["{layer}"]')
            self._emit(f'    _grp.material = _mat_for("{mat}")')
            self._emit(f'    _set_ifc(_grp, "{mark}", "{section}", "beam")')
            self._emit("  end")
            self._emit("rescue => e")
            self._emit(f'  puts "SKIP {mark}: #{{e.message}}"')
            self._emit("end")
            self._emit()

        elif mtype == "wall":
            x1, y1 = m.get("x_mm", 0), m.get("y_mm", 0)
            x2, y2 = m.get("x2_mm", 0), m.get("y2_mm", 3000)
            z1, z2 = m.get("z_start_mm", 0), m.get("z_end_mm", 3500)
            t = m.get("dimensions", {}).get("thickness", 200)
            l_mm = math.hypot(x2 - x1, y2 - y1)
            self._emit(f"# {mark} | wall | t={t}mm | conf={conf:.0%}")
            self._emit("begin")
            self._emit(f"  _sp  = Geom::Point3d.new({x1:.1f}.mm, {y1:.1f}.mm, {z1:.1f}.mm)")
            self._emit(f"  _ep  = Geom::Point3d.new({x2:.1f}.mm, {y2:.1f}.mm, {z1:.1f}.mm)")
            self._emit("  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)")
            self._emit("  if _len < 1.mm || !_vec.valid?")
            self._emit(f'    puts "SKIP {mark}: zero-length"')
            self._emit("  else")
            self._emit("    _grp = ents.add_group; _ge  = _grp.entities")
            self._emit("    _t   = Geom::Transformation.new(_sp, _vec)")
            self._emit(f"    _face = _add_rect(_ge, _t, {t/2:.1f}, {l_mm/2:.1f})")
            self._emit(f"    _face.pushpull({z2 - z1:.1f}.mm) if _face")
            self._emit(f'    _grp.layer = layers["{layer}"]')
            self._emit(f'    _grp.material = _mat_for("{mat}")')
            self._emit(f'    _set_ifc(_grp, "{mark}", "t={t}", "wall")')
            self._emit("  end")
            self._emit("rescue => e")
            self._emit(f'  puts "SKIP {mark}: #{{e.message}}"')
            self._emit("end")
            self._emit()

        elif mtype == "brace":
            # Braces are diagonal beams
            x1, y1 = m.get("x_mm", 0), m.get("y_mm", 0)
            x2, y2 = m.get("x2_mm", 3000), m.get("y2_mm", 3000)
            z1, z2 = m.get("z_start_mm", 0), m.get("z_end_mm", 3500)
            bw, bd = self._section_dims(section)
            beam_w = min(bw, bd)
            beam_d = max(bw, bd)
            self._emit(f"# {mark} | {section} | brace | conf={conf:.0%}")
            self._emit("begin")
            self._emit(f"  _sp  = Geom::Point3d.new({x1:.1f}.mm, {y1:.1f}.mm, {z1:.1f}.mm)")
            self._emit(f"  _ep  = Geom::Point3d.new({x2:.1f}.mm, {y2:.1f}.mm, {z2:.1f}.mm)")
            self._emit("  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)")
            self._emit("  if _len < 1.mm || !_vec.valid?")
            self._emit(f'    puts "SKIP {mark}: zero-length"')
            self._emit("  else")
            self._emit("    _grp = ents.add_group; _ge  = _grp.entities")
            self._emit("    _t   = Geom::Transformation.new(_sp, _vec)")
            self._emit(f"    _face = _add_rect(_ge, _t, {beam_w/2:.1f}, {beam_d/2:.1f})")
            self._emit("    _face.pushpull(_len) if _face")
            self._emit(f'    _grp.layer = layers["{layer}"]')
            self._emit(f'    _grp.material = _mat_for("{mat}")')
            self._emit(f'    _set_ifc(_grp, "{mark}", "{section}", "brace")')
            self._emit("  end")
            self._emit("rescue => e")
            self._emit(f'  puts "SKIP {mark}: #{{e.message}}"')
            self._emit("end")
            self._emit()

    # ── ARCHITECTURAL EMITTERS ─────────────────────────────────

    def _emit_slab(self, sl: dict, z_floor: float, level_name: str):
        """Emit floor slab from boundary points."""
        pts = sl.get("boundary_points", [])
        thick = sl.get("thickness_mm", 200)
        z = sl.get("z_mm", z_floor)
        if not pts:
            pts = [[0, 0], [12000, 0], [12000, 10000], [0, 10000]]
        self._emit(f"# Slab: {level_name} | t={thick}mm | z={z:.0f}")
        self._emit("begin")
        self._emit("  _grp = ents.add_group; _ge  = _grp.entities")
        pt_strs = [f"Geom::Point3d.new({p[0]:.1f}.mm, {p[1]:.1f}.mm, {z:.1f}.mm)" for p in pts]
        self._emit(f"  _face = _ge.add_face({', '.join(pt_strs)})")
        self._emit(f"  _face.pushpull({thick:.1f}.mm) if _face")
        self._emit('  _grp.layer = layers["STR-Slabs"]')
        self._emit('  _grp.material = _mat_for("Concrete")')
        self._emit('  _set_ifc(_grp, "SLB", "t={thick}", "slab")')
        self._emit("rescue => e")
        self._emit('  puts "SKIP slab: #{e.message}"')
        self._emit("end")
        self._emit()

    def _emit_door(self, d: dict, z_floor: float):
        """Emit door as vertical rectangle with swing arc."""
        mark = d.get("mark", "D")
        pos = d.get("position", {"x": 0, "y": 0})
        px, py = pos.get("x", 0), pos.get("y", 0)
        w = d.get("width_mm", 900)
        h = d.get("height_mm", 2100)
        z = z_floor
        conf = d.get("confidence", 0.5)
        self._emit(f"# {mark} | door | {w}x{h}mm | conf={conf:.0%}")
        self._emit("begin")
        self._emit("  _grp = ents.add_group; _ge  = _grp.entities")
        self._emit(f"  _p1 = Geom::Point3d.new({px:.1f}.mm, {py:.1f}.mm, {z:.1f}.mm)")
        self._emit(f"  _p2 = Geom::Point3d.new({px + w:.1f}.mm, {py:.1f}.mm, {z:.1f}.mm)")
        self._emit(f"  _p3 = Geom::Point3d.new({px + w:.1f}.mm, {py:.1f}.mm, {z + h:.1f}.mm)")
        self._emit(f"  _p4 = Geom::Point3d.new({px:.1f}.mm, {py:.1f}.mm, {z + h:.1f}.mm)")
        self._emit("  _face = _ge.add_face(_p1, _p2, _p3, _p4)")
        self._emit("  _face.pushpull(-100.mm) if _face")
        self._emit('  _grp.layer = layers["ARCH-Doors"]')
        self._emit('  _grp.material = _mat_for("Wood")')
        self._emit(f'  _set_ifc(_grp, "{mark}", "{w}x{h}", "door")')
        self._emit("rescue => e")
        self._emit(f'  puts "SKIP {mark}: #{{e.message}}"')
        self._emit("end")
        self._emit()

    def _emit_window(self, w: dict, z_floor: float):
        """Emit window as vertical rectangle with frame."""
        mark = w.get("mark", "WIN")
        pos = w.get("position", {"x": 0, "y": 0})
        px, py = pos.get("x", 0), pos.get("y", 0)
        width = w.get("width_mm", 2000)
        height = w.get("height_mm", 1500)
        sill = w.get("sill_height_mm", 900)
        z = z_floor + sill
        conf = w.get("confidence", 0.5)
        self._emit(f"# {mark} | window | {width}x{height}mm | sill={sill} | conf={conf:.0%}")
        self._emit("begin")
        self._emit("  _grp = ents.add_group; _ge  = _grp.entities")
        self._emit(f"  _p1 = Geom::Point3d.new({px:.1f}.mm, {py:.1f}.mm, {z:.1f}.mm)")
        self._emit(f"  _p2 = Geom::Point3d.new({px + width:.1f}.mm, {py:.1f}.mm, {z:.1f}.mm)")
        self._emit(f"  _p3 = Geom::Point3d.new({px + width:.1f}.mm, {py:.1f}.mm, {z + height:.1f}.mm)")
        self._emit(f"  _p4 = Geom::Point3d.new({px:.1f}.mm, {py:.1f}.mm, {z + height:.1f}.mm)")
        self._emit("  _face = _ge.add_face(_p1, _p2, _p3, _p4)")
        self._emit("  _face.pushpull(-100.mm) if _face")
        self._emit('  _grp.layer = layers["ARCH-Windows"]')
        self._emit('  _grp.material = _mat_for("Glass")')
        self._emit(f'  _set_ifc(_grp, "{mark}", "{width}x{height}", "window")')
        self._emit("rescue => e")
        self._emit(f'  puts "SKIP {mark}: #{{e.message}}"')
        self._emit("end")
        self._emit()

    def _emit_stair(self, st: dict, z_floor: float):
        """Emit stairs as series of steps."""
        mark = st.get("mark", "ST")
        pos = st.get("position", {"x": 0, "y": 0})
        px, py = pos.get("x", 0), pos.get("y", 0)
        width = st.get("width_mm", 1000)
        n_steps = st.get("num_risers", 16)
        rise = st.get("rise_mm", 3500) / n_steps
        run = st.get("run_mm", 300)
        z = z_floor
        conf = st.get("confidence", 0.5)
        self._emit(f"# {mark} | stair | {n_steps} steps | {width}mm wide | conf={conf:.0%}")
        self._emit("begin")
        self._emit("  _grp = ents.add_group; _ge  = _grp.entities")
        for i in range(min(n_steps, 30)):
            step_z = z + i * rise
            step_y = py + i * run
            self._emit(f"  _p1 = Geom::Point3d.new({px:.1f}.mm, {step_y:.1f}.mm, {step_z:.1f}.mm)")
            self._emit(f"  _p2 = Geom::Point3d.new({px + width:.1f}.mm, {step_y:.1f}.mm, {step_z:.1f}.mm)")
            self._emit(f"  _p3 = Geom::Point3d.new({px + width:.1f}.mm, {step_y + run:.1f}.mm, {step_z:.1f}.mm)")
            self._emit(f"  _p4 = Geom::Point3d.new({px:.1f}.mm, {step_y + run:.1f}.mm, {step_z:.1f}.mm)")
            self._emit("  _f = _ge.add_face(_p1, _p2, _p3, _p4)")
            self._emit(f"  _f.pushpull({rise:.1f}.mm) if _f")
        self._emit('  _grp.layer = layers["ARCH-Stairs"]')
        self._emit('  _grp.material = _mat_for("Concrete")')
        self._emit(f'  _set_ifc(_grp, "{mark}", "{n_steps}risers", "stair")')
        self._emit("rescue => e")
        self._emit(f'  puts "SKIP {mark}: #{{e.message}}"')
        self._emit("end")
        self._emit()

    def _emit_roof(self):
        """Emit roof from model data."""
        roof = self.model.get("roof", {})
        if not roof:
            return
        rtype = roof.get("type", "flat")
        eaves_z = roof.get("eaves_z_mm", self.manifest.get("total_height_mm", 3500))
        ridge_z = roof.get("ridge_z_mm", eaves_z + 2000)
        outline = self.model.get("building_outline", {})
        w = outline.get("overall_width_mm", 12000)
        d = outline.get("overall_depth_mm", 10000)
        self._emit(f"# ── Roof ({rtype}) ──")
        self._emit("begin")
        self._emit("  _grp = ents.add_group; _ge  = _grp.entities")
        if rtype in ("gable", "hip"):
            self._emit("  # Gable/hip roof (simplified: flat sloped plane)")
            self._emit(f"  _p1 = Geom::Point3d.new(0, 0, {eaves_z:.1f}.mm)")
            self._emit(f"  _p2 = Geom::Point3d.new({w:.1f}.mm, 0, {eaves_z:.1f}.mm)")
            self._emit(f"  _p3 = Geom::Point3d.new({w/2:.1f}.mm, {d/2:.1f}.mm, {ridge_z:.1f}.mm)")
            self._emit("  _f1 = _ge.add_face(_p1, _p2, _p3)")
            self._emit(f"  _p4 = Geom::Point3d.new({w:.1f}.mm, {d:.1f}.mm, {eaves_z:.1f}.mm)")
            self._emit("  _f2 = _ge.add_face(_p2, _p4, _p3)")
            self._emit(f"  _p5 = Geom::Point3d.new(0, {d:.1f}.mm, {eaves_z:.1f}.mm)")
            self._emit("  _f2 = _ge.add_face(_p4, _p5, _p3) if _f2")
            self._emit("  _f2 = _ge.add_face(_p5, _p1, _p3) if _f2")
        else:
            self._emit(f"  _p1 = Geom::Point3d.new(0, 0, {eaves_z:.1f}.mm)")
            self._emit(f"  _p2 = Geom::Point3d.new({w:.1f}.mm, 0, {eaves_z:.1f}.mm)")
            self._emit(f"  _p3 = Geom::Point3d.new({w:.1f}.mm, {d:.1f}.mm, {eaves_z:.1f}.mm)")
            self._emit(f"  _p4 = Geom::Point3d.new(0, {d:.1f}.mm, {eaves_z:.1f}.mm)")
            self._emit("  _face = _ge.add_face(_p1, _p2, _p3, _p4)")
            self._emit("  _face.pushpull(200.mm) if _face")
        self._emit('  _grp.layer = layers["ARCH-Roof"]')
        self._emit('  _grp.material = _mat_for("Concrete")')
        self._emit('  _set_ifc(_grp, "ROOF", "ROOF", "roof")')
        self._emit("rescue => e")
        self._emit('  puts "SKIP roof: #{e.message}"')
        self._emit("end")
        self._emit()

    # ── FOOTER ─────────────────────────────────────────────────

    def _emit_footer(self):
        self._emit("# ── Finalize ──")
        self._emit("model.commit_operation")
        self._emit('puts "LOD300 V4 Model import complete."')
        self._emit()
        total_cols = sum(len(f.get("columns", [])) for f in self.model.get("floors", []))
        total_beams = sum(len(f.get("beams", [])) for f in self.model.get("floors", []))
        total_walls = sum(len(f.get("walls", [])) for f in self.model.get("floors", []))
        total_doors = sum(len(f.get("arch_doors", [])) for f in self.model.get("floors", []))
        total_wins = sum(len(f.get("arch_windows", [])) for f in self.model.get("floors", []))
        total_stairs = sum(len(f.get("arch_stairs", [])) for f in self.model.get("floors", []))
        self._emit(f'puts "  Floors: {len(self.model.get("floors", []))}"')
        self._emit(f'puts "  Columns: {total_cols}"')
        self._emit(f'puts "  Beams: {total_beams}"')
        self._emit(f'puts "  Walls: {total_walls}"')
        self._emit(f'puts "  Doors: {total_doors}"')
        self._emit(f'puts "  Windows: {total_wins}"')
        self._emit(f'puts "  Stairs: {total_stairs}"')
        total = total_cols + total_beams + total_walls + total_doors + total_wins + total_stairs
        self._emit(f'puts "  Total: {total} elements"')

    # ── SECTION DIMENSION PARSING ──────────────────────────────

    def _section_dims(self, section_label: str) -> tuple:
        """Parse section label → (width_mm, depth_mm)."""
        if not section_label:
            return (300, 300)
        if section_label in STEEL_SECTIONS:
            s = STEEL_SECTIONS[section_label]
            return (s["width"], s["depth"])
        m = re.match(r'(\d+)\s*x\s*(\d+)', str(section_label))
        if m:
            return (float(m.group(1)), float(m.group(2)))
        m = re.match(r't\s*=\s*(\d+)', str(section_label))
        if m:
            t = float(m.group(1))
            return (t, t)
        return (300, 300)


# ── CONVENIENCE ─────────────────────────────────────────────────

def generate_ruby_v4(model: dict, manifest: dict, output_path: str | Path = None) -> str:
    """Generate Ruby script from model + manifest dicts."""
    gen = RubyGeneratorV4(model, manifest)
    code = gen.generate()
    if output_path:
        gen.save(output_path)
    return code