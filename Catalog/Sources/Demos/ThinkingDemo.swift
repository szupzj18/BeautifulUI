import BeautifulUI
import SwiftUI

/// Replays the original's staged trace: 0.8 s collapsed, open, two rows, the rest and done,
/// then fold away 2.6 s later.
struct ThinkingDemo: View {
    static let variants = ["Steps", "Reasoning", "Search", "Coding"]
    static let stageDurations: [Double] = [0.8, 0.6, 1.8, 2.6]

    let variant: String
    @State private var stage = 0
    @State private var manualExpanded: Bool?

    private struct Script {
        var style: ThinkingState.Style
        var active: String
        var done: String
        var rows: [ThinkingRow]
        var query: String?
        var footnote: String?
    }

    private var script: Script {
        switch variant {
        case "Reasoning":
            Script(style: .reasoning, active: "Thinking", done: "Thought for 4 seconds", rows: [
                ThinkingRow("Summer demand spikes for stone-fruit flavors — peach and apricot lead."),
                ThinkingRow("I should check cone inventory before promoting a waffle-bowl special."),
            ])
        case "Search":
            Script(style: .search, active: "Searching the web", done: "Searched the web", rows: [
                ThinkingRow("Joy Cone", detail: "joycone.com", url: URL(string: "https://joycone.com/fs_products/waffle-cones/")),
                ThinkingRow("WebstaurantStore", detail: "webstaurantstore.com", url: URL(string: "https://www.webstaurantstore.com/ice-cream-shop-supplies.html")),
                ThinkingRow("The Konery", detail: "thekonery.com", url: URL(string: "https://www.thekonery.com/")),
            ], query: "best waffle cone supplier", footnote: "+7 more")
        case "Coding":
            Script(style: .coding, active: "Running tools", done: "Ran 3 tools", rows: [
                ThinkingRow("Read", detail: "flavors.ts", monospacedDetail: true),
                ThinkingRow("Edit", detail: "ChurnSchedule.tsx", monospacedDetail: true, additions: 74, deletions: 41),
                ThinkingRow("Run", detail: "npm run freeze", monospacedDetail: true),
            ])
        default:
            Script(style: .steps, active: "Thinking", done: "Thought for 4 seconds", rows: [
                ThinkingRow("Reading flavor briefs"),
                ThinkingRow("Scanning supplier lists"),
                ThinkingRow("Comparing tasting notes", detail: "6 flavors"),
                ThinkingRow("Writing the scoop report"),
            ])
        }
    }

    var body: some View {
        let s = script
        let visible = stage < 2 ? 0 : stage == 2 ? min(2, s.rows.count) : s.rows.count
        let autoExpanded = stage >= 1 && stage < 4
        ThinkingState(
            s.style,
            isWorking: stage < 3,
            workingTitle: s.active,
            doneTitle: s.done,
            rows: Array(s.rows.prefix(visible)),
            query: s.query,
            footnote: s.footnote,
            isExpanded: Binding(
                get: { manualExpanded ?? autoExpanded },
                set: { manualExpanded = $0 }
            ),
            minimumHeight: 176
        )
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(maxWidth: 380)
        .task {
            for duration in Self.stageDurations {
                try? await Task.sleep(for: .seconds(duration))
                stage += 1
            }
        }
    }
}
