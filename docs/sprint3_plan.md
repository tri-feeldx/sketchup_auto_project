# Plan: Sprint 3 — Fix Z-Axis, Bracing Generation, and Per-Column Footings

## Context

Latest run (post Round-3 + Sprint 1/2 fixes) shows 3 new failures at 75.8% (Grade B):
- **level_real=0%**: 4-floor model uses hardcoded default template (0/3500/6700/9900mm) — scanner
  stores elevation data under `building_levels` key but synthesizer only reads `level_elevations`
- **44 bracing = 0 in SketchUp**: Bracing has no from_col/to_col AND RubyGeneratorV5 has zero
  bracing generation code — they exist in JSON but are never converted to geometry
- **1 footing for 37 columns**: Building uses pile foundations (P1-P5 + raft RF1); scanner only
  extracted 1 raft; no logic generates per-column footings from pile schedule data

---

## Bug 1: Z-Axis — `building_levels` Key Mismatch

### Diagnosis

Scanner page 14 (ELEVATION) stores data as:
```json
"building_levels": [
  {"level_name": "LEVEL 01", "ffl_mm": 0,    "rl_mm": null},
  {"level_name": "LEVEL 02", "ffl_mm": 3000, "rl_mm": null},
  {"level_name": "LEVEL 03", "ffl_mm": 6000, "rl_mm": null}
]
```

Synthesizer `_extract_levels` (line ~611) reads `pr.get("level_elevations", [])` — never finds the
data. GTB similarly failed all 4 extraction passes for page 14.

`level_real` is computed in RubyGeneratorV5 (line 79):
```python
sum(1 for l in levels if not str(l.get("id","")).startswith(("GROUND","LEVEL_","ROOF","Z")))
```
Current level IDs: "GROUND", "LEVEL_1", "LEVEL_2", "ROOF" → all filtered → 0% real.
"LEVEL 01" (space not underscore) → NOT caught by filter → counts as real.

### Fix 1a — Synthesizer `_extract_levels` (Priority 1 branch)

**File**: `agents/synthesizer_v7.py` — `_extract_levels` method, lines ~608-626

Add `building_levels` as an alias for `level_elevations` in the first priority read:
```python
# BEFORE:
for pr in page_results:
    for le in pr.get("level_elevations", []):

# AFTER:
for pr in page_results:
    raw_levels = pr.get("level_elevations") or pr.get("building_levels") or []
    for le in raw_levels:
        if not isinstance(le, dict): continue
        lvl_id = le.get("id") or le.get("label") or le.get("level_name", "")
        if lvl_id and lvl_id not in seen_ids:
            rl = le.get("rl_mm") or le.get("ffl_mm") or le.get("ssl_mm") or 0
            levels.append({
                "id": lvl_id,
                "name": le.get("label") or le.get("level_name", lvl_id),
                "height_from_datum_mm": int(rl),
                "elevation_mm": int(rl),
                "floor_to_floor_mm": le.get("floor_to_floor_mm"),
                "confidence": 0.8,
            })
            seen_ids.add(lvl_id)
```

### Fix 1b — GTB Also Reads `building_levels`

**File**: `agents/ground_truth_builder.py`

In `_extract_elevations` or wherever GTB reads the elevation page_result for floor heights:
also check `page_result.get("building_levels")` alongside existing keys.
Map `ffl_mm` → elevation, `level_name` → level id.

### Expected Impact

- `level_real`: 0% → ~75% (3 out of 4 levels get real IDs)
- Floor elevations: default 0/3500/6700/9900 → 0/3000/6000 + inferred roof ~7000mm
- SketchUp: all 4 floors will have distinct Z positions based on real drawing data

---

## Bug 2: Bracing — No Connectivity + No Ruby Generation

### Diagnosis

All 44 bracing members: `from_col=null, to_col=null, x_mm=null, y_mm=null, z_mm=null`.
RubyGeneratorV5 `_deterministic_script` has sections for cols/beams/slabs/walls/footings/stairs/shafts
but **zero bracing code** (no loop, no method, no layer). They exist in JSON but are never generated.

