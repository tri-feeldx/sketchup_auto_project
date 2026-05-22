"""
B2: RUBY VALIDATOR — SketchUp Ruby Script Quality Gate.
Checks generated .rb scripts for safety, correctness, and performance.
Optionally runs rubocop-sketchup if Ruby is installed (graceful fallback).
"""

import json
import os
import re
import shutil
import subprocess
import tempfile
from dataclasses import dataclass, field
from typing import List


@dataclass
class RubyIssue:
    rule: str
    severity: str  # ERROR, WARNING, INFO
    line: int
    message: str


@dataclass
class RubyValidationResult:
    passed: bool = True
    line_count: int = 0
    estimated_entities: int = 0
    errors: int = 0
    warnings: int = 0
    issues: List[RubyIssue] = field(default_factory=list)

    def to_dict(self) -> dict:
        return {
            "passed": self.passed,
            "line_count": self.line_count,
            "estimated_entities": self.estimated_entities,
            "errors": self.errors,
            "warnings": self.warnings,
            "issues": [
                {"rule": i.rule, "severity": i.severity, "line": i.line, "message": i.message}
                for i in self.issues
            ],
        }


class RubyValidator:
    """
    Validates generated Ruby scripts before SketchUp execution.
    Checks: syntax safety, entity limits, VN-specific patterns.
    """

    MAX_LINES = 50_000
    MAX_ENTITIES_EST = 20_000
    FORBIDDEN_CALLS = [
        "system(", "exec(", "eval(", "`", "%x(",
        "require 'net/", "require 'socket'",
        "File.delete", "File.unlink", "Dir.rmdir",
        "UI.menu", "UI.add_context_menu_handler",
    ]
    SUSPICIOUS_SHORTCUTS = {
        r"\.each\s*\{\s*\|": "Loop may be slow; consider batching",
        r"ents\.add_face\(\)": "add_face() without arguments",
    }
    REQUIRED_METHODS = [
        "start_operation", "commit_operation",
    ]
    # SketchUp API calls deprecated since SU2020+ — rubocop-sketchup SketchupDeprecations
    DEPRECATED_CALLS = [
        ("Sketchup.active_model.materials.current=", "Use material= on entities directly"),
        ("view.draw_points(", "Deprecated in SU2020 — use view.draw() with GL_POINTS"),
        (".selected_page=", "Use model.pages.selected= instead"),
        ("model.shadow_info[", "Use model.shadow_info.set_value() instead"),
    ]

    def __init__(self, region="vn"):
        self.region = region

    def validate(self, ruby_script: str) -> RubyValidationResult:
        result = RubyValidationResult()

        if not ruby_script or not ruby_script.strip():
            result.issues.append(RubyIssue("empty", "ERROR", 0, "Script is empty"))
            result.errors = 1
            result.passed = False
            return result

        lines = ruby_script.split("\n")
        result.line_count = len(lines)

        # Size check
        self._check_size(result, lines)

        # Forbidden calls
        self._check_forbidden(result, ruby_script)

        # SketchUp API safety
        self._check_api_safety(result, ruby_script)

        # Entity count estimation
        result.estimated_entities = self._estimate_entities(ruby_script)
        self._check_entity_limit(result, result.estimated_entities)

        # Transaction wrapping
        self._check_transactions(result, ruby_script)

        # SketchUp deprecated API calls
        self._check_deprecated(result, ruby_script)

        # Region-specific checks
        if self.region == "vn":
            self._check_vn_patterns(result, ruby_script)

        # Optional: rubocop-sketchup (if Ruby installed)
        self._check_rubocop_sketchup(result, ruby_script)

        # Aggregate
        for issue in result.issues:
            if issue.severity == "ERROR":
                result.errors += 1
            elif issue.severity == "WARNING":
                result.warnings += 1

        result.passed = result.errors == 0
        return result

    # ── SIZE ───────────────────────────────────────────

    def _check_size(self, result: RubyValidationResult, lines: List[str]):
        if result.line_count > self.MAX_LINES:
            result.issues.append(RubyIssue(
                "max_lines", "ERROR", 0,
                f"Script has {result.line_count} lines (max {self.MAX_LINES})"
            ))
        elif result.line_count > self.MAX_LINES * 0.7:
            result.issues.append(RubyIssue(
                "large_script", "WARNING", 0,
                f"Script is large ({result.line_count} lines), may slow SketchUp"
            ))

    # ── FORBIDDEN ──────────────────────────────────────

    def _check_forbidden(self, result: RubyValidationResult, script: str):
        for call in self.FORBIDDEN_CALLS:
            if call in script:
                line_no = script[:script.find(call)].count("\n") + 1
                result.issues.append(RubyIssue(
                    "forbidden_call", "ERROR", line_no,
                    f"Forbidden Ruby call: '{call}' (security risk)"
                ))

    # ── API SAFETY ─────────────────────────────────────

    def _check_api_safety(self, result: RubyValidationResult, script: str):
        # Check Sketchup.active_model usage
        if "Sketchup.active_model" not in script:
            result.issues.append(RubyIssue(
                "no_model_ref", "WARNING", 1,
                "No reference to Sketchup.active_model — script may not target the current model"
            ))

        # Check for add_face without error handling
        face_calls = [m.start() for m in re.finditer(r"\.add_face\(", script)]
        if face_calls:
            # Check if there's exception handling
            has_rescue = "rescue" in script or "begin" in script
            if not has_rescue and len(face_calls) > 50:
                result.issues.append(RubyIssue(
                    "no_error_handling", "WARNING", 0,
                    "No begin/rescue blocks found; many add_face calls may fail silently"
                ))

        # Check suspicious shortcuts
        for pattern, desc in self.SUSPICIOUS_SHORTCUTS.items():
            matches = list(re.finditer(pattern, script))
            if matches:
                result.issues.append(RubyIssue(
                    "suspicious_pattern", "WARNING", 0,
                    f"Found {len(matches)} '{pattern}': {desc}"
                ))

    # ── ENTITY COUNT ───────────────────────────────────

    def _estimate_entities(self, script: str) -> int:
        """Rough entity count from Ruby API calls."""
        count = 0
        count += len(re.findall(r"\.add_face\(", script))
        count += len(re.findall(r"\.add_line\(", script))
        count += len(re.findall(r"\.add_cline\(", script))
        count += len(re.findall(r"\.pushpull\(", script))
        count += len(re.findall(r"\.add_group\(", script))
        count += len(re.findall(r"\.add_instance\(", script))
        return max(count, 1)

    def _check_entity_limit(self, result: RubyValidationResult, count: int):
        if count > self.MAX_ENTITIES_EST:
            result.issues.append(RubyIssue(
                "entity_limit", "ERROR", 0,
                f"Estimated {count} entities exceeds limit {self.MAX_ENTITIES_EST}"
            ))
        elif count > self.MAX_ENTITIES_EST * 0.6:
            result.issues.append(RubyIssue(
                "entity_warning", "WARNING", 0,
                f"Estimated {count} entities — performance may degrade"
            ))

    # ── TRANSACTION WRAPPING ───────────────────────────

    def _check_transactions(self, result: RubyValidationResult, script: str):
        if "start_operation" not in script:
            result.issues.append(RubyIssue(
                "no_transaction_start", "WARNING", 0,
                "No model.start_operation() — no undo support"
            ))
        if "commit_operation" not in script:
            result.issues.append(RubyIssue(
                "no_transaction_commit", "WARNING", 0,
                "No model.commit_operation() — transaction may leak"
            ))

    # ── DEPRECATED API CALLS ───────────────────────────

    def _check_deprecated(self, result: RubyValidationResult, script: str):
        for call, hint in self.DEPRECATED_CALLS:
            if call in script:
                line_no = script[:script.find(call)].count("\n") + 1
                result.issues.append(RubyIssue(
                    "deprecated_api", "WARNING", line_no,
                    f"Deprecated SketchUp API: '{call}' — {hint}"
                ))

    # ── RUBOCOP-SKETCHUP (optional, requires Ruby + gems) ──────────────────

    def _check_rubocop_sketchup(self, result: RubyValidationResult, ruby_script: str):
        """Run rubocop-sketchup if available. Completely non-fatal if Ruby not installed."""
        rubocop_bin = shutil.which("rubocop")
        if not rubocop_bin:
            return  # Ruby not installed — skip silently

        rubocop_yml = os.path.join(
            os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
            ".rubocop.yml"
        )

        tmp_path = None
        try:
            with tempfile.NamedTemporaryFile(
                suffix=".rb", mode="w", delete=False, encoding="utf-8"
            ) as f:
                f.write(ruby_script)
                tmp_path = f.name

            cmd = [rubocop_bin, "--format", "json", tmp_path]
            if os.path.exists(rubocop_yml):
                cmd += ["--config", rubocop_yml]

            proc = subprocess.run(cmd, capture_output=True, text=True, timeout=30)
            try:
                data = json.loads(proc.stdout)
            except json.JSONDecodeError:
                return

            for file_result in data.get("files", []):
                for offense in file_result.get("offenses", []):
                    cop = offense.get("cop_name", "rubocop")
                    raw_sev = offense.get("severity", "convention").lower()
                    sev = "ERROR" if raw_sev in ("error", "fatal") else (
                        "WARNING" if raw_sev in ("warning", "convention") else "INFO"
                    )
                    result.issues.append(RubyIssue(
                        rule=f"rubocop:{cop}",
                        severity=sev,
                        line=offense.get("location", {}).get("line", 0),
                        message=offense.get("message", "")
                    ))

            if data.get("files"):
                total = sum(len(f.get("offenses", [])) for f in data["files"])
                print(f"  [RUBOCOP] {total} offense(s) from rubocop-sketchup")

        except subprocess.TimeoutExpired:
            print("  [RUBOCOP] Timed out after 30s — skipping")
        except Exception:
            pass  # Never crash the pipeline
        finally:
            if tmp_path:
                try:
                    os.unlink(tmp_path)
                except OSError:
                    pass

    # ── VN REGION CHECKS ───────────────────────────────

    def _check_vn_patterns(self, result: RubyValidationResult, script: str):
        # Check concrete material color
        if "Color.new(180,180,180)" not in script and "Color.new(180, 180, 180)" not in script:
            result.issues.append(RubyIssue(
                "vn_concrete_color", "INFO", 0,
                "Vietnamese concrete color (180,180,180) not set explicitly"
            ))

        # Check mm units hint
        if ".mm" not in script and "meter" not in script.lower():
            result.issues.append(RubyIssue(
                "no_unit_hint", "INFO", 0,
                "No .mm conversion visible; generated in raw units"
            ))

    # ── REPORT ─────────────────────────────────────────

    def print_report(self, result: RubyValidationResult):
        status = "PASSED" if result.passed else "FAILED"
        print(f"[RUBY VAL] {status}  Lines={result.line_count}  "
              f"Entities~{result.estimated_entities}  Err={result.errors}  Warn={result.warnings}")
        for issue in result.issues:
            if issue.severity == "ERROR":
                print(f"  [ERR:L{issue.line}] {issue.rule}: {issue.message}")


def validate_ruby(ruby_script: str, region="vn") -> RubyValidationResult:
    return RubyValidator(region=region).validate(ruby_script)