// SwiftletsContainer.swift
// Example of how to create a custom container configuration
// This would be used with Swift Container Plugin

import PackagePlugin
import Foundation

// This is a conceptual example - the actual API may differ
// Based on https://github.com/apple/swift-container-plugin

struct SwiftletsContainerConfig {
    static func configure() -> ContainerConfig {
        return ContainerConfig(
            baseImage: "swift:slim",
            workdir: "/app",
            
            // Copy swiftlets-server binary
            copyFiles: [
                CopyFile(from: ".build/release/swiftlets-server", to: "/app/swiftlets-server"),
                CopyFile(from: "sites", to: "/app/sites"),
                CopyFile(from: "run-site", to: "/app/run-site")
            ],
            
            // Set permissions
            runCommands: [
                "chmod +x /app/swiftlets-server",
                "chmod +x /app/run-site"
            ],
            
            // Expose port
            expose: [8080],
            
            // Set entrypoint
            entrypoint: ["/app/run-site"],
            cmd: ["sites/swiftlets-site", "--port", "8080"]
        )
    }
}

// Alternative: Minimal container with just the server
struct MinimalSwiftletsContainer {
    static func configure() -> ContainerConfig {
        return ContainerConfig(
            // Use static musl for minimal size
            buildArgs: ["--static-swift-stdlib"],
            
            // Minimal base image
            baseImage: "scratch",
            
            // Just the binary
            copyFiles: [
                CopyFile(from: ".build/release/swiftlets-server", to: "/swiftlets-server")
            ],
            
            expose: [8080],
            entrypoint: ["/swiftlets-server"]
        )
    }
}