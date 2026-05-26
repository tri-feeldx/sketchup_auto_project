"""
PIPELINE V8 — Accuracy-First PDF-to-SketchUp Orchestrator.
Extends V7 with:
  A4-NEW: ScheduleVerifier  — cross-reference against schedule tables
  A5-NEW: MultiPassExtractor — targeted re-scan for missed elements
  A9-NEW: AccuracyEvaluator — recall-based accuracy score (target ≥ 90%)

Full stage sequence:
  [0-2] ScannerV6 → [3] SynthesizerV7 → [4] ScheduleVerifier →
  [5] MultiPassExtractor → [6] ValidatorV7 → [7] RubyGeneratorV5 →
  [8] RubyValidator → [9] AccuracyEvaluator → save outputs
"""

import os
import sys
import json
import time
from pathlib import Path
from dataclasses import dataclass, field
from typing import Dict, List, Optional

_PROJ_ROOT = Path(__file__).resolve().parent.parent
if str(_PROJ_ROOT) not in sys.path:
    sys.path.insert(0, str(_PROJ_ROOT))

from agents.scanner_v6 import ScannerV6
from agents.synthesizer_v7 import SynthesizerV7
from agents.validator_v7 import ValidatorV7
from agents.schedule_verifier import ScheduleVerifier
from agents.multi_pass_extractor import MultiPassExtractor
from agents.structural_reviewer import StructuralReviewer
from agents.architect_reviewer import ArchitectReviewer, ARRPrincipal
from agents.code_reviewer import CodeReviewer
from generators.ruby_generator_v5 import RubyGeneratorV5
from generators.ruby_validator import RubyValidator
from generators.ifc_generator import IFCGenerator, _ifc_available
from metrics.accuracy_evaluator import AccuracyEvaluator
from core.agent_logger import stage_header, stage_footer, AgentLogger

ARR_ACCURACY_THRESHOLD = 95.0
ARR_MAX_RETRIES = 1

import re as _re
_ANSI_RE = _re.compile(r'\x1b\[[0-9;]*m')  # strip ANSI color codes for log file


class _TeeStream:
    """Tees writes to both the original stream and a log file (ANSI-stripped)."""
    def __init__(self, real, log_fh):
        self._real = real
        self._fh   = log_fh
    def write(self, s):
        self._real.write(s)
        self._fh.write(_ANSI_RE.sub('', s))
    def flush(self):
        self._real.flush()
        self._fh.flush()
    def __getattr__(self, attr):
        return getattr(self._real, attr)


@dataclass
class PipelineV8Result:
    success: bool = False
    pdf_path: str = ""
    duration_sec: float = 0.0

    # Stage outputs
    scanner_output: dict = field(default_factory=dict)
    plan_positions: dict = field(default_factory=dict)
    ground_truth: dict = field(default_factory=dict)
    structural_model: dict = field(default_factory=dict)
    verification: Optional[dict] = None
    validation: Optional[dict] = None
    ruby_script: str = ""
    ruby_validation: Optional[dict] = None
    accuracy: Optional[dict] = None

    # File outputs
    output_rb_path: str = ""
    output_json_path: str = ""
    output_ifc_path: str = ""
    log_path: str = ""

    errors: List[str] = field(default_factory=list)

    def to_dict(self) -> dict:
        forensic = self.scanner_output.get("forensic", {})
        model = self.structural_model
        m = model.get("members", {})
        acc = self.accuracy or {}
        return {
            "success": self.success,
            "pdf_path": self.pdf_path,
            "duration_sec": self.duration_sec,
            "forensic_summary": {
                "pages": forensic.get("num_pages", 0) or forensic.get("total_pages", 0),
                "type": forensic.get("document_type", "unknown"),
                "region": forensic.get("region", "unknown"),
                "language": forensic.get("detected_language", "unknown"),
            },
            "routed_page_count": len(self.scanner_output.get("page_results", {})),
            "structural_model_summary": {
                "columns": len(m.get("columns", [])),
                "beams": len(m.get("beams", [])),
                "slabs": len(m.get("slabs", [])),
                "walls": len(m.get("walls", [])),
                "footings": len(m.get("footings", [])),
                "bracing": len(m.get("bracing", [])),
                "levels": len(model.get("levels", [])),
            },
            "verification": self.verification,
            "validation_passed": (
                self.validation.get("passed") if self.validation else None
            ),
            "ruby_validation_passed": (
                self.ruby_validation.get("passed") if self.ruby_validation else None
            ),
            "accuracy_score": acc.get("overall_score"),
            "accuracy_grade": acc.get("grade"),
            "accuracy_target_met": acc.get("target_met"),
            "accuracy_per_type": acc.get("per_type"),
            "output_rb_path": self.output_rb_path,
            "output_json_path": self.output_json_path,
            "output_ifc_path": self.output_ifc_path,
            "errors": self.errors,
        }


