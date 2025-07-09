// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "HelloWorld",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "hello-world",
            targets: ["HelloWorld"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-container-plugin.git", from: "1.0.0")
    ],
    targets: [
        .executableTarget(
            name: "HelloWorld",
            path: "Sources"
        )
    ]
)