require 'sketchup.rb'
require 'json'

# Main script to generate a structural model in SketchUp
module StructuralModelGenerator

  # Parse the JSON data (assuming it's provided as a string)
  json_string = %q(
{
  "project_info": {
    "name": "THE UNIVERSITY OF NEW ENGLAND TAMWORTH CENTRAL CAMPUS",
    "location": "24 Fitzroy Street, Tamworth New South Wales 2340",
    "region": "AU",
    "units": {
      "length": "mm",
      "strength": "MPa"
    },
    "notes": [
      "These drawings are preliminary drawings issued for tendering purposes only as an indication of the extent of works only. They are not a complete set of construction drawings and are not to be used for construction.",
      "To determine the full extent of work, these drawings shall be read in conjunction with the architectural drawings and other contract documents. Allow for all items shown on architectural and other drawings as not all items are shown on the structural drawings.",
      "Should any ambiguity, error, omission, discrepancy, inconsistency or other fault exist or seem to exist in the documents, immediately notify, in writing, to the superintendent.",
      "Rates shown on these drawings are for the final structure in place and do not allow for any wastage, rolling margins, over supply or fabrication requirements etc."
    ]
  },
  "grid_system": {
    "origin_mm": {
      "x": 0,
      "y": 0,
      "z": 0
    },
    "x_grids": [
      {
        "label": "1",
        "coordinate_mm": 1000,
        "confidence": 0.9
      },
      {
        "label": "2",
        "coordinate_mm": 7000,
        "confidence": 0.9
      },
      {
        "label": "3",
        "coordinate_mm": 13000,
        "confidence": 0.9
      },
      {
        "label": "4",
        "coordinate_mm": 19000,
        "confidence": 0.9
      }
    ],
    "y_grids": [
      {
        "label": "D",
        "coordinate_mm": 1000,
        "confidence": 0.9
      },
      {
        "label": "C",
        "coordinate_mm": 7000,
        "confidence": 0.9
      },
      {
        "label": "B",
        "coordinate_mm": 13000,
        "confidence": 0.9
      },
      {
        "label": "A",
        "coordinate_mm": 19000,
        "confidence": 0.9
      }
    ]
  },
  "levels": [
    {
      "id": "L01",
      "name": "LEVEL 01",
      "elevation_mm": 0,
      "slab_thickness_mm": 240,
      "confidence": 0.9
    },
    {
      "id": "L02",
      "name": "LEVEL 02",
      "elevation_mm": 3000,
      "slab_thickness_mm": 200,
      "confidence": 0.85
    },
    {
      "id": "L03",
      "name": "LEVEL 03",
      "elevation_mm": 6000,
      "slab_thickness_mm": 200,
      "confidence": 0.85
    },
    {
      "id": "L04",
      "name": "LEVEL 04",
      "elevation_mm": 9000,
      "slab_thickness_mm": 200,
      "confidence": 0.85
    },
    {
      "id": "L05",
      "name": "LEVEL 05",
      "elevation_mm": 12000,
      "slab_thickness_mm": 200,
      "confidence": 0.8
    },
    {
      "id": "LRF",
      "name": "LOWER ROOF",
      "elevation_mm": 15000,
      "slab_thickness_mm": null,
      "confidence": 0.7
    },
    {
      "id": "URF",
      "name": "UPPER ROOF",
      "elevation_mm": 18000,
      "slab_thickness_mm": null,
      "confidence": 0.7
    }
  ],
  "foundations": {
    "piles": [
      {
        "id": "P1",
        "type": "pile",
        "diameter_mm": 750,
        "socket_length_mm": 600,
        "max_working_compression_kN": 850,
        "max_working_tension_kN": null,
        "max_ultimate_compression_kN": 1200,
        "max_ultimate_tension_kN": null,
        "max_ultimate_lateral_kN": 450,
        "notes": "Self-weight of piles excluded. Ultimate lateral force (shear) to be applied in any direction. Bedrock level approx 10m below surface (RL 368.5). *Denotes estimated pile socket into low-strength argilite bedrock. Single pile design to consider eccentric loading AS 2159.",
        "confidence": 0.95
      },
      {
        "id": "P2",
        "type": "pile",
        "diameter_mm": 750,
        "socket_length_mm": 3000,
        "max_working_compression_kN": 1500,
        "max_working_tension_kN": null,
        "max_ultimate_compression_kN": 2100,
        "max_ultimate_tension_kN": null,
        "max_ultimate_lateral_kN": 5
      }
    ]
  },
  "members": {
    "columns": [
      {
        "id": "Col_A1",
        "grid_x": "1",
        "grid_y": "A",
        "section": null,
        "material": null
      },
      {
        "id": "Col_A2",
        "grid_x": "2",
        "grid_y": "A",
        "section": null,
        "material": null
      },
      {
        "id": "Col_A3",
        "grid_x": "3",
        "grid_y": "A",
        "section": null,
        "material": null
      },
      {
        "id": "Col_A4",
        "grid_x": "4",
        "grid_y": "A",
        "section": null,
        "material": null
      },
      {
        "id": "Col_B1",
        "grid_x": "1",
        "grid_y": "B",
        "section": null,
        "material": null
      },
      {
        "id": "Col_B2",
        "grid_x": "2",
        "grid_y": "B",
        "section": null,
        "material": null
      },
      {
        "id": "Col_B3",
        "grid_x": "3",
        "grid_y": "B",
        "section": null,
        "material": null
      },
      {
        "id": "Col_B4",
        "grid_x": "4",
        "grid_y": "B",
        "section": null,
        "material": null
      },
      {
        "id": "Col_C1",
        "grid_x": "1",
        "grid_y": "C",
        "section": null,
        "material": null
      },
      {
        "id": "Col_C2",
        "grid_x": "2",
        "grid_y": "C",
        "section": null,
        "material": null
      },
      {
        "id": "Col_C3",
        "grid_x": "3",
        "grid_y": "C",
        "section": null,
        "material": null
      },
      {
        "id": "Col_C4",
        "grid_x": "4",
        "grid_y": "C",
        "section": null,
        "material": null
      },
      {
        "id": "Col_D1",
        "grid_x": "1",
        "grid_y": "D",
        "section": null,
        "material": null
      },
      {
        "id": "Col_D2",
        "grid_x": "2",
        "grid_y": "D",
        "section": null,
        "material": null
      },
      {
        "id": "Col_D3",
        "grid_x": "3",
        "grid_y": "D",
        "section": null,
        "material": null
      },
      {
        "id": "Col_D4",
        "grid_x": "4",
        "grid_y": "D",
        "section": null,
        "material": null
      },
      {
        "id": "Col_C_1_5",
        "grid_x": "between 1 and 2",
        "grid_y": "C",
        "location_description": "Centerline between Grid 1 and 2",
        "section": null,
        "material": null
      },
      {
        "id": "Col_C_2_5_Left",
        "grid_x": "between 2 and 3",
        "grid_y": "C",
        "location_description": "Left of centerline between Grid 2 and 3",
        "section": null,
        "material": null
      },
      {
        "id": "Col_C_2_5_Right",
        "grid_x": "between 2 and 3",
        "grid_y": "C",
        "location_description": "Right of centerline between Grid 2 and 3",
        "section": null,
        "material": null
      },
      {
        "id": "Col_C_3_5",
        "grid_x": "between 3 and 4",
        "grid_y": "C",
        "location_description": "Centerline between Grid 3 and 4",
        "section": null,
        "material": null
      },
      {
        "id": "Col_D_1_5",
        "grid_x": "between 1 and 2",
        "grid_y": "D",
        "location_description": "Centerline between Grid 1 and 2",
        "section": null,
        "material": null
      },
      {
        "id": "Col_D_2_5_Left",
        "grid_x": "between 2 and 3",
        "grid_y": "D",
        "location_description": "Left of centerline between Grid 2 and 3",
        "section": null,
        "material": null
      },
      {
        "id": "Col_D_2_5_Right",
        "grid_x": "between 2 and 3",
        "grid_y": "D",
        "location_description": "Right of centerline between Grid 2 and 3",
        "section": null,
        "material": null
      },
      {
        "id": "Col_D_3_5",
        "grid_x": "between 3 and 4",
        "grid_y": "D",
        "location_description": "Centerline between Grid 3 and 4",
        "section": null,
        "material": null
      },
      {
        "type": "column",
        "id": "C_CH40b",
        "section": "CH40b",
        "material": "Structural Steel",
        "grid_x": "2",
        "grid_y": null,
        "description": "Vertical column element shown in Detail 1/1A/1B"
      },
      {
        "type": "column",
        "id": "C_CH35a",
        "section": "CH35a",
        "material": "Structural Steel",
        "grid_x": null,
        "grid_y": null,
        "description": "Vertical column element shown in Detail 2/Section 2A"
      },
      {
        "type": "column",
        "id": "C_CH13c",
        "section": "CH13c",
        "material": "Structural Steel",
        "grid_x": null,
        "grid_y": null,
        "description": "Vertical column stub element shown in Detail 2/Section 2A"
      },
      {
        "id": "UB_Column_Cap_200UB",
        "type": "column",
        "section": "200 UB",
        "height_mm": null,
        "material": null,
        "base_connection": null,
        "cap_connection": {
          "type": "cap_plate_connection",
          "notes": [
            "10 stiffener plates each side"
          ],
          "cap_plate_thickness_mm": 10,
          "bolts": "4M20",
          "bolt_grade": "8.8/S"
        },
        "grid_x": null,
        "grid_y": null
      },
      {
        "id": "UB_Column_Cap_310UB",
        "type": "column",
        "section": "310 UB",
        "height_mm": null,
        "material": null,
        "base_connection": null,
        "cap_connection": {
          "type": "cap_plate_connection",
          "notes": [
            "10 stiffener plates each side"
          ],
          "cap_plate_thickness_mm": 12,
          "bolts": "4M20",
          "bolt_grade": "8.8/S"
        },
        "grid_x": null,
        "grid_y": null
      },
      {
        "id": "UB_Column_Cap_360UB",
        "type": "column",
        "section": "360 UB",
        "height_mm": null,
        "material": null,
        "base_connection": null,
        "cap_connection": {
          "type": "cap_plate_connection",
          "notes": [
            "10 stiffener plates each side"
          ],
          "cap_plate_thickness_mm": 12,
          "bolts": "4M20",
          "bolt_grade": "8.8/S"
        },
        "grid_x": null,
        "grid_y": null
      },
      {
        "id": "CHS_Column_End_140DIA",
        "type": "column",
        "section": "140 DIA CHS",
        "height_mm": null,
        "material": null,
        "base_connection": {
          "type": "compression_end_connection",
          "notes": [
            "6 seal plate",
            "10 stiffener plate",
            "Bolt centres 70mm for M20 bolts",
            "Bolt centres 80mm for M24 bolts",
            "Connection plate same thickness as slotted plate"
          ],
          "plate_thickness_mm": 10,
          "slot_length_mm": 140,
          "bolts": "3M20",
          "bolt_grade": "8.8/S"
        },
        "cap_connection": null,
        "grid_x": null,
        "grid_y": null
      },
      {
        "id": "CH35a",
        "type": "steel_column",
        "section": "CH35a",
        "grid_x": "A",
        "grid_y": "T",
        "height_description": "Extends from below Level 01 to above Level 03",
        "connections": [
          {
            "level": "LEVEL 03",
            "detail": "16 END PLATE WITH 4-M24 DRILL AND EPOXY ANCHORS"
          }
        ]
      }
    ]
  },
  "summary": {
    "total_columns": 32,
    "total_beams": 16,
    "total_slabs": 3,
    "total_walls": 5,
    "total_footings": 0,
    "total_bracing": 0,
    "num_levels": 1,
    "grid_x_axes": 8,
    "grid_