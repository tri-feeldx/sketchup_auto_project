============================================================
HANDOFF NOTE — 2026-05-21 END OF DAY
For: Home Claude instance
From: Office Claude (Sonnet 4.6)
Repo: D:\FeelDX_Workspace\sketchup_auto_project_clone
Branch: main — pushed to remote at commit 62040d5
============================================================


============================================================
PERSONA — WHO YOU ARE
============================================================

You are the PRINCIPAL AI ENGINEER + SENIOR BIM ARCHITECT on this project.

Your expertise (non-negotiable, internalize this):
  - Structural BIM: LOD100→400, AS/NZS standards, IFC2x3/4
  - PDF structural drawings: schedules, plans, details, elevations, sections
  - Python AI pipelines: LLM orchestration, vision models, JSON extraction
  - SketchUp Ruby API: push-pull geometry, groups, layers, model attributes
  - Building physics: floor-to-floor heights, pile types, connection types
  - Vietnamese/Australian structural notation (TCVN + AS/NZS)

You approach every code change like a senior professional:
  - Always understand WHY before touching code
  - Domain knowledge drives decisions, not just syntactic pattern matching
  - Every output has a confidence score — you know when you don't know
  - You catch architectural mistakes before they compound


============================================================
WHAT THIS PROJECT DOES
============================================================

PDF structural drawing → LOD300/350 SketchUp 3D model (automatic)

Stack:
  - Python pipeline (V8) → Vertex AI Gemini 2.5 Flash (paid tier)
  - Vision LLM reads each page at 200-300 DPI
  - Ruby script output → load in SketchUp to get 3D model
  - Region support: AU (AS/NZS) + VN (TCVN)

Working dir: D:\FeelDX_Workspace\sketchup_auto_project_clone
Run command: python pipelines/pipeline_v8.py Structural.pdf

Expected output files:
  output/v8/Structural_structural.rb   → load in SketchUp
  output/v8/Structural_model.json      → inspect member positions
  output/v8/Structural_summary.json    → count/accuracy summary


============================================================
FULL TIER HISTORY — WHAT WAS DONE TODAY
============================================================

TIER 1 — Bug fixes (11 bugs, all DONE):
  Bug A — Footing XY all at (0,0) → x-group cycling fix        ✅
  Bug B — Footing Z above ground → forced to -1000mm min        ✅
  Bug C — _BP baseplates as columns → suffix filter              ✅
  Bug D — Scanner crash list.get → isinstance guard             ✅
  Bug E — Ruby invalid variable name → re.sub sanitizer         ✅
  Bug F — Sequential scan → ThreadPoolExecutor (6 workers)      ✅
  Bug G/H — Column Z=0 → read start_level/end_level/coords     ✅
  Bug I  — Footings on single X line → x-group cycling          ✅
  Bug J  — 22 WS* phantom columns → mark regex + depth<50mm    ✅
  Bug K  — Rate limiter too strict → 0.2s gap                   ✅
  MultiPass Z — re-apply _assign_z after MultiPass              ✅

TIER 2A — Synthesizer domain knowledge (DONE):
  - AS/NZS section library injected into synthesizer prompt
  - _confidence field (0.4/0.7/1.0) on all members
  - _validate_building_logic() checks column height/section

TIER 2B — ARRPrincipal gate checks (DONE):
  - ARRPrincipal class in agents/architect_reviewer.py
  - gate_post_scan(): null page ratio, missing PLAN/SCHEDULE pages
  - gate_post_synthesize(): hardware leak %, low confidence count
  - gate_post_generate(): XY origin clustering, footing Z check
  - 3 gate blocks in pipeline_v8.py (non-blocking warnings)

TIER 2C — PlanPageColumnExtractor (DONE + HARDENED):
  - agents/plan_page_extractor.py — reads PLAN pages at 300 DPI
  - Column mark → grid XY position via vision LLM
  - 4-pass robust JSON parser + _unwrap() for nested format
  - Stage 2.5 in pipeline, enriches synthesizer columns
  - test_plan_extractor.py for isolated testing (--debug flag)

TIER 2D — Spatial accuracy metric (DONE):
  - spatial_accuracy metric in metrics/accuracy_evaluator.py
  - % of columns with _confidence >= 0.7
  - Grade A requires count_recall >= 90% AND spatial >= 75%

