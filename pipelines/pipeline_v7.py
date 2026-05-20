"""
PIPELINE V7 — Full PDF-to-SketchUp Orchestrator.
Chains: ScannerV6 (A0+A1+A2) → SynthesizerV7 (A3) → ValidatorV7 (A4)
        → RubyGeneratorV5 (B1) → RubyValidator (B2) → Output .rb file.

ScannerV6 internally runs:
  A0: PDFForensicAnalyzer → forensic.json
  A1: PageRouter → routing classification
  A2: Type-specific LLM scanning → per-page results
"""

import os
import sys
import json
import time
from pathlib import Path
from dataclasses import dataclass, field
from typing import Dict, List, Optional

# Ensure project root is on sys.path when run directly
_PROJ_ROOT = Path(__file__).resolve().parent.parent
if str(_PROJ_ROOT) not in sys.path:
    sys.path.insert(0, str(_PROJ_ROOT))

from agents.scanner_v6 import ScannerV6
from agents.synthesizer_v7 import SynthesizerV7
from agents.validator_v7 import ValidatorV7, ValidationResult
from generators.ruby_generator_v5 import RubyGeneratorV5
from generators.ruby_validator import RubyValidator, RubyValidationResult
from generators.ifc_generator import IFCGenerator, _ifc_available


@dataclass
class PipelineResult:
    success: bool = False
    pdf_path: str = ""
    duration_sec: float = 0.0

    # Stage outputs
    scanner_output: dict = field(default_factory=dict)
    structural_model: dict = field(default_factory=dict)
    validation: Optional[dict] = None
    ruby_script: str = ""
    ruby_validation: Optional[dict] = None

    # File outputs
    output_rb_path: str = ""
    output_json_path: str = ""
    output_ifc_path: str = ""

    errors: List[str] = field(default_factory=list)

    def to_dict(self) -> dict:
        forensic = self.scanner_output.get("forensic", {})
        model = self.structural_model
        m = model.get("members", {})
        return {
            "success": self.success,
            "pdf_path": self.pdf_path,
            "duration_sec": self.duration_sec,
            "forensic_summary": {
                "pages": forensic.get("num_pages", 0)
                or forensic.get("total_pages", 0),
                "type": forensic.get("document_type", "unknown"),
                "region": forensic.get("region", "unknown"),
                "language": forensic.get("detected_language", "unknown"),
            },
            "routed_page_count": len(
                self.scanner_output.get("page_results", {})
            ),
            "structural_model_summary": {
                "columns": len(m.get("columns", [])),
                "beams": len(m.get("beams", [])),
                "levels": len(model.get("levels", [])),
            },
            "validation_passed": (
                self.validation.get("passed") if self.validation else None
            ),
            "ruby_validation_passed": (
                self.ruby_validation.get("passed")
                if self.ruby_validation
                else None
            ),
            "output_rb_path": self.output_rb_path,
            "output_json_path": self.output_json_path,
            "output_ifc_path": self.output_ifc_path,
            "errors": self.errors,
        }


