# beautifului.dev design tokens

Read from the site's stylesheet (`/_next/static/css/916c3f25c8795666.css`, fetched 2026-10-30).
Colors are `oklch()` in the CSS; the sRGB values below come from `tools/oklch.py` and are
what `BUIColors.standard` uses. Dark mode is the `.dark` class on `<html>`.

## Color

| token | light | dark |
|---|---|---|
| page | #FAFAFB | #17181A |
| canvas | #F1F2F3 | #1C1D1F |
| surface | #FFFFFF | #232427 |
| inset | #F7F8F9 | #1F2022 |
| hover | #F4F5F6 | #2A2B2E |
| hover-2 | #E7E9EB | #313236 |
| ink | #1F2124 | #F2F3F4 |
| ink-2 | #62656B | #A5A8AD |
| ink-3 | #9A9DA3 | #6C6F75 |
| line | #ECEDEF | #2E3033 |
| line-strong | #E0E2E5 | #3A3C40 |
| line-soft | #F3F4F5 | #27282B |
| field | #F2F2F3 | #2B2C2F |
| stripe | #494949 @7.5% | #FFFFFF @5.5% |
| stripe-bg | #F5F5F5 | #1B1C1E |
| accent | #0285FF | #3D9AFF |
| accent-ink | #0070DD | #7EC0FF |
| accent-tint | #E9F3FF | #3D9AFF @16% |
| green | #199A4D | #3CBB72 |
| green-tint | #E8F5ED | #3CBB72 @14% |
| orange | #EF720D | #F68F3C |
| orange-tint | #FDF1E5 | #F68F3C @14% |
| red | #E3474C | #EE5C61 |
| red-tint | #FCECEC | #EE5C61 @14% |
| tooltip-bg | #25272B | #111214 |
| tooltip-fg | #F6F7F8 | #F2F3F4 |
| tooltip-muted | #A5A8AD | #A5A8AD |
| tooltip-border | #3A3C40 | #2E3033 |

## Type

- Sans: Inter (`font-feature-settings: "cv11", "ss01"`), body 14px / 1.5, `letter-spacing: -0.01em`.
- Mono: JetBrains Mono.
- Sizes used by components: 10, 10.5, 11, 11.5, 12, 12.5, 13, 13.5, 14, 15 px; weights 400/500/600/700.
- Tailwind scale present: `text-xs` 12/16, `text-sm` 14/20, `text-2xl` 24/32; leading tight 1.25, snug 1.375, normal 1.5, relaxed 1.625.

## Radius

| token | px |
|---|---|
| radius-sm | 4 |
| radius-md / radius-chip | 6 |
| radius-control | 8 |
| radius-card | 10 |
| radius-xl | 12 |
| radius-window | 14 |

## Shadow

Light:

- `shadow-hairline`: `0 0 0 1px var(--line)`
- `shadow-btn`: `0 0 0 1px var(--line-strong), 0 0 4px #0000000a`
- `shadow-card`: `0 0 0 1px var(--line)` + six-layer `shadow-sm` (largest `0 18px 47px #00000008`)
- `shadow-raised`: ring + five-layer `shadow-md` (largest `0 17.54px 23.39px #0000000a`)
- `shadow-overlay`: ring + five-layer `shadow-lg` (largest `0 25px 50px #0000000d`)
- `shadow-inset-field`: `inset 0 1px 2px oklch(0 0 0 / .12)`

Dark:

- `shadow-btn`: `0 0 0 1px #FFFFFF1A, 0 1px 2px #0000004D`
- `shadow-card`: `0 0 0 1px #FFFFFF1C, 0 1px 2px #00000033, 0 2px 6px #00000033`
- `shadow-raised`: `0 0 0 1px #FFFFFF21, 0 2px 10px #00000038`
- `shadow-overlay`: `0 0 0 1px #FFFFFF26, 0 8px 28px #00000057`
- `shadow-inset-field`: `inset 0 1px 2px oklch(0 0 0 / .4)`

## Motion

Curves:

| token | value |
|---|---|
| ease-out | cubic-bezier(0, 0, .2, 1) |
| ease-in-out (default transition) | cubic-bezier(.4, 0, .2, 1), 150 ms |
| ease-out-strong | cubic-bezier(.23, 1, .32, 1) |
| ease-in-out-strong | cubic-bezier(.77, 0, .175, 1) |
| ease-link | cubic-bezier(.16, 1, .3, 1) |

Keyframes:

| name | frames | typical use |
|---|---|---|
| shimmer-text | background-position 150% → -50% | 1.4 s linear infinite, gradient `ink-3 35%, ink 50%, ink-3 65%`, size 200% |
| pixel-on | 0/100% .15 · 18–42% 1 · 62% .15 | 650 ms (Orbit 950 ms) ease-in-out infinite, per-cell delay |
| fade-up | opacity 0, translateY(8px) → 1, 0 | 380–600 ms ease-out-strong, staggered 0–240 ms |
| fade-in | opacity 0 → 1 | 150–400 ms ease-out |
| pop-in | opacity 0, scale(.95) → 1, 1 | 160–300 ms ease-out-strong |
| caret-blink | opacity 1 / 0 at 50% | 1 s step-end infinite |
| eq-bounce | scaleY .35 → 1 → .35 | dictation level bars |
| records-pulse | opacity .35 scale .8 → 1, 1 | 1.1 s ease-in-out infinite |
| spin | rotate 1turn | 1.1 s linear infinite |

`prefers-reduced-motion: reduce` collapses all animation and transition durations to 0.01 ms
and stops the stream caret and stream-tail blur.

## Layout

- Page background: `stripe-bg` with 1 px `stripe` lines every 8 px at -45°.
- Demo surface: `rounded-window bg-canvas p-3 shadow-hairline`, `min-height: 272px`, content `max-w-120` (480 px) centred.
- Variant switcher: `absolute bottom-2.5`, `rounded-full bg-field p-0.5`; items `px-2 py-0.5 text-[11.5px] font-medium`, active `bg-surface text-ink shadow-btn`, inactive `text-ink-3`.
- Spacing scale: 4 px (`--spacing: .25rem`).
