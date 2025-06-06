import Foundation

public struct Request: Codable {
    public let method: String
    public let path: String
    public let headers: [String: String]
    public let queryParameters: [String: String]
    public let body: Data?
    
    public init(method: String, path: String, headers: [String: String] = [:], queryParameters: [String: String] = [:], body: Data? = nil) {
        self.method = method
        self.path = path
        self.headers = headers
        self.queryParameters = queryParameters
        self.body = body
    }
}