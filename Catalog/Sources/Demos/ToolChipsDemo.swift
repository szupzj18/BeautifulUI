import BeautifulUI
import SwiftUI

/// Adds a tool call every 700 ms, then the changed files.
struct ToolChipsDemo: View {
    static let calls = [
        ToolCall(.think, label: "Thinking", chip: "Planning the churn schedule…", monospacedChip: false, detail: [
            .init("Weekend demand carries pistachio, so it churns first."),
            .init("Batch capacity leaves two evening freezer windows."),
        ]),
        ToolCall(.write, label: "Write 204 lines", chip: "ChurnSchedule.tsx", detail: [
            .init("+ const windows = slots.filter((s) => s.temp <= -12)", isAddition: true),
            .init("+ return schedule(windows, { hero: \"pistachio\" })", isAddition: true),
        ], monospacedDetail: true),
        ToolCall(.run, label: "Rebuild and verify", chip: "npm run freeze", detail: [
            .init("✓ built in 1.2s"),
            .init("✓ 34 checks passed"),
        ], monospacedDetail: true),
        ToolCall(.read, label: "Read image", chip: "flavor-chart.png", detail: [
            .init("1280 × 720 · line chart, three summers."),
            .init("Mint chip trends up 12% through July."),
        ]),
    ]

    static let diffs = [
        FileDiff(file: "flavors.css", additions: 13, deletions: 0, lines: [
            .init(".scoop-card {", .context),
            .init("  gap: 14px;", .removed),
            .init("  gap: 12px;", .added),
            .init("  container-type: inline-size;", .added),
            .init("}", .context),
        ]),
        FileDiff(file: "ChurnSchedule.tsx", additions: 74, deletions: 41, lines: [
            .init("const slots = coldSlots(week);", .context),
            .init("const windows = slots;", .removed),
            .init("const windows = slots.filter(", .added),
            .init("  (s) => s.temp <= -12,", .added),
            .init(");", .added),
        ]),
        FileDiff(file: "menu.ts", additions: 8, deletions: 2, lines: [
            .init("export const hero = \"mint-chip\";", .removed),
            .init("export const hero = \"pistachio\";", .added),
        ]),
    ]

    @State private var step = 0
    @Environment(\.demoState) private var demoState

    var body: some View {
        ToolChips(
            summary: "4 tool calls, 2 messages",
            calls: Array(Self.calls.prefix(step)),
            diffs: step > Self.calls.count ? Self.diffs : nil,
            moreLabel: "+2 more",
            expandedCalls: demoState == "row" ? ["Write 204 lines"] : [],
            previewedFile: demoState == "diff" ? "ChurnSchedule.tsx" : nil
        )
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(maxWidth: 320)
        .task {
            while step <= Self.calls.count {
                try? await Task.sleep(for: .milliseconds(700))
                step += 1
            }
        }
    }
}
