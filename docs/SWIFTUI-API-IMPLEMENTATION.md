# SwiftUI-Style API Implementation

This document provides comprehensive implementation details for Swiftlets' SwiftUI-inspired web development API. This modern API allows developers to build dynamic web applications using familiar Swift patterns and property wrappers.

## Overview

The SwiftUI-style API in Swiftlets brings the declarative, composable nature of SwiftUI to web development. Key features include:

- **Property Wrappers** for accessing request data (`@Query`, `@FormValue`, `@Cookie`, etc.)
- **Protocol-Oriented Design** with `SwiftletMain` for entry points
- **Type-Safe HTML Generation** using result builders
- **Task Local Storage** for context propagation
- **Declarative Response Building** with modifiers

## Core Components

### 1. SwiftletMain Protocol

The `SwiftletMain` protocol serves as the entry point for SwiftUI-style swiftlets:

```swift
@main
struct MyPage: SwiftletMain {
    var title = "My Page"
    var meta = ["description": "A sample page"]
    
    var body: some HTMLElement {
        Div {
            H1("Welcome to My Page")
            P("This is a SwiftUI-style swiftlet!")
        }
    }
}
```

**Protocol Definition:**
```swift
public protocol SwiftletMain: SwiftletComponent {
    static func main() async throws
}

public protocol SwiftletComponent: HTMLComponent, HTMLHeader {
    init()
}

public protocol HTMLComponent {
    associatedtype Body
    var body: Body { get }
}

public protocol HTMLHeader {
    var title: String { get }
    var meta: [String: String] { get }
}
```

### 2. Property Wrappers

#### @Query - URL Query Parameters

Access URL query parameters with automatic parsing:

```swift
@main
struct SearchPage: SwiftletMain {
    @Query("q") var searchQuery: String?
    @Query("page", default: "1") var pageNumber: String?
    
    var title = "Search Results"
    
    var body: some HTMLElement {
        Div {
            H1("Search Results")
            if let query = searchQuery {
                P("Searching for: \(query)")
                P("Page: \(pageNumber ?? "1")")
            } else {
                P("No search query provided")
            }
        }
    }
}
```

#### @FormValue - Form Data

Access form-encoded POST data:

```swift
@main
struct LoginPage: SwiftletMain {
    @FormValue("username") var username: String?
    @FormValue("password") var password: String?
    @FormValue("remember") var rememberMe: String?
    
    var title = "Login"
    
    var body: some HTMLElement {
        if let username = username, let password = password {
            // Process login
            Div {
                H1("Welcome, \(username)!")
                P("Login successful")
            }
        } else {
            // Show login form
            Form(action: "/login", method: "POST") {
                Label("Username:")
                Input(type: "text", name: "username", required: true)
                
                Label("Password:")
                Input(type: "password", name: "password", required: true)
                
                Label {
                    Input(type: "checkbox", name: "remember", value: "yes")
                    Text(" Remember me")
                }
                
                Button("Login", type: "submit")
            }
        }
    }
}
```

#### @JSONBody - JSON Request Body

Parse JSON POST data into Swift types:

```swift
struct UserData: Codable, Sendable {
    let name: String
    let email: String
    let age: Int
}

@main
struct APIEndpoint: SwiftletMain {
    @JSONBody<UserData>() var userData: UserData?
    
    var title = "API Endpoint"
    
    var body: ResponseBuilder {
        if let user = userData {
            return ResponseWith {
                Div {
                    H1("User Created")
                    P("Name: \(user.name)")
                    P("Email: \(user.email)")
                    P("Age: \(user.age)")
                }
            }
            .status(201)
            .header("X-User-ID", value: UUID().uuidString)
        } else {
            return ResponseWith {
                Div {
                    H1("Error")
                    P("Invalid user data")
                }
            }
            .status(400)
        }
    }
}
```

#### @Cookie - HTTP Cookies

Read and write cookies:

```swift
@main
struct PreferencesPage: SwiftletMain {
    @Cookie("theme") var currentTheme: String?
    @Cookie("language", default: "en") var language: String?
    
    var title = "Preferences"
    
    var body: some HTMLElement {
        Div {
            H1("Your Preferences")
            P("Theme: \(currentTheme ?? "default")")
            P("Language: \(language ?? "en")")
        }
    }
}
```

