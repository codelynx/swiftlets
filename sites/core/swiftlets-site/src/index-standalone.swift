import Foundation

@main
struct HomePage {
    static func main() async throws {
        let request = try JSONDecoder().decode(Request.self, from: FileHandle.standardInput.readDataToEndOfFile())
        
        let html = Html {
            Head {
                Title("Swiftlets - Modern Swift Web Framework")
                Meta(name: "description", content: "A Swift-based web framework with executable-per-route architecture")
                Meta(name: "viewport", content: "width=device-width, initial-scale=1")
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
                            HStack(spacing: 30) {
                                Link(href: "/docs", "Documentation")
                                Link(href: "/showcase", "Showcase")
                                Link(href: "/about", "About")
                                Link(href: "https://github.com/yourusername/swiftlets", "GitHub")
                                    .attribute("target", "_blank")
                            }
                        }
                    }
                    .style("padding", "1rem 2rem")
                }
                .style("background-color", "#f8f9fa")
                .style("border-bottom", "1px solid #dee2e6")
                
                // Hero Section
                Section {
                    Container {
                        VStack(spacing: 40) {
                            VStack(spacing: 20) {
                                H1("Build Dynamic Web Apps with Swift")
                                    .style("font-size", "3rem")
                                    .style("text-align", "center")
                                
                                P("A revolutionary web framework that compiles each route into an independent executable, enabling perfect isolation, hot-reload development, and unlimited scalability.")
                                    .style("font-size", "1.25rem")
                                    .style("text-align", "center")
                                    .style("color", "#6c757d")
                                    .style("max-width", "800px")
                                    .style("margin", "0 auto")
                            }
                            
                            HStack(spacing: 20) {
                                Link(href: "/docs/getting-started") {
                                    Button("Get Started")
                                        .class("btn-primary")
                                }
                                Link(href: "/showcase") {
                                    Button("View Examples")
                                        .class("btn-secondary")
                                }
                            }
                            .style("justify-content", "center")
                        }
                    }
                }
                .style("padding", "4rem 0")
                .style("background", "linear-gradient(135deg, #667eea 0%, #764ba2 100%)")
                .style("color", "white")
                
                // Code Example
                Section {
                    Container {
                        VStack(spacing: 30) {
                            H2("Simple, Declarative Syntax")
                                .style("text-align", "center")
                            
                            Pre {
                                Code("""
                                import SwiftletsCore
                                import SwiftletsHTML
                                
                                @main
                                struct HomePage {
                                    static func main() async throws {
                                        let request = try Request.decode()
                                        
                                        let html = Html {
                                            Head {
                                                Title("Welcome to Swiftlets")
                                            }
                                            Body {
                                                H1("Hello, \\(request.query["name"] ?? "World")!")
                                                P("Build web apps with Swift's type safety and performance.")
                                            }
                                        }
                                        
                                        Response(html: html.render()).send()
                                    }
                                }
                                """)
                            }
                            .class("language-swift")
                            .style("background-color", "#f8f9fa")
                            .style("padding", "2rem")
                            .style("border-radius", "8px")
                            .style("overflow-x", "auto")
                        }
                    }
                }
                .style("padding", "4rem 0")
                
                // Features Grid
                Section {
                    Container {
                        VStack(spacing: 40) {
                            H2("Why Swiftlets?")
                                .style("text-align", "center")
                            
                            Grid(columns: .count(3), spacing: 30) {
                                VStack(spacing: 15) {
                                    H3("🚀 Executable Per Route")
                                    P("Each route is an independent executable, providing perfect isolation and hot-reload capabilities")
                                }
                                
                                VStack(spacing: 15) {
                                    H3("🔥 Hot Reload")
                                    P("Make changes and see them instantly. No server restarts, no state loss, just pure productivity")
                                }
                                
                                VStack(spacing: 15) {
                                    H3("⚡ Lightning Fast")
                                    P("Compiled Swift performance with minimal overhead. Your apps run at native speed")
                                }
                                
                                VStack(spacing: 15) {
                                    H3("🛡️ Type Safe")
                                    P("Leverage Swift's powerful type system to catch errors at compile time, not runtime")
                                }
                                
                                VStack(spacing: 15) {
                                    H3("🎨 SwiftUI-like DSL")
                                    P("Familiar, declarative syntax for building HTML. If you know SwiftUI, you know Swiftlets")
                                }
                                
                                VStack(spacing: 15) {
                                    H3("📦 Modular")
                                    P("Build reusable components and share them across projects. True modularity at its finest")
                                }
                            }
                        }
                    }
                }
                .style("padding", "4rem 0")
                .style("background-color", "#f8f9fa")
                
                // Footer
                Footer {
                    Container {
                        HStack {
                            P("© 2024 Swiftlets. Built with Swift and ❤️")
                            Spacer()
                            HStack(spacing: 20) {
                                Link(href: "/docs", "Docs")
                                Link(href: "https://github.com/yourusername/swiftlets", "GitHub")
                                Link(href: "/about", "About")
                            }
                        }
                    }
                    .style("padding", "2rem 0")
                }
                .style("background-color", "#212529")
                .style("color", "white")
                .style("margin-top", "4rem")
            }
        }
        
        let response = Response(html: html.render())
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonData = try encoder.encode(response)
        FileHandle.standardOutput.write(jsonData)
    }
}