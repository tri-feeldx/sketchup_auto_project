# SketchUp Auto Pipeline — Full Execution Plan (New Session Handoff)

> **Đọc file này trước khi làm bất cứ điều gì.**
> Đây là handoff plan từ session hôm nay (2026-05-21). Claude mới cần implement theo thứ tự chính xác dưới đây.

---

## 1. Project Overview

**Mục tiêu:** PDF structural drawing → LOD300/350/400 SketchUp model tự động, accuracy 100%.
**Stack:** Python pipeline (V8) → Vertex AI (Gemini) → Ruby script → SketchUp
**Working dir:** `c:\Users\minht\Feeldx\sketchup_auto_project`
**Current branch:** `main`

### Pipeline stages (V8):
```
Stage 0-2: ScannerV6 (Forensic → Page routing → Page scanning)
Stage 3:   SynthesizerV7 (Build structural model JSON)
Stage 4:   ScheduleVerifier (Count recall check)
Stage 5:   MultiPassExtractor (retry if recall < 70%)
Stage 6:   ValidatorV7 (Geometry check)
Stage 7:   RubyGeneratorV5 (Build .rb script)
Stage 8:   RubyValidator (Check script)
Stage 9:   AccuracyEvaluator (Count recall score)
Stage 9.5: ARR / CodeReviewer
Stage 10:  Save outputs
```

---

## 2. Current State (from logs2.txt — latest run)

**Pipeline says:** SUCCESS 100% accuracy
**SketchUp shows:** Grade D — model completely broken visually

### Log2 key metrics:
- `[FILTER] Removed 13 hardware items` ← Fix 1 working (was 6)
- `[XY] Column positions — real:0 grid:34 fallback:19/53` ← 36% wrong XY
- `[XY-FOOTING] P1 → col pos (0,0)` × 6 ← ALL footings still at origin
- `[GEN] WARN: col 75SHS_BP width=75` ← baseplates leaking as columns
- `[Z] Level map resolved: 1 levels (3500mm–3500mm)` ← footing Z placed at 3500mm (above ground)
- `53c 118b 1s 0w 6f 7br` ← 118 beams (suspicious — expected 59)

