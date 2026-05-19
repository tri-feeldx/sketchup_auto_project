# V6 ROOT CAUSE ANALYSIS & SYSTEM REDESIGN PLAN
## Principal AI Engineer — Architecture Review
### Date: 2026-05-18

---

## 🔴 ROOT CAUSE — Tại sao output chỉ đạt ~1%?

### 1. LEVEL DUPLICATE (CRITICAL)
- 12 floors trong model nhưng thực chất chỉ có 5 level bị duplicate 2 lần
- LEVEL 01-05 xuất hiện 2 bộ (từ elev page khác nhau) + Ground Floor + Level 1
- **Cause**: Scanner xử lý từng page riêng biệt, mỗi page extract levels riêng, KHÔNG merge/dedup

### 2. GRID QUÁ NHỎ (4x4)
- Grid detect: X=[1,2,3,4], Y=[A,B,C,D] → 4x4 = 16 cột
- Building outline thực tế: 46m x 37m, spacing = 6000mm
- Với 46m chiều rộng, grid thực tế cần ít nhất 8-9 cột X
- **Cause**: Vision model chỉ extract được grid từ 1 page, spacing hardcoded 6000mm

### 3. PAGE-LEVEL ISOLATION (CRITICAL)
- Mỗi PDF page được scan qua LLM độc lập → elements bị phân mảnh
- Page 1: 16 cols, Page 3: 0 cols, Page 5: 0 cols
- Không có cross-page spatial registration

### 4. ELEMENT ASSEMBLY LOGIC SAI
- Logic: `c.get("source_page") in floor_plan_pages`
- Cột chỉ thuộc 1 floor duy nhất (page nào thì floor đó)
- Thực tế: cột chạy xuyên suốt nhiều tầng

### 5. RUBY GENERATOR MINIMAL
- Chỉ tạo cột tại grid intersection cố định
- KHÔNG xử lý: walls, doors, windows, stairs, slabs
- KHÔNG có parametric components, materials, layers

### 6. THIẾU GLOBAL COORDINATE SYSTEM
- Elements extract với tọa độ local từng page
- KHÔNG có transform sang global origin
- KHÔNG merge được elements trùng giữa các pages

### 7. NO ARCHITECTURAL FEATURES
- Scanner focus structural (columns, beams)
- Thiếu: walls, doors, windows, stairs, slabs, roof
- KHÔNG đạt LOD300

---

## 🟢 GIẢI PHÁP — V6 Holistic Spatial Understanding

### Kiến trúc mới: 6-PHASE PIPELINE

```
PHASE 0: PDF Ingestion & Classification
  ├── Render all pages (VisionRenderer)
  ├── Classify per page: plan / elevation / section / schedule / skip
  └── Output: page_classifications, num_floors estimate

PHASE 1: GLOBAL SPATIAL REGISTRATION  ← NEW
  ├── Detect grid system across ALL plan pages
  ├── Establish global coordinate origin
  ├── Compute page-to-global transforms
  ├── Extract & dedup levels from ALL elevation pages
  └── Output: global_grid, levels (deduped), page_transforms

PHASE 2: PER-PAGE DEEP EXTRACTION (Parallel)
  ├── Each plan page → extract ALL elements (local coords)
  │   ├── Columns (x, y, section, mark)
  │   ├── Beams (from_col, to_col, section)
  │   ├── Walls (x1,y1 → x2,y2, thickness, material)
  │   ├── Openings: doors, windows (position on wall)
  │   └── Annotations: dimensions, grid labels
  ├── Each elevation page → extract heights, facade elements
  ├── Schedule pages → extract member DB, wall types
  └── Output: page_extracts[] (rich element lists)

PHASE 3: GLOBAL ASSEMBLY & DEDUP  ← NEW
  ├── Transform ALL elements to global coords
  ├── Column dedup: merge by grid position (spatial proximity)
  ├── Column height assignment: extends z=0 to z=total_height
  ├── Beam network: connect columns at each floor level
  ├── Wall network: merge wall segments, resolve intersections
  ├── Host doors/windows onto walls
  ├── Generate slabs per floor (boundary from walls + columns)
  ├── Add stairs between consecutive floors
  └── Output: unified_building_model

PHASE 4: MODEL VALIDATION & REPAIR
  ├── Structural integrity check
  ├── Missing element detection & fill
  ├── LOD300 compliance verification
  └── Output: validated_model + quality_report

PHASE 5: RUBY LOD300 GENERATION
  ├── Full SketchUp Ruby script
  ├── Parametric components (columns, beams, walls)
  ├── Proper layers: STRUCT-*, ARCH-*, OPEN-*, ROOF-*
  ├── Materials & colors
  ├── Groups & components for reuse
  └── Output: lod300_model.rb
```

---

## 📐 DATA MODEL V6

