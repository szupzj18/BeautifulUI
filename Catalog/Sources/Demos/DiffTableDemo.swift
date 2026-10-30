import BeautifulUI
import SwiftUI

struct DiffTableDemo: View {
    @Environment(\.buiTheme) private var theme

    var body: some View {
        DiffTable(title: "Proposed menu cleanup", columns: ["Flavor", "Category", "Supplier"], rows: [
            DiffTableRow(name: "Rocky Road", tag: "Classic", tagTint: theme.colors.accent, detail: "aurora-scoops", change: .removal),
            DiffTableRow(name: "Bubblegum", tag: "Retro", tagTint: theme.colors.ink3, detail: "kumo-creamery", change: .removal),
            DiffTableRow(name: "Mint Chip", tag: "Classic", tagTint: theme.colors.accent, detail: "maple-orbit"),
            DiffTableRow(name: "Pistachio", tag: "Seasonal", tagTint: theme.colors.green, detail: "maple-orbit", change: .addition),
        ])
    }
}
