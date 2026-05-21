# SketchUp Structural Script
# Generated: 2026-05-21T09:01:50.769685
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
mat_Concrete = model.materials.add('Concrete')
mat_Concrete.color = Sketchup::Color.new(190,190,190)
mat_concrete = model.materials.add('concrete')
mat_concrete.color = Sketchup::Color.new(180,180,180)
mat_reinforced_concrete = model.materials.add('reinforced_concrete')
mat_reinforced_concrete.color = Sketchup::Color.new(190,190,190)
mat_steel = model.materials.add('steel')
mat_steel.color = Sketchup::Color.new(200,200,220)

ox = 0; oy = 0; oz = 0

# === Columns ===
# Column 1: C1
pts_0 = [
  Geom::Point3d.new(ox+0, oy+0, 0),
  Geom::Point3d.new(ox+400, oy+0, 0),
  Geom::Point3d.new(ox+400, oy+400, 0),
  Geom::Point3d.new(ox+0, oy+400, 0)
]
f_0 = ents.add_face(pts_0)
f_0.material = mat_concrete if f_0
f_0.layer = layers['cols'] if f_0
f_0.pushpull(3500) if f_0
# Column 2: C2
pts_1 = [
  Geom::Point3d.new(ox+6000, oy+0, 0),
  Geom::Point3d.new(ox+6400, oy+0, 0),
  Geom::Point3d.new(ox+6400, oy+400, 0),
  Geom::Point3d.new(ox+6000, oy+400, 0)
]
f_1 = ents.add_face(pts_1)
f_1.material = mat_concrete if f_1
f_1.layer = layers['cols'] if f_1
f_1.pushpull(3500) if f_1
# Column 3: C3
pts_2 = [
  Geom::Point3d.new(ox+12000, oy+0, 0),
  Geom::Point3d.new(ox+12400, oy+0, 0),
  Geom::Point3d.new(ox+12400, oy+400, 0),
  Geom::Point3d.new(ox+12000, oy+400, 0)
]
f_2 = ents.add_face(pts_2)
f_2.material = mat_concrete if f_2
f_2.layer = layers['cols'] if f_2
f_2.pushpull(3500) if f_2
# Column 4: C4
pts_3 = [
  Geom::Point3d.new(ox+18000, oy+0, 0),
  Geom::Point3d.new(ox+18400, oy+0, 0),
  Geom::Point3d.new(ox+18400, oy+400, 0),
  Geom::Point3d.new(ox+18000, oy+400, 0)
]
f_3 = ents.add_face(pts_3)
f_3.material = mat_concrete if f_3
f_3.layer = layers['cols'] if f_3
f_3.pushpull(3500) if f_3
# Column 5: C5
pts_4 = [
  Geom::Point3d.new(ox+0, oy+0, 0),
  Geom::Point3d.new(ox+400, oy+0, 0),
  Geom::Point3d.new(ox+400, oy+400, 0),
  Geom::Point3d.new(ox+0, oy+400, 0)
]
f_4 = ents.add_face(pts_4)
f_4.material = mat_concrete if f_4
f_4.layer = layers['cols'] if f_4
f_4.pushpull(3500) if f_4
# Column 6: C6
pts_5 = [
  Geom::Point3d.new(ox+6000, oy+0, 0),
  Geom::Point3d.new(ox+6400, oy+0, 0),
  Geom::Point3d.new(ox+6400, oy+400, 0),
  Geom::Point3d.new(ox+6000, oy+400, 0)
]
f_5 = ents.add_face(pts_5)
f_5.material = mat_concrete if f_5
f_5.layer = layers['cols'] if f_5
f_5.pushpull(3500) if f_5
# Column 7: C7
pts_6 = [
  Geom::Point3d.new(ox+12000, oy+0, 0),
  Geom::Point3d.new(ox+12400, oy+0, 0),
  Geom::Point3d.new(ox+12400, oy+400, 0),
  Geom::Point3d.new(ox+12000, oy+400, 0)
]
f_6 = ents.add_face(pts_6)
f_6.material = mat_concrete if f_6
f_6.layer = layers['cols'] if f_6
f_6.pushpull(3500) if f_6
# Column 8: C8
pts_7 = [
  Geom::Point3d.new(ox+18000, oy+0, 0),
  Geom::Point3d.new(ox+18400, oy+0, 0),
  Geom::Point3d.new(ox+18400, oy+400, 0),
  Geom::Point3d.new(ox+18000, oy+400, 0)
]
f_7 = ents.add_face(pts_7)
f_7.material = mat_concrete if f_7
f_7.layer = layers['cols'] if f_7
f_7.pushpull(3500) if f_7
# Column 9: C9
pts_8 = [
  Geom::Point3d.new(ox+0, oy+3000, 0),
  Geom::Point3d.new(ox+400, oy+3000, 0),
  Geom::Point3d.new(ox+400, oy+3400, 0),
  Geom::Point3d.new(ox+0, oy+3400, 0)
]
f_8 = ents.add_face(pts_8)
f_8.material = mat_concrete if f_8
f_8.layer = layers['cols'] if f_8
f_8.pushpull(3500) if f_8
# Column 10: C10
pts_9 = [
  Geom::Point3d.new(ox+3000, oy+3000, 0),
  Geom::Point3d.new(ox+3400, oy+3000, 0),
  Geom::Point3d.new(ox+3400, oy+3400, 0),
  Geom::Point3d.new(ox+3000, oy+3400, 0)
]
f_9 = ents.add_face(pts_9)
f_9.material = mat_concrete if f_9
f_9.layer = layers['cols'] if f_9
f_9.pushpull(3500) if f_9
# Column 11: C11
pts_10 = [
  Geom::Point3d.new(ox+6000, oy+3000, 0),
  Geom::Point3d.new(ox+6400, oy+3000, 0),
  Geom::Point3d.new(ox+6400, oy+3400, 0),
  Geom::Point3d.new(ox+6000, oy+3400, 0)
]
f_10 = ents.add_face(pts_10)
f_10.material = mat_concrete if f_10
f_10.layer = layers['cols'] if f_10
f_10.pushpull(3500) if f_10
# Column 12: C12
pts_11 = [
  Geom::Point3d.new(ox+9000, oy+3000, 0),
  Geom::Point3d.new(ox+9400, oy+3000, 0),
  Geom::Point3d.new(ox+9400, oy+3400, 0),
  Geom::Point3d.new(ox+9000, oy+3400, 0)
]
f_11 = ents.add_face(pts_11)
f_11.material = mat_concrete if f_11
f_11.layer = layers['cols'] if f_11
f_11.pushpull(3500) if f_11
# Column 13: C13
pts_12 = [
  Geom::Point3d.new(ox+0, oy+0, 0),
  Geom::Point3d.new(ox+400, oy+0, 0),
  Geom::Point3d.new(ox+400, oy+400, 0),
  Geom::Point3d.new(ox+0, oy+400, 0)
]
f_12 = ents.add_face(pts_12)
f_12.material = mat_concrete if f_12
f_12.layer = layers['cols'] if f_12
f_12.pushpull(3500) if f_12
# Column 14: C14
pts_13 = [
  Geom::Point3d.new(ox+3000, oy+0, 0),
  Geom::Point3d.new(ox+3400, oy+0, 0),
  Geom::Point3d.new(ox+3400, oy+400, 0),
  Geom::Point3d.new(ox+3000, oy+400, 0)
]
f_13 = ents.add_face(pts_13)
f_13.material = mat_concrete if f_13
f_13.layer = layers['cols'] if f_13
f_13.pushpull(3500) if f_13
# Column 15: C15
pts_14 = [
  Geom::Point3d.new(ox+6000, oy+0, 0),
  Geom::Point3d.new(ox+6400, oy+0, 0),
  Geom::Point3d.new(ox+6400, oy+400, 0),
  Geom::Point3d.new(ox+6000, oy+400, 0)
]
f_14 = ents.add_face(pts_14)
f_14.material = mat_concrete if f_14
f_14.layer = layers['cols'] if f_14
f_14.pushpull(3500) if f_14
# Column 16: C16
pts_15 = [
  Geom::Point3d.new(ox+9000, oy+0, 0),
  Geom::Point3d.new(ox+9400, oy+0, 0),
  Geom::Point3d.new(ox+9400, oy+400, 0),
  Geom::Point3d.new(ox+9000, oy+400, 0)
]
f_15 = ents.add_face(pts_15)
f_15.material = mat_concrete if f_15
f_15.layer = layers['cols'] if f_15
f_15.pushpull(3500) if f_15
# Column 17: C17
pts_16 = [
  Geom::Point3d.new(ox+1500, oy+3000, 0),
  Geom::Point3d.new(ox+1900, oy+3000, 0),
  Geom::Point3d.new(ox+1900, oy+3400, 0),
  Geom::Point3d.new(ox+1500, oy+3400, 0)
]
f_16 = ents.add_face(pts_16)
f_16.material = mat_concrete if f_16
f_16.layer = layers['cols'] if f_16
f_16.pushpull(3500) if f_16
# Column 18: C18
pts_17 = [
  Geom::Point3d.new(ox+4500, oy+3000, 0),
  Geom::Point3d.new(ox+4900, oy+3000, 0),
  Geom::Point3d.new(ox+4900, oy+3400, 0),
  Geom::Point3d.new(ox+4500, oy+3400, 0)
]
f_17 = ents.add_face(pts_17)
f_17.material = mat_concrete if f_17
f_17.layer = layers['cols'] if f_17
f_17.pushpull(3500) if f_17
# Column 19: C19
pts_18 = [
  Geom::Point3d.new(ox+7500, oy+3000, 0),
  Geom::Point3d.new(ox+7900, oy+3000, 0),
  Geom::Point3d.new(ox+7900, oy+3400, 0),
  Geom::Point3d.new(ox+7500, oy+3400, 0)
]
f_18 = ents.add_face(pts_18)
f_18.material = mat_concrete if f_18
f_18.layer = layers['cols'] if f_18
f_18.pushpull(3500) if f_18
# Column 20: C20
pts_19 = [
  Geom::Point3d.new(ox+1500, oy+0, 0),
  Geom::Point3d.new(ox+1900, oy+0, 0),
  Geom::Point3d.new(ox+1900, oy+400, 0),
  Geom::Point3d.new(ox+1500, oy+400, 0)
]
f_19 = ents.add_face(pts_19)
f_19.material = mat_concrete if f_19
f_19.layer = layers['cols'] if f_19
f_19.pushpull(3500) if f_19
# Column 21: C21
pts_20 = [
  Geom::Point3d.new(ox+4500, oy+0, 0),
  Geom::Point3d.new(ox+4900, oy+0, 0),
  Geom::Point3d.new(ox+4900, oy+400, 0),
  Geom::Point3d.new(ox+4500, oy+400, 0)
]
f_20 = ents.add_face(pts_20)
f_20.material = mat_concrete if f_20
f_20.layer = layers['cols'] if f_20
f_20.pushpull(3500) if f_20
# Column 22: C22
pts_21 = [
  Geom::Point3d.new(ox+7500, oy+0, 0),
  Geom::Point3d.new(ox+7900, oy+0, 0),
  Geom::Point3d.new(ox+7900, oy+400, 0),
  Geom::Point3d.new(ox+7500, oy+400, 0)
]
f_21 = ents.add_face(pts_21)
f_21.material = mat_concrete if f_21
f_21.layer = layers['cols'] if f_21
f_21.pushpull(3500) if f_21
# Column 23: C23
pts_22 = [
  Geom::Point3d.new(ox+3750, oy+2250, 0),
  Geom::Point3d.new(ox+4150, oy+2250, 0),
  Geom::Point3d.new(ox+4150, oy+2650, 0),
  Geom::Point3d.new(ox+3750, oy+2650, 0)
]
f_22 = ents.add_face(pts_22)
f_22.material = mat_concrete if f_22
f_22.layer = layers['cols'] if f_22
f_22.pushpull(3500) if f_22
# Column 24: C24
pts_23 = [
  Geom::Point3d.new(ox+5250, oy+2250, 0),
  Geom::Point3d.new(ox+5650, oy+2250, 0),
  Geom::Point3d.new(ox+5650, oy+2650, 0),
  Geom::Point3d.new(ox+5250, oy+2650, 0)
]
f_23 = ents.add_face(pts_23)
f_23.material = mat_concrete if f_23
f_23.layer = layers['cols'] if f_23
f_23.pushpull(3500) if f_23
# Column 25: C25
pts_24 = [
  Geom::Point3d.new(ox+3750, oy+750, 0),
  Geom::Point3d.new(ox+4150, oy+750, 0),
  Geom::Point3d.new(ox+4150, oy+1150, 0),
  Geom::Point3d.new(ox+3750, oy+1150, 0)
]
f_24 = ents.add_face(pts_24)
f_24.material = mat_concrete if f_24
f_24.layer = layers['cols'] if f_24
f_24.pushpull(3500) if f_24
# Column 26: C26
pts_25 = [
  Geom::Point3d.new(ox+5250, oy+750, 0),
  Geom::Point3d.new(ox+5650, oy+750, 0),
  Geom::Point3d.new(ox+5650, oy+1150, 0),
  Geom::Point3d.new(ox+5250, oy+1150, 0)
]
f_25 = ents.add_face(pts_25)
f_25.material = mat_concrete if f_25
f_25.layer = layers['cols'] if f_25
f_25.pushpull(3500) if f_25
# Column 27: 200UB_BP
pts_26 = [
  Geom::Point3d.new(ox+12000, oy+36000, 0),
  Geom::Point3d.new(ox+12200, oy+36000, 0),
  Geom::Point3d.new(ox+12200, oy+36200, 0),
  Geom::Point3d.new(ox+12000, oy+36200, 0)
]
f_26 = ents.add_face(pts_26)
f_26.material = mat_Concrete if f_26
f_26.layer = layers['cols'] if f_26
f_26.pushpull(3500) if f_26
# Column 28: 250UB_BP
pts_27 = [
  Geom::Point3d.new(ox+18000, oy+36000, 0),
  Geom::Point3d.new(ox+18250, oy+36000, 0),
  Geom::Point3d.new(ox+18250, oy+36250, 0),
  Geom::Point3d.new(ox+18000, oy+36250, 0)
]
f_27 = ents.add_face(pts_27)
f_27.material = mat_Concrete if f_27
f_27.layer = layers['cols'] if f_27
f_27.pushpull(3500) if f_27
# Column 29: 310UB_BP
pts_28 = [
  Geom::Point3d.new(ox+0, oy+42000, 0),
  Geom::Point3d.new(ox+310, oy+42000, 0),
  Geom::Point3d.new(ox+310, oy+42310, 0),
  Geom::Point3d.new(ox+0, oy+42310, 0)
]
f_28 = ents.add_face(pts_28)
f_28.material = mat_Concrete if f_28
f_28.layer = layers['cols'] if f_28
f_28.pushpull(3500) if f_28
# Column 30: 360UB_BP
pts_29 = [
  Geom::Point3d.new(ox+6000, oy+42000, 0),
  Geom::Point3d.new(ox+6360, oy+42000, 0),
  Geom::Point3d.new(ox+6360, oy+42360, 0),
  Geom::Point3d.new(ox+6000, oy+42360, 0)
]
f_29 = ents.add_face(pts_29)
f_29.material = mat_Concrete if f_29
f_29.layer = layers['cols'] if f_29
f_29.pushpull(3500) if f_29
# Column 31: 410UB_BP
pts_30 = [
  Geom::Point3d.new(ox+12000, oy+42000, 0),
  Geom::Point3d.new(ox+12410, oy+42000, 0),
  Geom::Point3d.new(ox+12410, oy+42410, 0),
  Geom::Point3d.new(ox+12000, oy+42410, 0)
]
f_30 = ents.add_face(pts_30)
f_30.material = mat_Concrete if f_30
f_30.layer = layers['cols'] if f_30
f_30.pushpull(3500) if f_30
# Column 32: 460UB_BP
pts_31 = [
  Geom::Point3d.new(ox+18000, oy+42000, 0),
  Geom::Point3d.new(ox+18460, oy+42000, 0),
  Geom::Point3d.new(ox+18460, oy+42460, 0),
  Geom::Point3d.new(ox+18000, oy+42460, 0)
]
f_31 = ents.add_face(pts_31)
f_31.material = mat_Concrete if f_31
f_31.layer = layers['cols'] if f_31
f_31.pushpull(3500) if f_31
# Column 33: 530UB_BP
pts_32 = [
  Geom::Point3d.new(ox+0, oy+48000, 0),
  Geom::Point3d.new(ox+530, oy+48000, 0),
  Geom::Point3d.new(ox+530, oy+48530, 0),
  Geom::Point3d.new(ox+0, oy+48530, 0)
]
f_32 = ents.add_face(pts_32)
f_32.material = mat_Concrete if f_32
f_32.layer = layers['cols'] if f_32
f_32.pushpull(3500) if f_32
# Column 34: 150UC_BP
pts_33 = [
  Geom::Point3d.new(ox+6000, oy+48000, 0),
  Geom::Point3d.new(ox+6150, oy+48000, 0),
  Geom::Point3d.new(ox+6150, oy+48150, 0),
  Geom::Point3d.new(ox+6000, oy+48150, 0)
]
f_33 = ents.add_face(pts_33)
f_33.material = mat_Concrete if f_33
f_33.layer = layers['cols'] if f_33
f_33.pushpull(3500) if f_33
# Column 35: 200UC_BP
pts_34 = [
  Geom::Point3d.new(ox+12000, oy+48000, 0),
  Geom::Point3d.new(ox+12200, oy+48000, 0),
  Geom::Point3d.new(ox+12200, oy+48200, 0),
  Geom::Point3d.new(ox+12000, oy+48200, 0)
]
f_34 = ents.add_face(pts_34)
f_34.material = mat_Concrete if f_34
f_34.layer = layers['cols'] if f_34
f_34.pushpull(3500) if f_34
# Column 36: 250UC_BP
pts_35 = [
  Geom::Point3d.new(ox+18000, oy+48000, 0),
  Geom::Point3d.new(ox+18250, oy+48000, 0),
  Geom::Point3d.new(ox+18250, oy+48250, 0),
  Geom::Point3d.new(ox+18000, oy+48250, 0)
]
f_35 = ents.add_face(pts_35)
f_35.material = mat_Concrete if f_35
f_35.layer = layers['cols'] if f_35
f_35.pushpull(3500) if f_35
# Column 37: 310UC_BP
pts_36 = [
  Geom::Point3d.new(ox+0, oy+54000, 0),
  Geom::Point3d.new(ox+310, oy+54000, 0),
  Geom::Point3d.new(ox+310, oy+54310, 0),
  Geom::Point3d.new(ox+0, oy+54310, 0)
]
f_36 = ents.add_face(pts_36)
f_36.material = mat_Concrete if f_36
f_36.layer = layers['cols'] if f_36
f_36.pushpull(3500) if f_36
# Column 38: 75SHS_BP
pts_37 = [
  Geom::Point3d.new(ox+6000, oy+54000, 0),
  Geom::Point3d.new(ox+6100, oy+54000, 0),
  Geom::Point3d.new(ox+6100, oy+54100, 0),
  Geom::Point3d.new(ox+6000, oy+54100, 0)
]
f_37 = ents.add_face(pts_37)
f_37.material = mat_Concrete if f_37
f_37.layer = layers['cols'] if f_37
f_37.pushpull(3500) if f_37
# Column 39: 89SHS_BP
pts_38 = [
  Geom::Point3d.new(ox+12000, oy+54000, 0),
  Geom::Point3d.new(ox+12100, oy+54000, 0),
  Geom::Point3d.new(ox+12100, oy+54100, 0),
  Geom::Point3d.new(ox+12000, oy+54100, 0)
]
f_38 = ents.add_face(pts_38)
f_38.material = mat_Concrete if f_38
f_38.layer = layers['cols'] if f_38
f_38.pushpull(3500) if f_38
# Column 40: 100SHS_BP
pts_39 = [
  Geom::Point3d.new(ox+18000, oy+54000, 0),
  Geom::Point3d.new(ox+18100, oy+54000, 0),
  Geom::Point3d.new(ox+18100, oy+54100, 0),
  Geom::Point3d.new(ox+18000, oy+54100, 0)
]
f_39 = ents.add_face(pts_39)
f_39.material = mat_Concrete if f_39
f_39.layer = layers['cols'] if f_39
f_39.pushpull(3500) if f_39
# Column 41: 125SHS_BP
pts_40 = [
  Geom::Point3d.new(ox+0, oy+60000, 0),
  Geom::Point3d.new(ox+125, oy+60000, 0),
  Geom::Point3d.new(ox+125, oy+60125, 0),
  Geom::Point3d.new(ox+0, oy+60125, 0)
]
f_40 = ents.add_face(pts_40)
f_40.material = mat_Concrete if f_40
f_40.layer = layers['cols'] if f_40
f_40.pushpull(3500) if f_40
# Column 42: 200SHS_BP
pts_41 = [
  Geom::Point3d.new(ox+6000, oy+60000, 0),
  Geom::Point3d.new(ox+6200, oy+60000, 0),
  Geom::Point3d.new(ox+6200, oy+60200, 0),
  Geom::Point3d.new(ox+6000, oy+60200, 0)
]
f_41 = ents.add_face(pts_41)
f_41.material = mat_Concrete if f_41
f_41.layer = layers['cols'] if f_41
f_41.pushpull(3500) if f_41
# Column 43: 250SHS_BP
pts_42 = [
  Geom::Point3d.new(ox+12000, oy+60000, 0),
  Geom::Point3d.new(ox+12250, oy+60000, 0),
  Geom::Point3d.new(ox+12250, oy+60250, 0),
  Geom::Point3d.new(ox+12000, oy+60250, 0)
]
f_42 = ents.add_face(pts_42)
f_42.material = mat_Concrete if f_42
f_42.layer = layers['cols'] if f_42
f_42.pushpull(3500) if f_42
# Column 44: 219CHS_BP
pts_43 = [
  Geom::Point3d.new(ox+18000, oy+60000, 0),
  Geom::Point3d.new(ox+18219, oy+60000, 0),
  Geom::Point3d.new(ox+18219, oy+60219, 0),
  Geom::Point3d.new(ox+18000, oy+60219, 0)
]
f_43 = ents.add_face(pts_43)
f_43.material = mat_Concrete if f_43
f_43.layer = layers['cols'] if f_43
f_43.pushpull(3500) if f_43
# Column 45: 273CHS_BP
pts_44 = [
  Geom::Point3d.new(ox+0, oy+66000, 0),
  Geom::Point3d.new(ox+273, oy+66000, 0),
  Geom::Point3d.new(ox+273, oy+66273, 0),
  Geom::Point3d.new(ox+0, oy+66273, 0)
]
f_44 = ents.add_face(pts_44)
f_44.material = mat_Concrete if f_44
f_44.layer = layers['cols'] if f_44
f_44.pushpull(3500) if f_44
# Column 46: Column D
pts_45 = [
  Geom::Point3d.new(ox+0, oy+0, 0),
  Geom::Point3d.new(ox+400, oy+0, 0),
  Geom::Point3d.new(ox+400, oy+400, 0),
  Geom::Point3d.new(ox+0, oy+400, 0)
]
f_45 = ents.add_face(pts_45)
f_45.material = mat_Concrete if f_45
f_45.layer = layers['cols'] if f_45
f_45.pushpull(3500) if f_45
# Column 47: Column C
pts_46 = [
  Geom::Point3d.new(ox+0, oy+0, 0),
  Geom::Point3d.new(ox+400, oy+0, 0),
  Geom::Point3d.new(ox+400, oy+400, 0),
  Geom::Point3d.new(ox+0, oy+400, 0)
]
f_46 = ents.add_face(pts_46)
f_46.material = mat_Concrete if f_46
f_46.layer = layers['cols'] if f_46
f_46.pushpull(3500) if f_46
# Column 48: Column B
pts_47 = [
  Geom::Point3d.new(ox+0, oy+0, 0),
  Geom::Point3d.new(ox+400, oy+0, 0),
  Geom::Point3d.new(ox+400, oy+400, 0),
  Geom::Point3d.new(ox+0, oy+400, 0)
]
f_47 = ents.add_face(pts_47)
f_47.material = mat_Concrete if f_47
f_47.layer = layers['cols'] if f_47
f_47.pushpull(3500) if f_47
# Column 49: Column A
pts_48 = [
  Geom::Point3d.new(ox+0, oy+0, 0),
  Geom::Point3d.new(ox+400, oy+0, 0),
  Geom::Point3d.new(ox+400, oy+400, 0),
  Geom::Point3d.new(ox+0, oy+400, 0)
]
f_48 = ents.add_face(pts_48)
f_48.material = mat_Concrete if f_48
f_48.layer = layers['cols'] if f_48
f_48.pushpull(3500) if f_48
# Column 50: Column 4
pts_49 = [
  Geom::Point3d.new(ox+18000, oy+0, 0),
  Geom::Point3d.new(ox+18400, oy+0, 0),
  Geom::Point3d.new(ox+18400, oy+400, 0),
  Geom::Point3d.new(ox+18000, oy+400, 0)
]
f_49 = ents.add_face(pts_49)
f_49.material = mat_Concrete if f_49
f_49.layer = layers['cols'] if f_49
f_49.pushpull(3500) if f_49
# Column 51: Column 3
pts_50 = [
  Geom::Point3d.new(ox+12000, oy+0, 0),
  Geom::Point3d.new(ox+12400, oy+0, 0),
  Geom::Point3d.new(ox+12400, oy+400, 0),
  Geom::Point3d.new(ox+12000, oy+400, 0)
]
f_50 = ents.add_face(pts_50)
f_50.material = mat_Concrete if f_50
f_50.layer = layers['cols'] if f_50
f_50.pushpull(3500) if f_50
# Column 52: Column 2
pts_51 = [
  Geom::Point3d.new(ox+6000, oy+0, 0),
  Geom::Point3d.new(ox+6400, oy+0, 0),
  Geom::Point3d.new(ox+6400, oy+400, 0),
  Geom::Point3d.new(ox+6000, oy+400, 0)
]
f_51 = ents.add_face(pts_51)
f_51.material = mat_Concrete if f_51
f_51.layer = layers['cols'] if f_51
f_51.pushpull(3500) if f_51
# Column 53: Column 1
pts_52 = [
  Geom::Point3d.new(ox+0, oy+0, 0),
  Geom::Point3d.new(ox+400, oy+0, 0),
  Geom::Point3d.new(ox+400, oy+400, 0),
  Geom::Point3d.new(ox+0, oy+400, 0)
]
f_52 = ents.add_face(pts_52)
f_52.material = mat_Concrete if f_52
f_52.layer = layers['cols'] if f_52
f_52.pushpull(3500) if f_52

