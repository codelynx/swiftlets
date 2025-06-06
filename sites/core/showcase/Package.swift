// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "showcase-site",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "index", targets: ["index"]),
        .executable(name: "elements", targets: ["elements"]),
        .executable(name: "api-data", targets: ["api-data"])
    ],
    targets: [
        .executableTarget(
            name: "index",
            dependencies: [],
            path: "src",
            sources: ["index.swift"]
        ),
        .executableTarget(
            name: "elements",
            dependencies: [],
            path: "src",
            sources: ["elements.swift"]
        ),
        .executableTarget(
            name: "api-data",
            dependencies: [],
            path: "src",
            sources: ["api-data.swift"]
        )
    ]
)