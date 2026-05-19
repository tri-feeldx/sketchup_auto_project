# SketchUp Structural Script
# Generated: 2026-05-19T13:58:49.581409
# Region: vn

model = Sketchup.active_model
ents = model.active_entities
model.start_operation('Structural_Import', true)

layers = {
  'cols' => model.layers.add('Columns'),
  'beams'=> model.layers.add('Beams'),
  'slabs'=> model.layers.add('Slabs'),
  'walls'=> model.layers.add('Walls'),
  'ftgs' => model.layers.add('Footings'),
}

mat = model.materials.add('concrete')
mat.color = Sketchup::Color.new(180,180,180)
origin_x = 0; origin_y = 0

# === Columns ===
pts_0 = [Geom::Point3d.new(origin_x+0, origin_y+0, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 3500)]
f_0 = ents.add_face(pts_0)
f_0.pushpull(-3500) if f_0
f_0.material = mat if f_0
f_0.layer = layers['cols'] if f_0
pts_1 = [Geom::Point3d.new(origin_x+0, origin_y+0, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 3500)]
f_1 = ents.add_face(pts_1)
f_1.pushpull(-3500) if f_1
f_1.material = mat if f_1
f_1.layer = layers['cols'] if f_1
pts_2 = [Geom::Point3d.new(origin_x+0, origin_y+0, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 3500)]
f_2 = ents.add_face(pts_2)
f_2.pushpull(-3500) if f_2
f_2.material = mat if f_2
f_2.layer = layers['cols'] if f_2
pts_3 = [Geom::Point3d.new(origin_x+0, origin_y+0, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 3500)]
f_3 = ents.add_face(pts_3)
f_3.pushpull(-3500) if f_3
f_3.material = mat if f_3
f_3.layer = layers['cols'] if f_3
pts_4 = [Geom::Point3d.new(origin_x+0, origin_y+0, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 3500)]
f_4 = ents.add_face(pts_4)
f_4.pushpull(-3500) if f_4
f_4.material = mat if f_4
f_4.layer = layers['cols'] if f_4
pts_5 = [Geom::Point3d.new(origin_x+0, origin_y+0, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 3500)]
f_5 = ents.add_face(pts_5)
f_5.pushpull(-3500) if f_5
f_5.material = mat if f_5
f_5.layer = layers['cols'] if f_5
pts_6 = [Geom::Point3d.new(origin_x+0, origin_y+0, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 3500)]
f_6 = ents.add_face(pts_6)
f_6.pushpull(-3500) if f_6
f_6.material = mat if f_6
f_6.layer = layers['cols'] if f_6
pts_7 = [Geom::Point3d.new(origin_x+0, origin_y+0, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 3500)]
f_7 = ents.add_face(pts_7)
f_7.pushpull(-3500) if f_7
f_7.material = mat if f_7
f_7.layer = layers['cols'] if f_7
pts_8 = [Geom::Point3d.new(origin_x+0, origin_y+0, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 3500)]
f_8 = ents.add_face(pts_8)
f_8.pushpull(-3500) if f_8
f_8.material = mat if f_8
f_8.layer = layers['cols'] if f_8
pts_9 = [Geom::Point3d.new(origin_x+0, origin_y+0, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 3500)]
f_9 = ents.add_face(pts_9)
f_9.pushpull(-3500) if f_9
f_9.material = mat if f_9
f_9.layer = layers['cols'] if f_9
pts_10 = [Geom::Point3d.new(origin_x+0, origin_y+0, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 3500)]
f_10 = ents.add_face(pts_10)
f_10.pushpull(-3500) if f_10
f_10.material = mat if f_10
f_10.layer = layers['cols'] if f_10
pts_11 = [Geom::Point3d.new(origin_x+0, origin_y+0, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 3500)]
f_11 = ents.add_face(pts_11)
f_11.pushpull(-3500) if f_11
f_11.material = mat if f_11
f_11.layer = layers['cols'] if f_11
pts_12 = [Geom::Point3d.new(origin_x+0, origin_y+0, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 3500)]
f_12 = ents.add_face(pts_12)
f_12.pushpull(-3500) if f_12
f_12.material = mat if f_12
f_12.layer = layers['cols'] if f_12
pts_13 = [Geom::Point3d.new(origin_x+0, origin_y+0, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 3500)]
f_13 = ents.add_face(pts_13)
f_13.pushpull(-3500) if f_13
f_13.material = mat if f_13
f_13.layer = layers['cols'] if f_13
pts_14 = [Geom::Point3d.new(origin_x+0, origin_y+0, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 3500)]
f_14 = ents.add_face(pts_14)
f_14.pushpull(-3500) if f_14
f_14.material = mat if f_14
f_14.layer = layers['cols'] if f_14
pts_15 = [Geom::Point3d.new(origin_x+0, origin_y+0, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 3500)]
f_15 = ents.add_face(pts_15)
f_15.pushpull(-3500) if f_15
f_15.material = mat if f_15
f_15.layer = layers['cols'] if f_15
pts_16 = [Geom::Point3d.new(origin_x+0, origin_y+0, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 3500)]
f_16 = ents.add_face(pts_16)
f_16.pushpull(-3500) if f_16
f_16.material = mat if f_16
f_16.layer = layers['cols'] if f_16
pts_17 = [Geom::Point3d.new(origin_x+0, origin_y+0, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 3500)]
f_17 = ents.add_face(pts_17)
f_17.pushpull(-3500) if f_17
f_17.material = mat if f_17
f_17.layer = layers['cols'] if f_17
pts_18 = [Geom::Point3d.new(origin_x+0, origin_y+0, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 3500)]
f_18 = ents.add_face(pts_18)
f_18.pushpull(-3500) if f_18
f_18.material = mat if f_18
f_18.layer = layers['cols'] if f_18
pts_19 = [Geom::Point3d.new(origin_x+0, origin_y+0, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 3500)]
f_19 = ents.add_face(pts_19)
f_19.pushpull(-3500) if f_19
f_19.material = mat if f_19
f_19.layer = layers['cols'] if f_19
pts_20 = [Geom::Point3d.new(origin_x+0, origin_y+0, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 3500)]
f_20 = ents.add_face(pts_20)
f_20.pushpull(-3500) if f_20
f_20.material = mat if f_20
f_20.layer = layers['cols'] if f_20
pts_21 = [Geom::Point3d.new(origin_x+0, origin_y+0, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 3500)]
f_21 = ents.add_face(pts_21)
f_21.pushpull(-3500) if f_21
f_21.material = mat if f_21
f_21.layer = layers['cols'] if f_21
pts_22 = [Geom::Point3d.new(origin_x+0, origin_y+0, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 3500)]
f_22 = ents.add_face(pts_22)
f_22.pushpull(-3500) if f_22
f_22.material = mat if f_22
f_22.layer = layers['cols'] if f_22
pts_23 = [Geom::Point3d.new(origin_x+0, origin_y+0, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 3500)]
f_23 = ents.add_face(pts_23)
f_23.pushpull(-3500) if f_23
f_23.material = mat if f_23
f_23.layer = layers['cols'] if f_23
pts_24 = [Geom::Point3d.new(origin_x+0, origin_y+0, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 0), Geom::Point3d.new(origin_x+300, origin_y+300, 5000)]
f_24 = ents.add_face(pts_24)
f_24.pushpull(-5000) if f_24
f_24.material = mat if f_24
f_24.layer = layers['cols'] if f_24

