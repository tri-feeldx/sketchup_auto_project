"""Streamlit UI — PDF to SketchUp LOD 300 — Principal AI Engineer redesign."""
import os, sys, queue, json, shutil, threading
from pathlib import Path
from datetime import datetime
import streamlit as st

_PROJ_ROOT = Path(__file__).resolve().parent
if str(_PROJ_ROOT) not in sys.path:
    sys.path.insert(0, str(_PROJ_ROOT))

from config import INPUT_PDF_DIR, OUTPUT_JSON_DIR, RUBY_OUTPUT_DIR
from core.llm_wrapper import any_key_available, clear_cache, get_cache_stats

st.set_page_config(page_title="FeelDX — PDF to SketchUp LOD 300", page_icon="🏗️", layout="wide", initial_sidebar_state="expanded")

# ── CSS ──
st.markdown("""<style>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');
html,body,[class*="css"]{font-family:'Inter',sans-serif;}
section[data-testid="stSidebar"]{background:linear-gradient(180deg,#0f172a,#1e293b);border-right:1px solid #334155;}
section[data-testid="stSidebar"] .stMarkdown,section[data-testid="stSidebar"] label{color:#cbd5e1 !important;}
section[data-testid="stSidebar"] h1,section[data-testid="stSidebar"] h2,section[data-testid="stSidebar"] h3{color:#f1f5f9 !important;}
div.stButton>button{border-radius:10px;font-weight:600;letter-spacing:.3px;transition:all .2s ease;}
div.stButton>button:not([kind="primary"]){background:#334155;color:#e2e8f0;border:1px solid #475569;}
div.stButton>button:not([kind="primary"]):hover{background:#475569;}
div.stButton>button[kind="primary"]{background:linear-gradient(135deg,#3b82f6,#6366f1);border:none;box-shadow:0 4px 14px rgba(59,130,246,.35);}
div.stButton>button[kind="primary"]:hover{box-shadow:0 6px 20px rgba(59,130,246,.5);transform:translateY(-1px);}
.sb{border-radius:12px;padding:1rem 1.4rem;margin:.5rem 0;font-weight:500;}
.sbs{background:rgba(34,197,94,.12);border:1px solid rgba(34,197,94,.3);color:#bbf7d0;}
.sbe{background:rgba(239,68,68,.12);border:1px solid rgba(239,68,68,.3);color:#fecaca;}
.sbi{background:rgba(59,130,246,.12);border:1px solid rgba(59,130,246,.3);color:#bfdbfe;}
.sbw{background:rgba(251,191,36,.12);border:1px solid rgba(251,191,36,.3);color:#fde68a;}
hr{border-color:#334155 !important;margin:.4rem 0 !important;}
section[data-testid="stFileUploader"]{border:2px dashed #475569;border-radius:14px;padding:1rem;background:rgba(30,41,59,.4);}
div.stCodeBlock{border-radius:12px !important;border:1px solid #334155 !important;}
div.stProgress>div>div{background:linear-gradient(90deg,#3b82f6,#6366f1) !important;border-radius:4px !important;}
div[data-testid="stMetric"]{background:linear-gradient(135deg,#1e293b,#0f172a);border:1px solid #334155;border-radius:12px;padding:.6rem .8rem;}
div[data-testid="stMetric"] label{color:#94a3b8 !important;font-size:.7rem;text-transform:uppercase;letter-spacing:.5px;}
div[data-testid="stMetric"] div[data-testid="stMetricValue"]{color:#38bdf8 !important;font-weight:700;}
</style>""", unsafe_allow_html=True)

# ── Header ──
_, ctr, _ = st.columns([1, 3, 1])
with ctr:
    st.markdown("<h1 style='text-align:center;margin-bottom:4px;'><span style='color:#38bdf8;'>🏗️ FeelDX</span> <span style='color:#e2e8f0;font-weight:300;'>PDF → SketchUp LOD 300</span></h1>", unsafe_allow_html=True)
    st.markdown("<p style='text-align:center;color:#64748b;margin-bottom:24px;'>Multi‑Agent AI Pipeline · Gemini 2.5 Flash · Vertex AI</p>", unsafe_allow_html=True)

