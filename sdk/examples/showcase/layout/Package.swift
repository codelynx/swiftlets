// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "showcase-layout",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        .package(path: "../../..")
    ],
    targets: [
        .executableTarget(
            name: "showcase-layout",
            dependencies: [
                .product(name: "Swiftlets", package: "swiftlets")
            ],
            path: ".",
            sources: ["main.swift"]
        )
    ]
)