TIER 3 — Scanner as Senior Document Analyst (DONE TODAY):
  File: agents/scanner_v6.py
  - _parse_json() now returns (data, strategy_idx) tuple (0-5 or 99)
  - _compute_scan_confidence(): scores each page 0.0-1.0
    Based on: parse quality, member count, route_confidence
    Adds _scan_confidence, _issues, _retry_recommended to every page
  - Auto-retry: if _scan_confidence < 0.6 → retry at dpi+50
    Keeps whichever result has higher confidence
  - _cross_reference_pass(): finds "see detail X/YY" patterns in
    SCHEDULE/PLAN _raw_text → enriches null-section members from
    already-scanned DETAIL pages (ZERO extra LLM calls)
  - _raw_text field added to every page result (first 2000 chars)

TIER 4 — LOD350 (DONE TODAY):
  New files:
    agents/detail_page_extractor.py  — reads DETAIL pages 200 DPI
      → base plate dims, bolt pattern, end plate specs
      → used by generator for REAL plate geometry (not estimates)
    agents/coversheet_parser.py  — reads TITLE page title block
      → project name, revision, standard, floor count, material
      → injected as SketchUp model.set_attribute

  Modified files:
    pipelines/prompt_factory.py  — 3 new methods:
      system_prompt_detail_extractor()
      user_prompt_detail_extract(page_idx)
      system_prompt_coversheet_parser()

    agents/synthesizer_v7.py  — _deterministic_merge() now collects:
      stairs[] and shafts[] from page_results

    generators/ruby_generator_v5.py:
      - _stair_ruby_v5(): stair flight as ramp on S_STAIR layer
      - _shaft_ruby_v5(): lift/stair shaft box on S_SHAFT layer
      - _lod350_col_plates(): uses REAL base plate dims from detail_specs
      - Layer names → LOD350 standard (S_COLUMN, S_BEAM, S_SLAB,
        S_WALL, S_FOOTING, S_STAIR, S_SHAFT, S_BASEPLATE)
      - model.set_attribute for project name/revision/standard

    pipelines/pipeline_v8.py:
      - Stage 0.5: CoversheetParser (before scanner output consumed)
      - Stage 2.6: DetailPageExtractor (after PlanPageExtractor)
      - model['detail_specs'] + model['project'] injected before Stage 7


============================================================
CURRENT PIPELINE FLOW (V8 — FULL)
============================================================

  Stage 0:    ARRPrincipal.build_context()
  Stage 0-2:  ScannerV6 (6 parallel workers, auto-retry low confidence)
  Gate:       ARRPrincipal.gate_post_scan()
  Stage 0.5:  CoversheetParser → project metadata     [NEW Tier 4]
  Stage 2.5:  PlanPageColumnExtractor → column XY     [Tier 2C]
  Stage 2.6:  DetailPageExtractor → connection specs  [NEW Tier 4]
  Stage 3:    SynthesizerV7 → unified model (domain + confidence)
  Gate:       ARRPrincipal.gate_post_synthesize()
  Stage 4:    ScheduleVerifier → cross-check counts
  Stage 5:    MultiPassExtractor → re-scan if missing
  Stage 6:    ValidatorV7 → geometry check
  Stage 7:    RubyGeneratorV5 → LOD350 .rb file
  Gate:       ARRPrincipal.gate_post_generate()
  Stage 8:    RubyValidator → syntax check
  Stage 9:    AccuracyEvaluator → count recall + spatial score
  Stage 9.5:  ARR LLM review loop (if accuracy < 95%)
  Stage 10:   Save outputs


============================================================
WHAT STILL NEEDS TO BE DONE
============================================================

IMMEDIATE — Run and test:
  1. python pipelines/pipeline_v8.py Structural.pdf

  Watch for new log lines (Tier 3 + 4):
    [V8 STAGE 0.5] CoversheetParser: Reading project title block...
    [V8 STAGE 2.6] DetailPageExtractor: Reading connection details...
    [SCANNER] Page N: conf=0.45 — retrying +50 DPI   ← Tier 3 auto-retry
    [CROSS-REF] N references found, M members enriched  ← Tier 3 cross-ref
    [DETAIL-EXT] Page N: M connection details          ← Tier 4
    [GEN] LOD350: Nc Nb Ns Nw Nf Nst Nsh — N total elements

  Open output/v8/Structural_structural.rb in SketchUp:
    - Layers panel: S_COLUMN, S_BEAM, S_SLAB, S_WALL, S_FOOTING,
                    S_STAIR, S_SHAFT, S_BASEPLATE
    - Base plates under each column (real dims if DETAIL pages found)
    - Model attributes: project name, revision, standard

  Check accuracy:
    - Count recall ≥ 90%? (was 100% before)
    - Spatial score ≥ 75%? (was ~35% before Tier 2C)

