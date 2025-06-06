import Foundation
import Swiftlets

@main
struct GettingStartedPage {
    static func main() async throws {
        let request = try JSONDecoder().decode(Request.self, from: FileHandle.standardInput.readDataToEndOfFile())
        
        let html = Html {
            Head {
                Title("Getting Started - Swiftlets")
                Meta(name: "viewport", content: "width=device-width, initial-scale=1.0")
                LinkElement(rel: "stylesheet", href: "/styles/main.css")
            }
            Body {
                // Navigation
                Nav {
                    Container(maxWidth: .extraLarge) {
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
                            
                            P("First, clone the Swiftlets repository and install the CLI:")
                            
                            Pre {
                                Code("""
                                # Clone the repository
                                git clone https://github.com/swiftlets/swiftlets.git
                                cd swiftlets
                                
                                # Install the CLI
                                ./install-cli.sh
                                """)
                            }
                            .class("code-block")
                            
                            P("The installer will build the CLI and add it to your PATH.")
                        }
                        
                        // Create Project
                        Section {
                            H2("2. Create Your First Project")
                            
                            P("Use the CLI to create a new Swiftlets project:")
                            
                            Pre {
                                Code("""
                                swiftlets new my-first-app
                                cd my-first-app
                                """)
                            }
                            .class("code-block")
                            
                            P("This creates a new project with the following structure:")
                            
                            Pre {
                                Code("""
                                my-first-app/
                                ├── Package.swift      # Swift package manifest
                                ├── Makefile          # Build commands
                                ├── src/              # Your swiftlet source files
                                │   └── index.swift   # Homepage swiftlet
                                └── web/              # Web root directory
                                    ├── index.webbin  # Route mapping
                                    └── bin/          # Compiled swiftlets
                                """)
                            }
                            .class("code-block")
                        }
                        
                        // Hello World
                        Section {
                            H2("3. Understanding Your First Swiftlet")
                            
                            P("Open src/index.swift to see your first swiftlet:")
                            
                            Pre {
                                Code("""
                                import Foundation
                                
                                @main
                                struct Index {
                                    static func main() {
                                        print("Status: 200")
                                        print("Content-Type: text/html; charset=utf-8")
                                        print("")
                                        print(\"\"\"
                                <!DOCTYPE html>
                                <html>
                                <head>
                                    <title>Welcome to Swiftlets</title>
                                </head>
                                <body>
                                    <h1>Hello from Swiftlets!</h1>
                                    <p>Edit src/index.swift to change this page.</p>
                                </body>
                                </html>
                                \"\"\")
                                    }
                                }
                                """)
                            }
                            .class("code-block")
                        }
                        
                        // Run Server
                        Section {
                            H2("4. Run the Development Server")
                            
                            P("Start the development server:")
                            
                            Pre {
                                Code("""
                                swiftlets serve
                                """)
                            }
                            .class("code-block")
                            
                            P("Visit http://localhost:8080 to see your app running!")
                        }
                        
                        // Next Steps
                        Section {
                            H2("Next Steps")
                            
                            UL {
                                LI {
                                    Link(href: "/docs/html-dsl", "Learn the HTML DSL")
                                    Text(" - Use SwiftUI-like syntax for HTML")
                                }
                                LI {
                                    Link(href: "/docs/routing", "Understand Routing")
                                    Text(" - How URLs map to swiftlets")
                                }
                                LI {
                                    Link(href: "/docs/components", "Build Components")
                                    Text(" - Create reusable UI components")
                                }
                                LI {
                                    Link(href: "/showcase", "Explore Examples")
                                    Text(" - See what you can build")
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