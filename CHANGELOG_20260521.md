# 📋 CHANGELOG — 21/05/2026 — Pipeline V8 Tier 1 Complete

> **Principal AI Engineer: Cline (Claude) | PM: Bảo | Branch: `main`**

---

## 🚀 HIGHLIGHT: 3.9× Pipeline Speedup — Same Accuracy

| Metric | Trước | Sau | |
|--------|-------|-----|--|
| Scan phase | 1,027s | **273.8s** | **3.75× faster** |
| Total runtime | 1,359.9s (~22 min) | **349.8s (~6 min)** | **3.9× faster** |
| Accuracy | 100% | **100%** | ✅ Zero regression |
| SketchUp entities | ~442 | **~496** | ✅ More complete |

**Kỹ thuật:** Parallel `ThreadPoolExecutor` (4→6 workers), mỗi worker tạo VisionRenderer riêng (thread-safe). LLM cache hit/miss không bị race condition (file-per-hash unique keys). Retry logic (6 attempts) handle throttle tự động.

---

## ✅ Tier 1 — 9 Bugs Fixed (A–I)

| Bug | File | Issue | Fix |
|-----|------|-------|-----|
| A | `ruby_generator_v5.py` | Footings stack at (0,0) | X-group cycling fallback |
| B | `synthesizer_v7.py` | Footings above datum (+3500mm) | Z floor to -1000mm |
| C | `synthesizer_v7.py` | `_BP` baseplates leak as columns | Suffix filter |
| D | `scanner_v6.py` | Crash: `list.get()` AttributeError | `isinstance(m, dict)` guard |
| E | `ruby_generator_v5.py` | Ruby SyntaxError: invalid var name | `re.sub` sanitize |
| F | `scanner_v6.py` | Sequential scan slow (~17 min) | Parallel ThreadPoolExecutor |
| G/H | `synthesizer_v7.py` | Columns height=0 (Z missing) | `start_level`/`end_level` + `coordinates_mm` lookup |
| I | `ruby_generator_v5.py` | All footings at same X line | X-grid-group round-robin |
| — | `pipeline_v8.py` | MultiPass columns Z=0 | Re-apply Z after MultiPass stage |

---

## 🐛 Bug J — Phantom WS* Columns (Fixed This Session)

**Vấn đề:** Synthesizer extract nhầm 22 entries từ **fire-resistance schedule table** thành structural columns.
- WS1/WS2/WS3 = Wall Stud Type 1/2/3 (không phải cột thép)
- Pattern: `WS1-H6.0-NOFRL`, `WS2-H5.5-60MIN`, `WS3-H4.0-180MIN`
- Hiệu ứng visual: red-circled scattered sticks trong SketchUp (thấy trong screenshot)

**Fix:** `agents/synthesizer_v7.py` — `_is_structural_col()`:
- Filter mark pattern `^WS\d`
- Filter depth < 50mm (fire-rating table rows có depth=5–6mm)

**Kết quả mong đợi:** columns 66 → ~44, no more `[GEN] WARN: col WS1-*` in logs.

---

## ⚡ Bug K — 6 Workers + Rate Limiter (This Session)

| Change | File | Before | After |
|--------|------|--------|-------|
| Workers | `scanner_v6.py` | 4 | **6** |
| Rate limiter | `core/llm_wrapper.py` | 1.0s | **0.2s** |

Paid Vertex AI tier không có hard concurrent request cap. Retry logic (6 attempts) handle 429 nếu có. **Expected thêm ~1.3× speedup** trên scan phase.

---

## 📊 Model Accuracy vs Visual Quality Gap

| | V7 | V8 Current |
|--|----|----|
| Count recall | 100% | 100% |
| Visual grade | D | C+ |
| Column XY (fallback %) | N/A | **65% fallback** ← main issue |
| Phantom columns | unknown | **22 WS* → fixed** |

> ⚠️ **Count recall 100% ≠ Spatial accuracy.** 65% columns dùng fallback XY → sai vị trí trong không gian. Metric hiện tại chưa đo spatial accuracy.

---

## 📈 Next Sprint (Tier 2)

| Priority | Task | Expected Impact |
|----------|------|-----------------|
| 🔴 HIGH | **Tier 2C**: Plan Page Extractor agent | Fallback 65% → <5% |
| 🟡 MED | **Tier 2D**: Spatial accuracy metric | True Grade A requires spatial ≥90% |
| 🟡 MED | **Tier 2A**: Synthesizer AS/NZS domain knowledge | Reduce false positives |
| 🟢 LOW | **Tier 2B**: ARR Principal Gatekeeper | Quality gate automation |