# === Beams ===
pt1_0 = Geom::Point3d.new(origin_x+0, origin_y+0, 3500)
pt2_0 = Geom::Point3d.new(origin_x+4000, origin_y+0, 3500)
ln_0 = ents.add_cline(pt1_0, pt2_0)
ln_0.layer = layers['beams'] if ln_0
pt1_1 = Geom::Point3d.new(origin_x+0, origin_y+0, 3500)
pt2_1 = Geom::Point3d.new(origin_x+4000, origin_y+0, 3500)
ln_1 = ents.add_cline(pt1_1, pt2_1)
ln_1.layer = layers['beams'] if ln_1
pt1_2 = Geom::Point3d.new(origin_x+0, origin_y+0, 3500)
pt2_2 = Geom::Point3d.new(origin_x+4000, origin_y+0, 3500)
ln_2 = ents.add_cline(pt1_2, pt2_2)
ln_2.layer = layers['beams'] if ln_2
pt1_3 = Geom::Point3d.new(origin_x+0, origin_y+0, 3500)
pt2_3 = Geom::Point3d.new(origin_x+4000, origin_y+0, 3500)
ln_3 = ents.add_cline(pt1_3, pt2_3)
ln_3.layer = layers['beams'] if ln_3
pt1_4 = Geom::Point3d.new(origin_x+0, origin_y+0, 3500)
pt2_4 = Geom::Point3d.new(origin_x+4000, origin_y+0, 3500)
ln_4 = ents.add_cline(pt1_4, pt2_4)
ln_4.layer = layers['beams'] if ln_4

