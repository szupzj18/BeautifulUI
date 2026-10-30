import SwiftUI

/// The small line icons the site draws inline as 24×24 SVGs, redrawn as paths so their
/// weight and proportions match the original instead of the nearest SF Symbol.
public enum BUIGlyph: Sendable, Hashable {
    case sparkle
    case chevronDown
    case chevronRight
    case check
    case magnifier
    case globe
    case close
    case plus
    case arrowUp
    case arrowRight
    case copy
    case refresh
    case thumbUp
    case thumbDown

    /// Filled glyphs ignore the line width.
    var filled: Bool { self == .sparkle }

    func path(in unit: CGFloat) -> Path {
        var p = Path()
        func pt(_ x: CGFloat, _ y: CGFloat) -> CGPoint { CGPoint(x: x * unit, y: y * unit) }
        func circle(_ cx: CGFloat, _ cy: CGFloat, _ r: CGFloat) {
            p.addEllipse(in: CGRect(x: (cx - r) * unit, y: (cy - r) * unit, width: 2 * r * unit, height: 2 * r * unit))
        }
        func line(_ points: (CGFloat, CGFloat)...) {
            guard let first = points.first else { return }
            p.move(to: pt(first.0, first.1))
            for point in points.dropFirst() { p.addLine(to: pt(point.0, point.1)) }
        }
        switch self {
        case .sparkle:
            // M12 2l2.4 7.2L22 12l-7.6 2.8L12 22l-2.4-7.2L2 12l7.6-2.8z
            line((12, 2), (14.4, 9.2), (22, 12), (14.4, 14.8), (12, 22), (9.6, 14.8), (2, 12), (9.6, 9.2))
            p.closeSubpath()
        case .chevronDown:
            line((6, 9), (12, 15), (18, 9))
        case .chevronRight:
            line((9, 6), (15, 12), (9, 18))
        case .check:
            line((20, 6), (9, 17), (4, 12))
        case .magnifier:
            circle(11, 11, 7)
            line((21, 21), (16.7, 16.7))
        case .globe:
            circle(12, 12, 9)
            line((3.5, 12), (20.5, 12))
            p.move(to: pt(12, 3))
            p.addQuadCurve(to: pt(12, 21), control: pt(19, 12))
            p.move(to: pt(12, 3))
            p.addQuadCurve(to: pt(12, 21), control: pt(5, 12))
        case .close:
            line((18, 6), (6, 18))
            line((6, 6), (18, 18))
        case .plus:
            line((12, 5), (12, 19))
            line((5, 12), (19, 12))
        case .arrowUp:
            line((12, 19), (12, 5))
            line((5, 12), (12, 5), (19, 12))
        case .arrowRight:
            line((5, 12), (19, 12))
            line((13, 6), (19, 12), (13, 18))
        case .copy:
            p.addRoundedRect(in: CGRect(x: 9 * unit, y: 9 * unit, width: 13 * unit, height: 13 * unit), cornerSize: CGSize(width: 2 * unit, height: 2 * unit))
            p.move(to: pt(5, 15))
            p.addLine(to: pt(4, 15))
            p.addQuadCurve(to: pt(2, 13), control: pt(2, 15))
            p.addLine(to: pt(2, 4))
            p.addQuadCurve(to: pt(4, 2), control: pt(2, 2))
            p.addLine(to: pt(13, 2))
            p.addQuadCurve(to: pt(15, 4), control: pt(15, 2))
            p.addLine(to: pt(15, 5))
        case .refresh:
            p.addArc(center: pt(12, 12), radius: 8 * unit, startAngle: .degrees(-60), endAngle: .degrees(250), clockwise: false)
            line((16, 3.5), (16.2, 5.2), (14.5, 6.8))
        case .thumbUp:
            line((7, 10), (7, 20))
            p.move(to: pt(7, 10))
            p.addLine(to: pt(11, 3))
            p.addQuadCurve(to: pt(14, 6), control: pt(14, 3))
            p.addLine(to: pt(13.5, 9))
            p.addLine(to: pt(19, 9))
            p.addQuadCurve(to: pt(21, 11.5), control: pt(21.3, 9.3))
            p.addLine(to: pt(19.5, 18.5))
            p.addQuadCurve(to: pt(17, 20), control: pt(19, 20))
            p.addLine(to: pt(4, 20))
            p.addLine(to: pt(4, 10))
            p.closeSubpath()
        case .thumbDown:
            return BUIGlyph.thumbUp.path(in: unit)
                .applying(CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: 24 * unit))
        }
        return p
    }
}

/// Draws a `BUIGlyph` at `size` points with the original's SVG stroke width.
public struct BUIIcon: View {
    var glyph: BUIGlyph
    var size: CGFloat
    var lineWidth: CGFloat

    /// `lineWidth` is in the SVG's 24-unit space, as written in the original markup.
    public init(_ glyph: BUIGlyph, size: CGFloat = 14, lineWidth: CGFloat = 2) {
        self.glyph = glyph
        self.size = size
        self.lineWidth = lineWidth
    }

    public var body: some View {
        let unit = size / 24
        let path = glyph.path(in: unit)
        Group {
            if glyph.filled {
                path.fill(style: FillStyle())
            } else {
                path.stroke(style: StrokeStyle(lineWidth: lineWidth * unit, lineCap: .round, lineJoin: .round))
            }
        }
        .frame(width: size, height: size)
        .accessibilityHidden(true)
    }
}
