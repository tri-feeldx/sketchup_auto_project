# SketchUp Auto Pipeline — Master Execution Plan
**Version:** 2.0 | **Updated:** 2026-05-21 | **Branch:** main

> **Đọc toàn bộ file này trước khi viết bất kỳ dòng code nào.**
> Đây là plan A-Z từ trạng thái hiện tại đến LOD300/350/400.

---

## 0. Vision & Philosophy

**Mục tiêu cuối:** PDF structural drawing → LOD300/350/400 SketchUp model, chính xác như
một nhân công tay nghề cao đang làm thực sự — không phải một parser đơn giản.

**Mental model đúng: Đội chuyên gia, không phải pipeline:**

```
┌─────────────────────────────────────────────────────────────────┐
│  PRINCIPAL (ARR)                                                │
│  Senior Architect + AI Engineer                                  │
│  → Đọc toàn bộ PDF trước. Biết intent cả project.             │
│  → Giám sát từng stage. Block nếu output sai. Không thương.   │
└──────────┬──────────────┬──────────────┬─────────────────┬─────┘
           │              │              │                 │
           ▼              ▼              ▼                 ▼
     Document         Detailer     Structural          BIM Tech
     Analyst          (PLAN pages) Engineer            (Generator)
     (Scanner)                     (Synthesizer)
     
     Đọc, phân       Đọc không     Domain expert:     LOD conventions,
     loại, cross-    gian, grid,   AS/NZS sections,   tọa độ chính xác,
     reference       scale bar,    building logic,     confidence-aware
     drawings        column marks  hardware vs struct  placement
```

**Nguyên tắc:**
- Mỗi agent là chuyên gia cấp cao trong lĩnh vực hẹp của mình
- Agents có domain knowledge thực sự, không phải generic LLM calls
- Mỗi output có confidence score — agents biết mình không biết gì
- ARR (Principal) đọc PDF trước tất cả, gate từng stage
- Hệ thống tự nhận biết khi output không đáng tin và escalate

---

## 1. System Overview

**Stack:** Python pipeline (V8) → Vertex AI (Gemini) → Ruby script → SketchUp
**Working dir:** `c:\Users\minht\Feeldx\sketchup_auto_project`
**Branch:** `main`

**Current pipeline stages (V8):**
```
Stage 0:   ARR Principal — build_context() [TO BE ADDED at startup]
Stage 0-2: ScannerV6 → Document Analyst
Stage 2.5: PlanPageExtractor → Detailer [NEW AGENT]
Stage 3:   SynthesizerV7 → Structural Engineer
Stage 4:   ScheduleVerifier
Stage 5:   MultiPassExtractor
Stage 6:   ValidatorV7
Stage 7:   RubyGeneratorV5 → BIM Tech
Stage 8:   RubyValidator
Stage 9:   AccuracyEvaluator (count + spatial)
Stage 9.5: ARR Gates (post-scan, post-synth, post-generate) [REDESIGN]
Stage 10:  Save outputs
```

---

## 2. Current State (from logs2.txt — latest run 2026-05-21)

**Pipeline says:** SUCCESS 100% | **SketchUp shows:** Grade D (broken visually)

```
[FILTER] Removed 13 hardware items (was 6) ← partial fix
[XY] Column positions — real:0 grid:34 fallback:19/53 ← 36% wrong XY
[XY-FOOTING] P1 → col pos (0,0) × 6 ← all footings at origin
[GEN] WARN: col 75SHS_BP ← baseplates leaking
[Z] Level map resolved: 1 levels (3500mm) ← footings at 3500mm (above ground)
```

**Root problem:** Accuracy metric = count recall only. 100% count ≠ 100% spatial accuracy.
The pipeline cannot detect its own visual failures.

---

## 3. TIER 1 — Immediate Bug Fixes (Do First, Today)

These are surgical fixes to existing code. No new agents. No architecture changes.

### Bug A — Footing XY fallback picks (0,0) entries

**File:** `generators/ruby_generator_v5.py` **lines 667–674**

Current `sorted_cols` includes all 19 columns at (0,0) → (0,0) sorts first → all footings land at origin.