# === Slabs ===
pts_0 = [Geom::Point3d.new(2000,2000,3500),Geom::Point3d.new(6000,2000,3500),Geom::Point3d.new(6000,6000,3500),Geom::Point3d.new(2000,6000,3500)]
f_0 = ents.add_face(pts_0)
f_0.pushpull(-120) if f_0
f_0.material = mat if f_0
f_0.layer = layers['slabs'] if f_0
pts_1 = [Geom::Point3d.new(2000,2000,3500),Geom::Point3d.new(6000,2000,3500),Geom::Point3d.new(6000,6000,3500),Geom::Point3d.new(2000,6000,3500)]
f_1 = ents.add_face(pts_1)
f_1.pushpull(-unknown_thickness) if f_1
f_1.material = mat if f_1
f_1.layer = layers['slabs'] if f_1
pts_2 = [Geom::Point3d.new(2000,2000,3500),Geom::Point3d.new(6000,2000,3500),Geom::Point3d.new(6000,6000,3500),Geom::Point3d.new(2000,6000,3500)]
f_2 = ents.add_face(pts_2)
f_2.pushpull(-120) if f_2
f_2.material = mat if f_2
f_2.layer = layers['slabs'] if f_2

# === Walls ===
# Wall 1
v_0 = Geom::Vector3d.new(4000,0,0)
if v_0.length > 0
  d_0 = v_0.normalize
  p_0 = Geom::Vector3d.new(-d_0.y, d_0.x, 0)
  s_0 = Geom::Point3d.new(origin_x+0, origin_y+0, 0)
  e_0 = Geom::Point3d.new(origin_x+4000, origin_y+0, 0)
  ht = 100.mm / 2.0
  pts_0 = [s_0+p_0*ht, e_0+p_0*ht, e_0-p_0*ht, s_0-p_0*ht]
  f_0 = ents.add_face(pts_0)
  f_0.pushpull(3500) if f_0
  f_0.material = mat if f_0
  f_0.layer = layers['walls'] if f_0
end
# Wall 2
v_1 = Geom::Vector3d.new(4000,0,0)
if v_1.length > 0
  d_1 = v_1.normalize
  p_1 = Geom::Vector3d.new(-d_1.y, d_1.x, 0)
  s_1 = Geom::Point3d.new(origin_x+0, origin_y+0, 0)
  e_1 = Geom::Point3d.new(origin_x+4000, origin_y+0, 0)
  ht = 100.mm / 2.0
  pts_1 = [s_1+p_1*ht, e_1+p_1*ht, e_1-p_1*ht, s_1-p_1*ht]
  f_1 = ents.add_face(pts_1)
  f_1.pushpull(3500) if f_1
  f_1.material = mat if f_1
  f_1.layer = layers['walls'] if f_1
end
# Wall 3
v_2 = Geom::Vector3d.new(4000,0,0)
if v_2.length > 0
  d_2 = v_2.normalize
  p_2 = Geom::Vector3d.new(-d_2.y, d_2.x, 0)
  s_2 = Geom::Point3d.new(origin_x+0, origin_y+0, 0)
  e_2 = Geom::Point3d.new(origin_x+4000, origin_y+0, 0)
  ht = 100.mm / 2.0
  pts_2 = [s_2+p_2*ht, e_2+p_2*ht, e_2-p_2*ht, s_2-p_2*ht]
  f_2 = ents.add_face(pts_2)
  f_2.pushpull(3500) if f_2
  f_2.material = mat if f_2
  f_2.layer = layers['walls'] if f_2
