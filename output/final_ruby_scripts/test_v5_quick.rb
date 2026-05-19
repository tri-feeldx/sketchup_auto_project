# ===========================================================================
# LOD 300 Structural Model — Building
# Pipeline V4 (Vision LLM + Gridless)
# Building: other | 1 floors | 3.5m total height
# ===========================================================================

model  = Sketchup.active_model
model.name        = "Building"
model.description = "other | 1 floors | V4 Pipeline"
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

# ── Finalize ──
model.commit_operation
puts "LOD300 V4 Model import complete."

puts "  Floors: 1"
puts "  Columns: 0"
puts "  Beams: 0"
puts "  Walls: 0"
puts "  Doors: 0"
puts "  Windows: 0"
puts "  Stairs: 0"
puts "  Total: 0 elements"