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

    def __init__(self, pdf_path: str, region: str = "au", language: str = "en",
                 debug: bool = False):
        self.pdf_path = str(pdf_path)
        self.prompt_factory = PromptFactory(region=region, language=language)
        self.debug = debug

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

        system_prompt = self.prompt_factory.system_prompt_plan_extractor()
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
                    parsed = self._parse(response, debug=self.debug)
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

    def _parse(self, response: str, debug: bool = False) -> dict:
        """4-pass robust JSON parser. Returns {} on failure."""
        if debug:
            print(f"  [PARSE-DEBUG] Raw response ({len(response)} chars):\n{response[:600]}")

        # Pass 1: direct parse (clean JSON)
        try:
            data = json.loads(response.strip())
            if isinstance(data, dict):
                return self._unwrap(data)
        except (json.JSONDecodeError, ValueError):
            pass

        # Pass 2: strip markdown code fences then parse
        stripped = re.sub(r'^```(?:json)?\s*', '', response.strip(), flags=re.IGNORECASE)
        stripped = re.sub(r'\s*```\s*$', '', stripped.strip())
        try:
            data = json.loads(stripped.strip())
            if isinstance(data, dict):
                return self._unwrap(data)
        except (json.JSONDecodeError, ValueError):
            pass

        # Pass 3: extract first {...} block
        m = re.search(r'\{.*\}', response, re.DOTALL)
        if m:
            try:
                data = json.loads(m.group())
                if isinstance(data, dict):
                    return self._unwrap(data)
            except (json.JSONDecodeError, ValueError):
                pass

        if debug:
            print("  [PARSE-DEBUG] All 3 parse passes failed")
        return {}

    def _unwrap(self, data: dict) -> dict:
        """Handle nested wrapper: {'columns': {'C1': {...}}} → {'C1': {...}}"""
        sample = next(iter(data.values()), None)
        if isinstance(sample, dict) and (
            "grid_x_mm" in sample or "grid_label_x" in sample
        ):
            return data
        for key in ("columns", "positions", "column_positions", "members"):
            if key in data and isinstance(data[key], dict):
                return data[key]
        return data