Log: `[GEN] LOD350: 37c 47b 6s 0w 1f 0st 0sh — 91 total elements` (bracing absent from count)

### Fix 2a — Bracing Connectivity in Synthesizer

**File**: `agents/synthesizer_v7.py` — add new method after `_assign_beam_connectivity_from_grid` (line ~1587)

```python
def _assign_bracing_connectivity_from_grid(self, model: dict) -> dict:
    """Assign from_col/to_col to unconnected bracing using diagonal column pairs."""
    from collections import defaultdict
    bracing = model.get("members", {}).get("bracing", [])
    cols    = model.get("members", {}).get("columns", [])
    if not bracing or not cols:
        return model

    col_xy: dict = {}
    for c in cols:
        x = int(c.get("x_mm") or c.get("x") or 0)
        y = int(c.get("y_mm") or c.get("y") or 0)
        cid = c.get("id") or c.get("mark") or ""
        if cid and (x or y):
            col_xy[(x, y)] = cid

    xs = sorted(set(k[0] for k in col_xy))
    ys = sorted(set(k[1] for k in col_xy))

    # Diagonal pairs (across bays) — suitable for K/X bracing
    diag_pairs: list = []
    for yi in range(len(ys) - 1):
        for xi in range(len(xs) - 1):
            c1 = col_xy.get((xs[xi],     ys[yi]))
            c2 = col_xy.get((xs[xi + 1], ys[yi + 1]))
            if c1 and c2:
                diag_pairs.append((c1, c2))
            c3 = col_xy.get((xs[xi + 1], ys[yi]))
            c4 = col_xy.get((xs[xi],     ys[yi + 1]))
            if c3 and c4:
                diag_pairs.append((c3, c4))

    # Also include straight pairs (floor bracing runs parallel to beams)
    for y in ys:
        for i in range(len(xs) - 1):
            c1 = col_xy.get((xs[i], y))
            c2 = col_xy.get((xs[i + 1], y))
            if c1 and c2:
                diag_pairs.append((c1, c2))

    if not diag_pairs:
        return model

    unconnected = [br for br in bracing
                   if not br.get("from_col") and not br.get("to_col")]
    by_z: dict = defaultdict(list)
    for br in unconnected:
        by_z[int(br.get("z_mm") or 0)].append(br)

    assigned = 0
    for z_brs in by_z.values():
        for i, br in enumerate(z_brs):
            pair = diag_pairs[i % len(diag_pairs)]
            br["from_col"] = pair[0]
            br["to_col"]   = pair[1]
            br["_connectivity_source"] = "grid_synthetic"
            assigned += 1

    if assigned:
        print(f"  [BRACE-CONNECT] Synthetic grid assignment: {assigned} bracing -> column pairs")
    return model
```

**Where to call**: Add `model = self._assign_bracing_connectivity_from_grid(model)` in:
- `synthesize()` LLM path (after `_assign_beam_connectivity_from_grid` at line ~116)
- `synthesize()` deterministic path (after `_assign_beam_connectivity_from_grid` at line ~139)
- `post_process_after_multipass()` (after `_assign_beam_connectivity_from_grid` at line ~162)

### Fix 2b — Bracing Ruby Generation

**File**: `generators/ruby_generator_v5.py`

**Step 1** — Add bracing layer (layers dict, line ~163):
```python
"  'bracing'=> model.layers.add('S_BRACING'),",
```

**Step 2** — Extract bracing (alongside cols/beams, line ~213):
```python
bracing = members.get("bracing", [])
```

**Step 3** — Add bracing generation loop (after slabs block, line ~283):
```python
if bracing:
    lines.append("# === Bracing ===")
    for i, br in enumerate(bracing):
        lines.extend(self._bracing_ruby_v5(br, col_positions, i, mat_vars))
    lines.append("")
```

