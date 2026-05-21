"""
B1: RUBY GENERATOR V5 — SketchUp Ruby Script Builder.
Converts structural model into executable .rb scripts.
LOD300/350: uses exact cross-section profiles (I-beam, CHS, SHS/RHS, solid rect).
"""

import re
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

        # Deterministic first (reliable for large models with many members)
        ruby = None
        try:
            ruby = self._deterministic_script(model)
        except Exception as e:
            print(f"[GEN] Deterministic fail: {e} — falling back to LLM")

        if not ruby:
            try:
                sys_p = self.prompt_factory.build_full_system_prompt("ruby_generator", region=self.region)
                usr_p = self.prompt_factory.user_prompt_ruby_generate(model_json=model, profile=None)
                from core.llm_wrapper import call_llm
                resp = call_llm(usr_p, system=sys_p)
                ruby = self._extract_ruby(resp)
            except Exception as e:
                print(f"[GEN] LLM fail: {e}")
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
            _slug = re.sub(r"[^a-z0-9]+", "_", mn.lower()).strip("_") or "material"
            var = "mat_" + _slug
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

        # Build column lookup (id → resolved x,y,z) — all values forced to int
        col_positions = {}
        _pos_real = _pos_grid = _pos_fallback = 0
        for i, c in enumerate(cols):
            cid = c.get("id") or c.get("mark", f"COL_{i}")
            gx = c.get("grid_x")
            gy = c.get("grid_y")
            x = c.get("x") or c.get("x_mm")
            y = c.get("y") or c.get("y_mm")
            if x is None and gx is not None:
                x = grid_to_mm_x(gx)
            if y is None and gy is not None:
                y = grid_to_mm_y(gy)
            _had_real = x is not None and y is not None and gx is None
            _had_grid = x is not None and gx is not None
            x = self._n(x, (i % 4) * spacing_x)
            y = self._n(y, (i // 4) * spacing_y)
            if _had_real:
                _pos_real += 1
            elif _had_grid:
                _pos_grid += 1
            else:
                _pos_fallback += 1
            zb = self._n(c.get("z_base_mm") or c.get("z_base"), 0)
            zt = self._n(c.get("z_top_mm") or c.get("z_top"), None)
            if zt is not None and zt > zb:
                zh = zt - zb
            else:
                zh = self._n(c.get("height_mm") or c.get("height"), 3500)
            col_positions[cid] = {"x": x, "y": y, "z_base": zb, "z_top": zb + zh}
        total_cols = len(cols)
        if total_cols:
            print(f"  [XY] Column positions — real:{_pos_real} grid:{_pos_grid} fallback:{_pos_fallback}/{total_cols}")
            if _pos_fallback / total_cols > 0.2:
                print(f"  [WARN] >{int(_pos_fallback/total_cols*100)}% columns using fallback positions — X/Y may be wrong")

        # ── Columns ──
        if cols:
            lines.append("# === Columns ===")
            for i, c in enumerate(cols):
                cid = c.get("id") or c.get("mark", f"COL_{i}")
                pos = col_positions.get(cid, {"x": 0, "y": 0, "z_base": 0, "z_top": 3500})
                lines.extend(self._col_ruby_v5(c, pos, i, mat_vars))
            lines.append("")

        # ── Beams ──
        grid_ctx = {"x_coords": _x_coords, "y_coords": _y_coords,
                    "spacing_x": spacing_x, "spacing_y": spacing_y,
                    "gx_axes": gx_axes, "gy_axes": gy_axes}
        if beams:
            lines.append("# === Beams ===")
            for i, b in enumerate(beams):
                lines.extend(self._beam_ruby_v5(b, col_positions, i, mat_vars, grid_ctx))
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

        # ── LOD350 Connections ──
        lines.append("# === LOD350 Connections ===")
        lines.append("layers['conns'] = model.layers.add('Connections_LOD350')")
        lines.append("mat_steel_plate = model.materials.add('SteelPlate')")
        lines.append("mat_steel_plate.color = Sketchup::Color.new(140,140,160)")
        for i, c in enumerate(cols):
            cid = c.get("id") or c.get("mark", f"COL_{i}")
            pos = col_positions.get(cid, {"x": 0, "y": 0, "z_base": 0, "z_top": 3500})
            lines.extend(self._lod350_col_plates(c, pos, i))
        for i, b in enumerate(beams):
            lines.extend(self._lod350_beam_endplate(b, col_positions, i))
        lines.append("")

        lines.append("model.commit_operation")
        lines.append(f"UI.messagebox('Done: {len(cols)}c {len(beams)}b {len(slabs)}s {len(walls)}w {len(foots)}f [LOD350]')")
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
            # Z / C cold-formed purlin: Z10010 = Z100-1.0 (100mm deep, 1.0mm BMT)
            # Pattern: Z or C + 3-digit height + 2-digit thickness-tenths
            import re
            zm = re.match(r'^[ZC](\d{3})(\d{2})$', s.upper())
            if zm:
                depth = int(zm.group(1))   # 100, 150, 200, 250, 300
                flange = max(int(depth * 0.55), 50)  # typical Z/C flange ratio
                return flange, depth
            # UB / UC / PFC: try extract number
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
        d = max(int(sec.d), 100); bf = max(int(sec.bf), 60)
        tf = max(int(sec.tf), 5); tw = max(int(sec.tw), 5)
        tw = min(tw, bf - 2); tf = min(tf, d // 2 - 1)
        h = max(h, 100)
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
        od = max(int(sec.od or sec.d), 50)
        h = max(h, 100)
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
        x = self._n(pos["x"]); y = self._n(pos["y"])
        zb = self._n(pos["z_base"]); zt = self._n(pos["z_top"])
        h = zt - zb
        if sec:  # SHS/RHS — use exact outer dims from library
            w, d = int(sec.bf), int(sec.d)
        else:
            w, d = self._resolve_section(col, 400, 400)
        # Guard: degenerate face → fallback to minimum dimensions
        MIN_COL = 100
        if w < MIN_COL:
            print(f"[GEN] WARN: col {col.get('id','')} width={w} < {MIN_COL}mm, using {MIN_COL}")
            w = MIN_COL
        if d < MIN_COL:
            print(f"[GEN] WARN: col {col.get('id','')} depth={d} < {MIN_COL}mm, using {MIN_COL}")
            d = MIN_COL
        h = max(h, 100)
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

    def _beam_ruby_v5(self, beam: dict, col_map: dict, i: int, mat_vars: dict,
                      grid_ctx: dict = None) -> List[str]:
        # LOD300: try exact I-beam profile first
        sec = self._lookup_section_dims(beam)
        if sec and sec.profile_type == "I":
            return self._ibeam_beam_ruby(beam, col_map, i, mat_vars, sec)

        fid = beam.get("from_col") or beam.get("from", "")
        tid = beam.get("to_col") or beam.get("to", "")
        c1 = col_map.get(fid)
        c2 = col_map.get(tid)
        if c1 is None or c2 is None:
            # No column reference — distribute beams across grid spans systematically
            gc = grid_ctx or {}
            gx_c = gc.get("x_coords", {})
            gy_c = gc.get("y_coords", {})
            sx = gc.get("spacing_x", 6000) or 6000
            sy = gc.get("spacing_y", 6000) or 6000
            n_gx = len(gc.get("gx_axes", [])) or 3
            n_gy = len(gc.get("gy_axes", [])) or 3
            x_vals = sorted(set(int(v) for v in gx_c.values())) if gx_c else \
                     [j * sx for j in range(n_gx)]
            y_vals = sorted(set(int(v) for v in gy_c.values())) if gy_c else \
                     [j * sy for j in range(n_gy)]
            if len(x_vals) < 2:
                x_vals = [0, sx]
            if len(y_vals) < 2:
                y_vals = [0, sy]
            grid_spans = []
            for yi in y_vals:
                for xi in range(len(x_vals) - 1):
                    grid_spans.append((x_vals[xi], yi, x_vals[xi+1], yi))  # X-direction beam
            for xi in x_vals:
                for yi in range(len(y_vals) - 1):
                    grid_spans.append((xi, y_vals[yi], xi, y_vals[yi+1]))  # Y-direction beam
            if grid_spans:
                span = grid_spans[i % len(grid_spans)]
                c1 = {"x": span[0], "y": span[1]}
                c2 = {"x": span[2], "y": span[3]}
            else:
                c1 = {"x": 0, "y": 0}
                c2 = {"x": sx, "y": 0}
        x1, y1 = c1.get("x", 0), c1.get("y", 0)
        x2, y2 = c2.get("x", 0), c2.get("y", 0)
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
        x = self._n(ftg.get("x") or ftg.get("x_mm"), 0)
        y = self._n(ftg.get("y") or ftg.get("y_mm"), 0)
        # Try to snap to a column position by ID
        fid = ftg.get("column") or ftg.get("col_id") or ftg.get("id", "")
        if fid and fid in col_map:
            pos = col_map[fid]
            x = self._n(pos["x"]); y = self._n(pos["y"])
        # Fallback: if still at origin (0,0), distribute footings across x-groups
        # so they don't all pile up on the lowest-x column line
        if x == 0 and y == 0 and col_map:
            valid_cols = [p for p in col_map.values()
                          if self._n(p.get("x"), 0) != 0 or self._n(p.get("y"), 0) != 0]
            if valid_cols:
                # Group by x position, cycle i across groups for spatial distribution
                x_groups: dict = {}
                for p in valid_cols:
                    xi = int(self._n(p.get("x"), 0))
                    x_groups.setdefault(xi, []).append(p)
                x_keys = sorted(x_groups.keys())
                target_x = x_keys[i % len(x_keys)]
                group = x_groups[target_x]
                snap = group[i % len(group)]
                x = self._n(snap.get("x"), 0)
                y = self._n(snap.get("y"), 0)
                print(f"  [XY-FOOTING] {ftg.get('id','')} -> col pos ({x},{y})")
        # Pile footings use diameter_mm + socket_length_mm; raft/pad use width/depth/height
        ftg_type = str(ftg.get("type", "")).lower()
        if ftg_type == "pile":
            diam = ftg.get("diameter_mm") or ftg.get("diameter") or 600
            w = diam; d = diam
            raw_h = ftg.get("socket_length_mm") or ftg.get("height_mm") or ftg.get("height") or 600
            h = min(int(raw_h), 2000)  # cap at 2m for display
        else:
            w = ftg.get("width_mm") or ftg.get("width") or 1600
            d = ftg.get("depth_mm") or ftg.get("depth") or 1600
            h = ftg.get("height_mm") or ftg.get("height") or 600
        mat = self._get_mat(ftg, mat_vars)
        try:
            w = int(w); d = int(d); h = int(h)
        except (ValueError, TypeError):
            w = 600; d = 600; h = 600
        w = max(w, 200); d = max(d, 200); h = max(h, 100)
        hw = w // 2; hd = d // 2
        # Use Z from synthesizer if available; fallback to -h (below datum)
        z_top = self._n(ftg.get("z_top_mm"), 0)
        z_base = self._n(ftg.get("z_base_mm"), -h)
        actual_h = max(abs(z_top - z_base), h)
        return [
            f"# Footing {i+1}: {ftg.get('id','')} ({ftg_type})",
            f"pts_{i} = [",
            f"  Geom::Point3d.new(ox+{x-hw}, oy+{y-hd}, {z_base}),",
            f"  Geom::Point3d.new(ox+{x+hw}, oy+{y-hd}, {z_base}),",
            f"  Geom::Point3d.new(ox+{x+hw}, oy+{y+hd}, {z_base}),",
            f"  Geom::Point3d.new(ox+{x-hw}, oy+{y+hd}, {z_base})",
            f"]",
            f"f_{i} = ents.add_face(pts_{i})",
            f"f_{i}.material = {mat} if f_{i}",
            f"f_{i}.layer = layers['ftgs'] if f_{i}",
            f"f_{i}.pushpull({actual_h}) if f_{i}",
        ]

    # ── LOD350 CONNECTIONS ───────────────────────────────

    def _lod350_col_plates(self, col: dict, pos: dict, i: int) -> List[str]:
        """Generate base plate and cap plate for a column (LOD350)."""
        x = int(pos.get("x", 0))
        y = int(pos.get("y", 0))
        zb = int(pos.get("z_base", 0))
        zt = int(pos.get("z_top", 3500))

        # Estimate column flange width from section (fallback 200mm)
        sec = str(col.get("section", "") or "")
        col_w = 200
        try:
            import re as _re
            nums = _re.findall(r"\d+", sec)
            if nums:
                col_w = max(int(nums[0]), 100)
        except Exception:
            pass

        pw = col_w + 100   # plate wider than column flange
        ph = pw
        pt = 20            # plate thickness mm

        lines = [f"# LOD350 base+cap plates: col {i+1}"]
        for plate_name, pz, push_dir in [
            (f"bplate_{i}", zb - pt, pt),
            (f"cplate_{i}", zt, pt),
        ]:
            lines += [
                f"begin",
                f"  {plate_name}_pts = [",
                f"    Geom::Point3d.new(ox+{x - pw//2}, oy+{y - ph//2}, {pz}),",
                f"    Geom::Point3d.new(ox+{x + pw//2}, oy+{y - ph//2}, {pz}),",
                f"    Geom::Point3d.new(ox+{x + pw//2}, oy+{y + ph//2}, {pz}),",
                f"    Geom::Point3d.new(ox+{x - pw//2}, oy+{y + ph//2}, {pz})",
                f"  ]",
                f"  {plate_name}_f = ents.add_face({plate_name}_pts)",
                f"  if {plate_name}_f",
                f"    {plate_name}_f.material = mat_steel_plate",
                f"    {plate_name}_f.layer = layers['conns']",
                f"    {plate_name}_f.pushpull({push_dir})",
                f"  end",
                f"rescue; end",
            ]
        return lines

    def _lod350_beam_endplate(self, beam: dict, col_map: dict, i: int) -> List[str]:
        """Generate end plates at both ends of a beam (LOD350)."""
        from_id = beam.get("from_col") or beam.get("from", "")
        to_id = beam.get("to_col") or beam.get("to", "")
        c1 = col_map.get(from_id)
        c2 = col_map.get(to_id)
        if not (c1 and c2):
            return []

        sec = str(beam.get("section", "") or "")
        beam_d = 300
        beam_w = 150
        try:
            import re as _re
            nums = _re.findall(r"\d+", sec)
            if len(nums) >= 1:
                beam_d = int(nums[0])
            if len(nums) >= 2:
                beam_w = int(nums[1])
        except Exception:
            pass

        ept = 10   # end plate thickness mm
        zb = int(c1.get("z_base", 0))
        zt_beam = zb + beam_d  # approx beam bottom

        lines = [f"# LOD350 end plates: beam {i+1}"]
        for end_name, col_pos in [(f"ep1_{i}", c1), (f"ep2_{i}", c2)]:
            cx = int(col_pos.get("x", 0))
            cy = int(col_pos.get("y", 0))
            lines += [
                f"begin",
                f"  {end_name}_pts = [",
                f"    Geom::Point3d.new(ox+{cx - ept}, oy+{cy - beam_w//2}, {zt_beam}),",
                f"    Geom::Point3d.new(ox+{cx + ept}, oy+{cy - beam_w//2}, {zt_beam}),",
                f"    Geom::Point3d.new(ox+{cx + ept}, oy+{cy + beam_w//2}, {zt_beam}),",
                f"    Geom::Point3d.new(ox+{cx - ept}, oy+{cy + beam_w//2}, {zt_beam})",
                f"  ]",
                f"  {end_name}_f = ents.add_face({end_name}_pts)",
                f"  if {end_name}_f",
                f"    {end_name}_f.material = mat_steel_plate",
                f"    {end_name}_f.layer = layers['conns']",
                f"    {end_name}_f.pushpull({beam_d})",
                f"  end",
                f"rescue; end",
            ]
        return lines

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

    @staticmethod
    def _n(v, default: int = 0) -> int:
        """Safely coerce any model value (str/int/float/None) to int."""
        try:
            return int(float(v))
        except (ValueError, TypeError):
            return default

    def _error(self, msg: str) -> str:
        return f"# ERROR: {msg}\nUI.messagebox('Error: {msg}')"


def generate_ruby(model: dict, validation: Optional[dict] = None, region="vn") -> str:
    return RubyGeneratorV5(region=region).generate(model, validation)