"""
IFC Generator — converts a structural model dict to an IFC 2x3 file.

Uses ifcopenshell library. Importable in SketchUp, Revit, Navisworks, etc.

Usage:
    gen = IFCGenerator(region="au")
    ifc_path = gen.generate(structural_model, "output/model.ifc")
"""

from __future__ import annotations

import os
import math
import time
import logging
from typing import Optional

log = logging.getLogger(__name__)


def _ifc_available() -> bool:
    try:
        import ifcopenshell  # noqa: F401
        return True
    except ImportError:
        return False


class IFCGenerator:
    """
    Converts structural_model dict → IFC 2x3 file.

    Supports: columns, beams, slabs, walls, footings.
    Materials: Steel (G350/G450/CT3) and Concrete (N32/M300).
    """

    def __init__(self, region: str = "au"):
        self.region = region.lower()

    def generate(self, model: dict, output_path: str) -> str:
        """
        Generate IFC 2x3 file from structural model.

        Args:
            model:       Structural model dict from SynthesizerV7
            output_path: Path to write .ifc file

        Returns:
            output_path on success; raises RuntimeError on failure.
        """
        if not _ifc_available():
            raise RuntimeError(
                "ifcopenshell is not installed. "
                "Run: pip install ifcopenshell"
            )

        import ifcopenshell
        import ifcopenshell.api

        ifc = ifcopenshell.file(schema="IFC2X3")
        api = ifcopenshell.api

        # ── Project / Site / Building ──────────────────────
        proj_info = model.get("project_info") or model.get("project") or {}
        proj_name = proj_info.get("name", "Structural Model")
        location = proj_info.get("location", "Unknown")

        project = api.run("root.create_entity", ifc,
                          ifc_class="IfcProject", name=proj_name)
        api.run("unit.assign_unit", ifc, length={"is_metric": True, "raw": "MILLIMETRE"})

        ctx = api.run("context.add_context", ifc, context_type="Model")
        body_ctx = api.run("context.add_context", ifc,
                           context_type="Model",
                           context_identifier="Body",
                           target_view="MODEL_VIEW",
                           parent=ctx)

        site = api.run("root.create_entity", ifc,
                       ifc_class="IfcSite", name=location)
        building = api.run("root.create_entity", ifc,
                           ifc_class="IfcBuilding", name=proj_name)
        api.run("aggregate.assign_object", ifc, product=site, relating_object=project)
        api.run("aggregate.assign_object", ifc, product=building, relating_object=site)

        # ── Materials ──────────────────────────────────────
        _mat_cache: dict[str, object] = {}

        def get_material(grade: str) -> object:
            key = (grade or "concrete").upper()
            if key in _mat_cache:
                return _mat_cache[key]
            mat = api.run("material.add_material", ifc, name=key)
            _mat_cache[key] = mat
            return mat

        # ── Storeys ────────────────────────────────────────
        levels = model.get("levels", [])
        storey_map: dict[str, object] = {}  # level name → IfcBuildingStorey

        for lvl in levels:
            elev = _to_float(lvl.get("elevation_mm") or lvl.get("elevation", 0))
            name = lvl.get("name") or lvl.get("id") or f"L{len(storey_map)+1}"
            storey = api.run("root.create_entity", ifc,
                             ifc_class="IfcBuildingStorey", name=name)
            api.run("attribute.edit_attributes", ifc, product=storey,
                    attributes={"Elevation": elev})
            api.run("aggregate.assign_object", ifc, product=storey,
                    relating_object=building)
            storey_map[name] = storey

        default_storey = list(storey_map.values())[0] if storey_map else None
        if default_storey is None:
            default_storey = api.run("root.create_entity", ifc,
                                     ifc_class="IfcBuildingStorey", name="Ground Floor")
            api.run("aggregate.assign_object", ifc, product=default_storey,
                    relating_object=building)

        members = model.get("members", {})
        grid = model.get("grid_system", {})
        spacing_x = _to_float(grid.get("spacing_x_mm", 6000))
        spacing_y = _to_float(grid.get("spacing_y_mm", 6000))
        x_coords: dict = grid.get("x_coords", {})
        y_coords: dict = grid.get("y_coords", {})
        gx_axes = grid.get("x_axes", [])
        gy_axes = grid.get("y_axes", [])

        def resolve_x(gx) -> float:
            s = str(gx).strip()
            if s in x_coords:
                return float(x_coords[s])
            try:
                return (int(s) - 1) * spacing_x
            except ValueError:
                idx = gx_axes.index(s) if s in gx_axes else 0
                return idx * spacing_x

        def resolve_y(gy) -> float:
            s = str(gy).strip().upper()
            if s in y_coords:
                return float(y_coords[s])
            if s in gy_axes:
                return gy_axes.index(s) * spacing_y
            return 0.0

        # ── Columns ────────────────────────────────────────
        for col in members.get("columns", []):
            cid = col.get("id") or col.get("mark", "C?")
            gx = col.get("grid_x"); gy = col.get("grid_y")
            x = _to_float(col.get("x") or (resolve_x(gx) if gx else 0))
            y = _to_float(col.get("y") or (resolve_y(gy) if gy else 0))
            zb = _to_float(col.get("z_base_mm") or col.get("z_base", 0))
            h = _to_float(col.get("height_mm") or col.get("height", 3500))
            w, d = _section_dims(col, 400, 400)
            mat_key = col.get("material") or col.get("grade") or "concrete"

            placement = _placement(ifc, x, y, zb)
            profile = _rect_profile(ifc, w, d, f"COL_{cid}")
            solid = _extruded_solid(ifc, profile, body_ctx, h)
            shape = ifc.createIfcProductDefinitionShape(
                Representations=[ifc.createIfcShapeRepresentation(
                    ContextOfItems=body_ctx,
                    RepresentationIdentifier="Body",
                    RepresentationType="SweptSolid",
                    Items=[solid]
                )]
            )
            column = ifc.createIfcColumn(
                GlobalId=_guid(), Name=cid,
                ObjectPlacement=placement,
                Representation=shape
            )
            api.run("spatial.assign_container", ifc, product=column,
                    relating_structure=default_storey)
            mat = get_material(mat_key)
            api.run("material.assign_material", ifc, product=column,
                    material=mat)

        # ── Beams ──────────────────────────────────────────
        col_positions: dict[str, tuple[float, float, float]] = {}
        for col in members.get("columns", []):
            cid = col.get("id") or col.get("mark", "")
            gx = col.get("grid_x"); gy = col.get("grid_y")
            x = _to_float(col.get("x") or (resolve_x(gx) if gx else 0))
            y = _to_float(col.get("y") or (resolve_y(gy) if gy else 0))
            zt = _to_float(col.get("z_base_mm", 0)) + _to_float(col.get("height_mm", 3500))
            col_positions[cid] = (x, y, zt)

        for bm in members.get("beams", []):
            bid = bm.get("id") or bm.get("mark", "B?")
            fid = bm.get("from_col") or bm.get("from", "")
            tid = bm.get("to_col") or bm.get("to", "")
            p1 = col_positions.get(fid, (0.0, 0.0, 3500.0))
            p2 = col_positions.get(tid, (spacing_x, 0.0, 3500.0))
            x1, y1, z1 = p1
            x2, y2, _ = p2
            z = _to_float(bm.get("z_mm") or bm.get("z") or z1)
            bw, bd = _section_dims(bm, 200, 300)
            span = math.sqrt((x2 - x1) ** 2 + (y2 - y1) ** 2)
            if span < 100:
                span = 4000.0
            mat_key = bm.get("material") or bm.get("grade") or "steel"

            # Direction vector
            dx = x2 - x1; dy = y2 - y1
            angle = math.atan2(dy, dx)
            placement = _placement(ifc, x1, y1, z,
                                   dir_x=(math.cos(angle), math.sin(angle), 0.0))
            profile = _rect_profile(ifc, bw, bd, f"BM_{bid}")
            solid = _extruded_solid(ifc, profile, body_ctx, span)
            shape = ifc.createIfcProductDefinitionShape(
                Representations=[ifc.createIfcShapeRepresentation(
                    ContextOfItems=body_ctx,
                    RepresentationIdentifier="Body",
                    RepresentationType="SweptSolid",
                    Items=[solid]
                )]
            )
            beam = ifc.createIfcBeam(
                GlobalId=_guid(), Name=bid,
                ObjectPlacement=placement,
                Representation=shape
            )
            api.run("spatial.assign_container", ifc, product=beam,
                    relating_structure=default_storey)
            api.run("material.assign_material", ifc, product=beam,
                    material=get_material(mat_key))

        # ── Slabs ──────────────────────────────────────────
        for sl in members.get("slabs", []):
            sid = sl.get("id") or sl.get("mark", "S?")
            t = _to_float(sl.get("thickness_mm") or sl.get("thickness", 150))
            z = _to_float(sl.get("z_mm") or sl.get("elevation_mm", 3500))
            nx = max(1, len(gx_axes)); ny = max(1, len(gy_axes))
            sx = nx * spacing_x; sy = ny * spacing_y
            mat_key = sl.get("material") or "concrete"

            placement = _placement(ifc, 0.0, 0.0, z)
            profile = _rect_profile(ifc, sx, sy, f"SL_{sid}")
            solid = _extruded_solid(ifc, profile, body_ctx, -t)
            shape = ifc.createIfcProductDefinitionShape(
                Representations=[ifc.createIfcShapeRepresentation(
                    ContextOfItems=body_ctx,
                    RepresentationIdentifier="Body",
                    RepresentationType="SweptSolid",
                    Items=[solid]
                )]
            )
            slab = ifc.createIfcSlab(
                GlobalId=_guid(), Name=sid,
                PredefinedType="FLOOR",
                ObjectPlacement=placement,
                Representation=shape
            )
            api.run("spatial.assign_container", ifc, product=slab,
                    relating_structure=default_storey)
            api.run("material.assign_material", ifc, product=slab,
                    material=get_material(mat_key))

        # ── Walls ──────────────────────────────────────────
        for wl in members.get("walls", []):
            wid = wl.get("id") or wl.get("mark", "W?")
            t = _to_float(wl.get("thickness_mm") or wl.get("thickness", 200))
            h = _to_float(wl.get("height_mm") or wl.get("height", 3500))
            zb = _to_float(wl.get("z_base_mm") or wl.get("z_base", 0))
            x1 = _to_float(wl.get("x1") or wl.get("start_x", 0))
            y1 = _to_float(wl.get("y1") or wl.get("start_y", 0))
            x2 = _to_float(wl.get("x2") or wl.get("end_x", spacing_x))
            y2 = _to_float(wl.get("y2") or wl.get("end_y", 0))
            length = math.sqrt((x2 - x1) ** 2 + (y2 - y1) ** 2)
            if length < 100:
                length = 4000.0
            mat_key = wl.get("material") or "concrete"

            dx = x2 - x1; dy = y2 - y1
            angle = math.atan2(dy, dx)
            placement = _placement(ifc, x1, y1, zb,
                                   dir_x=(math.cos(angle), math.sin(angle), 0.0))
            profile = _rect_profile(ifc, length, t, f"WL_{wid}")
            solid = _extruded_solid(ifc, profile, body_ctx, h)
            shape = ifc.createIfcProductDefinitionShape(
                Representations=[ifc.createIfcShapeRepresentation(
                    ContextOfItems=body_ctx,
                    RepresentationIdentifier="Body",
                    RepresentationType="SweptSolid",
                    Items=[solid]
                )]
            )
            wall = ifc.createIfcWall(
                GlobalId=_guid(), Name=wid,
                ObjectPlacement=placement,
                Representation=shape
            )
            api.run("spatial.assign_container", ifc, product=wall,
                    relating_structure=default_storey)
            api.run("material.assign_material", ifc, product=wall,
                    material=get_material(mat_key))

        # ── Footings ───────────────────────────────────────
        for ftg in members.get("footings", []):
            fid = ftg.get("id") or ftg.get("mark", "F?")
            fw = _to_float(ftg.get("width_mm") or ftg.get("width", 1500))
            fd = _to_float(ftg.get("depth_mm") or ftg.get("depth", 1500))
            fh = _to_float(ftg.get("height_mm") or ftg.get("height", 600))
            x = _to_float(ftg.get("x", 0))
            y = _to_float(ftg.get("y", 0))
            mat_key = ftg.get("material") or "concrete"

            placement = _placement(ifc, x - fw / 2, y - fd / 2, -fh)
            profile = _rect_profile(ifc, fw, fd, f"FTG_{fid}")
            solid = _extruded_solid(ifc, profile, body_ctx, fh)
            shape = ifc.createIfcProductDefinitionShape(
                Representations=[ifc.createIfcShapeRepresentation(
                    ContextOfItems=body_ctx,
                    RepresentationIdentifier="Body",
                    RepresentationType="SweptSolid",
                    Items=[solid]
                )]
            )
            footing = ifc.createIfcFooting(
                GlobalId=_guid(), Name=fid,
                PredefinedType="PAD_FOOTING",
                ObjectPlacement=placement,
                Representation=shape
            )
            api.run("spatial.assign_container", ifc, product=footing,
                    relating_structure=default_storey)
            api.run("material.assign_material", ifc, product=footing,
                    material=get_material(mat_key))

        # ── Write file ─────────────────────────────────────
        os.makedirs(os.path.dirname(os.path.abspath(output_path)), exist_ok=True)
        ifc.write(output_path)
        log.info(f"IFC written to {output_path}")
        return output_path