# === Beams ===
# Beam 1: UB20d 1→2
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
    Geom::Point3d.new(blen_0, 20, 0),
    Geom::Point3d.new(0, 20, 0)
  ]
  bf_0 = bg_0.entities.add_face(pts_0)
  bf_0.material = mat_Concrete if bf_0
  bf_0.pushpull(-20) if bf_0
  bg_0.layer = layers['beams']
end
# Beam 2: UB35c 1→2
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
    Geom::Point3d.new(blen_1, 35, 0),
    Geom::Point3d.new(0, 35, 0)
  ]
  bf_1 = bg_1.entities.add_face(pts_1)
  bf_1.material = mat_Concrete if bf_1
  bf_1.pushpull(-35) if bf_1
  bg_1.layer = layers['beams']
end
# Beam 3: UB38c 1→2
bx1_2 = ox + 0; by1_2 = oy + 6000
bx2_2 = ox + 6000; by2_2 = oy + 6000
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
    Geom::Point3d.new(blen_2, 38, 0),
    Geom::Point3d.new(0, 38, 0)
  ]
  bf_2 = bg_2.entities.add_face(pts_2)
  bf_2.material = mat_Concrete if bf_2
  bf_2.pushpull(-38) if bf_2
  bg_2.layer = layers['beams']
end
# Beam 4: PF15a 1→2
bx1_3 = ox + 6000; by1_3 = oy + 6000
bx2_3 = ox + 12000; by2_3 = oy + 6000
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
    Geom::Point3d.new(blen_3, 15, 0),
    Geom::Point3d.new(0, 15, 0)
  ]
  bf_3 = bg_3.entities.add_face(pts_3)
  bf_3.material = mat_Concrete if bf_3
  bf_3.pushpull(-15) if bf_3
  bg_3.layer = layers['beams']
