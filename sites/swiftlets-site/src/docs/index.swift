import Foundation
import Swiftlets

@main
struct DocsIndex {
    static func main() async throws {
        let request = try JSONDecoder().decode(Request.self, from: FileHandle.standardInput.readDataToEndOfFile())
        
        let html = Html {
            Head {
            Title("Documentation - Swiftlets")
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
                    Link(href: "/docs", "Documentation").style("font-weight", "600")
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
                H1("Welcome to Swiftlets")
                    .style("font-size", "3rem")
                    .style("text-align", "center")
                    .style("margin-bottom", "0")
                
                P("Build modern web applications with Swift and SwiftUI-like syntax")
                    .style("font-size", "1.25rem")
                    .style("text-align", "center")
                    .style("color", "#6c757d")
            }
            }
            }
            .style("padding", "4rem 0")
            .style("background", "linear-gradient(to bottom, #f8f9fa, #ffffff)")
            
            // NEW: SwiftUI-Style API Announcement
            Section {
            Container(maxWidth: .large) {
            Div {
                VStack(spacing: 20) {
                    HStack(spacing: 10) {
                        Text("🎉 NEW")
                            .style("background", "#28a745")
                            .style("color", "white")
                            .style("padding", "0.25rem 0.5rem")
                            .style("border-radius", "0.25rem")
                            .style("font-weight", "bold")
                            .style("font-size", "0.875rem")
                        H2("SwiftUI-Style API with @main")
                            .style("margin", "0")
                    }
                    .style("justify-content", "center")
                    .style("align-items", "center")
                    
                    P("Write Swiftlets with zero boilerplate using our new declarative API")
                        .style("text-align", "center")
                        .style("font-size", "1.125rem")
                        .style("color", "#6c757d")
                    
                    Pre {
                        Code("""
                        @main
                        struct HomePage: SwiftletMain {
                            @Query("name") var userName: String?
                            
                            var title = "Welcome"
                            var body: some HTMLElement {
                                H1("Hello, \\(userName ?? "World")!")
                            }
                        }
                        """)
                    }
                    .style("background", "#f8f9fa")
                    .style("padding", "1.5rem")
                    .style("border-radius", "0.5rem")
                    .style("margin", "0 auto")
                    .style("max-width", "600px")
                    
                    HStack(spacing: 20) {
                        Link(href: "/showcase/api-demo") {
                            Button("Try Interactive Demo")
                                .style("padding", "0.75rem 2rem")
                                .style("background", "#007bff")
                                .style("color", "white")
                                .style("border", "none")
                                .style("border-radius", "0.375rem")
                                .style("font-size", "1.125rem")
                                .style("cursor", "pointer")
                        }
                        Link(href: "/docs/getting-started#swiftui-style") {
                            Button("Learn More")
                                .style("padding", "0.75rem 2rem")
                                .style("background", "white")
                                .style("color", "#007bff")
                                .style("border", "2px solid #007bff")
                                .style("border-radius", "0.375rem")
                                .style("font-size", "1.125rem")
                                .style("cursor", "pointer")
                        }
                    }
                    .style("justify-content", "center")
                }
            }
            .style("background", "linear-gradient(135deg, #667eea 0%, #764ba2 100%)")
            .style("color", "white")
            .style("padding", "3rem")
            .style("border-radius", "1rem")
            .style("box-shadow", "0 10px 30px rgba(0,0,0,0.1)")
            }
            }
            .style("padding", "3rem 0")
            
            // Quick Start Cards
            Section {
            Container(maxWidth: .large) {
            Grid(columns: .count(3), spacing: 30) {
                // Getting Started
                Link(href: "/docs/getting-started") {
                    Div {
                        VStack(spacing: 15) {
                            Text("🚀")
                                .style("font-size", "3rem")
                                .style("text-align", "center")
                            H3("Getting Started")
                                .style("margin", "0")
                            P("Get up and running with Swiftlets in minutes")
                                .style("color", "#6c757d")
                                .style("margin", "0")
                        }
                    }
                    .style("padding", "2rem")
                    .style("height", "100%")
                    .style("transition", "transform 0.2s")
                    .class("doc-card")
                }
                .style("text-decoration", "none")
                .style("color", "inherit")
                
                // Core Concepts
                Link(href: "/docs/concepts") {
                    Div {
                        VStack(spacing: 15) {
                            Text("💡")
                                .style("font-size", "3rem")
                                .style("text-align", "center")
                            H3("Core Concepts")
                                .style("margin", "0")
                            P("Understand how Swiftlets works under the hood")
                                .style("color", "#6c757d")
                                .style("margin", "0")
                        }
                    }
                    .style("padding", "2rem")
                    .style("height", "100%")
                    .style("transition", "transform 0.2s")
                    .class("doc-card")
                }
                .style("text-decoration", "none")
                .style("color", "inherit")
                
                // Components
                Link(href: "/showcase") {
                    Div {
                        VStack(spacing: 15) {
                            Text("🧩")
                                .style("font-size", "3rem")
                                .style("text-align", "center")
                            H3("Components")
                                .style("margin", "0")
                            P("Explore all available HTML components")
                                .style("color", "#6c757d")
                                .style("margin", "0")
                        }
                    }
                    .style("padding", "2rem")
                    .style("height", "100%")
                    .style("transition", "transform 0.2s")
                    .class("doc-card")
                }
                .style("text-decoration", "none")
                .style("color", "inherit")
            }
            }
            }
            .style("padding", "3rem 0")
            
            // Why Swiftlets
            Section {
            Container(maxWidth: .large) {
            VStack(spacing: 40) {
                H2("Why Choose Swiftlets?")
                    .style("text-align", "center")
                
                Grid(columns: .count(2), spacing: 40) {
                    VStack(spacing: 20) {
                        H3("🎯 Focused on Developer Experience")
                        P("Write web applications using familiar Swift syntax. If you know SwiftUI, you'll feel right at home.")
                    }
                    
                    VStack(spacing: 20) {
                        H3("⚡ Lightning Fast")
                        P("Built on SwiftNIO for exceptional performance. Each route runs as an independent process.")
                    }
                    
                    VStack(spacing: 20) {
                        H3("🔧 Simple Architecture")
                        P("No complex build steps or bundlers. Just write Swift code and run.")
                    }
                    
                    VStack(spacing: 20) {
                        H3("🎨 Full HTML5 Support")
                        P("Access to 60+ HTML elements with type-safe modifiers and attributes.")
                    }
                }
            }
            }
            }
            .style("padding", "4rem 0")
            .style("background", "#f8f9fa")
            
            // Getting Started CTA
            Section {
            Container(maxWidth: .medium) {
            Div {
                VStack(spacing: 25) {
                    H2("Ready to Build?")
                        .style("margin", "0")
                    P("Start building your first Swiftlets application in minutes")
                        .style("margin", "0")
                    Link(href: "/docs/getting-started") {
                        Button("Get Started →")
                            .style("background", "#667eea")
                            .style("color", "white")
                            .style("padding", "12px 24px")
                            .style("border", "none")
                            .style("border-radius", "6px")
                            .style("font-size", "1.1rem")
                            .style("cursor", "pointer")
                    }
                }
                .style("text-align", "center")
            }
            .style("padding", "3rem")
            .style("background", "white")
            .style("border", "2px solid #e9ecef")
            .style("border-radius", "8px")
            }
            }
            .style("padding", "4rem 0")
            
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