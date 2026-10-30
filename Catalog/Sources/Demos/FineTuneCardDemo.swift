import BeautifulUI
import SwiftUI

/// `-state edited` opens with the agent's edits applied; `-state menu` opens the type menu.
struct FineTuneCardDemo: View {
    @Environment(\.demoState) private var demoState

    var body: some View {
        FineTuneCard(
            title: "Flavor card",
            fields: [
                FineTuneField(id: "width", label: "W", value: 324, range: 40...999),
                FineTuneField(id: "height", label: "H", value: 96, range: 24...999),
                FineTuneField(id: "radius", label: "Radius", value: 28, range: 0...64),
                FineTuneField(id: "opacity", label: "Opacity", value: 100, range: 0...100, suffix: "%"),
            ],
            types: ["Seasonal", "Classic", "Limited"],
            layout: demoState == "edited" ? .grid : .row,
            values: demoState == "edited" ? ["radius": 20] : [:],
            type: demoState == "edited" ? "Seasonal" : nil,
            showsTypeMenu: demoState == "menu"
        )
    }
}
