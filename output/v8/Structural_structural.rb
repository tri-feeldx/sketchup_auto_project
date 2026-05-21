# SketchUp Structural Script
# Generated: 2026-05-21T14:21:09.901968
# Region: au

model = Sketchup.active_model
ents = model.active_entities
model.start_operation('Structural_Import', true)
defn = model.definitions

# ── Layers ──
layers = {
  'cols' => model.layers.add('Columns'),
  'beams'=> model.layers.add('Beams'),
  'slabs'=> model.layers.add('Slabs'),
  'walls'=> model.layers.add('Walls'),
  'ftgs' => model.layers.add('Footings'),
}

# ── Materials ──
mat_c40_50_assumed = model.materials.add('C40/50 (assumed)')
mat_c40_50_assumed.color = Sketchup::Color.new(190,190,190)
mat_steel = model.materials.add('Steel')
mat_steel.color = Sketchup::Color.new(190,190,190)
mat_concrete = model.materials.add('concrete')
mat_concrete.color = Sketchup::Color.new(180,180,180)
mat_reinforced_concrete = model.materials.add('reinforced_concrete')
mat_reinforced_concrete.color = Sketchup::Color.new(190,190,190)

ox = 0; oy = 0; oz = 0

# === Columns ===
# Column 1: UB36c
pts_0 = [
  Geom::Point3d.new(ox+0, oy+0, 0),
  Geom::Point3d.new(ox+360, oy+0, 0),
  Geom::Point3d.new(ox+360, oy+360, 0),
  Geom::Point3d.new(ox+0, oy+360, 0)
]
f_0 = ents.add_face(pts_0)
f_0.material = mat_c40_50_assumed if f_0
f_0.layer = layers['cols'] if f_0
f_0.pushpull(3500) if f_0
# Column 2: UB36d
pts_1 = [
  Geom::Point3d.new(ox+6000, oy+0, 0),
  Geom::Point3d.new(ox+6360, oy+0, 0),
  Geom::Point3d.new(ox+6360, oy+360, 0),
  Geom::Point3d.new(ox+6000, oy+360, 0)
]
f_1 = ents.add_face(pts_1)
f_1.material = mat_c40_50_assumed if f_1
f_1.layer = layers['cols'] if f_1
f_1.pushpull(3500) if f_1
# Column 3: C1
pts_2 = [
  Geom::Point3d.new(ox+0, oy+24000, 0),
  Geom::Point3d.new(ox+400, oy+24000, 0),
  Geom::Point3d.new(ox+400, oy+24400, 0),
  Geom::Point3d.new(ox+0, oy+24400, 0)
]
f_2 = ents.add_face(pts_2)
f_2.material = mat_concrete if f_2
f_2.layer = layers['cols'] if f_2
f_2.pushpull(3500) if f_2
# Column 4: C2
pts_3 = [
  Geom::Point3d.new(ox+6000, oy+24000, 0),
  Geom::Point3d.new(ox+6400, oy+24000, 0),
  Geom::Point3d.new(ox+6400, oy+24400, 0),
  Geom::Point3d.new(ox+6000, oy+24400, 0)
]
f_3 = ents.add_face(pts_3)
f_3.material = mat_concrete if f_3
f_3.layer = layers['cols'] if f_3
f_3.pushpull(3500) if f_3
# Column 5: C3
pts_4 = [
  Geom::Point3d.new(ox+12000, oy+24000, 0),
  Geom::Point3d.new(ox+12400, oy+24000, 0),
  Geom::Point3d.new(ox+12400, oy+24400, 0),
  Geom::Point3d.new(ox+12000, oy+24400, 0)
]
f_4 = ents.add_face(pts_4)
f_4.material = mat_concrete if f_4
f_4.layer = layers['cols'] if f_4
f_4.pushpull(3500) if f_4
# Column 6: C4
pts_5 = [
  Geom::Point3d.new(ox+18000, oy+24000, 0),
  Geom::Point3d.new(ox+18400, oy+24000, 0),
  Geom::Point3d.new(ox+18400, oy+24400, 0),
  Geom::Point3d.new(ox+18000, oy+24400, 0)
]
f_5 = ents.add_face(pts_5)
f_5.material = mat_concrete if f_5
f_5.layer = layers['cols'] if f_5
f_5.pushpull(3500) if f_5
# Column 7: C5
pts_6 = [
  Geom::Point3d.new(ox+0, oy+24000, 0),
  Geom::Point3d.new(ox+400, oy+24000, 0),
  Geom::Point3d.new(ox+400, oy+24400, 0),
  Geom::Point3d.new(ox+0, oy+24400, 0)
]
f_6 = ents.add_face(pts_6)
f_6.material = mat_concrete if f_6
f_6.layer = layers['cols'] if f_6
f_6.pushpull(3500) if f_6
# Column 8: C6
pts_7 = [
  Geom::Point3d.new(ox+6000, oy+24000, 0),
  Geom::Point3d.new(ox+6400, oy+24000, 0),
  Geom::Point3d.new(ox+6400, oy+24400, 0),
  Geom::Point3d.new(ox+6000, oy+24400, 0)
]
f_7 = ents.add_face(pts_7)
f_7.material = mat_concrete if f_7
f_7.layer = layers['cols'] if f_7
f_7.pushpull(3500) if f_7
# Column 9: C7
pts_8 = [
  Geom::Point3d.new(ox+12000, oy+24000, 0),
  Geom::Point3d.new(ox+12400, oy+24000, 0),
  Geom::Point3d.new(ox+12400, oy+24400, 0),
  Geom::Point3d.new(ox+12000, oy+24400, 0)
]
f_8 = ents.add_face(pts_8)
f_8.material = mat_concrete if f_8
f_8.layer = layers['cols'] if f_8
f_8.pushpull(3500) if f_8
# Column 10: C8
pts_9 = [
  Geom::Point3d.new(ox+18000, oy+24000, 0),
  Geom::Point3d.new(ox+18400, oy+24000, 0),
  Geom::Point3d.new(ox+18400, oy+24400, 0),
  Geom::Point3d.new(ox+18000, oy+24400, 0)
]
f_9 = ents.add_face(pts_9)
f_9.material = mat_concrete if f_9
f_9.layer = layers['cols'] if f_9
f_9.pushpull(3500) if f_9
# Column 11: C9
pts_10 = [
  Geom::Point3d.new(ox+4000, oy+11000, 0),
  Geom::Point3d.new(ox+4400, oy+11000, 0),
  Geom::Point3d.new(ox+4400, oy+11400, 0),
  Geom::Point3d.new(ox+4000, oy+11400, 0)
]
f_10 = ents.add_face(pts_10)
f_10.material = mat_c40_50_assumed if f_10
f_10.layer = layers['cols'] if f_10
f_10.pushpull(3500) if f_10
# Column 12: C10
pts_11 = [
  Geom::Point3d.new(ox+10000, oy+11000, 0),
  Geom::Point3d.new(ox+10400, oy+11000, 0),
  Geom::Point3d.new(ox+10400, oy+11400, 0),
  Geom::Point3d.new(ox+10000, oy+11400, 0)
]
f_11 = ents.add_face(pts_11)
f_11.material = mat_c40_50_assumed if f_11
f_11.layer = layers['cols'] if f_11
f_11.pushpull(3500) if f_11
# Column 13: C11
pts_12 = [
  Geom::Point3d.new(ox+16000, oy+11000, 0),
  Geom::Point3d.new(ox+16400, oy+11000, 0),
  Geom::Point3d.new(ox+16400, oy+11400, 0),
  Geom::Point3d.new(ox+16000, oy+11400, 0)
]
f_12 = ents.add_face(pts_12)
f_12.material = mat_c40_50_assumed if f_12
f_12.layer = layers['cols'] if f_12
f_12.pushpull(3500) if f_12
# Column 14: C12
pts_13 = [
  Geom::Point3d.new(ox+22000, oy+11000, 0),
  Geom::Point3d.new(ox+22400, oy+11000, 0),
  Geom::Point3d.new(ox+22400, oy+11400, 0),
  Geom::Point3d.new(ox+22000, oy+11400, 0)
]
f_13 = ents.add_face(pts_13)
f_13.material = mat_c40_50_assumed if f_13
f_13.layer = layers['cols'] if f_13
f_13.pushpull(3500) if f_13
# Column 15: C13
pts_14 = [
  Geom::Point3d.new(ox+4000, oy+5000, 0),
  Geom::Point3d.new(ox+4400, oy+5000, 0),
  Geom::Point3d.new(ox+4400, oy+5400, 0),
  Geom::Point3d.new(ox+4000, oy+5400, 0)
]
f_14 = ents.add_face(pts_14)
f_14.material = mat_c40_50_assumed if f_14
f_14.layer = layers['cols'] if f_14
f_14.pushpull(3500) if f_14
# Column 16: C14
pts_15 = [
  Geom::Point3d.new(ox+10000, oy+5000, 0),
  Geom::Point3d.new(ox+10400, oy+5000, 0),
  Geom::Point3d.new(ox+10400, oy+5400, 0),
  Geom::Point3d.new(ox+10000, oy+5400, 0)
]
f_15 = ents.add_face(pts_15)
f_15.material = mat_c40_50_assumed if f_15
f_15.layer = layers['cols'] if f_15
f_15.pushpull(3500) if f_15
# Column 17: C15
pts_16 = [
  Geom::Point3d.new(ox+16000, oy+5000, 0),
  Geom::Point3d.new(ox+16400, oy+5000, 0),
  Geom::Point3d.new(ox+16400, oy+5400, 0),
  Geom::Point3d.new(ox+16000, oy+5400, 0)
]
f_16 = ents.add_face(pts_16)
f_16.material = mat_c40_50_assumed if f_16
f_16.layer = layers['cols'] if f_16
f_16.pushpull(3500) if f_16
# Column 18: C16
pts_17 = [
  Geom::Point3d.new(ox+22000, oy+5000, 0),
  Geom::Point3d.new(ox+22400, oy+5000, 0),
  Geom::Point3d.new(ox+22400, oy+5400, 0),
  Geom::Point3d.new(ox+22000, oy+5400, 0)
]
f_17 = ents.add_face(pts_17)
f_17.material = mat_c40_50_assumed if f_17
f_17.layer = layers['cols'] if f_17
f_17.pushpull(3500) if f_17
# Column 19: C17
pts_18 = [
  Geom::Point3d.new(ox+12500, oy+15000, 0),
  Geom::Point3d.new(ox+12900, oy+15000, 0),
  Geom::Point3d.new(ox+12900, oy+15400, 0),
  Geom::Point3d.new(ox+12500, oy+15400, 0)
]
f_18 = ents.add_face(pts_18)
f_18.material = mat_concrete if f_18
f_18.layer = layers['cols'] if f_18
f_18.pushpull(3500) if f_18
# Column 20: C18
pts_19 = [
  Geom::Point3d.new(ox+12500, oy+10000, 0),
  Geom::Point3d.new(ox+12900, oy+10000, 0),
  Geom::Point3d.new(ox+12900, oy+10400, 0),
  Geom::Point3d.new(ox+12500, oy+10400, 0)
]
f_19 = ents.add_face(pts_19)
f_19.material = mat_concrete if f_19
f_19.layer = layers['cols'] if f_19
f_19.pushpull(3500) if f_19
# Column 21: C19
pts_20 = [
  Geom::Point3d.new(ox+12500, oy+5000, 0),
  Geom::Point3d.new(ox+12900, oy+5000, 0),
  Geom::Point3d.new(ox+12900, oy+5400, 0),
  Geom::Point3d.new(ox+12500, oy+5400, 0)
]
f_20 = ents.add_face(pts_20)
f_20.material = mat_concrete if f_20
f_20.layer = layers['cols'] if f_20
f_20.pushpull(3500) if f_20
# Column 22: C20
pts_21 = [
  Geom::Point3d.new(ox+12500, oy+0, 0),
  Geom::Point3d.new(ox+12900, oy+0, 0),
  Geom::Point3d.new(ox+12900, oy+400, 0),
  Geom::Point3d.new(ox+12500, oy+400, 0)
]
f_21 = ents.add_face(pts_21)
f_21.material = mat_concrete if f_21
f_21.layer = layers['cols'] if f_21
f_21.pushpull(3500) if f_21
# Column 23: C21
pts_22 = [
  Geom::Point3d.new(ox+15000, oy+12500, 0),
  Geom::Point3d.new(ox+15400, oy+12500, 0),
  Geom::Point3d.new(ox+15400, oy+12900, 0),
  Geom::Point3d.new(ox+15000, oy+12900, 0)
]
f_22 = ents.add_face(pts_22)
f_22.material = mat_concrete if f_22
f_22.layer = layers['cols'] if f_22
f_22.pushpull(3500) if f_22
# Column 24: C22
pts_23 = [
  Geom::Point3d.new(ox+15000, oy+7500, 0),
  Geom::Point3d.new(ox+15400, oy+7500, 0),
  Geom::Point3d.new(ox+15400, oy+7900, 0),
  Geom::Point3d.new(ox+15000, oy+7900, 0)
]
f_23 = ents.add_face(pts_23)
f_23.material = mat_concrete if f_23
f_23.layer = layers['cols'] if f_23
f_23.pushpull(3500) if f_23
# Column 25: C23
pts_24 = [
  Geom::Point3d.new(ox+15000, oy+2500, 0),
  Geom::Point3d.new(ox+15400, oy+2500, 0),
  Geom::Point3d.new(ox+15400, oy+2900, 0),
  Geom::Point3d.new(ox+15000, oy+2900, 0)
]
f_24 = ents.add_face(pts_24)
f_24.material = mat_concrete if f_24
f_24.layer = layers['cols'] if f_24
f_24.pushpull(3500) if f_24
# Column 26: WS1-H6.0-NOFRL
pts_25 = [
  Geom::Point3d.new(ox+6000, oy+36000, 0),
  Geom::Point3d.new(ox+6100, oy+36000, 0),
  Geom::Point3d.new(ox+6100, oy+36100, 0),
  Geom::Point3d.new(ox+6000, oy+36100, 0)
]
f_25 = ents.add_face(pts_25)
f_25.material = mat_c40_50_assumed if f_25
f_25.layer = layers['cols'] if f_25
f_25.pushpull(6000) if f_25
# Column 27: WS1-H6.0-60MIN
pts_26 = [
  Geom::Point3d.new(ox+12000, oy+36000, 0),
  Geom::Point3d.new(ox+12100, oy+36000, 0),
  Geom::Point3d.new(ox+12100, oy+36100, 0),
  Geom::Point3d.new(ox+12000, oy+36100, 0)
]
f_26 = ents.add_face(pts_26)
f_26.material = mat_c40_50_assumed if f_26
f_26.layer = layers['cols'] if f_26
f_26.pushpull(6000) if f_26
# Column 28: WS1-H6.0-90MIN
pts_27 = [
  Geom::Point3d.new(ox+18000, oy+36000, 0),
  Geom::Point3d.new(ox+18100, oy+36000, 0),
  Geom::Point3d.new(ox+18100, oy+36100, 0),
  Geom::Point3d.new(ox+18000, oy+36100, 0)
]
f_27 = ents.add_face(pts_27)
f_27.material = mat_c40_50_assumed if f_27
f_27.layer = layers['cols'] if f_27
f_27.pushpull(6000) if f_27
# Column 29: WS1-H6.0-120MIN
pts_28 = [
  Geom::Point3d.new(ox+0, oy+42000, 0),
  Geom::Point3d.new(ox+100, oy+42000, 0),
  Geom::Point3d.new(ox+100, oy+42100, 0),
  Geom::Point3d.new(ox+0, oy+42100, 0)
]
f_28 = ents.add_face(pts_28)
f_28.material = mat_c40_50_assumed if f_28
f_28.layer = layers['cols'] if f_28
f_28.pushpull(6000) if f_28
# Column 30: WS1-H5.5-NOFRL
pts_29 = [
  Geom::Point3d.new(ox+6000, oy+42000, 0),
  Geom::Point3d.new(ox+6100, oy+42000, 0),
  Geom::Point3d.new(ox+6100, oy+42100, 0),
  Geom::Point3d.new(ox+6000, oy+42100, 0)
]
f_29 = ents.add_face(pts_29)
f_29.material = mat_c40_50_assumed if f_29
f_29.layer = layers['cols'] if f_29
f_29.pushpull(5500) if f_29
# Column 31: WS1-H5.5-60MIN
pts_30 = [
  Geom::Point3d.new(ox+12000, oy+42000, 0),
  Geom::Point3d.new(ox+12100, oy+42000, 0),
  Geom::Point3d.new(ox+12100, oy+42100, 0),
  Geom::Point3d.new(ox+12000, oy+42100, 0)
]
f_30 = ents.add_face(pts_30)
f_30.material = mat_c40_50_assumed if f_30
f_30.layer = layers['cols'] if f_30
f_30.pushpull(5500) if f_30
# Column 32: WS1-H5.5-90MIN
pts_31 = [
  Geom::Point3d.new(ox+18000, oy+42000, 0),
  Geom::Point3d.new(ox+18100, oy+42000, 0),
  Geom::Point3d.new(ox+18100, oy+42100, 0),
  Geom::Point3d.new(ox+18000, oy+42100, 0)
]
f_31 = ents.add_face(pts_31)
f_31.material = mat_c40_50_assumed if f_31
f_31.layer = layers['cols'] if f_31
f_31.pushpull(5500) if f_31
# Column 33: WS1-H5.5-120MIN
pts_32 = [
  Geom::Point3d.new(ox+0, oy+48000, 0),
  Geom::Point3d.new(ox+100, oy+48000, 0),
  Geom::Point3d.new(ox+100, oy+48100, 0),
  Geom::Point3d.new(ox+0, oy+48100, 0)
]
f_32 = ents.add_face(pts_32)
f_32.material = mat_c40_50_assumed if f_32
f_32.layer = layers['cols'] if f_32
f_32.pushpull(5500) if f_32
# Column 34: WS1-H5.0-NOFRL
pts_33 = [
  Geom::Point3d.new(ox+6000, oy+48000, 0),
  Geom::Point3d.new(ox+6100, oy+48000, 0),
  Geom::Point3d.new(ox+6100, oy+48100, 0),
  Geom::Point3d.new(ox+6000, oy+48100, 0)
]
f_33 = ents.add_face(pts_33)
f_33.material = mat_c40_50_assumed if f_33
f_33.layer = layers['cols'] if f_33
f_33.pushpull(5000) if f_33
# Column 35: WS1-H5.0-60MIN
pts_34 = [
  Geom::Point3d.new(ox+12000, oy+48000, 0),
  Geom::Point3d.new(ox+12100, oy+48000, 0),
  Geom::Point3d.new(ox+12100, oy+48100, 0),
  Geom::Point3d.new(ox+12000, oy+48100, 0)
]
f_34 = ents.add_face(pts_34)
f_34.material = mat_c40_50_assumed if f_34
f_34.layer = layers['cols'] if f_34
f_34.pushpull(5000) if f_34
# Column 36: WS1-H5.0-90MIN
pts_35 = [
  Geom::Point3d.new(ox+18000, oy+48000, 0),
  Geom::Point3d.new(ox+18100, oy+48000, 0),
  Geom::Point3d.new(ox+18100, oy+48100, 0),
  Geom::Point3d.new(ox+18000, oy+48100, 0)
]
f_35 = ents.add_face(pts_35)
f_35.material = mat_c40_50_assumed if f_35
f_35.layer = layers['cols'] if f_35
f_35.pushpull(5000) if f_35
# Column 37: WS1-H5.0-120MIN
pts_36 = [
  Geom::Point3d.new(ox+0, oy+54000, 0),
  Geom::Point3d.new(ox+100, oy+54000, 0),
  Geom::Point3d.new(ox+100, oy+54100, 0),
  Geom::Point3d.new(ox+0, oy+54100, 0)
]
f_36 = ents.add_face(pts_36)
f_36.material = mat_c40_50_assumed if f_36
f_36.layer = layers['cols'] if f_36
f_36.pushpull(5000) if f_36
# Column 38: WS1-H4.5-NOFRL
pts_37 = [
  Geom::Point3d.new(ox+6000, oy+54000, 0),
  Geom::Point3d.new(ox+6100, oy+54000, 0),
  Geom::Point3d.new(ox+6100, oy+54100, 0),
  Geom::Point3d.new(ox+6000, oy+54100, 0)
]
f_37 = ents.add_face(pts_37)
f_37.material = mat_c40_50_assumed if f_37
f_37.layer = layers['cols'] if f_37
f_37.pushpull(4500) if f_37
# Column 39: WS1-H4.5-60MIN
pts_38 = [
  Geom::Point3d.new(ox+12000, oy+54000, 0),
  Geom::Point3d.new(ox+12100, oy+54000, 0),
  Geom::Point3d.new(ox+12100, oy+54100, 0),
  Geom::Point3d.new(ox+12000, oy+54100, 0)
]
f_38 = ents.add_face(pts_38)
f_38.material = mat_c40_50_assumed if f_38
f_38.layer = layers['cols'] if f_38
f_38.pushpull(4500) if f_38
# Column 40: WS1-H4.5-90MIN
pts_39 = [
  Geom::Point3d.new(ox+18000, oy+54000, 0),
  Geom::Point3d.new(ox+18100, oy+54000, 0),
  Geom::Point3d.new(ox+18100, oy+54100, 0),
  Geom::Point3d.new(ox+18000, oy+54100, 0)
]
f_39 = ents.add_face(pts_39)
f_39.material = mat_c40_50_assumed if f_39
f_39.layer = layers['cols'] if f_39
f_39.pushpull(4500) if f_39
# Column 41: WS1-H4.5-120MIN
pts_40 = [
  Geom::Point3d.new(ox+0, oy+60000, 0),
  Geom::Point3d.new(ox+100, oy+60000, 0),
  Geom::Point3d.new(ox+100, oy+60100, 0),
  Geom::Point3d.new(ox+0, oy+60100, 0)
]
f_40 = ents.add_face(pts_40)
f_40.material = mat_c40_50_assumed if f_40
f_40.layer = layers['cols'] if f_40
f_40.pushpull(4500) if f_40
# Column 42: WS1-H4.0-NOFRL
pts_41 = [
  Geom::Point3d.new(ox+6000, oy+60000, 0),
  Geom::Point3d.new(ox+6100, oy+60000, 0),
  Geom::Point3d.new(ox+6100, oy+60100, 0),
  Geom::Point3d.new(ox+6000, oy+60100, 0)
]
f_41 = ents.add_face(pts_41)
f_41.material = mat_c40_50_assumed if f_41
f_41.layer = layers['cols'] if f_41
f_41.pushpull(4000) if f_41
# Column 43: WS1-H4.0-60MIN
pts_42 = [
  Geom::Point3d.new(ox+12000, oy+60000, 0),
  Geom::Point3d.new(ox+12100, oy+60000, 0),
  Geom::Point3d.new(ox+12100, oy+60100, 0),
  Geom::Point3d.new(ox+12000, oy+60100, 0)
]
f_42 = ents.add_face(pts_42)
f_42.material = mat_c40_50_assumed if f_42
f_42.layer = layers['cols'] if f_42
f_42.pushpull(4000) if f_42
# Column 44: WS1-H4.0-90MIN
pts_43 = [
  Geom::Point3d.new(ox+18000, oy+60000, 0),
  Geom::Point3d.new(ox+18100, oy+60000, 0),
  Geom::Point3d.new(ox+18100, oy+60100, 0),
  Geom::Point3d.new(ox+18000, oy+60100, 0)
]
f_43 = ents.add_face(pts_43)
f_43.material = mat_c40_50_assumed if f_43
f_43.layer = layers['cols'] if f_43
f_43.pushpull(4000) if f_43
# Column 45: WS1-H4.0-120MIN
pts_44 = [
  Geom::Point3d.new(ox+0, oy+66000, 0),
  Geom::Point3d.new(ox+100, oy+66000, 0),
  Geom::Point3d.new(ox+100, oy+66100, 0),
  Geom::Point3d.new(ox+0, oy+66100, 0)
]
f_44 = ents.add_face(pts_44)
f_44.material = mat_c40_50_assumed if f_44
f_44.layer = layers['cols'] if f_44
f_44.pushpull(4000) if f_44
# Column 46: WS1-H3.5-NOFRL
pts_45 = [
  Geom::Point3d.new(ox+6000, oy+66000, 0),
  Geom::Point3d.new(ox+6100, oy+66000, 0),
  Geom::Point3d.new(ox+6100, oy+66100, 0),
  Geom::Point3d.new(ox+6000, oy+66100, 0)
]
f_45 = ents.add_face(pts_45)
f_45.material = mat_c40_50_assumed if f_45
f_45.layer = layers['cols'] if f_45
f_45.pushpull(3500) if f_45
# Column 47: WS1-H3.5-60MIN
pts_46 = [
  Geom::Point3d.new(ox+12000, oy+66000, 0),
  Geom::Point3d.new(ox+12100, oy+66000, 0),
  Geom::Point3d.new(ox+12100, oy+66100, 0),
  Geom::Point3d.new(ox+12000, oy+66100, 0)
]
f_46 = ents.add_face(pts_46)
f_46.material = mat_c40_50_assumed if f_46
f_46.layer = layers['cols'] if f_46
f_46.pushpull(3500) if f_46
# Column 48: WS1-H3.5-90MIN
pts_47 = [
  Geom::Point3d.new(ox+18000, oy+66000, 0),
  Geom::Point3d.new(ox+18100, oy+66000, 0),
  Geom::Point3d.new(ox+18100, oy+66100, 0),
  Geom::Point3d.new(ox+18000, oy+66100, 0)
]
f_47 = ents.add_face(pts_47)
f_47.material = mat_c40_50_assumed if f_47
f_47.layer = layers['cols'] if f_47
f_47.pushpull(3500) if f_47
# Column 49: WS1-H3.5-120MIN
pts_48 = [
  Geom::Point3d.new(ox+0, oy+72000, 0),
  Geom::Point3d.new(ox+100, oy+72000, 0),
  Geom::Point3d.new(ox+100, oy+72100, 0),
  Geom::Point3d.new(ox+0, oy+72100, 0)
]
f_48 = ents.add_face(pts_48)
f_48.material = mat_c40_50_assumed if f_48
f_48.layer = layers['cols'] if f_48
f_48.pushpull(3500) if f_48
# Column 50: WS1-H3.0-NOFRL
pts_49 = [
  Geom::Point3d.new(ox+6000, oy+72000, 0),
  Geom::Point3d.new(ox+6100, oy+72000, 0),
  Geom::Point3d.new(ox+6100, oy+72100, 0),
  Geom::Point3d.new(ox+6000, oy+72100, 0)
]
f_49 = ents.add_face(pts_49)
f_49.material = mat_c40_50_assumed if f_49
f_49.layer = layers['cols'] if f_49
f_49.pushpull(3000) if f_49
# Column 51: WS1-H3.0-60MIN
pts_50 = [
  Geom::Point3d.new(ox+12000, oy+72000, 0),
  Geom::Point3d.new(ox+12100, oy+72000, 0),
  Geom::Point3d.new(ox+12100, oy+72100, 0),
  Geom::Point3d.new(ox+12000, oy+72100, 0)
]
f_50 = ents.add_face(pts_50)
f_50.material = mat_c40_50_assumed if f_50
f_50.layer = layers['cols'] if f_50
f_50.pushpull(3000) if f_50
# Column 52: WS1-H3.0-90MIN
pts_51 = [
  Geom::Point3d.new(ox+18000, oy+72000, 0),
  Geom::Point3d.new(ox+18100, oy+72000, 0),
  Geom::Point3d.new(ox+18100, oy+72100, 0),
  Geom::Point3d.new(ox+18000, oy+72100, 0)
]
f_51 = ents.add_face(pts_51)
f_51.material = mat_c40_50_assumed if f_51
f_51.layer = layers['cols'] if f_51
f_51.pushpull(3000) if f_51
# Column 53: WS1-H3.0-120MIN
pts_52 = [
  Geom::Point3d.new(ox+0, oy+78000, 0),
  Geom::Point3d.new(ox+100, oy+78000, 0),
  Geom::Point3d.new(ox+100, oy+78100, 0),
  Geom::Point3d.new(ox+0, oy+78100, 0)
]
f_52 = ents.add_face(pts_52)
f_52.material = mat_c40_50_assumed if f_52
f_52.layer = layers['cols'] if f_52
f_52.pushpull(3000) if f_52
# Column 54: WS1-H2.6-NOFRL
pts_53 = [
  Geom::Point3d.new(ox+6000, oy+78000, 0),
  Geom::Point3d.new(ox+6100, oy+78000, 0),
  Geom::Point3d.new(ox+6100, oy+78100, 0),
  Geom::Point3d.new(ox+6000, oy+78100, 0)
]
f_53 = ents.add_face(pts_53)
f_53.material = mat_c40_50_assumed if f_53
f_53.layer = layers['cols'] if f_53
f_53.pushpull(2600) if f_53
# Column 55: WS1-H2.6-60MIN
pts_54 = [
  Geom::Point3d.new(ox+12000, oy+78000, 0),
  Geom::Point3d.new(ox+12100, oy+78000, 0),
  Geom::Point3d.new(ox+12100, oy+78100, 0),
  Geom::Point3d.new(ox+12000, oy+78100, 0)
]
f_54 = ents.add_face(pts_54)
f_54.material = mat_c40_50_assumed if f_54
f_54.layer = layers['cols'] if f_54
f_54.pushpull(2600) if f_54
# Column 56: WS1-H2.6-90MIN
pts_55 = [
  Geom::Point3d.new(ox+18000, oy+78000, 0),
  Geom::Point3d.new(ox+18100, oy+78000, 0),
  Geom::Point3d.new(ox+18100, oy+78100, 0),
  Geom::Point3d.new(ox+18000, oy+78100, 0)
]
f_55 = ents.add_face(pts_55)
f_55.material = mat_c40_50_assumed if f_55
f_55.layer = layers['cols'] if f_55
f_55.pushpull(2600) if f_55
# Column 57: WS1-H2.6-120MIN
pts_56 = [
  Geom::Point3d.new(ox+0, oy+84000, 0),
  Geom::Point3d.new(ox+100, oy+84000, 0),
  Geom::Point3d.new(ox+100, oy+84100, 0),
  Geom::Point3d.new(ox+0, oy+84100, 0)
]
f_56 = ents.add_face(pts_56)
f_56.material = mat_c40_50_assumed if f_56
f_56.layer = layers['cols'] if f_56
f_56.pushpull(2600) if f_56
# Column 58: WS3-H6.0-180-240MIN
pts_57 = [
  Geom::Point3d.new(ox+6000, oy+84000, 0),
  Geom::Point3d.new(ox+6100, oy+84000, 0),
  Geom::Point3d.new(ox+6100, oy+84100, 0),
  Geom::Point3d.new(ox+6000, oy+84100, 0)
]
f_57 = ents.add_face(pts_57)
f_57.material = mat_c40_50_assumed if f_57
f_57.layer = layers['cols'] if f_57
f_57.pushpull(6000) if f_57
# Column 59: WS3-H5.5-180-240MIN
pts_58 = [
  Geom::Point3d.new(ox+12000, oy+84000, 0),
  Geom::Point3d.new(ox+12100, oy+84000, 0),
  Geom::Point3d.new(ox+12100, oy+84100, 0),
  Geom::Point3d.new(ox+12000, oy+84100, 0)
]
f_58 = ents.add_face(pts_58)
f_58.material = mat_c40_50_assumed if f_58
f_58.layer = layers['cols'] if f_58
f_58.pushpull(5500) if f_58
# Column 60: WS3-H5.0-180-240MIN
pts_59 = [
  Geom::Point3d.new(ox+18000, oy+84000, 0),
  Geom::Point3d.new(ox+18100, oy+84000, 0),
  Geom::Point3d.new(ox+18100, oy+84100, 0),
  Geom::Point3d.new(ox+18000, oy+84100, 0)
]
f_59 = ents.add_face(pts_59)
f_59.material = mat_c40_50_assumed if f_59
f_59.layer = layers['cols'] if f_59
f_59.pushpull(5000) if f_59
# Column 61: WS3-H4.5-180-240MIN
pts_60 = [
  Geom::Point3d.new(ox+0, oy+90000, 0),
  Geom::Point3d.new(ox+100, oy+90000, 0),
  Geom::Point3d.new(ox+100, oy+90100, 0),
  Geom::Point3d.new(ox+0, oy+90100, 0)
]
f_60 = ents.add_face(pts_60)
f_60.material = mat_c40_50_assumed if f_60
f_60.layer = layers['cols'] if f_60
f_60.pushpull(4500) if f_60
# Column 62: WS3-H4.0-180-240MIN
pts_61 = [
  Geom::Point3d.new(ox+6000, oy+90000, 0),
  Geom::Point3d.new(ox+6100, oy+90000, 0),
  Geom::Point3d.new(ox+6100, oy+90100, 0),
  Geom::Point3d.new(ox+6000, oy+90100, 0)
]
f_61 = ents.add_face(pts_61)
f_61.material = mat_c40_50_assumed if f_61
f_61.layer = layers['cols'] if f_61
f_61.pushpull(4000) if f_61
# Column 63: WS3-H3.5-180-240MIN
pts_62 = [
  Geom::Point3d.new(ox+12000, oy+90000, 0),
  Geom::Point3d.new(ox+12100, oy+90000, 0),
  Geom::Point3d.new(ox+12100, oy+90100, 0),
  Geom::Point3d.new(ox+12000, oy+90100, 0)
]
f_62 = ents.add_face(pts_62)
f_62.material = mat_c40_50_assumed if f_62
f_62.layer = layers['cols'] if f_62
f_62.pushpull(3500) if f_62
# Column 64: WS3-H3.0-180-240MIN
pts_63 = [
  Geom::Point3d.new(ox+18000, oy+90000, 0),
  Geom::Point3d.new(ox+18100, oy+90000, 0),
  Geom::Point3d.new(ox+18100, oy+90100, 0),
  Geom::Point3d.new(ox+18000, oy+90100, 0)
]
f_63 = ents.add_face(pts_63)
f_63.material = mat_c40_50_assumed if f_63
f_63.layer = layers['cols'] if f_63
f_63.pushpull(3000) if f_63
# Column 65: WS3-H2.6-180-240MIN
pts_64 = [
  Geom::Point3d.new(ox+0, oy+96000, 0),
  Geom::Point3d.new(ox+100, oy+96000, 0),
  Geom::Point3d.new(ox+100, oy+96100, 0),
  Geom::Point3d.new(ox+0, oy+96100, 0)
]
f_64 = ents.add_face(pts_64)
f_64.material = mat_c40_50_assumed if f_64
f_64.layer = layers['cols'] if f_64
f_64.pushpull(2600) if f_64
# Column 66: WS2-H7.0-NOFRL
pts_65 = [
  Geom::Point3d.new(ox+6000, oy+96000, 0),
  Geom::Point3d.new(ox+6100, oy+96000, 0),
  Geom::Point3d.new(ox+6100, oy+96100, 0),
  Geom::Point3d.new(ox+6000, oy+96100, 0)
]
f_65 = ents.add_face(pts_65)
f_65.material = mat_c40_50_assumed if f_65
f_65.layer = layers['cols'] if f_65
f_65.pushpull(3500) if f_65

