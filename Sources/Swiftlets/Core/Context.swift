import Foundation

/// Context provided to swiftlets for accessing resources and storage
public protocol SwiftletContext: Sendable {
    /// The current HTTP request
    var request: Request { get }
    
    /// Access read-only resources with hierarchical lookup
    var resources: Resources { get }
    
    /// Access writable storage (no fallback)
    var storage: Storage { get }
    
    /// Current route path (e.g., "/blog/tutorial")
    var routePath: String { get }
}

// MARK: - Task Local Storage for SwiftletContext

public enum SwiftletContextKey {
    @TaskLocal
    public static var current: SwiftletContext?
}

public extension SwiftletContext {
    /// Current context from Task Local Storage
    static var current: SwiftletContext? {
        SwiftletContextKey.current
    }
    
    /// Run a closure with the given context
    static func run<T>(with context: SwiftletContext, operation: () async throws -> T) async rethrows -> T {
        try await SwiftletContextKey.$current.withValue(context) {
            try await operation()
        }
    }
}

/// Read-only resources with hierarchical lookup
public struct Resources: Sendable {
    private let resourcePaths: [String]
    
    init(resourcePaths: [String]) {
        self.resourcePaths = resourcePaths
    }
    
    /// Read resource with hierarchical lookup, returns raw binary data
    public func read(named name: String) throws -> Foundation.Data {
        // Try each path in order until we find the resource
        for basePath in resourcePaths {
            let fullPath = basePath + name
            if FileManager.default.fileExists(atPath: fullPath) {
                return try Foundation.Data(contentsOf: URL(fileURLWithPath: fullPath))
            }
        }
        
        throw ResourceError.notFound(name)
    }
}

/// Writable storage with working directory already set
public struct Storage: Sendable {
    // Working directory is already set to var/{route}/ by server
    
    public func write(_ data: Foundation.Data, to path: String) throws {
        let url = URL(fileURLWithPath: path)
        
        // Create parent directory if needed
        let parentDir = url.deletingLastPathComponent()
        try FileManager.default.createDirectory(
            at: parentDir,
            withIntermediateDirectories: true,
            attributes: nil
        )
        
        try data.write(to: url)
    }
    
    public func read(from path: String) throws -> Foundation.Data {
        let url = URL(fileURLWithPath: path)
        return try Foundation.Data(contentsOf: url)
    }
    
    public func delete(_ path: String) throws {
        let url = URL(fileURLWithPath: path)
        try FileManager.default.removeItem(at: url)
    }
    
    public func exists(_ path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
    
    // Directory operations using relative paths
    public func contentsOfDirectory(at path: String = ".") throws -> [String] {
        let url = URL(fileURLWithPath: path)
        return try FileManager.default.contentsOfDirectory(atPath: url.path)
    }
    
    public func createDirectory(at path: String) throws {
        let url = URL(fileURLWithPath: path)
        try FileManager.default.createDirectory(
            at: url,
            withIntermediateDirectories: true,
            attributes: nil
        )
    }
    
    public func removeDirectory(at path: String) throws {
        let url = URL(fileURLWithPath: path)
        try FileManager.default.removeItem(at: url)
    }
}

/// Errors that can occur when accessing resources
public enum ResourceError: Error, LocalizedError {
    case notFound(String)
    case invalidEncoding
    
    public var errorDescription: String? {
        switch self {
        case .notFound(let name):
            return "Resource not found: \(name)"
        case .invalidEncoding:
            return "Invalid string encoding"
        }
    }
}

/// Convenience extensions for common data conversions
extension Foundation.Data {
    public func string(encoding: String.Encoding = .utf8) throws -> String {
        guard let string = String(data: self, encoding: encoding) else {
            throw ResourceError.invalidEncoding
        }
        return string
    }
    
    public func json<T: Decodable>(as type: T.Type) throws -> T {
        return try JSONDecoder().decode(type, from: self)
    }
}