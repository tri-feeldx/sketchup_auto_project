# ===========================================================================
# LOD 300 Structural Model — Building
# Pipeline V4 (Vision LLM + Gridless)
# Building: other | 12 floors | 42.0m total height
# ===========================================================================

model  = Sketchup.active_model
model.name        = "Building"
model.description = "other | 12 floors | V4 Pipeline"
ents   = model.active_entities
layers = model.layers
model.start_operation('LOD300 V4 Import', true)

# ── Layers ──
[
  "STR-Columns",
  "STR-Beams",
  "STR-Braces",
  "STR-Walls",
  "STR-Slabs",
  "ARCH-Doors",
  "ARCH-Windows",
  "ARCH-Stairs",
  "ARCH-Roof",
  "LOD300_REVIEW",
].each do |lname|
  layers[lname] || layers.add(lname)
end

# ── Materials ──
_mats = model.materials

_steel_mat = _mats["Structural_Steel"] || _mats.add("Structural_Steel")
_steel_mat.color = Sketchup::Color.new(160, 160, 175, 255)

_concrete_mat = _mats["Concrete"] || _mats.add("Concrete")
_concrete_mat.color = Sketchup::Color.new(180, 175, 165, 255)

_glass_mat = _mats["Glass"] || _mats.add("Glass")
_glass_mat.color = Sketchup::Color.new(180, 220, 240, 140)

_wood_mat = _mats["Wood"] || _mats.add("Wood")
_wood_mat.color = Sketchup::Color.new(160, 120, 70, 255)

# ── Material lookup ──
def _mat_for(mname)
  case mname.downcase
  when "steel" then _steel_mat
  when "concrete", "rc" then _concrete_mat
  when "glass", "window" then _glass_mat
  when "wood", "timber" then _wood_mat
  else _steel_mat
  end
end

# ── IFC attributes ──
def _set_ifc(grp, mark, section, mtype)
  grp.set_attribute("IFC", "Mark",    mark)
  grp.set_attribute("IFC", "Section", section)
  grp.set_attribute("IFC", "Type",    mtype)
  grp.name = mark
end

# ── Create rectangle at transform ──
def _add_rect(_ge, _t, hw, hd)
  _raw = [[-hw, -hd], [hw, -hd], [hw, hd], [-hw, hd]]
  _face = _ge.add_face(_raw.map { |p| _t * Geom::Point3d.new(p[0].mm, p[1].mm, 0) })
  _face
end

# ======================================================================
# FLOOR: Level  (Z: 0 -> 3500 mm)
# ======================================================================

# ── Slab ──
# ── Columns (16) ──
# 35c CH* | 400x400 | col | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 35c CH*: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "35c CH*", "400x400", "column")
  end
rescue => e
  puts "SKIP 35c CH*: #{e.message}"
end

# 35c CH* | 400x400 | col | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 35c CH*: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "35c CH*", "400x400", "column")
  end
rescue => e
  puts "SKIP 35c CH*: #{e.message}"
end

# 35c CH* | 400x400 | col | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 35c CH*: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "35c CH*", "400x400", "column")
  end
rescue => e
  puts "SKIP 35c CH*: #{e.message}"
end

# 35c CH* | 400x400 | col | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 35c CH*: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "35c CH*", "400x400", "column")
  end
rescue => e
  puts "SKIP 35c CH*: #{e.message}"
end

# 36b UB | 400x400 | col | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 36b UB: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "36b UB", "400x400", "column")
  end
rescue => e
  puts "SKIP 36b UB: #{e.message}"
end

# 36b UB | 400x400 | col | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 36b UB: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "36b UB", "400x400", "column")
  end
rescue => e
  puts "SKIP 36b UB: #{e.message}"
end

# 36b UB | 400x400 | col | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 36b UB: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "36b UB", "400x400", "column")
  end
rescue => e
  puts "SKIP 36b UB: #{e.message}"
end

# 36b UB | 400x400 | col | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 36b UB: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "36b UB", "400x400", "column")
  end
rescue => e
  puts "SKIP 36b UB: #{e.message}"
end

# 36b UB | 400x400 | col | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 36b UB: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "36b UB", "400x400", "column")
  end
rescue => e
  puts "SKIP 36b UB: #{e.message}"
end

# 36b UB | 400x400 | col | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 36b UB: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "36b UB", "400x400", "column")
  end
rescue => e
  puts "SKIP 36b UB: #{e.message}"
end

# 36b UB | 400x400 | col | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 36b UB: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "36b UB", "400x400", "column")
  end
rescue => e
  puts "SKIP 36b UB: #{e.message}"
end

# 36b UB | 400x400 | col | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 36b UB: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "36b UB", "400x400", "column")
  end
rescue => e
  puts "SKIP 36b UB: #{e.message}"
end

# 36b UB | 400x400 | col | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 36b UB: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "36b UB", "400x400", "column")
  end
rescue => e
  puts "SKIP 36b UB: #{e.message}"
end

# 36b UB | 400x400 | col | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 36b UB: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "36b UB", "400x400", "column")
  end
rescue => e
  puts "SKIP 36b UB: #{e.message}"
end

# 36b UB | 400x400 | col | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 36b UB: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "36b UB", "400x400", "column")
  end
rescue => e
  puts "SKIP 36b UB: #{e.message}"
end

# 36b UB | 400x400 | col | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 36b UB: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "36b UB", "400x400", "column")
  end
rescue => e
  puts "SKIP 36b UB: #{e.message}"
end


# ── Beams (24) ──
# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end



# ======================================================================
# FLOOR: Level  (Z: 0 -> 3500 mm)
# ======================================================================

# ── Slab ──
# ── Columns (30) ──
# None | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP None: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "None", "400x400", "column")
  end
rescue => e
  puts "SKIP None: #{e.message}"
end

# None | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP None: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "None", "400x400", "column")
  end
rescue => e
  puts "SKIP None: #{e.message}"
end

# None | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP None: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "None", "400x400", "column")
  end
rescue => e
  puts "SKIP None: #{e.message}"
end

# None | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP None: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "None", "400x400", "column")
  end
rescue => e
  puts "SKIP None: #{e.message}"
end

# None | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP None: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "None", "400x400", "column")
  end
rescue => e
  puts "SKIP None: #{e.message}"
end

# None | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP None: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "None", "400x400", "column")
  end
rescue => e
  puts "SKIP None: #{e.message}"
end

# None | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP None: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "None", "400x400", "column")
  end
rescue => e
  puts "SKIP None: #{e.message}"
end

# None | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP None: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "None", "400x400", "column")
  end
rescue => e
  puts "SKIP None: #{e.message}"
end

# None | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP None: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "None", "400x400", "column")
  end
rescue => e
  puts "SKIP None: #{e.message}"
end

# None | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP None: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "None", "400x400", "column")
  end
rescue => e
  puts "SKIP None: #{e.message}"
end

# None | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP None: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "None", "400x400", "column")
  end
rescue => e
  puts "SKIP None: #{e.message}"
end

# None | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP None: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "None", "400x400", "column")
  end
rescue => e
  puts "SKIP None: #{e.message}"
end

# None | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP None: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "None", "400x400", "column")
  end
rescue => e
  puts "SKIP None: #{e.message}"
end

# None | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP None: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "None", "400x400", "column")
  end
rescue => e
  puts "SKIP None: #{e.message}"
end

# None | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP None: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "None", "400x400", "column")
  end
rescue => e
  puts "SKIP None: #{e.message}"
end

# None | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP None: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "None", "400x400", "column")
  end
rescue => e
  puts "SKIP None: #{e.message}"
end

# None | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP None: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "None", "400x400", "column")
  end
rescue => e
  puts "SKIP None: #{e.message}"
end

# None | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP None: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "None", "400x400", "column")
  end
rescue => e
  puts "SKIP None: #{e.message}"
end

# None | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP None: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "None", "400x400", "column")
  end
