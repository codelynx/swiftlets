// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "SwiftletsLambda",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        .executable(name: "SwiftletsLambda", targets: ["SwiftletsLambda"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-server/swift-aws-lambda-runtime.git", from: "1.0.0"),
        .package(url: "https://github.com/swift-server/swift-aws-lambda-events.git", from: "1.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "SwiftletsLambda",
            dependencies: [
                .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime"),
                .product(name: "AWSLambdaEvents", package: "swift-aws-lambda-events"),
            ],
            path: ".",
            sources: ["swiftlets-lambda-adapter.swift"]
        ),
    ]
)