#### @Environment - Access Context

Access the SwiftletContext components:

```swift
@main
struct ResourceDemo: SwiftletMain {
    @Environment(.resources) var resources: Resources
    @Environment(.storage) var storage: Storage
    @Environment(.request) var request: Request
    @Environment(.routePath) var routePath: String
    
    var title = "Resource Demo"
    
    var body: some HTMLElement {
        Div {
            H1("Context Information")
            P("Route: \(routePath)")
            P("Method: \(request.method)")
            
            // Access resources
            if let configData = try? resources.read(named: "config.json"),
               let config = try? configData.json(as: Config.self) {
                P("Config loaded: \(config.appName)")
            }
        }
    }
}
```

### 3. Response Building

#### Basic HTML Response

For simple HTML pages, return HTML elements directly:

```swift
var body: some HTMLElement {
    Div {
        H1("Simple Page")
        P("This returns a standard 200 OK response")
    }
}
```

#### Advanced Response Control

Use `ResponseBuilder` for full control over the HTTP response:

```swift
var body: ResponseBuilder {
    ResponseWith {
        Div {
            H1("Advanced Response")
            P("With custom headers and status")
        }
    }
    .status(201)
    .header("X-Custom-Header", value: "custom-value")
    .contentType("text/html; charset=utf-8")
    .cookie("session", value: sessionId, maxAge: 3600, httpOnly: true)
}
```

#### Setting Cookies

```swift
var body: ResponseBuilder {
    ResponseWith {
        Div {
            H1("Cookie Set!")
            P("Your preferences have been saved")
        }
    }
    .cookie("theme", value: "dark", maxAge: 86400)
    .cookie("language", value: "en", expires: Date().addingTimeInterval(86400))
    .deleteCookie("old_session")
}
```

### 4. Task Local Storage

SwiftletContext is propagated using Swift's Task Local Storage:

```swift
// Access current context anywhere in your code
if let context = SwiftletContext.current {
    let request = context.request
    let resources = context.resources
    // Use context...
}

// Run code with a specific context
await SwiftletContext.run(with: myContext) {
    // Code here has access to myContext via SwiftletContext.current
}
```

## Complete Examples

### Example 1: Blog Post with Comments

```swift
import Swiftlets

struct Comment: Codable, Sendable {
    let author: String
    let content: String
    let timestamp: Date
}

@main
struct BlogPost: SwiftletMain {
    @Query("id") var postId: String?
    @FormValue("author") var commentAuthor: String?
    @FormValue("content") var commentContent: String?
    @Environment(.storage) var storage: Storage
    
    var title = "Blog Post"
    var meta = ["author": "John Doe", "keywords": "swift, web, development"]
    
    var body: some HTMLElement {
        VStack(spacing: 20) {
            // Blog post content
            Article {
                H1("Understanding SwiftUI-Style Web Development")
                P("Posted on January 8, 2025")
                
                P("""
                SwiftUI has revolutionized iOS development with its declarative syntax. 
                Now, Swiftlets brings the same power to web development...
                """)
            }
            
            // Comments section
            Section {
                H2("Comments")
                
                // Add new comment if form was submitted
                if let author = commentAuthor, let content = commentContent {
                    handleNewComment(author: author, content: content)
                }
                
                // Display existing comments
                if let comments = loadComments() {
                    ForEach(comments) { comment in
                        Div {
                            Strong(comment.author)
                            P(comment.content)
                            Small(formatDate(comment.timestamp))
                        }
                        .class("comment")
                    }
                } else {
                    P("No comments yet. Be the first!")
                }
                
                // Comment form
                Form(action: "/blog", method: "POST") {
                    Input(type: "hidden", name: "id", value: postId ?? "")
                    
                    Label("Your Name:")
                    Input(type: "text", name: "author", required: true)
                    
                    Label("Comment:")
                    TextArea(name: "content", rows: 4, required: true)
                    
                    Button("Post Comment", type: "submit")
                }
            }
        }
        .class("container")
    }
    
    func loadComments() -> [Comment]? {
        guard let postId = postId,
              let data = try? storage.read(from: "comments/\(postId).json"),
              let comments = try? data.json(as: [Comment].self) else {
            return nil
        }
        return comments
    }
    
    func handleNewComment(author: String, content: String) -> some HTMLElement {
        guard let postId = postId else {
            return P("Error: No post ID")
        }
        
        var comments = loadComments() ?? []
        let newComment = Comment(
            author: author,
            content: content,
            timestamp: Date()
        )
        comments.append(newComment)
        
        if let data = try? JSONEncoder().encode(comments) {
            try? storage.write(data, to: "comments/\(postId).json")
        }
        
        return P("Comment posted successfully!")
            .class("success")
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
```

