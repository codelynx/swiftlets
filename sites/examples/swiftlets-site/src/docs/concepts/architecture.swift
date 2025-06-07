import Foundation
import Swiftlets

@main
struct ArchitecturePage {
    static func main() async throws {
        // Swiftlets passes request data via stdin
        _ = try JSONDecoder().decode(Request.self, from: FileHandle.standardInput.readDataToEndOfFile())
        
        let html = Html {
            Head {
                Title("Architecture - Swiftlets")
                Meta(name: "viewport", content: "width=device-width, initial-scale=1.0")
                LinkElement(rel: "stylesheet", href: "/styles/main.css")
            }
            Body {
                // Navigation
                Nav {
                    Container(maxWidth: .xl) {
                        HStack {
                            Link(href: "/") {
                                H1("Swiftlets").style("margin", "0")
                            }
                            Spacer()
                            HStack(spacing: 20) {
                                Link(href: "/docs", "Documentation").class("active")
                                Link(href: "/showcase", "Showcase")
                                Link(href: "/about", "About")
                                Link(href: "https://github.com/codelynx/swiftlets", "GitHub")
                                    .attribute("target", "_blank")
                            }
                        }
                        .style("align-items", "center")
                    }
                }
                .style("background", "#f8f9fa")
                .style("padding", "1rem 0")
                .style("border-bottom", "1px solid #dee2e6")
                
                // Content
                Container(maxWidth: .large) {
                    VStack(spacing: 40) {
                        // Breadcrumb
                        HStack(spacing: 10) {
                            Link(href: "/docs", "Docs")
                            Text("→")
                            Link(href: "/docs/concepts", "Core Concepts")
                            Text("→")
                            Text("Architecture")
                        }
                        .style("color", "#6c757d")
                        
                        H1("How Swiftlets Works")
                        
                        P("Swiftlets takes a unique approach to web development: each route in your application is a standalone Swift executable. This might sound unusual at first, but it provides remarkable benefits.")
                            .style("font-size", "1.25rem")
                            .style("line-height", "1.8")
                        
                        // Core Concept
                        Section {
                            H2("🎯 The Core Idea")
                            
                            Div {
                                P("Traditional web frameworks load your entire application into memory. Swiftlets works differently:")
                                    .style("margin-bottom", "1rem")
                                
                                Grid(columns: .count(3), spacing: 30) {
                                    Div {
                                        Text("1️⃣").style("font-size", "2rem").style("display", "block").style("margin-bottom", "0.5rem")
                                        H4("Request Arrives")
                                        P("Server receives HTTP request for /about")
                                            .style("color", "#6c757d")
                                    }
                                    .style("text-align", "center")
                                    
                                    Div {
                                        Text("2️⃣").style("font-size", "2rem").style("display", "block").style("margin-bottom", "0.5rem")
                                        H4("Find Executable")
                                        P("Server looks for bin/about executable")
                                            .style("color", "#6c757d")
                                    }
                                    .style("text-align", "center")
                                    
                                    Div {
                                        Text("3️⃣").style("font-size", "2rem").style("display", "block").style("margin-bottom", "0.5rem")
                                        H4("Execute & Respond")
                                        P("Runs executable, returns HTML response")
                                            .style("color", "#6c757d")
                                    }
                                    .style("text-align", "center")
                                }
                            }
                            .style("background", "#f8f9fa")
                            .style("padding", "2rem")
                            .style("border-radius", "8px")
                            .style("margin", "2rem 0")
                        }
                        
                        // Visual Diagram
                        Section {
                            H2("📊 Request Flow")
                            
                            Pre {
                                Code("""
                                Browser Request: GET /products/list
                                           ↓
                                    Swiftlets Server
                                           ↓
                                    Route Mapping
                                   /products/list → bin/products/list
                                           ↓
                                    Execute Swiftlet
                                    └─ Pass request data via stdin (JSON)
                                    └─ Receive response via stdout (Base64)
                                           ↓
                                    Return HTML to Browser
                                """)
                            }
                            .style("background", "#f5f5f5")
                            .style("padding", "1.5rem")
                            .style("border-radius", "8px")
                            .style("font-family", "monospace")
                            .style("line-height", "1.6")
                        }
                        
                        // Benefits
                        Section {
                            H2("✨ Why This Architecture?")
                            
                            Grid(columns: .count(2), spacing: 30) {
                                VStack(spacing: 20) {
                                    H3("🔄 Perfect Isolation")
                                    P("Each request runs in its own process. A crash in one route can't affect others. Memory leaks? Not a problem - the process ends after each request.")
                                }
                                
                                VStack(spacing: 20) {
                                    H3("🚀 True Hot Reload")
                                    P("Change your code, rebuild that one executable, and see changes immediately. No server restart needed. Other routes keep working.")
                                }
                                
                                VStack(spacing: 20) {
                                    H3("📦 Deploy Individually")
                                    P("Update a single route without touching the rest of your app. Perfect for incremental deployments and A/B testing.")
                                }
                                
                                VStack(spacing: 20) {
                                    H3("🧩 Language Agnostic")
                                    P("While we focus on Swift, any language that can read JSON from stdin and write to stdout can be a swiftlet.")
                                }
                            }
                        }
                        
                        // Code Example
                        Section {
                            H2("💻 Simple Example")
                            
                            P("Here's what happens when someone visits /hello:")
                            
                            Grid(columns: .count(2), spacing: 30) {
                                VStack(spacing: 10) {
                                    H4("1. Server sends request data:")
                                    Pre {
                                        Code("""
                                        {
                                          "path": "/hello",
                                          "method": "GET",
                                          "headers": {
                                            "user-agent": "Mozilla/5.0..."
                                          },
                                          "queryParameters": {
                                            "name": "Alice"
                                          }
                                        }
                                        """)
                                    }
                                    .style("background", "#f5f5f5")
                                    .style("padding", "1rem")
                                    .style("border-radius", "6px")
                                    .style("font-size", "0.9rem")
                                }
                                
                                VStack(spacing: 10) {
                                    H4("2. Your swiftlet responds:")
                                    Pre {
                                        Code("""
                                        {
                                          "status": 200,
                                          "headers": {
                                            "Content-Type": "text/html"
                                          },
                                          "body": "<h1>Hello, Alice!</h1>"
                                        }
                                        // Encoded as Base64
                                        """)
                                    }
                                    .style("background", "#f5f5f5")
                                    .style("padding", "1rem")
                                    .style("border-radius", "6px")
                                    .style("font-size", "0.9rem")
                                }
                            }
                        }
                        
                        // Performance Note
                        Section {
                            Div {
                                H3("⚡ What About Performance?")
                                P("You might think spawning processes is slow. But modern operating systems are incredibly efficient at this. With proper process pooling (coming soon), Swiftlets can handle thousands of requests per second. The isolation benefits far outweigh the minimal overhead.")
                            }
                            .style("background", "#fef3c7")
                            .style("border-left", "4px solid #f59e0b")
                            .style("padding", "1.5rem")
                            .style("margin", "2rem 0")
                        }
                        
                        // Next Steps
                        Section {
                            H2("📚 Learn More")
                            
                            Grid(columns: .count(3), spacing: 20) {
                                Link(href: "/docs/concepts/html-dsl") {
                                    Div {
                                        H4("HTML DSL →")
                                        P("Learn the SwiftUI-like syntax")
                                            .style("color", "#6c757d")
                                    }
                                    .class("doc-card")
                                    .style("padding", "1.5rem")
                                }
                                .style("text-decoration", "none")
                                .style("color", "inherit")
                                
                                Link(href: "/docs/concepts/routing") {
                                    Div {
                                        H4("Routing →")
                                        P("How URLs map to executables")
                                            .style("color", "#6c757d")
                                    }
                                    .class("doc-card")
                                    .style("padding", "1.5rem")
                                }
                                .style("text-decoration", "none")
                                .style("color", "inherit")
                                
                                Link(href: "/docs/concepts/request-response") {
                                    Div {
                                        H4("Request/Response →")
                                        P("Data flow in detail")
                                            .style("color", "#6c757d")
                                    }
                                    .class("doc-card")
                                    .style("padding", "1.5rem")
                                }
                                .style("text-decoration", "none")
                                .style("color", "inherit")
                            }
                        }
                    }
                }
                .style("padding", "3rem 0")
                
                // Footer
                Footer {
                    Container(maxWidth: .large) {
                        HStack {
                            P("© 2025 Swiftlets Project")
                            Spacer()
                            HStack(spacing: 20) {
                                Link(href: "https://github.com/codelynx/swiftlets", "GitHub")
                                Link(href: "/docs", "Docs")
                                Link(href: "/showcase", "Examples")
                            }
                        }
                        .style("align-items", "center")
                    }
                }
                .style("padding", "2rem 0")
                .style("border-top", "1px solid #dee2e6")
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