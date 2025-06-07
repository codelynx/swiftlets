import Foundation
import Swiftlets

@main
struct RoutingPage {
    static func main() async throws {
        _ = try JSONDecoder().decode(Request.self, from: FileHandle.standardInput.readDataToEndOfFile())
        
        let html = Html {
            Head {
                Title("Routing - Swiftlets")
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
                            Text("Routing")
                        }
                        .style("color", "#6c757d")
                        
                        H1("Simple, File-Based Routing")
                        
                        P("In Swiftlets, routing is refreshingly simple: URLs map directly to executables. No configuration files, no route definitions - just organize your files.")
                            .style("font-size", "1.25rem")
                            .style("line-height", "1.8")
                        
                        // Basic Concept
                        Section {
                            H2("📁 How It Works")
                            
                            Div {
                                P("The URL path maps directly to your file structure:")
                                    .style("margin-bottom", "1.5rem")
                                
                                Grid(columns: .count(2), spacing: 30) {
                                    VStack(spacing: 15) {
                                        H4("URL Request")
                                        Pre {
                                            Code("""
                                            GET /
                                            GET /about
                                            GET /products
                                            GET /products/list
                                            GET /api/users
                                            """)
                                        }
                                        .style("background", "#f5f5f5")
                                        .style("padding", "1rem")
                                        .style("border-radius", "6px")
                                    }
                                    
                                    VStack(spacing: 15) {
                                        H4("Executable Path")
                                        Pre {
                                            Code("""
                                            bin/index
                                            bin/about
                                            bin/products
                                            bin/products/list
                                            bin/api/users
                                            """)
                                        }
                                        .style("background", "#f5f5f5")
                                        .style("padding", "1rem")
                                        .style("border-radius", "6px")
                                    }
                                }
                            }
                            .style("background", "#f8f9fa")
                            .style("padding", "2rem")
                            .style("border-radius", "8px")
                        }
                        
                        // File Structure
                        Section {
                            H2("🏗️ Project Structure")
                            
                            P("Your source files mirror your URL structure:")
                            
                            Pre {
                                Code("""
                                src/
                                ├── index.swift          → /
                                ├── about.swift          → /about
                                ├── products.swift       → /products
                                ├── products/
                                │   └── list.swift       → /products/list
                                └── api/
                                    └── users.swift      → /api/users
                                
                                bin/  (after building)
                                ├── index
                                ├── about
                                ├── products
                                ├── products/
                                │   └── list
                                └── api/
                                    └── users
                                """)
                            }
                            .style("background", "#f5f5f5")
                            .style("padding", "1.5rem")
                            .style("border-radius", "8px")
                            .style("font-family", "monospace")
                            .style("line-height", "1.6")
                        }
                        
                        // Special Routes
                        Section {
                            H2("🎯 Special Routes")
                            
                            Grid(columns: .count(2), spacing: 30) {
                                VStack(spacing: 15) {
                                    H3("Index Routes")
                                    P("Files named `index.swift` handle directory roots:")
                                    Pre {
                                        Code("""
                                        src/index.swift         → /
                                        src/blog/index.swift    → /blog
                                        src/shop/index.swift    → /shop
                                        """)
                                    }
                                    .style("background", "#f5f5f5")
                                    .style("padding", "1rem")
                                    .style("border-radius", "6px")
                                    .style("font-size", "0.9rem")
                                }
                                
                                VStack(spacing: 15) {
                                    H3("Nested Routes")
                                    P("Create subdirectories for nested URLs:")
                                    Pre {
                                        Code("""
                                        src/docs/getting-started.swift
                                        → /docs/getting-started
                                        
                                        src/api/v1/products.swift
                                        → /api/v1/products
                                        """)
                                    }
                                    .style("background", "#f5f5f5")
                                    .style("padding", "1rem")
                                    .style("border-radius", "6px")
                                    .style("font-size", "0.9rem")
                                }
                            }
                        }
                        
                        // Static Files
                        Section {
                            H2("📄 Static Files")
                            
                            P("Static files (CSS, images, etc.) are served directly from the `web/` directory:")
                            
                            Pre {
                                Code("""
                                web/
                                ├── styles/
                                │   └── main.css         → /styles/main.css
                                ├── images/
                                │   └── logo.png         → /images/logo.png
                                └── favicon.ico          → /favicon.ico
                                """)
                            }
                            .style("background", "#f5f5f5")
                            .style("padding", "1rem")
                            .style("border-radius", "6px")
                            
                            Div {
                                P("💡 Tip: The server checks for static files first. If found, it serves them directly without running any executable.")
                            }
                            .style("background", "#f0f9ff")
                            .style("border-left", "4px solid #3b82f6")
                            .style("padding", "1rem")
                            .style("margin-top", "1rem")
                        }
                        
                        // Navigation Example
                        Section {
                            H2("🔗 Building Navigation")
                            
                            P("Creating links between pages is straightforward:")
                            
                            Pre {
                                Code("""
                                // In your layout or component
                                Nav {
                                    HStack(spacing: 20) {
                                        Link(href: "/", "Home")
                                        Link(href: "/about", "About")
                                        Link(href: "/products", "Products")
                                        Link(href: "/docs/getting-started", "Docs")
                                    }
                                }
                                
                                // Dynamic navigation
                                ForEach(categories) { category in
                                    Link(href: "/products/\\(category.slug)") {
                                        Text(category.name)
                                    }
                                }
                                """)
                            }
                            .style("background", "#f5f5f5")
                            .style("padding", "1rem")
                            .style("border-radius", "6px")
                        }
                        
                        // Coming Soon
                        Section {
                            H2("🚀 Coming Soon")
                            
                            Grid(columns: .count(2), spacing: 30) {
                                VStack(spacing: 10) {
                                    H4("Dynamic Routes")
                                    P("Support for parameters like `/products/:id` is planned, allowing dynamic segments in URLs.")
                                        .style("color", "#6c757d")
                                }
                                
                                VStack(spacing: 10) {
                                    H4("Route Patterns")
                                    P("Wildcard routes and pattern matching for more flexible URL handling.")
                                        .style("color", "#6c757d")
                                }
                            }
                            .style("padding", "1.5rem")
                            .style("background", "#fef3c7")
                            .style("border-radius", "8px")
                        }
                        
                        // Benefits
                        Section {
                            H2("✨ Why File-Based Routing?")
                            
                            Grid(columns: .count(3), spacing: 20) {
                                VStack(spacing: 10) {
                                    Text("👀").style("font-size", "2rem")
                                    H4("Intuitive")
                                    P("See your site structure at a glance. No mental mapping between routes and handlers.")
                                        .style("color", "#6c757d")
                                }
                                
                                VStack(spacing: 10) {
                                    Text("🚫").style("font-size", "2rem")
                                    H4("No Configuration")
                                    P("No route files to maintain. Add a file, get a route. Delete a file, remove a route.")
                                        .style("color", "#6c757d")
                                }
                                
                                VStack(spacing: 10) {
                                    Text("🎯").style("font-size", "2rem")
                                    H4("Predictable")
                                    P("URLs match your file structure exactly. Easy to debug and understand.")
                                        .style("color", "#6c757d")
                                }
                            }
                        }
                        
                        // Next Steps
                        Section {
                            H2("📚 Related Topics")
                            
                            Grid(columns: .count(3), spacing: 20) {
                                Link(href: "/docs/concepts/request-response") {
                                    Div {
                                        H4("Request & Response →")
                                        P("Handle incoming data")
                                            .style("color", "#6c757d")
                                    }
                                    .class("doc-card")
                                    .style("padding", "1.5rem")
                                }
                                .style("text-decoration", "none")
                                .style("color", "inherit")
                                
                                Link(href: "/docs/tutorials/multi-page") {
                                    Div {
                                        H4("Multi-Page Apps →")
                                        P("Build complete sites")
                                            .style("color", "#6c757d")
                                    }
                                    .class("doc-card")
                                    .style("padding", "1.5rem")
                                }
                                .style("text-decoration", "none")
                                .style("color", "inherit")
                                
                                Link(href: "/docs/deployment") {
                                    Div {
                                        H4("Deployment →")
                                        P("Production routing")
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