# === Beams ===
# Beam 1: SH20a →
bx1_0 = ox + 0; by1_0 = oy + 0
bx2_0 = ox + 6000; by2_0 = oy + 0
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
    Geom::Point3d.new(blen_0, 200, 0),
    Geom::Point3d.new(0, 200, 0)
  ]
  bf_0 = bg_0.entities.add_face(pts_0)
  bf_0.material = mat_c40_50_assumed if bf_0
  bf_0.pushpull(-200) if bf_0
  bg_0.layer = layers['beams']
end
# Beam 2: Z25d →
bx1_1 = ox + 6000; by1_1 = oy + 0
bx2_1 = ox + 12000; by2_1 = oy + 0
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
    Geom::Point3d.new(blen_1, 250, 0),
    Geom::Point3d.new(0, 250, 0)
  ]
  bf_1 = bg_1.entities.add_face(pts_1)
  bf_1.material = mat_c40_50_assumed if bf_1
  bf_1.pushpull(-250) if bf_1
  bg_1.layer = layers['beams']
end
# Beam 3: PF20a →
bx1_2 = ox + 12000; by1_2 = oy + 0
bx2_2 = ox + 18000; by2_2 = oy + 0
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
    Geom::Point3d.new(blen_2, 200, 0),
    Geom::Point3d.new(0, 200, 0)
  ]
  bf_2 = bg_2.entities.add_face(pts_2)
  bf_2.material = mat_c40_50_assumed if bf_2
  bf_2.pushpull(-200) if bf_2
  bg_2.layer = layers['beams']