# ──────────────────────────────────────────────────────────────
# IFC geometry helpers
# ──────────────────────────────────────────────────────────────

def _guid() -> str:
    import ifcopenshell.guid
    return ifcopenshell.guid.new()


def _placement(ifc, x: float, y: float, z: float,
               dir_x: tuple = (1.0, 0.0, 0.0),
               dir_z: tuple = (0.0, 0.0, 1.0)):
    """Create IfcLocalPlacement at (x, y, z)."""
    origin = ifc.createIfcCartesianPoint([x, y, z])
    ax_z = ifc.createIfcDirection(list(dir_z))
    ax_x = ifc.createIfcDirection(list(dir_x))
    axis2d = ifc.createIfcAxis2Placement3D(origin, ax_z, ax_x)
    return ifc.createIfcLocalPlacement(RelativePlacement=axis2d)


def _rect_profile(ifc, width: float, depth: float, name: str = ""):
    """Create IfcRectangleProfileDef."""
    return ifc.createIfcRectangleProfileDef(
        ProfileType="AREA",
        ProfileName=name,
        XDim=float(width),
        YDim=float(depth),
    )


def _extruded_solid(ifc, profile, context, depth: float):
    """Create IfcExtrudedAreaSolid extruded along +Z."""
    origin = ifc.createIfcCartesianPoint([0.0, 0.0, 0.0])
    dir_z = ifc.createIfcDirection([0.0, 0.0, 1.0])
    dir_x = ifc.createIfcDirection([1.0, 0.0, 0.0])
    placement = ifc.createIfcAxis2Placement3D(origin, dir_z, dir_x)
    extrude_dir = ifc.createIfcDirection([0.0, 0.0, 1.0])
    return ifc.createIfcExtrudedAreaSolid(
        SweptArea=profile,
        Position=placement,
        ExtrudedDirection=extrude_dir,
        Depth=abs(float(depth)),
    )


