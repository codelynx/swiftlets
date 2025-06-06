// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SwiftletsCLI",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "swiftlets", targets: ["SwiftletsCLI"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.5.0")
    ],
    targets: [
        .executableTarget(
            name: "SwiftletsCLI",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        )
    ]
)