end
# Beam 4: PF25a →
bx1_3 = ox + 0; by1_3 = oy + 6000
bx2_3 = ox + 6000; by2_3 = oy + 6000
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
    Geom::Point3d.new(blen_3, 250, 0),
    Geom::Point3d.new(0, 250, 0)
  ]
  bf_3 = bg_3.entities.add_face(pts_3)
  bf_3.material = mat_c40_50_assumed if bf_3
  bf_3.pushpull(-250) if bf_3
  bg_3.layer = layers['beams']
end
# Beam 5: B1 →
bx1_4 = ox + 6000; by1_4 = oy + 6000
bx2_4 = ox + 12000; by2_4 = oy + 6000
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
    Geom::Point3d.new(blen_4, 300, 0),
    Geom::Point3d.new(0, 300, 0)
  ]
  bf_4 = bg_4.entities.add_face(pts_4)
  bf_4.material = mat_concrete if bf_4
  bf_4.pushpull(-200) if bf_4
  bg_4.layer = layers['beams']
end
# Beam 6: B2 →
bx1_5 = ox + 12000; by1_5 = oy + 6000
bx2_5 = ox + 18000; by2_5 = oy + 6000
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
    Geom::Point3d.new(blen_5, 300, 0),
    Geom::Point3d.new(0, 300, 0)
  ]
  bf_5 = bg_5.entities.add_face(pts_5)
  bf_5.material = mat_concrete if bf_5
  bf_5.pushpull(-200) if bf_5
  bg_5.layer = layers['beams']