**Step 4** — New `_bracing_ruby_v5` method:
```python
def _bracing_ruby_v5(self, br: dict, col_positions: dict, idx: int,
                      mat_vars: dict) -> list:
    from_id = br.get("from_col") or br.get("from")
    to_id   = br.get("to_col")   or br.get("to")
    if not from_id or not to_id:
        return []
    p1 = col_positions.get(from_id)
    p2 = col_positions.get(to_id)
    if not p1 or not p2:
        return []

    MM_TO_INCH = 1.0 / 25.4
    x1 = round(p1["x"]      * MM_TO_INCH, 4)
    y1 = round(p1["y"]      * MM_TO_INCH, 4)
    x2 = round(p2["x"]      * MM_TO_INCH, 4)
    y2 = round(p2["y"]      * MM_TO_INCH, 4)
    z1 = round(p1["z_base"] * MM_TO_INCH, 4)
    z2 = round(p2["z_top"]  * MM_TO_INCH, 4)

    mat     = self._get_mat(br, mat_vars)
    br_id   = br.get("id") or br.get("mark") or f"BR{idx}"
    section = br.get("section") or "CHS"

    return [
        f"# Bracing {br_id} ({section}): {from_id}->{to_id}",
        f"br_pt1_{idx} = Geom::Point3d.new({x1}.inch, {y1}.inch, {z1}.inch)",
        f"br_pt2_{idx} = Geom::Point3d.new({x2}.inch, {y2}.inch, {z2}.inch)",
        f"br_e_{idx} = ents.add_line(br_pt1_{idx}, br_pt2_{idx})",
        f"br_e_{idx}.layer = layers['bracing']",
    ]
```

**Step 5** — Update LOD350 count (lines ~319-330) to include bracing in count and print.

### Expected Impact

- 44 bracing members with synthetic connectivity → 44 diagonal lines in SketchUp
- `[BRACE-CONNECT] Synthetic grid assignment: 44 bracing -> column pairs`
- SketchUp shows X/K bracing diagonals in the bays

---

## Bug 3: Footings — Per-Column Pile Caps

### Diagnosis

Building uses pile foundations. Page 28 extracted:
- 1 raft: `RF1` (5600x6500x1000mm)
- 5 pile types: `P1-P5` (bored piles, 600-750mm diameter, varying depths/capacity)
- 1 capping beam: `CB1` (750x600mm)

Current pipeline: synthesizer takes whatever footings the scanner found (1) and passes them
through. No logic to generate per-column footings. RubyGenerator places only the 1 raft.

### Fix 3a — Synthesizer: `_generate_footings_from_columns`

**File**: `agents/synthesizer_v7.py` — new method

```python
def _generate_footings_from_columns(self, model: dict,
                                      page_results: list) -> dict:
    """
    If footing count < column count, generate one pile-cap footing per column.
    Uses pile type data from foundation schedule pages; falls back to 1200x1200 pad.
    """
    cols  = model.get("members", {}).get("columns", [])
    foots = model.get("members", {}).get("footings", [])
    if not cols or len(foots) >= len(cols):
        return model

    pile_types: list = []
    for pr in (page_results or []):
        if isinstance(pr, dict):
            pile_types.extend(pr.get("piles") or [])

    if pile_types:
        diameters = [int(p.get("diameter_mm") or 0) for p in pile_types if p.get("diameter_mm")]
        dia = max(diameters) if diameters else 750
        cap_w = dia * 2
        cap_d = dia * 2
    else:
        cap_w, cap_d = 1200, 1200

    existing_col_ids = {f.get("column") or f.get("col_id") for f in foots}

    new_foots = []
    for col in cols:
        cid = col.get("id") or col.get("mark")
        if cid in existing_col_ids:
            continue
        x  = int(col.get("x_mm") or col.get("x") or 0)
        y  = int(col.get("y_mm") or col.get("y") or 0)
        zb = int(col.get("z_base_mm") or col.get("z_base") or 0)
        new_foots.append({
            "id":        f"PC_{cid}",
            "type":      "pile_cap",
            "column":    cid,
            "width_mm":  cap_w,
            "depth_mm":  cap_d,
            "height_mm": 600,
            "x_mm":      x,
            "y_mm":      y,
            "z_top_mm":  zb,
            "z_base_mm": zb - 600,
            "_confidence": 0.7,
            "_source":   "synthetic_pile_cap",
        })

    if new_foots:
        model["members"]["footings"] = foots + new_foots
        print(f"  [FOOTING-GEN] Generated {len(new_foots)} pile caps "
              f"({cap_w}x{cap_d}mm) for {len(cols)} columns")
    return model
```

