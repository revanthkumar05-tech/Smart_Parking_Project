import re
import struct
import zlib
from pathlib import Path

BASE = Path.home() / "smart_parking_vlsi/physical_design/images"
W, H = 1600, 1200
MARGIN = 100

def png_write(path, pixels):
    raw = b"".join(
        b"\x00" + bytes(pixels[y * W * 3:(y + 1) * W * 3])
        for y in range(H)
    )

    def chunk(tag, data):
        return (
            struct.pack(">I", len(data)) + tag + data
            + struct.pack(">I", zlib.crc32(tag + data) & 0xffffffff)
        )

    data = (
        b"\x89PNG\r\n\x1a\n"
        + chunk(b"IHDR", struct.pack(">IIBBBBB", W, H, 8, 2, 0, 0, 0))
        + chunk(b"IDAT", zlib.compress(raw, 6))
        + chunk(b"IEND", b"")
    )
    Path(path).write_bytes(data)

def pixel(p, x, y, color):
    x, y = int(x), int(y)
    if 0 <= x < W and 0 <= y < H:
        i = (y * W + x) * 3
        p[i:i+3] = bytes(color)

def rect(p, x1, y1, x2, y2, color):
    x1, x2 = sorted((int(x1), int(x2)))
    y1, y2 = sorted((int(y1), int(y2)))
    x1, x2 = max(0, x1), min(W - 1, x2)
    y1, y2 = max(0, y1), min(H - 1, y2)
    if x1 > x2 or y1 > y2:
        return
    line = bytes(color)
    for y in range(y1, y2 + 1):
        i = (y * W + x1) * 3
        p[i:i+3*(x2-x1+1)] = line * (x2-x1+1)

def line(p, x1, y1, x2, y2, color, thickness=1):
    dx, dy = x2-x1, y2-y1
    steps = max(1, int(max(abs(dx), abs(dy))))
    radius = max(0, thickness // 2)
    for j in range(steps + 1):
        x = round(x1 + dx*j/steps)
        y = round(y1 + dy*j/steps)
        rect(p, x-radius, y-radius, x+radius, y+radius, color)

def make_image(stage):
    path = BASE / f"{stage}.def"
    if not path.exists():
        print(f"Missing {path}")
        return

    text = path.read_text(errors="ignore")
    die = re.search(
        r"DIEAREA\s*\(\s*(-?\d+)\s+(-?\d+)\s*\)"
        r"\s*\(\s*(-?\d+)\s+(-?\d+)\s*\)", text
    )
    if not die:
        print(f"{stage}: DIEAREA not found")
        return

    dx1, dy1, dx2, dy2 = map(int, die.groups())
    if dx2 <= dx1 or dy2 <= dy1:
        print(f"{stage}: invalid DIEAREA")
        return

    scale = min(
        (W - 2*MARGIN) / (dx2 - dx1),
        (H - 2*MARGIN) / (dy2 - dy1)
    )

    board_w = (dx2 - dx1) * scale
    board_h = (dy2 - dy1) * scale
    left = (W - board_w) / 2
    top = (H - board_h) / 2

    def xy(x, y):
        return (
            round(left + (x-dx1)*scale),
            round(H - top - (y-dy1)*scale)
        )

    p = bytearray([248, 249, 252] * W * H)
    x1, y1 = xy(dx1, dy1)
    x2, y2 = xy(dx2, dy2)

    # Die background and border
    rect(p, x1, y2, x2, y1, (29, 35, 46))
    for t in range(3):
        line(p, x1+t, y1+t, x2-t, y1+t, (100, 115, 135))
        line(p, x1+t, y2-t, x2-t, y2-t, (100, 115, 135))
        line(p, x1+t, y1+t, x1+t, y2-t, (100, 115, 135))
        line(p, x2-t, y1+t, x2-t, y2-t, (100, 115, 135))

    core = re.search(
        r"COREAREA\s*\(\s*(-?\d+)\s+(-?\d+)\s*\)"
        r"\s*\(\s*(-?\d+)\s+(-?\d+)\s*\)", text
    )
    if core:
        cx1, cy1, cx2, cy2 = map(int, core.groups())
        a, b = xy(cx1, cy1)
        c, d = xy(cx2, cy2)
        rect(p, a, d, c, b, (43, 51, 65))

    # Cell locations from the actual DEF COMPONENTS section
    section = re.search(
        r"COMPONENTS\s+\d+\s*;(.*?)END COMPONENTS", text, re.S
    )
    cells = 0
    if section:
        for entry in re.finditer(
            r"-\s+\S+\s+\S+(.*?);", section.group(1), re.S
        ):
            q = re.search(
                r"\+\s+(?:PLACED|FIXED|COVER)\s+"
                r"\(\s*(-?\d+)\s+(-?\d+)\s*\)",
                entry.group(1)
            )
            if q:
                x, y = map(int, q.groups())
                px, py = xy(x, y)
                rect(p, px-3, py-3, px+3, py+3, (60, 175, 245))
                cells += 1

    # Show routed geometry only on the routing-stage image
    segments = 0
    if stage == "routing":
        nets = re.search(r"NETS\s+\d+\s*;(.*?)END NETS", text, re.S)
        if nets:
            for net in re.finditer(r"-\s+\S+.*?;", nets.group(1), re.S):
                entry = net.group(0)
                if not re.search(r"\b(?:ROUTED|NEW)\b", entry):
                    continue

                # DEF routing coordinates are taken from each routed path.
                for route in re.finditer(
                    r"(?:ROUTED|NEW)\s+\S+(.*?)(?=\bNEW\b|;)",
                    entry, re.S
                ):
                    coords = re.findall(
                        r"\(\s*(-?\d+)\s+(-?\d+)\s*\)",
                        route.group(1)
                    )
                    pts = [xy(int(a), int(b)) for a, b in coords]
                    for a, b in zip(pts, pts[1:]):
                        line(p, *a, *b, (232, 104, 91), 2)
                        segments += 1

    out = BASE / f"{stage}.png"
    png_write(out, p)
    print(
        f"{stage}: saved {out.name}; "
        f"placed cells={cells}; routed segments drawn={segments}"
    )

for stage in ("floorplan", "placement", "cts", "routing"):
    make_image(stage)