class PipelineV7:
    """
    PDF-to-SketchUp Pipeline V7.

    Usage:
        pipeline = PipelineV7(region="vn", language="vn")
        result = pipeline.run("path/to/drawing.pdf", output_dir="./output")

    ScannerV6 handles A0 (forensic) + A1 (routing) + A2 (scanning) internally.
    Pipeline then runs A3 (synthesize), A4 (validate), B1 (generate), B2 (validate ruby).
    """

    def __init__(
        self,
        region: str = "auto",
        language: str = "auto",
        building_type: str = "general",
        max_pages: Optional[int] = None,
        dpi: int = 200,
    ):
        self.region = region        # "auto" → detected from forensic in run()
        self.language = language    # "auto" → detected from forensic in run()
        self.building_type = building_type
        self.max_pages = max_pages
        self.dpi = dpi

        # Downstream components initialised with placeholder; re-created in run()
        # when region="auto" so they use the forensic-detected standard (VN/AU/INTL).
        _init_region = "vn" if region == "auto" else region
        _init_lang = "vn" if language == "auto" else language
        self.synthesizer = SynthesizerV7(region=_init_region)
        self.validator = ValidatorV7()
        self.ruby_gen = RubyGeneratorV5(region=_init_region, language=_init_lang)
        self.ruby_val = RubyValidator(region=_init_region)

    def run(
        self, pdf_path: str, output_dir: str = "./output"
    ) -> PipelineResult:
        result = PipelineResult(pdf_path=pdf_path)
        t0 = time.time()

        try:
            self._ensure_dir(output_dir)
            base_name = os.path.splitext(os.path.basename(pdf_path))[0]

            # ── STAGE 0-2: ScannerV6 (Forensic + Routing + Scanning) ──
            print("[STAGE 0-2] ScannerV6 running A0+A1+A2...")
            scanner = ScannerV6(
                pdf_path, dpi=self.dpi, region=self.region,
                language=self.language, max_pages=self.max_pages,
            )
            scanner_output = scanner.run(skip_vision=False)
            scanner.close()
            result.scanner_output = scanner_output

            forensic = scanner_output.get("forensic", {})
            num_pages = scanner_output.get("num_pages", 0)
            routing = scanner_output.get("routing_summary", {})
            page_results = scanner_output.get("page_results", {})
            elapsed_scan = scanner_output.get("elapsed_s", 0)

            # ── Auto-detect region from forensic analysis ──────────────
            if self.region == "auto" or self.language == "auto":
                _REGION_MAP = {
                    "au": "au", "australia": "au", "as/nzs": "au", "nzs": "au",
                    "vn": "vn", "vietnam": "vn", "tcvn": "vn",
                    "intl": "intl", "international": "intl", "eu": "intl",
                }
                raw_region = forensic.get("region", "vn").lower()
                effective_region = _REGION_MAP.get(raw_region, "vn")
                # AS/NZS drawings are almost always in English
                effective_lang = "en" if effective_region == "au" else (
                    "vn" if effective_region == "vn" else "en"
                )
                if self.region == "auto":
                    self.region = effective_region
                if self.language == "auto":
                    self.language = effective_lang
                # Re-create downstream components with the correct region
                self.synthesizer = SynthesizerV7(region=self.region)
                self.ruby_gen = RubyGeneratorV5(
                    region=self.region, language=self.language
                )
                self.ruby_val = RubyValidator(region=self.region)
                print(f"  -> Auto-detected: region={self.region}, lang={self.language}")

            print(f"  -> {num_pages} pages, "
                  f"region={forensic.get('region','?')}, "
                  f"lang={forensic.get('detected_language','?')}")
            print(f"  -> Routing: {routing.get('total_pages',0)} pages "
                  f"-> {len(page_results)} scanned")
            print(f"  -> Scanner completed in {elapsed_scan:.1f}s")

            if num_pages == 0:
                result.errors.append("No pages found in PDF")
                result.duration_sec = time.time() - t0
                return result

            # ── STAGE 3: Synthesize ───────────────────────────────
            print("[STAGE 3] SynthesizerV7 building structural model...")
            model = self.synthesizer.synthesize(scanner_output)
            result.structural_model = model

            if model.get("error"):
                result.errors.append(f"Synthesizer error: {model['error']}")
                print(f"  -> ERROR: {model['error']}")
            else:
                m = model.get("members", {})
                print(
                    f"  -> Model: {len(m.get('columns',[]))}c "
                    f"{len(m.get('beams',[]))}b "
                    f"{len(m.get('slabs',[]))}s "
                    f"{len(m.get('walls',[]))}w "
                    f"{len(model.get('levels',[]))} levels"
                )

            # ── STAGE 4: Validate Model ────────────────────────────
            print("[STAGE 4] ValidatorV7 checking model...")
            val = self.validator.validate(model)
            result.validation = val.to_dict()
            print(
                f"  -> {'PASSED' if val.passed else 'FAILED'} "
                f"(score={val.score:.2f})"
            )

            # ── STAGE 5: Generate Ruby ─────────────────────────────
            print("[STAGE 5] RubyGeneratorV5 building .rb script...")
            ruby = self.ruby_gen.generate(model, val.to_dict())
            result.ruby_script = ruby
            print(f"  -> Ruby script: {len(ruby)} chars, "
                  f"{len(ruby.splitlines())} lines")

            # ── STAGE 6: Validate Ruby ─────────────────────────────
            print("[STAGE 6] RubyValidator checking script...")
            rv = self.ruby_val.validate(ruby)
            result.ruby_validation = rv.to_dict()
            print(
                f"  -> {'PASSED' if rv.passed else 'FAILED'} "
                f"(lines={rv.line_count}, entities~{rv.estimated_entities})"
            )

            # ── STAGE 7: Save outputs ──────────────────────────────
            print("[STAGE 7] Saving outputs...")

            # Save Ruby script
            rb_path = os.path.join(
                output_dir, f"{base_name}_structural.rb"
            )
            with open(rb_path, "w", encoding="utf-8") as f:
                f.write(ruby)
            result.output_rb_path = rb_path
            print(f"  -> Ruby: {rb_path}")

            # Save JSON model
            json_path = os.path.join(
                output_dir, f"{base_name}_model.json"
            )
            with open(json_path, "w", encoding="utf-8") as f:
                json.dump(
                    model, f, indent=2, ensure_ascii=False,
                    default=str,
                )
            result.output_json_path = json_path
            print(f"  -> JSON: {json_path}")

            # Save scanner output (intermediate debug)
            scanner_json_path = os.path.join(
                output_dir, f"{base_name}_scanner_output.json"
            )
            with open(scanner_json_path, "w", encoding="utf-8") as f:
                json.dump(
                    scanner_output, f, indent=2,
                    ensure_ascii=False, default=str,
                )
            print(f"  -> Scanner Output: {scanner_json_path}")

            # ── STAGE 8: Generate IFC ──────────────────────────
            if _ifc_available():
                print("[STAGE 8] IFCGenerator building .ifc file...")
                try:
                    ifc_path = os.path.join(output_dir, f"{base_name}_structural.ifc")
                    IFCGenerator(region=self.region).generate(model, ifc_path)
                    result.output_ifc_path = ifc_path
                    print(f"  -> IFC: {ifc_path}")
                except Exception as ifc_err:
                    result.errors.append(f"IFC generation warning: {ifc_err}")
                    print(f"  -> IFC skipped: {ifc_err}")
            else:
                print("[STAGE 8] ifcopenshell not installed — skipping IFC export")

            result.success = True

        except FileNotFoundError:
            result.errors.append(f"PDF not found: {pdf_path}")
        except Exception as e:
            result.errors.append(f"Pipeline error: {str(e)}")
            import traceback

            traceback.print_exc()

        result.duration_sec = time.time() - t0
        status = "SUCCESS" if result.success else "FAILED"
        print(f"\n{'='*60}")
        print(f"PIPELINE {status} in {result.duration_sec:.1f}s")
        print(f"{'='*60}")
        return result

    # ── HELPERS ────────────────────────────────────────────────────

    @staticmethod
    def _ensure_dir(path: str):
        os.makedirs(path, exist_ok=True)