end
# Wall 4
v_3 = Geom::Vector3d.new(4000,0,0)
if v_3.length > 0
  d_3 = v_3.normalize
  p_3 = Geom::Vector3d.new(-d_3.y, d_3.x, 0)
  s_3 = Geom::Point3d.new(origin_x+0, origin_y+0, 0)
  e_3 = Geom::Point3d.new(origin_x+4000, origin_y+0, 0)
  ht = unknown_thickness.mm / 2.0
  pts_3 = [s_3+p_3*ht, e_3+p_3*ht, e_3-p_3*ht, s_3-p_3*ht]
  f_3 = ents.add_face(pts_3)
  f_3.pushpull(3500) if f_3
  f_3.material = mat if f_3
  f_3.layer = layers['walls'] if f_3
end
# Wall 5
v_4 = Geom::Vector3d.new(4000,0,0)
if v_4.length > 0
  d_4 = v_4.normalize
  p_4 = Geom::Vector3d.new(-d_4.y, d_4.x, 0)
  s_4 = Geom::Point3d.new(origin_x+0, origin_y+0, 0)
  e_4 = Geom::Point3d.new(origin_x+4000, origin_y+0, 0)
  ht = unknown_thickness.mm / 2.0
  pts_4 = [s_4+p_4*ht, e_4+p_4*ht, e_4-p_4*ht, s_4-p_4*ht]
  f_4 = ents.add_face(pts_4)
  f_4.pushpull(3500) if f_4
  f_4.material = mat if f_4
  f_4.layer = layers['walls'] if f_4
end
# Wall 6
v_5 = Geom::Vector3d.new(4000,0,0)
if v_5.length > 0
  d_5 = v_5.normalize
  p_5 = Geom::Vector3d.new(-d_5.y, d_5.x, 0)
  s_5 = Geom::Point3d.new(origin_x+0, origin_y+0, 0)
  e_5 = Geom::Point3d.new(origin_x+4000, origin_y+0, 0)
  ht = unknown_thickness.mm / 2.0
  pts_5 = [s_5+p_5*ht, e_5+p_5*ht, e_5-p_5*ht, s_5-p_5*ht]
  f_5 = ents.add_face(pts_5)
  f_5.pushpull(3500) if f_5
  f_5.material = mat if f_5
  f_5.layer = layers['walls'] if f_5
end
# Wall 7
v_6 = Geom::Vector3d.new(4000,0,0)
if v_6.length > 0
  d_6 = v_6.normalize
  p_6 = Geom::Vector3d.new(-d_6.y, d_6.x, 0)
  s_6 = Geom::Point3d.new(origin_x+0, origin_y+0, 0)
  e_6 = Geom::Point3d.new(origin_x+4000, origin_y+0, 0)
  ht = unknown_thickness.mm / 2.0
  pts_6 = [s_6+p_6*ht, e_6+p_6*ht, e_6-p_6*ht, s_6-p_6*ht]
  f_6 = ents.add_face(pts_6)
  f_6.pushpull(3500) if f_6
  f_6.material = mat if f_6
  f_6.layer = layers['walls'] if f_6
end
# Wall 8
v_7 = Geom::Vector3d.new(4000,0,0)
if v_7.length > 0
  d_7 = v_7.normalize
  p_7 = Geom::Vector3d.new(-d_7.y, d_7.x, 0)
  s_7 = Geom::Point3d.new(origin_x+0, origin_y+0, 0)
  e_7 = Geom::Point3d.new(origin_x+4000, origin_y+0, 0)
  ht = 300.mm / 2.0
  pts_7 = [s_7+p_7*ht, e_7+p_7*ht, e_7-p_7*ht, s_7-p_7*ht]
  f_7 = ents.add_face(pts_7)
  f_7.pushpull(3500) if f_7
  f_7.material = mat if f_7
  f_7.layer = layers['walls'] if f_7
