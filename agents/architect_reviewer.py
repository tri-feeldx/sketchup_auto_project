"""
=============================================================================
ARR-1 V2: ARCHITECT REVIEWER — Page-by-Page Architect-Level Model Review
=============================================================================
Reads every relevant PDF page with purpose (like an architect would).
Each page type triggers a targeted review:
  TITLE    → extract project profile (standard, floors, material)
  PLAN     → verify column positions, beam layout, grid alignment
  ELEVATION→ verify storey heights, bracing, Z positions
  SCHEDULE → verify section sizes, grades, member IDs
  DETAIL   → note special elements (stairs, lifts, balconies)
  FOUNDATION→ verify footing positions and sizes

Output:
  {
    "verdict": "OK" | "ISSUES_FOUND",
    "project_profile": {...},
    "page_reviews": [{page_idx, page_type, page_ok, discrepancies, 3d_issues}],
    "all_corrections": {"add": {...}, "update": {...}, "remove": {...}},
    "3d_issues": [{element_id, type, expected_z_mm, got_z_mm, action}],
    "confidence": 0.0–1.0,
  }
=============================================================================
"""

import json
import re
from pathlib import Path
from typing import Optional, List, Dict

from core.llm_wrapper import call_llm
from core.vision_renderer import VisionRenderer
from pipelines.prompt_factory import PromptFactory

MAX_VISION_PAGES = 4
MAX_TEXT_PER_PAGE = 3000
MAX_MODEL_EXCERPT = 6000