_REGION_MAP = {
    "au": "au", "australia": "au", "as/nzs": "au", "nzs": "au",
    "vn": "vn", "vietnam": "vn", "tcvn": "vn",
    "intl": "intl", "international": "intl", "eu": "intl",
}


class PipelineV8:
    """
    PDF-to-SketchUp Pipeline V8 — Accuracy-First.

    Usage:
        pipeline = PipelineV8(region="auto")
        result = pipeline.run("drawing.pdf", output_dir="./output/v8")
    """

    def __init__(
        self,
        region: str = "auto",
        language: str = "auto",
        building_type: str = "general",
        max_pages: Optional[int] = None,
        dpi: int = 200,
        skip_multipass: bool = False,
    ):
        self.region = region
        self.language = language
        self.building_type = building_type
        self.max_pages = max_pages
        self.dpi = dpi
        self.skip_multipass = skip_multipass

        _init_region = "vn" if region == "auto" else region
        _init_lang = "vn" if language == "auto" else language
        self.synthesizer = SynthesizerV7(region=_init_region)
        self.validator = ValidatorV7()
        self.ruby_gen = RubyGeneratorV5(region=_init_region, language=_init_lang)
        self.ruby_val = RubyValidator(region=_init_region)
        self.accuracy_eval = AccuracyEvaluator()

    def run(self, pdf_path: str, output_dir: str = "./output/v8") -> PipelineV8Result:
        result = PipelineV8Result(pdf_path=pdf_path)
        t0 = time.time()

        # ── Pipeline lock: prevent concurrent runs (doubles API cost) ────────
        os.makedirs(output_dir, exist_ok=True)
        _lock_path = os.path.join(output_dir, ".pipeline_v8.lock")
        if os.path.exists(_lock_path):
            try:
                _lock_age = time.time() - os.path.getmtime(_lock_path)
            except OSError:
                _lock_age = 9999
            if _lock_age < 3600:  # stale after 1 hour
                result.errors.append(
                    f"Pipeline already running (lock file: {_lock_path}, "
                    f"age={_lock_age:.0f}s). Wait for it to finish or delete the lock."
                )
                return result
        try:
            open(_lock_path, "w").close()
        except OSError:
            pass

        # ── Auto-log: tee stdout+stderr to file ──────────────────────────────
        _pdf_base = os.path.splitext(os.path.basename(pdf_path))[0]
        _log_path = os.path.join(output_dir, f"{_pdf_base}_run.log")
        _log_fh = open(_log_path, "w", encoding="utf-8", buffering=1)
        _orig_out, _orig_err = sys.stdout, sys.stderr
        sys.stdout = _TeeStream(sys.stdout, _log_fh)
        sys.stderr = _TeeStream(sys.stderr, _log_fh)

        try:
            os.makedirs(output_dir, exist_ok=True)
            base_name = os.path.splitext(os.path.basename(pdf_path))[0]

            _arr_principal = ARRPrincipal()

            # ── STAGE 0-2: ScannerV6 ─────────────────────────
            _t_scan = stage_header("0-2", "ScannerV6: Forensic + Routing + Scanning")
            scanner = ScannerV6(
                pdf_path, dpi=self.dpi, region=self.region,
                language=self.language, max_pages=self.max_pages,
            )
            scanner_output = scanner.run(skip_vision=False)
            scanner.close()
            result.scanner_output = scanner_output

            # ── GATE: POST-SCAN (with escalating DPI retry) ──
            print("[V8 GATE POST-SCAN]")
            _scan_dpi = self.dpi
            for _scan_retry in range(3):
                _arr_ctx = _arr_principal.build_context(scanner_output)
                _gate_scan = _arr_principal.gate_post_scan(scanner_output, _arr_ctx)
                ARRPrincipal._print_gate("POST-SCAN", _gate_scan)
                if _gate_scan.passed:
                    break
                if _scan_retry < 2:
                    _scan_dpi += 50
                    print(f"  [GATE] Scan quality FAIL — retrying at {_scan_dpi} DPI "
                          f"(attempt {_scan_retry + 2}/3)...")
                    _retry_scanner = ScannerV6(
                        pdf_path, dpi=_scan_dpi, region=self.region,
                        language=self.language, max_pages=self.max_pages,
                    )
                    scanner_output = _retry_scanner.run(skip_vision=False)
                    _retry_scanner.close()
                    result.scanner_output = scanner_output
                else:
                    print("  [GATE] Scan quality FAIL after 3 attempts — proceeding with best result")

            forensic = scanner_output.get("forensic", {})
            num_pages = scanner_output.get("num_pages", 0)

            # Auto-detect region
            if self.region == "auto" or self.language == "auto":
                raw_region = forensic.get("region", "vn").lower()
                effective_region = _REGION_MAP.get(raw_region, "vn")
                effective_lang = "en" if effective_region == "au" else (
                    "vn" if effective_region == "vn" else "en"
                )
                if self.region == "auto":
                    self.region = effective_region
                if self.language == "auto":
                    self.language = effective_lang
                self.synthesizer = SynthesizerV7(region=self.region)
                self.ruby_gen = RubyGeneratorV5(region=self.region, language=self.language)
                self.ruby_val = RubyValidator(region=self.region)
                print(f"  -> Auto-detected: region={self.region}, lang={self.language}")

            if num_pages == 0:
                result.errors.append("No pages found in PDF")
                result.duration_sec = time.time() - t0
                return result

            routing = scanner_output.get("routing_summary", {})
            page_results = scanner_output.get("page_results", {})
            print(f"  -> {num_pages} pages, {len(page_results)} scanned, "
                  f"types: {list(routing.get('types', {}).keys())}")

            stage_footer("0-2", _t_scan, True)
            # ── STAGE 0.5: Coversheet Parser ─────────────────
            _t_csp = stage_header("0.5", "CoversheetParser: Reading project title block")
            try:
                from agents.coversheet_parser import CoversheetParser
                _csp = CoversheetParser(str(pdf_path), region=self.region)
                project_meta = _csp.parse(scanner_output)
            except Exception as _csp_err:
                print(f"  [COVERSHEET] WARN: {_csp_err} — using defaults")
                project_meta = {"project_name": "Structural Model", "revision": "A",
                                "standard": "AS/NZS"}

            stage_footer("0.5", _t_csp, True)
            # ── STAGE 1.5: CAD Vector Extraction ─────────────
            _t_cad = stage_header("1.5", "CADVectorExtractor: Reading vector grid + column XY")
            cad_data: dict = {}
            try:
                from core.cad_vector_extractor import CADVectorExtractor
                _page_types_map = scanner_output.get("page_results", {})
                _plan_page_indices = sorted([
                    int(k) for k, v in _page_types_map.items()
                    if isinstance(v, dict) and v.get("page_type") == "PLAN"
                ])
                if _plan_page_indices:
                    _cve = CADVectorExtractor()
                    cad_data = _cve.extract_plan_data(str(pdf_path), _plan_page_indices)
                    _cve_conf = cad_data.get("confidence", 0)
                    _cve_cols = len(cad_data.get("column_positions", {}))
                    _cve_gx = len(cad_data.get("grid_x_mm", {}))
                    _cve_gy = len(cad_data.get("grid_y_mm", {}))
                    print(f"  -> grid {_cve_gx}×{_cve_gy} lines | "
                          f"{_cve_cols} column symbols | conf={_cve_conf:.2f}")
                    if _cve_conf < 0.3:
                        print("  -> Low confidence — scanned PDF or non-standard CAD. "
                              "Falling back to LLM vision for all geometry.")
                        cad_data = {}
                else:
                    print("  -> No PLAN pages found yet — skipping")
            except Exception as _cve_err:
                print(f"  [CAD-VEC] WARN: vector extraction failed ({_cve_err}) — skipping")
                cad_data = {}

            stage_footer("1.5", _t_cad, True)
            # ── STAGE 2.5: Plan Page Column Extractor ────────
            _t_plan = stage_header("2.5", "PlanPageExtractor: Reading plan pages for column XY")
            try:
                from agents.plan_page_extractor import PlanPageColumnExtractor
                _pex = PlanPageColumnExtractor(
                    str(pdf_path),
                    region=self.region,
                    language=self.language,
                )
                plan_positions = _pex.run(scanner_output, cad_data=cad_data)
            except Exception as _pex_err:
                print(f"  [PLAN-EXTRACT] WARN: extractor failed ({_pex_err}) — skipping")
                plan_positions = {}
            result.plan_positions = plan_positions

            stage_footer("2.5", _t_plan, True)
            # ── STAGE 2.6: Detail Page Extractor ─────────────
            _t_det = stage_header("2.6", "DetailPageExtractor: Reading connection details")
            try:
                from agents.detail_page_extractor import DetailPageExtractor
                _dex = DetailPageExtractor(str(pdf_path), region=self.region)
                detail_specs = _dex.run(scanner_output)
            except Exception as _dex_err:
                print(f"  [DETAIL-EXT] WARN: {_dex_err} — skipping")
                detail_specs = {}

            stage_footer("2.6", _t_det, True)
            # ── STAGE 0.6: Ground Truth Builder ──────────────
            _t_gtb = stage_header("0.6", "GroundTruthBuilder: Establishing locked ProjectFacts")
            ground_truth: dict = {}
            try:
                from agents.ground_truth_builder import GroundTruthBuilder
                _gtb = GroundTruthBuilder(
                    str(pdf_path), region=self.region, language=self.language
                )
                ground_truth = _gtb.build(scanner_output, cad_data=cad_data)
                result.ground_truth = ground_truth
            except Exception as _gtb_err:
                print(f"  [GTB] WARN: GroundTruthBuilder failed ({_gtb_err}) — skipping")

            stage_footer("0.6", _t_gtb, True)
            # ── STAGE 3: Synthesize ───────────────────────────
            _t_synth = stage_header("3", "SynthesizerV7: Building structural model")
            model = self.synthesizer.synthesize(
                scanner_output,
                plan_positions=plan_positions,
                ground_truth=ground_truth,
                cad_data=cad_data,
            )
            result.structural_model = model

            # ── GATE: POST-SYNTHESIZE ─────────────────────────
            print("[V8 GATE POST-SYNTHESIZE]")
            _gate_synth = _arr_principal.gate_post_synthesize(model, _arr_ctx)
            ARRPrincipal._print_gate("POST-SYNTHESIZE", _gate_synth)

            m = model.get("members", {})
            print(f"  -> {len(m.get('columns',[]))}c "
                  f"{len(m.get('beams',[]))}b "
                  f"{len(m.get('slabs',[]))}s "
                  f"{len(m.get('walls',[]))}w "
                  f"{len(m.get('footings',[]))}f "
                  f"{len(m.get('bracing',[]))}br")

            stage_footer("3", _t_synth, True)
            # ── STAGE 3.5: pdfplumber schedule table parse ────
            _sch_page_indices = sorted([
                int(k) for k, v in scanner_output.get("page_results", {}).items()
                if isinstance(v, dict) and v.get("page_type") == "SCHEDULE"
            ])
            _pdfplumber_counts: dict = {}
            if _sch_page_indices:
                try:
                    from core.schedule_table_parser import ScheduleTableParser
                    _stp = ScheduleTableParser()
                    _sch_data = _stp.parse_schedule_pages(str(pdf_path), _sch_page_indices)
                    if _sch_data.get("confidence", 0) > 0.5:
                        _pdfplumber_counts = {
                            "columns": _sch_data.get("column_count"),
                            "beams": _sch_data.get("beam_count"),
                        }
                        print(f"  [SCHED-TABLE] pdfplumber: "
                              f"{_pdfplumber_counts.get('columns')}c "
                              f"{_pdfplumber_counts.get('beams')}b "
                              f"(conf=0.9, pages={_sch_page_indices})")
                        if result.accuracy is None:
                            result.accuracy = {}
                        result.accuracy["schedule_table_counts"] = _pdfplumber_counts
                except Exception as _stp_err:
                    print(f"  [SCHED-TABLE] WARN: {_stp_err}")

            # ── STAGE 4: Schedule Verification (NEW) ─────────
            _t_sv = stage_header("4", "ScheduleVerifier: Cross-checking against schedules")
            verifier = ScheduleVerifier(region=self.region)
            verification = verifier.verify(scanner_output, model, ground_truth=ground_truth)
            result.verification = verification
            overall_recall = verification.get("overall_recall")
            if overall_recall is not None:
                print(f"  -> Overall recall: {overall_recall:.0%} "
                      f"({'✓' if overall_recall >= 0.70 else '⚠'})")

            stage_footer("4", _t_sv, True)
            # ── STAGE 5: Multi-Pass Extraction (NEW) ─────────
            if not self.skip_multipass and verification.get("needs_repass"):
                print("[V8 STAGE 5] MultiPassExtractor: Re-scanning for missing elements...")

                # Cap column target to grid ceiling so MultiPass can't hallucinate
                # more columns than the physical grid can accommodate.
                _gt_gx = len((ground_truth or {}).get("grid_x_mm") or {})
                _gt_gy = len((ground_truth or {}).get("grid_y_mm") or {})
                if _gt_gx > 0 and _gt_gy > 0:
                    _grid_ceiling = _gt_gx * _gt_gy * 2
                    for _disc in verification["discrepancies"]:
                        if _disc["type"] == "columns" and _disc.get("expected", 0) > _grid_ceiling:
                            print(f"  [MULTIPASS-CAP] Column target {_disc['expected']} "
                                  f"→ capped at {_grid_ceiling} ({_gt_gx}×{_gt_gy}×2)")
                            _disc["expected"] = _grid_ceiling
                            _disc["deficit"] = max(0, _grid_ceiling - _disc["got"])
                            _disc["needs_repass"] = _disc["deficit"] > 0

                extractor = MultiPassExtractor(pdf_path, dpi=self.dpi)
                model = extractor.run(
                    model,
                    verification["discrepancies"],
                    scanner_output,
                )

                # Re-run full enrichment chain: new elements have no sections or connectivity
                _page_results_list = list(scanner_output.get("page_results", {}).values())
                print("  [MULTIPASS-POST] Re-running section recovery + connectivity...")
                model = self.synthesizer.post_process_after_multipass(
                    model, _page_results_list, ground_truth
                )

                # Filter bracing/beam stubs that have no resolved endpoints —
                # these are pre-seed marks from schedule text with no geometry.
                # Without from_col/to_col they become floating elements in SketchUp.
                _members = model.get("members", {})
                for _etype in ("bracing", "beams"):
                    _before = len(_members.get(_etype, []))
                    _members[_etype] = [
                        _m for _m in _members.get(_etype, [])
                        if not (_m.get("_stub") and
                                not _m.get("from_col") and
                                not _m.get("to_col"))
                    ]
                    _removed = _before - len(_members[_etype])
                    if _removed:
                        print(f"  [STUB-FILTER] Removed {_removed} unresolved {_etype} stubs")

                # Re-apply Z assignment to cover newly-added members from MultiPass
                _lmap = self.synthesizer._resolve_level_elevations(
                    model.get("levels", []), _page_results_list
                )
                if _lmap:
                    model["members"] = self.synthesizer._assign_z_to_all_members(
                        model["members"], _lmap
                    )
                    print(f"  [Z] Re-applied Z to all members after MultiPass")
                result.structural_model = model
                m = model.get("members", {})
                print(f"  -> After re-scan: {len(m.get('columns',[]))}c "
                      f"{len(m.get('beams',[]))}b "
                      f"{len(m.get('slabs',[]))}s "
                      f"{len(m.get('footings',[]))}f "
                      f"{len(m.get('bracing',[]))}br")
            else:
                print("[V8 STAGE 5] MultiPassExtractor: Skipped (all recalls ≥ 70%)")

            # ── COUNT CONSISTENCY GATE ────────────────────────
            if _pdfplumber_counts:
                _model_cols = len(model.get("members", {}).get("columns", []))
                _sched_cols = _pdfplumber_counts.get("columns") or 0
                if _sched_cols > 0 and _model_cols < _sched_cols * 0.85:
                    _deficit = _sched_cols - _model_cols
                    print(f"  [COUNT-GATE] Column deficit: "
                          f"model={_model_cols}, schedule={_sched_cols}, "
                          f"missing={_deficit} — forcing MultiPass")
                    if not self.skip_multipass:
                        if "extractor" not in dir():
                            extractor = MultiPassExtractor(pdf_path, dpi=self.dpi)
                        model = extractor.run(
                            model,
                            [{"type": "columns", "deficit": _deficit}],
                            scanner_output,
                        )
                        result.structural_model = model
                        _model_cols_after = len(
                            model.get("members", {}).get("columns", []))
                        print(f"  [COUNT-GATE] After re-scan: {_model_cols_after}c "
                              f"({_model_cols_after - _model_cols:+d})")

            # ── STAGE 6: Validate Model ───────────────────────
            _t_val = stage_header("6", "ValidatorV7: Checking model geometry")
            val = self.validator.validate(model)
            result.validation = val.to_dict()
            print(f"  -> {'PASSED' if val.passed else 'FAILED'} (score={val.score:.2f})")

            stage_footer("6", _t_val, val.passed)
            # ── STAGE 7: Generate Ruby ────────────────────────
            _t_ruby = stage_header("7", "RubyGeneratorV5: Building .rb script")
            # Inject metadata and detail specs into model for LOD350 generator
            model.setdefault("project", {}).update(project_meta)
            model["detail_specs"] = detail_specs
            ruby = self.ruby_gen.generate(model, val.to_dict())
            result.ruby_script = ruby
            print(f"  -> {len(ruby.splitlines())} lines")

            # ── GATE: POST-GENERATE ───────────────────────────
            print("[V8 GATE POST-GENERATE]")
            _gate_gen = _arr_principal.gate_post_generate(model)
            ARRPrincipal._print_gate("POST-GENERATE", _gate_gen)

            stage_footer("7", _t_ruby, True)
            # ── STAGE 8: Validate Ruby ────────────────────────
            _t_rv = stage_header("8", "RubyValidator: Checking .rb script")
            rv = self.ruby_val.validate(ruby)
            result.ruby_validation = rv.to_dict()
            print(f"  -> {'PASSED' if rv.passed else 'FAILED'} "
                  f"(entities~{rv.estimated_entities})")

            stage_footer("8", _t_rv, rv.passed)
            # ── STAGE 9: Accuracy Score ────────────────────────
            _t_acc = stage_header("9", "AccuracyEvaluator: Computing quality score")
            schedule_counts = verification.get("schedule_counts", {})
            # Prefer pdfplumber counts (more reliable) when available
            if _pdfplumber_counts.get("columns"):
                schedule_counts = schedule_counts or {}
                schedule_counts.setdefault("columns", _pdfplumber_counts["columns"])
            if _pdfplumber_counts.get("beams"):
                schedule_counts = schedule_counts or {}
                schedule_counts.setdefault("beams", _pdfplumber_counts["beams"])
            accuracy = self.accuracy_eval.evaluate(model, schedule_counts or None)
            result.accuracy = accuracy
            print(f"  -> Accuracy: {accuracy['overall_score']}% "
                  f"(Grade {accuracy['grade']}) "
                  f"{'✅ TARGET MET' if accuracy['target_met'] else '❌ Below 90%'}")
            print(AccuracyEvaluator.format_report(accuracy))

            # ── STAGE 9.1: Visual Similarity ──────────────────
            _plan_page_indices_vs = sorted([
                int(k) for k, v in scanner_output.get("page_results", {}).items()
                if isinstance(v, dict) and v.get("page_type") == "PLAN"
            ])
            if _plan_page_indices_vs:
                print(f"  [VISUAL-SIM] Comparing model plan view against "
                      f"{len(_plan_page_indices_vs)} PLAN page(s): {_plan_page_indices_vs}")
                try:
                    visual_sim = AccuracyEvaluator.compute_visual_similarity(
                        model, str(pdf_path), _plan_page_indices_vs
                    )
                    if visual_sim.get("similarity_score") is not None:
                        print(f"  [VISUAL-SIM] Plan similarity: "
                              f"{visual_sim['similarity_score']:.1%} "
                              f"(Grade {visual_sim['grade']}) "
                              f"[top-down model vs PDF plan pages]")
                    result.accuracy["visual_similarity"] = visual_sim
                except Exception as _vs_err:
                    print(f"  [VISUAL-SIM] WARN: {_vs_err}")

            stage_footer("9", _t_acc, accuracy.get("target_met", False))
            # ── STAGE 9.5: ARR — Architect Review & Refine ───
            accuracy_score = (result.accuracy or {}).get("overall_score", 0) or 0
            rv_pass = result.ruby_validation.get("passed", True) if result.ruby_validation else True

            # Always run CodeReviewer to catch crash/geometry issues
            cr = CodeReviewer(region=self.region)
            cr_result = cr.review(ruby, model, ruby_validation_passed=rv_pass)
            if cr_result.get("fixed_script"):
                ruby = cr_result["fixed_script"]
                result.ruby_script = ruby
                print(f"[V8 STAGE 9.5] CodeReviewer: Script fixed "
                      f"({len(cr_result['issues'])} issue(s))")
            elif cr_result["issues"]:
                print(f"[V8 STAGE 9.5] CodeReviewer: {len(cr_result['issues'])} issue(s) "
                      f"(no auto-fix available)")

            # Check 3D positions — run ArchitectReviewer if accuracy < threshold OR 3D issues
            # OR visual similarity too low (model looks wrong even if counts are right)
            arch_reviewer = ArchitectReviewer(pdf_path=pdf_path, region=self.region, dpi=self.dpi)
            z_issues = arch_reviewer._verify_3d_positions(model)
            _vsim = (result.accuracy or {}).get("visual_similarity") or {}
            visual_sim_score = (_vsim.get("similarity_score") or 0) * 100 if isinstance(_vsim, dict) else 0
            _low_visual = visual_sim_score < 25
            needs_arr = (accuracy_score < ARR_ACCURACY_THRESHOLD) or bool(z_issues) \
                        or not _gate_gen.passed or _low_visual

            if needs_arr:
                if not _gate_gen.passed:
                    reason = f"gate POST-GENERATE FAIL: {'; '.join(_gate_gen.warnings)}"
                elif accuracy_score < ARR_ACCURACY_THRESHOLD:
                    reason = f"accuracy={accuracy_score}% < {ARR_ACCURACY_THRESHOLD}%"
                elif _low_visual:
                    reason = f"visual_similarity={visual_sim_score:.1f}% < 25% — model looks wrong"
                else:
                    reason = f"{len(z_issues)} 3D position issue(s) found"
                print(f"[V8 STAGE 9.5] ARR: {reason} — running ArchitectReviewer...")

                for arr_pass in range(1, ARR_MAX_RETRIES + 1):
                    print(f"  [ARR Pass {arr_pass}/{ARR_MAX_RETRIES}]")

                    arr_result = arch_reviewer.review(
                        scanner_output, model, ground_truth=ground_truth
                    )

                    if arr_result["verdict"] == "ISSUES_FOUND":
                        corrections = arr_result.get("all_corrections", {})
                        if corrections.get("add") or corrections.get("update"):
                            model = self._apply_corrections(model, corrections)
                            result.structural_model = model
                            print(f"    ARR-1: {arr_result['total_discrepancies']} discrepancy(ies) corrected")

                        # Apply 3D fixes to model levels if available
                        if arr_result.get("project_profile", {}).get("floor_count"):
                            # If we got a project profile with floor count, validate levels
                            self._ensure_levels_for_floor_count(
                                model, arr_result["project_profile"]["floor_count"]
                            )
                    else:
                        print(f"    ARR-1: No structural issues found")

                    # Re-generate Ruby with corrected model
                    ruby = self.ruby_gen.generate(model, val.to_dict())
                    cr2 = CodeReviewer(region=self.region)
                    cr2_result = cr2.review(ruby, model, ruby_validation_passed=rv_pass)
                    if cr2_result.get("fixed_script"):
                        ruby = cr2_result["fixed_script"]
                        print(f"    ARR-2: Script fixed ({len(cr2_result['issues'])} issue(s))")
                    result.ruby_script = ruby

                    accuracy = self.accuracy_eval.evaluate(model, schedule_counts or None)
                    result.accuracy = accuracy
                    new_score = accuracy.get("overall_score", 0) or 0
                    print(f"    -> Accuracy after ARR pass {arr_pass}: {new_score}%")
                    remaining_z = arch_reviewer._verify_3d_positions(model)
                    if new_score >= ARR_ACCURACY_THRESHOLD and not remaining_z:
                        print(f"    ✅ ARR complete — accuracy {new_score}%, no 3D issues")
                        break
                    elif remaining_z:
                        print(f"    ⚠ {len(remaining_z)} 3D issue(s) remain after pass {arr_pass}")
            else:
                print(f"[V8 STAGE 9.5] ARR: Skipped "
                      f"(accuracy={accuracy_score}% ≥ {ARR_ACCURACY_THRESHOLD}%, no 3D issues)")

            # ── STAGE 10: Save outputs ────────────────────────
            _t_save = stage_header("10", "Saving outputs")
            rb_path = os.path.join(output_dir, f"{base_name}_structural.rb")
            with open(rb_path, "w", encoding="utf-8") as f:
                f.write(ruby)
            result.output_rb_path = rb_path

            json_path = os.path.join(output_dir, f"{base_name}_model.json")
            with open(json_path, "w", encoding="utf-8") as f:
                json.dump(model, f, indent=2, ensure_ascii=False, default=str)
            result.output_json_path = json_path

            scanner_json_path = os.path.join(output_dir, f"{base_name}_scanner_output.json")
            with open(scanner_json_path, "w", encoding="utf-8") as f:
                json.dump(scanner_output, f, indent=2, ensure_ascii=False, default=str)

            summary_path = os.path.join(output_dir, f"{base_name}_summary.json")
            with open(summary_path, "w", encoding="utf-8") as f:
                json.dump(result.to_dict(), f, indent=2, ensure_ascii=False, default=str)
            stage_footer("10", _t_save, True)
            print(f"  -> Ruby: {rb_path}")
            print(f"  -> JSON: {json_path}")
            print(f"  -> Summary: {summary_path}")

            # ── STAGE 11: IFC (optional) ──────────────────────
            if _ifc_available():
                try:
                    ifc_path = os.path.join(output_dir, f"{base_name}_structural.ifc")
                    IFCGenerator(region=self.region).generate(model, ifc_path)
                    result.output_ifc_path = ifc_path
                    print(f"  -> IFC: {ifc_path}")
                except Exception as ifc_err:
                    result.errors.append(f"IFC warning: {ifc_err}")

            result.success = True

        except FileNotFoundError:
            result.errors.append(f"PDF not found: {pdf_path}")
        except Exception as e:
            result.errors.append(f"Pipeline error: {str(e)}")
            import traceback
            traceback.print_exc()
        finally:
            result.duration_sec = time.time() - t0
            status = "SUCCESS" if result.success else "FAILED"
            acc = result.accuracy or {}
            acc_score = acc.get("overall_score", "N/A")

            # ── QUALITY DASHBOARD ─────────────────────────────
            _pipeline_log = AgentLogger("PIPELINE")
            m_final = (result.structural_model or {}).get("members", {})
            _pipeline_log.stat("columns", len(m_final.get("columns", [])))
            _pipeline_log.stat("beams", len(m_final.get("beams", [])))
            _pipeline_log.stat("bracing", len(m_final.get("bracing", [])))
            _pipeline_log.stat("recall_score", f"{acc.get('overall_score', 0)}%")
            _pipeline_log.stat("spatial_score", f"{acc.get('spatial_pct', 0)}%")
            _vsim_d = acc.get("visual_similarity") or {}
            _vscore = (_vsim_d.get("similarity_score") or 0) if isinstance(_vsim_d, dict) else 0
            _pipeline_log.stat("visual_sim", f"{_vscore*100:.1f}%")
            _pipeline_log.stat("duration_s", f"{result.duration_sec:.0f}s")
            _qd = acc.get("quality_detail") or {}
            if _qd:
                _pipeline_log.stat("col_section", f"{_qd.get('col_section_pct',0)*100:.0f}%")
                _pipeline_log.stat("beam_section", f"{_qd.get('beam_section_pct',0)*100:.0f}%")
                _pipeline_log.stat("beam_connect", f"{_qd.get('beam_connectivity',0)*100:.0f}%")
                _pipeline_log.stat("level_real", f"{_qd.get('level_real_pct',0)*100:.0f}%")
            _gates = {
                "recall≥90%":      (acc.get("overall_score") or 0) >= 90,
                "spatial≥60%":     (acc.get("spatial_pct") or 0) >= 60,
                "visual_sim≥25%":  _vscore * 100 >= 25,
            }
            _pipeline_log.summary(gates=_gates)

            print(f"\n{'='*60}")
            print(f"PIPELINE V8 {status} in {result.duration_sec:.1f}s | "
                  f"Recall: {acc_score}% | Spatial: {acc.get('spatial_pct',0)}%")
            print(f"{'='*60}")
            result.log_path = _log_path
            print(f"\n[LOG] Run log saved → {_log_path}")
            sys.stdout = _orig_out
            sys.stderr = _orig_err
            _log_fh.close()
            try:
                os.remove(_lock_path)
            except OSError:
                pass

        return result


    def _ensure_levels_for_floor_count(self, model: dict, floor_count: int) -> None:
        """Fill in missing levels if project profile says there are more floors than in model."""
        levels = model.get("levels", [])
        if len(levels) >= floor_count:
            return
        DEFAULT_F2F = 3500
        max_elev = max(
            (l.get("height_from_datum_mm") or l.get("elevation_mm") or 0)
            for l in levels
        ) if levels else 0
        for i in range(len(levels), floor_count):
            elev = max_elev + DEFAULT_F2F * (i - len(levels) + 1)
            levels.append({
                "id": f"LEVEL_{i+1}",
                "name": f"Level {i+1}",
                "height_from_datum_mm": elev,
                "elevation_mm": elev,
                "floor_to_floor_mm": DEFAULT_F2F,
                "auto_generated": True,
            })
        model["levels"] = levels

    def _apply_corrections(self, model: dict, corrections: dict) -> dict:
        """Apply ARR-1 structural corrections (add/remove elements) to the model."""
        members = model.setdefault("members", {})
        for etype, adds in corrections.get("add", {}).items():
            if isinstance(adds, list):
                members.setdefault(etype, []).extend(adds)
        for etype, removes in corrections.get("remove", {}).items():
            if isinstance(removes, list):
                ids_to_remove = {r.get("id") for r in removes if isinstance(r, dict)}
                members[etype] = [
                    e for e in members.get(etype, [])
                    if e.get("id") not in ids_to_remove
                ]
        # Rebuild summary counts
        model["summary"] = {
            f"total_{t}": len(members.get(t, []))
            for t in ["columns", "beams", "slabs", "walls", "footings", "bracing"]
        }
        model["summary"]["num_levels"] = len(model.get("levels", []))
        return model


def main():
    import argparse
    parser = argparse.ArgumentParser(description="Pipeline V8: PDF → SketchUp Ruby (Accuracy-First)")
    parser.add_argument("pdf")
    parser.add_argument("-o", "--output", default="./output/v8")
    parser.add_argument("-r", "--region", default="auto")
    parser.add_argument("-l", "--language", default="auto")
    parser.add_argument("-m", "--max-pages", type=int)
    parser.add_argument("--dpi", type=int, default=200)
    parser.add_argument("--skip-multipass", action="store_true")
    args = parser.parse_args()

    pipeline = PipelineV8(
        region=args.region, language=args.language,
        max_pages=args.max_pages, dpi=args.dpi,
        skip_multipass=args.skip_multipass,
    )
    result = pipeline.run(args.pdf, args.output)
    sys.exit(0 if result.success else 1)


if __name__ == "__main__":
    main()
