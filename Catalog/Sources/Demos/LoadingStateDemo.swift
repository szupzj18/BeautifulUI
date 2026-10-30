import BeautifulUI
import SwiftUI

struct LoadingStateDemo: View {
    static let variants = ["Drive", "Dots", "Orbit", "Surfer"]
    let variant: String

    var body: some View {
        switch variant {
        case "Dots": LoadingState("Churning", pattern: .dots)
        case "Orbit": LoadingState("Churning", pattern: .orbit)
        case "Surfer":
            LoadingState("Subway surfing") {
                LoadingPreviewPlaceholder()
            }
        default: LoadingState("Churning", pattern: .drive)
        }
    }
}