end
# Beam 7: B3 →
bx1_6 = ox + 0; by1_6 = oy + 12000
bx2_6 = ox + 6000; by2_6 = oy + 12000
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
    Geom::Point3d.new(blen_6, 300, 0),
    Geom::Point3d.new(0, 300, 0)
  ]
  bf_6 = bg_6.entities.add_face(pts_6)
  bf_6.material = mat_concrete if bf_6
  bf_6.pushpull(-200) if bf_6
  bg_6.layer = layers['beams']
end
# Beam 8: B4 →
bx1_7 = ox + 6000; by1_7 = oy + 12000
bx2_7 = ox + 12000; by2_7 = oy + 12000
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
    Geom::Point3d.new(blen_7, 300, 0),
    Geom::Point3d.new(0, 300, 0)
  ]
  bf_7 = bg_7.entities.add_face(pts_7)
  bf_7.material = mat_concrete if bf_7
  bf_7.pushpull(-200) if bf_7
  bg_7.layer = layers['beams']
end
# Beam 9: B5 →
bx1_8 = ox + 12000; by1_8 = oy + 12000
bx2_8 = ox + 18000; by2_8 = oy + 12000
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
    Geom::Point3d.new(blen_8, 300, 0),
    Geom::Point3d.new(0, 300, 0)
  ]
  bf_8 = bg_8.entities.add_face(pts_8)
  bf_8.material = mat_concrete if bf_8
  bf_8.pushpull(-200) if bf_8
  bg_8.layer = layers['beams']
end
# Beam 10: B6 →
bx1_9 = ox + 0; by1_9 = oy + 18000
bx2_9 = ox + 6000; by2_9 = oy + 18000
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
# Beam 11: B7 →
bx1_10 = ox + 6000; by1_10 = oy + 18000
bx2_10 = ox + 12000; by2_10 = oy + 18000
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
# Beam 12: B8 →
bx1_11 = ox + 12000; by1_11 = oy + 18000
bx2_11 = ox + 18000; by2_11 = oy + 18000
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
# Beam 13: B9 →
bx1_12 = ox + 0; by1_12 = oy + 0
bx2_12 = ox + 0; by2_12 = oy + 6000
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
# Beam 14: B10 →
bx1_13 = ox + 0; by1_13 = oy + 6000
bx2_13 = ox + 0; by2_13 = oy + 12000
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
# Beam 15: B11 →
bx1_14 = ox + 0; by1_14 = oy + 12000
bx2_14 = ox + 0; by2_14 = oy + 18000
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
# Beam 16: B12 →
bx1_15 = ox + 6000; by1_15 = oy + 0
bx2_15 = ox + 6000; by2_15 = oy + 6000
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
# Beam 17: BEAM-CH32a-Detail1 →
bx1_16 = ox + 6000; by1_16 = oy + 6000
bx2_16 = ox + 6000; by2_16 = oy + 12000
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
    Geom::Point3d.new(blen_16, 32, 0),
    Geom::Point3d.new(0, 32, 0)
  ]
  bf_16 = bg_16.entities.add_face(pts_16)
  bf_16.material = mat_steel if bf_16
  bf_16.pushpull(-32) if bf_16
  bg_16.layer = layers['beams']
end
# Beam 18: BEAM-UB36c-Detail2 →
bx1_17 = ox + 6000; by1_17 = oy + 12000
bx2_17 = ox + 6000; by2_17 = oy + 18000
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
    Geom::Point3d.new(blen_17, 36, 0),
    Geom::Point3d.new(0, 36, 0)
  ]
  bf_17 = bg_17.entities.add_face(pts_17)
  bf_17.material = mat_steel if bf_17
  bf_17.pushpull(-36) if bf_17
  bg_17.layer = layers['beams']
end
# Beam 19: BEAM-CH13c-Detail2 →
bx1_18 = ox + 12000; by1_18 = oy + 0
bx2_18 = ox + 12000; by2_18 = oy + 6000
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
    Geom::Point3d.new(blen_18, 13, 0),
    Geom::Point3d.new(0, 13, 0)
  ]
  bf_18 = bg_18.entities.add_face(pts_18)
  bf_18.material = mat_steel if bf_18
  bf_18.pushpull(-13) if bf_18
  bg_18.layer = layers['beams']
end
# Beam 20: BEAM-PF15a-Detail2 →
bx1_19 = ox + 12000; by1_19 = oy + 6000
bx2_19 = ox + 12000; by2_19 = oy + 12000
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
    Geom::Point3d.new(blen_19, 15, 0),
    Geom::Point3d.new(0, 15, 0)
  ]
  bf_19 = bg_19.entities.add_face(pts_19)
  bf_19.material = mat_steel if bf_19
  bf_19.pushpull(-15) if bf_19
  bg_19.layer = layers['beams']
end
# Beam 21: BEAM-SH15b-Detail2 →
bx1_20 = ox + 12000; by1_20 = oy + 12000
bx2_20 = ox + 12000; by2_20 = oy + 18000
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
    Geom::Point3d.new(blen_20, 15, 0),
    Geom::Point3d.new(0, 15, 0)
  ]
  bf_20 = bg_20.entities.add_face(pts_20)
  bf_20.material = mat_steel if bf_20
  bf_20.pushpull(-15) if bf_20
  bg_20.layer = layers['beams']
end
# Beam 22: BEAM-PF25a-Detail2A →
bx1_21 = ox + 18000; by1_21 = oy + 0
bx2_21 = ox + 18000; by2_21 = oy + 6000
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
    Geom::Point3d.new(blen_21, 25, 0),
    Geom::Point3d.new(0, 25, 0)
  ]
  bf_21 = bg_21.entities.add_face(pts_21)
  bf_21.material = mat_steel if bf_21
  bf_21.pushpull(-25) if bf_21
  bg_21.layer = layers['beams']
end
# Beam 23: BEAM-PF25a-Detail3 →
bx1_22 = ox + 18000; by1_22 = oy + 6000
bx2_22 = ox + 18000; by2_22 = oy + 12000
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
    Geom::Point3d.new(blen_22, 25, 0),
    Geom::Point3d.new(0, 25, 0)
  ]
  bf_22 = bg_22.entities.add_face(pts_22)
  bf_22.material = mat_steel if bf_22
  bf_22.pushpull(-25) if bf_22
  bg_22.layer = layers['beams']
end
# Beam 24: Z10 →
bx1_23 = ox + 18000; by1_23 = oy + 12000
bx2_23 = ox + 18000; by2_23 = oy + 18000
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
    Geom::Point3d.new(blen_23, 10, 0),
    Geom::Point3d.new(0, 10, 0)
  ]
  bf_23 = bg_23.entities.add_face(pts_23)
  bf_23.material = mat_c40_50_assumed if bf_23
  bf_23.pushpull(-10) if bf_23
  bg_23.layer = layers['beams']
end
# Beam 25: Z15 →
bx1_24 = ox + 0; by1_24 = oy + 0
bx2_24 = ox + 6000; by2_24 = oy + 0
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
    Geom::Point3d.new(blen_24, 15, 0),
    Geom::Point3d.new(0, 15, 0)
  ]
  bf_24 = bg_24.entities.add_face(pts_24)
  bf_24.material = mat_c40_50_assumed if bf_24
  bf_24.pushpull(-15) if bf_24
  bg_24.layer = layers['beams']
end
# Beam 26: Z20 →
bx1_25 = ox + 6000; by1_25 = oy + 0
bx2_25 = ox + 12000; by2_25 = oy + 0
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
    Geom::Point3d.new(blen_25, 20, 0),
    Geom::Point3d.new(0, 20, 0)
  ]
  bf_25 = bg_25.entities.add_face(pts_25)
  bf_25.material = mat_c40_50_assumed if bf_25
  bf_25.pushpull(-20) if bf_25
  bg_25.layer = layers['beams']
end
# Beam 27: Z25 →
bx1_26 = ox + 12000; by1_26 = oy + 0
bx2_26 = ox + 18000; by2_26 = oy + 0
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
    Geom::Point3d.new(blen_26, 25, 0),
    Geom::Point3d.new(0, 25, 0)
  ]
  bf_26 = bg_26.entities.add_face(pts_26)
  bf_26.material = mat_c40_50_assumed if bf_26
  bf_26.pushpull(-25) if bf_26
  bg_26.layer = layers['beams']