**Where to call**: After `_dedup_beams` in both synthesize() paths and `post_process_after_multipass`:
- LLM path: line ~118, before `_ensure_walls`
- Deterministic path: line ~141, before `_ensure_walls`
- `post_process_after_multipass`: line ~165

The method needs `page_results` as input — pass `valid_results` (already available in context).

### Fix 3b — RubyGenerator Footing Placement (Verify, No Change Expected)

**File**: `generators/ruby_generator_v5.py` — `_footing_ruby_v5` method

The existing method tries `col_positions.get(linked_col_id)` for snapping. With Fix 3a,
new footings have `"column": cid` AND explicit `x_mm`/`y_mm`. Verify the method reads
`f.get("x_mm")` as a direct placement override when column snap fails. If it doesn't,
add this fallback: use `f.get("x_mm")` / `f.get("y_mm")` directly.

---

## Files to Modify

| File | Location | Change |
|------|----------|--------|
| `agents/synthesizer_v7.py` | `_extract_levels` ~L611 | Add `building_levels` key fallback |
| `agents/ground_truth_builder.py` | elevation extraction section | Also read `building_levels` |
| `agents/synthesizer_v7.py` | New method after L1587 | `_assign_bracing_connectivity_from_grid` |
| `agents/synthesizer_v7.py` | LLM path ~L116 | Call bracing connectivity after beam connectivity |
| `agents/synthesizer_v7.py` | Det path ~L139 | Call bracing connectivity after beam connectivity |
| `agents/synthesizer_v7.py` | `post_process_after_multipass` ~L162 | Call bracing connectivity |
| `agents/synthesizer_v7.py` | New method + call ~L118/141/165 | `_generate_footings_from_columns` |
| `generators/ruby_generator_v5.py` | Layers dict ~L163 | Add `'bracing'` layer |
| `generators/ruby_generator_v5.py` | Members extract ~L213 | Add `bracing` variable |
| `generators/ruby_generator_v5.py` | After slabs ~L283 | Add bracing generation loop |
| `generators/ruby_generator_v5.py` | New method | `_bracing_ruby_v5` |
| `generators/ruby_generator_v5.py` | LOD350 count ~L319-330 | Include bracing count |

---

## Expected Score After Sprint 3

| Metric | Before | After |
|--------|--------|-------|
| level_real | 0% | ~75% (3/4 levels real) |
| floor Z spacing | 0/3500/6700/9900 (default) | 0/3000/6000/~7000 (real data) |
| bracing in SketchUp | 0 | 44 |
| footings | 1 (raft only) | 37+ (1 per column + raft) |
| col_section | 43-45% | 43-45% (unchanged) |
| beam_section | 74% | 74% (unchanged) |
| beam recall | 60% | 60% (unchanged) |
| Overall score | 75.8% | ~80-82% |

---

## Verification

Log signals to look for after the run:

| Signal | Confirms |
|--------|---------|
| `[Z-DEBUG] level_elevations: [{'level_name': 'LEVEL 01'...}]` | Fix 1a: building_levels found |
| `[Z] Level map resolved: 4 levels (0mm-6000mm+)` | Real levels used |
| `[QUALITY] level_real=75%` in RubyGen | Level IDs count as real |
| `[BRACE-CONNECT] Synthetic grid assignment: 44 bracing` | Fix 2a: bracing connectivity |
| `[GEN] LOD350: 37c 47b 6s 0w 37f 44br` | Fix 2b + 3a working |
| `[FOOTING-GEN] Generated 37 pile caps` | Fix 3a: per-column footings created |
