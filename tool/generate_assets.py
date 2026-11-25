#!/usr/bin/env python3
"""Verimlilik merkezinin özgün simge, açılış ve mağaza görselleri (Pillow).
Üçüncü taraf görsel kullanılmaz.  pip install pillow && python tool/generate_assets.py"""
import os
from PIL import Image, ImageDraw

BG_TOP, BG_BOTTOM, ACCENT = (38, 36, 90), (13, 12, 38), (255, 200, 87)
PAPER, INK = (245, 243, 255), (120, 118, 190)


def gradient(w, h):
    im = Image.new("RGB", (w, h))
    d = ImageDraw.Draw(im)
    for y in range(h):
        t = y / max(1, h - 1)
        d.line([(0, y), (w, y)], fill=tuple(int(BG_TOP[i] * (1 - t) + BG_BOTTOM[i] * t) for i in range(3)))
    return im


def glyph(d, cx, cy, s, color=ACCENT):
    """Kontrol listesi sayfası ve onay işareti: özgün, sade çizim."""
    w = max(2, int(s // 14))
    x0, y0, x1, y1 = cx - s * 0.32, cy - s * 0.42, cx + s * 0.32, cy + s * 0.42
    d.rounded_rectangle([x0, y0, x1, y1], radius=s * 0.07, fill=PAPER)
    for i in range(3):
        y = y0 + s * (0.2 + i * 0.22)
        d.ellipse([x0 + s * 0.08, y - s * 0.05, x0 + s * 0.18, y + s * 0.05], outline=INK, width=max(1, w // 2))
        d.line([(x0 + s * 0.25, y), (x1 - s * 0.08, y)], fill=INK, width=w)
    r = s * 0.2
    ccx, ccy = x1 - s * 0.02, y1 - s * 0.04
    d.ellipse([ccx - r, ccy - r, ccx + r, ccy + r], fill=color)
    d.line([(ccx - r * 0.45, ccy), (ccx - r * 0.1, ccy + r * 0.38), (ccx + r * 0.5, ccy - r * 0.35)], fill=BG_BOTTOM, width=w + 2)


def icon(size=1024):
    im = gradient(size, size)
    glyph(ImageDraw.Draw(im), size / 2, size / 2, size * 0.66)
    return im


def main():
    os.makedirs("assets/branding", exist_ok=True)
    os.makedirs("store", exist_ok=True)
    ic = icon()
    ic.save("assets/branding/icon.png")
    fg = Image.new("RGBA", (1024, 1024), (0, 0, 0, 0))
    glyph(ImageDraw.Draw(fg), 512, 512, 440)
    fg.save("assets/branding/icon_foreground.png")
    sp = Image.new("RGBA", (768, 768), (0, 0, 0, 0))
    glyph(ImageDraw.Draw(sp), 384, 384, 320)
    sp.save("assets/branding/splash.png")
    a12 = Image.new("RGBA", (1152, 1152), (0, 0, 0, 0))
    glyph(ImageDraw.Draw(a12), 576, 576, 400)
    a12.save("assets/branding/splash_android12.png")
    ic.resize((512, 512)).save("store/icon_512.png")
    fe = gradient(1024, 500)
    glyph(ImageDraw.Draw(fe), 512, 250, 320)
    fe.save("store/feature_graphic.png")
    print("assets ok")


if __name__ == "__main__":
    main()
