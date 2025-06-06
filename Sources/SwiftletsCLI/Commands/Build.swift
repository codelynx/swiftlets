import ArgumentParser
import Foundation

struct Build: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Build swiftlets for the current project"
    )
    
    @Argument(help: "Specific swiftlet to build (builds all if not specified)")
    var target: String?
    
    @Flag(name: .long, help: "Build in release mode")
    var release: Bool = false
    
    @Flag(name: .long, help: "Clean before building")
    var clean: Bool = false
    
    @Flag(name: .long, help: "Show verbose output")
    var verbose: Bool = false
    
    mutating func run() throws {
        let fileManager = FileManager.default
        let currentPath = fileManager.currentDirectoryPath
        
        // Check if we're in a Swiftlets project
        let srcPath = "\(currentPath)/src"
        let webPath = "\(currentPath)/web"
        
        guard fileManager.fileExists(atPath: srcPath) else {
            print("❌ No 'src' directory found. Are you in a Swiftlets project?")
            throw ExitCode.failure
        }
        
        // Clean if requested
        if clean {
            print("🧹 Cleaning build artifacts...")
            let binPath = "\(webPath)/bin"
            if fileManager.fileExists(atPath: binPath) {
                try fileManager.removeItem(atPath: binPath)
            }
            try fileManager.createDirectory(atPath: binPath, withIntermediateDirectories: true)
        }
        
        // Find Swift files to build
        let swiftFiles = try findSwiftFiles(in: srcPath, target: target)
        
        if swiftFiles.isEmpty {
            print("⚠️  No Swift files found to build")
            return
        }
        
        print("🔨 Building \(swiftFiles.count) swiftlet(s)...")
        
        // Build each swiftlet
        var failures = 0
        for swiftFile in swiftFiles {
            do {
                try buildSwiftlet(swiftFile: swiftFile, webPath: webPath, release: release, verbose: verbose)
                print("✅ Built: \(swiftFile.lastPathComponent)")
            } catch {
                print("❌ Failed: \(swiftFile.lastPathComponent)")
                if verbose {
                    print("   Error: \(error)")
                }
                failures += 1
            }
        }
        
        // Summary
        print("\n📊 Build Summary:")
        print("   Total: \(swiftFiles.count)")
        print("   Success: \(swiftFiles.count - failures)")
        print("   Failed: \(failures)")
        
        if failures > 0 {
            throw ExitCode.failure
        }
    }
    
    private func findSwiftFiles(in directory: String, target: String?) throws -> [URL] {
        let fileManager = FileManager.default
        var swiftFiles: [URL] = []
        
        if let target = target {
            // Build specific target
            let targetPath = "\(directory)/\(target).swift"
            if fileManager.fileExists(atPath: targetPath) {
                swiftFiles.append(URL(fileURLWithPath: targetPath))
            } else {
                throw CLIError.buildFailed("Target '\(target)' not found")
            }
        } else {
            // Build all Swift files
            let enumerator = fileManager.enumerator(atPath: directory)
            while let file = enumerator?.nextObject() as? String {
                if file.hasSuffix(".swift") && !file.contains("Package.swift") {
                    swiftFiles.append(URL(fileURLWithPath: "\(directory)/\(file)"))
                }
            }
        }
        
        return swiftFiles
    }
    
    private func buildSwiftlet(swiftFile: URL, webPath: String, release: Bool, verbose: Bool) throws {
        let fileName = swiftFile.deletingPathExtension().lastPathComponent
        let outputPath = "\(webPath)/bin/\(fileName)"
        
        // Create output directory
        let outputDir = URL(fileURLWithPath: outputPath).deletingLastPathComponent().path
        try FileManager.default.createDirectory(atPath: outputDir, withIntermediateDirectories: true)
        
        // Build command
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        
        var arguments = ["swiftc", swiftFile.path, "-o", outputPath]
        if release {
            arguments.append(contentsOf: ["-O", "-whole-module-optimization"])
        }
        
        process.arguments = arguments
        
        // Capture output
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        process.standardOutput = outputPipe
        process.standardError = errorPipe
        
        try process.run()
        process.waitUntilExit()
        
        // Read output
        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        
        if verbose || process.terminationStatus != 0 {
            if let output = String(data: outputData, encoding: .utf8), !output.isEmpty {
                print(output)
            }
            if let error = String(data: errorData, encoding: .utf8), !error.isEmpty {
                print(error)
            }
        }
        
        if process.terminationStatus != 0 {
            throw CLIError.buildFailed("Compilation failed")
        }
        
        // Make executable
        try FileManager.default.setAttributes([.posixPermissions: 0o755], ofItemAtPath: outputPath)
        
        // Create/update webbin file
        let webbinPath = "\(webPath)/\(fileName).webbin"
        try fileName.write(toFile: webbinPath, atomically: true, encoding: .utf8)
    }
}