"""Copy 2 Australian PDFs into workspace, handle Vietnamese paths."""
import os, shutil

USERPROFILE = os.environ["USERPROFILE"]

srcs = [
    ("C:\\Users\\minht\\Downloads\\Structural.pdf", "data/input_pdf/Structural.pdf"),
]

# Scan OneDrive for St Carloa Moama
onedrive = os.path.join(USERPROFILE, "OneDrive")
for root, dirs, files in os.walk(onedrive):
    for f in files:
        if "St Carloa Moama" in f and f.endswith(".pdf"):
            srcs.append((os.path.join(root, f), "data/input_pdf/St_Carloa_Moama.pdf"))
            break

for src, dst in srcs:
    if os.path.exists(src):
        os.makedirs(os.path.dirname(dst), exist_ok=True)
        shutil.copy2(src, dst)
        print(f"OK: {os.path.basename(dst)} ({os.path.getsize(dst)} bytes)")
    else:
        print(f"MISSING: {src}")

# List all PDFs in input_pdf
print("\n=== input_pdf contents ===")
for f in os.listdir("data/input_pdf"):
    if f.endswith(".pdf"):
        sz = os.path.getsize(os.path.join("data/input_pdf", f))
        print(f"  {f:40s} {sz:>10,d} bytes")