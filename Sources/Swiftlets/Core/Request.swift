import Foundation

public struct Request: Codable {
    public let method: String
    public let path: String
    public let headers: [String: String]
    public let queryParameters: [String: String]
    public let body: Foundation.Data?
    public let context: SwiftletContextData?
    
    public init(method: String, path: String, headers: [String: String] = [:], queryParameters: [String: String] = [:], body: Foundation.Data? = nil, context: SwiftletContextData? = nil) {
        self.method = method
        self.path = path
        self.headers = headers
        self.queryParameters = queryParameters
        self.body = body
        self.context = context
    }
}

/// Context data passed from server to swiftlet
public struct SwiftletContextData: Codable {
    public let routePath: String           // e.g., "/blog/tutorial"
    public let resourcePaths: [String]     // Ordered paths for resource lookup
    public let storagePath: String         // e.g., "var/blog/tutorial/"
    
    public init(routePath: String, resourcePaths: [String], storagePath: String) {
        self.routePath = routePath
        self.resourcePaths = resourcePaths
        self.storagePath = storagePath
    }
}