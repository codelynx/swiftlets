// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "hello",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "index", targets: ["index"])
    ],
    targets: [
        .executableTarget(
            name: "index",
            dependencies: [],
            path: ".",
            sources: ["index.swift"]
        )
    ]
)