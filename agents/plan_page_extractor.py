"""
=============================================================================
PLAN PAGE COLUMN EXTRACTOR — Tier 2C
=============================================================================
Reads structural PLAN pages at 300 DPI and extracts column mark → grid XY
position using a vision LLM. Results are used to enrich the synthesizer
output, reducing fallback XY from ~65% to <5%.
=============================================================================
"""

import json
import re

from core.llm_wrapper import call_llm
from core.vision_renderer import VisionRenderer
from pipelines.prompt_factory import PromptFactory


class PlanPageColumnExtractor:
    """
    Reads PLAN pages from scanner output and extracts column grid positions.
    Returns: {MARK_UPPER: {grid_label_x, grid_label_y, grid_x_mm, grid_y_mm}}
    """

    def __init__(self, pdf_path: str, region: str = "au", language: str = "en"):
        self.pdf_path = str(pdf_path)
        self.prompt_factory = PromptFactory(region=region, language=language)

    def run(self, scanner_output: dict) -> dict:
        """
        Extract column mark → grid position from all PLAN pages.

        Args:
            scanner_output: output from ScannerV6.run() — needs page_results

        Returns:
            dict mapping MARK (uppercase) → {grid_label_x, grid_label_y,
                                              grid_x_mm, grid_y_mm}
        """
        page_results = scanner_output.get("page_results", {})
        plan_pages = sorted([
            int(k) for k, v in page_results.items()
            if isinstance(v, dict) and v.get("page_type") == "PLAN"
        ])

        if not plan_pages:
            print("  [PLAN-EXTRACT] No PLAN pages found — skipping")
            return {}

        system_prompt = self.prompt_factory.build_full_system_prompt("plan_extractor")
        positions: dict = {}

        renderer = VisionRenderer(self.pdf_path, dpi=300)
        try:
            for page_idx in plan_pages:
                print(f"  [PLAN-EXTRACT] Reading plan page {page_idx}...")
                try:
                    # VisionRenderer is 0-indexed internally
                    img_bytes = renderer.render_page_as_bytes(page_idx - 1, format="PNG")
                    user_prompt = self.prompt_factory.user_prompt_plan_extract(page_idx)
                    response = call_llm(user_prompt, system=system_prompt, images=[img_bytes])
                    parsed = self._parse(response)
                    # Normalise keys to uppercase for consistent lookup
                    parsed_upper = {k.strip().upper(): v for k, v in parsed.items()
                                    if isinstance(v, dict)}
                    positions.update(parsed_upper)
                    print(f"  [PLAN-EXTRACT] Page {page_idx}: {len(parsed_upper)} column positions")
                except Exception as e:
                    print(f"  [PLAN-EXTRACT] WARN page {page_idx}: {e}")
        finally:
            try:
                renderer.close()
            except Exception:
                pass

        print(f"  [PLAN-EXTRACT] Total: {len(positions)} column grid positions extracted")
        return positions

    def _parse(self, response: str) -> dict:
        """Parse LLM JSON response. Returns {} on failure."""
        try:
            m = re.search(r'\{.*\}', response, re.DOTALL)
            if m:
                data = json.loads(m.group())
                if isinstance(data, dict):
                    return data
        except Exception:
            pass
        return {}
