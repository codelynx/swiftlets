// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "my-website",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        // Swiftlets framework dependency
        // For local development:
        .package(path: "../../../core"),
        // For production, use:
        // .package(url: "https://github.com/yourusername/swiftlets.git", from: "1.0.0"),
    ],
    targets: []
)