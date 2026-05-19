# 📋 CHANGELOG — 19/05/2026 — Pipeline V7 Production Ready

> **Principal AI Engineer: Cline (Claude) | PM: Bảo | Git: `e4e3cee` | Branch: `main`**

---

## ✅ Pipeline Status: Production Ready

Pipeline V7 chạy thành công trên sample PDF 29 pages:
- **25 columns, 5 beams, 3 slabs, 30 walls** extracted
- Validator: **PASSED** (30 warnings + 25 info)
- Runtime: **~1087s (~18 phút)**
- Output: `output/v7/Structural_structural.rb` (610 lines)

---

## 🏗️ Kiến trúc V7 Multi-Agent Pipeline

```
PDF → PDFForensic → PageRouter → ScannerV6 → SynthesizerV7 → ValidatorV7 → RubyGeneratorV5 → RubyValidator → .rb
```

| # | Agent | File | Vai trò | Status |
|---|-------|------|---------|--------|
| 0 | **PDFForensic** | `agents/pdf_forensic.py` | Phân tích cấu trúc PDF (pages, text density, layout) | ✅ Modified |
| 1 | **PageRouter** | `pipelines/page_router.py` | Phân loại trang (structural/architectural/unknown) | 🆕 New |
| 2 | **ScannerV6** | `agents/scanner_v6.py` | Extract dimensions bằng Gemini từ từng trang | 🆕 New |
| 3 | **SynthesizerV7** | `agents/synthesizer_v7.py` | Tổng hợp multi-page → unified structural model JSON | 🆕 New |
| 4 | **ValidatorV7** | `agents/validator_v7.py` | Quality gate: dimension ranges, consistency, symmetry | 🆕 New |
| 5 | **RubyGeneratorV5** | `generators/ruby_generator_v5.py` | Sinh `.rb` (LLM-first, deterministic fallback) | 🆕 New |
| 6 | **RubyValidator** | `generators/ruby_validator.py` | Validate syntax `.rb` trước output | 🆕 New |
| — | **PipelineV7** | `pipelines/pipeline_v7.py` | Orchestrator toàn pipeline + write summary.json | 🆕 New |
| — | **PromptFactory** | `pipelines/prompt_factory.py` | Centralized prompt builder cho mọi agent | 🆕 New |
| — | **LLM Warpper** | `core/llm_wrapper.py` | Vertex AI interface (Gemini 2.5 Flash) | ✅ Modified |
| — | **App** | `app.py` | Streamlit UI | ✅ Redesigned |

**Files mới:** `agents/scanner_v6.py`, `agents/synthesizer_v7.py`, `agents/validator_v7.py`, `generators/`, `pipelines/`  
**Files sửa:** `agents/pdf_forensic.py`, `core/llm_wrapper.py`, `app.py`

---

## 🐛 9 Bug Fixes Chi Tiết

### Bug 1: ImportError trong pipeline_v7
- **File:** `pipelines/pipeline_v7.py`
- **Root cause:** `ScannerV6.analyze()` API signature không khớp cách gọi + import path sai
- **Fix:** Rewrite toàn bộ `PipelineV7.run()` align với API thực tế của ScannerV6

### Bug 2: summary.json thiếu success/duration_sec
- **File:** `pipelines/pipeline_v7.py`
- **Root cause:** Gọi `result.to_dict()` và `json.dump()` trước khi gán `result.success = True` và `result.duration_sec = time.time() - t0`
- **Fix:** Đảo thứ tự — set result fields trước, write JSON sau

### Bug 3: KeyError 'text' trong SynthesizerV7
- **File:** `agents/pdf_forensic.py`
- **Root cause:** `PageForensic.to_dict()` chỉ export `page_number`, `page_type`, `confidence`, `metadata` — thiếu field `"text"`
- **Fix:** Thêm `"text": self.text` vào dict return

### Bug 4: TypeError call_llm() missing 'system'
- **File:** `core/llm_wrapper.py` + `pipelines/prompt_factory.py`
- **Root cause:** Prompt V7 gọi `call_llm(user_prompt)` nhưng function signature yêu cầu `system` param
- **Fix:** Thêm `system=prompt_factory.system_prompt_scanner(page_type)` vào tất cả call sites

