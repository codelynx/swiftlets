// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "TestSwift602",
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "test-app", targets: ["TestApp"])
    ],
    targets: [
        .executableTarget(
            name: "TestApp",
            path: "Sources"
        )
    ]
)