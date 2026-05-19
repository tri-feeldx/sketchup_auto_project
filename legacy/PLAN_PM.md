# 🏗️ SKETCHUP AUTO PROJECT — PLAN C: FULL PIPELINE REDESIGN

> **Ngày:** 18/05/2026  
> **Mục tiêu:** Upload PDF bất kỳ → hệ thống tự động sinh SketchUp LOD300/350/400 gần giống nhất  
> **Nguyên lý:** Programmatic (zero-cost) nền tảng + LLM fallback cho edge cases khó

---

## 1. HÀNH TRÌNH ĐÃ ĐI QUA (retrospective)

| Giai đoạn | Mô tả | Khó khăn | Thành công |
|-----------|-------|----------|------------|
| **V1 (pre-refactor)** | Pipeline cũ: scanner → parser → mapper → coder → auditor | Output chỉ ~1% giống PDF, Ruby script rỗng/sai hoàn toàn | Có baseline kiến trúc agent-based |
| **Phase 0: Debug** | Phát hiện schedule page bị classify nhầm → plan → 25 "floors" ảo | Page classifier quá naive, keyword matching yếu | Xác định root cause: classifier + double-append + grid noise |
| **Phase 1: Core fixes** | Fix classifier (line density heuristic), parse_all double-append, Y-axis dimension filter | Grid Y chỉ còn 2 labels (A,C), levels trống, grid X còn nhiễu | 9 floors thay vì 18, classifier chính xác 100%, scale text priority |

### Các lỗi đã fix:
1. ✅ **Page classifier**: Schedule page 25 bị classify nhầm thành plan → thêm line density check (>3000 lines = drawing page)
2. ✅ **Double-append floors**: `parse_all()` bị gọi 2 lần → 18 floors → clear `self.pages = []` đầu hàm
3. ✅ **Y-axis dimension callout filter**: Số >20 ở biên trái/phải → score=0 (bỏ qua)
4. ✅ **FloorLayout→dict converter**: Coder nhận `list[dict]`, không phải `list[FloorLayout]`

### Các lỗi còn tồn đọng:
1. 🔴 **Grid labels có nhiễu**: `21`, `90`, `0`, `02`, `61`, `40` lọt qua filter
2. 🔴 **Y-axis quá ít labels**: Chỉ 2 (A,C) thay vì 6-8 (A,B,C,D,E,F,G)
3. 🔴 **Level markers trống**: Chỉ ROOF/BASE/GROUND, không có FL1-FL9
4. 🟡 **Member detection trống**: 0 columns, 0 beams detected
5. 🟡 **Ruby script chất lượng thấp**: Toàn placeholder/default geometry

---

## 2. KIẾN TRÚC MỚI (Plan C)

