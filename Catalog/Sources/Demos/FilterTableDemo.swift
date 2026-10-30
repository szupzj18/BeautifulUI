import BeautifulUI
import SwiftUI

struct FilterTableDemo: View {
    @Environment(\.demoState) private var demoState

    var body: some View {
        // -state <status id> opens filtered, e.g. -state progress.
        FilterTable(
            statuses: [
                TaskStatus(id: "todo", label: "To do", tint: Color(hex: 0xF09A2F)),
                TaskStatus(id: "progress", label: "In Progress", tint: Color(hex: 0x16A6C7)),
                TaskStatus(id: "done", label: "Completed", tint: Color(hex: 0x25A878)),
            ],
            rows: [
                FilterTableRow(task: "Restock mango sorbet", date: "Dec 03", statusID: "todo", owner: "Mango Moon Gelato"),
                FilterTableRow(task: "Churn black sesame", date: "Sep 22", statusID: "progress", owner: "Kumo Creamery"),
                FilterTableRow(task: "Print summer menu", date: "Jan 02", statusID: "todo", owner: "Coral Coast Sorbet"),
                FilterTableRow(task: "Taste-test batch 42", date: "Nov 08", statusID: "progress", owner: "Maple Orbit"),
                FilterTableRow(task: "Order waffle cones", date: "Apr 14", statusID: "done", owner: "Aurora Scoops"),
            ],
            filter: demoState
        )
    }
}
