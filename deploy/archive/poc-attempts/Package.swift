// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "HelloMusl",
    platforms: [.macOS(.v10_15)],
    products: [
        .executable(name: "hello-musl", targets: ["Hello"])
    ],
    targets: [
        .executableTarget(
            name: "Hello",
            path: ".",
            sources: ["hello.swift"]
        )
    ]
)