**Fix:**
```python
# REPLACE lines 667-674 with:
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

### Bug B — Footing Z at 3500mm (above ground)

**File:** `agents/synthesizer_v7.py` **line 682**

`min(lmap.values()) = 3500` when lmap only has 1 floor level → footings above ground.

**Fix:**
```python
# REPLACE line 682 with:
_lmap_min = min(lmap.values()) if lmap else -1000
footing_z_top = _lmap_min if _lmap_min < 0 else -1000
```

### Bug C — `_BP` suffix baseplates leaking as columns

**File:** `agents/synthesizer_v7.py` **~line 205** — inside `_is_structural_col()`

**Fix — add after existing prefix checks:**
```python
# Add after the mark_str prefix check block:
if sec.upper().endswith("_BP") or mark_str.endswith("_BP"):
    return False
```

### Tier 1 Verification

Run pipeline on same 29-page AU PDF. Expected log changes:

| Check | Expected |
|-------|----------|
| `[FILTER] Removed N` | N ≥ 15 |
| `[XY-FOOTING] P2 ->` | non-(0,0) value |
| `[GEN] WARN: col 75SHS_BP` | Gone |
| `[GEN] WARN: col 89SHS_BP` | Gone |
| SketchUp footings | Distributed on grid, ~750mm piles, below datum |

---

## 4. TIER 2A — Synthesizer → Senior Structural Engineer

**Why first:** Highest ROI. No new files, no pipeline changes. Just upgrade the domain knowledge in the existing Synthesizer.

**File:** `agents/synthesizer_v7.py`

### 4.1 AS/NZS Section Library (embed in synthesizer prompt)

Add a domain knowledge constant at the top of the file:

```python
ASNZS_STRUCTURAL_SECTIONS = """
STRUCTURAL COLUMNS (AS/NZS 3679.1): UC (Universal Column), WC (Welded Column),
  RHS (Rectangular Hollow Section), SHS (Square Hollow Section — when used as column),
  CHS (Circular Hollow Section — when used as column)
STRUCTURAL BEAMS (AS/NZS 3679.1): UB (Universal Beam), WB (Welded Beam),
  PFC (Parallel Flange Channel), TFB (Tapered Flange Beam)
CONNECTION HARDWARE (NOT structural members): CH (Channel — connection),
  SH (Shear hardware), EA (Equal Angle — gusset), UA (Unequal Angle),
  C_S (Stud connector), _BP suffix (Base Plate)
PILE TYPES (AS 2159): driven pile (diameter_mm + socket_length_mm),
  bored pile, screw pile
TYPICAL FLOOR-TO-FLOOR: residential 2700-3000mm, commercial 3500-4200mm,
  carpark 2400-2800mm
"""
```

Inject into the LLM system prompt in `synthesize()`.

### 4.2 Confidence Scoring on every element

Every column, beam, footing output must include a `_confidence` field:

```python
# Synthesizer should produce:
{
  "id": "C1",
  "section": "250UC89",
  "grid_x": "1", "grid_y": "A",
  "_confidence": 0.95,   # high: clear text, unambiguous
  "_source": "schedule_page_3"
}
{
  "id": "C15",
  "section": "250UC89",
  "grid_x": null, "grid_y": null,
  "_confidence": 0.4,    # low: no grid ref found
  "_source": "schedule_page_7",
  "_note": "grid position not found on any plan page"
}
```

Prompt addition for synthesizer LLM call:
```
For each structural member, add "_confidence" (0.0-1.0):
  1.0 = all fields clear, unambiguous
  0.7 = most fields clear, minor uncertainty
  0.4 = key field (position/section) inferred or ambiguous
  0.1 = mostly guessed
Add "_note" if confidence < 0.7 explaining the uncertainty.
```

### 4.3 Building Logic Rules (pre-output validation in synthesizer)

Add `_validate_building_logic()` before returning model:

```python
def _validate_building_logic(self, members: dict, grid_system: dict) -> List[str]:
    warnings = []
    cols = members.get("columns", [])
    beams = members.get("beams", [])
    
    # Column height sanity (typical commercial: 3000-5000mm)
    for col in cols:
        h = col.get("height_mm") or col.get("height") or 0
        try:
            if float(h) < 2000 or float(h) > 6000:
                warnings.append(f"Col {col.get('id')}: height={h}mm unusual")
        except: pass
    
    # Section size vs span ratio (UC columns for spans >6m should be ≥200UC)
    # Beam span vs section (UB span:depth ratio typically 15-20)
    for beam in beams:
        sec = str(beam.get("section", ""))
        if "UB" in sec:
            # Extract depth from section name (e.g. 310UB → 310mm)
            import re
            nums = re.findall(r'\d+', sec)
            if nums:
                depth = int(nums[0])
                if depth < 150:
                    warnings.append(f"Beam {beam.get('id')}: UB{depth} very shallow")
    return warnings
