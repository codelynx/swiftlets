# Swiftlets SwiftUI-Style API - Complete Review

## Executive Summary

This document provides a comprehensive review of the SwiftUI-style API design for Swiftlets, consolidating decisions from multiple design documents and proposing a unified, coherent API that maintains consistency while addressing all requirements.

## Core Design Principles

1. **Zero Boilerplate**: Developers write only their content logic, no plumbing
2. **Type Safety**: Leverage Swift's type system for compile-time guarantees
3. **Familiarity**: Mirror SwiftUI patterns and conventions
4. **Composability**: Build complex UIs from simple, reusable components
5. **Testability**: Easy to test components in isolation

## Unified API Design

### Core Protocol Hierarchy

```swift
// Base component protocol (like SwiftUI View)
protocol HTMLComponent {
    associatedtype Body: HTMLElement
    @HTMLBuilder var body: Body { get }
}

// HTML header protocol for metadata
protocol HTMLHeader {
    var title: String { get }
    var meta: [String: String] { get }
}

// Full page combines header + component
protocol Swiftlet: HTMLComponent, HTMLHeader {
    init()
}

// Response wrapper for HTTP control
protocol HTTPResponder {
    associatedtype Content: HTML
    var response: Response<Content> { get }
}
```

### Property Wrappers

```swift
// Query parameters (GET)
@Query("id") var productId: String?
@Query("page", default: 1) var page: Int

// Form data (POST)
@FormValue("email") var email: String?
@FormValue("password") var password: String?

// JSON body (POST/PUT)
@Body var userData: UserData

// Cookies (read)
@Cookie("sessionId") var sessionId: String?
@Cookie("theme", default: .light) var theme: Theme

// Environment access
@Environment(\.request) var request
@Environment(\.context) var context
@Environment(\.storage) var storage
@Environment(\.resources) var resources
```

### Response Builder Pattern

```swift
struct Response<Content: HTML>: HTML {
    let content: Content
    var status: HTTPStatus = .ok
    var headers: [String: String] = [:]
    var cookies: [HTTPCookie] = []
    
    // Builder methods
    func status(_ status: HTTPStatus) -> Response
    func header(_ name: String, value: String) -> Response
    func cookie(_ name: String, value: String, options: CookieOptions = .init()) -> Response
}
```

## Complete Examples

### Example 1: Simple Page with GET Parameters

```swift
import Swiftlets

@main
struct ProductPage: Swiftlet {
    @Query("id") var productId: String
    @Query("variant") var variant: String?
    @Cookie("recently_viewed") var recentlyViewed: [String] = []
    
    // Metadata
    var title: String {
        "Product \(productId)"
    }
    
    var meta: [String: String] {
        [
            "description": "View details for product \(productId)",
            "og:title": title,
            "og:type": "product"
        ]
    }
    
    // Content
    var body: some HTMLElement {
        Container {
            NavigationBar()
            
            Main {
                ProductDetails(id: productId, variant: variant)
                RecentlyViewedProducts(ids: recentlyViewed)
            }
            
            Footer()
        }
    }
}
```

### Example 2: Form Handling with Cookies