end
# Wall 9
v_8 = Geom::Vector3d.new(4000,0,0)
if v_8.length > 0
  d_8 = v_8.normalize
  p_8 = Geom::Vector3d.new(-d_8.y, d_8.x, 0)
  s_8 = Geom::Point3d.new(origin_x+0, origin_y+0, 0)
  e_8 = Geom::Point3d.new(origin_x+4000, origin_y+0, 0)
  ht = 300.mm / 2.0
  pts_8 = [s_8+p_8*ht, e_8+p_8*ht, e_8-p_8*ht, s_8-p_8*ht]
  f_8 = ents.add_face(pts_8)
  f_8.pushpull(3500) if f_8
  f_8.material = mat if f_8
  f_8.layer = layers['walls'] if f_8
end
# Wall 10
v_9 = Geom::Vector3d.new(4000,0,0)
if v_9.length > 0
  d_9 = v_9.normalize
  p_9 = Geom::Vector3d.new(-d_9.y, d_9.x, 0)
  s_9 = Geom::Point3d.new(origin_x+0, origin_y+0, 0)
  e_9 = Geom::Point3d.new(origin_x+4000, origin_y+0, 0)
  ht = 300.mm / 2.0
  pts_9 = [s_9+p_9*ht, e_9+p_9*ht, e_9-p_9*ht, s_9-p_9*ht]
  f_9 = ents.add_face(pts_9)
  f_9.pushpull(3500) if f_9
  f_9.material = mat if f_9
  f_9.layer = layers['walls'] if f_9
end
# Wall 11
v_10 = Geom::Vector3d.new(4000,0,0)
if v_10.length > 0
  d_10 = v_10.normalize
  p_10 = Geom::Vector3d.new(-d_10.y, d_10.x, 0)
  s_10 = Geom::Point3d.new(origin_x+0, origin_y+0, 0)
  e_10 = Geom::Point3d.new(origin_x+4000, origin_y+0, 0)
  ht = 300.mm / 2.0
  pts_10 = [s_10+p_10*ht, e_10+p_10*ht, e_10-p_10*ht, s_10-p_10*ht]
  f_10 = ents.add_face(pts_10)
  f_10.pushpull(3500) if f_10
  f_10.material = mat if f_10
  f_10.layer = layers['walls'] if f_10
end
# Wall 12
v_11 = Geom::Vector3d.new(4000,0,0)
if v_11.length > 0
  d_11 = v_11.normalize
  p_11 = Geom::Vector3d.new(-d_11.y, d_11.x, 0)
  s_11 = Geom::Point3d.new(origin_x+0, origin_y+0, 0)
  e_11 = Geom::Point3d.new(origin_x+4000, origin_y+0, 0)
  ht = 300.mm / 2.0
  pts_11 = [s_11+p_11*ht, e_11+p_11*ht, e_11-p_11*ht, s_11-p_11*ht]
  f_11 = ents.add_face(pts_11)
  f_11.pushpull(3500) if f_11
  f_11.material = mat if f_11
  f_11.layer = layers['walls'] if f_11
end
# Wall 13
v_12 = Geom::Vector3d.new(4000,0,0)
if v_12.length > 0
  d_12 = v_12.normalize
  p_12 = Geom::Vector3d.new(-d_12.y, d_12.x, 0)
  s_12 = Geom::Point3d.new(origin_x+0, origin_y+0, 0)
  e_12 = Geom::Point3d.new(origin_x+4000, origin_y+0, 0)
  ht = 300.mm / 2.0
  pts_12 = [s_12+p_12*ht, e_12+p_12*ht, e_12-p_12*ht, s_12-p_12*ht]
  f_12 = ents.add_face(pts_12)
  f_12.pushpull(3500) if f_12
  f_12.material = mat if f_12
  f_12.layer = layers['walls'] if f_12
end
# Wall 14
v_13 = Geom::Vector3d.new(4000,0,0)
if v_13.length > 0
  d_13 = v_13.normalize
  p_13 = Geom::Vector3d.new(-d_13.y, d_13.x, 0)
  s_13 = Geom::Point3d.new(origin_x+0, origin_y+0, 0)
  e_13 = Geom::Point3d.new(origin_x+4000, origin_y+0, 0)
  ht = 300.mm / 2.0
  pts_13 = [s_13+p_13*ht, e_13+p_13*ht, e_13-p_13*ht, s_13-p_13*ht]
  f_13 = ents.add_face(pts_13)
  f_13.pushpull(3500) if f_13
  f_13.material = mat if f_13
  f_13.layer = layers['walls'] if f_13
