"""Analyze V5 pipeline output quality."""
import json, sys

with open("data/output_json/test_v5_final_model.json", "r", encoding="utf-8") as f:
    j = json.load(f)

floors = j.get("floors", [])
print("=== FLOOR SUMMARY ===")
for i, f in enumerate(floors):
    name = f.get("name", "?")
    z = f.get("elevation_mm", 0)
    h = f.get("floor_height_mm", 0)
    pages = f.get("plan_page_indices", [])
    cols = len(f.get("columns", []))
    beams = len(f.get("beams", []))
    walls = len(f.get("walls", []))
    print(f"F{i}: {name:15s} z={z:6d} h={h} cols={cols:3d} beams={beams:3d} walls={walls:2d} pages={pages}")

print("\n=== ELEMENT SAMPLE (Floor 0) ===")
f0 = floors[0] if floors else {}
for item in f0.get("columns", [])[:3]:
    print("COL:", json.dumps(item, ensure_ascii=False))
for item in f0.get("beams", [])[:3]:
    print("BEAM:", json.dumps(item, ensure_ascii=False))
for item in f0.get("walls", [])[:3]:
    print("WALL:", json.dumps(item, ensure_ascii=False))

pc = j.get("page_classifications", {})
print("\n=== PAGE CLASSIFICATION ===")
print("plan pages:", pc.get("plan_page_indices"))
print("elev pages:", pc.get("elevation_page_indices"))
print("sched pages:", pc.get("schedule_page_indices"))
all_types = pc.get("all_page_types", {})
for k, v in all_types.items():
    if v != "skip":
        print(f"  page {k}: {v}")

# Check levels
print("\n=== LEVELS ===")
for lvl in j.get("levels", []):
    print(f"  {lvl['name']:15s} elev={lvl.get('elevation_mm',0):5d} h={lvl.get('height_above_ground_mm', lvl.get('floor_height_mm', 3500))}")

print("\n=== GRID ===")
print("X:", j.get("grid_x"))
print("Y:", j.get("grid_y"))

print("\n=== MEMBER DB ===")
mdb = j.get("member_db", {})
for k, v in list(mdb.items())[:10]:
    print(f"  {k}: {v}")

print("\n=== BUILDING OUTLINE ===")
print(json.dumps(j.get("building_outline"), indent=2))