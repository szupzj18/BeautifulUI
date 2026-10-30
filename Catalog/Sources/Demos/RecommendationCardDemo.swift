import BeautifulUI
import SwiftUI

struct RecommendationCardDemo: View {
    @Environment(\.demoState) private var demoState

    static let options = [
        Recommendation(
            id: "high",
            body: [.text("Reorder waffle cones from "), .entity("Cone King", monogram: "C", tint: Color(hex: 0xE08A3C)), .text(" with lead time "), .value("7 days", tone: .green)],
            summary: "Reorder from Cone King · 7-day lead", confidence: .high, confidenceLabel: "High confidence",
            actionTitle: "Accept", actionKind: .accent
        ),
        Recommendation(
            id: "review",
            body: [.text("Switch vanilla to "), .value("Vanilla Madagascar"), .text(" for peak season.")],
            summary: "Switch to Vanilla Madagascar", confidence: .review, confidenceLabel: "Needs review",
            actionTitle: "Configure"
        ),
        Recommendation(
            id: "none",
            body: [.text("Fall back to a "), .emphasis("full restock"), .text(" across every SKU.")],
            summary: "Full restock across every SKU", confidence: .none, confidenceLabel: "No signal",
            actionTitle: "Accept full restock"
        ),
    ]

    var body: some View {
        // -state alternatives opens the drawer; -state review promotes the second option.
        RecommendationCard(
            title: "Want me to place this restock order?",
            options: Self.options,
            selected: demoState == "review" ? 1 : 0,
            showsAlternatives: demoState == "alternatives"
        )
    }
}