rescue => e
  puts "SKIP None: #{e.message}"
end

# None | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP None: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "None", "400x400", "column")
  end
rescue => e
  puts "SKIP None: #{e.message}"
end

# None | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP None: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "None", "400x400", "column")
  end
rescue => e
  puts "SKIP None: #{e.message}"
end

# None | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP None: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "None", "400x400", "column")
  end
rescue => e
  puts "SKIP None: #{e.message}"
end

# None | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP None: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "None", "400x400", "column")
  end
rescue => e
  puts "SKIP None: #{e.message}"
end

# None | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP None: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "None", "400x400", "column")
  end
rescue => e
  puts "SKIP None: #{e.message}"
end

# None | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP None: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "None", "400x400", "column")
  end
rescue => e
  puts "SKIP None: #{e.message}"
end

# None | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP None: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "None", "400x400", "column")
  end
rescue => e
  puts "SKIP None: #{e.message}"
end

# None | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP None: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "None", "400x400", "column")
  end
rescue => e
  puts "SKIP None: #{e.message}"
end

# None | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP None: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "None", "400x400", "column")
  end
rescue => e
  puts "SKIP None: #{e.message}"
end

# None | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP None: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "None", "400x400", "column")
  end
rescue => e
  puts "SKIP None: #{e.message}"
end

# None | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP None: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "None", "400x400", "column")
  end
rescue => e
  puts "SKIP None: #{e.message}"
end


# ── Beams (44) ──
# BEA | 400x400 | beam | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end


# ── Stairs (1) ──
# ST | stair | 16 steps | 1000mm wide | conf=60%
begin
  _grp = ents.add_group; _ge  = _grp.entities
  _p1 = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 0.0.mm, 0.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 300.0.mm, 0.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 300.0.mm, 0.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 300.0.mm, 218.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 300.0.mm, 218.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 600.0.mm, 218.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 600.0.mm, 218.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 600.0.mm, 437.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 600.0.mm, 437.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 900.0.mm, 437.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 900.0.mm, 437.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 900.0.mm, 656.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 900.0.mm, 656.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 1200.0.mm, 656.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 1200.0.mm, 656.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 1200.0.mm, 875.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 1200.0.mm, 875.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 1500.0.mm, 875.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 1500.0.mm, 875.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 1500.0.mm, 1093.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 1500.0.mm, 1093.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 1800.0.mm, 1093.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 1800.0.mm, 1093.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 1800.0.mm, 1312.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 1800.0.mm, 1312.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 2100.0.mm, 1312.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 2100.0.mm, 1312.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 2100.0.mm, 1531.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 2100.0.mm, 1531.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 2400.0.mm, 1531.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 2400.0.mm, 1531.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 2400.0.mm, 1750.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 2400.0.mm, 1750.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 2700.0.mm, 1750.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 2700.0.mm, 1750.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 2700.0.mm, 1968.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 2700.0.mm, 1968.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3000.0.mm, 1968.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3000.0.mm, 1968.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3000.0.mm, 2187.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3000.0.mm, 2187.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3300.0.mm, 2187.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3300.0.mm, 2187.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3300.0.mm, 2406.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3300.0.mm, 2406.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3600.0.mm, 2406.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3600.0.mm, 2406.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3600.0.mm, 2625.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3600.0.mm, 2625.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3900.0.mm, 2625.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3900.0.mm, 2625.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3900.0.mm, 2843.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3900.0.mm, 2843.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 4200.0.mm, 2843.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 4200.0.mm, 2843.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 4200.0.mm, 3062.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 4200.0.mm, 3062.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 4500.0.mm, 3062.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 4500.0.mm, 3062.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 4500.0.mm, 3281.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 4500.0.mm, 3281.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 4800.0.mm, 3281.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 4800.0.mm, 3281.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _grp.layer = layers["ARCH-Stairs"]
  _grp.material = _mat_for("Concrete")
  _set_ifc(_grp, "ST", "16risers", "stair")
rescue => e
  puts "SKIP ST: #{e.message}"
end



# ======================================================================
# FLOOR: Level  (Z: 0 -> 3500 mm)
# ======================================================================

# ── Slab ──

# ======================================================================
# FLOOR: Level  (Z: 0 -> 3500 mm)
# ======================================================================

# ── Slab ──
# ── Columns (12) ──
# 1B | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 1B: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "1B", "400x400", "column")
  end
rescue => e
  puts "SKIP 1B: #{e.message}"
end

# 1C | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 1C: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "1C", "400x400", "column")
  end
rescue => e
  puts "SKIP 1C: #{e.message}"
end

# 1D | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 1D: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "1D", "400x400", "column")
  end
rescue => e
  puts "SKIP 1D: #{e.message}"
end

# 2B | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 2B: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "2B", "400x400", "column")
  end
rescue => e
  puts "SKIP 2B: #{e.message}"
end

# 2C | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 2C: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "2C", "400x400", "column")
  end
rescue => e
  puts "SKIP 2C: #{e.message}"
end

# 2D | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 2D: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "2D", "400x400", "column")
  end
rescue => e
  puts "SKIP 2D: #{e.message}"
end

# 3B | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 3B: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "3B", "400x400", "column")
  end
rescue => e
  puts "SKIP 3B: #{e.message}"
end

# 3C | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 3C: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "3C", "400x400", "column")
  end
rescue => e
  puts "SKIP 3C: #{e.message}"
end

# 3D | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 3D: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "3D", "400x400", "column")
  end
rescue => e
  puts "SKIP 3D: #{e.message}"
end

# 4B | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 4B: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "4B", "400x400", "column")
  end
rescue => e
  puts "SKIP 4B: #{e.message}"
end

# 4C | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 4C: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "4C", "400x400", "column")
  end
rescue => e
  puts "SKIP 4C: #{e.message}"
end

# 4D | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 4D: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "4D", "400x400", "column")
  end
rescue => e
  puts "SKIP 4D: #{e.message}"
end


# ── Beams (7) ──
# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end


# ── Walls (8) ──
# WAL | wall | t=200mm | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 3000.0.mm, 0.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP WAL: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 100.0, 1500.0)
    _face.pushpull(3500.0.mm) if _face
    _grp.layer = layers["STR-Walls"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "WAL", "t=200", "wall")
  end
rescue => e
  puts "SKIP WAL: #{e.message}"
end

# WAL | wall | t=200mm | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 3000.0.mm, 0.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP WAL: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 100.0, 1500.0)
    _face.pushpull(3500.0.mm) if _face
    _grp.layer = layers["STR-Walls"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "WAL", "t=200", "wall")
  end
rescue => e
  puts "SKIP WAL: #{e.message}"
end

# WAL | wall | t=200mm | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 3000.0.mm, 0.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP WAL: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 100.0, 1500.0)
    _face.pushpull(3500.0.mm) if _face
    _grp.layer = layers["STR-Walls"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "WAL", "t=200", "wall")
  end
rescue => e
  puts "SKIP WAL: #{e.message}"
end

# WAL | wall | t=200mm | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 3000.0.mm, 0.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP WAL: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 100.0, 1500.0)
    _face.pushpull(3500.0.mm) if _face
    _grp.layer = layers["STR-Walls"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "WAL", "t=200", "wall")
  end
rescue => e
  puts "SKIP WAL: #{e.message}"
end

# WAL | wall | t=200mm | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 3000.0.mm, 0.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP WAL: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 100.0, 1500.0)
    _face.pushpull(3500.0.mm) if _face
    _grp.layer = layers["STR-Walls"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "WAL", "t=200", "wall")
  end
rescue => e
  puts "SKIP WAL: #{e.message}"
end

# WAL | wall | t=200mm | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 3000.0.mm, 0.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP WAL: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 100.0, 1500.0)
    _face.pushpull(3500.0.mm) if _face
    _grp.layer = layers["STR-Walls"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "WAL", "t=200", "wall")
  end
