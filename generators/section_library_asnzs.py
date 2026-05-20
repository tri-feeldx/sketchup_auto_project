"""
Structural section dimension database for AS/NZS and TCVN standards.

All dimensions in millimetres.
Usage:
    dims = lookup_section("310UC118", "au")
    # → SectionDimensions(d=315, bf=307, tf=18.7, tw=11.9, ...)
"""

from __future__ import annotations
from dataclasses import dataclass
from typing import Optional
import re


@dataclass
class SectionDimensions:
    name: str
    profile_type: str   # "I", "RHS", "SHS", "CHS", "PFC", "EA", "UA", "RECT", "CIRC"
    d: float            # overall depth (mm)
    bf: float           # flange width (mm) — same as d for SHS/CHS
    tf: float           # flange thickness (mm)
    tw: float           # web thickness (mm)
    # hollow section wall thickness (RHS/SHS/CHS)
    t: float = 0.0
    # outer diameter for CHS
    od: float = 0.0
    mass_kg_m: float = 0.0

    @property
    def is_hollow(self) -> bool:
        return self.profile_type in ("RHS", "SHS", "CHS")

    @property
    def is_open(self) -> bool:
        return self.profile_type in ("I", "PFC", "EA", "UA")


# ──────────────────────────────────────────────────────────────
# AS/NZS Universal Beams (UB) — depth × mass
# Source: OneSteel / InfraBuild Hot Rolled Structural Steel (2021)
# ──────────────────────────────────────────────────────────────
_UB: dict[str, tuple] = {
    # name: (d, bf, tf, tw, mass_kg_m)
    "150UB14":  (150,  75,  7.6,  5.0,  14.0),
    "150UB18":  (155,  75,  9.5,  6.0,  18.0),
    "180UB16":  (173,  90,  7.0,  4.5,  16.1),
    "180UB18":  (175,  90,  8.0,  5.1,  18.1),
    "180UB22":  (178,  90,  9.7,  6.4,  22.2),
    "200UB18":  (198,  99,  7.0,  4.5,  18.2),
    "200UB22":  (200,  100, 8.5,  5.8,  22.3),
    "200UB25":  (203,  133, 7.8,  5.8,  25.1),
    "200UB29":  (207,  134, 9.6,  6.3,  29.8),
    "250UB25":  (248,  124, 8.0,  5.0,  25.7),
    "250UB31":  (252,  146, 8.6,  6.1,  31.4),
    "250UB37":  (256,  146, 10.9, 6.4,  37.3),
    "310UB32":  (298,  149, 8.0,  5.5,  32.0),
    "310UB40":  (304,  165, 8.7,  6.1,  40.4),
    "310UB46":  (307,  166, 11.8, 6.7,  46.2),
    "310UB54":  (311,  167, 13.7, 7.7,  54.0),
    "360UB45":  (352,  171, 9.7,  6.9,  45.0),
    "360UB51":  (355,  171, 11.5, 7.3,  51.0),
    "360UB57":  (358,  172, 13.0, 8.0,  57.0),
    "360UB67":  (364,  173, 15.7, 9.1,  67.0),
    "410UB54":  (403,  178, 10.9, 7.0,  54.0),
    "410UB60":  (406,  178, 12.8, 7.7,  60.0),
    "410UB67":  (410,  179, 14.4, 8.8,  67.0),
    "460UB67":  (454,  190, 12.7, 8.5,  67.0),
    "460UB74":  (457,  190, 14.5, 9.0,  74.0),
    "460UB82":  (460,  191, 16.0, 9.9,  82.0),
    "530UB82":  (528,  209, 13.2, 9.6,  82.0),
    "530UB92":  (533,  209, 15.6, 10.2, 92.0),
    "530UB101": (537,  210, 17.2, 10.9, 101.0),
    "610UB101": (602,  228, 14.8, 10.0, 101.0),
    "610UB113": (607,  228, 17.3, 11.2, 113.0),
    "610UB125": (612,  229, 19.6, 11.9, 125.0),
    "610UB140": (617,  230, 22.2, 13.1, 140.0),
    "700WB115": (690,  250, 16.0, 10.0, 115.0),
    "700WB128": (694,  250, 18.0, 11.0, 128.0),
    "700WB173": (702,  250, 24.0, 14.5, 173.0),
    "700WB222": (716,  275, 28.0, 17.5, 222.0),
    "800WB146": (790,  275, 20.0, 12.5, 146.0),
    "800WB168": (795,  275, 22.2, 14.0, 168.0),
    "800WB192": (800,  275, 25.0, 16.0, 192.0),
    "900WB175": (889,  300, 22.0, 13.5, 175.0),
    "900WB218": (896,  300, 26.0, 16.0, 218.0),
    "900WB257": (904,  300, 30.0, 19.0, 257.0),
    "1000WB215": (990, 300, 25.0, 16.0, 215.0),
    "1000WB249": (997, 300, 28.0, 18.0, 249.0),
    "1000WB296": (1008,300, 32.0, 20.0, 296.0),
}

