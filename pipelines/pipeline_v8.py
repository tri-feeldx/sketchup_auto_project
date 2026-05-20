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
from agents.code_reviewer import CodeReviewer
from generators.ruby_generator_v5 import RubyGeneratorV5
from generators.ruby_validator import RubyValidator
from generators.ifc_generator import IFCGenerator, _ifc_available
from metrics.accuracy_evaluator import AccuracyEvaluator

ARR_ACCURACY_THRESHOLD = 95.0
ARR_MAX_RETRIES = 3


@dataclass
class PipelineV8Result:
    success: bool = False
    pdf_path: str = ""
    duration_sec: float = 0.0

    # Stage outputs
    scanner_output: dict = field(default_factory=dict)
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

        try:
            os.makedirs(output_dir, exist_ok=True)
            base_name = os.path.splitext(os.path.basename(pdf_path))[0]

            # ── STAGE 0-2: ScannerV6 ─────────────────────────
            print("[V8 STAGE 0-2] ScannerV6: Forensic + Routing + Scanning...")
            scanner = ScannerV6(
                pdf_path, dpi=self.dpi, region=self.region,
                language=self.language, max_pages=self.max_pages,
            )
            scanner_output = scanner.run(skip_vision=False)
            scanner.close()
            result.scanner_output = scanner_output

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

            # ── STAGE 3: Synthesize ───────────────────────────
            print("[V8 STAGE 3] SynthesizerV7: Building structural model...")
            model = self.synthesizer.synthesize(scanner_output)
            result.structural_model = model
            m = model.get("members", {})
            print(f"  -> {len(m.get('columns',[]))}c "
                  f"{len(m.get('beams',[]))}b "
                  f"{len(m.get('slabs',[]))}s "
                  f"{len(m.get('walls',[]))}w "
                  f"{len(m.get('footings',[]))}f "
                  f"{len(m.get('bracing',[]))}br")

            # ── STAGE 4: Schedule Verification (NEW) ─────────
            print("[V8 STAGE 4] ScheduleVerifier: Cross-checking against schedules...")
            verifier = ScheduleVerifier(region=self.region)
            verification = verifier.verify(scanner_output, model)
            result.verification = verification
            overall_recall = verification.get("overall_recall")
            if overall_recall is not None:
                print(f"  -> Overall recall: {overall_recall:.0%} "
                      f"({'✓' if overall_recall >= 0.70 else '⚠'})")

            # ── STAGE 5: Multi-Pass Extraction (NEW) ─────────
            if not self.skip_multipass and verification.get("needs_repass"):
                print("[V8 STAGE 5] MultiPassExtractor: Re-scanning for missing elements...")
                extractor = MultiPassExtractor(pdf_path, dpi=self.dpi)
                model = extractor.run(
                    model,
                    verification["discrepancies"],
                    scanner_output,
                )
                result.structural_model = model
                m = model.get("members", {})
                print(f"  -> After re-scan: {len(m.get('columns',[]))}c "
                      f"{len(m.get('beams',[]))}b "
                      f"{len(m.get('slabs',[]))}s "
                      f"{len(m.get('footings',[]))}f "
                      f"{len(m.get('bracing',[]))}br")
            else:
                print("[V8 STAGE 5] MultiPassExtractor: Skipped (all recalls ≥ 70%)")

            # ── STAGE 6: Validate Model ───────────────────────
            print("[V8 STAGE 6] ValidatorV7: Checking model geometry...")
            val = self.validator.validate(model)
            result.validation = val.to_dict()
            print(f"  -> {'PASSED' if val.passed else 'FAILED'} (score={val.score:.2f})")

            # ── STAGE 7: Generate Ruby ────────────────────────
            print("[V8 STAGE 7] RubyGeneratorV5: Building .rb script...")
            ruby = self.ruby_gen.generate(model, val.to_dict())
            result.ruby_script = ruby
            print(f"  -> {len(ruby.splitlines())} lines")

            # ── STAGE 8: Validate Ruby ────────────────────────
            print("[V8 STAGE 8] RubyValidator: Checking script...")
            rv = self.ruby_val.validate(ruby)
            result.ruby_validation = rv.to_dict()
            print(f"  -> {'PASSED' if rv.passed else 'FAILED'} "
                  f"(entities~{rv.estimated_entities})")

            # ── STAGE 9: Accuracy Score (NEW) ─────────────────
            print("[V8 STAGE 9] AccuracyEvaluator: Computing recall-based score...")
            schedule_counts = verification.get("schedule_counts", {})
            accuracy = self.accuracy_eval.evaluate(model, schedule_counts or None)
            result.accuracy = accuracy
            print(f"  -> Accuracy: {accuracy['overall_score']}% "
                  f"(Grade {accuracy['grade']}) "
                  f"{'✅ TARGET MET' if accuracy['target_met'] else '❌ Below 90%'}")
            print(AccuracyEvaluator.format_report(accuracy))

            # ── STAGE 9.5: ARR — Architect Review & Refine ───
            accuracy_score = (result.accuracy or {}).get("overall_score", 0) or 0
            if accuracy_score < ARR_ACCURACY_THRESHOLD:
                print(f"[V8 STAGE 9.5] ARR: Accuracy={accuracy_score}% < "
                      f"{ARR_ACCURACY_THRESHOLD}% — running review...")
                for arr_pass in range(1, ARR_MAX_RETRIES + 1):
                    print(f"  [ARR Pass {arr_pass}/{ARR_MAX_RETRIES}]")

                    sr = StructuralReviewer(pdf_path=pdf_path, region=self.region, dpi=self.dpi)
                    sr_result = sr.review(scanner_output, model)
                    if sr_result["verdict"] == "ISSUES_FOUND" and sr_result.get("corrections"):
                        model = self._apply_corrections(model, sr_result["corrections"])
                        result.structural_model = model
                        print(f"    ARR-1: {len(sr_result['missing_elements'])} issue(s) corrected")
                    else:
                        print(f"    ARR-1: No structural issues found")

                    ruby = self.ruby_gen.generate(model, val.to_dict())
                    rv_pass = result.ruby_validation.get("passed", True) if result.ruby_validation else True
                    cr = CodeReviewer(region=self.region)
                    cr_result = cr.review(ruby, model, ruby_validation_passed=rv_pass)
                    if cr_result.get("fixed_script"):
                        ruby = cr_result["fixed_script"]
                        result.ruby_script = ruby
                        print(f"    ARR-2: Script fixed ({len(cr_result['issues'])} issue(s))")
                    else:
                        result.ruby_script = ruby
                        print(f"    ARR-2: Script OK or no fix available")

                    accuracy = self.accuracy_eval.evaluate(model, schedule_counts or None)
                    result.accuracy = accuracy
                    new_score = accuracy.get("overall_score", 0) or 0
                    print(f"    -> Accuracy after ARR pass {arr_pass}: {new_score}%")
                    if new_score >= ARR_ACCURACY_THRESHOLD:
                        print(f"    ✅ ARR target met ({new_score}%)")
                        break
            else:
                print(f"[V8 STAGE 9.5] ARR: Skipped "
                      f"(accuracy={accuracy_score}% ≥ {ARR_ACCURACY_THRESHOLD}%)")

            # ── STAGE 10: Save outputs ────────────────────────
            print("[V8 STAGE 10] Saving outputs...")
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

        result.duration_sec = time.time() - t0
        status = "SUCCESS" if result.success else "FAILED"
        acc_score = (result.accuracy or {}).get("overall_score", "N/A")
        print(f"\n{'='*60}")
        print(f"PIPELINE V8 {status} in {result.duration_sec:.1f}s | Accuracy: {acc_score}%")
        print(f"{'='*60}")
        return result


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