### What was already implemented (DO NOT redo):
| Fix | File | Lines | Status |
|-----|------|-------|--------|
| Hardware filter: CH→"CH", add C_S, check mark field | `agents/synthesizer_v7.py` | 191-210 | ✅ Done |
| Footing XY: ID snap in synthesizer | `agents/synthesizer_v7.py` | 673-679 | ✅ Done (but doesn't help — see Bug A) |
| Footing Z: min(lmap) in synthesizer | `agents/synthesizer_v7.py` | 681-690 | ✅ Done (but broken — see Bug B) |
| Pile dims: diameter_mm + socket_length_mm | `generators/ruby_generator_v5.py` | 657-710 | ✅ Done |
| Footing fallback to sorted col_map in generator | `generators/ruby_generator_v5.py` | 667-674 | ✅ Done (but broken — see Bug A) |

---

## 3. Remaining Tier 1 Fixes (DO THESE FIRST — Today)

### Bug A — Footing XY sorted fallback includes (0,0) entries

**File:** `generators/ruby_generator_v5.py` **lines 667-674**

**Root cause:** `sorted_cols` is built from ALL col_map entries including 19 columns at (0,0) fallback. Since (0,0) sorts first, footings P1-P5 (indices 0-5) all pick (0,0) entries.

**Current code (BUGGY):**
```python
if x == 0 and y == 0 and col_map:
    sorted_cols = sorted(col_map.values(),
                         key=lambda p: (self._n(p.get("x"), 0),
                                        self._n(p.get("y"), 0)))
    if i < len(sorted_cols):
        snap = sorted_cols[i]
        x = self._n(snap.get("x"), 0)
        y = self._n(snap.get("y"), 0)
        print(f"  [XY-FOOTING] {ftg.get('id','')} -> col pos ({x},{y})")
```

**Fix — filter out (0,0) before sorting:**
```python
if x == 0 and y == 0 and col_map:
    valid_cols = [p for p in col_map.values()
                  if self._n(p.get("x"), 0) != 0 or self._n(p.get("y"), 0) != 0]
    sorted_cols = sorted(valid_cols,
                         key=lambda p: (self._n(p.get("x"), 0),
                                        self._n(p.get("y"), 0)))
    if sorted_cols:
        snap = sorted_cols[i % len(sorted_cols)]
        x = self._n(snap.get("x"), 0)
        y = self._n(snap.get("y"), 0)
        print(f"  [XY-FOOTING] {ftg.get('id','')} -> col pos ({x},{y})")
```

**Expected after fix:**
```
[XY-FOOTING] P1 -> col pos (0,0)      ← might still be 0 if first grid is at origin
[XY-FOOTING] P2 -> col pos (8000,0)
[XY-FOOTING] P3 -> col pos (16000,0)
[XY-FOOTING] RF1 -> col pos (24000,8000)
```

---

### Bug B — Footing Z placed at 3500mm (above ground, not below)

**File:** `agents/synthesizer_v7.py` **line 682**

**Root cause:** Level map only has 1 level (3500mm = first floor). `min(lmap.values()) = 3500` → footings placed at z=3500mm above datum. Should be -1000mm (below ground).

**Current code (BUGGY):**
```python
footing_z_top = min(lmap.values()) if lmap else -1000
```

**Fix — guard against positive minimum:**
```python
_lmap_min = min(lmap.values()) if lmap else -1000
footing_z_top = _lmap_min if _lmap_min < 0 else -1000
```

**Expected after fix:** Footings placed at z_top=-1000mm, z_base=-1600mm (below datum)

---

### Bug C — Baseplate suffix `_BP` leaking as structural columns

**File:** `agents/synthesizer_v7.py` **lines 191-210** — `_is_structural_col()`

**Problem:** `75SHS_BP` and `89SHS_BP` are base plates (connection hardware), not structural columns. The `_BP` suffix is the signal.

**Current hw_prefixes:**
```python
hw_prefixes = ("SH", "CH", "P80", "PF2", "RH", "UA", "EA", "C_S")
```

**Fix — add `_BP` suffix check after the prefix checks:**
```python
hw_prefixes = ("SH", "CH", "P80", "PF2", "RH", "UA", "EA", "C_S")
if any(sec.upper().startswith(p) for p in hw_prefixes):
    return False
if any(mark_str.startswith(p) for p in hw_prefixes):
    return False
# Baseplate suffix check
if sec.upper().endswith("_BP") or mark_str.endswith("_BP"):
    return False
```

**Expected after fix:** `[GEN] WARN: col 75SHS_BP` and `89SHS_BP` — Gone

---

### Verification after Tier 1 fixes

Run pipeline on same 29-page AU PDF (`UNE_Tamworth_Central_Campus`). Expected logs:

| Log line | Expected |
|----------|---------|
| `[FILTER] Removed N` | N >= 15 (was 13) |
| `[XY-FOOTING] P2 ->` | non-(0,0) position |
| `[GEN] WARN: col 75SHS_BP` | Gone |
| `[GEN] WARN: col 89SHS_BP` | Gone |
| Footing Z in Ruby | `z_base = -1000` or below |
| SketchUp visual | Footings distributed, below ground, ~750mm piles |

---

## 4. Tier 2 — ARR Redesign (2-3 weeks)

### 4.1 The Problem with Current ARR

**Design intent (user's original vision):**
> ARR = Senior Architect + Senior AI Engineer. Reads full PDF once. Supervises every stage from A→Z as a gate/principal. Blocks pipeline from proceeding if stage output is wrong.

**Current broken implementation:**
- Runs ONCE at Stage 9.5 (after everything is done)
- Only triggers if `accuracy < 95%` — which never happens (count-recall is always 100%)
- `_verify_3d_positions()` only checks Z (height=0), not XY clustering
- Does NOT read PDF at all during supervision
- Even if it runs, `_apply_corrections()` cannot update XY coordinates

**Files:** `agents/architect_reviewer.py`, `pipelines/pipeline_v8.py` lines 265-334

---

### 4.2 Correct ARR Architecture

ARR must become an **inter-stage supervisor** that:
1. Reads PDF ONCE at pipeline startup → builds `ProjectContext`
2. Acts as a **GATE** after each critical stage
3. Can REJECT a stage output and trigger retry
4. Checks BOTH count AND spatial validity

```python
# New pipeline flow:
arr = ARRSupervisor(pdf_path)
arr.build_context()  # reads title, plan, elevation pages once

# Stage 2 → ARR Gate 1
scan_result = scanner.scan(pdf)
gate1 = arr.gate_post_scan(scan_result)
if gate1.status == "FAIL": retry_scan()

# Stage 3 → ARR Gate 2
model = synthesizer.synthesize(scan_result)
gate2 = arr.gate_post_synthesize(model)
if gate2.status == "FAIL": retry_synthesize()

# Stage 7 → ARR Gate 3
ruby = generator.generate(model)
gate3 = arr.gate_post_generate(ruby, model)
if gate3.status == "FAIL": retry_or_fix()
```

---

### 4.3 ARR Gate Checks

**Gate 1 — Post-Scan:**
- Null sections > 20%? → fail, retry scan with higher DPI
- PLAN pages present? → warn if 0 plan pages
- Schedule page count reasonable for building size?

**Gate 2 — Post-Synthesize:**
- Hardware % of columns > 15%? → fail, tighten filter
- Column count vs schedule expected (tolerance ±20%)?
- Columns with no grid_ref > 30%? → flag, still pass
- Footing count matches foundation schedule?

**Gate 3 — Post-Generate:**
- Elements clustered at (0,0)? → if >30% at origin, FAIL
- Footings distributed? → if all within 100mm of each other, FAIL
- Beam spans < 500mm or > 40000mm? → flag
- Any elements outside building footprint? → warn

**New `_verify_xy_positions()` method:**
```python
def _verify_xy_positions(self, model) -> List[dict]:
    issues = []
    members = model.get("members", {})
    
    # Check column XY clustering
    cols = members.get("columns", [])
    at_origin = sum(1 for c in cols
                    if abs(c.get("x", 0) or 0) < 100 and abs(c.get("y", 0) or 0) < 100)
    if len(cols) > 0 and at_origin / len(cols) > 0.3:
        issues.append({"type": "xy_clustered", "detail": f"{at_origin}/{len(cols)} cols at origin"})
    
    # Check footing XY clustering
    ftgs = members.get("footings", [])
    ftg_origin = sum(1 for f in ftgs
                     if abs(f.get("x", 0) or 0) < 100 and abs(f.get("y", 0) or 0) < 100)
    if len(ftgs) > 0 and ftg_origin == len(ftgs):
        issues.append({"type": "footings_at_origin", "detail": f"All {len(ftgs)} footings at (0,0)"})
    
    return issues
```

**Updated trigger in pipeline_v8.py:**
```python
z_issues = arch_reviewer._verify_3d_positions(model)
xy_issues = arch_reviewer._verify_xy_positions(model)
needs_arr = (accuracy_score < ARR_ACCURACY_THRESHOLD) or bool(z_issues) or bool(xy_issues)
```

---

## 5. Tier 2 — Plan Page Column Extractor (2-3 weeks)

### 5.1 The Problem

36% of columns (19/53) have no grid reference → placed at (0,0) fallback in generator.

**Root cause:** Scanner reads each page independently. SCHEDULE pages have column marks + properties but no grid positions. PLAN pages have grid layout but scanner doesn't extract which column mark is at which grid intersection.

**Col positions in JSON:** All `grid_x: null, grid_y: null` for 19 columns → generator falls back to (0,0).

---

### 5.2 Solution — New Agent: PlanPageColumnExtractor

**New file:** `agents/plan_page_extractor.py`

**Input:** PLAN page images (from ScannerV6 page_results where page_type="PLAN")

**Output:**
```json
{
  "column_positions": {
    "C1": {"grid_x": "1", "grid_y": "A"},
    "C2": {"grid_x": "2", "grid_y": "A"},
    "C10": {"grid_x": "3", "grid_y": "B"}
  },
  "grid_x_mm": {"1": 0, "2": 8000, "3": 16000, "4": 24000},
  "grid_y_mm": {"A": 0, "B": 8000, "C": 16000, "D": 24000},
  "scale_ratio": 100,
  "confidence": 0.85
}
```

**Prompt to LLM (vision):**
```
You are reading a structural plan drawing.
1. Identify all column grid lines (numbered 1,2,3... for X; lettered A,B,C... for Y)
2. For each column mark visible (C1, C2, HB1...) — identify which grid intersection it sits at
3. Read the scale bar to determine grid spacing in mm
Return JSON: {"column_positions": {mark: {grid_x, grid_y}}, "grid_x_mm": {line: mm}, "grid_y_mm": {line: mm}, "scale_ratio": N}
```

**Integration in pipeline_v8.py — after Stage 2 (Scanner):**
```python
# After scanner completes, enrich with plan page positions
from agents.plan_page_extractor import PlanPageColumnExtractor
plan_extractor = PlanPageColumnExtractor(pdf_path, dpi=300)
plan_positions = plan_extractor.extract(scanner_output)
# Merge into scanner_output for synthesizer to consume
scanner_output["plan_column_positions"] = plan_positions
```

**Integration in synthesizer_v7.py — in `synthesize()`:**
```python
# After building columns list, enrich grid_ref from plan positions
plan_pos = scanner_output.get("plan_column_positions", {})
col_pos_map = plan_pos.get("column_positions", {})
for col in members.get("columns", []):
    cid = col.get("id") or col.get("mark", "")
    if cid in col_pos_map and not col.get("grid_x"):
        col["grid_x"] = col_pos_map[cid]["grid_x"]
        col["grid_y"] = col_pos_map[cid]["grid_y"]
```

**Expected improvement:** column fallback from 36% → <5%

---

## 6. Tier 3 — Reference Only (1-2 months)

These are NOT for immediate implementation. For planning purposes only:

- **Spatial Accuracy Metric:** `position_score = % elements within ±500mm of nearest grid intersection`. Grade A requires BOTH count_recall AND position_score ≥ 95%.
- **Scale Bar Parser:** Pixel-to-mm conversion from plan page scale bar → validate grid spacing
- **Structural Logic Validator:** Check beam spans (1m–30m), column height consistency with F2F heights, bracing angles (30°–60°)
- **LOD350 Connections:** Base plates from detail pages, beam-column connections, bolt patterns
- **LOD400:** Shop drawing parser, fabrication tolerances, AS/NZS 4600 compliance

---

## 7. File Index (Critical Files)

| File | Role | Key functions |
|------|------|---------------|
| `pipelines/pipeline_v8.py` | Orchestrator | `run()`, Stage gates, ARR trigger (line 284) |
| `agents/synthesizer_v7.py` | Model builder | `_is_structural_col()` (line 191), `_assign_z_to_all_members()` (line 640+) |
| `agents/architect_reviewer.py` | ARR agent | `review()`, `_verify_3d_positions()` (line 300), `_verify_xy_positions()` (NEW) |
| `generators/ruby_generator_v5.py` | Ruby builder | `_footing_ruby_v5()` (line 657), `_build_col_map()` |
| `agents/scanner_v6.py` | PDF scanner | Page routing, LLM scan per page |
| `metrics/accuracy_evaluator.py` | Count recall | `evaluate()` — currently count-only |
| `output/v8/Structural_model.json` | Latest model | Ground truth for debugging |
| `logs2.txt` | Latest run log | Reference for current bugs |

---

## 8. Known Data Facts (UNE Tamworth Building)

**Grid system (from Structural_model.json):**
- X: 1→0mm, 2→8000mm, 3→16000mm, 4→24000mm
- Y: D→0mm, C→8000mm, B→16000mm, A→24000mm

**Footings (from JSON):**
- P1: pile, diameter_mm=750, socket_length_mm=600, NO x/y
- P2: pile, diameter_mm=750, socket_length_mm=3000, NO x/y
- P3: pile, diameter_mm=600, socket_length_mm=300, NO x/y
- P4: pile, diameter_mm=750, socket_length_mm=7000, NO x/y
- P5: pile, diameter_mm=750, socket_length_mm=19000, NO x/y
- RF1: raft, width_mm=5600, depth_mm=6500, height_mm=1000, NO x/y

**Levels:** 8 levels from -1000mm to 20000mm (LLM path); or 1 level at 3500mm (deterministic path — this is the broken one)

**Hardware already filtered:** CH35c, CH40b, CH35a, CH13c, C_S9_A–D, C_S10_A–D, UB36c, UB20d
**Hardware still leaking:** 75SHS_BP, 89SHS_BP (Bug C above)

---

## 9. Execution Order for New Session

```
Step 1: Read this file fully
Step 2: Read agents/synthesizer_v7.py lines 191-210 and 663-695
Step 3: Read generators/ruby_generator_v5.py lines 657-710
Step 4: Implement Bug A fix (footing XY, line 667-674 in generator)
Step 5: Implement Bug B fix (footing Z guard, line 682 in synthesizer)
Step 6: Implement Bug C fix (_BP suffix, line ~200 in synthesizer)
Step 7: Ask user to run pipeline and share new log
Step 8: Verify log output matches expected table in section 3
Step 9: If Tier 1 verified → proceed to Tier 2 ARR Redesign
Step 10: Start with _verify_xy_positions() in architect_reviewer.py
Step 11: Update ARR trigger in pipeline_v8.py line 284
Step 12: Then Plan Page Column Extractor (new file)
```

---

## 10. Architecture Decisions (Do Not Change Without Discussion)

1. **Column XY resolution happens in GENERATOR** (not synthesizer). Synthesizer only has `grid_x`/`grid_y` strings. Generator's `_resolve_grid_xy()` converts to mm. So footing XY fallback MUST be in generator using `col_map` (resolved positions).

2. **Accuracy metric = count recall** (current). Do NOT change this metric until Tier 3 spatial metric is ready — changing it will break ARR threshold logic.

3. **LLM call caching** — cache key is content hash. Same PDF run can produce different results if cache misses. This is a known reliability issue (Tier 2b to fix with deterministic synthesizer cache).

4. **ARR current role** — until redesigned, ARR is effectively dead code for position issues. Do not rely on it. Fix positions in Synthesizer + Generator directly.
