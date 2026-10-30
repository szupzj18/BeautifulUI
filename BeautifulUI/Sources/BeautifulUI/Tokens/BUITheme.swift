import SwiftUI

/// Everything a component reads to draw itself. Inject a custom theme with
/// `.buiTheme(_:)` to map the library onto a host app's own tokens.
public struct BUITheme: Sendable {
    public var colors: BUIColors
    public var radii: BUIRadii

    public init(colors: BUIColors = .standard, radii: BUIRadii = .standard) {
        self.colors = colors
        self.radii = radii
    }

    public static let standard = BUITheme()
}

public extension EnvironmentValues {
    @Entry var buiTheme: BUITheme = .standard
}

public extension View {
    func buiTheme(_ theme: BUITheme) -> some View {
        environment(\.buiTheme, theme)
    }
}
