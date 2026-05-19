"""
B1: RUBY GENERATOR V5 — SketchUp Ruby Script Builder.
Converts structural model into executable .rb scripts.
"""

from typing import List, Dict, Optional
from pipelines.prompt_factory import PromptFactory


class RubyGeneratorV5:

    MAX_ENTITIES = 50_000
    WARNING_ENTITIES = 30_000

    def __init__(self, region="vn", language="vn"):
        self.region = region
        self.language = language
        self.prompt_factory = PromptFactory(region=region, language=language)

    def generate(self, model: dict, validation_result: Optional[dict] = None) -> str:
        if not model or model.get("error"):
            return self._error(model.get("error", "Empty model") if model else "No model")

        members = model.get("members", {})
        total = sum(len(members.get(k, [])) for k in members)
        if total == 0:
            return self._error("No structural members")
        if total > self.WARNING_ENTITIES:
            print(f"[GEN] {total} entities, may be slow")

        # Try LLM first
        ruby = None
        try:
            sys_p = self.prompt_factory.build_full_system_prompt("ruby_generator", region=self.region)
            usr_p = self.prompt_factory.user_prompt_ruby_generate(model_json=model, profile=None)
            from core.llm_wrapper import call_llm
            resp = call_llm(usr_p, system=sys_p)
            ruby = self._extract_ruby(resp)
        except Exception as e:
            print(f"[GEN] LLM fail: {e}")

        if not ruby:
            ruby = self._deterministic_script(model)
        return self._wrap_script(ruby, model)

    # ── DETERMINISTIC ───────────────────────────────────

    def _deterministic_script(self, model: dict) -> str:
        lines = [self._header(model), ""]
        lines += [
            "model = Sketchup.active_model",
            "ents = model.active_entities",
            "model.start_operation('Structural_Import', true)",
            "",
            "layers = {",
            "  'cols' => model.layers.add('Columns'),",
            "  'beams'=> model.layers.add('Beams'),",
            "  'slabs'=> model.layers.add('Slabs'),",
            "  'walls'=> model.layers.add('Walls'),",
            "  'ftgs' => model.layers.add('Footings'),",
            "}",
            "",
            "mat = model.materials.add('concrete')",
            "mat.color = Sketchup::Color.new(180,180,180)",
            "origin_x = 0; origin_y = 0",
            "",
        ]

        members = model.get("members", {})
        cols = members.get("columns", [])
        beams = members.get("beams", [])
        slabs = members.get("slabs", [])
        walls = members.get("walls", [])
        foots = members.get("footings", [])

        # Columns
        if cols:
            lines.append("# === Columns ===")
            for i, c in enumerate(cols):
                lines.extend(self._col_ruby(c, i))
            lines.append("")

        # Beams
        if beams:
            lines.append("# === Beams ===")
            col_map = {}
            for c in cols:
                cid = c.get("id") or c.get("mark", "")
                if cid:
                    col_map[cid] = c
            for i, b in enumerate(beams):
                lines.extend(self._beam_ruby(b, col_map, i))
            lines.append("")

        # Slabs
        if slabs:
            lines.append("# === Slabs ===")
            for i, s in enumerate(slabs):
                lines.extend(self._slab_ruby(s, i))
            lines.append("")

        # Walls
        if walls:
            lines.append("# === Walls ===")
            for i, w in enumerate(walls):
                lines.extend(self._wall_ruby(w, i))
            lines.append("")

        # Footings
        if foots:
            lines.append("# === Footings ===")
            for i, f in enumerate(foots):
                lines.extend(self._footing_ruby(f, i))
            lines.append("")

        lines.append("model.commit_operation")
        lines.append(f"UI.messagebox('Done: {len(cols)}c {len(beams)}b {len(slabs)}s {len(walls)}w {len(foots)}f')")
        return "\n".join(lines)

    def _col_ruby(self, col: dict, i: int) -> List[str]:
        x = col.get("x", 0); y = col.get("y", 0)
        w = col.get("width_mm") or col.get("width") or col.get("size_x", 300)
        d = col.get("depth_mm") or col.get("depth") or col.get("size_y", 300)
        h = col.get("height_mm") or col.get("height", 3500)
        zb = col.get("z_base_mm") or col.get("z_base", 0)
        return [
            f"pts_{i} = [Geom::Point3d.new(origin_x+{x}, origin_y+{y}, {zb}), "
            f"Geom::Point3d.new(origin_x+{x+w}, origin_y+{y+d}, {zb}), "
            f"Geom::Point3d.new(origin_x+{x+w}, origin_y+{y+d}, {zb+h})]",
            f"f_{i} = ents.add_face(pts_{i})",
            f"f_{i}.material = mat if f_{i}",
            f"f_{i}.layer = layers['cols'] if f_{i}",
            f"f_{i}.pushpull(-{h}) if f_{i}",
        ]

    def _beam_ruby(self, beam: dict, col_map: dict, i: int) -> List[str]:
        fid = beam.get("from_col") or beam.get("from", "")
        tid = beam.get("to_col") or beam.get("to", "")
        c1 = col_map.get(fid, {})
        c2 = col_map.get(tid, {})
        x1 = c1.get("x", 0); y1 = c1.get("y", 0)
        x2 = c2.get("x", x1+4000); y2 = c2.get("y", y1)
        z = beam.get("z_mm") or beam.get("z", 3500)
        return [
            f"pt1_{i} = Geom::Point3d.new(origin_x+{x1}, origin_y+{y1}, {z})",
            f"pt2_{i} = Geom::Point3d.new(origin_x+{x2}, origin_y+{y2}, {z})",
            f"ln_{i} = ents.add_cline(pt1_{i}, pt2_{i})",
            f"ln_{i}.layer = layers['beams'] if ln_{i}",
        ]

    def _slab_ruby(self, slab: dict, i: int) -> List[str]:
        t = slab.get("thickness_mm") or slab.get("thickness", 120)
        # SAFEGUARD: coerce thickness to int, fallback 120
        try:
            t = int(t)
        except (ValueError, TypeError):
            t = 120
        z = slab.get("z_mm") or slab.get("z", 3500)
        bounds = slab.get("bounds", [])
        if bounds and len(bounds) >= 3:
            pts = ", ".join(f"Geom::Point3d.new({p.get('x',0)},{p.get('y',0)},{z})" for p in bounds)
            return [
                f"pts_{i} = [{pts}]",
                f"f_{i} = ents.add_face(pts_{i})",
                f"f_{i}.material = mat if f_{i}",
                f"f_{i}.layer = layers['slabs'] if f_{i}",
                f"f_{i}.pushpull(-{t}) if f_{i}",
            ]
        cx = slab.get("center_x", 2000); cy = slab.get("center_y", 2000)
        sx = slab.get("size_x", 4000); sy = slab.get("size_y", 4000)
        return [
            f"pts_{i} = [Geom::Point3d.new({cx},{cy},{z}),"
            f"Geom::Point3d.new({cx+sx},{cy},{z}),"
            f"Geom::Point3d.new({cx+sx},{cy+sy},{z}),"
            f"Geom::Point3d.new({cx},{cy+sy},{z})]",
            f"f_{i} = ents.add_face(pts_{i})",
            f"f_{i}.material = mat if f_{i}",
            f"f_{i}.layer = layers['slabs'] if f_{i}",
            f"f_{i}.pushpull(-{t}) if f_{i}",
        ]

    def _wall_ruby(self, wall: dict, i: int) -> List[str]:
        x1 = wall.get("x1") or wall.get("start_x", 0)
        y1 = wall.get("y1") or wall.get("start_y", 0)
        x2 = wall.get("x2") or wall.get("end_x", 4000)
        y2 = wall.get("y2") or wall.get("end_y", 0)
        t = wall.get("thickness_mm") or wall.get("thickness", 100)
        h = wall.get("height_mm") or wall.get("height", 3500)
        zb = wall.get("z_base_mm") or wall.get("z_base", 0)
        return [
            f"# Wall {i+1}",
            f"v_{i} = Geom::Vector3d.new({x2-x1},{y2-y1},0)",
            f"if v_{i}.length > 0",
            f"  d_{i} = v_{i}.normalize",
            f"  p_{i} = Geom::Vector3d.new(-d_{i}.y, d_{i}.x, 0)",
            f"  s_{i} = Geom::Point3d.new(origin_x+{x1}, origin_y+{y1}, {zb})",
            f"  e_{i} = Geom::Point3d.new(origin_x+{x2}, origin_y+{y2}, {zb})",
            f"  ht = {t}.mm / 2.0",
            f"  pts_{i} = [s_{i}+p_{i}*ht, e_{i}+p_{i}*ht, e_{i}-p_{i}*ht, s_{i}-p_{i}*ht]",
            f"  f_{i} = ents.add_face(pts_{i})",
            f"  f_{i}.material = mat if f_{i}",
            f"  f_{i}.layer = layers['walls'] if f_{i}",
            f"  f_{i}.pushpull({h}) if f_{i}",
            f"end",
        ]

    def _footing_ruby(self, ftg: dict, i: int) -> List[str]:
        x = ftg.get("x", 0); y = ftg.get("y", 0)
        w = ftg.get("width_mm") or ftg.get("width", 1600)
        d = ftg.get("depth_mm") or ftg.get("depth", 1600)
        h = ftg.get("height_mm") or ftg.get("height", 600)
        return [
            f"pts_{i} = [Geom::Point3d.new(origin_x+{x-w//2}, origin_y+{y-d//2}, -{h}),"
            f"Geom::Point3d.new(origin_x+{x+w//2}, origin_y+{y-d//2}, -{h}),"
            f"Geom::Point3d.new(origin_x+{x+w//2}, origin_y+{y+d//2}, -{h}),"
            f"Geom::Point3d.new(origin_x+{x-w//2}, origin_y+{y+d//2}, -{h})]",
            f"f_{i} = ents.add_face(pts_{i})",
            f"f_{i}.material = mat if f_{i}",
            f"f_{i}.layer = layers['ftgs'] if f_{i}",
            f"f_{i}.pushpull({h}) if f_{i}",
        ]

    # ── HELPERS ─────────────────────────────────────────

    def _header(self, model: dict) -> str:
        dt = __import__("datetime").datetime.now().isoformat()
        return f"# SketchUp Structural Script\n# Generated: {dt}\n# Region: {self.region}"

    def _extract_ruby(self, response: str) -> Optional[str]:
        if not response:
            return None
        import re
        m = re.search(r'```ruby\s*([\s\S]*?)```', response)
        if m:
            return m.group(1).strip()
        m = re.search(r'```\s*([\s\S]*?)```', response)
        if m and ("Sketchup" in m.group(1) or "ents." in m.group(1)):
            return m.group(1).strip()
        return response.strip()

    def _wrap_script(self, ruby: str, model: dict) -> str:
        return ruby

    def _error(self, msg: str) -> str:
        return f"# ERROR: {msg}\nUI.messagebox('Error: {msg}')"


def generate_ruby(model: dict, validation: Optional[dict] = None, region="vn") -> str:
    return RubyGeneratorV5(region=region).generate(model, validation)