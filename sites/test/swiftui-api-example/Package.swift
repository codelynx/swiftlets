// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "SwiftUIAPIExample",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        .package(path: "../../../")
    ],
    targets: [
        .executableTarget(
            name: "hello",
            dependencies: [
                .product(name: "Swiftlets", package: "swiftlets")
            ],
            path: "src",
            sources: ["hello.swift"]
        ),
        .executableTarget(
            name: "settings",
            dependencies: [
                .product(name: "Swiftlets", package: "swiftlets")
            ],
            path: "src",
            sources: ["settings.swift"]
        ),
        .executableTarget(
            name: "settings-cookie",
            dependencies: [
                .product(name: "Swiftlets", package: "swiftlets")
            ],
            path: "src",
            sources: ["settings-cookie.swift"]
        )
    ]
)