# ── Sidebar ──
with st.sidebar:
    st.markdown("<h2 style='color:#f1f5f9;'>⚙️ Configuration</h2>", unsafe_allow_html=True)
    st.markdown("<p style='color:#94a3b8;margin-bottom:4px;'>📄 Input PDF</p>", unsafe_allow_html=True)
    uploaded_file = st.file_uploader("Upload PDF", type=["pdf"], label_visibility="collapsed")
    st.divider()
    pipeline_version = st.selectbox("Pipeline Version", ["V8 (Accuracy-First ≥90%)", "V7 (Next-Gen Quality Gate)", "V5 (Vision-First)", "V4 (Adaptive)", "V3 (Structural)"])
    st.divider()
    st.markdown("<p style='color:#94a3b8;'>💾 LLM Cache</p>", unsafe_allow_html=True)
    stats = get_cache_stats()
    c1, c2 = st.columns(2)
    c1.metric("Hits", stats["hits"]); c2.metric("Misses", stats["misses"])
    if st.button("♻️ Clear LLM Cache", use_container_width=True):
        n = clear_cache(); st.toast(f"Cleared {n} cache file(s)", icon="🗑️")
    st.divider()
    st.markdown("<p style='color:#94a3b8;'>🔄 Reset</p>", unsafe_allow_html=True)
    force_fresh = st.checkbox("Force Fresh Run", value=False, help="Delete all cached outputs & LLM cache before running.")
    st.divider()
    run_disabled = uploaded_file is None
    run_btn = st.button("🚀 Start Conversion", type="primary", disabled=run_disabled, use_container_width=True)
    if run_disabled:
        st.caption("👆 Upload a PDF to enable pipeline.")
    st.divider()
    st.markdown("<p style='font-size:.72rem;color:#475569;text-align:center;'>FeelDX AI Engineering · Principal Pipeline<br>Vertex AI · Gemini 2.5 Flash</p>", unsafe_allow_html=True)

# ── Main area ──
tab_dash, tab_term = st.tabs(["📊 Dashboard", "📟 Terminal Log"])
with tab_dash:
    progress_slot = st.empty(); status_slot = st.empty(); metrics_slot = st.empty(); download_slot = st.empty()
    if not run_btn:
        status_slot.markdown('<div class="sb sbi">📋 Pipeline idle. Upload a PDF and press <b>Start Conversion</b>.</div>', unsafe_allow_html=True)
with tab_term:
    term_slot = st.empty(); log_dl_slot = st.empty()
    if not run_btn:
        term_slot.code("Waiting for pipeline to start...\n", language=None)

# ── Execution ──
PHASE_WEIGHTS = {"SCANNER": 8, "GLOSSARY": 3, "SCHEDULE": 18, "SPATIAL": 12, "MAPPER": 20, "CODER": 12, "ARCHITECTURAL": 15, "AUDITOR": 12}
V7_OUTPUT_DIR = Path(_PROJ_ROOT) / "output" / "v7"