```

---

## 5. TIER 2B — ARR → Principal/Gatekeeper (Full Redesign)

**Files:**
- `agents/architect_reviewer.py` — major rewrite
- `pipelines/pipeline_v8.py` — integration changes

### 5.1 New ARR Architecture

```python
class ARRPrincipal:
    """
    Senior Architect + AI Engineer.
    Reads full PDF ONCE at startup. Supervises every stage as gatekeeper.
    Never runs after the fact — runs BETWEEN stages.
    """
    
    def __init__(self, pdf_path: str, region: str = "au"):
        self.pdf_path = pdf_path
        self.region = region
        self.context: ProjectContext = None  # set by build_context()
    
    def build_context(self) -> ProjectContext:
        """
        Read PDF once: title page + all plan pages + elevation page.
        Build ProjectContext that all gates will use.
        """
        # Extract from title page: project name, standard, material
        # Extract from plan pages: grid layout, approximate column count
        # Extract from elevation: floor count, floor heights
        # Returns ProjectContext dataclass
        ...
    
    def gate_post_scan(self, scanner_output: dict) -> GateResult:
        """Gate 1: Is the scan output complete and reasonable?"""
        ...
    
    def gate_post_synthesize(self, model: dict) -> GateResult:
        """Gate 2: Is the structural model architecturally valid?"""
        ...
    
    def gate_post_generate(self, ruby: str, model: dict) -> GateResult:
        """Gate 3: Does the geometry make sense spatially?"""
        ...
```

### 5.2 ProjectContext dataclass

```python
@dataclass
class ProjectContext:
    project_name: str = ""
    standard: str = "AS/NZS"          # AS/NZS, Eurocode, AISC
    material: str = "steel"
    floor_count: int = 0
    floor_heights_mm: List[int] = None  # e.g. [3500, 3500, 3500, 4000, 3000]
    grid_x_count: int = 0              # number of X grid lines
    grid_y_count: int = 0
    grid_spacing_approx_mm: int = 0    # approximate spacing
    expected_col_count: int = 0        # from title/notes
    building_footprint_mm: tuple = (0, 0)  # (width, depth)
    has_basement: bool = False
    has_piles: bool = False
```

### 5.3 Gate Logic (concrete checks)

**Gate 1 — Post-Scan:**
```python
def gate_post_scan(self, scanner_output) -> GateResult:
    page_results = scanner_output.get("page_results", {})
    null_count = sum(1 for p in page_results.values()
                     if not p.get("structural_members"))
    total = len(page_results)
    
    issues = []
    if total > 0 and null_count / total > 0.25:
        issues.append(f"FAIL: {null_count}/{total} pages null — retry with higher DPI")
    
    plan_pages = [p for p in page_results.values() if p.get("page_type") == "PLAN"]
    if not plan_pages:
        issues.append("WARN: No PLAN pages detected — column positions will be missing")
    
    return GateResult(
        status="FAIL" if any("FAIL" in i for i in issues) else "PASS",
        issues=issues
    )
```

**Gate 2 — Post-Synthesize:**
```python
def gate_post_synthesize(self, model) -> GateResult:
    members = model.get("members", {})
    cols = members.get("columns", [])
    
    issues = []
    # Hardware leak check
    hw_count = sum(1 for c in cols if not c.get("_is_structural", True))
    if len(cols) > 0 and hw_count / len(cols) > 0.15:
        issues.append(f"FAIL: {hw_count}/{len(cols)} columns may be hardware")
    
    # Grid coverage check
    no_grid = sum(1 for c in cols if not c.get("grid_x"))
    if len(cols) > 0 and no_grid / len(cols) > 0.3:
        issues.append(f"WARN: {no_grid}/{len(cols)} columns have no grid position")
    
    # Low confidence check
    low_conf = [c for c in cols if c.get("_confidence", 1.0) < 0.5]
    if len(low_conf) > 3:
        issues.append(f"WARN: {len(low_conf)} columns low confidence — review needed")
    
    return GateResult(
        status="FAIL" if any("FAIL" in i for i in issues) else "PASS",
        issues=issues
    )
