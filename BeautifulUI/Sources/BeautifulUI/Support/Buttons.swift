import SwiftUI

/// The original's `Button` atom: 27 pt pills that shrink to 96 % while pressed.
public struct BUIButtonStyle: ButtonStyle {
    public enum Kind: Sendable {
        /// Accent fill, white label, a faint top highlight.
        case accent
        /// `hover-2` fill — quiet actions such as Skip.
        case ghost
        /// Surface fill with the button ring.
        case secondary
    }

    var kind: Kind
    var fontSize: CGFloat
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.buiTheme) private var theme

    public init(_ kind: Kind, fontSize: CGFloat = 13) {
        self.kind = kind
        self.fontSize = fontSize
    }

    public func makeBody(configuration: Configuration) -> some View {
        let pressed = configuration.isPressed
        configuration.label
            .buiFont(BUITextStyle(size: fontSize, weight: .medium, lineHeight: 1))
            .lineLimit(1)
            .foregroundStyle(kind == .accent ? Color.white : theme.colors.ink)
            .padding(.horizontal, kind == .secondary ? 10 : 12)
            .frame(height: 27)
            .background(fill(pressed: pressed), in: Capsule())
            .overlay {
                switch kind {
                case .accent:
                    // inset 0 1px 0 rgba(255,255,255,.14)
                    Capsule().stroke(Color.white.opacity(0.14), lineWidth: 1).mask(alignment: .top) {
                        Rectangle().frame(height: 1.5)
                    }
                case .secondary:
                    Capsule().strokeBorder(BUIElevation.button.ring(theme.colors) ?? .clear, lineWidth: 1)
                case .ghost:
                    EmptyView()
                }
            }
            .opacity(isEnabled ? 1 : 0.5)
            .scaleEffect(pressed ? 0.96 : 1)
            .animation(BUICurve.easeOut.animation(duration: 0.15), value: pressed)
    }

    private func fill(pressed: Bool) -> Color {
        switch kind {
        case .accent: pressed ? theme.colors.accentInk : theme.colors.accent
        case .ghost: pressed ? theme.colors.lineStrong : theme.colors.hover2
        case .secondary: pressed ? theme.colors.inset : theme.colors.surface
        }
    }
}

public extension ButtonStyle where Self == BUIButtonStyle {
    static func bui(_ kind: BUIButtonStyle.Kind, fontSize: CGFloat = 13) -> BUIButtonStyle {
        BUIButtonStyle(kind, fontSize: fontSize)
    }
}

/// `.primitive-icon-button`: a 28 pt square tap target in `ink-3` that fills `hover` when pressed.
struct IconButtonStyle: ButtonStyle {
    var size: CGFloat = 28
    @Environment(\.buiTheme) private var theme

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(configuration.isPressed ? theme.colors.ink : theme.colors.ink3)
            .frame(width: size, height: size)
            .background(configuration.isPressed ? theme.colors.hover : .clear, in: .rect(cornerRadius: theme.radii.control))
            .contentShape(.rect(cornerRadius: theme.radii.control))
    }
}
