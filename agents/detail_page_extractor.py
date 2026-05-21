"""
=============================================================================
DETAIL PAGE EXTRACTOR — Tier 4 / LOD350
=============================================================================
Reads structural DETAIL pages at 200 DPI and extracts connection specifications:
  - Base plate dimensions (width × depth × thickness mm)
  - Anchor bolt pattern (count, grade, diameter)
  - End plate specs for beam-to-column connections
  - Stiffener presence, weld size

Results are passed to RubyGeneratorV5 to produce accurate LOD350 geometry
instead of estimated plate sizes.
=============================================================================
"""

import json
import re

from core.llm_wrapper import call_llm
from core.vision_renderer import VisionRenderer
from pipelines.prompt_factory import PromptFactory


class DetailPageExtractor:
    """
    Reads DETAIL pages from scanner output → connection specification dict.
    Returns: {detail_id: {connection_type, member_ref, base_plate, end_plate, ...}}
    """

    def __init__(self, pdf_path: str, region: str = "au"):
        self.pdf_path = str(pdf_path)
        self.prompt_factory = PromptFactory(region=region)

    def run(self, scanner_output: dict) -> dict:
        """
        Extract connection specs from all DETAIL pages.

        Returns:
            dict mapping detail_id → connection spec dict
            e.g. {"7/A3": {"connection_type": "column_base", "base_plate": {...}}}
        """
        page_results = scanner_output.get("page_results", {})
        detail_pages = sorted([
            int(k) for k, v in page_results.items()
            if isinstance(v, dict)
            and v.get("page_type") == "DETAIL"
            and not v.get("skipped")
        ])

        if not detail_pages:
            print("  [DETAIL-EXT] No DETAIL pages found — skipping")
            return {}

        system_prompt = self.prompt_factory.system_prompt_detail_extractor()
        all_details: dict = {}

        renderer = VisionRenderer(self.pdf_path, dpi=200)
        try:
            for page_idx in detail_pages:
                print(f"  [DETAIL-EXT] Reading detail page {page_idx}...")
                try:
                    img_bytes = renderer.render_page_as_bytes(page_idx - 1, format="PNG")
                    user_prompt = self.prompt_factory.user_prompt_detail_extract(page_idx)
                    response = call_llm(user_prompt, system=system_prompt, images=[img_bytes])
                    parsed = self._parse(response)
                    all_details.update(parsed)
                    print(f"  [DETAIL-EXT] Page {page_idx}: {len(parsed)} connection details")
                except Exception as e:
                    print(f"  [DETAIL-EXT] WARN page {page_idx}: {e}")
        finally:
            try:
                renderer.close()
            except Exception:
                pass

        print(f"  [DETAIL-EXT] Total: {len(all_details)} connection details extracted")
        return all_details

    def get_base_plate_for_column(self, mark: str, details: dict) -> dict:
        """
        Find the base plate spec for a given column mark.
        Searches by member_ref or connection_type=column_base.
        Returns the base_plate sub-dict, or {} if not found.
        """
        mark_upper = mark.strip().upper()
        for spec in details.values():
            if not isinstance(spec, dict):
                continue
            ref = str(spec.get("member_ref", "")).strip().upper()
            if ref == mark_upper and spec.get("connection_type") == "column_base":
                return spec.get("base_plate", {})
        # Fallback: any column_base spec (if only one in drawing)
        column_bases = [
            v for v in details.values()
            if isinstance(v, dict) and v.get("connection_type") == "column_base"
        ]
        if len(column_bases) == 1:
            return column_bases[0].get("base_plate", {})
        return {}

    def _parse(self, response: str) -> dict:
        """4-pass robust JSON parser. Returns {} on failure."""
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
                    return self._unwrap(d)
            except Exception:
                pass
        return {}

    def _unwrap(self, data: dict) -> dict:
        for key in ("details", "connections", "connection_details"):
            if key in data and isinstance(data[key], dict):
                return data[key]
        sample = next(iter(data.values()), None)
        if isinstance(sample, dict) and (
            "connection_type" in sample or "base_plate" in sample or "end_plate" in sample
        ):
            return data
        return data