rescue => e
  puts "SKIP WAL: #{e.message}"
end

# WAL | wall | t=200mm | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 3000.0.mm, 0.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP WAL: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 100.0, 1500.0)
    _face.pushpull(3500.0.mm) if _face
    _grp.layer = layers["STR-Walls"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "WAL", "t=200", "wall")
  end
rescue => e
  puts "SKIP WAL: #{e.message}"
end

# WAL | wall | t=200mm | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 3000.0.mm, 0.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP WAL: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 100.0, 1500.0)
    _face.pushpull(3500.0.mm) if _face
    _grp.layer = layers["STR-Walls"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "WAL", "t=200", "wall")
  end
rescue => e
  puts "SKIP WAL: #{e.message}"
end


# ── Stairs (2) ──
# ST | stair | 16 steps | 1000mm wide | conf=70%
begin
  _grp = ents.add_group; _ge  = _grp.entities
  _p1 = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 0.0.mm, 0.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 300.0.mm, 0.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 300.0.mm, 0.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 300.0.mm, 218.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 300.0.mm, 218.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 600.0.mm, 218.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 600.0.mm, 218.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 600.0.mm, 437.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 600.0.mm, 437.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 900.0.mm, 437.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 900.0.mm, 437.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 900.0.mm, 656.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 900.0.mm, 656.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 1200.0.mm, 656.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 1200.0.mm, 656.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 1200.0.mm, 875.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 1200.0.mm, 875.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 1500.0.mm, 875.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 1500.0.mm, 875.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 1500.0.mm, 1093.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 1500.0.mm, 1093.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 1800.0.mm, 1093.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 1800.0.mm, 1093.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 1800.0.mm, 1312.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 1800.0.mm, 1312.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 2100.0.mm, 1312.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 2100.0.mm, 1312.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 2100.0.mm, 1531.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 2100.0.mm, 1531.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 2400.0.mm, 1531.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 2400.0.mm, 1531.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 2400.0.mm, 1750.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 2400.0.mm, 1750.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 2700.0.mm, 1750.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 2700.0.mm, 1750.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 2700.0.mm, 1968.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 2700.0.mm, 1968.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3000.0.mm, 1968.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3000.0.mm, 1968.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3000.0.mm, 2187.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3000.0.mm, 2187.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3300.0.mm, 2187.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3300.0.mm, 2187.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3300.0.mm, 2406.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3300.0.mm, 2406.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3600.0.mm, 2406.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3600.0.mm, 2406.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3600.0.mm, 2625.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3600.0.mm, 2625.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3900.0.mm, 2625.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3900.0.mm, 2625.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3900.0.mm, 2843.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3900.0.mm, 2843.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 4200.0.mm, 2843.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 4200.0.mm, 2843.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 4200.0.mm, 3062.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 4200.0.mm, 3062.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 4500.0.mm, 3062.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 4500.0.mm, 3062.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 4500.0.mm, 3281.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 4500.0.mm, 3281.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 4800.0.mm, 3281.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 4800.0.mm, 3281.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _grp.layer = layers["ARCH-Stairs"]
  _grp.material = _mat_for("Concrete")
  _set_ifc(_grp, "ST", "16risers", "stair")
rescue => e
  puts "SKIP ST: #{e.message}"
end

# ST | stair | 16 steps | 1000mm wide | conf=70%
begin
  _grp = ents.add_group; _ge  = _grp.entities
  _p1 = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 0.0.mm, 0.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 300.0.mm, 0.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 300.0.mm, 0.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 300.0.mm, 218.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 300.0.mm, 218.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 600.0.mm, 218.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 600.0.mm, 218.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 600.0.mm, 437.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 600.0.mm, 437.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 900.0.mm, 437.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 900.0.mm, 437.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 900.0.mm, 656.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 900.0.mm, 656.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 1200.0.mm, 656.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 1200.0.mm, 656.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 1200.0.mm, 875.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 1200.0.mm, 875.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 1500.0.mm, 875.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 1500.0.mm, 875.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 1500.0.mm, 1093.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 1500.0.mm, 1093.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 1800.0.mm, 1093.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 1800.0.mm, 1093.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 1800.0.mm, 1312.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 1800.0.mm, 1312.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 2100.0.mm, 1312.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 2100.0.mm, 1312.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 2100.0.mm, 1531.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 2100.0.mm, 1531.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 2400.0.mm, 1531.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 2400.0.mm, 1531.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 2400.0.mm, 1750.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 2400.0.mm, 1750.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 2700.0.mm, 1750.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 2700.0.mm, 1750.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 2700.0.mm, 1968.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 2700.0.mm, 1968.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3000.0.mm, 1968.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3000.0.mm, 1968.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3000.0.mm, 2187.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3000.0.mm, 2187.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3300.0.mm, 2187.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3300.0.mm, 2187.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3300.0.mm, 2406.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3300.0.mm, 2406.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3600.0.mm, 2406.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3600.0.mm, 2406.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3600.0.mm, 2625.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3600.0.mm, 2625.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3900.0.mm, 2625.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3900.0.mm, 2625.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3900.0.mm, 2843.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3900.0.mm, 2843.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 4200.0.mm, 2843.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 4200.0.mm, 2843.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 4200.0.mm, 3062.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 4200.0.mm, 3062.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 4500.0.mm, 3062.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 4500.0.mm, 3062.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 4500.0.mm, 3281.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 4500.0.mm, 3281.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 4800.0.mm, 3281.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 4800.0.mm, 3281.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _grp.layer = layers["ARCH-Stairs"]
  _grp.material = _mat_for("Concrete")
  _set_ifc(_grp, "ST", "16risers", "stair")
rescue => e
  puts "SKIP ST: #{e.message}"
end



# ======================================================================
# FLOOR: Level  (Z: 0 -> 3500 mm)
# ======================================================================

# ── Slab ──

# ======================================================================
# FLOOR: Level  (Z: 0 -> 3500 mm)
# ======================================================================

# ── Slab ──
# ── Columns (22) ──
# C1A | 400x400 | col | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP C1A: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "C1A", "400x400", "column")
  end
rescue => e
  puts "SKIP C1A: #{e.message}"
end

# C2A | 400x400 | col | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP C2A: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "C2A", "400x400", "column")
  end
rescue => e
  puts "SKIP C2A: #{e.message}"
end

# C3A | 400x400 | col | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP C3A: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "C3A", "400x400", "column")
  end
rescue => e
  puts "SKIP C3A: #{e.message}"
end

# C4A | 400x400 | col | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP C4A: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "C4A", "400x400", "column")
  end
rescue => e
  puts "SKIP C4A: #{e.message}"
end

# C1B | 400x400 | col | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP C1B: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "C1B", "400x400", "column")
  end
rescue => e
  puts "SKIP C1B: #{e.message}"
end

# C2B | 400x400 | col | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP C2B: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "C2B", "400x400", "column")
  end
rescue => e
  puts "SKIP C2B: #{e.message}"
end

# C_core_2.5B_L | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP C_core_2.5B_L: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "C_core_2.5B_L", "400x400", "column")
  end
rescue => e
  puts "SKIP C_core_2.5B_L: #{e.message}"
end

# C_core_2.5B_R | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP C_core_2.5B_R: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "C_core_2.5B_R", "400x400", "column")
  end
rescue => e
  puts "SKIP C_core_2.5B_R: #{e.message}"
end

# C3B | 400x400 | col | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP C3B: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "C3B", "400x400", "column")
  end
rescue => e
  puts "SKIP C3B: #{e.message}"
end

# C4B | 400x400 | col | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP C4B: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "C4B", "400x400", "column")
  end
rescue => e
  puts "SKIP C4B: #{e.message}"
end

# C1C | 400x400 | col | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP C1C: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "C1C", "400x400", "column")
  end
rescue => e
  puts "SKIP C1C: #{e.message}"
end

