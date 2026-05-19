"""
Streamlit Web UI — PDF to SketchUp LOD 300 Converter
Run: streamlit run app.py
"""

import sys
import threading
import queue
from pathlib import Path
from datetime import datetime

import streamlit as st

sys.path.insert(0, str(Path(__file__).parent))
from config import INPUT_PDF_DIR, CODER_OUTPUT_FILE, SKP_OUTPUT_FILE, RUBY_OUTPUT_DIR
from core.llm_wrapper import (
    get_cache_stats, clear_cache,
    get_key_quota_status, any_key_available,
)

# ── Page config ───────────────────────────────────────────────────────────────
st.set_page_config(
    page_title="PDF -> SketchUp LOD 300",
    page_icon=":building_construction:",
    layout="wide",
    initial_sidebar_state="collapsed",
)

# ── CSS ───────────────────────────────────────────────────────────────────────
st.markdown("""
<style>
    .main-title  { font-size: 2.1rem; font-weight: 800; color: #1E3A5F; line-height:1.1; }
    .sub-caption { color: #6B7280; font-size: 0.9rem; margin-top: -4px; margin-bottom: 12px; }
    div[data-testid="metric-container"] {
        background: #F0F9FF; border: 1px solid #BAE6FD;
        border-radius: 10px; padding: 12px 8px; text-align: center;
    }
    .warn-box {
        background: #FFFBEB; border: 1px solid #FCD34D;
        border-radius: 8px; padding: 12px; font-size: 0.88rem;
    }
    .stDownloadButton > button {
        background: #2563EB !important; color: white !important;
        font-size: 1.05rem !important; padding: 12px 24px !important;
        border-radius: 8px !important; font-weight: 700 !important;
        width: 100%;
    }
    .stDownloadButton > button:hover { background: #1D4ED8 !important; }
    /* Subtle tab styling */
    button[data-baseweb="tab"] { font-size: 0.97rem; font-weight: 600; }
</style>
""", unsafe_allow_html=True)

# ── Header ────────────────────────────────────────────────────────────────────
h1, h2 = st.columns([1, 14])
with h1:
    st.markdown("## [B]")
with h2:
    st.markdown('<p class="main-title">PDF to SketchUp LOD 300 Converter</p>', unsafe_allow_html=True)
    st.markdown(
        '<p class="sub-caption">Multi-Agent AI &nbsp;-&nbsp; Gemini 2.5 Flash &nbsp;-&nbsp; '
        'Structural Steel + Architectural Elements -> Ruby Script</p>',
        unsafe_allow_html=True,
    )

st.divider()

# ── Layout: sidebar-style left + main right ───────────────────────────────────
left, right = st.columns([1.1, 1.9], gap="large")

# ═══════════════════════════════════════════
# LEFT — Upload + controls
# ═══════════════════════════════════════════
with left:
    st.subheader("[>] Upload PDF")
    uploaded_file = st.file_uploader(
        "Drag & drop or browse", type=["pdf"], label_visibility="collapsed"
    )
    if uploaded_file:
        kb = len(uploaded_file.getvalue()) / 1024
        st.success(f"[OK] **{uploaded_file.name}**\n\n{kb:.1f} KB")

    st.divider()
    st.subheader("[C] Vertex AI Status")
    st.success("[OK] Service Account connected\n\nProject: `river-bedrock-496101-a7`")

    st.divider()
    st.subheader("[*] Options")
    auto_scroll_log = st.toggle("Auto-scroll terminal log", value=True)
    st.caption("Keep last 60 lines visible while pipeline runs.")
    
    st.divider()
    
    # Pipeline version selector
    st.subheader("[#] Pipeline Version")
    pipeline_version = st.selectbox(
        "Choose pipeline:",
        [
            "V5 (Vision-First - Image Analysis)",
            "V4 (Adaptive - Structural + Architectural)",
            "V3 (Structural only)",
        ],
        help=(
            "V5: Gemini Vision nhìn TRỰC TIẾP bản vẽ 300 DPI, đa tầng, đa loại bản vẽ.\n"
            "V4: auto-detect PDF type, full structural + architectural elements.\n"
            "V3: structural steel only."
        ),
    )
    
    st.divider()
    st.subheader("[x] Cache")
    _stats_sidebar = get_cache_stats()
    st.caption(f"Hits: {_stats_sidebar['hits']}  -  Misses: {_stats_sidebar['misses']}")
    if st.button("Clear LLM Cache", use_container_width=True):
        n = clear_cache()
        st.success(f"[OK] Cleared {n} cache file(s).")
    st.divider()

    force_fresh = st.toggle(
        "[!] Force Fresh Run",
        value=False,
        help="Clear all cached data and re-run every pipeline phase from scratch. "
             "Keeps glossary.json (expensive to rebuild).",
    )

    run_disabled = uploaded_file is None
    run_btn = st.button(
        ">  Start Conversion",
        type="primary",
        disabled=run_disabled,
        use_container_width=True,
    )
    if run_disabled:
        st.caption("^^ Upload a PDF to enable.")

