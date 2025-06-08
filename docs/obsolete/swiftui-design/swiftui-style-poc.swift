// SwiftUI-Style Swiftlet Proof of Concept
// This file demonstrates how the new API would look and work

import Foundation
import Swiftlets

// MARK: - Protocol Definition

public protocol Swiftlet {
    associatedtype Body: HTML
    
    init()
    
    @HTMLBuilder
    var body: Body { get }
}

// MARK: - Property Wrappers

@propertyWrapper
public struct RequestValue {
    private static var current: Request?
    
    public init() {}
    
    public var wrappedValue: Request {
        guard let request = Self.current else {
            fatalError("@Request can only be used within a Swiftlet")
        }
        return request
    }
    
    static func setCurrent(_ request: Request) {
        current = request
    }
}

@propertyWrapper
public struct ContextValue {
    private static var current: SwiftletContext?
    
    public init() {}
    
    public var wrappedValue: SwiftletContext {
        guard let context = Self.current else {
            fatalError("@Context can only be used within a Swiftlet")
        }
        return context
    }
    
    static func setCurrent(_ context: SwiftletContext) {
        current = context
    }
}

@propertyWrapper
public struct Query {
    let key: String
    
    public init(_ key: String) {
        self.key = key
    }
    
    public var wrappedValue: String? {
        RequestValue.current?.query?[key]
    }
}

// MARK: - Protocol Extension with main()

extension Swiftlet {
    public static func main() async throws {
        // Parse request
        let requestData = FileHandle.standardInput.readDataToEndOfFile()
        let request = try JSONDecoder().decode(Request.self, from: requestData)
        
        // Set up context
        let context = DefaultSwiftletContext(from: request.context!)
        
        // Configure property wrappers
        RequestValue.setCurrent(request)
        ContextValue.setCurrent(context)
        
        // Create instance and render
        let instance = Self()
        let html = instance.body
        
        // Create response
        let response = Response(
            status: 200,
            headers: ["Content-Type": "text/html; charset=utf-8"],
            body: html.render()
        )
        
        // Send response
        print(try JSONEncoder().encode(response).base64EncodedString())
    }
}

// MARK: - Example Usage

@main
struct HomePage: Swiftlet {
    @RequestValue var request
    @Query("name") var userName: String?
    @Query("page") var pageNumber: String?
    
    var body: some HTML {
        Html {
            Head {
                Title("SwiftUI-Style Swiftlet")
                Meta(name: "viewport", content: "width=device-width, initial-scale=1.0")
            }
            Body {
                header()
                
                Container {
                    VStack(spacing: 20) {
                        welcomeSection()
                        
                        if let page = pageNumber {
                            P("You're on page \(page)")
                        }
                        
                        featuresSection()
                    }
                }
                .style("padding", "2rem 0")
                
                footer()
            }
        }
    }
    
    @HTMLBuilder
    private func header() -> some HTML {
        Nav {
            Container {
                HStack {
                    H1("Swiftlets").style("margin", "0")
                    Spacer()
                    HStack(spacing: 20) {
                        Link(href: "/", "Home")
                        Link(href: "/docs", "Docs")
                        Link(href: "/examples", "Examples")
                    }
                }
                .style("align-items", "center")
            }
        }
        .style("background", "#f8f9fa")
        .style("padding", "1rem 0")
    }
    
    @HTMLBuilder
    private func welcomeSection() -> some HTML {
        VStack(spacing: 10) {
            if let name = userName {
                H1("Welcome, \(name)!")
            } else {
                H1("Welcome to SwiftUI-Style Swiftlets!")
            }
            
            P("This is a demonstration of the new declarative API.")
                .style("font-size", "1.25rem")
        }
    }
    
    @HTMLBuilder
    private func featuresSection() -> some HTML {
        Section {
            H2("Features")
            
            UL {
                LI("Declarative syntax like SwiftUI")
                LI("Property wrappers for dependencies")
                LI("Instance methods instead of static")
                LI("Better testability and reusability")
            }
        }
    }
    
    @HTMLBuilder
    private func footer() -> some HTML {
        Footer {
            Container {
                P("© 2025 Swiftlets - SwiftUI-Style")
            }
        }
        .style("padding", "2rem 0")
        .style("border-top", "1px solid #dee2e6")
        .style("margin-top", "3rem")
    }
}

// MARK: - More Complex Example

struct BlogPost: Swiftlet {
    @RequestValue var request
    @ContextValue var context
    @Query("id") var postId: String?
    
    struct Post {
        let id: String
        let title: String
        let content: String
        let date: Date
    }
    
    var body: some HTML {
        Html {
            Head {
                Title(pageTitle)
            }
            Body {
                if let post = loadPost() {
                    postView(post)
                } else {
                    notFoundView()
                }
            }
        }
    }
    
    private var pageTitle: String {
        if let post = loadPost() {
            return "\(post.title) - My Blog"
        }
        return "Post Not Found"
    }
    
    private func loadPost() -> Post? {
        guard let id = postId else { return nil }
        
        // In real implementation, would load from context.storage
        // For demo, return mock data
        if id == "1" {
            return Post(
                id: "1",
                title: "Introduction to Swiftlets",
                content: "Swiftlets is a new way to build web applications...",
                date: Date()
            )
        }
        
        return nil
    }
    
    @HTMLBuilder
    private func postView(_ post: Post) -> some HTML {
        Article {
            H1(post.title)
            Time(post.date.formatted())
                .style("color", "#6c757d")
            Div {
                Text(post.content)
            }
            .style("margin-top", "2rem")
        }
        .style("max-width", "800px")
        .style("margin", "0 auto")
        .style("padding", "2rem")
    }
    
    @HTMLBuilder
    private func notFoundView() -> some HTML {
        Container {
            VStack(spacing: 20) {
                H1("404 - Post Not Found")
                P("The blog post you're looking for doesn't exist.")
                Link(href: "/blog", "← Back to Blog")
                    .class("button")
            }
            .style("text-align", "center")
            .style("padding", "4rem 0")
        }
    }
}