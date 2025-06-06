// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Swiftlets",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        // Framework
        .library(
            name: "Swiftlets",
            targets: ["Swiftlets"]
        ),
        // Executables
        .executable(
            name: "swiftlets-server",
            targets: ["SwiftletsServer"]
        ),
        .executable(
            name: "swiftlets",
            targets: ["SwiftletsCLI"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.77.0"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.5.0"),
        .package(url: "https://github.com/apple/swift-crypto.git", from: "3.0.0")
    ],
    targets: [
        // Framework target
        .target(
            name: "Swiftlets",
            dependencies: [],
            path: "Sources/Swiftlets"
        ),
        
        // Server executable
        .executableTarget(
            name: "SwiftletsServer",
            dependencies: [
                .product(name: "NIO", package: "swift-nio"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio"),
                .product(name: "NIOHTTP1", package: "swift-nio"),
                .product(name: "NIOFoundationCompat", package: "swift-nio"),
                .product(name: "Crypto", package: "swift-crypto")
            ],
            path: "Sources/SwiftletsServer"
        ),
        
        // CLI executable
        .executableTarget(
            name: "SwiftletsCLI",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ],
            path: "Sources/SwiftletsCLI"
        ),
        
        // Tests
        .testTarget(
            name: "SwiftletsTests",
            dependencies: ["Swiftlets"],
            path: "Tests/SwiftletsTests"
        )
    ]
)