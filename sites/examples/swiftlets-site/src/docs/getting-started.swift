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
                            H2("1. Installation")
                            
                            P("First, ensure you have Swift installed (5.7 or later), then clone the Swiftlets repository:")
                            
                            Pre {
                                Code("""
                                # Clone the repository
                                git clone https://github.com/codelynx/swiftlets.git
                                cd swiftlets
                                
                                # Install the CLI
                                ./install-cli.sh
                                """)
                            }
                            .class("code-block")
                            
                            P("The installer will build the CLI and add it to your PATH.")
                        }
                        
                        // Try the Showcase
                        Section {
                            H2("2. Try the Showcase Site")
                            
                            P("Before creating your own project, let's explore what Swiftlets can do! The repository includes a complete example site with documentation and component showcases - all built with Swiftlets.")
                            
                            P("Build and run the example site:")
                            
                            Pre {
                                Code("""
                                # From the Swiftlets root directory
                                ./smake build sites/examples/swiftlets-site
                                ./smake run sites/examples/swiftlets-site
                                
                                # Or using traditional make
                                make build SITE=sites/examples/swiftlets-site
                                make run SITE=sites/examples/swiftlets-site
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
                        
                        // Hello World
                        Section {
                            H2("3. Your First Swiftlet")
                            
                            P("Let's create a simple page using the Swiftlets HTML DSL. Replace the contents of src/index.swift:")
                            
                            Pre {
                                Code("""
                                import Foundation
                                import Swiftlets
                                
                                @main
                                struct HomePage {
                                    static func main() async throws {
                                        // Swiftlets passes request data via stdin
                                        let request = try JSONDecoder().decode(Request.self, 
                                            from: FileHandle.standardInput.readDataToEndOfFile())
                                        
                                        // Build your page using SwiftUI-like syntax
                                        let html = Html {
                                            Head {
                                                Title("My First Swiftlets App")
                                                Meta(name: "viewport", content: "width=device-width, initial-scale=1.0")
                                            }
                                            Body {
                                                Container {
                                                    VStack(spacing: 30) {
                                                        // Dynamic content based on time
                                                        H1(greeting())
                                                            .style("color", "#667eea")
                                                        
                                                        P("This page was built with Swift!")
                                                            .style("font-size", "1.25rem")
                                                        
                                                        // Show request path
                                                        P("You're visiting: \\(request.path)")
                                                            .style("color", "#6c757d")
                                                        
                                                        HStack(spacing: 20) {
                                                            Link(href: "/about") {
                                                                Button("About")
                                                                    .style("padding", "10px 20px")
                                                            }
                                                            Link(href: "/docs") {
                                                                Button("Documentation")
                                                                    .style("padding", "10px 20px")
                                                            }
                                                        }
                                                    }
                                                }
                                                .style("padding", "3rem 0")
                                                .style("text-align", "center")
                                            }
                                        }
                                        
                                        // Send response back to server
                                        let response = Response(
                                            status: 200,
                                            headers: ["Content-Type": "text/html; charset=utf-8"],
                                            body: html.render()
                                        )
                                        
                                        print(try JSONEncoder().encode(response).base64EncodedString())
                                    }
                                    
                                    static func greeting() -> String {
                                        let hour = Calendar.current.component(.hour, from: Date())
                                        switch hour {
                                        case 0..<12: return "Good morning! ☀️"
                                        case 12..<17: return "Good afternoon! 🌤"
                                        default: return "Good evening! 🌙"
                                        }
                                    }
                                }
                                """)
                            }
                            .class("code-block")
                            
                            P("This example demonstrates:")
                            UL {
                                LI("SwiftUI-like declarative syntax with result builders")
                                LI("Dynamic content generation (time-based greeting)")
                                LI("Access to request data (showing the path)")
                                LI("Navigation with Links and styled Buttons")
                                LI("Type-safe HTML generation with proper escaping")
                                LI("Familiar layout components (Container, VStack, HStack)")
                            }
                        }
                        
                        // Build and Run
                        Section {
                            H2("4. Build and Run")
                            
                            P("First, build your swiftlet:")
                            
                            Pre {
                                Code("""
                                swiftlets build
                                # or
                                make build
                                """)
                            }
                            .class("code-block")
                            
                            P("Then start the development server:")
                            
                            Pre {
                                Code("""
                                swiftlets serve
                                # Server starts at http://localhost:8080
                                """)
                            }
                            .class("code-block")
                            
                            P("Visit http://localhost:8080 to see your app running!")
                            
                            Div {
                                P("💡 Tip: The server will automatically route requests to your compiled swiftlets based on the URL path.")
                            }
                            .style("background", "#f0f9ff")
                            .style("border-left", "4px solid #3b82f6")
                            .style("padding", "1rem")
                            .style("margin", "1rem 0")
                        }
                        
                        // Create Your Own Project
                        Section {
                            H2("5. Create Your Own Project")
                            
                            P("After exploring the showcase, you're ready to create your own project!")
                            
                            Div {
                                P("🚧 Note: The `swiftlets new` command is coming soon. For now, you can:")
                                UL {
                                    LI("Copy the `templates/blank` directory as a starting point")
                                    LI("Or work directly in the cloned repository")
                                    LI("Study the showcase source code for patterns")
                                }
                            }
                            .style("background", "#fef3c7")
                            .style("border-left", "4px solid #f59e0b")
                            .style("padding", "1rem")
                            .style("margin", "1rem 0")
                            
                            P("A basic Swiftlets project structure:")
                            
                            Pre {
                                Code("""
                                my-app/
                                ├── Makefile          # Build commands
                                ├── src/              # Your swiftlet source files
                                │   └── index.swift   # Homepage
                                └── web/              # Static files (CSS, images)
                                """)
                            }
                            .class("code-block")
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