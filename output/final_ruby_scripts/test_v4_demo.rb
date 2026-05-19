# ===========================================================================
# LOD 300 Structural Model — Test Building V4
# Pipeline V4 (Vision LLM + Gridless)
# Building: mixed_use | 2 floors | 7.0m total height
# ===========================================================================

model  = Sketchup.active_model
model.name        = "Test Building V4"
model.description = "mixed_use | 2 floors | V4 Pipeline"
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
# FLOOR: Ground Floor  (Z: 0 -> 3500 mm)
# ======================================================================

# ── Slab ──
# Slab: Ground Floor | t=200mm | z=0
begin
  _grp = ents.add_group; _ge  = _grp.entities
  _face = _ge.add_face(Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm), Geom::Point3d.new(12000.0.mm, 0.0.mm, 0.0.mm), Geom::Point3d.new(12000.0.mm, 10000.0.mm, 0.0.mm), Geom::Point3d.new(0.0.mm, 10000.0.mm, 0.0.mm))
  _face.pushpull(200.0.mm) if _face
  _grp.layer = layers["STR-Slabs"]
  _grp.material = _mat_for("Concrete")
  _set_ifc(_grp, "SLB", "t={thick}", "slab")
rescue => e
  puts "SKIP slab: #{e.message}"
end

# ── Columns (4) ──
# C1 | 400x400 | col | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP C1: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Concrete")
    _set_ifc(_grp, "C1", "400x400", "column")
  end
rescue => e
  puts "SKIP C1: #{e.message}"
end

