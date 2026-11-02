import BeautifulUI
import SwiftUI

/// The original's self-running walkthrough: the @ menu, connecting Mail, the / menu, then
/// upgrading the model (which fires the rainbow sweep). `-state stepN` holds on step N.
struct PromptBarDemo: View {
    static let variants = ["Rounded", "Pill"]

    struct Step {
        var draft: String
        var active: Int?
        var connect: Bool?
        var modelOpen: Bool?
        var model: String?
        var hold: Double
    }

    static let steps: [Step] = [
        Step(draft: "", connect: false, model: "vanilla-1", hold: 1.1),
        Step(draft: "@", active: 0, hold: 0.9),
        Step(draft: "@", active: 1, hold: 0.62),
        Step(draft: "@", active: 4, hold: 0.62),
        Step(draft: "@", active: 6, hold: 0.7),
        Step(draft: "@", active: 6, connect: true, hold: 1.0),
        Step(draft: "", hold: 0.7),
        Step(draft: "/", active: 0, hold: 0.9),
        Step(draft: "/", active: 1, hold: 0.62),
        Step(draft: "/", active: 3, hold: 1.0),
        Step(draft: "", hold: 0.8),
        Step(draft: "", modelOpen: true, hold: 1.2),
        Step(draft: "", model: "sprinkles-5", hold: 2.4),
        Step(draft: "", hold: 0.9),
    ]

    static let sources = [
        PromptSource(id: "attach", name: "Add photos & files", detail: "Upload from your computer", icon: .glyph(BUIGlyph("m21.4 11.05-9.19 9.19a6 6 0 0 1-8.49-8.49l8.57-8.57A4 4 0 1 1 18 8.84l-8.59 8.57a2 2 0 0 1-2.83-2.83l8.49-8.48")), kind: .attach),
        PromptSource(id: "scoop", name: "Scoop Data", detail: "Sales & churn metrics", icon: .glyph(BUIGlyph("M4 20V10M10 20V4M16 20v-7M22 20H2"))),
        PromptSource(id: "flavors", name: "Flavor records", detail: "26 makers, tags, links", icon: .glyph(BUIGlyph("M12 2 2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"))),
        PromptSource(id: "web", name: "Web search", detail: "Real-time news and info", icon: .glyph(BUIGlyph(BUIGlyph.circle(12, 12, 10) + "M2 12h20M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"))),
        PromptSource(id: "docs", name: "Docs", detail: "Drafts and shared notes", icon: .glyph(BUIGlyph("M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7zM14 2v4a2 2 0 0 0 2 2h4M10 9H8M16 13H8M16 17H8"))),
        PromptSource(id: "chat", name: "Chat", detail: "Read and manage Chat", icon: .glyph(BUIGlyph("M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"))),
        PromptSource(id: "mail", name: "Mail", detail: "Read and manage Mail", icon: .glyph(BUIGlyph("M4 4h16a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2zM22 7l-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7")), kind: .connectable),
    ]

    static let commands = [
        PromptCommand("/compare", detail: "Flavor vs. last summer"),
        PromptCommand("/churn-plan", detail: "Draft a churn schedule"),
        PromptCommand("/restock", detail: "Build a reorder list"),
        PromptCommand("/draft-email", detail: "Write a supplier email"),
        PromptCommand("/summarize", detail: "Digest the thread so far"),
    ]

    static let models = [
        PromptModel(id: "sprinkles-5", name: "Sprinkles 5", tag: "Flagship"),
        PromptModel(id: "vanilla-1", name: "Vanilla 1", tag: "Basic"),
        PromptModel(id: "freezer-burn", name: "Freezer Burn 0.4", tag: "Stale"),
    ]

    static let files = ["flavor-chart.png", "summer-menu.pdf", "pos-export.csv"]

    let variant: String
    @State private var model = PromptBarModel(selectedModelID: "vanilla-1")
    @State private var auto = true
    @Environment(\.demoState) private var demoState

    var body: some View {
        PromptBar(
            model: model,
            shape: variant == "Pill" ? .pill : .rounded,
            sources: Self.sources,
            commands: Self.commands,
            models: Self.models,
            sweepModelID: "sprinkles-5",
            onAttach: { model.attachments.append(Self.files[model.attachments.count % Self.files.count]) }
        )
        .frame(maxWidth: 420)
        .frame(minHeight: 384, alignment: .bottom)
        .padding(.bottom, 32)
        .simultaneousGesture(TapGesture().onEnded { auto = false })
        .task {
            if let held = demoState.flatMap({ $0.hasPrefix("step") ? Int($0.dropFirst(4)) : nil }) {
                for i in 0...min(held, Self.steps.count - 1) { apply(Self.steps[i]) }
                return
            }
            var i = 0
            while auto && !Task.isCancelled {
                let step = Self.steps[i % Self.steps.count]
                apply(step)
                try? await Task.sleep(for: .seconds(step.hold))
                i += 1
            }
        }
    }

    private func apply(_ step: Step) {
        withAnimation(BUICurve.outStrong.animation(duration: 0.18)) {
            model.text = step.draft
            if let connect = step.connect {
                if connect { model.connectedSourceIDs.insert("mail") } else { model.connectedSourceIDs.remove("mail") }
            }
            if let open = step.modelOpen { model.isModelMenuOpen = open }
            if let id = step.model {
                model.selectedModelID = id
                model.isModelMenuOpen = false
            }
        }
    }
}