```swift
import Swiftlets

@main
struct LoginPage: Swiftlet, HTTPResponder {
    @Environment(\.request) var request
    @FormValue("email") var email: String?
    @FormValue("password") var password: String?
    @FormValue("remember") var remember: Bool = false
    @Cookie("auth_token") var existingToken: String?
    
    var title = "Login"
    var meta = ["description": "Sign in to your account"]
    
    var response: Response<some HTML> {
        Response {
            Html {
                Head {
                    Title(title)
                    metaTags
                }
                Body {
                    content
                }
            }
        }
        .cookie("auth_token", value: authToken, options: cookieOptions)
        .status(responseStatus)
    }
    
    @HTMLBuilder
    private var content: some HTMLElement {
        Container {
            if request.method == .post {
                handleLogin()
            } else {
                showLoginForm()
            }
        }
    }
    
    @HTMLBuilder
    private func handleLogin() -> some HTMLElement {
        if let email = email, let password = password,
           authenticate(email: email, password: password) {
            // Success
            Card {
                H2("Welcome back!")
                P("Redirecting to dashboard...")
            }
            .onAppear {
                // Set redirect header in response
            }
        } else {
            // Failure
            Alert(style: .danger) {
                Text("Invalid email or password")
            }
            showLoginForm()
        }
    }
    
    @HTMLBuilder
    private func showLoginForm() -> some HTMLElement {
        Form(action: "/login", method: .post) {
            FormGroup {
                Label("Email")
                Input(type: .email, name: "email")
                    .required()
                    .placeholder("you@example.com")
            }
            
            FormGroup {
                Label("Password")
                Input(type: .password, name: "password")
                    .required()
            }
            
            FormCheck {
                Input(type: .checkbox, name: "remember")
                Label("Remember me")
            }
            
            Button(type: .submit) {
                Text("Sign In")
            }
            .style(.primary)
        }
    }
    
    // Computed properties for response building
    private var authToken: String? {
        guard request.method == .post,
              let email = email, let password = password,
              authenticate(email: email, password: password) else {
            return nil
        }
        return generateToken(for: email)
    }
    
    private var cookieOptions: CookieOptions {
        CookieOptions(
            maxAge: remember ? 30 * 24 * 60 * 60 : nil, // 30 days if remember
            httpOnly: true,
            secure: true,
            sameSite: .strict
        )
    }
    
    private var responseStatus: HTTPStatus {
        if request.method == .post && authToken != nil {
            return .found // 302 redirect
        }
        return .ok
    }
}
```

### Example 3: API Endpoint with JSON

```swift
import Swiftlets

struct CreateUserRequest: Codable {
    let name: String
    let email: String
    let role: UserRole
}

struct UserResponse: Codable {
    let id: String
    let name: String
    let email: String
    let role: UserRole
    let createdAt: Date
}

@main
struct UserAPI: Swiftlet, HTTPResponder {
    @Environment(\.request) var request
    @Body var createRequest: Result<CreateUserRequest, Error>
    @Cookie("api_key") var apiKey: String?
    
    var title = "User API"
    var meta = ["robots": "noindex"]
    
    var response: Response<some HTML> {
        // Validate API key
        guard let apiKey = apiKey, validateAPIKey(apiKey) else {
            return Response {
                EmptyHTML()
            }
            .status(.unauthorized)
            .header("Content-Type", value: "application/json")
            .header("WWW-Authenticate", value: "Bearer")
        }
        
        // Handle request
        switch request.method {
        case .post:
            return handleCreateUser()
        case .get:
            return handleListUsers()
        default:
            return Response {
                EmptyHTML()
            }
            .status(.methodNotAllowed)
            .header("Allow", value: "GET, POST")
        }
    }
    
    private func handleCreateUser() -> Response<some HTML> {
        guard case .success(let userData) = createRequest else {
            return errorResponse(.badRequest, message: "Invalid request body")
        }
        
        // Validate
        guard isValidEmail(userData.email) else {
            return errorResponse(.badRequest, message: "Invalid email format")
        }
        
        // Create user
        let user = UserResponse(
            id: UUID().uuidString,
            name: userData.name,
            email: userData.email,
            role: userData.role,
            createdAt: Date()
        )
        
        return Response {
            EmptyHTML()
        }
        .status(.created)
        .header("Content-Type", value: "application/json")
        .header("Location", value: "/api/users/\(user.id)")
        .body(try! JSONEncoder().encode(user))
    }
}
```

### Example 4: Reusable Components

