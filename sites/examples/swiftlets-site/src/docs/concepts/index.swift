import Swiftlets

@main
struct ConceptsIndex: SwiftletMain {
    var title = "Core Concepts - Swiftlets"
    
    var body: some HTMLElement {
        Fragment {
            // Navigation
            navigation()
            
            // Hero Section
            heroSection()
            
            // Main Content
            mainContent()
            
            // Footer
            footer()
        }
    }
    
    @HTMLBuilder
    func navigation() -> some HTMLElement {
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
    }
    
    @HTMLBuilder
    func heroSection() -> some HTMLElement {
        Section {
            Container(maxWidth: .large) {
                VStack(spacing: 30) {
                    // Breadcrumb
                    HStack(spacing: 10) {
                        Link(href: "/docs", "Docs")
                            .style("color", "#667eea")
                        Text("→")
                            .style("color", "#a0aec0")
                        Text("Core Concepts")
                            .style("font-weight", "600")
                    }
                    .class("breadcrumb")
                    .style("font-size", "0.875rem")
                    
                    // Hero Content
                    VStack(spacing: 20) {
                        H1("Core Concepts")
                            .style("font-size", "3rem")
                            .style("font-weight", "800")
                            .style("background", "linear-gradient(135deg, #667eea 0%, #764ba2 100%)")
                            .style("-webkit-background-clip", "text")
                            .style("-webkit-text-fill-color", "transparent")
                            .style("margin", "0")
                        
                        P("Understand the fundamental ideas that power Swiftlets and make it unique")
                            .style("font-size", "1.375rem")
                            .style("color", "#4a5568")
                            .style("max-width", "600px")
                            .style("margin", "0 auto")
                            .style("text-align", "center")
                    }
                    .style("text-align", "center")
                }
            }
        }
        .style("padding", "4rem 0 3rem 0")
        .style("background", "linear-gradient(180deg, #ffffff 0%, #f7fafc 100%)")
    }
    
    @HTMLBuilder
    func mainContent() -> some HTMLElement {
        Container(maxWidth: .large) {
            VStack(spacing: 60) {
            
                // Concept Cards Grid
                conceptCards()
                
                // Learning Path Section
                learningPath()
                
                // Key Principles
                keyPrinciples()
            }
        }
        .style("padding", "3rem 0 5rem 0")
    }
    
