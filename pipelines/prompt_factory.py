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
                "FOCUS: This page is a FLOOR PLAN. Extract:\n"
                "- Column positions with grid coordinates\n"
                "- Beam layout between columns\n"
                "- Slab boundaries and thickness\n"
                "- Wall locations (external & internal)\n"
                "- Grid lines with labels\n"
                "- Opening locations (doors, windows)\n"
                "- Overall plan dimensions\n"
            ),
            "elevation": (
                "FOCUS: This page is an ELEVATION VIEW. Extract:\n"
                "- Building height and levels\n"
                "- Column heights and base connections\n"
                "- Bracing configuration (X, V, chevron)\n"
                "- Roof profile and ridge height\n"
                "- Wall cladding zones\n"
                "- Girt and purlin positions\n"
                "- Level notations (RL, FFL, SSL)\n"
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
            "schedule": (
                "FOCUS: This page is a SCHEDULE/TABLE. Extract:\n"
                "- Member schedule data (columns, beams, footings)\n"
                "- Section sizes with labels\n"
                "- Reinforcement details\n"
                "- Bolt/weld specifications\n"
                "- Material grades\n"
                "- Quantities and weights\n"
                "Format as structured table data.\n"
            ),
            "general": (
                "Analyze this drawing and extract ALL structural elements:\n"
                "- Columns (position, size, height, material, base connection)\n"
                "- Beams (span, section, material, end connections)\n"
                "- Slabs (area, thickness, material, reinforcement)\n"
                "- Walls (position, thickness, material, openings)\n"
                "- Foundations (type, size, depth)\n"
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

    # ── REGION-AWARE SYSTEM PROMPT ──────────────────────────
    def get_region_prompt(self) -> str:
        """Get region-specific conventions."""
        prompts = {
            "vn": (
                "\nVIETNAM (TCVN) CONVENTIONS:\n"
                "- Steel grades: CT3, CT38, CT42, SS400, SM490\n"
                "- Concrete grades: M200, M250, M300, M400 (TCVN)\n"
                "- Reinforcement: Ø6, Ø8, Ø10, Ø12, Ø14, Ø16, Ø18, Ø20, Ø22, Ø25\n"
                "- Grid notation: Trục 1, 2, 3... (numbers) and Trục A, B, C... (letters)\n"
                "- Level notation: Cốt ±0.00, Cao độ\n"
                "- Section labels: D1, D2... (dầm/beams), C1, C2... (cột/columns)\n"
                "- Unit: mm for dimensions, MPa for strength\n"
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

    def build_full_system_prompt(self, agent_type: str, **kwargs) -> str:
        """Build complete system prompt for any agent."""
        agent_prompts = {
            "scanner": self.system_prompt_scanner(kwargs.get("page_type", "general")),
            "synthesizer": self.system_prompt_synthesizer(kwargs.get("building_type", "general")),
            "validator": self.system_prompt_validator(),
            "ruby_generator": self.system_prompt_ruby_generator(),
            "ruby_validator": self.system_prompt_ruby_validator(),
        }
        prompt = agent_prompts.get(agent_type, agent_prompts["scanner"])
        prompt += self.get_region_prompt()
        prompt += self.get_shot_examples(kwargs.get("region", self.region))
        return prompt
