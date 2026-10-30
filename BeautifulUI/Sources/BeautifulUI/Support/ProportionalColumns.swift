import SwiftUI

/// A table row whose cells take fixed fractions of the width (CSS `table-fixed` with
/// `<col>` percentages). Cells are vertically centred; the row is as tall as its tallest cell.
public struct BUIColumns: Layout {
    public var fractions: [CGFloat]

    public init(_ fractions: [CGFloat]) {
        self.fractions = fractions
    }

    private func widths(_ total: CGFloat, count: Int) -> [CGFloat] {
        (0..<count).map { i in total * (i < fractions.count ? fractions[i] : 0) }
    }

    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? subviews.map { $0.sizeThatFits(.unspecified).width }.reduce(0, +)
        let ws = widths(width, count: subviews.count)
        let height = zip(subviews, ws).map { $0.sizeThatFits(ProposedViewSize(width: $1, height: nil)).height }.max() ?? 0
        return CGSize(width: width, height: height)
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX
        for (subview, w) in zip(subviews, widths(bounds.width, count: subviews.count)) {
            subview.place(at: CGPoint(x: x, y: bounds.midY), anchor: .leading, proposal: ProposedViewSize(width: w, height: bounds.height))
            x += w
        }
    }
}

/// The site's tag pill: `h-5.5 rounded-full bg-inset px-2 text-[11.5px] font-medium shadow-hairline`
/// with a 6 pt colour dot.
public struct BUITagPill: View {
    var label: String
    var dot: Color?
    var fill: Color?
    @Environment(\.buiTheme) private var theme

    public init(_ label: String, dot: Color? = nil, fill: Color? = nil) {
        self.label = label
        self.dot = dot
        self.fill = fill
    }

    public var body: some View {
        HStack(spacing: 6) {
            if let dot {
                Circle().fill(dot).frame(width: 6, height: 6)
            }
            Text(label)
                .buiFont(BUITextStyle(size: 11.5, weight: .medium))
                .foregroundStyle(theme.colors.ink2)
                .lineLimit(1)
        }
        .padding(.horizontal, 8)
        .frame(height: 22)
        .background(fill ?? theme.colors.inset, in: Capsule())
        .overlay(Capsule().strokeBorder(theme.colors.line, lineWidth: 1))
        .fixedSize()
    }
}
