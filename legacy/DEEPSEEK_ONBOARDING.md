# DeepSeek Onboarding: SketchUp Auto Project

> **Role:** Principal AI Engineer — đồng hành phát triển hệ thống PDF→SketchUp LOD300.
> **Date:** 2026-05-19
> **Context:** Project đã qua 5 version pipeline. Mục tiêu hiện tại: đạt output Ruby SketchUp Script khớp 80%+ bản vẽ gốc.

---

## 1. PROJECT OVERVIEW

**Mission:** Tự động chuyển đổi bản vẽ kết cấu PDF → file `.rb` cho SketchUp, ở mức LOD300 (chi tiết trung bình-cao: đầy đủ kích thước, section, connection, rebar).

**Pipeline hiện tại (V5 → đang nâng lên V6 AU):**
```
PDF → [Forensic] → [VisionRenderer (300DPI PNG)] → [Scanner V5 (Gemini Vision)] 
    → [Model Builder] → [Ruby Generator] → output/final_ruby_scripts/*.rb
```

**Stack:**
- Python 3.11+
- PyMuPDF (fitz) — PDF parsing
- Pillow — image manipulation
- Gemini API (gemini-2.5-flash) — core LLM for vision + text extraction
- LangChain/LangGraph — agent orchestration (đang triển khai)
- DeepSeek local — hỗ trợ extraction, validation, code generation (qua Continue.dev)

---

## 2. DIRECTORY STRUCTURE

```
sketchup_auto_project/
├── agents/                     # Core intelligence modules
│   ├── pdf_forensic.py         # [NEW V6] Pre-LLM PDF analysis (keyword detection, region)
│   ├── prompt_factory_au.py    # [NEW V6] Australian AS/NZS drawing prompts
│   ├── scanner_v5.py           # Current scanner (Gemini Vision)
│   ├── pdf_classifier.py       # Old classifier
│   ├── structural_scanner.py   # V3 structural scanner
│   ├── structural_extractor.py # V3 structural extractor
│   ├── ruby_generator_v4.py    # Ruby .rb code generator
│   ├── coder.py, auditor.py    # Self-check + audit agents
│   └── ... (older agents)
├── core/
│   ├── llm_wrapper.py          # LLM API wrapper (Gemini)
│   ├── vision_renderer.py      # PDF→PNG rendering at configurable DPI
│   ├── pdf_utils.py            # PDF utilities
│   └── analysis_context.py     # Analysis context manager
├── data/
│   ├── input_pdf/              # Input PDFs
│   │   ├── structural.pdf      # 29-page AU structural (concrete + steel)
│   │   └── St_Carloa_Moama.pdf # 27-page AU steel portal frame
│   └── backup_debug/           # Debug data
├── output/
│   └── final_ruby_scripts/     # Generated .rb files for SketchUp
├── pipeline_v5.py              # [ACTIVE] Main V5 pipeline
├── config.py                   # Configuration
├── main.py                     # Old entry point
├── app.py                      # Web UI (Flask)
└── ARCHITECTURE.md             # Architecture documentation
```

---

## 3. CURRENT STATUS (as of 2026-05-19)

### What Works
- PDF → PNG rendering at 300 DPI ✓
- Single-page vision extraction (Gemini) ✓
- Page classification (plan/elevation/section/schedule/detail) ✓ (70% accuracy)
- Basic Ruby code generation ✓
- Web UI upload page ✓

### What DOES NOT Work (Root Causes → V6 fixes in progress)
1. **LLM không hiểu quy ước bản vẽ Úc (AS/NZS):** Section UB/UC/PFC, rebar N12-N16 notation, RL levels → Fix: `prompt_factory_au.py` + `pdf_forensic.py`
2. **Thiếu forensic pre-analysis:** Pipeline không biết PDF thuộc region nào, material gì, có schedules không → Fix: `pdf_forensic.py` tích hợp vào pipeline
3. **Không có agentic validation loop:** Scanner extract sai nhưng không tự sửa → Fix: sắp tới thêm validation agent
4. **Single-page context:** Mỗi page xử lý độc lập, không cross-reference schedules với plans → Fix: multi-page synthesis

### 2 PDFs Đang Test
| File | Pages | Type | Standard |
|------|-------|------|----------|
| `structural.pdf` | 29 | Concrete + Steel Building | AS/NZS |
| `St_Carloa_Moama.pdf` | 27 | Steel Portal Frame | AS4100 + AS3600 |

---

## 4. AUSTRALIAN STRUCTURAL DRAWING CONVENTIONS

### Steel Sections (AS/NZS 3679.1, AS/NZS 1163)
| Code | Name | Typical Use |
|------|------|-------------|
| UB | Universal Beam | Beams, rafters |
| UC | Universal Column | Columns |
| PFC | Parallel Flange Channel | Purlins, girts, bracing |
| RHS/SHS | Rectangular/Square Hollow Section | Columns, bracing |
| EA/UA | Equal/Unequal Angle | Bracing, cleats, fly braces |
| Z/C | Zed/C Channel | Purlins, girts (cold-formed G450/G500) |

### Steel Grades
- Grade 250 (AS/NZS 3678) — Plate
- Grade 300 (AS/NZS 3679.1) — Hot-rolled sections
- Grade C350 (AS/NZS 1163) — Hollow sections
- G450, G500 — Cold-formed purlins/girts

### Reinforcement (AS 3600)
- N12, N16, N20, N24, N28, N32 — 500 MPa deformed bars
- R10, R12 — 250 MPa round bars
- "N12-300 E.F." = N12 bars @ 300mm spacing, Each Face
- Cover: 40-75mm depending on exposure classification