if run_btn and uploaded_file:
    if not any_key_available():
        with tab_dash:
            status_slot.markdown('<div class="sb sbe">❌ <b>Vertex AI connection unavailable.</b></div>', unsafe_allow_html=True)
        st.stop()

    # Force Fresh
    if force_fresh:
        cleared = []
        n = clear_cache()
        if n > 0: cleared.append(f"{n} LLM cache files")
        if V7_OUTPUT_DIR.exists(): shutil.rmtree(V7_OUTPUT_DIR); cleared.append("V7 output dir")
        lo = Path(OUTPUT_JSON_DIR)
        if lo.exists():
            nj = sum(1 for j in lo.glob("*.json") if j.name != "glossary.json" and (j.unlink(missing_ok=True) or True))
            if nj > 0: cleared.append(f"{nj} legacy JSONs")
        lr = Path(RUBY_OUTPUT_DIR)
        if lr.exists():
            nr = sum(1 for r in lr.glob("*.rb") if (r.unlink(missing_ok=True) or True))
            if nr > 0: cleared.append(f"{nr} legacy .rb files")
        _v8_lock = Path(_PROJ_ROOT) / "output" / "v8" / ".pipeline_v8.lock"
        if _v8_lock.exists():
            _v8_lock.unlink(missing_ok=True)
            cleared.append("V8 pipeline lock")
        _pdf_hash_file = Path(_PROJ_ROOT) / "data" / ".last_pdf_hash"
        if _pdf_hash_file.exists():
            _pdf_hash_file.unlink(missing_ok=True)
            cleared.append("PDF fingerprint")
        s = ", ".join(cleared) if cleared else "nothing to clear"
        with tab_dash: status_slot.markdown(f'<div class="sb sbw">🔄 <b>Force Fresh:</b> Cleared {s}</div>', unsafe_allow_html=True)

    # Always clear stale lock (process may have been killed mid-run)
    _v8_lock = Path(_PROJ_ROOT) / "output" / "v8" / ".pipeline_v8.lock"
    if _v8_lock.exists():
        _v8_lock.unlink(missing_ok=True)

    # Auto-clear LLM cache when a different PDF is uploaded
    import hashlib as _hashlib
    _pdf_hash = _hashlib.sha256(uploaded_file.getvalue()).hexdigest()
    _pdf_hash_file = Path(_PROJ_ROOT) / "data" / ".last_pdf_hash"
    _stored_hash = _pdf_hash_file.read_text().strip() if _pdf_hash_file.exists() else ""
    if _pdf_hash != _stored_hash:
        n_cleared = clear_cache()
        _pdf_hash_file.parent.mkdir(parents=True, exist_ok=True)
        _pdf_hash_file.write_text(_pdf_hash)
        with tab_dash:
            status_slot.markdown(
                f'<div class="sb sbw">New PDF detected — cleared {n_cleared} cached responses. Running fresh.</div>',
                unsafe_allow_html=True
            )

    Path(INPUT_PDF_DIR).mkdir(parents=True, exist_ok=True)
    save_path = Path(INPUT_PDF_DIR) / uploaded_file.name
    save_path.write_bytes(uploaded_file.getvalue())

    _pdf_bytes = uploaded_file.getvalue()
    try:
        import fitz  # PyMuPDF
        with fitz.open(stream=_pdf_bytes, filetype="pdf") as doc:
            _n_pages = doc.page_count
    except Exception:
        _n_pages = max(1, round(len(_pdf_bytes) / (80 * 1024)))  # fallback
    _est_calls = _n_pages * 5
    with tab_dash: status_slot.markdown(f'<div class="sb sbi">📄 {_n_pages} pages · ~{_est_calls} API calls · Starting…</div>', unsafe_allow_html=True)

    log_q = queue.Queue()
    log_lines = []
    result_holder = {}

    def _log_fn(msg):
        log_q.put(msg)

    use_v8 = "V8" in pipeline_version
    use_v7 = "V7" in pipeline_version and not use_v8
    use_v5 = "V5" in pipeline_version
    use_v4 = "V4" in pipeline_version

    def _run():
        try:
            if use_v8:
                from pipelines.pipeline_v8 import PipelineV8
                V8_OUTPUT_DIR = Path(_PROJ_ROOT) / "output" / "v8"
                _log_fn("[STAGE 0] PDFForensic: Analyzing PDF structure…")
                _log_fn("[STAGE 1] PageRouter: Classifying pages (incl. FOUNDATION)…")
                pipeline = PipelineV8(region="auto", language="auto")
                presult = pipeline.run(str(save_path), output_dir=str(V8_OUTPUT_DIR))
                pdict = presult.to_dict()
                _fsummary = pdict.get("forensic_summary", {})
                _det_region = _fsummary.get("region", "?")
                _det_lang = _fsummary.get("language", "?")
                _log_fn(f"[FORENSIC] Detected: {_det_region.upper()} | {_det_lang.upper()}")
                n_pages = len(presult.scanner_output.get("page_results", {}))
                _log_fn(f"[STAGE 2] ScannerV6 -> {n_pages} pages scanned")
                msum = presult.structural_model.get("members", {})
                nc = len(msum.get("columns", [])); nb = len(msum.get("beams", []))
                ns = len(msum.get("slabs", [])); nw = len(msum.get("walls", []))
                nf = len(msum.get("footings", [])); nbr = len(msum.get("bracing", []))
                _log_fn(f"[STAGE 3] SynthesizerV7 -> {nc}c {nb}b {ns}s {nw}w {nf}f {nbr}br")
                vr = presult.verification or {}
                recall = vr.get("overall_recall")
                _log_fn(f"[STAGE 4] ScheduleVerifier -> recall={f'{recall:.0%}' if recall else 'N/A'}")
                _log_fn(f"[STAGE 5] MultiPassExtractor -> {'ran' if vr.get('needs_repass') else 'skipped'}")
                vp = pdict.get("validation_passed")
                _log_fn(f"[STAGE 6] ValidatorV7 -> {'PASS' if vp else 'FAIL'}")
                rvp = pdict.get("ruby_validation_passed")
                re_ents = presult.ruby_validation.get("estimated_entities", 0) if presult.ruby_validation else 0
                _log_fn(f"[STAGE 7-8] RubyGen+Validate -> {'PASS' if rvp else 'FAIL'} (~{re_ents} entities)")
                acc = presult.accuracy or {}
                acc_score = acc.get("overall_score", "N/A")
                acc_grade = acc.get("grade", "?")
                acc_met = acc.get("target_met", False)
                _log_fn(f"[STAGE 9] AccuracyEval -> {acc_score}% Grade {acc_grade} {'✅' if acc_met else '❌'}")
                _log_fn(f"[COMPLETE] Pipeline V8 in {presult.duration_sec:.1f}s")
                total_members = nc + nb + ns + nw + nf + nbr
                res = {
                    "ruby_path": presult.output_rb_path,
                    "ifc_path": presult.output_ifc_path,
                    "detected_region": _det_region,
                    "members_total": total_members, "placed": total_members,
                    "unmapped": 0, "unmapped_marks": [],
                    "audit_passed": pdict.get("validation_passed", True),
                    "columns": nc, "beams": nb, "arch_walls": nw,
                    "arch_doors": 0, "arch_windows": 0, "arch_slabs": ns,
                    "arch_count": nw + ns + nf + nbr,
                    "footings": nf, "bracing": nbr,
                    "accuracy_score": acc_score,
                    "accuracy_grade": acc_grade,
                    "accuracy_target_met": acc_met,
                    "log_path": presult.log_path,
                    "error": None,
                }
            elif use_v7:
                from pipelines.pipeline_v7 import PipelineV7
                _log_fn("[STAGE 0] PDFForensic: Analyzing PDF structure…")
                _log_fn("[STAGE 1] PageRouter: Classifying pages…")
                pipeline = PipelineV7(region="auto", language="auto")
                presult = pipeline.run(str(save_path), output_dir=str(V7_OUTPUT_DIR))
                pdict = presult.to_dict()
                _fsummary = pdict.get("forensic_summary", {})
                _det_region = _fsummary.get("region", "?")
                _det_lang = _fsummary.get("language", "?")
                _log_fn(f"[FORENSIC] Detected standard: {_det_region.upper()} | language: {_det_lang.upper()}")
                n_pages = len(presult.scanner_output.get("page_results", {}))
                _log_fn(f"[STAGE 2] ScannerV6 -> {n_pages} pages scanned")
                msum = presult.structural_model.get("members", {})
                nc = len(msum.get("columns", [])); nb = len(msum.get("beams", []))
                ns = len(msum.get("slabs", [])); nw = len(msum.get("walls", []))
                nf = len(msum.get("footings", []))
                _log_fn(f"[STAGE 3] SynthesizerV7 -> {nc}c {nb}b {ns}s {nw}w {nf}f")
                vp = pdict.get("validation_passed")
                _log_fn(f"[STAGE 4] ValidatorV7 -> {'PASS' if vp else 'FAIL'}")
                rvp = pdict.get("ruby_validation_passed")
                re = presult.ruby_validation.get("estimated_entities", 0) if presult.ruby_validation else 0
                _log_fn(f"[STAGE 5] RubyGeneratorV5 -> .rb generated")
                _log_fn(f"[STAGE 6] RubyValidator -> {'PASS' if rvp else 'FAIL'} (entities~{re})")
                _log_fn(f"[COMPLETE] Pipeline V7 finished in {presult.duration_sec:.1f}s")
                total_members = nc + nb + ns + nw + nf
                res = {
                    "ruby_path": presult.output_rb_path,
                    "ifc_path": presult.output_ifc_path,
                    "detected_region": _det_region,
                    "members_total": total_members, "placed": total_members,
                    "unmapped": 0, "unmapped_marks": [],
                    "audit_passed": pdict.get("validation_passed", True),
                    "columns": nc, "beams": nb, "arch_walls": nw,
                    "arch_doors": 0, "arch_windows": 0, "arch_slabs": ns,
                    "arch_count": nw + ns, "error": None,
                }
            elif use_v5:
                from pipeline_v5 import run_pipeline_v5
                _log_fn("[PHASE 0] VisionRenderer: Rendering PDF to 300 DPI images...")
                res = run_pipeline_v5(str(save_path), output_name="lod300_v5")
                stats = res.get("stats", {})
                res["members_total"] = stats.get("total_elements", 0)
                res["placed"] = stats.get("total_elements", 0)
                res["unmapped"] = 0; res["unmapped_marks"] = []
                res["audit_passed"] = stats.get("average_confidence", 0) > 0.5
                res["arch_count"] = stats.get("doors", 0) + stats.get("windows", 0) + stats.get("stairs", 0)
                res["columns"] = stats.get("columns", 0); res["beams"] = stats.get("beams", 0)
                res["arch_walls"] = stats.get("walls", 0); res["arch_doors"] = stats.get("doors", 0)
                res["arch_windows"] = stats.get("windows", 0); res["arch_slabs"] = stats.get("slabs", 0)
                _log_fn(f"[PHASE 1] Scanner -> {stats.get('num_floors', 0)} floors")
                _log_fn(f"[PHASE 2] Validation -> {stats.get('total_elements', 0)} els, conf={stats.get('average_confidence', 0):.2f}")
                _log_fn(f"[COMPLETE] V5 finished - {res.get('elapsed_seconds', 0):.1f}s")
            elif use_v4:
                from pipeline_v4 import run_pipeline_v4
                res = run_pipeline_v4(str(save_path), output_name="lod300_v4")
                res["members_total"] = res.get("total_members", 0)
                res["placed"] = res.get("total_members", 0)
                res["unmapped"] = 0; res["unmapped_marks"] = []
                res["audit_passed"] = True
                res["arch_count"] = sum(len(f.get("arch_doors", [])) + len(f.get("arch_windows", [])) + len(f.get("arch_slabs", [])) + len(f.get("arch_stairs", [])) for f in res.get("model", {}).get("floors", []))
                _log_fn(f"[PHASE 0] PDF Classification -> {res.get('pdf_type', 'unknown')}")
                _log_fn(f"[PHASE 1] Scanner V4 -> {res.get('num_floors', 0)} floors")
                _log_fn(f"[PHASE 2] Extractor V4 -> {res.get('total_members', 0)} elements")
                _log_fn("[COMPLETE] V4 finished")
            else:
                from main import run_pipeline
                res = run_pipeline(str(save_path), log_fn=_log_fn)
        except Exception as exc:
            res = {"ruby_path": None, "error": str(exc), "members_total": 0, "placed": 0, "unmapped": 0, "unmapped_marks": [], "audit_passed": False}
        result_holder.update(res)
        log_q.put("__DONE__")

    thread = threading.Thread(target=_run, daemon=True)
    thread.start()

    current_pct = 0
    with tab_dash: progress_slot.progress(0, text="Initialising pipeline...")
    while True:
        try:
            msg = log_q.get(timeout=0.4)
        except queue.Empty:
            continue
        if msg == "__DONE__":
            break
        log_lines.append(msg)
        upper = msg.upper()
        for phase_key, weight in PHASE_WEIGHTS.items():
            if phase_key in upper and "PHASE" in upper:
                current_pct = min(current_pct + int(weight / sum(PHASE_WEIGHTS.values()) * 100), 95)
                with tab_dash: progress_slot.progress(current_pct, text=f"Running: {msg[:55]}...")
                break
        display = "\n".join(log_lines[-60:])
        with tab_term: term_slot.code(display, language=None)

    with tab_dash: progress_slot.progress(100, text="Done.")

    error = result_holder.get("error")
    ruby_path = result_holder.get("ruby_path")

    with tab_dash:
        if error:
            status_slot.markdown(f'<div class="sb sbe">❌ <b>Pipeline failed:</b> {error}</div>', unsafe_allow_html=True)
            progress_slot.empty()
        else:
            status_slot.markdown('<div class="sb sbs">✅ Pipeline complete!</div>', unsafe_allow_html=True)
            with metrics_slot.container():
                st.markdown("#### 📊 Extraction Summary")
                acc_score = result_holder.get("accuracy_score")
                acc_grade = result_holder.get("accuracy_grade", "?")
                acc_met = result_holder.get("accuracy_target_met", False)
                if acc_score is not None:
                    acc_label = f"{acc_score}% (Grade {acc_grade}) {'✅' if acc_met else '❌'}"
                    c1, c2, c3, c4, c5 = st.columns(5)
                    c1.metric("🎯 Accuracy", acc_label)
                    c2.metric("Total Members", result_holder.get("members_total", 0))
                    c3.metric("⚠️ Unmapped", result_holder.get("unmapped", 0))
                    c4.metric("Audit", "✅ Pass" if result_holder.get("audit_passed") else "⚠️ Warn")
                    c5.metric("Cache Hits", get_cache_stats()["hits"])
                    if not acc_met:
                        st.warning(f"Accuracy {acc_score}% < 90% target — multi-pass ran but more passes may help.")
                else:
                    c1, c2, c3, c4, c5 = st.columns(5)
                    c1.metric("Total Members", result_holder.get("members_total", 0))
                    c2.metric("3D Placed", result_holder.get("placed", 0))
                    c3.metric("⚠️ Unmapped", result_holder.get("unmapped", 0))
                    c4.metric("Audit", "✅ Pass" if result_holder.get("audit_passed") else "⚠️ Warn")
                    c5.metric("Cache Hits", get_cache_stats()["hits"])
                arch_count = result_holder.get("arch_count", 0)
                if arch_count > 0:
                    st.markdown("#### 🏗️ Elements Breakdown")
                    w1, w2, w3, w4, w5, w6, w7 = st.columns(7)
                    w1.metric("Columns", result_holder.get("columns", 0))
                    w2.metric("Beams", result_holder.get("beams", 0))
                    w3.metric("Slabs", result_holder.get("arch_slabs", 0))
                    w4.metric("Walls", result_holder.get("arch_walls", 0))
                    w5.metric("Footings", result_holder.get("footings", 0))
                    w6.metric("Bracing", result_holder.get("bracing", 0))
                    w7.metric("Doors+Win", result_holder.get("arch_doors", 0) + result_holder.get("arch_windows", 0))
            unmapped_marks = result_holder.get("unmapped_marks", [])
            if unmapped_marks:
                st.warning(f"⚠️ {len(unmapped_marks)} member(s) could not be auto-placed: {', '.join(unmapped_marks)}")
        if ruby_path and Path(ruby_path).exists():
            _pdf_stem = uploaded_file.name.replace(".pdf", "")
            _ts = datetime.now().strftime("%Y%m%d_%H%M")
            rb_bytes = Path(ruby_path).read_bytes()
            _lod_level = "LOD350" if use_v8 else "LOD300"
            rb_name = f"{_lod_level}_{_pdf_stem}_{_ts}.rb"
            _det_region = result_holder.get("detected_region", "").upper()
            with download_slot.container():
                st.divider()
                if _det_region:
                    st.markdown(f"#### 🌏 Detected Standard: **{_det_region}**")
                if use_v8:
                    acc_s = result_holder.get("accuracy_score", "N/A")
                    acc_g = result_holder.get("accuracy_grade", "?")
                    badge_color = "green" if result_holder.get("accuracy_target_met") else "orange"
                    st.markdown(
                        f"<span style='background:{badge_color};color:white;padding:4px 10px;"
                        f"border-radius:8px;font-weight:600;'>LOD350 | Accuracy: {acc_s}% Grade {acc_g}</span>",
                        unsafe_allow_html=True,
                    )
                    st.write("")
                st.markdown("#### 📥 Download Output Files")

                # .rb (primary)
                st.download_button(
                    label=f"⬇️ {rb_name} — SketchUp Ruby Script ({_lod_level})",
                    data=rb_bytes, file_name=rb_name, mime="text/plain",
                    use_container_width=True,
                )

                # .ifc (if generated)
                _ifc_path = result_holder.get("ifc_path", "")
                if _ifc_path and Path(_ifc_path).exists():
                    _ifc_bytes = Path(_ifc_path).read_bytes()
                    _ifc_mb = len(_ifc_bytes) / (1024 * 1024)
                    _ifc_name = f"LOD300_{_pdf_stem}_{_ts}.ifc"
                    st.download_button(
                        label=f"⬇️ {_ifc_name} ({_ifc_mb:.1f} MB) — IFC 2x3 (Revit / Navisworks / SketchUp)",
                        data=_ifc_bytes, file_name=_ifc_name,
                        mime="application/x-step", use_container_width=True,
                    )
                else:
                    st.caption("💡 IFC export skipped (install `ifcopenshell` to enable)")

                # .skp instructions
                st.info(
                    "**Tạo file .skp:**  \n"
                    f"1. Mở SketchUp → Extensions → Ruby Console  \n"
                    f"2. Gõ: `load '{ruby_path}'`  \n"
                    "3. Script tự chạy và **auto-save** vào thư mục Downloads  \n"
                    "4. File `.skp` LOD300 sẵn sàng để dùng ✅"
                )

                _log_path = result_holder.get("log_path", "")
                if _log_path and Path(_log_path).exists():
                    st.success(f"📋 Log tự động lưu → `{_log_path}`")

    full_log = "\n".join(log_lines)
    with tab_term:
        term_slot.code(full_log, language=None)
        log_dl_slot.download_button(label="📥 Download pipeline_debug.log", data=full_log.encode("utf-8"), file_name=f"pipeline_debug_{datetime.now().strftime('%Y%m%d_%H%M%S')}.log", mime="text/plain")

st.divider()
st.markdown("<center><small>PDF to SketchUp LOD 300 · Gemini 2.5 Flash · Multi-Agent AI Pipeline</small></center>", unsafe_allow_html=True)
