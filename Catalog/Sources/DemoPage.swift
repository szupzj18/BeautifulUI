import BeautifulUI
import SwiftUI

/// One component page: its section, alone, with a replay button.
struct DemoPage: View {
    let entry: CatalogEntry
    var initialVariant: String?
    var reportsFrame = false
    /// Goes straight to the next component (handy for flipping through the catalog).
    var onNext: (() -> Void)?
    @State private var replay = 0

    var body: some View {
        ScrollView {
            DemoSection(entry: entry, initialVariant: initialVariant, replay: replay, reportsFrame: reportsFrame)
                .padding(20)
        }
        .background(StripedBackground().ignoresSafeArea())
        .navigationTitle(entry.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Replay", systemImage: "arrow.counterclockwise") { replay += 1 }
            }
            if let onNext {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Next component", systemImage: "chevron.forward", action: onNext)
                }
            }
        }
    }
}

/// A component laid out like a section of beautifului.dev: numbered header, a
/// canvas-coloured demo surface (min 272 pt), and the pill switcher for variants.
struct DemoSection<Header: View>: View {
    let entry: CatalogEntry
    var replay = 0
    var reportsFrame = false
    @ViewBuilder var headerAccessory: Header
    @State private var variant: String
    @Environment(\.buiTheme) private var theme

    init(
        entry: CatalogEntry,
        initialVariant: String? = nil,
        replay: Int = 0,
        reportsFrame: Bool = false,
        @ViewBuilder headerAccessory: () -> Header = { EmptyView() }
    ) {
        self.entry = entry
        self.replay = replay
        self.reportsFrame = reportsFrame
        self.headerAccessory = headerAccessory()
        let start = initialVariant.flatMap { v in entry.variants.first { $0.caseInsensitiveCompare(v) == .orderedSame } }
        _variant = State(initialValue: start ?? entry.variants.first ?? "")
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            header
            surface
        }
    }

    private var header: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Text(entry.number)
                .buiFont(BUITextStyle(size: 11, design: .monospaced))
                .monospacedDigit()
                .foregroundStyle(theme.colors.ink3)
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.title)
                    .buiFont(.title)
                    .foregroundStyle(theme.colors.ink)
                Text(entry.subtitle)
                    .buiFont(.detail)
                    .foregroundStyle(theme.colors.ink3)
            }
            Spacer(minLength: 0)
            headerAccessory
        }
    }

    private var hasSwitcher: Bool { entry.variants.count > 1 }

    private var surface: some View {
        Group {
            if let content = entry.content {
                content(variant)
                    .frame(maxWidth: 480)
                    .id("\(variant)-\(replay)")
            } else {
                Text("Not ported yet")
                    .buiFont(.caption)
                    .foregroundStyle(theme.colors.ink3)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 12)
        // The switcher floats over the surface like the site's `absolute bottom-2.5`;
        // symmetric insets keep the demo centred and clear of it.
        .padding(.vertical, hasSwitcher ? 40 : 12)
        .frame(maxWidth: .infinity, minHeight: 272)
        .background(theme.colors.canvas, in: .rect(cornerRadius: theme.radii.window, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: theme.radii.window, style: .continuous)
                .strokeBorder(theme.colors.line, lineWidth: 1)
        }
        .overlay(alignment: .bottom) {
            if hasSwitcher {
                VariantSwitcher(variants: entry.variants, selection: $variant)
                    .padding(.bottom, 10)
            }
        }
        .onGeometryChange(for: CGRect.self) { $0.frame(in: .global) } action: { frame in
            if reportsFrame { SurfaceFrameReport.write(frame) }
        }
    }
}

/// The site's pill segmented control (`rounded-full bg-field p-0.5`).
struct VariantSwitcher: View {
    let variants: [String]
    @Binding var selection: String
    @Environment(\.buiTheme) private var theme
    @Namespace private var pill

    var body: some View {
        HStack(spacing: 0) {
            ForEach(variants, id: \.self) { v in
                let active = v == selection
                Button {
                    withAnimation(BUIMotion.standard) { selection = v }
                } label: {
                    Text(v)
                        .buiFont(BUITextStyle(size: 11.5, weight: .medium))
                        .foregroundStyle(active ? theme.colors.ink : theme.colors.ink3)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background {
                            if active {
                                Capsule()
                                    .fill(theme.colors.surface)
                                    .overlay(Capsule().strokeBorder(BUIElevationRing.button, lineWidth: 1))
                                    .shadow(color: .black.opacity(0.06), radius: 1.5, y: 0.5)
                                    .matchedGeometryEffect(id: "pill", in: pill)
                            }
                        }
                        .contentShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(2)
        .background(theme.colors.field, in: Capsule())
    }
}

enum BUIElevationRing {
    static let button = Color(light: 0xE0E2E5, dark: 0xFFFFFF, darkAlpha: 0.10)
}

/// The site's page background: `--stripe-bg` with 1 pt `--stripe` lines every 8 pt at -45°.
struct StripedBackground: View {
    @Environment(\.buiTheme) private var theme

    var body: some View {
        Canvas { gc, size in
            gc.fill(Path(CGRect(origin: .zero, size: size)), with: .color(theme.colors.stripeBackground))
            var path = Path()
            let span = size.width + size.height
            var x: CGFloat = 0
            while x < span {
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x - size.height, y: size.height))
                x += 8 * 2.squareRoot()
            }
            gc.stroke(path, with: .color(theme.colors.stripe), lineWidth: 1)
        }
    }
}

enum SurfaceFrameReport {
    static func write(_ frame: CGRect) {
        let json = """
        {"x":\(frame.minX),"y":\(frame.minY),"width":\(frame.width),"height":\(frame.height)}
        """
        let url = URL.documentsDirectory.appending(path: "surface-frame.json")
        try? json.data(using: .utf8)?.write(to: url)
    }
}