### Level Notation
- RL (Reduced Level) — height above Australian Height Datum (metres, 2 decimal)
- FFL — Finished Floor Level
- SSL — Structural Slab Level
- TOS — Top of Steel
- TOB/TOC/BOC — Top of Beam/Concrete, Bottom of Concrete

### Grid System
- Numbers (1,2,3...) — horizontal, left to right
- Letters (A,B,C...) — vertical, bottom to top
- Grid intersection (1,A) typically origin (0,0,0)
- Typical spacing: 6000-9000mm residential, 8000-12000mm industrial

---

## 5. PROMPT FACTORY ARCHITECTURE (V6)

```
AustralianPromptFactory (agents/prompt_factory_au.py)
├── SYSTEM_AU_STRUCTURAL_ENGINEER          # Principal engineer persona
├── PAGE_CLASSIFICATION_AU                  # Classify drawing type
├── STRUCTURAL_PLAN_AU_PROMPT              # Plan extraction schema
├── STRUCTURAL_ELEVATION_AU_PROMPT         # Elevation extraction schema
├── STRUCTURAL_SCHEDULE_AU_PROMPT          # Schedule extraction schema
├── STRUCTURAL_DETAIL_AU_PROMPT            # Detail extraction schema
└── get_validation_prompt()                # Error correction prompt
```

Each prompt enforces:
- Exact JSON output schema
- Australian conventions embedded
- Coordinate system: (0,0) = bottom-left grid intersection, Z-up
- All dimensions in millimetres
- RL values × 1000 = mm

---

## 6. FORENSIC PIPELINE

```
PDFForensicAnalyzer (agents/pdf_forensic.py)
├── _extract_pages()       # PyMuPDF: page sizes, orientations, text
├── _detect_keywords()     # AU_KEYWORDS, VN_KEYWORDS, INTL_KEYWORDS
├── _derive_region()       # "au", "vn", "intl", "unknown"
├── _derive_material()     # "steel", "concrete", "mixed"
├── _derive_building_type() # "portal_frame", "multi_storey", "industrial"
└── _derive_has_types()    # has_plans, has_elevations, has_schedules, ...
```

Output → ForensicResult dict feed vào prompt để calibrate LLM.

---

## 7. CRITICAL CODE PATTERNS

### Calling Gemini via llm_wrapper
```python
from core.llm_wrapper import LLMWrapper
llm = LLMWrapper()  # uses GEMINI_API_KEY from .env
response = llm.chat(
    system_prompt=SYSTEM_AU_STRUCTURAL_ENGINEER,
    user_prompt=prompt_text,
    image_paths=[image_path],  # optional vision
)
data = json.loads(response)
```

### Running Forensic
```python
from agents.pdf_forensic import run_forensic
result = run_forensic("data/input_pdf/structural.pdf")
# result.region → "au"
# result.primary_material → "mixed"
# result.keywords → {"UB_sections": True, ...}
```

### Building AU Prompt
```python
from agents.prompt_factory_au import AustralianPromptFactory
prompt = AustralianPromptFactory.get_prompt(
    drawing_type="structural_plan",
    page_idx=0,
    total_pages=29,
    text_context=page_text,
)
# enrich with forensic
prompt = AustralianPromptFactory.enrich_with_forensic(prompt, forensic_data)
```

---

## 8. NEXT PRIORITIES (Ordered)

1. **[DONE]** forensic.py → module tích hợp
2. **[DONE]** prompt_factory_au.py với full AS/NZS domain
3. **[TODO]** Tích hợp forensic + prompt_factory vào pipeline_v5 → pipeline_v6_au.py
4. **[TODO]** Agentic validation loop (scanner extract → validate → correct)
5. **[TODO]** Multi-page synthesis (cross-reference schedules with plans)
6. **[TODO]** DeepSeek local integration cho extraction tasks
7. **[TODO]** Ruby generator nâng cấp với AU section library
8. **[TODO]** Test full pipeline trên cả 2 PDFs

---

## 9. USEFUL COMMANDS

```bash
# Run forensic on a PDF
python -c "from agents.pdf_forensic import run_forensic; run_forensic('data/input_pdf/structural.pdf')"

# Run V5 pipeline
python pipeline_v5.py

# Test single LLM extraction
python -c "
from core.llm_wrapper import LLMWrapper
from agents.prompt_factory_au import AustralianPromptFactory
llm = LLMWrapper()
pf = AustralianPromptFactory()
prompt = pf.get_prompt('structural_plan', 0, 29, 'test text')
print(llm.chat(pf.get_system_prompt('structural_plan'), prompt)[:500])
"

# List all Python agents
ls agents/*.py

# Git
git status
git add -A && git commit -m "V6: Australian prompt factory + forensic analyzer" && git push
```

---

## 10. DEEPSEEK'S ROLE

DeepSeek chạy local qua Continue.dev có thể hỗ trợ:

1. **Code Completion & Review:** Hiểu codebase, suggest improvements
2. **Extraction Validation:** Kiểm tra JSON output từ Gemini có hợp lệ schema không
3. **Ruby Code Review:** Đọc file .rb generated, check syntax Ruby
4. **Prompt Engineering:** Đề xuất cải tiến prompt template
5. **Test Generation:** Viết test cases cho các agent

Khi cần DeepSeek xử lý text extraction (thay vì Gemini Vision), cần thêm:
- `agents/deepseek_extractor.py` — wrapper gọi DeepSeek API local
- Prompt format tương thích DeepSeek (có thể khác Gemini)

---

*End of Onboarding Document. Project lead: minht@Feeldx. Repo: github.com/Boothill2001/sketchup_auto_project*