    @HTMLBuilder
    func conceptCards() -> some HTMLElement {
        VStack(spacing: 20) {
            H2("Explore the Concepts")
                .style("font-size", "2.25rem")
                .style("font-weight", "700")
                .style("text-align", "center")
                .style("margin-bottom", "1rem")
            
            Grid(columns: .count(2), spacing: 30) {
                Link(href: "/docs/concepts/architecture") {
                    Div {
                        VStack(spacing: 20) {
                            Div {
                                Text("🏗️")
                                    .style("font-size", "3.5rem")
                            }
                            .style("height", "80px")
                            .style("display", "flex")
                            .style("align-items", "center")
                            .style("justify-content", "center")
                            
                            VStack(spacing: 10) {
                                H3("Architecture")
                                    .style("margin", "0")
                                    .style("font-size", "1.5rem")
                                    .style("color", "#1a202c")
                                P("Executable-per-route architecture for true isolation and hot reload")
                                    .style("color", "#718096")
                                    .style("margin", "0")
                                    .style("line-height", "1.6")
                            }
                        }
                    }
                    .class("concept-card")
                    .style("padding", "2.5rem")
                    .style("background", "white")
                    .style("border", "2px solid #e2e8f0")
                    .style("border-radius", "16px")
                    .style("height", "100%")
                    .style("transition", "all 0.3s ease")
                    .style("cursor", "pointer")
                }
                .style("text-decoration", "none")
                .style("color", "inherit")
                
                Link(href: "/docs/concepts/html-dsl") {
                    Div {
                        VStack(spacing: 20) {
                            Div {
                                Text("🎨")
                                    .style("font-size", "3.5rem")
                            }
                            .style("height", "80px")
                            .style("display", "flex")
                            .style("align-items", "center")
                            .style("justify-content", "center")
                            
                            VStack(spacing: 10) {
                                H3("HTML DSL")
                                    .style("margin", "0")
                                    .style("font-size", "1.5rem")
                                    .style("color", "#1a202c")
                                P("SwiftUI-inspired syntax for building beautiful, type-safe web pages")
                                    .style("color", "#718096")
                                    .style("margin", "0")
                                    .style("line-height", "1.6")
                            }
                        }
                    }
                    .class("concept-card")
                    .style("padding", "2.5rem")
                    .style("background", "white")
                    .style("border", "2px solid #e2e8f0")
                    .style("border-radius", "16px")
                    .style("height", "100%")
                    .style("transition", "all 0.3s ease")
                    .style("cursor", "pointer")
                }
                .style("text-decoration", "none")
                .style("color", "inherit")
                
                Link(href: "/docs/concepts/routing") {
                    Div {
                        VStack(spacing: 20) {
                            Div {
                                Text("🛣️")
                                    .style("font-size", "3.5rem")
                            }
                            .style("height", "80px")
                            .style("display", "flex")
                            .style("align-items", "center")
                            .style("justify-content", "center")
                            
                            VStack(spacing: 10) {
                                H3("Routing")
                                    .style("margin", "0")
                                    .style("font-size", "1.5rem")
                                    .style("color", "#1a202c")
                                P("File-based routing that maps URLs directly to Swift executables")
                                    .style("color", "#718096")
                                    .style("margin", "0")
                                    .style("line-height", "1.6")
                            }
                        }
                    }
                    .class("concept-card")
                    .style("padding", "2.5rem")
                    .style("background", "white")
                    .style("border", "2px solid #e2e8f0")
                    .style("border-radius", "16px")
                    .style("height", "100%")
                    .style("transition", "all 0.3s ease")
                    .style("cursor", "pointer")
                }
                .style("text-decoration", "none")
                .style("color", "inherit")
                
                Link(href: "/docs/concepts/request-response") {
                    Div {
                        VStack(spacing: 20) {
                            Div {
                                Text("🔄")
                                    .style("font-size", "3.5rem")
                            }
                            .style("height", "80px")
                            .style("display", "flex")
                            .style("align-items", "center")
                            .style("justify-content", "center")
                            
                            VStack(spacing: 10) {
                                H3("Request & Response")
                                    .style("margin", "0")
                                    .style("font-size", "1.5rem")
                                    .style("color", "#1a202c")
                                P("Simple, powerful API for handling HTTP requests and responses")
                                    .style("color", "#718096")
                                    .style("margin", "0")
                                    .style("line-height", "1.6")
                            }
                        }
                    }
                    .class("concept-card")
                    .style("padding", "2.5rem")
                    .style("background", "white")
                    .style("border", "2px solid #e2e8f0")
                    .style("border-radius", "16px")
                    .style("height", "100%")
                    .style("transition", "all 0.3s ease")
                    .style("cursor", "pointer")
                }
                .style("text-decoration", "none")
                .style("color", "inherit")
                
            }
        }
    }
    
    @HTMLBuilder
    func learningPath() -> some HTMLElement {
        Section {
            VStack(spacing: 30) {
                H2("Learning Path")
                    .style("font-size", "2rem")
                    .style("font-weight", "700")
                    .style("text-align", "center")
                
                P("Follow this recommended order to master Swiftlets concepts")
                    .style("text-align", "center")
                    .style("color", "#718096")
                    .style("margin-bottom", "2rem")
                
                VStack(spacing: 20) {
                    learningStep(number: "1", title: "Architecture", description: "Start here to understand how Swiftlets is fundamentally different", href: "/docs/concepts/architecture")
                    learningStep(number: "2", title: "Routing", description: "Learn how file paths become URLs and how routing works", href: "/docs/concepts/routing")
                    learningStep(number: "3", title: "HTML DSL", description: "Master the SwiftUI-inspired syntax for building pages", href: "/docs/concepts/html-dsl")
                    learningStep(number: "4", title: "Request & Response", description: "Handle dynamic data and user interactions", href: "/docs/concepts/request-response")
                }
            }
        }
        .style("background", "linear-gradient(135deg, #667eea 0%, #764ba2 100%)")
        .style("padding", "4rem 2rem")
        .style("border-radius", "24px")
        .style("color", "white")
    }
    
    @HTMLBuilder
    func learningStep(number: String, title: String, description: String, href: String) -> some HTMLElement {
        Link(href: href) {
            HStack(spacing: 20) {
                Div {
                    Text(number)
                        .style("font-size", "1.5rem")
                        .style("font-weight", "800")
                }
                .style("width", "60px")
                .style("height", "60px")
                .style("background", "rgba(255, 255, 255, 0.2)")
                .style("border-radius", "16px")
                .style("display", "flex")
                .style("align-items", "center")
                .style("justify-content", "center")
                .style("flex-shrink", "0")
                
                VStack(spacing: 5) {
                    H3(title)
                        .style("margin", "0")
                        .style("font-size", "1.25rem")
                        .style("color", "white")
                    P(description)
                        .style("margin", "0")
                        .style("opacity", "0.9")
                        .style("font-size", "0.95rem")
                }
                .style("text-align", "left")
                
                Div {
                    Text("→")
                        .style("font-size", "1.5rem")
                        .style("opacity", "0.7")
                }
                .style("margin-left", "auto")
            }
            .class("learning-step")
            .style("background", "rgba(255, 255, 255, 0.1)")
            .style("padding", "1.5rem")
            .style("border-radius", "16px")
            .style("border", "2px solid rgba(255, 255, 255, 0.2)")
            .style("transition", "all 0.3s ease")
            .style("align-items", "center")
        }
        .style("text-decoration", "none")
        .style("color", "white")
        .style("display", "block")
    }
    