# ──────────────────────────────────────────────────────────────
# Utility
# ──────────────────────────────────────────────────────────────

def _to_float(val, default: float = 0.0) -> float:
    try:
        return float(val)
    except (TypeError, ValueError):
        return default


def _section_dims(member: dict, default_w: int, default_d: int) -> tuple[int, int]:
    """Extract width and depth from a member dict."""
    section = str(member.get("section") or member.get("section_size") or "")
    import re
    if section:
        # Try section library first
        try:
            from generators.section_library_asnzs import lookup_section
            s = lookup_section(section)
            if s:
                return int(s.bf), int(s.d)
        except Exception:
            pass
        # Fall back to number extraction
        nums = re.findall(r'(\d+)', section)
        if nums:
            w = int(nums[0])
            d = int(nums[-1]) if len(nums) > 1 else w
            return w, d
    w = int(_to_float(member.get("width_mm") or member.get("width"), default_w))
    d = int(_to_float(member.get("depth_mm") or member.get("depth"), default_d))
    return w or default_w, d or default_d


# ──────────────────────────────────────────────────────────────
# Public helper
# ──────────────────────────────────────────────────────────────

def generate_ifc(model: dict, output_path: str, region: str = "au") -> str:
    """Convenience wrapper."""
    return IFCGenerator(region=region).generate(model, output_path)
