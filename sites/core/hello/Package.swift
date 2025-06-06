// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "hello-site",
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
            path: "src",
            sources: ["index.swift"]
        )
    ]
)