# SwiftUI-Style API Parameter Passing in Swiftlets

This document explains how GET and POST parameters are passed to swiftlet code using the new SwiftUI-style property wrapper API design.

## Overview

Swiftlets uses property wrappers to provide a declarative, SwiftUI-like interface for accessing HTTP request data. The framework automatically injects values from the HTTP request into these property wrappers before executing your swiftlet code.

## Data Flow Architecture

```
HTTP Request → Web Server → Swiftlet Process → Property Wrapper Injection → Your Code
```

### Detailed Flow:

1. **HTTP Request Arrives**: Client sends GET/POST request to server
2. **Server Routes Request**: Server finds matching swiftlet executable
3. **Server Spawns Process**: Creates process with environment variables
4. **Framework Initialization**: Swiftlet framework reads environment
5. **Property Wrapper Injection**: Framework injects values into property wrappers
6. **Code Execution**: Your swiftlet code runs with populated values

## Property Wrappers

### @Query - GET Parameters

Handles URL query parameters from GET requests.

```swift
@propertyWrapper
public struct Query<Value: Decodable> {
    private let key: String
    private let defaultValue: Value?
    private var value: Value?
    
    public init(_ key: String, default defaultValue: Value? = nil) {
        self.key = key
        self.defaultValue = defaultValue
        
        // Read from environment
        if let context = ProcessInfo.processInfo.environment["SWIFTLET_CONTEXT"],
           let data = context.data(using: .utf8),
           let ctx = try? JSONDecoder().decode(SwiftletContext.self, from: data) {
            // Extract query parameter
            if let stringValue = ctx.queryParameters[key] {
                // Convert string to expected type
                self.value = Self.convert(stringValue, to: Value.self)
            }
        }
        
        // Fall back to default if no value found
        if value == nil {
            value = defaultValue
        }
    }
    
    public var wrappedValue: Value {
        get {
            guard let value = value else {
                fatalError("Query parameter '\(key)' is required but not provided")
            }
            return value
        }
    }
    
    // Type conversion logic
    private static func convert<T>(_ string: String, to type: T.Type) -> T? {
        // Handle different types: String, Int, Bool, etc.
        // Implementation details...
    }
}
```

### @FormValue - POST Form Data

Handles form-encoded POST data (application/x-www-form-urlencoded).

```swift
@propertyWrapper
public struct FormValue<Value: Decodable> {
    private let key: String
    private let defaultValue: Value?
    private var value: Value?
    
    public init(_ key: String, default defaultValue: Value? = nil) {
        self.key = key
        self.defaultValue = defaultValue
        
        // Read from environment
        if let context = ProcessInfo.processInfo.environment["SWIFTLET_CONTEXT"],
           let data = context.data(using: .utf8),
           let ctx = try? JSONDecoder().decode(SwiftletContext.self, from: data) {
            // Extract form value
            if ctx.contentType?.contains("application/x-www-form-urlencoded") == true,
               let formData = ctx.formData,
               let stringValue = formData[key] {
                self.value = Self.convert(stringValue, to: Value.self)
            }
        }
        
        // Fall back to default if no value found
        if value == nil {
            value = defaultValue
        }
    }
    
    public var wrappedValue: Value {
        get {
            guard let value = value else {
                fatalError("Form value '\(key)' is required but not provided")
            }
            return value
        }
    }
}
```

### @Body - JSON POST Bodies

Handles JSON-encoded POST bodies (application/json).

```swift
@propertyWrapper
public struct Body<Value: Decodable> {
    private var value: Value?
    
    public init() {
        // Read from environment
        if let context = ProcessInfo.processInfo.environment["SWIFTLET_CONTEXT"],
           let data = context.data(using: .utf8),
           let ctx = try? JSONDecoder().decode(SwiftletContext.self, from: data) {
            // Parse JSON body
            if ctx.contentType?.contains("application/json") == true,
               let bodyData = ctx.body?.data(using: .utf8) {
                self.value = try? JSONDecoder().decode(Value.self, from: bodyData)
            }
        }
    }
    
    public var wrappedValue: Value {
        get {
            guard let value = value else {
                fatalError("JSON body is required but not provided or invalid")
            }
            return value
        }
    }
}
```

## Context Passing Mechanism

The server passes request data to swiftlets via the `SWIFTLET_CONTEXT` environment variable:

```swift
// SwiftletContext structure
struct SwiftletContext: Codable {
    let method: String
    let path: String
    let queryParameters: [String: String]
    let headers: [String: String]
    let contentType: String?
    let body: String?
    let formData: [String: String]?
}

// Server creates context
let context = SwiftletContext(
    method: request.method,
    path: request.path,
    queryParameters: request.queryParameters,
    headers: request.headers,
    contentType: request.headers["Content-Type"],
    body: request.body,
    formData: parseFormData(request.body, contentType: request.headers["Content-Type"])
)

// Server passes via environment
var environment = ProcessInfo.processInfo.environment
environment["SWIFTLET_CONTEXT"] = try JSONEncoder().encode(context).base64EncodedString()

// Spawn swiftlet process with environment
let process = Process()
process.environment = environment
process.launchPath = swiftletPath
```

## Practical Usage Examples

### Example 1: Search with GET Parameters

```swift
import Swiftlets

@main
struct SearchSwiftlet: Swiftlet {
    @Query("q") var query: String
    @Query("page", default: 1) var page: Int
    @Query("limit", default: 20) var limit: Int
    
    var body: some HTML {
        Html {
            Head {
                Title("Search Results")
            }
            Body {
                H1("Search Results for: \(query)")
                P("Page \(page) of results (showing \(limit) items)")
                
                // Search results...
            }
        }
    }
}
```

