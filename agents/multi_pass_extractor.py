"""
=============================================================================
A5: MULTI-PASS EXTRACTOR — Targeted Re-Extraction for Missed Elements
=============================================================================
When ScheduleVerifier detects recall < 70% for any element type,
this agent re-scans relevant pages with targeted prompts to find
the missing elements and merges them into the structural model.

Max 2 re-scan passes to avoid infinite loops.
=============================================================================
"""

import concurrent.futures
import json
import re
import time
from pathlib import Path
from typing import Dict, List, Optional

from core.llm_wrapper import call_llm
from core.vision_renderer import VisionRenderer

MAX_PASSES = 2
MULTIPASS_WORKERS = 5

# Which page types to re-scan for each element type
ELEMENT_PAGE_MAP = {
    "columns": ["PLAN", "SCHEDULE"],
    "beams": ["PLAN", "SECTION", "ELEVATION", "SCHEDULE"],
    "footings": ["FOUNDATION", "PLAN", "SECTION", "SCHEDULE"],
    "bracing": ["ELEVATION", "SECTION", "PLAN"],
    "slabs": ["PLAN", "SECTION"],
    "walls": ["PLAN", "ELEVATION"],
}


class MultiPassExtractor:
    """
    Re-extracts missing structural elements by targeted LLM re-scanning
    of specific pages with focused prompts.
    """

    def __init__(self, pdf_path: str, dpi: int = 200):
        self.pdf_path = Path(pdf_path)
        self.dpi = dpi

    def run(
        self,
        structural_model: dict,
        discrepancies: List[dict],
        scanner_output: dict,
    ) -> dict:
        """
        Re-extract missing elements and merge into structural_model.

        Args:
            structural_model: Current model from SynthesizerV7
            discrepancies: From ScheduleVerifier — list of {type, deficit, recall}
            scanner_output: From ScannerV6 — has page_results, batches, forensic

        Returns:
            Updated structural_model with additional elements merged in
        """
        needs_repass = [d for d in discrepancies if d.get("needs_repass") and d["deficit"] > 0]
        if not needs_repass:
            print("[MULTIPASS] No re-scan needed (all recalls ≥ 70%)")
            return structural_model

        batches = scanner_output.get("batches", {})
        forensic = scanner_output.get("forensic", {})
        page_texts = forensic.get("page_texts", {})

        print(f"[MULTIPASS] Starting targeted re-extraction for: "
              f"{[d['type'] for d in needs_repass]}")

        for pass_num in range(1, MAX_PASSES + 1):
            print(f"[MULTIPASS] Pass {pass_num}/{MAX_PASSES}")
            any_improved = False

            for disc in needs_repass:
                etype = disc["type"]
                deficit = disc["deficit"]
                current_count = len(structural_model.get("members", {}).get(etype, []))

                if deficit <= 0:
                    continue

                print(f"  Re-scanning for {etype}: deficit={deficit}")

                # Find relevant pages to re-scan
                relevant_types = ELEMENT_PAGE_MAP.get(etype, ["PLAN"])
                pages_to_scan = []
                for pt in relevant_types:
                    pages_to_scan.extend(batches.get(pt, []))
                pages_to_scan = list(dict.fromkeys(pages_to_scan))[:5]  # max 5 pages

                new_elements = []
                force_fresh = pass_num > 1  # bypass cache on retry passes to break cache trap
                n_w = min(MULTIPASS_WORKERS, len(pages_to_scan)) if pages_to_scan else 1
                with concurrent.futures.ThreadPoolExecutor(max_workers=n_w) as ex:
                    futs = {
                        ex.submit(
                            self._targeted_scan,
                            etype,
                            p,
                            page_texts.get(str(p)) or page_texts.get(p) or "",
                            deficit,
                            forensic,
                            force_fresh,
                        ): p
                        for p in pages_to_scan
                    }
                    for fut in concurrent.futures.as_completed(futs):
                        try:
                            new_elements.extend(fut.result())
                        except Exception as e:
                            print(f"    [WARN] MultiPass worker p{futs[fut]}: {e}")

                if new_elements:
                    schedule_cap = int(disc.get("expected", 0) * 1.1) or None
                    merged_count = self._merge_elements(
                        structural_model, etype, new_elements, schedule_cap=schedule_cap
                    )
                    new_total = len(structural_model.get("members", {}).get(etype, []))
                    improved = new_total > current_count
                    if improved:
                        any_improved = True
                        disc["deficit"] = max(0, disc["deficit"] - (new_total - current_count))
                        print(f"    ✓ {etype}: {current_count} → {new_total} "
                              f"(+{new_total - current_count} merged)")
                    else:
                        print(f"    — {etype}: no new unique elements found")

            if not any_improved:
                print(f"[MULTIPASS] Pass {pass_num}: no improvement — stopping early")
                break

        # Rebuild model summary
        self._rebuild_summary(structural_model)
        return structural_model

    def _targeted_scan(
        self,
        etype: str,
        page_idx: int,
        page_text: str,
        deficit: int,
        forensic: dict,
        force_fresh: bool = False,
    ) -> List[dict]:
        """Run a targeted LLM scan for a specific element type on a page."""
        region = forensic.get("region", "au")
        system = self._build_system_prompt(etype, region)
        user = self._build_user_prompt(etype, page_idx, page_text, deficit, forensic)

        # Try with vision if renderer available
        images = []
        try:
            renderer = VisionRenderer(str(self.pdf_path), dpi=self.dpi)
            img_bytes = renderer.render_page_as_bytes(page_idx, format="PNG")
            images = [img_bytes]
            renderer.close()
        except Exception:
            pass

        try:
            response = call_llm(user, system=system, images=images or None,
                                 force_fresh=force_fresh)
            data = self._parse_json(response)
            if not data:
                return []
            # Response may be a list or {etype: [...]}
            if isinstance(data, list):
                return data
            if isinstance(data, dict):
                return data.get(etype, data.get("items", []))
        except Exception as e:
            print(f"    [WARN] Targeted scan page {page_idx} for {etype}: {e}")
        return []

    def _build_system_prompt(self, etype: str, region: str) -> str:
        region_hints = {
            "au": "AS/NZS standards: UB/UC/PFC/RHS/SHS/CHS sections, pile types PBFC/PSFC.",
            "vn": "TCVN standards: H/I sections, móng cọc/móng băng/móng đơn.",
            "intl": "Eurocode: IPE/HEA/HEB sections.",
        }
        hint = region_hints.get(region.lower(), region_hints["intl"])

        element_instructions = {
            "footings": (
                "Your ONLY job: find ALL pile/footing locations. "
                "Look for: pile caps, pile marks (P1, PC1), 'DIA', 'NGL', 'founding level', "
                "'bored pile', 'strip footing', 'pad footing', 'móng'. "
                "Return EVERY pile/footing you can identify."
            ),
            "beams": (
                "Your ONLY job: find ALL beam members — primary AND secondary. "
                "Look for: beam marks (B1, RB1), section labels (UB, UC, RHS), "
                "dashed lines between columns, beam-to-beam connections. "
                "Include tie beams, transfer beams, secondary beams. "
                "Do NOT miss any beam even if short."
            ),
            "bracing": (
                "Your ONLY job: find ALL bracing members. "
                "Look for: diagonal lines, X-bracing, K-bracing, flat bar braces, "
                "knee braces, wind braces, giằng chéo, RHS/SHS diagonals. "
                "Return EVERY diagonal structural member."
            ),
            "columns": (
                "Your ONLY job: find ALL column locations. "
                "Look for: column marks (C1, UC, H-section), grid intersections, "
                "box symbols on plan, 'cột'. Return EVERY column on the page."
            ),
            "slabs": (
                "Your ONLY job: find ALL floor/roof slabs. "
                "Look for: slab thickness annotations, hatch patterns, 'sàn', 'T.H. slab', "
                "slab marks. Return one entry per floor level."
            ),
            "walls": (
                "Your ONLY job: find ALL wall locations. "
                "Look for: thick lines on plan, wall thickness annotations, 'tường'. "
                "Return EVERY wall segment."
            ),
        }

        return (
            f"You are a Senior Structural Engineer doing a FOCUSED re-scan. {hint}\n"
            f"{element_instructions.get(etype, 'Extract all structural elements.')}\n"
            "Return ONLY JSON. No explanations."
        )

    def _build_user_prompt(
        self, etype: str, page_idx: int, page_text: str,
        deficit: int, forensic: dict
    ) -> str:
        schema_map = {
            "footings": (
                '{"footings": [{"id":"P1","type":"bored_pile","grid":"A-1",'
                '"diameter_mm":600,"depth_mm":15000,"x_mm":0,"y_mm":0}]}'
            ),
            "beams": (
                '{"beams": [{"id":"B1","section":"530UB92","grade":"G350",'
                '"from_col":"C1","to_col":"C2","span_mm":6000}]}'
            ),
            "bracing": (
                '{"bracing": [{"id":"BR1","section":"150x100x6RHS","grade":"C350",'
                '"from_col":"C1","to_col":"C2","level":"L01"}]}'
            ),
            "columns": (
                '{"columns": [{"id":"C1","section":"310UC118","grade":"G350",'
                '"grid_x":"1","grid_y":"A","x_mm":1000,"y_mm":1000,"height_mm":4500}]}'
            ),
            "slabs": (
                '{"slabs": [{"id":"S1","level":"L01","thickness_mm":200,'
                '"boundary":[[0,0],[18000,0],[18000,9000],[0,9000]]}]}'
            ),
            "walls": (
                '{"walls": [{"id":"W1","start_x":0,"start_y":0,'
                '"end_x":18000,"end_y":0,"thickness_mm":200,"height_mm":3500}]}'
            ),
        }

        return (
            f"TARGETED RE-SCAN — Page {page_idx + 1}\n"
            f"Looking for: {etype.upper()} (approximately {deficit} missing)\n\n"
            f"Drawing text:\n{page_text[:5000]}\n\n"
            f"Return ALL {etype} found. Schema:\n{schema_map.get(etype, '{}')}\n"
            "Be EXHAUSTIVE — do not skip any element."
        )

    def _pos_key(self, elem: dict, tolerance_mm: int = 500) -> Optional[tuple]:
        """Return bucketed (x, y) position key for spatial deduplication."""
        x = elem.get("x_mm") or elem.get("x")
        y = elem.get("y_mm") or elem.get("y")
        if x is not None and y is not None:
            try:
                return (round(float(x) / tolerance_mm), round(float(y) / tolerance_mm))
            except (ValueError, TypeError):
                pass
        return None

    def _merge_elements(
        self, structural_model: dict, etype: str, new_elements: List[dict],
        schedule_cap: Optional[int] = None,
    ) -> int:
        """Merge new elements into structural model, deduplicating by id and position."""
        members = structural_model.setdefault("members", {})
        existing = members.setdefault(etype, [])

        existing_ids = {
            e.get("id") or e.get("mark") or e.get("pile_id", "")
            for e in existing
            if e.get("id") or e.get("mark") or e.get("pile_id")
        }
        existing_pos_keys = {
            pk for e in existing
            if (pk := self._pos_key(e)) is not None
        }

        added = 0
        for elem in new_elements:
            if not isinstance(elem, dict):
                continue
            # Schedule cap: don't exceed expected count × 1.1
            if schedule_cap and len(existing) >= schedule_cap:
                break
            elem_id = elem.get("id") or elem.get("mark") or elem.get("pile_id", "")
            # Dedup by ID
            if elem_id and elem_id in existing_ids:
                continue
            # Dedup by position (catches elements with missing or duplicate IDs)
            pos_key = self._pos_key(elem)
            if pos_key and pos_key in existing_pos_keys:
                continue
            elem["_source"] = "multi_pass"
            existing.append(elem)
            if elem_id:
                existing_ids.add(elem_id)
            if pos_key:
                existing_pos_keys.add(pos_key)
            added += 1

        return added

    def _rebuild_summary(self, structural_model: dict) -> None:
        """Rebuild the summary counts after merging."""
        members = structural_model.get("members", {})
        structural_model["summary"] = {
            f"total_{t}": len(members.get(t, []))
            for t in ["columns", "beams", "slabs", "walls", "footings", "bracing"]
        }
        structural_model["summary"]["num_levels"] = len(structural_model.get("levels", []))

    def _parse_json(self, response: str) -> Optional[dict]:
        if not response:
            return None
        try:
            return json.loads(response)
        except json.JSONDecodeError:
            pass
        for open_c, close_c in [('{', '}'), ('[', ']')]:
            start = response.find(open_c)
            end = response.rfind(close_c)
            if start >= 0 and end > start:
                try:
                    return json.loads(response[start:end + 1])
                except json.JSONDecodeError:
                    pass
        return None