class ArchitectReviewer:
    """
    ARR-1 V2: Page-aware architect-level review of the structural model.
    Reviews every relevant page against the model and proposes corrections.
    """

    def __init__(self, pdf_path: str, region: str = "au", dpi: int = 200):
        self.pdf_path = Path(pdf_path)
        self.region = region
        self.dpi = dpi
        self.prompt_factory = PromptFactory(region=region)

    def review(self, scanner_output: dict, structural_model: dict) -> dict:
        """
        Full architect review: page-by-page analysis + 3D position verification.

        Returns structured corrections that pipeline_v8 can apply.
        """
        forensic = scanner_output.get("forensic", {})
        page_results = scanner_output.get("page_results", {})
        page_texts = forensic.get("page_texts", {})

        project_profile = {}
        page_reviews = []
        all_corrections: Dict = {"add": {}, "update": {}, "remove": {}}
        all_3d_issues = []
        all_diagnostics: List[dict] = []
        vision_used = 0

        # ── Stage 1: Title page → project profile ───────────
        title_pages = [
            idx for idx, pr in page_results.items()
            if pr.get("page_type") in ("TITLE", "COVER")
        ]
        if title_pages:
            tp_idx = title_pages[0]
            pt = self._get_page_text(page_texts, tp_idx)
            if pt:
                project_profile = self._extract_project_profile(pt)
                if project_profile:
                    print(f"  [ARR] Project: {project_profile.get('project_name','?')} "
                          f"| std={project_profile.get('standard','?')} "
                          f"| floors={project_profile.get('floor_count','?')}")

        # ── Stage 2: Per-page review ─────────────────────────
        model_excerpt = self._build_model_excerpt(structural_model)
        sys_p = self.prompt_factory.system_prompt_architect_reviewer()

        for idx_str, pr in sorted(page_results.items(), key=lambda kv: int(kv[0])):
            ptype = pr.get("page_type", "UNKNOWN")
            if ptype in ("TITLE", "COVER", "UNKNOWN") or pr.get("skipped"):
                continue

            page_idx = pr.get("page_idx", int(idx_str))
            pt = self._get_page_text(page_texts, idx_str)
            if not pt:
                continue

            # Use vision for PLAN and ELEVATION pages (highest value)
            use_vision = (ptype in ("PLAN", "ELEVATION") and
                          vision_used < MAX_VISION_PAGES)
            img_bytes = None
            if use_vision:
                try:
                    renderer = VisionRenderer(str(self.pdf_path), dpi=self.dpi)
                    img_bytes = renderer.render_page_as_bytes(page_idx, format="PNG")
                    renderer.close()
                    vision_used += 1
                except Exception as e:
                    print(f"    [ARR] Vision render page {page_idx} failed: {e}")

            # Build pipeline context for this page so LLM can trace root causes
            pipeline_ctx = self._build_pipeline_context(pr, structural_model)

            usr_p = self.prompt_factory.user_prompt_page_review(
                page_type=ptype,
                page_text=pt[:MAX_TEXT_PER_PAGE],
                model_json_excerpt=model_excerpt,
                pipeline_context=pipeline_ctx,
            )

            try:
                resp = call_llm(
                    usr_p,
                    system=sys_p,
                    images=[img_bytes] if img_bytes else None,
                )
                review = self._parse_json(resp)
                if review and isinstance(review, dict):
                    review["page_idx"] = page_idx
                    review["page_type"] = ptype
                    page_reviews.append(review)
                    # Collect corrections, 3D issues, and pipeline diagnostics
                    for disc in review.get("discrepancies", []):
                        action = disc.get("action", "")
                        etype = disc.get("element_type") or disc.get("type", "unknown")
                        data = disc.get("data", {})
                        if action == "add_column" and data:
                            all_corrections["add"].setdefault("columns", []).append(data)
                        elif action == "add_beam" and data:
                            all_corrections["add"].setdefault("beams", []).append(data)
                        elif action in ("update_section", "fix_dimension") and data:
                            all_corrections["update"].setdefault(etype, []).append(data)
                        # Collect diagnostic if has root cause
                        if disc.get("root_cause") or disc.get("pipeline_stage"):
                            all_diagnostics.append({
                                "page_idx": page_idx,
                                "page_type": ptype,
                                "element_id": disc.get("element_id"),
                                "visual_issue": disc.get("visual_issue") or disc.get("expected", ""),
                                "root_cause": disc.get("root_cause", "unknown"),
                                "pipeline_stage": disc.get("pipeline_stage", "unknown"),
                                "suggested_fix": disc.get("suggested_fix", ""),
                            })
                    for issue in review.get("3d_issues", []):
                        all_3d_issues.append(issue)
                        if issue.get("root_cause") or issue.get("pipeline_stage"):
                            all_diagnostics.append({
                                "page_idx": page_idx,
                                "page_type": ptype,
                                "element_id": issue.get("element_id"),
                                "visual_issue": issue.get("visual_issue", issue.get("type", "")),
                                "root_cause": issue.get("root_cause", "unknown"),
                                "pipeline_stage": issue.get("pipeline_stage", "unknown"),
                                "suggested_fix": issue.get("suggested_fix", ""),
                            })
            except Exception as e:
                print(f"    [ARR] Review page {page_idx} ({ptype}) failed: {e}")

        # ── Stage 3: 3D position verification ───────────────
        z_issues = self._verify_3d_positions(structural_model)
        all_3d_issues.extend(z_issues)

        # ── Result ───────────────────────────────────────────
        issues_found = (
            any(not r.get("page_ok", True) for r in page_reviews) or
            bool(all_3d_issues) or
            any(v for v in all_corrections["add"].values()) or
            any(v for v in all_corrections["update"].values())
        )

        total_discrepancies = sum(
            len(r.get("discrepancies", [])) for r in page_reviews
        )

        # Group diagnostics by pipeline stage for summary
        stage_counts: Dict[str, int] = {}
        for d in all_diagnostics:
            stage = d.get("pipeline_stage", "unknown").split("/")[0].strip()
            stage_counts[stage] = stage_counts.get(stage, 0) + 1

        result = {
            "verdict": "ISSUES_FOUND" if issues_found else "OK",
            "project_profile": project_profile,
            "page_reviews": page_reviews,
            "all_corrections": all_corrections,
            "3d_issues": all_3d_issues,
            "pipeline_diagnostics": all_diagnostics,
            "pipeline_stage_counts": stage_counts,
            "confidence": 0.85 if page_reviews else 0.5,
            "total_discrepancies": total_discrepancies,
            "total_3d_issues": len(all_3d_issues),
            "vision_pages_used": vision_used,
        }

        print(f"  [ARR] Verdict={result['verdict']} | "
              f"pages={len(page_reviews)} | "
              f"discrepancies={total_discrepancies} | "
              f"3d_issues={len(all_3d_issues)}")
        if stage_counts:
            print("  [ARR] Root causes by pipeline stage:")
            for stage, count in sorted(stage_counts.items(), key=lambda kv: -kv[1]):
                print(f"    {stage}: {count} issue(s)")
        return result

    def _build_pipeline_context(self, page_result: dict, model: dict) -> str:
        """Build a concise pipeline context string so the LLM can trace root causes."""
        ptype = page_result.get("page_type", "")
        page_idx = page_result.get("page_idx", "?")
        members = model.get("members", {})
        grid = model.get("grid_system", {})
        levels = model.get("levels", [])

        # Scanner stage summary
        n_extracted = sum(
            len(page_result.get(k, []))
            for k in ("columns", "beams", "slabs", "footings", "bracing")
        )
        scanner_line = (
            f"stage_scanner: completed "
            f"(page {page_idx} type={ptype}, {n_extracted} elements extracted"
            + (", level_elevations=" + str(len(page_result.get("level_elevations", [])))
               if page_result.get("level_elevations") else "")
            + (", grid_coords confidence=" + str(page_result.get("grid_coords", {}).get("confidence", 0))
               if page_result.get("grid_coords") else "")
            + ")"
        )

        # Synthesizer stage summary
        grid_conf = grid.get("coord_confidence", 0.0)
        x_coords_count = len(grid.get("x_coords", {}))
        y_coords_count = len(grid.get("y_coords", {}))
        null_levels = sum(
            1 for l in levels
            if not (l.get("height_from_datum_mm") or l.get("elevation_mm"))
        )
        synth_line = (
            f"stage_synthesizer: completed "
            f"(grid_coords x={x_coords_count} y={y_coords_count} conf={grid_conf:.2f}, "
            f"levels={len(levels)} null_elevations={null_levels})"
        )

        # Key field snapshot for elements on this page
        field_lines = []
        if ptype == "PLAN":
            cols_sample = members.get("columns", [])[:5]
            for c in cols_sample:
                field_lines.append(
                    f"  col {c.get('id','?')}: "
                    f"grid=({c.get('grid_x','?')},{c.get('grid_y','?')}) "
                    f"z_base={c.get('z_base_mm','null')} "
                    f"z_top={c.get('z_top_mm','null')} "
                    f"h={c.get('height_mm','null')} "
                    f"section={c.get('section','null')}"
                )
        elif ptype == "ELEVATION":
            for lvl in levels[:6]:
                field_lines.append(
                    f"  level {lvl.get('id','?')}: "
                    f"elevation={lvl.get('height_from_datum_mm', lvl.get('elevation_mm','null'))}"
                )
        elif ptype == "SCHEDULE":
            for c in members.get("columns", [])[:3]:
                field_lines.append(
                    f"  col {c.get('id','?')}: section={c.get('section','null')} "
                    f"material={c.get('material','null')}"
                )

        ctx_parts = [scanner_line, synth_line]
        if field_lines:
            ctx_parts.append("Key model fields for this page's elements:")
            ctx_parts.extend(field_lines)
        return "\n".join(ctx_parts)

    def _extract_project_profile(self, cover_text: str) -> dict:
        """Extract project metadata from title/cover page."""
        usr_p = self.prompt_factory.user_prompt_master_pdf_scan(cover_text)
        sys_p = (
            "You are a document analyst. Extract project metadata from a construction drawing "
            "title sheet. Return ONLY valid JSON. No markdown."
        )
        try:
            resp = call_llm(usr_p, system=sys_p)
            data = self._parse_json(resp)
            if isinstance(data, dict):
                return data
        except Exception as e:
            print(f"    [ARR] Project profile extract failed: {e}")
        return {}

    def _verify_3d_positions(self, model: dict) -> List[dict]:
        """Check if elements have valid Z positions (not all at zero)."""
        issues = []
        members = model.get("members", {})

        # Columns: check if z_base_mm and z_top_mm are set and non-trivial
        cols_at_zero = 0
        for col in members.get("columns", []):
            zb = col.get("z_base_mm", col.get("z_base", 0))
            zt = col.get("z_top_mm", col.get("z_top", 0))
            h = col.get("height_mm", 0)
            if not h or int(float(h)) < 100:
                cid = col.get("id") or col.get("mark", "?")
                issues.append({
                    "element_id": cid,
                    "type": "zero_height",
                    "expected_z_mm": 3500,
                    "got_z_mm": 0,
                    "action": "set_z",
                })
                cols_at_zero += 1

        if cols_at_zero > 0:
            print(f"    [ARR-3D] {cols_at_zero} columns with height=0 detected")

        # Beams: check if any have z=0 when columns have non-zero z
        col_zbase_vals = [
            int(float(c.get("z_base_mm", c.get("z_base", 0)) or 0))
            for c in members.get("columns", [])
            if c.get("z_base_mm") or c.get("z_base")
        ]
        has_elevated_cols = bool(col_zbase_vals and max(col_zbase_vals) > 0)

        for beam in members.get("beams", []):
            bz = beam.get("z_mm") or beam.get("z", 0)
            if not bz and has_elevated_cols:
                issues.append({
                    "element_id": beam.get("id", "?"),
                    "type": "beam_z_missing",
                    "expected_z_mm": None,
                    "got_z_mm": 0,
                    "action": "set_z",
                })

        return issues

    def _build_model_excerpt(self, model: dict) -> str:
        """Build a concise model excerpt for page review prompts."""
        members = model.get("members", {})
        excerpt = {
            "levels": model.get("levels", []),
            "grid_system": {
                k: v for k, v in model.get("grid_system", {}).items()
                if k in ("x_axes", "y_axes", "spacing_x_mm", "spacing_y_mm", "x_coords", "y_coords")
            },
            "member_counts": {
                k: len(v) for k, v in members.items()
            },
            "columns_sample": members.get("columns", [])[:10],
            "beams_sample": members.get("beams", [])[:10],
            "footings": members.get("footings", []),
        }
        s = json.dumps(excerpt, indent=2, ensure_ascii=False)
        if len(s) > MAX_MODEL_EXCERPT:
            s = s[:MAX_MODEL_EXCERPT] + "\n...(truncated)"
        return s

    def _get_page_text(self, page_texts: dict, idx) -> str:
        """Get page text by index (handles str or int keys)."""
        pt = page_texts.get(str(idx)) or page_texts.get(idx) or ""
        return pt[:MAX_TEXT_PER_PAGE] if pt else ""

    def _parse_json(self, response: str):
        if not response:
            return None
        try:
            return json.loads(response)
        except json.JSONDecodeError:
            pass
        m = re.search(r'```(?:json)?\s*([\s\S]*?)```', response)
        if m:
            try:
                return json.loads(m.group(1))
            except json.JSONDecodeError:
                pass
        for oc, cc in [('{', '}'), ('[', ']')]:
            s = response.find(oc)
            e = response.rfind(cc)
            if s >= 0 and e > s:
                try:
                    return json.loads(response[s:e+1])
                except json.JSONDecodeError:
                    pass
        return None