# C2C | 400x400 | col | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP C2C: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "C2C", "400x400", "column")
  end
rescue => e
  puts "SKIP C2C: #{e.message}"
end

# C_core_2.5C_L | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP C_core_2.5C_L: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "C_core_2.5C_L", "400x400", "column")
  end
rescue => e
  puts "SKIP C_core_2.5C_L: #{e.message}"
end

# C_core_2.5C_R | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP C_core_2.5C_R: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "C_core_2.5C_R", "400x400", "column")
  end
rescue => e
  puts "SKIP C_core_2.5C_R: #{e.message}"
end

# C3C | 400x400 | col | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP C3C: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "C3C", "400x400", "column")
  end
rescue => e
  puts "SKIP C3C: #{e.message}"
end

# C4C | 400x400 | col | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP C4C: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "C4C", "400x400", "column")
  end
rescue => e
  puts "SKIP C4C: #{e.message}"
end

# C1D | 400x400 | col | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP C1D: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "C1D", "400x400", "column")
  end
rescue => e
  puts "SKIP C1D: #{e.message}"
end

# C2D | 400x400 | col | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP C2D: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "C2D", "400x400", "column")
  end
rescue => e
  puts "SKIP C2D: #{e.message}"
end

# C_core_2.5D_L | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP C_core_2.5D_L: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "C_core_2.5D_L", "400x400", "column")
  end
rescue => e
  puts "SKIP C_core_2.5D_L: #{e.message}"
end

# C_core_2.5D_R | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP C_core_2.5D_R: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "C_core_2.5D_R", "400x400", "column")
  end
rescue => e
  puts "SKIP C_core_2.5D_R: #{e.message}"
end

# C3D | 400x400 | col | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP C3D: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "C3D", "400x400", "column")
  end
rescue => e
  puts "SKIP C3D: #{e.message}"
end

# C4D | 400x400 | col | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP C4D: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "C4D", "400x400", "column")
  end
rescue => e
  puts "SKIP C4D: #{e.message}"
end


# ── Beams (30) ──
# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=60%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=60%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=60%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=60%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=60%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=60%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=60%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=60%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=60%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=60%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=60%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=60%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=60%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=60%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end

# BEA | 400x400 | beam | conf=60%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP BEA: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "BEA", "400x400", "beam")
  end
rescue => e
  puts "SKIP BEA: #{e.message}"
end


# ── Stairs (5) ──
# ST | stair | 16 steps | 1000mm wide | conf=80%
begin
  _grp = ents.add_group; _ge  = _grp.entities
  _p1 = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 0.0.mm, 0.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 300.0.mm, 0.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 300.0.mm, 0.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 300.0.mm, 218.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 300.0.mm, 218.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 600.0.mm, 218.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 600.0.mm, 218.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 600.0.mm, 437.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 600.0.mm, 437.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 900.0.mm, 437.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 900.0.mm, 437.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 900.0.mm, 656.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 900.0.mm, 656.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 1200.0.mm, 656.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 1200.0.mm, 656.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 1200.0.mm, 875.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 1200.0.mm, 875.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 1500.0.mm, 875.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 1500.0.mm, 875.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 1500.0.mm, 1093.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 1500.0.mm, 1093.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 1800.0.mm, 1093.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 1800.0.mm, 1093.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 1800.0.mm, 1312.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 1800.0.mm, 1312.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 2100.0.mm, 1312.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 2100.0.mm, 1312.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 2100.0.mm, 1531.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 2100.0.mm, 1531.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 2400.0.mm, 1531.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 2400.0.mm, 1531.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 2400.0.mm, 1750.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 2400.0.mm, 1750.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 2700.0.mm, 1750.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 2700.0.mm, 1750.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 2700.0.mm, 1968.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 2700.0.mm, 1968.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3000.0.mm, 1968.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3000.0.mm, 1968.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3000.0.mm, 2187.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3000.0.mm, 2187.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3300.0.mm, 2187.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3300.0.mm, 2187.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3300.0.mm, 2406.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3300.0.mm, 2406.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3600.0.mm, 2406.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3600.0.mm, 2406.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3600.0.mm, 2625.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3600.0.mm, 2625.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3900.0.mm, 2625.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3900.0.mm, 2625.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3900.0.mm, 2843.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3900.0.mm, 2843.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 4200.0.mm, 2843.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 4200.0.mm, 2843.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 4200.0.mm, 3062.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 4200.0.mm, 3062.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 4500.0.mm, 3062.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 4500.0.mm, 3062.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 4500.0.mm, 3281.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 4500.0.mm, 3281.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 4800.0.mm, 3281.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 4800.0.mm, 3281.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _grp.layer = layers["ARCH-Stairs"]
  _grp.material = _mat_for("Concrete")
  _set_ifc(_grp, "ST", "16risers", "stair")
rescue => e
  puts "SKIP ST: #{e.message}"
end

# ST | stair | 16 steps | 1000mm wide | conf=80%
begin
  _grp = ents.add_group; _ge  = _grp.entities
  _p1 = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 0.0.mm, 0.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 300.0.mm, 0.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 300.0.mm, 0.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 300.0.mm, 218.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 300.0.mm, 218.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 600.0.mm, 218.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 600.0.mm, 218.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 600.0.mm, 437.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 600.0.mm, 437.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 900.0.mm, 437.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 900.0.mm, 437.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 900.0.mm, 656.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 900.0.mm, 656.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 1200.0.mm, 656.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 1200.0.mm, 656.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 1200.0.mm, 875.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 1200.0.mm, 875.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 1500.0.mm, 875.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 1500.0.mm, 875.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 1500.0.mm, 1093.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 1500.0.mm, 1093.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 1800.0.mm, 1093.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 1800.0.mm, 1093.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 1800.0.mm, 1312.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 1800.0.mm, 1312.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 2100.0.mm, 1312.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 2100.0.mm, 1312.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 2100.0.mm, 1531.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 2100.0.mm, 1531.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 2400.0.mm, 1531.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 2400.0.mm, 1531.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 2400.0.mm, 1750.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 2400.0.mm, 1750.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 2700.0.mm, 1750.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 2700.0.mm, 1750.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 2700.0.mm, 1968.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 2700.0.mm, 1968.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3000.0.mm, 1968.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3000.0.mm, 1968.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3000.0.mm, 2187.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3000.0.mm, 2187.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3300.0.mm, 2187.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3300.0.mm, 2187.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3300.0.mm, 2406.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3300.0.mm, 2406.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3600.0.mm, 2406.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3600.0.mm, 2406.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3600.0.mm, 2625.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3600.0.mm, 2625.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3900.0.mm, 2625.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3900.0.mm, 2625.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3900.0.mm, 2843.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3900.0.mm, 2843.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 4200.0.mm, 2843.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 4200.0.mm, 2843.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 4200.0.mm, 3062.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 4200.0.mm, 3062.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 4500.0.mm, 3062.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 4500.0.mm, 3062.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 4500.0.mm, 3281.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 4500.0.mm, 3281.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 4800.0.mm, 3281.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 4800.0.mm, 3281.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _grp.layer = layers["ARCH-Stairs"]
  _grp.material = _mat_for("Concrete")
  _set_ifc(_grp, "ST", "16risers", "stair")
rescue => e
  puts "SKIP ST: #{e.message}"
end

