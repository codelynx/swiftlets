import Foundation
import Swiftlets

@main
struct DocsPage {
    static func main() async throws {
        let request = try JSONDecoder().decode(Request.self, from: FileHandle.standardInput.readDataToEndOfFile())
        
        let html = Html {
            Head {
                Title("Documentation - Swiftlets")
                Meta(name: "viewport", content: "width=device-width, initial-scale=1.0")
                LinkElement(rel: "stylesheet", href: "/styles/main.css")
            }
            Body {
                // Navigation (would be extracted to component)
                Nav {
                    Container(maxWidth: .xxl) {
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
                
                // Documentation Content
                Container(maxWidth: .xxl) {
                    Grid(columns: .columns(.fixed(250), .fractional(1)), spacing: 30) {
                        // Sidebar
                        Aside {
                            VStack(spacing: 20) {
                                H3("Getting Started")
                                VStack(spacing: 10) {
                                    Link(href: "/docs/getting-started", "Quick Start")
                                    Link(href: "/docs/installation", "Installation")
                                    Link(href: "/docs/first-app", "Your First App")
                                }
                                
                                H3("Core Concepts")
                                VStack(spacing: 10) {
                                    Link(href: "/docs/routing", "Routing")
                                    Link(href: "/docs/html-dsl", "HTML DSL")
                                    Link(href: "/docs/components", "Components")
                                }
                                
                                H3("CLI")
                                VStack(spacing: 10) {
                                    Link(href: "/docs/cli-overview", "Overview")
                                    Link(href: "/docs/cli-commands", "Commands")
                                }
                                
                                H3("Deployment")
                                VStack(spacing: 10) {
                                    Link(href: "/docs/deployment", "Deployment Guide")
                                    Link(href: "/docs/docker", "Docker")
                                    Link(href: "/docs/linux", "Linux Setup")
                                }
                            }
                        }
                        .style("grid-column", "span 1")
                        
                        // Main Content
                        Main {
                            VStack(spacing: 30) {
                                H1("Documentation")
                                
                                P("Welcome to the Swiftlets documentation. Learn how to build modern web applications with Swift.")
                                
                                // Quick Links
                                Grid(columns: .count(3), spacing: 20) {
                                    Div {
                                        H3("🚀 Getting Started")
                                        P("New to Swiftlets? Start here for a quick introduction.")
                                        Link(href: "/docs/getting-started", "Get Started →")
                                    }
                                    .classes("card", "p-4")
                                    
                                    Div {
                                        H3("📖 CLI Guide")
                                        P("Learn how to use the Swiftlets CLI for development.")
                                        Link(href: "/docs/cli-overview", "View CLI Docs →")
                                    }
                                    .classes("card", "p-4")
                                    
                                    Div {
                                        H3("🎨 HTML DSL")
                                        P("Master the SwiftUI-like syntax for building web pages.")
                                        Link(href: "/docs/html-dsl", "Learn HTML DSL →")
                                    }
                                    .classes("card", "p-4")
                                }
                                
                                H2("Popular Topics")
                                
                                UL {
                                    LI { Link(href: "/docs/routing", "Understanding Routing") }
                                    LI { Link(href: "/docs/components", "Building Reusable Components") }
                                    LI { Link(href: "/docs/deployment", "Deploying to Production") }
                                    LI { Link(href: "/docs/performance", "Performance Best Practices") }
                                }
                            }
                        }
                        .style("grid-column", "span 3")
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