### Example 2: File Upload with Progress

```swift
@main
struct FileUpload: SwiftletMain {
    @FormValue("file") var fileData: String?
    @Query("action") var action: String?
    @Environment(.storage) var storage: Storage
    
    var title = "File Upload"
    
    var body: ResponseBuilder {
        if action == "list" {
            return listFiles()
        } else if let data = fileData {
            return handleUpload(data)
        } else {
            return showUploadForm()
        }
    }
    
    func showUploadForm() -> ResponseBuilder {
        ResponseWith {
            VStack(spacing: 20) {
                H1("File Upload")
                
                Form(action: "/upload", method: "POST", enctype: "multipart/form-data") {
                    Label("Select file:")
                    Input(type: "file", name: "file", required: true)
                        .attribute("accept", "image/*,.pdf,.doc,.docx")
                    
                    Button("Upload", type: "submit")
                        .class("btn-primary")
                }
                
                Link(href: "/upload?action=list", "View uploaded files")
            }
        }
    }
    
    func handleUpload(_ data: String) -> ResponseBuilder {
        let filename = "upload_\(Date().timeIntervalSince1970)"
        
        if let fileData = Data(base64Encoded: data) {
            do {
                try storage.write(fileData, to: "uploads/\(filename)")
                
                return ResponseWith {
                    VStack {
                        H1("Upload Successful!")
                        P("File saved as: \(filename)")
                        Link(href: "/upload", "Upload another")
                    }
                }
                .status(201)
            } catch {
                return ResponseWith {
                    Div {
                        H1("Upload Failed")
                        P("Error: \(error.localizedDescription)")
                    }
                }
                .status(500)
            }
        }
        
        return ResponseWith {
            P("Invalid file data")
        }
        .status(400)
    }
    
    func listFiles() -> ResponseBuilder {
        do {
            let files = try storage.contentsOfDirectory(at: "uploads")
            
            return ResponseWith {
                VStack {
                    H1("Uploaded Files")
                    
                    if files.isEmpty {
                        P("No files uploaded yet")
                    } else {
                        UL {
                            ForEach(files.sorted()) { file in
                                LI(file)
                            }
                        }
                    }
                    
                    Link(href: "/upload", "Back to upload")
                }
            }
        } catch {
            return ResponseWith {
                P("Error listing files: \(error.localizedDescription)")
            }
            .status(500)
        }
    }
}
```

### Example 3: RESTful API Endpoint