    @HTMLBuilder
    func keyPrinciples() -> some HTMLElement {
        Section {
            VStack(spacing: 30) {
                H2("Key Principles")
                    .style("font-size", "2rem")
                    .style("font-weight", "700")
                    .style("text-align", "center")
                
                Grid(columns: .count(3), spacing: 30) {
                    principleCard(icon: "🏝️", title: "True Isolation", description: "Each route is a separate process. No shared state, no memory leaks, no cascading failures.")
                    principleCard(icon: "🚀", title: "Hot Reload", description: "Changes take effect immediately without restarting the server or losing state.")
                    principleCard(icon: "🎯", title: "Simplicity", description: "No complex abstractions. Just Swift code that produces HTML.")
                    principleCard(icon: "🔒", title: "Security", description: "Process isolation provides natural security boundaries between routes.")
                    principleCard(icon: "🌈", title: "Language Freedom", description: "Mix Swift, Python, Ruby, or any language that can produce HTML.")
                    principleCard(icon: "⚡", title: "Performance", description: "Efficient process pooling and caching for production workloads.")
                }
            }
        }
    }
    
    @HTMLBuilder
    func principleCard(icon: String, title: String, description: String) -> some HTMLElement {
        Div {
            VStack(spacing: 15) {
                Text(icon)
                    .style("font-size", "2.5rem")
                H3(title)
                    .style("margin", "0")
                    .style("font-size", "1.125rem")
                P(description)
                    .style("margin", "0")
                    .style("color", "#718096")
                    .style("font-size", "0.95rem")
                    .style("line-height", "1.6")
            }
        }
        .style("text-align", "center")
        .style("padding", "1.5rem")
    }
    
    @HTMLBuilder
    func footer() -> some HTMLElement {
        Footer {
            Container(maxWidth: .large) {
                VStack(spacing: 40) {
                    // Main footer content
                    Grid(columns: .count(4), spacing: 40) {
                        VStack(spacing: 15) {
                            H4("Swiftlets")
                                .style("margin", "0")
                            P("A revolutionary approach to building web applications with Swift")
                                .style("margin", "0")
                                .style("color", "#718096")
                                .style("font-size", "0.875rem")
                        }
                        
                        VStack(spacing: 15) {
                            H4("Documentation")
                                .style("margin", "0")
                            VStack(spacing: 10) {
                                Link(href: "/docs/getting-started", "Getting Started")
                                Link(href: "/docs/concepts", "Core Concepts")
                                Link(href: "/docs/api", "API Reference")
                            }
                        }
                        .style("font-size", "0.875rem")
                        
                        VStack(spacing: 15) {
                            H4("Community")
                                .style("margin", "0")
                            VStack(spacing: 10) {
                                Link(href: "https://github.com/codelynx/swiftlets", "GitHub")
                                    .attribute("target", "_blank")
                                Link(href: "/showcase", "Examples")
                                Link(href: "/about", "About")
                            }
                        }
                        .style("font-size", "0.875rem")
                        
                        VStack(spacing: 15) {
                            H4("Resources")
                                .style("margin", "0")
                            VStack(spacing: 10) {
                                Link(href: "/docs/troubleshooting", "Troubleshooting")
                                Link(href: "/docs/faq", "FAQ")
                                Link(href: "/docs/changelog", "Changelog")
                            }
                        }
                        .style("font-size", "0.875rem")
                    }
                    
                    // Bottom bar
                    Div {
                        HStack {
                            P("© 2025 Swiftlets Project. MIT Licensed.")
                                .style("margin", "0")
                                .style("color", "#718096")
                                .style("font-size", "0.875rem")
                            Spacer()
                            P("Built with ❤️ using Swiftlets")
                                .style("margin", "0")
                                .style("color", "#718096")
                                .style("font-size", "0.875rem")
                        }
                        .style("align-items", "center")
                    }
                    .style("padding-top", "2rem")
                    .style("border-top", "1px solid #e2e8f0")
                }
            }
        }
        .style("background", "#f7fafc")
        .style("padding", "4rem 0 2rem 0")
        .style("margin-top", "5rem")
    }
}