"""
=============================================================================
A2: SCANNER V6 — Text-First Smart Scanner (V7 UPGRADE)
=============================================================================
Replaces scanner_v5.py — uses page_router (non-LLM classification) +
prompt_factory (centralized prompts) + pdf_forensic for pre-analysis.

Key V6 improvements over V5:
  - NO LLM for page classification (uses PageRouter A1)
  - All prompts from PromptFactory (no hardcoded prompts)
  - Region-aware system prompt per page
  - Schedule extraction via dedicated prompt
  - Better JSON parsing with recovery
  - Per-page type → appropriate scanning mode
  - Forensic pre-context injected into every LLM call
=============================================================================
"""

import json
import time
from pathlib import Path
from typing import Optional, Dict, List

from core.llm_wrapper import call_llm
from core.vision_renderer import VisionRenderer
from core.pdf_utils import get_page_count

# V7 imports
from agents.pdf_forensic import PDFForensicAnalyzer
from pipelines.page_router import PageRouter
from pipelines.prompt_factory import PromptFactory


class ScannerV6:
    """
    Text-First Smart Scanner V6.
    
    Pipeline:
      1. FORENSIC (A0): Extract PDF metadata without LLM
      2. ROUTE (A1): Classify pages using PageRouter (no LLM)
      3. SCAN (A2): Analyze each page with type-specific prompts from PromptFactory
      4. COLLECT: Return all page results
    """

    def __init__(self, pdf_path: str | Path, dpi: int = 200,
                 region: str = "vn", language: str = "vn"):
        self.pdf_path = Path(pdf_path)
        self.dpi = dpi
        self.region = region
        self.language = language

        self.renderer: Optional[VisionRenderer] = None
        self.forensic_result: Optional[Dict] = None
        self.router = PageRouter()
        self.prompt_factory = PromptFactory(region=region, language=language)

    def _open(self):
        """Open PDF renderer."""
        self.renderer = VisionRenderer(str(self.pdf_path), dpi=self.dpi)

    def close(self):
        """Close renderer."""
        if self.renderer:
            self.renderer.close()
            self.renderer = None

    def run(self, skip_vision: bool = False) -> dict:
        """
        Run full V6 scanning pipeline.
        
        Args:
            skip_vision: If True, text-only analysis (no image rendering)
        
        Returns:
            dict with forensic, routing, and page_results
        """
        t0 = time.time()

        # ── STAGE 0: FORENSIC ───────────────────────────────
        print("[SCAN V6] Stage 0: Forensic analysis (A0)...")
        forensic = PDFForensicAnalyzer(str(self.pdf_path))
        forensic_result = forensic.analyze()
        self.forensic_result = forensic_result.to_dict()
        num_pages = forensic_result.num_pages
        print(f"  -> {num_pages} pages, region={self.forensic_result['region']}, "
              f"lang={self.forensic_result['detected_language']}")

        if num_pages == 0:
            return self._empty_result()

        # ── STAGE 1: ROUTE ──────────────────────────────────
        print("[SCAN V6] Stage 1: Page routing (A1)...")
        pf_list = [pf.to_dict() for pf in forensic_result.page_forensics]
        routed = self.router.route_all(pf_list)
        batches = self.router.batch_pages(routed)
        summary = self.router.get_summary(routed)
        print(f"  -> Types: {', '.join(f'{k}={len(v)}' for k,v in batches.items())}")

        # ── STAGE 2: SCAN ───────────────────────────────────
        print("[SCAN V6] Stage 2: Page scanning (A2)...")
        if not skip_vision:
            self._open()

        page_results = {}
        for rp in routed:
            ptype = rp.page_type
            if ptype in ("TITLE", "UNKNOWN"):
                # Skip title/unknown pages — just store metadata
                page_results[str(rp.page_idx)] = {
                    "page_idx": rp.page_idx,
                    "page_type": ptype,
                    "confidence": rp.confidence,
                    "skipped": True,
                }
                continue

            print(f"  Scanning page {rp.page_idx+1}/{num_pages} ({ptype})...")
            result = self._scan_page(rp, skip_vision=skip_vision)
            if result:
                page_results[str(rp.page_idx)] = result

        if self.renderer:
            self.close()

        # ── COLLECT ─────────────────────────────────────────
        elapsed = time.time() - t0
        output = {
            "pdf_path": str(self.pdf_path),
            "num_pages": num_pages,
            "forensic": self.forensic_result,
            "routing_summary": summary,
            "batches": {k: v for k, v in batches.items()},
            "page_results": page_results,
            "elapsed_s": round(elapsed, 1),
        }
        print(f"  [OK] V6 Complete: {len(page_results)} pages scanned in {elapsed:.1f}s")
        return output

    def _scan_page(self, rp, skip_vision: bool = False) -> Optional[dict]:
        """Scan a single page — text-only or vision-assisted."""
        page_idx = rp.page_idx
        ptype = rp.page_type

        # Get text from forensic
        page_text = ""
        if self.forensic_result:
            page_texts = self.forensic_result.get("page_texts", [])
            if page_idx < len(page_texts):
                page_text = page_texts[page_idx]

        # Build prompts
        system_prompt = self.prompt_factory.build_full_system_prompt(
            "scanner", page_type=ptype.lower(), region=self.region
        )
        user_prompt = self.prompt_factory.user_prompt_scan(
            page_text=page_text,
            page_idx=page_idx,
            page_type=ptype.lower(),
            profile=self.forensic_result,
        )

        # Get image if vision enabled
        images = []
        if not skip_vision and self.renderer:
            try:
                img_bytes = self.renderer.render_page_as_bytes(page_idx, format="PNG")
                images = [img_bytes]
            except Exception as e:
                print(f"    [WARN] Render page {page_idx} failed: {e}")

        # Call LLM
        try:
            response = call_llm(
                user_prompt,
                system=system_prompt,
                images=images if images else None,
            )
            data = self._parse_json(response)
            if data:
                data["page_idx"] = page_idx
                data["page_type"] = ptype
                data["route_confidence"] = rp.confidence
                return data
        except Exception as e:
            print(f"    [WARN] LLM scan page {page_idx} failed: {e}")

        # Fallback: return text-only metadata
        return {
            "page_idx": page_idx,
            "page_type": ptype,
            "route_confidence": rp.confidence,
            "error": "LLM analysis failed",
            "raw_text": page_text[:500] if page_text else "",
        }

    # ── JSON PARSING WITH RECOVERY ──────────────────────────
    def _parse_json(self, response: str) -> Optional[dict]:
        """Parse LLM JSON response with multiple recovery strategies."""
        if not response or not response.strip():
            return None

        # Strategy 1: Direct parse
        try:
            return json.loads(response)
        except json.JSONDecodeError:
            pass

        # Strategy 2: Extract from code blocks
        import re
        m = re.search(r'```(?:json)?\s*([\s\S]*?)```', response)
        if m:
            try:
                return json.loads(m.group(1))
            except json.JSONDecodeError:
                pass

        # Strategy 3: Find outer braces
        brace_start = response.find('{')
        brace_end = response.rfind('}')
        if brace_start >= 0 and brace_end > brace_start:
            try:
                return json.loads(response[brace_start:brace_end+1])
            except json.JSONDecodeError:
                pass

        print(f"    [WARN] Could not parse JSON from response: {response[:200]}...")
        return None

    def _empty_result(self) -> dict:
        return {
            "pdf_path": str(self.pdf_path),
            "num_pages": 0,
            "forensic": self.forensic_result or {},
            "routing_summary": {"total_pages": 0, "types": {}, "unknown_count": 0},
            "batches": {},
            "page_results": {},
            "elapsed_s": 0,
            "error": "No pages found",
        }


# ============================================================
# PUBLIC HELPER
# ============================================================

def scan_pdf(pdf_path: str, dpi: int = 200, region: str = "vn",
             skip_vision: bool = False) -> dict:
    """Convenience wrapper: full V6 scan of a PDF."""
    scanner = ScannerV6(pdf_path, dpi=dpi, region=region)
    try:
        result = scanner.run(skip_vision=skip_vision)
    finally:
        scanner.close()
    return result