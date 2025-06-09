import Foundation

// MARK: - Query Parameter Access

/// Property wrapper for accessing URL query parameters
@propertyWrapper
public struct Query: Sendable {
    private let key: String
    private let defaultValue: String?
    
    public init(_ key: String, default defaultValue: String? = nil) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public var wrappedValue: String? {
        get {
            guard let context = SwiftletContextKey.current,
                  let queryItems = URLComponents(string: context.request.url)?.queryItems else {
                return defaultValue
            }
            return queryItems.first(where: { $0.name == key })?.value ?? defaultValue
        }
    }
}

// MARK: - Form Value Access

/// Property wrapper for accessing form-encoded POST parameters
@propertyWrapper
public struct FormValue: Sendable {
    private let key: String
    private let defaultValue: String?
    
    public init(_ key: String, default defaultValue: String? = nil) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public var wrappedValue: String? {
        get {
            guard let context = SwiftletContextKey.current,
                  context.request.method == "POST",
                  context.request.headers["Content-Type"]?.contains("application/x-www-form-urlencoded") ?? false,
                  let bodyData = Foundation.Data(base64Encoded: context.request.body ?? ""),
                  let bodyString = String(data: bodyData, encoding: .utf8) else {
                return defaultValue
            }
            
            let formData = bodyString.split(separator: "&").reduce(into: [String: String]()) { result, pair in
                let parts = pair.split(separator: "=", maxSplits: 1).map(String.init)
                if parts.count == 2 {
                    result[parts[0].removingPercentEncoding ?? parts[0]] = 
                        parts[1].removingPercentEncoding ?? parts[1]
                }
            }
            
            return formData[key] ?? defaultValue
        }
    }
}

// MARK: - JSON Body Access

/// Property wrapper for accessing JSON POST body
@propertyWrapper
public struct JSONBody<T: Decodable & Sendable>: Sendable {
    private let defaultValue: T?
    
    public init(default defaultValue: T? = nil) {
        self.defaultValue = defaultValue
    }
    
    public var wrappedValue: T? {
        get {
            guard let context = SwiftletContextKey.current,
                  context.request.method == "POST",
                  context.request.headers["Content-Type"]?.contains("application/json") ?? false,
                  let bodyData = Foundation.Data(base64Encoded: context.request.body ?? "") else {
                return defaultValue
            }
            
            return try? JSONDecoder().decode(T.self, from: bodyData)
        }
    }
}

// MARK: - Cookie Access

/// Property wrapper for accessing HTTP cookies
@propertyWrapper
public struct Cookie: Sendable {
    private let key: String
    private let defaultValue: String?
    
    public init(_ key: String, default defaultValue: String? = nil) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public var wrappedValue: String? {
        get {
            guard let context = SwiftletContextKey.current,
                  let cookieHeader = context.request.headers["Cookie"] else {
                return defaultValue
            }
            
            let cookies = cookieHeader.split(separator: ";").reduce(into: [String: String]()) { result, cookie in
                let trimmed = cookie.trimmingCharacters(in: CharacterSet.whitespaces)
                let parts = trimmed.split(separator: "=", maxSplits: 1).map(String.init)
                if parts.count == 2 {
                    result[parts[0]] = parts[1]
                }
            }
            
            return cookies[key] ?? defaultValue
        }
    }
}

// MARK: - Environment Access

/// Property wrapper for accessing environment values
@propertyWrapper
public struct Environment: Sendable {
    public enum Key: String, Sendable {
        case request
        case resources
        case storage
        case routePath
    }
    
    private let key: Key
    
    public init(_ key: Key) {
        self.key = key
    }
    
    public var wrappedValue: Any {
        get {
            guard let context = SwiftletContextKey.current else {
                fatalError("Environment accessed outside of Swiftlet context")
            }
            
            switch key {
            case .request:
                return context.request
            case .resources:
                return context.resources
            case .storage:
                return context.storage
            case .routePath:
                return context.routePath
            }
        }
    }
}