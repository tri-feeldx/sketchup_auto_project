"""
B1: RUBY GENERATOR V5 — SketchUp Ruby Script Builder.
Converts structural model into executable .rb scripts.
LOD300/350: uses exact cross-section profiles (I-beam, CHS, SHS/RHS, solid rect).
"""

from typing import List, Optional
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
        # Resolve grid → coordinate snapping
        grid = model.get("grid_system", {})
        gx_axes = grid.get("x_axes", [])
        gy_axes = grid.get("y_axes", [])
        spacing_x = int(grid.get("spacing_x_mm", 6000))
        spacing_y = int(grid.get("spacing_y_mm", 6000))
        # Real mm coordinates from PDFDimensionExtractor (highest priority)
        _x_coords: dict = grid.get("x_coords", {})
        _y_coords: dict = grid.get("y_coords", {})

        def grid_to_mm_x(gx_val):
            """Map grid label to X mm coordinate (PDFDimensionExtractor → index fallback)."""
            s = str(gx_val).strip()
            if s in _x_coords:
                return int(_x_coords[s])
            try:
                return (int(s) - 1) * spacing_x
            except ValueError:
                idx = gx_axes.index(s) if s in gx_axes else -1
                return idx * spacing_x if idx >= 0 else len(gx_axes) * spacing_x

        def grid_to_mm_y(gy_val):
            s = str(gy_val).strip().upper()
            if s in _y_coords:
                return int(_y_coords[s])
            if s in gy_axes:
                return gy_axes.index(s) * spacing_y
            return len(gy_axes) * spacing_y

        lines = [self._header(model), ""]
        lines += [
            "model = Sketchup.active_model",
            "ents = model.active_entities",
            "model.start_operation('Structural_Import', true)",
            "defn = model.definitions",
            "",
            "# ── Layers ──",
            "layers = {",
            "  'cols' => model.layers.add('Columns'),",
            "  'beams'=> model.layers.add('Beams'),",
            "  'slabs'=> model.layers.add('Slabs'),",
            "  'walls'=> model.layers.add('Walls'),",
            "  'ftgs' => model.layers.add('Footings'),",
            "}",
            "",
            "# ── Materials ──",
        ]

        # Create materials dynamically from model data
        materials = model.get("materials", {})
        member_mats = set()
        members = model.get("members", {})
        for cat in ("columns", "beams", "slabs", "walls", "footings", "bracing"):
            for m in members.get(cat, []):
                mat = m.get("material")
                if mat:
                    member_mats.add(str(mat))

        mat_vars = {}
        mat_colors = {
            "concrete": "180,180,180",
            "steel": "200,200,220",
            "C20": "160,160,160",
            "C25": "170,170,170",
            "C30": "180,180,180",
            "C40": "190,190,190",
            "C50": "200,200,200",
            "steel_primary": "200,200,220",
        }
        for mn in sorted(member_mats):
            var = "mat_" + mn.replace(" ", "_").replace("-", "_")
            color = mat_colors.get(mn, "190,190,190")
            lines.append(f"{var} = model.materials.add('{mn}')")
            lines.append(f"{var}.color = Sketchup::Color.new({color})")
            mat_vars[mn] = var
        if not mat_vars:
            lines.append("mat_default = model.materials.add('concrete')")
            lines.append("mat_default.color = Sketchup::Color.new(180,180,180)")
            mat_vars["concrete"] = "mat_default"
        lines.append("")

        # Grid origin offset
        lines.append("ox = 0; oy = 0; oz = 0")
        lines.append("")

        cols = members.get("columns", [])
        beams = members.get("beams", [])
        slabs = members.get("slabs", [])
        walls = members.get("walls", [])
        foots = members.get("footings", [])

        # Build column lookup (id → resolved x,y,z)
        col_positions = {}
        for i, c in enumerate(cols):
            cid = c.get("id") or c.get("mark", f"COL_{i}")
            gx = c.get("grid_x")
            gy = c.get("grid_y")
            x = c.get("x")
            y = c.get("y")
            if x is None and gx is not None:
                x = grid_to_mm_x(gx)
            if y is None and gy is not None:
                y = grid_to_mm_y(gy)
            x = x or (i % 4) * spacing_x
            y = y or (i // 4) * spacing_y
            zb = c.get("z_base_mm") or c.get("z_base", 0)
            zh = c.get("height_mm") or c.get("height", 3500)
            col_positions[cid] = {"x": x, "y": y, "z_base": zb, "z_top": zb + zh}

        # ── Columns ──
        if cols:
            lines.append("# === Columns ===")
            for i, c in enumerate(cols):
                cid = c.get("id") or c.get("mark", f"COL_{i}")
                pos = col_positions.get(cid, {"x": 0, "y": 0, "z_base": 0, "z_top": 3500})
                lines.extend(self._col_ruby_v5(c, pos, i, mat_vars))
            lines.append("")

        # ── Beams ──
        if beams:
            lines.append("# === Beams ===")
            for i, b in enumerate(beams):
                lines.extend(self._beam_ruby_v5(b, col_positions, i, mat_vars))
            lines.append("")

        # ── Slabs ──
        if slabs:
            lines.append("# === Slabs ===")
            for i, s in enumerate(slabs):
                lines.extend(self._slab_ruby_v5(s, i, mat_vars, gx_axes, gy_axes, spacing_x, spacing_y))
            lines.append("")

        # ── Walls ──
        if walls:
            lines.append("# === Walls ===")
            for i, w in enumerate(walls):
                lines.extend(self._wall_ruby_v5(w, i, mat_vars, spacing_x, spacing_y, gx_axes, gy_axes))
            lines.append("")

        # ── Footings ──
        if foots:
            lines.append("# === Footings ===")
            for i, f in enumerate(foots):
                lines.extend(self._footing_ruby_v5(f, col_positions, i, mat_vars))
            lines.append("")

        lines.append("model.commit_operation")
        lines.append(f"UI.messagebox('Done: {len(cols)}c {len(beams)}b {len(slabs)}s {len(walls)}w {len(foots)}f')")
        return "\n".join(lines)

    def _get_mat(self, member: dict, mat_vars: dict) -> str:
        """Return material variable name for a member."""
        mat = member.get("material")
        if mat and str(mat) in mat_vars:
            return mat_vars[str(mat)]
        return list(mat_vars.values())[0] if mat_vars else "mat_default"

    def _resolve_section(self, member: dict, default_w: int, default_d: int):
        """Resolve section width/depth from member data.
        Handles steel section names like CHS400, UB360, SHS150x150.
        """
        w, d = default_w, default_d
        section = member.get("section") or member.get("section_size") or ""
        if section:
            s = str(section).strip()
            # CHSxxx = circular hollow section (diameter)
            if s.upper().startswith("CHS"):
                try:
                    dia = int(s[3:].split("x")[0]) if "x" in s[3:] else int(s[3:])
                    w = d = dia
                    return w, d
                except ValueError:
                    pass
            # SHS150x150 = square hollow section
            if s.upper().startswith("SHS"):
                try:
                    dims = s[3:].split("x")
                    w = int(dims[0]) if dims else default_w
                    d = int(dims[1]) if len(dims) > 1 else w
                    return w, d
                except ValueError:
                    pass
            # UB / UC / PFC: try extract number
            import re
            nums = re.findall(r'(\d+)', s)
            if nums:
                w = int(nums[0])
                d = int(nums[-1]) if len(nums) > 1 else w
                return w, d
        # Also try generic width/depth fields
        w = member.get("width_mm") or member.get("width") or w
        d = member.get("depth_mm") or member.get("depth") or d
        try:
            w = int(w)
            d = int(d)
        except (ValueError, TypeError):
            w, d = default_w, default_d
        return w, d

    # ── Section library lookup (LOD300) ─────────────────────
    def _lookup_section_dims(self, member: dict):
        """Return SectionDimensions from library, or None if not found."""
        raw = (member.get("section") or member.get("section_size") or
               member.get("size") or "").strip()
        if not raw:
            return None
        try:
            from generators.section_library_asnzs import (
                lookup_section, parse_section_from_string
            )
            return lookup_section(raw, self.region) or parse_section_from_string(raw, self.region)
        except Exception:
            return None

    def _ibeam_col_ruby(self, col: dict, pos: dict, i: int,
                         mat_vars: dict, sec) -> List[str]:
        """Column with exact I-profile (UB/UC). Extrudes vertically along Z."""
        x = int(pos["x"]); y = int(pos["y"])
        zb = int(pos["z_base"]); h = int(pos["z_top"] - pos["z_base"])
        d = int(sec.d); bf = int(sec.bf); tf = int(sec.tf); tw = int(sec.tw)
        mat = self._get_mat(col, mat_vars)
        # Centre profile on (x, y); profile spans x±bf/2, y…y+d
        cx = x - bf // 2;  cy = y
        # 12-vertex I-profile (CCW viewed from below = face normal points -Z then flipped)
        return [
            f"# Column {i+1} [{col.get('id','')}] {sec.name} LOD300 I-profile",
            f"cg_{i} = ents.add_group",
            f"cge_{i} = cg_{i}.entities",
            f"cp_{i} = [",
            f"  Geom::Point3d.new(ox+{cx},       oy+{cy},       {zb}),",
            f"  Geom::Point3d.new(ox+{cx+bf},    oy+{cy},       {zb}),",
            f"  Geom::Point3d.new(ox+{cx+bf},    oy+{cy+tf},    {zb}),",
            f"  Geom::Point3d.new(ox+{cx+bf//2+tw//2}, oy+{cy+tf},    {zb}),",
            f"  Geom::Point3d.new(ox+{cx+bf//2+tw//2}, oy+{cy+d-tf},  {zb}),",
            f"  Geom::Point3d.new(ox+{cx+bf},    oy+{cy+d-tf},  {zb}),",
            f"  Geom::Point3d.new(ox+{cx+bf},    oy+{cy+d},     {zb}),",
            f"  Geom::Point3d.new(ox+{cx},       oy+{cy+d},     {zb}),",
            f"  Geom::Point3d.new(ox+{cx},       oy+{cy+d-tf},  {zb}),",
            f"  Geom::Point3d.new(ox+{cx+bf//2-tw//2}, oy+{cy+d-tf},  {zb}),",
            f"  Geom::Point3d.new(ox+{cx+bf//2-tw//2}, oy+{cy+tf},    {zb}),",
            f"  Geom::Point3d.new(ox+{cx},       oy+{cy+tf},    {zb})",
            f"]",
            f"cf_{i} = cge_{i}.add_face(cp_{i})",
            f"cf_{i}.material = {mat} if cf_{i}",
            f"cf_{i}.pushpull({h}) if cf_{i}",
            f"cg_{i}.layer = layers['cols']",
        ]

    def _chs_col_ruby(self, col: dict, pos: dict, i: int,
                       mat_vars: dict, sec) -> List[str]:
        """Column with CHS circular profile. Uses SketchUp add_circle + pushpull."""
        x = int(pos["x"]); y = int(pos["y"])
        zb = int(pos["z_base"]); h = int(pos["z_top"] - pos["z_base"])
        od = int(sec.od or sec.d)
        mat = self._get_mat(col, mat_vars)
        return [
            f"# Column {i+1} [{col.get('id','')}] {sec.name} CHS LOD300",
            f"cg_{i} = ents.add_group",
            f"cge_{i} = cg_{i}.entities",
            f"cc_{i} = cge_{i}.add_circle(",
            f"  Geom::Point3d.new(ox+{x}, oy+{y}, {zb}),",
            f"  Geom::Vector3d.new(0,0,1), {od//2}, 48)",
            f"cf_{i} = cc_{i}.first.faces.first if cc_{i}",
            f"cf_{i}.material = {mat} if cf_{i}",
            f"cf_{i}.pushpull({h}) if cf_{i}",
            f"cg_{i}.layer = layers['cols']",
        ]

    def _ibeam_beam_ruby(self, beam: dict, col_map: dict, i: int,
                          mat_vars: dict, sec) -> List[str]:
        """Beam with exact I-profile. Profile in YZ local plane, extrudes along X."""
        fid = beam.get("from_col") or beam.get("from", "")
        tid = beam.get("to_col") or beam.get("to", "")
        c1 = col_map.get(fid, {"x": 0, "y": 0, "z_top": 3500})
        c2 = col_map.get(tid, {"x": 6000, "y": 0, "z_top": 3500})
        x1, y1 = int(c1["x"]), int(c1["y"])
        x2, y2 = int(c2["x"]), int(c2["y"])
        z = int(beam.get("z_mm") or beam.get("z") or c1.get("z_top", 3500))
        d = int(sec.d); bf = int(sec.bf); tf = int(sec.tf); tw = int(sec.tw)
        mat = self._get_mat(beam, mat_vars)
        # Place bottom of beam at z; web vertical (Z), flanges horizontal (Y)
        return [
            f"# Beam {i+1} [{beam.get('id','')}] {sec.name} LOD300 I-profile",
            f"bx1_{i} = ox+{x1}; by1_{i} = oy+{y1}",
            f"bx2_{i} = ox+{x2}; by2_{i} = oy+{y2}",
            f"bdx_{i} = bx2_{i}-bx1_{i}; bdy_{i} = by2_{i}-by1_{i}",
            f"blen_{i} = Math.sqrt(bdx_{i}**2+bdy_{i}**2).round",
            f"if blen_{i} > 0",
            f"  bang_{i} = Math.atan2(bdy_{i}, bdx_{i})",
            f"  bori_{i} = Geom::Point3d.new(bx1_{i}, by1_{i}, {z})",
            f"  brot_{i} = Geom::Transformation.rotation(bori_{i}, Geom::Vector3d.new(0,0,1), bang_{i})",
            f"  bg_{i} = ents.add_group",
            f"  bg_{i}.transformation = brot_{i}",
            f"  bge_{i} = bg_{i}.entities",
            f"  # I-profile in YZ local plane (x=0), Y=flange width, Z=depth",
            f"  bp_{i} = [",
            f"    Geom::Point3d.new(0, {-bf//2},          0),",
            f"    Geom::Point3d.new(0,  {bf//2},          0),",
            f"    Geom::Point3d.new(0,  {bf//2},         {tf}),",
            f"    Geom::Point3d.new(0,  {tw//2},         {tf}),",
            f"    Geom::Point3d.new(0,  {tw//2},         {d-tf}),",
            f"    Geom::Point3d.new(0,  {bf//2},         {d-tf}),",
            f"    Geom::Point3d.new(0,  {bf//2},          {d}),",
            f"    Geom::Point3d.new(0, {-bf//2},          {d}),",
            f"    Geom::Point3d.new(0, {-bf//2},         {d-tf}),",
            f"    Geom::Point3d.new(0, {-tw//2},         {d-tf}),",
            f"    Geom::Point3d.new(0, {-tw//2},         {tf}),",
            f"    Geom::Point3d.new(0, {-bf//2},         {tf})",
            f"  ]",
            f"  bface_{i} = bge_{i}.add_face(bp_{i})",
            f"  bface_{i}.material = {mat} if bface_{i}",
            f"  bface_{i}.pushpull(blen_{i}) if bface_{i}",
            f"  bg_{i}.layer = layers['beams']",
            f"end",
        ]

    def _col_ruby_v5(self, col: dict, pos: dict, i: int, mat_vars: dict) -> List[str]:
        # LOD300: try exact section profile first
        sec = self._lookup_section_dims(col)
        if sec and sec.profile_type == "I":
            return self._ibeam_col_ruby(col, pos, i, mat_vars, sec)
        if sec and sec.profile_type == "CHS":
            return self._chs_col_ruby(col, pos, i, mat_vars, sec)
        # Fallback: rectangular solid with resolved dimensions
        x = pos["x"]; y = pos["y"]
        zb = pos["z_base"]; zt = pos["z_top"]
        h = zt - zb
        if sec:  # SHS/RHS — use exact outer dims from library
            w, d = int(sec.bf), int(sec.d)
        else:
            w, d = self._resolve_section(col, 400, 400)
        mat = self._get_mat(col, mat_vars)
        return [
            f"# Column {i+1}: {col.get('id','')}",
            f"pts_{i} = [",
            f"  Geom::Point3d.new(ox+{x}, oy+{y}, {zb}),",
            f"  Geom::Point3d.new(ox+{x+w}, oy+{y}, {zb}),",
            f"  Geom::Point3d.new(ox+{x+w}, oy+{y+d}, {zb}),",
            f"  Geom::Point3d.new(ox+{x}, oy+{y+d}, {zb})",
            f"]",
            f"f_{i} = ents.add_face(pts_{i})",
            f"f_{i}.material = {mat} if f_{i}",
            f"f_{i}.layer = layers['cols'] if f_{i}",
            f"f_{i}.pushpull({h}) if f_{i}",
        ]

    def _beam_ruby_v5(self, beam: dict, col_map: dict, i: int, mat_vars: dict) -> List[str]:
        # LOD300: try exact I-beam profile first
        sec = self._lookup_section_dims(beam)
        if sec and sec.profile_type == "I":
            return self._ibeam_beam_ruby(beam, col_map, i, mat_vars, sec)

        fid = beam.get("from_col") or beam.get("from", "")
        tid = beam.get("to_col") or beam.get("to", "")
        c1 = col_map.get(fid, {"x": 0, "y": 0, "z_top": 3500})
        c2 = col_map.get(tid, {"x": 6000, "y": 0, "z_top": 3500})
        x1, y1 = c1["x"], c1["y"]
        x2, y2 = c2["x"], c2["y"]
        z = beam.get("z_mm") or beam.get("z") or c1.get("z_top", 3500)
        if sec:  # SHS/RHS — use exact outer dims
            w, d = int(sec.bf), int(sec.d)
        else:
            w, d = self._resolve_section(beam, 200, 300)
        mat = self._get_mat(beam, mat_vars)
        return [
            f"# Beam {i+1}: {beam.get('id','')} {fid}→{tid}",
            f"bx1_{i} = ox + {x1}; by1_{i} = oy + {y1}",
            f"bx2_{i} = ox + {x2}; by2_{i} = oy + {y2}",
            f"bdx_{i} = bx2_{i} - bx1_{i}; bdy_{i} = by2_{i} - by1_{i}",
            f"blen_{i} = Math.sqrt(bdx_{i}*bdx_{i} + bdy_{i}*bdy_{i})",
            f"if blen_{i} > 0",
            f"  bang_{i} = Math.atan2(bdy_{i}, bdx_{i})",
            f"  bpt_{i} = Geom::Point3d.new(bx1_{i}, by1_{i}, {z})",
            f"  btr_{i} = Geom::Transformation.translation(bpt_{i})",
            f"  btr_{i} = btr_{i} * Geom::Transformation.rotation(bpt_{i}, [0,0,1], bang_{i})",
            f"  bg_{i} = ents.add_group",
            f"  bg_{i}.transformation = btr_{i}",
            f"  pts_{i} = [",
            f"    Geom::Point3d.new(0, 0, 0),",
            f"    Geom::Point3d.new(blen_{i}, 0, 0),",
            f"    Geom::Point3d.new(blen_{i}, {d}, 0),",
            f"    Geom::Point3d.new(0, {d}, 0)",
            f"  ]",
            f"  bf_{i} = bg_{i}.entities.add_face(pts_{i})",
            f"  bf_{i}.material = {mat} if bf_{i}",
            f"  bf_{i}.pushpull(-{w}) if bf_{i}",
            f"  bg_{i}.layer = layers['beams']",
            f"end",
        ]

    def _slab_ruby_v5(self, slab: dict, i: int, mat_vars: dict,
                       gx_axes: list, gy_axes: list,
                       spacing_x: int, spacing_y: int) -> List[str]:
        t = slab.get("thickness_mm") or slab.get("thickness", 200)
        try:
            t = int(t)
        except (ValueError, TypeError):
            t = 200
        z = slab.get("z_mm") or slab.get("z") or slab.get("elevation_mm", 3500)
        bounds = slab.get("bounds", [])
        mat = self._get_mat(slab, mat_vars)
        if bounds and len(bounds) >= 3:
            pts = ", ".join(
                f"Geom::Point3d.new({p.get('x',0)},{p.get('y',0)},{z})"
                for p in bounds
            )
            return [
                f"# Slab {i+1}: {slab.get('id','')}",
                f"pts_{i} = [{pts}]",
                f"f_{i} = ents.add_face(pts_{i})",
                f"f_{i}.material = {mat} if f_{i}",
                f"f_{i}.layer = layers['slabs'] if f_{i}",
                f"f_{i}.pushpull(-{t}) if f_{i}",
            ]
        # Fallback: use grid extent
        nx = max(1, len(gx_axes)); ny = max(1, len(gy_axes))
        sx = nx * spacing_x; sy = ny * spacing_y
        return [
            f"# Slab {i+1}: {slab.get('id','')}",
            f"pts_{i} = [",
            f"  Geom::Point3d.new(ox, oy, {z}),",
            f"  Geom::Point3d.new(ox+{sx}, oy, {z}),",
            f"  Geom::Point3d.new(ox+{sx}, oy+{sy}, {z}),",
            f"  Geom::Point3d.new(ox, oy+{sy}, {z})",
            f"]",
            f"f_{i} = ents.add_face(pts_{i})",
            f"f_{i}.material = {mat} if f_{i}",
            f"f_{i}.layer = layers['slabs'] if f_{i}",
            f"f_{i}.pushpull(-{t}) if f_{i}",
        ]

    def _wall_ruby_v5(self, wall: dict, i: int, mat_vars: dict,
                       spacing_x: int, spacing_y: int,
                       gx_axes: list, gy_axes: list) -> List[str]:
        t = wall.get("thickness_mm") or wall.get("thickness", 200)
        h = wall.get("height_mm") or wall.get("height", 3500)
        zb = wall.get("z_base_mm") or wall.get("z_base", 0)
        mat = self._get_mat(wall, mat_vars)
        try:
            t = int(t)
            h = int(h)
            zb = int(zb)
        except (ValueError, TypeError):
            pass

        # Resolve wall location from grid-based location
        loc = wall.get("location", {})
        if loc:
            # Grid-based: {"along_grid_x": "3", "start_grid_y": "A", "end_grid_y": "D"}
            agx = loc.get("along_grid_x") or loc.get("along_grid")
            sgy = loc.get("start_grid_y") or loc.get("start_grid")
            egy = loc.get("end_grid_y") or loc.get("end_grid")
            agy = loc.get("along_grid_y")
            sgx = loc.get("start_grid_x")
            egx = loc.get("end_grid_x")
            if agx and sgy and egy:
                x_val = int(agx) - 1 if str(agx).isdigit() else (gx_axes.index(str(agx)) if str(agx) in gx_axes else 0)
                x1 = x_val * spacing_x
                y1_idx = gy_axes.index(str(sgy).upper()) if str(sgy).upper() in gy_axes else 0
                y2_idx = gy_axes.index(str(egy).upper()) if str(egy).upper() in gy_axes else len(gy_axes) - 1
                y1 = y1_idx * spacing_y
                y2 = y2_idx * spacing_y
                return [
                    f"# Wall {i+1}: {wall.get('id','')} along X={agx}",
                    f"pts_{i} = [",
                    f"  Geom::Point3d.new(ox+{x1-t//2}, oy+{y1}, {zb}),",
                    f"  Geom::Point3d.new(ox+{x1+t//2}, oy+{y1}, {zb}),",
                    f"  Geom::Point3d.new(ox+{x1+t//2}, oy+{y2}, {zb}),",
                    f"  Geom::Point3d.new(ox+{x1-t//2}, oy+{y2}, {zb})",
                    f"]",
                    f"f_{i} = ents.add_face(pts_{i})",
                    f"f_{i}.material = {mat} if f_{i}",
                    f"f_{i}.layer = layers['walls'] if f_{i}",
                    f"f_{i}.pushpull({h}) if f_{i}",
                ]
            elif agy and sgx and egx:
                y_val = int(agy) - 1 if str(agy).isdigit() else (gy_axes.index(str(agy)) if str(agy) in gy_axes else 0)
                y1 = y_val * spacing_y
                x1_idx = gx_axes.index(str(sgx)) if str(sgx) in gx_axes else 0
                x2_idx = gx_axes.index(str(egx)) if str(egx) in gx_axes else len(gx_axes) - 1
                x1 = x1_idx * spacing_x
                x2 = x2_idx * spacing_x
                return [
                    f"# Wall {i+1}: {wall.get('id','')} along Y={agy}",
                    f"pts_{i} = [",
                    f"  Geom::Point3d.new(ox+{x1}, oy+{y1-t//2}, {zb}),",
                    f"  Geom::Point3d.new(ox+{x2}, oy+{y1-t//2}, {zb}),",
                    f"  Geom::Point3d.new(ox+{x2}, oy+{y1+t//2}, {zb}),",
                    f"  Geom::Point3d.new(ox+{x1}, oy+{y1+t//2}, {zb})",
                    f"]",
                    f"f_{i} = ents.add_face(pts_{i})",
                    f"f_{i}.material = {mat} if f_{i}",
                    f"f_{i}.layer = layers['walls'] if f_{i}",
                    f"f_{i}.pushpull({h}) if f_{i}",
                ]

        # Fallback: use x1/y1/x2/y2
        x1 = wall.get("x1") or wall.get("start_x", 0)
        y1 = wall.get("y1") or wall.get("start_y", 0)
        x2 = wall.get("x2") or wall.get("end_x", 6000)
        y2 = wall.get("y2") or wall.get("end_y", 0)
        return [
            f"# Wall {i+1}: {wall.get('id','')}",
            f"v_{i} = Geom::Vector3d.new({x2-x1},{y2-y1},0)",
            f"if v_{i}.length > 0",
            f"  d_{i} = v_{i}.normalize",
            f"  p_{i} = Geom::Vector3d.new(-d_{i}.y, d_{i}.x, 0)",
            f"  s_{i} = Geom::Point3d.new(ox+{x1}, oy+{y1}, {zb})",
            f"  e_{i} = Geom::Point3d.new(ox+{x2}, oy+{y2}, {zb})",
            f"  ht = {t} / 2.0",
            f"  pts_{i} = [s_{i}+p_{i}*ht, e_{i}+p_{i}*ht, e_{i}-p_{i}*ht, s_{i}-p_{i}*ht]",
            f"  f_{i} = ents.add_face(pts_{i})",
            f"  f_{i}.material = {mat} if f_{i}",
            f"  f_{i}.layer = layers['walls'] if f_{i}",
            f"  f_{i}.pushpull({h}) if f_{i}",
            f"end",
        ]

    def _footing_ruby_v5(self, ftg: dict, col_map: dict, i: int,
                          mat_vars: dict) -> List[str]:
        x = ftg.get("x", 0); y = ftg.get("y", 0)
        # Try to snap to a column position
        fid = ftg.get("column") or ftg.get("col_id") or ftg.get("id", "")
        if fid and fid in col_map:
            pos = col_map[fid]
            x = pos["x"]; y = pos["y"]
        w = ftg.get("width_mm") or ftg.get("width", 1600)
        d = ftg.get("depth_mm") or ftg.get("depth", 1600)
        h = ftg.get("height_mm") or ftg.get("height", 600)
        mat = self._get_mat(ftg, mat_vars)
        try:
            w = int(w); d = int(d); h = int(h)
        except (ValueError, TypeError):
            w = 1600; d = 1600; h = 600
        hw = w // 2; hd = d // 2
        return [
            f"# Footing {i+1}: {ftg.get('id','')}",
            f"pts_{i} = [",
            f"  Geom::Point3d.new(ox+{x-hw}, oy+{y-hd}, -{h}),",
            f"  Geom::Point3d.new(ox+{x+hw}, oy+{y-hd}, -{h}),",
            f"  Geom::Point3d.new(ox+{x+hw}, oy+{y+hd}, -{h}),",
            f"  Geom::Point3d.new(ox+{x-hw}, oy+{y+hd}, -{h})",
            f"]",
            f"f_{i} = ents.add_face(pts_{i})",
            f"f_{i}.material = {mat} if f_{i}",
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
        # Strategy 1: full code block with closing ```
        m = re.search(r'```ruby\s*([\s\S]*?)```', response)
        if m:
            return m.group(1).strip()
        m = re.search(r'```\s*([\s\S]*?)```', response)
        if m and ("Sketchup" in m.group(1) or "ents." in m.group(1)):
            return m.group(1).strip()
        # Strategy 2: unclosed ```ruby block (truncated LLM output)
        if response.strip().startswith('```ruby'):
            return response.strip()[7:].strip()  # remove ```ruby prefix
        if response.strip().startswith('```'):
            return response.strip()[3:].strip()
        # Strategy 3: strip any remaining markdown wrapper
        cleaned = response.strip()
        if cleaned.endswith('```'):
            cleaned = cleaned[:-3].strip()
        return cleaned

    def _wrap_script(self, ruby: str, model: dict) -> str:
        # Append .skp auto-save so SketchUp writes the file to Downloads automatically.
        proj = (model.get("project_info") or {}).get("name", "structural_model")
        safe = proj.replace(" ", "_").replace("/", "_").replace("\\", "_")
        footer = (
            "\n# ── Auto-save .skp ──────────────────────────────────────────\n"
            "begin\n"
            f"  _skp_name = '{safe}_LOD300.skp'\n"
            "  _skp_dir  = File.expand_path('~/Downloads')\n"
            "  _skp_path = File.join(_skp_dir, _skp_name)\n"
            "  Sketchup.active_model.save(_skp_path)\n"
            "  UI.messagebox(\"\\u2705 Model saved: #{_skp_path}\")\n"
            "rescue => _e\n"
            "  UI.messagebox(\"Save failed: #{_e.message}. Use File > Save As manually.\")\n"
            "end\n"
        )
        return ruby + footer

    def _error(self, msg: str) -> str:
        return f"# ERROR: {msg}\nUI.messagebox('Error: {msg}')"


def generate_ruby(model: dict, validation: Optional[dict] = None, region="vn") -> str:
    return RubyGeneratorV5(region=region).generate(model, validation)