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
                    Container(maxWidth: .xl) {
                        VStack(spacing: 40) {
                            // Main headline with gradient
                            H1 {
                                Text("Build ")
                                Span("Dynamic Web Apps")
                                    .style("background", "linear-gradient(135deg, #667eea 0%, #764ba2 100%)")
                                    .style("-webkit-background-clip", "text")
                                    .style("-webkit-text-fill-color", "transparent")
                                    .style("background-clip", "text")
                                Text(" with Swift")
                            }
                            .style("font-size", "clamp(2.5rem, 6vw, 4.5rem)")
                            .style("font-weight", "800")
                            .style("text-align", "center")
                            .style("line-height", "1.1")
                            .style("margin", "0")
                            
                            // Subtitle
                            P("A modern web framework that brings SwiftUI-like syntax to server-side development")
                                .style("font-size", "clamp(1.1rem, 2vw, 1.5rem)")
                                .style("text-align", "center")
                                .style("color", "#4a5568")
                                .style("max-width", "650px")
                                .style("margin", "0 auto")
                                .style("line-height", "1.6")
                            
                            // CTA Buttons
                            HStack(spacing: 24) {
                                Link(href: "/docs/getting-started") {
                                    Button {
                                        HStack(spacing: 8) {
                                            Text("Get Started")
                                            Text("→")
                                        }
                                    }
                                    .style("background", "linear-gradient(135deg, #667eea 0%, #764ba2 100%)")
                                    .style("color", "white")
                                    .style("padding", "14px 32px")
                                    .style("border", "none")
                                    .style("border-radius", "8px")
                                    .style("font-size", "1.1rem")
                                    .style("font-weight", "600")
                                    .style("cursor", "pointer")
                                    .style("transition", "all 0.3s ease")
                                    .style("box-shadow", "0 4px 15px rgba(102, 126, 234, 0.3)")
                                    .class("hero-btn-primary")
                                }
                                Link(href: "/showcase") {
                                    Button {
                                        HStack(spacing: 8) {
                                            Text("View Examples")
                                            Text("✨")
                                        }
                                    }
                                    .style("background", "transparent")
                                    .style("color", "#667eea")
                                    .style("padding", "14px 32px")
                                    .style("border", "2px solid #667eea")
                                    .style("border-radius", "8px")
                                    .style("font-size", "1.1rem")
                                    .style("font-weight", "600")
                                    .style("cursor", "pointer")
                                    .style("transition", "all 0.3s ease")
                                    .class("hero-btn-secondary")
                                }
                            }
                            .style("justify-content", "center")
                            .style("flex-wrap", "wrap")
                            
                            // Quick stats
                            HStack(spacing: 40) {
                                VStack(spacing: 4) {
                                    Text("60+")
                                        .style("font-size", "2rem")
                                        .style("font-weight", "700")
                                        .style("color", "#667eea")
                                    Text("HTML Elements")
                                        .style("color", "#718096")
                                        .style("font-size", "0.9rem")
                                }
                                
                                VStack(spacing: 4) {
                                    Text("100%")
                                        .style("font-size", "2rem")
                                        .style("font-weight", "700")
                                        .style("color", "#764ba2")
                                    Text("Type Safe")
                                        .style("color", "#718096")
                                        .style("font-size", "0.9rem")
                                }
                                
                                VStack(spacing: 4) {
                                    Text("Zero")
                                        .style("font-size", "2rem")
                                        .style("font-weight", "700")
                                        .style("color", "#667eea")
                                    Text("JavaScript Required")
                                        .style("color", "#718096")
                                        .style("font-size", "0.9rem")
                                }
                            }
                            .style("justify-content", "center")
                            .style("margin-top", "2rem")
                            .style("flex-wrap", "wrap")
                            .style("gap", "2rem")
                        }
                    }
                }
                .class("hero-section")
                .style("padding", "clamp(4rem, 10vw, 8rem) 0")
                .style("background", "linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%)")
                .style("position", "relative")
                .style("overflow", "hidden")
                
                // Development Status Notice
                Section {
                    Container(maxWidth: .large) {
                        Div {
                            HStack(spacing: 20) {
                                Text("🚧")
                                    .style("font-size", "2rem")
                                VStack(spacing: 10) {
                                    HStack(spacing: 10) {
                                        Strong("Development Status:")
                                        Text("Swiftlets is under active development and not ready for production use.")
                                    }
                                    P {
                                        Text("We're building something special and would love your feedback! ")
                                        Link(href: "https://github.com/codelynx/swiftlets", "Join us on GitHub")
                                            .style("color", "#667eea")
                                            .style("font-weight", "600")
                                        Text(" to contribute, report issues, or share ideas. Your input shapes the future of Swift on the web.")
                                    }
                                    .style("margin", "0")
                                }
                                .style("flex", "1")
                            }
                            .style("align-items", "center")
                        }
                        .style("background", "#fef3c7")
                        .style("border", "1px solid #fbbf24")
                        .style("border-radius", "8px")
                        .style("padding", "1.5rem")
                        .style("margin", "0 auto")
                    }
                }
                .style("padding", "2rem 0")
                
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