```

**Gate 3 — Post-Generate (NEW: XY spatial checks):**
```python
def gate_post_generate(self, ruby, model) -> GateResult:
    members = model.get("members", {})
    cols = members.get("columns", [])
    ftgs = members.get("footings", [])
    
    issues = []
    # XY clustering check
    at_origin = sum(1 for c in cols
                    if abs(c.get("x") or 0) < 100 and abs(c.get("y") or 0) < 100)
    if len(cols) > 0 and at_origin / len(cols) > 0.3:
        issues.append(f"FAIL: {at_origin}/{len(cols)} columns clustered at origin")
    
    # Footing distribution check
    ftg_at_origin = sum(1 for f in ftgs
                        if abs(f.get("x") or 0) < 100 and abs(f.get("y") or 0) < 100)
    if ftgs and ftg_at_origin == len(ftgs):
        issues.append(f"FAIL: All {len(ftgs)} footings at (0,0)")
    
    # Footing Z check
    for f in ftgs:
        if (f.get("z_top_mm") or 0) > 0:
            issues.append(f"FAIL: Footing {f.get('id')} Z={f.get('z_top_mm')}mm (above ground)")
            break
    
    return GateResult(
        status="FAIL" if any("FAIL" in i for i in issues) else "PASS",
        issues=issues
    )
```

### 5.4 Pipeline Integration (pipeline_v8.py)

```python
# STAGE 0 — Principal reads PDF once (add BEFORE scanner)
arr = ARRPrincipal(pdf_path=pdf_path, region=self.region)
arr.build_context()
print(f"[ARR Principal] Context: {arr.context.floor_count} floors, "
      f"{arr.context.grid_x_count}x{arr.context.grid_y_count} grid, "
      f"material={arr.context.material}")

# AFTER Stage 2 (scanner):
gate1 = arr.gate_post_scan(scanner_output)
if gate1.status == "FAIL":
    print(f"[ARR Gate 1] FAIL — {gate1.issues}")
    # retry scanner or raise

# AFTER Stage 3 (synthesizer):
gate2 = arr.gate_post_synthesize(model)
if gate2.status == "FAIL":
    print(f"[ARR Gate 2] FAIL — {gate2.issues}")
    # retry synthesizer or raise

# AFTER Stage 7 (generator):
gate3 = arr.gate_post_generate(ruby, model)
if gate3.status == "FAIL":
    print(f"[ARR Gate 3] FAIL — {gate3.issues}")
    # apply corrections or raise
