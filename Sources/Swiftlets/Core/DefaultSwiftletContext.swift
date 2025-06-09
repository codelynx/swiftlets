import Foundation

/// Default implementation of SwiftletContext
public struct DefaultSwiftletContext: SwiftletContext {
    public let request: Request
    public let resources: Resources
    public let storage: Storage
    public let routePath: String
    
    public init(request: Request) {
        self.request = request
        self.routePath = request.url
        self.resources = Resources(resourcePaths: [])
        self.storage = Storage()
    }
    
    public init(from contextData: SwiftletContextData) {
        self.request = Request(
            method: "GET",
            url: contextData.routePath,
            headers: [:],
            body: nil
        )
        self.routePath = contextData.routePath
        self.resources = Resources(resourcePaths: contextData.resourcePaths)
        self.storage = Storage()
    }
}