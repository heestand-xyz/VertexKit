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
        .package(url: "https://github.com/heestand-xyz/RenderKit.git", .branch("lite")),
        .package(url: "https://github.com/heestand-xyz/PixelKit.git", .branch("lite")),
    ],
    targets: [
        .target(name: "VertexKit", dependencies: ["PixelKit", "RenderKit"], path: "Source", resources: [
//            .copy("Metal/VertexKitShaders.metallib"),
//            .copy("Metal/VertexKitShaders-macOS.metallib"),
            .process("Shaders")
        ]),
    ]
)
