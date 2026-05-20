"""
=============================================================================
ARR-2: CODE REVIEWER — Ruby Script Validation & Auto-Fix
=============================================================================
Reviews the generated SketchUp Ruby script for correctness:
  1. Static analysis — broken references, malformed geometry, missing wrappers
  2. LLM auto-fix — sends issues + script excerpt to LLM for correction

Output:
  {
    "verdict": "OK" | "ISSUES_FOUND",
    "issues": [{"line": 42, "type": "missing_ref", "description": "..."}],
    "fixed_script": "...",   # corrected Ruby if fixable, else None
    "confidence": 0.0–1.0,
  }
=============================================================================
"""

import re
import json
from typing import Optional

from core.llm_wrapper import call_llm

MAX_SCRIPT_CHARS_FOR_LLM = 12000
STATIC_ISSUE_THRESHOLD = 3   # Run LLM only if >= N static issues OR ruby_val failed


class CodeReviewer:
    """
    ARR-2: Static + LLM review of SketchUp Ruby scripts.
    Tries to auto-fix common issues and return a corrected script.
    """

    def __init__(self, region: str = "au"):
        self.region = region

    def review(
        self,
        ruby_script: str,
        structural_model: dict,
        ruby_validation_passed: bool = True,
    ) -> dict:
        """
        Step 1: Static analysis.
        Step 2: LLM fix if issues found or ruby_validation_passed is False.
        """
        issues = self._static_analysis(ruby_script, structural_model)

        needs_llm = len(issues) >= STATIC_ISSUE_THRESHOLD or not ruby_validation_passed

        fixed_script = None
        confidence = 0.95 if not issues else 0.6

        if needs_llm and issues:
            print(f"    [ARR-2] {len(issues)} static issue(s) found — running LLM fix...")
            fixed_script = self._llm_fix(ruby_script, issues, structural_model)
            if fixed_script:
                # Verify fix reduced issues
                post_issues = self._static_analysis(fixed_script, structural_model)
                if len(post_issues) < len(issues):
                    confidence = 0.85
                    print(f"    [ARR-2] Fix reduced issues: {len(issues)} → {len(post_issues)}")
                else:
                    fixed_script = None  # Fix didn't help
                    print(f"    [ARR-2] Fix did not reduce issues — discarding")
        elif not ruby_validation_passed and not issues:
            # RubyValidator failed but static found nothing: do LLM review anyway
            print(f"    [ARR-2] RubyValidator failed — LLM review without static issues...")
            fixed_script = self._llm_fix(ruby_script, [], structural_model)
            confidence = 0.7

        verdict = "ISSUES_FOUND" if (issues or not ruby_validation_passed) else "OK"

        return {
            "verdict": verdict,
            "issues": issues,
            "fixed_script": fixed_script,
            "confidence": confidence,
        }

    def _static_analysis(self, script: str, structural_model: dict) -> list:
        """Fast regex-based static checks."""
        issues = []
        lines = script.splitlines()

        # 1. Extract declared col_positions keys
        col_ids = set(re.findall(r'col_positions\["([^"]+)"\]\s*=', script))

        # 2. Beam references to undefined columns
        for i, line in enumerate(lines, 1):
            m = re.search(r'col_positions\["([^"]+)"\]', line)
            if m:
                cid = m.group(1)
                if col_ids and cid not in col_ids:
                    issues.append({
                        "line": i,
                        "type": "missing_col_ref",
                        "description": f"col_positions[\"{cid}\"] used but never defined",
                    })

        # 3. Check model.start_operation / model.commit_operation pair
        has_start = "model.start_operation" in script
        has_commit = "model.commit_operation" in script
        if has_start and not has_commit:
            issues.append({
                "line": 0,
                "type": "missing_commit",
                "description": "model.start_operation found but model.commit_operation missing",
            })
        if has_commit and not has_start:
            issues.append({
                "line": 0,
                "type": "missing_start",
                "description": "model.commit_operation found but model.start_operation missing",
            })

        # 4. Zero-height or negative geometry (common crash cause)
        for i, line in enumerate(lines, 1):
            m = re.search(r'\.mm\s*\*\s*(-?\d+(?:\.\d+)?)', line)
            if m:
                val = float(m.group(1))
                if val <= 0:
                    issues.append({
                        "line": i,
                        "type": "zero_or_neg_dimension",
                        "description": f"Non-positive dimension ({val}) may crash SketchUp",
                    })

        # 5. entities variable before definition
        for i, line in enumerate(lines, 1):
            if "entities.add_" in line:
                prefix = "\n".join(lines[max(0, i - 20):i])
                if "entities" not in prefix or ("= model.active_entities" not in prefix
                                                 and "= grp.entities" not in prefix):
                    issues.append({
                        "line": i,
                        "type": "entities_undefined",
                        "description": "entities.add_* called but 'entities' may not be defined in scope",
                    })
                    break  # Report once

        # 6. pushpull(0) — extrudes nothing, may cause empty geometry
        for i, line in enumerate(lines, 1):
            m = re.search(r'\.pushpull\(\s*(-?0\.?0*)\s*\)', line)
            if m:
                issues.append({
                    "line": i,
                    "type": "zero_pushpull",
                    "description": f"pushpull(0) creates no geometry — element will be invisible",
                })

        # 7. Duplicate points in add_face — detect when w or d suffix = 0
        # Pattern: pts array where ox+N appears twice with the same Y value
        for i, line in enumerate(lines, 1):
            if "add_face(pts_" in line:
                # Look back up to 8 lines for the pts array
                block = "\n".join(lines[max(0, i - 9):i])
                y_vals = re.findall(r'oy\+(\d+)', block)
                if y_vals:
                    # If all Y values are identical → collinear → degenerate face
                    if len(set(y_vals)) == 1 and len(y_vals) >= 3:
                        issues.append({
                            "line": i,
                            "type": "degenerate_face",
                            "description": f"add_face near line {i}: all Y coords identical — collinear points will crash",
                        })

        # 8. Negative pushpull with potential overflow
        for i, line in enumerate(lines, 1):
            m = re.search(r'\.pushpull\(\s*-(\d+)\s*\)', line)
            if m:
                val = int(m.group(1))
                if val > 100000:
                    issues.append({
                        "line": i,
                        "type": "extreme_pushpull",
                        "description": f"pushpull(-{val}) is extremely large (>{100000}mm) — may be unit error",
                    })

        # Deduplicate by (line, type)
        seen = set()
        unique = []
        for iss in issues:
            key = (iss["line"], iss["type"])
            if key not in seen:
                seen.add(key)
                unique.append(iss)

        return unique[:20]  # Cap to avoid overwhelming LLM

    def _llm_fix(
        self,
        ruby_script: str,
        issues: list,
        structural_model: dict,
    ) -> Optional[str]:
        """Send script + issues to LLM and ask for corrected Ruby."""
        region_hint = {
            "au": "AS/NZS structural standards.",
            "vn": "TCVN standards.",
            "intl": "Eurocode standards.",
        }.get(self.region, "")

        m = structural_model.get("members", {})
        model_counts = (
            f"Model: {len(m.get('columns',[]))}c "
            f"{len(m.get('beams',[]))}b "
            f"{len(m.get('footings',[]))}f "
            f"{len(m.get('bracing',[]))}br"
        )

        issues_text = json.dumps(issues, indent=2) if issues else "RubyValidator reported entity count mismatch."

        system = (
            "You are a Senior Ruby/SketchUp developer and structural engineer. "
            f"{region_hint}\n"
            "Fix the SketchUp Ruby script so it correctly generates the 3D structural model.\n"
            "Rules:\n"
            "- Keep ALL elements (columns, beams, footings, bracing)\n"
            "- Do NOT truncate or summarize — return the COMPLETE fixed script\n"
            "- Fix only what is broken; don't restructure unnecessarily\n"
            "- Output ONLY the Ruby code, no explanations, no markdown fences"
        )

        script_excerpt = ruby_script[:MAX_SCRIPT_CHARS_FOR_LLM]
        truncated = len(ruby_script) > MAX_SCRIPT_CHARS_FOR_LLM
        if truncated:
            script_excerpt += f"\n# ... [{len(ruby_script) - MAX_SCRIPT_CHARS_FOR_LLM} chars truncated]"

        user = (
            f"STRUCTURAL MODEL: {model_counts}\n\n"
            f"STATIC ISSUES FOUND:\n{issues_text}\n\n"
            f"RUBY SCRIPT {'(truncated)' if truncated else ''}:\n{script_excerpt}\n\n"
            "Return the complete corrected Ruby script."
        )

        try:
            resp = call_llm(user, system=system)
            if resp and len(resp.strip()) > 100:
                # Strip markdown fences if present
                cleaned = re.sub(r'^```(?:ruby)?\s*', '', resp.strip(), flags=re.MULTILINE)
                cleaned = re.sub(r'\s*```\s*$', '', cleaned.strip(), flags=re.MULTILINE)
                return cleaned.strip()
        except Exception as e:
            print(f"    [ARR-2 WARN] LLM fix error: {e}")

        return None