# ──────────────────────────────────────────────────────────────
# AS/NZS Universal Columns (UC) — depth × mass
# ──────────────────────────────────────────────────────────────
_UC: dict[str, tuple] = {
    "100UC14.8": (97,  99,  7.8,  5.0,  14.8),
    "100UC15":   (97,  99,  7.8,  5.0,  15.0),
    "150UC23.4": (152, 152, 6.8,  6.1,  23.4),
    "150UC23":   (152, 152, 6.8,  6.1,  23.0),
    "150UC30.0": (158, 153, 9.4,  6.6,  30.0),
    "150UC30":   (158, 153, 9.4,  6.6,  30.0),
    "150UC37.2": (162, 154, 11.5, 8.1,  37.2),
    "150UC37":   (162, 154, 11.5, 8.1,  37.0),
    "200UC46.2": (203, 203, 11.0, 7.2,  46.2),
    "200UC46":   (203, 203, 11.0, 7.2,  46.0),
    "200UC52.2": (206, 204, 12.5, 7.9,  52.2),
    "200UC52":   (206, 204, 12.5, 7.9,  52.0),
    "200UC59.5": (210, 205, 14.2, 9.3,  59.5),
    "200UC60":   (210, 205, 14.2, 9.3,  60.0),
    "250UC72.9": (254, 254, 14.2, 8.6,  72.9),
    "250UC73":   (254, 254, 14.2, 8.6,  73.0),
    "250UC89.5": (260, 256, 17.3, 10.3, 89.5),
    "250UC89":   (260, 256, 17.3, 10.3, 89.0),
    "250UC107":  (266, 259, 20.5, 12.5, 107.0),
    "310UC96.8": (308, 305, 15.4, 9.9,  96.8),
    "310UC97":   (308, 305, 15.4, 9.9,  97.0),
    "310UC118":  (315, 307, 18.7, 11.9, 118.0),
    "310UC137":  (321, 309, 21.7, 13.8, 137.0),
    "310UC158":  (327, 311, 25.0, 15.7, 158.0),
    "310UC179":  (333, 313, 28.1, 17.4, 179.0),
    "310UC198":  (339, 314, 31.4, 19.1, 198.0),
    "310UC220":  (346, 317, 34.5, 21.1, 220.0),
    "310UC240":  (352, 318, 37.7, 23.0, 240.0),
    "360UC145":  (357, 370, 22.0, 15.0, 145.0),
    "360UC170":  (362, 373, 26.0, 17.0, 170.0),
    "360UC197":  (367, 374, 30.2, 19.0, 197.0),
    "360UC235":  (374, 377, 35.6, 22.6, 235.0),
}

# ──────────────────────────────────────────────────────────────
# AS/NZS Parallel Flange Channels (PFC)
# ──────────────────────────────────────────────────────────────
_PFC: dict[str, tuple] = {
    # (d, bf, tf, tw, mass)
    "75PFC":  (75,  40,  6.1, 5.0,  6.0),
    "100PFC": (100, 50,  6.7, 5.0,  8.3),
    "125PFC": (125, 65,  8.1, 5.5,  11.9),
    "150PFC": (150, 75,  9.0, 6.0,  15.7),
    "180PFC": (180, 75,  9.5, 6.5,  18.2),
    "200PFC": (200, 75,  9.5, 6.5,  19.9),
    "230PFC": (230, 75,  11.0,7.0,  25.1),
    "250PFC": (250, 90,  12.5,8.0,  29.5),
    "300PFC": (300, 90,  13.5,7.5,  35.0),
    "380PFC": (380, 100, 16.5,9.5,  55.2),
}