end
# Beam 28: Z30 →
bx1_27 = ox + 0; by1_27 = oy + 6000
bx2_27 = ox + 6000; by2_27 = oy + 6000
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
    Geom::Point3d.new(blen_27, 30, 0),
    Geom::Point3d.new(0, 30, 0)
  ]
  bf_27 = bg_27.entities.add_face(pts_27)
  bf_27.material = mat_c40_50_assumed if bf_27
  bf_27.pushpull(-30) if bf_27
  bg_27.layer = layers['beams']
end
# Beam 29: Z35 →
bx1_28 = ox + 6000; by1_28 = oy + 6000
bx2_28 = ox + 12000; by2_28 = oy + 6000
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
    Geom::Point3d.new(blen_28, 35, 0),
    Geom::Point3d.new(0, 35, 0)
  ]
  bf_28 = bg_28.entities.add_face(pts_28)
  bf_28.material = mat_c40_50_assumed if bf_28
  bf_28.pushpull(-35) if bf_28
  bg_28.layer = layers['beams']
end
# Beam 30: C10 →
bx1_29 = ox + 12000; by1_29 = oy + 6000
bx2_29 = ox + 18000; by2_29 = oy + 6000
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
    Geom::Point3d.new(blen_29, 10, 0),
    Geom::Point3d.new(0, 10, 0)
  ]
  bf_29 = bg_29.entities.add_face(pts_29)
  bf_29.material = mat_c40_50_assumed if bf_29
  bf_29.pushpull(-10) if bf_29
  bg_29.layer = layers['beams']
end
# Beam 31: C15 →
bx1_30 = ox + 0; by1_30 = oy + 12000
bx2_30 = ox + 6000; by2_30 = oy + 12000
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
    Geom::Point3d.new(blen_30, 15, 0),
    Geom::Point3d.new(0, 15, 0)
  ]
  bf_30 = bg_30.entities.add_face(pts_30)
  bf_30.material = mat_c40_50_assumed if bf_30
  bf_30.pushpull(-15) if bf_30
  bg_30.layer = layers['beams']
end
# Beam 32: C20 →
bx1_31 = ox + 6000; by1_31 = oy + 12000
bx2_31 = ox + 12000; by2_31 = oy + 12000
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
  bf_31.material = mat_c40_50_assumed if bf_31
  bf_31.pushpull(-20) if bf_31
  bg_31.layer = layers['beams']
end
# Beam 33: C25 →
bx1_32 = ox + 12000; by1_32 = oy + 12000
bx2_32 = ox + 18000; by2_32 = oy + 12000
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
    Geom::Point3d.new(blen_32, 25, 0),
    Geom::Point3d.new(0, 25, 0)
  ]
  bf_32 = bg_32.entities.add_face(pts_32)
  bf_32.material = mat_c40_50_assumed if bf_32
  bf_32.pushpull(-25) if bf_32
  bg_32.layer = layers['beams']
end
# Beam 34: C30 →
bx1_33 = ox + 0; by1_33 = oy + 18000
bx2_33 = ox + 6000; by2_33 = oy + 18000
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
    Geom::Point3d.new(blen_33, 30, 0),
    Geom::Point3d.new(0, 30, 0)
  ]
  bf_33 = bg_33.entities.add_face(pts_33)
  bf_33.material = mat_c40_50_assumed if bf_33
  bf_33.pushpull(-30) if bf_33
  bg_33.layer = layers['beams']
end
# Beam 35: C35 →
bx1_34 = ox + 6000; by1_34 = oy + 18000
bx2_34 = ox + 12000; by2_34 = oy + 18000
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
    Geom::Point3d.new(blen_34, 35, 0),
    Geom::Point3d.new(0, 35, 0)
  ]
  bf_34 = bg_34.entities.add_face(pts_34)
  bf_34.material = mat_c40_50_assumed if bf_34
  bf_34.pushpull(-35) if bf_34
  bg_34.layer = layers['beams']
end
# Beam 36: CB1 →
bx1_35 = ox + 12000; by1_35 = oy + 18000
bx2_35 = ox + 18000; by2_35 = oy + 18000
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
    Geom::Point3d.new(blen_35, 600, 0),
    Geom::Point3d.new(0, 600, 0)
  ]
  bf_35 = bg_35.entities.add_face(pts_35)
  bf_35.material = mat_c40_50_assumed if bf_35
  bf_35.pushpull(-750) if bf_35
  bg_35.layer = layers['beams']
end

# === Slabs ===
# Slab 1: S_AUTO_Ground Level
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
# Slab 2: S_AUTO_Level 01
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
# Slab 3: S_AUTO_Level 02
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
# Slab 4: S_AUTO_Level 03
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
# Slab 5: S_AUTO_Level 04
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
# Slab 6: S_AUTO_Level 05
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
# Slab 7: S_AUTO_Lower Roof
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
# Slab 8: S_AUTO_Upper Roof
pts_7 = [
  Geom::Point3d.new(ox, oy, 0),
  Geom::Point3d.new(ox+24000, oy, 0),
  Geom::Point3d.new(ox+24000, oy+24000, 0),
  Geom::Point3d.new(ox, oy+24000, 0)
]
f_7 = ents.add_face(pts_7)
f_7.material = mat_reinforced_concrete if f_7
f_7.layer = layers['slabs'] if f_7
f_7.pushpull(-200) if f_7

# === Footings ===
# Footing 1: P1 (pile)
pts_0 = [
  Geom::Point3d.new(ox+-300, oy+23700, -1600),
  Geom::Point3d.new(ox+300, oy+23700, -1600),
  Geom::Point3d.new(ox+300, oy+24300, -1600),
  Geom::Point3d.new(ox+-300, oy+24300, -1600)
]
f_0 = ents.add_face(pts_0)
f_0.material = mat_c40_50_assumed if f_0
f_0.layer = layers['ftgs'] if f_0
f_0.pushpull(600) if f_0
# Footing 2: P2 (pile)
pts_1 = [
  Geom::Point3d.new(ox+3700, oy+4700, -3000),
  Geom::Point3d.new(ox+4300, oy+4700, -3000),
  Geom::Point3d.new(ox+4300, oy+5300, -3000),
  Geom::Point3d.new(ox+3700, oy+5300, -3000)
]
f_1 = ents.add_face(pts_1)
f_1.material = mat_c40_50_assumed if f_1
f_1.layer = layers['ftgs'] if f_1
f_1.pushpull(2000) if f_1
# Footing 3: P3 (pile)
pts_2 = [
  Geom::Point3d.new(ox+5700, oy+23700, -1300),
  Geom::Point3d.new(ox+6300, oy+23700, -1300),
  Geom::Point3d.new(ox+6300, oy+24300, -1300),
  Geom::Point3d.new(ox+5700, oy+24300, -1300)
]
f_2 = ents.add_face(pts_2)
f_2.material = mat_c40_50_assumed if f_2
f_2.layer = layers['ftgs'] if f_2
f_2.pushpull(300) if f_2
# Footing 4: P4 (pile)
pts_3 = [
  Geom::Point3d.new(ox+9700, oy+4700, -3000),
  Geom::Point3d.new(ox+10300, oy+4700, -3000),
  Geom::Point3d.new(ox+10300, oy+5300, -3000),
  Geom::Point3d.new(ox+9700, oy+5300, -3000)
]
f_3 = ents.add_face(pts_3)
f_3.material = mat_c40_50_assumed if f_3
f_3.layer = layers['ftgs'] if f_3
f_3.pushpull(2000) if f_3
# Footing 5: P5 (pile)
pts_4 = [
  Geom::Point3d.new(ox+11700, oy+47700, -3000),
  Geom::Point3d.new(ox+12300, oy+47700, -3000),
  Geom::Point3d.new(ox+12300, oy+48300, -3000),
  Geom::Point3d.new(ox+11700, oy+48300, -3000)
]
f_4 = ents.add_face(pts_4)
f_4.material = mat_c40_50_assumed if f_4
f_4.layer = layers['ftgs'] if f_4
f_4.pushpull(2000) if f_4
# Footing 6: RF1 (raft)
pts_5 = [
  Geom::Point3d.new(ox+9700, oy+6750, -2000),
  Geom::Point3d.new(ox+15300, oy+6750, -2000),
  Geom::Point3d.new(ox+15300, oy+13250, -2000),
  Geom::Point3d.new(ox+9700, oy+13250, -2000)
]
f_5 = ents.add_face(pts_5)
f_5.material = mat_c40_50_assumed if f_5
f_5.layer = layers['ftgs'] if f_5
f_5.pushpull(1000) if f_5

