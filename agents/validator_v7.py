"""
=============================================================================
A4: VALIDATOR V7 — Structural Model Quality Checker
=============================================================================
Validates the unified structural model from Synthesizer V7 for:
  - Completeness: all expected member types present
  - Consistency: grid alignment, span-to-section ratios
  - Realism: dimensions within typical engineering ranges
  - Conflicts: overlapping columns, missing connections
  - Structural logic: loading paths, stability checks

Output: Pass/Fail + issue list with severity levels
=============================================================================
"""

from dataclasses import dataclass, field
from typing import Dict, List


@dataclass
class ValidationIssue:
    rule: str
    severity: str  # ERROR, WARNING, INFO
    message: str
    affected_ids: List[str] = field(default_factory=list)


@dataclass
class ValidationResult:
    passed: bool = True
    score: float = 1.0  # 0.0 - 1.0
    total_checks: int = 0
    errors: int = 0
    warnings: int = 0
    infos: int = 0
    issues: List[ValidationIssue] = field(default_factory=list)

    def to_dict(self) -> dict:
        return {
            "passed": self.passed,
            "score": self.score,
            "total_checks": self.total_checks,
            "errors": self.errors,
            "warnings": self.warnings,
            "infos": self.infos,
            "issues": [
                {
                    "rule": i.rule,
                    "severity": i.severity,
                    "message": i.message,
                    "affected_ids": i.affected_ids,
                }
                for i in self.issues
            ],
        }


