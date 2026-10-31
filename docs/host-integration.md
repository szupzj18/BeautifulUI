# Host integration

Hooks for putting the components into an existing app, where the type size, the fonts and the list
behavior are already decided.

```swift
RootView()
    .buiTheme(BUITheme(colors: myColors, radii: myRadii,
                       typeScale: 1.2,     // the original uses desktop sizes (13 pt labels); apps with 17 pt body text set 1.15–1.2
                       entrances: false))  // lists that rebuild rows while scrolling: turn entrances off, or every row fades in at once when a history opens
```

See [theming](theming.md) for the theme itself.

## Fonts

When the host sets `.fontDesign` on an outer view (for example rounded type for the whole app),
the default design of `buiFont` follows it. Styles that are monospaced or rounded by definition
keep their own design.

## Thinking

`ThinkingState(…, maxWidth:)` can fill the available width (the default is 380 pt). While folded it
builds no body, and on appearance it starts no task and attaches no entrance animation. That makes it
fit in a lazy list, one thinking trace per row.

## Tool Chips, used in pieces

- `ToolChipRow(call, isOpen:, isRunning:, chipStyle:, action:) { trailing view }`: one call per row,
  for lists where every step has its own row. The host draws the expanded content.
  `chipStyle: .plain` removes the box around the arguments.
- `ToolCall.Kind.symbol("terminal")` uses an SF Symbol as the icon.
- `ToolChipGroup(chips, isOpen:, isRunning:)`: a run of consecutive calls as one line of chips, for
  example "Read 3 files · Edit Provider.swift +6 −3". There is one chip per tool; `BUIFlowLayout` wraps
  them, and the number of chips does not depend on the number of calls. Tap and expansion are handled
  by the host.

## Code Block diffs

`CodeBlock(filename:diff:additions:deletions:maxWidth:elevation:onTitleTap:)`

- `additions` / `deletions`: the counts in the title, for when only an excerpt of a diff is passed.
- `elevation: .hairline`: drops the shadow when the block sits inside another card.
- `onTitleTap`: makes the file name tappable.
- When no line has a line number, the number gutter is not drawn.
