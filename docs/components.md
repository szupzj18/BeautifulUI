# Components

The 21 components of [Beautiful UI](https://www.beautifului.dev/), in the order of the original site.
Each one links to a sheet of its states: one row per state, two columns (SwiftUI dark, SwiftUI light),
captured from the Catalog on an iPhone 17 Pro.

Components are data-driven and carry no demo data. The ice-cream sample data lives in the
[Catalog](../README.md#run-the-catalog) app only.

| # | Component | Swift types | Differences from the original |
|---|---|---|---|
| 01 | [Loading State](../compare/01-loading-state.jpg) | `LoadingState`, `PixelLoader` | In the Surfer variant the video is replaced by a preview card that takes any view (the Catalog uses the original's own "Video unavailable" fallback). |
| 02 | [Thinking](../compare/02-thinking-state.jpg) | `ThinkingState` | The original advances on an internal timer; here it is driven by `isWorking` and the rows that have arrived. Tapping a search result opens its link. |
| 03 | [Streaming Text](../compare/03-streaming-text.jpg) | `StreamingText` | Inline source chips are drawn after the text and the body is a single `Text`, so CJK wraps correctly. Chips have no separate pop-in animation. |
| 04 | [Approval Card](../compare/04-approval-card.jpg) | `ApprovalCard` | The sliding hover highlight of the options becomes a pressed highlight. The step count uses a numeric roll transition. |
| 05 | [Tool Chips](../compare/05-tool-chips.jpg) | `ToolChips`, `ToolChipRow`, `ToolChipGroup` | Hover becomes tap: tap a row to expand its detail, tap a file chip to float a diff preview below it. It can also be used in pieces: one row per call, or a run of calls as one line (see [host integration](host-integration.md)). |
| 06 | [Task Rows](../compare/06-task-rows.jpg) | `TaskRows` | Hover background becomes pressed background. |
| 07 | [Chat](../compare/07-chat-composer.jpg) | `ChatPanel` | Same as the original. |
| 08 | [Prompt Bar](../compare/08-prompt-bar.jpg) | `PromptBar`, `PromptBarModel` | State lives in an `@Observable` model. The rainbow sweep is a gradient band instead of the original's WebGL shader. Arrow-key and Esc handling is not implemented. The model menu is 184 pt wide (176 in the original; SF is wider). |
| 09 | [Recommendation Card](../compare/09-recommendation-card.jpg) | `RecommendationCard` | Same as the original. Inline entity and value pills are drawn after the text. |
| 10 | [Context Cards](../compare/10-context-cards.jpg) | `ContextCards` | Same as the original. |
| 11 | [Diff Table](../compare/11-diff-table.jpg) | `DiffTable` | Hover dimming becomes pressed dimming. The hint reads "Tap" instead of "Click". |
| 12 | [Records Table](../compare/12-records-table.jpg) | `RecordsTable` | No column-width dragging. The property popover is reduced to prompt, sort and run. While scrolling sideways the company column narrows to 120 pt so the other columns are visible on a phone. |
| 13 | [Filter Table](../compare/13-filter-table.jpg) | `FilterTable` | Same as the original. |
| 14 | [Sidebar Nav](../compare/14-sidebar-nav.jpg) | `SidebarNav` | The original's icon library is replaced by SF Symbols (the popsicle icon is drawn by hand). The sliding hover highlight becomes a pressed background. |
| 15 | [Search](../compare/15-search.jpg) | `SearchList` | Same as the original. |
| 16 | [Flowchart](../compare/16-flowchart.jpg) | `Flowchart` | Same as the original: drag a card and its connectors follow. |
| 17 | [Insight Cards](../compare/17-insight-cards.jpg) | `InsightCards` | The original's Liveline chart library is replaced by a hand-drawn Canvas; drag sideways to read values. |
| 18 | [Code Block](../compare/18-code-block.jpg) | `CodeBlock` | Same as the original. iOS breaks lines differently from a browser, so a few lines wrap at a different place. |
| 19 | [Fine-tune Card](../compare/19-fine-tune-card.jpg) | `FineTuneCard` | Drag a label to change its value directly (the original needs a hover to get the ↔ cursor). Arrow-key nudging is not implemented. |
| 20 | [Selection Actions](../compare/20-selection-actions.jpg) | `SelectionActions` | At phone width the field narrows and the expanded actions scroll sideways inside the bar instead of overflowing. The original's iconoir icons are replaced by SF Symbols. |
| 21 | [Agent Screen](../compare/21-agent-screen.jpg) | `AgentScreen` | The original's desktop screenshot is replaced by a window-like placeholder (pass any screen view). The Open button appears while pressed. The viewer is a full-screen overlay. |

## Global differences

Where web and iOS conventions differ:

- **Fonts.** The original uses Inter and JetBrains Mono; this library uses SF Pro and SF Mono and ships no font files. SF Mono is 0.618 em wide against JetBrains Mono's 0.6 em, so monospaced text is tightened by 0.03 em by default to keep widths and line breaks aligned.
- **Line height.** CSS `line-height` leaves half the extra leading above and below every line. `buiFont` adds that extra space as vertical padding, so line boxes keep the original's height.
- **Hover, right-click, scrollbars.** iOS has none of them. Hover highlights become pressed highlights, controls that only appear on hover appear on tap or press, and scrollbars are hidden.
- **Shadows.** CSS stacks up to six shadows. Here a 1 pt stroke and at most two shadow layers are kept, which is cheaper to composite in a scrolling list.
- **Third-party libraries and assets.** The Liveline charts, the glimm shader, the central-icons and iconoir icons, and the original's videos and screenshots are not included. Canvas, gradients, SF Symbols and placeholder views stand in for them.
