// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "hello-site",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "index", targets: ["index"]),
        .executable(name: "index-dsl", targets: ["index-dsl"])
    ],
    dependencies: [
        .package(path: "../../..")
    ],
    targets: [
        .executableTarget(
            name: "index",
            dependencies: [],
            path: "src",
            sources: ["index.swift"]
        ),
        .executableTarget(
            name: "index-dsl",
            dependencies: [
                .product(name: "SwiftletsHTML", package: "swiftlets")
            ],
            path: "src",
            sources: ["index-dsl.swift"]
        )
    ]
)