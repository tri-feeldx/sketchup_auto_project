"""
=============================================================================
A2: PROMPT FACTORY V7 — Prompt Engineering Hub
=============================================================================
Centralized prompt generation for ALL agents.
No hardcoded prompts in agent code — everything comes from here.
Supports:
  - Region-aware templates (VN / AU / INTL)
  - Material-specific system prompts (steel / concrete / wood / composite)
  - Per-page and full-PDF analysis templates
  - Multi-shot examples per region
  - Budget-aware prompt trunction
  - Scheduling extraction prompts
  - Ruby generation prompts (B1)
  - Ruby validation prompts (B2)
=============================================================================
"""

import json
from pathlib import Path
from typing import Dict, List, Optional, Tuple

# ============================================================
# PROMPT FACTORY V7
# ============================================================

class PromptFactory:
    """Centralized prompt builder — V7 UPGRADED."""

    def __init__(self, region: str = "vn", language: str = "vn"):
        self.region = region.lower()
        self.language = language.lower()
        # Max chars per prompt before truncation
        self.max_chars = 12000

    # ── SYSTEM PROMPT: GLOBAL STRUCTURAL ANALYZER ──────────
    def system_prompt_scanner(self, page_type: str = "general") -> str:
        """
        System prompt for scanner agent.
        page_type: plan / elevation / section / schedule / general
        """
        base = (
            "You are a Senior Structural Engineer with 20+ years experience. "
            "You analyze construction drawings and extract structured technical data. "
            "Respond ONLY with JSON. No explanations, no markdown formatting.\n\n"
            "IMPORTANT RULES:\n"
            "- All dimensions in millimeters (mm)\n"
            "- Coordinates: (x, y) origin at bottom-left of drawing\n"
            "- Grid coordinates: use actual grid labels from drawing (e.g., '1', 'A')\n"
            "- Steel grades: use standard notation (e.g., 'C350L0', 'G450')\n"
            "- Concrete grades: use standard notation (e.g., 'M40', 'N32')\n"
            "- Spans: measure center-to-center of supports\n"
            "- Member heights: measure from floor level (F.F.L) to underside\n\n"
        )

        page_hints = {
            "plan": (
                "FOCUS: This page is a FLOOR PLAN. Extract ALL of the following:\n"
                "- Column positions with grid coordinates (EVERY column — do not skip any)\n"
                "- ALL beams: primary beams, secondary beams, transfer beams, tie beams\n"
                "- ALL beam-to-beam connections (secondary beams framing into primary beams)\n"
                "- Slab boundaries and thickness for each bay\n"
                "- Wall locations (external & internal)\n"
                "- Grid lines with labels\n"
                "- Opening locations (doors, windows)\n"
                "- Overall plan dimensions\n"
                "CRITICAL: Do NOT skip secondary beams or short beams. "
                "List EVERY beam visible on the plan.\n"
            ),
            "elevation": (
                "FOCUS: This page is an ELEVATION VIEW. Extract ALL of the following:\n"
                "- Building height and levels (RL, FFL, SSL values)\n"
                "- Column heights and base connections\n"
                "- ALL bracing members: X-bracing, K-bracing, flat bar braces, "
                "knee braces, wind braces, diagonal members\n"
                "- Roof profile and ridge height\n"
                "- Wall cladding zones\n"
                "- ALL girt and purlin positions and spacings\n"
                "- Level notations (RL, FFL, SSL)\n"
                "CRITICAL: Extract EVERY diagonal and brace member visible. "
                "Return bracing as a list even if only one.\n"
            ),
            "section": (
                "FOCUS: This page is a SECTION VIEW. Extract:\n"
                "- Foundation depth and type\n"
                "- Column/beam connection details\n"
                "- Slab thickness and reinforcement zones\n"
                "- Roof structure (rafters, purlins)\n"
                "- Floor-to-floor heights\n"
                "- Structural member sizes\n"
                "- Level markings\n"
            ),
            "foundation": (
                "FOCUS: This page shows FOUNDATION / PILE LAYOUT information. "
                "Extract ALL of the following:\n\n"
                "REQUIRED OUTPUT FORMAT:\n"
                '{\n'
                '  "footings": [\n'
                '    {"id":"P1","type":"bored_pile","grid":"A-1","x_mm":1000,"y_mm":1000,\n'
                '     "diameter_mm":600,"depth_mm":15000,"cap_type":"PC1",\n'
                '     "cap_width_mm":1200,"cap_length_mm":1200,"cap_depth_mm":600,\n'
                '     "pile_capacity_kN":800,"material":"reinforced_concrete"}\n'
                "  ],\n"
                '  "pile_caps": [\n'
                '    {"id":"PC1","type":"single","width_mm":1200,"length_mm":1200,"depth_mm":600}\n'
                "  ],\n"
                '  "pile_schedule": [\n'
                '    {"pile_id":"P1","grid_ref":"A-1","pile_type":"BC1","dia_mm":600,"depth_m":15}\n'
                "  ]\n"
                "}\n\n"
                "CRITICAL RULES:\n"
                "- Extract EVERY pile/footing location — do not summarize\n"
                "- Include grid reference for each pile (e.g. 'A-1', 'B-3')\n"
                "- Include diameter (dia) and depth for every pile\n"
                "- Types: bored_pile, driven_pile, strip_footing, pad_footing, raft\n"
                "- AU: look for 'PBFC' (pile below footing column), 'DIA', 'NGL'\n"
                "- VN: look for 'cọc khoan nhồi', 'cọc ép', 'móng băng', 'móng đơn'\n"
            ),
            "schedule": (
                "FOCUS: This page is a MEMBER SCHEDULE / TABLE. "
                "Extract EVERY row from EVERY table.\n\n"
                "REQUIRED OUTPUT FORMAT:\n"
                '{\n'
                '  "columns": [{"id":"C1","section":"310UC118","grade":"G350","height_mm":4500}],\n'
                '  "beams":   [{"id":"B1","section":"530UB92","grade":"G350","span_mm":7200,'
                '"from_col":"C1","to_col":"C2"}],\n'
                '  "footings":[{"id":"F1","type":"pad","width_mm":2400,"depth_mm":2400,"height_mm":600}],\n'
                '  "bracing": [{"id":"BR1","section":"150x100x8RHS","grade":"C350"}],\n'
                '  "schedule_counts": {"columns":32,"beams":48,"footings":32,"bracing":8}\n'
                "}\n\n"
                "CRITICAL RULES:\n"
                "- section field MUST contain the full section designation (e.g. '310UC118', '530UB92', '150x100x6RHS')\n"
                "- grade field MUST contain the steel/concrete grade (e.g. 'G350', 'C350', 'N32')\n"
                "- Extract id/mark exactly as shown (e.g. 'C1', 'B1', 'BR3A')\n"
                "- Do NOT summarize — include ALL rows\n"
                "- ALWAYS include schedule_counts with total count per element type\n"
                "- AS/NZS sections: UB, UC, PFC, RHS, SHS, CHS (e.g. '530UB92', '168.3x5.0CHS')\n"
                "- TCVN sections: H-sections, I-sections (e.g. 'H300x300x10x15', 'I200')\n"
            ),
            "general": (
                "Analyze this drawing and extract ALL structural elements:\n"
                "- Columns (position, size, height, material, base connection)\n"
                "- Beams (span, section, material, end connections) — include ALL secondary beams\n"
                "- Slabs (area, thickness, material, reinforcement)\n"
                "- Walls (position, thickness, material, openings)\n"
                "- Foundations (type, size, depth)\n"
                "- Bracing (ALL diagonal members, X-bracing, K-bracing)\n"
                "- Grid system (axes labels, spacing)\n"
                "- All dimensions and levels\n"
            ),
        }

        return base + page_hints.get(page_type, page_hints["general"])

    # ── USER PROMPT: PDF ANALYSIS ───────────────────────────
    def user_prompt_scan(self, page_text: str, page_idx: int,
                         page_type: str = "general",
                         profile: Optional[Dict] = None) -> str:
        """
        Build the user prompt for scanning a single page.
        Includes forensic profile context for better accuracy.
        """
        prompt_parts = []

        # Context from forensic
        if profile:
            prompt_parts.append("=== DOCUMENT PROFILE ===")
            prompt_parts.append(f"Region: {profile.get('region', 'unknown')}")
            prompt_parts.append(f"Language: {profile.get('detected_language', 'unknown')}")
            prompt_parts.append(f"Material: {profile.get('primary_material', 'unknown')}")
            prompt_parts.append(f"Scale: {profile.get('estimated_scale_plans', '1:100')}")
            grid_x = profile.get("detected_grid_x", [])
            grid_y = profile.get("detected_grid_y", [])
            if grid_x or grid_y:
                prompt_parts.append(f"Grid X axes: {', '.join(grid_x)}")
                prompt_parts.append(f"Grid Y axes: {', '.join(grid_y)}")

        prompt_parts.append(f"\n=== PAGE {page_idx + 1} ({page_type}) ===")
        prompt_parts.append("Extracted text from drawing:\n")
        prompt_parts.append(self._truncate(page_text))
        prompt_parts.append("\n---")
        prompt_parts.append("Extract structured data as JSON following the schema exactly.")

        return "\n".join(prompt_parts)

    # ── SYNTHESIZER PROMPT ─────────────────────────────────
    def system_prompt_synthesizer(self, building_type: str = "general") -> str:
        """System prompt for the synthesizer / integrator agent."""
        return (
            f"You are a Principal Structural Engineer specializing in {building_type} buildings. "
            "Your task is to synthesize multiple page analyses into a coherent structural model. "
            "Resolve conflicts between overlapping data. Merge dimensions, grid systems, "
            "and member data from multiple views (plans, elevations, sections, schedules).\n\n"
            "OUTPUT: Single unified JSON representing the complete structural model.\n"
            "Rules:\n"
            "- Combine member data from plans + schedules (schedules take precedence)\n"
            "- Resolve dimension conflicts using elevation/section data\n"
            "- Maintain consistent grid coordinate system across all pages\n"
            "- All coordinates in mm, origin at bottom-left\n"
            "- Include confidence scores per element\n"
        )

    def user_prompt_synthesize(self, page_results: List[Dict],
                                profile: Optional[Dict] = None) -> str:
        """Build the synthesizer user prompt with all page results."""
        parts = []

        if profile:
            parts.append("=== DOCUMENT PROFILE ===")
            parts.append(json.dumps(profile, indent=2, ensure_ascii=False))

        parts.append("\n=== PAGE ANALYSIS RESULTS ===")
        for i, pr in enumerate(page_results):
            parts.append(f"\n--- Page {i+1} ---")
            parts.append(json.dumps(pr, indent=2, ensure_ascii=False))

        parts.append("\n\nSynthesize all page data into a unified structural model JSON.")
        return "\n".join(parts)

    # ── VALIDATOR PROMPT ────────────────────────────────────
    def system_prompt_validator(self) -> str:
        """System prompt for the validation agent."""
        return (
            "You are a QA/QC Structural Engineer. Your job is to validate the synthesized "
            "structural model against engineering principles and the original drawing data.\n\n"
            "Check for:\n"
            "- GRID CONSISTENCY: Columns must align to grid intersections\n"
            "- SPAN FEASIBILITY: Beam spans must be structurally feasible for their section\n"
            "- LOAD PATH: Vertical loads must transfer from roof -> beams -> columns -> footings\n"
            "- DIMENSION COHERENCE: Overall dimensions = sum of grid spacings\n"
            "- LEVEL CONSISTENCY: Floor heights must be consistent across views\n"
            "- MISSING ELEMENTS: Check if plans show members not in the model\n\n"
            "OUTPUT: JSON with validation_results array, each having:\n"
            "- check_name, passed (bool), severity (error/warning/info), message, suggestion\n"
        )

    def user_prompt_validate(self, model_json: Dict,
                               page_results: List[Dict],
                               profile: Optional[Dict] = None) -> str:
        """Build the validator user prompt."""
        parts = ["=== SYNTHESIZED STRUCTURAL MODEL ==="]
        parts.append(json.dumps(model_json, indent=2, ensure_ascii=False))

        if profile:
            parts.append("\n=== DOCUMENT PROFILE ===")
            parts.append(json.dumps(profile, indent=2, ensure_ascii=False))

        parts.append("\n=== SOURCE PAGE DATA ===")
        for i, pr in enumerate(page_results):
            parts.append(f"\n--- Source Page {i+1} ---")
            parts.append(json.dumps(pr, indent=2, ensure_ascii=False))

        parts.append("\n\nValidate the model and report all issues.")
        return "\n".join(parts)

    # ── RUBY GENERATION PROMPTS (B1) ────────────────────────
    def system_prompt_ruby_generator(self) -> str:
        """System prompt for Ruby generator agent (SketchUp API)."""
        return (
            "You are a SketchUp Ruby API expert. Generate complete, working Ruby scripts "
            "that create 3D structural models in SketchUp.\n\n"
            "SketchUp Ruby API CONVENTIONS:\n"
            "- Use Sketchup.active_model.entities for all geometry\n"
            "- Points: Geom::Point3d.new(x_mm, y_mm, z_mm) — use mm units\n"
            "- Lines: entities.add_line(p1, p2)\n"
            "- Groups: entities.add_group for each member\n"
            "- Components: definition.entities.add_face for complex geometry\n"
            "- Materials: model.materials.add('Steel_G450') and .add('Concrete_M40')\n"
            "- Transformations: Geom::Transformation.translation for placement\n"
            "- Layers: model.layers.add('Columns'), .add('Beams'), etc\n\n"
            "LAYERS REQUIRED:\n"
            "- 'Grids' — grid lines and labels\n"
            "- 'Columns' — all column members\n"
            "- 'Beams' — all beam members\n"
            "- 'Slabs' — floor slabs\n"
            "- 'Walls' — wall elements\n"
            "- 'Footings' — foundation elements\n"
            "- 'Bracing' — bracing members\n"
            "- 'Roof' — roof members (rafters, purlins)\n"
            "- 'Dimensions' — dimension annotations\n"
            "- 'Labels' — text labels\n\n"
            "OUTPUT: Complete Ruby (.rb) script. No explanations, just the code.\n"
            "Wrap in ```ruby ... ``` code block.\n"
        )

    def user_prompt_ruby_generate(self, model_json: Dict,
                                    profile: Optional[Dict] = None) -> str:
        """Build the Ruby generator user prompt."""
        parts = ["=== STRUCTURAL MODEL FOR SKETCHUP ==="]
        parts.append(json.dumps(model_json, indent=2, ensure_ascii=False))

        if profile:
            parts.append("\n=== DOCUMENT PROFILE ===")
            p = {
                "region": profile.get("region", "unknown"),
                "detected_language": profile.get("detected_language", "unknown"),
                "primary_material": profile.get("primary_material", "unknown"),
                "building_type": profile.get("building_type", "unknown"),
                "estimated_scale_plans": profile.get("estimated_scale_plans", "1:100"),
                "detected_scales": profile.get("detected_scales", []),
                "detected_grid_x": profile.get("detected_grid_x", []),
                "detected_grid_y": profile.get("detected_grid_y", []),
            }
            parts.append(json.dumps(p, indent=2, ensure_ascii=False))

        parts.append("\n\nGenerate a SketchUp Ruby script from this structural model.")
        return "\n".join(parts)

    # ── RUBY VALIDATION PROMPTS (B2) ────────────────────────
    def system_prompt_ruby_validator(self) -> str:
        """System prompt for Ruby validator agent."""
        return (
            "You are a SketchUp Ruby API QA expert. Validate Ruby scripts for:\n"
            "- Syntax errors\n"
            "- API compatibility (SketchUp 2020+)\n"
            "- Entity creation correctness\n"
            "- Coordinate consistency (all in mm)\n"
            "- Missing required layers\n"
            "- Unclosed groups/components\n"
            "- Performance issues (large loops without progress)\n\n"
            "OUTPUT: JSON with validation_results, each having:\n"
            "- line (int, 1-based)\n"
            "- severity (error/warning/info)\n"
            "- check_name (string)\n"
            "- message (string)\n"
            "- suggestion (string, how to fix)\n"
            "- auto_fix_ruby (string, replacement code — ONLY if fix is unambiguous)\n"
        )

    def user_prompt_ruby_validate(self, ruby_code: str,
                                    model_json: Optional[Dict] = None) -> str:
        """Build the Ruby validator user prompt."""
        parts = ["=== RUBY SCRIPT TO VALIDATE ==="]
        parts.append("```ruby")
        parts.append(ruby_code)
        parts.append("```")

        if model_json:
            parts.append("\n=== EXPECTED STRUCTURAL MODEL ===")
            parts.append(json.dumps(model_json, indent=2, ensure_ascii=False))

        parts.append("\n\nValidate this Ruby script and report ALL issues found.")
        return "\n".join(parts)

    # ── TARGETED SECTION EXTRACTION (retry for null sections) ──
    def system_prompt_section_extractor(self) -> str:
        """Targeted system prompt for re-scanning schedule pages to fill null sections."""
        return (
            "You are a structural steel detailer expert at reading member schedules. "
            "Your ONLY job is to extract section designations, steel grades, and member IDs. "
            "Return ONLY valid JSON. No explanations, no markdown.\n\n"
            "AS/NZS section examples:\n"
            "  '310UC118 G350' → section='310UC118', grade='G350'\n"
            "  '530UB92.4 G350' → section='530UB92', grade='G350'\n"
            "  '150x100x6RHS C350' → section='150x100x6RHS', grade='C350'\n"
            "  'CHS168.3x5.0 C350' → section='168.3x5.0CHS', grade='C350'\n"
            "  '100x100x5SHS C350' → section='100x100x5SHS', grade='C350'\n"
            "TCVN section examples:\n"
            "  'H300x300x10x15 CT3' → section='H300x300x10x15', grade='CT3'\n"
            "  'I200 SS400' → section='I200', grade='SS400'\n"
        )

    def user_prompt_targeted_section_extract(
        self, page_text: str, member_ids: List[str]
    ) -> str:
        """User prompt for targeted re-scan of a schedule page to fill null sections."""
        ids_str = ", ".join(member_ids[:30])
        return (
            f"These member IDs are MISSING their section data: {ids_str}\n\n"
            "From the schedule text below, extract the section designation and grade "
            "for EACH member ID listed.\n\n"
            f"SCHEDULE TEXT:\n{self._truncate(page_text)}\n\n"
            "OUTPUT — JSON only:\n"
            '{"section_map": {\n'
            '  "C1": {"section": "310UC118", "grade": "G350"},\n'
            '  "B1": {"section": "530UB92",  "grade": "G350"}\n'
            "}}\n"
            "Include only member IDs you can confirm from the text. "
            "Use null for section/grade if genuinely absent."
        )

    # ── ELEVATION / STOREY HEIGHT EXTRACTION ───────────────
    def system_prompt_elevation_extractor(self) -> str:
        """System prompt for extracting storey heights and level elevations from any drawing."""
        return (
            "You are a Senior Structural Engineer. Extract ALL level elevation data from "
            "construction drawings. Your output must be a JSON array of level objects.\n\n"
            "HANDLE ALL NOTATION STYLES:\n"
            "  AU/NZ:   'RL 9.150', 'FFL +9150', 'SSL +8900', 'EL.+9.15m', '3rd Floor RL12.600'\n"
            "  VN:      'Cốt +3.500', '+3500', '±0.000', 'Cao độ 3.5m', 'Tầng 3: +7000'\n"
            "  INTL:    '+3.50m', 'Level 3: +7000mm', 'EL +3500', 'FF +3500'\n\n"
            "OUTPUT FORMAT (JSON array, no markdown):\n"
            "[\n"
            "  {\"id\": \"GROUND\",  \"label\": \"Ground Floor\", \"rl_mm\": 0,    \"ffl_mm\": 0,    \"floor_to_floor_mm\": 3500},\n"
            "  {\"id\": \"LEVEL_1\", \"label\": \"Level 1\",      \"rl_mm\": 3500, \"ffl_mm\": 3500, \"floor_to_floor_mm\": 3200},\n"
            "  {\"id\": \"ROOF\",    \"label\": \"Roof\",          \"rl_mm\": 6700, \"ffl_mm\": null, \"floor_to_floor_mm\": null}\n"
            "]\n\n"
            "RULES:\n"
            "- Convert all values to mm (multiply metres by 1000)\n"
            "- If only RL/elevation given (not F2F), compute floor_to_floor_mm from differences\n"
            "- Sort levels by ascending elevation\n"
            "- If no explicit level data found, return []\n"
            "- Never invent values — only extract what is visible in the drawing\n"
        )

    def user_prompt_extract_elevations(self, page_text: str, page_type: str = "elevation") -> str:
        """User prompt to extract RL/FFL/storey heights from a specific page."""
        return (
            f"PAGE TYPE: {page_type.upper()}\n\n"
            "Extract ALL level elevations, storey heights, and RL/FFL values from this page.\n\n"
            f"PAGE TEXT:\n{self._truncate(page_text)}\n\n"
            "Return ONLY the JSON array of level objects. No explanation."
        )

    # ── GRID COORDINATE EXTRACTION ──────────────────────────
    def user_prompt_extract_grid(self, page_text: str, page_type: str = "plan") -> str:
        """User prompt to extract grid label → mm coordinate mappings from a plan page."""
        return (
            f"PAGE TYPE: {page_type.upper()}\n\n"
            "Extract the structural grid coordinate system from this page.\n"
            "Find the exact millimetre position of EACH grid line.\n\n"
            "HANDLE ALL NOTATION STYLES:\n"
            "  'GRID 1 @ 0', 'GRID 2 @ 6000', 'Grid A = 0mm, Grid B = 4500mm'\n"
            "  Dimension chains: '4500  6000  4500' between grid labels\n"
            "  TCVN: 'Trục 1: 0', 'Trục A: 4500'\n\n"
            f"PAGE TEXT:\n{self._truncate(page_text)}\n\n"
            "OUTPUT FORMAT (JSON, no markdown):\n"
            "{\n"
            "  \"x_labels\": {\"1\": 0, \"2\": 6000, \"3\": 12000, \"4\": 16500},\n"
            "  \"y_labels\": {\"A\": 0, \"B\": 4500, \"C\": 9000},\n"
            "  \"confidence\": 0.9,\n"
            "  \"source\": \"dimension_chain\"\n"
            "}\n\n"
            "Set confidence: 1.0 = explicit labels with mm values, "
            "0.7 = computed from dimension chain, 0.3 = estimated from scale.\n"
            "Return {\"x_labels\": {}, \"y_labels\": {}, \"confidence\": 0.0} if no grid data found.\n"
            "Return ONLY the JSON. No explanation."
        )

    # ── ARCHITECT REVIEWER PROMPTS ──────────────────────────
    def system_prompt_architect_reviewer(self) -> str:
        """Dual-persona system prompt: Senior Fullstack Engineer + Structural Architect."""
        region_hint = {
            "au": "AS/NZS standards. Sections: UB/UC/RHS/CHS/SHS. Levels: RL/FFL/SSL.",
            "vn": "TCVN standards. Members: C=column, D=beam, S=slab, M=foundation. Levels: Cốt.",
            "intl": "Eurocode. Sections: IPE/HEA/HEB. Levels: EL/FF.",
        }.get(self.region, "International standards.")
        return (
            "You are TWO experts merged into one reviewer:\n\n"
            "EXPERT A — Principal Structural Engineer (15+ yrs):\n"
            f"  {region_hint}\n"
            "  You read structural drawings fluently. You know grid systems, RL elevations,\n"
            "  member schedules, load paths, and LOD300/350 geometry requirements.\n\n"
            "EXPERT B — Senior Fullstack Software Engineer (15+ yrs):\n"
            "  You understand this exact data pipeline end-to-end:\n"
            "    PDF text → ScannerV6 → JSON model (SynthesizerV7) → RubyGeneratorV5 → SketchUp .rb\n\n"
            "  Pipeline stage reference (use these names for root_cause attribution):\n"
            "    'scanner_v6.py'        Stage 0-2: per-page PDF extraction\n"
            "    'synthesizer_v7.py'    Stage 3:   merge pages + Z-coordinate assignment\n"
            "    'ruby_generator_v5.py' Stage 7:   JSON model → SketchUp Ruby geometry\n"
            "    'code_reviewer.py'     Stage 9.5: static script validation\n\n"
            "TASK: For every discrepancy you find, reason through BOTH perspectives:\n"
            "  1. What does the PDF show? (EXPERT A)\n"
            "  2. What is wrong in the model or script? (EXPERT A)\n"
            "  3. Which pipeline stage produced this bad data? (EXPERT B)\n"
            "  4. What specific code or data fix resolves it? (EXPERT B)\n\n"
            "COMMON ROOT CAUSES to look for:\n"
            "  - Null z_base_mm/z_top_mm  → synthesizer_v7.py: level elevation not resolved\n"
            "  - Missing column           → scanner_v6.py: grid notation not parsed\n"
            "  - Wrong section size       → scanner_v6.py: schedule row not matched\n"
            "  - Z=0 for all members      → synthesizer_v7.py: height_from_datum_mm all null\n"
            "  - Crash in Ruby            → ruby_generator_v5.py: degenerate face / pushpull(0)\n"
            "  - Wrong grid coordinates   → synthesizer_v7.py: x_coords/y_coords empty dict\n\n"
            "OUTPUT FORMAT — respond with a single JSON object:\n"
            "{\n"
            "  \"page_ok\": false,\n"
            "  \"page_summary\": \"Plan Level 1 — columns at grids A-D, 1-4\",\n"
            "  \"discrepancies\": [\n"
            "    {\n"
            "      \"element_id\": \"C5\",\n"
            "      \"visual_issue\": \"column missing from 3D model\",\n"
            "      \"root_cause\": \"scanner_v6 page 7: grid notation 'C-3' not parsed\",\n"
            "      \"pipeline_stage\": \"scanner_v6.py / _scan_page\",\n"
            "      \"suggested_fix\": \"add pattern for hyphenated grid refs like 'C-3'\",\n"
            "      \"action\": \"add_column\",\n"
            "      \"data\": {\"grid_x\": \"3\", \"grid_y\": \"C\", \"section\": \"310UC118\"}\n"
            "    }\n"
            "  ],\n"
            "  \"3d_issues\": [\n"
            "    {\n"
            "      \"element_id\": \"C1\",\n"
            "      \"visual_issue\": \"column height=0, not visible in 3D\",\n"
            "      \"root_cause\": \"synthesizer_v7: height_from_datum_mm null for all levels\",\n"
            "      \"pipeline_stage\": \"synthesizer_v7.py / _resolve_level_elevations\",\n"
            "      \"suggested_fix\": \"elevation page RL values not extracted — check ELEVATION page scan\",\n"
            "      \"type\": \"wrong_z\", \"expected_z_mm\": 3500, \"got_z_mm\": 0,\n"
            "      \"action\": \"set_z\"\n"
            "    }\n"
            "  ]\n"
            "}\n\n"
            "Use pipeline_stage: 'unknown' only if you truly cannot identify the cause.\n"
            "Return ONLY JSON. No markdown, no explanation outside the JSON."
        )

    def user_prompt_page_review(self, page_type: str, page_text: str,
                                 model_json_excerpt: str,
                                 pipeline_context: Optional[str] = None,
                                 page_image_b64: Optional[str] = None) -> str:
        """User prompt for reviewing one PDF page against the current model + pipeline state."""
        parts = [
            f"PAGE TYPE: {page_type.upper()}",
            "",
            "=== PDF PAGE TEXT ===",
            self._truncate(page_text),
            "",
            "=== CURRENT MODEL (relevant excerpt) ===",
            model_json_excerpt[:4000] if len(model_json_excerpt) > 4000 else model_json_excerpt,
        ]
        if pipeline_context:
            parts += ["", "=== PIPELINE CONTEXT (what each stage produced) ===", pipeline_context]
        parts += [
            "",
            f"Review this {page_type} page. As EXPERT A: identify all structural discrepancies. "
            "As EXPERT B: diagnose which pipeline stage caused each one and suggest a fix. "
            "Return structured JSON as specified.",
        ]
        return "\n".join(parts)

    def user_prompt_master_pdf_scan(self, cover_page_text: str) -> str:
        """User prompt for initial master scan of title/cover page to understand project scope."""
        return (
            "Analyze this project title sheet / cover page and extract project metadata.\n\n"
            f"PAGE TEXT:\n{self._truncate(cover_page_text)}\n\n"
            "OUTPUT FORMAT (JSON):\n"
            "{\n"
            "  \"project_name\": \"University of New England Tamworth\",\n"
            "  \"location\": \"Tamworth NSW 2340\",\n"
            "  \"standard\": \"au\",\n"
            "  \"building_type\": \"commercial\",\n"
            "  \"floor_count\": 3,\n"
            "  \"primary_material\": \"steel\",\n"
            "  \"expected_elements\": {\"columns\": 44, \"beams\": 32, \"footings\": 6},\n"
            "  \"drawing_list\": [\"S01 - Ground Floor Plan\", \"S02 - First Floor Plan\"]\n"
            "}\n"
            "Set standard: 'au' for AS/NZS, 'vn' for TCVN, 'intl' for Eurocode.\n"
            "Use null for any field not found in the text. Return ONLY JSON."
        )

    # ── REGION-AWARE SYSTEM PROMPT ──────────────────────────
    def get_region_prompt(self) -> str:
        """Get region-specific conventions."""
        prompts = {
            "vn": (
                "\nVIETNAM (TCVN) CONVENTIONS:\n"
                "- Steel grades: CT3, CT38, CT42, SS400, SM490, A572\n"
                "- Concrete grades: M200, M250, M300, M350, M400 (TCVN)\n"
                "- Reinforcement: Ø6, Ø8, Ø10, Ø12, Ø14, Ø16, Ø18, Ø20, Ø22, Ø25, Ø28, Ø32\n"
                "- Grid notation: 'Trục 1', 'Trục A' or just '1', 'A' in schedules\n"
                "- Level notation: 'Cốt +X.XXX' (metres), 'Cao độ +X.XXX', '±0.000' = ground\n"
                "- MEMBER ID prefixes:\n"
                "    C, CP, COT = column (cột)\n"
                "    D, DB, DAM = beam (dầm)\n"
                "    S, SL, SAN = slab (sàn)\n"
                "    M, MB, MONG = footing/foundation (móng)\n"
                "    T, TT, TUONG = wall (tường)\n"
                "    GK, GC, GIANG = bracing (giằng)\n"
                "- Section notation: H300x300x10x15 (H-section), I200 (I-section), "
                "  □200x200x8 (box section), Ø168x5 (circular)\n"
                "- Pile types: cọc khoan nhồi (bored pile), cọc ép (driven pile), "
                "  cọc vuông (square pile)\n"
                "- Standards: TCVN 5574 (concrete), TCVN 5575 (steel), TCVN 2737 (loading)\n"
                "- Units: mm for dimensions, kN for forces, MPa for strength\n"
            ),
            "au": (
                "\nAUSTRALIA (AS/NZS) CONVENTIONS:\n"
                "- Steel grades: C250, C350, C450 (cold-formed), G250, G300, G350, G450, G500 (hot-rolled)\n"
                "- Sections: UB, UC, PFC, EA, UA, RHS, SHS, CHS, Z150-Z350, C150-C350\n"
                "- Concrete: N20, N25, N32, N40, S20-S40\n"
                "- Reinforcement: N12, N16, N20, N24, N28, N32, R10, R12\n"
                "- Level: RL (Reduced Level), FFL (Finished Floor Level), SSL (Structural Slab Level)\n"
                "- Bolts: M16, M20, M24 Grade 8.8, M30 Grade 8.8\n"
                "- Welds: E41XX, E48XX\n"
                "- Standards: AS4100 (Steel), AS3600 (Concrete), AS4600 (Cold-formed), AS1170 (Loading)\n"
            ),
            "intl": (
                "\nINTERNATIONAL (EUROCODE) CONVENTIONS:\n"
                "- Steel grades: S235, S275, S355, S460\n"
                "- Sections: IPE, HEA, HEB, HEM, UPN, UPE\n"
                "- Concrete: C20/25, C25/30, C30/37, C40/50\n"
                "- Reinforcement: B500A, B500B\n"
                "- Standards: EN 1990-1999 (Eurocodes)\n"
            ),
        }
        return prompts.get(self.region, prompts["intl"])

    # ── MULTI-SHOT EXAMPLES ─────────────────────────────────
    def get_shot_examples(self, region: str = "vn") -> str:
        """Get region-specific few-shot examples for better LLM accuracy."""
        vn_examples = (
            'EXAMPLE Column: Input "Cot C1: H300x300x10x15, L=4200mm, thep CT3, Truc 1-A" -> '
            '{"type":"column","id":"C1","section":"H300x300x10x15","height_mm":4200,"material":"CT3","grid_x":"1","grid_y":"A"} '
            'EXAMPLE Beam: Input "Dam D1: I400x200x8x13, L=6000mm, thep SS400" -> '
            '{"type":"beam","id":"D1","section":"I400x200x8x13","span_mm":6000,"material":"SS400"} '
        )
        au_examples = (
            'EXAMPLE Column: Input "Column C1: 310UC158, H=4500mm, G350, Grid 2-B" -> '
            '{"type":"column","id":"C1","section":"310UC158","height_mm":4500,"material":"G350","grid_x":"2","grid_y":"B"} '
        )
        intl_examples = (
            'EXAMPLE Column: Input "Column C1: HEB300, H=4500mm, S355, Axis 2-B" -> '
            '{"type":"column","id":"C1","section":"HEB300","height_mm":4500,"material":"S355","grid_x":"2","grid_y":"B"} '
        )
        examples = {"vn": vn_examples, "au": au_examples, "intl": intl_examples}
        return examples.get(region, intl_examples)

    # ── UTILITY ─────────────────────────────────────────────
    def _truncate(self, text: str) -> str:
        """Truncate text to max_chars, keeping middle if needed."""
        if len(text) <= self.max_chars:
            return text
        half = self.max_chars // 2
        return text[:half] + "\n...(truncated)...\n" + text[-half:]

    def system_prompt_plan_extractor(self) -> str:
        return (
            "You are a senior structural detailer reading a structural plan drawing.\n"
            "Your task: identify every column mark (e.g. C1, C2, UC1, 1C, etc.) visible "
            "on the plan and record its exact grid intersection position.\n\n"
            "Output JSON only — no explanation:\n"
            '{\n'
            '  "C1": {\n'
            '    "grid_label_x": "A",\n'
            '    "grid_label_y": "1",\n'
            '    "grid_x_mm": 0,\n'
            '    "grid_y_mm": 7000\n'
            '  }\n'
            '}\n\n'
            "Rules:\n"
            "- Only include columns you can clearly identify at a grid intersection\n"
            "- grid_x_mm and grid_y_mm must be integers in millimetres from the grid origin\n"
            "- If a scale bar is shown, use it to calibrate distances\n"
            "- Do NOT include beams, slabs, walls, or non-structural items\n"
            "- If you cannot determine a position, omit that mark rather than guessing\n"
        )

    def user_prompt_plan_extract(self, page_idx: int) -> str:
        return (
            f"Structural plan page {page_idx}. "
            "Extract all column marks and their grid XY positions from this plan drawing. "
            "Output valid JSON only — no text before or after the JSON object."
        )

    def system_prompt_detail_extractor(self) -> str:
        return (
            "You are a senior structural connection designer with 20 years experience "
            "reading Australian structural detail drawings (AS/NZS 4100, AS 4600).\n"
            "Your task: read each connection detail shown and extract its specifications precisely.\n\n"
            "For each detail visible, output JSON:\n"
            "{\n"
            '  "DET_ID": {\n'
            '    "connection_type": "column_base" | "beam_to_column" | "beam_splice" | "brace_end",\n'
            '    "member_ref": "C1",\n'
            '    "base_plate": {"width_mm": 400, "depth_mm": 400, "thickness_mm": 20,\n'
            '                   "bolt_count": 4, "bolt_grade": "8.8", "bolt_dia_mm": 24},\n'
            '    "end_plate": {"width_mm": 200, "depth_mm": 300, "thickness_mm": 12},\n'
            '    "stiffeners": true,\n'
            '    "weld_size_mm": 8,\n'
            '    "confidence": 0.85\n'
            "  }\n"
            "}\n\n"
            "Rules:\n"
            "- DET_ID format: 'N/XX' matching the detail reference on drawing (e.g. '7/A3')\n"
            "- Only include fields you can clearly read — omit uncertain values\n"
            "- All dimensions in mm\n"
            "- Output JSON only, no markdown, no explanation"
        )

    def user_prompt_detail_extract(self, page_idx: int) -> str:
        return (
            f"Structural detail page {page_idx}. "
            "Extract all connection details shown: base plates, end plates, bolt layouts, welds. "
            "Output valid JSON only — no text before or after the JSON object."
        )

    def system_prompt_coversheet_parser(self) -> str:
        return (
            "You are reading a structural engineering drawing title block / coversheet.\n"
            "Extract the project metadata from the title block and drawing list.\n\n"
            "Output JSON:\n"
            "{\n"
            '  "project_name": "...",\n'
            '  "project_number": "...",\n'
            '  "revision": "A",\n'
            '  "standard": "AS/NZS",\n'
            '  "engineer": "...",\n'
            '  "date": "2026-05",\n'
            '  "building_type": "commercial",\n'
            '  "floor_count": 4,\n'
            '  "material": "steel"\n'
            "}\n\n"
            "Rules:\n"
            "- Use null for any field not found\n"
            "- floor_count: read from notes (e.g. '4-storey', 'G+3') — integer only\n"
            "- Output JSON only, no markdown"
        )

    def build_full_system_prompt(self, agent_type: str, **kwargs) -> str:
        """Build complete system prompt for any agent."""
        agent_prompts = {
            "scanner": self.system_prompt_scanner(kwargs.get("page_type", "general")),
            "synthesizer": self.system_prompt_synthesizer(kwargs.get("building_type", "general")),
            "validator": self.system_prompt_validator(),
            "ruby_generator": self.system_prompt_ruby_generator(),
            "ruby_validator": self.system_prompt_ruby_validator(),
            "plan_extractor": self.system_prompt_plan_extractor(),
        }
        prompt = agent_prompts.get(agent_type, agent_prompts["scanner"])
        prompt += self.get_region_prompt()
        prompt += self.get_shot_examples(kwargs.get("region", self.region))
        return prompt
