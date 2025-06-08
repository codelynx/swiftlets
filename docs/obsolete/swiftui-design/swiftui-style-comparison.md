# SwiftUI-Style vs Current Style Comparison

## The Core Philosophy

**Current Style**: Developers manage the entire request/response lifecycle
**SwiftUI Style**: Developers focus only on their content

## Side-by-Side Examples

### Simple Page

#### Current Style (Static)
```swift
@main
struct HomePage {
    static func main() async throws {
        let request = try JSONDecoder().decode(Request.self, from: FileHandle.standardInput.readDataToEndOfFile())
        
        let html = Html {
            Head { Title("Home") }
            Body {
                H1("Welcome to Swiftlets")
                P("Build web apps with Swift")
            }
        }
        
        let response = Response(
            status: 200,
            headers: ["Content-Type": "text/html; charset=utf-8"],
            body: html.render()
        )
        
        print(try JSONEncoder().encode(response).base64EncodedString())
    }
}
```

#### SwiftUI Style (Instance)
```swift
@main
struct HomePage: Swiftlet {
    var body: some HTML {
        Html {
            Head { Title("Home") }
            Body {
                H1("Welcome to Swiftlets")
                P("Build web apps with Swift")
            }
        }
    }
}
```

### With Query Parameters

#### Current Style
```swift
@main
struct GreetingPage {
    static func main() async throws {
        let request = try JSONDecoder().decode(Request.self, from: FileHandle.standardInput.readDataToEndOfFile())
        
        let name = request.query?["name"] ?? "Guest"
        
        let html = Html {
            Head { Title("Greeting") }
            Body {
                H1("Hello, \(name)!")
            }
        }
        
        let response = Response(
            status: 200,
            headers: ["Content-Type": "text/html; charset=utf-8"],
            body: html.render()
        )
        
        print(try JSONEncoder().encode(response).base64EncodedString())
    }
}
```

#### SwiftUI Style
```swift
@main
struct GreetingPage: Swiftlet {
    @Query("name") var name: String?
    
    var body: some HTML {
        Html {
            Head { Title("Greeting") }
            Body {
                H1("Hello, \(name ?? "Guest")!")
            }
        }
    }
}
```

### Handling POST Requests

#### Current Style
```swift
@main
struct CreateUser {
    static func main() async throws {
        let request = try JSONDecoder().decode(Request.self, from: FileHandle.standardInput.readDataToEndOfFile())
        
        let html: Html
        
        if request.method == "POST" {
            // Parse form data manually
            if let bodyData = request.body {
                let formData = String(data: bodyData, encoding: .utf8) ?? ""
                let params = formData.split(separator: "&").reduce(into: [String: String]()) { dict, pair in
                    let parts = pair.split(separator: "=", maxSplits: 1)
                    if parts.count == 2 {
                        dict[String(parts[0])] = String(parts[1]).removingPercentEncoding
                    }
                }
                
                let name = params["name"] ?? ""
                let email = params["email"] ?? ""
                
                html = Html {
                    Head { Title("Success") }
                    Body {
                        H1("User created: \(name)")
                        P("Email: \(email)")
                    }
                }
            } else {
                html = Html {
                    Head { Title("Error") }
                    Body { H1("No data received") }
                }
            }
        } else {
            // Show form
            html = Html {
                Head { Title("Create User") }
                Body {
                    Form(action: "/user", method: "post") {
                        Input(type: "text", name: "name")
                        Input(type: "email", name: "email")
                        Button(type: "submit", "Create")
                    }
                }
            }
        }
        
        let response = Response(
            status: 200,
            headers: ["Content-Type": "text/html; charset=utf-8"],
            body: html.render()
        )
        
        print(try JSONEncoder().encode(response).base64EncodedString())
    }
}
```

#### SwiftUI Style
```swift
@main
struct CreateUser: Swiftlet {
    @Environment(\.request) var request
    @FormValue("name") var name: String?
    @FormValue("email") var email: String?
    
    var body: some HTML {
        Html {
            Head { Title(request.method == .post ? "Success" : "Create User") }
            Body {
                if request.method == .post {
                    H1("User created: \(name ?? "Unknown")")
                    P("Email: \(email ?? "Unknown")")
                } else {
                    Form(action: "/user", method: "post") {
                        Input(type: "text", name: "name")
                        Input(type: "email", name: "email")
                        Button(type: "submit", "Create")
                    }
                }
            }
        }
    }
}
```

### With Resources and Storage

#### Current Style
```swift
@main
struct ConfigPage {
    static func main() async throws {
        let request = try JSONDecoder().decode(Request.self, from: FileHandle.standardInput.readDataToEndOfFile())
        let context = DefaultSwiftletContext(from: request.context!)
        
        let configData = try context.resources.read(named: "config.json")
        let config = try configData.json(as: Config.self)
        
        let html = Html {
            Head { Title(config.siteName) }
            Body {
                H1(config.siteName)
                P(config.description)
            }
        }
        
        let response = Response(
            status: 200,
            headers: ["Content-Type": "text/html; charset=utf-8"],
            body: html.render()
        )
        
        print(try JSONEncoder().encode(response).base64EncodedString())
    }
}
```

