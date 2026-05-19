# PLAN V7 — SELF-CONFIGURING UNIVERSAL PDF-TO-SKETCHUP PIPELINE

> **Principal Engineer: Cline AI** | **Date: 2026-05-19** | **Status: IN PROGRESS**
> 
> Tài liệu này để cả người và AI (DeepSeek local) đọc, triển khai từng bước.

---

## 📋 MỤC LỤC

1. [Tổng quan](#1-tổng-quan)
2. [Gap Analysis — Tại sao V5 chỉ đạt ~1%](#2-gap-analysis)
3. [Kiến trúc V7](#3-kiến-trúc-v7)
4. [Cấu trúc file & đường dẫn](#4-cấu-trúc-file)
5. [Kế hoạch triển khai](#5-kế-hoạch-triển-khai)
6. [Domain Knowledge Reference](#6-domain-knowledge-reference)

---

## 1. TỔNG QUAN

### Mục tiêu
- Input: PDF bản vẽ xây dựng (structural, architectural, mixed, multi-story)
- Output: SketchUp .rb script → model LOD300 với độ chính xác 60-80%
- Tự động thích ứng với mọi loại bản vẽ (VN, AU, INT'L)

### Hiện trạng V5
- Vị trí: tất cả elements tại (0,0,0) — không có tọa độ thực
- Section: generic 200x200mm — không theo schedule
- Layers: hầu hết LOD300_UNMAPPED — không phân loại đúng
- Số floors: 1 floor fallback — không detect đúng số tầng
- Tỷ lệ khớp bản vẽ: **~1%**

### Mục tiêu V7
- Tỷ lệ khớp: **60-80%**
- Loại bản vẽ: tự động xử lý tất cả (structural, architectural, mixed)
- Số elements: 200-500+ elements cho building 2-6 tầng
- Self-correction: tự detect và sửa lỗi

---

## 2. GAP ANALYSIS

### GAP #1: Prompt quá generic — LLM không biết đọc bản vẽ
- **Hiện tại:** 1 prompt cho mọi loại bản vẽ
- **Vấn đề:** Gemini không có context về quy ước ký hiệu (cột thép tô đen, dầm nét đậm, ký hiệu VLXD...)
- **Fix:** PromptFactory với template riêng cho từng loại bản vẽ + domain knowledge

### GAP #2: 1 prompt cho mọi loại bản vẽ
- **Hiện tại:** Cùng prompt cho structural plan, architectural plan, elevation
- **Vấn đề:** LLM không biết cần tập trung vào element nào
- **Fix:** Page Router → phân loại page → gán role → dùng prompt tương ứng

### GAP #3: Không có vòng lặp validation (Agentic Loop)
- **Hiện tại:** 1 LLM call → output. Không ai check.
- **Vấn đề:** Sai tọa độ, thiếu element, conflict không được phát hiện
- **Fix:** Audit output → detect lỗi → retry với error context (max 2 retries)

### GAP #4: Cross-page alignment thủ công
- **Hiện tại:** Mỗi page phân tích độc lập, merge bằng append
- **Vấn đề:** Cùng cột C1 ở nhiều tầng không match; grid không aligned
- **Fix:** Grid Alignment Engine — match grid labels, transform về gốc tọa độ chung

### GAP #5: Ruby generator không có domain validation
- **Hiện tại:** Fallback generator đọc field names không nhất quán
- **Vấn đề:** Cột ngoài building outline, dầm không kết nối cột, wall cắt cột
- **Fix:** Geometry + consistency validator trước khi generate Ruby

### GAP #6: Không có feedback loop
- **Hiện tại:** Generate .rb → xong. Không verify.
- **Fix:** Ruby syntax check + geometry sanity check trước khi output

---

## 3. KIẾN TRÚC V7

```
┌─────────────────────────────────────────────────────────────────────┐
│                     V7 UNIVERSAL PIPELINE                             │
├─────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  PHASE A: DEEP UNDERSTAND (Self-Configuring)                         │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │ A0: PDF FORENSIC ANALYSIS                                     │    │
│  │   File: agents/pdf_forensic.py (ĐÃ CÓ, cần upgrade)          │    │
│  │   - Extract text blocks, detect keywords                     │    │
│  │   - Detect: language (VN/EN), region (AU/VN/INTL)            │    │
│  │   - Detect: scale, grid mentions, dimension keywords         │    │
│  │   - Detect: material type (steel/concrete/mixed)             │    │
│  │   Output: pdf_profile dict                                   │    │
│  ├─────────────────────────────────────────────────────────────┤    │
│  │ A1: PAGE CLASSIFICATION & ROUTING                             │    │
│  │   File: agents/page_router.py (MỚI)                          │    │
│  │   - Gemini Vision: classify each page thumbnail              │    │
│  │   - Output routing: plan_struct, plan_arch, elev_main,       │    │
│  │     elev_side, section_long, section_cross, schedule_col,    │    │
│  │     schedule_beam, detail_typ, title_page, general_note      │    │
│  │   Output: routing_matrix dict                                │    │
│  ├─────────────────────────────────────────────────────────────┤    │
│  │ A2: TYPE-SPECIFIC EXTRACTION (PARALLEL batches)              │    │
│  │   File: agents/scanner_v6.py (MỚI, thay scanner_v5.py)       │    │
│  │   File: agents/prompt_factory.py (MỚI)                       │    │
│  │   - Mỗi role có PROMPT RIÊNG với domain knowledge            │    │
│  │   - Structural Plan: grid, columns, beams, bracing, slabs    │    │
│  │   - Architectural Plan: walls, doors, windows, rooms, stairs │    │
│  │   - Elevation: levels, heights, facade elements              │    │
│  │   - Section: floor-to-floor, beam depths, slab thickness     │    │
│  │   - Schedule: member marks, sizes, grades, quantities        │    │
│  │   - Có validation loop: extract → audit → retry nếu lỗi     │    │
│  ├─────────────────────────────────────────────────────────────┤    │
│  │ A3: CROSS-PAGE ALIGNMENT & SYNTHESIS                          │    │
│  │   File: agents/synthesizer_v7.py (MỚI)                       │    │
│  │   - Grid Alignment: match labels (1,2,3.. × A,B,C..)          │    │
│  │   - Column matching: cùng mark → cùng vị trí → merge info     │    │
│  │   - Triangulation: cùng 1 điểm từ 2 view → tọa độ 3D         │    │
│  │   - Conflict resolution: 2 page báo khác size → chọn source   │    │
│  │     có confidence cao hơn hoặc lấy từ schedule (chính xác nhất)│    │
│  │   Output: unified building_model dict                         │    │
│  ├─────────────────────────────────────────────────────────────┤    │
│  │ A4: MODEL AUDIT & SELF-CORRECTION                             │    │
│  │   File: agents/validator_v7.py (MỚI)                         │    │
│  │   - Check: all columns in grid? beams connect 2 columns?     │    │
│  │   - Check: walls don't cut through columns?                  │    │
│  │   - Check: floor heights consistent with elevation?          │    │
│  │   - Check: no zero-length elements? all within bounding box? │    │
│  │   - If errors → retry A2/A3 with error context (max 2 lần)  │    │
│  └─────────────────────────────────────────────────────────────┘    │
│                              ↓                                        │
│  PHASE B: GENERATE (SketchUp Ruby)                                    │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │ B1: RUBY CODE GENERATOR (UPGRADED)                           │    │
│  │   File: agents/ruby_generator_v5.py (MỚI)                    │    │
│  │   - Generate từ validated building_model                     │    │
│  │   - Structural: columns, beams, bracing, base plates,        │    │
│  │     purlins, girts, rafters, footings                        │    │
│  │   - Architectural: walls, doors, windows, stairs, slabs      │    │
│  │   - Layer: STRUCT-*, ARCH-*, MEP-* theo element type         │    │
│  │   - Material: steel (160,160,175), concrete (180,175,165)    │    │
│  │   - IFC attributes: Mark, Section, Type                      │    │
│  ├─────────────────────────────────────────────────────────────┤    │
│  │ B2: RUBY VALIDATION                                           │    │
│  │   File: agents/ruby_validator.py (MỚI)                       │    │
│  │   - Parse .rb → check syntax (begin/rescue/end pairs)        │    │
│  │   - Validate: no zero-length extrusions                      │    │
│  │   - Validate: all elements within bounding box               │    │
│  │   - If errors → retry B1 with error context                  │    │
│  └─────────────────────────────────────────────────────────────┘    │
│                                                                       │
└─────────────────────────────────────────────────────────────────────┘
```

### Data Flow

```
data/input_pdf/{pdf_name}.pdf
  │
  ├──[A0]──→ output/v7/{pdf_name}/forensic.json
  │              pdf_profile: {region, material, building_type, ...}
  │
  ├──[A1]──→ output/v7/{pdf_name}/routing.json
  │              routing_matrix: {page_0: [plan_struct], page_1: [elev_main], ...}
  │
  ├──[A2]──→ output/v7/{pdf_name}/page_results/
  │              p0_plan_struct.json, p1_elev_main.json, p2_schedule_col.json, ...
  │
  ├──[A3]──→ output/v7/{pdf_name}/building_model.json
  │              unified model: floors, elements, grid, levels, member_db
  │
  ├──[A4]──→ output/v7/{pdf_name}/audit_report.json
  │              errors, warnings, fixes_applied
  │
  └──[B1]──→ output/final_ruby_scripts/{pdf_name}_lod300.rb
                 SketchUp Ruby script
```

---

## 4. CẤU TRÚC FILE

### File tree hiện tại → cleanup → target

```
sketchup_auto_project/
│
├── PLAN_V7.md                          ← [NEW] Tài liệu này
├── README.md
├── requirements.txt
├── config.py                           ← [KEEP] Cấu hình LLM, paths
├── app.py                              ← [KEEP] Web UI upload
├── main.py                             ← [KEEP] CLI entry point
├── .env                                ← [KEEP] API keys
├── .env.example
├── .gitignore
│
├── core/                               ← Core utilities
│   ├── __init__.py
│   ├── llm_wrapper.py                  ← [KEEP] call_llm() wrapper
│   ├── pdf_utils.py                    ← [KEEP] PDF helpers (PyMuPDF)
│   ├── vision_renderer.py              ← [KEEP] Render PDF→image 300DPI
│   └── analysis_context.py             ← [KEEP] AnalysisContext dataclass
│
├── agents/                             ← Pipeline stages
│   ├── __init__.py
│   │
│   │  === V7 (CURRENT — đang implement) ===
│   ├── pdf_forensic.py                 ← [UPGRADE] A0: Forensic analysis
│   ├── page_router.py                  ← [NEW]     A1: Page routing
│   ├── prompt_factory.py               ← [NEW]     A2: Prompt templates
│   ├── scanner_v6.py                   ← [NEW]     A2: Type-specific extraction
│   ├── synthesizer_v7.py               ← [NEW]     A3: Cross-page synthesis
│   ├── validator_v7.py                 ← [NEW]     A4: Model audit
│   ├── ruby_generator_v5.py            ← [NEW]     B1: Ruby code gen
│   ├── ruby_validator.py               ← [NEW]     B2: Ruby validation
│   │
│   │  === V5 (giữ lại tham khảo) ===
│   ├── scanner_v5.py                   ← [ARCHIVE] Scanner V5
│   │
│   │  === Các file cũ (archive) ===
│   ├── scanner.py                      ← [ARCHIVE]
│   ├── scanner_v4.py                   ← [ARCHIVE]
│   ├── analyze_pdf.py                  ← [ARCHIVE]
│   ├── architectural_extractor.py      ← [ARCHIVE]
│   ├── structural_scanner.py           ← [ARCHIVE]
│   ├── structural_extractor.py         ← [ARCHIVE]
│   ├── extractor_v4.py                 ← [ARCHIVE]
│   ├── pdf_classifier.py               ← [ARCHIVE]
│   ├── grid_math_engine.py             ← [ARCHIVE - sẽ migrate logic]
│   ├── schedule_parser.py              ← [ARCHIVE - sẽ migrate logic]
│   ├── spatial_parser.py               ← [ARCHIVE]
│   ├── detail_extractor.py             ← [ARCHIVE]
│   ├── glossary_agent.py               ← [ARCHIVE]
│   ├── mapper.py                       ← [ARCHIVE]
│   ├── coder.py                        ← [ARCHIVE]
│   ├── auditor.py                      ← [ARCHIVE]
│   ├── parser.py                       ← [ARCHIVE]
│   ├── reconstructor_3d.py             ← [ARCHIVE]
│   ├── ruby_generator_v3.py            ← [ARCHIVE]
│   ├── ruby_generator_v4.py            ← [ARCHIVE]
│   └── sc                              ← [ARCHIVE]
│
├── pipelines/                          ← [NEW] Pipeline orchestrators
│   ├── __init__.py
│   ├── pipeline_v5.py                  ← [KEEP] V5 pipeline (giữ lại)
│   └── pipeline_v7.py                  ← [NEW] V7 orchestrator
│
├── output/
│   ├── v7/                             ← [NEW] V7 intermediate outputs
│   │   └── {pdf_name}/
│   │       ├── forensic.json
│   │       ├── routing.json
│   │       ├── page_results/
│   │       ├── building_model.json
│   │       └── audit_report.json
│   ├── final_ruby_scripts/             ← [KEEP] Final .rb output
│   │   └── {pdf_name}_lod300.rb
│   └── cache/                          ← [NEW] LLM response cache
│
├── data/
│   ├── input_pdf/                      ← [KEEP] PDF uploads
│   │   ├── structural.pdf
│   │   └── St_Carloa_Moama.pdf
│   └── backup_debug/
│
├── tests/                              ← [NEW] Unit tests
│   ├── __init__.py
│   ├── test_forensic.py
│   ├── test_prompt_factory.py
│   └── test_validator.py
│
├── legacy/                             ← [NEW] Archive cũ
│   └── (chuyển tất cả file V1-V4 vào đây)
│
└── scripts/                            ← Utility scripts
    ├── rebuild_from_cache.py
    ├── debug_cache.py
    ├── debug_parse.py
    ├── analyze_output.py
    ├── test_fixes.py
    ├── test_v3_dryrun.py
    └── test_fix1.py
```

### File cần tạo MỚI (7 files)

| # | File | Mục đích | Thời gian |
|---|------|----------|-----------|
| 1 | `agents/page_router.py` | A1: Phân loại page → role | 1h |
| 2 | `agents/prompt_factory.py` | A2: Prompt template cho từng role | 1h |
| 3 | `agents/scanner_v6.py` | A2: Extraction với type-specific prompts | 2h |
| 4 | `agents/synthesizer_v7.py` | A3: Cross-page alignment + synthesis | 2h |
| 5 | `agents/validator_v7.py` | A4: Model audit + self-correction | 1h |
| 6 | `agents/ruby_generator_v5.py` | B1: Ruby generator từ building model | 1.5h |
| 7 | `pipelines/pipeline_v7.py` | Orchestrator kết nối tất cả stages | 0.5h |

### File cần UPGRADE (1 file)

| # | File | Thay đổi | Thời gian |
|---|------|----------|-----------|
| 1 | `agents/pdf_forensic.py` | Thêm text extraction, grid detection, VN keywords | 0.5h |

---

## 5. KẾ HOẠCH TRIỂN KHAI

### Step 1: Cleanup codebase (30 phút)
```bash
mkdir legacy
mkdir pipelines
mkdir output/v7
mkdir output/cache
mkdir tests

# Di chuyển file cũ vào legacy/
mv agents/scanner.py agents/scanner_v4.py agents/analyze_pdf.py legacy/ 2>/dev/null
mv agents/architectural_extractor.py agents/structural_scanner.py legacy/ 2>/dev/null
mv agents/extractor_v4.py agents/pdf_classifier.py legacy/ 2>/dev/null
mv agents/spatial_parser.py agents/detail_extractor.py legacy/ 2>/dev/null
mv agents/glossary_agent.py agents/mapper.py legacy/ 2>/dev/null
mv agents/coder.py agents/auditor.py agents/parser.py legacy/ 2>/dev/null
mv agents/reconstructor_3d.py agents/ruby_generator_v3.py legacy/ 2>/dev/null
mv agents/ruby_generator_v4.py agents/sc legacy/ 2>/dev/null
mv agents/structural_extractor.py agents/grid_math_engine.py legacy/ 2>/dev/null
mv agents/schedule_parser.py legacy/ 2>/dev/null

# Di chuyển pipeline cũ
mv pipeline_v2.py pipeline_v3.py pipeline_v4.py pipeline_phase3.py legacy/ 2>/dev/null
mv analyze_v5.py pipeline_v6_au.py phase1 phase phase1_quick.py legacy/ 2>/dev/null
mv phase1_test.py quick_test.py legacy/ 2>/dev/null
mv _copy_pdfs.py _forensic.py legacy/ 2>/dev/null
mv DEEPSEEK_ONBOARDING.md PROJECT_RETROSPECTIVE.txt legacy/ 2>/dev/null
mv DAILY_REPORT_2026-05-18.txt legacy/ 2>/dev/null
mv PLAN_PM.md PLAN_V6_ROOT_CAUSE.md legacy/ 2>/dev/null

# Di chuyển scripts
mv debug debug_parse.py debug_cache.py debug_grids.py scripts/ 2>/dev/null
mv rebuild_from_cache.py analyze_output.py scripts/ 2>/dev/null
mv test_fixes.py test_v3_dryrun.py test_fix1.py scripts/ 2>/dev/null
```

### Step 2: Upgrade pdf_forensic.py (30 phút)
- Thêm VN keywords: TCVN, cột, dầm, sàn, móng, mặt bằng, mặt đứng, mặt cắt
- Thêm grid detection: tìm "trục 1", "trục A", "grid 1", "grid A" trong text
- Thêm scale detection: tìm "1:100", "1:50", "1:200"
- Output thêm fields: `detected_language`, `detected_grid_system`, `detected_scales`

### Step 3: Tạo prompt_factory.py (1 giờ)
- Định nghĩa PROMPTS dict với template cho từng role:
  - `structural_plan_vn`: grid, columns (C1,C2...), beams (D1,D2...), bracing
  - `structural_plan_au`: grid, columns, UB/UC/RHS sections, portal frames
  - `architectural_plan_vn`: walls, doors, windows, rooms, stairs
  - `elevation_main`: level heights, facade, openings
  - `section_long/section_cross`: floor-to-floor, beam depths
  - `schedule_columns`: mark, section, grade, length
  - `schedule_beams`: mark, section, span, grade
- Mỗi template có: `system_prompt`, `conventions`, `extract_fields`, `output_schema`, `coordinate_instructions`
- Hàm `assemble_prompt(role, page_info, extra_context)` → full prompt string

### Step 4: Tạo page_router.py (1 giờ)
- Dùng Gemini Vision thumbnail để classify page
- Input: page thumbnails + metadata (size, orientation, text từ forensic)
- Output: routing dict `{page_idx: [roles]}` (1 page có thể có nhiều role)
- Roles enum: plan_struct, plan_arch, elev_main, elev_side, section_long, section_cross, schedule_col, schedule_beam, detail_typ, title_page, general_note

### Step 5: Tạo scanner_v6.py (2 giờ)
- Kế thừa ý tưởng từ scanner_v5.py
- KHÁC BIỆT CHÍNH:
  1. Dùng PromptFactory thay vì prompt cứng
  2. Mỗi page được extract với prompt tương ứng role
  3. Có agentic validation loop: extract → validate → retry nếu lỗi (max 2)
  4. Schedule pages extract member DB (marks + sizes)
  5. Output per-page JSON standardized schema

### Step 6: Tạo synthesizer_v7.py (2 giờ)
- Input: tất cả page_results + routing + forensic
- Cross-page grid alignment:
  1. Thu thập tất cả grid labels từ mỗi plan page
  2. Align X-grid: sort numerical (1→N)
  3. Align Y-grid: sort alphabetical (A→Z)
  4. Xác định origin = grid 1-A (góc dưới-trái)
  5. Tính spacing từ column positions hoặc dimension lines
  6. Transform tất cả coordinates về gốc chung
- Column matching: same mark → same position → merge info
- Conflict resolution: schedule > plan measurement > guess
- Build unified building_model với floors, levels, elements

### Step 7: Tạo validator_v7.py (1 giờ)
- Geometry checks:
  - Columns: in grid? within building outline?
  - Beams: connect 2 columns? reasonable length?
  - Walls: don't cut through columns?
  - All elements: within bounding box?
- Consistency checks:
  - Floor heights consistent with elevation?
  - Member sizes consistent with schedule?
- Output: audit_report.json với list errors/warnings
- Nếu có critical errors → return error context để retry A2/A3

### Step 8: Tạo ruby_generator_v5.py (1.5 giờ)
- Input: validated building_model
- Generate Ruby script với:
  - Layer management (STRUCT-*, ARCH-*, MEP-*)
  - Material assignment (steel, concrete màu đúng)
  - Section profiles chính xác (CHS circle, RHS rectangle, UB/UC I-shape)
  - IFC attributes (Mark, Section, Type)
  - Element types: columns, beams, bracing, walls, doors, windows, stairs, slabs, footings, purlins, girts, rafters
- Cross-section generation:
  - CHS (circular hollow section): polygon 24 cạnh
  - RHS/SHS (rectangular): 4 cạnh
  - UB/UC (I-beam): 12 cạnh (flanges + web)
  - Wall: rectangle x thickness x height
  - Slab: polygon x thickness

### Step 9: Tạo ruby_validator.py (30 phút)
- Parse .rb script → check syntax:
  - begin/rescue/end pairs balanced?
  - No undefined variables?
- Geometry sanity:
  - Any zero-length extrusions?
  - Any elements outside bounding box?
- Report errors

### Step 10: Tạo pipelines/pipeline_v7.py (30 phút)
- Orchestrator:
  ```
  pipe = PipelineV7(pdf_path)
  pipe.run()
  # Gọi tuần tự: A0→A1→A2→A3→A4→B1→B2
  # Mỗi stage save intermediate output
  # Có resume capability (skip stage nếu output đã có)
  ```

### Step 11: Test & Validate (1 giờ)
- Test với structural.pdf (29 pages, AU, portal frame)
- Test với St_Carloa_Moama.pdf (27 pages, AU, portal frame)
- So sánh Ruby output V7 vs V5
- Đếm số elements đúng vị trí, đúng section

---

## 6. DOMAIN KNOWLEDGE REFERENCE

### 6.1 Quy ước bản vẽ Việt Nam (TCVN)

**Ký hiệu kết cấu:**
- Cột bê tông: C1, C2... → hình vuông/chữ nhật tô đen
- Cột thép: C1, C2... → hình tròn tô đen hoặc 2 đường chéo
- Dầm: D1, D2... → nét đậm liền
- Sàn: nét mảnh, ghi chú chiều dày
- Móng: M1, M2... → nét đứt

**Grid system:**
- Trục ngang: 1, 2, 3... (số)
- Trục dọc: A, B, C... (chữ)
- Giao điểm grid là vị trí cột

**Tỷ lệ thường gặp:**
- Mặt bằng tổng thể: 1:100, 1:200
- Mặt bằng chi tiết: 1:50
- Mặt đứng: 1:100, 1:200
- Mặt cắt: 1:50, 1:100
- Chi tiết cấu kiện: 1:20, 1:25, 1:10

**Ký hiệu VLXD:**
- Bê tông: tô chấm hoặc gạch xiên
- Thép: tô đen hoặc gạch chéo
- Gạch: gạch ngang/dọc
- Gỗ: vân gỗ

**Bảng thống kê:**
- Bảng thống kê cột: Mark, Kích thước, Thép chủ, Thép đai, Cao độ
- Bảng thống kê dầm: Mark, Kích thước, Thép dọc, Thép đai, Nhịp
- Bảng thống kê sàn: Ô sàn, Chiều dày, Thép lớp dưới, Thép lớp trên

### 6.2 Quy ước bản vẽ Úc (AS/NZS)

**Steel sections:**
- UB (Universal Beam): XXX.x kg/m → ví dụ UB310x125
- UC (Universal Column): XXX.x kg/m → ví dụ UC203x203
- PFC (Parallel Flange Channel): XXX.x → ví dụ PFC200
- RHS/SHS: (Rectangular/Square Hollow Section) → ví dụ RHS200x100x5
- CHS: (Circular Hollow Section) → ví dụ CHS168.3x7.1
- EA/UA: (Equal/Unequal Angle) → ví dụ EA50x50x5
- Z/C purlin: Z200, C250

**Grid notation:**
- Numbered grid: 1, 2, 3... (horizontal)
- Lettered grid: A, B, C... (vertical)
- Grid intersections define column positions

**Level notation:**
- RL (Reduced Level): absolute height above datum
- FFL (Finished Floor Level): finished floor height
- SSL (Structural Slab Level): structural slab height

**Schedule columns:**
- Mark | Section | Grade | Length | Base Plate | Head Plate | Stiffeners

**Common scales:**
- Plans: 1:100, 1:200
- Elevations: 1:100, 1:200
- Sections: 1:50, 1:100
- Details: 1:10, 1:20

### 6.3 Coordinate System

```
Y (vertical in plan = North typically)
^
|
+-----> X (horizontal in plan = East typically)

Z (height, into screen)
O
```

- Origin (0,0) = bottom-left of drawing = grid intersection 1-A
- X axis = horizontal grid (1, 2, 3...)
- Y axis = vertical grid (A, B, C...)
- Z axis = height (floor levels)

### 6.4 LOD300 Requirements

| Element | LOD300 Requirement |
|---------|-------------------|
| Columns | Exact location (grid intersection), exact section size, full height |
| Beams | Exact location (between columns), exact section, exact span |
| Bracing | Exact location, exact section, connection type |
| Walls | Exact location, thickness, height, openings for doors/windows |
| Doors | Exact location, width, height, type |
| Windows | Exact location, width, height, sill height |
| Slabs | Exact boundary, thickness, openings |
| Stairs | Exact location, number of steps, width |
| Footings | Exact location, size, depth |

---

## 7. CODING CONVENTIONS

### Prompt Engineering Rules
1. **Always specify coordinate system** — origin (0,0) = bottom-left of drawing
2. **Always request estimated positions in mm** — not pixels
3. **Always request confidence** (0.0-1.0) for each extracted element
4. **Always include drawing conventions** phù hợp với region (VN/AU/INTL)
5. **Always request grid labels** nếu visible
6. **Never ask LLM to "measure from image"** — instead ask to read text labels and infer

### Code Architecture Rules
1. **Mỗi agent là 1 class riêng** với interface rõ ràng: `__init__` + `run()` → dict
2. **Intermediate output luôn lưu JSON** để debug/resume
3. **Mọi LLM call có try/except + fallback**
4. **Logging print() với prefix** `[STAGE]` để trace pipeline
5. **Không hardcode paths** — dùng `config.py` hoặc tham số
6. **Type hints** cho tất cả function signatures

---

## 8. SUCCESS METRICS

| Metric | V5 (hiện tại) | V7 (target) |
|--------|---------------|-------------|
| Element positions đúng grid | ~0% | >70% |
| Section sizes đúng schedule | ~0% | >80% |
| Số floors đúng | ~20% | >90% |
| Layer assignment đúng | ~10% | >95% |
| Tỷ lệ khớp tổng thể | ~1% | 60-80% |
| Tự detect loại bản vẽ | Manual | Tự động |
| Xử lý PDF đa dạng | Chỉ structural | Structural + Architectural + Mixed |
| Self-correction | Không | Có (max 2 retries) |

---

## 9. NEXT STEPS (cho DeepSeek local)

Nếu đọc file này trên laptop với DeepSeek, thực hiện theo thứ tự:

1. **Đọc hiểu kiến trúc V7** (section 3)
2. **Cleanup codebase** (section 5, step 1)
3. **Implement từng file** theo thứ tự trong section 5 (steps 2-10)
4. **Test** với 2 PDF có sẵn trong `data/input_pdf/`
5. **Báo cáo kết quả** — tỷ lệ khớp, số elements, lỗi gặp phải

### Câu hỏi thường gặp cho DeepSeek:
- Q: "Tại sao phải xóa file cũ?"
  - A: Chỉ move vào legacy/, không xóa. Code cũ vẫn tham khảo được.
- Q: "Làm sao test được?"
  - A: `python pipelines/pipeline_v7.py --pdf data/input_pdf/structural.pdf`
- Q: "Gemini API key ở đâu?"
  - A: File `.env` có GEMINI_API_KEY
- Q: "Làm sao biết kết quả đúng?"
  - A: Mở file `output/final_ruby_scripts/{pdf_name}_lod300.rb`, so sánh tọa độ cột với grid labels trong bản vẽ gốc

---

> **Principal Engineer's Note:**
> 
> Đây là bản kế hoạch sống — có thể điều chỉnh khi gặp thực tế.
> Ưu tiên cao nhất: **Grid-First Coordinate System** (A3).
> Không có grid chính xác → mọi thứ khác vô nghĩa.
> 
> Good luck, DeepSeek! 🚀