# ===========================================================
# CLI ENTRY POINT
# ===========================================================


def main():
    import argparse

    parser = argparse.ArgumentParser(
        description="Pipeline V7: PDF → SketchUp Ruby"
    )
    parser.add_argument("pdf", help="Path to PDF drawing")
    parser.add_argument(
        "-o", "--output", default="./output", help="Output directory"
    )
    parser.add_argument(
        "-r", "--region", default="vn", help="Region code"
    )
    parser.add_argument(
        "-l", "--language", default="vn", help="Language code"
    )
    parser.add_argument(
        "-t", "--type", default="general", help="Building type"
    )
    parser.add_argument(
        "-m", "--max-pages", type=int, help="Max pages to process"
    )
    parser.add_argument(
        "--dpi", type=int, default=200, help="Rendering DPI"
    )
    args = parser.parse_args()

    pipeline = PipelineV7(
        region=args.region,
        language=args.language,
        building_type=args.type,
        max_pages=args.max_pages,
        dpi=args.dpi,
    )
    result = pipeline.run(args.pdf, args.output)

    summary_path = os.path.join(args.output, "pipeline_summary.json")
    with open(summary_path, "w", encoding="utf-8") as f:
        json.dump(result.to_dict(), f, indent=2, ensure_ascii=False)

    sys.exit(0 if result.success else 1)


if __name__ == "__main__":
    main()