# ST | stair | 16 steps | 1000mm wide | conf=80%
begin
  _grp = ents.add_group; _ge  = _grp.entities
  _p1 = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 0.0.mm, 0.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 300.0.mm, 0.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 300.0.mm, 0.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 300.0.mm, 218.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 300.0.mm, 218.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 600.0.mm, 218.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 600.0.mm, 218.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 600.0.mm, 437.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 600.0.mm, 437.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 900.0.mm, 437.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 900.0.mm, 437.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 900.0.mm, 656.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 900.0.mm, 656.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 1200.0.mm, 656.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 1200.0.mm, 656.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 1200.0.mm, 875.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 1200.0.mm, 875.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 1500.0.mm, 875.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 1500.0.mm, 875.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 1500.0.mm, 1093.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 1500.0.mm, 1093.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 1800.0.mm, 1093.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 1800.0.mm, 1093.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 1800.0.mm, 1312.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 1800.0.mm, 1312.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 2100.0.mm, 1312.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 2100.0.mm, 1312.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 2100.0.mm, 1531.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 2100.0.mm, 1531.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 2400.0.mm, 1531.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 2400.0.mm, 1531.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 2400.0.mm, 1750.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 2400.0.mm, 1750.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 2700.0.mm, 1750.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 2700.0.mm, 1750.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 2700.0.mm, 1968.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 2700.0.mm, 1968.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3000.0.mm, 1968.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3000.0.mm, 1968.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3000.0.mm, 2187.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3000.0.mm, 2187.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3300.0.mm, 2187.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3300.0.mm, 2187.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3300.0.mm, 2406.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3300.0.mm, 2406.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3600.0.mm, 2406.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3600.0.mm, 2406.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3600.0.mm, 2625.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3600.0.mm, 2625.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3900.0.mm, 2625.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3900.0.mm, 2625.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3900.0.mm, 2843.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3900.0.mm, 2843.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 4200.0.mm, 2843.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 4200.0.mm, 2843.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 4200.0.mm, 3062.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 4200.0.mm, 3062.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 4500.0.mm, 3062.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 4500.0.mm, 3062.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 4500.0.mm, 3281.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 4500.0.mm, 3281.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 4800.0.mm, 3281.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 4800.0.mm, 3281.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _grp.layer = layers["ARCH-Stairs"]
  _grp.material = _mat_for("Concrete")
  _set_ifc(_grp, "ST", "16risers", "stair")
rescue => e
  puts "SKIP ST: #{e.message}"
end

# ST | stair | 16 steps | 1000mm wide | conf=80%
begin
  _grp = ents.add_group; _ge  = _grp.entities
  _p1 = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 0.0.mm, 0.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 300.0.mm, 0.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 300.0.mm, 0.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 300.0.mm, 218.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 300.0.mm, 218.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 600.0.mm, 218.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 600.0.mm, 218.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 600.0.mm, 437.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 600.0.mm, 437.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 900.0.mm, 437.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 900.0.mm, 437.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 900.0.mm, 656.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 900.0.mm, 656.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 1200.0.mm, 656.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 1200.0.mm, 656.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 1200.0.mm, 875.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 1200.0.mm, 875.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 1500.0.mm, 875.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 1500.0.mm, 875.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 1500.0.mm, 1093.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 1500.0.mm, 1093.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 1800.0.mm, 1093.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 1800.0.mm, 1093.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 1800.0.mm, 1312.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 1800.0.mm, 1312.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 2100.0.mm, 1312.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 2100.0.mm, 1312.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 2100.0.mm, 1531.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 2100.0.mm, 1531.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 2400.0.mm, 1531.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 2400.0.mm, 1531.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 2400.0.mm, 1750.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 2400.0.mm, 1750.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 2700.0.mm, 1750.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 2700.0.mm, 1750.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 2700.0.mm, 1968.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 2700.0.mm, 1968.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3000.0.mm, 1968.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3000.0.mm, 1968.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3000.0.mm, 2187.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3000.0.mm, 2187.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3300.0.mm, 2187.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3300.0.mm, 2187.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3300.0.mm, 2406.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3300.0.mm, 2406.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3600.0.mm, 2406.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3600.0.mm, 2406.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3600.0.mm, 2625.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3600.0.mm, 2625.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3900.0.mm, 2625.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3900.0.mm, 2625.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3900.0.mm, 2843.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3900.0.mm, 2843.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 4200.0.mm, 2843.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 4200.0.mm, 2843.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 4200.0.mm, 3062.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 4200.0.mm, 3062.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 4500.0.mm, 3062.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 4500.0.mm, 3062.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 4500.0.mm, 3281.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 4500.0.mm, 3281.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 4800.0.mm, 3281.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 4800.0.mm, 3281.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _grp.layer = layers["ARCH-Stairs"]
  _grp.material = _mat_for("Concrete")
  _set_ifc(_grp, "ST", "16risers", "stair")
rescue => e
  puts "SKIP ST: #{e.message}"
end

# ST | stair | 16 steps | 1000mm wide | conf=80%
begin
  _grp = ents.add_group; _ge  = _grp.entities
  _p1 = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 0.0.mm, 0.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 300.0.mm, 0.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 300.0.mm, 0.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 300.0.mm, 218.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 300.0.mm, 218.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 600.0.mm, 218.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 600.0.mm, 218.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 600.0.mm, 437.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 600.0.mm, 437.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 900.0.mm, 437.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 900.0.mm, 437.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 900.0.mm, 656.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 900.0.mm, 656.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 1200.0.mm, 656.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 1200.0.mm, 656.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 1200.0.mm, 875.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 1200.0.mm, 875.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 1500.0.mm, 875.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 1500.0.mm, 875.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 1500.0.mm, 1093.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 1500.0.mm, 1093.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 1800.0.mm, 1093.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 1800.0.mm, 1093.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 1800.0.mm, 1312.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 1800.0.mm, 1312.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 2100.0.mm, 1312.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 2100.0.mm, 1312.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 2100.0.mm, 1531.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 2100.0.mm, 1531.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 2400.0.mm, 1531.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 2400.0.mm, 1531.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 2400.0.mm, 1750.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 2400.0.mm, 1750.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 2700.0.mm, 1750.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 2700.0.mm, 1750.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 2700.0.mm, 1968.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 2700.0.mm, 1968.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3000.0.mm, 1968.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3000.0.mm, 1968.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3000.0.mm, 2187.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3000.0.mm, 2187.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3300.0.mm, 2187.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3300.0.mm, 2187.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3300.0.mm, 2406.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3300.0.mm, 2406.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3600.0.mm, 2406.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3600.0.mm, 2406.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3600.0.mm, 2625.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3600.0.mm, 2625.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3900.0.mm, 2625.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3900.0.mm, 2625.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3900.0.mm, 2843.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3900.0.mm, 2843.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 4200.0.mm, 2843.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 4200.0.mm, 2843.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 4200.0.mm, 3062.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 4200.0.mm, 3062.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 4500.0.mm, 3062.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 4500.0.mm, 3062.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 4500.0.mm, 3281.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 4500.0.mm, 3281.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 4800.0.mm, 3281.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 4800.0.mm, 3281.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _grp.layer = layers["ARCH-Stairs"]
  _grp.material = _mat_for("Concrete")
  _set_ifc(_grp, "ST", "16risers", "stair")
rescue => e
  puts "SKIP ST: #{e.message}"
end



# ======================================================================
# FLOOR: Level  (Z: 0 -> 3500 mm)
# ======================================================================

# ── Slab ──

# ======================================================================
# FLOOR: Level  (Z: 0 -> 3500 mm)
# ======================================================================

# ── Slab ──
# ── Columns (29) ──
# 1A | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 1A: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "1A", "400x400", "column")
  end
rescue => e
  puts "SKIP 1A: #{e.message}"
end

# 1B | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 1B: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "1B", "400x400", "column")
  end
rescue => e
  puts "SKIP 1B: #{e.message}"
end

# 1C | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 1C: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "1C", "400x400", "column")
  end
rescue => e
  puts "SKIP 1C: #{e.message}"
end

# 1D | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 1D: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "1D", "400x400", "column")
  end
rescue => e
  puts "SKIP 1D: #{e.message}"
end

# 2A | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 2A: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "2A", "400x400", "column")
  end
rescue => e
  puts "SKIP 2A: #{e.message}"
end

# 2B | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 2B: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "2B", "400x400", "column")
  end
rescue => e
  puts "SKIP 2B: #{e.message}"
end

