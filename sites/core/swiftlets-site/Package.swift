// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "swiftlets-site",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        .package(path: "../../../core")
    ],
    targets: [
        .executableTarget(
            name: "SwiftletsSite",
            dependencies: [
                .product(name: "SwiftletsCore", package: "core"),
                .product(name: "SwiftletsHTML", package: "core")
            ],
            path: "src"
        )
    ]
)