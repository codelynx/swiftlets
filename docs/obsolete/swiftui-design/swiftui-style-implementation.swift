// SwiftUI-Style Swiftlets Implementation
// This shows how the framework handles ALL the boilerplate

import Foundation
import Swiftlets

// MARK: - What the Framework Provides

public protocol Swiftlet {
    associatedtype Body: HTML
    
    init()
    
    @HTMLBuilder
    var body: Body { get }
}

// The magic happens here - developers NEVER see this!
extension Swiftlet {
    public static func main() async throws {
        // ========================================
        // ALL THIS BOILERPLATE IS HIDDEN!
        // ========================================
        
        // 1. Parse request from stdin (developer doesn't care how)
        let requestData = FileHandle.standardInput.readDataToEndOfFile()
        let request = try JSONDecoder().decode(Request.self, from: requestData)
        
        // 2. Set up context (automatic)
        let context = DefaultSwiftletContext(from: request.context!)
        
        // 3. Create environment (invisible to developer)
        let environment = SwiftletEnvironment(
            request: request,
            context: context,
            storage: context.storage,
            resources: context.resources
        )
        
        // 4. Run with task-local environment
        await SwiftletEnvironmentKey.$current.withValue(environment) {
            // 5. Create swiftlet instance
            let swiftlet = Self()
            
            // 6. Get the body (this is ALL the developer writes!)
            let html = swiftlet.body
            
            // 7. Create response (automatic)
            let response = Response(
                status: 200,
                headers: ["Content-Type": "text/html; charset=utf-8"],
                body: html.render()
            )
            
            // 8. Encode and output (developer never sees this)
            let encoded = try JSONEncoder().encode(response).base64EncodedString()
            print(encoded)
        }
    }
}

// MARK: - Property Wrappers (Clean API)

@propertyWrapper
public struct Environment<Value> {
    private let keyPath: KeyPath<SwiftletEnvironment, Value>
    
    public var wrappedValue: Value {
        guard let env = SwiftletEnvironmentKey.current else {
            fatalError("@Environment used outside of Swiftlet context")
        }
        return env[keyPath: keyPath]
    }
    
    public init(_ keyPath: KeyPath<SwiftletEnvironment, Value>) {
        self.keyPath = keyPath
    }
}

@propertyWrapper
public struct Query {
    private let key: String
    private let defaultValue: String?
    
    public var wrappedValue: String? {
        guard let env = SwiftletEnvironmentKey.current else {
            return defaultValue
        }
        return env.request.query?[key] ?? defaultValue
    }
    
    public init(_ key: String, default: String? = nil) {
        self.key = key
        self.defaultValue = `default`
    }
}

@propertyWrapper
public struct Header {
    private let key: String
    
    public var wrappedValue: String? {
        guard let env = SwiftletEnvironmentKey.current else {
            return nil
        }
        return env.request.headers[key]
    }
    
    public init(_ key: String) {
        self.key = key
    }
}

// MARK: - What Developers Write (ONLY THIS!)

@main
struct GreetingPage: Swiftlet {
    // Simple property wrappers - no boilerplate!
    @Query("name") var userName: String?
    @Query("age") var userAge: String?
    @Header("Accept-Language") var language: String?
    
    // Just focus on your content!
    var body: some HTML {
        Html {
            Head {
                Title("Greeting")
            }
            Body {
                Container {
                    greeting()
                    
                    if let age = userAge {
                        P("You are \(age) years old!")
                    }
                    
                    if let lang = language {
                        P("Your language: \(lang)")
                            .style("color", "#6c757d")
                    }
                }
            }
        }
    }
    
    @HTMLBuilder
    private func greeting() -> some HTML {
        if let name = userName {
            H1("Hello, \(name)!")
        } else {
            H1("Hello, Stranger!")
        }
    }
}

// MARK: - Advanced Example (Still No Boilerplate!)

@main
struct BlogPost: Swiftlet {
    @Environment(\.request) var request
    @Environment(\.context) var context
    @Environment(\.resources) var resources
    
    // Computed properties for business logic
    var postId: String? {
        request.path.components.last
    }
    
    var post: BlogPost? {
        guard let id = postId else { return nil }
        
        // Even file I/O is simplified!
        if let data = try? resources.read(named: "posts/\(id).json") {
            return try? data.json(as: BlogPost.self)
        }
        return nil
    }
    
    // Still just focusing on content!
    var body: some HTML {
        Html {
            Head {
                Title(post?.title ?? "Not Found")
            }
            Body {
                if let post = post {
                    Article {
                        H1(post.title)
                        Time(post.date.formatted())
                        Div(post.content)
                    }
                } else {
                    notFound()
                }
            }
        }
    }
    
    @HTMLBuilder
    private func notFound() -> some HTML {
        Container {
            H1("404 - Post Not Found")
            Link(href: "/blog", "← Back to Blog")
        }
    }
}

// MARK: - The Developer Experience

/*
 * NO JSON decoding
 * NO Response creation
 * NO Base64 encoding
 * NO Print statements
 * NO Error handling for protocol stuff
 * 
 * JUST your content and business logic!
 * 
 * Compare the BlogPost above to the current style:
 * - Current: 40+ lines with all the boilerplate
 * - SwiftUI-style: ~30 lines of JUST your logic
 * 
 * And it's:
 * - Type-safe
 * - Testable
 * - Familiar to SwiftUI developers
 * - Focused on what matters
 */