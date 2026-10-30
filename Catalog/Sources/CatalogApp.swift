import BeautifulUI
import SwiftUI

@main
struct CatalogApp: App {
    private let launch = LaunchOptions.current

    var body: some Scene {
        WindowGroup {
            RootView(launch: launch)
                .preferredColorScheme(launch.colorScheme)
        }
    }
}

/// Launch arguments for screenshots, e.g.
/// `-component loading-state -variant Dots -theme dark -shot YES`.
struct LaunchOptions {
    var component: String?
    var variant: String?
    var colorScheme: ColorScheme?
    /// Writes the demo surface's frame to `Documents/surface-frame.json` so a script can crop screenshots.
    var shot: Bool

    static let current: LaunchOptions = {
        let defaults = UserDefaults.standard
        let scheme: ColorScheme? = switch defaults.string(forKey: "theme") {
        case "dark": .dark
        case "light": .light
        default: nil
        }
        return LaunchOptions(
            component: defaults.string(forKey: "component"),
            variant: defaults.string(forKey: "variant"),
            colorScheme: scheme,
            shot: defaults.bool(forKey: "shot")
        )
    }()
}

struct RootView: View {
    let launch: LaunchOptions
    @State private var path: [String]
    @AppStorage("catalog.layout") private var layout = CatalogLayout.gallery

    init(launch: LaunchOptions) {
        self.launch = launch
        _path = State(initialValue: launch.component.map { [$0] } ?? [])
    }

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                switch layout {
                case .gallery: GalleryView()
                case .list: CatalogList()
                }
            }
            .navigationTitle("BeautifulUI")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(
                        layout == .gallery ? "List" : "Gallery",
                        systemImage: layout == .gallery ? "list.bullet" : "square.grid.2x2"
                    ) {
                        layout = layout == .gallery ? .list : .gallery
                    }
                }
            }
            .navigationDestination(for: String.self) { id in
                if let entry = Catalog.entry(id) {
                    DemoPage(entry: entry, initialVariant: launch.variant, reportsFrame: launch.shot)
                }
            }
        }
    }
}

enum CatalogLayout: String {
    case gallery, list
}

/// Every component live on one scrolling page, in the site's order — the iOS
/// counterpart of beautifului.dev's single-page showcase.
struct GalleryView: View {
    @Environment(\.buiTheme) private var theme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 6) {
                Text("Crafted primitives for AI-native interfaces")
                    .buiFont(BUITextStyle(size: 15, weight: .semibold))
                    .foregroundStyle(theme.colors.ink)
                Text("\(Catalog.portedCount) of \(Catalog.entries.count) components ported from beautifului.dev. Tap a title to open it alone.")
                    .buiFont(.detail)
                    .foregroundStyle(theme.colors.ink3)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.top, 8)

            // Lazy, so demos scrolled off screen stop animating.
            LazyVStack(spacing: 40) {
                ForEach(Catalog.entries) { entry in
                    DemoSection(entry: entry) {
                        if entry.content != nil {
                            NavigationLink(value: entry.id) {
                                Image(systemName: "arrow.up.left.and.arrow.down.right")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(theme.colors.ink3)
                                    .frame(width: 28, height: 28)
                                    .buiSurface(radius: theme.radii.control, elevation: .button)
                            }
                            .accessibilityLabel("Open \(entry.title)")
                        }
                    }
                }
            }
            .padding(16)
        }
        .background(StripedBackground().ignoresSafeArea())
    }
}

struct CatalogList: View {
    @Environment(\.buiTheme) private var theme

    var body: some View {
        List {
            Section {
                ForEach(Catalog.entries) { entry in
                    NavigationLink(value: entry.id) {
                        HStack(alignment: .firstTextBaseline, spacing: 10) {
                            Text(entry.number)
                                .buiFont(BUITextStyle(size: 11, design: .monospaced))
                                .foregroundStyle(theme.colors.ink3)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(entry.title).buiFont(.title)
                                Text(entry.subtitle)
                                    .buiFont(.detail)
                                    .foregroundStyle(theme.colors.ink3)
                                    .lineLimit(2)
                            }
                            Spacer(minLength: 8)
                            if entry.content == nil {
                                Text("Planned")
                                    .buiFont(.micro)
                                    .foregroundStyle(theme.colors.ink3)
                            }
                        }
                    }
                    .disabled(entry.content == nil)
                }
            } footer: {
                Text("SwiftUI port of beautifului.dev (MIT, © 2026 Shane Levine).")
                    .buiFont(.caption)
            }
        }
    }
}
