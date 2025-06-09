import Foundation

public struct Request: Codable, Sendable {
    public let method: String
    public let url: String
    public let headers: [String: String]
    public let body: String?  // Base64 encoded body
    
    // Legacy properties for backward compatibility
    public var path: String { url }
    public var queryParameters: [String: String] {
        guard let components = URLComponents(string: url),
              let queryItems = components.queryItems else { return [:] }
        return queryItems.reduce(into: [:]) { result, item in
            result[item.name] = item.value ?? ""
        }
    }
    
    public init(method: String, url: String, headers: [String: String] = [:], body: String? = nil) {
        self.method = method
        self.url = url
        self.headers = headers
        self.body = body
    }
    
    // Legacy init for backward compatibility
    public init(method: String, path: String, headers: [String: String] = [:], queryParameters: [String: String] = [:], body: Foundation.Data? = nil, context: SwiftletContextData? = nil) {
        var components = URLComponents()
        components.path = path
        if !queryParameters.isEmpty {
            components.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        self.method = method
        self.url = components.string ?? path
        self.headers = headers
        self.body = body?.base64EncodedString()
    }
}

/// Context data passed from server to swiftlet
public struct SwiftletContextData: Codable, Sendable {
    public let routePath: String           // e.g., "/blog/tutorial"
    public let resourcePaths: [String]     // Ordered paths for resource lookup
    public let storagePath: String         // e.g., "var/blog/tutorial/"
    
    public init(routePath: String, resourcePaths: [String], storagePath: String) {
        self.routePath = routePath
        self.resourcePaths = resourcePaths
        self.storagePath = storagePath
    }
}