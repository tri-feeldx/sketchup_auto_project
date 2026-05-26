"""
Structured per-agent logger.
Works with pipeline_v8's TeeStream (stdout redirect) — just wraps print().
Usage:
    log = AgentLogger("GTB")
    log.info("Grid X: 7 lines")
    log.warn("Level real = 0")
    log.stat("grid_x_count", 7)
    log.stat("level_real", 0)
    log.summary(gates={"grid_axes≥33": False, "confidence≥0.7": True})
"""

import time

# Quality thresholds for each stat key — used to colour ✓/✗ in summary
_PASS_THRESHOLDS: dict = {
    "grid_x_count":       (">=", 4),
    "grid_y_count":       (">=", 4),
    "level_real":         (">=", 1),
    "confidence":         (">=", 0.7),
    "section_rate":       (">=", 0.5),
    "beam_connectivity":  (">=", 0.5),
    "force_assigned_pct": ("<=", 0.25),
    "col_section_pct":    (">=", 0.5),
    "guessed_ratio":      ("<=", 0.40),
    "null_section_rate":  ("<=", 0.20),
    "visual_sim":         (">=", 0.25),
}

_BOX_WIDTH = 62


def _is_pass(key: str, value) -> bool:
    if key not in _PASS_THRESHOLDS:
        return True
    op, threshold = _PASS_THRESHOLDS[key]
    try:
        v = float(value)
        if op == ">=":
            return v >= threshold
        if op == "<=":
            return v <= threshold
    except (TypeError, ValueError):
        pass
    return True


def _fmt_value(v) -> str:
    if isinstance(v, float):
        if 0.0 <= v <= 1.0:
            return f"{v*100:.0f}%"
        return f"{v:.1f}"
    return str(v)


class AgentLogger:
    """Per-agent structured logger with summary box."""

    def __init__(self, name: str):
        self.name = name
        self._stats: dict = {}
        self._warns: list[str] = []
        self._errors: list[str] = []
        self._t0: float = time.monotonic()

    def info(self, msg: str) -> None:
        print(f"  [{self.name}] {msg}")

    def warn(self, msg: str) -> None:
        self._warns.append(msg)
        print(f"  [{self.name}] WARN: {msg}")

    def error(self, msg: str) -> None:
        self._errors.append(msg)
        print(f"  [{self.name}] ERROR: {msg}")

    def stat(self, key: str, value) -> None:
        self._stats[key] = value

    def summary(self, gates: dict | None = None) -> None:
        elapsed = time.monotonic() - self._t0
        inner = _BOX_WIDTH - 2

        title = f" {self.name} SUMMARY ({elapsed:.1f}s) "
        dashes = _BOX_WIDTH - len(title) - 2
        print(f"\n  ┌─{title}{'─' * dashes}┐")

        # Stats — two per row
        items = list(self._stats.items())
        for i in range(0, len(items), 2):
            left_k, left_v = items[i]
            icon_l = "✓" if _is_pass(left_k, left_v) else "✗"
            left_str = f"{icon_l} {left_k}: {_fmt_value(left_v)}"
            if i + 1 < len(items):
                right_k, right_v = items[i + 1]
                icon_r = "✓" if _is_pass(right_k, right_v) else "✗"
                right_str = f"{icon_r} {right_k}: {_fmt_value(right_v)}"
            else:
                right_str = ""
            row = f"  {left_str:<28}  {right_str:<28}"
            print(f"  │{row[:inner]:<{inner}}│")

        # Quality gates
        if gates:
            print(f"  │{'─' * inner}│")
            for gate_name, passed in gates.items():
                icon = "✓" if passed else "✗ FAIL"
                row = f"  {icon} Gate: {gate_name}"
                print(f"  │{row:<{inner}}│")

        # Warnings/errors summary
        if self._warns or self._errors:
            print(f"  │{'─' * inner}│")
            for w in self._warns[:3]:
                row = f"  WARN: {w[:inner - 8]}"
                print(f"  │{row:<{inner}}│")
            if len(self._warns) > 3:
                row = f"  ... +{len(self._warns) - 3} more warnings"
                print(f"  │{row:<{inner}}│")
            for e in self._errors:
                row = f"  ERROR: {e[:inner - 9]}"
                print(f"  │{row:<{inner}}│")

        wc = len(self._warns)
        ec = len(self._errors)
        footer = f"  Warnings: {wc}  Errors: {ec}"
        print(f"  │{footer:<{inner}}│")
        print(f"  └{'─' * _BOX_WIDTH}┘\n")


def stage_header(stage_id: str, name: str) -> float:
    """Print a stage divider header. Returns start time (pass to stage_footer)."""
    print(f"\n{'═' * 66}")
    print(f"  STAGE {stage_id}: {name}")
    print(f"{'─' * 66}")
    return time.monotonic()


def stage_footer(stage_id: str, t0: float, gate_pass: bool) -> None:
    """Print a stage divider footer."""
    elapsed = time.monotonic() - t0
    icon = "✅" if gate_pass else "❌"
    print(f"{'─' * 66}")
    print(f"  {icon} STAGE {stage_id} complete ({elapsed:.1f}s)")
    print(f"{'═' * 66}\n")
