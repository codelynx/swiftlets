// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "swiftlets",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "swiftlets-server", targets: ["SwiftletsServer"]),
        .library(name: "SwiftletsCore", targets: ["SwiftletsCore"]),
        .library(name: "SwiftletsHTML", targets: ["SwiftletsHTML"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.77.0"),
    ],
    targets: [
        .target(
            name: "SwiftletsCore",
            dependencies: []
        ),
        .target(
            name: "SwiftletsHTML",
            dependencies: ["SwiftletsCore"]
        ),
        .executableTarget(
            name: "SwiftletsServer",
            dependencies: [
                .product(name: "NIO", package: "swift-nio"),
                .product(name: "NIOHTTP1", package: "swift-nio"),
                .product(name: "NIOFoundationCompat", package: "swift-nio")
            ]
        ),
        .testTarget(
            name: "SwiftletsHTMLTests",
            dependencies: ["SwiftletsHTML"]
        )
    ]
)
