import BeautifulUI
import SwiftUI

struct ContextCardsDemo: View {
    @Environment(\.buiTheme) private var theme

    var body: some View {
        ContextCards(count: "32", chunks: [
            ContextChunk(
                title: "Vendor onboarding rule", size: "290 characters",
                body: "Cold-chain certification must be verified before a new dairy can be added to the reorder workflow.",
                source: "Dairy Onboarding SOP.pdf", badge: "PDF", badgeTint: theme.colors.red
            ),
            ContextChunk(
                title: "Seasonal demand row", size: "1,250 characters",
                body: "Q4 velocity table: pistachio +18%, vanilla +6%, rocky road -11%; retire flavors below 40 scoops weekly.",
                source: "Sales Velocity Export.csv", badge: "CSV", badgeTint: theme.colors.green
            ),
        ])
    }
}
