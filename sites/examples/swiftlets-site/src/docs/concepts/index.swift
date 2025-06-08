import Foundation
import Swiftlets

@main
struct ConceptsIndex {
    static func main() async throws {
        _ = try JSONDecoder().decode(Request.self, from: FileHandle.standardInput.readDataToEndOfFile())
        
        let html = Html {
            Head {
                Title("Core Concepts - Swiftlets")
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
                            Text("Core Concepts")
                        }
                        .style("color", "#6c757d")
                        
                        H1("Core Concepts")
                        
                        P("Understand the fundamental ideas that make Swiftlets unique and powerful.")
                            .style("font-size", "1.25rem")
                        
                        // Concept Cards
                        Grid(columns: .count(2), spacing: 30) {
                            Link(href: "/docs/concepts/architecture") {
                                Div {
                                    VStack(spacing: 15) {
                                        Text("🏗️")
                                            .style("font-size", "3rem")
                                        H3("Architecture")
                                            .style("margin", "0")
                                        P("Learn about the executable-per-route architecture and why it matters.")
                                            .style("color", "#6c757d")
                                            .style("margin", "0")
                                    }
                                }
                                .class("doc-card")
                                .style("padding", "2rem")
                                .style("height", "100%")
                            }
                            .style("text-decoration", "none")
                            .style("color", "inherit")
                            
                            Link(href: "/docs/concepts/html-dsl") {
                                Div {
                                    VStack(spacing: 15) {
                                        Text("🎨")
                                            .style("font-size", "3rem")
                                        H3("HTML DSL")
                                            .style("margin", "0")
                                        P("Master the SwiftUI-like syntax for building web pages.")
                                            .style("color", "#6c757d")
                                            .style("margin", "0")
                                    }
                                }
                                .class("doc-card")
                                .style("padding", "2rem")
                                .style("height", "100%")
                            }
                            .style("text-decoration", "none")
                            .style("color", "inherit")
                            
                            Link(href: "/docs/concepts/routing") {
                                Div {
                                    VStack(spacing: 15) {
                                        Text("🛣️")
                                            .style("font-size", "3rem")
                                        H3("Routing")
                                            .style("margin", "0")
                                        P("Understand how URLs map to your Swift executables.")
                                            .style("color", "#6c757d")
                                            .style("margin", "0")
                                    }
                                }
                                .class("doc-card")
                                .style("padding", "2rem")
                                .style("height", "100%")
                            }
                            .style("text-decoration", "none")
                            .style("color", "inherit")
                            
                            Link(href: "/docs/concepts/request-response") {
                                Div {
                                    VStack(spacing: 15) {
                                        Text("🔄")
                                            .style("font-size", "3rem")
                                        H3("Request & Response")
                                            .style("margin", "0")
                                        P("How data flows between the server and your swiftlets.")
                                            .style("color", "#6c757d")
                                            .style("margin", "0")
                                    }
                                }
                                .class("doc-card")
                                .style("padding", "2rem")
                                .style("height", "100%")
                            }
                            .style("text-decoration", "none")
                            .style("color", "inherit")
                            
                            // Resources & Storage - temporarily disabled
                            // Link(href: "/docs/concepts/resources-storage") {
                            //     Div {
                            //         VStack(spacing: 15) {
                            //             Text("📁")
                            //                 .style("font-size", "3rem")
                            //             H3("Resources & Storage")
                            //                 .style("margin", "0")
                            //             P("Read configuration files and manage dynamic content with resources and storage.")
                            //                 .style("color", "#6c757d")
                            //                 .style("margin", "0")
                            //         }
                            //     }
                            //     .class("doc-card")
                            //     .style("padding", "2rem")
                            //     .style("height", "100%")
                            // }
                            // .style("text-decoration", "none")
                            // .style("color", "inherit")
                        }
                        
                        // Quick Overview
                        Section {
                            H2("Quick Overview")
                            
                            VStack(spacing: 30) {
                                VStack(spacing: 10) {
                                    H3("🎯 Different by Design")
                                    P("Swiftlets isn't just another web framework. It rethinks how web applications should be built, prioritizing isolation, simplicity, and developer experience.")
                                }
                                
                                VStack(spacing: 10) {
                                    H3("🔧 Built for Modern Development")
                                    P("Hot reload that actually works, true process isolation, and the ability to mix programming languages - Swiftlets is designed for how developers work today.")
                                }
                                
                                VStack(spacing: 10) {
                                    H3("⚡ Performance Through Simplicity")
                                    P("By keeping each route independent, Swiftlets achieves excellent performance without complex optimization strategies.")
                                }
                            }
                        }
                        .style("background", "#f8f9fa")
                        .style("padding", "2rem")
                        .style("border-radius", "8px")
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