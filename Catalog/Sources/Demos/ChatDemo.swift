import BeautifulUI
import SwiftUI

/// Opens on the finished thread; sending replays the replies (0.5 s, then 1.4 s and 1.2 s).
/// `-state resolving` holds on the second reply still resolving.
struct ChatDemo: View {
    enum Phase: Int { case idle, sent, reply1, reply2, done }

    static let replies = [
        ChatReply(label: "Sales History", source: "Flavor Data", duration: "4s", body: "Pulled 3 summers of mint chip sales for comparison."),
        ChatReply(label: "Comparison", source: "Trend Detection", duration: "2s", body: "Mint chip is up 12% with stronger weekend peaks."),
    ]

    @State private var phase = Phase.done
    @State private var prompt = "Compare mint chip to last summer"
    @Environment(\.demoState) private var demoState

    private var visibleReplies: [ChatReply] {
        var out: [ChatReply] = []
        if phase.rawValue >= Phase.reply1.rawValue { out.append(Self.replies[0]) }
        if phase.rawValue >= Phase.reply2.rawValue {
            var second = Self.replies[1]
            second.isResolving = phase == .reply2
            out.append(second)
        }
        return out
    }

    var body: some View {
        ChatPanel(
            tabs: ["Flavors", "Suppliers"],
            prompt: phase == .idle ? nil : prompt,
            replies: visibleReplies,
            onSend: { text in
                prompt = text
                phase = .sent
            }
        )
        .onAppear { if demoState == "resolving" { phase = .reply2 } }
        .task(id: phase) {
            let next: (Phase, Double)? = switch phase {
            case .sent: (.reply1, 0.5)
            case .reply1: (.reply2, 1.4)
            case .reply2: demoState == "resolving" ? nil : (.done, 1.2)
            default: nil
            }
            guard let (to, delay) = next else { return }
            try? await Task.sleep(for: .seconds(delay))
            phase = to
        }
    }
}
