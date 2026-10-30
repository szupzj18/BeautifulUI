import BeautifulUI
import SwiftUI

/// `-state <query>` opens with that query typed, e.g. `-state cone` or `-state xyz` for the empty state.
struct SearchDemo: View {
    @Environment(\.demoState) private var demoState

    var body: some View {
        SearchList(
            items: [
                "Forecast summer demand", "Find waffle cone suppliers", "Compare seasonal flavors", "Draft flavor launch plan",
                "Check cold-chain status", "Audit sugar costs", "Retire low sellers",
            ],
            query: demoState ?? "",
            placeholder: "Search flavors…"
        )
    }
}
