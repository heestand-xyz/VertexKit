// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "VertexKit",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13)
    ],
    products: [
        .library(name: "VertexKit", targets: ["VertexKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/heestand-xyz/PixelKit", from: "3.0.1"),
        .package(url: "https://github.com/heestand-xyz/PixelColor", from: "1.3.2"),
        .package(url: "https://github.com/heestand-xyz/Resolution", from: "1.0.4"),
        .package(url: "https://github.com/heestand-xyz/CoreGraphicsExtensions", from: "1.3.2"),
    ],
    targets: [
        .target(name: "VertexKit", dependencies: ["PixelKit", "PixelColor", "Resolution", "CoreGraphicsExtensions"], path: "Source"),
    ]
)
