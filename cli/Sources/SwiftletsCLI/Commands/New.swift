import ArgumentParser
import Foundation

struct New: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Create a new Swiftlets project"
    )
    
    @Argument(help: "The name of the project to create")
    var name: String
    
    @Option(name: .long, help: "Template to use (default: blank)")
    var template: String = "blank"
    
    @Flag(name: .long, help: "Skip git initialization")
    var skipGit: Bool = false
    
    mutating func run() throws {
        print("Creating new Swiftlets project: \(name)")
        
        let fileManager = FileManager.default
        let currentPath = fileManager.currentDirectoryPath
        let projectPath = "\(currentPath)/\(name)"
        
        // Check if directory already exists
        if fileManager.fileExists(atPath: projectPath) {
            throw CLIError.directoryExists(name)
        }
        
        // Find template path
        let templatePath = findTemplatePath(template: template)
        guard fileManager.fileExists(atPath: templatePath) else {
            throw CLIError.templateNotFound(template)
        }
        
        // Copy template
        print("Using template: \(template)")
        try fileManager.copyItem(atPath: templatePath, toPath: projectPath)
        
        // Update project name in files
        try updateProjectName(in: projectPath, name: name)
        
        // Initialize git if not skipped
        if !skipGit {
            print("Initializing git repository...")
            try initializeGit(in: projectPath)
        }
        
        // Success message
        print("\n✅ Created project: \(name)")
        print("\nNext steps:")
        print("  cd \(name)")
        print("  swiftlets serve")
        print("\nOr build manually:")
        print("  make build")
    }
    
    private func findTemplatePath(template: String) -> String {
        // First, check if we're running from the Swiftlets repo
        let possiblePaths = [
            // Running from CLI build directory
            "../../sdk/templates/\(template)",
            // Running from installed location
            "/usr/local/share/swiftlets/templates/\(template)",
            // Running from development
            "sdk/templates/\(template)",
            // Check relative to executable
            URL(fileURLWithPath: CommandLine.arguments[0])
                .deletingLastPathComponent()
                .appendingPathComponent("../../../sdk/templates/\(template)")
                .path
        ]
        
        let fileManager = FileManager.default
        for path in possiblePaths {
            let absolutePath = URL(fileURLWithPath: path).standardized.path
            if fileManager.fileExists(atPath: absolutePath) {
                return absolutePath
            }
        }
        
        // Default to first path
        return possiblePaths[0]
    }
    
    private func updateProjectName(in projectPath: String, name: String) throws {
        let filesToUpdate = [
            "\(projectPath)/Package.swift",
            "\(projectPath)/README.md",
            "\(projectPath)/Makefile"
        ]
        
        for file in filesToUpdate {
            if FileManager.default.fileExists(atPath: file) {
                var content = try String(contentsOfFile: file)
                content = content.replacingOccurrences(of: "MyProject", with: name)
                content = content.replacingOccurrences(of: "my-project", with: name.lowercased())
                try content.write(toFile: file, atomically: true, encoding: .utf8)
            }
        }
    }
    
    private func initializeGit(in projectPath: String) throws {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/git")
        process.arguments = ["init"]
        process.currentDirectoryURL = URL(fileURLWithPath: projectPath)
        
        try process.run()
        process.waitUntilExit()
        
        if process.terminationStatus != 0 {
            throw CLIError.gitInitFailed
        }
    }
}

enum CLIError: LocalizedError {
    case directoryExists(String)
    case templateNotFound(String)
    case gitInitFailed
    case serverNotFound
    case buildFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .directoryExists(let name):
            return "Directory '\(name)' already exists"
        case .templateNotFound(let template):
            return "Template '\(template)' not found"
        case .gitInitFailed:
            return "Failed to initialize git repository"
        case .serverNotFound:
            return "Swiftlets server not found. Please build it first with 'swiftlets build'"
        case .buildFailed(let message):
            return "Build failed: \(message)"
        }
    }
}