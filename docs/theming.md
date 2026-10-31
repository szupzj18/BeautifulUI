# Theming

Components read a `BUITheme` from the SwiftUI environment. It holds the colors (`BUIColors`), the
corner radii (`BUIRadii`), a type scale and a switch for entrance animations. The default is the
original site's palette, with light and dark variants that follow the system appearance.

```swift
import BeautifulUI

RootView()
    .buiTheme(BUITheme(colors: myColors, radii: BUIRadii(control: 10, card: 14)))
```

Start from `BUIColors.standard` and change the tokens you need:

```swift
var colors = BUIColors.standard
colors.accent = .indigo
colors.surface = .white

let theme = BUITheme(colors: colors, radii: .standard)
```

`BUITheme` has four fields:

| Field | Default | Meaning |
|---|---|---|
| `colors` | `.standard` | Page, canvas, surface, ink, line, accent and status colors, each with a light and a dark value. |
| `radii` | `.standard` | Chip, control and card corner radii. |
| `typeScale` | `1` | Multiplies every `buiFont` size. The original's sizes are desktop sizes (13 pt labels); an app whose body text is 17 pt sets about 1.15–1.2. |
| `entrances` | `true` | One-shot entrance animations. Turn them off in lists that rebuild rows as they scroll in. |

## Type

Text styles are `BUITextStyle`, converted from the original's px to pt one to one. At the default size,
dimensions match the original. Sizes scale with the system text size setting (13 pt follows
`.footnote`, 12 pt follows `.caption`).

When the host sets `.fontDesign` on an outer view (for example rounded type for the whole app), the default
design of `buiFont` follows it. Styles that are monospaced or rounded by definition keep their own design.

## Motion

Looping animations stop when the system setting "Reduce Motion" is on.

## Tokens

The values behind `BUIColors`, `BUIRadii`, `BUIElevation`, `BUICurve` and `BUIKeyframes` were read from
the original site's stylesheet; [`tokens.md`](tokens.md) lists them.