end
# Beam 5: PF25a 1→2
bx1_4 = ox + 0; by1_4 = oy + 12000
bx2_4 = ox + 6000; by2_4 = oy + 12000
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
    Geom::Point3d.new(blen_4, 25, 0),
    Geom::Point3d.new(0, 25, 0)
  ]
  bf_4 = bg_4.entities.add_face(pts_4)
  bf_4.material = mat_Concrete if bf_4
  bf_4.pushpull(-25) if bf_4
  bg_4.layer = layers['beams']
end
# Beam 6: SH20a 1→2
bx1_5 = ox + 6000; by1_5 = oy + 12000
bx2_5 = ox + 12000; by2_5 = oy + 12000
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
    Geom::Point3d.new(blen_5, 20, 0),
    Geom::Point3d.new(0, 20, 0)
  ]
  bf_5 = bg_5.entities.add_face(pts_5)
  bf_5.material = mat_Concrete if bf_5
  bf_5.pushpull(-20) if bf_5
  bg_5.layer = layers['beams']
end
# Beam 7: B1 →
bx1_6 = ox + 0; by1_6 = oy + 0
bx2_6 = ox + 0; by2_6 = oy + 6000
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
# Beam 8: B2 →
bx1_7 = ox + 0; by1_7 = oy + 6000
bx2_7 = ox + 0; by2_7 = oy + 12000
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
# Beam 9: B3 →
bx1_8 = ox + 6000; by1_8 = oy + 0
bx2_8 = ox + 6000; by2_8 = oy + 6000
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
# Beam 10: B4 →
bx1_9 = ox + 6000; by1_9 = oy + 6000
bx2_9 = ox + 6000; by2_9 = oy + 12000
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
# Beam 11: B5 →
bx1_10 = ox + 12000; by1_10 = oy + 0
bx2_10 = ox + 12000; by2_10 = oy + 6000
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
# Beam 12: B6 →
bx1_11 = ox + 12000; by1_11 = oy + 6000
bx2_11 = ox + 12000; by2_11 = oy + 12000
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
# Beam 13: B7 →
bx1_12 = ox + 0; by1_12 = oy + 0
bx2_12 = ox + 6000; by2_12 = oy + 0
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
# Beam 14: B8 →
bx1_13 = ox + 6000; by1_13 = oy + 0
bx2_13 = ox + 12000; by2_13 = oy + 0
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
# Beam 15: B9 →
bx1_14 = ox + 0; by1_14 = oy + 6000
bx2_14 = ox + 6000; by2_14 = oy + 6000
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
# Beam 16: B10 →
bx1_15 = ox + 6000; by1_15 = oy + 6000
bx2_15 = ox + 12000; by2_15 = oy + 6000
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
# Beam 17: B11 →
bx1_16 = ox + 0; by1_16 = oy + 12000
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
    Geom::Point3d.new(blen_16, 300, 0),
    Geom::Point3d.new(0, 300, 0)
  ]
  bf_16 = bg_16.entities.add_face(pts_16)
  bf_16.material = mat_concrete if bf_16
  bf_16.pushpull(-200) if bf_16
  bg_16.layer = layers['beams']
end
# Beam 18: B12 →
bx1_17 = ox + 6000; by1_17 = oy + 12000
bx2_17 = ox + 12000; by2_17 = oy + 12000
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
# Beam 19: B13 →
bx1_18 = ox + 0; by1_18 = oy + 0
bx2_18 = ox + 0; by2_18 = oy + 6000
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
# Beam 20: B14 →
bx1_19 = ox + 0; by1_19 = oy + 6000
bx2_19 = ox + 0; by2_19 = oy + 12000
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
# Beam 21: B15 →
bx1_20 = ox + 6000; by1_20 = oy + 0
bx2_20 = ox + 6000; by2_20 = oy + 6000
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
# Beam 22: B-CH32a-1 →
bx1_21 = ox + 6000; by1_21 = oy + 6000
bx2_21 = ox + 6000; by2_21 = oy + 12000
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
    Geom::Point3d.new(blen_21, 32, 0),
    Geom::Point3d.new(0, 32, 0)
  ]
  bf_21 = bg_21.entities.add_face(pts_21)
  bf_21.material = mat_steel if bf_21
  bf_21.pushpull(-32) if bf_21
  bg_21.layer = layers['beams']
end
# Beam 23: B-UB36c-1 →
bx1_22 = ox + 12000; by1_22 = oy + 0
bx2_22 = ox + 12000; by2_22 = oy + 6000
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
    Geom::Point3d.new(blen_22, 36, 0),
    Geom::Point3d.new(0, 36, 0)
  ]
  bf_22 = bg_22.entities.add_face(pts_22)
  bf_22.material = mat_steel if bf_22
  bf_22.pushpull(-36) if bf_22
  bg_22.layer = layers['beams']
end
# Beam 24: B-SH15b-1 →
bx1_23 = ox + 12000; by1_23 = oy + 6000
bx2_23 = ox + 12000; by2_23 = oy + 12000
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
    Geom::Point3d.new(blen_23, 15, 0),
    Geom::Point3d.new(0, 15, 0)
  ]
  bf_23 = bg_23.entities.add_face(pts_23)
  bf_23.material = mat_steel if bf_23
  bf_23.pushpull(-15) if bf_23
  bg_23.layer = layers['beams']
end
# Beam 25: B-PF15a-1 →
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
  bf_24.material = mat_steel if bf_24
  bf_24.pushpull(-15) if bf_24
  bg_24.layer = layers['beams']
end
# Beam 26: B-PF25a-1 →
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
    Geom::Point3d.new(blen_25, 25, 0),
    Geom::Point3d.new(0, 25, 0)
  ]
  bf_25 = bg_25.entities.add_face(pts_25)
  bf_25.material = mat_steel if bf_25
  bf_25.pushpull(-25) if bf_25
  bg_25.layer = layers['beams']
end
# Beam 27: B-Unlabeled-D-1 →
bx1_26 = ox + 0; by1_26 = oy + 6000
bx2_26 = ox + 6000; by2_26 = oy + 6000
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
    Geom::Point3d.new(blen_26, 300, 0),
    Geom::Point3d.new(0, 300, 0)
  ]
  bf_26 = bg_26.entities.add_face(pts_26)
  bf_26.material = mat_steel if bf_26
  bf_26.pushpull(-200) if bf_26
  bg_26.layer = layers['beams']
end
# Beam 28 [UB_Beam_Type_200UB22.3] 200UB22.3 LOD300 I-profile
bx1_27 = ox+0; by1_27 = oy+0
bx2_27 = ox+6000; by2_27 = oy+0
bdx_27 = bx2_27-bx1_27; bdy_27 = by2_27-by1_27
blen_27 = Math.sqrt(bdx_27**2+bdy_27**2).round
if blen_27 > 0
  bang_27 = Math.atan2(bdy_27, bdx_27)
  bori_27 = Geom::Point3d.new(bx1_27, by1_27, 3500)
  brot_27 = Geom::Transformation.rotation(bori_27, Geom::Vector3d.new(0,0,1), bang_27)
  bg_27 = ents.add_group
  bg_27.transformation = brot_27
  bge_27 = bg_27.entities
  # I-profile in YZ local plane (x=0), Y=flange width, Z=depth
  bp_27 = [
    Geom::Point3d.new(0, -50,          0),
    Geom::Point3d.new(0,  50,          0),
    Geom::Point3d.new(0,  50,         8),
    Geom::Point3d.new(0,  2,         8),
    Geom::Point3d.new(0,  2,         192),
    Geom::Point3d.new(0,  50,         192),
    Geom::Point3d.new(0,  50,          200),
    Geom::Point3d.new(0, -50,          200),
    Geom::Point3d.new(0, -50,         192),
    Geom::Point3d.new(0, -3,         192),
    Geom::Point3d.new(0, -3,         8),
    Geom::Point3d.new(0, -50,         8)
  ]
  bface_27 = bge_27.add_face(bp_27)
  bface_27.material = mat_steel if bface_27
  bface_27.pushpull(blen_27) if bface_27
  bg_27.layer = layers['beams']
end
# Beam 29 [UB_Beam_Type_200UB29.8] 200UB29.8 LOD300 I-profile
bx1_28 = ox+0; by1_28 = oy+0
bx2_28 = ox+6000; by2_28 = oy+0
bdx_28 = bx2_28-bx1_28; bdy_28 = by2_28-by1_28
blen_28 = Math.sqrt(bdx_28**2+bdy_28**2).round
if blen_28 > 0
  bang_28 = Math.atan2(bdy_28, bdx_28)
  bori_28 = Geom::Point3d.new(bx1_28, by1_28, 3500)
  brot_28 = Geom::Transformation.rotation(bori_28, Geom::Vector3d.new(0,0,1), bang_28)
  bg_28 = ents.add_group
  bg_28.transformation = brot_28
  bge_28 = bg_28.entities
  # I-profile in YZ local plane (x=0), Y=flange width, Z=depth
  bp_28 = [
    Geom::Point3d.new(0, -67,          0),
    Geom::Point3d.new(0,  67,          0),
    Geom::Point3d.new(0,  67,         9),
    Geom::Point3d.new(0,  3,         9),
    Geom::Point3d.new(0,  3,         198),
    Geom::Point3d.new(0,  67,         198),
    Geom::Point3d.new(0,  67,          207),
    Geom::Point3d.new(0, -67,          207),
    Geom::Point3d.new(0, -67,         198),
    Geom::Point3d.new(0, -3,         198),
    Geom::Point3d.new(0, -3,         9),
    Geom::Point3d.new(0, -67,         9)
  ]
  bface_28 = bge_28.add_face(bp_28)
  bface_28.material = mat_steel if bface_28
  bface_28.pushpull(blen_28) if bface_28
  bg_28.layer = layers['beams']
end
# Beam 30: UB_Beam_Type_360UB50.7 →
bx1_29 = ox + 6000; by1_29 = oy + 12000
bx2_29 = ox + 12000; by2_29 = oy + 12000
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
    Geom::Point3d.new(blen_29, 7, 0),
    Geom::Point3d.new(0, 7, 0)
  ]
  bf_29 = bg_29.entities.add_face(pts_29)
  bf_29.material = mat_steel if bf_29
  bf_29.pushpull(-360) if bf_29
  bg_29.layer = layers['beams']
end
# Beam 31: UB_Beam_Type_360UB56.7 →
bx1_30 = ox + 0; by1_30 = oy + 0
bx2_30 = ox + 0; by2_30 = oy + 6000
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
    Geom::Point3d.new(blen_30, 7, 0),
    Geom::Point3d.new(0, 7, 0)
  ]
  bf_30 = bg_30.entities.add_face(pts_30)
  bf_30.material = mat_steel if bf_30
  bf_30.pushpull(-360) if bf_30
  bg_30.layer = layers['beams']
end
# Beam 32: Z10-a →
bx1_31 = ox + 0; by1_31 = oy + 6000
bx2_31 = ox + 0; by2_31 = oy + 12000
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
    Geom::Point3d.new(blen_31, 100, 0),
    Geom::Point3d.new(0, 100, 0)
  ]
  bf_31 = bg_31.entities.add_face(pts_31)
  bf_31.material = mat_Concrete if bf_31
  bf_31.pushpull(-55) if bf_31
  bg_31.layer = layers['beams']
end
# Beam 33: Z10-b →
bx1_32 = ox + 6000; by1_32 = oy + 0
bx2_32 = ox + 6000; by2_32 = oy + 6000
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
    Geom::Point3d.new(blen_32, 100, 0),
    Geom::Point3d.new(0, 100, 0)
  ]
  bf_32 = bg_32.entities.add_face(pts_32)
  bf_32.material = mat_Concrete if bf_32
  bf_32.pushpull(-55) if bf_32
  bg_32.layer = layers['beams']
end
# Beam 34: Z10-c →
bx1_33 = ox + 6000; by1_33 = oy + 6000
bx2_33 = ox + 6000; by2_33 = oy + 12000
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
    Geom::Point3d.new(blen_33, 100, 0),
    Geom::Point3d.new(0, 100, 0)
  ]
  bf_33 = bg_33.entities.add_face(pts_33)
  bf_33.material = mat_Concrete if bf_33
  bf_33.pushpull(-55) if bf_33
  bg_33.layer = layers['beams']
end
# Beam 35: Z10-d →
bx1_34 = ox + 12000; by1_34 = oy + 0
bx2_34 = ox + 12000; by2_34 = oy + 6000
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
    Geom::Point3d.new(blen_34, 100, 0),
    Geom::Point3d.new(0, 100, 0)
  ]
  bf_34 = bg_34.entities.add_face(pts_34)
  bf_34.material = mat_Concrete if bf_34
  bf_34.pushpull(-55) if bf_34
  bg_34.layer = layers['beams']
end
# Beam 36: Z15-b →
bx1_35 = ox + 12000; by1_35 = oy + 6000
bx2_35 = ox + 12000; by2_35 = oy + 12000
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
    Geom::Point3d.new(blen_35, 150, 0),
    Geom::Point3d.new(0, 150, 0)
  ]
  bf_35 = bg_35.entities.add_face(pts_35)
  bf_35.material = mat_Concrete if bf_35
  bf_35.pushpull(-82) if bf_35
  bg_35.layer = layers['beams']
end
# Beam 37: Z15-c →
bx1_36 = ox + 0; by1_36 = oy + 0
bx2_36 = ox + 6000; by2_36 = oy + 0
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
    Geom::Point3d.new(blen_36, 150, 0),
    Geom::Point3d.new(0, 150, 0)
  ]
  bf_36 = bg_36.entities.add_face(pts_36)
  bf_36.material = mat_Concrete if bf_36
  bf_36.pushpull(-82) if bf_36
  bg_36.layer = layers['beams']
end
# Beam 38: Z15-d →
bx1_37 = ox + 6000; by1_37 = oy + 0
bx2_37 = ox + 12000; by2_37 = oy + 0
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
    Geom::Point3d.new(blen_37, 150, 0),
    Geom::Point3d.new(0, 150, 0)
  ]
  bf_37 = bg_37.entities.add_face(pts_37)
  bf_37.material = mat_Concrete if bf_37
  bf_37.pushpull(-82) if bf_37
  bg_37.layer = layers['beams']
