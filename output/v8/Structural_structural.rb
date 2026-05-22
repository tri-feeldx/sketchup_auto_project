# SketchUp Structural Script
# Generated: 2026-05-22T14:20:05.437860
# Region: au

model = Sketchup.active_model
model.set_attribute('project','name',"THE UNIVERSITY OF NEW ENGLAND TAMWORTH CENTRAL CAMPUS")
model.set_attribute('project','revision',"B")
model.set_attribute('project','standard',"None")
ents = model.active_entities
model.start_operation('Structural Import', true)
defn = model.definitions

# ── Layers ──
layers = {
  'cols'  => model.layers.add('S_COLUMN'),
  'beams' => model.layers.add('S_BEAM'),
  'slabs' => model.layers.add('S_SLAB'),
  'walls' => model.layers.add('S_WALL'),
  'ftgs'  => model.layers.add('S_FOOTING'),
  'stairs'=> model.layers.add('S_STAIR'),
  'shafts'=> model.layers.add('S_SHAFT'),
}

# ── Materials ──
mat_c350l0 = model.materials.add('C350L0')
mat_c350l0.color = Sketchup::Color.new(190,190,190)
mat_concrete = model.materials.add('Concrete')
mat_concrete.color = Sketchup::Color.new(190,190,190)
mat_concrete = model.materials.add('concrete')
mat_concrete.color = Sketchup::Color.new(180,180,180)
mat_reinforced_concrete = model.materials.add('reinforced_concrete')
mat_reinforced_concrete.color = Sketchup::Color.new(190,190,190)

ox = 0; oy = 0; oz = 0

# === Columns ===
# Column 1: C1
pts_0 = [
  Geom::Point3d.new(ox+0, oy+16000, 0),
  Geom::Point3d.new(ox+400, oy+16000, 0),
  Geom::Point3d.new(ox+400, oy+16400, 0),
  Geom::Point3d.new(ox+0, oy+16400, 0)
]
f_0 = ents.add_face(pts_0)
f_0.material = mat_concrete if f_0
f_0.layer = layers['cols'] if f_0
f_0.pushpull(3500) if f_0
# Column 2: C2
pts_1 = [
  Geom::Point3d.new(ox+8000, oy+16000, 0),
  Geom::Point3d.new(ox+8400, oy+16000, 0),
  Geom::Point3d.new(ox+8400, oy+16400, 0),
  Geom::Point3d.new(ox+8000, oy+16400, 0)
]
f_1 = ents.add_face(pts_1)
f_1.material = mat_concrete if f_1
f_1.layer = layers['cols'] if f_1
f_1.pushpull(3500) if f_1
# Column 3: C3
pts_2 = [
  Geom::Point3d.new(ox+16000, oy+16000, 0),
  Geom::Point3d.new(ox+16400, oy+16000, 0),
  Geom::Point3d.new(ox+16400, oy+16400, 0),
  Geom::Point3d.new(ox+16000, oy+16400, 0)
]
f_2 = ents.add_face(pts_2)
f_2.material = mat_concrete if f_2
f_2.layer = layers['cols'] if f_2
f_2.pushpull(3500) if f_2
# Column 4: C4
pts_3 = [
  Geom::Point3d.new(ox+24000, oy+16000, 0),
  Geom::Point3d.new(ox+24400, oy+16000, 0),
  Geom::Point3d.new(ox+24400, oy+16400, 0),
  Geom::Point3d.new(ox+24000, oy+16400, 0)
]
f_3 = ents.add_face(pts_3)
f_3.material = mat_concrete if f_3
f_3.layer = layers['cols'] if f_3
f_3.pushpull(3500) if f_3
# Column 5: W1
pts_4 = [
  Geom::Point3d.new(ox+0, oy+8000, 0),
  Geom::Point3d.new(ox+400, oy+8000, 0),
  Geom::Point3d.new(ox+400, oy+8400, 0),
  Geom::Point3d.new(ox+0, oy+8400, 0)
]
f_4 = ents.add_face(pts_4)
f_4.material = mat_concrete if f_4
f_4.layer = layers['cols'] if f_4
f_4.pushpull(3500) if f_4
# Column 6: W2
pts_5 = [
  Geom::Point3d.new(ox+8000, oy+8000, 0),
  Geom::Point3d.new(ox+8400, oy+8000, 0),
  Geom::Point3d.new(ox+8400, oy+8400, 0),
  Geom::Point3d.new(ox+8000, oy+8400, 0)
]
f_5 = ents.add_face(pts_5)
f_5.material = mat_concrete if f_5
f_5.layer = layers['cols'] if f_5
f_5.pushpull(3500) if f_5
# Column 7: W3
pts_6 = [
  Geom::Point3d.new(ox+16000, oy+8000, 0),
  Geom::Point3d.new(ox+16400, oy+8000, 0),
  Geom::Point3d.new(ox+16400, oy+8400, 0),
  Geom::Point3d.new(ox+16000, oy+8400, 0)
]
f_6 = ents.add_face(pts_6)
f_6.material = mat_concrete if f_6
f_6.layer = layers['cols'] if f_6
f_6.pushpull(3500) if f_6
# Column 8: W4
pts_7 = [
  Geom::Point3d.new(ox+24000, oy+8000, 0),
  Geom::Point3d.new(ox+24400, oy+8000, 0),
  Geom::Point3d.new(ox+24400, oy+8400, 0),
  Geom::Point3d.new(ox+24000, oy+8400, 0)
]
f_7 = ents.add_face(pts_7)
f_7.material = mat_concrete if f_7
f_7.layer = layers['cols'] if f_7
f_7.pushpull(3500) if f_7
# Column 9: C5
pts_8 = [
  Geom::Point3d.new(ox+0, oy+0, 0),
  Geom::Point3d.new(ox+400, oy+0, 0),
  Geom::Point3d.new(ox+400, oy+400, 0),
  Geom::Point3d.new(ox+0, oy+400, 0)
]
f_8 = ents.add_face(pts_8)
f_8.material = mat_concrete if f_8
f_8.layer = layers['cols'] if f_8
f_8.pushpull(3500) if f_8
# Column 10: C6
pts_9 = [
  Geom::Point3d.new(ox+8000, oy+0, 0),
  Geom::Point3d.new(ox+8400, oy+0, 0),
  Geom::Point3d.new(ox+8400, oy+400, 0),
  Geom::Point3d.new(ox+8000, oy+400, 0)
]
f_9 = ents.add_face(pts_9)
f_9.material = mat_concrete if f_9
f_9.layer = layers['cols'] if f_9
f_9.pushpull(3500) if f_9
# Column 11: C7
pts_10 = [
  Geom::Point3d.new(ox+16000, oy+0, 0),
  Geom::Point3d.new(ox+16400, oy+0, 0),
  Geom::Point3d.new(ox+16400, oy+400, 0),
  Geom::Point3d.new(ox+16000, oy+400, 0)
]
f_10 = ents.add_face(pts_10)
f_10.material = mat_concrete if f_10
f_10.layer = layers['cols'] if f_10
f_10.pushpull(3500) if f_10
# Column 12: C8
pts_11 = [
  Geom::Point3d.new(ox+24000, oy+0, 0),
  Geom::Point3d.new(ox+24400, oy+0, 0),
  Geom::Point3d.new(ox+24400, oy+400, 0),
  Geom::Point3d.new(ox+24000, oy+400, 0)
]
f_11 = ents.add_face(pts_11)
f_11.material = mat_concrete if f_11
f_11.layer = layers['cols'] if f_11
f_11.pushpull(3500) if f_11
# Column 13: C9
pts_12 = [
  Geom::Point3d.new(ox+0, oy+18000, 0),
  Geom::Point3d.new(ox+400, oy+18000, 0),
  Geom::Point3d.new(ox+400, oy+18400, 0),
  Geom::Point3d.new(ox+0, oy+18400, 0)
]
f_12 = ents.add_face(pts_12)
f_12.material = mat_c350l0 if f_12
f_12.layer = layers['cols'] if f_12
f_12.pushpull(3500) if f_12
# Column 14: C10
pts_13 = [
  Geom::Point3d.new(ox+6000, oy+18000, 0),
  Geom::Point3d.new(ox+6400, oy+18000, 0),
  Geom::Point3d.new(ox+6400, oy+18400, 0),
  Geom::Point3d.new(ox+6000, oy+18400, 0)
]
f_13 = ents.add_face(pts_13)
f_13.material = mat_c350l0 if f_13
f_13.layer = layers['cols'] if f_13
f_13.pushpull(3500) if f_13
# Column 15: C11
pts_14 = [
  Geom::Point3d.new(ox+12000, oy+18000, 0),
  Geom::Point3d.new(ox+12400, oy+18000, 0),
  Geom::Point3d.new(ox+12400, oy+18400, 0),
  Geom::Point3d.new(ox+12000, oy+18400, 0)
]
f_14 = ents.add_face(pts_14)
f_14.material = mat_c350l0 if f_14
f_14.layer = layers['cols'] if f_14
f_14.pushpull(3500) if f_14
# Column 16: C12
pts_15 = [
  Geom::Point3d.new(ox+18000, oy+18000, 0),
  Geom::Point3d.new(ox+18400, oy+18000, 0),
  Geom::Point3d.new(ox+18400, oy+18400, 0),
  Geom::Point3d.new(ox+18000, oy+18400, 0)
]
f_15 = ents.add_face(pts_15)
f_15.material = mat_c350l0 if f_15
f_15.layer = layers['cols'] if f_15
f_15.pushpull(3500) if f_15
# Column 17: C13
pts_16 = [
  Geom::Point3d.new(ox+0, oy+24000, 0),
  Geom::Point3d.new(ox+400, oy+24000, 0),
  Geom::Point3d.new(ox+400, oy+24400, 0),
  Geom::Point3d.new(ox+0, oy+24400, 0)
]
f_16 = ents.add_face(pts_16)
f_16.material = mat_c350l0 if f_16
f_16.layer = layers['cols'] if f_16
f_16.pushpull(3500) if f_16
# Column 18: C14
pts_17 = [
  Geom::Point3d.new(ox+6000, oy+24000, 0),
  Geom::Point3d.new(ox+6400, oy+24000, 0),
  Geom::Point3d.new(ox+6400, oy+24400, 0),
  Geom::Point3d.new(ox+6000, oy+24400, 0)
]
f_17 = ents.add_face(pts_17)
f_17.material = mat_c350l0 if f_17
f_17.layer = layers['cols'] if f_17
f_17.pushpull(3500) if f_17
# Column 19: C15
pts_18 = [
  Geom::Point3d.new(ox+12000, oy+24000, 0),
  Geom::Point3d.new(ox+12400, oy+24000, 0),
  Geom::Point3d.new(ox+12400, oy+24400, 0),
  Geom::Point3d.new(ox+12000, oy+24400, 0)
]
f_18 = ents.add_face(pts_18)
f_18.material = mat_c350l0 if f_18
f_18.layer = layers['cols'] if f_18
f_18.pushpull(3500) if f_18
# Column 20: C16
pts_19 = [
  Geom::Point3d.new(ox+18000, oy+24000, 0),
  Geom::Point3d.new(ox+18400, oy+24000, 0),
  Geom::Point3d.new(ox+18400, oy+24400, 0),
  Geom::Point3d.new(ox+18000, oy+24400, 0)
]
f_19 = ents.add_face(pts_19)
f_19.material = mat_c350l0 if f_19
f_19.layer = layers['cols'] if f_19
f_19.pushpull(3500) if f_19
# Column 21: C-CH35a-1A
pts_20 = [
  Geom::Point3d.new(ox+0, oy+30000, 0),
  Geom::Point3d.new(ox+400, oy+30000, 0),
  Geom::Point3d.new(ox+400, oy+30400, 0),
  Geom::Point3d.new(ox+0, oy+30400, 0)
]
f_20 = ents.add_face(pts_20)
f_20.material = mat_c350l0 if f_20
f_20.layer = layers['cols'] if f_20
f_20.pushpull(3500) if f_20
# Column 22: C-CH35a-2A
pts_21 = [
  Geom::Point3d.new(ox+6000, oy+30000, 0),
  Geom::Point3d.new(ox+6400, oy+30000, 0),
  Geom::Point3d.new(ox+6400, oy+30400, 0),
  Geom::Point3d.new(ox+6000, oy+30400, 0)
]
f_21 = ents.add_face(pts_21)
f_21.material = mat_c350l0 if f_21
f_21.layer = layers['cols'] if f_21
f_21.pushpull(3500) if f_21
# Column 23: C-CH35a-3A
pts_22 = [
  Geom::Point3d.new(ox+12000, oy+30000, 0),
  Geom::Point3d.new(ox+12400, oy+30000, 0),
  Geom::Point3d.new(ox+12400, oy+30400, 0),
  Geom::Point3d.new(ox+12000, oy+30400, 0)
]
f_22 = ents.add_face(pts_22)
f_22.material = mat_c350l0 if f_22
f_22.layer = layers['cols'] if f_22
f_22.pushpull(3500) if f_22
# Column 24: C-CH35a-4A
pts_23 = [
  Geom::Point3d.new(ox+18000, oy+30000, 0),
  Geom::Point3d.new(ox+18400, oy+30000, 0),
  Geom::Point3d.new(ox+18400, oy+30400, 0),
  Geom::Point3d.new(ox+18000, oy+30400, 0)
]
f_23 = ents.add_face(pts_23)
f_23.material = mat_c350l0 if f_23
f_23.layer = layers['cols'] if f_23
f_23.pushpull(3500) if f_23
# Column 25: C-CH35a-1B
pts_24 = [
  Geom::Point3d.new(ox+0, oy+36000, 0),
  Geom::Point3d.new(ox+400, oy+36000, 0),
  Geom::Point3d.new(ox+400, oy+36400, 0),
  Geom::Point3d.new(ox+0, oy+36400, 0)
]
f_24 = ents.add_face(pts_24)
f_24.material = mat_c350l0 if f_24
f_24.layer = layers['cols'] if f_24
f_24.pushpull(3500) if f_24
# Column 26: C-CH35a-2B
pts_25 = [
  Geom::Point3d.new(ox+6000, oy+36000, 0),
  Geom::Point3d.new(ox+6400, oy+36000, 0),
  Geom::Point3d.new(ox+6400, oy+36400, 0),
  Geom::Point3d.new(ox+6000, oy+36400, 0)
]
f_25 = ents.add_face(pts_25)
f_25.material = mat_c350l0 if f_25
f_25.layer = layers['cols'] if f_25
f_25.pushpull(3500) if f_25
# Column 27: C-CH35a-3B
pts_26 = [
  Geom::Point3d.new(ox+12000, oy+36000, 0),
  Geom::Point3d.new(ox+12400, oy+36000, 0),
  Geom::Point3d.new(ox+12400, oy+36400, 0),
  Geom::Point3d.new(ox+12000, oy+36400, 0)
]
f_26 = ents.add_face(pts_26)
f_26.material = mat_c350l0 if f_26
f_26.layer = layers['cols'] if f_26
f_26.pushpull(3500) if f_26
# Column 28: C-CH35a-4B
pts_27 = [
  Geom::Point3d.new(ox+18000, oy+36000, 0),
  Geom::Point3d.new(ox+18400, oy+36000, 0),
  Geom::Point3d.new(ox+18400, oy+36400, 0),
  Geom::Point3d.new(ox+18000, oy+36400, 0)
]
f_27 = ents.add_face(pts_27)
f_27.material = mat_c350l0 if f_27
f_27.layer = layers['cols'] if f_27
f_27.pushpull(3500) if f_27
# Column 29: C-CH35a-1C
pts_28 = [
  Geom::Point3d.new(ox+0, oy+42000, 0),
  Geom::Point3d.new(ox+400, oy+42000, 0),
  Geom::Point3d.new(ox+400, oy+42400, 0),
  Geom::Point3d.new(ox+0, oy+42400, 0)
]
f_28 = ents.add_face(pts_28)
f_28.material = mat_c350l0 if f_28
f_28.layer = layers['cols'] if f_28
f_28.pushpull(3500) if f_28
# Column 30: C-CH35a-2C
pts_29 = [
  Geom::Point3d.new(ox+6000, oy+42000, 0),
  Geom::Point3d.new(ox+6400, oy+42000, 0),
  Geom::Point3d.new(ox+6400, oy+42400, 0),
  Geom::Point3d.new(ox+6000, oy+42400, 0)
]
f_29 = ents.add_face(pts_29)
f_29.material = mat_c350l0 if f_29
f_29.layer = layers['cols'] if f_29
f_29.pushpull(3500) if f_29
# Column 31: C-CH35a-3C
pts_30 = [
  Geom::Point3d.new(ox+12000, oy+42000, 0),
  Geom::Point3d.new(ox+12400, oy+42000, 0),
  Geom::Point3d.new(ox+12400, oy+42400, 0),
  Geom::Point3d.new(ox+12000, oy+42400, 0)
]
f_30 = ents.add_face(pts_30)
f_30.material = mat_c350l0 if f_30
f_30.layer = layers['cols'] if f_30
f_30.pushpull(3500) if f_30
# Column 32: C-CH35a-4C
pts_31 = [
  Geom::Point3d.new(ox+18000, oy+42000, 0),
  Geom::Point3d.new(ox+18400, oy+42000, 0),
  Geom::Point3d.new(ox+18400, oy+42400, 0),
  Geom::Point3d.new(ox+18000, oy+42400, 0)
]
f_31 = ents.add_face(pts_31)
f_31.material = mat_c350l0 if f_31
f_31.layer = layers['cols'] if f_31
f_31.pushpull(3500) if f_31
# Column 33: C-CH35a-1D
pts_32 = [
  Geom::Point3d.new(ox+0, oy+48000, 0),
  Geom::Point3d.new(ox+400, oy+48000, 0),
  Geom::Point3d.new(ox+400, oy+48400, 0),
  Geom::Point3d.new(ox+0, oy+48400, 0)
]
f_32 = ents.add_face(pts_32)
f_32.material = mat_c350l0 if f_32
f_32.layer = layers['cols'] if f_32
f_32.pushpull(3500) if f_32
# Column 34: C-CH35a-2D
pts_33 = [
  Geom::Point3d.new(ox+6000, oy+48000, 0),
  Geom::Point3d.new(ox+6400, oy+48000, 0),
  Geom::Point3d.new(ox+6400, oy+48400, 0),
  Geom::Point3d.new(ox+6000, oy+48400, 0)
]
f_33 = ents.add_face(pts_33)
f_33.material = mat_c350l0 if f_33
f_33.layer = layers['cols'] if f_33
f_33.pushpull(3500) if f_33
# Column 35: C-CH35a-3D
pts_34 = [
  Geom::Point3d.new(ox+12000, oy+48000, 0),
  Geom::Point3d.new(ox+12400, oy+48000, 0),
  Geom::Point3d.new(ox+12400, oy+48400, 0),
  Geom::Point3d.new(ox+12000, oy+48400, 0)
]
f_34 = ents.add_face(pts_34)
f_34.material = mat_c350l0 if f_34
f_34.layer = layers['cols'] if f_34
f_34.pushpull(3500) if f_34
# Column 36: C-CH35a-4D
pts_35 = [
  Geom::Point3d.new(ox+18000, oy+48000, 0),
  Geom::Point3d.new(ox+18400, oy+48000, 0),
  Geom::Point3d.new(ox+18400, oy+48400, 0),
  Geom::Point3d.new(ox+18000, oy+48400, 0)
]
f_35 = ents.add_face(pts_35)
f_35.material = mat_c350l0 if f_35
f_35.layer = layers['cols'] if f_35
f_35.pushpull(3500) if f_35
# Column 37: C-CH35b-1-AB
pts_36 = [
  Geom::Point3d.new(ox+0, oy+54000, 0),
  Geom::Point3d.new(ox+400, oy+54000, 0),
  Geom::Point3d.new(ox+400, oy+54400, 0),
  Geom::Point3d.new(ox+0, oy+54400, 0)
]
f_36 = ents.add_face(pts_36)
f_36.material = mat_c350l0 if f_36
f_36.layer = layers['cols'] if f_36
f_36.pushpull(3500) if f_36
# Column 38: C-CH35b-2-AB
pts_37 = [
  Geom::Point3d.new(ox+6000, oy+54000, 0),
  Geom::Point3d.new(ox+6400, oy+54000, 0),
  Geom::Point3d.new(ox+6400, oy+54400, 0),
  Geom::Point3d.new(ox+6000, oy+54400, 0)
]
f_37 = ents.add_face(pts_37)
f_37.material = mat_c350l0 if f_37
f_37.layer = layers['cols'] if f_37
f_37.pushpull(3500) if f_37
# Column 39: C-CH35b-3-AB
pts_38 = [
  Geom::Point3d.new(ox+12000, oy+54000, 0),
  Geom::Point3d.new(ox+12400, oy+54000, 0),
  Geom::Point3d.new(ox+12400, oy+54400, 0),
  Geom::Point3d.new(ox+12000, oy+54400, 0)
]
f_38 = ents.add_face(pts_38)
f_38.material = mat_c350l0 if f_38
f_38.layer = layers['cols'] if f_38
f_38.pushpull(3500) if f_38
# Column 40: C-CH35b-4-AB
pts_39 = [
  Geom::Point3d.new(ox+18000, oy+54000, 0),
  Geom::Point3d.new(ox+18400, oy+54000, 0),
  Geom::Point3d.new(ox+18400, oy+54400, 0),
  Geom::Point3d.new(ox+18000, oy+54400, 0)
]
f_39 = ents.add_face(pts_39)
f_39.material = mat_c350l0 if f_39
f_39.layer = layers['cols'] if f_39
f_39.pushpull(3500) if f_39
# Column 41: C-CH35b-1-BC
pts_40 = [
  Geom::Point3d.new(ox+0, oy+60000, 0),
  Geom::Point3d.new(ox+400, oy+60000, 0),
  Geom::Point3d.new(ox+400, oy+60400, 0),
  Geom::Point3d.new(ox+0, oy+60400, 0)
]
f_40 = ents.add_face(pts_40)
f_40.material = mat_c350l0 if f_40
f_40.layer = layers['cols'] if f_40
f_40.pushpull(3500) if f_40
# Column 42: C-CH35b-2-BC
pts_41 = [
  Geom::Point3d.new(ox+6000, oy+60000, 0),
  Geom::Point3d.new(ox+6400, oy+60000, 0),
  Geom::Point3d.new(ox+6400, oy+60400, 0),
  Geom::Point3d.new(ox+6000, oy+60400, 0)
]
f_41 = ents.add_face(pts_41)
f_41.material = mat_c350l0 if f_41
f_41.layer = layers['cols'] if f_41
f_41.pushpull(3500) if f_41
# Column 43: C-CH35b-3-BC
pts_42 = [
  Geom::Point3d.new(ox+12000, oy+60000, 0),
  Geom::Point3d.new(ox+12400, oy+60000, 0),
  Geom::Point3d.new(ox+12400, oy+60400, 0),
  Geom::Point3d.new(ox+12000, oy+60400, 0)
]
f_42 = ents.add_face(pts_42)
f_42.material = mat_c350l0 if f_42
f_42.layer = layers['cols'] if f_42
f_42.pushpull(3500) if f_42
# Column 44: C-CH35b-4-BC
pts_43 = [
  Geom::Point3d.new(ox+18000, oy+60000, 0),
  Geom::Point3d.new(ox+18400, oy+60000, 0),
  Geom::Point3d.new(ox+18400, oy+60400, 0),
  Geom::Point3d.new(ox+18000, oy+60400, 0)
]
f_43 = ents.add_face(pts_43)
f_43.material = mat_c350l0 if f_43
f_43.layer = layers['cols'] if f_43
f_43.pushpull(3500) if f_43
# Column 45: C-CH35b-1-CD
pts_44 = [
  Geom::Point3d.new(ox+0, oy+66000, 0),
  Geom::Point3d.new(ox+400, oy+66000, 0),
  Geom::Point3d.new(ox+400, oy+66400, 0),
  Geom::Point3d.new(ox+0, oy+66400, 0)
]
f_44 = ents.add_face(pts_44)
f_44.material = mat_c350l0 if f_44
f_44.layer = layers['cols'] if f_44
f_44.pushpull(3500) if f_44
# Column 46: C-CH35b-2-CD
pts_45 = [
  Geom::Point3d.new(ox+6000, oy+66000, 0),
  Geom::Point3d.new(ox+6400, oy+66000, 0),
  Geom::Point3d.new(ox+6400, oy+66400, 0),
  Geom::Point3d.new(ox+6000, oy+66400, 0)
]
f_45 = ents.add_face(pts_45)
f_45.material = mat_c350l0 if f_45
f_45.layer = layers['cols'] if f_45
f_45.pushpull(3500) if f_45
# Column 47: C-CH35b-3-CD
pts_46 = [
  Geom::Point3d.new(ox+12000, oy+66000, 0),
  Geom::Point3d.new(ox+12400, oy+66000, 0),
  Geom::Point3d.new(ox+12400, oy+66400, 0),
  Geom::Point3d.new(ox+12000, oy+66400, 0)
]
f_46 = ents.add_face(pts_46)
f_46.material = mat_c350l0 if f_46
f_46.layer = layers['cols'] if f_46
f_46.pushpull(3500) if f_46
# Column 48: C-CH35b-4-CD
pts_47 = [
  Geom::Point3d.new(ox+18000, oy+66000, 0),
  Geom::Point3d.new(ox+18400, oy+66000, 0),
  Geom::Point3d.new(ox+18400, oy+66400, 0),
  Geom::Point3d.new(ox+18000, oy+66400, 0)
]
f_47 = ents.add_face(pts_47)
f_47.material = mat_c350l0 if f_47
f_47.layer = layers['cols'] if f_47
f_47.pushpull(3500) if f_47
# Column 49: C-CH35c-12-A
pts_48 = [
  Geom::Point3d.new(ox+0, oy+72000, 0),
  Geom::Point3d.new(ox+400, oy+72000, 0),
  Geom::Point3d.new(ox+400, oy+72400, 0),
  Geom::Point3d.new(ox+0, oy+72400, 0)
]
f_48 = ents.add_face(pts_48)
f_48.material = mat_c350l0 if f_48
f_48.layer = layers['cols'] if f_48
f_48.pushpull(3500) if f_48
# Column 50: C-CH35c-23-A
pts_49 = [
  Geom::Point3d.new(ox+6000, oy+72000, 0),
  Geom::Point3d.new(ox+6400, oy+72000, 0),
  Geom::Point3d.new(ox+6400, oy+72400, 0),
  Geom::Point3d.new(ox+6000, oy+72400, 0)
]
f_49 = ents.add_face(pts_49)
f_49.material = mat_c350l0 if f_49
f_49.layer = layers['cols'] if f_49
f_49.pushpull(3500) if f_49
# Column 51: C-CH35c-34-A
pts_50 = [
  Geom::Point3d.new(ox+12000, oy+72000, 0),
  Geom::Point3d.new(ox+12400, oy+72000, 0),
  Geom::Point3d.new(ox+12400, oy+72400, 0),
  Geom::Point3d.new(ox+12000, oy+72400, 0)
]
f_50 = ents.add_face(pts_50)
f_50.material = mat_c350l0 if f_50
f_50.layer = layers['cols'] if f_50
f_50.pushpull(3500) if f_50
# Column 52: C-CH35c-12-B
pts_51 = [
  Geom::Point3d.new(ox+18000, oy+72000, 0),
  Geom::Point3d.new(ox+18400, oy+72000, 0),
  Geom::Point3d.new(ox+18400, oy+72400, 0),
  Geom::Point3d.new(ox+18000, oy+72400, 0)
]
f_51 = ents.add_face(pts_51)
f_51.material = mat_c350l0 if f_51
f_51.layer = layers['cols'] if f_51
f_51.pushpull(3500) if f_51
# Column 53: C-CH35c-23-B
pts_52 = [
  Geom::Point3d.new(ox+0, oy+78000, 0),
  Geom::Point3d.new(ox+400, oy+78000, 0),
  Geom::Point3d.new(ox+400, oy+78400, 0),
  Geom::Point3d.new(ox+0, oy+78400, 0)
]
f_52 = ents.add_face(pts_52)
f_52.material = mat_c350l0 if f_52
f_52.layer = layers['cols'] if f_52
f_52.pushpull(3500) if f_52
# Column 54: C-CH35c-34-B
pts_53 = [
  Geom::Point3d.new(ox+6000, oy+78000, 0),
  Geom::Point3d.new(ox+6400, oy+78000, 0),
  Geom::Point3d.new(ox+6400, oy+78400, 0),
  Geom::Point3d.new(ox+6000, oy+78400, 0)
]
f_53 = ents.add_face(pts_53)
f_53.material = mat_c350l0 if f_53
f_53.layer = layers['cols'] if f_53
f_53.pushpull(3500) if f_53
# Column 55: C-CH35c-12-C
pts_54 = [
  Geom::Point3d.new(ox+12000, oy+78000, 0),
  Geom::Point3d.new(ox+12400, oy+78000, 0),
  Geom::Point3d.new(ox+12400, oy+78400, 0),
  Geom::Point3d.new(ox+12000, oy+78400, 0)
]
f_54 = ents.add_face(pts_54)
f_54.material = mat_c350l0 if f_54
f_54.layer = layers['cols'] if f_54
f_54.pushpull(3500) if f_54
# Column 56: C-CH35c-23-C
pts_55 = [
  Geom::Point3d.new(ox+18000, oy+78000, 0),
  Geom::Point3d.new(ox+18400, oy+78000, 0),
  Geom::Point3d.new(ox+18400, oy+78400, 0),
  Geom::Point3d.new(ox+18000, oy+78400, 0)
]
f_55 = ents.add_face(pts_55)
f_55.material = mat_c350l0 if f_55
f_55.layer = layers['cols'] if f_55
f_55.pushpull(3500) if f_55
# Column 57: C-CH35c-34-C
pts_56 = [
  Geom::Point3d.new(ox+0, oy+84000, 0),
  Geom::Point3d.new(ox+400, oy+84000, 0),
  Geom::Point3d.new(ox+400, oy+84400, 0),
  Geom::Point3d.new(ox+0, oy+84400, 0)
]
f_56 = ents.add_face(pts_56)
f_56.material = mat_c350l0 if f_56
f_56.layer = layers['cols'] if f_56
f_56.pushpull(3500) if f_56
# Column 58: C-CH35c-12-D
pts_57 = [
  Geom::Point3d.new(ox+6000, oy+84000, 0),
  Geom::Point3d.new(ox+6400, oy+84000, 0),
  Geom::Point3d.new(ox+6400, oy+84400, 0),
  Geom::Point3d.new(ox+6000, oy+84400, 0)
]
f_57 = ents.add_face(pts_57)
f_57.material = mat_c350l0 if f_57
f_57.layer = layers['cols'] if f_57
f_57.pushpull(3500) if f_57
# Column 59: C-CH35c-23-D
pts_58 = [
  Geom::Point3d.new(ox+12000, oy+84000, 0),
  Geom::Point3d.new(ox+12400, oy+84000, 0),
  Geom::Point3d.new(ox+12400, oy+84400, 0),
  Geom::Point3d.new(ox+12000, oy+84400, 0)
]
f_58 = ents.add_face(pts_58)
f_58.material = mat_c350l0 if f_58
f_58.layer = layers['cols'] if f_58
f_58.pushpull(3500) if f_58
# Column 60: C-CH35c-34-D
pts_59 = [
  Geom::Point3d.new(ox+18000, oy+84000, 0),
  Geom::Point3d.new(ox+18400, oy+84000, 0),
  Geom::Point3d.new(ox+18400, oy+84400, 0),
  Geom::Point3d.new(ox+18000, oy+84400, 0)
]
f_59 = ents.add_face(pts_59)
f_59.material = mat_c350l0 if f_59
f_59.layer = layers['cols'] if f_59
f_59.pushpull(3500) if f_59
# Column 61: Concrete Column D-S9
pts_60 = [
  Geom::Point3d.new(ox+24000, oy+90000, 0),
  Geom::Point3d.new(ox+24400, oy+90000, 0),
  Geom::Point3d.new(ox+24400, oy+90400, 0),
  Geom::Point3d.new(ox+24000, oy+90400, 0)
]
f_60 = ents.add_face(pts_60)
f_60.material = mat_concrete if f_60
f_60.layer = layers['cols'] if f_60
f_60.pushpull(3500) if f_60
# Column 62: Concrete Column C-S9
pts_61 = [
  Geom::Point3d.new(ox+24000, oy+90000, 0),
  Geom::Point3d.new(ox+24400, oy+90000, 0),
  Geom::Point3d.new(ox+24400, oy+90400, 0),
  Geom::Point3d.new(ox+24000, oy+90400, 0)
]
f_61 = ents.add_face(pts_61)
f_61.material = mat_concrete if f_61
f_61.layer = layers['cols'] if f_61
f_61.pushpull(3500) if f_61
# Column 63: Concrete Column B-S9
pts_62 = [
  Geom::Point3d.new(ox+24000, oy+90000, 0),
  Geom::Point3d.new(ox+24400, oy+90000, 0),
  Geom::Point3d.new(ox+24400, oy+90400, 0),
  Geom::Point3d.new(ox+24000, oy+90400, 0)
]
f_62 = ents.add_face(pts_62)
f_62.material = mat_concrete if f_62
f_62.layer = layers['cols'] if f_62
f_62.pushpull(3500) if f_62
# Column 64: Concrete Column A-S10
pts_63 = [
  Geom::Point3d.new(ox+24000, oy+90000, 0),
  Geom::Point3d.new(ox+24400, oy+90000, 0),
  Geom::Point3d.new(ox+24400, oy+90400, 0),
  Geom::Point3d.new(ox+24000, oy+90400, 0)
]
f_63 = ents.add_face(pts_63)
f_63.material = mat_concrete if f_63
f_63.layer = layers['cols'] if f_63
f_63.pushpull(3500) if f_63
# Column 65: Concrete Column B-S10
pts_64 = [
  Geom::Point3d.new(ox+24000, oy+96000, 0),
  Geom::Point3d.new(ox+24400, oy+96000, 0),
  Geom::Point3d.new(ox+24400, oy+96400, 0),
  Geom::Point3d.new(ox+24000, oy+96400, 0)
]
f_64 = ents.add_face(pts_64)
f_64.material = mat_concrete if f_64
f_64.layer = layers['cols'] if f_64
f_64.pushpull(3500) if f_64
# Column 66: Concrete Column C-S10
pts_65 = [
  Geom::Point3d.new(ox+24000, oy+96000, 0),
  Geom::Point3d.new(ox+24400, oy+96000, 0),
  Geom::Point3d.new(ox+24400, oy+96400, 0),
  Geom::Point3d.new(ox+24000, oy+96400, 0)
]
f_65 = ents.add_face(pts_65)
f_65.material = mat_concrete if f_65
f_65.layer = layers['cols'] if f_65
f_65.pushpull(3500) if f_65
# Column 67: Concrete Column 4-S11
pts_66 = [
  Geom::Point3d.new(ox+24000, oy+96000, 0),
  Geom::Point3d.new(ox+24400, oy+96000, 0),
  Geom::Point3d.new(ox+24400, oy+96400, 0),
  Geom::Point3d.new(ox+24000, oy+96400, 0)
]
f_66 = ents.add_face(pts_66)
f_66.material = mat_concrete if f_66
f_66.layer = layers['cols'] if f_66
f_66.pushpull(3500) if f_66
# Column 68: Concrete Column 3-S11
pts_67 = [
  Geom::Point3d.new(ox+16000, oy+96000, 0),
  Geom::Point3d.new(ox+16400, oy+96000, 0),
  Geom::Point3d.new(ox+16400, oy+96400, 0),
  Geom::Point3d.new(ox+16000, oy+96400, 0)
]
f_67 = ents.add_face(pts_67)
f_67.material = mat_concrete if f_67
f_67.layer = layers['cols'] if f_67
f_67.pushpull(3500) if f_67
# Column 69: Concrete Column 2-S11
pts_68 = [
  Geom::Point3d.new(ox+8000, oy+102000, 0),
  Geom::Point3d.new(ox+8400, oy+102000, 0),
  Geom::Point3d.new(ox+8400, oy+102400, 0),
  Geom::Point3d.new(ox+8000, oy+102400, 0)
]
f_68 = ents.add_face(pts_68)
f_68.material = mat_concrete if f_68
f_68.layer = layers['cols'] if f_68
f_68.pushpull(3500) if f_68
# Column 70: Concrete Column 1-S11
pts_69 = [
  Geom::Point3d.new(ox+0, oy+102000, 0),
  Geom::Point3d.new(ox+400, oy+102000, 0),
  Geom::Point3d.new(ox+400, oy+102400, 0),
  Geom::Point3d.new(ox+0, oy+102400, 0)
]
f_69 = ents.add_face(pts_69)
f_69.material = mat_concrete if f_69
f_69.layer = layers['cols'] if f_69
f_69.pushpull(3500) if f_69
# Column 71: C_1_A
pts_70 = [
  Geom::Point3d.new(ox+0, oy+9000, 0),
  Geom::Point3d.new(ox+400, oy+9000, 0),
  Geom::Point3d.new(ox+400, oy+9400, 0),
  Geom::Point3d.new(ox+0, oy+9400, 0)
]
f_70 = ents.add_face(pts_70)
f_70.material = mat_concrete if f_70
f_70.layer = layers['cols'] if f_70
f_70.pushpull(3500) if f_70
# Column 72: C_2_A
pts_71 = [
  Geom::Point3d.new(ox+3000, oy+9000, 0),
  Geom::Point3d.new(ox+3400, oy+9000, 0),
  Geom::Point3d.new(ox+3400, oy+9400, 0),
  Geom::Point3d.new(ox+3000, oy+9400, 0)
]
f_71 = ents.add_face(pts_71)
f_71.material = mat_concrete if f_71
f_71.layer = layers['cols'] if f_71
f_71.pushpull(3500) if f_71
# Column 73: C_3_A
pts_72 = [
  Geom::Point3d.new(ox+6000, oy+9000, 0),
  Geom::Point3d.new(ox+6400, oy+9000, 0),
  Geom::Point3d.new(ox+6400, oy+9400, 0),
  Geom::Point3d.new(ox+6000, oy+9400, 0)
]
f_72 = ents.add_face(pts_72)
f_72.material = mat_concrete if f_72
f_72.layer = layers['cols'] if f_72
f_72.pushpull(3500) if f_72
# Column 74: C_4_A
pts_73 = [
  Geom::Point3d.new(ox+9000, oy+9000, 0),
  Geom::Point3d.new(ox+9400, oy+9000, 0),
  Geom::Point3d.new(ox+9400, oy+9400, 0),
  Geom::Point3d.new(ox+9000, oy+9400, 0)
]
f_73 = ents.add_face(pts_73)
f_73.material = mat_concrete if f_73
f_73.layer = layers['cols'] if f_73
f_73.pushpull(3500) if f_73
# Column 75: C_1_B
pts_74 = [
  Geom::Point3d.new(ox+0, oy+6000, 0),
  Geom::Point3d.new(ox+400, oy+6000, 0),
  Geom::Point3d.new(ox+400, oy+6400, 0),
  Geom::Point3d.new(ox+0, oy+6400, 0)
]
f_74 = ents.add_face(pts_74)
f_74.material = mat_concrete if f_74
f_74.layer = layers['cols'] if f_74
f_74.pushpull(3500) if f_74
# Column 76: C_2_B
pts_75 = [
  Geom::Point3d.new(ox+3000, oy+6000, 0),
  Geom::Point3d.new(ox+3400, oy+6000, 0),
  Geom::Point3d.new(ox+3400, oy+6400, 0),
  Geom::Point3d.new(ox+3000, oy+6400, 0)
]
f_75 = ents.add_face(pts_75)
f_75.material = mat_concrete if f_75
f_75.layer = layers['cols'] if f_75
f_75.pushpull(3500) if f_75
# Column 77: C_3_B
pts_76 = [
  Geom::Point3d.new(ox+6000, oy+6000, 0),
  Geom::Point3d.new(ox+6400, oy+6000, 0),
  Geom::Point3d.new(ox+6400, oy+6400, 0),
  Geom::Point3d.new(ox+6000, oy+6400, 0)
]
f_76 = ents.add_face(pts_76)
f_76.material = mat_concrete if f_76
f_76.layer = layers['cols'] if f_76
f_76.pushpull(3500) if f_76
# Column 78: C_4_B
pts_77 = [
  Geom::Point3d.new(ox+9000, oy+6000, 0),
  Geom::Point3d.new(ox+9400, oy+6000, 0),
  Geom::Point3d.new(ox+9400, oy+6400, 0),
  Geom::Point3d.new(ox+9000, oy+6400, 0)
]
f_77 = ents.add_face(pts_77)
f_77.material = mat_concrete if f_77
f_77.layer = layers['cols'] if f_77
f_77.pushpull(3500) if f_77
# Column 79: C_1_C
pts_78 = [
  Geom::Point3d.new(ox+0, oy+3000, 0),
  Geom::Point3d.new(ox+400, oy+3000, 0),
  Geom::Point3d.new(ox+400, oy+3400, 0),
  Geom::Point3d.new(ox+0, oy+3400, 0)
]
f_78 = ents.add_face(pts_78)
f_78.material = mat_concrete if f_78
f_78.layer = layers['cols'] if f_78
f_78.pushpull(3500) if f_78
# Column 80: C_2_C
pts_79 = [
  Geom::Point3d.new(ox+3000, oy+3000, 0),
  Geom::Point3d.new(ox+3400, oy+3000, 0),
  Geom::Point3d.new(ox+3400, oy+3400, 0),
  Geom::Point3d.new(ox+3000, oy+3400, 0)
]
f_79 = ents.add_face(pts_79)
f_79.material = mat_concrete if f_79
f_79.layer = layers['cols'] if f_79
f_79.pushpull(3500) if f_79
# Column 81: C_3_C
pts_80 = [
  Geom::Point3d.new(ox+6000, oy+3000, 0),
  Geom::Point3d.new(ox+6400, oy+3000, 0),
  Geom::Point3d.new(ox+6400, oy+3400, 0),
  Geom::Point3d.new(ox+6000, oy+3400, 0)
]
f_80 = ents.add_face(pts_80)
f_80.material = mat_concrete if f_80
f_80.layer = layers['cols'] if f_80
f_80.pushpull(3500) if f_80
# Column 82: C_4_C
pts_81 = [
  Geom::Point3d.new(ox+9000, oy+3000, 0),
  Geom::Point3d.new(ox+9400, oy+3000, 0),
  Geom::Point3d.new(ox+9400, oy+3400, 0),
  Geom::Point3d.new(ox+9000, oy+3400, 0)
]
f_81 = ents.add_face(pts_81)
f_81.material = mat_concrete if f_81
f_81.layer = layers['cols'] if f_81
f_81.pushpull(3500) if f_81
# Column 83: C_1_D
pts_82 = [
  Geom::Point3d.new(ox+0, oy+0, 0),
  Geom::Point3d.new(ox+400, oy+0, 0),
  Geom::Point3d.new(ox+400, oy+400, 0),
  Geom::Point3d.new(ox+0, oy+400, 0)
]
f_82 = ents.add_face(pts_82)
f_82.material = mat_concrete if f_82
f_82.layer = layers['cols'] if f_82
f_82.pushpull(3500) if f_82
# Column 84: C_2_D
pts_83 = [
  Geom::Point3d.new(ox+3000, oy+0, 0),
  Geom::Point3d.new(ox+3400, oy+0, 0),
  Geom::Point3d.new(ox+3400, oy+400, 0),
  Geom::Point3d.new(ox+3000, oy+400, 0)
]
f_83 = ents.add_face(pts_83)
f_83.material = mat_concrete if f_83
f_83.layer = layers['cols'] if f_83
f_83.pushpull(3500) if f_83
# Column 85: C_3_D
pts_84 = [
  Geom::Point3d.new(ox+6000, oy+0, 0),
  Geom::Point3d.new(ox+6400, oy+0, 0),
  Geom::Point3d.new(ox+6400, oy+400, 0),
  Geom::Point3d.new(ox+6000, oy+400, 0)
]
f_84 = ents.add_face(pts_84)
f_84.material = mat_concrete if f_84
f_84.layer = layers['cols'] if f_84
f_84.pushpull(3500) if f_84
# Column 86: C_4_D
pts_85 = [
  Geom::Point3d.new(ox+9000, oy+0, 0),
  Geom::Point3d.new(ox+9400, oy+0, 0),
  Geom::Point3d.new(ox+9400, oy+400, 0),
  Geom::Point3d.new(ox+9000, oy+400, 0)
]
f_85 = ents.add_face(pts_85)
f_85.material = mat_concrete if f_85
f_85.layer = layers['cols'] if f_85
f_85.pushpull(3500) if f_85
# Column 87: C_2A
pts_86 = [
  Geom::Point3d.new(ox+8000, oy+24000, 0),
  Geom::Point3d.new(ox+8400, oy+24000, 0),
  Geom::Point3d.new(ox+8400, oy+24400, 0),
  Geom::Point3d.new(ox+8000, oy+24400, 0)
]
f_86 = ents.add_face(pts_86)
f_86.material = mat_c350l0 if f_86
f_86.layer = layers['cols'] if f_86
f_86.pushpull(3500) if f_86
# Column 88: C_3A
pts_87 = [
  Geom::Point3d.new(ox+16000, oy+24000, 0),
  Geom::Point3d.new(ox+16400, oy+24000, 0),
  Geom::Point3d.new(ox+16400, oy+24400, 0),
  Geom::Point3d.new(ox+16000, oy+24400, 0)
]
f_87 = ents.add_face(pts_87)
f_87.material = mat_c350l0 if f_87
f_87.layer = layers['cols'] if f_87
f_87.pushpull(3500) if f_87
# Column 89: C_4A
pts_88 = [
  Geom::Point3d.new(ox+24000, oy+24000, 0),
  Geom::Point3d.new(ox+24400, oy+24000, 0),
  Geom::Point3d.new(ox+24400, oy+24400, 0),
  Geom::Point3d.new(ox+24000, oy+24400, 0)
]
f_88 = ents.add_face(pts_88)
f_88.material = mat_c350l0 if f_88
f_88.layer = layers['cols'] if f_88
f_88.pushpull(3500) if f_88
# Column 90: C_4B
pts_89 = [
  Geom::Point3d.new(ox+24000, oy+16000, 0),
  Geom::Point3d.new(ox+24400, oy+16000, 0),
  Geom::Point3d.new(ox+24400, oy+16400, 0),
  Geom::Point3d.new(ox+24000, oy+16400, 0)
]
f_89 = ents.add_face(pts_89)
f_89.material = mat_c350l0 if f_89
f_89.layer = layers['cols'] if f_89
f_89.pushpull(3500) if f_89
# Column 91: C_4C
pts_90 = [
  Geom::Point3d.new(ox+24000, oy+8000, 0),
  Geom::Point3d.new(ox+24400, oy+8000, 0),
  Geom::Point3d.new(ox+24400, oy+8400, 0),
  Geom::Point3d.new(ox+24000, oy+8400, 0)
]
f_90 = ents.add_face(pts_90)
f_90.material = mat_c350l0 if f_90
f_90.layer = layers['cols'] if f_90
f_90.pushpull(3500) if f_90
# Column 92: C_4D
pts_91 = [
  Geom::Point3d.new(ox+24000, oy+0, 0),
  Geom::Point3d.new(ox+24400, oy+0, 0),
  Geom::Point3d.new(ox+24400, oy+400, 0),
  Geom::Point3d.new(ox+24000, oy+400, 0)
]
f_91 = ents.add_face(pts_91)
f_91.material = mat_c350l0 if f_91
f_91.layer = layers['cols'] if f_91
f_91.pushpull(3500) if f_91
# Column 93: C_3D
pts_92 = [
  Geom::Point3d.new(ox+16000, oy+0, 0),
  Geom::Point3d.new(ox+16400, oy+0, 0),
  Geom::Point3d.new(ox+16400, oy+400, 0),
  Geom::Point3d.new(ox+16000, oy+400, 0)
]
f_92 = ents.add_face(pts_92)
f_92.material = mat_c350l0 if f_92
f_92.layer = layers['cols'] if f_92
f_92.pushpull(3500) if f_92
# Column 94: C_2D
pts_93 = [
  Geom::Point3d.new(ox+8000, oy+0, 0),
  Geom::Point3d.new(ox+8400, oy+0, 0),
  Geom::Point3d.new(ox+8400, oy+400, 0),
  Geom::Point3d.new(ox+8000, oy+400, 0)
]
f_93 = ents.add_face(pts_93)
f_93.material = mat_c350l0 if f_93
f_93.layer = layers['cols'] if f_93
f_93.pushpull(3500) if f_93
# Column 95: C_2B
pts_94 = [
  Geom::Point3d.new(ox+8000, oy+16000, 0),
  Geom::Point3d.new(ox+8400, oy+16000, 0),
  Geom::Point3d.new(ox+8400, oy+16400, 0),
  Geom::Point3d.new(ox+8000, oy+16400, 0)
]
f_94 = ents.add_face(pts_94)
f_94.material = mat_c350l0 if f_94
f_94.layer = layers['cols'] if f_94
f_94.pushpull(3500) if f_94
# Column 96: C_3B
pts_95 = [
  Geom::Point3d.new(ox+16000, oy+16000, 0),
  Geom::Point3d.new(ox+16400, oy+16000, 0),
  Geom::Point3d.new(ox+16400, oy+16400, 0),
  Geom::Point3d.new(ox+16000, oy+16400, 0)
]
f_95 = ents.add_face(pts_95)
f_95.material = mat_c350l0 if f_95
f_95.layer = layers['cols'] if f_95
f_95.pushpull(3500) if f_95
# Column 97: C_2C
pts_96 = [
  Geom::Point3d.new(ox+8000, oy+8000, 0),
  Geom::Point3d.new(ox+8400, oy+8000, 0),
  Geom::Point3d.new(ox+8400, oy+8400, 0),
  Geom::Point3d.new(ox+8000, oy+8400, 0)
]
f_96 = ents.add_face(pts_96)
f_96.material = mat_c350l0 if f_96
f_96.layer = layers['cols'] if f_96
f_96.pushpull(3500) if f_96
# Column 98: C_3C
pts_97 = [
  Geom::Point3d.new(ox+16000, oy+8000, 0),
  Geom::Point3d.new(ox+16400, oy+8000, 0),
  Geom::Point3d.new(ox+16400, oy+8400, 0),
  Geom::Point3d.new(ox+16000, oy+8400, 0)
]
f_97 = ents.add_face(pts_97)
f_97.material = mat_c350l0 if f_97
f_97.layer = layers['cols'] if f_97
f_97.pushpull(3500) if f_97
# Column 99: Generic Column for Wall Connection
pts_98 = [
  Geom::Point3d.new(ox+12000, oy+144000, 0),
  Geom::Point3d.new(ox+12400, oy+144000, 0),
  Geom::Point3d.new(ox+12400, oy+144400, 0),
  Geom::Point3d.new(ox+12000, oy+144400, 0)
]
f_98 = ents.add_face(pts_98)
f_98.material = mat_c350l0 if f_98
f_98.layer = layers['cols'] if f_98
f_98.pushpull(3500) if f_98

# === Beams ===
# Beam 1: UB36b →
bx1_0 = ox + 0; by1_0 = oy + 0
bx2_0 = ox + 8000; by2_0 = oy + 0
bdx_0 = bx2_0 - bx1_0; bdy_0 = by2_0 - by1_0
blen_0 = Math.sqrt(bdx_0*bdx_0 + bdy_0*bdy_0)
if blen_0 > 0
  bang_0 = Math.atan2(bdy_0, bdx_0)
  bpt_0 = Geom::Point3d.new(bx1_0, by1_0, 3500)
  btr_0 = Geom::Transformation.translation(bpt_0)
  btr_0 = btr_0 * Geom::Transformation.rotation(bpt_0, [0,0,1], bang_0)
  bg_0 = ents.add_group
  bg_0.transformation = btr_0
  pts_0 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_0, 0, 0),
    Geom::Point3d.new(blen_0, 36, 0),
    Geom::Point3d.new(0, 36, 0)
  ]
  bf_0 = bg_0.entities.add_face(pts_0)
  bf_0.material = mat_c350l0 if bf_0
  bf_0.pushpull(-36) if bf_0
  bg_0.layer = layers['beams']
end
# Beam 2: UB31b →
bx1_1 = ox + 8000; by1_1 = oy + 0
bx2_1 = ox + 16000; by2_1 = oy + 0
bdx_1 = bx2_1 - bx1_1; bdy_1 = by2_1 - by1_1
blen_1 = Math.sqrt(bdx_1*bdx_1 + bdy_1*bdy_1)
if blen_1 > 0
  bang_1 = Math.atan2(bdy_1, bdx_1)
  bpt_1 = Geom::Point3d.new(bx1_1, by1_1, 3500)
  btr_1 = Geom::Transformation.translation(bpt_1)
  btr_1 = btr_1 * Geom::Transformation.rotation(bpt_1, [0,0,1], bang_1)
  bg_1 = ents.add_group
  bg_1.transformation = btr_1
  pts_1 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_1, 0, 0),
    Geom::Point3d.new(blen_1, 31, 0),
    Geom::Point3d.new(0, 31, 0)
  ]
  bf_1 = bg_1.entities.add_face(pts_1)
  bf_1.material = mat_c350l0 if bf_1
  bf_1.pushpull(-31) if bf_1
  bg_1.layer = layers['beams']
end
# Beam 3: UB20c →
bx1_2 = ox + 16000; by1_2 = oy + 0
bx2_2 = ox + 24000; by2_2 = oy + 0
bdx_2 = bx2_2 - bx1_2; bdy_2 = by2_2 - by1_2
blen_2 = Math.sqrt(bdx_2*bdx_2 + bdy_2*bdy_2)
if blen_2 > 0
  bang_2 = Math.atan2(bdy_2, bdx_2)
  bpt_2 = Geom::Point3d.new(bx1_2, by1_2, 3500)
  btr_2 = Geom::Transformation.translation(bpt_2)
  btr_2 = btr_2 * Geom::Transformation.rotation(bpt_2, [0,0,1], bang_2)
  bg_2 = ents.add_group
  bg_2.transformation = btr_2
  pts_2 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_2, 0, 0),
    Geom::Point3d.new(blen_2, 20, 0),
    Geom::Point3d.new(0, 20, 0)
  ]
  bf_2 = bg_2.entities.add_face(pts_2)
  bf_2.material = mat_c350l0 if bf_2
  bf_2.pushpull(-20) if bf_2
  bg_2.layer = layers['beams']
end
# Beam 4: UB36c →
bx1_3 = ox + 0; by1_3 = oy + 8000
bx2_3 = ox + 8000; by2_3 = oy + 8000
bdx_3 = bx2_3 - bx1_3; bdy_3 = by2_3 - by1_3
blen_3 = Math.sqrt(bdx_3*bdx_3 + bdy_3*bdy_3)
if blen_3 > 0
  bang_3 = Math.atan2(bdy_3, bdx_3)
  bpt_3 = Geom::Point3d.new(bx1_3, by1_3, 3500)
  btr_3 = Geom::Transformation.translation(bpt_3)
  btr_3 = btr_3 * Geom::Transformation.rotation(bpt_3, [0,0,1], bang_3)
  bg_3 = ents.add_group
  bg_3.transformation = btr_3
  pts_3 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_3, 0, 0),
    Geom::Point3d.new(blen_3, 36, 0),
    Geom::Point3d.new(0, 36, 0)
  ]
  bf_3 = bg_3.entities.add_face(pts_3)
  bf_3.material = mat_c350l0 if bf_3
  bf_3.pushpull(-36) if bf_3
  bg_3.layer = layers['beams']
end
# Beam 5: UB20d →
bx1_4 = ox + 8000; by1_4 = oy + 8000
bx2_4 = ox + 16000; by2_4 = oy + 8000
bdx_4 = bx2_4 - bx1_4; bdy_4 = by2_4 - by1_4
blen_4 = Math.sqrt(bdx_4*bdx_4 + bdy_4*bdy_4)
if blen_4 > 0
  bang_4 = Math.atan2(bdy_4, bdx_4)
  bpt_4 = Geom::Point3d.new(bx1_4, by1_4, 3500)
  btr_4 = Geom::Transformation.translation(bpt_4)
  btr_4 = btr_4 * Geom::Transformation.rotation(bpt_4, [0,0,1], bang_4)
  bg_4 = ents.add_group
  bg_4.transformation = btr_4
  pts_4 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_4, 0, 0),
    Geom::Point3d.new(blen_4, 20, 0),
    Geom::Point3d.new(0, 20, 0)
  ]
  bf_4 = bg_4.entities.add_face(pts_4)
  bf_4.material = mat_c350l0 if bf_4
  bf_4.pushpull(-20) if bf_4
  bg_4.layer = layers['beams']
end
# Beam 6: PF25a →
bx1_5 = ox + 16000; by1_5 = oy + 8000
bx2_5 = ox + 24000; by2_5 = oy + 8000
bdx_5 = bx2_5 - bx1_5; bdy_5 = by2_5 - by1_5
blen_5 = Math.sqrt(bdx_5*bdx_5 + bdy_5*bdy_5)
if blen_5 > 0
  bang_5 = Math.atan2(bdy_5, bdx_5)
  bpt_5 = Geom::Point3d.new(bx1_5, by1_5, 3500)
  btr_5 = Geom::Transformation.translation(bpt_5)
  btr_5 = btr_5 * Geom::Transformation.rotation(bpt_5, [0,0,1], bang_5)
  bg_5 = ents.add_group
  bg_5.transformation = btr_5
  pts_5 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_5, 0, 0),
    Geom::Point3d.new(blen_5, 25, 0),
    Geom::Point3d.new(0, 25, 0)
  ]
  bf_5 = bg_5.entities.add_face(pts_5)
  bf_5.material = mat_c350l0 if bf_5
  bf_5.pushpull(-25) if bf_5
  bg_5.layer = layers['beams']
end
# Beam 7: PF15a →
bx1_6 = ox + 0; by1_6 = oy + 16000
bx2_6 = ox + 8000; by2_6 = oy + 16000
bdx_6 = bx2_6 - bx1_6; bdy_6 = by2_6 - by1_6
blen_6 = Math.sqrt(bdx_6*bdx_6 + bdy_6*bdy_6)
if blen_6 > 0
  bang_6 = Math.atan2(bdy_6, bdx_6)
  bpt_6 = Geom::Point3d.new(bx1_6, by1_6, 3500)
  btr_6 = Geom::Transformation.translation(bpt_6)
  btr_6 = btr_6 * Geom::Transformation.rotation(bpt_6, [0,0,1], bang_6)
  bg_6 = ents.add_group
  bg_6.transformation = btr_6
  pts_6 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_6, 0, 0),
    Geom::Point3d.new(blen_6, 15, 0),
    Geom::Point3d.new(0, 15, 0)
  ]
  bf_6 = bg_6.entities.add_face(pts_6)
  bf_6.material = mat_c350l0 if bf_6
  bf_6.pushpull(-15) if bf_6
  bg_6.layer = layers['beams']
end
# Beam 8: CH13c →
bx1_7 = ox + 8000; by1_7 = oy + 16000
bx2_7 = ox + 16000; by2_7 = oy + 16000
bdx_7 = bx2_7 - bx1_7; bdy_7 = by2_7 - by1_7
blen_7 = Math.sqrt(bdx_7*bdx_7 + bdy_7*bdy_7)
if blen_7 > 0
  bang_7 = Math.atan2(bdy_7, bdx_7)
  bpt_7 = Geom::Point3d.new(bx1_7, by1_7, 3500)
  btr_7 = Geom::Transformation.translation(bpt_7)
  btr_7 = btr_7 * Geom::Transformation.rotation(bpt_7, [0,0,1], bang_7)
  bg_7 = ents.add_group
  bg_7.transformation = btr_7
  pts_7 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_7, 0, 0),
    Geom::Point3d.new(blen_7, 13, 0),
    Geom::Point3d.new(0, 13, 0)
  ]
  bf_7 = bg_7.entities.add_face(pts_7)
  bf_7.material = mat_c350l0 if bf_7
  bf_7.pushpull(-13) if bf_7
  bg_7.layer = layers['beams']
end
# Beam 9: UB38c →
bx1_8 = ox + 16000; by1_8 = oy + 16000
bx2_8 = ox + 24000; by2_8 = oy + 16000
bdx_8 = bx2_8 - bx1_8; bdy_8 = by2_8 - by1_8
blen_8 = Math.sqrt(bdx_8*bdx_8 + bdy_8*bdy_8)
if blen_8 > 0
  bang_8 = Math.atan2(bdy_8, bdx_8)
  bpt_8 = Geom::Point3d.new(bx1_8, by1_8, 3500)
  btr_8 = Geom::Transformation.translation(bpt_8)
  btr_8 = btr_8 * Geom::Transformation.rotation(bpt_8, [0,0,1], bang_8)
  bg_8 = ents.add_group
  bg_8.transformation = btr_8
  pts_8 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_8, 0, 0),
    Geom::Point3d.new(blen_8, 38, 0),
    Geom::Point3d.new(0, 38, 0)
  ]
  bf_8 = bg_8.entities.add_face(pts_8)
  bf_8.material = mat_c350l0 if bf_8
  bf_8.pushpull(-38) if bf_8
  bg_8.layer = layers['beams']
end
# Beam 10: B1 →
bx1_9 = ox + 0; by1_9 = oy + 24000
bx2_9 = ox + 8000; by2_9 = oy + 24000
bdx_9 = bx2_9 - bx1_9; bdy_9 = by2_9 - by1_9
blen_9 = Math.sqrt(bdx_9*bdx_9 + bdy_9*bdy_9)
if blen_9 > 0
  bang_9 = Math.atan2(bdy_9, bdx_9)
  bpt_9 = Geom::Point3d.new(bx1_9, by1_9, 3500)
  btr_9 = Geom::Transformation.translation(bpt_9)
  btr_9 = btr_9 * Geom::Transformation.rotation(bpt_9, [0,0,1], bang_9)
  bg_9 = ents.add_group
  bg_9.transformation = btr_9
  pts_9 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_9, 0, 0),
    Geom::Point3d.new(blen_9, 300, 0),
    Geom::Point3d.new(0, 300, 0)
  ]
  bf_9 = bg_9.entities.add_face(pts_9)
  bf_9.material = mat_concrete if bf_9
  bf_9.pushpull(-200) if bf_9
  bg_9.layer = layers['beams']
end
# Beam 11: B2 →
bx1_10 = ox + 8000; by1_10 = oy + 24000
bx2_10 = ox + 16000; by2_10 = oy + 24000
bdx_10 = bx2_10 - bx1_10; bdy_10 = by2_10 - by1_10
blen_10 = Math.sqrt(bdx_10*bdx_10 + bdy_10*bdy_10)
if blen_10 > 0
  bang_10 = Math.atan2(bdy_10, bdx_10)
  bpt_10 = Geom::Point3d.new(bx1_10, by1_10, 3500)
  btr_10 = Geom::Transformation.translation(bpt_10)
  btr_10 = btr_10 * Geom::Transformation.rotation(bpt_10, [0,0,1], bang_10)
  bg_10 = ents.add_group
  bg_10.transformation = btr_10
  pts_10 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_10, 0, 0),
    Geom::Point3d.new(blen_10, 300, 0),
    Geom::Point3d.new(0, 300, 0)
  ]
  bf_10 = bg_10.entities.add_face(pts_10)
  bf_10.material = mat_concrete if bf_10
  bf_10.pushpull(-200) if bf_10
  bg_10.layer = layers['beams']
end
# Beam 12: B3 →
bx1_11 = ox + 16000; by1_11 = oy + 24000
bx2_11 = ox + 24000; by2_11 = oy + 24000
bdx_11 = bx2_11 - bx1_11; bdy_11 = by2_11 - by1_11
blen_11 = Math.sqrt(bdx_11*bdx_11 + bdy_11*bdy_11)
if blen_11 > 0
  bang_11 = Math.atan2(bdy_11, bdx_11)
  bpt_11 = Geom::Point3d.new(bx1_11, by1_11, 3500)
  btr_11 = Geom::Transformation.translation(bpt_11)
  btr_11 = btr_11 * Geom::Transformation.rotation(bpt_11, [0,0,1], bang_11)
  bg_11 = ents.add_group
  bg_11.transformation = btr_11
  pts_11 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_11, 0, 0),
    Geom::Point3d.new(blen_11, 300, 0),
    Geom::Point3d.new(0, 300, 0)
  ]
  bf_11 = bg_11.entities.add_face(pts_11)
  bf_11.material = mat_concrete if bf_11
  bf_11.pushpull(-200) if bf_11
  bg_11.layer = layers['beams']
end
# Beam 13: B4 →
bx1_12 = ox + 0; by1_12 = oy + 0
bx2_12 = ox + 0; by2_12 = oy + 8000
bdx_12 = bx2_12 - bx1_12; bdy_12 = by2_12 - by1_12
blen_12 = Math.sqrt(bdx_12*bdx_12 + bdy_12*bdy_12)
if blen_12 > 0
  bang_12 = Math.atan2(bdy_12, bdx_12)
  bpt_12 = Geom::Point3d.new(bx1_12, by1_12, 3500)
  btr_12 = Geom::Transformation.translation(bpt_12)
  btr_12 = btr_12 * Geom::Transformation.rotation(bpt_12, [0,0,1], bang_12)
  bg_12 = ents.add_group
  bg_12.transformation = btr_12
  pts_12 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_12, 0, 0),
    Geom::Point3d.new(blen_12, 300, 0),
    Geom::Point3d.new(0, 300, 0)
  ]
  bf_12 = bg_12.entities.add_face(pts_12)
  bf_12.material = mat_concrete if bf_12
  bf_12.pushpull(-200) if bf_12
  bg_12.layer = layers['beams']
end
# Beam 14: B5 →
bx1_13 = ox + 0; by1_13 = oy + 8000
bx2_13 = ox + 0; by2_13 = oy + 16000
bdx_13 = bx2_13 - bx1_13; bdy_13 = by2_13 - by1_13
blen_13 = Math.sqrt(bdx_13*bdx_13 + bdy_13*bdy_13)
if blen_13 > 0
  bang_13 = Math.atan2(bdy_13, bdx_13)
  bpt_13 = Geom::Point3d.new(bx1_13, by1_13, 3500)
  btr_13 = Geom::Transformation.translation(bpt_13)
  btr_13 = btr_13 * Geom::Transformation.rotation(bpt_13, [0,0,1], bang_13)
  bg_13 = ents.add_group
  bg_13.transformation = btr_13
  pts_13 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_13, 0, 0),
    Geom::Point3d.new(blen_13, 300, 0),
    Geom::Point3d.new(0, 300, 0)
  ]
  bf_13 = bg_13.entities.add_face(pts_13)
  bf_13.material = mat_concrete if bf_13
  bf_13.pushpull(-200) if bf_13
  bg_13.layer = layers['beams']
end
# Beam 15: B6 →
bx1_14 = ox + 0; by1_14 = oy + 16000
bx2_14 = ox + 0; by2_14 = oy + 24000
bdx_14 = bx2_14 - bx1_14; bdy_14 = by2_14 - by1_14
blen_14 = Math.sqrt(bdx_14*bdx_14 + bdy_14*bdy_14)
if blen_14 > 0
  bang_14 = Math.atan2(bdy_14, bdx_14)
  bpt_14 = Geom::Point3d.new(bx1_14, by1_14, 3500)
  btr_14 = Geom::Transformation.translation(bpt_14)
  btr_14 = btr_14 * Geom::Transformation.rotation(bpt_14, [0,0,1], bang_14)
  bg_14 = ents.add_group
  bg_14.transformation = btr_14
  pts_14 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_14, 0, 0),
    Geom::Point3d.new(blen_14, 300, 0),
    Geom::Point3d.new(0, 300, 0)
  ]
  bf_14 = bg_14.entities.add_face(pts_14)
  bf_14.material = mat_concrete if bf_14
  bf_14.pushpull(-200) if bf_14
  bg_14.layer = layers['beams']
end
# Beam 16: B7 →
bx1_15 = ox + 8000; by1_15 = oy + 0
bx2_15 = ox + 8000; by2_15 = oy + 8000
bdx_15 = bx2_15 - bx1_15; bdy_15 = by2_15 - by1_15
blen_15 = Math.sqrt(bdx_15*bdx_15 + bdy_15*bdy_15)
if blen_15 > 0
  bang_15 = Math.atan2(bdy_15, bdx_15)
  bpt_15 = Geom::Point3d.new(bx1_15, by1_15, 3500)
  btr_15 = Geom::Transformation.translation(bpt_15)
  btr_15 = btr_15 * Geom::Transformation.rotation(bpt_15, [0,0,1], bang_15)
  bg_15 = ents.add_group
  bg_15.transformation = btr_15
  pts_15 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_15, 0, 0),
    Geom::Point3d.new(blen_15, 300, 0),
    Geom::Point3d.new(0, 300, 0)
  ]
  bf_15 = bg_15.entities.add_face(pts_15)
  bf_15.material = mat_concrete if bf_15
  bf_15.pushpull(-200) if bf_15
  bg_15.layer = layers['beams']
end
# Beam 17: B8 →
bx1_16 = ox + 8000; by1_16 = oy + 8000
bx2_16 = ox + 8000; by2_16 = oy + 16000
bdx_16 = bx2_16 - bx1_16; bdy_16 = by2_16 - by1_16
blen_16 = Math.sqrt(bdx_16*bdx_16 + bdy_16*bdy_16)
if blen_16 > 0
  bang_16 = Math.atan2(bdy_16, bdx_16)
  bpt_16 = Geom::Point3d.new(bx1_16, by1_16, 3500)
  btr_16 = Geom::Transformation.translation(bpt_16)
  btr_16 = btr_16 * Geom::Transformation.rotation(bpt_16, [0,0,1], bang_16)
  bg_16 = ents.add_group
  bg_16.transformation = btr_16
  pts_16 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_16, 0, 0),
    Geom::Point3d.new(blen_16, 300, 0),
    Geom::Point3d.new(0, 300, 0)
  ]
  bf_16 = bg_16.entities.add_face(pts_16)
  bf_16.material = mat_concrete if bf_16
  bf_16.pushpull(-200) if bf_16
  bg_16.layer = layers['beams']
end
# Beam 18: B9 →
bx1_17 = ox + 8000; by1_17 = oy + 16000
bx2_17 = ox + 8000; by2_17 = oy + 24000
bdx_17 = bx2_17 - bx1_17; bdy_17 = by2_17 - by1_17
blen_17 = Math.sqrt(bdx_17*bdx_17 + bdy_17*bdy_17)
if blen_17 > 0
  bang_17 = Math.atan2(bdy_17, bdx_17)
  bpt_17 = Geom::Point3d.new(bx1_17, by1_17, 3500)
  btr_17 = Geom::Transformation.translation(bpt_17)
  btr_17 = btr_17 * Geom::Transformation.rotation(bpt_17, [0,0,1], bang_17)
  bg_17 = ents.add_group
  bg_17.transformation = btr_17
  pts_17 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_17, 0, 0),
    Geom::Point3d.new(blen_17, 300, 0),
    Geom::Point3d.new(0, 300, 0)
  ]
  bf_17 = bg_17.entities.add_face(pts_17)
  bf_17.material = mat_concrete if bf_17
  bf_17.pushpull(-200) if bf_17
  bg_17.layer = layers['beams']
end
# Beam 19: B10 →
bx1_18 = ox + 16000; by1_18 = oy + 0
bx2_18 = ox + 16000; by2_18 = oy + 8000
bdx_18 = bx2_18 - bx1_18; bdy_18 = by2_18 - by1_18
blen_18 = Math.sqrt(bdx_18*bdx_18 + bdy_18*bdy_18)
if blen_18 > 0
  bang_18 = Math.atan2(bdy_18, bdx_18)
  bpt_18 = Geom::Point3d.new(bx1_18, by1_18, 3500)
  btr_18 = Geom::Transformation.translation(bpt_18)
  btr_18 = btr_18 * Geom::Transformation.rotation(bpt_18, [0,0,1], bang_18)
  bg_18 = ents.add_group
  bg_18.transformation = btr_18
  pts_18 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_18, 0, 0),
    Geom::Point3d.new(blen_18, 300, 0),
    Geom::Point3d.new(0, 300, 0)
  ]
  bf_18 = bg_18.entities.add_face(pts_18)
  bf_18.material = mat_concrete if bf_18
  bf_18.pushpull(-200) if bf_18
  bg_18.layer = layers['beams']
end
# Beam 20: B11 →
bx1_19 = ox + 16000; by1_19 = oy + 8000
bx2_19 = ox + 16000; by2_19 = oy + 16000
bdx_19 = bx2_19 - bx1_19; bdy_19 = by2_19 - by1_19
blen_19 = Math.sqrt(bdx_19*bdx_19 + bdy_19*bdy_19)
if blen_19 > 0
  bang_19 = Math.atan2(bdy_19, bdx_19)
  bpt_19 = Geom::Point3d.new(bx1_19, by1_19, 3500)
  btr_19 = Geom::Transformation.translation(bpt_19)
  btr_19 = btr_19 * Geom::Transformation.rotation(bpt_19, [0,0,1], bang_19)
  bg_19 = ents.add_group
  bg_19.transformation = btr_19
  pts_19 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_19, 0, 0),
    Geom::Point3d.new(blen_19, 300, 0),
    Geom::Point3d.new(0, 300, 0)
  ]
  bf_19 = bg_19.entities.add_face(pts_19)
  bf_19.material = mat_concrete if bf_19
  bf_19.pushpull(-200) if bf_19
  bg_19.layer = layers['beams']
end
# Beam 21: B12 →
bx1_20 = ox + 16000; by1_20 = oy + 16000
bx2_20 = ox + 16000; by2_20 = oy + 24000
bdx_20 = bx2_20 - bx1_20; bdy_20 = by2_20 - by1_20
blen_20 = Math.sqrt(bdx_20*bdx_20 + bdy_20*bdy_20)
if blen_20 > 0
  bang_20 = Math.atan2(bdy_20, bdx_20)
  bpt_20 = Geom::Point3d.new(bx1_20, by1_20, 3500)
  btr_20 = Geom::Transformation.translation(bpt_20)
  btr_20 = btr_20 * Geom::Transformation.rotation(bpt_20, [0,0,1], bang_20)
  bg_20 = ents.add_group
  bg_20.transformation = btr_20
  pts_20 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_20, 0, 0),
    Geom::Point3d.new(blen_20, 300, 0),
    Geom::Point3d.new(0, 300, 0)
  ]
  bf_20 = bg_20.entities.add_face(pts_20)
  bf_20.material = mat_concrete if bf_20
  bf_20.pushpull(-200) if bf_20
  bg_20.layer = layers['beams']
end
# Beam 22: B13 →
bx1_21 = ox + 24000; by1_21 = oy + 0
bx2_21 = ox + 24000; by2_21 = oy + 8000
bdx_21 = bx2_21 - bx1_21; bdy_21 = by2_21 - by1_21
blen_21 = Math.sqrt(bdx_21*bdx_21 + bdy_21*bdy_21)
if blen_21 > 0
  bang_21 = Math.atan2(bdy_21, bdx_21)
  bpt_21 = Geom::Point3d.new(bx1_21, by1_21, 3500)
  btr_21 = Geom::Transformation.translation(bpt_21)
  btr_21 = btr_21 * Geom::Transformation.rotation(bpt_21, [0,0,1], bang_21)
  bg_21 = ents.add_group
  bg_21.transformation = btr_21
  pts_21 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_21, 0, 0),
    Geom::Point3d.new(blen_21, 300, 0),
    Geom::Point3d.new(0, 300, 0)
  ]
  bf_21 = bg_21.entities.add_face(pts_21)
  bf_21.material = mat_concrete if bf_21
  bf_21.pushpull(-200) if bf_21
  bg_21.layer = layers['beams']
end
# Beam 23: B14 →
bx1_22 = ox + 24000; by1_22 = oy + 8000
bx2_22 = ox + 24000; by2_22 = oy + 16000
bdx_22 = bx2_22 - bx1_22; bdy_22 = by2_22 - by1_22
blen_22 = Math.sqrt(bdx_22*bdx_22 + bdy_22*bdy_22)
if blen_22 > 0
  bang_22 = Math.atan2(bdy_22, bdx_22)
  bpt_22 = Geom::Point3d.new(bx1_22, by1_22, 3500)
  btr_22 = Geom::Transformation.translation(bpt_22)
  btr_22 = btr_22 * Geom::Transformation.rotation(bpt_22, [0,0,1], bang_22)
  bg_22 = ents.add_group
  bg_22.transformation = btr_22
  pts_22 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_22, 0, 0),
    Geom::Point3d.new(blen_22, 300, 0),
    Geom::Point3d.new(0, 300, 0)
  ]
  bf_22 = bg_22.entities.add_face(pts_22)
  bf_22.material = mat_concrete if bf_22
  bf_22.pushpull(-200) if bf_22
  bg_22.layer = layers['beams']
end
# Beam 24: B15 →
bx1_23 = ox + 24000; by1_23 = oy + 16000
bx2_23 = ox + 24000; by2_23 = oy + 24000
bdx_23 = bx2_23 - bx1_23; bdy_23 = by2_23 - by1_23
blen_23 = Math.sqrt(bdx_23*bdx_23 + bdy_23*bdy_23)
if blen_23 > 0
  bang_23 = Math.atan2(bdy_23, bdx_23)
  bpt_23 = Geom::Point3d.new(bx1_23, by1_23, 3500)
  btr_23 = Geom::Transformation.translation(bpt_23)
  btr_23 = btr_23 * Geom::Transformation.rotation(bpt_23, [0,0,1], bang_23)
  bg_23 = ents.add_group
  bg_23.transformation = btr_23
  pts_23 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_23, 0, 0),
    Geom::Point3d.new(blen_23, 300, 0),
    Geom::Point3d.new(0, 300, 0)
  ]
  bf_23 = bg_23.entities.add_face(pts_23)
  bf_23.material = mat_concrete if bf_23
  bf_23.pushpull(-200) if bf_23
  bg_23.layer = layers['beams']
end
# Beam 25: B16 →
bx1_24 = ox + 0; by1_24 = oy + 0
bx2_24 = ox + 8000; by2_24 = oy + 0
bdx_24 = bx2_24 - bx1_24; bdy_24 = by2_24 - by1_24
blen_24 = Math.sqrt(bdx_24*bdx_24 + bdy_24*bdy_24)
if blen_24 > 0
  bang_24 = Math.atan2(bdy_24, bdx_24)
  bpt_24 = Geom::Point3d.new(bx1_24, by1_24, 3500)
  btr_24 = Geom::Transformation.translation(bpt_24)
  btr_24 = btr_24 * Geom::Transformation.rotation(bpt_24, [0,0,1], bang_24)
  bg_24 = ents.add_group
  bg_24.transformation = btr_24
  pts_24 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_24, 0, 0),
    Geom::Point3d.new(blen_24, 300, 0),
    Geom::Point3d.new(0, 300, 0)
  ]
  bf_24 = bg_24.entities.add_face(pts_24)
  bf_24.material = mat_concrete if bf_24
  bf_24.pushpull(-200) if bf_24
  bg_24.layer = layers['beams']
end
# Beam 26: B17 →
bx1_25 = ox + 8000; by1_25 = oy + 0
bx2_25 = ox + 16000; by2_25 = oy + 0
bdx_25 = bx2_25 - bx1_25; bdy_25 = by2_25 - by1_25
blen_25 = Math.sqrt(bdx_25*bdx_25 + bdy_25*bdy_25)
if blen_25 > 0
  bang_25 = Math.atan2(bdy_25, bdx_25)
  bpt_25 = Geom::Point3d.new(bx1_25, by1_25, 3500)
  btr_25 = Geom::Transformation.translation(bpt_25)
  btr_25 = btr_25 * Geom::Transformation.rotation(bpt_25, [0,0,1], bang_25)
  bg_25 = ents.add_group
  bg_25.transformation = btr_25
  pts_25 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_25, 0, 0),
    Geom::Point3d.new(blen_25, 300, 0),
    Geom::Point3d.new(0, 300, 0)
  ]
  bf_25 = bg_25.entities.add_face(pts_25)
  bf_25.material = mat_concrete if bf_25
  bf_25.pushpull(-200) if bf_25
  bg_25.layer = layers['beams']
end
# Beam 27: SH20a-1 →
bx1_26 = ox + 16000; by1_26 = oy + 0
bx2_26 = ox + 24000; by2_26 = oy + 0
bdx_26 = bx2_26 - bx1_26; bdy_26 = by2_26 - by1_26
blen_26 = Math.sqrt(bdx_26*bdx_26 + bdy_26*bdy_26)
if blen_26 > 0
  bang_26 = Math.atan2(bdy_26, bdx_26)
  bpt_26 = Geom::Point3d.new(bx1_26, by1_26, 3500)
  btr_26 = Geom::Transformation.translation(bpt_26)
  btr_26 = btr_26 * Geom::Transformation.rotation(bpt_26, [0,0,1], bang_26)
  bg_26 = ents.add_group
  bg_26.transformation = btr_26
  pts_26 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_26, 0, 0),
    Geom::Point3d.new(blen_26, 20, 0),
    Geom::Point3d.new(0, 20, 0)
  ]
  bf_26 = bg_26.entities.add_face(pts_26)
  bf_26.material = mat_c350l0 if bf_26
  bf_26.pushpull(-20) if bf_26
  bg_26.layer = layers['beams']
end
# Beam 28: SH20a-2 →
bx1_27 = ox + 0; by1_27 = oy + 8000
bx2_27 = ox + 8000; by2_27 = oy + 8000
bdx_27 = bx2_27 - bx1_27; bdy_27 = by2_27 - by1_27
blen_27 = Math.sqrt(bdx_27*bdx_27 + bdy_27*bdy_27)
if blen_27 > 0
  bang_27 = Math.atan2(bdy_27, bdx_27)
  bpt_27 = Geom::Point3d.new(bx1_27, by1_27, 3500)
  btr_27 = Geom::Transformation.translation(bpt_27)
  btr_27 = btr_27 * Geom::Transformation.rotation(bpt_27, [0,0,1], bang_27)
  bg_27 = ents.add_group
  bg_27.transformation = btr_27
  pts_27 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_27, 0, 0),
    Geom::Point3d.new(blen_27, 20, 0),
    Geom::Point3d.new(0, 20, 0)
  ]
  bf_27 = bg_27.entities.add_face(pts_27)
  bf_27.material = mat_c350l0 if bf_27
  bf_27.pushpull(-20) if bf_27
  bg_27.layer = layers['beams']
end
# Beam 29: SH20a-3 →
bx1_28 = ox + 8000; by1_28 = oy + 8000
bx2_28 = ox + 16000; by2_28 = oy + 8000
bdx_28 = bx2_28 - bx1_28; bdy_28 = by2_28 - by1_28
blen_28 = Math.sqrt(bdx_28*bdx_28 + bdy_28*bdy_28)
if blen_28 > 0
  bang_28 = Math.atan2(bdy_28, bdx_28)
  bpt_28 = Geom::Point3d.new(bx1_28, by1_28, 3500)
  btr_28 = Geom::Transformation.translation(bpt_28)
  btr_28 = btr_28 * Geom::Transformation.rotation(bpt_28, [0,0,1], bang_28)
  bg_28 = ents.add_group
  bg_28.transformation = btr_28
  pts_28 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_28, 0, 0),
    Geom::Point3d.new(blen_28, 20, 0),
    Geom::Point3d.new(0, 20, 0)
  ]
  bf_28 = bg_28.entities.add_face(pts_28)
  bf_28.material = mat_c350l0 if bf_28
  bf_28.pushpull(-20) if bf_28
  bg_28.layer = layers['beams']
end
# Beam 30: SH20a-4 →
bx1_29 = ox + 16000; by1_29 = oy + 8000
bx2_29 = ox + 24000; by2_29 = oy + 8000
bdx_29 = bx2_29 - bx1_29; bdy_29 = by2_29 - by1_29
blen_29 = Math.sqrt(bdx_29*bdx_29 + bdy_29*bdy_29)
if blen_29 > 0
  bang_29 = Math.atan2(bdy_29, bdx_29)
  bpt_29 = Geom::Point3d.new(bx1_29, by1_29, 3500)
  btr_29 = Geom::Transformation.translation(bpt_29)
  btr_29 = btr_29 * Geom::Transformation.rotation(bpt_29, [0,0,1], bang_29)
  bg_29 = ents.add_group
  bg_29.transformation = btr_29
  pts_29 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_29, 0, 0),
    Geom::Point3d.new(blen_29, 20, 0),
    Geom::Point3d.new(0, 20, 0)
  ]
  bf_29 = bg_29.entities.add_face(pts_29)
  bf_29.material = mat_c350l0 if bf_29
  bf_29.pushpull(-20) if bf_29
  bg_29.layer = layers['beams']
end
# Beam 31: SH20a-5 →
bx1_30 = ox + 0; by1_30 = oy + 16000
bx2_30 = ox + 8000; by2_30 = oy + 16000
bdx_30 = bx2_30 - bx1_30; bdy_30 = by2_30 - by1_30
blen_30 = Math.sqrt(bdx_30*bdx_30 + bdy_30*bdy_30)
if blen_30 > 0
  bang_30 = Math.atan2(bdy_30, bdx_30)
  bpt_30 = Geom::Point3d.new(bx1_30, by1_30, 3500)
  btr_30 = Geom::Transformation.translation(bpt_30)
  btr_30 = btr_30 * Geom::Transformation.rotation(bpt_30, [0,0,1], bang_30)
  bg_30 = ents.add_group
  bg_30.transformation = btr_30
  pts_30 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_30, 0, 0),
    Geom::Point3d.new(blen_30, 20, 0),
    Geom::Point3d.new(0, 20, 0)
  ]
  bf_30 = bg_30.entities.add_face(pts_30)
  bf_30.material = mat_c350l0 if bf_30
  bf_30.pushpull(-20) if bf_30
  bg_30.layer = layers['beams']
end
# Beam 32: SH20a-6 →
bx1_31 = ox + 8000; by1_31 = oy + 16000
bx2_31 = ox + 16000; by2_31 = oy + 16000
bdx_31 = bx2_31 - bx1_31; bdy_31 = by2_31 - by1_31
blen_31 = Math.sqrt(bdx_31*bdx_31 + bdy_31*bdy_31)
if blen_31 > 0
  bang_31 = Math.atan2(bdy_31, bdx_31)
  bpt_31 = Geom::Point3d.new(bx1_31, by1_31, 3500)
  btr_31 = Geom::Transformation.translation(bpt_31)
  btr_31 = btr_31 * Geom::Transformation.rotation(bpt_31, [0,0,1], bang_31)
  bg_31 = ents.add_group
  bg_31.transformation = btr_31
  pts_31 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_31, 0, 0),
    Geom::Point3d.new(blen_31, 20, 0),
    Geom::Point3d.new(0, 20, 0)
  ]
  bf_31 = bg_31.entities.add_face(pts_31)
  bf_31.material = mat_c350l0 if bf_31
  bf_31.pushpull(-20) if bf_31
  bg_31.layer = layers['beams']
end
# Beam 33: SH15b-U-1 →
bx1_32 = ox + 16000; by1_32 = oy + 16000
bx2_32 = ox + 24000; by2_32 = oy + 16000
bdx_32 = bx2_32 - bx1_32; bdy_32 = by2_32 - by1_32
blen_32 = Math.sqrt(bdx_32*bdx_32 + bdy_32*bdy_32)
if blen_32 > 0
  bang_32 = Math.atan2(bdy_32, bdx_32)
  bpt_32 = Geom::Point3d.new(bx1_32, by1_32, 3500)
  btr_32 = Geom::Transformation.translation(bpt_32)
  btr_32 = btr_32 * Geom::Transformation.rotation(bpt_32, [0,0,1], bang_32)
  bg_32 = ents.add_group
  bg_32.transformation = btr_32
  pts_32 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_32, 0, 0),
    Geom::Point3d.new(blen_32, 15, 0),
    Geom::Point3d.new(0, 15, 0)
  ]
  bf_32 = bg_32.entities.add_face(pts_32)
  bf_32.material = mat_c350l0 if bf_32
  bf_32.pushpull(-15) if bf_32
  bg_32.layer = layers['beams']
end
# Beam 34: UB20d-1 →
bx1_33 = ox + 0; by1_33 = oy + 24000
bx2_33 = ox + 8000; by2_33 = oy + 24000
bdx_33 = bx2_33 - bx1_33; bdy_33 = by2_33 - by1_33
blen_33 = Math.sqrt(bdx_33*bdx_33 + bdy_33*bdy_33)
if blen_33 > 0
  bang_33 = Math.atan2(bdy_33, bdx_33)
  bpt_33 = Geom::Point3d.new(bx1_33, by1_33, 3500)
  btr_33 = Geom::Transformation.translation(bpt_33)
  btr_33 = btr_33 * Geom::Transformation.rotation(bpt_33, [0,0,1], bang_33)
  bg_33 = ents.add_group
  bg_33.transformation = btr_33
  pts_33 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_33, 0, 0),
    Geom::Point3d.new(blen_33, 20, 0),
    Geom::Point3d.new(0, 20, 0)
  ]
  bf_33 = bg_33.entities.add_face(pts_33)
  bf_33.material = mat_c350l0 if bf_33
  bf_33.pushpull(-20) if bf_33
  bg_33.layer = layers['beams']
end
# Beam 35: UB20d-2 →
bx1_34 = ox + 8000; by1_34 = oy + 24000
bx2_34 = ox + 16000; by2_34 = oy + 24000
bdx_34 = bx2_34 - bx1_34; bdy_34 = by2_34 - by1_34
blen_34 = Math.sqrt(bdx_34*bdx_34 + bdy_34*bdy_34)
if blen_34 > 0
  bang_34 = Math.atan2(bdy_34, bdx_34)
  bpt_34 = Geom::Point3d.new(bx1_34, by1_34, 3500)
  btr_34 = Geom::Transformation.translation(bpt_34)
  btr_34 = btr_34 * Geom::Transformation.rotation(bpt_34, [0,0,1], bang_34)
  bg_34 = ents.add_group
  bg_34.transformation = btr_34
  pts_34 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_34, 0, 0),
    Geom::Point3d.new(blen_34, 20, 0),
    Geom::Point3d.new(0, 20, 0)
  ]
  bf_34 = bg_34.entities.add_face(pts_34)
  bf_34.material = mat_c350l0 if bf_34
  bf_34.pushpull(-20) if bf_34
  bg_34.layer = layers['beams']
end
# Beam 36: UB36c-1 →
bx1_35 = ox + 16000; by1_35 = oy + 24000
bx2_35 = ox + 24000; by2_35 = oy + 24000
bdx_35 = bx2_35 - bx1_35; bdy_35 = by2_35 - by1_35
blen_35 = Math.sqrt(bdx_35*bdx_35 + bdy_35*bdy_35)
if blen_35 > 0
  bang_35 = Math.atan2(bdy_35, bdx_35)
  bpt_35 = Geom::Point3d.new(bx1_35, by1_35, 3500)
  btr_35 = Geom::Transformation.translation(bpt_35)
  btr_35 = btr_35 * Geom::Transformation.rotation(bpt_35, [0,0,1], bang_35)
  bg_35 = ents.add_group
  bg_35.transformation = btr_35
  pts_35 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_35, 0, 0),
    Geom::Point3d.new(blen_35, 36, 0),
    Geom::Point3d.new(0, 36, 0)
  ]
  bf_35 = bg_35.entities.add_face(pts_35)
  bf_35.material = mat_c350l0 if bf_35
  bf_35.pushpull(-36) if bf_35
  bg_35.layer = layers['beams']
end
# Beam 37: UB36c-2 →
bx1_36 = ox + 0; by1_36 = oy + 0
bx2_36 = ox + 0; by2_36 = oy + 8000
bdx_36 = bx2_36 - bx1_36; bdy_36 = by2_36 - by1_36
blen_36 = Math.sqrt(bdx_36*bdx_36 + bdy_36*bdy_36)
if blen_36 > 0
  bang_36 = Math.atan2(bdy_36, bdx_36)
  bpt_36 = Geom::Point3d.new(bx1_36, by1_36, 3500)
  btr_36 = Geom::Transformation.translation(bpt_36)
  btr_36 = btr_36 * Geom::Transformation.rotation(bpt_36, [0,0,1], bang_36)
  bg_36 = ents.add_group
  bg_36.transformation = btr_36
  pts_36 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_36, 0, 0),
    Geom::Point3d.new(blen_36, 36, 0),
    Geom::Point3d.new(0, 36, 0)
  ]
  bf_36 = bg_36.entities.add_face(pts_36)
  bf_36.material = mat_c350l0 if bf_36
  bf_36.pushpull(-36) if bf_36
  bg_36.layer = layers['beams']
end
# Beam 38: PF20a-1 →
bx1_37 = ox + 0; by1_37 = oy + 8000
bx2_37 = ox + 0; by2_37 = oy + 16000
bdx_37 = bx2_37 - bx1_37; bdy_37 = by2_37 - by1_37
blen_37 = Math.sqrt(bdx_37*bdx_37 + bdy_37*bdy_37)
if blen_37 > 0
  bang_37 = Math.atan2(bdy_37, bdx_37)
  bpt_37 = Geom::Point3d.new(bx1_37, by1_37, 3500)
  btr_37 = Geom::Transformation.translation(bpt_37)
  btr_37 = btr_37 * Geom::Transformation.rotation(bpt_37, [0,0,1], bang_37)
  bg_37 = ents.add_group
  bg_37.transformation = btr_37
  pts_37 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_37, 0, 0),
    Geom::Point3d.new(blen_37, 20, 0),
    Geom::Point3d.new(0, 20, 0)
  ]
  bf_37 = bg_37.entities.add_face(pts_37)
  bf_37.material = mat_c350l0 if bf_37
  bf_37.pushpull(-20) if bf_37
  bg_37.layer = layers['beams']
end
# Beam 39: PF20a-2 →
bx1_38 = ox + 0; by1_38 = oy + 16000
bx2_38 = ox + 0; by2_38 = oy + 24000
bdx_38 = bx2_38 - bx1_38; bdy_38 = by2_38 - by1_38
blen_38 = Math.sqrt(bdx_38*bdx_38 + bdy_38*bdy_38)
if blen_38 > 0
  bang_38 = Math.atan2(bdy_38, bdx_38)
  bpt_38 = Geom::Point3d.new(bx1_38, by1_38, 3500)
  btr_38 = Geom::Transformation.translation(bpt_38)
  btr_38 = btr_38 * Geom::Transformation.rotation(bpt_38, [0,0,1], bang_38)
  bg_38 = ents.add_group
  bg_38.transformation = btr_38
  pts_38 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_38, 0, 0),
    Geom::Point3d.new(blen_38, 20, 0),
    Geom::Point3d.new(0, 20, 0)
  ]
  bf_38 = bg_38.entities.add_face(pts_38)
  bf_38.material = mat_c350l0 if bf_38
  bf_38.pushpull(-20) if bf_38
  bg_38.layer = layers['beams']
end
# Beam 40: PF20a-3 →
bx1_39 = ox + 8000; by1_39 = oy + 0
bx2_39 = ox + 8000; by2_39 = oy + 8000
bdx_39 = bx2_39 - bx1_39; bdy_39 = by2_39 - by1_39
blen_39 = Math.sqrt(bdx_39*bdx_39 + bdy_39*bdy_39)
if blen_39 > 0
  bang_39 = Math.atan2(bdy_39, bdx_39)
  bpt_39 = Geom::Point3d.new(bx1_39, by1_39, 3500)
  btr_39 = Geom::Transformation.translation(bpt_39)
  btr_39 = btr_39 * Geom::Transformation.rotation(bpt_39, [0,0,1], bang_39)
  bg_39 = ents.add_group
  bg_39.transformation = btr_39
  pts_39 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_39, 0, 0),
    Geom::Point3d.new(blen_39, 20, 0),
    Geom::Point3d.new(0, 20, 0)
  ]
  bf_39 = bg_39.entities.add_face(pts_39)
  bf_39.material = mat_c350l0 if bf_39
  bf_39.pushpull(-20) if bf_39
  bg_39.layer = layers['beams']
end
# Beam 41: PF20a-4 →
bx1_40 = ox + 8000; by1_40 = oy + 8000
bx2_40 = ox + 8000; by2_40 = oy + 16000
bdx_40 = bx2_40 - bx1_40; bdy_40 = by2_40 - by1_40
blen_40 = Math.sqrt(bdx_40*bdx_40 + bdy_40*bdy_40)
if blen_40 > 0
  bang_40 = Math.atan2(bdy_40, bdx_40)
  bpt_40 = Geom::Point3d.new(bx1_40, by1_40, 3500)
  btr_40 = Geom::Transformation.translation(bpt_40)
  btr_40 = btr_40 * Geom::Transformation.rotation(bpt_40, [0,0,1], bang_40)
  bg_40 = ents.add_group
  bg_40.transformation = btr_40
  pts_40 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_40, 0, 0),
    Geom::Point3d.new(blen_40, 20, 0),
    Geom::Point3d.new(0, 20, 0)
  ]
  bf_40 = bg_40.entities.add_face(pts_40)
  bf_40.material = mat_c350l0 if bf_40
  bf_40.pushpull(-20) if bf_40
  bg_40.layer = layers['beams']
end
# Beam 42: PF20a-5 →
bx1_41 = ox + 8000; by1_41 = oy + 16000
bx2_41 = ox + 8000; by2_41 = oy + 24000
bdx_41 = bx2_41 - bx1_41; bdy_41 = by2_41 - by1_41
blen_41 = Math.sqrt(bdx_41*bdx_41 + bdy_41*bdy_41)
if blen_41 > 0
  bang_41 = Math.atan2(bdy_41, bdx_41)
  bpt_41 = Geom::Point3d.new(bx1_41, by1_41, 3500)
  btr_41 = Geom::Transformation.translation(bpt_41)
  btr_41 = btr_41 * Geom::Transformation.rotation(bpt_41, [0,0,1], bang_41)
  bg_41 = ents.add_group
  bg_41.transformation = btr_41
  pts_41 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_41, 0, 0),
    Geom::Point3d.new(blen_41, 20, 0),
    Geom::Point3d.new(0, 20, 0)
  ]
  bf_41 = bg_41.entities.add_face(pts_41)
  bf_41.material = mat_c350l0 if bf_41
  bf_41.pushpull(-20) if bf_41
  bg_41.layer = layers['beams']
end
# Beam 43: PF20a-6 →
bx1_42 = ox + 16000; by1_42 = oy + 0
bx2_42 = ox + 16000; by2_42 = oy + 8000
bdx_42 = bx2_42 - bx1_42; bdy_42 = by2_42 - by1_42
blen_42 = Math.sqrt(bdx_42*bdx_42 + bdy_42*bdy_42)
if blen_42 > 0
  bang_42 = Math.atan2(bdy_42, bdx_42)
  bpt_42 = Geom::Point3d.new(bx1_42, by1_42, 3500)
  btr_42 = Geom::Transformation.translation(bpt_42)
  btr_42 = btr_42 * Geom::Transformation.rotation(bpt_42, [0,0,1], bang_42)
  bg_42 = ents.add_group
  bg_42.transformation = btr_42
  pts_42 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_42, 0, 0),
    Geom::Point3d.new(blen_42, 20, 0),
    Geom::Point3d.new(0, 20, 0)
  ]
  bf_42 = bg_42.entities.add_face(pts_42)
  bf_42.material = mat_c350l0 if bf_42
  bf_42.pushpull(-20) if bf_42
  bg_42.layer = layers['beams']
end
# Beam 44: PF25a-1 →
bx1_43 = ox + 16000; by1_43 = oy + 8000
bx2_43 = ox + 16000; by2_43 = oy + 16000
bdx_43 = bx2_43 - bx1_43; bdy_43 = by2_43 - by1_43
blen_43 = Math.sqrt(bdx_43*bdx_43 + bdy_43*bdy_43)
if blen_43 > 0
  bang_43 = Math.atan2(bdy_43, bdx_43)
  bpt_43 = Geom::Point3d.new(bx1_43, by1_43, 3500)
  btr_43 = Geom::Transformation.translation(bpt_43)
  btr_43 = btr_43 * Geom::Transformation.rotation(bpt_43, [0,0,1], bang_43)
  bg_43 = ents.add_group
  bg_43.transformation = btr_43
  pts_43 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_43, 0, 0),
    Geom::Point3d.new(blen_43, 25, 0),
    Geom::Point3d.new(0, 25, 0)
  ]
  bf_43 = bg_43.entities.add_face(pts_43)
  bf_43.material = mat_c350l0 if bf_43
  bf_43.pushpull(-25) if bf_43
  bg_43.layer = layers['beams']
end
# Beam 45: PF25a-2 →
bx1_44 = ox + 16000; by1_44 = oy + 16000
bx2_44 = ox + 16000; by2_44 = oy + 24000
bdx_44 = bx2_44 - bx1_44; bdy_44 = by2_44 - by1_44
blen_44 = Math.sqrt(bdx_44*bdx_44 + bdy_44*bdy_44)
if blen_44 > 0
  bang_44 = Math.atan2(bdy_44, bdx_44)
  bpt_44 = Geom::Point3d.new(bx1_44, by1_44, 3500)
  btr_44 = Geom::Transformation.translation(bpt_44)
  btr_44 = btr_44 * Geom::Transformation.rotation(bpt_44, [0,0,1], bang_44)
  bg_44 = ents.add_group
  bg_44.transformation = btr_44
  pts_44 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_44, 0, 0),
    Geom::Point3d.new(blen_44, 25, 0),
    Geom::Point3d.new(0, 25, 0)
  ]
  bf_44 = bg_44.entities.add_face(pts_44)
  bf_44.material = mat_c350l0 if bf_44
  bf_44.pushpull(-25) if bf_44
  bg_44.layer = layers['beams']
end
# Beam 46: PF25a-3 →
bx1_45 = ox + 24000; by1_45 = oy + 0
bx2_45 = ox + 24000; by2_45 = oy + 8000
bdx_45 = bx2_45 - bx1_45; bdy_45 = by2_45 - by1_45
blen_45 = Math.sqrt(bdx_45*bdx_45 + bdy_45*bdy_45)
if blen_45 > 0
  bang_45 = Math.atan2(bdy_45, bdx_45)
  bpt_45 = Geom::Point3d.new(bx1_45, by1_45, 3500)
  btr_45 = Geom::Transformation.translation(bpt_45)
  btr_45 = btr_45 * Geom::Transformation.rotation(bpt_45, [0,0,1], bang_45)
  bg_45 = ents.add_group
  bg_45.transformation = btr_45
  pts_45 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_45, 0, 0),
    Geom::Point3d.new(blen_45, 25, 0),
    Geom::Point3d.new(0, 25, 0)
  ]
  bf_45 = bg_45.entities.add_face(pts_45)
  bf_45.material = mat_c350l0 if bf_45
  bf_45.pushpull(-25) if bf_45
  bg_45.layer = layers['beams']
end
# Beam 47: PF25a-4 →
bx1_46 = ox + 24000; by1_46 = oy + 8000
bx2_46 = ox + 24000; by2_46 = oy + 16000
bdx_46 = bx2_46 - bx1_46; bdy_46 = by2_46 - by1_46
blen_46 = Math.sqrt(bdx_46*bdx_46 + bdy_46*bdy_46)
if blen_46 > 0
  bang_46 = Math.atan2(bdy_46, bdx_46)
  bpt_46 = Geom::Point3d.new(bx1_46, by1_46, 3500)
  btr_46 = Geom::Transformation.translation(bpt_46)
  btr_46 = btr_46 * Geom::Transformation.rotation(bpt_46, [0,0,1], bang_46)
  bg_46 = ents.add_group
  bg_46.transformation = btr_46
  pts_46 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_46, 0, 0),
    Geom::Point3d.new(blen_46, 25, 0),
    Geom::Point3d.new(0, 25, 0)
  ]
  bf_46 = bg_46.entities.add_face(pts_46)
  bf_46.material = mat_c350l0 if bf_46
  bf_46.pushpull(-25) if bf_46
  bg_46.layer = layers['beams']
end
# Beam 48: PF25a-5 →
bx1_47 = ox + 24000; by1_47 = oy + 16000
bx2_47 = ox + 24000; by2_47 = oy + 24000
bdx_47 = bx2_47 - bx1_47; bdy_47 = by2_47 - by1_47
blen_47 = Math.sqrt(bdx_47*bdx_47 + bdy_47*bdy_47)
if blen_47 > 0
  bang_47 = Math.atan2(bdy_47, bdx_47)
  bpt_47 = Geom::Point3d.new(bx1_47, by1_47, 3500)
  btr_47 = Geom::Transformation.translation(bpt_47)
  btr_47 = btr_47 * Geom::Transformation.rotation(bpt_47, [0,0,1], bang_47)
  bg_47 = ents.add_group
  bg_47.transformation = btr_47
  pts_47 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_47, 0, 0),
    Geom::Point3d.new(blen_47, 25, 0),
    Geom::Point3d.new(0, 25, 0)
  ]
  bf_47 = bg_47.entities.add_face(pts_47)
  bf_47.material = mat_c350l0 if bf_47
  bf_47.pushpull(-25) if bf_47
  bg_47.layer = layers['beams']
end
# Beam 49: PF25a-6 →
bx1_48 = ox + 0; by1_48 = oy + 0
bx2_48 = ox + 8000; by2_48 = oy + 0
bdx_48 = bx2_48 - bx1_48; bdy_48 = by2_48 - by1_48
blen_48 = Math.sqrt(bdx_48*bdx_48 + bdy_48*bdy_48)
if blen_48 > 0
  bang_48 = Math.atan2(bdy_48, bdx_48)
  bpt_48 = Geom::Point3d.new(bx1_48, by1_48, 3500)
  btr_48 = Geom::Transformation.translation(bpt_48)
  btr_48 = btr_48 * Geom::Transformation.rotation(bpt_48, [0,0,1], bang_48)
  bg_48 = ents.add_group
  bg_48.transformation = btr_48
  pts_48 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_48, 0, 0),
    Geom::Point3d.new(blen_48, 25, 0),
    Geom::Point3d.new(0, 25, 0)
  ]
  bf_48 = bg_48.entities.add_face(pts_48)
  bf_48.material = mat_c350l0 if bf_48
  bf_48.pushpull(-25) if bf_48
  bg_48.layer = layers['beams']
end
# Beam 50: Z25d-1 →
bx1_49 = ox + 8000; by1_49 = oy + 0
bx2_49 = ox + 16000; by2_49 = oy + 0
bdx_49 = bx2_49 - bx1_49; bdy_49 = by2_49 - by1_49
blen_49 = Math.sqrt(bdx_49*bdx_49 + bdy_49*bdy_49)
if blen_49 > 0
  bang_49 = Math.atan2(bdy_49, bdx_49)
  bpt_49 = Geom::Point3d.new(bx1_49, by1_49, 3500)
  btr_49 = Geom::Transformation.translation(bpt_49)
  btr_49 = btr_49 * Geom::Transformation.rotation(bpt_49, [0,0,1], bang_49)
  bg_49 = ents.add_group
  bg_49.transformation = btr_49
  pts_49 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_49, 0, 0),
    Geom::Point3d.new(blen_49, 25, 0),
    Geom::Point3d.new(0, 25, 0)
  ]
  bf_49 = bg_49.entities.add_face(pts_49)
  bf_49.material = mat_c350l0 if bf_49
  bf_49.pushpull(-25) if bf_49
  bg_49.layer = layers['beams']
end
# Beam 51: Z25d-2 →
bx1_50 = ox + 16000; by1_50 = oy + 0
bx2_50 = ox + 24000; by2_50 = oy + 0
bdx_50 = bx2_50 - bx1_50; bdy_50 = by2_50 - by1_50
blen_50 = Math.sqrt(bdx_50*bdx_50 + bdy_50*bdy_50)
if blen_50 > 0
  bang_50 = Math.atan2(bdy_50, bdx_50)
  bpt_50 = Geom::Point3d.new(bx1_50, by1_50, 3500)
  btr_50 = Geom::Transformation.translation(bpt_50)
  btr_50 = btr_50 * Geom::Transformation.rotation(bpt_50, [0,0,1], bang_50)
  bg_50 = ents.add_group
  bg_50.transformation = btr_50
  pts_50 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_50, 0, 0),
    Geom::Point3d.new(blen_50, 25, 0),
    Geom::Point3d.new(0, 25, 0)
  ]
  bf_50 = bg_50.entities.add_face(pts_50)
  bf_50.material = mat_c350l0 if bf_50
  bf_50.pushpull(-25) if bf_50
  bg_50.layer = layers['beams']
end
# Beam 52: Z25d-3 →
bx1_51 = ox + 0; by1_51 = oy + 8000
bx2_51 = ox + 8000; by2_51 = oy + 8000
bdx_51 = bx2_51 - bx1_51; bdy_51 = by2_51 - by1_51
blen_51 = Math.sqrt(bdx_51*bdx_51 + bdy_51*bdy_51)
if blen_51 > 0
  bang_51 = Math.atan2(bdy_51, bdx_51)
  bpt_51 = Geom::Point3d.new(bx1_51, by1_51, 3500)
  btr_51 = Geom::Transformation.translation(bpt_51)
  btr_51 = btr_51 * Geom::Transformation.rotation(bpt_51, [0,0,1], bang_51)
  bg_51 = ents.add_group
  bg_51.transformation = btr_51
  pts_51 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_51, 0, 0),
    Geom::Point3d.new(blen_51, 25, 0),
    Geom::Point3d.new(0, 25, 0)
  ]
  bf_51 = bg_51.entities.add_face(pts_51)
  bf_51.material = mat_c350l0 if bf_51
  bf_51.pushpull(-25) if bf_51
  bg_51.layer = layers['beams']
end
# Beam 53: CH13c-1 →
bx1_52 = ox + 8000; by1_52 = oy + 8000
bx2_52 = ox + 16000; by2_52 = oy + 8000
bdx_52 = bx2_52 - bx1_52; bdy_52 = by2_52 - by1_52
blen_52 = Math.sqrt(bdx_52*bdx_52 + bdy_52*bdy_52)
if blen_52 > 0
  bang_52 = Math.atan2(bdy_52, bdx_52)
  bpt_52 = Geom::Point3d.new(bx1_52, by1_52, 3500)
  btr_52 = Geom::Transformation.translation(bpt_52)
  btr_52 = btr_52 * Geom::Transformation.rotation(bpt_52, [0,0,1], bang_52)
  bg_52 = ents.add_group
  bg_52.transformation = btr_52
  pts_52 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_52, 0, 0),
    Geom::Point3d.new(blen_52, 13, 0),
    Geom::Point3d.new(0, 13, 0)
  ]
  bf_52 = bg_52.entities.add_face(pts_52)
  bf_52.material = mat_c350l0 if bf_52
  bf_52.pushpull(-13) if bf_52
  bg_52.layer = layers['beams']
end
# Beam 54: CH13c-2 →
bx1_53 = ox + 16000; by1_53 = oy + 8000
bx2_53 = ox + 24000; by2_53 = oy + 8000
bdx_53 = bx2_53 - bx1_53; bdy_53 = by2_53 - by1_53
blen_53 = Math.sqrt(bdx_53*bdx_53 + bdy_53*bdy_53)
if blen_53 > 0
  bang_53 = Math.atan2(bdy_53, bdx_53)
  bpt_53 = Geom::Point3d.new(bx1_53, by1_53, 3500)
  btr_53 = Geom::Transformation.translation(bpt_53)
  btr_53 = btr_53 * Geom::Transformation.rotation(bpt_53, [0,0,1], bang_53)
  bg_53 = ents.add_group
  bg_53.transformation = btr_53
  pts_53 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_53, 0, 0),
    Geom::Point3d.new(blen_53, 13, 0),
    Geom::Point3d.new(0, 13, 0)
  ]
  bf_53 = bg_53.entities.add_face(pts_53)
  bf_53.material = mat_c350l0 if bf_53
  bf_53.pushpull(-13) if bf_53
  bg_53.layer = layers['beams']
end
# Beam 55: CH13c-3 →
bx1_54 = ox + 0; by1_54 = oy + 16000
bx2_54 = ox + 8000; by2_54 = oy + 16000
bdx_54 = bx2_54 - bx1_54; bdy_54 = by2_54 - by1_54
blen_54 = Math.sqrt(bdx_54*bdx_54 + bdy_54*bdy_54)
if blen_54 > 0
  bang_54 = Math.atan2(bdy_54, bdx_54)
  bpt_54 = Geom::Point3d.new(bx1_54, by1_54, 3500)
  btr_54 = Geom::Transformation.translation(bpt_54)
  btr_54 = btr_54 * Geom::Transformation.rotation(bpt_54, [0,0,1], bang_54)
  bg_54 = ents.add_group
  bg_54.transformation = btr_54
  pts_54 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_54, 0, 0),
    Geom::Point3d.new(blen_54, 13, 0),
    Geom::Point3d.new(0, 13, 0)
  ]
  bf_54 = bg_54.entities.add_face(pts_54)
  bf_54.material = mat_c350l0 if bf_54
  bf_54.pushpull(-13) if bf_54
  bg_54.layer = layers['beams']
end
# Beam 56: CH13c-4 →
bx1_55 = ox + 8000; by1_55 = oy + 16000
bx2_55 = ox + 16000; by2_55 = oy + 16000
bdx_55 = bx2_55 - bx1_55; bdy_55 = by2_55 - by1_55
blen_55 = Math.sqrt(bdx_55*bdx_55 + bdy_55*bdy_55)
if blen_55 > 0
  bang_55 = Math.atan2(bdy_55, bdx_55)
  bpt_55 = Geom::Point3d.new(bx1_55, by1_55, 3500)
  btr_55 = Geom::Transformation.translation(bpt_55)
  btr_55 = btr_55 * Geom::Transformation.rotation(bpt_55, [0,0,1], bang_55)
  bg_55 = ents.add_group
  bg_55.transformation = btr_55
  pts_55 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_55, 0, 0),
    Geom::Point3d.new(blen_55, 13, 0),
    Geom::Point3d.new(0, 13, 0)
  ]
  bf_55 = bg_55.entities.add_face(pts_55)
  bf_55.material = mat_c350l0 if bf_55
  bf_55.pushpull(-13) if bf_55
  bg_55.layer = layers['beams']
end
# Beam 57: CH13c-5 →
bx1_56 = ox + 16000; by1_56 = oy + 16000
bx2_56 = ox + 24000; by2_56 = oy + 16000
bdx_56 = bx2_56 - bx1_56; bdy_56 = by2_56 - by1_56
blen_56 = Math.sqrt(bdx_56*bdx_56 + bdy_56*bdy_56)
if blen_56 > 0
  bang_56 = Math.atan2(bdy_56, bdx_56)
  bpt_56 = Geom::Point3d.new(bx1_56, by1_56, 3500)
  btr_56 = Geom::Transformation.translation(bpt_56)
  btr_56 = btr_56 * Geom::Transformation.rotation(bpt_56, [0,0,1], bang_56)
  bg_56 = ents.add_group
  bg_56.transformation = btr_56
  pts_56 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_56, 0, 0),
    Geom::Point3d.new(blen_56, 13, 0),
    Geom::Point3d.new(0, 13, 0)
  ]
  bf_56 = bg_56.entities.add_face(pts_56)
  bf_56.material = mat_c350l0 if bf_56
  bf_56.pushpull(-13) if bf_56
  bg_56.layer = layers['beams']
end
# Beam 58: CH13c-6 →
bx1_57 = ox + 0; by1_57 = oy + 24000
bx2_57 = ox + 8000; by2_57 = oy + 24000
bdx_57 = bx2_57 - bx1_57; bdy_57 = by2_57 - by1_57
blen_57 = Math.sqrt(bdx_57*bdx_57 + bdy_57*bdy_57)
if blen_57 > 0
  bang_57 = Math.atan2(bdy_57, bdx_57)
  bpt_57 = Geom::Point3d.new(bx1_57, by1_57, 3500)
  btr_57 = Geom::Transformation.translation(bpt_57)
  btr_57 = btr_57 * Geom::Transformation.rotation(bpt_57, [0,0,1], bang_57)
  bg_57 = ents.add_group
  bg_57.transformation = btr_57
  pts_57 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_57, 0, 0),
    Geom::Point3d.new(blen_57, 13, 0),
    Geom::Point3d.new(0, 13, 0)
  ]
  bf_57 = bg_57.entities.add_face(pts_57)
  bf_57.material = mat_c350l0 if bf_57
  bf_57.pushpull(-13) if bf_57
  bg_57.layer = layers['beams']
end
# Beam 59: CH13c-7 →
bx1_58 = ox + 8000; by1_58 = oy + 24000
bx2_58 = ox + 16000; by2_58 = oy + 24000
bdx_58 = bx2_58 - bx1_58; bdy_58 = by2_58 - by1_58
blen_58 = Math.sqrt(bdx_58*bdx_58 + bdy_58*bdy_58)
if blen_58 > 0
  bang_58 = Math.atan2(bdy_58, bdx_58)
  bpt_58 = Geom::Point3d.new(bx1_58, by1_58, 3500)
  btr_58 = Geom::Transformation.translation(bpt_58)
  btr_58 = btr_58 * Geom::Transformation.rotation(bpt_58, [0,0,1], bang_58)
  bg_58 = ents.add_group
  bg_58.transformation = btr_58
  pts_58 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_58, 0, 0),
    Geom::Point3d.new(blen_58, 13, 0),
    Geom::Point3d.new(0, 13, 0)
  ]
  bf_58 = bg_58.entities.add_face(pts_58)
  bf_58.material = mat_c350l0 if bf_58
  bf_58.pushpull(-13) if bf_58
  bg_58.layer = layers['beams']
end
# Beam 60: CH13c-8 →
bx1_59 = ox + 16000; by1_59 = oy + 24000
bx2_59 = ox + 24000; by2_59 = oy + 24000
bdx_59 = bx2_59 - bx1_59; bdy_59 = by2_59 - by1_59
blen_59 = Math.sqrt(bdx_59*bdx_59 + bdy_59*bdy_59)
if blen_59 > 0
  bang_59 = Math.atan2(bdy_59, bdx_59)
  bpt_59 = Geom::Point3d.new(bx1_59, by1_59, 3500)
  btr_59 = Geom::Transformation.translation(bpt_59)
  btr_59 = btr_59 * Geom::Transformation.rotation(bpt_59, [0,0,1], bang_59)
  bg_59 = ents.add_group
  bg_59.transformation = btr_59
  pts_59 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_59, 0, 0),
    Geom::Point3d.new(blen_59, 13, 0),
    Geom::Point3d.new(0, 13, 0)
  ]
  bf_59 = bg_59.entities.add_face(pts_59)
  bf_59.material = mat_c350l0 if bf_59
  bf_59.pushpull(-13) if bf_59
  bg_59.layer = layers['beams']
end
# Beam 61: CH13c-9 →
bx1_60 = ox + 0; by1_60 = oy + 0
bx2_60 = ox + 0; by2_60 = oy + 8000
bdx_60 = bx2_60 - bx1_60; bdy_60 = by2_60 - by1_60
blen_60 = Math.sqrt(bdx_60*bdx_60 + bdy_60*bdy_60)
if blen_60 > 0
  bang_60 = Math.atan2(bdy_60, bdx_60)
  bpt_60 = Geom::Point3d.new(bx1_60, by1_60, 3500)
  btr_60 = Geom::Transformation.translation(bpt_60)
  btr_60 = btr_60 * Geom::Transformation.rotation(bpt_60, [0,0,1], bang_60)
  bg_60 = ents.add_group
  bg_60.transformation = btr_60
  pts_60 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_60, 0, 0),
    Geom::Point3d.new(blen_60, 13, 0),
    Geom::Point3d.new(0, 13, 0)
  ]
  bf_60 = bg_60.entities.add_face(pts_60)
  bf_60.material = mat_c350l0 if bf_60
  bf_60.pushpull(-13) if bf_60
  bg_60.layer = layers['beams']
end
# Beam 62: CH13c-10 →
bx1_61 = ox + 0; by1_61 = oy + 8000
bx2_61 = ox + 0; by2_61 = oy + 16000
bdx_61 = bx2_61 - bx1_61; bdy_61 = by2_61 - by1_61
blen_61 = Math.sqrt(bdx_61*bdx_61 + bdy_61*bdy_61)
if blen_61 > 0
  bang_61 = Math.atan2(bdy_61, bdx_61)
  bpt_61 = Geom::Point3d.new(bx1_61, by1_61, 3500)
  btr_61 = Geom::Transformation.translation(bpt_61)
  btr_61 = btr_61 * Geom::Transformation.rotation(bpt_61, [0,0,1], bang_61)
  bg_61 = ents.add_group
  bg_61.transformation = btr_61
  pts_61 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_61, 0, 0),
    Geom::Point3d.new(blen_61, 13, 0),
    Geom::Point3d.new(0, 13, 0)
  ]
  bf_61 = bg_61.entities.add_face(pts_61)
  bf_61.material = mat_c350l0 if bf_61
  bf_61.pushpull(-13) if bf_61
  bg_61.layer = layers['beams']
end
# Beam 63: CH13c-11 →
bx1_62 = ox + 0; by1_62 = oy + 16000
bx2_62 = ox + 0; by2_62 = oy + 24000
bdx_62 = bx2_62 - bx1_62; bdy_62 = by2_62 - by1_62
blen_62 = Math.sqrt(bdx_62*bdx_62 + bdy_62*bdy_62)
if blen_62 > 0
  bang_62 = Math.atan2(bdy_62, bdx_62)
  bpt_62 = Geom::Point3d.new(bx1_62, by1_62, 3500)
  btr_62 = Geom::Transformation.translation(bpt_62)
  btr_62 = btr_62 * Geom::Transformation.rotation(bpt_62, [0,0,1], bang_62)
  bg_62 = ents.add_group
  bg_62.transformation = btr_62
  pts_62 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_62, 0, 0),
    Geom::Point3d.new(blen_62, 13, 0),
    Geom::Point3d.new(0, 13, 0)
  ]
  bf_62 = bg_62.entities.add_face(pts_62)
  bf_62.material = mat_c350l0 if bf_62
  bf_62.pushpull(-13) if bf_62
  bg_62.layer = layers['beams']
end
# Beam 64: CH13c-12 →
bx1_63 = ox + 8000; by1_63 = oy + 0
bx2_63 = ox + 8000; by2_63 = oy + 8000
bdx_63 = bx2_63 - bx1_63; bdy_63 = by2_63 - by1_63
blen_63 = Math.sqrt(bdx_63*bdx_63 + bdy_63*bdy_63)
if blen_63 > 0
  bang_63 = Math.atan2(bdy_63, bdx_63)
  bpt_63 = Geom::Point3d.new(bx1_63, by1_63, 3500)
  btr_63 = Geom::Transformation.translation(bpt_63)
  btr_63 = btr_63 * Geom::Transformation.rotation(bpt_63, [0,0,1], bang_63)
  bg_63 = ents.add_group
  bg_63.transformation = btr_63
  pts_63 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_63, 0, 0),
    Geom::Point3d.new(blen_63, 13, 0),
    Geom::Point3d.new(0, 13, 0)
  ]
  bf_63 = bg_63.entities.add_face(pts_63)
  bf_63.material = mat_c350l0 if bf_63
  bf_63.pushpull(-13) if bf_63
  bg_63.layer = layers['beams']
end
# Beam 65: CH13c-13 →
bx1_64 = ox + 8000; by1_64 = oy + 8000
bx2_64 = ox + 8000; by2_64 = oy + 16000
bdx_64 = bx2_64 - bx1_64; bdy_64 = by2_64 - by1_64
blen_64 = Math.sqrt(bdx_64*bdx_64 + bdy_64*bdy_64)
if blen_64 > 0
  bang_64 = Math.atan2(bdy_64, bdx_64)
  bpt_64 = Geom::Point3d.new(bx1_64, by1_64, 3500)
  btr_64 = Geom::Transformation.translation(bpt_64)
  btr_64 = btr_64 * Geom::Transformation.rotation(bpt_64, [0,0,1], bang_64)
  bg_64 = ents.add_group
  bg_64.transformation = btr_64
  pts_64 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_64, 0, 0),
    Geom::Point3d.new(blen_64, 13, 0),
    Geom::Point3d.new(0, 13, 0)
  ]
  bf_64 = bg_64.entities.add_face(pts_64)
  bf_64.material = mat_c350l0 if bf_64
  bf_64.pushpull(-13) if bf_64
  bg_64.layer = layers['beams']
end
# Beam 66: CH13c-14 →
bx1_65 = ox + 8000; by1_65 = oy + 16000
bx2_65 = ox + 8000; by2_65 = oy + 24000
bdx_65 = bx2_65 - bx1_65; bdy_65 = by2_65 - by1_65
blen_65 = Math.sqrt(bdx_65*bdx_65 + bdy_65*bdy_65)
if blen_65 > 0
  bang_65 = Math.atan2(bdy_65, bdx_65)
  bpt_65 = Geom::Point3d.new(bx1_65, by1_65, 3500)
  btr_65 = Geom::Transformation.translation(bpt_65)
  btr_65 = btr_65 * Geom::Transformation.rotation(bpt_65, [0,0,1], bang_65)
  bg_65 = ents.add_group
  bg_65.transformation = btr_65
  pts_65 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_65, 0, 0),
    Geom::Point3d.new(blen_65, 13, 0),
    Geom::Point3d.new(0, 13, 0)
  ]
  bf_65 = bg_65.entities.add_face(pts_65)
  bf_65.material = mat_c350l0 if bf_65
  bf_65.pushpull(-13) if bf_65
  bg_65.layer = layers['beams']
end
# Beam 67: CH13c-15 →
bx1_66 = ox + 16000; by1_66 = oy + 0
bx2_66 = ox + 16000; by2_66 = oy + 8000
bdx_66 = bx2_66 - bx1_66; bdy_66 = by2_66 - by1_66
blen_66 = Math.sqrt(bdx_66*bdx_66 + bdy_66*bdy_66)
if blen_66 > 0
  bang_66 = Math.atan2(bdy_66, bdx_66)
  bpt_66 = Geom::Point3d.new(bx1_66, by1_66, 3500)
  btr_66 = Geom::Transformation.translation(bpt_66)
  btr_66 = btr_66 * Geom::Transformation.rotation(bpt_66, [0,0,1], bang_66)
  bg_66 = ents.add_group
  bg_66.transformation = btr_66
  pts_66 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_66, 0, 0),
    Geom::Point3d.new(blen_66, 13, 0),
    Geom::Point3d.new(0, 13, 0)
  ]
  bf_66 = bg_66.entities.add_face(pts_66)
  bf_66.material = mat_c350l0 if bf_66
  bf_66.pushpull(-13) if bf_66
  bg_66.layer = layers['beams']
end
# Beam 68: CH13c-16 →
bx1_67 = ox + 16000; by1_67 = oy + 8000
bx2_67 = ox + 16000; by2_67 = oy + 16000
bdx_67 = bx2_67 - bx1_67; bdy_67 = by2_67 - by1_67
blen_67 = Math.sqrt(bdx_67*bdx_67 + bdy_67*bdy_67)
if blen_67 > 0
  bang_67 = Math.atan2(bdy_67, bdx_67)
  bpt_67 = Geom::Point3d.new(bx1_67, by1_67, 3500)
  btr_67 = Geom::Transformation.translation(bpt_67)
  btr_67 = btr_67 * Geom::Transformation.rotation(bpt_67, [0,0,1], bang_67)
  bg_67 = ents.add_group
  bg_67.transformation = btr_67
  pts_67 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_67, 0, 0),
    Geom::Point3d.new(blen_67, 13, 0),
    Geom::Point3d.new(0, 13, 0)
  ]
  bf_67 = bg_67.entities.add_face(pts_67)
  bf_67.material = mat_c350l0 if bf_67
  bf_67.pushpull(-13) if bf_67
  bg_67.layer = layers['beams']
end
# Beam 69: CH13c-17 →
bx1_68 = ox + 16000; by1_68 = oy + 16000
bx2_68 = ox + 16000; by2_68 = oy + 24000
bdx_68 = bx2_68 - bx1_68; bdy_68 = by2_68 - by1_68
blen_68 = Math.sqrt(bdx_68*bdx_68 + bdy_68*bdy_68)
if blen_68 > 0
  bang_68 = Math.atan2(bdy_68, bdx_68)
  bpt_68 = Geom::Point3d.new(bx1_68, by1_68, 3500)
  btr_68 = Geom::Transformation.translation(bpt_68)
  btr_68 = btr_68 * Geom::Transformation.rotation(bpt_68, [0,0,1], bang_68)
  bg_68 = ents.add_group
  bg_68.transformation = btr_68
  pts_68 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_68, 0, 0),
    Geom::Point3d.new(blen_68, 13, 0),
    Geom::Point3d.new(0, 13, 0)
  ]
  bf_68 = bg_68.entities.add_face(pts_68)
  bf_68.material = mat_c350l0 if bf_68
  bf_68.pushpull(-13) if bf_68
  bg_68.layer = layers['beams']
end
# Beam 70: CH13c-18 →
bx1_69 = ox + 24000; by1_69 = oy + 0
bx2_69 = ox + 24000; by2_69 = oy + 8000
bdx_69 = bx2_69 - bx1_69; bdy_69 = by2_69 - by1_69
blen_69 = Math.sqrt(bdx_69*bdx_69 + bdy_69*bdy_69)
if blen_69 > 0
  bang_69 = Math.atan2(bdy_69, bdx_69)
  bpt_69 = Geom::Point3d.new(bx1_69, by1_69, 3500)
  btr_69 = Geom::Transformation.translation(bpt_69)
  btr_69 = btr_69 * Geom::Transformation.rotation(bpt_69, [0,0,1], bang_69)
  bg_69 = ents.add_group
  bg_69.transformation = btr_69
  pts_69 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_69, 0, 0),
    Geom::Point3d.new(blen_69, 13, 0),
    Geom::Point3d.new(0, 13, 0)
  ]
  bf_69 = bg_69.entities.add_face(pts_69)
  bf_69.material = mat_c350l0 if bf_69
  bf_69.pushpull(-13) if bf_69
  bg_69.layer = layers['beams']
end
# Beam 71: CH32a-1 →
bx1_70 = ox + 24000; by1_70 = oy + 8000
bx2_70 = ox + 24000; by2_70 = oy + 16000
bdx_70 = bx2_70 - bx1_70; bdy_70 = by2_70 - by1_70
blen_70 = Math.sqrt(bdx_70*bdx_70 + bdy_70*bdy_70)
if blen_70 > 0
  bang_70 = Math.atan2(bdy_70, bdx_70)
  bpt_70 = Geom::Point3d.new(bx1_70, by1_70, 3500)
  btr_70 = Geom::Transformation.translation(bpt_70)
  btr_70 = btr_70 * Geom::Transformation.rotation(bpt_70, [0,0,1], bang_70)
  bg_70 = ents.add_group
  bg_70.transformation = btr_70
  pts_70 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_70, 0, 0),
    Geom::Point3d.new(blen_70, 32, 0),
    Geom::Point3d.new(0, 32, 0)
  ]
  bf_70 = bg_70.entities.add_face(pts_70)
  bf_70.material = mat_c350l0 if bf_70
  bf_70.pushpull(-32) if bf_70
  bg_70.layer = layers['beams']
end
# Beam 72: CH32a-2 →
bx1_71 = ox + 24000; by1_71 = oy + 16000
bx2_71 = ox + 24000; by2_71 = oy + 24000
bdx_71 = bx2_71 - bx1_71; bdy_71 = by2_71 - by1_71
blen_71 = Math.sqrt(bdx_71*bdx_71 + bdy_71*bdy_71)
if blen_71 > 0
  bang_71 = Math.atan2(bdy_71, bdx_71)
  bpt_71 = Geom::Point3d.new(bx1_71, by1_71, 3500)
  btr_71 = Geom::Transformation.translation(bpt_71)
  btr_71 = btr_71 * Geom::Transformation.rotation(bpt_71, [0,0,1], bang_71)
  bg_71 = ents.add_group
  bg_71.transformation = btr_71
  pts_71 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_71, 0, 0),
    Geom::Point3d.new(blen_71, 32, 0),
    Geom::Point3d.new(0, 32, 0)
  ]
  bf_71 = bg_71.entities.add_face(pts_71)
  bf_71.material = mat_c350l0 if bf_71
  bf_71.pushpull(-32) if bf_71
  bg_71.layer = layers['beams']
end
# Beam 73: CH32a-3 →
bx1_72 = ox + 0; by1_72 = oy + 0
bx2_72 = ox + 8000; by2_72 = oy + 0
bdx_72 = bx2_72 - bx1_72; bdy_72 = by2_72 - by1_72
blen_72 = Math.sqrt(bdx_72*bdx_72 + bdy_72*bdy_72)
if blen_72 > 0
  bang_72 = Math.atan2(bdy_72, bdx_72)
  bpt_72 = Geom::Point3d.new(bx1_72, by1_72, 3500)
  btr_72 = Geom::Transformation.translation(bpt_72)
  btr_72 = btr_72 * Geom::Transformation.rotation(bpt_72, [0,0,1], bang_72)
  bg_72 = ents.add_group
  bg_72.transformation = btr_72
  pts_72 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_72, 0, 0),
    Geom::Point3d.new(blen_72, 32, 0),
    Geom::Point3d.new(0, 32, 0)
  ]
  bf_72 = bg_72.entities.add_face(pts_72)
  bf_72.material = mat_c350l0 if bf_72
  bf_72.pushpull(-32) if bf_72
  bg_72.layer = layers['beams']
end
# Beam 74: Beam_Detail1 →
bx1_73 = ox + 8000; by1_73 = oy + 0
bx2_73 = ox + 16000; by2_73 = oy + 0
bdx_73 = bx2_73 - bx1_73; bdy_73 = by2_73 - by1_73
blen_73 = Math.sqrt(bdx_73*bdx_73 + bdy_73*bdy_73)
if blen_73 > 0
  bang_73 = Math.atan2(bdy_73, bdx_73)
  bpt_73 = Geom::Point3d.new(bx1_73, by1_73, 3500)
  btr_73 = Geom::Transformation.translation(bpt_73)
  btr_73 = btr_73 * Geom::Transformation.rotation(bpt_73, [0,0,1], bang_73)
  bg_73 = ents.add_group
  bg_73.transformation = btr_73
  pts_73 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_73, 0, 0),
    Geom::Point3d.new(blen_73, 320, 0),
    Geom::Point3d.new(0, 320, 0)
  ]
  bf_73 = bg_73.entities.add_face(pts_73)
  bf_73.material = mat_c350l0 if bf_73
  bf_73.pushpull(-320) if bf_73
  bg_73.layer = layers['beams']
end
# Beam 75: Beam_Detail2 →
bx1_74 = ox + 16000; by1_74 = oy + 0
bx2_74 = ox + 24000; by2_74 = oy + 0
bdx_74 = bx2_74 - bx1_74; bdy_74 = by2_74 - by1_74
blen_74 = Math.sqrt(bdx_74*bdx_74 + bdy_74*bdy_74)
if blen_74 > 0
  bang_74 = Math.atan2(bdy_74, bdx_74)
  bpt_74 = Geom::Point3d.new(bx1_74, by1_74, 3500)
  btr_74 = Geom::Transformation.translation(bpt_74)
  btr_74 = btr_74 * Geom::Transformation.rotation(bpt_74, [0,0,1], bang_74)
  bg_74 = ents.add_group
  bg_74.transformation = btr_74
  pts_74 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_74, 0, 0),
    Geom::Point3d.new(blen_74, 360, 0),
    Geom::Point3d.new(0, 360, 0)
  ]
  bf_74 = bg_74.entities.add_face(pts_74)
  bf_74.material = mat_c350l0 if bf_74
  bf_74.pushpull(-360) if bf_74
  bg_74.layer = layers['beams']
end
# Beam 76: Beam_Detail3 →
bx1_75 = ox + 0; by1_75 = oy + 8000
bx2_75 = ox + 8000; by2_75 = oy + 8000
bdx_75 = bx2_75 - bx1_75; bdy_75 = by2_75 - by1_75
blen_75 = Math.sqrt(bdx_75*bdx_75 + bdy_75*bdy_75)
if blen_75 > 0
  bang_75 = Math.atan2(bdy_75, bdx_75)
  bpt_75 = Geom::Point3d.new(bx1_75, by1_75, 3500)
  btr_75 = Geom::Transformation.translation(bpt_75)
  btr_75 = btr_75 * Geom::Transformation.rotation(bpt_75, [0,0,1], bang_75)
  bg_75 = ents.add_group
  bg_75.transformation = btr_75
  pts_75 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_75, 0, 0),
    Geom::Point3d.new(blen_75, 130, 0),
    Geom::Point3d.new(0, 130, 0)
  ]
  bf_75 = bg_75.entities.add_face(pts_75)
  bf_75.material = mat_c350l0 if bf_75
  bf_75.pushpull(-130) if bf_75
  bg_75.layer = layers['beams']
end
# Beam 77: Beam_Detail4 →
bx1_76 = ox + 8000; by1_76 = oy + 8000
bx2_76 = ox + 16000; by2_76 = oy + 8000
bdx_76 = bx2_76 - bx1_76; bdy_76 = by2_76 - by1_76
blen_76 = Math.sqrt(bdx_76*bdx_76 + bdy_76*bdy_76)
if blen_76 > 0
  bang_76 = Math.atan2(bdy_76, bdx_76)
  bpt_76 = Geom::Point3d.new(bx1_76, by1_76, 3500)
  btr_76 = Geom::Transformation.translation(bpt_76)
  btr_76 = btr_76 * Geom::Transformation.rotation(bpt_76, [0,0,1], bang_76)
  bg_76 = ents.add_group
  bg_76.transformation = btr_76
  pts_76 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_76, 0, 0),
    Geom::Point3d.new(blen_76, 150, 0),
    Geom::Point3d.new(0, 150, 0)
  ]
  bf_76 = bg_76.entities.add_face(pts_76)
  bf_76.material = mat_c350l0 if bf_76
  bf_76.pushpull(-150) if bf_76
  bg_76.layer = layers['beams']
end
# Beam 78: Beam_Detail5 →
bx1_77 = ox + 16000; by1_77 = oy + 8000
bx2_77 = ox + 24000; by2_77 = oy + 8000
bdx_77 = bx2_77 - bx1_77; bdy_77 = by2_77 - by1_77
blen_77 = Math.sqrt(bdx_77*bdx_77 + bdy_77*bdy_77)
if blen_77 > 0
  bang_77 = Math.atan2(bdy_77, bdx_77)
  bpt_77 = Geom::Point3d.new(bx1_77, by1_77, 3500)
  btr_77 = Geom::Transformation.translation(bpt_77)
  btr_77 = btr_77 * Geom::Transformation.rotation(bpt_77, [0,0,1], bang_77)
  bg_77 = ents.add_group
  bg_77.transformation = btr_77
  pts_77 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_77, 0, 0),
    Geom::Point3d.new(blen_77, 300, 0),
    Geom::Point3d.new(0, 300, 0)
  ]
  bf_77 = bg_77.entities.add_face(pts_77)
  bf_77.material = mat_c350l0 if bf_77
  bf_77.pushpull(-200) if bf_77
  bg_77.layer = layers['beams']
end
# Beam 79: Beam_Detail6 →
bx1_78 = ox + 0; by1_78 = oy + 16000
bx2_78 = ox + 8000; by2_78 = oy + 16000
bdx_78 = bx2_78 - bx1_78; bdy_78 = by2_78 - by1_78
blen_78 = Math.sqrt(bdx_78*bdx_78 + bdy_78*bdy_78)
if blen_78 > 0
  bang_78 = Math.atan2(bdy_78, bdx_78)
  bpt_78 = Geom::Point3d.new(bx1_78, by1_78, 3500)
  btr_78 = Geom::Transformation.translation(bpt_78)
  btr_78 = btr_78 * Geom::Transformation.rotation(bpt_78, [0,0,1], bang_78)
  bg_78 = ents.add_group
  bg_78.transformation = btr_78
  pts_78 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_78, 0, 0),
    Geom::Point3d.new(blen_78, 300, 0),
    Geom::Point3d.new(0, 300, 0)
  ]
  bf_78 = bg_78.entities.add_face(pts_78)
  bf_78.material = mat_c350l0 if bf_78
  bf_78.pushpull(-200) if bf_78
  bg_78.layer = layers['beams']
end
# Beam 80: UB36b-1 →
bx1_79 = ox + 8000; by1_79 = oy + 16000
bx2_79 = ox + 16000; by2_79 = oy + 16000
bdx_79 = bx2_79 - bx1_79; bdy_79 = by2_79 - by1_79
blen_79 = Math.sqrt(bdx_79*bdx_79 + bdy_79*bdy_79)
if blen_79 > 0
  bang_79 = Math.atan2(bdy_79, bdx_79)
  bpt_79 = Geom::Point3d.new(bx1_79, by1_79, 3500)
  btr_79 = Geom::Transformation.translation(bpt_79)
  btr_79 = btr_79 * Geom::Transformation.rotation(bpt_79, [0,0,1], bang_79)
  bg_79 = ents.add_group
  bg_79.transformation = btr_79
  pts_79 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_79, 0, 0),
    Geom::Point3d.new(blen_79, 36, 0),
    Geom::Point3d.new(0, 36, 0)
  ]
  bf_79 = bg_79.entities.add_face(pts_79)
  bf_79.material = mat_c350l0 if bf_79
  bf_79.pushpull(-36) if bf_79
  bg_79.layer = layers['beams']
end
# Beam 81: UB36b-2 →
bx1_80 = ox + 16000; by1_80 = oy + 16000
bx2_80 = ox + 24000; by2_80 = oy + 16000
bdx_80 = bx2_80 - bx1_80; bdy_80 = by2_80 - by1_80
blen_80 = Math.sqrt(bdx_80*bdx_80 + bdy_80*bdy_80)
if blen_80 > 0
  bang_80 = Math.atan2(bdy_80, bdx_80)
  bpt_80 = Geom::Point3d.new(bx1_80, by1_80, 3500)
  btr_80 = Geom::Transformation.translation(bpt_80)
  btr_80 = btr_80 * Geom::Transformation.rotation(bpt_80, [0,0,1], bang_80)
  bg_80 = ents.add_group
  bg_80.transformation = btr_80
  pts_80 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_80, 0, 0),
    Geom::Point3d.new(blen_80, 36, 0),
    Geom::Point3d.new(0, 36, 0)
  ]
  bf_80 = bg_80.entities.add_face(pts_80)
  bf_80.material = mat_c350l0 if bf_80
  bf_80.pushpull(-36) if bf_80
  bg_80.layer = layers['beams']
end
# Beam 82: UB36b-3 →
bx1_81 = ox + 0; by1_81 = oy + 24000
bx2_81 = ox + 8000; by2_81 = oy + 24000
bdx_81 = bx2_81 - bx1_81; bdy_81 = by2_81 - by1_81
blen_81 = Math.sqrt(bdx_81*bdx_81 + bdy_81*bdy_81)
if blen_81 > 0
  bang_81 = Math.atan2(bdy_81, bdx_81)
  bpt_81 = Geom::Point3d.new(bx1_81, by1_81, 3500)
  btr_81 = Geom::Transformation.translation(bpt_81)
  btr_81 = btr_81 * Geom::Transformation.rotation(bpt_81, [0,0,1], bang_81)
  bg_81 = ents.add_group
  bg_81.transformation = btr_81
  pts_81 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_81, 0, 0),
    Geom::Point3d.new(blen_81, 36, 0),
    Geom::Point3d.new(0, 36, 0)
  ]
  bf_81 = bg_81.entities.add_face(pts_81)
  bf_81.material = mat_c350l0 if bf_81
  bf_81.pushpull(-36) if bf_81
  bg_81.layer = layers['beams']
end
# Beam 83: UB36b-4 →
bx1_82 = ox + 8000; by1_82 = oy + 24000
bx2_82 = ox + 16000; by2_82 = oy + 24000
bdx_82 = bx2_82 - bx1_82; bdy_82 = by2_82 - by1_82
blen_82 = Math.sqrt(bdx_82*bdx_82 + bdy_82*bdy_82)
if blen_82 > 0
  bang_82 = Math.atan2(bdy_82, bdx_82)
  bpt_82 = Geom::Point3d.new(bx1_82, by1_82, 3500)
  btr_82 = Geom::Transformation.translation(bpt_82)
  btr_82 = btr_82 * Geom::Transformation.rotation(bpt_82, [0,0,1], bang_82)
  bg_82 = ents.add_group
  bg_82.transformation = btr_82
  pts_82 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_82, 0, 0),
    Geom::Point3d.new(blen_82, 36, 0),
    Geom::Point3d.new(0, 36, 0)
  ]
  bf_82 = bg_82.entities.add_face(pts_82)
  bf_82.material = mat_c350l0 if bf_82
  bf_82.pushpull(-36) if bf_82
  bg_82.layer = layers['beams']
end
# Beam 84: SH38d-1 →
bx1_83 = ox + 16000; by1_83 = oy + 24000
bx2_83 = ox + 24000; by2_83 = oy + 24000
bdx_83 = bx2_83 - bx1_83; bdy_83 = by2_83 - by1_83
blen_83 = Math.sqrt(bdx_83*bdx_83 + bdy_83*bdy_83)
if blen_83 > 0
  bang_83 = Math.atan2(bdy_83, bdx_83)
  bpt_83 = Geom::Point3d.new(bx1_83, by1_83, 3500)
  btr_83 = Geom::Transformation.translation(bpt_83)
  btr_83 = btr_83 * Geom::Transformation.rotation(bpt_83, [0,0,1], bang_83)
  bg_83 = ents.add_group
  bg_83.transformation = btr_83
  pts_83 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_83, 0, 0),
    Geom::Point3d.new(blen_83, 38, 0),
    Geom::Point3d.new(0, 38, 0)
  ]
  bf_83 = bg_83.entities.add_face(pts_83)
  bf_83.material = mat_c350l0 if bf_83
  bf_83.pushpull(-38) if bf_83
  bg_83.layer = layers['beams']
end
# Beam 85: SH38d-2 →
bx1_84 = ox + 0; by1_84 = oy + 0
bx2_84 = ox + 0; by2_84 = oy + 8000
bdx_84 = bx2_84 - bx1_84; bdy_84 = by2_84 - by1_84
blen_84 = Math.sqrt(bdx_84*bdx_84 + bdy_84*bdy_84)
if blen_84 > 0
  bang_84 = Math.atan2(bdy_84, bdx_84)
  bpt_84 = Geom::Point3d.new(bx1_84, by1_84, 3500)
  btr_84 = Geom::Transformation.translation(bpt_84)
  btr_84 = btr_84 * Geom::Transformation.rotation(bpt_84, [0,0,1], bang_84)
  bg_84 = ents.add_group
  bg_84.transformation = btr_84
  pts_84 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_84, 0, 0),
    Geom::Point3d.new(blen_84, 38, 0),
    Geom::Point3d.new(0, 38, 0)
  ]
  bf_84 = bg_84.entities.add_face(pts_84)
  bf_84.material = mat_c350l0 if bf_84
  bf_84.pushpull(-38) if bf_84
  bg_84.layer = layers['beams']
end
# Beam 86: SH08d-1 →
bx1_85 = ox + 0; by1_85 = oy + 8000
bx2_85 = ox + 0; by2_85 = oy + 16000
bdx_85 = bx2_85 - bx1_85; bdy_85 = by2_85 - by1_85
blen_85 = Math.sqrt(bdx_85*bdx_85 + bdy_85*bdy_85)
if blen_85 > 0
  bang_85 = Math.atan2(bdy_85, bdx_85)
  bpt_85 = Geom::Point3d.new(bx1_85, by1_85, 3500)
  btr_85 = Geom::Transformation.translation(bpt_85)
  btr_85 = btr_85 * Geom::Transformation.rotation(bpt_85, [0,0,1], bang_85)
  bg_85 = ents.add_group
  bg_85.transformation = btr_85
  pts_85 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_85, 0, 0),
    Geom::Point3d.new(blen_85, 8, 0),
    Geom::Point3d.new(0, 8, 0)
  ]
  bf_85 = bg_85.entities.add_face(pts_85)
  bf_85.material = mat_c350l0 if bf_85
  bf_85.pushpull(-8) if bf_85
  bg_85.layer = layers['beams']
end
# Beam 87: SH08d-2 →
bx1_86 = ox + 0; by1_86 = oy + 16000
bx2_86 = ox + 0; by2_86 = oy + 24000
bdx_86 = bx2_86 - bx1_86; bdy_86 = by2_86 - by1_86
blen_86 = Math.sqrt(bdx_86*bdx_86 + bdy_86*bdy_86)
if blen_86 > 0
  bang_86 = Math.atan2(bdy_86, bdx_86)
  bpt_86 = Geom::Point3d.new(bx1_86, by1_86, 3500)
  btr_86 = Geom::Transformation.translation(bpt_86)
  btr_86 = btr_86 * Geom::Transformation.rotation(bpt_86, [0,0,1], bang_86)
  bg_86 = ents.add_group
  bg_86.transformation = btr_86
  pts_86 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_86, 0, 0),
    Geom::Point3d.new(blen_86, 8, 0),
    Geom::Point3d.new(0, 8, 0)
  ]
  bf_86 = bg_86.entities.add_face(pts_86)
  bf_86.material = mat_c350l0 if bf_86
  bf_86.pushpull(-8) if bf_86
  bg_86.layer = layers['beams']
end
# Beam 88: Z10-Z10010 →
bx1_87 = ox + 8000; by1_87 = oy + 0
bx2_87 = ox + 8000; by2_87 = oy + 8000
bdx_87 = bx2_87 - bx1_87; bdy_87 = by2_87 - by1_87
blen_87 = Math.sqrt(bdx_87*bdx_87 + bdy_87*bdy_87)
if blen_87 > 0
  bang_87 = Math.atan2(bdy_87, bdx_87)
  bpt_87 = Geom::Point3d.new(bx1_87, by1_87, 3500)
  btr_87 = Geom::Transformation.translation(bpt_87)
  btr_87 = btr_87 * Geom::Transformation.rotation(bpt_87, [0,0,1], bang_87)
  bg_87 = ents.add_group
  bg_87.transformation = btr_87
  pts_87 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_87, 0, 0),
    Geom::Point3d.new(blen_87, 100, 0),
    Geom::Point3d.new(0, 100, 0)
  ]
  bf_87 = bg_87.entities.add_face(pts_87)
  bf_87.material = mat_c350l0 if bf_87
  bf_87.pushpull(-55) if bf_87
  bg_87.layer = layers['beams']
end
# Beam 89: Z10-Z10012 →
bx1_88 = ox + 8000; by1_88 = oy + 8000
bx2_88 = ox + 8000; by2_88 = oy + 16000
bdx_88 = bx2_88 - bx1_88; bdy_88 = by2_88 - by1_88
blen_88 = Math.sqrt(bdx_88*bdx_88 + bdy_88*bdy_88)
if blen_88 > 0
  bang_88 = Math.atan2(bdy_88, bdx_88)
  bpt_88 = Geom::Point3d.new(bx1_88, by1_88, 3500)
  btr_88 = Geom::Transformation.translation(bpt_88)
  btr_88 = btr_88 * Geom::Transformation.rotation(bpt_88, [0,0,1], bang_88)
  bg_88 = ents.add_group
  bg_88.transformation = btr_88
  pts_88 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_88, 0, 0),
    Geom::Point3d.new(blen_88, 100, 0),
    Geom::Point3d.new(0, 100, 0)
  ]
  bf_88 = bg_88.entities.add_face(pts_88)
  bf_88.material = mat_c350l0 if bf_88
  bf_88.pushpull(-55) if bf_88
  bg_88.layer = layers['beams']
end
# Beam 90: Z10-Z10015 →
bx1_89 = ox + 8000; by1_89 = oy + 16000
bx2_89 = ox + 8000; by2_89 = oy + 24000
bdx_89 = bx2_89 - bx1_89; bdy_89 = by2_89 - by1_89
blen_89 = Math.sqrt(bdx_89*bdx_89 + bdy_89*bdy_89)
if blen_89 > 0
  bang_89 = Math.atan2(bdy_89, bdx_89)
  bpt_89 = Geom::Point3d.new(bx1_89, by1_89, 3500)
  btr_89 = Geom::Transformation.translation(bpt_89)
  btr_89 = btr_89 * Geom::Transformation.rotation(bpt_89, [0,0,1], bang_89)
  bg_89 = ents.add_group
  bg_89.transformation = btr_89
  pts_89 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_89, 0, 0),
    Geom::Point3d.new(blen_89, 100, 0),
    Geom::Point3d.new(0, 100, 0)
  ]
  bf_89 = bg_89.entities.add_face(pts_89)
  bf_89.material = mat_c350l0 if bf_89
  bf_89.pushpull(-55) if bf_89
  bg_89.layer = layers['beams']
end
# Beam 91: Z10-Z10019 →
bx1_90 = ox + 16000; by1_90 = oy + 0
bx2_90 = ox + 16000; by2_90 = oy + 8000
bdx_90 = bx2_90 - bx1_90; bdy_90 = by2_90 - by1_90
blen_90 = Math.sqrt(bdx_90*bdx_90 + bdy_90*bdy_90)
if blen_90 > 0
  bang_90 = Math.atan2(bdy_90, bdx_90)
  bpt_90 = Geom::Point3d.new(bx1_90, by1_90, 3500)
  btr_90 = Geom::Transformation.translation(bpt_90)
  btr_90 = btr_90 * Geom::Transformation.rotation(bpt_90, [0,0,1], bang_90)
  bg_90 = ents.add_group
  bg_90.transformation = btr_90
  pts_90 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_90, 0, 0),
    Geom::Point3d.new(blen_90, 100, 0),
    Geom::Point3d.new(0, 100, 0)
  ]
  bf_90 = bg_90.entities.add_face(pts_90)
  bf_90.material = mat_c350l0 if bf_90
  bf_90.pushpull(-55) if bf_90
  bg_90.layer = layers['beams']
end
# Beam 92: Z15-Z15012 →
bx1_91 = ox + 16000; by1_91 = oy + 8000
bx2_91 = ox + 16000; by2_91 = oy + 16000
bdx_91 = bx2_91 - bx1_91; bdy_91 = by2_91 - by1_91
blen_91 = Math.sqrt(bdx_91*bdx_91 + bdy_91*bdy_91)
if blen_91 > 0
  bang_91 = Math.atan2(bdy_91, bdx_91)
  bpt_91 = Geom::Point3d.new(bx1_91, by1_91, 3500)
  btr_91 = Geom::Transformation.translation(bpt_91)
  btr_91 = btr_91 * Geom::Transformation.rotation(bpt_91, [0,0,1], bang_91)
  bg_91 = ents.add_group
  bg_91.transformation = btr_91
  pts_91 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_91, 0, 0),
    Geom::Point3d.new(blen_91, 150, 0),
    Geom::Point3d.new(0, 150, 0)
  ]
  bf_91 = bg_91.entities.add_face(pts_91)
  bf_91.material = mat_c350l0 if bf_91
  bf_91.pushpull(-82) if bf_91
  bg_91.layer = layers['beams']
end
# Beam 93: Z15-Z15015 →
bx1_92 = ox + 16000; by1_92 = oy + 16000
bx2_92 = ox + 16000; by2_92 = oy + 24000
bdx_92 = bx2_92 - bx1_92; bdy_92 = by2_92 - by1_92
blen_92 = Math.sqrt(bdx_92*bdx_92 + bdy_92*bdy_92)
if blen_92 > 0
  bang_92 = Math.atan2(bdy_92, bdx_92)
  bpt_92 = Geom::Point3d.new(bx1_92, by1_92, 3500)
  btr_92 = Geom::Transformation.translation(bpt_92)
  btr_92 = btr_92 * Geom::Transformation.rotation(bpt_92, [0,0,1], bang_92)
  bg_92 = ents.add_group
  bg_92.transformation = btr_92
  pts_92 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_92, 0, 0),
    Geom::Point3d.new(blen_92, 150, 0),
    Geom::Point3d.new(0, 150, 0)
  ]
  bf_92 = bg_92.entities.add_face(pts_92)
  bf_92.material = mat_c350l0 if bf_92
  bf_92.pushpull(-82) if bf_92
  bg_92.layer = layers['beams']
end
# Beam 94: Z15-Z15019 →
bx1_93 = ox + 24000; by1_93 = oy + 0
bx2_93 = ox + 24000; by2_93 = oy + 8000
bdx_93 = bx2_93 - bx1_93; bdy_93 = by2_93 - by1_93
blen_93 = Math.sqrt(bdx_93*bdx_93 + bdy_93*bdy_93)
if blen_93 > 0
  bang_93 = Math.atan2(bdy_93, bdx_93)
  bpt_93 = Geom::Point3d.new(bx1_93, by1_93, 3500)
  btr_93 = Geom::Transformation.translation(bpt_93)
  btr_93 = btr_93 * Geom::Transformation.rotation(bpt_93, [0,0,1], bang_93)
  bg_93 = ents.add_group
  bg_93.transformation = btr_93
  pts_93 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_93, 0, 0),
    Geom::Point3d.new(blen_93, 150, 0),
    Geom::Point3d.new(0, 150, 0)
  ]
  bf_93 = bg_93.entities.add_face(pts_93)
  bf_93.material = mat_c350l0 if bf_93
  bf_93.pushpull(-82) if bf_93
  bg_93.layer = layers['beams']
end
# Beam 95: Z15-Z15024 →
bx1_94 = ox + 24000; by1_94 = oy + 8000
bx2_94 = ox + 24000; by2_94 = oy + 16000
bdx_94 = bx2_94 - bx1_94; bdy_94 = by2_94 - by1_94
blen_94 = Math.sqrt(bdx_94*bdx_94 + bdy_94*bdy_94)
if blen_94 > 0
  bang_94 = Math.atan2(bdy_94, bdx_94)
  bpt_94 = Geom::Point3d.new(bx1_94, by1_94, 3500)
  btr_94 = Geom::Transformation.translation(bpt_94)
  btr_94 = btr_94 * Geom::Transformation.rotation(bpt_94, [0,0,1], bang_94)
  bg_94 = ents.add_group
  bg_94.transformation = btr_94
  pts_94 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_94, 0, 0),
    Geom::Point3d.new(blen_94, 150, 0),
    Geom::Point3d.new(0, 150, 0)
  ]
  bf_94 = bg_94.entities.add_face(pts_94)
  bf_94.material = mat_c350l0 if bf_94
  bf_94.pushpull(-82) if bf_94
  bg_94.layer = layers['beams']
end
# Beam 96: Z20-Z20015 →
bx1_95 = ox + 24000; by1_95 = oy + 16000
bx2_95 = ox + 24000; by2_95 = oy + 24000
bdx_95 = bx2_95 - bx1_95; bdy_95 = by2_95 - by1_95
blen_95 = Math.sqrt(bdx_95*bdx_95 + bdy_95*bdy_95)
if blen_95 > 0
  bang_95 = Math.atan2(bdy_95, bdx_95)
  bpt_95 = Geom::Point3d.new(bx1_95, by1_95, 3500)
  btr_95 = Geom::Transformation.translation(bpt_95)
  btr_95 = btr_95 * Geom::Transformation.rotation(bpt_95, [0,0,1], bang_95)
  bg_95 = ents.add_group
  bg_95.transformation = btr_95
  pts_95 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_95, 0, 0),
    Geom::Point3d.new(blen_95, 200, 0),
    Geom::Point3d.new(0, 200, 0)
  ]
  bf_95 = bg_95.entities.add_face(pts_95)
  bf_95.material = mat_c350l0 if bf_95
  bf_95.pushpull(-110) if bf_95
  bg_95.layer = layers['beams']
end
# Beam 97: Z20-Z20019 →
bx1_96 = ox + 0; by1_96 = oy + 0
bx2_96 = ox + 8000; by2_96 = oy + 0
bdx_96 = bx2_96 - bx1_96; bdy_96 = by2_96 - by1_96
blen_96 = Math.sqrt(bdx_96*bdx_96 + bdy_96*bdy_96)
if blen_96 > 0
  bang_96 = Math.atan2(bdy_96, bdx_96)
  bpt_96 = Geom::Point3d.new(bx1_96, by1_96, 3500)
  btr_96 = Geom::Transformation.translation(bpt_96)
  btr_96 = btr_96 * Geom::Transformation.rotation(bpt_96, [0,0,1], bang_96)
  bg_96 = ents.add_group
  bg_96.transformation = btr_96
  pts_96 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_96, 0, 0),
    Geom::Point3d.new(blen_96, 200, 0),
    Geom::Point3d.new(0, 200, 0)
  ]
  bf_96 = bg_96.entities.add_face(pts_96)
  bf_96.material = mat_c350l0 if bf_96
  bf_96.pushpull(-110) if bf_96
  bg_96.layer = layers['beams']
end
# Beam 98: Z20-Z20024 →
bx1_97 = ox + 8000; by1_97 = oy + 0
bx2_97 = ox + 16000; by2_97 = oy + 0
bdx_97 = bx2_97 - bx1_97; bdy_97 = by2_97 - by1_97
blen_97 = Math.sqrt(bdx_97*bdx_97 + bdy_97*bdy_97)
if blen_97 > 0
  bang_97 = Math.atan2(bdy_97, bdx_97)
  bpt_97 = Geom::Point3d.new(bx1_97, by1_97, 3500)
  btr_97 = Geom::Transformation.translation(bpt_97)
  btr_97 = btr_97 * Geom::Transformation.rotation(bpt_97, [0,0,1], bang_97)
  bg_97 = ents.add_group
  bg_97.transformation = btr_97
  pts_97 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_97, 0, 0),
    Geom::Point3d.new(blen_97, 200, 0),
    Geom::Point3d.new(0, 200, 0)
  ]
  bf_97 = bg_97.entities.add_face(pts_97)
  bf_97.material = mat_c350l0 if bf_97
  bf_97.pushpull(-110) if bf_97
  bg_97.layer = layers['beams']
end
# Beam 99: Z25-Z25019 →
bx1_98 = ox + 16000; by1_98 = oy + 0
bx2_98 = ox + 24000; by2_98 = oy + 0
bdx_98 = bx2_98 - bx1_98; bdy_98 = by2_98 - by1_98
blen_98 = Math.sqrt(bdx_98*bdx_98 + bdy_98*bdy_98)
if blen_98 > 0
  bang_98 = Math.atan2(bdy_98, bdx_98)
  bpt_98 = Geom::Point3d.new(bx1_98, by1_98, 3500)
  btr_98 = Geom::Transformation.translation(bpt_98)
  btr_98 = btr_98 * Geom::Transformation.rotation(bpt_98, [0,0,1], bang_98)
  bg_98 = ents.add_group
  bg_98.transformation = btr_98
  pts_98 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_98, 0, 0),
    Geom::Point3d.new(blen_98, 250, 0),
    Geom::Point3d.new(0, 250, 0)
  ]
  bf_98 = bg_98.entities.add_face(pts_98)
  bf_98.material = mat_c350l0 if bf_98
  bf_98.pushpull(-137) if bf_98
  bg_98.layer = layers['beams']
end
# Beam 100: Z25-Z25024 →
bx1_99 = ox + 0; by1_99 = oy + 8000
bx2_99 = ox + 8000; by2_99 = oy + 8000
bdx_99 = bx2_99 - bx1_99; bdy_99 = by2_99 - by1_99
blen_99 = Math.sqrt(bdx_99*bdx_99 + bdy_99*bdy_99)
if blen_99 > 0
  bang_99 = Math.atan2(bdy_99, bdx_99)
  bpt_99 = Geom::Point3d.new(bx1_99, by1_99, 3500)
  btr_99 = Geom::Transformation.translation(bpt_99)
  btr_99 = btr_99 * Geom::Transformation.rotation(bpt_99, [0,0,1], bang_99)
  bg_99 = ents.add_group
  bg_99.transformation = btr_99
  pts_99 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_99, 0, 0),
    Geom::Point3d.new(blen_99, 250, 0),
    Geom::Point3d.new(0, 250, 0)
  ]
  bf_99 = bg_99.entities.add_face(pts_99)
  bf_99.material = mat_c350l0 if bf_99
  bf_99.pushpull(-137) if bf_99
  bg_99.layer = layers['beams']
end
# Beam 101: Z30-Z30024 →
bx1_100 = ox + 8000; by1_100 = oy + 8000
bx2_100 = ox + 16000; by2_100 = oy + 8000
bdx_100 = bx2_100 - bx1_100; bdy_100 = by2_100 - by1_100
blen_100 = Math.sqrt(bdx_100*bdx_100 + bdy_100*bdy_100)
if blen_100 > 0
  bang_100 = Math.atan2(bdy_100, bdx_100)
  bpt_100 = Geom::Point3d.new(bx1_100, by1_100, 3500)
  btr_100 = Geom::Transformation.translation(bpt_100)
  btr_100 = btr_100 * Geom::Transformation.rotation(bpt_100, [0,0,1], bang_100)
  bg_100 = ents.add_group
  bg_100.transformation = btr_100
  pts_100 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_100, 0, 0),
    Geom::Point3d.new(blen_100, 300, 0),
    Geom::Point3d.new(0, 300, 0)
  ]
  bf_100 = bg_100.entities.add_face(pts_100)
  bf_100.material = mat_c350l0 if bf_100
  bf_100.pushpull(-165) if bf_100
  bg_100.layer = layers['beams']
end
# Beam 102: Z30-Z30030 →
bx1_101 = ox + 16000; by1_101 = oy + 8000
bx2_101 = ox + 24000; by2_101 = oy + 8000
bdx_101 = bx2_101 - bx1_101; bdy_101 = by2_101 - by1_101
blen_101 = Math.sqrt(bdx_101*bdx_101 + bdy_101*bdy_101)
if blen_101 > 0
  bang_101 = Math.atan2(bdy_101, bdx_101)
  bpt_101 = Geom::Point3d.new(bx1_101, by1_101, 3500)
  btr_101 = Geom::Transformation.translation(bpt_101)
  btr_101 = btr_101 * Geom::Transformation.rotation(bpt_101, [0,0,1], bang_101)
  bg_101 = ents.add_group
  bg_101.transformation = btr_101
  pts_101 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_101, 0, 0),
    Geom::Point3d.new(blen_101, 300, 0),
    Geom::Point3d.new(0, 300, 0)
  ]
  bf_101 = bg_101.entities.add_face(pts_101)
  bf_101.material = mat_c350l0 if bf_101
  bf_101.pushpull(-165) if bf_101
  bg_101.layer = layers['beams']
end
# Beam 103: Z35-Z35030 →
bx1_102 = ox + 0; by1_102 = oy + 16000
bx2_102 = ox + 8000; by2_102 = oy + 16000
bdx_102 = bx2_102 - bx1_102; bdy_102 = by2_102 - by1_102
blen_102 = Math.sqrt(bdx_102*bdx_102 + bdy_102*bdy_102)
if blen_102 > 0
  bang_102 = Math.atan2(bdy_102, bdx_102)
  bpt_102 = Geom::Point3d.new(bx1_102, by1_102, 3500)
  btr_102 = Geom::Transformation.translation(bpt_102)
  btr_102 = btr_102 * Geom::Transformation.rotation(bpt_102, [0,0,1], bang_102)
  bg_102 = ents.add_group
  bg_102.transformation = btr_102
  pts_102 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_102, 0, 0),
    Geom::Point3d.new(blen_102, 350, 0),
    Geom::Point3d.new(0, 350, 0)
  ]
  bf_102 = bg_102.entities.add_face(pts_102)
  bf_102.material = mat_c350l0 if bf_102
  bf_102.pushpull(-192) if bf_102
  bg_102.layer = layers['beams']
end
# Beam 104: C10-C10010 →
bx1_103 = ox + 8000; by1_103 = oy + 16000
bx2_103 = ox + 16000; by2_103 = oy + 16000
bdx_103 = bx2_103 - bx1_103; bdy_103 = by2_103 - by1_103
blen_103 = Math.sqrt(bdx_103*bdx_103 + bdy_103*bdy_103)
if blen_103 > 0
  bang_103 = Math.atan2(bdy_103, bdx_103)
  bpt_103 = Geom::Point3d.new(bx1_103, by1_103, 3500)
  btr_103 = Geom::Transformation.translation(bpt_103)
  btr_103 = btr_103 * Geom::Transformation.rotation(bpt_103, [0,0,1], bang_103)
  bg_103 = ents.add_group
  bg_103.transformation = btr_103
  pts_103 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_103, 0, 0),
    Geom::Point3d.new(blen_103, 100, 0),
    Geom::Point3d.new(0, 100, 0)
  ]
  bf_103 = bg_103.entities.add_face(pts_103)
  bf_103.material = mat_c350l0 if bf_103
  bf_103.pushpull(-55) if bf_103
  bg_103.layer = layers['beams']
end
# Beam 105: C10-C10012 →
bx1_104 = ox + 16000; by1_104 = oy + 16000
bx2_104 = ox + 24000; by2_104 = oy + 16000
bdx_104 = bx2_104 - bx1_104; bdy_104 = by2_104 - by1_104
blen_104 = Math.sqrt(bdx_104*bdx_104 + bdy_104*bdy_104)
if blen_104 > 0
  bang_104 = Math.atan2(bdy_104, bdx_104)
  bpt_104 = Geom::Point3d.new(bx1_104, by1_104, 3500)
  btr_104 = Geom::Transformation.translation(bpt_104)
  btr_104 = btr_104 * Geom::Transformation.rotation(bpt_104, [0,0,1], bang_104)
  bg_104 = ents.add_group
  bg_104.transformation = btr_104
  pts_104 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_104, 0, 0),
    Geom::Point3d.new(blen_104, 100, 0),
    Geom::Point3d.new(0, 100, 0)
  ]
  bf_104 = bg_104.entities.add_face(pts_104)
  bf_104.material = mat_c350l0 if bf_104
  bf_104.pushpull(-55) if bf_104
  bg_104.layer = layers['beams']
end
# Beam 106: C10-C10015 →
bx1_105 = ox + 0; by1_105 = oy + 24000
bx2_105 = ox + 8000; by2_105 = oy + 24000
bdx_105 = bx2_105 - bx1_105; bdy_105 = by2_105 - by1_105
blen_105 = Math.sqrt(bdx_105*bdx_105 + bdy_105*bdy_105)
if blen_105 > 0
  bang_105 = Math.atan2(bdy_105, bdx_105)
  bpt_105 = Geom::Point3d.new(bx1_105, by1_105, 3500)
  btr_105 = Geom::Transformation.translation(bpt_105)
  btr_105 = btr_105 * Geom::Transformation.rotation(bpt_105, [0,0,1], bang_105)
  bg_105 = ents.add_group
  bg_105.transformation = btr_105
  pts_105 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_105, 0, 0),
    Geom::Point3d.new(blen_105, 100, 0),
    Geom::Point3d.new(0, 100, 0)
  ]
  bf_105 = bg_105.entities.add_face(pts_105)
  bf_105.material = mat_c350l0 if bf_105
  bf_105.pushpull(-55) if bf_105
  bg_105.layer = layers['beams']
end
# Beam 107: C10-C10019 →
bx1_106 = ox + 8000; by1_106 = oy + 24000
bx2_106 = ox + 16000; by2_106 = oy + 24000
bdx_106 = bx2_106 - bx1_106; bdy_106 = by2_106 - by1_106
blen_106 = Math.sqrt(bdx_106*bdx_106 + bdy_106*bdy_106)
if blen_106 > 0
  bang_106 = Math.atan2(bdy_106, bdx_106)
  bpt_106 = Geom::Point3d.new(bx1_106, by1_106, 3500)
  btr_106 = Geom::Transformation.translation(bpt_106)
  btr_106 = btr_106 * Geom::Transformation.rotation(bpt_106, [0,0,1], bang_106)
  bg_106 = ents.add_group
  bg_106.transformation = btr_106
  pts_106 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_106, 0, 0),
    Geom::Point3d.new(blen_106, 100, 0),
    Geom::Point3d.new(0, 100, 0)
  ]
  bf_106 = bg_106.entities.add_face(pts_106)
  bf_106.material = mat_c350l0 if bf_106
  bf_106.pushpull(-55) if bf_106
  bg_106.layer = layers['beams']
end
# Beam 108: C15-C15012 →
bx1_107 = ox + 16000; by1_107 = oy + 24000
bx2_107 = ox + 24000; by2_107 = oy + 24000
bdx_107 = bx2_107 - bx1_107; bdy_107 = by2_107 - by1_107
blen_107 = Math.sqrt(bdx_107*bdx_107 + bdy_107*bdy_107)
if blen_107 > 0
  bang_107 = Math.atan2(bdy_107, bdx_107)
  bpt_107 = Geom::Point3d.new(bx1_107, by1_107, 3500)
  btr_107 = Geom::Transformation.translation(bpt_107)
  btr_107 = btr_107 * Geom::Transformation.rotation(bpt_107, [0,0,1], bang_107)
  bg_107 = ents.add_group
  bg_107.transformation = btr_107
  pts_107 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_107, 0, 0),
    Geom::Point3d.new(blen_107, 150, 0),
    Geom::Point3d.new(0, 150, 0)
  ]
  bf_107 = bg_107.entities.add_face(pts_107)
  bf_107.material = mat_c350l0 if bf_107
  bf_107.pushpull(-82) if bf_107
  bg_107.layer = layers['beams']
end
# Beam 109: C15-C15015 →
bx1_108 = ox + 0; by1_108 = oy + 0
bx2_108 = ox + 0; by2_108 = oy + 8000
bdx_108 = bx2_108 - bx1_108; bdy_108 = by2_108 - by1_108
blen_108 = Math.sqrt(bdx_108*bdx_108 + bdy_108*bdy_108)
if blen_108 > 0
  bang_108 = Math.atan2(bdy_108, bdx_108)
  bpt_108 = Geom::Point3d.new(bx1_108, by1_108, 3500)
  btr_108 = Geom::Transformation.translation(bpt_108)
  btr_108 = btr_108 * Geom::Transformation.rotation(bpt_108, [0,0,1], bang_108)
  bg_108 = ents.add_group
  bg_108.transformation = btr_108
  pts_108 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_108, 0, 0),
    Geom::Point3d.new(blen_108, 150, 0),
    Geom::Point3d.new(0, 150, 0)
  ]
  bf_108 = bg_108.entities.add_face(pts_108)
  bf_108.material = mat_c350l0 if bf_108
  bf_108.pushpull(-82) if bf_108
  bg_108.layer = layers['beams']
end
# Beam 110: C15-C15019 →
bx1_109 = ox + 0; by1_109 = oy + 8000
bx2_109 = ox + 0; by2_109 = oy + 16000
bdx_109 = bx2_109 - bx1_109; bdy_109 = by2_109 - by1_109
blen_109 = Math.sqrt(bdx_109*bdx_109 + bdy_109*bdy_109)
if blen_109 > 0
  bang_109 = Math.atan2(bdy_109, bdx_109)
  bpt_109 = Geom::Point3d.new(bx1_109, by1_109, 3500)
  btr_109 = Geom::Transformation.translation(bpt_109)
  btr_109 = btr_109 * Geom::Transformation.rotation(bpt_109, [0,0,1], bang_109)
  bg_109 = ents.add_group
  bg_109.transformation = btr_109
  pts_109 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_109, 0, 0),
    Geom::Point3d.new(blen_109, 150, 0),
    Geom::Point3d.new(0, 150, 0)
  ]
  bf_109 = bg_109.entities.add_face(pts_109)
  bf_109.material = mat_c350l0 if bf_109
  bf_109.pushpull(-82) if bf_109
  bg_109.layer = layers['beams']
end
# Beam 111: C15-C15024 →
bx1_110 = ox + 0; by1_110 = oy + 16000
bx2_110 = ox + 0; by2_110 = oy + 24000
bdx_110 = bx2_110 - bx1_110; bdy_110 = by2_110 - by1_110
blen_110 = Math.sqrt(bdx_110*bdx_110 + bdy_110*bdy_110)
if blen_110 > 0
  bang_110 = Math.atan2(bdy_110, bdx_110)
  bpt_110 = Geom::Point3d.new(bx1_110, by1_110, 3500)
  btr_110 = Geom::Transformation.translation(bpt_110)
  btr_110 = btr_110 * Geom::Transformation.rotation(bpt_110, [0,0,1], bang_110)
  bg_110 = ents.add_group
  bg_110.transformation = btr_110
  pts_110 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_110, 0, 0),
    Geom::Point3d.new(blen_110, 150, 0),
    Geom::Point3d.new(0, 150, 0)
  ]
  bf_110 = bg_110.entities.add_face(pts_110)
  bf_110.material = mat_c350l0 if bf_110
  bf_110.pushpull(-82) if bf_110
  bg_110.layer = layers['beams']
end
# Beam 112: C20-C20015 →
bx1_111 = ox + 8000; by1_111 = oy + 0
bx2_111 = ox + 8000; by2_111 = oy + 8000
bdx_111 = bx2_111 - bx1_111; bdy_111 = by2_111 - by1_111
blen_111 = Math.sqrt(bdx_111*bdx_111 + bdy_111*bdy_111)
if blen_111 > 0
  bang_111 = Math.atan2(bdy_111, bdx_111)
  bpt_111 = Geom::Point3d.new(bx1_111, by1_111, 3500)
  btr_111 = Geom::Transformation.translation(bpt_111)
  btr_111 = btr_111 * Geom::Transformation.rotation(bpt_111, [0,0,1], bang_111)
  bg_111 = ents.add_group
  bg_111.transformation = btr_111
  pts_111 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_111, 0, 0),
    Geom::Point3d.new(blen_111, 200, 0),
    Geom::Point3d.new(0, 200, 0)
  ]
  bf_111 = bg_111.entities.add_face(pts_111)
  bf_111.material = mat_c350l0 if bf_111
  bf_111.pushpull(-110) if bf_111
  bg_111.layer = layers['beams']
end
# Beam 113: C20-C20019 →
bx1_112 = ox + 8000; by1_112 = oy + 8000
bx2_112 = ox + 8000; by2_112 = oy + 16000
bdx_112 = bx2_112 - bx1_112; bdy_112 = by2_112 - by1_112
blen_112 = Math.sqrt(bdx_112*bdx_112 + bdy_112*bdy_112)
if blen_112 > 0
  bang_112 = Math.atan2(bdy_112, bdx_112)
  bpt_112 = Geom::Point3d.new(bx1_112, by1_112, 3500)
  btr_112 = Geom::Transformation.translation(bpt_112)
  btr_112 = btr_112 * Geom::Transformation.rotation(bpt_112, [0,0,1], bang_112)
  bg_112 = ents.add_group
  bg_112.transformation = btr_112
  pts_112 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_112, 0, 0),
    Geom::Point3d.new(blen_112, 200, 0),
    Geom::Point3d.new(0, 200, 0)
  ]
  bf_112 = bg_112.entities.add_face(pts_112)
  bf_112.material = mat_c350l0 if bf_112
  bf_112.pushpull(-110) if bf_112
  bg_112.layer = layers['beams']
end
# Beam 114: C20-C20024 →
bx1_113 = ox + 8000; by1_113 = oy + 16000
bx2_113 = ox + 8000; by2_113 = oy + 24000
bdx_113 = bx2_113 - bx1_113; bdy_113 = by2_113 - by1_113
blen_113 = Math.sqrt(bdx_113*bdx_113 + bdy_113*bdy_113)
if blen_113 > 0
  bang_113 = Math.atan2(bdy_113, bdx_113)
  bpt_113 = Geom::Point3d.new(bx1_113, by1_113, 3500)
  btr_113 = Geom::Transformation.translation(bpt_113)
  btr_113 = btr_113 * Geom::Transformation.rotation(bpt_113, [0,0,1], bang_113)
  bg_113 = ents.add_group
  bg_113.transformation = btr_113
  pts_113 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_113, 0, 0),
    Geom::Point3d.new(blen_113, 200, 0),
    Geom::Point3d.new(0, 200, 0)
  ]
  bf_113 = bg_113.entities.add_face(pts_113)
  bf_113.material = mat_c350l0 if bf_113
  bf_113.pushpull(-110) if bf_113
  bg_113.layer = layers['beams']
end
# Beam 115: C25-C25019 →
bx1_114 = ox + 16000; by1_114 = oy + 0
bx2_114 = ox + 16000; by2_114 = oy + 8000
bdx_114 = bx2_114 - bx1_114; bdy_114 = by2_114 - by1_114
blen_114 = Math.sqrt(bdx_114*bdx_114 + bdy_114*bdy_114)
if blen_114 > 0
  bang_114 = Math.atan2(bdy_114, bdx_114)
  bpt_114 = Geom::Point3d.new(bx1_114, by1_114, 3500)
  btr_114 = Geom::Transformation.translation(bpt_114)
  btr_114 = btr_114 * Geom::Transformation.rotation(bpt_114, [0,0,1], bang_114)
  bg_114 = ents.add_group
  bg_114.transformation = btr_114
  pts_114 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_114, 0, 0),
    Geom::Point3d.new(blen_114, 250, 0),
    Geom::Point3d.new(0, 250, 0)
  ]
  bf_114 = bg_114.entities.add_face(pts_114)
  bf_114.material = mat_c350l0 if bf_114
  bf_114.pushpull(-137) if bf_114
  bg_114.layer = layers['beams']
end
# Beam 116: C25-C25024 →
bx1_115 = ox + 16000; by1_115 = oy + 8000
bx2_115 = ox + 16000; by2_115 = oy + 16000
bdx_115 = bx2_115 - bx1_115; bdy_115 = by2_115 - by1_115
blen_115 = Math.sqrt(bdx_115*bdx_115 + bdy_115*bdy_115)
if blen_115 > 0
  bang_115 = Math.atan2(bdy_115, bdx_115)
  bpt_115 = Geom::Point3d.new(bx1_115, by1_115, 3500)
  btr_115 = Geom::Transformation.translation(bpt_115)
  btr_115 = btr_115 * Geom::Transformation.rotation(bpt_115, [0,0,1], bang_115)
  bg_115 = ents.add_group
  bg_115.transformation = btr_115
  pts_115 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_115, 0, 0),
    Geom::Point3d.new(blen_115, 250, 0),
    Geom::Point3d.new(0, 250, 0)
  ]
  bf_115 = bg_115.entities.add_face(pts_115)
  bf_115.material = mat_c350l0 if bf_115
  bf_115.pushpull(-137) if bf_115
  bg_115.layer = layers['beams']
end
# Beam 117: C30-C30024 →
bx1_116 = ox + 16000; by1_116 = oy + 16000
bx2_116 = ox + 16000; by2_116 = oy + 24000
bdx_116 = bx2_116 - bx1_116; bdy_116 = by2_116 - by1_116
blen_116 = Math.sqrt(bdx_116*bdx_116 + bdy_116*bdy_116)
if blen_116 > 0
  bang_116 = Math.atan2(bdy_116, bdx_116)
  bpt_116 = Geom::Point3d.new(bx1_116, by1_116, 3500)
  btr_116 = Geom::Transformation.translation(bpt_116)
  btr_116 = btr_116 * Geom::Transformation.rotation(bpt_116, [0,0,1], bang_116)
  bg_116 = ents.add_group
  bg_116.transformation = btr_116
  pts_116 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_116, 0, 0),
    Geom::Point3d.new(blen_116, 300, 0),
    Geom::Point3d.new(0, 300, 0)
  ]
  bf_116 = bg_116.entities.add_face(pts_116)
  bf_116.material = mat_c350l0 if bf_116
  bf_116.pushpull(-165) if bf_116
  bg_116.layer = layers['beams']
end
# Beam 118: C30-C30030 →
bx1_117 = ox + 24000; by1_117 = oy + 0
bx2_117 = ox + 24000; by2_117 = oy + 8000
bdx_117 = bx2_117 - bx1_117; bdy_117 = by2_117 - by1_117
blen_117 = Math.sqrt(bdx_117*bdx_117 + bdy_117*bdy_117)
if blen_117 > 0
  bang_117 = Math.atan2(bdy_117, bdx_117)
  bpt_117 = Geom::Point3d.new(bx1_117, by1_117, 3500)
  btr_117 = Geom::Transformation.translation(bpt_117)
  btr_117 = btr_117 * Geom::Transformation.rotation(bpt_117, [0,0,1], bang_117)
  bg_117 = ents.add_group
  bg_117.transformation = btr_117
  pts_117 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_117, 0, 0),
    Geom::Point3d.new(blen_117, 300, 0),
    Geom::Point3d.new(0, 300, 0)
  ]
  bf_117 = bg_117.entities.add_face(pts_117)
  bf_117.material = mat_c350l0 if bf_117
  bf_117.pushpull(-165) if bf_117
  bg_117.layer = layers['beams']
end
# Beam 119: C35-C35030 →
bx1_118 = ox + 24000; by1_118 = oy + 8000
bx2_118 = ox + 24000; by2_118 = oy + 16000
bdx_118 = bx2_118 - bx1_118; bdy_118 = by2_118 - by1_118
blen_118 = Math.sqrt(bdx_118*bdx_118 + bdy_118*bdy_118)
if blen_118 > 0
  bang_118 = Math.atan2(bdy_118, bdx_118)
  bpt_118 = Geom::Point3d.new(bx1_118, by1_118, 3500)
  btr_118 = Geom::Transformation.translation(bpt_118)
  btr_118 = btr_118 * Geom::Transformation.rotation(bpt_118, [0,0,1], bang_118)
  bg_118 = ents.add_group
  bg_118.transformation = btr_118
  pts_118 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_118, 0, 0),
    Geom::Point3d.new(blen_118, 350, 0),
    Geom::Point3d.new(0, 350, 0)
  ]
  bf_118 = bg_118.entities.add_face(pts_118)
  bf_118.material = mat_c350l0 if bf_118
  bf_118.pushpull(-192) if bf_118
  bg_118.layer = layers['beams']
end
# Beam 120: SH15b →
bx1_119 = ox + 24000; by1_119 = oy + 16000
bx2_119 = ox + 24000; by2_119 = oy + 24000
bdx_119 = bx2_119 - bx1_119; bdy_119 = by2_119 - by1_119
blen_119 = Math.sqrt(bdx_119*bdx_119 + bdy_119*bdy_119)
if blen_119 > 0
  bang_119 = Math.atan2(bdy_119, bdx_119)
  bpt_119 = Geom::Point3d.new(bx1_119, by1_119, 3500)
  btr_119 = Geom::Transformation.translation(bpt_119)
  btr_119 = btr_119 * Geom::Transformation.rotation(bpt_119, [0,0,1], bang_119)
  bg_119 = ents.add_group
  bg_119.transformation = btr_119
  pts_119 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_119, 0, 0),
    Geom::Point3d.new(blen_119, 15, 0),
    Geom::Point3d.new(0, 15, 0)
  ]
  bf_119 = bg_119.entities.add_face(pts_119)
  bf_119.material = mat_c350l0 if bf_119
  bf_119.pushpull(-15) if bf_119
  bg_119.layer = layers['beams']
end
# Beam 121: SH10a →
bx1_120 = ox + 0; by1_120 = oy + 0
bx2_120 = ox + 8000; by2_120 = oy + 0
bdx_120 = bx2_120 - bx1_120; bdy_120 = by2_120 - by1_120
blen_120 = Math.sqrt(bdx_120*bdx_120 + bdy_120*bdy_120)
if blen_120 > 0
  bang_120 = Math.atan2(bdy_120, bdx_120)
  bpt_120 = Geom::Point3d.new(bx1_120, by1_120, 3500)
  btr_120 = Geom::Transformation.translation(bpt_120)
  btr_120 = btr_120 * Geom::Transformation.rotation(bpt_120, [0,0,1], bang_120)
  bg_120 = ents.add_group
  bg_120.transformation = btr_120
  pts_120 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_120, 0, 0),
    Geom::Point3d.new(blen_120, 10, 0),
    Geom::Point3d.new(0, 10, 0)
  ]
  bf_120 = bg_120.entities.add_face(pts_120)
  bf_120.material = mat_c350l0 if bf_120
  bf_120.pushpull(-10) if bf_120
  bg_120.layer = layers['beams']
end
# Beam 122: SH10d →
bx1_121 = ox + 8000; by1_121 = oy + 0
bx2_121 = ox + 16000; by2_121 = oy + 0
bdx_121 = bx2_121 - bx1_121; bdy_121 = by2_121 - by1_121
blen_121 = Math.sqrt(bdx_121*bdx_121 + bdy_121*bdy_121)
if blen_121 > 0
  bang_121 = Math.atan2(bdy_121, bdx_121)
  bpt_121 = Geom::Point3d.new(bx1_121, by1_121, 3500)
  btr_121 = Geom::Transformation.translation(bpt_121)
  btr_121 = btr_121 * Geom::Transformation.rotation(bpt_121, [0,0,1], bang_121)
  bg_121 = ents.add_group
  bg_121.transformation = btr_121
  pts_121 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_121, 0, 0),
    Geom::Point3d.new(blen_121, 10, 0),
    Geom::Point3d.new(0, 10, 0)
  ]
  bf_121 = bg_121.entities.add_face(pts_121)
  bf_121.material = mat_c350l0 if bf_121
  bf_121.pushpull(-10) if bf_121
  bg_121.layer = layers['beams']
end
# Beam 123: SH10f →
bx1_122 = ox + 16000; by1_122 = oy + 0
bx2_122 = ox + 24000; by2_122 = oy + 0
bdx_122 = bx2_122 - bx1_122; bdy_122 = by2_122 - by1_122
blen_122 = Math.sqrt(bdx_122*bdx_122 + bdy_122*bdy_122)
if blen_122 > 0
  bang_122 = Math.atan2(bdy_122, bdx_122)
  bpt_122 = Geom::Point3d.new(bx1_122, by1_122, 3500)
  btr_122 = Geom::Transformation.translation(bpt_122)
  btr_122 = btr_122 * Geom::Transformation.rotation(bpt_122, [0,0,1], bang_122)
  bg_122 = ents.add_group
  bg_122.transformation = btr_122
  pts_122 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_122, 0, 0),
    Geom::Point3d.new(blen_122, 10, 0),
    Geom::Point3d.new(0, 10, 0)
  ]
  bf_122 = bg_122.entities.add_face(pts_122)
  bf_122.material = mat_c350l0 if bf_122
  bf_122.pushpull(-10) if bf_122
  bg_122.layer = layers['beams']
end
# Beam 124: SH15a →
bx1_123 = ox + 0; by1_123 = oy + 8000
bx2_123 = ox + 8000; by2_123 = oy + 8000
bdx_123 = bx2_123 - bx1_123; bdy_123 = by2_123 - by1_123
blen_123 = Math.sqrt(bdx_123*bdx_123 + bdy_123*bdy_123)
if blen_123 > 0
  bang_123 = Math.atan2(bdy_123, bdx_123)
  bpt_123 = Geom::Point3d.new(bx1_123, by1_123, 3500)
  btr_123 = Geom::Transformation.translation(bpt_123)
  btr_123 = btr_123 * Geom::Transformation.rotation(bpt_123, [0,0,1], bang_123)
  bg_123 = ents.add_group
  bg_123.transformation = btr_123
  pts_123 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_123, 0, 0),
    Geom::Point3d.new(blen_123, 15, 0),
    Geom::Point3d.new(0, 15, 0)
  ]
  bf_123 = bg_123.entities.add_face(pts_123)
  bf_123.material = mat_c350l0 if bf_123
  bf_123.pushpull(-15) if bf_123
  bg_123.layer = layers['beams']
end
# Beam 125: SH08d →
bx1_124 = ox + 8000; by1_124 = oy + 8000
bx2_124 = ox + 16000; by2_124 = oy + 8000
bdx_124 = bx2_124 - bx1_124; bdy_124 = by2_124 - by1_124
blen_124 = Math.sqrt(bdx_124*bdx_124 + bdy_124*bdy_124)
if blen_124 > 0
  bang_124 = Math.atan2(bdy_124, bdx_124)
  bpt_124 = Geom::Point3d.new(bx1_124, by1_124, 3500)
  btr_124 = Geom::Transformation.translation(bpt_124)
  btr_124 = btr_124 * Geom::Transformation.rotation(bpt_124, [0,0,1], bang_124)
  bg_124 = ents.add_group
  bg_124.transformation = btr_124
  pts_124 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_124, 0, 0),
    Geom::Point3d.new(blen_124, 8, 0),
    Geom::Point3d.new(0, 8, 0)
  ]
  bf_124 = bg_124.entities.add_face(pts_124)
  bf_124.material = mat_c350l0 if bf_124
  bf_124.pushpull(-8) if bf_124
  bg_124.layer = layers['beams']
end
# Beam 126: SH07g →
bx1_125 = ox + 16000; by1_125 = oy + 8000
bx2_125 = ox + 24000; by2_125 = oy + 8000
bdx_125 = bx2_125 - bx1_125; bdy_125 = by2_125 - by1_125
blen_125 = Math.sqrt(bdx_125*bdx_125 + bdy_125*bdy_125)
if blen_125 > 0
  bang_125 = Math.atan2(bdy_125, bdx_125)
  bpt_125 = Geom::Point3d.new(bx1_125, by1_125, 3500)
  btr_125 = Geom::Transformation.translation(bpt_125)
  btr_125 = btr_125 * Geom::Transformation.rotation(bpt_125, [0,0,1], bang_125)
  bg_125 = ents.add_group
  bg_125.transformation = btr_125
  pts_125 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_125, 0, 0),
    Geom::Point3d.new(blen_125, 7, 0),
    Geom::Point3d.new(0, 7, 0)
  ]
  bf_125 = bg_125.entities.add_face(pts_125)
  bf_125.material = mat_c350l0 if bf_125
  bf_125.pushpull(-7) if bf_125
  bg_125.layer = layers['beams']
end
# Beam 127: RB20a →
bx1_126 = ox + 0; by1_126 = oy + 16000
bx2_126 = ox + 8000; by2_126 = oy + 16000
bdx_126 = bx2_126 - bx1_126; bdy_126 = by2_126 - by1_126
blen_126 = Math.sqrt(bdx_126*bdx_126 + bdy_126*bdy_126)
if blen_126 > 0
  bang_126 = Math.atan2(bdy_126, bdx_126)
  bpt_126 = Geom::Point3d.new(bx1_126, by1_126, 3500)
  btr_126 = Geom::Transformation.translation(bpt_126)
  btr_126 = btr_126 * Geom::Transformation.rotation(bpt_126, [0,0,1], bang_126)
  bg_126 = ents.add_group
  bg_126.transformation = btr_126
  pts_126 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_126, 0, 0),
    Geom::Point3d.new(blen_126, 20, 0),
    Geom::Point3d.new(0, 20, 0)
  ]
  bf_126 = bg_126.entities.add_face(pts_126)
  bf_126.material = mat_c350l0 if bf_126
  bf_126.pushpull(-20) if bf_126
  bg_126.layer = layers['beams']
end
# Beam 128: PF25b →
bx1_127 = ox + 8000; by1_127 = oy + 16000
bx2_127 = ox + 16000; by2_127 = oy + 16000
bdx_127 = bx2_127 - bx1_127; bdy_127 = by2_127 - by1_127
blen_127 = Math.sqrt(bdx_127*bdx_127 + bdy_127*bdy_127)
if blen_127 > 0
  bang_127 = Math.atan2(bdy_127, bdx_127)
  bpt_127 = Geom::Point3d.new(bx1_127, by1_127, 3500)
  btr_127 = Geom::Transformation.translation(bpt_127)
  btr_127 = btr_127 * Geom::Transformation.rotation(bpt_127, [0,0,1], bang_127)
  bg_127 = ents.add_group
  bg_127.transformation = btr_127
  pts_127 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_127, 0, 0),
    Geom::Point3d.new(blen_127, 25, 0),
    Geom::Point3d.new(0, 25, 0)
  ]
  bf_127 = bg_127.entities.add_face(pts_127)
  bf_127.material = mat_c350l0 if bf_127
  bf_127.pushpull(-25) if bf_127
  bg_127.layer = layers['beams']
end
# Beam 129: SH30b →
bx1_128 = ox + 16000; by1_128 = oy + 16000
bx2_128 = ox + 24000; by2_128 = oy + 16000
bdx_128 = bx2_128 - bx1_128; bdy_128 = by2_128 - by1_128
blen_128 = Math.sqrt(bdx_128*bdx_128 + bdy_128*bdy_128)
if blen_128 > 0
  bang_128 = Math.atan2(bdy_128, bdx_128)
  bpt_128 = Geom::Point3d.new(bx1_128, by1_128, 3500)
  btr_128 = Geom::Transformation.translation(bpt_128)
  btr_128 = btr_128 * Geom::Transformation.rotation(bpt_128, [0,0,1], bang_128)
  bg_128 = ents.add_group
  bg_128.transformation = btr_128
  pts_128 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_128, 0, 0),
    Geom::Point3d.new(blen_128, 30, 0),
    Geom::Point3d.new(0, 30, 0)
  ]
  bf_128 = bg_128.entities.add_face(pts_128)
  bf_128.material = mat_c350l0 if bf_128
  bf_128.pushpull(-30) if bf_128
  bg_128.layer = layers['beams']
end
# Beam 130: RH25b →
bx1_129 = ox + 0; by1_129 = oy + 24000
bx2_129 = ox + 8000; by2_129 = oy + 24000
bdx_129 = bx2_129 - bx1_129; bdy_129 = by2_129 - by1_129
blen_129 = Math.sqrt(bdx_129*bdx_129 + bdy_129*bdy_129)
if blen_129 > 0
  bang_129 = Math.atan2(bdy_129, bdx_129)
  bpt_129 = Geom::Point3d.new(bx1_129, by1_129, 3500)
  btr_129 = Geom::Transformation.translation(bpt_129)
  btr_129 = btr_129 * Geom::Transformation.rotation(bpt_129, [0,0,1], bang_129)
  bg_129 = ents.add_group
  bg_129.transformation = btr_129
  pts_129 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_129, 0, 0),
    Geom::Point3d.new(blen_129, 25, 0),
    Geom::Point3d.new(0, 25, 0)
  ]
  bf_129 = bg_129.entities.add_face(pts_129)
  bf_129.material = mat_c350l0 if bf_129
  bf_129.pushpull(-25) if bf_129
  bg_129.layer = layers['beams']
end
# Beam 131: EA15a →
bx1_130 = ox + 8000; by1_130 = oy + 24000
bx2_130 = ox + 16000; by2_130 = oy + 24000
bdx_130 = bx2_130 - bx1_130; bdy_130 = by2_130 - by1_130
blen_130 = Math.sqrt(bdx_130*bdx_130 + bdy_130*bdy_130)
if blen_130 > 0
  bang_130 = Math.atan2(bdy_130, bdx_130)
  bpt_130 = Geom::Point3d.new(bx1_130, by1_130, 3500)
  btr_130 = Geom::Transformation.translation(bpt_130)
  btr_130 = btr_130 * Geom::Transformation.rotation(bpt_130, [0,0,1], bang_130)
  bg_130 = ents.add_group
  bg_130.transformation = btr_130
  pts_130 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_130, 0, 0),
    Geom::Point3d.new(blen_130, 15, 0),
    Geom::Point3d.new(0, 15, 0)
  ]
  bf_130 = bg_130.entities.add_face(pts_130)
  bf_130.material = mat_c350l0 if bf_130
  bf_130.pushpull(-15) if bf_130
  bg_130.layer = layers['beams']
end
# Beam 132: SH10e →
bx1_131 = ox + 16000; by1_131 = oy + 24000
bx2_131 = ox + 24000; by2_131 = oy + 24000
bdx_131 = bx2_131 - bx1_131; bdy_131 = by2_131 - by1_131
blen_131 = Math.sqrt(bdx_131*bdx_131 + bdy_131*bdy_131)
if blen_131 > 0
  bang_131 = Math.atan2(bdy_131, bdx_131)
  bpt_131 = Geom::Point3d.new(bx1_131, by1_131, 3500)
  btr_131 = Geom::Transformation.translation(bpt_131)
  btr_131 = btr_131 * Geom::Transformation.rotation(bpt_131, [0,0,1], bang_131)
  bg_131 = ents.add_group
  bg_131.transformation = btr_131
  pts_131 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_131, 0, 0),
    Geom::Point3d.new(blen_131, 10, 0),
    Geom::Point3d.new(0, 10, 0)
  ]
  bf_131 = bg_131.entities.add_face(pts_131)
  bf_131.material = mat_c350l0 if bf_131
  bf_131.pushpull(-10) if bf_131
  bg_131.layer = layers['beams']
end
# Beam 133: UB20a →
bx1_132 = ox + 0; by1_132 = oy + 0
bx2_132 = ox + 0; by2_132 = oy + 8000
bdx_132 = bx2_132 - bx1_132; bdy_132 = by2_132 - by1_132
blen_132 = Math.sqrt(bdx_132*bdx_132 + bdy_132*bdy_132)
if blen_132 > 0
  bang_132 = Math.atan2(bdy_132, bdx_132)
  bpt_132 = Geom::Point3d.new(bx1_132, by1_132, 3500)
  btr_132 = Geom::Transformation.translation(bpt_132)
  btr_132 = btr_132 * Geom::Transformation.rotation(bpt_132, [0,0,1], bang_132)
  bg_132 = ents.add_group
  bg_132.transformation = btr_132
  pts_132 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_132, 0, 0),
    Geom::Point3d.new(blen_132, 20, 0),
    Geom::Point3d.new(0, 20, 0)
  ]
  bf_132 = bg_132.entities.add_face(pts_132)
  bf_132.material = mat_c350l0 if bf_132
  bf_132.pushpull(-20) if bf_132
  bg_132.layer = layers['beams']
end
# Beam 134: SH20a →
bx1_133 = ox + 0; by1_133 = oy + 8000
bx2_133 = ox + 0; by2_133 = oy + 16000
bdx_133 = bx2_133 - bx1_133; bdy_133 = by2_133 - by1_133
blen_133 = Math.sqrt(bdx_133*bdx_133 + bdy_133*bdy_133)
if blen_133 > 0
  bang_133 = Math.atan2(bdy_133, bdx_133)
  bpt_133 = Geom::Point3d.new(bx1_133, by1_133, 3500)
  btr_133 = Geom::Transformation.translation(bpt_133)
  btr_133 = btr_133 * Geom::Transformation.rotation(bpt_133, [0,0,1], bang_133)
  bg_133 = ents.add_group
  bg_133.transformation = btr_133
  pts_133 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_133, 0, 0),
    Geom::Point3d.new(blen_133, 20, 0),
    Geom::Point3d.new(0, 20, 0)
  ]
  bf_133 = bg_133.entities.add_face(pts_133)
  bf_133.material = mat_c350l0 if bf_133
  bf_133.pushpull(-20) if bf_133
  bg_133.layer = layers['beams']
end
# Beam 135: PF20a →
bx1_134 = ox + 0; by1_134 = oy + 16000
bx2_134 = ox + 0; by2_134 = oy + 24000
bdx_134 = bx2_134 - bx1_134; bdy_134 = by2_134 - by1_134
blen_134 = Math.sqrt(bdx_134*bdx_134 + bdy_134*bdy_134)
if blen_134 > 0
  bang_134 = Math.atan2(bdy_134, bdx_134)
  bpt_134 = Geom::Point3d.new(bx1_134, by1_134, 3500)
  btr_134 = Geom::Transformation.translation(bpt_134)
  btr_134 = btr_134 * Geom::Transformation.rotation(bpt_134, [0,0,1], bang_134)
  bg_134 = ents.add_group
  bg_134.transformation = btr_134
  pts_134 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_134, 0, 0),
    Geom::Point3d.new(blen_134, 20, 0),
    Geom::Point3d.new(0, 20, 0)
  ]
  bf_134 = bg_134.entities.add_face(pts_134)
  bf_134.material = mat_c350l0 if bf_134
  bf_134.pushpull(-20) if bf_134
  bg_134.layer = layers['beams']
end
# Beam 136: CH32a →
bx1_135 = ox + 8000; by1_135 = oy + 0
bx2_135 = ox + 8000; by2_135 = oy + 8000
bdx_135 = bx2_135 - bx1_135; bdy_135 = by2_135 - by1_135
blen_135 = Math.sqrt(bdx_135*bdx_135 + bdy_135*bdy_135)
if blen_135 > 0
  bang_135 = Math.atan2(bdy_135, bdx_135)
  bpt_135 = Geom::Point3d.new(bx1_135, by1_135, 3500)
  btr_135 = Geom::Transformation.translation(bpt_135)
  btr_135 = btr_135 * Geom::Transformation.rotation(bpt_135, [0,0,1], bang_135)
  bg_135 = ents.add_group
  bg_135.transformation = btr_135
  pts_135 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_135, 0, 0),
    Geom::Point3d.new(blen_135, 32, 0),
    Geom::Point3d.new(0, 32, 0)
  ]
  bf_135 = bg_135.entities.add_face(pts_135)
  bf_135.material = mat_c350l0 if bf_135
  bf_135.pushpull(-32) if bf_135
  bg_135.layer = layers['beams']
end
# Beam 137: UA15a →
bx1_136 = ox + 8000; by1_136 = oy + 8000
bx2_136 = ox + 8000; by2_136 = oy + 16000
bdx_136 = bx2_136 - bx1_136; bdy_136 = by2_136 - by1_136
blen_136 = Math.sqrt(bdx_136*bdx_136 + bdy_136*bdy_136)
if blen_136 > 0
  bang_136 = Math.atan2(bdy_136, bdx_136)
  bpt_136 = Geom::Point3d.new(bx1_136, by1_136, 3500)
  btr_136 = Geom::Transformation.translation(bpt_136)
  btr_136 = btr_136 * Geom::Transformation.rotation(bpt_136, [0,0,1], bang_136)
  bg_136 = ents.add_group
  bg_136.transformation = btr_136
  pts_136 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_136, 0, 0),
    Geom::Point3d.new(blen_136, 15, 0),
    Geom::Point3d.new(0, 15, 0)
  ]
  bf_136 = bg_136.entities.add_face(pts_136)
  bf_136.material = mat_c350l0 if bf_136
  bf_136.pushpull(-15) if bf_136
  bg_136.layer = layers['beams']
end
# Beam 138: B_A_1-4 →
bx1_137 = ox + 8000; by1_137 = oy + 16000
bx2_137 = ox + 8000; by2_137 = oy + 24000
bdx_137 = bx2_137 - bx1_137; bdy_137 = by2_137 - by1_137
blen_137 = Math.sqrt(bdx_137*bdx_137 + bdy_137*bdy_137)
if blen_137 > 0
  bang_137 = Math.atan2(bdy_137, bdx_137)
  bpt_137 = Geom::Point3d.new(bx1_137, by1_137, 3500)
  btr_137 = Geom::Transformation.translation(bpt_137)
  btr_137 = btr_137 * Geom::Transformation.rotation(bpt_137, [0,0,1], bang_137)
  bg_137 = ents.add_group
  bg_137.transformation = btr_137
  pts_137 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_137, 0, 0),
    Geom::Point3d.new(blen_137, 300, 0),
    Geom::Point3d.new(0, 300, 0)
  ]
  bf_137 = bg_137.entities.add_face(pts_137)
  bf_137.material = mat_concrete if bf_137
  bf_137.pushpull(-200) if bf_137
  bg_137.layer = layers['beams']
end
# Beam 139: B_B_1-4 →
bx1_138 = ox + 16000; by1_138 = oy + 0
bx2_138 = ox + 16000; by2_138 = oy + 8000
bdx_138 = bx2_138 - bx1_138; bdy_138 = by2_138 - by1_138
blen_138 = Math.sqrt(bdx_138*bdx_138 + bdy_138*bdy_138)
if blen_138 > 0
  bang_138 = Math.atan2(bdy_138, bdx_138)
  bpt_138 = Geom::Point3d.new(bx1_138, by1_138, 3500)
  btr_138 = Geom::Transformation.translation(bpt_138)
  btr_138 = btr_138 * Geom::Transformation.rotation(bpt_138, [0,0,1], bang_138)
  bg_138 = ents.add_group
  bg_138.transformation = btr_138
  pts_138 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_138, 0, 0),
    Geom::Point3d.new(blen_138, 300, 0),
    Geom::Point3d.new(0, 300, 0)
  ]
  bf_138 = bg_138.entities.add_face(pts_138)
  bf_138.material = mat_concrete if bf_138
  bf_138.pushpull(-200) if bf_138
  bg_138.layer = layers['beams']
end
# Beam 140: B_C_1-4 →
bx1_139 = ox + 16000; by1_139 = oy + 8000
bx2_139 = ox + 16000; by2_139 = oy + 16000
bdx_139 = bx2_139 - bx1_139; bdy_139 = by2_139 - by1_139
blen_139 = Math.sqrt(bdx_139*bdx_139 + bdy_139*bdy_139)
if blen_139 > 0
  bang_139 = Math.atan2(bdy_139, bdx_139)
  bpt_139 = Geom::Point3d.new(bx1_139, by1_139, 3500)
  btr_139 = Geom::Transformation.translation(bpt_139)
  btr_139 = btr_139 * Geom::Transformation.rotation(bpt_139, [0,0,1], bang_139)
  bg_139 = ents.add_group
  bg_139.transformation = btr_139
  pts_139 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_139, 0, 0),
    Geom::Point3d.new(blen_139, 300, 0),
    Geom::Point3d.new(0, 300, 0)
  ]
  bf_139 = bg_139.entities.add_face(pts_139)
  bf_139.material = mat_concrete if bf_139
  bf_139.pushpull(-200) if bf_139
  bg_139.layer = layers['beams']
end
# Beam 141: B_D_1-4 →
bx1_140 = ox + 16000; by1_140 = oy + 16000
bx2_140 = ox + 16000; by2_140 = oy + 24000
bdx_140 = bx2_140 - bx1_140; bdy_140 = by2_140 - by1_140
blen_140 = Math.sqrt(bdx_140*bdx_140 + bdy_140*bdy_140)
if blen_140 > 0
  bang_140 = Math.atan2(bdy_140, bdx_140)
  bpt_140 = Geom::Point3d.new(bx1_140, by1_140, 3500)
  btr_140 = Geom::Transformation.translation(bpt_140)
  btr_140 = btr_140 * Geom::Transformation.rotation(bpt_140, [0,0,1], bang_140)
  bg_140 = ents.add_group
  bg_140.transformation = btr_140
  pts_140 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_140, 0, 0),
    Geom::Point3d.new(blen_140, 300, 0),
    Geom::Point3d.new(0, 300, 0)
  ]
  bf_140 = bg_140.entities.add_face(pts_140)
  bf_140.material = mat_concrete if bf_140
  bf_140.pushpull(-200) if bf_140
  bg_140.layer = layers['beams']
end
# Beam 142: B_1_A-D →
bx1_141 = ox + 24000; by1_141 = oy + 0
bx2_141 = ox + 24000; by2_141 = oy + 8000
bdx_141 = bx2_141 - bx1_141; bdy_141 = by2_141 - by1_141
blen_141 = Math.sqrt(bdx_141*bdx_141 + bdy_141*bdy_141)
if blen_141 > 0
  bang_141 = Math.atan2(bdy_141, bdx_141)
  bpt_141 = Geom::Point3d.new(bx1_141, by1_141, 3500)
  btr_141 = Geom::Transformation.translation(bpt_141)
  btr_141 = btr_141 * Geom::Transformation.rotation(bpt_141, [0,0,1], bang_141)
  bg_141 = ents.add_group
  bg_141.transformation = btr_141
  pts_141 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_141, 0, 0),
    Geom::Point3d.new(blen_141, 300, 0),
    Geom::Point3d.new(0, 300, 0)
  ]
  bf_141 = bg_141.entities.add_face(pts_141)
  bf_141.material = mat_concrete if bf_141
  bf_141.pushpull(-200) if bf_141
  bg_141.layer = layers['beams']
end
# Beam 143: B_2_A-D →
bx1_142 = ox + 24000; by1_142 = oy + 8000
bx2_142 = ox + 24000; by2_142 = oy + 16000
bdx_142 = bx2_142 - bx1_142; bdy_142 = by2_142 - by1_142
blen_142 = Math.sqrt(bdx_142*bdx_142 + bdy_142*bdy_142)
if blen_142 > 0
  bang_142 = Math.atan2(bdy_142, bdx_142)
  bpt_142 = Geom::Point3d.new(bx1_142, by1_142, 3500)
  btr_142 = Geom::Transformation.translation(bpt_142)
  btr_142 = btr_142 * Geom::Transformation.rotation(bpt_142, [0,0,1], bang_142)
  bg_142 = ents.add_group
  bg_142.transformation = btr_142
  pts_142 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_142, 0, 0),
    Geom::Point3d.new(blen_142, 300, 0),
    Geom::Point3d.new(0, 300, 0)
  ]
  bf_142 = bg_142.entities.add_face(pts_142)
  bf_142.material = mat_concrete if bf_142
  bf_142.pushpull(-200) if bf_142
  bg_142.layer = layers['beams']
end
# Beam 144: B_3_A-D →
bx1_143 = ox + 24000; by1_143 = oy + 16000
bx2_143 = ox + 24000; by2_143 = oy + 24000
bdx_143 = bx2_143 - bx1_143; bdy_143 = by2_143 - by1_143
blen_143 = Math.sqrt(bdx_143*bdx_143 + bdy_143*bdy_143)
if blen_143 > 0
  bang_143 = Math.atan2(bdy_143, bdx_143)
  bpt_143 = Geom::Point3d.new(bx1_143, by1_143, 3500)
  btr_143 = Geom::Transformation.translation(bpt_143)
  btr_143 = btr_143 * Geom::Transformation.rotation(bpt_143, [0,0,1], bang_143)
  bg_143 = ents.add_group
  bg_143.transformation = btr_143
  pts_143 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_143, 0, 0),
    Geom::Point3d.new(blen_143, 300, 0),
    Geom::Point3d.new(0, 300, 0)
  ]
  bf_143 = bg_143.entities.add_face(pts_143)
  bf_143.material = mat_concrete if bf_143
  bf_143.pushpull(-200) if bf_143
  bg_143.layer = layers['beams']
end
# Beam 145: B_4_A-D →
bx1_144 = ox + 0; by1_144 = oy + 0
bx2_144 = ox + 8000; by2_144 = oy + 0
bdx_144 = bx2_144 - bx1_144; bdy_144 = by2_144 - by1_144
blen_144 = Math.sqrt(bdx_144*bdx_144 + bdy_144*bdy_144)
if blen_144 > 0
  bang_144 = Math.atan2(bdy_144, bdx_144)
  bpt_144 = Geom::Point3d.new(bx1_144, by1_144, 3500)
  btr_144 = Geom::Transformation.translation(bpt_144)
  btr_144 = btr_144 * Geom::Transformation.rotation(bpt_144, [0,0,1], bang_144)
  bg_144 = ents.add_group
  bg_144.transformation = btr_144
  pts_144 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_144, 0, 0),
    Geom::Point3d.new(blen_144, 300, 0),
    Geom::Point3d.new(0, 300, 0)
  ]
  bf_144 = bg_144.entities.add_face(pts_144)
  bf_144.material = mat_concrete if bf_144
  bf_144.pushpull(-200) if bf_144
  bg_144.layer = layers['beams']
end
# Beam 146: HB1 →
bx1_145 = ox + 8000; by1_145 = oy + 0
bx2_145 = ox + 16000; by2_145 = oy + 0
bdx_145 = bx2_145 - bx1_145; bdy_145 = by2_145 - by1_145
blen_145 = Math.sqrt(bdx_145*bdx_145 + bdy_145*bdy_145)
if blen_145 > 0
  bang_145 = Math.atan2(bdy_145, bdx_145)
  bpt_145 = Geom::Point3d.new(bx1_145, by1_145, 3500)
  btr_145 = Geom::Transformation.translation(bpt_145)
  btr_145 = btr_145 * Geom::Transformation.rotation(bpt_145, [0,0,1], bang_145)
  bg_145 = ents.add_group
  bg_145.transformation = btr_145
  pts_145 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_145, 0, 0),
    Geom::Point3d.new(blen_145, 150, 0),
    Geom::Point3d.new(0, 150, 0)
  ]
  bf_145 = bg_145.entities.add_face(pts_145)
  bf_145.material = mat_c350l0 if bf_145
  bf_145.pushpull(-6) if bf_145
  bg_145.layer = layers['beams']
end
# Beam 147: HB2 →
bx1_146 = ox + 16000; by1_146 = oy + 0
bx2_146 = ox + 24000; by2_146 = oy + 0
bdx_146 = bx2_146 - bx1_146; bdy_146 = by2_146 - by1_146
blen_146 = Math.sqrt(bdx_146*bdx_146 + bdy_146*bdy_146)
if blen_146 > 0
  bang_146 = Math.atan2(bdy_146, bdx_146)
  bpt_146 = Geom::Point3d.new(bx1_146, by1_146, 3500)
  btr_146 = Geom::Transformation.translation(bpt_146)
  btr_146 = btr_146 * Geom::Transformation.rotation(bpt_146, [0,0,1], bang_146)
  bg_146 = ents.add_group
  bg_146.transformation = btr_146
  pts_146 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_146, 0, 0),
    Geom::Point3d.new(blen_146, 150, 0),
    Geom::Point3d.new(0, 150, 0)
  ]
  bf_146 = bg_146.entities.add_face(pts_146)
  bf_146.material = mat_c350l0 if bf_146
  bf_146.pushpull(-4) if bf_146
  bg_146.layer = layers['beams']
end
# Beam 148: HB3 →
bx1_147 = ox + 0; by1_147 = oy + 8000
bx2_147 = ox + 8000; by2_147 = oy + 8000
bdx_147 = bx2_147 - bx1_147; bdy_147 = by2_147 - by1_147
blen_147 = Math.sqrt(bdx_147*bdx_147 + bdy_147*bdy_147)
if blen_147 > 0
  bang_147 = Math.atan2(bdy_147, bdx_147)
  bpt_147 = Geom::Point3d.new(bx1_147, by1_147, 3500)
  btr_147 = Geom::Transformation.translation(bpt_147)
  btr_147 = btr_147 * Geom::Transformation.rotation(bpt_147, [0,0,1], bang_147)
  bg_147 = ents.add_group
  bg_147.transformation = btr_147
  pts_147 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_147, 0, 0),
    Geom::Point3d.new(blen_147, 150, 0),
    Geom::Point3d.new(0, 150, 0)
  ]
  bf_147 = bg_147.entities.add_face(pts_147)
  bf_147.material = mat_c350l0 if bf_147
  bf_147.pushpull(-8) if bf_147
  bg_147.layer = layers['beams']
end
# Beam 149: HB4 →
bx1_148 = ox + 8000; by1_148 = oy + 8000
bx2_148 = ox + 16000; by2_148 = oy + 8000
bdx_148 = bx2_148 - bx1_148; bdy_148 = by2_148 - by1_148
blen_148 = Math.sqrt(bdx_148*bdx_148 + bdy_148*bdy_148)
if blen_148 > 0
  bang_148 = Math.atan2(bdy_148, bdx_148)
  bpt_148 = Geom::Point3d.new(bx1_148, by1_148, 3500)
  btr_148 = Geom::Transformation.translation(bpt_148)
  btr_148 = btr_148 * Geom::Transformation.rotation(bpt_148, [0,0,1], bang_148)
  bg_148 = ents.add_group
  bg_148.transformation = btr_148
  pts_148 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_148, 0, 0),
    Geom::Point3d.new(blen_148, 150, 0),
    Geom::Point3d.new(0, 150, 0)
  ]
  bf_148 = bg_148.entities.add_face(pts_148)
  bf_148.material = mat_c350l0 if bf_148
  bf_148.pushpull(-8) if bf_148
  bg_148.layer = layers['beams']
end
# Beam 150: HB5 →
bx1_149 = ox + 16000; by1_149 = oy + 8000
bx2_149 = ox + 24000; by2_149 = oy + 8000
bdx_149 = bx2_149 - bx1_149; bdy_149 = by2_149 - by1_149
blen_149 = Math.sqrt(bdx_149*bdx_149 + bdy_149*bdy_149)
if blen_149 > 0
  bang_149 = Math.atan2(bdy_149, bdx_149)
  bpt_149 = Geom::Point3d.new(bx1_149, by1_149, 3500)
  btr_149 = Geom::Transformation.translation(bpt_149)
  btr_149 = btr_149 * Geom::Transformation.rotation(bpt_149, [0,0,1], bang_149)
  bg_149 = ents.add_group
  bg_149.transformation = btr_149
  pts_149 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_149, 0, 0),
    Geom::Point3d.new(blen_149, 150, 0),
    Geom::Point3d.new(0, 150, 0)
  ]
  bf_149 = bg_149.entities.add_face(pts_149)
  bf_149.material = mat_c350l0 if bf_149
  bf_149.pushpull(-8) if bf_149
  bg_149.layer = layers['beams']
end
# Beam 151: HB6 →
bx1_150 = ox + 0; by1_150 = oy + 16000
bx2_150 = ox + 8000; by2_150 = oy + 16000
bdx_150 = bx2_150 - bx1_150; bdy_150 = by2_150 - by1_150
blen_150 = Math.sqrt(bdx_150*bdx_150 + bdy_150*bdy_150)
if blen_150 > 0
  bang_150 = Math.atan2(bdy_150, bdx_150)
  bpt_150 = Geom::Point3d.new(bx1_150, by1_150, 3500)
  btr_150 = Geom::Transformation.translation(bpt_150)
  btr_150 = btr_150 * Geom::Transformation.rotation(bpt_150, [0,0,1], bang_150)
  bg_150 = ents.add_group
  bg_150.transformation = btr_150
  pts_150 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_150, 0, 0),
    Geom::Point3d.new(blen_150, 150, 0),
    Geom::Point3d.new(0, 150, 0)
  ]
  bf_150 = bg_150.entities.add_face(pts_150)
  bf_150.material = mat_c350l0 if bf_150
  bf_150.pushpull(-8) if bf_150
  bg_150.layer = layers['beams']
end
# Beam 152: HB7 →
bx1_151 = ox + 8000; by1_151 = oy + 16000
bx2_151 = ox + 16000; by2_151 = oy + 16000
bdx_151 = bx2_151 - bx1_151; bdy_151 = by2_151 - by1_151
blen_151 = Math.sqrt(bdx_151*bdx_151 + bdy_151*bdy_151)
if blen_151 > 0
  bang_151 = Math.atan2(bdy_151, bdx_151)
  bpt_151 = Geom::Point3d.new(bx1_151, by1_151, 3500)
  btr_151 = Geom::Transformation.translation(bpt_151)
  btr_151 = btr_151 * Geom::Transformation.rotation(bpt_151, [0,0,1], bang_151)
  bg_151 = ents.add_group
  bg_151.transformation = btr_151
  pts_151 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_151, 0, 0),
    Geom::Point3d.new(blen_151, 150, 0),
    Geom::Point3d.new(0, 150, 0)
  ]
  bf_151 = bg_151.entities.add_face(pts_151)
  bf_151.material = mat_c350l0 if bf_151
  bf_151.pushpull(-8) if bf_151
  bg_151.layer = layers['beams']
end
# Beam 153: HB8 →
bx1_152 = ox + 16000; by1_152 = oy + 16000
bx2_152 = ox + 24000; by2_152 = oy + 16000
bdx_152 = bx2_152 - bx1_152; bdy_152 = by2_152 - by1_152
blen_152 = Math.sqrt(bdx_152*bdx_152 + bdy_152*bdy_152)
if blen_152 > 0
  bang_152 = Math.atan2(bdy_152, bdx_152)
  bpt_152 = Geom::Point3d.new(bx1_152, by1_152, 3500)
  btr_152 = Geom::Transformation.translation(bpt_152)
  btr_152 = btr_152 * Geom::Transformation.rotation(bpt_152, [0,0,1], bang_152)
  bg_152 = ents.add_group
  bg_152.transformation = btr_152
  pts_152 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_152, 0, 0),
    Geom::Point3d.new(blen_152, 150, 0),
    Geom::Point3d.new(0, 150, 0)
  ]
  bf_152 = bg_152.entities.add_face(pts_152)
  bf_152.material = mat_c350l0 if bf_152
  bf_152.pushpull(-2) if bf_152
  bg_152.layer = layers['beams']
end
# Beam 154: CB1 →
bx1_153 = ox + 0; by1_153 = oy + 24000
bx2_153 = ox + 8000; by2_153 = oy + 24000
bdx_153 = bx2_153 - bx1_153; bdy_153 = by2_153 - by1_153
blen_153 = Math.sqrt(bdx_153*bdx_153 + bdy_153*bdy_153)
if blen_153 > 0
  bang_153 = Math.atan2(bdy_153, bdx_153)
  bpt_153 = Geom::Point3d.new(bx1_153, by1_153, 3500)
  btr_153 = Geom::Transformation.translation(bpt_153)
  btr_153 = btr_153 * Geom::Transformation.rotation(bpt_153, [0,0,1], bang_153)
  bg_153 = ents.add_group
  bg_153.transformation = btr_153
  pts_153 = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(blen_153, 0, 0),
    Geom::Point3d.new(blen_153, 600, 0),
    Geom::Point3d.new(0, 600, 0)
  ]
  bf_153 = bg_153.entities.add_face(pts_153)
  bf_153.material = mat_c350l0 if bf_153
  bf_153.pushpull(-750) if bf_153
  bg_153.layer = layers['beams']
end

# === Slabs ===
# Slab 1: S_AUTO_GL
pts_0 = [
  Geom::Point3d.new(ox, oy, 0),
  Geom::Point3d.new(ox+24000, oy, 0),
  Geom::Point3d.new(ox+24000, oy+24000, 0),
  Geom::Point3d.new(ox, oy+24000, 0)
]
f_0 = ents.add_face(pts_0)
f_0.material = mat_reinforced_concrete if f_0
f_0.layer = layers['slabs'] if f_0
f_0.pushpull(-200) if f_0
# Slab 2: S_AUTO_LEVEL 01
pts_1 = [
  Geom::Point3d.new(ox, oy, 0),
  Geom::Point3d.new(ox+24000, oy, 0),
  Geom::Point3d.new(ox+24000, oy+24000, 0),
  Geom::Point3d.new(ox, oy+24000, 0)
]
f_1 = ents.add_face(pts_1)
f_1.material = mat_reinforced_concrete if f_1
f_1.layer = layers['slabs'] if f_1
f_1.pushpull(-200) if f_1
# Slab 3: S_AUTO_LEVEL 02
pts_2 = [
  Geom::Point3d.new(ox, oy, 0),
  Geom::Point3d.new(ox+24000, oy, 0),
  Geom::Point3d.new(ox+24000, oy+24000, 0),
  Geom::Point3d.new(ox, oy+24000, 0)
]
f_2 = ents.add_face(pts_2)
f_2.material = mat_reinforced_concrete if f_2
f_2.layer = layers['slabs'] if f_2
f_2.pushpull(-200) if f_2
# Slab 4: S_AUTO_LEVEL 03
pts_3 = [
  Geom::Point3d.new(ox, oy, 3500),
  Geom::Point3d.new(ox+24000, oy, 3500),
  Geom::Point3d.new(ox+24000, oy+24000, 3500),
  Geom::Point3d.new(ox, oy+24000, 3500)
]
f_3 = ents.add_face(pts_3)
f_3.material = mat_reinforced_concrete if f_3
f_3.layer = layers['slabs'] if f_3
f_3.pushpull(-200) if f_3
# Slab 5: S_AUTO_LEVEL 04
pts_4 = [
  Geom::Point3d.new(ox, oy, 0),
  Geom::Point3d.new(ox+24000, oy, 0),
  Geom::Point3d.new(ox+24000, oy+24000, 0),
  Geom::Point3d.new(ox, oy+24000, 0)
]
f_4 = ents.add_face(pts_4)
f_4.material = mat_reinforced_concrete if f_4
f_4.layer = layers['slabs'] if f_4
f_4.pushpull(-200) if f_4
# Slab 6: S_AUTO_LEVEL 05
pts_5 = [
  Geom::Point3d.new(ox, oy, 0),
  Geom::Point3d.new(ox+24000, oy, 0),
  Geom::Point3d.new(ox+24000, oy+24000, 0),
  Geom::Point3d.new(ox, oy+24000, 0)
]
f_5 = ents.add_face(pts_5)
f_5.material = mat_reinforced_concrete if f_5
f_5.layer = layers['slabs'] if f_5
f_5.pushpull(-200) if f_5
# Slab 7: S_AUTO_ROOF
pts_6 = [
  Geom::Point3d.new(ox, oy, 0),
  Geom::Point3d.new(ox+24000, oy, 0),
  Geom::Point3d.new(ox+24000, oy+24000, 0),
  Geom::Point3d.new(ox, oy+24000, 0)
]
f_6 = ents.add_face(pts_6)
f_6.material = mat_reinforced_concrete if f_6
f_6.layer = layers['slabs'] if f_6
f_6.pushpull(-200) if f_6

# === Walls ===
# Wall 1: W1
v_0 = Geom::Vector3d.new(24000,0,0)
if v_0.length > 0
  d_0 = v_0.normalize
  p_0 = Geom::Vector3d.new(-d_0.y, d_0.x, 0)
  s_0 = Geom::Point3d.new(ox+0, oy+24000, 3500)
  e_0 = Geom::Point3d.new(ox+24000, oy+24000, 3500)
  ht = 200 / 2.0
  pts_0 = [s_0+p_0*ht, e_0+p_0*ht, e_0-p_0*ht, s_0-p_0*ht]
  f_0 = ents.add_face(pts_0)
  f_0.material = mat_reinforced_concrete if f_0
  f_0.layer = layers['walls'] if f_0
  f_0.pushpull(3500) if f_0
end
# Wall 2: W2
v_1 = Geom::Vector3d.new(24000,0,0)
if v_1.length > 0
  d_1 = v_1.normalize
  p_1 = Geom::Vector3d.new(-d_1.y, d_1.x, 0)
  s_1 = Geom::Point3d.new(ox+0, oy+0, 3500)
  e_1 = Geom::Point3d.new(ox+24000, oy+0, 3500)
  ht = 200 / 2.0
  pts_1 = [s_1+p_1*ht, e_1+p_1*ht, e_1-p_1*ht, s_1-p_1*ht]
  f_1 = ents.add_face(pts_1)
  f_1.material = mat_reinforced_concrete if f_1
  f_1.layer = layers['walls'] if f_1
  f_1.pushpull(3500) if f_1
end
# Wall 3: W3
v_2 = Geom::Vector3d.new(6000,24000,0)
if v_2.length > 0
  d_2 = v_2.normalize
  p_2 = Geom::Vector3d.new(-d_2.y, d_2.x, 0)
  s_2 = Geom::Point3d.new(ox+0, oy+0, 3500)
  e_2 = Geom::Point3d.new(ox+6000, oy+24000, 3500)
  ht = 200 / 2.0
  pts_2 = [s_2+p_2*ht, e_2+p_2*ht, e_2-p_2*ht, s_2-p_2*ht]
  f_2 = ents.add_face(pts_2)
  f_2.material = mat_reinforced_concrete if f_2
  f_2.layer = layers['walls'] if f_2
  f_2.pushpull(3500) if f_2
end
# Wall 4: W4
v_3 = Geom::Vector3d.new(0,24000,0)
if v_3.length > 0
  d_3 = v_3.normalize
  p_3 = Geom::Vector3d.new(-d_3.y, d_3.x, 0)
  s_3 = Geom::Point3d.new(ox+24000, oy+0, 3500)
  e_3 = Geom::Point3d.new(ox+24000, oy+24000, 3500)
  ht = 200 / 2.0
  pts_3 = [s_3+p_3*ht, e_3+p_3*ht, e_3-p_3*ht, s_3-p_3*ht]
  f_3 = ents.add_face(pts_3)
  f_3.material = mat_reinforced_concrete if f_3
  f_3.layer = layers['walls'] if f_3
  f_3.pushpull(3500) if f_3
end

# === Footings ===
# Footing 1: P1 (pile)
pts_0 = [
  Geom::Point3d.new(ox+-300, oy+15700, -1600),
  Geom::Point3d.new(ox+300, oy+15700, -1600),
  Geom::Point3d.new(ox+300, oy+16300, -1600),
  Geom::Point3d.new(ox+-300, oy+16300, -1600)
]
f_0 = ents.add_face(pts_0)
f_0.material = mat_c350l0 if f_0
f_0.layer = layers['ftgs'] if f_0
f_0.pushpull(600) if f_0
# Footing 2: P2 (pile)
pts_1 = [
  Geom::Point3d.new(ox+2700, oy+5700, -3000),
  Geom::Point3d.new(ox+3300, oy+5700, -3000),
  Geom::Point3d.new(ox+3300, oy+6300, -3000),
  Geom::Point3d.new(ox+2700, oy+6300, -3000)
]
f_1 = ents.add_face(pts_1)
f_1.material = mat_c350l0 if f_1
f_1.layer = layers['ftgs'] if f_1
f_1.pushpull(2000) if f_1
# Footing 3: P3 (pile)
pts_2 = [
  Geom::Point3d.new(ox+5700, oy+29700, -1300),
  Geom::Point3d.new(ox+6300, oy+29700, -1300),
  Geom::Point3d.new(ox+6300, oy+30300, -1300),
  Geom::Point3d.new(ox+5700, oy+30300, -1300)
]
f_2 = ents.add_face(pts_2)
f_2.material = mat_c350l0 if f_2
f_2.layer = layers['ftgs'] if f_2
f_2.pushpull(300) if f_2
# Footing 4: P4 (pile)
pts_3 = [
  Geom::Point3d.new(ox+7700, oy+101700, -3000),
  Geom::Point3d.new(ox+8300, oy+101700, -3000),
  Geom::Point3d.new(ox+8300, oy+102300, -3000),
  Geom::Point3d.new(ox+7700, oy+102300, -3000)
]
f_3 = ents.add_face(pts_3)
f_3.material = mat_c350l0 if f_3
f_3.layer = layers['ftgs'] if f_3
f_3.pushpull(2000) if f_3
# Footing 5: P5 (pile)
pts_4 = [
  Geom::Point3d.new(ox+8700, oy+8700, -3000),
  Geom::Point3d.new(ox+9300, oy+8700, -3000),
  Geom::Point3d.new(ox+9300, oy+9300, -3000),
  Geom::Point3d.new(ox+8700, oy+9300, -3000)
]
f_4 = ents.add_face(pts_4)
f_4.material = mat_c350l0 if f_4
f_4.layer = layers['ftgs'] if f_4
f_4.pushpull(2000) if f_4
# Footing 6: RF1 (raft)
pts_5 = [
  Geom::Point3d.new(ox+8750, oy+45200, -2000),
  Geom::Point3d.new(ox+15250, oy+45200, -2000),
  Geom::Point3d.new(ox+15250, oy+50800, -2000),
  Geom::Point3d.new(ox+8750, oy+50800, -2000)
]
f_5 = ents.add_face(pts_5)
f_5.material = mat_c350l0 if f_5
f_5.layer = layers['ftgs'] if f_5
f_5.pushpull(1000) if f_5

# === LOD350 Connections (Base Plates + End Plates) ===
layers['conns'] = model.layers.add('S_BASEPLATE')
mat_steel_plate = model.materials.add('SteelPlate')
mat_steel_plate.color = Sketchup::Color.new(140,140,160)
# LOD350 base+cap plates: col 1
begin
  bplate_0_pts = [
    Geom::Point3d.new(ox+-150, oy+15850, -20),
    Geom::Point3d.new(ox+150, oy+15850, -20),
    Geom::Point3d.new(ox+150, oy+16150, -20),
    Geom::Point3d.new(ox+-150, oy+16150, -20)
  ]
  bplate_0_f = ents.add_face(bplate_0_pts)
  if bplate_0_f
    bplate_0_f.material = mat_steel_plate
    bplate_0_f.layer = layers['conns']
    bplate_0_f.pushpull(20)
  end
rescue; end
begin
  cplate_0_pts = [
    Geom::Point3d.new(ox+-150, oy+15850, 3500),
    Geom::Point3d.new(ox+150, oy+15850, 3500),
    Geom::Point3d.new(ox+150, oy+16150, 3500),
    Geom::Point3d.new(ox+-150, oy+16150, 3500)
  ]
  cplate_0_f = ents.add_face(cplate_0_pts)
  if cplate_0_f
    cplate_0_f.material = mat_steel_plate
    cplate_0_f.layer = layers['conns']
    cplate_0_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 2
begin
  bplate_1_pts = [
    Geom::Point3d.new(ox+7850, oy+15850, -20),
    Geom::Point3d.new(ox+8150, oy+15850, -20),
    Geom::Point3d.new(ox+8150, oy+16150, -20),
    Geom::Point3d.new(ox+7850, oy+16150, -20)
  ]
  bplate_1_f = ents.add_face(bplate_1_pts)
  if bplate_1_f
    bplate_1_f.material = mat_steel_plate
    bplate_1_f.layer = layers['conns']
    bplate_1_f.pushpull(20)
  end
rescue; end
begin
  cplate_1_pts = [
    Geom::Point3d.new(ox+7850, oy+15850, 3500),
    Geom::Point3d.new(ox+8150, oy+15850, 3500),
    Geom::Point3d.new(ox+8150, oy+16150, 3500),
    Geom::Point3d.new(ox+7850, oy+16150, 3500)
  ]
  cplate_1_f = ents.add_face(cplate_1_pts)
  if cplate_1_f
    cplate_1_f.material = mat_steel_plate
    cplate_1_f.layer = layers['conns']
    cplate_1_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 3
begin
  bplate_2_pts = [
    Geom::Point3d.new(ox+15850, oy+15850, -20),
    Geom::Point3d.new(ox+16150, oy+15850, -20),
    Geom::Point3d.new(ox+16150, oy+16150, -20),
    Geom::Point3d.new(ox+15850, oy+16150, -20)
  ]
  bplate_2_f = ents.add_face(bplate_2_pts)
  if bplate_2_f
    bplate_2_f.material = mat_steel_plate
    bplate_2_f.layer = layers['conns']
    bplate_2_f.pushpull(20)
  end
rescue; end
begin
  cplate_2_pts = [
    Geom::Point3d.new(ox+15850, oy+15850, 3500),
    Geom::Point3d.new(ox+16150, oy+15850, 3500),
    Geom::Point3d.new(ox+16150, oy+16150, 3500),
    Geom::Point3d.new(ox+15850, oy+16150, 3500)
  ]
  cplate_2_f = ents.add_face(cplate_2_pts)
  if cplate_2_f
    cplate_2_f.material = mat_steel_plate
    cplate_2_f.layer = layers['conns']
    cplate_2_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 4
begin
  bplate_3_pts = [
    Geom::Point3d.new(ox+23850, oy+15850, -20),
    Geom::Point3d.new(ox+24150, oy+15850, -20),
    Geom::Point3d.new(ox+24150, oy+16150, -20),
    Geom::Point3d.new(ox+23850, oy+16150, -20)
  ]
  bplate_3_f = ents.add_face(bplate_3_pts)
  if bplate_3_f
    bplate_3_f.material = mat_steel_plate
    bplate_3_f.layer = layers['conns']
    bplate_3_f.pushpull(20)
  end
rescue; end
begin
  cplate_3_pts = [
    Geom::Point3d.new(ox+23850, oy+15850, 3500),
    Geom::Point3d.new(ox+24150, oy+15850, 3500),
    Geom::Point3d.new(ox+24150, oy+16150, 3500),
    Geom::Point3d.new(ox+23850, oy+16150, 3500)
  ]
  cplate_3_f = ents.add_face(cplate_3_pts)
  if cplate_3_f
    cplate_3_f.material = mat_steel_plate
    cplate_3_f.layer = layers['conns']
    cplate_3_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 5
begin
  bplate_4_pts = [
    Geom::Point3d.new(ox+-150, oy+7850, -20),
    Geom::Point3d.new(ox+150, oy+7850, -20),
    Geom::Point3d.new(ox+150, oy+8150, -20),
    Geom::Point3d.new(ox+-150, oy+8150, -20)
  ]
  bplate_4_f = ents.add_face(bplate_4_pts)
  if bplate_4_f
    bplate_4_f.material = mat_steel_plate
    bplate_4_f.layer = layers['conns']
    bplate_4_f.pushpull(20)
  end
rescue; end
begin
  cplate_4_pts = [
    Geom::Point3d.new(ox+-150, oy+7850, 3500),
    Geom::Point3d.new(ox+150, oy+7850, 3500),
    Geom::Point3d.new(ox+150, oy+8150, 3500),
    Geom::Point3d.new(ox+-150, oy+8150, 3500)
  ]
  cplate_4_f = ents.add_face(cplate_4_pts)
  if cplate_4_f
    cplate_4_f.material = mat_steel_plate
    cplate_4_f.layer = layers['conns']
    cplate_4_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 6
begin
  bplate_5_pts = [
    Geom::Point3d.new(ox+7850, oy+7850, -20),
    Geom::Point3d.new(ox+8150, oy+7850, -20),
    Geom::Point3d.new(ox+8150, oy+8150, -20),
    Geom::Point3d.new(ox+7850, oy+8150, -20)
  ]
  bplate_5_f = ents.add_face(bplate_5_pts)
  if bplate_5_f
    bplate_5_f.material = mat_steel_plate
    bplate_5_f.layer = layers['conns']
    bplate_5_f.pushpull(20)
  end
rescue; end
begin
  cplate_5_pts = [
    Geom::Point3d.new(ox+7850, oy+7850, 3500),
    Geom::Point3d.new(ox+8150, oy+7850, 3500),
    Geom::Point3d.new(ox+8150, oy+8150, 3500),
    Geom::Point3d.new(ox+7850, oy+8150, 3500)
  ]
  cplate_5_f = ents.add_face(cplate_5_pts)
  if cplate_5_f
    cplate_5_f.material = mat_steel_plate
    cplate_5_f.layer = layers['conns']
    cplate_5_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 7
begin
  bplate_6_pts = [
    Geom::Point3d.new(ox+15850, oy+7850, -20),
    Geom::Point3d.new(ox+16150, oy+7850, -20),
    Geom::Point3d.new(ox+16150, oy+8150, -20),
    Geom::Point3d.new(ox+15850, oy+8150, -20)
  ]
  bplate_6_f = ents.add_face(bplate_6_pts)
  if bplate_6_f
    bplate_6_f.material = mat_steel_plate
    bplate_6_f.layer = layers['conns']
    bplate_6_f.pushpull(20)
  end
rescue; end
begin
  cplate_6_pts = [
    Geom::Point3d.new(ox+15850, oy+7850, 3500),
    Geom::Point3d.new(ox+16150, oy+7850, 3500),
    Geom::Point3d.new(ox+16150, oy+8150, 3500),
    Geom::Point3d.new(ox+15850, oy+8150, 3500)
  ]
  cplate_6_f = ents.add_face(cplate_6_pts)
  if cplate_6_f
    cplate_6_f.material = mat_steel_plate
    cplate_6_f.layer = layers['conns']
    cplate_6_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 8
begin
  bplate_7_pts = [
    Geom::Point3d.new(ox+23850, oy+7850, -20),
    Geom::Point3d.new(ox+24150, oy+7850, -20),
    Geom::Point3d.new(ox+24150, oy+8150, -20),
    Geom::Point3d.new(ox+23850, oy+8150, -20)
  ]
  bplate_7_f = ents.add_face(bplate_7_pts)
  if bplate_7_f
    bplate_7_f.material = mat_steel_plate
    bplate_7_f.layer = layers['conns']
    bplate_7_f.pushpull(20)
  end
rescue; end
begin
  cplate_7_pts = [
    Geom::Point3d.new(ox+23850, oy+7850, 3500),
    Geom::Point3d.new(ox+24150, oy+7850, 3500),
    Geom::Point3d.new(ox+24150, oy+8150, 3500),
    Geom::Point3d.new(ox+23850, oy+8150, 3500)
  ]
  cplate_7_f = ents.add_face(cplate_7_pts)
  if cplate_7_f
    cplate_7_f.material = mat_steel_plate
    cplate_7_f.layer = layers['conns']
    cplate_7_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 9
begin
  bplate_8_pts = [
    Geom::Point3d.new(ox+-150, oy+-150, -20),
    Geom::Point3d.new(ox+150, oy+-150, -20),
    Geom::Point3d.new(ox+150, oy+150, -20),
    Geom::Point3d.new(ox+-150, oy+150, -20)
  ]
  bplate_8_f = ents.add_face(bplate_8_pts)
  if bplate_8_f
    bplate_8_f.material = mat_steel_plate
    bplate_8_f.layer = layers['conns']
    bplate_8_f.pushpull(20)
  end
rescue; end
begin
  cplate_8_pts = [
    Geom::Point3d.new(ox+-150, oy+-150, 3500),
    Geom::Point3d.new(ox+150, oy+-150, 3500),
    Geom::Point3d.new(ox+150, oy+150, 3500),
    Geom::Point3d.new(ox+-150, oy+150, 3500)
  ]
  cplate_8_f = ents.add_face(cplate_8_pts)
  if cplate_8_f
    cplate_8_f.material = mat_steel_plate
    cplate_8_f.layer = layers['conns']
    cplate_8_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 10
begin
  bplate_9_pts = [
    Geom::Point3d.new(ox+7850, oy+-150, -20),
    Geom::Point3d.new(ox+8150, oy+-150, -20),
    Geom::Point3d.new(ox+8150, oy+150, -20),
    Geom::Point3d.new(ox+7850, oy+150, -20)
  ]
  bplate_9_f = ents.add_face(bplate_9_pts)
  if bplate_9_f
    bplate_9_f.material = mat_steel_plate
    bplate_9_f.layer = layers['conns']
    bplate_9_f.pushpull(20)
  end
rescue; end
begin
  cplate_9_pts = [
    Geom::Point3d.new(ox+7850, oy+-150, 3500),
    Geom::Point3d.new(ox+8150, oy+-150, 3500),
    Geom::Point3d.new(ox+8150, oy+150, 3500),
    Geom::Point3d.new(ox+7850, oy+150, 3500)
  ]
  cplate_9_f = ents.add_face(cplate_9_pts)
  if cplate_9_f
    cplate_9_f.material = mat_steel_plate
    cplate_9_f.layer = layers['conns']
    cplate_9_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 11
begin
  bplate_10_pts = [
    Geom::Point3d.new(ox+15850, oy+-150, -20),
    Geom::Point3d.new(ox+16150, oy+-150, -20),
    Geom::Point3d.new(ox+16150, oy+150, -20),
    Geom::Point3d.new(ox+15850, oy+150, -20)
  ]
  bplate_10_f = ents.add_face(bplate_10_pts)
  if bplate_10_f
    bplate_10_f.material = mat_steel_plate
    bplate_10_f.layer = layers['conns']
    bplate_10_f.pushpull(20)
  end
rescue; end
begin
  cplate_10_pts = [
    Geom::Point3d.new(ox+15850, oy+-150, 3500),
    Geom::Point3d.new(ox+16150, oy+-150, 3500),
    Geom::Point3d.new(ox+16150, oy+150, 3500),
    Geom::Point3d.new(ox+15850, oy+150, 3500)
  ]
  cplate_10_f = ents.add_face(cplate_10_pts)
  if cplate_10_f
    cplate_10_f.material = mat_steel_plate
    cplate_10_f.layer = layers['conns']
    cplate_10_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 12
begin
  bplate_11_pts = [
    Geom::Point3d.new(ox+23850, oy+-150, -20),
    Geom::Point3d.new(ox+24150, oy+-150, -20),
    Geom::Point3d.new(ox+24150, oy+150, -20),
    Geom::Point3d.new(ox+23850, oy+150, -20)
  ]
  bplate_11_f = ents.add_face(bplate_11_pts)
  if bplate_11_f
    bplate_11_f.material = mat_steel_plate
    bplate_11_f.layer = layers['conns']
    bplate_11_f.pushpull(20)
  end
rescue; end
begin
  cplate_11_pts = [
    Geom::Point3d.new(ox+23850, oy+-150, 3500),
    Geom::Point3d.new(ox+24150, oy+-150, 3500),
    Geom::Point3d.new(ox+24150, oy+150, 3500),
    Geom::Point3d.new(ox+23850, oy+150, 3500)
  ]
  cplate_11_f = ents.add_face(cplate_11_pts)
  if cplate_11_f
    cplate_11_f.material = mat_steel_plate
    cplate_11_f.layer = layers['conns']
    cplate_11_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 13
begin
  bplate_12_pts = [
    Geom::Point3d.new(ox+-150, oy+17850, -20),
    Geom::Point3d.new(ox+150, oy+17850, -20),
    Geom::Point3d.new(ox+150, oy+18150, -20),
    Geom::Point3d.new(ox+-150, oy+18150, -20)
  ]
  bplate_12_f = ents.add_face(bplate_12_pts)
  if bplate_12_f
    bplate_12_f.material = mat_steel_plate
    bplate_12_f.layer = layers['conns']
    bplate_12_f.pushpull(20)
  end
rescue; end
begin
  cplate_12_pts = [
    Geom::Point3d.new(ox+-150, oy+17850, 3500),
    Geom::Point3d.new(ox+150, oy+17850, 3500),
    Geom::Point3d.new(ox+150, oy+18150, 3500),
    Geom::Point3d.new(ox+-150, oy+18150, 3500)
  ]
  cplate_12_f = ents.add_face(cplate_12_pts)
  if cplate_12_f
    cplate_12_f.material = mat_steel_plate
    cplate_12_f.layer = layers['conns']
    cplate_12_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 14
begin
  bplate_13_pts = [
    Geom::Point3d.new(ox+5850, oy+17850, -20),
    Geom::Point3d.new(ox+6150, oy+17850, -20),
    Geom::Point3d.new(ox+6150, oy+18150, -20),
    Geom::Point3d.new(ox+5850, oy+18150, -20)
  ]
  bplate_13_f = ents.add_face(bplate_13_pts)
  if bplate_13_f
    bplate_13_f.material = mat_steel_plate
    bplate_13_f.layer = layers['conns']
    bplate_13_f.pushpull(20)
  end
rescue; end
begin
  cplate_13_pts = [
    Geom::Point3d.new(ox+5850, oy+17850, 3500),
    Geom::Point3d.new(ox+6150, oy+17850, 3500),
    Geom::Point3d.new(ox+6150, oy+18150, 3500),
    Geom::Point3d.new(ox+5850, oy+18150, 3500)
  ]
  cplate_13_f = ents.add_face(cplate_13_pts)
  if cplate_13_f
    cplate_13_f.material = mat_steel_plate
    cplate_13_f.layer = layers['conns']
    cplate_13_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 15
begin
  bplate_14_pts = [
    Geom::Point3d.new(ox+11850, oy+17850, -20),
    Geom::Point3d.new(ox+12150, oy+17850, -20),
    Geom::Point3d.new(ox+12150, oy+18150, -20),
    Geom::Point3d.new(ox+11850, oy+18150, -20)
  ]
  bplate_14_f = ents.add_face(bplate_14_pts)
  if bplate_14_f
    bplate_14_f.material = mat_steel_plate
    bplate_14_f.layer = layers['conns']
    bplate_14_f.pushpull(20)
  end
rescue; end
begin
  cplate_14_pts = [
    Geom::Point3d.new(ox+11850, oy+17850, 3500),
    Geom::Point3d.new(ox+12150, oy+17850, 3500),
    Geom::Point3d.new(ox+12150, oy+18150, 3500),
    Geom::Point3d.new(ox+11850, oy+18150, 3500)
  ]
  cplate_14_f = ents.add_face(cplate_14_pts)
  if cplate_14_f
    cplate_14_f.material = mat_steel_plate
    cplate_14_f.layer = layers['conns']
    cplate_14_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 16
begin
  bplate_15_pts = [
    Geom::Point3d.new(ox+17850, oy+17850, -20),
    Geom::Point3d.new(ox+18150, oy+17850, -20),
    Geom::Point3d.new(ox+18150, oy+18150, -20),
    Geom::Point3d.new(ox+17850, oy+18150, -20)
  ]
  bplate_15_f = ents.add_face(bplate_15_pts)
  if bplate_15_f
    bplate_15_f.material = mat_steel_plate
    bplate_15_f.layer = layers['conns']
    bplate_15_f.pushpull(20)
  end
rescue; end
begin
  cplate_15_pts = [
    Geom::Point3d.new(ox+17850, oy+17850, 3500),
    Geom::Point3d.new(ox+18150, oy+17850, 3500),
    Geom::Point3d.new(ox+18150, oy+18150, 3500),
    Geom::Point3d.new(ox+17850, oy+18150, 3500)
  ]
  cplate_15_f = ents.add_face(cplate_15_pts)
  if cplate_15_f
    cplate_15_f.material = mat_steel_plate
    cplate_15_f.layer = layers['conns']
    cplate_15_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 17
begin
  bplate_16_pts = [
    Geom::Point3d.new(ox+-150, oy+23850, -20),
    Geom::Point3d.new(ox+150, oy+23850, -20),
    Geom::Point3d.new(ox+150, oy+24150, -20),
    Geom::Point3d.new(ox+-150, oy+24150, -20)
  ]
  bplate_16_f = ents.add_face(bplate_16_pts)
  if bplate_16_f
    bplate_16_f.material = mat_steel_plate
    bplate_16_f.layer = layers['conns']
    bplate_16_f.pushpull(20)
  end
rescue; end
begin
  cplate_16_pts = [
    Geom::Point3d.new(ox+-150, oy+23850, 3500),
    Geom::Point3d.new(ox+150, oy+23850, 3500),
    Geom::Point3d.new(ox+150, oy+24150, 3500),
    Geom::Point3d.new(ox+-150, oy+24150, 3500)
  ]
  cplate_16_f = ents.add_face(cplate_16_pts)
  if cplate_16_f
    cplate_16_f.material = mat_steel_plate
    cplate_16_f.layer = layers['conns']
    cplate_16_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 18
begin
  bplate_17_pts = [
    Geom::Point3d.new(ox+5850, oy+23850, -20),
    Geom::Point3d.new(ox+6150, oy+23850, -20),
    Geom::Point3d.new(ox+6150, oy+24150, -20),
    Geom::Point3d.new(ox+5850, oy+24150, -20)
  ]
  bplate_17_f = ents.add_face(bplate_17_pts)
  if bplate_17_f
    bplate_17_f.material = mat_steel_plate
    bplate_17_f.layer = layers['conns']
    bplate_17_f.pushpull(20)
  end
rescue; end
begin
  cplate_17_pts = [
    Geom::Point3d.new(ox+5850, oy+23850, 3500),
    Geom::Point3d.new(ox+6150, oy+23850, 3500),
    Geom::Point3d.new(ox+6150, oy+24150, 3500),
    Geom::Point3d.new(ox+5850, oy+24150, 3500)
  ]
  cplate_17_f = ents.add_face(cplate_17_pts)
  if cplate_17_f
    cplate_17_f.material = mat_steel_plate
    cplate_17_f.layer = layers['conns']
    cplate_17_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 19
begin
  bplate_18_pts = [
    Geom::Point3d.new(ox+11850, oy+23850, -20),
    Geom::Point3d.new(ox+12150, oy+23850, -20),
    Geom::Point3d.new(ox+12150, oy+24150, -20),
    Geom::Point3d.new(ox+11850, oy+24150, -20)
  ]
  bplate_18_f = ents.add_face(bplate_18_pts)
  if bplate_18_f
    bplate_18_f.material = mat_steel_plate
    bplate_18_f.layer = layers['conns']
    bplate_18_f.pushpull(20)
  end
rescue; end
begin
  cplate_18_pts = [
    Geom::Point3d.new(ox+11850, oy+23850, 3500),
    Geom::Point3d.new(ox+12150, oy+23850, 3500),
    Geom::Point3d.new(ox+12150, oy+24150, 3500),
    Geom::Point3d.new(ox+11850, oy+24150, 3500)
  ]
  cplate_18_f = ents.add_face(cplate_18_pts)
  if cplate_18_f
    cplate_18_f.material = mat_steel_plate
    cplate_18_f.layer = layers['conns']
    cplate_18_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 20
begin
  bplate_19_pts = [
    Geom::Point3d.new(ox+17850, oy+23850, -20),
    Geom::Point3d.new(ox+18150, oy+23850, -20),
    Geom::Point3d.new(ox+18150, oy+24150, -20),
    Geom::Point3d.new(ox+17850, oy+24150, -20)
  ]
  bplate_19_f = ents.add_face(bplate_19_pts)
  if bplate_19_f
    bplate_19_f.material = mat_steel_plate
    bplate_19_f.layer = layers['conns']
    bplate_19_f.pushpull(20)
  end
rescue; end
begin
  cplate_19_pts = [
    Geom::Point3d.new(ox+17850, oy+23850, 3500),
    Geom::Point3d.new(ox+18150, oy+23850, 3500),
    Geom::Point3d.new(ox+18150, oy+24150, 3500),
    Geom::Point3d.new(ox+17850, oy+24150, 3500)
  ]
  cplate_19_f = ents.add_face(cplate_19_pts)
  if cplate_19_f
    cplate_19_f.material = mat_steel_plate
    cplate_19_f.layer = layers['conns']
    cplate_19_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 21
begin
  bplate_20_pts = [
    Geom::Point3d.new(ox+-150, oy+29850, -20),
    Geom::Point3d.new(ox+150, oy+29850, -20),
    Geom::Point3d.new(ox+150, oy+30150, -20),
    Geom::Point3d.new(ox+-150, oy+30150, -20)
  ]
  bplate_20_f = ents.add_face(bplate_20_pts)
  if bplate_20_f
    bplate_20_f.material = mat_steel_plate
    bplate_20_f.layer = layers['conns']
    bplate_20_f.pushpull(20)
  end
rescue; end
begin
  cplate_20_pts = [
    Geom::Point3d.new(ox+-150, oy+29850, 3500),
    Geom::Point3d.new(ox+150, oy+29850, 3500),
    Geom::Point3d.new(ox+150, oy+30150, 3500),
    Geom::Point3d.new(ox+-150, oy+30150, 3500)
  ]
  cplate_20_f = ents.add_face(cplate_20_pts)
  if cplate_20_f
    cplate_20_f.material = mat_steel_plate
    cplate_20_f.layer = layers['conns']
    cplate_20_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 22
begin
  bplate_21_pts = [
    Geom::Point3d.new(ox+5850, oy+29850, -20),
    Geom::Point3d.new(ox+6150, oy+29850, -20),
    Geom::Point3d.new(ox+6150, oy+30150, -20),
    Geom::Point3d.new(ox+5850, oy+30150, -20)
  ]
  bplate_21_f = ents.add_face(bplate_21_pts)
  if bplate_21_f
    bplate_21_f.material = mat_steel_plate
    bplate_21_f.layer = layers['conns']
    bplate_21_f.pushpull(20)
  end
rescue; end
begin
  cplate_21_pts = [
    Geom::Point3d.new(ox+5850, oy+29850, 3500),
    Geom::Point3d.new(ox+6150, oy+29850, 3500),
    Geom::Point3d.new(ox+6150, oy+30150, 3500),
    Geom::Point3d.new(ox+5850, oy+30150, 3500)
  ]
  cplate_21_f = ents.add_face(cplate_21_pts)
  if cplate_21_f
    cplate_21_f.material = mat_steel_plate
    cplate_21_f.layer = layers['conns']
    cplate_21_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 23
begin
  bplate_22_pts = [
    Geom::Point3d.new(ox+11850, oy+29850, -20),
    Geom::Point3d.new(ox+12150, oy+29850, -20),
    Geom::Point3d.new(ox+12150, oy+30150, -20),
    Geom::Point3d.new(ox+11850, oy+30150, -20)
  ]
  bplate_22_f = ents.add_face(bplate_22_pts)
  if bplate_22_f
    bplate_22_f.material = mat_steel_plate
    bplate_22_f.layer = layers['conns']
    bplate_22_f.pushpull(20)
  end
rescue; end
begin
  cplate_22_pts = [
    Geom::Point3d.new(ox+11850, oy+29850, 3500),
    Geom::Point3d.new(ox+12150, oy+29850, 3500),
    Geom::Point3d.new(ox+12150, oy+30150, 3500),
    Geom::Point3d.new(ox+11850, oy+30150, 3500)
  ]
  cplate_22_f = ents.add_face(cplate_22_pts)
  if cplate_22_f
    cplate_22_f.material = mat_steel_plate
    cplate_22_f.layer = layers['conns']
    cplate_22_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 24
begin
  bplate_23_pts = [
    Geom::Point3d.new(ox+17850, oy+29850, -20),
    Geom::Point3d.new(ox+18150, oy+29850, -20),
    Geom::Point3d.new(ox+18150, oy+30150, -20),
    Geom::Point3d.new(ox+17850, oy+30150, -20)
  ]
  bplate_23_f = ents.add_face(bplate_23_pts)
  if bplate_23_f
    bplate_23_f.material = mat_steel_plate
    bplate_23_f.layer = layers['conns']
    bplate_23_f.pushpull(20)
  end
rescue; end
begin
  cplate_23_pts = [
    Geom::Point3d.new(ox+17850, oy+29850, 3500),
    Geom::Point3d.new(ox+18150, oy+29850, 3500),
    Geom::Point3d.new(ox+18150, oy+30150, 3500),
    Geom::Point3d.new(ox+17850, oy+30150, 3500)
  ]
  cplate_23_f = ents.add_face(cplate_23_pts)
  if cplate_23_f
    cplate_23_f.material = mat_steel_plate
    cplate_23_f.layer = layers['conns']
    cplate_23_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 25
begin
  bplate_24_pts = [
    Geom::Point3d.new(ox+-150, oy+35850, -20),
    Geom::Point3d.new(ox+150, oy+35850, -20),
    Geom::Point3d.new(ox+150, oy+36150, -20),
    Geom::Point3d.new(ox+-150, oy+36150, -20)
  ]
  bplate_24_f = ents.add_face(bplate_24_pts)
  if bplate_24_f
    bplate_24_f.material = mat_steel_plate
    bplate_24_f.layer = layers['conns']
    bplate_24_f.pushpull(20)
  end
rescue; end
begin
  cplate_24_pts = [
    Geom::Point3d.new(ox+-150, oy+35850, 3500),
    Geom::Point3d.new(ox+150, oy+35850, 3500),
    Geom::Point3d.new(ox+150, oy+36150, 3500),
    Geom::Point3d.new(ox+-150, oy+36150, 3500)
  ]
  cplate_24_f = ents.add_face(cplate_24_pts)
  if cplate_24_f
    cplate_24_f.material = mat_steel_plate
    cplate_24_f.layer = layers['conns']
    cplate_24_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 26
begin
  bplate_25_pts = [
    Geom::Point3d.new(ox+5850, oy+35850, -20),
    Geom::Point3d.new(ox+6150, oy+35850, -20),
    Geom::Point3d.new(ox+6150, oy+36150, -20),
    Geom::Point3d.new(ox+5850, oy+36150, -20)
  ]
  bplate_25_f = ents.add_face(bplate_25_pts)
  if bplate_25_f
    bplate_25_f.material = mat_steel_plate
    bplate_25_f.layer = layers['conns']
    bplate_25_f.pushpull(20)
  end
rescue; end
begin
  cplate_25_pts = [
    Geom::Point3d.new(ox+5850, oy+35850, 3500),
    Geom::Point3d.new(ox+6150, oy+35850, 3500),
    Geom::Point3d.new(ox+6150, oy+36150, 3500),
    Geom::Point3d.new(ox+5850, oy+36150, 3500)
  ]
  cplate_25_f = ents.add_face(cplate_25_pts)
  if cplate_25_f
    cplate_25_f.material = mat_steel_plate
    cplate_25_f.layer = layers['conns']
    cplate_25_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 27
begin
  bplate_26_pts = [
    Geom::Point3d.new(ox+11850, oy+35850, -20),
    Geom::Point3d.new(ox+12150, oy+35850, -20),
    Geom::Point3d.new(ox+12150, oy+36150, -20),
    Geom::Point3d.new(ox+11850, oy+36150, -20)
  ]
  bplate_26_f = ents.add_face(bplate_26_pts)
  if bplate_26_f
    bplate_26_f.material = mat_steel_plate
    bplate_26_f.layer = layers['conns']
    bplate_26_f.pushpull(20)
  end
rescue; end
begin
  cplate_26_pts = [
    Geom::Point3d.new(ox+11850, oy+35850, 3500),
    Geom::Point3d.new(ox+12150, oy+35850, 3500),
    Geom::Point3d.new(ox+12150, oy+36150, 3500),
    Geom::Point3d.new(ox+11850, oy+36150, 3500)
  ]
  cplate_26_f = ents.add_face(cplate_26_pts)
  if cplate_26_f
    cplate_26_f.material = mat_steel_plate
    cplate_26_f.layer = layers['conns']
    cplate_26_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 28
begin
  bplate_27_pts = [
    Geom::Point3d.new(ox+17850, oy+35850, -20),
    Geom::Point3d.new(ox+18150, oy+35850, -20),
    Geom::Point3d.new(ox+18150, oy+36150, -20),
    Geom::Point3d.new(ox+17850, oy+36150, -20)
  ]
  bplate_27_f = ents.add_face(bplate_27_pts)
  if bplate_27_f
    bplate_27_f.material = mat_steel_plate
    bplate_27_f.layer = layers['conns']
    bplate_27_f.pushpull(20)
  end
rescue; end
begin
  cplate_27_pts = [
    Geom::Point3d.new(ox+17850, oy+35850, 3500),
    Geom::Point3d.new(ox+18150, oy+35850, 3500),
    Geom::Point3d.new(ox+18150, oy+36150, 3500),
    Geom::Point3d.new(ox+17850, oy+36150, 3500)
  ]
  cplate_27_f = ents.add_face(cplate_27_pts)
  if cplate_27_f
    cplate_27_f.material = mat_steel_plate
    cplate_27_f.layer = layers['conns']
    cplate_27_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 29
begin
  bplate_28_pts = [
    Geom::Point3d.new(ox+-150, oy+41850, -20),
    Geom::Point3d.new(ox+150, oy+41850, -20),
    Geom::Point3d.new(ox+150, oy+42150, -20),
    Geom::Point3d.new(ox+-150, oy+42150, -20)
  ]
  bplate_28_f = ents.add_face(bplate_28_pts)
  if bplate_28_f
    bplate_28_f.material = mat_steel_plate
    bplate_28_f.layer = layers['conns']
    bplate_28_f.pushpull(20)
  end
rescue; end
begin
  cplate_28_pts = [
    Geom::Point3d.new(ox+-150, oy+41850, 3500),
    Geom::Point3d.new(ox+150, oy+41850, 3500),
    Geom::Point3d.new(ox+150, oy+42150, 3500),
    Geom::Point3d.new(ox+-150, oy+42150, 3500)
  ]
  cplate_28_f = ents.add_face(cplate_28_pts)
  if cplate_28_f
    cplate_28_f.material = mat_steel_plate
    cplate_28_f.layer = layers['conns']
    cplate_28_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 30
begin
  bplate_29_pts = [
    Geom::Point3d.new(ox+5850, oy+41850, -20),
    Geom::Point3d.new(ox+6150, oy+41850, -20),
    Geom::Point3d.new(ox+6150, oy+42150, -20),
    Geom::Point3d.new(ox+5850, oy+42150, -20)
  ]
  bplate_29_f = ents.add_face(bplate_29_pts)
  if bplate_29_f
    bplate_29_f.material = mat_steel_plate
    bplate_29_f.layer = layers['conns']
    bplate_29_f.pushpull(20)
  end
rescue; end
begin
  cplate_29_pts = [
    Geom::Point3d.new(ox+5850, oy+41850, 3500),
    Geom::Point3d.new(ox+6150, oy+41850, 3500),
    Geom::Point3d.new(ox+6150, oy+42150, 3500),
    Geom::Point3d.new(ox+5850, oy+42150, 3500)
  ]
  cplate_29_f = ents.add_face(cplate_29_pts)
  if cplate_29_f
    cplate_29_f.material = mat_steel_plate
    cplate_29_f.layer = layers['conns']
    cplate_29_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 31
begin
  bplate_30_pts = [
    Geom::Point3d.new(ox+11850, oy+41850, -20),
    Geom::Point3d.new(ox+12150, oy+41850, -20),
    Geom::Point3d.new(ox+12150, oy+42150, -20),
    Geom::Point3d.new(ox+11850, oy+42150, -20)
  ]
  bplate_30_f = ents.add_face(bplate_30_pts)
  if bplate_30_f
    bplate_30_f.material = mat_steel_plate
    bplate_30_f.layer = layers['conns']
    bplate_30_f.pushpull(20)
  end
rescue; end
begin
  cplate_30_pts = [
    Geom::Point3d.new(ox+11850, oy+41850, 3500),
    Geom::Point3d.new(ox+12150, oy+41850, 3500),
    Geom::Point3d.new(ox+12150, oy+42150, 3500),
    Geom::Point3d.new(ox+11850, oy+42150, 3500)
  ]
  cplate_30_f = ents.add_face(cplate_30_pts)
  if cplate_30_f
    cplate_30_f.material = mat_steel_plate
    cplate_30_f.layer = layers['conns']
    cplate_30_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 32
begin
  bplate_31_pts = [
    Geom::Point3d.new(ox+17850, oy+41850, -20),
    Geom::Point3d.new(ox+18150, oy+41850, -20),
    Geom::Point3d.new(ox+18150, oy+42150, -20),
    Geom::Point3d.new(ox+17850, oy+42150, -20)
  ]
  bplate_31_f = ents.add_face(bplate_31_pts)
  if bplate_31_f
    bplate_31_f.material = mat_steel_plate
    bplate_31_f.layer = layers['conns']
    bplate_31_f.pushpull(20)
  end
rescue; end
begin
  cplate_31_pts = [
    Geom::Point3d.new(ox+17850, oy+41850, 3500),
    Geom::Point3d.new(ox+18150, oy+41850, 3500),
    Geom::Point3d.new(ox+18150, oy+42150, 3500),
    Geom::Point3d.new(ox+17850, oy+42150, 3500)
  ]
  cplate_31_f = ents.add_face(cplate_31_pts)
  if cplate_31_f
    cplate_31_f.material = mat_steel_plate
    cplate_31_f.layer = layers['conns']
    cplate_31_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 33
begin
  bplate_32_pts = [
    Geom::Point3d.new(ox+-150, oy+47850, -20),
    Geom::Point3d.new(ox+150, oy+47850, -20),
    Geom::Point3d.new(ox+150, oy+48150, -20),
    Geom::Point3d.new(ox+-150, oy+48150, -20)
  ]
  bplate_32_f = ents.add_face(bplate_32_pts)
  if bplate_32_f
    bplate_32_f.material = mat_steel_plate
    bplate_32_f.layer = layers['conns']
    bplate_32_f.pushpull(20)
  end
rescue; end
begin
  cplate_32_pts = [
    Geom::Point3d.new(ox+-150, oy+47850, 3500),
    Geom::Point3d.new(ox+150, oy+47850, 3500),
    Geom::Point3d.new(ox+150, oy+48150, 3500),
    Geom::Point3d.new(ox+-150, oy+48150, 3500)
  ]
  cplate_32_f = ents.add_face(cplate_32_pts)
  if cplate_32_f
    cplate_32_f.material = mat_steel_plate
    cplate_32_f.layer = layers['conns']
    cplate_32_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 34
begin
  bplate_33_pts = [
    Geom::Point3d.new(ox+5850, oy+47850, -20),
    Geom::Point3d.new(ox+6150, oy+47850, -20),
    Geom::Point3d.new(ox+6150, oy+48150, -20),
    Geom::Point3d.new(ox+5850, oy+48150, -20)
  ]
  bplate_33_f = ents.add_face(bplate_33_pts)
  if bplate_33_f
    bplate_33_f.material = mat_steel_plate
    bplate_33_f.layer = layers['conns']
    bplate_33_f.pushpull(20)
  end
rescue; end
begin
  cplate_33_pts = [
    Geom::Point3d.new(ox+5850, oy+47850, 3500),
    Geom::Point3d.new(ox+6150, oy+47850, 3500),
    Geom::Point3d.new(ox+6150, oy+48150, 3500),
    Geom::Point3d.new(ox+5850, oy+48150, 3500)
  ]
  cplate_33_f = ents.add_face(cplate_33_pts)
  if cplate_33_f
    cplate_33_f.material = mat_steel_plate
    cplate_33_f.layer = layers['conns']
    cplate_33_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 35
begin
  bplate_34_pts = [
    Geom::Point3d.new(ox+11850, oy+47850, -20),
    Geom::Point3d.new(ox+12150, oy+47850, -20),
    Geom::Point3d.new(ox+12150, oy+48150, -20),
    Geom::Point3d.new(ox+11850, oy+48150, -20)
  ]
  bplate_34_f = ents.add_face(bplate_34_pts)
  if bplate_34_f
    bplate_34_f.material = mat_steel_plate
    bplate_34_f.layer = layers['conns']
    bplate_34_f.pushpull(20)
  end
rescue; end
begin
  cplate_34_pts = [
    Geom::Point3d.new(ox+11850, oy+47850, 3500),
    Geom::Point3d.new(ox+12150, oy+47850, 3500),
    Geom::Point3d.new(ox+12150, oy+48150, 3500),
    Geom::Point3d.new(ox+11850, oy+48150, 3500)
  ]
  cplate_34_f = ents.add_face(cplate_34_pts)
  if cplate_34_f
    cplate_34_f.material = mat_steel_plate
    cplate_34_f.layer = layers['conns']
    cplate_34_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 36
begin
  bplate_35_pts = [
    Geom::Point3d.new(ox+17850, oy+47850, -20),
    Geom::Point3d.new(ox+18150, oy+47850, -20),
    Geom::Point3d.new(ox+18150, oy+48150, -20),
    Geom::Point3d.new(ox+17850, oy+48150, -20)
  ]
  bplate_35_f = ents.add_face(bplate_35_pts)
  if bplate_35_f
    bplate_35_f.material = mat_steel_plate
    bplate_35_f.layer = layers['conns']
    bplate_35_f.pushpull(20)
  end
rescue; end
begin
  cplate_35_pts = [
    Geom::Point3d.new(ox+17850, oy+47850, 3500),
    Geom::Point3d.new(ox+18150, oy+47850, 3500),
    Geom::Point3d.new(ox+18150, oy+48150, 3500),
    Geom::Point3d.new(ox+17850, oy+48150, 3500)
  ]
  cplate_35_f = ents.add_face(cplate_35_pts)
  if cplate_35_f
    cplate_35_f.material = mat_steel_plate
    cplate_35_f.layer = layers['conns']
    cplate_35_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 37
begin
  bplate_36_pts = [
    Geom::Point3d.new(ox+-150, oy+53850, -20),
    Geom::Point3d.new(ox+150, oy+53850, -20),
    Geom::Point3d.new(ox+150, oy+54150, -20),
    Geom::Point3d.new(ox+-150, oy+54150, -20)
  ]
  bplate_36_f = ents.add_face(bplate_36_pts)
  if bplate_36_f
    bplate_36_f.material = mat_steel_plate
    bplate_36_f.layer = layers['conns']
    bplate_36_f.pushpull(20)
  end
rescue; end
begin
  cplate_36_pts = [
    Geom::Point3d.new(ox+-150, oy+53850, 3500),
    Geom::Point3d.new(ox+150, oy+53850, 3500),
    Geom::Point3d.new(ox+150, oy+54150, 3500),
    Geom::Point3d.new(ox+-150, oy+54150, 3500)
  ]
  cplate_36_f = ents.add_face(cplate_36_pts)
  if cplate_36_f
    cplate_36_f.material = mat_steel_plate
    cplate_36_f.layer = layers['conns']
    cplate_36_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 38
begin
  bplate_37_pts = [
    Geom::Point3d.new(ox+5850, oy+53850, -20),
    Geom::Point3d.new(ox+6150, oy+53850, -20),
    Geom::Point3d.new(ox+6150, oy+54150, -20),
    Geom::Point3d.new(ox+5850, oy+54150, -20)
  ]
  bplate_37_f = ents.add_face(bplate_37_pts)
  if bplate_37_f
    bplate_37_f.material = mat_steel_plate
    bplate_37_f.layer = layers['conns']
    bplate_37_f.pushpull(20)
  end
rescue; end
begin
  cplate_37_pts = [
    Geom::Point3d.new(ox+5850, oy+53850, 3500),
    Geom::Point3d.new(ox+6150, oy+53850, 3500),
    Geom::Point3d.new(ox+6150, oy+54150, 3500),
    Geom::Point3d.new(ox+5850, oy+54150, 3500)
  ]
  cplate_37_f = ents.add_face(cplate_37_pts)
  if cplate_37_f
    cplate_37_f.material = mat_steel_plate
    cplate_37_f.layer = layers['conns']
    cplate_37_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 39
begin
  bplate_38_pts = [
    Geom::Point3d.new(ox+11850, oy+53850, -20),
    Geom::Point3d.new(ox+12150, oy+53850, -20),
    Geom::Point3d.new(ox+12150, oy+54150, -20),
    Geom::Point3d.new(ox+11850, oy+54150, -20)
  ]
  bplate_38_f = ents.add_face(bplate_38_pts)
  if bplate_38_f
    bplate_38_f.material = mat_steel_plate
    bplate_38_f.layer = layers['conns']
    bplate_38_f.pushpull(20)
  end
rescue; end
begin
  cplate_38_pts = [
    Geom::Point3d.new(ox+11850, oy+53850, 3500),
    Geom::Point3d.new(ox+12150, oy+53850, 3500),
    Geom::Point3d.new(ox+12150, oy+54150, 3500),
    Geom::Point3d.new(ox+11850, oy+54150, 3500)
  ]
  cplate_38_f = ents.add_face(cplate_38_pts)
  if cplate_38_f
    cplate_38_f.material = mat_steel_plate
    cplate_38_f.layer = layers['conns']
    cplate_38_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 40
begin
  bplate_39_pts = [
    Geom::Point3d.new(ox+17850, oy+53850, -20),
    Geom::Point3d.new(ox+18150, oy+53850, -20),
    Geom::Point3d.new(ox+18150, oy+54150, -20),
    Geom::Point3d.new(ox+17850, oy+54150, -20)
  ]
  bplate_39_f = ents.add_face(bplate_39_pts)
  if bplate_39_f
    bplate_39_f.material = mat_steel_plate
    bplate_39_f.layer = layers['conns']
    bplate_39_f.pushpull(20)
  end
rescue; end
begin
  cplate_39_pts = [
    Geom::Point3d.new(ox+17850, oy+53850, 3500),
    Geom::Point3d.new(ox+18150, oy+53850, 3500),
    Geom::Point3d.new(ox+18150, oy+54150, 3500),
    Geom::Point3d.new(ox+17850, oy+54150, 3500)
  ]
  cplate_39_f = ents.add_face(cplate_39_pts)
  if cplate_39_f
    cplate_39_f.material = mat_steel_plate
    cplate_39_f.layer = layers['conns']
    cplate_39_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 41
begin
  bplate_40_pts = [
    Geom::Point3d.new(ox+-150, oy+59850, -20),
    Geom::Point3d.new(ox+150, oy+59850, -20),
    Geom::Point3d.new(ox+150, oy+60150, -20),
    Geom::Point3d.new(ox+-150, oy+60150, -20)
  ]
  bplate_40_f = ents.add_face(bplate_40_pts)
  if bplate_40_f
    bplate_40_f.material = mat_steel_plate
    bplate_40_f.layer = layers['conns']
    bplate_40_f.pushpull(20)
  end
rescue; end
begin
  cplate_40_pts = [
    Geom::Point3d.new(ox+-150, oy+59850, 3500),
    Geom::Point3d.new(ox+150, oy+59850, 3500),
    Geom::Point3d.new(ox+150, oy+60150, 3500),
    Geom::Point3d.new(ox+-150, oy+60150, 3500)
  ]
  cplate_40_f = ents.add_face(cplate_40_pts)
  if cplate_40_f
    cplate_40_f.material = mat_steel_plate
    cplate_40_f.layer = layers['conns']
    cplate_40_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 42
begin
  bplate_41_pts = [
    Geom::Point3d.new(ox+5850, oy+59850, -20),
    Geom::Point3d.new(ox+6150, oy+59850, -20),
    Geom::Point3d.new(ox+6150, oy+60150, -20),
    Geom::Point3d.new(ox+5850, oy+60150, -20)
  ]
  bplate_41_f = ents.add_face(bplate_41_pts)
  if bplate_41_f
    bplate_41_f.material = mat_steel_plate
    bplate_41_f.layer = layers['conns']
    bplate_41_f.pushpull(20)
  end
rescue; end
begin
  cplate_41_pts = [
    Geom::Point3d.new(ox+5850, oy+59850, 3500),
    Geom::Point3d.new(ox+6150, oy+59850, 3500),
    Geom::Point3d.new(ox+6150, oy+60150, 3500),
    Geom::Point3d.new(ox+5850, oy+60150, 3500)
  ]
  cplate_41_f = ents.add_face(cplate_41_pts)
  if cplate_41_f
    cplate_41_f.material = mat_steel_plate
    cplate_41_f.layer = layers['conns']
    cplate_41_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 43
begin
  bplate_42_pts = [
    Geom::Point3d.new(ox+11850, oy+59850, -20),
    Geom::Point3d.new(ox+12150, oy+59850, -20),
    Geom::Point3d.new(ox+12150, oy+60150, -20),
    Geom::Point3d.new(ox+11850, oy+60150, -20)
  ]
  bplate_42_f = ents.add_face(bplate_42_pts)
  if bplate_42_f
    bplate_42_f.material = mat_steel_plate
    bplate_42_f.layer = layers['conns']
    bplate_42_f.pushpull(20)
  end
rescue; end
begin
  cplate_42_pts = [
    Geom::Point3d.new(ox+11850, oy+59850, 3500),
    Geom::Point3d.new(ox+12150, oy+59850, 3500),
    Geom::Point3d.new(ox+12150, oy+60150, 3500),
    Geom::Point3d.new(ox+11850, oy+60150, 3500)
  ]
  cplate_42_f = ents.add_face(cplate_42_pts)
  if cplate_42_f
    cplate_42_f.material = mat_steel_plate
    cplate_42_f.layer = layers['conns']
    cplate_42_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 44
begin
  bplate_43_pts = [
    Geom::Point3d.new(ox+17850, oy+59850, -20),
    Geom::Point3d.new(ox+18150, oy+59850, -20),
    Geom::Point3d.new(ox+18150, oy+60150, -20),
    Geom::Point3d.new(ox+17850, oy+60150, -20)
  ]
  bplate_43_f = ents.add_face(bplate_43_pts)
  if bplate_43_f
    bplate_43_f.material = mat_steel_plate
    bplate_43_f.layer = layers['conns']
    bplate_43_f.pushpull(20)
  end
rescue; end
begin
  cplate_43_pts = [
    Geom::Point3d.new(ox+17850, oy+59850, 3500),
    Geom::Point3d.new(ox+18150, oy+59850, 3500),
    Geom::Point3d.new(ox+18150, oy+60150, 3500),
    Geom::Point3d.new(ox+17850, oy+60150, 3500)
  ]
  cplate_43_f = ents.add_face(cplate_43_pts)
  if cplate_43_f
    cplate_43_f.material = mat_steel_plate
    cplate_43_f.layer = layers['conns']
    cplate_43_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 45
begin
  bplate_44_pts = [
    Geom::Point3d.new(ox+-150, oy+65850, -20),
    Geom::Point3d.new(ox+150, oy+65850, -20),
    Geom::Point3d.new(ox+150, oy+66150, -20),
    Geom::Point3d.new(ox+-150, oy+66150, -20)
  ]
  bplate_44_f = ents.add_face(bplate_44_pts)
  if bplate_44_f
    bplate_44_f.material = mat_steel_plate
    bplate_44_f.layer = layers['conns']
    bplate_44_f.pushpull(20)
  end
rescue; end
begin
  cplate_44_pts = [
    Geom::Point3d.new(ox+-150, oy+65850, 3500),
    Geom::Point3d.new(ox+150, oy+65850, 3500),
    Geom::Point3d.new(ox+150, oy+66150, 3500),
    Geom::Point3d.new(ox+-150, oy+66150, 3500)
  ]
  cplate_44_f = ents.add_face(cplate_44_pts)
  if cplate_44_f
    cplate_44_f.material = mat_steel_plate
    cplate_44_f.layer = layers['conns']
    cplate_44_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 46
begin
  bplate_45_pts = [
    Geom::Point3d.new(ox+5850, oy+65850, -20),
    Geom::Point3d.new(ox+6150, oy+65850, -20),
    Geom::Point3d.new(ox+6150, oy+66150, -20),
    Geom::Point3d.new(ox+5850, oy+66150, -20)
  ]
  bplate_45_f = ents.add_face(bplate_45_pts)
  if bplate_45_f
    bplate_45_f.material = mat_steel_plate
    bplate_45_f.layer = layers['conns']
    bplate_45_f.pushpull(20)
  end
rescue; end
begin
  cplate_45_pts = [
    Geom::Point3d.new(ox+5850, oy+65850, 3500),
    Geom::Point3d.new(ox+6150, oy+65850, 3500),
    Geom::Point3d.new(ox+6150, oy+66150, 3500),
    Geom::Point3d.new(ox+5850, oy+66150, 3500)
  ]
  cplate_45_f = ents.add_face(cplate_45_pts)
  if cplate_45_f
    cplate_45_f.material = mat_steel_plate
    cplate_45_f.layer = layers['conns']
    cplate_45_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 47
begin
  bplate_46_pts = [
    Geom::Point3d.new(ox+11850, oy+65850, -20),
    Geom::Point3d.new(ox+12150, oy+65850, -20),
    Geom::Point3d.new(ox+12150, oy+66150, -20),
    Geom::Point3d.new(ox+11850, oy+66150, -20)
  ]
  bplate_46_f = ents.add_face(bplate_46_pts)
  if bplate_46_f
    bplate_46_f.material = mat_steel_plate
    bplate_46_f.layer = layers['conns']
    bplate_46_f.pushpull(20)
  end
rescue; end
begin
  cplate_46_pts = [
    Geom::Point3d.new(ox+11850, oy+65850, 3500),
    Geom::Point3d.new(ox+12150, oy+65850, 3500),
    Geom::Point3d.new(ox+12150, oy+66150, 3500),
    Geom::Point3d.new(ox+11850, oy+66150, 3500)
  ]
  cplate_46_f = ents.add_face(cplate_46_pts)
  if cplate_46_f
    cplate_46_f.material = mat_steel_plate
    cplate_46_f.layer = layers['conns']
    cplate_46_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 48
begin
  bplate_47_pts = [
    Geom::Point3d.new(ox+17850, oy+65850, -20),
    Geom::Point3d.new(ox+18150, oy+65850, -20),
    Geom::Point3d.new(ox+18150, oy+66150, -20),
    Geom::Point3d.new(ox+17850, oy+66150, -20)
  ]
  bplate_47_f = ents.add_face(bplate_47_pts)
  if bplate_47_f
    bplate_47_f.material = mat_steel_plate
    bplate_47_f.layer = layers['conns']
    bplate_47_f.pushpull(20)
  end
rescue; end
begin
  cplate_47_pts = [
    Geom::Point3d.new(ox+17850, oy+65850, 3500),
    Geom::Point3d.new(ox+18150, oy+65850, 3500),
    Geom::Point3d.new(ox+18150, oy+66150, 3500),
    Geom::Point3d.new(ox+17850, oy+66150, 3500)
  ]
  cplate_47_f = ents.add_face(cplate_47_pts)
  if cplate_47_f
    cplate_47_f.material = mat_steel_plate
    cplate_47_f.layer = layers['conns']
    cplate_47_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 49
begin
  bplate_48_pts = [
    Geom::Point3d.new(ox+-150, oy+71850, -20),
    Geom::Point3d.new(ox+150, oy+71850, -20),
    Geom::Point3d.new(ox+150, oy+72150, -20),
    Geom::Point3d.new(ox+-150, oy+72150, -20)
  ]
  bplate_48_f = ents.add_face(bplate_48_pts)
  if bplate_48_f
    bplate_48_f.material = mat_steel_plate
    bplate_48_f.layer = layers['conns']
    bplate_48_f.pushpull(20)
  end
rescue; end
begin
  cplate_48_pts = [
    Geom::Point3d.new(ox+-150, oy+71850, 3500),
    Geom::Point3d.new(ox+150, oy+71850, 3500),
    Geom::Point3d.new(ox+150, oy+72150, 3500),
    Geom::Point3d.new(ox+-150, oy+72150, 3500)
  ]
  cplate_48_f = ents.add_face(cplate_48_pts)
  if cplate_48_f
    cplate_48_f.material = mat_steel_plate
    cplate_48_f.layer = layers['conns']
    cplate_48_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 50
begin
  bplate_49_pts = [
    Geom::Point3d.new(ox+5850, oy+71850, -20),
    Geom::Point3d.new(ox+6150, oy+71850, -20),
    Geom::Point3d.new(ox+6150, oy+72150, -20),
    Geom::Point3d.new(ox+5850, oy+72150, -20)
  ]
  bplate_49_f = ents.add_face(bplate_49_pts)
  if bplate_49_f
    bplate_49_f.material = mat_steel_plate
    bplate_49_f.layer = layers['conns']
    bplate_49_f.pushpull(20)
  end
rescue; end
begin
  cplate_49_pts = [
    Geom::Point3d.new(ox+5850, oy+71850, 3500),
    Geom::Point3d.new(ox+6150, oy+71850, 3500),
    Geom::Point3d.new(ox+6150, oy+72150, 3500),
    Geom::Point3d.new(ox+5850, oy+72150, 3500)
  ]
  cplate_49_f = ents.add_face(cplate_49_pts)
  if cplate_49_f
    cplate_49_f.material = mat_steel_plate
    cplate_49_f.layer = layers['conns']
    cplate_49_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 51
begin
  bplate_50_pts = [
    Geom::Point3d.new(ox+11850, oy+71850, -20),
    Geom::Point3d.new(ox+12150, oy+71850, -20),
    Geom::Point3d.new(ox+12150, oy+72150, -20),
    Geom::Point3d.new(ox+11850, oy+72150, -20)
  ]
  bplate_50_f = ents.add_face(bplate_50_pts)
  if bplate_50_f
    bplate_50_f.material = mat_steel_plate
    bplate_50_f.layer = layers['conns']
    bplate_50_f.pushpull(20)
  end
rescue; end
begin
  cplate_50_pts = [
    Geom::Point3d.new(ox+11850, oy+71850, 3500),
    Geom::Point3d.new(ox+12150, oy+71850, 3500),
    Geom::Point3d.new(ox+12150, oy+72150, 3500),
    Geom::Point3d.new(ox+11850, oy+72150, 3500)
  ]
  cplate_50_f = ents.add_face(cplate_50_pts)
  if cplate_50_f
    cplate_50_f.material = mat_steel_plate
    cplate_50_f.layer = layers['conns']
    cplate_50_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 52
begin
  bplate_51_pts = [
    Geom::Point3d.new(ox+17850, oy+71850, -20),
    Geom::Point3d.new(ox+18150, oy+71850, -20),
    Geom::Point3d.new(ox+18150, oy+72150, -20),
    Geom::Point3d.new(ox+17850, oy+72150, -20)
  ]
  bplate_51_f = ents.add_face(bplate_51_pts)
  if bplate_51_f
    bplate_51_f.material = mat_steel_plate
    bplate_51_f.layer = layers['conns']
    bplate_51_f.pushpull(20)
  end
rescue; end
begin
  cplate_51_pts = [
    Geom::Point3d.new(ox+17850, oy+71850, 3500),
    Geom::Point3d.new(ox+18150, oy+71850, 3500),
    Geom::Point3d.new(ox+18150, oy+72150, 3500),
    Geom::Point3d.new(ox+17850, oy+72150, 3500)
  ]
  cplate_51_f = ents.add_face(cplate_51_pts)
  if cplate_51_f
    cplate_51_f.material = mat_steel_plate
    cplate_51_f.layer = layers['conns']
    cplate_51_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 53
begin
  bplate_52_pts = [
    Geom::Point3d.new(ox+-150, oy+77850, -20),
    Geom::Point3d.new(ox+150, oy+77850, -20),
    Geom::Point3d.new(ox+150, oy+78150, -20),
    Geom::Point3d.new(ox+-150, oy+78150, -20)
  ]
  bplate_52_f = ents.add_face(bplate_52_pts)
  if bplate_52_f
    bplate_52_f.material = mat_steel_plate
    bplate_52_f.layer = layers['conns']
    bplate_52_f.pushpull(20)
  end
rescue; end
begin
  cplate_52_pts = [
    Geom::Point3d.new(ox+-150, oy+77850, 3500),
    Geom::Point3d.new(ox+150, oy+77850, 3500),
    Geom::Point3d.new(ox+150, oy+78150, 3500),
    Geom::Point3d.new(ox+-150, oy+78150, 3500)
  ]
  cplate_52_f = ents.add_face(cplate_52_pts)
  if cplate_52_f
    cplate_52_f.material = mat_steel_plate
    cplate_52_f.layer = layers['conns']
    cplate_52_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 54
begin
  bplate_53_pts = [
    Geom::Point3d.new(ox+5850, oy+77850, -20),
    Geom::Point3d.new(ox+6150, oy+77850, -20),
    Geom::Point3d.new(ox+6150, oy+78150, -20),
    Geom::Point3d.new(ox+5850, oy+78150, -20)
  ]
  bplate_53_f = ents.add_face(bplate_53_pts)
  if bplate_53_f
    bplate_53_f.material = mat_steel_plate
    bplate_53_f.layer = layers['conns']
    bplate_53_f.pushpull(20)
  end
rescue; end
begin
  cplate_53_pts = [
    Geom::Point3d.new(ox+5850, oy+77850, 3500),
    Geom::Point3d.new(ox+6150, oy+77850, 3500),
    Geom::Point3d.new(ox+6150, oy+78150, 3500),
    Geom::Point3d.new(ox+5850, oy+78150, 3500)
  ]
  cplate_53_f = ents.add_face(cplate_53_pts)
  if cplate_53_f
    cplate_53_f.material = mat_steel_plate
    cplate_53_f.layer = layers['conns']
    cplate_53_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 55
begin
  bplate_54_pts = [
    Geom::Point3d.new(ox+11850, oy+77850, -20),
    Geom::Point3d.new(ox+12150, oy+77850, -20),
    Geom::Point3d.new(ox+12150, oy+78150, -20),
    Geom::Point3d.new(ox+11850, oy+78150, -20)
  ]
  bplate_54_f = ents.add_face(bplate_54_pts)
  if bplate_54_f
    bplate_54_f.material = mat_steel_plate
    bplate_54_f.layer = layers['conns']
    bplate_54_f.pushpull(20)
  end
rescue; end
begin
  cplate_54_pts = [
    Geom::Point3d.new(ox+11850, oy+77850, 3500),
    Geom::Point3d.new(ox+12150, oy+77850, 3500),
    Geom::Point3d.new(ox+12150, oy+78150, 3500),
    Geom::Point3d.new(ox+11850, oy+78150, 3500)
  ]
  cplate_54_f = ents.add_face(cplate_54_pts)
  if cplate_54_f
    cplate_54_f.material = mat_steel_plate
    cplate_54_f.layer = layers['conns']
    cplate_54_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 56
begin
  bplate_55_pts = [
    Geom::Point3d.new(ox+17850, oy+77850, -20),
    Geom::Point3d.new(ox+18150, oy+77850, -20),
    Geom::Point3d.new(ox+18150, oy+78150, -20),
    Geom::Point3d.new(ox+17850, oy+78150, -20)
  ]
  bplate_55_f = ents.add_face(bplate_55_pts)
  if bplate_55_f
    bplate_55_f.material = mat_steel_plate
    bplate_55_f.layer = layers['conns']
    bplate_55_f.pushpull(20)
  end
rescue; end
begin
  cplate_55_pts = [
    Geom::Point3d.new(ox+17850, oy+77850, 3500),
    Geom::Point3d.new(ox+18150, oy+77850, 3500),
    Geom::Point3d.new(ox+18150, oy+78150, 3500),
    Geom::Point3d.new(ox+17850, oy+78150, 3500)
  ]
  cplate_55_f = ents.add_face(cplate_55_pts)
  if cplate_55_f
    cplate_55_f.material = mat_steel_plate
    cplate_55_f.layer = layers['conns']
    cplate_55_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 57
begin
  bplate_56_pts = [
    Geom::Point3d.new(ox+-150, oy+83850, -20),
    Geom::Point3d.new(ox+150, oy+83850, -20),
    Geom::Point3d.new(ox+150, oy+84150, -20),
    Geom::Point3d.new(ox+-150, oy+84150, -20)
  ]
  bplate_56_f = ents.add_face(bplate_56_pts)
  if bplate_56_f
    bplate_56_f.material = mat_steel_plate
    bplate_56_f.layer = layers['conns']
    bplate_56_f.pushpull(20)
  end
rescue; end
begin
  cplate_56_pts = [
    Geom::Point3d.new(ox+-150, oy+83850, 3500),
    Geom::Point3d.new(ox+150, oy+83850, 3500),
    Geom::Point3d.new(ox+150, oy+84150, 3500),
    Geom::Point3d.new(ox+-150, oy+84150, 3500)
  ]
  cplate_56_f = ents.add_face(cplate_56_pts)
  if cplate_56_f
    cplate_56_f.material = mat_steel_plate
    cplate_56_f.layer = layers['conns']
    cplate_56_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 58
begin
  bplate_57_pts = [
    Geom::Point3d.new(ox+5850, oy+83850, -20),
    Geom::Point3d.new(ox+6150, oy+83850, -20),
    Geom::Point3d.new(ox+6150, oy+84150, -20),
    Geom::Point3d.new(ox+5850, oy+84150, -20)
  ]
  bplate_57_f = ents.add_face(bplate_57_pts)
  if bplate_57_f
    bplate_57_f.material = mat_steel_plate
    bplate_57_f.layer = layers['conns']
    bplate_57_f.pushpull(20)
  end
rescue; end
begin
  cplate_57_pts = [
    Geom::Point3d.new(ox+5850, oy+83850, 3500),
    Geom::Point3d.new(ox+6150, oy+83850, 3500),
    Geom::Point3d.new(ox+6150, oy+84150, 3500),
    Geom::Point3d.new(ox+5850, oy+84150, 3500)
  ]
  cplate_57_f = ents.add_face(cplate_57_pts)
  if cplate_57_f
    cplate_57_f.material = mat_steel_plate
    cplate_57_f.layer = layers['conns']
    cplate_57_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 59
begin
  bplate_58_pts = [
    Geom::Point3d.new(ox+11850, oy+83850, -20),
    Geom::Point3d.new(ox+12150, oy+83850, -20),
    Geom::Point3d.new(ox+12150, oy+84150, -20),
    Geom::Point3d.new(ox+11850, oy+84150, -20)
  ]
  bplate_58_f = ents.add_face(bplate_58_pts)
  if bplate_58_f
    bplate_58_f.material = mat_steel_plate
    bplate_58_f.layer = layers['conns']
    bplate_58_f.pushpull(20)
  end
rescue; end
begin
  cplate_58_pts = [
    Geom::Point3d.new(ox+11850, oy+83850, 3500),
    Geom::Point3d.new(ox+12150, oy+83850, 3500),
    Geom::Point3d.new(ox+12150, oy+84150, 3500),
    Geom::Point3d.new(ox+11850, oy+84150, 3500)
  ]
  cplate_58_f = ents.add_face(cplate_58_pts)
  if cplate_58_f
    cplate_58_f.material = mat_steel_plate
    cplate_58_f.layer = layers['conns']
    cplate_58_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 60
begin
  bplate_59_pts = [
    Geom::Point3d.new(ox+17850, oy+83850, -20),
    Geom::Point3d.new(ox+18150, oy+83850, -20),
    Geom::Point3d.new(ox+18150, oy+84150, -20),
    Geom::Point3d.new(ox+17850, oy+84150, -20)
  ]
  bplate_59_f = ents.add_face(bplate_59_pts)
  if bplate_59_f
    bplate_59_f.material = mat_steel_plate
    bplate_59_f.layer = layers['conns']
    bplate_59_f.pushpull(20)
  end
rescue; end
begin
  cplate_59_pts = [
    Geom::Point3d.new(ox+17850, oy+83850, 3500),
    Geom::Point3d.new(ox+18150, oy+83850, 3500),
    Geom::Point3d.new(ox+18150, oy+84150, 3500),
    Geom::Point3d.new(ox+17850, oy+84150, 3500)
  ]
  cplate_59_f = ents.add_face(cplate_59_pts)
  if cplate_59_f
    cplate_59_f.material = mat_steel_plate
    cplate_59_f.layer = layers['conns']
    cplate_59_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 61
begin
  bplate_60_pts = [
    Geom::Point3d.new(ox+23850, oy+89850, -20),
    Geom::Point3d.new(ox+24150, oy+89850, -20),
    Geom::Point3d.new(ox+24150, oy+90150, -20),
    Geom::Point3d.new(ox+23850, oy+90150, -20)
  ]
  bplate_60_f = ents.add_face(bplate_60_pts)
  if bplate_60_f
    bplate_60_f.material = mat_steel_plate
    bplate_60_f.layer = layers['conns']
    bplate_60_f.pushpull(20)
  end
rescue; end
begin
  cplate_60_pts = [
    Geom::Point3d.new(ox+23850, oy+89850, 3500),
    Geom::Point3d.new(ox+24150, oy+89850, 3500),
    Geom::Point3d.new(ox+24150, oy+90150, 3500),
    Geom::Point3d.new(ox+23850, oy+90150, 3500)
  ]
  cplate_60_f = ents.add_face(cplate_60_pts)
  if cplate_60_f
    cplate_60_f.material = mat_steel_plate
    cplate_60_f.layer = layers['conns']
    cplate_60_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 62
begin
  bplate_61_pts = [
    Geom::Point3d.new(ox+23850, oy+89850, -20),
    Geom::Point3d.new(ox+24150, oy+89850, -20),
    Geom::Point3d.new(ox+24150, oy+90150, -20),
    Geom::Point3d.new(ox+23850, oy+90150, -20)
  ]
  bplate_61_f = ents.add_face(bplate_61_pts)
  if bplate_61_f
    bplate_61_f.material = mat_steel_plate
    bplate_61_f.layer = layers['conns']
    bplate_61_f.pushpull(20)
  end
rescue; end
begin
  cplate_61_pts = [
    Geom::Point3d.new(ox+23850, oy+89850, 3500),
    Geom::Point3d.new(ox+24150, oy+89850, 3500),
    Geom::Point3d.new(ox+24150, oy+90150, 3500),
    Geom::Point3d.new(ox+23850, oy+90150, 3500)
  ]
  cplate_61_f = ents.add_face(cplate_61_pts)
  if cplate_61_f
    cplate_61_f.material = mat_steel_plate
    cplate_61_f.layer = layers['conns']
    cplate_61_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 63
begin
  bplate_62_pts = [
    Geom::Point3d.new(ox+23850, oy+89850, -20),
    Geom::Point3d.new(ox+24150, oy+89850, -20),
    Geom::Point3d.new(ox+24150, oy+90150, -20),
    Geom::Point3d.new(ox+23850, oy+90150, -20)
  ]
  bplate_62_f = ents.add_face(bplate_62_pts)
  if bplate_62_f
    bplate_62_f.material = mat_steel_plate
    bplate_62_f.layer = layers['conns']
    bplate_62_f.pushpull(20)
  end
rescue; end
begin
  cplate_62_pts = [
    Geom::Point3d.new(ox+23850, oy+89850, 3500),
    Geom::Point3d.new(ox+24150, oy+89850, 3500),
    Geom::Point3d.new(ox+24150, oy+90150, 3500),
    Geom::Point3d.new(ox+23850, oy+90150, 3500)
  ]
  cplate_62_f = ents.add_face(cplate_62_pts)
  if cplate_62_f
    cplate_62_f.material = mat_steel_plate
    cplate_62_f.layer = layers['conns']
    cplate_62_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 64
begin
  bplate_63_pts = [
    Geom::Point3d.new(ox+23850, oy+89850, -20),
    Geom::Point3d.new(ox+24150, oy+89850, -20),
    Geom::Point3d.new(ox+24150, oy+90150, -20),
    Geom::Point3d.new(ox+23850, oy+90150, -20)
  ]
  bplate_63_f = ents.add_face(bplate_63_pts)
  if bplate_63_f
    bplate_63_f.material = mat_steel_plate
    bplate_63_f.layer = layers['conns']
    bplate_63_f.pushpull(20)
  end
rescue; end
begin
  cplate_63_pts = [
    Geom::Point3d.new(ox+23850, oy+89850, 3500),
    Geom::Point3d.new(ox+24150, oy+89850, 3500),
    Geom::Point3d.new(ox+24150, oy+90150, 3500),
    Geom::Point3d.new(ox+23850, oy+90150, 3500)
  ]
  cplate_63_f = ents.add_face(cplate_63_pts)
  if cplate_63_f
    cplate_63_f.material = mat_steel_plate
    cplate_63_f.layer = layers['conns']
    cplate_63_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 65
begin
  bplate_64_pts = [
    Geom::Point3d.new(ox+23850, oy+95850, -20),
    Geom::Point3d.new(ox+24150, oy+95850, -20),
    Geom::Point3d.new(ox+24150, oy+96150, -20),
    Geom::Point3d.new(ox+23850, oy+96150, -20)
  ]
  bplate_64_f = ents.add_face(bplate_64_pts)
  if bplate_64_f
    bplate_64_f.material = mat_steel_plate
    bplate_64_f.layer = layers['conns']
    bplate_64_f.pushpull(20)
  end
rescue; end
begin
  cplate_64_pts = [
    Geom::Point3d.new(ox+23850, oy+95850, 3500),
    Geom::Point3d.new(ox+24150, oy+95850, 3500),
    Geom::Point3d.new(ox+24150, oy+96150, 3500),
    Geom::Point3d.new(ox+23850, oy+96150, 3500)
  ]
  cplate_64_f = ents.add_face(cplate_64_pts)
  if cplate_64_f
    cplate_64_f.material = mat_steel_plate
    cplate_64_f.layer = layers['conns']
    cplate_64_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 66
begin
  bplate_65_pts = [
    Geom::Point3d.new(ox+23850, oy+95850, -20),
    Geom::Point3d.new(ox+24150, oy+95850, -20),
    Geom::Point3d.new(ox+24150, oy+96150, -20),
    Geom::Point3d.new(ox+23850, oy+96150, -20)
  ]
  bplate_65_f = ents.add_face(bplate_65_pts)
  if bplate_65_f
    bplate_65_f.material = mat_steel_plate
    bplate_65_f.layer = layers['conns']
    bplate_65_f.pushpull(20)
  end
rescue; end
begin
  cplate_65_pts = [
    Geom::Point3d.new(ox+23850, oy+95850, 3500),
    Geom::Point3d.new(ox+24150, oy+95850, 3500),
    Geom::Point3d.new(ox+24150, oy+96150, 3500),
    Geom::Point3d.new(ox+23850, oy+96150, 3500)
  ]
  cplate_65_f = ents.add_face(cplate_65_pts)
  if cplate_65_f
    cplate_65_f.material = mat_steel_plate
    cplate_65_f.layer = layers['conns']
    cplate_65_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 67
begin
  bplate_66_pts = [
    Geom::Point3d.new(ox+23850, oy+95850, -20),
    Geom::Point3d.new(ox+24150, oy+95850, -20),
    Geom::Point3d.new(ox+24150, oy+96150, -20),
    Geom::Point3d.new(ox+23850, oy+96150, -20)
  ]
  bplate_66_f = ents.add_face(bplate_66_pts)
  if bplate_66_f
    bplate_66_f.material = mat_steel_plate
    bplate_66_f.layer = layers['conns']
    bplate_66_f.pushpull(20)
  end
rescue; end
begin
  cplate_66_pts = [
    Geom::Point3d.new(ox+23850, oy+95850, 3500),
    Geom::Point3d.new(ox+24150, oy+95850, 3500),
    Geom::Point3d.new(ox+24150, oy+96150, 3500),
    Geom::Point3d.new(ox+23850, oy+96150, 3500)
  ]
  cplate_66_f = ents.add_face(cplate_66_pts)
  if cplate_66_f
    cplate_66_f.material = mat_steel_plate
    cplate_66_f.layer = layers['conns']
    cplate_66_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 68
begin
  bplate_67_pts = [
    Geom::Point3d.new(ox+15850, oy+95850, -20),
    Geom::Point3d.new(ox+16150, oy+95850, -20),
    Geom::Point3d.new(ox+16150, oy+96150, -20),
    Geom::Point3d.new(ox+15850, oy+96150, -20)
  ]
  bplate_67_f = ents.add_face(bplate_67_pts)
  if bplate_67_f
    bplate_67_f.material = mat_steel_plate
    bplate_67_f.layer = layers['conns']
    bplate_67_f.pushpull(20)
  end
rescue; end
begin
  cplate_67_pts = [
    Geom::Point3d.new(ox+15850, oy+95850, 3500),
    Geom::Point3d.new(ox+16150, oy+95850, 3500),
    Geom::Point3d.new(ox+16150, oy+96150, 3500),
    Geom::Point3d.new(ox+15850, oy+96150, 3500)
  ]
  cplate_67_f = ents.add_face(cplate_67_pts)
  if cplate_67_f
    cplate_67_f.material = mat_steel_plate
    cplate_67_f.layer = layers['conns']
    cplate_67_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 69
begin
  bplate_68_pts = [
    Geom::Point3d.new(ox+7850, oy+101850, -20),
    Geom::Point3d.new(ox+8150, oy+101850, -20),
    Geom::Point3d.new(ox+8150, oy+102150, -20),
    Geom::Point3d.new(ox+7850, oy+102150, -20)
  ]
  bplate_68_f = ents.add_face(bplate_68_pts)
  if bplate_68_f
    bplate_68_f.material = mat_steel_plate
    bplate_68_f.layer = layers['conns']
    bplate_68_f.pushpull(20)
  end
rescue; end
begin
  cplate_68_pts = [
    Geom::Point3d.new(ox+7850, oy+101850, 3500),
    Geom::Point3d.new(ox+8150, oy+101850, 3500),
    Geom::Point3d.new(ox+8150, oy+102150, 3500),
    Geom::Point3d.new(ox+7850, oy+102150, 3500)
  ]
  cplate_68_f = ents.add_face(cplate_68_pts)
  if cplate_68_f
    cplate_68_f.material = mat_steel_plate
    cplate_68_f.layer = layers['conns']
    cplate_68_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 70
begin
  bplate_69_pts = [
    Geom::Point3d.new(ox+-150, oy+101850, -20),
    Geom::Point3d.new(ox+150, oy+101850, -20),
    Geom::Point3d.new(ox+150, oy+102150, -20),
    Geom::Point3d.new(ox+-150, oy+102150, -20)
  ]
  bplate_69_f = ents.add_face(bplate_69_pts)
  if bplate_69_f
    bplate_69_f.material = mat_steel_plate
    bplate_69_f.layer = layers['conns']
    bplate_69_f.pushpull(20)
  end
rescue; end
begin
  cplate_69_pts = [
    Geom::Point3d.new(ox+-150, oy+101850, 3500),
    Geom::Point3d.new(ox+150, oy+101850, 3500),
    Geom::Point3d.new(ox+150, oy+102150, 3500),
    Geom::Point3d.new(ox+-150, oy+102150, 3500)
  ]
  cplate_69_f = ents.add_face(cplate_69_pts)
  if cplate_69_f
    cplate_69_f.material = mat_steel_plate
    cplate_69_f.layer = layers['conns']
    cplate_69_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 71
begin
  bplate_70_pts = [
    Geom::Point3d.new(ox+-150, oy+8850, -20),
    Geom::Point3d.new(ox+150, oy+8850, -20),
    Geom::Point3d.new(ox+150, oy+9150, -20),
    Geom::Point3d.new(ox+-150, oy+9150, -20)
  ]
  bplate_70_f = ents.add_face(bplate_70_pts)
  if bplate_70_f
    bplate_70_f.material = mat_steel_plate
    bplate_70_f.layer = layers['conns']
    bplate_70_f.pushpull(20)
  end
rescue; end
begin
  cplate_70_pts = [
    Geom::Point3d.new(ox+-150, oy+8850, 3500),
    Geom::Point3d.new(ox+150, oy+8850, 3500),
    Geom::Point3d.new(ox+150, oy+9150, 3500),
    Geom::Point3d.new(ox+-150, oy+9150, 3500)
  ]
  cplate_70_f = ents.add_face(cplate_70_pts)
  if cplate_70_f
    cplate_70_f.material = mat_steel_plate
    cplate_70_f.layer = layers['conns']
    cplate_70_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 72
begin
  bplate_71_pts = [
    Geom::Point3d.new(ox+2850, oy+8850, -20),
    Geom::Point3d.new(ox+3150, oy+8850, -20),
    Geom::Point3d.new(ox+3150, oy+9150, -20),
    Geom::Point3d.new(ox+2850, oy+9150, -20)
  ]
  bplate_71_f = ents.add_face(bplate_71_pts)
  if bplate_71_f
    bplate_71_f.material = mat_steel_plate
    bplate_71_f.layer = layers['conns']
    bplate_71_f.pushpull(20)
  end
rescue; end
begin
  cplate_71_pts = [
    Geom::Point3d.new(ox+2850, oy+8850, 3500),
    Geom::Point3d.new(ox+3150, oy+8850, 3500),
    Geom::Point3d.new(ox+3150, oy+9150, 3500),
    Geom::Point3d.new(ox+2850, oy+9150, 3500)
  ]
  cplate_71_f = ents.add_face(cplate_71_pts)
  if cplate_71_f
    cplate_71_f.material = mat_steel_plate
    cplate_71_f.layer = layers['conns']
    cplate_71_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 73
begin
  bplate_72_pts = [
    Geom::Point3d.new(ox+5850, oy+8850, -20),
    Geom::Point3d.new(ox+6150, oy+8850, -20),
    Geom::Point3d.new(ox+6150, oy+9150, -20),
    Geom::Point3d.new(ox+5850, oy+9150, -20)
  ]
  bplate_72_f = ents.add_face(bplate_72_pts)
  if bplate_72_f
    bplate_72_f.material = mat_steel_plate
    bplate_72_f.layer = layers['conns']
    bplate_72_f.pushpull(20)
  end
rescue; end
begin
  cplate_72_pts = [
    Geom::Point3d.new(ox+5850, oy+8850, 3500),
    Geom::Point3d.new(ox+6150, oy+8850, 3500),
    Geom::Point3d.new(ox+6150, oy+9150, 3500),
    Geom::Point3d.new(ox+5850, oy+9150, 3500)
  ]
  cplate_72_f = ents.add_face(cplate_72_pts)
  if cplate_72_f
    cplate_72_f.material = mat_steel_plate
    cplate_72_f.layer = layers['conns']
    cplate_72_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 74
begin
  bplate_73_pts = [
    Geom::Point3d.new(ox+8850, oy+8850, -20),
    Geom::Point3d.new(ox+9150, oy+8850, -20),
    Geom::Point3d.new(ox+9150, oy+9150, -20),
    Geom::Point3d.new(ox+8850, oy+9150, -20)
  ]
  bplate_73_f = ents.add_face(bplate_73_pts)
  if bplate_73_f
    bplate_73_f.material = mat_steel_plate
    bplate_73_f.layer = layers['conns']
    bplate_73_f.pushpull(20)
  end
rescue; end
begin
  cplate_73_pts = [
    Geom::Point3d.new(ox+8850, oy+8850, 3500),
    Geom::Point3d.new(ox+9150, oy+8850, 3500),
    Geom::Point3d.new(ox+9150, oy+9150, 3500),
    Geom::Point3d.new(ox+8850, oy+9150, 3500)
  ]
  cplate_73_f = ents.add_face(cplate_73_pts)
  if cplate_73_f
    cplate_73_f.material = mat_steel_plate
    cplate_73_f.layer = layers['conns']
    cplate_73_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 75
begin
  bplate_74_pts = [
    Geom::Point3d.new(ox+-150, oy+5850, -20),
    Geom::Point3d.new(ox+150, oy+5850, -20),
    Geom::Point3d.new(ox+150, oy+6150, -20),
    Geom::Point3d.new(ox+-150, oy+6150, -20)
  ]
  bplate_74_f = ents.add_face(bplate_74_pts)
  if bplate_74_f
    bplate_74_f.material = mat_steel_plate
    bplate_74_f.layer = layers['conns']
    bplate_74_f.pushpull(20)
  end
rescue; end
begin
  cplate_74_pts = [
    Geom::Point3d.new(ox+-150, oy+5850, 3500),
    Geom::Point3d.new(ox+150, oy+5850, 3500),
    Geom::Point3d.new(ox+150, oy+6150, 3500),
    Geom::Point3d.new(ox+-150, oy+6150, 3500)
  ]
  cplate_74_f = ents.add_face(cplate_74_pts)
  if cplate_74_f
    cplate_74_f.material = mat_steel_plate
    cplate_74_f.layer = layers['conns']
    cplate_74_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 76
begin
  bplate_75_pts = [
    Geom::Point3d.new(ox+2850, oy+5850, -20),
    Geom::Point3d.new(ox+3150, oy+5850, -20),
    Geom::Point3d.new(ox+3150, oy+6150, -20),
    Geom::Point3d.new(ox+2850, oy+6150, -20)
  ]
  bplate_75_f = ents.add_face(bplate_75_pts)
  if bplate_75_f
    bplate_75_f.material = mat_steel_plate
    bplate_75_f.layer = layers['conns']
    bplate_75_f.pushpull(20)
  end
rescue; end
begin
  cplate_75_pts = [
    Geom::Point3d.new(ox+2850, oy+5850, 3500),
    Geom::Point3d.new(ox+3150, oy+5850, 3500),
    Geom::Point3d.new(ox+3150, oy+6150, 3500),
    Geom::Point3d.new(ox+2850, oy+6150, 3500)
  ]
  cplate_75_f = ents.add_face(cplate_75_pts)
  if cplate_75_f
    cplate_75_f.material = mat_steel_plate
    cplate_75_f.layer = layers['conns']
    cplate_75_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 77
begin
  bplate_76_pts = [
    Geom::Point3d.new(ox+5850, oy+5850, -20),
    Geom::Point3d.new(ox+6150, oy+5850, -20),
    Geom::Point3d.new(ox+6150, oy+6150, -20),
    Geom::Point3d.new(ox+5850, oy+6150, -20)
  ]
  bplate_76_f = ents.add_face(bplate_76_pts)
  if bplate_76_f
    bplate_76_f.material = mat_steel_plate
    bplate_76_f.layer = layers['conns']
    bplate_76_f.pushpull(20)
  end
rescue; end
begin
  cplate_76_pts = [
    Geom::Point3d.new(ox+5850, oy+5850, 3500),
    Geom::Point3d.new(ox+6150, oy+5850, 3500),
    Geom::Point3d.new(ox+6150, oy+6150, 3500),
    Geom::Point3d.new(ox+5850, oy+6150, 3500)
  ]
  cplate_76_f = ents.add_face(cplate_76_pts)
  if cplate_76_f
    cplate_76_f.material = mat_steel_plate
    cplate_76_f.layer = layers['conns']
    cplate_76_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 78
begin
  bplate_77_pts = [
    Geom::Point3d.new(ox+8850, oy+5850, -20),
    Geom::Point3d.new(ox+9150, oy+5850, -20),
    Geom::Point3d.new(ox+9150, oy+6150, -20),
    Geom::Point3d.new(ox+8850, oy+6150, -20)
  ]
  bplate_77_f = ents.add_face(bplate_77_pts)
  if bplate_77_f
    bplate_77_f.material = mat_steel_plate
    bplate_77_f.layer = layers['conns']
    bplate_77_f.pushpull(20)
  end
rescue; end
begin
  cplate_77_pts = [
    Geom::Point3d.new(ox+8850, oy+5850, 3500),
    Geom::Point3d.new(ox+9150, oy+5850, 3500),
    Geom::Point3d.new(ox+9150, oy+6150, 3500),
    Geom::Point3d.new(ox+8850, oy+6150, 3500)
  ]
  cplate_77_f = ents.add_face(cplate_77_pts)
  if cplate_77_f
    cplate_77_f.material = mat_steel_plate
    cplate_77_f.layer = layers['conns']
    cplate_77_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 79
begin
  bplate_78_pts = [
    Geom::Point3d.new(ox+-150, oy+2850, -20),
    Geom::Point3d.new(ox+150, oy+2850, -20),
    Geom::Point3d.new(ox+150, oy+3150, -20),
    Geom::Point3d.new(ox+-150, oy+3150, -20)
  ]
  bplate_78_f = ents.add_face(bplate_78_pts)
  if bplate_78_f
    bplate_78_f.material = mat_steel_plate
    bplate_78_f.layer = layers['conns']
    bplate_78_f.pushpull(20)
  end
rescue; end
begin
  cplate_78_pts = [
    Geom::Point3d.new(ox+-150, oy+2850, 3500),
    Geom::Point3d.new(ox+150, oy+2850, 3500),
    Geom::Point3d.new(ox+150, oy+3150, 3500),
    Geom::Point3d.new(ox+-150, oy+3150, 3500)
  ]
  cplate_78_f = ents.add_face(cplate_78_pts)
  if cplate_78_f
    cplate_78_f.material = mat_steel_plate
    cplate_78_f.layer = layers['conns']
    cplate_78_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 80
begin
  bplate_79_pts = [
    Geom::Point3d.new(ox+2850, oy+2850, -20),
    Geom::Point3d.new(ox+3150, oy+2850, -20),
    Geom::Point3d.new(ox+3150, oy+3150, -20),
    Geom::Point3d.new(ox+2850, oy+3150, -20)
  ]
  bplate_79_f = ents.add_face(bplate_79_pts)
  if bplate_79_f
    bplate_79_f.material = mat_steel_plate
    bplate_79_f.layer = layers['conns']
    bplate_79_f.pushpull(20)
  end
rescue; end
begin
  cplate_79_pts = [
    Geom::Point3d.new(ox+2850, oy+2850, 3500),
    Geom::Point3d.new(ox+3150, oy+2850, 3500),
    Geom::Point3d.new(ox+3150, oy+3150, 3500),
    Geom::Point3d.new(ox+2850, oy+3150, 3500)
  ]
  cplate_79_f = ents.add_face(cplate_79_pts)
  if cplate_79_f
    cplate_79_f.material = mat_steel_plate
    cplate_79_f.layer = layers['conns']
    cplate_79_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 81
begin
  bplate_80_pts = [
    Geom::Point3d.new(ox+5850, oy+2850, -20),
    Geom::Point3d.new(ox+6150, oy+2850, -20),
    Geom::Point3d.new(ox+6150, oy+3150, -20),
    Geom::Point3d.new(ox+5850, oy+3150, -20)
  ]
  bplate_80_f = ents.add_face(bplate_80_pts)
  if bplate_80_f
    bplate_80_f.material = mat_steel_plate
    bplate_80_f.layer = layers['conns']
    bplate_80_f.pushpull(20)
  end
rescue; end
begin
  cplate_80_pts = [
    Geom::Point3d.new(ox+5850, oy+2850, 3500),
    Geom::Point3d.new(ox+6150, oy+2850, 3500),
    Geom::Point3d.new(ox+6150, oy+3150, 3500),
    Geom::Point3d.new(ox+5850, oy+3150, 3500)
  ]
  cplate_80_f = ents.add_face(cplate_80_pts)
  if cplate_80_f
    cplate_80_f.material = mat_steel_plate
    cplate_80_f.layer = layers['conns']
    cplate_80_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 82
begin
  bplate_81_pts = [
    Geom::Point3d.new(ox+8850, oy+2850, -20),
    Geom::Point3d.new(ox+9150, oy+2850, -20),
    Geom::Point3d.new(ox+9150, oy+3150, -20),
    Geom::Point3d.new(ox+8850, oy+3150, -20)
  ]
  bplate_81_f = ents.add_face(bplate_81_pts)
  if bplate_81_f
    bplate_81_f.material = mat_steel_plate
    bplate_81_f.layer = layers['conns']
    bplate_81_f.pushpull(20)
  end
rescue; end
begin
  cplate_81_pts = [
    Geom::Point3d.new(ox+8850, oy+2850, 3500),
    Geom::Point3d.new(ox+9150, oy+2850, 3500),
    Geom::Point3d.new(ox+9150, oy+3150, 3500),
    Geom::Point3d.new(ox+8850, oy+3150, 3500)
  ]
  cplate_81_f = ents.add_face(cplate_81_pts)
  if cplate_81_f
    cplate_81_f.material = mat_steel_plate
    cplate_81_f.layer = layers['conns']
    cplate_81_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 83
begin
  bplate_82_pts = [
    Geom::Point3d.new(ox+-150, oy+-150, -20),
    Geom::Point3d.new(ox+150, oy+-150, -20),
    Geom::Point3d.new(ox+150, oy+150, -20),
    Geom::Point3d.new(ox+-150, oy+150, -20)
  ]
  bplate_82_f = ents.add_face(bplate_82_pts)
  if bplate_82_f
    bplate_82_f.material = mat_steel_plate
    bplate_82_f.layer = layers['conns']
    bplate_82_f.pushpull(20)
  end
rescue; end
begin
  cplate_82_pts = [
    Geom::Point3d.new(ox+-150, oy+-150, 3500),
    Geom::Point3d.new(ox+150, oy+-150, 3500),
    Geom::Point3d.new(ox+150, oy+150, 3500),
    Geom::Point3d.new(ox+-150, oy+150, 3500)
  ]
  cplate_82_f = ents.add_face(cplate_82_pts)
  if cplate_82_f
    cplate_82_f.material = mat_steel_plate
    cplate_82_f.layer = layers['conns']
    cplate_82_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 84
begin
  bplate_83_pts = [
    Geom::Point3d.new(ox+2850, oy+-150, -20),
    Geom::Point3d.new(ox+3150, oy+-150, -20),
    Geom::Point3d.new(ox+3150, oy+150, -20),
    Geom::Point3d.new(ox+2850, oy+150, -20)
  ]
  bplate_83_f = ents.add_face(bplate_83_pts)
  if bplate_83_f
    bplate_83_f.material = mat_steel_plate
    bplate_83_f.layer = layers['conns']
    bplate_83_f.pushpull(20)
  end
rescue; end
begin
  cplate_83_pts = [
    Geom::Point3d.new(ox+2850, oy+-150, 3500),
    Geom::Point3d.new(ox+3150, oy+-150, 3500),
    Geom::Point3d.new(ox+3150, oy+150, 3500),
    Geom::Point3d.new(ox+2850, oy+150, 3500)
  ]
  cplate_83_f = ents.add_face(cplate_83_pts)
  if cplate_83_f
    cplate_83_f.material = mat_steel_plate
    cplate_83_f.layer = layers['conns']
    cplate_83_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 85
begin
  bplate_84_pts = [
    Geom::Point3d.new(ox+5850, oy+-150, -20),
    Geom::Point3d.new(ox+6150, oy+-150, -20),
    Geom::Point3d.new(ox+6150, oy+150, -20),
    Geom::Point3d.new(ox+5850, oy+150, -20)
  ]
  bplate_84_f = ents.add_face(bplate_84_pts)
  if bplate_84_f
    bplate_84_f.material = mat_steel_plate
    bplate_84_f.layer = layers['conns']
    bplate_84_f.pushpull(20)
  end
rescue; end
begin
  cplate_84_pts = [
    Geom::Point3d.new(ox+5850, oy+-150, 3500),
    Geom::Point3d.new(ox+6150, oy+-150, 3500),
    Geom::Point3d.new(ox+6150, oy+150, 3500),
    Geom::Point3d.new(ox+5850, oy+150, 3500)
  ]
  cplate_84_f = ents.add_face(cplate_84_pts)
  if cplate_84_f
    cplate_84_f.material = mat_steel_plate
    cplate_84_f.layer = layers['conns']
    cplate_84_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 86
begin
  bplate_85_pts = [
    Geom::Point3d.new(ox+8850, oy+-150, -20),
    Geom::Point3d.new(ox+9150, oy+-150, -20),
    Geom::Point3d.new(ox+9150, oy+150, -20),
    Geom::Point3d.new(ox+8850, oy+150, -20)
  ]
  bplate_85_f = ents.add_face(bplate_85_pts)
  if bplate_85_f
    bplate_85_f.material = mat_steel_plate
    bplate_85_f.layer = layers['conns']
    bplate_85_f.pushpull(20)
  end
rescue; end
begin
  cplate_85_pts = [
    Geom::Point3d.new(ox+8850, oy+-150, 3500),
    Geom::Point3d.new(ox+9150, oy+-150, 3500),
    Geom::Point3d.new(ox+9150, oy+150, 3500),
    Geom::Point3d.new(ox+8850, oy+150, 3500)
  ]
  cplate_85_f = ents.add_face(cplate_85_pts)
  if cplate_85_f
    cplate_85_f.material = mat_steel_plate
    cplate_85_f.layer = layers['conns']
    cplate_85_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 87
begin
  bplate_86_pts = [
    Geom::Point3d.new(ox+7850, oy+23850, -20),
    Geom::Point3d.new(ox+8150, oy+23850, -20),
    Geom::Point3d.new(ox+8150, oy+24150, -20),
    Geom::Point3d.new(ox+7850, oy+24150, -20)
  ]
  bplate_86_f = ents.add_face(bplate_86_pts)
  if bplate_86_f
    bplate_86_f.material = mat_steel_plate
    bplate_86_f.layer = layers['conns']
    bplate_86_f.pushpull(20)
  end
rescue; end
begin
  cplate_86_pts = [
    Geom::Point3d.new(ox+7850, oy+23850, 3500),
    Geom::Point3d.new(ox+8150, oy+23850, 3500),
    Geom::Point3d.new(ox+8150, oy+24150, 3500),
    Geom::Point3d.new(ox+7850, oy+24150, 3500)
  ]
  cplate_86_f = ents.add_face(cplate_86_pts)
  if cplate_86_f
    cplate_86_f.material = mat_steel_plate
    cplate_86_f.layer = layers['conns']
    cplate_86_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 88
begin
  bplate_87_pts = [
    Geom::Point3d.new(ox+15850, oy+23850, -20),
    Geom::Point3d.new(ox+16150, oy+23850, -20),
    Geom::Point3d.new(ox+16150, oy+24150, -20),
    Geom::Point3d.new(ox+15850, oy+24150, -20)
  ]
  bplate_87_f = ents.add_face(bplate_87_pts)
  if bplate_87_f
    bplate_87_f.material = mat_steel_plate
    bplate_87_f.layer = layers['conns']
    bplate_87_f.pushpull(20)
  end
rescue; end
begin
  cplate_87_pts = [
    Geom::Point3d.new(ox+15850, oy+23850, 3500),
    Geom::Point3d.new(ox+16150, oy+23850, 3500),
    Geom::Point3d.new(ox+16150, oy+24150, 3500),
    Geom::Point3d.new(ox+15850, oy+24150, 3500)
  ]
  cplate_87_f = ents.add_face(cplate_87_pts)
  if cplate_87_f
    cplate_87_f.material = mat_steel_plate
    cplate_87_f.layer = layers['conns']
    cplate_87_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 89
begin
  bplate_88_pts = [
    Geom::Point3d.new(ox+23850, oy+23850, -20),
    Geom::Point3d.new(ox+24150, oy+23850, -20),
    Geom::Point3d.new(ox+24150, oy+24150, -20),
    Geom::Point3d.new(ox+23850, oy+24150, -20)
  ]
  bplate_88_f = ents.add_face(bplate_88_pts)
  if bplate_88_f
    bplate_88_f.material = mat_steel_plate
    bplate_88_f.layer = layers['conns']
    bplate_88_f.pushpull(20)
  end
rescue; end
begin
  cplate_88_pts = [
    Geom::Point3d.new(ox+23850, oy+23850, 3500),
    Geom::Point3d.new(ox+24150, oy+23850, 3500),
    Geom::Point3d.new(ox+24150, oy+24150, 3500),
    Geom::Point3d.new(ox+23850, oy+24150, 3500)
  ]
  cplate_88_f = ents.add_face(cplate_88_pts)
  if cplate_88_f
    cplate_88_f.material = mat_steel_plate
    cplate_88_f.layer = layers['conns']
    cplate_88_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 90
begin
  bplate_89_pts = [
    Geom::Point3d.new(ox+23850, oy+15850, -20),
    Geom::Point3d.new(ox+24150, oy+15850, -20),
    Geom::Point3d.new(ox+24150, oy+16150, -20),
    Geom::Point3d.new(ox+23850, oy+16150, -20)
  ]
  bplate_89_f = ents.add_face(bplate_89_pts)
  if bplate_89_f
    bplate_89_f.material = mat_steel_plate
    bplate_89_f.layer = layers['conns']
    bplate_89_f.pushpull(20)
  end
rescue; end
begin
  cplate_89_pts = [
    Geom::Point3d.new(ox+23850, oy+15850, 3500),
    Geom::Point3d.new(ox+24150, oy+15850, 3500),
    Geom::Point3d.new(ox+24150, oy+16150, 3500),
    Geom::Point3d.new(ox+23850, oy+16150, 3500)
  ]
  cplate_89_f = ents.add_face(cplate_89_pts)
  if cplate_89_f
    cplate_89_f.material = mat_steel_plate
    cplate_89_f.layer = layers['conns']
    cplate_89_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 91
begin
  bplate_90_pts = [
    Geom::Point3d.new(ox+23850, oy+7850, -20),
    Geom::Point3d.new(ox+24150, oy+7850, -20),
    Geom::Point3d.new(ox+24150, oy+8150, -20),
    Geom::Point3d.new(ox+23850, oy+8150, -20)
  ]
  bplate_90_f = ents.add_face(bplate_90_pts)
  if bplate_90_f
    bplate_90_f.material = mat_steel_plate
    bplate_90_f.layer = layers['conns']
    bplate_90_f.pushpull(20)
  end
rescue; end
begin
  cplate_90_pts = [
    Geom::Point3d.new(ox+23850, oy+7850, 3500),
    Geom::Point3d.new(ox+24150, oy+7850, 3500),
    Geom::Point3d.new(ox+24150, oy+8150, 3500),
    Geom::Point3d.new(ox+23850, oy+8150, 3500)
  ]
  cplate_90_f = ents.add_face(cplate_90_pts)
  if cplate_90_f
    cplate_90_f.material = mat_steel_plate
    cplate_90_f.layer = layers['conns']
    cplate_90_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 92
begin
  bplate_91_pts = [
    Geom::Point3d.new(ox+23850, oy+-150, -20),
    Geom::Point3d.new(ox+24150, oy+-150, -20),
    Geom::Point3d.new(ox+24150, oy+150, -20),
    Geom::Point3d.new(ox+23850, oy+150, -20)
  ]
  bplate_91_f = ents.add_face(bplate_91_pts)
  if bplate_91_f
    bplate_91_f.material = mat_steel_plate
    bplate_91_f.layer = layers['conns']
    bplate_91_f.pushpull(20)
  end
rescue; end
begin
  cplate_91_pts = [
    Geom::Point3d.new(ox+23850, oy+-150, 3500),
    Geom::Point3d.new(ox+24150, oy+-150, 3500),
    Geom::Point3d.new(ox+24150, oy+150, 3500),
    Geom::Point3d.new(ox+23850, oy+150, 3500)
  ]
  cplate_91_f = ents.add_face(cplate_91_pts)
  if cplate_91_f
    cplate_91_f.material = mat_steel_plate
    cplate_91_f.layer = layers['conns']
    cplate_91_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 93
begin
  bplate_92_pts = [
    Geom::Point3d.new(ox+15850, oy+-150, -20),
    Geom::Point3d.new(ox+16150, oy+-150, -20),
    Geom::Point3d.new(ox+16150, oy+150, -20),
    Geom::Point3d.new(ox+15850, oy+150, -20)
  ]
  bplate_92_f = ents.add_face(bplate_92_pts)
  if bplate_92_f
    bplate_92_f.material = mat_steel_plate
    bplate_92_f.layer = layers['conns']
    bplate_92_f.pushpull(20)
  end
rescue; end
begin
  cplate_92_pts = [
    Geom::Point3d.new(ox+15850, oy+-150, 3500),
    Geom::Point3d.new(ox+16150, oy+-150, 3500),
    Geom::Point3d.new(ox+16150, oy+150, 3500),
    Geom::Point3d.new(ox+15850, oy+150, 3500)
  ]
  cplate_92_f = ents.add_face(cplate_92_pts)
  if cplate_92_f
    cplate_92_f.material = mat_steel_plate
    cplate_92_f.layer = layers['conns']
    cplate_92_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 94
begin
  bplate_93_pts = [
    Geom::Point3d.new(ox+7850, oy+-150, -20),
    Geom::Point3d.new(ox+8150, oy+-150, -20),
    Geom::Point3d.new(ox+8150, oy+150, -20),
    Geom::Point3d.new(ox+7850, oy+150, -20)
  ]
  bplate_93_f = ents.add_face(bplate_93_pts)
  if bplate_93_f
    bplate_93_f.material = mat_steel_plate
    bplate_93_f.layer = layers['conns']
    bplate_93_f.pushpull(20)
  end
rescue; end
begin
  cplate_93_pts = [
    Geom::Point3d.new(ox+7850, oy+-150, 3500),
    Geom::Point3d.new(ox+8150, oy+-150, 3500),
    Geom::Point3d.new(ox+8150, oy+150, 3500),
    Geom::Point3d.new(ox+7850, oy+150, 3500)
  ]
  cplate_93_f = ents.add_face(cplate_93_pts)
  if cplate_93_f
    cplate_93_f.material = mat_steel_plate
    cplate_93_f.layer = layers['conns']
    cplate_93_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 95
begin
  bplate_94_pts = [
    Geom::Point3d.new(ox+7850, oy+15850, -20),
    Geom::Point3d.new(ox+8150, oy+15850, -20),
    Geom::Point3d.new(ox+8150, oy+16150, -20),
    Geom::Point3d.new(ox+7850, oy+16150, -20)
  ]
  bplate_94_f = ents.add_face(bplate_94_pts)
  if bplate_94_f
    bplate_94_f.material = mat_steel_plate
    bplate_94_f.layer = layers['conns']
    bplate_94_f.pushpull(20)
  end
rescue; end
begin
  cplate_94_pts = [
    Geom::Point3d.new(ox+7850, oy+15850, 3500),
    Geom::Point3d.new(ox+8150, oy+15850, 3500),
    Geom::Point3d.new(ox+8150, oy+16150, 3500),
    Geom::Point3d.new(ox+7850, oy+16150, 3500)
  ]
  cplate_94_f = ents.add_face(cplate_94_pts)
  if cplate_94_f
    cplate_94_f.material = mat_steel_plate
    cplate_94_f.layer = layers['conns']
    cplate_94_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 96
begin
  bplate_95_pts = [
    Geom::Point3d.new(ox+15850, oy+15850, -20),
    Geom::Point3d.new(ox+16150, oy+15850, -20),
    Geom::Point3d.new(ox+16150, oy+16150, -20),
    Geom::Point3d.new(ox+15850, oy+16150, -20)
  ]
  bplate_95_f = ents.add_face(bplate_95_pts)
  if bplate_95_f
    bplate_95_f.material = mat_steel_plate
    bplate_95_f.layer = layers['conns']
    bplate_95_f.pushpull(20)
  end
rescue; end
begin
  cplate_95_pts = [
    Geom::Point3d.new(ox+15850, oy+15850, 3500),
    Geom::Point3d.new(ox+16150, oy+15850, 3500),
    Geom::Point3d.new(ox+16150, oy+16150, 3500),
    Geom::Point3d.new(ox+15850, oy+16150, 3500)
  ]
  cplate_95_f = ents.add_face(cplate_95_pts)
  if cplate_95_f
    cplate_95_f.material = mat_steel_plate
    cplate_95_f.layer = layers['conns']
    cplate_95_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 97
begin
  bplate_96_pts = [
    Geom::Point3d.new(ox+7850, oy+7850, -20),
    Geom::Point3d.new(ox+8150, oy+7850, -20),
    Geom::Point3d.new(ox+8150, oy+8150, -20),
    Geom::Point3d.new(ox+7850, oy+8150, -20)
  ]
  bplate_96_f = ents.add_face(bplate_96_pts)
  if bplate_96_f
    bplate_96_f.material = mat_steel_plate
    bplate_96_f.layer = layers['conns']
    bplate_96_f.pushpull(20)
  end
rescue; end
begin
  cplate_96_pts = [
    Geom::Point3d.new(ox+7850, oy+7850, 3500),
    Geom::Point3d.new(ox+8150, oy+7850, 3500),
    Geom::Point3d.new(ox+8150, oy+8150, 3500),
    Geom::Point3d.new(ox+7850, oy+8150, 3500)
  ]
  cplate_96_f = ents.add_face(cplate_96_pts)
  if cplate_96_f
    cplate_96_f.material = mat_steel_plate
    cplate_96_f.layer = layers['conns']
    cplate_96_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 98
begin
  bplate_97_pts = [
    Geom::Point3d.new(ox+15850, oy+7850, -20),
    Geom::Point3d.new(ox+16150, oy+7850, -20),
    Geom::Point3d.new(ox+16150, oy+8150, -20),
    Geom::Point3d.new(ox+15850, oy+8150, -20)
  ]
  bplate_97_f = ents.add_face(bplate_97_pts)
  if bplate_97_f
    bplate_97_f.material = mat_steel_plate
    bplate_97_f.layer = layers['conns']
    bplate_97_f.pushpull(20)
  end
rescue; end
begin
  cplate_97_pts = [
    Geom::Point3d.new(ox+15850, oy+7850, 3500),
    Geom::Point3d.new(ox+16150, oy+7850, 3500),
    Geom::Point3d.new(ox+16150, oy+8150, 3500),
    Geom::Point3d.new(ox+15850, oy+8150, 3500)
  ]
  cplate_97_f = ents.add_face(cplate_97_pts)
  if cplate_97_f
    cplate_97_f.material = mat_steel_plate
    cplate_97_f.layer = layers['conns']
    cplate_97_f.pushpull(20)
  end
rescue; end
# LOD350 base+cap plates: col 99
begin
  bplate_98_pts = [
    Geom::Point3d.new(ox+11850, oy+143850, -20),
    Geom::Point3d.new(ox+12150, oy+143850, -20),
    Geom::Point3d.new(ox+12150, oy+144150, -20),
    Geom::Point3d.new(ox+11850, oy+144150, -20)
  ]
  bplate_98_f = ents.add_face(bplate_98_pts)
  if bplate_98_f
    bplate_98_f.material = mat_steel_plate
    bplate_98_f.layer = layers['conns']
    bplate_98_f.pushpull(20)
  end
rescue; end
begin
  cplate_98_pts = [
    Geom::Point3d.new(ox+11850, oy+143850, 3500),
    Geom::Point3d.new(ox+12150, oy+143850, 3500),
    Geom::Point3d.new(ox+12150, oy+144150, 3500),
    Geom::Point3d.new(ox+11850, oy+144150, 3500)
  ]
  cplate_98_f = ents.add_face(cplate_98_pts)
  if cplate_98_f
    cplate_98_f.material = mat_steel_plate
    cplate_98_f.layer = layers['conns']
    cplate_98_f.pushpull(20)
  end
rescue; end

model.commit_operation
UI.messagebox('LOD350 Done: 99c 154b 7s 4w 6f 0st 0sh')
# ── Auto-save .skp ──────────────────────────────────────────
begin
  _skp_name = 'THE_UNIVERSITY_OF_NEW_ENGLAND_TAMWORTH_CENTRAL_CAMPUS_LOD300.skp'
  _skp_dir  = File.expand_path('~/Downloads')
  _skp_path = File.join(_skp_dir, _skp_name)
  Sketchup.active_model.save(_skp_path)
  UI.messagebox("\u2705 Model saved: #{_skp_path}")
rescue => _e
  UI.messagebox("Save failed: #{_e.message}. Use File > Save As manually.")
end
