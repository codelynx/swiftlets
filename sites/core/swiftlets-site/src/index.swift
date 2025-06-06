import Foundation
import Swiftlets

@main
struct HomePage {
    static func main() async throws {
        let request = try JSONDecoder().decode(Request.self, from: FileHandle.standardInput.readDataToEndOfFile())
        
        let html = Html {
            Head {
                Title("Swiftlets - Modern Swift Web Framework")
                Meta(name: "description", content: "A Swift-based web framework with executable-per-route architecture")
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
                
                // Hero Section
                Section {
                    Container(maxWidth: .large) {
                        VStack(spacing: 30) {
                            H1("Build Dynamic Web Apps with Swift")
                                .style("font-size", "3rem")
                                .style("text-align", "center")
                            
                            P("A modern web framework that brings SwiftUI-like syntax to server-side development")
                                .style("font-size", "1.25rem")
                                .style("text-align", "center")
                                .style("color", "#6c757d")
                            
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
                .style("padding", "5rem 0")
                
                // Code Example
                Section {
                    Container(maxWidth: .large) {
                        VStack(spacing: 20) {
                            H2("Simple and Familiar")
                                .style("text-align", "center")
                            
                            Pre {
                                Code("""
                                @main
                                struct MyPage {
                                    static func main() async throws {
                                        let html = Html {
                                            Head {
                                                Title("Hello, Swiftlets!")
                                            }
                                            Body {
                                                H1("Welcome to Swiftlets")
                                                P("Build web apps with Swift")
                                            }
                                        }
                                        
                                        print(html.render())
                                    }
                                }
                                """)
                            }
                            .style("background", "#f8f9fa")
                            .style("padding", "1.5rem")
                            .style("border-radius", "0.5rem")
                            .style("overflow-x", "auto")
                        }
                    }
                }
                .style("padding", "3rem 0")
                .style("background", "#ffffff")
                
                // Features
                Section {
                    Container(maxWidth: .large) {
                        VStack(spacing: 40) {
                            H2("Why Swiftlets?")
                                .style("text-align", "center")
                            
                            Grid(columns: .count(3), spacing: 30) {
                                VStack(spacing: 15) {
                                    H3("🚀 Executable Per Route")
                                    P("Each route is an independent executable, providing perfect isolation and hot-reload capabilities")
                                }
                                
                                VStack(spacing: 15) {
                                    H3("🎨 SwiftUI-like Syntax")
                                    P("Familiar declarative syntax with result builders makes web development feel natural")
                                }
                                
                                VStack(spacing: 15) {
                                    H3("🔒 Type Safe")
                                    P("Leverage Swift's type system for compile-time guarantees and better developer experience")
                                }
                                
                                VStack(spacing: 15) {
                                    H3("⚡ Fast by Default")
                                    P("Built on SwiftNIO for high performance with minimal overhead")
                                }
                                
                                VStack(spacing: 15) {
                                    H3("🛠️ Great CLI")
                                    P("Professional CLI tool for project creation, development, and deployment")
                                }
                                
                                VStack(spacing: 15) {
                                    H3("🌍 Cross Platform")
                                    P("Works on macOS and Linux, supporting x86_64 and ARM64 architectures")
                                }
                            }
                        }
                    }
                }
                .style("padding", "5rem 0")
                .style("background", "#f8f9fa")
                
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