# 2C | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 2C: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "2C", "400x400", "column")
  end
rescue => e
  puts "SKIP 2C: #{e.message}"
end

# 2D | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 2D: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "2D", "400x400", "column")
  end
rescue => e
  puts "SKIP 2D: #{e.message}"
end

# 3A | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 3A: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "3A", "400x400", "column")
  end
rescue => e
  puts "SKIP 3A: #{e.message}"
end

# 3B | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 3B: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "3B", "400x400", "column")
  end
rescue => e
  puts "SKIP 3B: #{e.message}"
end

# 3C | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 3C: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "3C", "400x400", "column")
  end
rescue => e
  puts "SKIP 3C: #{e.message}"
end

# 3D | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 3D: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "3D", "400x400", "column")
  end
rescue => e
  puts "SKIP 3D: #{e.message}"
end

# 4A | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 4A: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "4A", "400x400", "column")
  end
rescue => e
  puts "SKIP 4A: #{e.message}"
end

# 4B | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 4B: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "4B", "400x400", "column")
  end
rescue => e
  puts "SKIP 4B: #{e.message}"
end

# 4C | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 4C: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "4C", "400x400", "column")
  end
rescue => e
  puts "SKIP 4C: #{e.message}"
end

# 4D | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 4D: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "4D", "400x400", "column")
  end
rescue => e
  puts "SKIP 4D: #{e.message}"
end

# 3.5A | 400x400 | col | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 3.5A: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "3.5A", "400x400", "column")
  end
rescue => e
  puts "SKIP 3.5A: #{e.message}"
end

# 3.5D | 400x400 | col | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 3.5D: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "3.5D", "400x400", "column")
  end
rescue => e
  puts "SKIP 3.5D: #{e.message}"
end

# 4(A-B) | 400x400 | col | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 4(A-B): zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "4(A-B)", "400x400", "column")
  end
rescue => e
  puts "SKIP 4(A-B): #{e.message}"
end

# 4(B-C) | 400x400 | col | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 4(B-C): zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "4(B-C)", "400x400", "column")
  end
rescue => e
  puts "SKIP 4(B-C): #{e.message}"
end

# 4(C-D) | 400x400 | col | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP 4(C-D): zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "4(C-D)", "400x400", "column")
  end
rescue => e
  puts "SKIP 4(C-D): #{e.message}"
end

# CoreTL | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP CoreTL: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "CoreTL", "400x400", "column")
  end
rescue => e
  puts "SKIP CoreTL: #{e.message}"
end

# CoreTR | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP CoreTR: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "CoreTR", "400x400", "column")
  end
rescue => e
  puts "SKIP CoreTR: #{e.message}"
end

# CoreBL | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP CoreBL: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "CoreBL", "400x400", "column")
  end
rescue => e
  puts "SKIP CoreBL: #{e.message}"
end

# CoreBR | 400x400 | col | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP CoreBR: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "CoreBR", "400x400", "column")
  end
rescue => e
  puts "SKIP CoreBR: #{e.message}"
end

# CoreT_mid | 400x400 | col | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP CoreT_mid: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "CoreT_mid", "400x400", "column")
  end
rescue => e
  puts "SKIP CoreT_mid: #{e.message}"
end

# CoreB_mid | 400x400 | col | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP CoreB_mid: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "CoreB_mid", "400x400", "column")
  end
rescue => e
  puts "SKIP CoreB_mid: #{e.message}"
end

# CoreL_mid | 400x400 | col | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP CoreL_mid: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "CoreL_mid", "400x400", "column")
  end
rescue => e
  puts "SKIP CoreL_mid: #{e.message}"
end

# CoreR_mid | 400x400 | col | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP CoreR_mid: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "CoreR_mid", "400x400", "column")
  end
rescue => e
  puts "SKIP CoreR_mid: #{e.message}"
end


# ── Walls (9) ──
# WAL | wall | t=200mm | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 3000.0.mm, 0.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP WAL: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 100.0, 1500.0)
    _face.pushpull(3500.0.mm) if _face
    _grp.layer = layers["STR-Walls"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "WAL", "t=200", "wall")
  end
rescue => e
  puts "SKIP WAL: #{e.message}"
end

# WAL | wall | t=200mm | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 3000.0.mm, 0.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP WAL: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 100.0, 1500.0)
    _face.pushpull(3500.0.mm) if _face
    _grp.layer = layers["STR-Walls"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "WAL", "t=200", "wall")
  end
rescue => e
  puts "SKIP WAL: #{e.message}"
end

# WAL | wall | t=200mm | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 3000.0.mm, 0.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP WAL: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 100.0, 1500.0)
    _face.pushpull(3500.0.mm) if _face
    _grp.layer = layers["STR-Walls"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "WAL", "t=200", "wall")
  end
rescue => e
  puts "SKIP WAL: #{e.message}"
end

# WAL | wall | t=200mm | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 3000.0.mm, 0.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP WAL: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 100.0, 1500.0)
    _face.pushpull(3500.0.mm) if _face
    _grp.layer = layers["STR-Walls"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "WAL", "t=200", "wall")
  end
rescue => e
  puts "SKIP WAL: #{e.message}"
end

# WAL | wall | t=200mm | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 3000.0.mm, 0.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP WAL: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 100.0, 1500.0)
    _face.pushpull(3500.0.mm) if _face
    _grp.layer = layers["STR-Walls"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "WAL", "t=200", "wall")
  end
rescue => e
  puts "SKIP WAL: #{e.message}"
end

# WAL | wall | t=200mm | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 3000.0.mm, 0.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP WAL: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 100.0, 1500.0)
    _face.pushpull(3500.0.mm) if _face
    _grp.layer = layers["STR-Walls"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "WAL", "t=200", "wall")
  end
rescue => e
  puts "SKIP WAL: #{e.message}"
end

# WAL | wall | t=200mm | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 3000.0.mm, 0.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP WAL: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 100.0, 1500.0)
    _face.pushpull(3500.0.mm) if _face
    _grp.layer = layers["STR-Walls"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "WAL", "t=200", "wall")
  end
rescue => e
  puts "SKIP WAL: #{e.message}"
end

# WAL | wall | t=200mm | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 3000.0.mm, 0.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP WAL: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 100.0, 1500.0)
    _face.pushpull(3500.0.mm) if _face
    _grp.layer = layers["STR-Walls"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "WAL", "t=200", "wall")
  end
rescue => e
  puts "SKIP WAL: #{e.message}"
end

# WAL | wall | t=200mm | conf=70%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 3000.0.mm, 0.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP WAL: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 100.0, 1500.0)
    _face.pushpull(3500.0.mm) if _face
    _grp.layer = layers["STR-Walls"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "WAL", "t=200", "wall")
  end
rescue => e
  puts "SKIP WAL: #{e.message}"
end