```swift
struct Product: Codable, Sendable {
    let id: String
    let name: String
    let price: Double
    let inStock: Bool
}

@main
struct ProductAPI: SwiftletMain {
    @Environment(.request) var request: Request
    @Query("id") var productId: String?
    @JSONBody<Product>() var productData: Product?
    @Environment(.storage) var storage: Storage
    
    var title = "Product API"
    
    var body: ResponseBuilder {
        switch request.method {
        case "GET":
            return handleGet()
        case "POST":
            return handlePost()
        case "PUT":
            return handlePut()
        case "DELETE":
            return handleDelete()
        default:
            return ResponseWith {
                P("Method not allowed")
            }
            .status(405)
            .header("Allow", value: "GET, POST, PUT, DELETE")
        }
    }
    
    func handleGet() -> ResponseBuilder {
        if let id = productId {
            // Get single product
            if let data = try? storage.read(from: "products/\(id).json"),
               let product = try? data.json(as: Product.self) {
                return ResponseWith {
                    Pre(try! JSONEncoder().encode(product).string())
                }
                .contentType("application/json")
            } else {
                return ResponseWith { P("Product not found") }.status(404)
            }
        } else {
            // List all products
            do {
                let files = try storage.contentsOfDirectory(at: "products")
                var products: [Product] = []
                
                for file in files where file.hasSuffix(".json") {
                    if let data = try? storage.read(from: "products/\(file)"),
                       let product = try? data.json(as: Product.self) {
                        products.append(product)
                    }
                }
                
                let jsonData = try JSONEncoder().encode(products)
                return ResponseWith {
                    Pre(jsonData.string())
                }
                .contentType("application/json")
            } catch {
                return ResponseWith { P("[]") }.contentType("application/json")
            }
        }
    }
    
    func handlePost() -> ResponseBuilder {
        guard let product = productData else {
            return ResponseWith { P("Invalid product data") }.status(400)
        }
        
        do {
            let data = try JSONEncoder().encode(product)
            try storage.write(data, to: "products/\(product.id).json")
            
            return ResponseWith {
                Pre(data.string())
            }
            .status(201)
            .contentType("application/json")
            .header("Location", value: "/api/products?id=\(product.id)")
        } catch {
            return ResponseWith { P("Error creating product") }.status(500)
        }
    }
    
    func handlePut() -> ResponseBuilder {
        guard let id = productId,
              let product = productData else {
            return ResponseWith { P("Invalid request") }.status(400)
        }
        
        // Ensure ID matches
        guard product.id == id else {
            return ResponseWith { P("ID mismatch") }.status(400)
        }
        
        do {
            let data = try JSONEncoder().encode(product)
            try storage.write(data, to: "products/\(id).json")
            
            return ResponseWith {
                Pre(data.string())
            }
            .contentType("application/json")
        } catch {
            return ResponseWith { P("Error updating product") }.status(500)
        }
    }
    
    func handleDelete() -> ResponseBuilder {
        guard let id = productId else {
            return ResponseWith { P("Product ID required") }.status(400)
        }
        
        do {
            try storage.delete("products/\(id).json")
            return ResponseWith { P("") }.status(204)
        } catch {
            return ResponseWith { P("Product not found") }.status(404)
        }
    }
}
```

## Migration Guide

### From Traditional Swiftlet to SwiftUI-Style

**Before (Traditional):**
```swift
import Swiftlets

struct MyPage: Swiftlet {
    func handle(_ request: Request) -> Response {
        let html = Html {
            Head {
                Title("My Page")
            }
            Body {
                H1("Welcome")
                P("This is the old style")
            }
        }
        
        return Response(
            status: 200,
            headers: ["Content-Type": "text/html"],
            body: html.render()
        )
    }
}

// Main entry point
let request = // ... read from stdin
let page = MyPage()
let response = page.handle(request)
// ... output response
```

**After (SwiftUI-Style):**
```swift
import Swiftlets

@main
struct MyPage: SwiftletMain {
    var title = "My Page"
    
    var body: some HTMLElement {
        VStack {
            H1("Welcome")
            P("This is the new SwiftUI style!")
        }
    }
}
```

### Key Differences

1. **Automatic Request Handling**: No need to manually parse stdin or encode stdout
2. **Property Wrappers**: Direct access to request data without manual parsing
3. **Declarative Syntax**: Focus on what to render, not how
4. **Type Safety**: Compile-time checks for HTML structure
5. **Context Propagation**: Automatic access to resources and storage

## Troubleshooting

### Common Issues

#### 1. Property Wrapper Returns nil

**Problem**: `@Query`, `@FormValue`, etc. return nil even when data is present.

**Solution**: Ensure you're accessing the property within the `body` computed property where the context is available:

```swift
// ❌ Wrong - accessing outside body
@main
struct Page: SwiftletMain {
    @Query("name") var name: String?
    let greeting = "Hello, \(name ?? "World")"  // Will always be nil
    
    var body: some HTMLElement {
        P(greeting)
    }
}

// ✅ Correct - accessing inside body
@main
struct Page: SwiftletMain {
    @Query("name") var name: String?
    
    var body: some HTMLElement {
        P("Hello, \(name ?? "World")")  // Works correctly
    }
}
```

#### 2. Context Not Available

**Problem**: "Environment accessed outside of Swiftlet context" error.

**Solution**: Ensure you're running within the SwiftletMain framework:

```swift
// ✅ Correct - using @main
@main
struct MyPage: SwiftletMain {
    @Environment(.storage) var storage: Storage
    // ...
}

// ❌ Wrong - manual implementation missing context setup
struct MyPage {
    static func main() {
        // Missing context setup
        let storage = Storage()  // Won't work
    }
}
```