end
# Beam 39: Z15-e →
bx1_38 = ox + 0; by1_38 = oy + 6000
bx2_38 = ox + 6000; by2_38 = oy + 6000
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
    Geom::Point3d.new(blen_38, 150, 0),
    Geom::Point3d.new(0, 150, 0)
  ]
  bf_38 = bg_38.entities.add_face(pts_38)
  bf_38.material = mat_Concrete if bf_38
  bf_38.pushpull(-82) if bf_38
  bg_38.layer = layers['beams']
end
# Beam 40: Z20-c →
bx1_39 = ox + 6000; by1_39 = oy + 6000
bx2_39 = ox + 12000; by2_39 = oy + 6000
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
    Geom::Point3d.new(blen_39, 200, 0),
    Geom::Point3d.new(0, 200, 0)
  ]
  bf_39 = bg_39.entities.add_face(pts_39)
  bf_39.material = mat_Concrete if bf_39
  bf_39.pushpull(-110) if bf_39
  bg_39.layer = layers['beams']
end
# Beam 41: Z20-d →
bx1_40 = ox + 0; by1_40 = oy + 12000
bx2_40 = ox + 6000; by2_40 = oy + 12000
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
    Geom::Point3d.new(blen_40, 200, 0),
    Geom::Point3d.new(0, 200, 0)
  ]
  bf_40 = bg_40.entities.add_face(pts_40)
  bf_40.material = mat_Concrete if bf_40
  bf_40.pushpull(-110) if bf_40
  bg_40.layer = layers['beams']
end
# Beam 42: Z20-e →
bx1_41 = ox + 6000; by1_41 = oy + 12000
bx2_41 = ox + 12000; by2_41 = oy + 12000
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
    Geom::Point3d.new(blen_41, 200, 0),
    Geom::Point3d.new(0, 200, 0)
  ]
  bf_41 = bg_41.entities.add_face(pts_41)
  bf_41.material = mat_Concrete if bf_41
  bf_41.pushpull(-110) if bf_41
  bg_41.layer = layers['beams']
end
# Beam 43: Z25-d →
bx1_42 = ox + 0; by1_42 = oy + 0
bx2_42 = ox + 0; by2_42 = oy + 6000
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
    Geom::Point3d.new(blen_42, 250, 0),
    Geom::Point3d.new(0, 250, 0)
  ]
  bf_42 = bg_42.entities.add_face(pts_42)
  bf_42.material = mat_Concrete if bf_42
  bf_42.pushpull(-137) if bf_42
  bg_42.layer = layers['beams']
end
# Beam 44: Z25-e →
bx1_43 = ox + 0; by1_43 = oy + 6000
bx2_43 = ox + 0; by2_43 = oy + 12000
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
    Geom::Point3d.new(blen_43, 250, 0),
    Geom::Point3d.new(0, 250, 0)
  ]
  bf_43 = bg_43.entities.add_face(pts_43)
  bf_43.material = mat_Concrete if bf_43
  bf_43.pushpull(-137) if bf_43
  bg_43.layer = layers['beams']
end
# Beam 45: Z30-e →
bx1_44 = ox + 6000; by1_44 = oy + 0
bx2_44 = ox + 6000; by2_44 = oy + 6000
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
    Geom::Point3d.new(blen_44, 300, 0),
    Geom::Point3d.new(0, 300, 0)
  ]
  bf_44 = bg_44.entities.add_face(pts_44)
  bf_44.material = mat_Concrete if bf_44
  bf_44.pushpull(-165) if bf_44
  bg_44.layer = layers['beams']
end
# Beam 46: Z30-f →
bx1_45 = ox + 6000; by1_45 = oy + 6000
bx2_45 = ox + 6000; by2_45 = oy + 12000
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
    Geom::Point3d.new(blen_45, 300, 0),
    Geom::Point3d.new(0, 300, 0)
  ]
  bf_45 = bg_45.entities.add_face(pts_45)
  bf_45.material = mat_Concrete if bf_45
  bf_45.pushpull(-165) if bf_45
  bg_45.layer = layers['beams']
end
# Beam 47: Z35-f →
bx1_46 = ox + 12000; by1_46 = oy + 0
bx2_46 = ox + 12000; by2_46 = oy + 6000
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
    Geom::Point3d.new(blen_46, 350, 0),
    Geom::Point3d.new(0, 350, 0)
  ]
  bf_46 = bg_46.entities.add_face(pts_46)
  bf_46.material = mat_Concrete if bf_46
  bf_46.pushpull(-192) if bf_46
  bg_46.layer = layers['beams']
end
# Beam 48: C10-a →
bx1_47 = ox + 12000; by1_47 = oy + 6000
bx2_47 = ox + 12000; by2_47 = oy + 12000
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
    Geom::Point3d.new(blen_47, 100, 0),
    Geom::Point3d.new(0, 100, 0)
  ]
  bf_47 = bg_47.entities.add_face(pts_47)
  bf_47.material = mat_Concrete if bf_47
  bf_47.pushpull(-55) if bf_47
  bg_47.layer = layers['beams']
end
# Beam 49: C10-b →
bx1_48 = ox + 0; by1_48 = oy + 0
bx2_48 = ox + 6000; by2_48 = oy + 0
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
    Geom::Point3d.new(blen_48, 100, 0),
    Geom::Point3d.new(0, 100, 0)
  ]
  bf_48 = bg_48.entities.add_face(pts_48)
  bf_48.material = mat_Concrete if bf_48
  bf_48.pushpull(-55) if bf_48
  bg_48.layer = layers['beams']
end
# Beam 50: C10-c →
bx1_49 = ox + 6000; by1_49 = oy + 0
bx2_49 = ox + 12000; by2_49 = oy + 0
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
    Geom::Point3d.new(blen_49, 100, 0),
    Geom::Point3d.new(0, 100, 0)
  ]
  bf_49 = bg_49.entities.add_face(pts_49)
  bf_49.material = mat_Concrete if bf_49
  bf_49.pushpull(-55) if bf_49
  bg_49.layer = layers['beams']
end
# Beam 51: C10-d →
bx1_50 = ox + 0; by1_50 = oy + 6000
bx2_50 = ox + 6000; by2_50 = oy + 6000
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
    Geom::Point3d.new(blen_50, 100, 0),
    Geom::Point3d.new(0, 100, 0)
  ]
  bf_50 = bg_50.entities.add_face(pts_50)
  bf_50.material = mat_Concrete if bf_50
  bf_50.pushpull(-55) if bf_50
  bg_50.layer = layers['beams']
end
# Beam 52: C15-b →
bx1_51 = ox + 6000; by1_51 = oy + 6000
bx2_51 = ox + 12000; by2_51 = oy + 6000
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
    Geom::Point3d.new(blen_51, 150, 0),
    Geom::Point3d.new(0, 150, 0)
  ]
  bf_51 = bg_51.entities.add_face(pts_51)
  bf_51.material = mat_Concrete if bf_51
  bf_51.pushpull(-82) if bf_51
  bg_51.layer = layers['beams']
end
# Beam 53: C15-c →
bx1_52 = ox + 0; by1_52 = oy + 12000
bx2_52 = ox + 6000; by2_52 = oy + 12000
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
    Geom::Point3d.new(blen_52, 150, 0),
    Geom::Point3d.new(0, 150, 0)
  ]
  bf_52 = bg_52.entities.add_face(pts_52)
  bf_52.material = mat_Concrete if bf_52
  bf_52.pushpull(-82) if bf_52
  bg_52.layer = layers['beams']
end
# Beam 54: C15-d →
bx1_53 = ox + 6000; by1_53 = oy + 12000
bx2_53 = ox + 12000; by2_53 = oy + 12000
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
    Geom::Point3d.new(blen_53, 150, 0),
    Geom::Point3d.new(0, 150, 0)
  ]
  bf_53 = bg_53.entities.add_face(pts_53)
  bf_53.material = mat_Concrete if bf_53
  bf_53.pushpull(-82) if bf_53
  bg_53.layer = layers['beams']
end
# Beam 55: C15-e →
bx1_54 = ox + 0; by1_54 = oy + 0
bx2_54 = ox + 0; by2_54 = oy + 6000
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
    Geom::Point3d.new(blen_54, 150, 0),
    Geom::Point3d.new(0, 150, 0)
  ]
  bf_54 = bg_54.entities.add_face(pts_54)
  bf_54.material = mat_Concrete if bf_54
  bf_54.pushpull(-82) if bf_54
  bg_54.layer = layers['beams']
end
# Beam 56: C20-c →
bx1_55 = ox + 0; by1_55 = oy + 6000
bx2_55 = ox + 0; by2_55 = oy + 12000
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
    Geom::Point3d.new(blen_55, 200, 0),
    Geom::Point3d.new(0, 200, 0)
  ]
  bf_55 = bg_55.entities.add_face(pts_55)
  bf_55.material = mat_Concrete if bf_55
  bf_55.pushpull(-110) if bf_55
  bg_55.layer = layers['beams']
end
# Beam 57: C20-d →
bx1_56 = ox + 6000; by1_56 = oy + 0
bx2_56 = ox + 6000; by2_56 = oy + 6000
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
    Geom::Point3d.new(blen_56, 200, 0),
    Geom::Point3d.new(0, 200, 0)
  ]
  bf_56 = bg_56.entities.add_face(pts_56)
  bf_56.material = mat_Concrete if bf_56
  bf_56.pushpull(-110) if bf_56
  bg_56.layer = layers['beams']
end
# Beam 58: C20-e →
bx1_57 = ox + 6000; by1_57 = oy + 6000
bx2_57 = ox + 6000; by2_57 = oy + 12000
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
    Geom::Point3d.new(blen_57, 200, 0),
    Geom::Point3d.new(0, 200, 0)
  ]
  bf_57 = bg_57.entities.add_face(pts_57)
  bf_57.material = mat_Concrete if bf_57
  bf_57.pushpull(-110) if bf_57
  bg_57.layer = layers['beams']
end
# Beam 59: C25-d →
bx1_58 = ox + 12000; by1_58 = oy + 0
bx2_58 = ox + 12000; by2_58 = oy + 6000
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
    Geom::Point3d.new(blen_58, 250, 0),
    Geom::Point3d.new(0, 250, 0)
  ]
  bf_58 = bg_58.entities.add_face(pts_58)
  bf_58.material = mat_Concrete if bf_58
  bf_58.pushpull(-137) if bf_58
  bg_58.layer = layers['beams']
end
# Beam 60: C25-e →
bx1_59 = ox + 12000; by1_59 = oy + 6000
bx2_59 = ox + 12000; by2_59 = oy + 12000
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
    Geom::Point3d.new(blen_59, 250, 0),
    Geom::Point3d.new(0, 250, 0)
  ]
  bf_59 = bg_59.entities.add_face(pts_59)
  bf_59.material = mat_Concrete if bf_59
  bf_59.pushpull(-137) if bf_59
  bg_59.layer = layers['beams']
end
# Beam 61: C30-e →
bx1_60 = ox + 0; by1_60 = oy + 0
bx2_60 = ox + 6000; by2_60 = oy + 0
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
    Geom::Point3d.new(blen_60, 300, 0),
    Geom::Point3d.new(0, 300, 0)
  ]
  bf_60 = bg_60.entities.add_face(pts_60)
  bf_60.material = mat_Concrete if bf_60
  bf_60.pushpull(-165) if bf_60
  bg_60.layer = layers['beams']
end
# Beam 62: C30-f →
bx1_61 = ox + 6000; by1_61 = oy + 0
bx2_61 = ox + 12000; by2_61 = oy + 0
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
    Geom::Point3d.new(blen_61, 300, 0),
    Geom::Point3d.new(0, 300, 0)
  ]
  bf_61 = bg_61.entities.add_face(pts_61)
  bf_61.material = mat_Concrete if bf_61
  bf_61.pushpull(-165) if bf_61
  bg_61.layer = layers['beams']
end
# Beam 63: C35-f →
bx1_62 = ox + 0; by1_62 = oy + 6000
bx2_62 = ox + 6000; by2_62 = oy + 6000
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
    Geom::Point3d.new(blen_62, 350, 0),
    Geom::Point3d.new(0, 350, 0)
  ]
  bf_62 = bg_62.entities.add_face(pts_62)
  bf_62.material = mat_Concrete if bf_62
  bf_62.pushpull(-192) if bf_62
  bg_62.layer = layers['beams']
end
# Beam 64: SH10a →
bx1_63 = ox + 6000; by1_63 = oy + 6000
bx2_63 = ox + 12000; by2_63 = oy + 6000
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
    Geom::Point3d.new(blen_63, 10, 0),
    Geom::Point3d.new(0, 10, 0)
  ]
  bf_63 = bg_63.entities.add_face(pts_63)
  bf_63.material = mat_Concrete if bf_63
  bf_63.pushpull(-10) if bf_63
  bg_63.layer = layers['beams']
end
# Beam 65: SH10d →
bx1_64 = ox + 0; by1_64 = oy + 12000
bx2_64 = ox + 6000; by2_64 = oy + 12000
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
    Geom::Point3d.new(blen_64, 10, 0),
    Geom::Point3d.new(0, 10, 0)
  ]
  bf_64 = bg_64.entities.add_face(pts_64)
  bf_64.material = mat_Concrete if bf_64
  bf_64.pushpull(-10) if bf_64
  bg_64.layer = layers['beams']
end
# Beam 66: SH10f →
bx1_65 = ox + 6000; by1_65 = oy + 12000
bx2_65 = ox + 12000; by2_65 = oy + 12000
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
    Geom::Point3d.new(blen_65, 10, 0),
    Geom::Point3d.new(0, 10, 0)
  ]
  bf_65 = bg_65.entities.add_face(pts_65)
  bf_65.material = mat_Concrete if bf_65
  bf_65.pushpull(-10) if bf_65
  bg_65.layer = layers['beams']
end
# Beam 67: SH10i →
bx1_66 = ox + 0; by1_66 = oy + 0
bx2_66 = ox + 0; by2_66 = oy + 6000
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
    Geom::Point3d.new(blen_66, 10, 0),
    Geom::Point3d.new(0, 10, 0)
  ]
  bf_66 = bg_66.entities.add_face(pts_66)
  bf_66.material = mat_Concrete if bf_66
  bf_66.pushpull(-10) if bf_66
  bg_66.layer = layers['beams']
