"""
=============================================================================
A4: SCHEDULE VERIFIER — Cross-Reference Extracted Model Against Schedule
=============================================================================
Compares extracted element counts from the structural model against
expected counts found in schedule/table pages.

Outputs a list of discrepancies that triggers MultiPassExtractor if
any element type has recall < RECALL_THRESHOLD.
=============================================================================
"""

import json
import re
from typing import Dict, List, Optional

from core.llm_wrapper import call_llm

RECALL_THRESHOLD = 0.70  # Trigger multi-pass if recall < 70%

ELEMENT_TYPES = ["columns", "beams", "slabs", "walls", "footings", "bracing"]


class ScheduleVerifier:
    """
    Extracts expected element counts from schedule pages,
    compares with the synthesized model, and returns discrepancies.
    """

    def __init__(self, region: str = "auto"):
        self.region = region

    def verify(
        self,
        scanner_output: dict,
        structural_model: dict,
        ground_truth: dict = None,
    ) -> dict:
        """
        Run schedule cross-verification.

        Args:
            scanner_output: Output of ScannerV6.run() — has page_results + batches
            structural_model: Output of SynthesizerV7.synthesize()
            ground_truth: Optional ProjectFacts from GroundTruthBuilder — used to
                          override column count with the more reliable GTB value.

        Returns:
            {
              "schedule_counts": {type: expected_count},
              "extracted_counts": {type: extracted_count},
              "discrepancies": [{type, expected, got, deficit, recall}],
              "needs_repass": bool,
              "overall_recall": float,
            }
        """
        page_results = scanner_output.get("page_results", {})
        batches = scanner_output.get("batches", {})

        # Step 1: Extract expected counts from schedule pages
        schedule_counts = self._extract_schedule_counts(page_results, batches, scanner_output)

        # Use GTB ground truth as authoritative column count — its LLM vision prompt
        # explicitly filters hardware and counts structural columns per page, making it
        # more reliable than the heuristic regex that can over-count mark instances.
        if ground_truth:
            gtb_cols = ground_truth.get("col_count_expected")
            if gtb_cols and gtb_cols > 0:
                schedule_counts["columns"] = gtb_cols

        # Also check if scanner already recorded schedule_counts in page results
        for pr in page_results.values():
            sc = pr.get("schedule_counts", {})
            for etype, cnt in sc.items():
                if etype in ELEMENT_TYPES and cnt:
                    cur = schedule_counts.get(etype, 0)
                    schedule_counts[etype] = max(cur, int(cnt))

        # Step 2: Get extracted counts from structural model
        members = structural_model.get("members", {})
        extracted_counts = {t: len(members.get(t, [])) for t in ELEMENT_TYPES}

        # Step 3: Compute discrepancies
        discrepancies = []
        recalls = []
        for etype in ELEMENT_TYPES:
            expected = schedule_counts.get(etype, 0)
            got = extracted_counts.get(etype, 0)
            if expected > 0:
                recall = min(got / expected, 1.0)
                recalls.append(recall)
                deficit = max(0, expected - got)
                discrepancies.append({
                    "type": etype,
                    "expected": expected,
                    "got": got,
                    "deficit": deficit,
                    "recall": round(recall, 3),
                    "needs_repass": recall < RECALL_THRESHOLD,
                })

        needs_repass = any(d["needs_repass"] for d in discrepancies)
        overall_recall = round(sum(recalls) / len(recalls), 3) if recalls else None

        if discrepancies:
            print(f"[VERIFY] Schedule cross-check: overall_recall={overall_recall}")
            for d in discrepancies:
                flag = "⚠" if d["needs_repass"] else "✓"
                print(f"  {flag} {d['type']}: expected={d['expected']}, "
                      f"got={d['got']}, recall={d['recall']:.0%}")
        else:
            print("[VERIFY] No schedule reference found — skipping count verification")

        return {
            "schedule_counts": schedule_counts,
            "extracted_counts": extracted_counts,
            "discrepancies": discrepancies,
            "needs_repass": needs_repass,
            "overall_recall": overall_recall,
        }

    def _extract_schedule_counts(
        self,
        page_results: dict,
        batches: dict,
        scanner_output: dict,
    ) -> Dict[str, int]:
        """
        Ask LLM to extract element counts from schedule pages.
        Falls back to heuristic parsing if LLM fails.
        """
        schedule_idxs = batches.get("SCHEDULE", [])
        if not schedule_idxs:
            return {}

        page_texts = scanner_output.get("forensic", {}).get("page_texts", {})
        counts: Dict[str, int] = {}

        for page_idx in schedule_idxs[:4]:  # scan up to 4 schedule pages
            pt = page_texts.get(str(page_idx)) or page_texts.get(page_idx) or ""
            if not pt:
                # Try from page_results
                pr = page_results.get(str(page_idx), {})
                pt = pr.get("raw_text", "")
            if not pt:
                continue

            # Try heuristic first (fast, free)
            heuristic = self._heuristic_count_extract(pt)
            for etype, cnt in heuristic.items():
                if cnt > counts.get(etype, 0):
                    counts[etype] = cnt

            # If heuristic found nothing meaningful, use LLM
            if not any(heuristic.values()):
                llm_counts = self._llm_count_extract(pt, page_idx)
                for etype, cnt in llm_counts.items():
                    if cnt > counts.get(etype, 0):
                        counts[etype] = cnt

        return counts

    def _heuristic_count_extract(self, text: str) -> Dict[str, int]:
        """Fast regex-based count extraction from schedule text."""
        counts: Dict[str, int] = {}
        text_lower = text.lower()

        # Look for patterns like "32 columns", "columns: 32", "total: 48 beams"
        patterns = {
            "columns": [
                r"(\d+)\s*(?:no\.?\s*)?colum",
                r"colum[^:]*:\s*(\d+)",
                r"total\s+colum[^:]*:\s*(\d+)",
            ],
            "beams": [
                r"(\d+)\s*(?:no\.?\s*)?beam",
                r"beam[^:]*:\s*(\d+)",
                r"total\s+beam[^:]*:\s*(\d+)",
            ],
            "footings": [
                r"(\d+)\s*(?:no\.?\s*)?(?:footing|pile|mong|coc)",
                r"(?:footing|pile)[^:]*:\s*(\d+)",
                r"pile\s+(?:schedule|list)[^:]*(\d+)\s*(?:no|piles)",
            ],
            "bracing": [
                r"(\d+)\s*(?:no\.?\s*)?brac",
                r"brac[^:]*:\s*(\d+)",
            ],
            "slabs": [
                r"(\d+)\s*(?:no\.?\s*)?slab",
                r"slab[^:]*:\s*(\d+)",
            ],
            "walls": [
                r"(\d+)\s*(?:no\.?\s*)?wall",
                r"wall[^:]*:\s*(\d+)",
            ],
        }

        for etype, pats in patterns.items():
            for pat in pats:
                m = re.search(pat, text_lower)
                if m:
                    val = int(m.group(1))
                    if val > counts.get(etype, 0):
                        counts[etype] = val

        # Count table rows as a fallback: count occurrences of member marks
        # e.g., C1, C2, C3... B1, B2...
        col_marks = set(re.findall(r"\bC\d+\b", text))
        beam_marks = set(re.findall(r"\bB\d+\b", text))
        pile_marks = set(re.findall(r"\bP\d+\b", text))

        if len(col_marks) > counts.get("columns", 0):
            counts["columns"] = len(col_marks)
        if len(beam_marks) > counts.get("beams", 0):
            counts["beams"] = len(beam_marks)
        if len(pile_marks) > counts.get("footings", 0):
            counts["footings"] = len(pile_marks)

        return counts

    def _llm_count_extract(self, page_text: str, page_idx: int) -> Dict[str, int]:
        """Use LLM to extract element counts from a schedule page."""
        system = (
            "You are a structural engineer reading a member schedule table. "
            "Extract the TOTAL COUNT of each element type from this schedule. "
            "Return ONLY JSON. No explanations."
        )
        user = (
            "From this schedule page, extract the total number of each structural element type.\n\n"
            f"SCHEDULE TEXT (page {page_idx + 1}):\n{page_text[:4000]}\n\n"
            "OUTPUT — JSON only:\n"
            '{"columns": 32, "beams": 48, "footings": 32, "bracing": 8, "slabs": 0, "walls": 0}\n'
            "Use 0 if an element type is not mentioned. Count TOTAL instances, not unique marks."
        )
        try:
            response = call_llm(user, system=system)
            data = self._parse_json(response)
            if data and isinstance(data, dict):
                return {
                    k: int(v) for k, v in data.items()
                    if k in ELEMENT_TYPES and isinstance(v, (int, float)) and v > 0
                }
        except Exception as e:
            print(f"  [VERIFY] LLM count extract page {page_idx}: {e}")
        return {}

    def _parse_json(self, response: str) -> Optional[dict]:
        if not response:
            return None
        try:
            return json.loads(response)
        except json.JSONDecodeError:
            pass
        m = re.search(r'\{[\s\S]*\}', response)
        if m:
            try:
                return json.loads(m.group())
            except json.JSONDecodeError:
                pass
        return None
