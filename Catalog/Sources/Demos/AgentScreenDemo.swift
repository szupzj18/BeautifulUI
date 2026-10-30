import BeautifulUI
import SwiftUI

/// `-state open` opens the viewer; `-state recording` opens it recording.
struct AgentScreenDemo: View {
    static let variants = ["Working", "Loading"]
    let variant: String
    @Environment(\.demoState) private var demoState

    var body: some View {
        AgentScreen(
            isLoading: variant == "Loading",
            isOpen: demoState == "open" || demoState == "recording",
            isRecording: demoState == "recording"
        )
    }
}
