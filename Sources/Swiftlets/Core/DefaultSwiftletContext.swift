import Foundation

/// Default implementation of SwiftletContext
public struct DefaultSwiftletContext: SwiftletContext {
    public let resources: Resources
    public let storage: Storage
    public let routePath: String
    
    public init(from contextData: SwiftletContextData) {
        self.routePath = contextData.routePath
        self.resources = Resources(resourcePaths: contextData.resourcePaths)
        self.storage = Storage()
    }
}