NEXT SESSIONS:

  Tier 5 — Accuracy Verification & True Spatial Metric:
    Currently spatial score = % of columns with _confidence >= 0.7 (proxy)
    True metric = distance from column XY to nearest grid intersection (mm)
    Implement _spatial_accuracy_mm() in metrics/accuracy_evaluator.py
    Threshold: columns within ±200mm of grid → PASS

  Tier 6 — IFC Export Improvement:
    Currently IFCGenerator exists but basic
    Add LOD350 attributes to IFC properties:
      IfcColumn → Pset_ColumnCommon, IfcStructuralSurface
      IfcBeam → connection type from detail_specs
      IfcSlab → span direction, fire rating
    File: generators/ifc_generator.py

  Tier 7 — LOD400 Fabrication:
    Shop drawing parser (exact bolt patterns from detail drawings)
    AS/NZS 4600 compliance checker
    Weld size extraction from symbol library
    New file: agents/fabrication_extractor.py

  Multi-PDF Support:
    Currently assumes single PDF with all pages
    Real projects often split: architecture + structure + services
    Cross-reference between PDFs for complete model


============================================================
KEY NUMBERS — BEFORE TODAY'S SESSION
============================================================

  Pipeline runtime:  ~350s (~6 min)
  Count recall:      100% — 44/44 columns, 12/12 beams, 6/6 footings
  Spatial score:     ~35% (before Tier 2C — expected to rise)
  LOD:               300 (now upgraded to 350 with Tier 4)
  SketchUp:          3D model loads, shows structural frame


============================================================
ARCHITECTURE DECISIONS — DO NOT CHANGE WITHOUT DISCUSSION
============================================================

1. Column XY resolution in GENERATOR, not synthesizer.
   Synthesizer stores grid_x/grid_y labels. Generator's grid_to_mm_x()
   converts to mm. Footing XY fallback also in generator.

2. Confidence scores advisory only (not blocking).
   Low confidence → logged + flagged but pipeline continues.
   Gate failures are WARN only, never abort pipeline.

3. Per-thread VisionRenderer in parallel scanner.
   Each of 6 workers opens its own renderer. NEVER share renderer across threads.

4. LLM cache: .cache/ directory, SHA256-keyed per (prompt+image).
   Survives between runs — do NOT delete unless stale.
   Rate limit: 0.2s gap between calls.

5. _raw_text on every page result (first 2000 chars).
   Used by _cross_reference_pass() for pattern matching.
   Required for Tier 3 cross-ref — do not remove.

6. detail_specs stored in model dict (model['detail_specs']).
   Passed from pipeline → generator. Pattern matches plan_positions.
   Generator reads it in _lod350_col_plates().

7. stairs/shafts follow same pattern as walls/slabs:
   Scanner extracts → synthesizer collects → generator outputs.
   No special handling needed — additive.


============================================================
COMMIT HISTORY (TODAY)
============================================================

  62040d5 — feat: Tier 4 — LOD350 detail extractor, coversheet, stairs/shafts
  082a4d3 — feat: Tier 3 — Scanner confidence + auto-retry + cross-page refs
  5409884 — feat: Tier 2C hardened — robust _parse() + debug flag + test script
  d565047 — feat: Tier 2B — ARRPrincipal gate checks
  6452152 — feat: V9 Tier 1 complete + Tier 2A/2C/2D coded, 3.9x speedup
  ebaa013 — docs: PLAN.md v2 — expert team architecture + LOD300/350/400 roadmap


============================================================
QUICK COMMAND REFERENCE
============================================================

  Run full pipeline:
    cd D:\FeelDX_Workspace\sketchup_auto_project_clone
    python pipelines/pipeline_v8.py Structural.pdf

  Test Tier 2C (plan extractor) standalone:
    python test_plan_extractor.py
    python test_plan_extractor.py --debug   # see raw LLM response

  Check scan confidence distribution:
    python -c "
    import json
    data = json.load(open('output/v8/Structural_scanner_output.json'))
    for k,v in data['page_results'].items():
      if isinstance(v,dict) and not v.get('skipped'):
        print(k, v.get('_scan_confidence'), v.get('_issues'))
    "

  Check detail specs extracted:
    python -c "
    import json
    m = json.load(open('output/v8/Structural_model.json'))
    print(json.dumps(m.get('detail_specs',{}), indent=2))
    "

  Git status:
    git log --oneline -8

============================================================
END OF HANDOFF — 2026-05-21 EOD
============================================================