```

**Remove the old Stage 9.5 ARR block** — it is replaced entirely by the 3 gates above.

---

## 6. TIER 2C — Plan Page Extractor → Senior Detailer (New Agent)

**New file:** `agents/plan_page_extractor.py`

This is the single most impactful change for spatial accuracy.
36% column fallback → target <5% after this.

### 6.1 What this agent does

Reads PLAN pages as a senior detailer would — spatially:
1. Identifies structural grid lines (X: 1,2,3,4... Y: A,B,C,D...)
2. Reads scale bar → converts pixel distances to mm
3. Identifies which column mark is at which grid intersection
4. Cross-checks with grid_system in model to validate mm spacings

### 6.2 Implementation

```python
class PlanPageColumnExtractor:
    """
    Senior Detailer: reads plan pages spatially to extract
    column mark → grid position mapping.
    Runs AFTER scanner, BEFORE synthesizer.
    """
    
    SYSTEM_PROMPT = """You are a senior structural detailer with 15 years experience
reading Australian structural drawings (AS/NZS standards).

You are looking at a structural PLAN view drawing.

Your task:
1. Find all structural grid lines:
   - X-axis lines: typically numbered (1, 2, 3...) along the bottom or top
   - Y-axis lines: typically lettered (A, B, C...) along the sides
2. For EACH column mark visible on the plan (e.g. C1, C2, 1C, etc.):
   - Identify exactly which grid intersection it sits on
   - Column marks appear as small circles or squares with a label
3. Read the scale bar (e.g. "1:100") to determine actual spacing
4. Note any column marks that are between grid lines (off-grid)

Return ONLY valid JSON, no markdown:
{
  "column_positions": {"C1": {"grid_x": "1", "grid_y": "A"}, ...},
  "grid_x_lines": ["1", "2", "3", "4"],
  "grid_y_lines": ["A", "B", "C", "D"],
  "grid_x_mm": {"1": 0, "2": 8000, "3": 16000},
  "grid_y_mm": {"A": 0, "B": 8000, "C": 16000},
  "scale_ratio": 100,
  "off_grid_columns": ["C15"],
  "confidence": 0.85,
  "notes": "any ambiguity observed"
}"""

    def extract(self, scanner_output: dict) -> dict:
        """Extract column positions from all PLAN pages."""
        page_results = scanner_output.get("page_results", {})
        all_positions = {}
        grid_x_mm = {}
        grid_y_mm = {}
        
        plan_pages = [(idx, pr) for idx, pr in page_results.items()
                      if pr.get("page_type") == "PLAN"]
        
        for page_idx, _ in plan_pages:
            result = self._extract_page(page_idx)
            if result:
                all_positions.update(result.get("column_positions", {}))
                grid_x_mm.update(result.get("grid_x_mm", {}))
                grid_y_mm.update(result.get("grid_y_mm", {}))
        
        return {
            "column_positions": all_positions,
            "grid_x_mm": grid_x_mm,
            "grid_y_mm": grid_y_mm,
        }
    
    def _extract_page(self, page_idx) -> dict:
        """Vision LLM call on single PLAN page at 300 DPI."""
        img = VisionRenderer(self.pdf_path).render_page(page_idx, dpi=300)
        response = call_llm(
            user_prompt="Extract all column positions from this structural plan.",
            system=self.SYSTEM_PROMPT,
            images=[img]
        )
        return self._parse_json(response)
```

### 6.3 Pipeline Integration (pipeline_v8.py, after Stage 2)

```python
# STAGE 2.5 — Plan Page Extractor (new stage)
print("[V8 STAGE 2.5] PlanPageExtractor: Reading column positions from plan pages...")
from agents.plan_page_extractor import PlanPageColumnExtractor
plan_ext = PlanPageColumnExtractor(pdf_path=pdf_path, dpi=300)
plan_positions = plan_ext.extract(scanner_output)
scanner_output["plan_column_positions"] = plan_positions
col_count = len(plan_positions.get("column_positions", {}))
print(f"  -> {col_count} column positions extracted from plan pages")
```

### 6.4 Synthesizer Integration

In `synthesizer_v7.py`, inside `synthesize()`, add after columns are built:

```python
# Enrich column grid refs from plan page extractor
plan_pos = scanner_output.get("plan_column_positions", {})
col_pos_map = plan_pos.get("column_positions", {})
grid_x_mm_override = plan_pos.get("grid_x_mm", {})
grid_y_mm_override = plan_pos.get("grid_y_mm", {})

enriched = 0
for col in members.get("columns", []):
    cid = col.get("id") or col.get("mark", "")
    if cid in col_pos_map and not col.get("grid_x"):
        col["grid_x"] = col_pos_map[cid]["grid_x"]
        col["grid_y"] = col_pos_map[cid]["grid_y"]
        col["_source_plan"] = True
        enriched += 1
print(f"  [PLAN-ENRICH] {enriched} columns got grid position from plan pages")

# Also update grid_system with mm values from plan extractor if available
if grid_x_mm_override:
    model.setdefault("grid_system", {})["x_coords"] = grid_x_mm_override
if grid_y_mm_override:
    model.setdefault("grid_system", {})["y_coords"] = grid_y_mm_override
```

---

## 7. TIER 2D — Confidence-Aware Accuracy Metric

**File:** `metrics/accuracy_evaluator.py`

Replace count-only recall with dual metric:

```python
def evaluate(self, model, schedule_counts=None):
    # Existing count recall (keep)
    count_score = self._count_recall(model, schedule_counts)
    
    # NEW: Spatial accuracy score
    spatial_score = self._spatial_accuracy(model)
    
    # Final grade requires BOTH
    overall = min(count_score, spatial_score)
    
    return {
        "count_recall": count_score,
        "spatial_accuracy": spatial_score,
        "overall_score": overall,
        "grade": self._grade(overall),
        "target_met": overall >= 90.0
    }

