// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "TestCrossCompile",
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