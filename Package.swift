// swift-tools-version: 6.2
import PackageDescription

// The manifest that makes `https://github.com/szupzj18/BeautifulUI` installable as a
// Swift package. It points at the sources under BeautifulUI/, which is also a package
// of its own (hosts that depend on a local checkout use BeautifulUI/Package.swift).
// Keep the two manifests in sync.
let package = Package(
    name: "BeautifulUI",
    platforms: [.iOS(.v26), .macOS(.v26)],
    products: [
        .library(name: "BeautifulUI", targets: ["BeautifulUI"]),
    ],
    targets: [
        .target(name: "BeautifulUI", path: "BeautifulUI/Sources/BeautifulUI"),
        .testTarget(
            name: "BeautifulUITests",
            dependencies: ["BeautifulUI"],
            path: "BeautifulUI/Tests/BeautifulUITests"
        ),
    ]
)