# === LOD350 Connections ===
layers['conns'] = model.layers.add('Connections_LOD350')
mat_steel_plate = model.materials.add('SteelPlate')
mat_steel_plate.color = Sketchup::Color.new(140,140,160)
# LOD350 base+cap plates: col 1
begin
  bplate_0_pts = [
    Geom::Point3d.new(ox+-230, oy+-230, -20),
    Geom::Point3d.new(ox+230, oy+-230, -20),
    Geom::Point3d.new(ox+230, oy+230, -20),
    Geom::Point3d.new(ox+-230, oy+230, -20)
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
    Geom::Point3d.new(ox+-230, oy+-230, 3500),
    Geom::Point3d.new(ox+230, oy+-230, 3500),
    Geom::Point3d.new(ox+230, oy+230, 3500),
    Geom::Point3d.new(ox+-230, oy+230, 3500)
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
    Geom::Point3d.new(ox+5770, oy+-230, -20),
    Geom::Point3d.new(ox+6230, oy+-230, -20),
    Geom::Point3d.new(ox+6230, oy+230, -20),
    Geom::Point3d.new(ox+5770, oy+230, -20)
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
    Geom::Point3d.new(ox+5770, oy+-230, 3500),
    Geom::Point3d.new(ox+6230, oy+-230, 3500),
    Geom::Point3d.new(ox+6230, oy+230, 3500),
    Geom::Point3d.new(ox+5770, oy+230, 3500)
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
    Geom::Point3d.new(ox+-150, oy+23850, -20),
    Geom::Point3d.new(ox+150, oy+23850, -20),
    Geom::Point3d.new(ox+150, oy+24150, -20),
    Geom::Point3d.new(ox+-150, oy+24150, -20)
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
    Geom::Point3d.new(ox+-150, oy+23850, 3500),
    Geom::Point3d.new(ox+150, oy+23850, 3500),
    Geom::Point3d.new(ox+150, oy+24150, 3500),
    Geom::Point3d.new(ox+-150, oy+24150, 3500)
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
    Geom::Point3d.new(ox+5850, oy+23850, -20),
    Geom::Point3d.new(ox+6150, oy+23850, -20),
    Geom::Point3d.new(ox+6150, oy+24150, -20),
    Geom::Point3d.new(ox+5850, oy+24150, -20)
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
    Geom::Point3d.new(ox+5850, oy+23850, 3500),
    Geom::Point3d.new(ox+6150, oy+23850, 3500),
    Geom::Point3d.new(ox+6150, oy+24150, 3500),
    Geom::Point3d.new(ox+5850, oy+24150, 3500)
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
    Geom::Point3d.new(ox+11850, oy+23850, -20),
    Geom::Point3d.new(ox+12150, oy+23850, -20),
    Geom::Point3d.new(ox+12150, oy+24150, -20),
    Geom::Point3d.new(ox+11850, oy+24150, -20)
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
    Geom::Point3d.new(ox+11850, oy+23850, 3500),
    Geom::Point3d.new(ox+12150, oy+23850, 3500),
    Geom::Point3d.new(ox+12150, oy+24150, 3500),
    Geom::Point3d.new(ox+11850, oy+24150, 3500)
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
    Geom::Point3d.new(ox+17850, oy+23850, -20),
    Geom::Point3d.new(ox+18150, oy+23850, -20),
    Geom::Point3d.new(ox+18150, oy+24150, -20),
    Geom::Point3d.new(ox+17850, oy+24150, -20)
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
    Geom::Point3d.new(ox+17850, oy+23850, 3500),
    Geom::Point3d.new(ox+18150, oy+23850, 3500),
    Geom::Point3d.new(ox+18150, oy+24150, 3500),
    Geom::Point3d.new(ox+17850, oy+24150, 3500)
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
    Geom::Point3d.new(ox+-150, oy+23850, -20),
    Geom::Point3d.new(ox+150, oy+23850, -20),
    Geom::Point3d.new(ox+150, oy+24150, -20),
    Geom::Point3d.new(ox+-150, oy+24150, -20)
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
    Geom::Point3d.new(ox+-150, oy+23850, 3500),
    Geom::Point3d.new(ox+150, oy+23850, 3500),
    Geom::Point3d.new(ox+150, oy+24150, 3500),
    Geom::Point3d.new(ox+-150, oy+24150, 3500)
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
    Geom::Point3d.new(ox+5850, oy+23850, -20),
    Geom::Point3d.new(ox+6150, oy+23850, -20),
    Geom::Point3d.new(ox+6150, oy+24150, -20),
    Geom::Point3d.new(ox+5850, oy+24150, -20)
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
    Geom::Point3d.new(ox+5850, oy+23850, 3500),
    Geom::Point3d.new(ox+6150, oy+23850, 3500),
    Geom::Point3d.new(ox+6150, oy+24150, 3500),
    Geom::Point3d.new(ox+5850, oy+24150, 3500)
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
    Geom::Point3d.new(ox+11850, oy+23850, -20),
    Geom::Point3d.new(ox+12150, oy+23850, -20),
    Geom::Point3d.new(ox+12150, oy+24150, -20),
    Geom::Point3d.new(ox+11850, oy+24150, -20)
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
    Geom::Point3d.new(ox+11850, oy+23850, 3500),
    Geom::Point3d.new(ox+12150, oy+23850, 3500),
    Geom::Point3d.new(ox+12150, oy+24150, 3500),
    Geom::Point3d.new(ox+11850, oy+24150, 3500)
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
    Geom::Point3d.new(ox+17850, oy+23850, -20),
    Geom::Point3d.new(ox+18150, oy+23850, -20),
    Geom::Point3d.new(ox+18150, oy+24150, -20),
    Geom::Point3d.new(ox+17850, oy+24150, -20)
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
    Geom::Point3d.new(ox+17850, oy+23850, 3500),
    Geom::Point3d.new(ox+18150, oy+23850, 3500),
    Geom::Point3d.new(ox+18150, oy+24150, 3500),
    Geom::Point3d.new(ox+17850, oy+24150, 3500)
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
    Geom::Point3d.new(ox+3850, oy+10850, -20),
    Geom::Point3d.new(ox+4150, oy+10850, -20),
    Geom::Point3d.new(ox+4150, oy+11150, -20),
    Geom::Point3d.new(ox+3850, oy+11150, -20)
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
    Geom::Point3d.new(ox+3850, oy+10850, 3500),
    Geom::Point3d.new(ox+4150, oy+10850, 3500),
    Geom::Point3d.new(ox+4150, oy+11150, 3500),
    Geom::Point3d.new(ox+3850, oy+11150, 3500)
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
    Geom::Point3d.new(ox+9850, oy+10850, -20),
    Geom::Point3d.new(ox+10150, oy+10850, -20),
    Geom::Point3d.new(ox+10150, oy+11150, -20),
    Geom::Point3d.new(ox+9850, oy+11150, -20)
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
    Geom::Point3d.new(ox+9850, oy+10850, 3500),
    Geom::Point3d.new(ox+10150, oy+10850, 3500),
    Geom::Point3d.new(ox+10150, oy+11150, 3500),
    Geom::Point3d.new(ox+9850, oy+11150, 3500)
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
    Geom::Point3d.new(ox+15850, oy+10850, -20),
    Geom::Point3d.new(ox+16150, oy+10850, -20),
    Geom::Point3d.new(ox+16150, oy+11150, -20),
    Geom::Point3d.new(ox+15850, oy+11150, -20)
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
    Geom::Point3d.new(ox+15850, oy+10850, 3500),
    Geom::Point3d.new(ox+16150, oy+10850, 3500),
    Geom::Point3d.new(ox+16150, oy+11150, 3500),
    Geom::Point3d.new(ox+15850, oy+11150, 3500)
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
    Geom::Point3d.new(ox+21850, oy+10850, -20),
    Geom::Point3d.new(ox+22150, oy+10850, -20),
    Geom::Point3d.new(ox+22150, oy+11150, -20),
    Geom::Point3d.new(ox+21850, oy+11150, -20)
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
    Geom::Point3d.new(ox+21850, oy+10850, 3500),
    Geom::Point3d.new(ox+22150, oy+10850, 3500),
    Geom::Point3d.new(ox+22150, oy+11150, 3500),
    Geom::Point3d.new(ox+21850, oy+11150, 3500)
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
    Geom::Point3d.new(ox+3850, oy+4850, -20),
    Geom::Point3d.new(ox+4150, oy+4850, -20),
    Geom::Point3d.new(ox+4150, oy+5150, -20),
    Geom::Point3d.new(ox+3850, oy+5150, -20)
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
    Geom::Point3d.new(ox+3850, oy+4850, 3500),
    Geom::Point3d.new(ox+4150, oy+4850, 3500),
    Geom::Point3d.new(ox+4150, oy+5150, 3500),
    Geom::Point3d.new(ox+3850, oy+5150, 3500)
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
    Geom::Point3d.new(ox+9850, oy+4850, -20),
    Geom::Point3d.new(ox+10150, oy+4850, -20),
    Geom::Point3d.new(ox+10150, oy+5150, -20),
    Geom::Point3d.new(ox+9850, oy+5150, -20)
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
    Geom::Point3d.new(ox+9850, oy+4850, 3500),
    Geom::Point3d.new(ox+10150, oy+4850, 3500),
    Geom::Point3d.new(ox+10150, oy+5150, 3500),
    Geom::Point3d.new(ox+9850, oy+5150, 3500)
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
    Geom::Point3d.new(ox+15850, oy+4850, -20),
    Geom::Point3d.new(ox+16150, oy+4850, -20),
    Geom::Point3d.new(ox+16150, oy+5150, -20),
    Geom::Point3d.new(ox+15850, oy+5150, -20)
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
    Geom::Point3d.new(ox+15850, oy+4850, 3500),
    Geom::Point3d.new(ox+16150, oy+4850, 3500),
    Geom::Point3d.new(ox+16150, oy+5150, 3500),
    Geom::Point3d.new(ox+15850, oy+5150, 3500)
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
    Geom::Point3d.new(ox+21850, oy+4850, -20),
    Geom::Point3d.new(ox+22150, oy+4850, -20),
    Geom::Point3d.new(ox+22150, oy+5150, -20),
    Geom::Point3d.new(ox+21850, oy+5150, -20)
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
    Geom::Point3d.new(ox+21850, oy+4850, 3500),
    Geom::Point3d.new(ox+22150, oy+4850, 3500),
    Geom::Point3d.new(ox+22150, oy+5150, 3500),
    Geom::Point3d.new(ox+21850, oy+5150, 3500)
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
    Geom::Point3d.new(ox+12350, oy+14850, -20),
    Geom::Point3d.new(ox+12650, oy+14850, -20),
    Geom::Point3d.new(ox+12650, oy+15150, -20),
    Geom::Point3d.new(ox+12350, oy+15150, -20)
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
    Geom::Point3d.new(ox+12350, oy+14850, 3500),
    Geom::Point3d.new(ox+12650, oy+14850, 3500),
    Geom::Point3d.new(ox+12650, oy+15150, 3500),
    Geom::Point3d.new(ox+12350, oy+15150, 3500)
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
    Geom::Point3d.new(ox+12350, oy+9850, -20),
    Geom::Point3d.new(ox+12650, oy+9850, -20),
    Geom::Point3d.new(ox+12650, oy+10150, -20),
    Geom::Point3d.new(ox+12350, oy+10150, -20)
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
    Geom::Point3d.new(ox+12350, oy+9850, 3500),
    Geom::Point3d.new(ox+12650, oy+9850, 3500),
    Geom::Point3d.new(ox+12650, oy+10150, 3500),
    Geom::Point3d.new(ox+12350, oy+10150, 3500)
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
    Geom::Point3d.new(ox+12350, oy+4850, -20),
    Geom::Point3d.new(ox+12650, oy+4850, -20),
    Geom::Point3d.new(ox+12650, oy+5150, -20),
    Geom::Point3d.new(ox+12350, oy+5150, -20)
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
    Geom::Point3d.new(ox+12350, oy+4850, 3500),
    Geom::Point3d.new(ox+12650, oy+4850, 3500),
    Geom::Point3d.new(ox+12650, oy+5150, 3500),
    Geom::Point3d.new(ox+12350, oy+5150, 3500)
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
    Geom::Point3d.new(ox+12350, oy+-150, -20),
    Geom::Point3d.new(ox+12650, oy+-150, -20),
    Geom::Point3d.new(ox+12650, oy+150, -20),
    Geom::Point3d.new(ox+12350, oy+150, -20)
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
    Geom::Point3d.new(ox+12350, oy+-150, 3500),
    Geom::Point3d.new(ox+12650, oy+-150, 3500),
    Geom::Point3d.new(ox+12650, oy+150, 3500),
    Geom::Point3d.new(ox+12350, oy+150, 3500)
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
    Geom::Point3d.new(ox+14850, oy+12350, -20),
    Geom::Point3d.new(ox+15150, oy+12350, -20),
    Geom::Point3d.new(ox+15150, oy+12650, -20),
    Geom::Point3d.new(ox+14850, oy+12650, -20)
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
    Geom::Point3d.new(ox+14850, oy+12350, 3500),
    Geom::Point3d.new(ox+15150, oy+12350, 3500),
    Geom::Point3d.new(ox+15150, oy+12650, 3500),
    Geom::Point3d.new(ox+14850, oy+12650, 3500)
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
    Geom::Point3d.new(ox+14850, oy+7350, -20),
    Geom::Point3d.new(ox+15150, oy+7350, -20),
    Geom::Point3d.new(ox+15150, oy+7650, -20),
    Geom::Point3d.new(ox+14850, oy+7650, -20)
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
    Geom::Point3d.new(ox+14850, oy+7350, 3500),
    Geom::Point3d.new(ox+15150, oy+7350, 3500),
    Geom::Point3d.new(ox+15150, oy+7650, 3500),
    Geom::Point3d.new(ox+14850, oy+7650, 3500)
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
    Geom::Point3d.new(ox+14850, oy+2350, -20),
    Geom::Point3d.new(ox+15150, oy+2350, -20),
    Geom::Point3d.new(ox+15150, oy+2650, -20),
    Geom::Point3d.new(ox+14850, oy+2650, -20)
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
    Geom::Point3d.new(ox+14850, oy+2350, 3500),
    Geom::Point3d.new(ox+15150, oy+2350, 3500),
    Geom::Point3d.new(ox+15150, oy+2650, 3500),
    Geom::Point3d.new(ox+14850, oy+2650, 3500)
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
    Geom::Point3d.new(ox+5900, oy+35900, -20),
    Geom::Point3d.new(ox+6100, oy+35900, -20),
    Geom::Point3d.new(ox+6100, oy+36100, -20),
    Geom::Point3d.new(ox+5900, oy+36100, -20)
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
    Geom::Point3d.new(ox+5900, oy+35900, 6000),
    Geom::Point3d.new(ox+6100, oy+35900, 6000),
    Geom::Point3d.new(ox+6100, oy+36100, 6000),
    Geom::Point3d.new(ox+5900, oy+36100, 6000)
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
    Geom::Point3d.new(ox+11900, oy+35900, -20),
    Geom::Point3d.new(ox+12100, oy+35900, -20),
    Geom::Point3d.new(ox+12100, oy+36100, -20),
    Geom::Point3d.new(ox+11900, oy+36100, -20)
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
    Geom::Point3d.new(ox+11900, oy+35900, 6000),
    Geom::Point3d.new(ox+12100, oy+35900, 6000),
    Geom::Point3d.new(ox+12100, oy+36100, 6000),
    Geom::Point3d.new(ox+11900, oy+36100, 6000)
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
    Geom::Point3d.new(ox+17900, oy+35900, -20),
    Geom::Point3d.new(ox+18100, oy+35900, -20),
    Geom::Point3d.new(ox+18100, oy+36100, -20),
    Geom::Point3d.new(ox+17900, oy+36100, -20)
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
    Geom::Point3d.new(ox+17900, oy+35900, 6000),
    Geom::Point3d.new(ox+18100, oy+35900, 6000),
    Geom::Point3d.new(ox+18100, oy+36100, 6000),
    Geom::Point3d.new(ox+17900, oy+36100, 6000)
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
    Geom::Point3d.new(ox+-100, oy+41900, -20),
    Geom::Point3d.new(ox+100, oy+41900, -20),
    Geom::Point3d.new(ox+100, oy+42100, -20),
    Geom::Point3d.new(ox+-100, oy+42100, -20)
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
    Geom::Point3d.new(ox+-100, oy+41900, 6000),
    Geom::Point3d.new(ox+100, oy+41900, 6000),
    Geom::Point3d.new(ox+100, oy+42100, 6000),
    Geom::Point3d.new(ox+-100, oy+42100, 6000)
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
    Geom::Point3d.new(ox+5900, oy+41900, -20),
    Geom::Point3d.new(ox+6100, oy+41900, -20),
    Geom::Point3d.new(ox+6100, oy+42100, -20),
    Geom::Point3d.new(ox+5900, oy+42100, -20)
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
    Geom::Point3d.new(ox+5900, oy+41900, 5500),
    Geom::Point3d.new(ox+6100, oy+41900, 5500),
    Geom::Point3d.new(ox+6100, oy+42100, 5500),
    Geom::Point3d.new(ox+5900, oy+42100, 5500)
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
    Geom::Point3d.new(ox+11900, oy+41900, -20),
    Geom::Point3d.new(ox+12100, oy+41900, -20),
    Geom::Point3d.new(ox+12100, oy+42100, -20),
    Geom::Point3d.new(ox+11900, oy+42100, -20)
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
    Geom::Point3d.new(ox+11900, oy+41900, 5500),
    Geom::Point3d.new(ox+12100, oy+41900, 5500),
    Geom::Point3d.new(ox+12100, oy+42100, 5500),
    Geom::Point3d.new(ox+11900, oy+42100, 5500)
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
    Geom::Point3d.new(ox+17900, oy+41900, -20),
    Geom::Point3d.new(ox+18100, oy+41900, -20),
    Geom::Point3d.new(ox+18100, oy+42100, -20),
    Geom::Point3d.new(ox+17900, oy+42100, -20)
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
    Geom::Point3d.new(ox+17900, oy+41900, 5500),
    Geom::Point3d.new(ox+18100, oy+41900, 5500),
    Geom::Point3d.new(ox+18100, oy+42100, 5500),
    Geom::Point3d.new(ox+17900, oy+42100, 5500)
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
    Geom::Point3d.new(ox+-100, oy+47900, -20),
    Geom::Point3d.new(ox+100, oy+47900, -20),
    Geom::Point3d.new(ox+100, oy+48100, -20),
    Geom::Point3d.new(ox+-100, oy+48100, -20)
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
    Geom::Point3d.new(ox+-100, oy+47900, 5500),
    Geom::Point3d.new(ox+100, oy+47900, 5500),
    Geom::Point3d.new(ox+100, oy+48100, 5500),
    Geom::Point3d.new(ox+-100, oy+48100, 5500)
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
    Geom::Point3d.new(ox+5900, oy+47900, -20),
    Geom::Point3d.new(ox+6100, oy+47900, -20),
    Geom::Point3d.new(ox+6100, oy+48100, -20),
    Geom::Point3d.new(ox+5900, oy+48100, -20)
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
    Geom::Point3d.new(ox+5900, oy+47900, 5000),
    Geom::Point3d.new(ox+6100, oy+47900, 5000),
    Geom::Point3d.new(ox+6100, oy+48100, 5000),
    Geom::Point3d.new(ox+5900, oy+48100, 5000)
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
    Geom::Point3d.new(ox+11900, oy+47900, -20),
    Geom::Point3d.new(ox+12100, oy+47900, -20),
    Geom::Point3d.new(ox+12100, oy+48100, -20),
    Geom::Point3d.new(ox+11900, oy+48100, -20)
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
    Geom::Point3d.new(ox+11900, oy+47900, 5000),
    Geom::Point3d.new(ox+12100, oy+47900, 5000),
    Geom::Point3d.new(ox+12100, oy+48100, 5000),
    Geom::Point3d.new(ox+11900, oy+48100, 5000)
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
    Geom::Point3d.new(ox+17900, oy+47900, -20),
    Geom::Point3d.new(ox+18100, oy+47900, -20),
    Geom::Point3d.new(ox+18100, oy+48100, -20),
    Geom::Point3d.new(ox+17900, oy+48100, -20)
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
    Geom::Point3d.new(ox+17900, oy+47900, 5000),
    Geom::Point3d.new(ox+18100, oy+47900, 5000),
    Geom::Point3d.new(ox+18100, oy+48100, 5000),
    Geom::Point3d.new(ox+17900, oy+48100, 5000)
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
    Geom::Point3d.new(ox+-100, oy+53900, -20),
    Geom::Point3d.new(ox+100, oy+53900, -20),
    Geom::Point3d.new(ox+100, oy+54100, -20),
    Geom::Point3d.new(ox+-100, oy+54100, -20)
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
    Geom::Point3d.new(ox+-100, oy+53900, 5000),
    Geom::Point3d.new(ox+100, oy+53900, 5000),
    Geom::Point3d.new(ox+100, oy+54100, 5000),
    Geom::Point3d.new(ox+-100, oy+54100, 5000)
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
    Geom::Point3d.new(ox+5900, oy+53900, -20),
    Geom::Point3d.new(ox+6100, oy+53900, -20),
    Geom::Point3d.new(ox+6100, oy+54100, -20),
    Geom::Point3d.new(ox+5900, oy+54100, -20)
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
    Geom::Point3d.new(ox+5900, oy+53900, 4500),
    Geom::Point3d.new(ox+6100, oy+53900, 4500),
    Geom::Point3d.new(ox+6100, oy+54100, 4500),
    Geom::Point3d.new(ox+5900, oy+54100, 4500)
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
    Geom::Point3d.new(ox+11900, oy+53900, -20),
    Geom::Point3d.new(ox+12100, oy+53900, -20),
    Geom::Point3d.new(ox+12100, oy+54100, -20),
    Geom::Point3d.new(ox+11900, oy+54100, -20)
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
    Geom::Point3d.new(ox+11900, oy+53900, 4500),
    Geom::Point3d.new(ox+12100, oy+53900, 4500),
    Geom::Point3d.new(ox+12100, oy+54100, 4500),
    Geom::Point3d.new(ox+11900, oy+54100, 4500)
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
    Geom::Point3d.new(ox+17900, oy+53900, -20),
    Geom::Point3d.new(ox+18100, oy+53900, -20),
    Geom::Point3d.new(ox+18100, oy+54100, -20),
    Geom::Point3d.new(ox+17900, oy+54100, -20)
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
    Geom::Point3d.new(ox+17900, oy+53900, 4500),
    Geom::Point3d.new(ox+18100, oy+53900, 4500),
    Geom::Point3d.new(ox+18100, oy+54100, 4500),
    Geom::Point3d.new(ox+17900, oy+54100, 4500)
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
    Geom::Point3d.new(ox+-100, oy+59900, -20),
    Geom::Point3d.new(ox+100, oy+59900, -20),
    Geom::Point3d.new(ox+100, oy+60100, -20),
    Geom::Point3d.new(ox+-100, oy+60100, -20)
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
    Geom::Point3d.new(ox+-100, oy+59900, 4500),
    Geom::Point3d.new(ox+100, oy+59900, 4500),
    Geom::Point3d.new(ox+100, oy+60100, 4500),
    Geom::Point3d.new(ox+-100, oy+60100, 4500)
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
    Geom::Point3d.new(ox+5900, oy+59900, -20),
    Geom::Point3d.new(ox+6100, oy+59900, -20),
    Geom::Point3d.new(ox+6100, oy+60100, -20),
    Geom::Point3d.new(ox+5900, oy+60100, -20)
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
    Geom::Point3d.new(ox+5900, oy+59900, 4000),
    Geom::Point3d.new(ox+6100, oy+59900, 4000),
    Geom::Point3d.new(ox+6100, oy+60100, 4000),
    Geom::Point3d.new(ox+5900, oy+60100, 4000)
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
    Geom::Point3d.new(ox+11900, oy+59900, -20),
    Geom::Point3d.new(ox+12100, oy+59900, -20),
    Geom::Point3d.new(ox+12100, oy+60100, -20),
    Geom::Point3d.new(ox+11900, oy+60100, -20)
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
    Geom::Point3d.new(ox+11900, oy+59900, 4000),
    Geom::Point3d.new(ox+12100, oy+59900, 4000),
    Geom::Point3d.new(ox+12100, oy+60100, 4000),
    Geom::Point3d.new(ox+11900, oy+60100, 4000)
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
    Geom::Point3d.new(ox+17900, oy+59900, -20),
    Geom::Point3d.new(ox+18100, oy+59900, -20),
    Geom::Point3d.new(ox+18100, oy+60100, -20),
    Geom::Point3d.new(ox+17900, oy+60100, -20)
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
    Geom::Point3d.new(ox+17900, oy+59900, 4000),
    Geom::Point3d.new(ox+18100, oy+59900, 4000),
    Geom::Point3d.new(ox+18100, oy+60100, 4000),
    Geom::Point3d.new(ox+17900, oy+60100, 4000)
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
    Geom::Point3d.new(ox+-100, oy+65900, -20),
    Geom::Point3d.new(ox+100, oy+65900, -20),
    Geom::Point3d.new(ox+100, oy+66100, -20),
    Geom::Point3d.new(ox+-100, oy+66100, -20)
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
    Geom::Point3d.new(ox+-100, oy+65900, 4000),
    Geom::Point3d.new(ox+100, oy+65900, 4000),
    Geom::Point3d.new(ox+100, oy+66100, 4000),
    Geom::Point3d.new(ox+-100, oy+66100, 4000)
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
    Geom::Point3d.new(ox+5900, oy+65900, -20),
    Geom::Point3d.new(ox+6100, oy+65900, -20),
    Geom::Point3d.new(ox+6100, oy+66100, -20),
    Geom::Point3d.new(ox+5900, oy+66100, -20)
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
    Geom::Point3d.new(ox+5900, oy+65900, 3500),
    Geom::Point3d.new(ox+6100, oy+65900, 3500),
    Geom::Point3d.new(ox+6100, oy+66100, 3500),
    Geom::Point3d.new(ox+5900, oy+66100, 3500)
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
    Geom::Point3d.new(ox+11900, oy+65900, -20),
    Geom::Point3d.new(ox+12100, oy+65900, -20),
    Geom::Point3d.new(ox+12100, oy+66100, -20),
    Geom::Point3d.new(ox+11900, oy+66100, -20)
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
    Geom::Point3d.new(ox+11900, oy+65900, 3500),
    Geom::Point3d.new(ox+12100, oy+65900, 3500),
    Geom::Point3d.new(ox+12100, oy+66100, 3500),
    Geom::Point3d.new(ox+11900, oy+66100, 3500)
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
    Geom::Point3d.new(ox+17900, oy+65900, -20),
    Geom::Point3d.new(ox+18100, oy+65900, -20),
    Geom::Point3d.new(ox+18100, oy+66100, -20),
    Geom::Point3d.new(ox+17900, oy+66100, -20)
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
    Geom::Point3d.new(ox+17900, oy+65900, 3500),
    Geom::Point3d.new(ox+18100, oy+65900, 3500),
    Geom::Point3d.new(ox+18100, oy+66100, 3500),
    Geom::Point3d.new(ox+17900, oy+66100, 3500)
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
    Geom::Point3d.new(ox+-100, oy+71900, -20),
    Geom::Point3d.new(ox+100, oy+71900, -20),
    Geom::Point3d.new(ox+100, oy+72100, -20),
    Geom::Point3d.new(ox+-100, oy+72100, -20)
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
    Geom::Point3d.new(ox+-100, oy+71900, 3500),
    Geom::Point3d.new(ox+100, oy+71900, 3500),
    Geom::Point3d.new(ox+100, oy+72100, 3500),
    Geom::Point3d.new(ox+-100, oy+72100, 3500)
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
    Geom::Point3d.new(ox+5900, oy+71900, -20),
    Geom::Point3d.new(ox+6100, oy+71900, -20),
    Geom::Point3d.new(ox+6100, oy+72100, -20),
    Geom::Point3d.new(ox+5900, oy+72100, -20)
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
    Geom::Point3d.new(ox+5900, oy+71900, 3000),
    Geom::Point3d.new(ox+6100, oy+71900, 3000),
    Geom::Point3d.new(ox+6100, oy+72100, 3000),
    Geom::Point3d.new(ox+5900, oy+72100, 3000)
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
    Geom::Point3d.new(ox+11900, oy+71900, -20),
    Geom::Point3d.new(ox+12100, oy+71900, -20),
    Geom::Point3d.new(ox+12100, oy+72100, -20),
    Geom::Point3d.new(ox+11900, oy+72100, -20)
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
    Geom::Point3d.new(ox+11900, oy+71900, 3000),
    Geom::Point3d.new(ox+12100, oy+71900, 3000),
    Geom::Point3d.new(ox+12100, oy+72100, 3000),
    Geom::Point3d.new(ox+11900, oy+72100, 3000)
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
    Geom::Point3d.new(ox+17900, oy+71900, -20),
    Geom::Point3d.new(ox+18100, oy+71900, -20),
    Geom::Point3d.new(ox+18100, oy+72100, -20),
    Geom::Point3d.new(ox+17900, oy+72100, -20)
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
    Geom::Point3d.new(ox+17900, oy+71900, 3000),
    Geom::Point3d.new(ox+18100, oy+71900, 3000),
    Geom::Point3d.new(ox+18100, oy+72100, 3000),
    Geom::Point3d.new(ox+17900, oy+72100, 3000)
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
    Geom::Point3d.new(ox+-100, oy+77900, -20),
    Geom::Point3d.new(ox+100, oy+77900, -20),
    Geom::Point3d.new(ox+100, oy+78100, -20),
    Geom::Point3d.new(ox+-100, oy+78100, -20)
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
    Geom::Point3d.new(ox+-100, oy+77900, 3000),
    Geom::Point3d.new(ox+100, oy+77900, 3000),
    Geom::Point3d.new(ox+100, oy+78100, 3000),
    Geom::Point3d.new(ox+-100, oy+78100, 3000)
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
    Geom::Point3d.new(ox+5900, oy+77900, -20),
    Geom::Point3d.new(ox+6100, oy+77900, -20),
    Geom::Point3d.new(ox+6100, oy+78100, -20),
    Geom::Point3d.new(ox+5900, oy+78100, -20)
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
    Geom::Point3d.new(ox+5900, oy+77900, 2600),
    Geom::Point3d.new(ox+6100, oy+77900, 2600),
    Geom::Point3d.new(ox+6100, oy+78100, 2600),
    Geom::Point3d.new(ox+5900, oy+78100, 2600)
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
    Geom::Point3d.new(ox+11900, oy+77900, -20),
    Geom::Point3d.new(ox+12100, oy+77900, -20),
    Geom::Point3d.new(ox+12100, oy+78100, -20),
    Geom::Point3d.new(ox+11900, oy+78100, -20)
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
    Geom::Point3d.new(ox+11900, oy+77900, 2600),
    Geom::Point3d.new(ox+12100, oy+77900, 2600),
    Geom::Point3d.new(ox+12100, oy+78100, 2600),
    Geom::Point3d.new(ox+11900, oy+78100, 2600)
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
    Geom::Point3d.new(ox+17900, oy+77900, -20),
    Geom::Point3d.new(ox+18100, oy+77900, -20),
    Geom::Point3d.new(ox+18100, oy+78100, -20),
    Geom::Point3d.new(ox+17900, oy+78100, -20)
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
    Geom::Point3d.new(ox+17900, oy+77900, 2600),
    Geom::Point3d.new(ox+18100, oy+77900, 2600),
    Geom::Point3d.new(ox+18100, oy+78100, 2600),
    Geom::Point3d.new(ox+17900, oy+78100, 2600)
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
    Geom::Point3d.new(ox+-100, oy+83900, -20),
    Geom::Point3d.new(ox+100, oy+83900, -20),
    Geom::Point3d.new(ox+100, oy+84100, -20),
    Geom::Point3d.new(ox+-100, oy+84100, -20)
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
    Geom::Point3d.new(ox+-100, oy+83900, 2600),
    Geom::Point3d.new(ox+100, oy+83900, 2600),
    Geom::Point3d.new(ox+100, oy+84100, 2600),
    Geom::Point3d.new(ox+-100, oy+84100, 2600)
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
    Geom::Point3d.new(ox+5900, oy+83900, -20),
    Geom::Point3d.new(ox+6100, oy+83900, -20),
    Geom::Point3d.new(ox+6100, oy+84100, -20),
    Geom::Point3d.new(ox+5900, oy+84100, -20)
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
    Geom::Point3d.new(ox+5900, oy+83900, 6000),
    Geom::Point3d.new(ox+6100, oy+83900, 6000),
    Geom::Point3d.new(ox+6100, oy+84100, 6000),
    Geom::Point3d.new(ox+5900, oy+84100, 6000)
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
    Geom::Point3d.new(ox+11900, oy+83900, -20),
    Geom::Point3d.new(ox+12100, oy+83900, -20),
    Geom::Point3d.new(ox+12100, oy+84100, -20),
    Geom::Point3d.new(ox+11900, oy+84100, -20)
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
    Geom::Point3d.new(ox+11900, oy+83900, 5500),
    Geom::Point3d.new(ox+12100, oy+83900, 5500),
    Geom::Point3d.new(ox+12100, oy+84100, 5500),
    Geom::Point3d.new(ox+11900, oy+84100, 5500)
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
    Geom::Point3d.new(ox+17900, oy+83900, -20),
    Geom::Point3d.new(ox+18100, oy+83900, -20),
    Geom::Point3d.new(ox+18100, oy+84100, -20),
    Geom::Point3d.new(ox+17900, oy+84100, -20)
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
    Geom::Point3d.new(ox+17900, oy+83900, 5000),
    Geom::Point3d.new(ox+18100, oy+83900, 5000),
    Geom::Point3d.new(ox+18100, oy+84100, 5000),
    Geom::Point3d.new(ox+17900, oy+84100, 5000)
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
    Geom::Point3d.new(ox+-100, oy+89900, -20),
    Geom::Point3d.new(ox+100, oy+89900, -20),
    Geom::Point3d.new(ox+100, oy+90100, -20),
    Geom::Point3d.new(ox+-100, oy+90100, -20)
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
    Geom::Point3d.new(ox+-100, oy+89900, 4500),
    Geom::Point3d.new(ox+100, oy+89900, 4500),
    Geom::Point3d.new(ox+100, oy+90100, 4500),
    Geom::Point3d.new(ox+-100, oy+90100, 4500)
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
    Geom::Point3d.new(ox+5900, oy+89900, -20),
    Geom::Point3d.new(ox+6100, oy+89900, -20),
    Geom::Point3d.new(ox+6100, oy+90100, -20),
    Geom::Point3d.new(ox+5900, oy+90100, -20)
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
    Geom::Point3d.new(ox+5900, oy+89900, 4000),
    Geom::Point3d.new(ox+6100, oy+89900, 4000),
    Geom::Point3d.new(ox+6100, oy+90100, 4000),
    Geom::Point3d.new(ox+5900, oy+90100, 4000)
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
    Geom::Point3d.new(ox+11900, oy+89900, -20),
    Geom::Point3d.new(ox+12100, oy+89900, -20),
    Geom::Point3d.new(ox+12100, oy+90100, -20),
    Geom::Point3d.new(ox+11900, oy+90100, -20)
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
    Geom::Point3d.new(ox+11900, oy+89900, 3500),
    Geom::Point3d.new(ox+12100, oy+89900, 3500),
    Geom::Point3d.new(ox+12100, oy+90100, 3500),
    Geom::Point3d.new(ox+11900, oy+90100, 3500)
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
    Geom::Point3d.new(ox+17900, oy+89900, -20),
    Geom::Point3d.new(ox+18100, oy+89900, -20),
    Geom::Point3d.new(ox+18100, oy+90100, -20),
    Geom::Point3d.new(ox+17900, oy+90100, -20)
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
    Geom::Point3d.new(ox+17900, oy+89900, 3000),
    Geom::Point3d.new(ox+18100, oy+89900, 3000),
    Geom::Point3d.new(ox+18100, oy+90100, 3000),
    Geom::Point3d.new(ox+17900, oy+90100, 3000)
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
    Geom::Point3d.new(ox+-100, oy+95900, -20),
    Geom::Point3d.new(ox+100, oy+95900, -20),
    Geom::Point3d.new(ox+100, oy+96100, -20),
    Geom::Point3d.new(ox+-100, oy+96100, -20)
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
    Geom::Point3d.new(ox+-100, oy+95900, 2600),
    Geom::Point3d.new(ox+100, oy+95900, 2600),
    Geom::Point3d.new(ox+100, oy+96100, 2600),
    Geom::Point3d.new(ox+-100, oy+96100, 2600)
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
    Geom::Point3d.new(ox+5900, oy+95900, -20),
    Geom::Point3d.new(ox+6100, oy+95900, -20),
    Geom::Point3d.new(ox+6100, oy+96100, -20),
    Geom::Point3d.new(ox+5900, oy+96100, -20)
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
    Geom::Point3d.new(ox+5900, oy+95900, 3500),
    Geom::Point3d.new(ox+6100, oy+95900, 3500),
    Geom::Point3d.new(ox+6100, oy+96100, 3500),
    Geom::Point3d.new(ox+5900, oy+96100, 3500)
  ]
  cplate_65_f = ents.add_face(cplate_65_pts)
  if cplate_65_f
    cplate_65_f.material = mat_steel_plate
    cplate_65_f.layer = layers['conns']
    cplate_65_f.pushpull(20)
  end
rescue; end

model.commit_operation
UI.messagebox('Done: 66c 36b 8s 0w 6f [LOD350]')
# ── Auto-save .skp ──────────────────────────────────────────
begin
  _skp_name = 'structural_model_LOD300.skp'
  _skp_dir  = File.expand_path('~/Downloads')
  _skp_path = File.join(_skp_dir, _skp_name)
  Sketchup.active_model.save(_skp_path)
  UI.messagebox("\u2705 Model saved: #{_skp_path}")
rescue => _e
  UI.messagebox("Save failed: #{_e.message}. Use File > Save As manually.")
end
