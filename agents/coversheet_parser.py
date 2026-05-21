"""
=============================================================================
COVERSHEET PARSER — Tier 4
=============================================================================
Reads the TITLE / COVERSHEET page of a structural drawing set and extracts
project metadata from the title block: project name, number, revision,
engineer, standard, floor count, material, building type.

Metadata is injected into the Ruby script as SketchUp model attributes
and used to label the model in SketchUp.
=============================================================================
"""

import json
import re

from core.llm_wrapper import call_llm
from core.vision_renderer import VisionRenderer
from core.pdf_utils import get_page_count
from pipelines.prompt_factory import PromptFactory


_DEFAULTS = {
    "project_name": "Structural Model",
    "project_number": "",
    "revision": "A",
    "standard": "AS/NZS",
    "engineer": "",
    "date": "",
    "building_type": "general",
    "floor_count": 0,
    "material": "steel",
}


class CoversheetParser:
    """
    Extracts project metadata from TITLE/COVERSHEET page.
    Falls back to forensic metadata if no title page found.
    """

    def __init__(self, pdf_path: str, region: str = "au"):
        self.pdf_path = str(pdf_path)
        self.prompt_factory = PromptFactory(region=region)

    def parse(self, scanner_output: dict) -> dict:
        """
        Extract project metadata.

        Args:
            scanner_output: output from ScannerV6.run()

        Returns:
            dict with project metadata (always returns dict with defaults)
        """
        page_results = scanner_output.get("page_results", {})

        # Find TITLE or COVERSHEET page
        title_page = None
        for k, v in page_results.items():
            if isinstance(v, dict) and v.get("page_type") in ("TITLE", "COVERSHEET"):
                title_page = int(k)
                break

        if title_page is None:
            print("  [COVERSHEET] No TITLE page found — using forensic metadata")
            return self._from_forensic(scanner_output.get("forensic", {}))

        print(f"  [COVERSHEET] Reading title block from page {title_page}...")
        try:
            renderer = VisionRenderer(self.pdf_path, dpi=150)
            try:
                img_bytes = renderer.render_page_as_bytes(title_page - 1, format="PNG")
            finally:
                try:
                    renderer.close()
                except Exception:
                    pass

            sys_p = self.prompt_factory.system_prompt_coversheet_parser()
            # Also use forensic text if available
            page_text = scanner_output.get("forensic", {}).get("page_texts", {}).get(
                str(title_page), ""
            )
            user_p = (
                f"Title block / coversheet page {title_page}. "
                f"Raw text excerpt:\n{page_text[:1000]}\n\n"
                "Extract all project metadata from this title block. Output JSON only."
            )
            response = call_llm(user_p, system=sys_p, images=[img_bytes])
            parsed = self._parse(response)
            if parsed:
                result = {**_DEFAULTS, **parsed}
                print(f"  [COVERSHEET] Project: '{result.get('project_name')}' "
                      f"rev={result.get('revision')} floors={result.get('floor_count')}")
                return result
        except Exception as e:
            print(f"  [COVERSHEET] WARN: {e} — using forensic metadata")

        return self._from_forensic(scanner_output.get("forensic", {}))

    def _from_forensic(self, forensic: dict) -> dict:
        """Build metadata from forensic analysis when no title page available."""
        return {
            **_DEFAULTS,
            "project_name": forensic.get("project_name", "Structural Model"),
            "standard": "AS/NZS" if forensic.get("region") == "au" else
                        "TCVN" if forensic.get("region") == "vn" else "AS/NZS",
            "material": forensic.get("primary_material", "steel"),
            "building_type": forensic.get("building_type", "general"),
        }

    def _parse(self, response: str) -> dict:
        for attempt in [
            lambda: json.loads(response.strip()),
            lambda: json.loads(re.sub(
                r'\s*```\s*$', '',
                re.sub(r'^```(?:json)?\s*', '', response.strip(), flags=re.IGNORECASE)
            ).strip()),
            lambda: json.loads(re.search(r'\{.*\}', response, re.DOTALL).group()),
        ]:
            try:
                d = attempt()
                if isinstance(d, dict):
                    return d
            except Exception:
                pass
        return {}