# ──────────────────────────────────────────────────────────────
# AS/NZS Rectangular Hollow Sections (RHS) — common sizes
# Format: "BxDxT"  B=width, D=depth, T=thickness
# ──────────────────────────────────────────────────────────────
_RHS: dict[str, tuple] = {
    # (d, bf, tf=tw=0, tw=0, t_wall, mass)  — profile_type="RHS"
    "50x25x2RHS":   (50,  25,  2.0, 2.0, 2.0,  2.7),
    "75x25x2RHS":   (75,  25,  2.0, 2.0, 2.0,  3.3),
    "75x50x3RHS":   (75,  50,  3.0, 3.0, 3.0,  5.5),
    "100x50x3RHS":  (100, 50,  3.0, 3.0, 3.0,  6.7),
    "100x50x4RHS":  (100, 50,  4.0, 4.0, 4.0,  8.8),
    "100x75x4RHS":  (100, 75,  4.0, 4.0, 4.0,  10.7),
    "125x75x4RHS":  (125, 75,  4.0, 4.0, 4.0,  12.5),
    "150x50x5RHS":  (150, 50,  5.0, 5.0, 5.0,  14.2),
    "150x100x4RHS": (150, 100, 4.0, 4.0, 4.0,  15.1),
    "150x100x5RHS": (150, 100, 5.0, 5.0, 5.0,  18.5),
    "150x100x6RHS": (150, 100, 6.0, 6.0, 6.0,  22.1),
    "200x100x5RHS": (200, 100, 5.0, 5.0, 5.0,  22.9),
    "200x100x6RHS": (200, 100, 6.0, 6.0, 6.0,  27.4),
    "200x100x8RHS": (200, 100, 8.0, 8.0, 8.0,  35.7),
    "200x150x6RHS": (200, 150, 6.0, 6.0, 6.0,  32.2),
    "250x150x6RHS": (250, 150, 6.0, 6.0, 6.0,  38.5),
    "250x150x8RHS": (250, 150, 8.0, 8.0, 8.0,  50.8),
    "300x200x8RHS": (300, 200, 8.0, 8.0, 8.0,  65.3),
    "350x250x10RHS":(350, 250, 10.0,10.0,10.0, 95.0),
}

# ──────────────────────────────────────────────────────────────
# AS/NZS Square Hollow Sections (SHS)
# ──────────────────────────────────────────────────────────────
_SHS: dict[str, tuple] = {
    # (d=bf, bf, tf=tw=0, t_wall, mass)
    "35x35x2SHS":  (35,  35,  2.0, 2.0, 2.0,  2.0),
    "40x40x2SHS":  (40,  40,  2.0, 2.0, 2.0,  2.3),
    "50x50x3SHS":  (50,  50,  3.0, 3.0, 3.0,  4.4),
    "65x65x3SHS":  (65,  65,  3.0, 3.0, 3.0,  5.7),
    "75x75x3SHS":  (75,  75,  3.0, 3.0, 3.0,  6.7),
    "75x75x4SHS":  (75,  75,  4.0, 4.0, 4.0,  8.7),
    "75x75x5SHS":  (75,  75,  5.0, 5.0, 5.0,  10.6),
    "89x89x4SHS":  (89,  89,  4.0, 4.0, 4.0,  10.5),
    "100x100x4SHS":(100, 100, 4.0, 4.0, 4.0,  12.0),
    "100x100x5SHS":(100, 100, 5.0, 5.0, 5.0,  14.9),
    "100x100x6SHS":(100, 100, 6.0, 6.0, 6.0,  17.7),
    "125x125x5SHS":(125, 125, 5.0, 5.0, 5.0,  18.8),
    "125x125x6SHS":(125, 125, 6.0, 6.0, 6.0,  22.3),
    "150x150x5SHS":(150, 150, 5.0, 5.0, 5.0,  22.7),
    "150x150x6SHS":(150, 150, 6.0, 6.0, 6.0,  27.0),
    "150x150x8SHS":(150, 150, 8.0, 8.0, 8.0,  35.4),
    "200x200x6SHS":(200, 200, 6.0, 6.0, 6.0,  36.6),
    "200x200x8SHS":(200, 200, 8.0, 8.0, 8.0,  47.9),
    "250x250x8SHS":(250, 250, 8.0, 8.0, 8.0,  60.7),
    "250x250x10SHS":(250,250, 10.0,10.0,10.0, 74.9),
    "300x300x9SHS":(300, 300, 9.0, 9.0, 9.0,  82.4),
    "300x300x10SHS":(300,300, 10.0,10.0,10.0, 91.3),
}