#### 3. JSON Body Not Parsing

**Problem**: `@JSONBody` returns nil even with valid JSON.

**Solution**: Check Content-Type header and ensure proper JSON encoding:

```swift
// Client must send:
// Content-Type: application/json
// Body: {"name": "John", "age": 30}

@main
struct API: SwiftletMain {
    @JSONBody<User>() var user: User?
    
    var body: some HTMLElement {
        if let user = user {
            P("Received user: \(user.name)")
        } else {
            P("No valid JSON body")
        }
    }
}
```

### Performance Tips

1. **Use Lazy Loading**: Don't load resources until needed
2. **Cache Computed Values**: Store expensive computations
3. **Minimize Storage Reads**: Batch operations when possible
4. **Use Appropriate Response Types**: Return JSON for APIs, HTML for pages

## Advanced Patterns

### Custom Property Wrappers

Create your own property wrappers for specific needs:

```swift
@propertyWrapper
public struct Header: Sendable {
    private let name: String
    
    public init(_ name: String) {
        self.name = name
    }
    
    public var wrappedValue: String? {
        SwiftletContext.current?.request.headers[name]
    }
}

// Usage
@main
struct APIPage: SwiftletMain {
    @Header("Authorization") var authToken: String?
    @Header("X-API-Key") var apiKey: String?
    
    var body: some HTMLElement {
        if let token = authToken {
            P("Authenticated request")
        } else {
            P("Please provide authorization")
        }
    }
}
```

### Middleware-like Behavior

Implement cross-cutting concerns using composition:

```swift
protocol AuthenticatedPage: SwiftletMain {
    var requiresAuth: Bool { get }
}

extension AuthenticatedPage {
    func authenticatedBody() -> ResponseBuilder {
        guard requiresAuth else {
            return ResponseWith { body }
        }
        
        @Cookie("session") var sessionId: String?
        
        if validateSession(sessionId) {
            return ResponseWith { body }
        } else {
            return ResponseWith {
                Div {
                    H1("Authentication Required")
                    Link(href: "/login", "Please log in")
                }
            }
            .status(401)
        }
    }
}
```

### Async Operations

While the current implementation is synchronous, you can still perform async-like operations:

```swift
@main
struct AsyncExample: SwiftletMain {
    @Environment(.storage) var storage: Storage
    
    var title = "Async Example"
    
    var body: some HTMLElement {
        VStack {
            H1("Data Dashboard")
            
            // Simulate loading multiple data sources
            let userData = loadUserData()
            let statsData = loadStatsData()
            
            if let users = userData, let stats = statsData {
                renderDashboard(users: users, stats: stats)
            } else {
                P("Loading data...")
            }
        }
    }
    
    func loadUserData() -> [User]? {
        // Load from storage or external source
        // In future versions, this could be async
    }
}
```

## Best Practices

1. **Keep Components Small**: Break large pages into smaller, reusable components
2. **Use Semantic HTML**: Leverage Swiftlets' full HTML element library
3. **Handle Errors Gracefully**: Always provide fallbacks for missing data
4. **Validate Input**: Check and sanitize user input before processing
5. **Use Type Safety**: Leverage Swift's type system for data models
6. **Document Your Code**: Add comments for complex logic
7. **Test Edge Cases**: Handle missing parameters, invalid data, etc.

## Future Enhancements

The SwiftUI-style API will continue to evolve with:

- **Async/Await Support**: True asynchronous request handling
- **State Management**: Session and application state
- **WebSocket Support**: Real-time bidirectional communication
- **Streaming Responses**: For large data transfers
- **Built-in Validation**: Declarative input validation
- **Component Libraries**: Pre-built UI components
- **Hot Reload**: Development mode with instant updates

## Conclusion

The SwiftUI-style API in Swiftlets brings the best of modern Swift development to web applications. By leveraging property wrappers, protocol-oriented design, and declarative syntax, developers can build robust web applications with less code and more safety.

For more information, see:
- [API Reference](./SWIFTUI-API-REFERENCE.md)
- [Architecture Guide](./swiftlet-architecture.md)
- [HTML DSL Documentation](./html-dsl-implementation-status.md)