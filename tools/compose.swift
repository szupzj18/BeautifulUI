// Crops simulator screenshots and lays out the per-component state sheets.
//
//   compose crop <in.png> <x> <y> <w> <h> <scale> <out.png>
//   compose grid <title> <out.png> <col labels a|b|c> <row labels x|y> <images, row-major...>
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

func grid(_ args: [String]) {
    let title = args[0], out = args[1]
    let cols = args[2].split(separator: "|").map(String.init)
    let rows = args[3].split(separator: "|").map(String.init)
    let images = args[4...].map(load)
    precondition(images.count == cols.count * rows.count, "need \(cols.count * rows.count) images, got \(images.count)")
    let colWidth: CGFloat = 560
    let pad: CGFloat = 28, gap: CGFloat = 16, labelH: CGFloat = 30, titleH: CGFloat = 56, rowLabelH: CGFloat = 28
    func scaledHeight(_ i: CGImage) -> CGFloat { CGFloat(i.height) * colWidth / CGFloat(i.width) }
    let rowHeights = (0..<rows.count).map { r in (0..<cols.count).map { scaledHeight(images[r * cols.count + $0]) }.max()! }
    let width = pad * 2 + colWidth * CGFloat(cols.count) + gap * CGFloat(cols.count - 1)
    let height = pad + titleH + labelH + rowHeights.reduce(0, +) + (rowLabelH + gap) * CGFloat(rows.count) + pad
    let ctx = CGContext(
        data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0,
        space: CGColorSpace(name: CGColorSpace.sRGB)!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
    )!
    ctx.translateBy(x: 0, y: height)
    ctx.scaleBy(x: 1, y: -1)
    ctx.setFillColor(CGColor(gray: 0.5, alpha: 1))
    ctx.fill(CGRect(x: 0, y: 0, width: width, height: height))
    NSGraphicsContext.current = NSGraphicsContext(cgContext: ctx, flipped: true)
    func text(_ s: String, _ x: CGFloat, _ y: CGFloat, size: CGFloat, weight: NSFont.Weight = .regular) {
        let attrs: [NSAttributedString.Key: Any] = [.font: NSFont.systemFont(ofSize: size, weight: weight), .foregroundColor: NSColor.white]
        NSAttributedString(string: s, attributes: attrs).draw(at: CGPoint(x: x, y: y))
    }
    text(title, pad, pad, size: 28, weight: .semibold)
    var y = pad + titleH
    for (c, label) in cols.enumerated() {
        text(label, pad + CGFloat(c) * (colWidth + gap), y, size: 17, weight: .medium)
    }
    y += labelH
    for (r, label) in rows.enumerated() {
        text(label, pad, y, size: 15)
        y += rowLabelH
        for c in 0..<cols.count {
            let img = images[r * cols.count + c]
            let h = scaledHeight(img)
            ctx.saveGState()
            ctx.translateBy(x: pad + CGFloat(c) * (colWidth + gap), y: y + h)
            ctx.scaleBy(x: 1, y: -1)
            ctx.interpolationQuality = .high
            ctx.draw(img, in: CGRect(x: 0, y: 0, width: colWidth, height: h))
            ctx.restoreGState()
        }
        y += rowHeights[r] + gap
    }
    NSGraphicsContext.current = nil
    save(ctx.makeImage()!, out)
}

let args = Array(CommandLine.arguments.dropFirst())
switch args.first {
case "crop": crop(Array(args.dropFirst()))
case "grid": grid(Array(args.dropFirst()))
default: print("usage: compose crop|grid ..."); exit(2)
}
