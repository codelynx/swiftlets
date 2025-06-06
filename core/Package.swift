// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Swiftlets",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "swiftlets-server", targets: ["SwiftletsServer"]),
        .library(name: "Swiftlets", targets: ["Swiftlets"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.77.0"),
    ],
    targets: [
        .target(
            name: "Swiftlets",
            dependencies: [],
            path: "Sources/Swiftlets"
        ),
        .executableTarget(
            name: "SwiftletsServer",
            dependencies: [
                "Swiftlets",
                .product(name: "NIO", package: "swift-nio"),
                .product(name: "NIOHTTP1", package: "swift-nio"),
                .product(name: "NIOFoundationCompat", package: "swift-nio")
            ]
        ),
        .testTarget(
            name: "SwiftletsTests",
            dependencies: ["Swiftlets"]
        )
    ]
)