### Bug 5: Force Fresh không xóa V7 output
- **File:** `app.py`
- **Root cause:** Force Fresh chỉ gọi `clear_cache()` (LLM cache), không xóa `output/v7/`
- **Fix:** Thêm xóa `output/v7/` + legacy JSONs trong `OUTPUT_JSON_DIR` + legacy `.rb` trong `RUBY_OUTPUT_DIR`

### Bug 6: Page count heuristic sai
- **File:** `app.py`
- **Root cause:** Ước lượng `n_pages = len(pdf_bytes) / 80KB` → sai ±50%
- **Fix:** Dùng **PyMuPDF (`fitz`)** đọc `doc.page_count` thực tế
- **Install:** `pip install PyMuPDF`

### Bug 7: TypeError '<' str vs int trong ValidatorV7
- **File:** `agents/validator_v7.py`
- **Root cause:** LLM scan trả về dimension dạng `"200"` (string) thay vì `200` (int). Python3 không so sánh được `str < int`
- **Fix:** `float()` coercion + try/except ValueError trong **6 method**: `_check_column_dimensions`, `_check_beam_dimensions`, `_check_slab_dimensions`, `_check_wall_dimensions`, `_check_footing_dimensions`, `_check_floor_heights`

### Bug 8: UI hiển thị sai hướng dẫn .skp
- **File:** `app.py`
- **Root cause:** Pipeline hiện tại dừng ở `.rb`, không sinh `.skp` (binary format độc quyền Trimble SketchUp)
- **Fix:** UI display: download `.rb` + hướng dẫn `SketchUp → Ruby Console → load 'path/to/file.rb' → Save As .skp`

### Bug 9 (CRITICAL): reference to deleted DrawingElement
- **File:** `generators/ruby_generator_v5.py`
- **Root cause:** SketchUp Ruby API: `.pushpull` **xóa face gốc** và tạo solid mới dưới dạng `Group`. Gọi `.material=` sau `.pushpull` crash vì face reference đã bị delete
- **Fix:** Đảo thứ tự trong **5 method** (`_col_ruby`, `_beam_ruby`, `_slab_ruby`, `_wall_ruby`, `_footing_ruby`):
  ```ruby
  # TRƯỚC (bug):
  f_0.pushpull(-3500) if f_0   # ← xóa face
  f_0.material = mat if f_0    # ← CRASH: face đã bị xóa
  
  # SAU (fix):
  f_0.material = mat if f_0    # ← OK: face còn sống
  f_0.layer = layers['cols'] if f_0
  f_0.pushpull(-3500) if f_0   # ← pushpull sau cùng
  ```

---

## 🎨 UI Redesign (app.py)
- Dark theme: gradient sidebar `#0f172a → #1e293b`
- Gradient primary buttons: `#3b82f6 → #6366f1`
- Tab layout: `📊 Dashboard` | `📟 Terminal Log`
- Live progress bar + streaming terminal log
- Force Fresh checkbox: xóa LLM cache + V7 output + legacy files
- PyMuPDF actual page count
- Download buttons: `.rb`, `combined.rb`, debug log

---

## 🚀 Quick Start

```bash
# Install dependencies
pip install streamlit PyMuPDF google-cloud-aiplatform

# Set Vertex AI credentials
# (dùng service account: river-bedrock-496101-a7)

# Run
streamlit run app.py
# → http://localhost:8505

# Pipeline:
# 1. Upload PDF
# 2. Check "Force Fresh Run" nếu muốn chạy lại từ đầu
# 3. Select "V7 (Next-Gen Quality Gate)"
# 4. Nhấn Start Conversion
# 5. Download .rb → Load vào SketchUp Ruby Console
```

---

## 📌 Ghi Chú Cho DeepSeek

1. **Pipeline đã chạy thành công** với file PDF 29 pages structural
2. **Output chuẩn:** `output/v7/Structural_structural.rb` (610 lines)
3. **Validator** đang PASS nhưng có 55 issues (30 warnings + 25 info) — có thể cần tune prompt
4. **RubyGeneratorV5** dùng chiến lược **LLM-first, deterministic fallback** — nếu LLM fail sẽ tự sinh code cơ bản
5. **Bug #9** là critical nhất — nếu không fix, SketchUp crash ngay dòng 30
6. **Vertex AI region:** `us-central1`, model: `gemini-2.5-flash-preview-0519`
7. Các file trong `output/v7/` đã commit lên git (để có sample output reference)

---

**Commit:** `e4e3cee` • **Date:** 2026-05-19 • **By:** Cline (Claude) • **PM:** Bảo