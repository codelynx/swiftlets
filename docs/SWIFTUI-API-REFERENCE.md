# SwiftUI-Style API Reference

Complete API reference for Swiftlets' SwiftUI-inspired web development framework.

## Table of Contents

- [Protocols](#protocols)
- [Property Wrappers](#property-wrappers)
- [Response Building](#response-building)
- [Context Access](#context-access)
- [Type Aliases](#type-aliases)
- [Error Types](#error-types)

## Protocols

### SwiftletMain

The main entry point for SwiftUI-style swiftlets.

```swift
public protocol SwiftletMain: SwiftletComponent {
    static func main() async throws
}
```

**Requirements:**
- Must be marked with `@main`
- Must implement `body` property
- Must implement `title` property
- Optionally implement `meta` property

**Example:**
```swift
@main
struct MyPage: SwiftletMain {
    var title = "My Page"
    var meta = ["description": "Page description"]
    
    var body: some HTMLElement {
        Div { H1("Hello") }
    }
}
```

### SwiftletComponent

Base protocol for swiftlet components.

```swift
public protocol SwiftletComponent: HTMLComponent, HTMLHeader {
    init()
}
```

### HTMLComponent

Protocol for components that generate HTML content.

```swift
public protocol HTMLComponent {
    associatedtype Body
    var body: Body { get }
}
```

### HTMLHeader

Protocol for defining HTML page metadata.

```swift
public protocol HTMLHeader {
    var title: String { get }
    var meta: [String: String] { get }
}
```

**Default Implementation:**
```swift
public extension HTMLHeader {
    var meta: [String: String] { [:] }
}
```

### SwiftletBody

Protocol for types that can be returned as body content.

```swift
public protocol SwiftletBody {
    func buildResponse(with metadata: any HTMLHeader) -> Response
}
```

**Conforming Types:**
- `HTMLElement`
- `ResponseBuilder`

## Property Wrappers

### @Query

Access URL query parameters.

```swift
@propertyWrapper
public struct Query: Sendable {
    public init(_ key: String, default defaultValue: String? = nil)
    public var wrappedValue: String? { get }
}
```

**Parameters:**
- `key`: The query parameter name
- `defaultValue`: Optional default value if parameter is missing

**Example:**
```swift
@Query("page", default: "1") var pageNumber: String?
@Query("search") var searchTerm: String?

// URL: /products?search=swift&page=2
// searchTerm = "swift"
// pageNumber = "2"
```

### @FormValue

Access form-encoded POST data.

```swift
@propertyWrapper
public struct FormValue: Sendable {
    public init(_ key: String, default defaultValue: String? = nil)
    public var wrappedValue: String? { get }
}
```

**Requirements:**
- Request method must be POST
- Content-Type must be `application/x-www-form-urlencoded`

**Example:**
```swift
@FormValue("username") var username: String?
@FormValue("remember", default: "no") var remember: String?
```

### @JSONBody

Parse JSON request body into Swift types.

```swift
@propertyWrapper
public struct JSONBody<T: Decodable & Sendable>: Sendable {
    public init(default defaultValue: T? = nil)
    public var wrappedValue: T? { get }
}
```

**Type Requirements:**
- `T` must conform to `Decodable`
- `T` must conform to `Sendable`

**Example:**
```swift
struct UserData: Codable, Sendable {
    let name: String
    let email: String
}

@JSONBody<UserData>() var userData: UserData?
@JSONBody<[String: Any]>(default: [:]) var jsonData: [String: Any]?
```

### @Cookie

Access HTTP cookies.

```swift
@propertyWrapper
public struct Cookie: Sendable {
    public init(_ key: String, default defaultValue: String? = nil)
    public var wrappedValue: String? { get }
}
```

**Example:**
```swift
@Cookie("session") var sessionId: String?
@Cookie("theme", default: "light") var theme: String?
```

### @Environment

Access SwiftletContext components.

```swift
@propertyWrapper
public struct Environment: Sendable {
    public enum Key: String, Sendable {
        case request
        case resources
        case storage
        case routePath
    }
    
    public init(_ key: Key)
    public var wrappedValue: Any { get }
}
```

**Available Keys:**
- `.request`: Returns `Request`
- `.resources`: Returns `Resources`
- `.storage`: Returns `Storage`
- `.routePath`: Returns `String`

**Example:**
```swift
@Environment(.request) var request: Request
@Environment(.storage) var storage: Storage
@Environment(.resources) var resources: Resources
@Environment(.routePath) var routePath: String
```

## Response Building

### ResponseBuilder

Build HTTP responses with custom headers and status codes.

```swift
public struct ResponseBuilder {
    public init(@HTMLBuilder content: @escaping () -> some HTMLElement)
    public init(html: String)
    
    // Status
    public func status(_ code: Int) -> ResponseBuilder
    
    // Headers
    public func header(_ name: String, value: String) -> ResponseBuilder
    public func contentType(_ type: String) -> ResponseBuilder
    
    // Cookies
    public func cookie(
        _ name: String,
        value: String,
        expires: Date? = nil,
        maxAge: Int? = nil,
        domain: String? = nil,
        path: String = "/",
        secure: Bool = false,
        httpOnly: Bool = false,
        sameSite: SameSite? = nil
    ) -> ResponseBuilder
    
    public func deleteCookie(_ name: String, path: String = "/", domain: String? = nil) -> ResponseBuilder
}
```

### ResponseWith

Convenience function for creating ResponseBuilder.

```swift
public func ResponseWith(
    @HTMLBuilder content: @escaping () -> some HTMLElement
) -> ResponseBuilder
```

**Example:**
```swift
var body: ResponseBuilder {
    ResponseWith {
        Div { H1("Success!") }
    }
    .status(201)
    .header("X-Custom", value: "value")
    .cookie("auth", value: token, httpOnly: true)
}
```

### SameSite

Cookie SameSite attribute values.

```swift
public enum SameSite: String {
    case strict = "Strict"
    case lax = "Lax"
    case none = "None"
}
```

## Context Access

### SwiftletContext

Protocol for accessing request context.

```swift
public protocol SwiftletContext: Sendable {
    var request: Request { get }
    var resources: Resources { get }
    var storage: Storage { get }
    var routePath: String { get }
}
```

### SwiftletContext Static Methods

```swift
public extension SwiftletContext {
    // Get current context from Task Local Storage
    static var current: SwiftletContext? { get }
    
    // Run closure with specific context
    static func run<T>(
        with context: SwiftletContext,
        operation: () async throws -> T
    ) async rethrows -> T
}
```

### Resources

Read-only resource access with hierarchical lookup.

```swift
public struct Resources: Sendable {
    // Read resource data
    public func read(named name: String) throws -> Foundation.Data
}
```

**Data Extensions:**
```swift
extension Foundation.Data {
    // Convert to String
    public func string(encoding: String.Encoding = .utf8) throws -> String
    
    // Decode JSON
    public func json<T: Decodable>(as type: T.Type) throws -> T
}
```

### Storage

Writable storage access.

```swift
public struct Storage: Sendable {
    // File operations
    public func write(_ data: Foundation.Data, to path: String) throws
    public func read(from path: String) throws -> Foundation.Data
    public func delete(_ path: String) throws
    public func exists(_ path: String) -> Bool
    
    // Directory operations
    public func contentsOfDirectory(at path: String = ".") throws -> [String]
    public func createDirectory(at path: String) throws
    public func removeDirectory(at path: String) throws
}
```

## Type Aliases

### Common Return Types

```swift
// For simple HTML responses
var body: some HTMLElement { ... }

// For advanced HTTP responses
var body: ResponseBuilder { ... }

// For any HTML element
var body: AnyHTMLElement { ... }
```

## Error Types

### ResourceError

Errors that can occur when accessing resources.

```swift
public enum ResourceError: Error, LocalizedError {
    case notFound(String)
    case invalidEncoding
    
    public var errorDescription: String? { get }
}
```

## Usage Patterns

### Basic Page

```swift
@main
struct HomePage: SwiftletMain {
    var title = "Home"
    
    var body: some HTMLElement {
        Div {
            H1("Welcome")
            P("This is a basic page")
        }
    }
}
```

### Page with Query Parameters

```swift
@main
struct SearchPage: SwiftletMain {
    @Query("q") var query: String?
    @Query("page", default: "1") var page: String?
    
    var title = "Search"
    
    var body: some HTMLElement {
        Div {
            if let q = query {
                H1("Results for: \(q)")
                P("Page \(page ?? "1")")
            } else {
                H1("Enter a search term")
            }
        }
    }
}
```

### Form Handling

```swift
@main
struct ContactForm: SwiftletMain {
    @FormValue("name") var name: String?
    @FormValue("email") var email: String?
    @FormValue("message") var message: String?
    
    var title = "Contact"
    
    var body: ResponseBuilder {
        if let name = name, let email = email, let message = message {
            // Process form submission
            return ResponseWith {
                Div {
                    H1("Thank you, \(name)!")
                    P("We'll respond to \(email) soon.")
                }
            }
            .status(201)
        } else {
            // Show form
            return ResponseWith {
                Form(action: "/contact", method: "POST") {
                    Input(type: "text", name: "name", placeholder: "Name")
                    Input(type: "email", name: "email", placeholder: "Email")
                    TextArea(name: "message", placeholder: "Message")
                    Button("Send", type: "submit")
                }
            }
        }
    }
}
```

### JSON API Endpoint

```swift
struct APIResponse: Codable, Sendable {
    let status: String
    let data: [String: Any]
}

@main
struct APIEndpoint: SwiftletMain {
    @JSONBody<[String: Any]>() var requestData: [String: Any]?
    @Environment(.request) var request: Request
    
    var title = "API"
    
    var body: ResponseBuilder {
        guard request.method == "POST" else {
            return ResponseWith {
                P("Method not allowed")
            }
            .status(405)
            .contentType("application/json")
        }
        
        if let data = requestData {
            let response = APIResponse(status: "success", data: data)
            let json = try! JSONEncoder().encode(response)
            
            return ResponseWith {
                Pre(json.string())
            }
            .contentType("application/json")
        } else {
            return ResponseWith {
                P("{\"status\": \"error\", \"message\": \"Invalid JSON\"}")
            }
            .status(400)
            .contentType("application/json")
        }
    }
}
```

### Cookie Management

```swift
@main
struct Dashboard: SwiftletMain {
    @Cookie("user_id") var userId: String?
    @Cookie("theme") var theme: String?
    @FormValue("logout") var logout: String?
    
    var title = "Dashboard"
    
    var body: ResponseBuilder {
        if logout == "true" {
            return ResponseWith {
                Div {
                    H1("Logged out")
                    P("You have been logged out successfully")
                }
            }
            .deleteCookie("user_id")
            .deleteCookie("session")
        }
        
        guard let userId = userId else {
            return ResponseWith {
                Div {
                    H1("Please log in")
                    Link(href: "/login", "Go to login")
                }
            }
            .status(401)
        }
        
        return ResponseWith {
            Div {
                H1("Welcome, User \(userId)")
                P("Theme: \(theme ?? "default")")
                
                Form(action: "/dashboard", method: "POST") {
                    Input(type: "hidden", name: "logout", value: "true")
                    Button("Logout", type: "submit")
                }
            }
        }
    }
}
```

### Resource Access

```swift
struct Config: Codable, Sendable {
    let siteName: String
    let features: [String]
}

@main
struct ConfiguredPage: SwiftletMain {
    @Environment(.resources) var resources: Resources
    
    var title = "Configured Page"
    
    var body: some HTMLElement {
        do {
            let configData = try resources.read(named: "config.json")
            let config = try configData.json(as: Config.self)
            
            return VStack {
                H1(config.siteName)
                H2("Features:")
                UL {
                    ForEach(config.features) { feature in
                        LI(feature)
                    }
                }
            }
        } catch {
            return Div {
                H1("Default Site")
                P("Could not load configuration: \(error.localizedDescription)")
            }
        }
    }
}
```

### Storage Operations

```swift
@main
struct FileManager: SwiftletMain {
    @Environment(.storage) var storage: Storage
    @Query("action") var action: String?
    @FormValue("filename") var filename: String?
    @FormValue("content") var content: String?
    
    var title = "File Manager"
    
    var body: some HTMLElement {
        VStack {
            H1("File Manager")
            
            switch action {
            case "create":
                createFile()
            case "list":
                listFiles()
            case "delete":
                deleteFile()
            default:
                showMenu()
            }
        }
    }
    
    func createFile() -> some HTMLElement {
        if let name = filename, let data = content?.data(using: .utf8) {
            do {
                try storage.write(data, to: name)
                return P("File created: \(name)")
            } catch {
                return P("Error: \(error.localizedDescription)")
            }
        }
        return fileForm()
    }
    
    func listFiles() -> some HTMLElement {
        do {
            let files = try storage.contentsOfDirectory()
            return VStack {
                H2("Files:")
                UL {
                    ForEach(files) { file in
                        LI(file)
                    }
                }
            }
        } catch {
            return P("Error listing files")
        }
    }
    
    func deleteFile() -> some HTMLElement {
        if let name = filename {
            do {
                try storage.delete(name)
                return P("Deleted: \(name)")
            } catch {
                return P("Error: \(error.localizedDescription)")
            }
        }
        return P("No filename specified")
    }
    
    func showMenu() -> some HTMLElement {
        VStack {
            Link(href: "?action=create", "Create File")
            Link(href: "?action=list", "List Files")
            Link(href: "?action=delete", "Delete File")
        }
    }
    
    func fileForm() -> some HTMLElement {
        Form(method: "POST") {
            Input(type: "hidden", name: "action", value: action ?? "")
            Label("Filename:")
            Input(type: "text", name: "filename")
            Label("Content:")
            TextArea(name: "content")
            Button("Submit", type: "submit")
        }
    }
}
```