# ═══════════════════════════════════════════
# RIGHT — Tabs
# ═══════════════════════════════════════════
with right:
    tab_dash, tab_term = st.tabs(["[=] Dashboard", "[~] Terminal & Debug Logs"])

    # ── Tab 1: Dashboard (clean, user-facing) ──────────────────────────────
    with tab_dash:
        progress_slot  = st.empty()   # progress bar during run
        status_slot    = st.empty()   # status message
        metrics_slot   = st.empty()   # 4 metrics after run
        warning_slot   = st.empty()   # unmapped warning
        download_slot  = st.empty()   # download button

        if not run_btn:
            status_slot.info(
                "Pipeline idle. Upload a structural/architectural PDF and press **Start Conversion**."
            )

    # ── Tab 2: Terminal (technical, admin-facing) ───────────────────────────
    with tab_term:
        term_slot      = st.empty()   # live scrolling log box
        log_dl_slot    = st.empty()   # download-log button (appears after run)

        if not run_btn:
            term_slot.code("Waiting for pipeline to start...", language=None)


# ═══════════════════════════════════════════
# PIPELINE EXECUTION
# ═══════════════════════════════════════════
PHASE_ICONS = {
    "SCANNER": "[S]", "GLOSSARY": "[G]", "SCHEDULE": "[SCH]",
    "SPATIAL": "[SP]", "MAPPER": "[M]",  "CODER": "[C]",
    "ARCHITECTURAL": "[A]", "AUDITOR": "[V]", "RETRY": "[!]",
    "COMPLETE": "[OK]", "ERROR": "[ERR]",
}
PHASE_WEIGHTS = {
    "SCANNER": 8, "GLOSSARY": 3, "SCHEDULE": 18,
    "SPATIAL": 12, "MAPPER": 20, "CODER": 12,
    "ARCHITECTURAL": 15, "AUDITOR": 12,
}

def _icon(line: str) -> str:
    upper = line.upper()
    for k, v in PHASE_ICONS.items():
        if k in upper:
            return v
    return " -"


