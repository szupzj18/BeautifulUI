# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

First version: the SwiftUI port of [Beautiful UI](https://www.beautifului.dev/). When the first
release is tagged, this section becomes `0.1.0`.

### Added

- The `BeautifulUI` Swift package (iOS 26 and macOS 26, Swift 6.2, no third-party dependencies) with a
  token layer: colors with light and dark values, radii, type styles, elevation, easing curves and
  keyframes, taken from the original site (`docs/tokens.md`).
- All 21 components, in the order of the original site: Loading State, Thinking, Streaming Text,
  Approval Card, Tool Chips, Task Rows, Chat, Prompt Bar, Recommendation Card, Context Cards,
  Diff Table, Records Table, Filter Table, Sidebar Nav, Search, Flowchart, Insight Cards,
  Code Block, Fine-tune Card, Selection Actions and Agent Screen.
- `BUITheme` and `.buiTheme(_:)` to map the library onto a host app's own colors and radii.
- Host hooks: `typeScale` and `entrances` on `BUITheme`, a font design that follows the host,
  `ThinkingState(maxWidth:)` (which builds no body while folded, so it stays cheap in a scrolling list),
  `ToolChipRow`, `ToolChipGroup`, `ToolCall.Kind.symbol`, and diff options on `CodeBlock`
  (`additions`, `deletions`, `elevation`, `onTitleTap`, no gutter when lines have no numbers).
  See `docs/host-integration.md`.
- A Catalog demo app, generated with XcodeGen: a gallery of live demos in the original's order, a list
  view, single-component pages, launch arguments for screenshots, and a scripted UI-test walkthrough.
- 58 unit tests.
- Side-by-side comparison sheets with the original site in `compare/`, and the scripts that build them in `tools/`.
- MIT license for this code, the original project's MIT license (`LICENSE-beautifului`) and a `NOTICE`.
- A root `Package.swift`, so the repository can be added to a project by URL.
- README, `docs/`, contributing guide, code of conduct, security policy, issue and pull request
  templates, and a CI workflow.