```
┌─────────────────────────────────────────────────────────────┐
│                    PDF INPUT (bất kỳ)                        │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│  PHASE 0: PDF TEXT EXTRACTOR (pdfplumber)                    │
│  - Trích toàn bộ text tokens + vector lines                  │
│  - Output: RawPageData (per page)                            │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│  PHASE 1: PAGE CLASSIFIER (rule-based + line density)        │
│  - Classify: plan | elevation | section | schedule | title   │
│  - Output: ClassifiedPage (type + metadata)                  │
└────────────────────────┬────────────────────────────────────┘
                         │
          ┌──────────────┼──────────────┬──────────────┐
          ▼              ▼              ▼              ▼
┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐
│ PLAN        │ │ ELEVATION   │ │ SECTION     │ │ SCHEDULE    │
│ EXTRACTOR   │ │ EXTRACTOR   │ │ EXTRACTOR   │ │ EXTRACTOR   │
│             │ │             │ │             │ │             │
│ - Grid X/Y  │ │ - Level Z   │ │ - Details   │ │ - Tables    │
│ - Columns   │ │ - Floor H   │ │ - Rebar     │ │ - Sections  │
│ - Beams     │ │ - Openings  │ │ - Notes     │ │ - Materials │
│ - Walls     │ │ - Grid ref  │ │ - Grid ref  │ │ - Marks     │
│ - Slabs     │ │             │ │             │ │             │
└──────┬──────┘ └──────┬──────┘ └──────┬──────┘ └──────┬──────┘
       │               │               │               │
       └───────────────┴───────────────┴───────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│  PHASE 2: CROSS-PAGE CONSENSUS ENGINE                        │
│  - Hợp nhất grid labels từ nhiều plan pages                  │
│  - Spatial clustering + multi-page stability filter          │
│  - Dimension chain → mm resolution                           │
│  - Level markers → Z-height assignment                       │
│  Output: UnifiedBuildingModel                                │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│  PHASE 3: LOD GENERATOR                                      │
│  LOD300: Columns + Beams + Slabs (basic geometry)            │
│  LOD350: + Connections + Openings + Rebar                    │
│  LOD400: + Bolts + Welds + Detailed connections              │
│  Output: Ruby script (.rb)                                   │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│  PHASE 4: SKETCHUP LOADER (Ruby console)                     │
│  - Load .rb file → tạo model trong SketchUp                  │
│  - Auto-group, auto-layer, auto-material                     │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. PLAN TRIỂN KHAI (5 Sprint)

### Sprint 1: GRID SYSTEM COMPLETE (hiện tại → 2h)
- [ ] Fix grid label noise: multi-page spatial stability filter nâng cấp
- [ ] Expand Y-axis detection: search cả vùng giữa page cho labels
- [ ] Cross-page union: merge grid từ tất cả plan pages
- [ ] Verify: grid X đủ 1-10 (clean), grid Y đủ A-F, scale chính xác

### Sprint 2: LEVEL MARKERS (2h)
- [ ] Extract level markers từ elevation/section pages
- [ ] Pattern matching: RL/FFL/EL/FL + số + đơn vị
- [ ] LLM fallback: nếu text extraction không đủ → gọi LLM đọc elevation
- [ ] Resolve Z-heights: gán cao độ cho từng floor

### Sprint 3: MEMBER DETECTION (3h)
- [ ] Detect columns từ plan: tìm text marks (C1, C2...) + grid intersection
- [ ] Detect beams: connect columns along grid lines
- [ ] Schedule extraction: parse bảng thép → dimensions
- [ ] Wall detection: line patterns trên plan

### Sprint 4: RUBY CODEGEN NÂNG CẤP (2h)
- [ ] Template-based codegen cho từng member type
- [ ] LOD300: basic extrusions + positions
- [ ] LOD350: add connections, openings
- [ ] LOD400: detailed connections, bolts

### Sprint 5: END-TO-END + UI (2h)
- [ ] Pipeline end-to-end: upload PDF → .rb output
- [ ] Web UI (Gradio): upload + progress + preview
- [ ] Test với đa dạng bản vẽ (nhà 1 tầng, cao tầng, công nghiệp)

---

## 4. METRICS THÀNH CÔNG

| Metric | Target | Current |
|--------|--------|---------|
| Page classification accuracy | 100% | 100% ✅ |
| Grid X labels detected | Đủ tất cả trục | 10/10 (còn nhiễu) |
| Grid Y labels detected | Đủ tất cả trục | 2/6 (thiếu B,D,E,F) |
| Level markers | Đủ số tầng | 3 (ROOF/BASE/GROUND) |
| Columns detected | >80% thực tế | 0% |
| Beams detected | >70% thực tế | 0% |
| Ruby script validity | Load được trong SketchUp | ⚠️ Chưa test |
| Model similarity | >70% giống PDF | ~1% |

---

## 5. RISK & MITIGATION

| Risk | Impact | Mitigation |
|------|--------|------------|
| PDF scan quality kém | Grid/dimensions không detect được | LLM fallback với page image |
| Bản vẽ phức tạp (nhiều block) | Text bị fragment | Spatial clustering + font size grouping |
| Đơn vị khác nhau (mm, cm, m) | Scale sai | Unit detection từ dimension text |
| Tiếng Việt vs English | Pattern matching miss | Dual-language patterns |
| LLM cost cao | Budget vượt | Programmatic first, LLM only for hard cases |

---

## 6. GIT COMMIT HISTORY (dự kiến)

```
Phase 1: Core parser fixes (classifier, double-append, Y-axis filter)
Phase 1.5: FloorLayout→dict converter
Phase 2: Grid system complete (multi-page consensus, noise filter)
Phase 3: Level markers from elevation pages
Phase 4: Member detection (columns, beams from plan)
Phase 5: Ruby codegen nâng cấp (LOD300/350/400)
Phase 6: End-to-end pipeline + web UI