def _spatial_accuracy(self, model) -> float:
    """% of elements within ±500mm of nearest grid intersection."""
    members = model.get("members", {})
    grid = model.get("grid_system", {})
    x_coords = list(grid.get("x_coords", {}).values())
    y_coords = list(grid.get("y_coords", {}).values())
    
    if not x_coords or not y_coords:
        return 50.0  # cannot verify — return neutral score
    
    cols = members.get("columns", [])
    if not cols:
        return 100.0
    
    correct = 0
    for col in cols:
        cx = col.get("x") or 0
        cy = col.get("y") or 0
        nearest_x = min(x_coords, key=lambda v: abs(v - cx))
        nearest_y = min(y_coords, key=lambda v: abs(v - cy))
        if abs(cx - nearest_x) <= 500 and abs(cy - nearest_y) <= 500:
            correct += 1
    
    return round(correct / len(cols) * 100, 1)
```

**ARR trigger update** (pipeline_v8.py line ~284):
```python
# Replace old needs_arr condition:
spatial_score = (result.accuracy or {}).get("spatial_accuracy", 100)
needs_arr = (accuracy_score < ARR_ACCURACY_THRESHOLD) or \
            (spatial_score < 80.0) or \
            bool(z_issues) or bool(xy_issues)
```

---

## 8. TIER 3 — Scanner → Senior Document Analyst (3-4 weeks)

**File:** `agents/scanner_v6.py`

Current scanner reads each page in isolation. Senior document analyst cross-references:

### 8.1 Cross-Page Context

After all pages are scanned, run a cross-reference pass:
```python
def _cross_reference_pass(self, page_results: dict) -> dict:
    """
    After scanning all pages individually, resolve cross-page references.
    E.g.: Schedule says "C1 - see detail 7/A3" → find detail page → extract detail
    """
    # Find all "see detail X/YY" references in schedule pages
    # Match to DETAIL pages by detail number
    # Enrich the column/beam record with detail data
```

### 8.2 Per-Page Confidence

Add confidence to each page scan result:
```python
{
  "page_type": "SCHEDULE",
  "structural_members": {...},
  "_scan_confidence": 0.9,
  "_issues": ["text partially cut off at right margin"],
  "_retry_recommended": False
}
```

Scanner retries automatically if `_scan_confidence < 0.6`.

---

## 9. TIER 4 — LOD350/400 (1-2 months)

### LOD350 — Connection interfaces

**New agent:** `agents/detail_page_extractor.py`

Reads DETAIL pages to extract:
- Base plate dimensions and bolt pattern
- Beam-column moment connection type
- Bracing end connections

```python
class DetailPageExtractor:
    """Reads DETAIL pages to extract connection specifications."""
    
    def extract_connections(self, scanner_output) -> dict:
        detail_pages = [pr for pr in scanner_output["page_results"].values()
                        if pr.get("page_type") == "DETAIL"]
        # Vision LLM: extract connection type, bolt grade, plate size
        # Returns: {detail_id: {connection_type, plate_size_mm, bolt_grade}}
```

Generator uses this to add LOD350 elements (base plates, stiffeners).

### LOD400 — Fabrication ready

- Shop drawing parser (detailed section cuts)
- AS/NZS 4600 compliance checker
- Bolt pattern generator
- Weld size extraction from detail symbols

---

## 10. Execution Order for New Session

**DO IN THIS EXACT ORDER. Do not skip ahead.**

```
PHASE 1 — Tier 1 bugs (verify pipeline visually correct first):
  Step 1:  Read this file
  Step 2:  Read generators/ruby_generator_v5.py lines 657-710
  Step 3:  Read agents/synthesizer_v7.py lines 191-210 and 663-695
  Step 4:  Fix Bug A (generator line 667-674) — footing XY filter
  Step 5:  Fix Bug B (synthesizer line 682) — footing Z guard
  Step 6:  Fix Bug C (synthesizer ~line 205) — _BP suffix
  Step 7:  → USER: run pipeline, share log
  Step 8:  Verify Tier 1 checks pass (section 3 table)

