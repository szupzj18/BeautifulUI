import BeautifulUI
import SwiftUI

/// `-state thinking`, `-state result` and `-state expanded` open in those states.
struct SelectionActionsDemo: View {
    @Environment(\.demoState) private var demoState

    var body: some View {
        SelectionActions(
            lead: "Pistachio holds the top slot all weekend. ",
            original: "Churn it first thing Saturday so the batch has time to firm up before the afternoon rush.",
            rewrite: "Churn pistachio first thing Saturday so the batch has time to fully firm before the afternoon rush.",
            primaryActions: [
                SelectionAction("Explain", symbol: "questionmark.bubble"),
                SelectionAction("Improve", symbol: "sparkle", action: "Improve", busyLabel: "Improving"),
            ],
            moreActions: [
                SelectionAction("Shorten", symbol: "scissors", action: "Shorten", busyLabel: "Shortening"),
                SelectionAction("Tone", symbol: "face.smiling", action: "Change tone", busyLabel: "Changing tone"),
                SelectionAction("Grammar", symbol: "textformat", action: "Fix grammar"),
            ],
            phase: demoState == "thinking" ? .thinking : demoState == "result" ? .result : .idle,
            expanded: demoState == "expanded"
        )
    }
}