# ── Stairs (1) ──
# ST | stair | 16 steps | 1000mm wide | conf=90%
begin
  _grp = ents.add_group; _ge  = _grp.entities
  _p1 = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 0.0.mm, 0.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 300.0.mm, 0.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 300.0.mm, 0.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 300.0.mm, 218.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 300.0.mm, 218.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 600.0.mm, 218.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 600.0.mm, 218.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 600.0.mm, 437.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 600.0.mm, 437.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 900.0.mm, 437.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 900.0.mm, 437.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 900.0.mm, 656.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 900.0.mm, 656.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 1200.0.mm, 656.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 1200.0.mm, 656.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 1200.0.mm, 875.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 1200.0.mm, 875.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 1500.0.mm, 875.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 1500.0.mm, 875.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 1500.0.mm, 1093.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 1500.0.mm, 1093.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 1800.0.mm, 1093.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 1800.0.mm, 1093.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 1800.0.mm, 1312.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 1800.0.mm, 1312.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 2100.0.mm, 1312.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 2100.0.mm, 1312.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 2100.0.mm, 1531.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 2100.0.mm, 1531.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 2400.0.mm, 1531.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 2400.0.mm, 1531.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 2400.0.mm, 1750.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 2400.0.mm, 1750.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 2700.0.mm, 1750.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 2700.0.mm, 1750.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 2700.0.mm, 1968.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 2700.0.mm, 1968.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3000.0.mm, 1968.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3000.0.mm, 1968.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3000.0.mm, 2187.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3000.0.mm, 2187.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3300.0.mm, 2187.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3300.0.mm, 2187.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3300.0.mm, 2406.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3300.0.mm, 2406.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3600.0.mm, 2406.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3600.0.mm, 2406.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3600.0.mm, 2625.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3600.0.mm, 2625.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3900.0.mm, 2625.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3900.0.mm, 2625.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3900.0.mm, 2843.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3900.0.mm, 2843.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 4200.0.mm, 2843.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 4200.0.mm, 2843.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 4200.0.mm, 3062.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 4200.0.mm, 3062.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 4500.0.mm, 3062.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 4500.0.mm, 3062.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 4500.0.mm, 3281.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 4500.0.mm, 3281.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 4800.0.mm, 3281.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 4800.0.mm, 3281.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _grp.layer = layers["ARCH-Stairs"]
  _grp.material = _mat_for("Concrete")
  _set_ifc(_grp, "ST", "16risers", "stair")
rescue => e
  puts "SKIP ST: #{e.message}"
end



# ======================================================================
# FLOOR: Level  (Z: 0 -> 3500 mm)
# ======================================================================

# ── Slab ──

# ======================================================================
# FLOOR: Level  (Z: 0 -> 3500 mm)
# ======================================================================

# ── Slab ──

# ======================================================================
# FLOOR: Level  (Z: 0 -> 3500 mm)
# ======================================================================

# ── Slab ──
# ── Stairs (3) ──
# ST | stair | 16 steps | 1000mm wide | conf=70%
begin
  _grp = ents.add_group; _ge  = _grp.entities
  _p1 = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 0.0.mm, 0.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 300.0.mm, 0.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 300.0.mm, 0.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 300.0.mm, 218.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 300.0.mm, 218.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 600.0.mm, 218.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 600.0.mm, 218.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 600.0.mm, 437.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 600.0.mm, 437.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 900.0.mm, 437.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 900.0.mm, 437.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 900.0.mm, 656.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 900.0.mm, 656.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 1200.0.mm, 656.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 1200.0.mm, 656.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 1200.0.mm, 875.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 1200.0.mm, 875.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 1500.0.mm, 875.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 1500.0.mm, 875.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 1500.0.mm, 1093.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 1500.0.mm, 1093.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 1800.0.mm, 1093.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 1800.0.mm, 1093.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 1800.0.mm, 1312.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 1800.0.mm, 1312.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 2100.0.mm, 1312.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 2100.0.mm, 1312.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 2100.0.mm, 1531.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 2100.0.mm, 1531.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 2400.0.mm, 1531.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 2400.0.mm, 1531.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 2400.0.mm, 1750.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 2400.0.mm, 1750.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 2700.0.mm, 1750.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 2700.0.mm, 1750.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 2700.0.mm, 1968.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 2700.0.mm, 1968.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3000.0.mm, 1968.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3000.0.mm, 1968.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3000.0.mm, 2187.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3000.0.mm, 2187.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3300.0.mm, 2187.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3300.0.mm, 2187.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3300.0.mm, 2406.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3300.0.mm, 2406.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3600.0.mm, 2406.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3600.0.mm, 2406.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3600.0.mm, 2625.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3600.0.mm, 2625.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3900.0.mm, 2625.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3900.0.mm, 2625.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3900.0.mm, 2843.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3900.0.mm, 2843.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 4200.0.mm, 2843.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 4200.0.mm, 2843.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 4200.0.mm, 3062.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 4200.0.mm, 3062.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 4500.0.mm, 3062.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 4500.0.mm, 3062.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 4500.0.mm, 3281.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 4500.0.mm, 3281.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 4800.0.mm, 3281.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 4800.0.mm, 3281.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _grp.layer = layers["ARCH-Stairs"]
  _grp.material = _mat_for("Concrete")
  _set_ifc(_grp, "ST", "16risers", "stair")
rescue => e
  puts "SKIP ST: #{e.message}"
end

# ST | stair | 16 steps | 1000mm wide | conf=70%
begin
  _grp = ents.add_group; _ge  = _grp.entities
  _p1 = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 0.0.mm, 0.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 300.0.mm, 0.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 300.0.mm, 0.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 300.0.mm, 218.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 300.0.mm, 218.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 600.0.mm, 218.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 600.0.mm, 218.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 600.0.mm, 437.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 600.0.mm, 437.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 900.0.mm, 437.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 900.0.mm, 437.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 900.0.mm, 656.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 900.0.mm, 656.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 1200.0.mm, 656.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 1200.0.mm, 656.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 1200.0.mm, 875.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 1200.0.mm, 875.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 1500.0.mm, 875.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 1500.0.mm, 875.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 1500.0.mm, 1093.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 1500.0.mm, 1093.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 1800.0.mm, 1093.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 1800.0.mm, 1093.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 1800.0.mm, 1312.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 1800.0.mm, 1312.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 2100.0.mm, 1312.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 2100.0.mm, 1312.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 2100.0.mm, 1531.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 2100.0.mm, 1531.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 2400.0.mm, 1531.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 2400.0.mm, 1531.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 2400.0.mm, 1750.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 2400.0.mm, 1750.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 2700.0.mm, 1750.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 2700.0.mm, 1750.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 2700.0.mm, 1968.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 2700.0.mm, 1968.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3000.0.mm, 1968.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3000.0.mm, 1968.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3000.0.mm, 2187.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3000.0.mm, 2187.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3300.0.mm, 2187.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3300.0.mm, 2187.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3300.0.mm, 2406.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3300.0.mm, 2406.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3600.0.mm, 2406.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3600.0.mm, 2406.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3600.0.mm, 2625.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3600.0.mm, 2625.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3900.0.mm, 2625.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3900.0.mm, 2625.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3900.0.mm, 2843.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3900.0.mm, 2843.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 4200.0.mm, 2843.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 4200.0.mm, 2843.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 4200.0.mm, 3062.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 4200.0.mm, 3062.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 4500.0.mm, 3062.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 4500.0.mm, 3062.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 4500.0.mm, 3281.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 4500.0.mm, 3281.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 4800.0.mm, 3281.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 4800.0.mm, 3281.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _grp.layer = layers["ARCH-Stairs"]
  _grp.material = _mat_for("Concrete")
  _set_ifc(_grp, "ST", "16risers", "stair")
rescue => e
  puts "SKIP ST: #{e.message}"
end

