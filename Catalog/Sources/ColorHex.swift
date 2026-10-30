import SwiftUI

/// The Catalog's own hex helpers (the library keeps its equivalents internal so they can't
/// collide with a host app's).
extension Color {
    init(hex: UInt32, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }

    init(light lightHex: UInt32, dark darkHex: UInt32, lightAlpha: Double = 1, darkAlpha: Double = 1) {
        let lightColor = UIColor(Color(hex: lightHex, alpha: lightAlpha))
        let darkColor = UIColor(Color(hex: darkHex, alpha: darkAlpha))
        self.init(uiColor: UIColor { $0.userInterfaceStyle == .dark ? darkColor : lightColor })
    }
}