URL: `/search?q=swift&page=2&limit=50`

### Example 2: Login Form with POST

```swift
import Swiftlets

@main
struct LoginSwiftlet: Swiftlet {
    @FormValue("username") var username: String
    @FormValue("password") var password: String
    @FormValue("remember", default: false) var rememberMe: Bool
    
    var body: some HTML {
        Html {
            Head {
                Title("Login")
            }
            Body {
                if authenticate(username: username, password: password) {
                    H1("Welcome, \(username)!")
                    if rememberMe {
                        P("We'll remember you next time.")
                    }
                } else {
                    H1("Login Failed")
                    P("Invalid username or password")
                }
            }
        }
    }
    
    func authenticate(username: String, password: String) -> Bool {
        // Authentication logic...
        return true
    }
}
```

### Example 3: API Endpoint with JSON

```swift
import Swiftlets

struct CreateUserRequest: Codable {
    let name: String
    let email: String
    let age: Int
}

@main
struct APISwiftlet: Swiftlet {
    @Body var request: CreateUserRequest
    
    var response: Response {
        // Validate request
        guard request.age >= 18 else {
            return Response(
                status: 400,
                json: ["error": "User must be 18 or older"]
            )
        }
        
        // Create user...
        let userId = createUser(request)
        
        return Response(
            status: 201,
            json: [
                "id": userId,
                "name": request.name,
                "email": request.email
            ]
        )
    }
    
    func createUser(_ user: CreateUserRequest) -> String {
        // Database logic...
        return UUID().uuidString
    }
}
```

### Example 4: Mixed Parameters

```swift
import Swiftlets

@main
struct ComplexSwiftlet: Swiftlet {
    // GET parameters
    @Query("filter", default: "all") var filter: String
    @Query("sort", default: "date") var sortBy: String
    
    // POST form data
    @FormValue("action") var action: String?
    @FormValue("ids") var selectedIds: String?
    
    var body: some HTML {
        Html {
            Body {
                H1("Complex Example")
                
                if let action = action {
                    P("Performing action: \(action)")
                    if let ids = selectedIds {
                        P("On items: \(ids)")
                    }
                }
                
                P("Current filter: \(filter)")
                P("Sort by: \(sortBy)")
            }
        }
    }
}
```

## Error Handling

### Optional vs Required Parameters

```swift
// Required parameter - will crash if not provided
@Query("id") var userId: String

// Optional with default - safe if not provided
@Query("page", default: 1) var page: Int

// Truly optional - can check for nil
@Query("search") var searchTerm: String?
```

### Type Conversion Errors

The framework handles common type conversions:

```swift
// String to Int
@Query("count") var count: Int  // "123" → 123

// String to Bool
@Query("active") var isActive: Bool  // "true" → true, "1" → true

// String to Double
@Query("price") var price: Double  // "19.99" → 19.99

// String to Date (ISO8601)
@Query("date") var date: Date  // "2024-01-15" → Date object
```

### Validation

```swift
@main
struct ValidatedSwiftlet: Swiftlet {
    @Query("age") var age: Int?
    
    var body: some HTML {
        Html {
            Body {
                if let age = age, age >= 0 && age <= 120 {
                    P("Valid age: \(age)")
                } else {
                    P("Invalid age provided")
                        .foregroundColor(.red)
                }
            }
        }
    }
}
```

## Advanced Features

### Custom Types

You can use any `Decodable` type:

```swift
enum SortOrder: String, Decodable {
    case ascending = "asc"
    case descending = "desc"
}

@main
struct SortableSwiftlet: Swiftlet {
    @Query("order", default: .ascending) var sortOrder: SortOrder
    
    var body: some HTML {
        Text("Sorting: \(sortOrder.rawValue)")
    }
}
```

### Array Parameters

For repeated query parameters:

```swift
// URL: /items?id=1&id=2&id=3
@Query("id") var ids: [String]  // ["1", "2", "3"]
```

### Nested JSON Objects

```swift
struct Address: Codable {
    let street: String
    let city: String
    let zip: String
}

struct UserProfile: Codable {
    let name: String
    let email: String
    let address: Address
}

@main
struct ProfileSwiftlet: Swiftlet {
    @Body var profile: UserProfile
    
    var body: some HTML {
        VStack {
            H2(profile.name)
            P(profile.email)
            Div {
                P(profile.address.street)
                P("\(profile.address.city), \(profile.address.zip)")
            }
        }
    }
}
```

## Implementation Notes

1. **Initialization Order**: Property wrappers are initialized before the swiftlet's `init` method
2. **Thread Safety**: Each swiftlet process is isolated, no threading concerns
3. **Memory Efficiency**: Values are parsed once during initialization
4. **Type Safety**: Compile-time type checking for all parameters
5. **Performance**: Minimal overhead, parsing happens once at startup

## Future Enhancements

- **@Cookie**: Access HTTP cookies
- **@Header**: Access specific HTTP headers
- **@Session**: Server-side session management
- **@File**: Handle file uploads
- **@PathParam**: Extract values from URL paths (e.g., `/user/{id}`)
- **Custom Validators**: Declarative validation rules
- **Async Support**: Async property wrapper initialization

## Conclusion

The SwiftUI-style property wrapper API makes handling HTTP parameters intuitive and type-safe. By leveraging Swift's property wrapper feature, Swiftlets provides a declarative way to access request data that feels natural to Swift developers while maintaining the simplicity and isolation of the CGI-like architecture.