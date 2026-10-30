import BeautifulUI
import SwiftUI

/// The original's self-running walkthrough: the @ menu, connecting Gmail, the / menu, then
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
        PromptSource(id: "figma", name: "Figma", detail: "Design-to-code workflows", icon: .mark(BrandMarks.figma, size: CGSize(width: 11, height: 16))),
        PromptSource(id: "slack", name: "Slack", detail: "Read and manage Slack", icon: .mark(BrandMarks.slack, size: CGSize(width: 15, height: 15))),
        PromptSource(id: "gmail", name: "Gmail", detail: "Read and manage Gmail", icon: .mark(BrandMarks.gmail, size: CGSize(width: 15, height: 12)), kind: .connectable),
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
                if connect { model.connectedSourceIDs.insert("gmail") } else { model.connectedSourceIDs.remove("gmail") }
            }
            if let open = step.modelOpen { model.isModelMenuOpen = open }
            if let id = step.model {
                model.selectedModelID = id
                model.isModelMenuOpen = false
            }
        }
    }
}

/// Figma, Slack and Gmail marks from the original's inline SVGs.
enum BrandMarks {
    static func mark(viewBox: CGSize, _ paths: [(String, UInt32)]) -> BUIAvatar {
        .drawing { gc, size in
            let k = min(size.width / viewBox.width, size.height / viewBox.height)
            gc.translateBy(x: (size.width - viewBox.width * k) / 2, y: (size.height - viewBox.height * k) / 2)
            gc.scaleBy(x: k, y: k)
            for (d, color) in paths { gc.fill(SVGPath.path(d), with: .color(Color(hex: color))) }
        }
    }

    static let figma = mark(viewBox: CGSize(width: 38, height: 57), [
        ("M9.5 57A9.5 9.5 0 0 0 19 47.5V38H9.5a9.5 9.5 0 0 0 0 19z", 0x0ACF83),
        ("M0 28.5A9.5 9.5 0 0 1 9.5 19H19v19H9.5A9.5 9.5 0 0 1 0 28.5z", 0xA259FF),
        ("M0 9.5A9.5 9.5 0 0 1 9.5 0H19v19H9.5A9.5 9.5 0 0 1 0 9.5z", 0xF24E1E),
        ("M19 0h9.5a9.5 9.5 0 1 1 0 19H19V0z", 0xFF7262),
        ("M38 28.5a9.5 9.5 0 1 1-19 0 9.5 9.5 0 0 1 19 0z", 0x1ABCFE),
    ])

    static let slack = mark(viewBox: CGSize(width: 127, height: 127), [
        ("M27.2 80c0 7.3-5.9 13.2-13.2 13.2C6.7 93.2.8 87.3.8 80c0-7.3 5.9-13.2 13.2-13.2h13.2V80zm6.6 0c0-7.3 5.9-13.2 13.2-13.2 7.3 0 13.2 5.9 13.2 13.2v33c0 7.3-5.9 13.2-13.2 13.2-7.3 0-13.2-5.9-13.2-13.2V80z", 0xE01E5A),
        ("M47 27.2c-7.3 0-13.2-5.9-13.2-13.2C33.8 6.7 39.7.8 47 .8c7.3 0 13.2 5.9 13.2 13.2v13.2H47zm0 6.7c7.3 0 13.2 5.9 13.2 13.2 0 7.3-5.9 13.2-13.2 13.2H13.9C6.6 60.3.7 54.4.7 47.1c0-7.3 5.9-13.2 13.2-13.2H47z", 0x36C5F0),
        ("M99.9 47.1c0-7.3 5.9-13.2 13.2-13.2 7.3 0 13.2 5.9 13.2 13.2 0 7.3-5.9 13.2-13.2 13.2H99.9V47.1zm-6.6 0c0 7.3-5.9 13.2-13.2 13.2-7.3 0-13.2-5.9-13.2-13.2V13.9C66.9 6.6 72.8.7 80.1.7c7.3 0 13.2 5.9 13.2 13.2v33.2z", 0x2EB67D),
        ("M80.1 99.8c7.3 0 13.2 5.9 13.2 13.2 0 7.3-5.9 13.2-13.2 13.2-7.3 0-13.2-5.9-13.2-13.2V99.8h13.2zm0-6.6c-7.3 0-13.2-5.9-13.2-13.2 0-7.3 5.9-13.2 13.2-13.2h33.1c7.3 0 13.2 5.9 13.2 13.2 0 7.3-5.9 13.2-13.2 13.2H80.1z", 0xECB22E),
    ])

    static let gmail = mark(viewBox: CGSize(width: 256, height: 193), [
        ("M58.182 192.05V93.14L27.507 65.077 0 49.504v125.091c0 9.658 7.825 17.455 17.455 17.455h40.727Z", 0x4285F4),
        ("M197.818 192.05h40.727c9.659 0 17.455-7.826 17.455-17.455V49.505l-31.156 17.837-27.026 25.798v98.91Z", 0x34A853),
        ("m58.182 93.14-4.174-38.647 4.174-36.989L128 69.868l69.818-52.364 4.669 34.992-4.669 40.644L128 145.504 58.182 93.14Z", 0xEA4335),
        ("M197.818 17.504V93.14L256 49.504V26.231c0-21.585-24.64-33.89-41.89-20.945l-16.292 12.218Z", 0xFBBC04),
        ("m0 49.504 26.759 20.07L58.182 93.14V17.504L41.89 5.286C24.61-7.66 0 4.646 0 26.23v23.273Z", 0xC5221F),
    ])
}