if run_btn and uploaded_file:

    # Pre-flight: verify Vertex AI connection
    if not any_key_available():
        with tab_dash:
            status_slot.error(
                "[ERR] **Vertex AI connection unavailable.**  \n"
                "Check that the service account JSON key file exists in the project root "
                "and the project `river-bedrock-496101-a7` has the Vertex AI API enabled."
            )
        st.stop()

    # Estimate API calls needed for user awareness
    _pdf_bytes  = uploaded_file.getvalue()
    _n_pages    = max(1, round(len(_pdf_bytes) / (80 * 1024)))  # ~80 KB per page heuristic
    _est_calls  = _n_pages * 5
    with tab_dash:
        status_slot.info(
            f"[PDF] This PDF (~{_n_pages} pages) will use ~{_est_calls} API calls. Starting pipeline..."
        )

    # 1. Save PDF to disk
    Path(INPUT_PDF_DIR).mkdir(parents=True, exist_ok=True)
    save_path = Path(INPUT_PDF_DIR) / uploaded_file.name
    save_path.write_bytes(uploaded_file.getvalue())

    # 2. Shared state
    log_q: queue.Queue[str] = queue.Queue()
    log_lines: list[str] = []
    result_holder: dict = {}

    def _log_fn(msg: str) -> None:
        log_q.put(msg)

    # === Pipeline version dispatch ===
    use_v5 = "V5" in pipeline_version
    use_v4 = "V4" in pipeline_version

    def _run():
        try:
            if use_v5:
                # V5 — Vision-First pipeline
                from pipeline_v5 import run_pipeline_v5
                _log_fn("[PHASE 0] VisionRenderer: Rendering PDF to 300 DPI images...")
                res = run_pipeline_v5(str(save_path), output_name="lod300_v5")
                # Map V5 result to expected app.py format
                stats = res.get("stats", {})
                bmodel = res.get("building_model", {})
                res["members_total"] = stats.get("total_elements", 0)
                res["placed"] = stats.get("total_elements", 0)
                res["unmapped"] = 0
                res["unmapped_marks"] = []
                res["audit_passed"] = stats.get("average_confidence", 0) > 0.5
                res["arch_count"] = stats.get("doors", 0) + stats.get("windows", 0) + stats.get("stairs", 0)
                res["columns"] = stats.get("columns", 0)
                res["beams"] = stats.get("beams", 0)
                res["arch_walls"] = stats.get("walls", 0)
                res["arch_doors"] = stats.get("doors", 0)
                res["arch_windows"] = stats.get("windows", 0)
                res["arch_slabs"] = stats.get("slabs", 0)
                # Log phases
                classification = res.get("classification", {})
                _log_fn(f"[PHASE 0] VisionRenderer -> {res.get('num_pages', '?')} pages rendered")
                _log_fn(f"[PHASE 1] Scanner V5 -> Vision-First Analysis ({stats.get('num_floors', 0)} floors)")
                _log_fn(f"[PHASE 2] Model Validation -> {stats.get('total_elements', 0)} elements, "
                        f"confidence={stats.get('average_confidence', 0):.2f}")
                _log_fn(f"[PHASE 3] Ruby Generator V5 -> {Path(res.get('ruby_path','')).name}")
                _log_fn(f"[COMPLETE] Pipeline V5 Vision-First finished — {res.get('elapsed_seconds', 0):.1f}s")
            elif use_v4:
                from pipeline_v4 import run_pipeline_v4
                res = run_pipeline_v4(str(save_path), output_name="lod300_v4")
                # Map V4 result to expected app.py format
                res["members_total"] = res.get("total_members", 0)
                res["placed"] = res.get("total_members", 0)
                res["unmapped"] = 0
                res["unmapped_marks"] = []
                res["audit_passed"] = True
                res["arch_count"] = sum(
                    len(f.get("arch_doors", [])) + len(f.get("arch_windows", [])) +
                    len(f.get("arch_slabs", [])) + len(f.get("arch_stairs", []))
                    for f in res.get("model", {}).get("floors", [])
                )
                # Log phases
                _log_fn(f"[PHASE 0] PDF Classification -> {res.get('pdf_type', 'unknown')}")
                _log_fn(f"[PHASE 1] Scanner V4 -> manifest ({res.get('num_floors', 0)} floors)")
                _log_fn(f"[PHASE 2] Extractor V4 -> model ({res.get('total_members', 0)} elements)")
                _log_fn(f"[PHASE 3] Ruby Generator V4 -> {Path(res.get('ruby_path','')).name}")
                _log_fn("[COMPLETE] Pipeline V4 finished successfully")
            else:
                from main import run_pipeline
                res = run_pipeline(str(save_path), log_fn=_log_fn)
        except Exception as exc:
            res = {
                "ruby_path": None, "error": str(exc),
                "members_total": 0, "placed": 0,
                "unmapped": 0, "unmapped_marks": [], "audit_passed": False,
            }
        result_holder.update(res)
        log_q.put("__DONE__")

    # Force-fresh: wipe LLM cache + output JSONs (keep glossary.json)
    if force_fresh:
        _proj_root  = Path(__file__).parent
        n_llm       = clear_cache()
        _out_dir    = _proj_root / "data" / "output_json"
        _cleared    = []
        if _out_dir.exists():
            for _jf in _out_dir.glob("*.json"):
                if _jf.name != "glossary.json":
                    _jf.unlink(missing_ok=True)
                    _cleared.append(_jf.name)
        with tab_dash:
            status_slot.info(
                f"[FRESH] Force fresh run -- cleared {n_llm} LLM cache file(s) + "
                f"{len(_cleared)} output file(s)"
                + (f": {', '.join(_cleared)}" if _cleared else "")
            )

    thread = threading.Thread(target=_run, daemon=True)
    thread.start()

    # 3. Live streaming into BOTH tabs simultaneously
    current_pct = 0

    with tab_dash:
        progress_slot.progress(0, text="Initialising pipeline...")
        status_slot.empty()

    while True:
        try:
            msg = log_q.get(timeout=0.4)
        except queue.Empty:
            continue

        if msg == "__DONE__":
            break

        log_lines.append(msg)

        # ── Advance progress bar (Dashboard) ──
        upper = msg.upper()
        for phase_key, weight in PHASE_WEIGHTS.items():
            if phase_key in upper and "PHASE" in upper:
                current_pct = min(current_pct + int(weight / sum(PHASE_WEIGHTS.values()) * 100), 95)
                with tab_dash:
                    progress_slot.progress(current_pct, text=f"Running: {msg[:55]}...")
                break

        # ── Update terminal (Tab 2) ──
        display_lines = log_lines[-60:] if auto_scroll_log else log_lines
        display = "\n".join(f"{_icon(ln)}  {ln}" for ln in display_lines)
        with tab_term:
            term_slot.code(display, language=None)

    # 4. Final progress tick
    with tab_dash:
        progress_slot.progress(100, text="Done.")

    # ── Populate Dashboard (Tab 1) ─────────────────────────────────────────
    error     = result_holder.get("error")
    ruby_path = result_holder.get("ruby_path")

    with tab_dash:
        if error:
            status_slot.error(f"[ERR] **Pipeline failed:** {error}")
            progress_slot.empty()
        else:
            status_slot.success("[OK] Pipeline complete!")

            # Metrics row
            with metrics_slot.container():
                st.markdown("#### [*] Extraction Summary")
                c1, c2, c3, c4, c5 = st.columns(5)
                c1.metric("Total Members",  result_holder.get("members_total", 0))
                c2.metric("3D Placed",       result_holder.get("placed", 0))
                c3.metric("[!] Unmapped",     result_holder.get("unmapped", 0))
                c4.metric("Audit",           "[OK] Pass" if result_holder.get("audit_passed") else "[!] Warn")
                c5.metric("API Calls Saved", get_cache_stats()["hits"])

            # Architectural & Structural metrics
            arch_count = result_holder.get("arch_count", 0)
            if arch_count > 0:
                st.markdown("#### [A] Elements Breakdown")
                w1, w2, w3, w4, w5 = st.columns(5)
                w1.metric("Columns", result_holder.get("columns", 0))
                w2.metric("Beams", result_holder.get("beams", 0))
                w3.metric("Walls", result_holder.get("arch_walls", 0))
                w4.metric("Doors+Win", result_holder.get("arch_doors", 0) + result_holder.get("arch_windows", 0))
                w5.metric("Slabs", result_holder.get("arch_slabs", 0))

            unmapped_marks = result_holder.get("unmapped_marks", [])
            if unmapped_marks:
                warning_slot.markdown(
                    f'<div class="warn-box">[!] <b>{len(unmapped_marks)} member(s)</b> could not be '
                    f'auto-placed: <code>{", ".join(unmapped_marks)}</code><br>'
                    f'In SketchUp -> filter layer <b>LOD300_UNMAPPED_NEEDS_REVIEW</b></div>',
                    unsafe_allow_html=True,
                )

        # Download buttons (always show if .rb exists, even on audit warn)
        if ruby_path and Path(ruby_path).exists():
            _pdf_stem   = uploaded_file.name.replace(".pdf", "")
            _ts         = datetime.now().strftime("%Y%m%d_%H%M")
            rb_bytes    = Path(ruby_path).read_bytes()
            rb_name     = f"LOD300_{_pdf_stem}_{_ts}.rb"
            skp_path    = Path(SKP_OUTPUT_FILE)
            with download_slot.container():
                st.divider()
                st.markdown("#### [>>] Download Output Files")

                # Main .rb
                st.download_button(
                    label=f"[v] Download  {rb_name} (SketchUp Ruby)",
                    data=rb_bytes,
                    file_name=rb_name,
                    mime="text/plain",
                    use_container_width=True,
                )

                # Combined Steel + Architectural .rb (V3 legacy)
                combined_path = Path(CODER_OUTPUT_FILE).parent / "lod300_combined.rb"
                if combined_path.exists():
                    combined_bytes = combined_path.read_bytes()
                    combined_name  = f"LOD300_{_pdf_stem}_combined_{_ts}.rb"
                    st.download_button(
                        label=f"[v] Download  {combined_name} (Steel + Architecture)",
                        data=combined_bytes,
                        file_name=combined_name,
                        mime="text/plain",
                        use_container_width=True,
                    )

                st.caption(
                    f"SketchUp: **Extensions -> Ruby Console** -> `load 'path/to/{combined_name if combined_path.exists() else rb_name}'`  "
                    f"&nbsp;-&nbsp; {datetime.now().strftime('%Y-%m-%d %H:%M')}"
                )
                if skp_path.exists():
                    skp_bytes = skp_path.read_bytes()
                    skp_mb    = len(skp_bytes) / (1024 * 1024)
                    skp_name  = f"LOD300_{_pdf_stem}_{_ts}.skp"
                    st.download_button(
                        label=f"[v] Download  {skp_name}",
                        data=skp_bytes,
                        file_name=skp_name,
                        mime="application/octet-stream",
                        use_container_width=True,
                    )
                    st.caption(f"SketchUp model - {skp_mb:.1f} MB - open directly in SketchUp Pro")
                else:
                    st.caption(
                        "[i] **lod300_model.skp** will appear here after you run the .rb script in SketchUp "
                        "(it auto-saves to the same folder)."
                    )

    # ── Populate Terminal (Tab 2) ──────────────────────────────────────────
    full_log = "\n".join(log_lines)
    with tab_term:
        # Show full log (not truncated)
        term_slot.code(full_log, language=None)

        # Download log button
        log_dl_slot.download_button(
            label="[=] Download pipeline_debug.log",
            data=full_log.encode("utf-8"),
            file_name=f"pipeline_debug_{datetime.now().strftime('%Y%m%d_%H%M%S')}.log",
            mime="text/plain",
        )

# ── Footer ────────────────────────────────────────────────────────────────────
st.divider()
st.markdown(
    "<center><small>PDF to SketchUp LOD 300 &nbsp;-&nbsp; Gemini 2.5 Flash "
    "&nbsp;-&nbsp; Multi-Agent AI Pipeline</small></center>",
    unsafe_allow_html=True,
)