# ──────────────────────────────────────────────────────────────
# AS/NZS Circular Hollow Sections (CHS) — OD × thickness
# ──────────────────────────────────────────────────────────────
_CHS: dict[str, tuple] = {
    # (od, od, 0, 0, t_wall, mass)
    "48.3x3.2CHS":  (48.3,  48.3, 3.2, 3.2, 3.2,  3.56),
    "60.3x3.2CHS":  (60.3,  60.3, 3.2, 3.2, 3.2,  4.51),
    "76.1x3.2CHS":  (76.1,  76.1, 3.2, 3.2, 3.2,  5.75),
    "88.9x3.5CHS":  (88.9,  88.9, 3.5, 3.5, 3.5,  7.41),
    "101.6x4.0CHS": (101.6, 101.6,4.0, 4.0, 4.0,  9.67),
    "114.3x4.5CHS": (114.3, 114.3,4.5, 4.5, 4.5,  12.2),
    "139.7x5.0CHS": (139.7, 139.7,5.0, 5.0, 5.0,  16.6),
    "165.1x5.0CHS": (165.1, 165.1,5.0, 5.0, 5.0,  19.8),
    "168.3x5.0CHS": (168.3, 168.3,5.0, 5.0, 5.0,  20.1),
    "168.3x6.4CHS": (168.3, 168.3,6.4, 6.4, 6.4,  25.5),
    "193.7x5.0CHS": (193.7, 193.7,5.0, 5.0, 5.0,  23.3),
    "219.1x6.4CHS": (219.1, 219.1,6.4, 6.4, 6.4,  33.4),
    "244.5x8.0CHS": (244.5, 244.5,8.0, 8.0, 8.0,  46.7),
    "273.1x9.3CHS": (273.1, 273.1,9.3, 9.3, 9.3,  60.3),
    "323.9x9.5CHS": (323.9, 323.9,9.5, 9.5, 9.5,  73.7),
    "355.6x9.5CHS": (355.6, 355.6,9.5, 9.5, 9.5,  81.1),
    "406.4x12.7CHS":(406.4, 406.4,12.7,12.7,12.7, 123.0),
    "508x12.7CHS":  (508.0, 508.0,12.7,12.7,12.7, 155.0),
}

# ──────────────────────────────────────────────────────────────
# TCVN H-Beams (H-section, equivalent to HEA/HEB Eurocode)
# Vietnamese standard: TCVN 7571-1:2019
# ──────────────────────────────────────────────────────────────
_TCVN_H: dict[str, tuple] = {
    # (d, bf, tf, tw, mass)
    "H100x100x6x8":  (100, 100, 8.0, 6.0,  16.9),
    "H125x125x6.5x9":(125, 125, 9.0, 6.5,  23.8),
    "H150x150x7x10": (150, 150, 10.0,7.0,  31.5),
    "H175x175x7.5x11":(175,175, 11.0,7.5,  40.4),
    "H200x200x8x12": (200, 200, 12.0,8.0,  50.0),
    "H250x250x9x14": (250, 250, 14.0,9.0,  72.4),
    "H300x300x10x15":(300, 300, 15.0,10.0, 94.0),
    "H350x350x12x19":(350, 350, 19.0,12.0, 137.0),
    "H400x400x13x21":(400, 400, 21.0,13.0, 172.0),
    # Vietnamese I-beams (I-section, narrow flange)
    "I100":  (100, 55,  7.2, 4.5,  10.6),
    "I120":  (120, 64,  7.8, 4.8,  13.3),
    "I140":  (140, 73,  8.4, 5.1,  16.4),
    "I160":  (160, 82,  9.0, 5.4,  19.8),
    "I180":  (180, 90,  9.7, 5.8,  23.7),
    "I200":  (200, 100, 10.3,6.2,  27.9),
    "I220":  (220, 110, 11.1,6.6,  33.1),
    "I240":  (240, 115, 11.9,7.0,  38.1),
    "I260":  (260, 125, 12.7,7.4,  44.1),
    "I280":  (280, 130, 13.5,7.8,  49.9),
    "I300":  (300, 135, 14.2,8.1,  57.0),
    "I320":  (320, 140, 15.0,8.5,  65.0),
    "I360":  (360, 145, 16.5,9.0,  79.0),
    "I400":  (400, 155, 18.0,10.0, 98.0),
}

# ──────────────────────────────────────────────────────────────
# Alias normalisation table — handles variations the LLM might output
# ──────────────────────────────────────────────────────────────
_ALIASES: dict[str, str] = {
    # Strip spaces
    "310 UC 118": "310UC118",
    "530 UB 92":  "530UB92",
    # Dot variants
    "100UC14.8":  "100UC14.8",
    # Mass-only variants (some drawings drop mass decimal)
    "200UC46":    "200UC46.2",
}


