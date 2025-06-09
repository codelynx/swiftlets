import Foundation
import Swiftlets

@main
struct GettingStartedPage {
    static func main() async throws {
        // Swiftlets passes request data via stdin, but we don't need it for this static page
        _ = try JSONDecoder().decode(Request.self, from: FileHandle.standardInput.readDataToEndOfFile())
        
        let html = Html {
            Head {
            Title("Getting Started - Swiftlets")
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
                    Link(href: "https://github.com/swiftlets/swiftlets", "GitHub")
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
                Text("Getting Started")
            }
            .style("color", "#6c757d")
            
            H1("Getting Started with Swiftlets")
            
            P("Get up and running with Swiftlets in just a few minutes. This guide will walk you through installation, creating your first project, and understanding the basics.")
                .style("font-size", "1.25rem")
            
            // Installation
            Section {
                H2("1. Clone and Build")
                
                P("First, ensure you have Swift installed (5.7 or later), then clone the Swiftlets repository and build the server:")
                
                Pre {
                    Code("""
                    # Clone the repository
                    git clone https://github.com/codelynx/swiftlets.git
                    cd swiftlets
                    
                    # Build the server (one time setup)
                    ./build-server
                    """)
                }
                .class("code-block")
                
                P("This builds the server binary and places it in the platform-specific directory (e.g., bin/darwin/arm64/).")
            }
            
            // Try the Showcase
            Section {
                H2("2. Try the Showcase Site")
                
                P("Before creating your own project, let's explore what Swiftlets can do! The repository includes a complete example site with documentation and component showcases - all built with Swiftlets.")
                
                P("Build and run the example site:")
                
                Pre {
                    Code("""
                    # Build the site
                    ./build-site sites/examples/swiftlets-site
                    
                    # Run the site
                    ./run-site sites/examples/swiftlets-site
                    
                    # Or combine build and run
                    ./run-site sites/examples/swiftlets-site --build
                    """)
                }
                .class("code-block")
                
                P("Visit http://localhost:8080 and explore:")
                
                UL {
                    LI {
                        Strong("/showcase")
                        Text(" - See all HTML components in action")
                    }
                    LI {
                        Strong("/docs")
                        Text(" - Read documentation (also built with Swiftlets!)")
                    }
                    LI {
                        Strong("View source")
                        Text(" - Check ")
                        Code("sites/examples/swiftlets-site/src/")
                        Text(" to see how it's built")
                    }
                }
                
                Div {
                    P("💡 Tip: The entire documentation site you're reading right now is built with Swiftlets! Check out the source code to see real-world examples.")
                }
                .style("background", "#f0f9ff")
                .style("border-left", "4px solid #3b82f6")
                .style("padding", "1rem")
                .style("margin", "1rem 0")
            }
            
            // Understanding Swiftlets
            Section {
                H2("3. Understanding the Architecture")
                
                P("Swiftlets uses a unique architecture where each route is a standalone executable:")
                
                Pre {
                    Code("""
                    sites/examples/swiftlets-site/
                    ├── src/              # Swift source files
                    │   ├── index.swift   # Homepage route
                    │   ├── about.swift   # About page route
                    │   └── docs/
                    │       └── index.swift  # Docs index route
                    ├── web/              # Static files + .webbin markers
                    │   ├── styles/       # CSS files
                    │   ├── *.webbin      # Route markers (generated)
                    │   └── images/       # Static assets
                    └── bin/              # Compiled executables (generated)
                        ├── index         # Executable for /
                        ├── about         # Executable for /about
                        └── docs/
                            └── index     # Executable for /docs
                    """)
                }
                .class("code-block")
                
                P("Key concepts:")
                UL {
                    LI {
                        Strong("File-based routing:")
                        Text(" Your file structure defines your routes")
                    }
                    LI {
                        Strong("Independent executables:")
                        Text(" Each route compiles to its own binary")
                    }
                    LI {
                        Strong("No Makefiles needed:")
                        Text(" The build-site script handles everything")
                    }
                    LI {
                        Strong("Hot reload ready:")
                        Text(" Executables can be rebuilt without restarting the server")
                    }
                }
            }
            
            // Working with Sites
            Section {
                H2("4. Working with Sites")
                
                P("The build scripts make it easy to work with any site:")
                
                Pre {
                    Code("""
                    # Build a site (incremental - only changed files)
                    ./build-site path/to/site
                    
                    # Force rebuild all files
                    ./build-site path/to/site --force
                    
                    # Clean build artifacts
                    ./build-site path/to/site --clean
                    
                    # Run a site
                    ./run-site path/to/site
                    
                    # Run with custom port
                    ./run-site path/to/site --port 3000
                    
                    # Build and run in one command
                    ./run-site path/to/site --build
                    """)
                }
                .class("code-block")
                
                Div {
                    P("💡 Tip: The scripts automatically detect your platform (macOS/Linux) and architecture (x86_64/arm64).")
                }
                .style("background", "#f0f9ff")
                .style("border-left", "4px solid #3b82f6")
                .style("padding", "1rem")
                .style("margin", "1rem 0")
            }
            
            // SwiftUI-Style Components
            Section {
                H2("5. SwiftUI-Style Components")
                
                P("Swiftlets also supports creating reusable components with a SwiftUI-like API:")
                
                Pre {
                    Code("""
                    struct Greeting: HTMLComponent {
                        let name: String
                        
                        var body: some HTMLElement {
                            VStack(spacing: 10) {
                                H1("Hello, \\(name)!")
                                P("Welcome to Swiftlets")
                            }
                            .style("text-align", "center")
                        }
                    }
                    
                    // Use it in your page:
                    @main
                    struct HomePage: SwiftletMain {
                        var title: String { "Home" }
                        
                        var body: some HTMLElement {
                            Html {
                                Head { Title(title) }
                                Body {
                                    Greeting(name: "Developer").body
                                }
                            }
                        }
                    }
                    """)
                }
                .class("code-block")
                
                P("This approach enables building complex UIs from simple, composable components - just like SwiftUI!")
                
                Link(href: "/showcase/swiftui-style") {
                    Button("See SwiftUI-Style Examples →")
                        .class("btn btn-primary")
                        .style("margin-top", "1rem")
                }
            }
            
            // Next Steps
            Section {
                H2("Next Steps")
                
                UL {
                    LI {
                        Link(href: "/docs/concepts", "Core Concepts")
                        Text(" - Understand how Swiftlets works")
                    }
                    LI {
                        Link(href: "/showcase", "Component Showcase")
                        Text(" - See all available components")
                    }
                    LI {
                        Link(href: "/showcase/swiftui-style", "SwiftUI-Style API")
                        Text(" - Build with reusable components")
                    }
                    LI {
                        Link(href: "https://github.com/codelynx/swiftlets/tree/main/sites/examples/swiftlets-site", "Study the Source")
                            .attribute("target", "_blank")
                        Text(" - Learn from real examples")
                    }
                    LI {
                        Link(href: "/docs/concepts/html-dsl", "HTML DSL Guide")
                        Text(" - Master the SwiftUI-like syntax")
                    }
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
                    Link(href: "https://github.com/swiftlets/swiftlets", "GitHub")
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