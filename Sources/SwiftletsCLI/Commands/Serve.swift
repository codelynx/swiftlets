import ArgumentParser
import Foundation

struct Serve: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Start the Swiftlets development server"
    )
    
    @Argument(help: "Path to the site directory (default: current directory)")
    var path: String?
    
    @Option(name: .shortAndLong, help: "Port to listen on")
    var port: Int = 8080
    
    @Option(name: .shortAndLong, help: "Host to bind to")
    var host: String = "127.0.0.1"
    
    @Flag(name: .long, help: "Build in release mode")
    var release: Bool = false
    
    @Flag(name: .long, help: "Suppress server output")
    var quiet: Bool = false
    
    mutating func run() throws {
        // Determine site path
        let sitePath = path ?? FileManager.default.currentDirectoryPath
        
        // Check if web directory exists
        let webPath = "\(sitePath)/web"
        if !FileManager.default.fileExists(atPath: webPath) {
            print("⚠️  No 'web' directory found in: \(sitePath)")
            print("💡 Create one with: mkdir web")
            print("💡 Or specify a different path: swiftlets serve path/to/site")
        }
        
        // Find server binary
        let serverPath = try findServerBinary()
        
        // Set up environment
        var environment = ProcessInfo.processInfo.environment
        environment["SWIFTLETS_SITE"] = sitePath
        environment["SWIFTLETS_HOST"] = host
        environment["SWIFTLETS_PORT"] = String(port)
        
        // Print startup message
        if !quiet {
            print("🚀 Starting Swiftlets server")
            print("📁 Site: \(sitePath)")
            print("🌐 URL: http://\(host):\(port)")
            print("\nPress Ctrl+C to stop the server\n")
        }
        
        // Run server
        let process = Process()
        process.executableURL = URL(fileURLWithPath: serverPath)
        process.environment = environment
        
        // Forward output unless quiet
        if !quiet {
            process.standardOutput = FileHandle.standardOutput
            process.standardError = FileHandle.standardError
        }
        
        // Handle interruption
        signal(SIGINT) { _ in
            print("\n\n👋 Stopping server...")
            Foundation.exit(0)
        }
        
        try process.run()
        process.waitUntilExit()
    }
    
    private func findServerBinary() throws -> String {
        let _ = detectPlatform()
        let arch = detectArchitecture()
        
        // Possible server locations
        let buildMode = release ? "release" : "debug"
        let possiblePaths = [
            // Running from development
            "core/.build/\(buildMode)/swiftlets-server",
            "../core/.build/\(buildMode)/swiftlets-server",
            "../../core/.build/\(buildMode)/swiftlets-server",
            // Platform-specific paths
            "core/.build/\(arch)-apple-macosx/\(buildMode)/swiftlets-server",
            "core/.build/aarch64-unknown-linux-gnu/\(buildMode)/swiftlets-server",
            "core/.build/x86_64-unknown-linux-gnu/\(buildMode)/swiftlets-server",
            // Installed location
            "/usr/local/bin/swiftlets-server"
        ]
        
        let fileManager = FileManager.default
        for path in possiblePaths {
            let absolutePath = URL(fileURLWithPath: path).standardized.path
            if fileManager.fileExists(atPath: absolutePath) &&
               fileManager.isExecutableFile(atPath: absolutePath) {
                return absolutePath
            }
        }
        
        throw CLIError.serverNotFound
    }
    
    private func detectPlatform() -> String {
        #if os(macOS)
        return "macos"
        #elseif os(Linux)
        return "linux"
        #else
        return "unknown"
        #endif
    }
    
    private func detectArchitecture() -> String {
        #if arch(x86_64)
        return "x86_64"
        #elseif arch(arm64)
        return "arm64"
        #else
        return "unknown"
        #endif
    }
}