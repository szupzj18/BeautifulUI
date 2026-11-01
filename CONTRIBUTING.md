# Contributing

Thanks for your interest in BeautifulUI. Bug reports, fixes and new ideas are all welcome. For anything
bigger than a small fix, please open an issue first so we can agree on the direction.

By taking part you agree to follow the [Code of Conduct](CODE_OF_CONDUCT.md). Contributions are
released under the [MIT license](LICENSE) of this repository.

## Requirements

- macOS with Xcode 26 or later (Swift 6.2)
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) for the Catalog app: `brew install xcodegen`

## Layout

| Path | What it holds |
|---|---|
| `BeautifulUI/Sources/BeautifulUI/` | The library: `Tokens/`, `Support/`, `Components/` (one file per component) |
| `BeautifulUI/Tests/` | Unit tests |
| `Package.swift` | The manifest that makes the repository installable as a package |
| `BeautifulUI/Package.swift` | The same package for hosts that depend on a local checkout |
| `Catalog/` | The demo app (`project.yml` is the XcodeGen spec) and its UI tests |
| `docs/` | Documentation and design tokens |
| `compare/`, `tools/` | Per-component state sheets (dark and light) and the scripts that build them |

The two `Package.swift` files must declare the same platforms, products and targets. If you change
one, change the other.

## Build and test

```sh
swift build
swift test          # unit tests: curves, keyframes, SVG parsing, per-component state logic
```

## Run the Catalog

```sh
cd Catalog
xcodegen generate   # writes Catalog.xcodeproj, which is not committed
open Catalog.xcodeproj
```

Pick the `Catalog` scheme and an iPhone simulator. The UI tests in `Catalog/UITests/` walk through all
21 components:

```sh
xcodebuild test -project Catalog/Catalog.xcodeproj -scheme Catalog \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

`tools/build-catalog.sh` generates, builds and installs the Catalog on a simulator of its own. The
Catalog also reads launch arguments (`-component <id> -variant <name> -theme dark|light -state <state>`)
so one component can be opened directly.

## Making a change

- Behavior, sizes and timing follow [beautifului.dev](https://www.beautifului.dev/). If you change a
  component, say how it compares with the original and add or update its test.
- Components stay data-driven: no demo data in the library, no third-party dependencies.
- Keep public API changes small and documented. The library is used by host apps that depend on
  names such as `ToolChipRow` and `BUITheme`.
- Do not add screenshots, source code or assets from beautifului.dev beyond what [NOTICE](NOTICE)
  already covers.

## Commits and pull requests

- One commit per topic. Write the subject in the imperative, sentence case, without a trailing period
  and without a type prefix, as in the history: `Add ToolChipGroup: a run of tool calls as one line of chips`.
- Use the body to say why, when the subject does not.
- Open the pull request against `main` and fill in the template. Tests should pass before review.