#### SwiftUI Style
```swift
@main
struct ConfigPage: Swiftlet {
    @Context var context
    
    var config: Config {
        let data = try! context.resources.read(named: "config.json")
        return try! data.json(as: Config.self)
    }
    
    var body: some HTML {
        Html {
            Head { Title(config.siteName) }
            Body {
                H1(config.siteName)
                P(config.description)
            }
        }
    }
}
```

### Complex Page with Functions

#### Current Style
```swift
@main
struct DashboardPage {
    static func main() async throws {
        let request = try JSONDecoder().decode(Request.self, from: FileHandle.standardInput.readDataToEndOfFile())
        
        let html = Html {
            Head { 
                Title("Dashboard")
                LinkElement(rel: "stylesheet", href: "/styles/dashboard.css")
            }
            Body {
                navigation()
                
                Container {
                    Grid(columns: .count(3), spacing: 20) {
                        statsCard(title: "Users", value: "1,234")
                        statsCard(title: "Revenue", value: "$12,345")
                        statsCard(title: "Orders", value: "567")
                    }
                }
                
                footer()
            }
        }
        
        let response = Response(
            status: 200,
            headers: ["Content-Type": "text/html; charset=utf-8"],
            body: html.render()
        )
        
        print(try JSONEncoder().encode(response).base64EncodedString())
    }
    
    @HTMLBuilder
    static func navigation() -> some HTML {
        Nav {
            // Navigation content
        }
    }
    
    @HTMLBuilder
    static func statsCard(title: String, value: String) -> some HTML {
        Div {
            H3(title)
            P(value).style("font-size", "2rem")
        }
        .class("stats-card")
    }
    
    @HTMLBuilder
    static func footer() -> some HTML {
        Footer {
            P("© 2025 Dashboard")
        }
    }
}
```

#### SwiftUI Style
```swift
@main
struct DashboardPage: Swiftlet {
    var body: some HTML {
        Html {
            Head { 
                Title("Dashboard")
                LinkElement(rel: "stylesheet", href: "/styles/dashboard.css")
            }
            Body {
                navigation()
                
                Container {
                    Grid(columns: .count(3), spacing: 20) {
                        statsCard(title: "Users", value: "1,234")
                        statsCard(title: "Revenue", value: "$12,345")
                        statsCard(title: "Orders", value: "567")
                    }
                }
                
                footer()
            }
        }
    }
    
    @HTMLBuilder
    func navigation() -> some HTML {
        Nav {
            // Navigation content
        }
    }
    
    @HTMLBuilder
    func statsCard(title: String, value: String) -> some HTML {
        Div {
            H3(title)
            P(value).style("font-size", "2rem")
        }
        .class("stats-card")
    }
    
    @HTMLBuilder
    func footer() -> some HTML {
        Footer {
            P("© 2025 Dashboard")
        }
    }
}
```

## Key Differences

### 1. Entry Point
- **Current**: `static func main() async throws`
- **SwiftUI-Style**: `var body: some HTML` with protocol conformance

### 2. Boilerplate
- **Current**: Must handle request parsing, response creation, and output
- **SwiftUI-Style**: Framework handles all boilerplate

### 3. Dependencies
- **Current**: Manual parsing and passing of request/context
- **SwiftUI-Style**: Property wrappers provide automatic injection

### 4. Functions
- **Current**: Static functions with `@HTMLBuilder`
- **SwiftUI-Style**: Instance methods with `@HTMLBuilder`

### 5. Testing
- **Current**: Hard to test static functions
- **SwiftUI-Style**: Easy to test instance methods and properties

## Migration Checklist

When migrating from current to SwiftUI-style:

1. [ ] Change struct to conform to `Swiftlet` protocol
2. [ ] Remove `@main` from struct, add to protocol conformance
3. [ ] Convert `static func main()` to `var body: some HTML`
4. [ ] Move HTML generation to body
5. [ ] Replace request parsing with `@Request` property wrapper
6. [ ] Replace context creation with `@Context` property wrapper
7. [ ] Convert static functions to instance methods
8. [ ] Remove response creation and output code
9. [ ] Add property wrappers for commonly accessed values

## What You DON'T Write in SwiftUI Style

```swift
// ❌ You DON'T write this anymore:
let request = try JSONDecoder().decode(Request.self, from: FileHandle.standardInput.readDataToEndOfFile())
let context = DefaultSwiftletContext(from: request.context!)

// ❌ You DON'T write this:
let response = Response(
    status: 200,
    headers: ["Content-Type": "text/html; charset=utf-8"],
    body: html.render()
)

// ❌ You DON'T write this:
print(try JSONEncoder().encode(response).base64EncodedString())

// ✅ You just write:
@Environment(\.request) var request
@Query("name") var name: String?

var body: some HTML {
    H1("Hello, \(name ?? "World")!")
}
```

## Benefits Summary

| Aspect | Current Style | SwiftUI Style |
|--------|--------------|---------------|
| Lines of Code | ~20-30 for simple page | ~10-15 for simple page |
| Boilerplate | High | Zero |
| Focus | Protocol details | Your content |
| Testability | Difficult | Easy |
| Familiarity | Custom pattern | SwiftUI pattern |
| Type Safety | Manual | Property wrappers |
| Error Handling | Explicit | Automatic |
| Reusability | Limited | High |