```swift
// Navigation component
struct NavigationBar: HTMLComponent {
    @Environment(\.request) var request
    @Cookie("user_id") var userId: String?
    
    var body: some HTMLElement {
        Nav {
            Container {
                HStack {
                    Link(href: "/") {
                        Image(src: "/logo.png", alt: "Logo")
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 20) {
                        NavLink(href: "/", label: "Home", current: request.path)
                        NavLink(href: "/products", label: "Products", current: request.path)
                        NavLink(href: "/about", label: "About", current: request.path)
                        
                        if userId != nil {
                            Link(href: "/account") {
                                Text("Account")
                            }
                        } else {
                            Link(href: "/login") {
                                Text("Login")
                            }
                        }
                    }
                }
            }
        }
        .class("navbar")
    }
}

// Reusable nav link
struct NavLink: HTMLComponent {
    let href: String
    let label: String
    let current: String
    
    var body: some HTMLElement {
        Link(href: href) {
            Text(label)
        }
        .class(current == href ? "active" : "")
    }
}

// Card component
struct Card<Content: HTMLElement>: HTMLComponent {
    let content: Content
    var style: CardStyle = .default
    
    init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some HTMLElement {
        Div {
            content
        }
        .class("card", style.className)
    }
}
```

## API Consistency Analysis

### Strengths

1. **Unified Pattern**: All features follow SwiftUI conventions
2. **Type Safety**: Strong typing throughout with proper generics
3. **Composability**: Components compose naturally
4. **Progressive Disclosure**: Simple cases are simple, complex cases are possible

### Identified Gaps

1. **Session Management**: No built-in session support yet
2. **File Uploads**: @File property wrapper not implemented
3. **WebSocket Support**: Real-time features need design
4. **Middleware**: No middleware/plugin system
5. **Async Handlers**: Limited async/await support

### Proposed Solutions

#### Session Management

```swift
@Session("user") var user: User?
@Session var sessionId: String = UUID().uuidString

// Implementation would use cookies + server-side storage
```

#### File Uploads

```swift
@FileUpload("avatar") var avatar: UploadedFile?

struct UploadedFile {
    let filename: String
    let contentType: String
    let size: Int
    let tempPath: URL
}
```

#### Async Support

```swift
protocol AsyncSwiftlet: Swiftlet {
    func render() async throws -> Response<some HTML>
}
```

## Implementation Priorities

### Phase 1: Core Foundation (Current)
- [x] Basic Swiftlet protocol
- [x] HTML DSL with result builders
- [x] @Query property wrapper
- [x] @FormValue property wrapper
- [x] Basic routing

### Phase 2: Enhanced Features (Next)
- [ ] @Cookie property wrapper (read)
- [ ] Response wrapper with cookie/header support
- [ ] @Body property wrapper for JSON
- [ ] @Environment system
- [ ] Error handling improvements

### Phase 3: Advanced Features
- [ ] @Session management
- [ ] @FileUpload support
- [ ] Async/await support
- [ ] WebSocket integration
- [ ] Middleware system

### Phase 4: Ecosystem
- [ ] Testing utilities
- [ ] Documentation generator
- [ ] Performance optimizations
- [ ] Developer tools
- [ ] Template library

## Migration Guide

### From Current API

```swift
// Before
static func main() {
    let request = parseRequest()
    let html = generateHTML(request)
    let response = Response(html: html)
    print(response.toJSON())
}

// After
@main
struct MyPage: Swiftlet {
    @Query("id") var id: String?
    
    var title = "My Page"
    var body: some HTMLElement {
        Text("ID: \(id ?? "none")")
    }
}
```

### Adding Response Control

```swift
// When you need headers/cookies
struct MyPage: Swiftlet, HTTPResponder {
    var response: Response<some HTML> {
        Response {
            // Your HTML
        }
        .cookie("visited", value: "true")
        .header("X-Custom", value: "example")
    }
}
```

## Best Practices

1. **Keep Components Small**: Break complex pages into reusable components
2. **Use Property Wrappers**: Let the framework handle data extraction
3. **Leverage Type Safety**: Use custom types instead of strings
4. **Test Components**: Write unit tests for your components
5. **Handle Errors Gracefully**: Always provide fallbacks

## Conclusion

The SwiftUI-style API for Swiftlets provides a coherent, type-safe, and familiar development experience. By maintaining consistency with SwiftUI patterns while addressing web-specific needs, we create an API that is both powerful and approachable.

The phased implementation approach ensures we can deliver value incrementally while maintaining a clear vision for the complete system. The unified design eliminates inconsistencies and provides a solid foundation for future enhancements.