# ST | stair | 16 steps | 1000mm wide | conf=70%
begin
  _grp = ents.add_group; _ge  = _grp.entities
  _p1 = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 0.0.mm, 0.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 300.0.mm, 0.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 300.0.mm, 0.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 300.0.mm, 218.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 300.0.mm, 218.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 600.0.mm, 218.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 600.0.mm, 218.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 600.0.mm, 437.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 600.0.mm, 437.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 900.0.mm, 437.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 900.0.mm, 437.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 900.0.mm, 656.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 900.0.mm, 656.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 1200.0.mm, 656.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 1200.0.mm, 656.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 1200.0.mm, 875.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 1200.0.mm, 875.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 1500.0.mm, 875.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 1500.0.mm, 875.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 1500.0.mm, 1093.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 1500.0.mm, 1093.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 1800.0.mm, 1093.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 1800.0.mm, 1093.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 1800.0.mm, 1312.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 1800.0.mm, 1312.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 2100.0.mm, 1312.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 2100.0.mm, 1312.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 2100.0.mm, 1531.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 2100.0.mm, 1531.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 2400.0.mm, 1531.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 2400.0.mm, 1531.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 2400.0.mm, 1750.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 2400.0.mm, 1750.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 2700.0.mm, 1750.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 2700.0.mm, 1750.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 2700.0.mm, 1968.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 2700.0.mm, 1968.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3000.0.mm, 1968.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3000.0.mm, 1968.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3000.0.mm, 2187.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3000.0.mm, 2187.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3300.0.mm, 2187.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3300.0.mm, 2187.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3300.0.mm, 2406.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3300.0.mm, 2406.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3600.0.mm, 2406.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3600.0.mm, 2406.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3600.0.mm, 2625.0.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3600.0.mm, 2625.0.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 3900.0.mm, 2625.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3900.0.mm, 2625.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 3900.0.mm, 2843.8.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 3900.0.mm, 2843.8.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 4200.0.mm, 2843.8.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 4200.0.mm, 2843.8.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 4200.0.mm, 3062.5.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 4200.0.mm, 3062.5.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 4500.0.mm, 3062.5.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 4500.0.mm, 3062.5.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _p1 = Geom::Point3d.new(0.0.mm, 4500.0.mm, 3281.2.mm)
  _p2 = Geom::Point3d.new(1000.0.mm, 4500.0.mm, 3281.2.mm)
  _p3 = Geom::Point3d.new(1000.0.mm, 4800.0.mm, 3281.2.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 4800.0.mm, 3281.2.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(218.8.mm) if _f
  _grp.layer = layers["ARCH-Stairs"]
  _grp.material = _mat_for("Concrete")
  _set_ifc(_grp, "ST", "16risers", "stair")
rescue => e
  puts "SKIP ST: #{e.message}"
end



# ======================================================================
# FLOOR: Level  (Z: 0 -> 3500 mm)
# ======================================================================

# ── Slab ──
# ── Columns (24) ──
# P1 | 400x400 | col | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP P1: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "P1", "400x400", "column")
  end
rescue => e
  puts "SKIP P1: #{e.message}"
end

# P4 | 400x400 | col | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP P4: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "P4", "400x400", "column")
  end
rescue => e
  puts "SKIP P4: #{e.message}"
end

# P4 | 400x400 | col | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP P4: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "P4", "400x400", "column")
  end
rescue => e
  puts "SKIP P4: #{e.message}"
end

# P2 | 400x400 | col | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP P2: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "P2", "400x400", "column")
  end
rescue => e
  puts "SKIP P2: #{e.message}"
end

# P1 | 400x400 | col | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP P1: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "P1", "400x400", "column")
  end
rescue => e
  puts "SKIP P1: #{e.message}"
end

# P4 | 400x400 | col | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP P4: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "P4", "400x400", "column")
  end
rescue => e
  puts "SKIP P4: #{e.message}"
end

# P4 | 400x400 | col | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP P4: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "P4", "400x400", "column")
  end
rescue => e
  puts "SKIP P4: #{e.message}"
end

# P2 | 400x400 | col | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP P2: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "P2", "400x400", "column")
  end
rescue => e
  puts "SKIP P2: #{e.message}"
end

# P1 | 400x400 | col | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP P1: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "P1", "400x400", "column")
  end
rescue => e
  puts "SKIP P1: #{e.message}"
end

# P4 | 400x400 | col | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP P4: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "P4", "400x400", "column")
  end
rescue => e
  puts "SKIP P4: #{e.message}"
end

# P4 | 400x400 | col | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP P4: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "P4", "400x400", "column")
  end
rescue => e
  puts "SKIP P4: #{e.message}"
end

# P2 | 400x400 | col | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP P2: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "P2", "400x400", "column")
  end
rescue => e
  puts "SKIP P2: #{e.message}"
end

# P1 | 400x400 | col | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP P1: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "P1", "400x400", "column")
  end
rescue => e
  puts "SKIP P1: #{e.message}"
end

# P4 | 400x400 | col | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP P4: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "P4", "400x400", "column")
  end
rescue => e
  puts "SKIP P4: #{e.message}"
end

# P4 | 400x400 | col | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP P4: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "P4", "400x400", "column")
  end
rescue => e
  puts "SKIP P4: #{e.message}"
end

# P2 | 400x400 | col | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP P2: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "P2", "400x400", "column")
  end
rescue => e
  puts "SKIP P2: #{e.message}"
end

# P5 | 400x400 | col | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP P5: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "P5", "400x400", "column")
  end
rescue => e
  puts "SKIP P5: #{e.message}"
end

# P5 | 400x400 | col | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP P5: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "P5", "400x400", "column")
  end
rescue => e
  puts "SKIP P5: #{e.message}"
end

# P5 | 400x400 | col | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP P5: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "P5", "400x400", "column")
  end
rescue => e
  puts "SKIP P5: #{e.message}"
end

# P5 | 400x400 | col | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP P5: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "P5", "400x400", "column")
  end
rescue => e
  puts "SKIP P5: #{e.message}"
end

# P5 | 400x400 | col | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP P5: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "P5", "400x400", "column")
  end
rescue => e
  puts "SKIP P5: #{e.message}"
end

# P5 | 400x400 | col | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP P5: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "P5", "400x400", "column")
  end
rescue => e
  puts "SKIP P5: #{e.message}"
end

# P5 | 400x400 | col | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP P5: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "P5", "400x400", "column")
  end
rescue => e
  puts "SKIP P5: #{e.message}"
end

# P5 | 400x400 | col | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP P5: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "P5", "400x400", "column")
  end
rescue => e
  puts "SKIP P5: #{e.message}"
end


# ── Beams (12) ──
# CB1 | 400x400 | beam | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP CB1: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "CB1", "400x400", "beam")
  end
rescue => e
  puts "SKIP CB1: #{e.message}"
end

# CB1 | 400x400 | beam | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP CB1: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "CB1", "400x400", "beam")
  end
rescue => e
  puts "SKIP CB1: #{e.message}"
end

# CB1 | 400x400 | beam | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP CB1: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "CB1", "400x400", "beam")
  end
rescue => e
  puts "SKIP CB1: #{e.message}"
end

# CB1 | 400x400 | beam | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP CB1: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "CB1", "400x400", "beam")
  end
rescue => e
  puts "SKIP CB1: #{e.message}"
end

# CB1 | 400x400 | beam | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP CB1: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "CB1", "400x400", "beam")
  end
rescue => e
  puts "SKIP CB1: #{e.message}"
end

# CB1 | 400x400 | beam | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP CB1: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "CB1", "400x400", "beam")
  end
rescue => e
  puts "SKIP CB1: #{e.message}"
end

# CB1 | 400x400 | beam | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP CB1: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "CB1", "400x400", "beam")
  end
rescue => e
  puts "SKIP CB1: #{e.message}"
end

# CB1 | 400x400 | beam | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP CB1: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "CB1", "400x400", "beam")
  end
rescue => e
  puts "SKIP CB1: #{e.message}"
end

# CB1 | 400x400 | beam | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP CB1: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "CB1", "400x400", "beam")
  end
rescue => e
  puts "SKIP CB1: #{e.message}"
end

# CB1 | 400x400 | beam | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP CB1: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "CB1", "400x400", "beam")
  end
rescue => e
  puts "SKIP CB1: #{e.message}"
end

# CB1 | 400x400 | beam | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP CB1: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "CB1", "400x400", "beam")
  end
rescue => e
  puts "SKIP CB1: #{e.message}"
end

# CB1 | 400x400 | beam | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(3000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP CB1: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "CB1", "400x400", "beam")
  end
rescue => e
  puts "SKIP CB1: #{e.message}"
end



# ── Finalize ──
model.commit_operation
puts "LOD300 V4 Model import complete."

puts "  Floors: 12"
puts "  Columns: 133"
puts "  Beams: 117"
puts "  Walls: 17"
puts "  Doors: 0"
puts "  Windows: 0"
puts "  Stairs: 12"
puts "  Total: 279 elements"