PHASE 2 — Tier 2A: Synthesizer upgrade (no new files):
  Step 9:  Add ASNZS_STRUCTURAL_SECTIONS constant to synthesizer_v7.py
  Step 10: Inject into LLM system prompt in synthesize()
  Step 11: Add confidence scoring to synthesizer output
  Step 12: Add _validate_building_logic() method

PHASE 3 — Tier 2B: ARR as Principal:
  Step 13: Read agents/architect_reviewer.py fully
  Step 14: Read pipelines/pipeline_v8.py lines 265-335
  Step 15: Add ProjectContext dataclass + GateResult dataclass
  Step 16: Implement build_context(), gate_post_scan(),
           gate_post_synthesize(), gate_post_generate()
  Step 17: Add _verify_xy_positions() (replaces _verify_3d_positions upgrade)
  Step 18: Integrate 3 gates into pipeline_v8.py (Stage 0 + post-2 + post-3 + post-7)
  Step 19: Remove old Stage 9.5 ARR block
  Step 20: → USER: run pipeline, verify gates fire in logs

PHASE 4 — Tier 2C: Plan Page Extractor (new agent):
  Step 21: Create agents/plan_page_extractor.py
  Step 22: Add Stage 2.5 to pipeline_v8.py
  Step 23: Add enrichment block to synthesizer_v7.py synthesize()
  Step 24: → USER: run pipeline, verify "[PLAN-ENRICH] N columns"
  Step 25: Verify fallback drops from 36% → <10%

PHASE 5 — Tier 2D: Spatial accuracy metric:
  Step 26: Read metrics/accuracy_evaluator.py
  Step 27: Add _spatial_accuracy() method
  Step 28: Update evaluate() to return dual metric
  Step 29: Update ARR trigger in pipeline_v8.py
  Step 30: → USER: run pipeline, verify spatial_score in log
```

---

## 11. File Index

| File | Role | Key sections |
|------|------|-------------|
| `pipelines/pipeline_v8.py` | Orchestrator | `run()` line ~100, ARR trigger line 284, Stage gates |
| `agents/synthesizer_v7.py` | Structural Engineer | `_is_structural_col()` line 191, `synthesize()`, `_assign_z_to_all_members()` line 640+ |
| `agents/architect_reviewer.py` | ARR Principal | `review()`, `_verify_3d_positions()` line 300 — **major rewrite** |
| `agents/plan_page_extractor.py` | Detailer | **NEW FILE** |
| `generators/ruby_generator_v5.py` | BIM Tech | `_footing_ruby_v5()` line 657 |
| `agents/scanner_v6.py` | Document Analyst | Page routing + scan loop |
| `metrics/accuracy_evaluator.py` | QC metric | `evaluate()` — add spatial score |
| `output/v8/Structural_model.json` | Ground truth | For debugging |
| `logs2.txt` | Latest run | Reference for current bugs |

---

## 12. Architecture Decisions (Do Not Change Without Discussion)

1. **Column XY resolution in GENERATOR, not synthesizer.** Synthesizer has `grid_x`/`grid_y` strings only. Generator's `_resolve_grid_xy()` converts to mm. Footing XY fallback must use `col_map` in generator.

2. **Confidence scores are advisory, not blocking (Phase 2).** Low confidence elements get logged and flagged but don't fail the pipeline until spatial metric is ready (Phase 5).

3. **ARR gates can WARN but FAIL only on hard errors.** A gate that fails too aggressively causes infinite retry loops. FAIL threshold should be high (e.g. >30% at origin), WARN for softer issues.

4. **Plan Page Extractor result enriches scanner_output** (not synthesizer output directly) so it can be cached alongside the scan. If PDF hasn't changed, plan positions don't need re-extraction.

5. **Spatial accuracy metric replaces count-recall as the primary grade,** but count-recall is still reported separately. A model with 100% count + 40% spatial = Grade D. Both must be ≥90% for Grade A.

6. **Do not change LLM caching mechanism** until Tier 3. Current hash-based cache is fragile but changing it mid-Tier-2 would invalidate all existing cached runs.