end
# Wall 15
v_14 = Geom::Vector3d.new(4000,0,0)
if v_14.length > 0
  d_14 = v_14.normalize
  p_14 = Geom::Vector3d.new(-d_14.y, d_14.x, 0)
  s_14 = Geom::Point3d.new(origin_x+0, origin_y+0, 0)
  e_14 = Geom::Point3d.new(origin_x+4000, origin_y+0, 0)
  ht = 300.mm / 2.0
  pts_14 = [s_14+p_14*ht, e_14+p_14*ht, e_14-p_14*ht, s_14-p_14*ht]
  f_14 = ents.add_face(pts_14)
  f_14.pushpull(3500) if f_14
  f_14.material = mat if f_14
  f_14.layer = layers['walls'] if f_14
end
# Wall 16
v_15 = Geom::Vector3d.new(4000,0,0)
if v_15.length > 0
  d_15 = v_15.normalize
  p_15 = Geom::Vector3d.new(-d_15.y, d_15.x, 0)
  s_15 = Geom::Point3d.new(origin_x+0, origin_y+0, 0)
  e_15 = Geom::Point3d.new(origin_x+4000, origin_y+0, 0)
  ht = 100.mm / 2.0
  pts_15 = [s_15+p_15*ht, e_15+p_15*ht, e_15-p_15*ht, s_15-p_15*ht]
  f_15 = ents.add_face(pts_15)
  f_15.pushpull(3500) if f_15
  f_15.material = mat if f_15
  f_15.layer = layers['walls'] if f_15
end
# Wall 17
v_16 = Geom::Vector3d.new(4000,0,0)
if v_16.length > 0
  d_16 = v_16.normalize
  p_16 = Geom::Vector3d.new(-d_16.y, d_16.x, 0)
  s_16 = Geom::Point3d.new(origin_x+0, origin_y+0, 0)
  e_16 = Geom::Point3d.new(origin_x+4000, origin_y+0, 0)
  ht = 100.mm / 2.0
  pts_16 = [s_16+p_16*ht, e_16+p_16*ht, e_16-p_16*ht, s_16-p_16*ht]
  f_16 = ents.add_face(pts_16)
  f_16.pushpull(3500) if f_16
  f_16.material = mat if f_16
  f_16.layer = layers['walls'] if f_16
end
# Wall 18
v_17 = Geom::Vector3d.new(4000,0,0)
if v_17.length > 0
  d_17 = v_17.normalize
  p_17 = Geom::Vector3d.new(-d_17.y, d_17.x, 0)
  s_17 = Geom::Point3d.new(origin_x+0, origin_y+0, 0)
  e_17 = Geom::Point3d.new(origin_x+4000, origin_y+0, 0)
  ht = 100.mm / 2.0
  pts_17 = [s_17+p_17*ht, e_17+p_17*ht, e_17-p_17*ht, s_17-p_17*ht]
  f_17 = ents.add_face(pts_17)
  f_17.pushpull(3500) if f_17
  f_17.material = mat if f_17
  f_17.layer = layers['walls'] if f_17
end
# Wall 19
v_18 = Geom::Vector3d.new(4000,0,0)
if v_18.length > 0
  d_18 = v_18.normalize
  p_18 = Geom::Vector3d.new(-d_18.y, d_18.x, 0)
  s_18 = Geom::Point3d.new(origin_x+0, origin_y+0, 0)
  e_18 = Geom::Point3d.new(origin_x+4000, origin_y+0, 0)
  ht = 100.mm / 2.0
  pts_18 = [s_18+p_18*ht, e_18+p_18*ht, e_18-p_18*ht, s_18-p_18*ht]
  f_18 = ents.add_face(pts_18)
  f_18.pushpull(3500) if f_18
  f_18.material = mat if f_18
  f_18.layer = layers['walls'] if f_18