end
# Beam 68: SH15a →
bx1_67 = ox + 0; by1_67 = oy + 6000
bx2_67 = ox + 0; by2_67 = oy + 12000
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
    Geom::Point3d.new(blen_67, 15, 0),
    Geom::Point3d.new(0, 15, 0)
  ]
  bf_67 = bg_67.entities.add_face(pts_67)
  bf_67.material = mat_Concrete if bf_67
  bf_67.pushpull(-15) if bf_67
  bg_67.layer = layers['beams']
end
# Beam 69: SH15b →
bx1_68 = ox + 6000; by1_68 = oy + 0
bx2_68 = ox + 6000; by2_68 = oy + 6000
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
    Geom::Point3d.new(blen_68, 15, 0),
    Geom::Point3d.new(0, 15, 0)
  ]
  bf_68 = bg_68.entities.add_face(pts_68)
  bf_68.material = mat_Concrete if bf_68
  bf_68.pushpull(-15) if bf_68
  bg_68.layer = layers['beams']
end
# Beam 70: SH15c →
bx1_69 = ox + 6000; by1_69 = oy + 6000
bx2_69 = ox + 6000; by2_69 = oy + 12000
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
    Geom::Point3d.new(blen_69, 15, 0),
    Geom::Point3d.new(0, 15, 0)
  ]
  bf_69 = bg_69.entities.add_face(pts_69)
  bf_69.material = mat_Concrete if bf_69
  bf_69.pushpull(-15) if bf_69
  bg_69.layer = layers['beams']
end
# Beam 71: SH15d →
bx1_70 = ox + 12000; by1_70 = oy + 0
bx2_70 = ox + 12000; by2_70 = oy + 6000
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
    Geom::Point3d.new(blen_70, 15, 0),
    Geom::Point3d.new(0, 15, 0)
  ]
  bf_70 = bg_70.entities.add_face(pts_70)
  bf_70.material = mat_Concrete if bf_70
  bf_70.pushpull(-15) if bf_70
  bg_70.layer = layers['beams']
end
# Beam 72: SH15e →
bx1_71 = ox + 12000; by1_71 = oy + 6000
bx2_71 = ox + 12000; by2_71 = oy + 12000
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
    Geom::Point3d.new(blen_71, 15, 0),
    Geom::Point3d.new(0, 15, 0)
  ]
  bf_71 = bg_71.entities.add_face(pts_71)
  bf_71.material = mat_Concrete if bf_71
  bf_71.pushpull(-15) if bf_71
  bg_71.layer = layers['beams']
end
# Beam 73: SH15f →
bx1_72 = ox + 0; by1_72 = oy + 0
bx2_72 = ox + 6000; by2_72 = oy + 0
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
    Geom::Point3d.new(blen_72, 15, 0),
    Geom::Point3d.new(0, 15, 0)
  ]
  bf_72 = bg_72.entities.add_face(pts_72)
  bf_72.material = mat_Concrete if bf_72
  bf_72.pushpull(-15) if bf_72
  bg_72.layer = layers['beams']
end
# Beam 74: SH15g →
bx1_73 = ox + 6000; by1_73 = oy + 0
bx2_73 = ox + 12000; by2_73 = oy + 0
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
    Geom::Point3d.new(blen_73, 15, 0),
    Geom::Point3d.new(0, 15, 0)
  ]
  bf_73 = bg_73.entities.add_face(pts_73)
  bf_73.material = mat_Concrete if bf_73
  bf_73.pushpull(-15) if bf_73
  bg_73.layer = layers['beams']
end
# Beam 75: SH15h →
bx1_74 = ox + 0; by1_74 = oy + 6000
bx2_74 = ox + 6000; by2_74 = oy + 6000
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
    Geom::Point3d.new(blen_74, 15, 0),
    Geom::Point3d.new(0, 15, 0)
  ]
  bf_74 = bg_74.entities.add_face(pts_74)
  bf_74.material = mat_Concrete if bf_74
  bf_74.pushpull(-15) if bf_74
  bg_74.layer = layers['beams']
end
# Beam 76: SH15i →
bx1_75 = ox + 6000; by1_75 = oy + 6000
bx2_75 = ox + 12000; by2_75 = oy + 6000
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
    Geom::Point3d.new(blen_75, 15, 0),
    Geom::Point3d.new(0, 15, 0)
  ]
  bf_75 = bg_75.entities.add_face(pts_75)
  bf_75.material = mat_Concrete if bf_75
  bf_75.pushpull(-15) if bf_75
  bg_75.layer = layers['beams']
end
# Beam 77: SH15j →
bx1_76 = ox + 0; by1_76 = oy + 12000
bx2_76 = ox + 6000; by2_76 = oy + 12000
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
    Geom::Point3d.new(blen_76, 15, 0),
    Geom::Point3d.new(0, 15, 0)
  ]
  bf_76 = bg_76.entities.add_face(pts_76)
  bf_76.material = mat_Concrete if bf_76
  bf_76.pushpull(-15) if bf_76
  bg_76.layer = layers['beams']
end
# Beam 78: SH07g →
bx1_77 = ox + 6000; by1_77 = oy + 12000
bx2_77 = ox + 12000; by2_77 = oy + 12000
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
    Geom::Point3d.new(blen_77, 7, 0),
    Geom::Point3d.new(0, 7, 0)
  ]
  bf_77 = bg_77.entities.add_face(pts_77)
  bf_77.material = mat_Concrete if bf_77
  bf_77.pushpull(-7) if bf_77
  bg_77.layer = layers['beams']
end
# Beam 79: SH08d →
bx1_78 = ox + 0; by1_78 = oy + 0
bx2_78 = ox + 0; by2_78 = oy + 6000
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
    Geom::Point3d.new(blen_78, 8, 0),
    Geom::Point3d.new(0, 8, 0)
  ]
  bf_78 = bg_78.entities.add_face(pts_78)
  bf_78.material = mat_Concrete if bf_78
  bf_78.pushpull(-8) if bf_78
  bg_78.layer = layers['beams']
end
# Beam 80: SH08e →
bx1_79 = ox + 0; by1_79 = oy + 6000
bx2_79 = ox + 0; by2_79 = oy + 12000
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
    Geom::Point3d.new(blen_79, 8, 0),
    Geom::Point3d.new(0, 8, 0)
  ]
  bf_79 = bg_79.entities.add_face(pts_79)
  bf_79.material = mat_Concrete if bf_79
  bf_79.pushpull(-8) if bf_79
  bg_79.layer = layers['beams']
end
# Beam 81: SH08f →
bx1_80 = ox + 6000; by1_80 = oy + 0
bx2_80 = ox + 6000; by2_80 = oy + 6000
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
    Geom::Point3d.new(blen_80, 8, 0),
    Geom::Point3d.new(0, 8, 0)
  ]
  bf_80 = bg_80.entities.add_face(pts_80)
  bf_80.material = mat_Concrete if bf_80
  bf_80.pushpull(-8) if bf_80
  bg_80.layer = layers['beams']
end
# Beam 82: SH08g →
bx1_81 = ox + 6000; by1_81 = oy + 6000
bx2_81 = ox + 6000; by2_81 = oy + 12000
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
    Geom::Point3d.new(blen_81, 8, 0),
    Geom::Point3d.new(0, 8, 0)
  ]
  bf_81 = bg_81.entities.add_face(pts_81)
  bf_81.material = mat_Concrete if bf_81
  bf_81.pushpull(-8) if bf_81
  bg_81.layer = layers['beams']
end
# Beam 83: SH08h →
bx1_82 = ox + 12000; by1_82 = oy + 0
bx2_82 = ox + 12000; by2_82 = oy + 6000
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
    Geom::Point3d.new(blen_82, 8, 0),
    Geom::Point3d.new(0, 8, 0)
  ]
  bf_82 = bg_82.entities.add_face(pts_82)
  bf_82.material = mat_Concrete if bf_82
  bf_82.pushpull(-8) if bf_82
  bg_82.layer = layers['beams']
end
# Beam 84: SH08i →
bx1_83 = ox + 12000; by1_83 = oy + 6000
bx2_83 = ox + 12000; by2_83 = oy + 12000
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
    Geom::Point3d.new(blen_83, 8, 0),
    Geom::Point3d.new(0, 8, 0)
  ]
  bf_83 = bg_83.entities.add_face(pts_83)
  bf_83.material = mat_Concrete if bf_83
  bf_83.pushpull(-8) if bf_83
  bg_83.layer = layers['beams']
end
# Beam 85: SH08j →
bx1_84 = ox + 0; by1_84 = oy + 0
bx2_84 = ox + 6000; by2_84 = oy + 0
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
    Geom::Point3d.new(blen_84, 8, 0),
    Geom::Point3d.new(0, 8, 0)
  ]
  bf_84 = bg_84.entities.add_face(pts_84)
  bf_84.material = mat_Concrete if bf_84
  bf_84.pushpull(-8) if bf_84
  bg_84.layer = layers['beams']
end
# Beam 86: SH08k →
bx1_85 = ox + 6000; by1_85 = oy + 0
bx2_85 = ox + 12000; by2_85 = oy + 0
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
  bf_85.material = mat_Concrete if bf_85
  bf_85.pushpull(-8) if bf_85
  bg_85.layer = layers['beams']
end
# Beam 87: SH08l →
bx1_86 = ox + 0; by1_86 = oy + 6000
bx2_86 = ox + 6000; by2_86 = oy + 6000
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
  bf_86.material = mat_Concrete if bf_86
  bf_86.pushpull(-8) if bf_86
  bg_86.layer = layers['beams']
end
# Beam 88: SH08m →
bx1_87 = ox + 6000; by1_87 = oy + 6000
bx2_87 = ox + 12000; by2_87 = oy + 6000
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
    Geom::Point3d.new(blen_87, 8, 0),
    Geom::Point3d.new(0, 8, 0)
  ]
  bf_87 = bg_87.entities.add_face(pts_87)
  bf_87.material = mat_Concrete if bf_87
  bf_87.pushpull(-8) if bf_87
  bg_87.layer = layers['beams']
end
# Beam 89: SH08n →
bx1_88 = ox + 0; by1_88 = oy + 12000
bx2_88 = ox + 6000; by2_88 = oy + 12000
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
    Geom::Point3d.new(blen_88, 8, 0),
    Geom::Point3d.new(0, 8, 0)
  ]
  bf_88 = bg_88.entities.add_face(pts_88)
  bf_88.material = mat_Concrete if bf_88
  bf_88.pushpull(-8) if bf_88
  bg_88.layer = layers['beams']
end
# Beam 90: SH08o →
bx1_89 = ox + 6000; by1_89 = oy + 12000
bx2_89 = ox + 12000; by2_89 = oy + 12000
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
    Geom::Point3d.new(blen_89, 8, 0),
    Geom::Point3d.new(0, 8, 0)
  ]
  bf_89 = bg_89.entities.add_face(pts_89)
  bf_89.material = mat_Concrete if bf_89
  bf_89.pushpull(-8) if bf_89
  bg_89.layer = layers['beams']
end
# Beam 91: SH08p →
bx1_90 = ox + 0; by1_90 = oy + 0
bx2_90 = ox + 0; by2_90 = oy + 6000
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
    Geom::Point3d.new(blen_90, 8, 0),
    Geom::Point3d.new(0, 8, 0)
  ]
  bf_90 = bg_90.entities.add_face(pts_90)
  bf_90.material = mat_Concrete if bf_90
  bf_90.pushpull(-8) if bf_90
  bg_90.layer = layers['beams']
end
# Beam 92: SH08q →
bx1_91 = ox + 0; by1_91 = oy + 6000
bx2_91 = ox + 0; by2_91 = oy + 12000
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
    Geom::Point3d.new(blen_91, 8, 0),
    Geom::Point3d.new(0, 8, 0)
  ]
  bf_91 = bg_91.entities.add_face(pts_91)
  bf_91.material = mat_Concrete if bf_91
  bf_91.pushpull(-8) if bf_91
  bg_91.layer = layers['beams']
end
# Beam 93: SH08r →
bx1_92 = ox + 6000; by1_92 = oy + 0
bx2_92 = ox + 6000; by2_92 = oy + 6000
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
    Geom::Point3d.new(blen_92, 8, 0),
    Geom::Point3d.new(0, 8, 0)
  ]
  bf_92 = bg_92.entities.add_face(pts_92)
  bf_92.material = mat_Concrete if bf_92
  bf_92.pushpull(-8) if bf_92
  bg_92.layer = layers['beams']
end
# Beam 94: SH08s →
bx1_93 = ox + 6000; by1_93 = oy + 6000
bx2_93 = ox + 6000; by2_93 = oy + 12000
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
    Geom::Point3d.new(blen_93, 8, 0),
    Geom::Point3d.new(0, 8, 0)
  ]
  bf_93 = bg_93.entities.add_face(pts_93)
  bf_93.material = mat_Concrete if bf_93
  bf_93.pushpull(-8) if bf_93
  bg_93.layer = layers['beams']
end
# Beam 95: SH08t →
bx1_94 = ox + 12000; by1_94 = oy + 0
bx2_94 = ox + 12000; by2_94 = oy + 6000
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
    Geom::Point3d.new(blen_94, 8, 0),
    Geom::Point3d.new(0, 8, 0)
  ]
  bf_94 = bg_94.entities.add_face(pts_94)
  bf_94.material = mat_Concrete if bf_94
  bf_94.pushpull(-8) if bf_94
  bg_94.layer = layers['beams']
end
# Beam 96: SH08u →
bx1_95 = ox + 12000; by1_95 = oy + 6000
bx2_95 = ox + 12000; by2_95 = oy + 12000
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
    Geom::Point3d.new(blen_95, 8, 0),
    Geom::Point3d.new(0, 8, 0)
  ]
  bf_95 = bg_95.entities.add_face(pts_95)
  bf_95.material = mat_Concrete if bf_95
  bf_95.pushpull(-8) if bf_95
  bg_95.layer = layers['beams']
