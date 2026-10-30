// Crops simulator screenshots and lays out web-vs-SwiftUI comparison sheets.
//
//   compose crop <in.png> <x> <y> <w> <h> <scale> <out.png>
//   compose compare <title> <out.png> <web-dark.png> <ios-dark.png> <web-light.png> <ios-light.png> [caption]
//
// Build: swiftc -O tools/compose.swift -o verify/bin/compose
import AppKit
import CoreGraphics
import ImageIO
import UniformTypeIdentifiers

func load(_ path: String) -> CGImage {
    guard let src = CGImageSourceCreateWithURL(URL(fileURLWithPath: path) as CFURL, nil),
          let img = CGImageSourceCreateImageAtIndex(src, 0, nil) else {
        fatalError("cannot read \(path)")
    }
    return img
}

func save(_ image: CGImage, _ path: String) {
    let url = URL(fileURLWithPath: path)
    try? FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
    guard let dst = CGImageDestinationCreateWithURL(url as CFURL, UTType.png.identifier as CFString, 1, nil) else {
        fatalError("cannot write \(path)")
    }
    CGImageDestinationAddImage(dst, image, nil)
    CGImageDestinationFinalize(dst)
}

func crop(_ args: [String]) {
    let img = load(args[0])
    let n = args[1...5].map { Double($0)! }
    let s = n[4]
    let rect = CGRect(x: n[0] * s, y: n[1] * s, width: n[2] * s, height: n[3] * s).integral
    guard let out = img.cropping(to: rect) else { fatalError("crop out of bounds") }
    save(out, args[6])
}

func compare(_ args: [String]) {
    let title = args[0], out = args[1]
    let images = args[2...5].map(load)
    let caption = args.count > 6 ? args[6] : ""
    let colWidth: CGFloat = 900
    let pad: CGFloat = 32, gap: CGFloat = 24, labelH: CGFloat = 34, titleH: CGFloat = 64
    let captionH: CGFloat = caption.isEmpty ? 0 : 40
    func scaledHeight(_ i: CGImage) -> CGFloat { CGFloat(i.height) * colWidth / CGFloat(i.width) }
    let row1 = max(scaledHeight(images[0]), scaledHeight(images[1]))
    let row2 = max(scaledHeight(images[2]), scaledHeight(images[3]))
    let width = pad * 2 + colWidth * 2 + gap
    let height = pad + titleH + labelH + row1 + gap + labelH + row2 + captionH + pad

    let ctx = CGContext(
        data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0,
        space: CGColorSpace(name: CGColorSpace.sRGB)!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
    )!
    // Flip to top-left origin for layout math.
    ctx.translateBy(x: 0, y: height)
    ctx.scaleBy(x: 1, y: -1)
    ctx.setFillColor(CGColor(gray: 0.5, alpha: 1))
    ctx.fill(CGRect(x: 0, y: 0, width: width, height: height))

    let ns = NSGraphicsContext(cgContext: ctx, flipped: true)
    NSGraphicsContext.current = ns
    func text(_ s: String, _ x: CGFloat, _ y: CGFloat, size: CGFloat, weight: NSFont.Weight = .regular, color: NSColor = .white) {
        let attrs: [NSAttributedString.Key: Any] = [.font: NSFont.systemFont(ofSize: size, weight: weight), .foregroundColor: color]
        NSAttributedString(string: s, attributes: attrs).draw(at: CGPoint(x: x, y: y))
    }
    func draw(_ img: CGImage, _ x: CGFloat, _ y: CGFloat) {
        let h = scaledHeight(img)
        ctx.saveGState()
        ctx.translateBy(x: x, y: y + h)
        ctx.scaleBy(x: 1, y: -1)
        ctx.interpolationQuality = .high
        ctx.draw(img, in: CGRect(x: 0, y: 0, width: colWidth, height: h))
        ctx.restoreGState()
    }

    text(title, pad, pad, size: 30, weight: .semibold)
    let leftX = pad, rightX = pad + colWidth + gap
    var y = pad + titleH
    text("beautifului.dev · dark", leftX, y, size: 18, weight: .medium)
    text("BeautifulUI (SwiftUI, iPhone 17 Pro) · dark", rightX, y, size: 18, weight: .medium)
    y += labelH
    draw(images[0], leftX, y)
    draw(images[1], rightX, y)
    y += row1 + gap
    text("beautifului.dev · light", leftX, y, size: 18, weight: .medium)
    text("BeautifulUI (SwiftUI, iPhone 17 Pro) · light", rightX, y, size: 18, weight: .medium)
    y += labelH
    draw(images[2], leftX, y)
    draw(images[3], rightX, y)
    y += row2
    if !caption.isEmpty { text(caption, pad, y + 10, size: 16, color: NSColor(white: 0.92, alpha: 1)) }

    NSGraphicsContext.current = nil
    save(ctx.makeImage()!, out)
}

let args = Array(CommandLine.arguments.dropFirst())
switch args.first {
case "crop": crop(Array(args.dropFirst()))
case "compare": compare(Array(args.dropFirst()))
default: print("usage: compose crop|compare ..."); exit(2)
}