end
# Wall 20
v_19 = Geom::Vector3d.new(4000,0,0)
if v_19.length > 0
  d_19 = v_19.normalize
  p_19 = Geom::Vector3d.new(-d_19.y, d_19.x, 0)
  s_19 = Geom::Point3d.new(origin_x+0, origin_y+0, 0)
  e_19 = Geom::Point3d.new(origin_x+4000, origin_y+0, 0)
  ht = 100.mm / 2.0
  pts_19 = [s_19+p_19*ht, e_19+p_19*ht, e_19-p_19*ht, s_19-p_19*ht]
  f_19 = ents.add_face(pts_19)
  f_19.pushpull(3500) if f_19
  f_19.material = mat if f_19
  f_19.layer = layers['walls'] if f_19
end
# Wall 21
v_20 = Geom::Vector3d.new(4000,0,0)
if v_20.length > 0
  d_20 = v_20.normalize
  p_20 = Geom::Vector3d.new(-d_20.y, d_20.x, 0)
  s_20 = Geom::Point3d.new(origin_x+0, origin_y+0, 0)
  e_20 = Geom::Point3d.new(origin_x+4000, origin_y+0, 0)
  ht = 100.mm / 2.0
  pts_20 = [s_20+p_20*ht, e_20+p_20*ht, e_20-p_20*ht, s_20-p_20*ht]
  f_20 = ents.add_face(pts_20)
  f_20.pushpull(3500) if f_20
  f_20.material = mat if f_20
  f_20.layer = layers['walls'] if f_20
end
# Wall 22
v_21 = Geom::Vector3d.new(4000,0,0)
if v_21.length > 0
  d_21 = v_21.normalize
  p_21 = Geom::Vector3d.new(-d_21.y, d_21.x, 0)
  s_21 = Geom::Point3d.new(origin_x+0, origin_y+0, 0)
  e_21 = Geom::Point3d.new(origin_x+4000, origin_y+0, 0)
  ht = 100.mm / 2.0
  pts_21 = [s_21+p_21*ht, e_21+p_21*ht, e_21-p_21*ht, s_21-p_21*ht]
  f_21 = ents.add_face(pts_21)
  f_21.pushpull(3500) if f_21
  f_21.material = mat if f_21
  f_21.layer = layers['walls'] if f_21
end
# Wall 23
v_22 = Geom::Vector3d.new(4000,0,0)
if v_22.length > 0
  d_22 = v_22.normalize
  p_22 = Geom::Vector3d.new(-d_22.y, d_22.x, 0)
  s_22 = Geom::Point3d.new(origin_x+0, origin_y+0, 0)
  e_22 = Geom::Point3d.new(origin_x+4000, origin_y+0, 0)
  ht = 100.mm / 2.0
  pts_22 = [s_22+p_22*ht, e_22+p_22*ht, e_22-p_22*ht, s_22-p_22*ht]
  f_22 = ents.add_face(pts_22)
  f_22.pushpull(3500) if f_22
  f_22.material = mat if f_22
  f_22.layer = layers['walls'] if f_22
end
# Wall 24
v_23 = Geom::Vector3d.new(4000,0,0)
if v_23.length > 0
  d_23 = v_23.normalize
  p_23 = Geom::Vector3d.new(-d_23.y, d_23.x, 0)
  s_23 = Geom::Point3d.new(origin_x+0, origin_y+0, 0)
  e_23 = Geom::Point3d.new(origin_x+4000, origin_y+0, 0)
  ht = 250.mm / 2.0
  pts_23 = [s_23+p_23*ht, e_23+p_23*ht, e_23-p_23*ht, s_23-p_23*ht]
  f_23 = ents.add_face(pts_23)
  f_23.pushpull(3500) if f_23
  f_23.material = mat if f_23
  f_23.layer = layers['walls'] if f_23
end
# Wall 25
v_24 = Geom::Vector3d.new(4000,0,0)
if v_24.length > 0
  d_24 = v_24.normalize
  p_24 = Geom::Vector3d.new(-d_24.y, d_24.x, 0)
  s_24 = Geom::Point3d.new(origin_x+0, origin_y+0, 0)
  e_24 = Geom::Point3d.new(origin_x+4000, origin_y+0, 0)
  ht = 250.mm / 2.0
  pts_24 = [s_24+p_24*ht, e_24+p_24*ht, e_24-p_24*ht, s_24-p_24*ht]
  f_24 = ents.add_face(pts_24)
  f_24.pushpull(3500) if f_24
  f_24.material = mat if f_24
  f_24.layer = layers['walls'] if f_24