```json
{
  "project": {
    "name": "Building Name",
    "type": "steel_frame | concrete | mixed",
    "num_floors": 5,
    "total_height_mm": 17500,
    "floor_height_mm": 3500
  },
  "global_grid": {
    "origin": { "x": 0, "y": 0, "z": 0 },
    "x_axes": [
      { "label": "1", "coord_mm": 0 },
      { "label": "2", "coord_mm": 6000 },
      ...
    ],
    "y_axes": [
      { "label": "A", "coord_mm": 0 },
      { "label": "B", "coord_mm": 6000 },
      ...
    ]
  },
  "levels": [
    { "id": "L01", "name": "Ground Floor", "elevation_mm": 0 },
    { "id": "L02", "name": "Level 01", "elevation_mm": 3500 },
    ...
  ],
  "columns": [
    {
      "id": "COL-A1",
      "grid_x": "1", "grid_y": "A",
      "x_mm": 0, "y_mm": 0,
      "bottom_z": 0, "top_z": 17500,
      "width_mm": 350, "depth_mm": 350,
      "section": "UC356x368x129",
      "material": "steel",
      "confidence": 0.9
    }
  ],
  "beams": [
    {
      "id": "B-A1-A2-L02",
      "floor_level_id": "L02",
      "from_col": "COL-A1", "to_col": "COL-A2",
      "section": "UB356x171x51",
      "material": "steel",
      "confidence": 0.85
    }
  ],
  "walls": [
    {
      "id": "W-EXT-N-01",
      "type": "exterior",
      "points": [[0,0], [6000,0]],
      "thickness_mm": 200,
      "height_mm": 17500,
      "material": "concrete",
      "openings": ["D-01", "W-01"]
    }
  ],
  "openings": {
    "doors": [
      { "id": "D-01", "host_wall": "W-EXT-N-01", "pos_from_start_mm": 2000, "width_mm": 900, "height_mm": 2100 }
    ],
    "windows": [
      { "id": "W-01", "host_wall": "W-EXT-N-01", "pos_from_start_mm": 3500, "width_mm": 1200, "height_mm": 1500, "sill_height_mm": 900 }
    ]
  },
  "slabs": [
    {
      "id": "SLAB-L02",
      "floor_level_id": "L02",
      "boundary": [[0,0], [46000,0], [46000,37000], [0,37000]],
      "thickness_mm": 150,
      "material": "concrete"
    }
  ],
  "stairs": [
    {
      "id": "STAIR-01",
      "from_level": "L01", "to_level": "L02",
      "x_mm": 15000, "y_mm": 8000,
      "width_mm": 1200,
      "num_risers": 20, "riser_mm": 175, "tread_mm": 280
    }
  ]
}
```

---

## 🛠 IMPLEMENTATION PLAN

### Sprint 1: Core Foundation (1-2 days)
- [ ] 1.1 Create `pipeline_v6.py` — new pipeline skeleton
- [ ] 1.2 Create `agents/grid_detector.py` — multi-page grid detection
- [ ] 1.3 Create `agents/level_extractor.py` — level dedup & merge
- [ ] 1.4 Create `agents/spatial_registrar.py` — page-to-global transform

### Sprint 2: Enhanced Extraction (1-2 days)
- [ ] 2.1 Enhance `agents/scanner_v5.py` → `agents/extractor_v6.py` with richer element extraction
- [ ] 2.2 Add wall extraction with thickness & material
- [ ] 2.3 Add opening detection (doors/windows on walls)
- [ ] 2.4 Add slab boundary inference
- [ ] 2.5 Add stair detection

### Sprint 3: Global Assembly (1-2 days)
- [ ] 3.1 Create `agents/assembler.py` — global coordinate transform
- [ ] 3.2 Implement column dedup (spatial clustering)
- [ ] 3.3 Implement beam network connectivity
- [ ] 3.4 Implement wall network merge & intersection resolve
- [ ] 3.5 Host openings on walls

### Sprint 4: Ruby LOD300 Generator (1 day)
- [ ] 4.1 Create `agents/ruby_generator_v6.py`
- [ ] 4.2 Parametric column/beam components
- [ ] 4.3 Wall assemblies with openings
- [ ] 4.4 Slab generation
- [ ] 4.5 Stair generation
- [ ] 4.6 Proper layers, materials, groups

### Sprint 5: Validation & Iteration (1-2 days)
- [ ] 5.1 Model validator & repair
- [ ] 5.2 LOD300 compliance checker
- [ ] 5.3 Test with real PDFs
- [ ] 5.4 Iterative improvement

---

## ⚡ IMMEDIATE FIXES (Có thể làm ngay)

1. **Fix level dedup** — merge duplicate levels by name+elevation proximity
2. **Fix floor assignment** — columns belong to ALL floors from bottom_z to top_z
3. **Fix grid spacing** — detect real spacing from dimension lines instead of hardcoded 6000
4. **Fix ruby generator** — use actual column positions instead of grid-only