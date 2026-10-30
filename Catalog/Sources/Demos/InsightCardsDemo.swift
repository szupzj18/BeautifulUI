import BeautifulUI
import SwiftUI

/// `-state 1` / `-state 2` open on the second or third page.
struct InsightCardsDemo: View {
    @Environment(\.demoState) private var demoState
    @Environment(\.buiTheme) private var theme

    var body: some View {
        InsightCards(pages: [
            InsightPage(
                id: "compare",
                prose: [.text("The worst performer in your "), .mention("Creamery", dot: theme.colors.orange), .text(" is Rocky Road — down "),
                         .code("-6%", tone: .red), .text(" or "), .code("-$2,453.44", tone: .red), .text(".")],
                card: .comparison([
                    InsightSeries(name: "Mint Chip", values: [-2.9, -3.4, -3.05, -3.86, -3.52, -4.1, -3.82, -4.41], detail: "-$2,377.66", color: Color(hex: 0xF68F3C)),
                    InsightSeries(name: "Pistachio", values: [0.22, 0.58, 0.42, 0.91, 0.76, 1.08, 0.96, 1.15], detail: "+$617.22", color: Color(hex: 0x3D9AFF)),
                ]),
                prompt: "Should I rebalance flavors?"
            ),
            InsightPage(
                id: "anomaly",
                prose: [.text("Unusually high freezer bill on "), .emphasis("Dec 13"), .text(" — "), .code("+$1,834.66", tone: .red), .text(" above your average.")],
                card: .anomaly(InsightAnomaly(
                    title: "High freezer spend",
                    primaryLabel: "Spend", primary: [274, 289, 264, 307, 331, 1210, 1718, 2112], primaryThreshold: "$2,112",
                    secondaryLabel: "Usage", secondary: [18, 19, 17, 21, 22, 58, 81, 96], secondaryThreshold: "82 kWh",
                    headline: "$2,112 spent", delta: "+$1,834.66", comparison: "vs 3 months",
                    format: { value, spend in spend ? "$\(Int(value.rounded()).formatted())" : "\(Int(value.rounded())) kWh" }
                )),
                prompt: "Get tips on cutting freezer costs"
            ),
            InsightPage(
                id: "allocation",
                prose: [.text("You’re heavily invested in "), .mention("Vanilla", dot: theme.colors.orange), .text(" — it’s "), .emphasis("72.5%"), .text(" of your case.")],
                card: .allocation(title: "Vanilla allocation", monogram: "V", segments: [
                    InsightSegment(code: "VAN", label: "Vanilla", percent: 72.5, amount: "$51,785", color: theme.colors.orange),
                    InsightSegment(code: "CHOC", label: "Chocolate", percent: 22.8, amount: "$16,278", color: theme.colors.lineStrong),
                    InsightSegment(code: "MINT", label: "Mint", percent: 4.7, amount: "$3,357", color: theme.colors.line),
                ], note: "Contribution snapshot across current inventory value. Segment selection changes the inspected group without moving the card."),
                prompt: "If we look at seasonals, what changes?"
            ),
        ], page: Int(demoState ?? "") ?? 0)
    }
}
