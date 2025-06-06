import Foundation
import SwiftletsCore
import SwiftletsHTML

@main
struct AboutPage {
    static func main() async throws {
        let request = try JSONDecoder().decode(Request.self, from: FileHandle.standardInput.readDataToEndOfFile())
        
        let html = Html {
            Head {
                Title("About - Swiftlets")
                Meta(name: "viewport", content: "width=device-width, initial-scale=1.0")
                LinkElement(rel: "stylesheet", href: "/styles/main.css")
            }
            Body {
                // Navigation
                Nav {
                    Container(maxWidth: .xxl) {
                        HStack {
                            Link(href: "/") {
                                H1("Swiftlets").style("margin", "0")
                            }
                            Spacer()
                            HStack(spacing: 20) {
                                Link(href: "/docs", "Documentation")
                                Link(href: "/showcase", "Showcase")
                                Link(href: "/about", "About").class("active")
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
                
                // About Content
                Container(maxWidth: .large) {
                    VStack(spacing: 50) {
                        // Header
                        VStack(spacing: 20) {
                            H1("About Swiftlets")
                            P("A modern approach to server-side Swift development")
                                .style("font-size", "1.25rem")
                        }
                        
                        // Philosophy
                        Section {
                            H2("Philosophy")
                            
                            P("Swiftlets was born from a simple idea: what if each web route was its own program? This approach brings several benefits:")
                            
                            UL {
                                LI("Perfect isolation - one route can't crash another")
                                LI("True hot reload - change code without restarting the server")
                                LI("Language flexibility - mix Swift, Python, or any language")
                                LI("Granular deployment - update individual routes")
                                LI("Natural code organization - filesystem mirrors URL structure")
                            }
                            
                            P("Combined with a SwiftUI-like syntax for HTML generation, Swiftlets makes server-side Swift development feel as natural as building iOS apps.")
                        }
                        
                        // Architecture
                        Section {
                            H2("Unique Architecture")
                            
                            Grid(columns: .count(2), spacing: 40) {
                                VStack(spacing: 20) {
                                    H3("Traditional Frameworks")
                                    P("All routes compiled into one monolithic application")
                                    Pre {
                                        Code("""
                                        app.get("/") { ... }
                                        app.get("/about") { ... }
                                        app.get("/contact") { ... }
                                        // All in one process
                                        """)
                                    }
                                    .class("code-block")
                                }
                                
                                VStack(spacing: 20) {
                                    H3("Swiftlets Approach")
                                    P("Each route is an independent executable")
                                    Pre {
                                        Code("""
                                        src/index.swift → bin/index
                                        src/about.swift → bin/about
                                        src/contact.swift → bin/contact
                                        // Separate processes
                                        """)
                                    }
                                    .class("code-block")
                                }
                            }
                        }
                        
                        // Inspiration
                        Section {
                            H2("Inspiration")
                            
                            P("Swiftlets draws inspiration from several sources:")
                            
                            UL {
                                LI {
                                    Strong("Paul Hudson's Ignite")
                                    Text(" - The beautiful HTML DSL with result builders")
                                }
                                LI {
                                    Strong("CGI Architecture")
                                    Text(" - The simplicity of executable-per-request, modernized")
                                }
                                LI {
                                    Strong("SwiftUI")
                                    Text(" - Declarative syntax that Swift developers already know")
                                }
                                LI {
                                    Strong("Microservices")
                                    Text(" - Independent deployment and scaling")
                                }
                            }
                        }
                        
                        // Community
                        Section {
                            H2("Open Source")
                            
                            P("Swiftlets is open source and welcomes contributions. Whether you're fixing bugs, adding features, or improving documentation, we'd love your help!")
                            
                            HStack(spacing: 20) {
                                Link(href: "https://github.com/swiftlets/swiftlets") {
                                    Button("View on GitHub")
                                        .class("btn-primary")
                                }
                                Link(href: "/docs/contributing") {
                                    Button("Contributing Guide")
                                        .class("btn-secondary")
                                }
                            }
                        }
                        
                        // Roadmap
                        Section {
                            H2("What's Next?")
                            
                            P("We're actively developing Swiftlets with these priorities:")
                            
                            OL {
                                LI("Auto-compilation on request for better developer experience")
                                LI("WebSocket support for real-time features")
                                LI("Database integration with type-safe queries")
                                LI("Deployment tools for production use")
                                LI("Performance optimizations and caching")
                            }
                            
                            P {
                                Text("Check out our ")
                                Link(href: "/docs/roadmap", "full roadmap")
                                Text(" for more details.")
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