end
# Beam 97: SH08v →
bx1_96 = ox + 0; by1_96 = oy + 0
bx2_96 = ox + 6000; by2_96 = oy + 0
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
    Geom::Point3d.new(blen_96, 8, 0),
    Geom::Point3d.new(0, 8, 0)
  ]
  bf_96 = bg_96.entities.add_face(pts_96)
  bf_96.material = mat_Concrete if bf_96
  bf_96.pushpull(-8) if bf_96
  bg_96.layer = layers['beams']
end
# Beam 98: SH08w →
bx1_97 = ox + 6000; by1_97 = oy + 0
bx2_97 = ox + 12000; by2_97 = oy + 0
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
    Geom::Point3d.new(blen_97, 8, 0),
    Geom::Point3d.new(0, 8, 0)
  ]
  bf_97 = bg_97.entities.add_face(pts_97)
  bf_97.material = mat_Concrete if bf_97
  bf_97.pushpull(-8) if bf_97
  bg_97.layer = layers['beams']
end
# Beam 99: SH08x →
bx1_98 = ox + 0; by1_98 = oy + 6000
bx2_98 = ox + 6000; by2_98 = oy + 6000
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
    Geom::Point3d.new(blen_98, 8, 0),
    Geom::Point3d.new(0, 8, 0)
  ]
  bf_98 = bg_98.entities.add_face(pts_98)
  bf_98.material = mat_Concrete if bf_98
  bf_98.pushpull(-8) if bf_98
  bg_98.layer = layers['beams']
end
# Beam 100: SH08y →
bx1_99 = ox + 6000; by1_99 = oy + 6000
bx2_99 = ox + 12000; by2_99 = oy + 6000
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
    Geom::Point3d.new(blen_99, 8, 0),
    Geom::Point3d.new(0, 8, 0)
  ]
  bf_99 = bg_99.entities.add_face(pts_99)
  bf_99.material = mat_Concrete if bf_99
  bf_99.pushpull(-8) if bf_99
  bg_99.layer = layers['beams']
end
# Beam 101: SH08z →
bx1_100 = ox + 0; by1_100 = oy + 12000
bx2_100 = ox + 6000; by2_100 = oy + 12000
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
    Geom::Point3d.new(blen_100, 8, 0),
    Geom::Point3d.new(0, 8, 0)
  ]
  bf_100 = bg_100.entities.add_face(pts_100)
  bf_100.material = mat_Concrete if bf_100
  bf_100.pushpull(-8) if bf_100
  bg_100.layer = layers['beams']
end
# Beam 102: SH08aa →
bx1_101 = ox + 6000; by1_101 = oy + 12000
bx2_101 = ox + 12000; by2_101 = oy + 12000
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
    Geom::Point3d.new(blen_101, 8, 0),
    Geom::Point3d.new(0, 8, 0)
  ]
  bf_101 = bg_101.entities.add_face(pts_101)
  bf_101.material = mat_Concrete if bf_101
  bf_101.pushpull(-8) if bf_101
  bg_101.layer = layers['beams']
end
# Beam 103: SH08ab →
bx1_102 = ox + 0; by1_102 = oy + 0
bx2_102 = ox + 0; by2_102 = oy + 6000
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
    Geom::Point3d.new(blen_102, 8, 0),
    Geom::Point3d.new(0, 8, 0)
  ]
  bf_102 = bg_102.entities.add_face(pts_102)
  bf_102.material = mat_Concrete if bf_102
  bf_102.pushpull(-8) if bf_102
  bg_102.layer = layers['beams']
end
# Beam 104: SH08ac →
bx1_103 = ox + 0; by1_103 = oy + 6000
bx2_103 = ox + 0; by2_103 = oy + 12000
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
    Geom::Point3d.new(blen_103, 8, 0),
    Geom::Point3d.new(0, 8, 0)
  ]
  bf_103 = bg_103.entities.add_face(pts_103)
  bf_103.material = mat_Concrete if bf_103
  bf_103.pushpull(-8) if bf_103
  bg_103.layer = layers['beams']
end
# Beam 105: SH08ad →
bx1_104 = ox + 6000; by1_104 = oy + 0
bx2_104 = ox + 6000; by2_104 = oy + 6000
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
    Geom::Point3d.new(blen_104, 8, 0),
    Geom::Point3d.new(0, 8, 0)
  ]
  bf_104 = bg_104.entities.add_face(pts_104)
  bf_104.material = mat_Concrete if bf_104
  bf_104.pushpull(-8) if bf_104
  bg_104.layer = layers['beams']
end
# Beam 106: SH08ae →
bx1_105 = ox + 6000; by1_105 = oy + 6000
bx2_105 = ox + 6000; by2_105 = oy + 12000
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
    Geom::Point3d.new(blen_105, 8, 0),
    Geom::Point3d.new(0, 8, 0)
  ]
  bf_105 = bg_105.entities.add_face(pts_105)
  bf_105.material = mat_Concrete if bf_105
  bf_105.pushpull(-8) if bf_105
  bg_105.layer = layers['beams']
end
# Beam 107: SH08af →
bx1_106 = ox + 12000; by1_106 = oy + 0
bx2_106 = ox + 12000; by2_106 = oy + 6000
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
    Geom::Point3d.new(blen_106, 8, 0),
    Geom::Point3d.new(0, 8, 0)
  ]
  bf_106 = bg_106.entities.add_face(pts_106)
  bf_106.material = mat_Concrete if bf_106
  bf_106.pushpull(-8) if bf_106
  bg_106.layer = layers['beams']
end
# Beam 108: SH08ag →
bx1_107 = ox + 12000; by1_107 = oy + 6000
bx2_107 = ox + 12000; by2_107 = oy + 12000
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
    Geom::Point3d.new(blen_107, 8, 0),
    Geom::Point3d.new(0, 8, 0)
  ]
  bf_107 = bg_107.entities.add_face(pts_107)
  bf_107.material = mat_Concrete if bf_107
  bf_107.pushpull(-8) if bf_107
  bg_107.layer = layers['beams']
end
# Beam 109: SH08ah →
bx1_108 = ox + 0; by1_108 = oy + 0
bx2_108 = ox + 6000; by2_108 = oy + 0
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
    Geom::Point3d.new(blen_108, 8, 0),
    Geom::Point3d.new(0, 8, 0)
  ]
  bf_108 = bg_108.entities.add_face(pts_108)
  bf_108.material = mat_Concrete if bf_108
  bf_108.pushpull(-8) if bf_108
  bg_108.layer = layers['beams']
end
# Beam 110: SH08ai →
bx1_109 = ox + 6000; by1_109 = oy + 0
bx2_109 = ox + 12000; by2_109 = oy + 0
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
    Geom::Point3d.new(blen_109, 8, 0),
    Geom::Point3d.new(0, 8, 0)
  ]
  bf_109 = bg_109.entities.add_face(pts_109)
  bf_109.material = mat_Concrete if bf_109
  bf_109.pushpull(-8) if bf_109
  bg_109.layer = layers['beams']
end
# Beam 111: SH08aj →
bx1_110 = ox + 0; by1_110 = oy + 6000
bx2_110 = ox + 6000; by2_110 = oy + 6000
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
    Geom::Point3d.new(blen_110, 8, 0),
    Geom::Point3d.new(0, 8, 0)
  ]
  bf_110 = bg_110.entities.add_face(pts_110)
  bf_110.material = mat_Concrete if bf_110
  bf_110.pushpull(-8) if bf_110
  bg_110.layer = layers['beams']
end
# Beam 112: SH08ak →
bx1_111 = ox + 6000; by1_111 = oy + 6000
bx2_111 = ox + 12000; by2_111 = oy + 6000
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
    Geom::Point3d.new(blen_111, 8, 0),
    Geom::Point3d.new(0, 8, 0)
  ]
  bf_111 = bg_111.entities.add_face(pts_111)
  bf_111.material = mat_Concrete if bf_111
  bf_111.pushpull(-8) if bf_111
  bg_111.layer = layers['beams']
end
# Beam 113: SH08al →
bx1_112 = ox + 0; by1_112 = oy + 12000
bx2_112 = ox + 6000; by2_112 = oy + 12000
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
    Geom::Point3d.new(blen_112, 8, 0),
    Geom::Point3d.new(0, 8, 0)
  ]
  bf_112 = bg_112.entities.add_face(pts_112)
  bf_112.material = mat_Concrete if bf_112
  bf_112.pushpull(-8) if bf_112
  bg_112.layer = layers['beams']
end
# Beam 114: UB36b →
bx1_113 = ox + 6000; by1_113 = oy + 12000
bx2_113 = ox + 12000; by2_113 = oy + 12000
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
    Geom::Point3d.new(blen_113, 36, 0),
    Geom::Point3d.new(0, 36, 0)
  ]
  bf_113 = bg_113.entities.add_face(pts_113)
  bf_113.material = mat_Concrete if bf_113
  bf_113.pushpull(-36) if bf_113
  bg_113.layer = layers['beams']
end
# Beam 115: UB31b →
bx1_114 = ox + 0; by1_114 = oy + 0
bx2_114 = ox + 0; by2_114 = oy + 6000
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
    Geom::Point3d.new(blen_114, 31, 0),
    Geom::Point3d.new(0, 31, 0)
  ]
  bf_114 = bg_114.entities.add_face(pts_114)
  bf_114.material = mat_Concrete if bf_114
  bf_114.pushpull(-31) if bf_114
  bg_114.layer = layers['beams']
end
# Beam 116: PF25b →
bx1_115 = ox + 0; by1_115 = oy + 6000
bx2_115 = ox + 0; by2_115 = oy + 12000
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
    Geom::Point3d.new(blen_115, 25, 0),
    Geom::Point3d.new(0, 25, 0)
  ]
  bf_115 = bg_115.entities.add_face(pts_115)
  bf_115.material = mat_Concrete if bf_115
  bf_115.pushpull(-25) if bf_115
  bg_115.layer = layers['beams']
end
# Beam 117: RB20a →
bx1_116 = ox + 6000; by1_116 = oy + 0
bx2_116 = ox + 6000; by2_116 = oy + 6000
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
    Geom::Point3d.new(blen_116, 20, 0),
    Geom::Point3d.new(0, 20, 0)
  ]
  bf_116 = bg_116.entities.add_face(pts_116)
  bf_116.material = mat_Concrete if bf_116
  bf_116.pushpull(-20) if bf_116
  bg_116.layer = layers['beams']
end
# Beam 118: CB1 →
bx1_117 = ox + 6000; by1_117 = oy + 6000
bx2_117 = ox + 6000; by2_117 = oy + 12000
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
    Geom::Point3d.new(blen_117, 600, 0),
    Geom::Point3d.new(0, 600, 0)
  ]
  bf_117 = bg_117.entities.add_face(pts_117)
  bf_117.material = mat_Concrete if bf_117
  bf_117.pushpull(-750) if bf_117
  bg_117.layer = layers['beams']
end

# === Slabs ===
# Slab 1: S_AUTO_LEVEL 03
pts_0 = [
  Geom::Point3d.new(ox, oy, 3500),
  Geom::Point3d.new(ox+6000, oy, 3500),
  Geom::Point3d.new(ox+6000, oy+6000, 3500),
  Geom::Point3d.new(ox, oy+6000, 3500)
]
f_0 = ents.add_face(pts_0)
f_0.material = mat_reinforced_concrete if f_0
f_0.layer = layers['slabs'] if f_0
f_0.pushpull(-200) if f_0

# === Footings ===
# Footing 1: P1 (pile)
pts_0 = [
  Geom::Point3d.new(ox+-375, oy+-375, 2900),
  Geom::Point3d.new(ox+375, oy+-375, 2900),
  Geom::Point3d.new(ox+375, oy+375, 2900),
  Geom::Point3d.new(ox+-375, oy+375, 2900)
]
f_0 = ents.add_face(pts_0)
f_0.material = mat_Concrete if f_0
f_0.layer = layers['ftgs'] if f_0
f_0.pushpull(600) if f_0
# Footing 2: P2 (pile)
pts_1 = [
  Geom::Point3d.new(ox+-375, oy+-375, 1500),
  Geom::Point3d.new(ox+375, oy+-375, 1500),
  Geom::Point3d.new(ox+375, oy+375, 1500),
  Geom::Point3d.new(ox+-375, oy+375, 1500)
]
f_1 = ents.add_face(pts_1)
f_1.material = mat_Concrete if f_1
f_1.layer = layers['ftgs'] if f_1
f_1.pushpull(2000) if f_1
# Footing 3: P3 (pile)
pts_2 = [
  Geom::Point3d.new(ox+-300, oy+-300, 3200),
  Geom::Point3d.new(ox+300, oy+-300, 3200),
  Geom::Point3d.new(ox+300, oy+300, 3200),
  Geom::Point3d.new(ox+-300, oy+300, 3200)
]
f_2 = ents.add_face(pts_2)
f_2.material = mat_Concrete if f_2
f_2.layer = layers['ftgs'] if f_2
f_2.pushpull(300) if f_2
# Footing 4: P4 (pile)
pts_3 = [
  Geom::Point3d.new(ox+-375, oy+-375, 1500),
  Geom::Point3d.new(ox+375, oy+-375, 1500),
  Geom::Point3d.new(ox+375, oy+375, 1500),
  Geom::Point3d.new(ox+-375, oy+375, 1500)
]
f_3 = ents.add_face(pts_3)
f_3.material = mat_Concrete if f_3
f_3.layer = layers['ftgs'] if f_3
f_3.pushpull(2000) if f_3
# Footing 5: P5 (pile)
pts_4 = [
  Geom::Point3d.new(ox+-375, oy+-375, 1500),
  Geom::Point3d.new(ox+375, oy+-375, 1500),
  Geom::Point3d.new(ox+375, oy+375, 1500),
  Geom::Point3d.new(ox+-375, oy+375, 1500)
]
f_4 = ents.add_face(pts_4)
f_4.material = mat_Concrete if f_4
f_4.layer = layers['ftgs'] if f_4
f_4.pushpull(2000) if f_4
# Footing 6: RF1 (raft)
pts_5 = [
  Geom::Point3d.new(ox+-3250, oy+-2800, 2500),
  Geom::Point3d.new(ox+3250, oy+-2800, 2500),
  Geom::Point3d.new(ox+3250, oy+2800, 2500),
  Geom::Point3d.new(ox+-3250, oy+2800, 2500)
]
f_5 = ents.add_face(pts_5)
f_5.material = mat_Concrete if f_5
f_5.layer = layers['ftgs'] if f_5
f_5.pushpull(1000) if f_5