end
# Wall 26
v_25 = Geom::Vector3d.new(4000,0,0)
if v_25.length > 0
  d_25 = v_25.normalize
  p_25 = Geom::Vector3d.new(-d_25.y, d_25.x, 0)
  s_25 = Geom::Point3d.new(origin_x+0, origin_y+0, 0)
  e_25 = Geom::Point3d.new(origin_x+4000, origin_y+0, 0)
  ht = 250.mm / 2.0
  pts_25 = [s_25+p_25*ht, e_25+p_25*ht, e_25-p_25*ht, s_25-p_25*ht]
  f_25 = ents.add_face(pts_25)
  f_25.pushpull(3500) if f_25
  f_25.material = mat if f_25
  f_25.layer = layers['walls'] if f_25
end
# Wall 27
v_26 = Geom::Vector3d.new(4000,0,0)
if v_26.length > 0
  d_26 = v_26.normalize
  p_26 = Geom::Vector3d.new(-d_26.y, d_26.x, 0)
  s_26 = Geom::Point3d.new(origin_x+0, origin_y+0, 0)
  e_26 = Geom::Point3d.new(origin_x+4000, origin_y+0, 0)
  ht = 250.mm / 2.0
  pts_26 = [s_26+p_26*ht, e_26+p_26*ht, e_26-p_26*ht, s_26-p_26*ht]
  f_26 = ents.add_face(pts_26)
  f_26.pushpull(3500) if f_26
  f_26.material = mat if f_26
  f_26.layer = layers['walls'] if f_26
end
# Wall 28
v_27 = Geom::Vector3d.new(4000,0,0)
if v_27.length > 0
  d_27 = v_27.normalize
  p_27 = Geom::Vector3d.new(-d_27.y, d_27.x, 0)
  s_27 = Geom::Point3d.new(origin_x+0, origin_y+0, 0)
  e_27 = Geom::Point3d.new(origin_x+4000, origin_y+0, 0)
  ht = 250.mm / 2.0
  pts_27 = [s_27+p_27*ht, e_27+p_27*ht, e_27-p_27*ht, s_27-p_27*ht]
  f_27 = ents.add_face(pts_27)
  f_27.pushpull(3500) if f_27
  f_27.material = mat if f_27
  f_27.layer = layers['walls'] if f_27
end
# Wall 29
v_28 = Geom::Vector3d.new(4000,0,0)
if v_28.length > 0
  d_28 = v_28.normalize
  p_28 = Geom::Vector3d.new(-d_28.y, d_28.x, 0)
  s_28 = Geom::Point3d.new(origin_x+0, origin_y+0, 0)
  e_28 = Geom::Point3d.new(origin_x+4000, origin_y+0, 0)
  ht = 250.mm / 2.0
  pts_28 = [s_28+p_28*ht, e_28+p_28*ht, e_28-p_28*ht, s_28-p_28*ht]
  f_28 = ents.add_face(pts_28)
  f_28.pushpull(3500) if f_28
  f_28.material = mat if f_28
  f_28.layer = layers['walls'] if f_28
end
# Wall 30
v_29 = Geom::Vector3d.new(4000,0,0)
if v_29.length > 0
  d_29 = v_29.normalize
  p_29 = Geom::Vector3d.new(-d_29.y, d_29.x, 0)
  s_29 = Geom::Point3d.new(origin_x+0, origin_y+0, 0)
  e_29 = Geom::Point3d.new(origin_x+4000, origin_y+0, 0)
  ht = 250.mm / 2.0
  pts_29 = [s_29+p_29*ht, e_29+p_29*ht, e_29-p_29*ht, s_29-p_29*ht]
  f_29 = ents.add_face(pts_29)
  f_29.pushpull(3500) if f_29
  f_29.material = mat if f_29
  f_29.layer = layers['walls'] if f_29
end

model.commit_operation
UI.messagebox('Done: 25c 5b 3s 30w 0f')