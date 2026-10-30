"""Convert the oklch() design tokens in beautifului.dev's CSS to sRGB hex (+alpha).

Usage: python3 -I oklch.py <site.css>   -> prints a markdown table and a Swift table
"""
import math, re, sys

def oklch_to_srgb(L, C, H):
    a, b = C * math.cos(math.radians(H)), C * math.sin(math.radians(H))
    l_ = L + 0.3963377774 * a + 0.2158037573 * b
    m_ = L - 0.1055613458 * a - 0.0638541728 * b
    s_ = L - 0.0894841775 * a - 1.2914855480 * b
    l, m, s = l_ ** 3, m_ ** 3, s_ ** 3
    r = 4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s
    g = -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s
    bl = -0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s
    def gamma(x):
        x = min(max(x, 0.0), 1.0)
        return 12.92 * x if x <= 0.0031308 else 1.055 * x ** (1 / 2.4) - 0.055
    return tuple(round(gamma(c) * 255) for c in (r, g, bl))

def parse_block(css, selector):
    m = re.search(re.escape(selector) + r"\{([^{}]*--page:[^{}]*)\}", css)
    m2 = re.search(re.escape(selector) + r"\{([^{}]*--field:[^{}]*)\}", css)
    body = (m.group(1) if m else "") + ";" + (m2.group(1) if m2 and selector == ":root" else "")
    out = {}
    for name, val in re.findall(r"--([\w-]+):(oklch\([^)]*\))", body):
        L, C, H, *alpha = re.findall(r"[\d.]+%?", val)
        L = float(L.rstrip("%")) / 100 if L.endswith("%") else float(L)
        A = float(alpha[0]) if alpha else 1.0
        out[name] = (*oklch_to_srgb(L, float(C), float(H)), A)
    return out

css = open(sys.argv[1]).read()
light, dark = parse_block(css, ":root"), parse_block(css, ".dark")
hexa = lambda t: "#%02X%02X%02X" % t[:3] + ("" if t[3] == 1 else " @%.3g" % t[3])
print("| token | light | dark |\n|---|---|---|")
for k in light:
    print(f"| {k} | {hexa(light[k])} | {hexa(dark[k]) if k in dark else '—'} |")
print()
for k in light:
    d = dark.get(k, light[k])
    print(f'{k}: light 0x{"%02X%02X%02X" % light[k][:3]} a{light[k][3]:g}  dark 0x{"%02X%02X%02X" % d[:3]} a{d[3]:g}')
