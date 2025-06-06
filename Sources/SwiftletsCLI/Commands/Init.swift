import ArgumentParser
import Foundation

struct Init: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Initialize Swiftlets in the current directory"
    )
    
    @Flag(name: .long, help: "Force initialization even if files exist")
    var force: Bool = false
    
    mutating func run() throws {
        let fileManager = FileManager.default
        let currentPath = fileManager.currentDirectoryPath
        let projectName = URL(fileURLWithPath: currentPath).lastPathComponent
        
        print("Initializing Swiftlets in: \(currentPath)")
        
        // Check for existing files
        let requiredDirs = ["src", "web", "web/bin"]
        let requiredFiles = ["Package.swift", "Makefile", ".gitignore"]
        
        if !force {
            for file in requiredFiles {
                if fileManager.fileExists(atPath: "\(currentPath)/\(file)") {
                    print("❌ \(file) already exists. Use --force to overwrite.")
                    throw ExitCode.failure
                }
            }
        }
        
        // Create directories
        for dir in requiredDirs {
            try fileManager.createDirectory(
                atPath: "\(currentPath)/\(dir)",
                withIntermediateDirectories: true
            )
        }
        
        // Create Package.swift
        let packageContent = """
        // swift-tools-version: 6.0
        import PackageDescription
        
        let package = Package(
            name: "\(projectName)",
            platforms: [
                .macOS(.v13)
            ],
            products: [
                .executable(name: "index", targets: ["Index"])
            ],
            targets: [
                .executableTarget(
                    name: "Index",
                    path: "src",
                    sources: ["index.swift"]
                )
            ]
        )
        """
        try packageContent.write(
            toFile: "\(currentPath)/Package.swift",
            atomically: true,
            encoding: .utf8
        )
        
        // Create Makefile
        let makefileContent = """
        # Swiftlets Makefile
        
        .PHONY: build
        build:
        	swiftlets build
        
        .PHONY: serve
        serve:
        	swiftlets serve
        
        .PHONY: clean
        clean:
        	rm -rf web/bin/*
        
        .PHONY: dev
        dev: build serve
        """
        try makefileContent.write(
            toFile: "\(currentPath)/Makefile",
            atomically: true,
            encoding: .utf8
        )
        
        // Create .gitignore
        let gitignoreContent = """
        .build/
        .swiftpm/
        .DS_Store
        *.xcodeproj
        *.xcworkspace
        Package.resolved
        web/bin/
        """
        try gitignoreContent.write(
            toFile: "\(currentPath)/.gitignore",
            atomically: true,
            encoding: .utf8
        )
        
        // Create sample index.swift
        let indexContent = """
        import Foundation
        
        @main
        struct Index {
            static func main() {
                print("Status: 200")
                print("Content-Type: text/html; charset=utf-8")
                print("")
                print(\"\"\"
        <!DOCTYPE html>
        <html>
        <head>
            <title>Welcome to Swiftlets</title>
        </head>
        <body>
            <h1>Hello from Swiftlets!</h1>
            <p>Your server is running. Edit src/index.swift to change this page.</p>
        </body>
        </html>
        \"\"\")
            }
        }
        """
        try indexContent.write(
            toFile: "\(currentPath)/src/index.swift",
            atomically: true,
            encoding: .utf8
        )
        
        // Create webbin file
        try "index".write(
            toFile: "\(currentPath)/web/index.webbin",
            atomically: true,
            encoding: .utf8
        )
        
        print("\n✅ Swiftlets initialized successfully!")
        print("\nNext steps:")
        print("  swiftlets build    # Build your swiftlets")
        print("  swiftlets serve    # Start the development server")
    }
}