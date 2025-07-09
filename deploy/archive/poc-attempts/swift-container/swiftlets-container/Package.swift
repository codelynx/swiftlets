// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "SwiftletsContainer",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "swiftlets-container",
            targets: ["SwiftletsContainer"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.77.0"),
        .package(url: "https://github.com/apple/swift-container-plugin.git", from: "1.0.0")
    ],
    targets: [
        .executableTarget(
            name: "SwiftletsContainer",
            dependencies: [
                .product(name: "NIO", package: "swift-nio"),
                .product(name: "NIOHTTP1", package: "swift-nio")
            ],
            path: "Sources"
        )
    ]
)