# === LOD350 Connections ===
layers['conns'] = model.layers.add('Connections_LOD350')
mat_steel_plate = model.materials.add('SteelPlate')
mat_steel_plate.color = Sketchup::Color.new(140,140,160)
# LOD350 base+cap plates: col 1
begin
  bplate_0_pts = [
    Geom::Point3d.new(ox+-150, oy+-150, -20),
    Geom::Point3d.new(ox+150, oy+-150, -20),
    Geom::Point3d.new(ox+150, oy+150, -20),
    Geom::Point3d.new(ox+-150, oy+150, -20)
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
    Geom::Point3d.new(ox+-150, oy+-150, 3500),
    Geom::Point3d.new(ox+150, oy+-150, 3500),
    Geom::Point3d.new(ox+150, oy+150, 3500),
    Geom::Point3d.new(ox+-150, oy+150, 3500)
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
    Geom::Point3d.new(ox+5850, oy+-150, -20),
    Geom::Point3d.new(ox+6150, oy+-150, -20),
    Geom::Point3d.new(ox+6150, oy+150, -20),
    Geom::Point3d.new(ox+5850, oy+150, -20)
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
    Geom::Point3d.new(ox+5850, oy+-150, 3500),
    Geom::Point3d.new(ox+6150, oy+-150, 3500),
    Geom::Point3d.new(ox+6150, oy+150, 3500),
    Geom::Point3d.new(ox+5850, oy+150, 3500)
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
    Geom::Point3d.new(ox+11850, oy+-150, -20),
    Geom::Point3d.new(ox+12150, oy+-150, -20),
    Geom::Point3d.new(ox+12150, oy+150, -20),
    Geom::Point3d.new(ox+11850, oy+150, -20)
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
    Geom::Point3d.new(ox+11850, oy+-150, 3500),
    Geom::Point3d.new(ox+12150, oy+-150, 3500),
    Geom::Point3d.new(ox+12150, oy+150, 3500),
    Geom::Point3d.new(ox+11850, oy+150, 3500)
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
    Geom::Point3d.new(ox+17850, oy+-150, -20),
    Geom::Point3d.new(ox+18150, oy+-150, -20),
    Geom::Point3d.new(ox+18150, oy+150, -20),
    Geom::Point3d.new(ox+17850, oy+150, -20)
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
    Geom::Point3d.new(ox+17850, oy+-150, 3500),
    Geom::Point3d.new(ox+18150, oy+-150, 3500),
    Geom::Point3d.new(ox+18150, oy+150, 3500),
    Geom::Point3d.new(ox+17850, oy+150, 3500)
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
    Geom::Point3d.new(ox+-150, oy+-150, -20),
    Geom::Point3d.new(ox+150, oy+-150, -20),
    Geom::Point3d.new(ox+150, oy+150, -20),
    Geom::Point3d.new(ox+-150, oy+150, -20)
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
    Geom::Point3d.new(ox+-150, oy+-150, 3500),
    Geom::Point3d.new(ox+150, oy+-150, 3500),
    Geom::Point3d.new(ox+150, oy+150, 3500),
    Geom::Point3d.new(ox+-150, oy+150, 3500)
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
    Geom::Point3d.new(ox+5850, oy+-150, -20),
    Geom::Point3d.new(ox+6150, oy+-150, -20),
    Geom::Point3d.new(ox+6150, oy+150, -20),
    Geom::Point3d.new(ox+5850, oy+150, -20)
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
    Geom::Point3d.new(ox+5850, oy+-150, 3500),
    Geom::Point3d.new(ox+6150, oy+-150, 3500),
    Geom::Point3d.new(ox+6150, oy+150, 3500),
    Geom::Point3d.new(ox+5850, oy+150, 3500)
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
    Geom::Point3d.new(ox+11850, oy+-150, -20),
    Geom::Point3d.new(ox+12150, oy+-150, -20),
    Geom::Point3d.new(ox+12150, oy+150, -20),
    Geom::Point3d.new(ox+11850, oy+150, -20)
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
    Geom::Point3d.new(ox+11850, oy+-150, 3500),
    Geom::Point3d.new(ox+12150, oy+-150, 3500),
    Geom::Point3d.new(ox+12150, oy+150, 3500),
    Geom::Point3d.new(ox+11850, oy+150, 3500)
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
    Geom::Point3d.new(ox+17850, oy+-150, -20),
    Geom::Point3d.new(ox+18150, oy+-150, -20),
    Geom::Point3d.new(ox+18150, oy+150, -20),
    Geom::Point3d.new(ox+17850, oy+150, -20)
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
    Geom::Point3d.new(ox+17850, oy+-150, 3500),
    Geom::Point3d.new(ox+18150, oy+-150, 3500),
    Geom::Point3d.new(ox+18150, oy+150, 3500),
    Geom::Point3d.new(ox+17850, oy+150, 3500)
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
    Geom::Point3d.new(ox+-150, oy+2850, -20),
    Geom::Point3d.new(ox+150, oy+2850, -20),
    Geom::Point3d.new(ox+150, oy+3150, -20),
    Geom::Point3d.new(ox+-150, oy+3150, -20)
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
    Geom::Point3d.new(ox+-150, oy+2850, 3500),
    Geom::Point3d.new(ox+150, oy+2850, 3500),
    Geom::Point3d.new(ox+150, oy+3150, 3500),
    Geom::Point3d.new(ox+-150, oy+3150, 3500)
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
    Geom::Point3d.new(ox+2850, oy+2850, -20),
    Geom::Point3d.new(ox+3150, oy+2850, -20),
    Geom::Point3d.new(ox+3150, oy+3150, -20),
    Geom::Point3d.new(ox+2850, oy+3150, -20)
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
    Geom::Point3d.new(ox+2850, oy+2850, 3500),
    Geom::Point3d.new(ox+3150, oy+2850, 3500),
    Geom::Point3d.new(ox+3150, oy+3150, 3500),
    Geom::Point3d.new(ox+2850, oy+3150, 3500)
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
    Geom::Point3d.new(ox+5850, oy+2850, -20),
    Geom::Point3d.new(ox+6150, oy+2850, -20),
    Geom::Point3d.new(ox+6150, oy+3150, -20),
    Geom::Point3d.new(ox+5850, oy+3150, -20)
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
    Geom::Point3d.new(ox+5850, oy+2850, 3500),
    Geom::Point3d.new(ox+6150, oy+2850, 3500),
    Geom::Point3d.new(ox+6150, oy+3150, 3500),
    Geom::Point3d.new(ox+5850, oy+3150, 3500)
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
    Geom::Point3d.new(ox+8850, oy+2850, -20),
    Geom::Point3d.new(ox+9150, oy+2850, -20),
    Geom::Point3d.new(ox+9150, oy+3150, -20),
    Geom::Point3d.new(ox+8850, oy+3150, -20)
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
    Geom::Point3d.new(ox+8850, oy+2850, 3500),
    Geom::Point3d.new(ox+9150, oy+2850, 3500),
    Geom::Point3d.new(ox+9150, oy+3150, 3500),
    Geom::Point3d.new(ox+8850, oy+3150, 3500)
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
    Geom::Point3d.new(ox+-150, oy+-150, -20),
    Geom::Point3d.new(ox+150, oy+-150, -20),
    Geom::Point3d.new(ox+150, oy+150, -20),
    Geom::Point3d.new(ox+-150, oy+150, -20)
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
    Geom::Point3d.new(ox+-150, oy+-150, 3500),
    Geom::Point3d.new(ox+150, oy+-150, 3500),
    Geom::Point3d.new(ox+150, oy+150, 3500),
    Geom::Point3d.new(ox+-150, oy+150, 3500)
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
    Geom::Point3d.new(ox+2850, oy+-150, -20),
    Geom::Point3d.new(ox+3150, oy+-150, -20),
    Geom::Point3d.new(ox+3150, oy+150, -20),
    Geom::Point3d.new(ox+2850, oy+150, -20)
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
    Geom::Point3d.new(ox+2850, oy+-150, 3500),
    Geom::Point3d.new(ox+3150, oy+-150, 3500),
    Geom::Point3d.new(ox+3150, oy+150, 3500),
    Geom::Point3d.new(ox+2850, oy+150, 3500)
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
    Geom::Point3d.new(ox+5850, oy+-150, -20),
    Geom::Point3d.new(ox+6150, oy+-150, -20),
    Geom::Point3d.new(ox+6150, oy+150, -20),
    Geom::Point3d.new(ox+5850, oy+150, -20)
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
    Geom::Point3d.new(ox+5850, oy+-150, 3500),
    Geom::Point3d.new(ox+6150, oy+-150, 3500),
    Geom::Point3d.new(ox+6150, oy+150, 3500),
    Geom::Point3d.new(ox+5850, oy+150, 3500)
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
    Geom::Point3d.new(ox+8850, oy+-150, -20),
    Geom::Point3d.new(ox+9150, oy+-150, -20),
    Geom::Point3d.new(ox+9150, oy+150, -20),
    Geom::Point3d.new(ox+8850, oy+150, -20)
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
    Geom::Point3d.new(ox+8850, oy+-150, 3500),
    Geom::Point3d.new(ox+9150, oy+-150, 3500),
    Geom::Point3d.new(ox+9150, oy+150, 3500),
    Geom::Point3d.new(ox+8850, oy+150, 3500)
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
    Geom::Point3d.new(ox+1350, oy+2850, -20),
    Geom::Point3d.new(ox+1650, oy+2850, -20),
    Geom::Point3d.new(ox+1650, oy+3150, -20),
    Geom::Point3d.new(ox+1350, oy+3150, -20)
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
    Geom::Point3d.new(ox+1350, oy+2850, 3500),
    Geom::Point3d.new(ox+1650, oy+2850, 3500),
    Geom::Point3d.new(ox+1650, oy+3150, 3500),
    Geom::Point3d.new(ox+1350, oy+3150, 3500)
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
    Geom::Point3d.new(ox+4350, oy+2850, -20),
    Geom::Point3d.new(ox+4650, oy+2850, -20),
    Geom::Point3d.new(ox+4650, oy+3150, -20),
    Geom::Point3d.new(ox+4350, oy+3150, -20)
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
    Geom::Point3d.new(ox+4350, oy+2850, 3500),
    Geom::Point3d.new(ox+4650, oy+2850, 3500),
    Geom::Point3d.new(ox+4650, oy+3150, 3500),
    Geom::Point3d.new(ox+4350, oy+3150, 3500)
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
    Geom::Point3d.new(ox+7350, oy+2850, -20),
    Geom::Point3d.new(ox+7650, oy+2850, -20),
    Geom::Point3d.new(ox+7650, oy+3150, -20),
    Geom::Point3d.new(ox+7350, oy+3150, -20)
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
    Geom::Point3d.new(ox+7350, oy+2850, 3500),
    Geom::Point3d.new(ox+7650, oy+2850, 3500),
    Geom::Point3d.new(ox+7650, oy+3150, 3500),
    Geom::Point3d.new(ox+7350, oy+3150, 3500)
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
    Geom::Point3d.new(ox+1350, oy+-150, -20),
    Geom::Point3d.new(ox+1650, oy+-150, -20),
    Geom::Point3d.new(ox+1650, oy+150, -20),
    Geom::Point3d.new(ox+1350, oy+150, -20)
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
    Geom::Point3d.new(ox+1350, oy+-150, 3500),
    Geom::Point3d.new(ox+1650, oy+-150, 3500),
    Geom::Point3d.new(ox+1650, oy+150, 3500),
    Geom::Point3d.new(ox+1350, oy+150, 3500)
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
    Geom::Point3d.new(ox+4350, oy+-150, -20),
    Geom::Point3d.new(ox+4650, oy+-150, -20),
    Geom::Point3d.new(ox+4650, oy+150, -20),
    Geom::Point3d.new(ox+4350, oy+150, -20)
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
    Geom::Point3d.new(ox+4350, oy+-150, 3500),
    Geom::Point3d.new(ox+4650, oy+-150, 3500),
    Geom::Point3d.new(ox+4650, oy+150, 3500),
    Geom::Point3d.new(ox+4350, oy+150, 3500)
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
    Geom::Point3d.new(ox+7350, oy+-150, -20),
    Geom::Point3d.new(ox+7650, oy+-150, -20),
    Geom::Point3d.new(ox+7650, oy+150, -20),
    Geom::Point3d.new(ox+7350, oy+150, -20)
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
    Geom::Point3d.new(ox+7350, oy+-150, 3500),
    Geom::Point3d.new(ox+7650, oy+-150, 3500),
    Geom::Point3d.new(ox+7650, oy+150, 3500),
    Geom::Point3d.new(ox+7350, oy+150, 3500)
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
    Geom::Point3d.new(ox+3600, oy+2100, -20),
    Geom::Point3d.new(ox+3900, oy+2100, -20),
    Geom::Point3d.new(ox+3900, oy+2400, -20),
    Geom::Point3d.new(ox+3600, oy+2400, -20)
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
    Geom::Point3d.new(ox+3600, oy+2100, 3500),
    Geom::Point3d.new(ox+3900, oy+2100, 3500),
    Geom::Point3d.new(ox+3900, oy+2400, 3500),
    Geom::Point3d.new(ox+3600, oy+2400, 3500)
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
    Geom::Point3d.new(ox+5100, oy+2100, -20),
    Geom::Point3d.new(ox+5400, oy+2100, -20),
    Geom::Point3d.new(ox+5400, oy+2400, -20),
    Geom::Point3d.new(ox+5100, oy+2400, -20)
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
    Geom::Point3d.new(ox+5100, oy+2100, 3500),
    Geom::Point3d.new(ox+5400, oy+2100, 3500),
    Geom::Point3d.new(ox+5400, oy+2400, 3500),
    Geom::Point3d.new(ox+5100, oy+2400, 3500)
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
    Geom::Point3d.new(ox+3600, oy+600, -20),
    Geom::Point3d.new(ox+3900, oy+600, -20),
    Geom::Point3d.new(ox+3900, oy+900, -20),
    Geom::Point3d.new(ox+3600, oy+900, -20)
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
    Geom::Point3d.new(ox+3600, oy+600, 3500),
    Geom::Point3d.new(ox+3900, oy+600, 3500),
    Geom::Point3d.new(ox+3900, oy+900, 3500),
    Geom::Point3d.new(ox+3600, oy+900, 3500)
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
    Geom::Point3d.new(ox+5100, oy+600, -20),
    Geom::Point3d.new(ox+5400, oy+600, -20),
    Geom::Point3d.new(ox+5400, oy+900, -20),
    Geom::Point3d.new(ox+5100, oy+900, -20)
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
    Geom::Point3d.new(ox+5100, oy+600, 3500),
    Geom::Point3d.new(ox+5400, oy+600, 3500),
    Geom::Point3d.new(ox+5400, oy+900, 3500),
    Geom::Point3d.new(ox+5100, oy+900, 3500)
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
    Geom::Point3d.new(ox+17825, oy+35825, -20),
    Geom::Point3d.new(ox+18175, oy+35825, -20),
    Geom::Point3d.new(ox+18175, oy+36175, -20),
    Geom::Point3d.new(ox+17825, oy+36175, -20)
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
    Geom::Point3d.new(ox+17825, oy+35825, 3500),
    Geom::Point3d.new(ox+18175, oy+35825, 3500),
    Geom::Point3d.new(ox+18175, oy+36175, 3500),
    Geom::Point3d.new(ox+17825, oy+36175, 3500)
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
    Geom::Point3d.new(ox+-205, oy+41795, -20),
    Geom::Point3d.new(ox+205, oy+41795, -20),
    Geom::Point3d.new(ox+205, oy+42205, -20),
    Geom::Point3d.new(ox+-205, oy+42205, -20)
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
    Geom::Point3d.new(ox+-205, oy+41795, 3500),
    Geom::Point3d.new(ox+205, oy+41795, 3500),
    Geom::Point3d.new(ox+205, oy+42205, 3500),
    Geom::Point3d.new(ox+-205, oy+42205, 3500)
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
    Geom::Point3d.new(ox+5770, oy+41770, -20),
    Geom::Point3d.new(ox+6230, oy+41770, -20),
    Geom::Point3d.new(ox+6230, oy+42230, -20),
    Geom::Point3d.new(ox+5770, oy+42230, -20)
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
    Geom::Point3d.new(ox+5770, oy+41770, 3500),
    Geom::Point3d.new(ox+6230, oy+41770, 3500),
    Geom::Point3d.new(ox+6230, oy+42230, 3500),
    Geom::Point3d.new(ox+5770, oy+42230, 3500)
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
    Geom::Point3d.new(ox+11745, oy+41745, -20),
    Geom::Point3d.new(ox+12255, oy+41745, -20),
    Geom::Point3d.new(ox+12255, oy+42255, -20),
    Geom::Point3d.new(ox+11745, oy+42255, -20)
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
    Geom::Point3d.new(ox+11745, oy+41745, 3500),
    Geom::Point3d.new(ox+12255, oy+41745, 3500),
    Geom::Point3d.new(ox+12255, oy+42255, 3500),
    Geom::Point3d.new(ox+11745, oy+42255, 3500)
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
    Geom::Point3d.new(ox+17720, oy+41720, -20),
    Geom::Point3d.new(ox+18280, oy+41720, -20),
    Geom::Point3d.new(ox+18280, oy+42280, -20),
    Geom::Point3d.new(ox+17720, oy+42280, -20)
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
    Geom::Point3d.new(ox+17720, oy+41720, 3500),
    Geom::Point3d.new(ox+18280, oy+41720, 3500),
    Geom::Point3d.new(ox+18280, oy+42280, 3500),
    Geom::Point3d.new(ox+17720, oy+42280, 3500)
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
    Geom::Point3d.new(ox+-315, oy+47685, -20),
    Geom::Point3d.new(ox+315, oy+47685, -20),
    Geom::Point3d.new(ox+315, oy+48315, -20),
    Geom::Point3d.new(ox+-315, oy+48315, -20)
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
    Geom::Point3d.new(ox+-315, oy+47685, 3500),
    Geom::Point3d.new(ox+315, oy+47685, 3500),
    Geom::Point3d.new(ox+315, oy+48315, 3500),
    Geom::Point3d.new(ox+-315, oy+48315, 3500)
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
    Geom::Point3d.new(ox+5875, oy+47875, -20),
    Geom::Point3d.new(ox+6125, oy+47875, -20),
    Geom::Point3d.new(ox+6125, oy+48125, -20),
    Geom::Point3d.new(ox+5875, oy+48125, -20)
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
    Geom::Point3d.new(ox+5875, oy+47875, 3500),
    Geom::Point3d.new(ox+6125, oy+47875, 3500),
    Geom::Point3d.new(ox+6125, oy+48125, 3500),
    Geom::Point3d.new(ox+5875, oy+48125, 3500)
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
    Geom::Point3d.new(ox+17825, oy+47825, -20),
    Geom::Point3d.new(ox+18175, oy+47825, -20),
    Geom::Point3d.new(ox+18175, oy+48175, -20),
    Geom::Point3d.new(ox+17825, oy+48175, -20)
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
    Geom::Point3d.new(ox+17825, oy+47825, 3500),
    Geom::Point3d.new(ox+18175, oy+47825, 3500),
    Geom::Point3d.new(ox+18175, oy+48175, 3500),
    Geom::Point3d.new(ox+17825, oy+48175, 3500)
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
    Geom::Point3d.new(ox+-205, oy+53795, -20),
    Geom::Point3d.new(ox+205, oy+53795, -20),
    Geom::Point3d.new(ox+205, oy+54205, -20),
    Geom::Point3d.new(ox+-205, oy+54205, -20)
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
    Geom::Point3d.new(ox+-205, oy+53795, 3500),
    Geom::Point3d.new(ox+205, oy+53795, 3500),
    Geom::Point3d.new(ox+205, oy+54205, 3500),
    Geom::Point3d.new(ox+-205, oy+54205, 3500)
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
    Geom::Point3d.new(ox+5900, oy+53900, 3500),
    Geom::Point3d.new(ox+6100, oy+53900, 3500),
    Geom::Point3d.new(ox+6100, oy+54100, 3500),
    Geom::Point3d.new(ox+5900, oy+54100, 3500)
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
    Geom::Point3d.new(ox+11900, oy+53900, 3500),
    Geom::Point3d.new(ox+12100, oy+53900, 3500),
    Geom::Point3d.new(ox+12100, oy+54100, 3500),
    Geom::Point3d.new(ox+11900, oy+54100, 3500)
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
    Geom::Point3d.new(ox+17900, oy+53900, 3500),
    Geom::Point3d.new(ox+18100, oy+53900, 3500),
    Geom::Point3d.new(ox+18100, oy+54100, 3500),
    Geom::Point3d.new(ox+17900, oy+54100, 3500)
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
    Geom::Point3d.new(ox+-112, oy+59888, -20),
    Geom::Point3d.new(ox+112, oy+59888, -20),
    Geom::Point3d.new(ox+112, oy+60112, -20),
    Geom::Point3d.new(ox+-112, oy+60112, -20)
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
    Geom::Point3d.new(ox+-112, oy+59888, 3500),
    Geom::Point3d.new(ox+112, oy+59888, 3500),
    Geom::Point3d.new(ox+112, oy+60112, 3500),
    Geom::Point3d.new(ox+-112, oy+60112, 3500)
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
    Geom::Point3d.new(ox+11825, oy+59825, -20),
    Geom::Point3d.new(ox+12175, oy+59825, -20),
    Geom::Point3d.new(ox+12175, oy+60175, -20),
    Geom::Point3d.new(ox+11825, oy+60175, -20)
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
    Geom::Point3d.new(ox+11825, oy+59825, 3500),
    Geom::Point3d.new(ox+12175, oy+59825, 3500),
    Geom::Point3d.new(ox+12175, oy+60175, 3500),
    Geom::Point3d.new(ox+11825, oy+60175, 3500)
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
    Geom::Point3d.new(ox+17841, oy+59841, -20),
    Geom::Point3d.new(ox+18159, oy+59841, -20),
    Geom::Point3d.new(ox+18159, oy+60159, -20),
    Geom::Point3d.new(ox+17841, oy+60159, -20)
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
    Geom::Point3d.new(ox+17841, oy+59841, 3500),
    Geom::Point3d.new(ox+18159, oy+59841, 3500),
    Geom::Point3d.new(ox+18159, oy+60159, 3500),
    Geom::Point3d.new(ox+17841, oy+60159, 3500)
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
    Geom::Point3d.new(ox+-186, oy+65814, -20),
    Geom::Point3d.new(ox+186, oy+65814, -20),
    Geom::Point3d.new(ox+186, oy+66186, -20),
    Geom::Point3d.new(ox+-186, oy+66186, -20)
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
    Geom::Point3d.new(ox+-186, oy+65814, 3500),
    Geom::Point3d.new(ox+186, oy+65814, 3500),
    Geom::Point3d.new(ox+186, oy+66186, 3500),
    Geom::Point3d.new(ox+-186, oy+66186, 3500)
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
    Geom::Point3d.new(ox+-150, oy+-150, -20),
    Geom::Point3d.new(ox+150, oy+-150, -20),
    Geom::Point3d.new(ox+150, oy+150, -20),
    Geom::Point3d.new(ox+-150, oy+150, -20)
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
    Geom::Point3d.new(ox+-150, oy+-150, 3500),
    Geom::Point3d.new(ox+150, oy+-150, 3500),
    Geom::Point3d.new(ox+150, oy+150, 3500),
    Geom::Point3d.new(ox+-150, oy+150, 3500)
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
    Geom::Point3d.new(ox+-150, oy+-150, -20),
    Geom::Point3d.new(ox+150, oy+-150, -20),
    Geom::Point3d.new(ox+150, oy+150, -20),
    Geom::Point3d.new(ox+-150, oy+150, -20)
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
    Geom::Point3d.new(ox+-150, oy+-150, 3500),
    Geom::Point3d.new(ox+150, oy+-150, 3500),
    Geom::Point3d.new(ox+150, oy+150, 3500),
    Geom::Point3d.new(ox+-150, oy+150, 3500)
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
    Geom::Point3d.new(ox+-150, oy+-150, -20),
    Geom::Point3d.new(ox+150, oy+-150, -20),
    Geom::Point3d.new(ox+150, oy+150, -20),
    Geom::Point3d.new(ox+-150, oy+150, -20)
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
    Geom::Point3d.new(ox+-150, oy+-150, 3500),
    Geom::Point3d.new(ox+150, oy+-150, 3500),
    Geom::Point3d.new(ox+150, oy+150, 3500),
    Geom::Point3d.new(ox+-150, oy+150, 3500)
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
    Geom::Point3d.new(ox+-150, oy+-150, -20),
    Geom::Point3d.new(ox+150, oy+-150, -20),
    Geom::Point3d.new(ox+150, oy+150, -20),
    Geom::Point3d.new(ox+-150, oy+150, -20)
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
    Geom::Point3d.new(ox+-150, oy+-150, 3500),
    Geom::Point3d.new(ox+150, oy+-150, 3500),
    Geom::Point3d.new(ox+150, oy+150, 3500),
    Geom::Point3d.new(ox+-150, oy+150, 3500)
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
    Geom::Point3d.new(ox+17850, oy+-150, -20),
    Geom::Point3d.new(ox+18150, oy+-150, -20),
    Geom::Point3d.new(ox+18150, oy+150, -20),
    Geom::Point3d.new(ox+17850, oy+150, -20)
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
    Geom::Point3d.new(ox+17850, oy+-150, 3500),
    Geom::Point3d.new(ox+18150, oy+-150, 3500),
    Geom::Point3d.new(ox+18150, oy+150, 3500),
    Geom::Point3d.new(ox+17850, oy+150, 3500)
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
    Geom::Point3d.new(ox+11850, oy+-150, -20),
    Geom::Point3d.new(ox+12150, oy+-150, -20),
    Geom::Point3d.new(ox+12150, oy+150, -20),
    Geom::Point3d.new(ox+11850, oy+150, -20)
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
    Geom::Point3d.new(ox+11850, oy+-150, 3500),
    Geom::Point3d.new(ox+12150, oy+-150, 3500),
    Geom::Point3d.new(ox+12150, oy+150, 3500),
    Geom::Point3d.new(ox+11850, oy+150, 3500)
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
    Geom::Point3d.new(ox+5850, oy+-150, -20),
    Geom::Point3d.new(ox+6150, oy+-150, -20),
    Geom::Point3d.new(ox+6150, oy+150, -20),
    Geom::Point3d.new(ox+5850, oy+150, -20)
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
    Geom::Point3d.new(ox+5850, oy+-150, 3500),
    Geom::Point3d.new(ox+6150, oy+-150, 3500),
    Geom::Point3d.new(ox+6150, oy+150, 3500),
    Geom::Point3d.new(ox+5850, oy+150, 3500)
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
    Geom::Point3d.new(ox+-150, oy+-150, -20),
    Geom::Point3d.new(ox+150, oy+-150, -20),
    Geom::Point3d.new(ox+150, oy+150, -20),
    Geom::Point3d.new(ox+-150, oy+150, -20)
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
    Geom::Point3d.new(ox+-150, oy+-150, 3500),
    Geom::Point3d.new(ox+150, oy+-150, 3500),
    Geom::Point3d.new(ox+150, oy+150, 3500),
    Geom::Point3d.new(ox+-150, oy+150, 3500)
  ]
  cplate_52_f = ents.add_face(cplate_52_pts)
  if cplate_52_f
    cplate_52_f.material = mat_steel_plate
    cplate_52_f.layer = layers['conns']
    cplate_52_f.pushpull(20)
  end
rescue; end

model.commit_operation
UI.messagebox('Done: 53c 118b 1s 0w 6f [LOD350]')
# ── Auto-save .skp ──────────────────────────────────────────
begin
  _skp_name = 'UNE_Tamworth_Central_Campus_LOD300.skp'
  _skp_dir  = File.expand_path('~/Downloads')
  _skp_path = File.join(_skp_dir, _skp_name)
  Sketchup.active_model.save(_skp_path)
  UI.messagebox("\u2705 Model saved: #{_skp_path}")
rescue => _e
  UI.messagebox("Save failed: #{_e.message}. Use File > Save As manually.")
end
