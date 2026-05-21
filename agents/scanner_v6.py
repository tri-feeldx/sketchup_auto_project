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
import concurrent.futures
from pathlib import Path
from typing import Optional, Dict, List

PARALLEL_SCAN_WORKERS = 6

from core.llm_wrapper import call_llm
from core.vision_renderer import VisionRenderer
from core.pdf_utils import get_page_count, region_normaliser

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
                 region: str = "vn", language: str = "vn",
                 max_pages: Optional[int] = None):
        self.pdf_path = Path(pdf_path)
        self.dpi = dpi
        self.region = region
        self.language = language
        self.max_pages = max_pages

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
        print(f"  -> {num_pages} pages, region={self.forensic_result.get('region','?')}, "
              f"lang={self.forensic_result.get('detected_language','?')}")

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
        pages_to_scan = routed[:self.max_pages] if self.max_pages else routed
        page_results = self._scan_pages_parallel(pages_to_scan, skip_vision, num_pages)

        # ── STAGE 2b: TARGETED SECTION RETRY ────────────────
        # If any members came back with null sections, re-query schedule pages.
        page_results = self._targeted_section_retry(page_results, batches)

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

    def _scan_page(self, rp, skip_vision: bool = False, _renderer=None) -> Optional[dict]:
        """Scan a single page — text-only or vision-assisted.
        _renderer: per-thread VisionRenderer for parallel mode (overrides self.renderer).
        """
        page_idx = rp.page_idx
        ptype = rp.page_type

        # Get text from forensic (page_texts can be dict<str, str> or list)
        page_text = ""
        if self.forensic_result:
            page_texts = self.forensic_result.get("page_texts", {})
            if isinstance(page_texts, dict):
                page_text = page_texts.get(str(page_idx), "")
            elif isinstance(page_texts, list) and page_idx < len(page_texts):
                page_text = page_texts[page_idx]

        # Normalise regional notation before LLM sees the text
        page_text_norm = region_normaliser(page_text, self.region)

        # Build prompts
        system_prompt = self.prompt_factory.build_full_system_prompt(
            "scanner", page_type=ptype.lower(), region=self.region
        )
        user_prompt = self.prompt_factory.user_prompt_scan(
            page_text=page_text_norm,
            page_idx=page_idx,
            page_type=ptype.lower(),
            profile=self.forensic_result,
        )

        # Get image if vision enabled — use _renderer (parallel) or self.renderer (sequential)
        images = []
        active_renderer = _renderer if _renderer is not None else self.renderer
        if not skip_vision and active_renderer:
            try:
                img_bytes = active_renderer.render_page_as_bytes(page_idx, format="PNG")
                images = [img_bytes]
            except Exception as e:
                print(f"    [WARN] Render page {page_idx} failed: {e}")

        # Call LLM
        result_data = None
        try:
            response = call_llm(
                user_prompt,
                system=system_prompt,
                images=images if images else None,
            )
            data = self._parse_json(response)
            if data is not None:
                if isinstance(data, dict):
                    data["page_idx"] = page_idx
                    data["page_type"] = ptype
                    data["route_confidence"] = rp.confidence
                    result_data = data
                elif isinstance(data, list):
                    print(f"    [INFO] LLM returned array, wrapping as dict")
                    result_data = {
                        "page_idx": page_idx,
                        "page_type": ptype,
                        "route_confidence": rp.confidence,
                        "items": data,
                    }
                else:
                    print(f"    [WARN] Unexpected JSON type: {type(data).__name__}")
        except Exception as e:
            print(f"    [WARN] LLM scan page {page_idx} failed: {e}")

        if result_data is None:
            result_data = {
                "page_idx": page_idx,
                "page_type": ptype,
                "route_confidence": rp.confidence,
                "error": "LLM analysis failed",
                "raw_text": page_text[:500] if page_text else "",
            }

        # ── Post-scan: specialised extractors ───────────────
        if ptype == "ELEVATION" and page_text:
            result_data["level_elevations"] = self._extract_elevations(page_idx, page_text)

        if ptype in ("PLAN", "SECTION") and page_text:
            grid = self._extract_grid_coords(page_idx, page_text, ptype)
            if grid and grid.get("confidence", 0) > 0.4:
                result_data["grid_coords"] = grid

        return result_data

    def _extract_elevations(self, page_idx: int, page_text: str) -> list:
        """Call elevation extractor LLM to get RL/FFL/storey heights from a page."""
        try:
            sys_p = self.prompt_factory.system_prompt_elevation_extractor()
            usr_p = self.prompt_factory.user_prompt_extract_elevations(page_text, "elevation")
            resp = call_llm(usr_p, system=sys_p)
            data = self._parse_json(resp)
            if isinstance(data, list) and data:
                print(f"    [ELEV] Page {page_idx}: extracted {len(data)} level elevations")
                return data
        except Exception as e:
            print(f"    [WARN] Elevation extract page {page_idx}: {e}")
        return []

    def _scan_pages_parallel(self, routed: list, skip_vision: bool, num_pages: int) -> dict:
        """Scan pages in parallel. Each worker opens its own VisionRenderer instance."""
        page_results = {}

        def _worker(rp):
            ptype = rp.page_type
            if ptype in ("TITLE", "UNKNOWN"):
                return str(rp.page_idx), {
                    "page_idx": rp.page_idx,
                    "page_type": ptype,
                    "confidence": rp.confidence,
                    "skipped": True,
                }
            print(f"  Scanning page {rp.page_idx+1}/{num_pages} ({ptype})...")
            renderer = None
            if not skip_vision:
                try:
                    renderer = VisionRenderer(str(self.pdf_path), dpi=self.dpi)
                except Exception as e:
                    print(f"    [WARN] Renderer open failed page {rp.page_idx}: {e}")
            try:
                result = self._scan_page(rp, skip_vision=skip_vision, _renderer=renderer)
            finally:
                if renderer:
                    try:
                        renderer.close()
                    except Exception:
                        pass
            return str(rp.page_idx), result

        n_workers = min(PARALLEL_SCAN_WORKERS, len(routed)) if routed else 1
        print(f"  [PARALLEL] Scanning {len(routed)} pages with {n_workers} workers...")
        with concurrent.futures.ThreadPoolExecutor(max_workers=n_workers) as executor:
            futures = {executor.submit(_worker, rp): rp for rp in routed}
            for future in concurrent.futures.as_completed(futures):
                rp = futures[future]
                try:
                    key, result = future.result()
                    if result:
                        page_results[key] = result
                except Exception as e:
                    print(f"    [WARN] Worker failed page {rp.page_idx}: {e}")

        return page_results

    def _extract_grid_coords(self, page_idx: int, page_text: str, ptype: str) -> dict:
        """Call grid extractor LLM to get label→mm coordinate mapping from a plan page."""
        try:
            sys_p = self.prompt_factory.system_prompt_scanner("plan")
            usr_p = self.prompt_factory.user_prompt_extract_grid(page_text, ptype.lower())
            resp = call_llm(usr_p, system=sys_p)
            data = self._parse_json(resp)
            if isinstance(data, dict) and (data.get("x_labels") or data.get("y_labels")):
                conf = data.get("confidence", 0)
                print(f"    [GRID] Page {page_idx}: extracted grid coords "
                      f"(confidence={conf:.2f}, "
                      f"x={len(data.get('x_labels',{}))}, y={len(data.get('y_labels',{}))})")
                return data
        except Exception as e:
            print(f"    [WARN] Grid extract page {page_idx}: {e}")
        return {}

    # ── TARGETED SECTION RETRY ──────────────────────────────
    def _targeted_section_retry(self, page_results: dict, batches: dict) -> dict:
        """
        After the main scan pass, collect all members whose section is null.
        Re-query up to 3 schedule pages with a targeted prompt to fill them.
        """
        # Collect member IDs with null sections
        null_ids: List[str] = []
        for pdata in page_results.values():
            for mtype in ("columns", "beams", "bracing", "footings"):
                for m in pdata.get(mtype, []):
                    if not isinstance(m, dict):
                        continue
                    if not (m.get("section") or m.get("section_size") or m.get("size")):
                        mid = m.get("id") or m.get("mark") or m.get("label")
                        if mid and str(mid) not in null_ids:
                            null_ids.append(str(mid))

        if not null_ids:
            return page_results

        schedule_idxs = batches.get("SCHEDULE", [])
        if not schedule_idxs:
            print(f"  [RETRY] {len(null_ids)} null sections but no schedule pages found")
            return page_results

        print(f"  [RETRY] {len(null_ids)} null sections → re-scanning "
              f"{min(3, len(schedule_idxs))} schedule page(s)")

        page_texts = (self.forensic_result or {}).get("page_texts", {})
        sys_p = self.prompt_factory.system_prompt_section_extractor()

        for page_idx in schedule_idxs[:3]:
            pt = (page_texts.get(str(page_idx)) or page_texts.get(page_idx) or "")
            if not pt:
                continue
            usr_p = self.prompt_factory.user_prompt_targeted_section_extract(
                pt, null_ids[:25]
            )
            try:
                resp = call_llm(usr_p, system=sys_p)
                data = self._parse_json(resp)
                if not data or not isinstance(data, dict):
                    continue
                section_map: dict = data.get("section_map", data)
                # Apply to all page results
                filled = 0
                for pdata in page_results.values():
                    for mtype in ("columns", "beams", "bracing", "footings"):
                        for m in pdata.get(mtype, []):
                            if not isinstance(m, dict):
                                continue
                            mid = m.get("id") or m.get("mark") or m.get("label")
                            if not mid or str(mid) not in section_map:
                                continue
                            info = section_map[str(mid)]
                            if not isinstance(info, dict):
                                continue
                            if not (m.get("section") or m.get("section_size")):
                                sec = info.get("section")
                                if sec and sec != "null":
                                    m["section"] = sec
                                    filled += 1
                            if not m.get("material"):
                                grade = info.get("grade") or info.get("material")
                                if grade and grade != "null":
                                    m["material"] = grade
                print(f"    [OK] Retry page {page_idx}: filled {filled} sections")
                # Remove from null_ids those now filled
                null_ids = [
                    mid for mid in null_ids
                    if not any(
                        (pdata.get("id") or pdata.get("mark")) == mid
                        and (pdata.get("section") or pdata.get("section_size"))
                        for pdata in [
                            m for pr in page_results.values()
                            for mt in ("columns", "beams", "bracing")
                            for m in pr.get(mt, [])
                        ]
                    )
                ]
                if not null_ids:
                    break
            except Exception as e:
                print(f"    [WARN] Section retry page {page_idx}: {e}")

        return page_results

    # ── JSON PARSING WITH RECOVERY ──────────────────────────
    def _parse_json(self, response: str):
        """Parse LLM JSON response with multiple recovery strategies.
        Returns dict, list, or None."""
        if not response or not response.strip():
            return None

        import re

        # Strategy 1: Direct parse
        try:
            return json.loads(response)
        except json.JSONDecodeError:
            pass

        # Strategy 2: Extract from code blocks
        m = re.search(r'```(?:json)?\s*([\s\S]*?)```', response)
        if m:
            try:
                return json.loads(m.group(1))
            except json.JSONDecodeError:
                pass

        # Strategy 3: Find outer braces or brackets
        for open_c, close_c in [('{', '}'), ('[', ']')]:
            start = response.find(open_c)
            end = response.rfind(close_c)
            if start >= 0 and end > start:
                try:
                    return json.loads(response[start:end+1])
                except json.JSONDecodeError:
                    pass

        # Strategy 4: Repair truncated JSON (add missing closing brackets/braces)
        try:
            stripped = response.strip().rstrip(",. \t\n\r")
            depth_curly = stripped.count("{") - stripped.count("}")
            depth_square = stripped.count("[") - stripped.count("]")
            repair = stripped
            repair += "]" * depth_square
            repair += "}" * depth_curly
            result = json.loads(repair)
            print(f"    [OK] JSON repaired (added {depth_square}] {depth_curly}}})")
            return result
        except (json.JSONDecodeError, Exception):
            pass

        # Strategy 5: Try json_repair library
        try:
            from json_repair import repair_json
            repaired = repair_json(response)
            return json.loads(repaired)
        except Exception:
            pass

        # Strategy 6: Last-resort — find the LAST complete JSON object/array
        try:
            # Find the last '}' and work backwards to find matching '{'
            last_brace = response.rfind('}')
            if last_brace >= 0:
                # Find matching opening brace
                depth = 0
                first_brace = -1
                for i in range(last_brace, -1, -1):
                    if response[i] == '}':
                        depth += 1
                    elif response[i] == '{':
                        depth -= 1
                        if depth == 0:
                            first_brace = i
                            break
                if first_brace >= 0:
                    return json.loads(response[first_brace:last_brace+1])
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