def _normalise(name: str) -> str:
    """Strip whitespace/dots, upper-case for lookup."""
    n = name.strip().upper()
    # "310 UC 118" → "310UC118"
    n = re.sub(r"\s+", "", n)
    return n


def lookup_section(name: str, region: str = "au") -> Optional[SectionDimensions]:
    """
    Look up a structural section by name and region.

    Args:
        name:   Section designation, e.g. "310UC118", "530UB92.4", "150x100x6RHS"
        region: "au" for AS/NZS, "vn" for TCVN, "intl" for Eurocode (fallback)

    Returns:
        SectionDimensions or None if not found.
    """
    key = _normalise(name)

    # Resolve aliases first
    key = _ALIASES.get(key, key)

    # Also try stripping trailing decimal mass (e.g. "530UB92.4" → "530UB92")
    key_no_dec = re.sub(r"\.\d+$", "", key)

    def _make(db: dict, k: str, ptype: str) -> Optional[SectionDimensions]:
        row = db.get(k) or db.get(key_no_dec)
        if row is None:
            return None
        d, bf, tf, tw, *rest = row
        t_wall = rest[0] if rest else 0.0
        mass = rest[1] if len(rest) > 1 else (rest[0] if rest else 0.0)
        if ptype in ("RHS", "SHS"):
            mass = rest[1] if len(rest) > 1 else t_wall
        if ptype == "CHS":
            mass = rest[1] if len(rest) > 1 else t_wall
        return SectionDimensions(
            name=name, profile_type=ptype,
            d=d, bf=bf, tf=tf, tw=tw,
            t=t_wall if ptype in ("RHS", "SHS", "CHS") else 0.0,
            od=d if ptype == "CHS" else 0.0,
            mass_kg_m=mass,
        )

    # Ordered lookup by profile type keyword in name
    ku = key.upper()
    if "UB" in ku and "WB" not in ku:
        result = _make(_UB, key, "I")
        if result:
            return result
    if "UC" in ku:
        result = _make(_UC, key, "I")
        if result:
            return result
    if "WB" in ku:
        result = _make(_UB, key, "I")
        if result:
            return result
    if "PFC" in ku:
        result = _make(_PFC, key, "PFC")
        if result:
            return result
    if "CHS" in ku:
        result = _make(_CHS, key, "CHS")
        if result:
            return result
    if "SHS" in ku:
        result = _make(_SHS, key, "SHS")
        if result:
            return result
    if "RHS" in ku:
        result = _make(_RHS, key, "RHS")
        if result:
            return result

    # TCVN lookups
    if region == "vn" or ku.startswith("H") or ku.startswith("I"):
        result = _make(_TCVN_H, key, "I")
        if result:
            return result

    # Fuzzy fallback: partial match in AS/NZS tables
    for db, ptype in [(_UB, "I"), (_UC, "I"), (_PFC, "PFC"),
                      (_RHS, "RHS"), (_SHS, "SHS"), (_CHS, "CHS")]:
        for k in (key, key_no_dec):
            r = _make(db, k, ptype)
            if r:
                return r

    return None


def parse_section_from_string(raw: str, region: str = "au") -> Optional[SectionDimensions]:
    """
    Try to extract a section designation from a freeform string and look it up.

    Handles: "310UC118 G350", "530UB92 @ 6000", "150x100x6RHS - Grade C350"
    """
    if not raw:
        return None
    # Try direct lookup first
    result = lookup_section(raw.strip(), region)
    if result:
        return result
    # Extract likely section token: word chars + digits + x/× separators
    tokens = re.findall(
        r"[\d]+(?:[\.\d]*)(?:UB|UC|WB|PFC|RHS|SHS|CHS|EA|UA)"
        r"|[Hh]\d+x\d+x[\d.]+x[\d.]+"
        r"|[Ii]\d{2,3}"
        r"|\d+x\d+x[\d.]+(?:RHS|SHS|CHS)",
        raw, re.IGNORECASE
    )
    for tok in tokens:
        r = lookup_section(tok, region)
        if r:
            return r
    return None


if __name__ == "__main__":
    # Quick self-test
    tests = [
        ("310UC118", "au"),
        ("530UB92", "au"),
        ("310UC118", "au"),
        ("150x100x6RHS", "au"),
        ("168.3x5.0CHS", "au"),
        ("100x100x5SHS", "au"),
        ("H300x300x10x15", "vn"),
        ("I200", "vn"),
        ("310UC118 G350", "au"),
    ]
    for name, reg in tests:
        s = lookup_section(name, reg) or parse_section_from_string(name, reg)
        print(f"{name:30s} → {s}")