# C2 | 400x400 | col | conf=90%
begin
  _sp  = Geom::Point3d.new(12000.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(12000.0.mm, 0.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP C2: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Concrete")
    _set_ifc(_grp, "C2", "400x400", "column")
  end
rescue => e
  puts "SKIP C2: #{e.message}"
end

# C3 | 400x400 | col | conf=85%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 10000.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 10000.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP C3: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Concrete")
    _set_ifc(_grp, "C3", "400x400", "column")
  end
rescue => e
  puts "SKIP C3: #{e.message}"
end

# C4 | 400x400 | col | conf=85%
begin
  _sp  = Geom::Point3d.new(12000.0.mm, 10000.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(12000.0.mm, 10000.0.mm, 3500.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP C4: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Concrete")
    _set_ifc(_grp, "C4", "400x400", "column")
  end
rescue => e
  puts "SKIP C4: #{e.message}"
end


# ── Beams (4) ──
# B1 | UB305x165x40 | beam | conf=85%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(12000.0.mm, 0.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP B1: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 82.5, 151.7)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "B1", "UB305x165x40", "beam")
  end
rescue => e
  puts "SKIP B1: #{e.message}"
end

# B2 | UB305x165x40 | beam | conf=85%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 10000.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(12000.0.mm, 10000.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP B2: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 82.5, 151.7)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "B2", "UB305x165x40", "beam")
  end
rescue => e
  puts "SKIP B2: #{e.message}"
end

# B3 | UB356x171x51 | beam | conf=85%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 10000.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP B3: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 85.8, 177.5)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "B3", "UB356x171x51", "beam")
  end
rescue => e
  puts "SKIP B3: #{e.message}"
end

# B4 | UB356x171x51 | beam | conf=85%
begin
  _sp  = Geom::Point3d.new(12000.0.mm, 0.0.mm, 3100.0.mm)
  _ep  = Geom::Point3d.new(12000.0.mm, 10000.0.mm, 3100.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP B4: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 85.8, 177.5)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "B4", "UB356x171x51", "beam")
  end
rescue => e
  puts "SKIP B4: #{e.message}"
end


# ── Walls (3) ──
# W1 | wall | t=200mm | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 10000.0.mm, 0.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP W1: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 100.0, 5000.0)
    _face.pushpull(3500.0.mm) if _face
    _grp.layer = layers["STR-Walls"]
    _grp.material = _mat_for("Concrete")
    _set_ifc(_grp, "W1", "t=200", "wall")
  end
rescue => e
  puts "SKIP W1: #{e.message}"
end

# W2 | wall | t=200mm | conf=80%
begin
  _sp  = Geom::Point3d.new(12000.0.mm, 0.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(12000.0.mm, 10000.0.mm, 0.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP W2: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 100.0, 5000.0)
    _face.pushpull(3500.0.mm) if _face
    _grp.layer = layers["STR-Walls"]
    _grp.material = _mat_for("Concrete")
    _set_ifc(_grp, "W2", "t=200", "wall")
  end
rescue => e
  puts "SKIP W2: #{e.message}"
end

# W3 | wall | t=200mm | conf=80%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 10000.0.mm, 0.0.mm)
  _ep  = Geom::Point3d.new(12000.0.mm, 10000.0.mm, 0.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP W3: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 100.0, 6000.0)
    _face.pushpull(3500.0.mm) if _face
    _grp.layer = layers["STR-Walls"]
    _grp.material = _mat_for("Concrete")
    _set_ifc(_grp, "W3", "t=200", "wall")
  end
rescue => e
  puts "SKIP W3: #{e.message}"
end


# ── Doors (2) ──
# D1 | door | 900x2100mm | conf=90%
begin
  _grp = ents.add_group; _ge  = _grp.entities
  _p1 = Geom::Point3d.new(3000.0.mm, 0.0.mm, 0.0.mm)
  _p2 = Geom::Point3d.new(3900.0.mm, 0.0.mm, 0.0.mm)
  _p3 = Geom::Point3d.new(3900.0.mm, 0.0.mm, 2100.0.mm)
  _p4 = Geom::Point3d.new(3000.0.mm, 0.0.mm, 2100.0.mm)
  _face = _ge.add_face(_p1, _p2, _p3, _p4)
  _face.pushpull(-100.mm) if _face
  _grp.layer = layers["ARCH-Doors"]
  _grp.material = _mat_for("Wood")
  _set_ifc(_grp, "D1", "900x2100", "door")
rescue => e
  puts "SKIP D1: #{e.message}"
end

# D2 | door | 1600x2100mm | conf=85%
begin
  _grp = ents.add_group; _ge  = _grp.entities
  _p1 = Geom::Point3d.new(12000.0.mm, 5000.0.mm, 0.0.mm)
  _p2 = Geom::Point3d.new(13600.0.mm, 5000.0.mm, 0.0.mm)
  _p3 = Geom::Point3d.new(13600.0.mm, 5000.0.mm, 2100.0.mm)
  _p4 = Geom::Point3d.new(12000.0.mm, 5000.0.mm, 2100.0.mm)
  _face = _ge.add_face(_p1, _p2, _p3, _p4)
  _face.pushpull(-100.mm) if _face
  _grp.layer = layers["ARCH-Doors"]
  _grp.material = _mat_for("Wood")
  _set_ifc(_grp, "D2", "1600x2100", "door")
rescue => e
  puts "SKIP D2: #{e.message}"
end


# ── Windows (3) ──
# WIN1 | window | 2000x1500mm | sill=900 | conf=85%
begin
  _grp = ents.add_group; _ge  = _grp.entities
  _p1 = Geom::Point3d.new(5000.0.mm, 0.0.mm, 900.0.mm)
  _p2 = Geom::Point3d.new(7000.0.mm, 0.0.mm, 900.0.mm)
  _p3 = Geom::Point3d.new(7000.0.mm, 0.0.mm, 2400.0.mm)
  _p4 = Geom::Point3d.new(5000.0.mm, 0.0.mm, 2400.0.mm)
  _face = _ge.add_face(_p1, _p2, _p3, _p4)
  _face.pushpull(-100.mm) if _face
  _grp.layer = layers["ARCH-Windows"]
  _grp.material = _mat_for("Glass")
  _set_ifc(_grp, "WIN1", "2000x1500", "window")
rescue => e
  puts "SKIP WIN1: #{e.message}"
end

# WIN2 | window | 2000x1500mm | sill=900 | conf=85%
begin
  _grp = ents.add_group; _ge  = _grp.entities
  _p1 = Geom::Point3d.new(9000.0.mm, 0.0.mm, 900.0.mm)
  _p2 = Geom::Point3d.new(11000.0.mm, 0.0.mm, 900.0.mm)
  _p3 = Geom::Point3d.new(11000.0.mm, 0.0.mm, 2400.0.mm)
  _p4 = Geom::Point3d.new(9000.0.mm, 0.0.mm, 2400.0.mm)
  _face = _ge.add_face(_p1, _p2, _p3, _p4)
  _face.pushpull(-100.mm) if _face
  _grp.layer = layers["ARCH-Windows"]
  _grp.material = _mat_for("Glass")
  _set_ifc(_grp, "WIN2", "2000x1500", "window")
rescue => e
  puts "SKIP WIN2: #{e.message}"
end

# WIN3 | window | 1200x1200mm | sill=1000 | conf=80%
begin
  _grp = ents.add_group; _ge  = _grp.entities
  _p1 = Geom::Point3d.new(0.0.mm, 3000.0.mm, 1000.0.mm)
  _p2 = Geom::Point3d.new(1200.0.mm, 3000.0.mm, 1000.0.mm)
  _p3 = Geom::Point3d.new(1200.0.mm, 3000.0.mm, 2200.0.mm)
  _p4 = Geom::Point3d.new(0.0.mm, 3000.0.mm, 2200.0.mm)
  _face = _ge.add_face(_p1, _p2, _p3, _p4)
  _face.pushpull(-100.mm) if _face
  _grp.layer = layers["ARCH-Windows"]
  _grp.material = _mat_for("Glass")
  _set_ifc(_grp, "WIN3", "1200x1200", "window")
rescue => e
  puts "SKIP WIN3: #{e.message}"
end



# ======================================================================
# FLOOR: First Floor  (Z: 3500 -> 7000 mm)
# ======================================================================

# ── Slab ──
# Slab: First Floor | t=200mm | z=3500
begin
  _grp = ents.add_group; _ge  = _grp.entities
  _face = _ge.add_face(Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm), Geom::Point3d.new(12000.0.mm, 0.0.mm, 3500.0.mm), Geom::Point3d.new(12000.0.mm, 10000.0.mm, 3500.0.mm), Geom::Point3d.new(0.0.mm, 10000.0.mm, 3500.0.mm))
  _face.pushpull(200.0.mm) if _face
  _grp.layer = layers["STR-Slabs"]
  _grp.material = _mat_for("Concrete")
  _set_ifc(_grp, "SLB", "t={thick}", "slab")
rescue => e
  puts "SKIP slab: #{e.message}"
end

# ── Columns (4) ──
# C1 | 400x400 | col | conf=90%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 3500.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 0.0.mm, 7000.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP C1: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Concrete")
    _set_ifc(_grp, "C1", "400x400", "column")
  end
rescue => e
  puts "SKIP C1: #{e.message}"
end

# C2 | 400x400 | col | conf=90%
begin
  _sp  = Geom::Point3d.new(12000.0.mm, 0.0.mm, 3500.0.mm)
  _ep  = Geom::Point3d.new(12000.0.mm, 0.0.mm, 7000.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP C2: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Concrete")
    _set_ifc(_grp, "C2", "400x400", "column")
  end
rescue => e
  puts "SKIP C2: #{e.message}"
end

# C3 | 400x400 | col | conf=85%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 10000.0.mm, 3500.0.mm)
  _ep  = Geom::Point3d.new(0.0.mm, 10000.0.mm, 7000.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP C3: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Concrete")
    _set_ifc(_grp, "C3", "400x400", "column")
  end
rescue => e
  puts "SKIP C3: #{e.message}"
end

# C4 | 400x400 | col | conf=85%
begin
  _sp  = Geom::Point3d.new(12000.0.mm, 10000.0.mm, 3500.0.mm)
  _ep  = Geom::Point3d.new(12000.0.mm, 10000.0.mm, 7000.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP C4: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 200.0, 200.0)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Columns"]
    _grp.material = _mat_for("Concrete")
    _set_ifc(_grp, "C4", "400x400", "column")
  end
rescue => e
  puts "SKIP C4: #{e.message}"
end


# ── Beams (2) ──
# B5 | UB305x165x40 | beam | conf=85%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 0.0.mm, 6600.0.mm)
  _ep  = Geom::Point3d.new(12000.0.mm, 0.0.mm, 6600.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP B5: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 82.5, 151.7)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "B5", "UB305x165x40", "beam")
  end
rescue => e
  puts "SKIP B5: #{e.message}"
end

# B6 | UB305x165x40 | beam | conf=85%
begin
  _sp  = Geom::Point3d.new(0.0.mm, 10000.0.mm, 6600.0.mm)
  _ep  = Geom::Point3d.new(12000.0.mm, 10000.0.mm, 6600.0.mm)
  _vec = _sp.vector_to(_ep); _len = _sp.distance(_ep)
  if _len < 1.mm || !_vec.valid?
    puts "SKIP B6: zero-length"
  else
    _grp = ents.add_group; _ge  = _grp.entities
    _t   = Geom::Transformation.new(_sp, _vec)
    _face = _add_rect(_ge, _t, 82.5, 151.7)
    _face.pushpull(_len) if _face
    _grp.layer = layers["STR-Beams"]
    _grp.material = _mat_for("Steel")
    _set_ifc(_grp, "B6", "UB305x165x40", "beam")
  end
rescue => e
  puts "SKIP B6: #{e.message}"
end


# ── Doors (1) ──
# D3 | door | 900x2100mm | conf=85%
begin
  _grp = ents.add_group; _ge  = _grp.entities
  _p1 = Geom::Point3d.new(6000.0.mm, 0.0.mm, 3500.0.mm)
  _p2 = Geom::Point3d.new(6900.0.mm, 0.0.mm, 3500.0.mm)
  _p3 = Geom::Point3d.new(6900.0.mm, 0.0.mm, 5600.0.mm)
  _p4 = Geom::Point3d.new(6000.0.mm, 0.0.mm, 5600.0.mm)
  _face = _ge.add_face(_p1, _p2, _p3, _p4)
  _face.pushpull(-100.mm) if _face
  _grp.layer = layers["ARCH-Doors"]
  _grp.material = _mat_for("Wood")
  _set_ifc(_grp, "D3", "900x2100", "door")
rescue => e
  puts "SKIP D3: #{e.message}"
end


# ── Windows (1) ──
# WIN4 | window | 1800x1500mm | sill=900 | conf=80%
begin
  _grp = ents.add_group; _ge  = _grp.entities
  _p1 = Geom::Point3d.new(3000.0.mm, 10000.0.mm, 4400.0.mm)
  _p2 = Geom::Point3d.new(4800.0.mm, 10000.0.mm, 4400.0.mm)
  _p3 = Geom::Point3d.new(4800.0.mm, 10000.0.mm, 5900.0.mm)
  _p4 = Geom::Point3d.new(3000.0.mm, 10000.0.mm, 5900.0.mm)
  _face = _ge.add_face(_p1, _p2, _p3, _p4)
  _face.pushpull(-100.mm) if _face
  _grp.layer = layers["ARCH-Windows"]
  _grp.material = _mat_for("Glass")
  _set_ifc(_grp, "WIN4", "1800x1500", "window")
rescue => e
  puts "SKIP WIN4: #{e.message}"
end


# ── Stairs (1) ──
# ST1 | stair | 20 steps | 1000mm wide | conf=85%
begin
  _grp = ents.add_group; _ge  = _grp.entities
  _p1 = Geom::Point3d.new(1000.0.mm, 3000.0.mm, 3500.0.mm)
  _p2 = Geom::Point3d.new(2000.0.mm, 3000.0.mm, 3500.0.mm)
  _p3 = Geom::Point3d.new(2000.0.mm, 7000.0.mm, 3500.0.mm)
  _p4 = Geom::Point3d.new(1000.0.mm, 7000.0.mm, 3500.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(175.0.mm) if _f
  _p1 = Geom::Point3d.new(1000.0.mm, 7000.0.mm, 3675.0.mm)
  _p2 = Geom::Point3d.new(2000.0.mm, 7000.0.mm, 3675.0.mm)
  _p3 = Geom::Point3d.new(2000.0.mm, 11000.0.mm, 3675.0.mm)
  _p4 = Geom::Point3d.new(1000.0.mm, 11000.0.mm, 3675.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(175.0.mm) if _f
  _p1 = Geom::Point3d.new(1000.0.mm, 11000.0.mm, 3850.0.mm)
  _p2 = Geom::Point3d.new(2000.0.mm, 11000.0.mm, 3850.0.mm)
  _p3 = Geom::Point3d.new(2000.0.mm, 15000.0.mm, 3850.0.mm)
  _p4 = Geom::Point3d.new(1000.0.mm, 15000.0.mm, 3850.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(175.0.mm) if _f
  _p1 = Geom::Point3d.new(1000.0.mm, 15000.0.mm, 4025.0.mm)
  _p2 = Geom::Point3d.new(2000.0.mm, 15000.0.mm, 4025.0.mm)
  _p3 = Geom::Point3d.new(2000.0.mm, 19000.0.mm, 4025.0.mm)
  _p4 = Geom::Point3d.new(1000.0.mm, 19000.0.mm, 4025.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(175.0.mm) if _f
  _p1 = Geom::Point3d.new(1000.0.mm, 19000.0.mm, 4200.0.mm)
  _p2 = Geom::Point3d.new(2000.0.mm, 19000.0.mm, 4200.0.mm)
  _p3 = Geom::Point3d.new(2000.0.mm, 23000.0.mm, 4200.0.mm)
  _p4 = Geom::Point3d.new(1000.0.mm, 23000.0.mm, 4200.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(175.0.mm) if _f
  _p1 = Geom::Point3d.new(1000.0.mm, 23000.0.mm, 4375.0.mm)
  _p2 = Geom::Point3d.new(2000.0.mm, 23000.0.mm, 4375.0.mm)
  _p3 = Geom::Point3d.new(2000.0.mm, 27000.0.mm, 4375.0.mm)
  _p4 = Geom::Point3d.new(1000.0.mm, 27000.0.mm, 4375.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(175.0.mm) if _f
  _p1 = Geom::Point3d.new(1000.0.mm, 27000.0.mm, 4550.0.mm)
  _p2 = Geom::Point3d.new(2000.0.mm, 27000.0.mm, 4550.0.mm)
  _p3 = Geom::Point3d.new(2000.0.mm, 31000.0.mm, 4550.0.mm)
  _p4 = Geom::Point3d.new(1000.0.mm, 31000.0.mm, 4550.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(175.0.mm) if _f
  _p1 = Geom::Point3d.new(1000.0.mm, 31000.0.mm, 4725.0.mm)
  _p2 = Geom::Point3d.new(2000.0.mm, 31000.0.mm, 4725.0.mm)
  _p3 = Geom::Point3d.new(2000.0.mm, 35000.0.mm, 4725.0.mm)
  _p4 = Geom::Point3d.new(1000.0.mm, 35000.0.mm, 4725.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(175.0.mm) if _f
  _p1 = Geom::Point3d.new(1000.0.mm, 35000.0.mm, 4900.0.mm)
  _p2 = Geom::Point3d.new(2000.0.mm, 35000.0.mm, 4900.0.mm)
  _p3 = Geom::Point3d.new(2000.0.mm, 39000.0.mm, 4900.0.mm)
  _p4 = Geom::Point3d.new(1000.0.mm, 39000.0.mm, 4900.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(175.0.mm) if _f
  _p1 = Geom::Point3d.new(1000.0.mm, 39000.0.mm, 5075.0.mm)
  _p2 = Geom::Point3d.new(2000.0.mm, 39000.0.mm, 5075.0.mm)
  _p3 = Geom::Point3d.new(2000.0.mm, 43000.0.mm, 5075.0.mm)
  _p4 = Geom::Point3d.new(1000.0.mm, 43000.0.mm, 5075.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(175.0.mm) if _f
  _p1 = Geom::Point3d.new(1000.0.mm, 43000.0.mm, 5250.0.mm)
  _p2 = Geom::Point3d.new(2000.0.mm, 43000.0.mm, 5250.0.mm)
  _p3 = Geom::Point3d.new(2000.0.mm, 47000.0.mm, 5250.0.mm)
  _p4 = Geom::Point3d.new(1000.0.mm, 47000.0.mm, 5250.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(175.0.mm) if _f
  _p1 = Geom::Point3d.new(1000.0.mm, 47000.0.mm, 5425.0.mm)
  _p2 = Geom::Point3d.new(2000.0.mm, 47000.0.mm, 5425.0.mm)
  _p3 = Geom::Point3d.new(2000.0.mm, 51000.0.mm, 5425.0.mm)
  _p4 = Geom::Point3d.new(1000.0.mm, 51000.0.mm, 5425.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(175.0.mm) if _f
  _p1 = Geom::Point3d.new(1000.0.mm, 51000.0.mm, 5600.0.mm)
  _p2 = Geom::Point3d.new(2000.0.mm, 51000.0.mm, 5600.0.mm)
  _p3 = Geom::Point3d.new(2000.0.mm, 55000.0.mm, 5600.0.mm)
  _p4 = Geom::Point3d.new(1000.0.mm, 55000.0.mm, 5600.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(175.0.mm) if _f
  _p1 = Geom::Point3d.new(1000.0.mm, 55000.0.mm, 5775.0.mm)
  _p2 = Geom::Point3d.new(2000.0.mm, 55000.0.mm, 5775.0.mm)
  _p3 = Geom::Point3d.new(2000.0.mm, 59000.0.mm, 5775.0.mm)
  _p4 = Geom::Point3d.new(1000.0.mm, 59000.0.mm, 5775.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(175.0.mm) if _f
  _p1 = Geom::Point3d.new(1000.0.mm, 59000.0.mm, 5950.0.mm)
  _p2 = Geom::Point3d.new(2000.0.mm, 59000.0.mm, 5950.0.mm)
  _p3 = Geom::Point3d.new(2000.0.mm, 63000.0.mm, 5950.0.mm)
  _p4 = Geom::Point3d.new(1000.0.mm, 63000.0.mm, 5950.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(175.0.mm) if _f
  _p1 = Geom::Point3d.new(1000.0.mm, 63000.0.mm, 6125.0.mm)
  _p2 = Geom::Point3d.new(2000.0.mm, 63000.0.mm, 6125.0.mm)
  _p3 = Geom::Point3d.new(2000.0.mm, 67000.0.mm, 6125.0.mm)
  _p4 = Geom::Point3d.new(1000.0.mm, 67000.0.mm, 6125.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(175.0.mm) if _f
  _p1 = Geom::Point3d.new(1000.0.mm, 67000.0.mm, 6300.0.mm)
  _p2 = Geom::Point3d.new(2000.0.mm, 67000.0.mm, 6300.0.mm)
  _p3 = Geom::Point3d.new(2000.0.mm, 71000.0.mm, 6300.0.mm)
  _p4 = Geom::Point3d.new(1000.0.mm, 71000.0.mm, 6300.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(175.0.mm) if _f
  _p1 = Geom::Point3d.new(1000.0.mm, 71000.0.mm, 6475.0.mm)
  _p2 = Geom::Point3d.new(2000.0.mm, 71000.0.mm, 6475.0.mm)
  _p3 = Geom::Point3d.new(2000.0.mm, 75000.0.mm, 6475.0.mm)
  _p4 = Geom::Point3d.new(1000.0.mm, 75000.0.mm, 6475.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(175.0.mm) if _f
  _p1 = Geom::Point3d.new(1000.0.mm, 75000.0.mm, 6650.0.mm)
  _p2 = Geom::Point3d.new(2000.0.mm, 75000.0.mm, 6650.0.mm)
  _p3 = Geom::Point3d.new(2000.0.mm, 79000.0.mm, 6650.0.mm)
  _p4 = Geom::Point3d.new(1000.0.mm, 79000.0.mm, 6650.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(175.0.mm) if _f
  _p1 = Geom::Point3d.new(1000.0.mm, 79000.0.mm, 6825.0.mm)
  _p2 = Geom::Point3d.new(2000.0.mm, 79000.0.mm, 6825.0.mm)
  _p3 = Geom::Point3d.new(2000.0.mm, 83000.0.mm, 6825.0.mm)
  _p4 = Geom::Point3d.new(1000.0.mm, 83000.0.mm, 6825.0.mm)
  _f = _ge.add_face(_p1, _p2, _p3, _p4)
  _f.pushpull(175.0.mm) if _f
  _grp.layer = layers["ARCH-Stairs"]
  _grp.material = _mat_for("Concrete")
  _set_ifc(_grp, "ST1", "20risers", "stair")
rescue => e
  puts "SKIP ST1: #{e.message}"
end



# ── Roof (flat) ──
begin
  _grp = ents.add_group; _ge  = _grp.entities
  _p1 = Geom::Point3d.new(0, 0, 7000.0.mm)
  _p2 = Geom::Point3d.new(12000.0.mm, 0, 7000.0.mm)
  _p3 = Geom::Point3d.new(12000.0.mm, 10000.0.mm, 7000.0.mm)
  _p4 = Geom::Point3d.new(0, 10000.0.mm, 7000.0.mm)
  _face = _ge.add_face(_p1, _p2, _p3, _p4)
  _face.pushpull(200.mm) if _face
  _grp.layer = layers["ARCH-Roof"]
  _grp.material = _mat_for("Concrete")
  _set_ifc(_grp, "ROOF", "ROOF", "roof")
rescue => e
  puts "SKIP roof: #{e.message}"
end

# ── Finalize ──
model.commit_operation
puts "LOD300 V4 Model import complete."

puts "  Floors: 2"
puts "  Columns: 8"
puts "  Beams: 6"
puts "  Walls: 3"
puts "  Doors: 3"
puts "  Windows: 4"
puts "  Stairs: 1"
puts "  Total: 25 elements"