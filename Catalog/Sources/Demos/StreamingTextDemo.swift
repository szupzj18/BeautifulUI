import BeautifulUI
import SwiftUI

/// Streams the original's answer at 55 ms a word, holds the finished answer 3.4 s, and loops.
struct StreamingTextDemo: View {
    static let tokens: [StreamingToken] =
        StreamingToken.words("Pistachio is your fastest-growing flavor — sales are up 23% this month and margins beat vanilla by 8 points.")
        + [.citation(0)]
        + StreamingToken.words("Stone-fruit flavors are trending in the same range.")

    static let sources = [
        StreamingSource(name: "Scoop Data", domain: "scoopdata.io", url: URL(string: "https://scoopdata.io/"), avatar: DemoMarks.scoop),
        StreamingSource(name: "Trends Index", domain: "trends.google.com", url: URL(string: "https://trends.google.com/trends/"), avatar: DemoMarks.trends),
        StreamingSource(name: "Market Basket", domain: "marketbasket.io", url: URL(string: "https://marketbasket.io/"), avatar: DemoMarks.market),
    ]

    @State private var count = 0
    @State private var sourcesOpen = false
    @Environment(\.demoState) private var demoState

    var body: some View {
        StreamingText(
            tokens: Array(Self.tokens.prefix(count)),
            isStreaming: count < Self.tokens.count,
            sources: Self.sources,
            sourcesLabel: "10 sources",
            followUps: ["Which flavors sell best in winter", "Compare gelato and soft serve margins"],
            minimumHeight: 248,
            sourcesExpanded: $sourcesOpen
        )
        .frame(maxWidth: 380)
        .onAppear { sourcesOpen = demoState == "sources" }
        .task {
            while !Task.isCancelled {
                let done = count >= Self.tokens.count
                try? await Task.sleep(for: .milliseconds(done ? 3400 : 55))
                count = done ? 0 : count + 1
            }
        }
    }
}

/// The original's three source marks (64×64 SVGs), redrawn from their path data.
enum DemoMarks {
    static func mark(_ draw: @escaping @Sendable (inout GraphicsContext, CGFloat) -> Void) -> BUIAvatar {
        .drawing { gc, size in
            let k = size.width / 64
            gc.scaleBy(x: k, y: k)
            draw(&gc, k)
        }
    }

    static let scoop = mark { gc, _ in
        gc.fill(Path(roundedRect: CGRect(x: 0, y: 0, width: 64, height: 64), cornerRadius: 16), with: .color(Color(hex: 0x1F7A5F)))
        gc.fill(SVGPath.path("M20 36c0 7 5.4 12 12 12s12-5 12-12H20Z"), with: .color(.white))
        gc.fill(Path(ellipseIn: CGRect(x: 21, y: 14, width: 22, height: 22)), with: .color(Color(hex: 0xBFF3DD)))
        gc.stroke(SVGPath.path("M24 24c4-7 13-7 17 0"), with: .color(Color(hex: 0x1F7A5F)), style: StrokeStyle(lineWidth: 4, lineCap: .round))
    }

    static let trends = mark { gc, _ in
        gc.fill(Path(roundedRect: CGRect(x: 0, y: 0, width: 64, height: 64), cornerRadius: 16), with: .color(Color(hex: 0x2F6FEC)))
        gc.stroke(SVGPath.path("M15 43 27 31l8 7 14-18"), with: .color(.white), style: StrokeStyle(lineWidth: 7, lineCap: .round, lineJoin: .round))
        gc.fill(Path(ellipseIn: CGRect(x: 44, y: 15, width: 10, height: 10)), with: .color(Color(hex: 0xBFE0FF)))
    }

    static let market = mark { gc, _ in
        gc.fill(Path(roundedRect: CGRect(x: 0, y: 0, width: 64, height: 64), cornerRadius: 16), with: .color(Color(hex: 0xE56D24)))
        gc.fill(SVGPath.path("M17 45V25h8v20h-8Zm11 0V16h8v29h-8Zm11 0V30h8v15h-8Z"), with: .color(.white))
        gc.stroke(SVGPath.path("M16 49h32"), with: .color(Color(hex: 0xFFD6B8)), style: StrokeStyle(lineWidth: 4, lineCap: .round))
    }
}