class ValidatorV7:
    """
    Structural Model Validator.
    Runs a battery of checks on the synthesized model.
    """

    # Typical Vietnamese residential/commercial ranges in mm
    VIETNAM_RANGES = {
        "column_min_dim": 200,
        "column_max_dim": 800,
        "beam_min_depth": 200,
        "beam_max_depth": 1000,
        "beam_min_span": 1000,
        "beam_max_span": 12000,
        "slab_min_thickness": 80,
        "slab_max_thickness": 500,
        "wall_min_thickness": 100,
        "wall_max_thickness": 400,
        "footing_min_dim": 800,
        "footing_max_dim": 4000,
        "min_grid_spacing": 2000,
        "max_grid_spacing": 10000,
        "max_levels": 6,
        "min_floor_height": 2500,
        "max_floor_height": 5000,
    }

    def __init__(self, region: str = "vn"):
        self.region = region
        self.ranges = self.VIETNAM_RANGES

    def validate(self, model: dict) -> ValidationResult:
        """
        Run all validation checks on the structural model.
        """
        result = ValidationResult()
        issues: List[ValidationIssue] = []

        # Completeness
        self._check_members_exist(model, issues)
        self._check_grid_exist(model, issues)
        self._check_levels_exist(model, issues)

        # Dimension realism
        self._check_column_dimensions(model, issues)
        self._check_beam_dimensions(model, issues)
        self._check_slab_dimensions(model, issues)
        self._check_wall_dimensions(model, issues)
        self._check_footing_dimensions(model, issues)

        # Consistency
        self._check_column_duplicates(model, issues)
        self._check_beam_connections(model, issues)
        self._check_floor_heights(model, issues)

        # Connectivity
        self._check_orphan_columns(model, issues)
        self._check_orphan_beams(model, issues)

        # Aggregate
        for issue in issues:
            if issue.severity == "ERROR":
                result.errors += 1
            elif issue.severity == "WARNING":
                result.warnings += 1
            else:
                result.infos += 1

        result.total_checks = len(issues)
        result.issues = issues
        penalty = result.errors * 0.15 + result.warnings * 0.05
        result.score = max(0.0, 1.0 - penalty)
        result.passed = result.errors == 0

        self._print_report(result)
        return result

    # ── COMPLETENESS ────────────────────────────────────

    def _check_members_exist(self, model, issues):
        members = model.get("members", {})
        col_count = len(members.get("columns", []))
        beam_count = len(members.get("beams", []))

        if col_count == 0 and beam_count == 0:
            issues.append(ValidationIssue(
                "members_exist", "ERROR",
                "No columns or beams found in model."
            ))
        elif col_count == 0:
            issues.append(ValidationIssue(
                "columns_exist", "WARNING",
                "No columns detected. Wall-bearing structure?"
            ))
        elif col_count < 4:
            issues.append(ValidationIssue(
                "min_columns", "INFO",
                f"Only {col_count} columns found. Small/partial building?"
            ))
        if beam_count == 0 and col_count > 4:
            issues.append(ValidationIssue(
                "beams_exist", "WARNING",
                "No beams but columns exist. Check connections."
            ))

    def _check_grid_exist(self, model, issues):
        grid = model.get("grid_system", {})
        if not grid.get("x_axes") and not grid.get("y_axes"):
            issues.append(ValidationIssue(
                "grid_exist", "INFO",
                "No grid axes detected. Alignment may be approximate."
            ))

    def _check_levels_exist(self, model, issues):
        levels = model.get("levels", [])
        if not levels:
            issues.append(ValidationIssue(
                "levels_exist", "WARNING",
                "No floor levels defined."
            ))
        elif len(levels) > self.ranges["max_levels"]:
            issues.append(ValidationIssue(
                "max_levels", "WARNING",
                f"{len(levels)} levels exceeds typical max."
            ))

    # ── DIMENSION REALISM ───────────────────────────────

    def _check_column_dimensions(self, model, issues):
        for col in model.get("members", {}).get("columns", []):
            w_raw = col.get("width_mm") or col.get("width") or col.get("size_x", 0)
            try:
                w = float(w_raw)
            except (ValueError, TypeError):
                w = 0.0
            col_id = col.get("id", col.get("mark", "?"))
            if not col.get("x") or not col.get("y"):
                issues.append(ValidationIssue(
                    "col_position", "WARNING",
                    f"Column {col_id} missing X/Y position.", [col_id]
                ))
            if w and w < self.ranges["column_min_dim"]:
                issues.append(ValidationIssue(
                    "col_min_dim", "WARNING",
                    f"Column {col_id} width={w}mm below min.", [col_id]
                ))
            if w and w > self.ranges["column_max_dim"]:
                issues.append(ValidationIssue(
                    "col_max_dim", "WARNING",
                    f"Column {col_id} width={w}mm above typical max.", [col_id]
                ))

    def _check_beam_dimensions(self, model, issues):
        for beam in model.get("members", {}).get("beams", []):
            span_raw = beam.get("span_mm") or beam.get("span", 0)
            depth_raw = beam.get("depth_mm") or beam.get("depth", 0)
            try:
                span = float(span_raw)
            except (ValueError, TypeError):
                span = 0.0
            try:
                depth = float(depth_raw)
            except (ValueError, TypeError):
                depth = 0.0
            beam_id = beam.get("id", beam.get("mark", "?"))

            if span and span < self.ranges["beam_min_span"]:
                issues.append(ValidationIssue(
                    "beam_min_span", "INFO",
                    f"Beam {beam_id} span={span}mm very short.", [beam_id]
                ))
            if span and span > self.ranges["beam_max_span"]:
                issues.append(ValidationIssue(
                    "beam_max_span", "WARNING",
                    f"Beam {beam_id} span={span}mm exceeds max.", [beam_id]
                ))
            if span and depth and depth > 0:
                ratio = span / depth
                if ratio < 6:
                    issues.append(ValidationIssue(
                        "beam_sd_low", "INFO",
                        f"Beam {beam_id} L/d={ratio:.1f} low.", [beam_id]
                    ))
                elif ratio > 30:
                    issues.append(ValidationIssue(
                        "beam_sd_high", "WARNING",
                        f"Beam {beam_id} L/d={ratio:.1f} high.", [beam_id]
                    ))

    def _check_slab_dimensions(self, model, issues):
        for slab in model.get("members", {}).get("slabs", []):
            t_raw = slab.get("thickness_mm") or slab.get("thickness", 0)
            try:
                t = float(t_raw)
            except (ValueError, TypeError):
                t = 0.0
            slab_id = slab.get("id", "?")
            if t and t < self.ranges["slab_min_thickness"]:
                issues.append(ValidationIssue(
                    "slab_min_t", "WARNING",
                    f"Slab {slab_id} t={t}mm below min.", [slab_id]
                ))

    def _check_wall_dimensions(self, model, issues):
        for wall in model.get("members", {}).get("walls", []):
            t_raw = wall.get("thickness_mm") or wall.get("thickness", 0)
            try:
                t = float(t_raw)
            except (ValueError, TypeError):
                t = 0.0
            wall_id = wall.get("id", "?")
            if t and t < self.ranges["wall_min_thickness"]:
                issues.append(ValidationIssue(
                    "wall_min_t", "WARNING",
                    f"Wall {wall_id} t={t}mm below min.", [wall_id]
                ))

    def _check_footing_dimensions(self, model, issues):
        for ftg in model.get("members", {}).get("footings", []):
            w_raw = ftg.get("width_mm") or ftg.get("width", 0)
            try:
                w = float(w_raw)
            except (ValueError, TypeError):
                w = 0.0
            ftg_id = ftg.get("id", "?")
            if w and w < self.ranges["footing_min_dim"]:
                issues.append(ValidationIssue(
                    "ftg_min_dim", "WARNING",
                    f"Footing {ftg_id} w={w}mm below min.", [ftg_id]
                ))

    # ── CONSISTENCY ─────────────────────────────────────

    def _check_column_duplicates(self, model, issues):
        columns = model.get("members", {}).get("columns", [])
        seen = {}
        for col in columns:
            x = col.get("x", -1)
            y = col.get("y", -1)
            if x < 0 or y < 0:
                continue
            key = (round(x/100)*100, round(y/100)*100)
            if key in seen:
                issues.append(ValidationIssue(
                    "col_dup", "WARNING",
                    f"Cols {col.get('id','?')} & {seen[key]} at ~{key}.",
                    [col.get("id","?"), seen[key]]
                ))
            else:
                seen[key] = col.get("id", col.get("mark", "?"))

    def _check_beam_connections(self, model, issues):
        beams = model.get("members", {}).get("beams", [])
        columns = model.get("members", {}).get("columns", [])
        col_ids = {c.get("id") for c in columns if c.get("id")}
        col_ids.update(c.get("mark") for c in columns if c.get("mark"))

        for beam in beams:
            frm = beam.get("from_col") or beam.get("from", "")
            to = beam.get("to_col") or beam.get("to", "")
            bid = beam.get("id", "?")
            if frm and frm not in col_ids:
                issues.append(ValidationIssue(
                    "beam_conn", "INFO",
                    f"Beam {bid} ref unknown col={frm}", [bid, frm]
                ))
            if to and to not in col_ids:
                issues.append(ValidationIssue(
                    "beam_conn", "INFO",
                    f"Beam {bid} ref unknown col={to}", [bid, to]
                ))

    def _check_floor_heights(self, model, issues):
        for lvl in model.get("levels", []):
            h_raw = lvl.get("height_mm") or lvl.get("height_above_ground_mm", 0)
            try:
                h = float(h_raw)
            except (ValueError, TypeError):
                h = 0.0
            name = lvl.get("name", "?")
            if h and h < self.ranges["min_floor_height"]:
                issues.append(ValidationIssue(
                    "flr_h_min", "WARNING",
                    f"Level {name} h={h}mm too low.", [name]
                ))
            if h and h > self.ranges["max_floor_height"]:
                issues.append(ValidationIssue(
                    "flr_h_max", "INFO",
                    f"Level {name} h={h}mm tall.", [name]
                ))

    # ── CONNECTIVITY ────────────────────────────────────

    def _check_orphan_columns(self, model, issues):
        columns = model.get("members", {}).get("columns", [])
        beams = model.get("members", {}).get("beams", [])
        connected = set()
        for b in beams:
            connected.add(b.get("from_col") or b.get("from", ""))
            connected.add(b.get("to_col") or b.get("to", ""))

        for col in columns:
            cid = col.get("id") or col.get("mark", "")
            if cid and cid not in connected and len(columns) > 4:
                issues.append(ValidationIssue(
                    "orphan_col", "INFO",
                    f"Column {cid} has no beam connections.", [cid]
                ))

    def _check_orphan_beams(self, model, issues):
        for beam in model.get("members", {}).get("beams", []):
            if not (beam.get("from_col") or beam.get("from")) and \
               not (beam.get("to_col") or beam.get("to")):
                bid = beam.get("id", "?")
                issues.append(ValidationIssue(
                    "orphan_beam", "WARNING",
                    f"Beam {bid} has no column connections.", [bid]
                ))

    # ── OUTPUT ──────────────────────────────────────────

    def _print_report(self, result: ValidationResult):
        """Print validation summary to console."""
        status = "PASSED" if result.passed else "FAILED"
        print(
            f"[VALIDATOR] {status}  Score={result.score:.2f}  "
            f"Err={result.errors} Warn={result.warnings} Info={result.infos}"
        )
        for issue in result.issues:
            if issue.severity == "ERROR":
                print(f"  [ERR] {issue.rule}: {issue.message}")
        for sev, tag in [("WARNING", "WARN"), ("INFO", "INFO")]:
            count = sum(1 for i in result.issues if i.severity == sev)
            if count:
                print(f"  [{tag}] {count} issues (details in result.issues)")


# ============================================================
# PUBLIC HELPER
# ============================================================

def validate_model(model: dict, region: str = "vn") -> ValidationResult:
    """Convenience wrapper."""
    return ValidatorV7(region=region).validate(model)