import BeautifulUI
import SwiftUI

/// The original's run: row 2 opens at 1.5 s and closes at 3.9 s, when row 3 fails;
/// row 3 completes at 5.3 s. Taps override the scripted expansion.
struct TaskRowsDemo: View {
    static let variants = ["Capsules", "List"]
    static let ticks: [Double] = [0.6, 0.9, 2.4, 1.4, 2.4]

    let variant: String
    @State private var tick = 0
    @State private var manual: [String: Bool] = [:]
    @Environment(\.demoState) private var demoState

    private var tasks: [TaskItem] {
        [
            TaskItem(id: "verify", title: "Verified vendor records", amount: "12 suppliers", status: .completed, details: [
                .init("Matched tax and contact IDs", meta: "12/12"),
                .init("Flagged stale records", meta: "0"),
            ]),
            TaskItem(id: "index", title: "Build reorder task list", amount: "7 SKUs", status: .running(step: 2), details: [
                .init("Reading POS export", meta: "3 files"),
                .init("Scoring stockout risk", meta: "68%"),
            ]),
            TaskItem(id: "draft", title: "Draft supplier emails", amount: "2 messages",
                     status: tick < 3 ? .pending(step: 3) : tick == 3 ? .failed : .completed, details: [
                .init("Cone supplier follow-up", meta: "draft"),
                .init("Pistachio reorder note", meta: "draft"),
            ]),
        ]
    }

    private func isOpen(_ id: String) -> Bool {
        manual[id] ?? (id == "index" && tick == 2)
    }

    var body: some View {
        TaskRows(
            tasks,
            style: variant == "List" ? .list : .capsules,
            expanded: Binding(
                get: { Set(["verify", "index", "draft"].filter(isOpen)) },
                set: { next in
                    for id in ["verify", "index", "draft"] where next.contains(id) != isOpen(id) {
                        manual[id] = next.contains(id)
                    }
                }
            )
        )
        .animation(BUICurve.outStrong.animation(duration: 0.3), value: tick)
        .onAppear {
            // -state <tick> jumps the script, e.g. -state 3 for the failed row.
            if let t = Int(demoState ?? "") { tick = t }
        }
        .task {
            while tick < Self.ticks.count {
                try? await Task.sleep(for: .seconds(Self.ticks[tick]))
                tick += 1
            }
        }
    }
}
