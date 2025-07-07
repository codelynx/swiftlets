import Swiftlets

@main
struct ArchitecturePage: SwiftletMain {
    var title = "Architecture - Swiftlets"
    
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
                        Link(href: "/docs/concepts", "Core Concepts")
                            .style("color", "#667eea")
                        Text("→")
                            .style("color", "#a0aec0")
                        Text("Architecture")
                            .style("font-weight", "600")
                    }
                    .class("breadcrumb")
                    .style("font-size", "0.875rem")
                    
                    // Hero Content
                    VStack(spacing: 20) {
                        H1("How Swiftlets Works")
                            .style("font-size", "3rem")
                            .style("font-weight", "800")
                            .style("background", "linear-gradient(135deg, #667eea 0%, #764ba2 100%)")
                            .style("-webkit-background-clip", "text")
                            .style("-webkit-text-fill-color", "transparent")
                            .style("margin", "0")
                        
                        P("A revolutionary architecture that treats each route as an independent executable")
                            .style("font-size", "1.375rem")
                            .style("color", "#4a5568")
                            .style("max-width", "700px")
                            .style("margin", "0 auto")
                            .style("text-align", "center")
                    }
                    .style("text-align", "center")
                }
            }
        }
        .style("padding", "3rem 0")
        .style("background", "linear-gradient(180deg, #ffffff 0%, #f7fafc 100%)")
    }
    
    @HTMLBuilder
    func mainContent() -> some HTMLElement {
        Container(maxWidth: .large) {
            VStack(spacing: 60) {
                // Introduction
                introSection()
                
                // Architecture Diagram
                architectureDiagram()
                
                // Key Components
                keyComponents()
                
                // Benefits
                benefitsSection()
            }
        }
        .style("padding", "3rem 0 5rem 0")
    }
    
    @HTMLBuilder
    func introSection() -> some HTMLElement {
        VStack(spacing: 20) {
            P("Swiftlets takes a unique approach to web development: each route in your application is a standalone Swift executable. This might sound unusual at first, but it provides remarkable benefits.")
                .style("font-size", "1.25rem")
                .style("line-height", "1.8")
                .style("color", "#2d3748")
                
            Div {
                P("💡 Unlike traditional web frameworks that run everything in a single process, Swiftlets gives each route its own isolated environment.")
                    .style("margin", "0")
            }
            .style("background", "linear-gradient(135deg, #667eea15 0%, #764ba215 100%)")
            .style("border-left", "4px solid #667eea")
            .style("padding", "1.5rem")
            .style("border-radius", "8px")
        }
    }
    
    @HTMLBuilder
    func architectureDiagram() -> some HTMLElement {
        Section {
            VStack(spacing: 30) {
                H2("Architecture Overview")
                    .style("font-size", "2rem")
                    .style("font-weight", "700")
                    .style("text-align", "center")
                
                // Visual representation
                Div {
                    VStack(spacing: 30) {
                        // Web Server
                        Div {
                            VStack(spacing: 10) {
                                Text("🌐")
                                    .style("font-size", "2rem")
                                H3("Web Server")
                                    .style("margin", "0")
                                P("Routes requests to executables")
                                    .style("margin", "0")
                                    .style("color", "#718096")
                                    .style("font-size", "0.875rem")
                            }
                        }
                        .style("background", "white")
                        .style("padding", "2rem")
                        .style("border", "2px solid #e2e8f0")
                        .style("border-radius", "12px")
                        .style("text-align", "center")
                        
                        // Arrow
                        Text("↓")
                            .style("font-size", "2rem")
                            .style("color", "#667eea")
                            .style("text-align", "center")
                        
                        // Executables
                        Grid(columns: .count(3), spacing: 20) {
                            executableCard(emoji: "🏠", name: "index", path: "/")
                            executableCard(emoji: "📖", name: "about", path: "/about")
                            executableCard(emoji: "📞", name: "contact", path: "/contact")
                        }
                    }
                }
                .style("background", "#f7fafc")
                .style("padding", "3rem")
                .style("border-radius", "16px")
            }
        }
    }
    
    @HTMLBuilder
    func executableCard(emoji: String, name: String, path: String) -> some HTMLElement {
        Div {
            VStack(spacing: 10) {
                Text(emoji)
                    .style("font-size", "2rem")
                Code(name)
                    .style("font-size", "0.875rem")
                    .style("background", "#edf2f7")
                    .style("padding", "0.25rem 0.5rem")
                    .style("border-radius", "4px")
                Text(path)
                    .style("font-size", "0.75rem")
                    .style("color", "#718096")
            }
        }
        .style("background", "white")
        .style("padding", "1.5rem")
        .style("border", "2px solid #e2e8f0")
        .style("border-radius", "12px")
        .style("text-align", "center")
    }
    
    @HTMLBuilder
    func keyComponents() -> some HTMLElement {
        Section {
            VStack(spacing: 30) {
                H2("Key Components")
                    .style("font-size", "2rem")
                    .style("font-weight", "700")
                
                Grid(columns: .count(2), spacing: 30) {
                    simpleComponentCard(
                        title: "Web Server",
                        icon: "🌐",
                        description: "Routes requests to executables based on URL patterns"
                    )
                    
                    simpleComponentCard(
                        title: "Build System",
                        icon: "🔨",
                        description: "Compiles Swift files into standalone executables"
                    )
                    
                    simpleComponentCard(
                        title: "Swiftlets",
                        icon: "🚀",
                        description: "Independent executables handling specific routes"
                    )
                    
                    simpleComponentCard(
                        title: "HTML DSL",
                        icon: "🎨",
                        description: "SwiftUI-style syntax for building type-safe HTML"
                    )
                }
            }
        }
    }
    
    @HTMLBuilder
    func simpleComponentCard(title: String, icon: String, description: String) -> some HTMLElement {
        Div {
            VStack(spacing: 15) {
                Text(icon)
                    .style("font-size", "2.5rem")
                H3(title)
                    .style("margin", "0")
                P(description)
                    .style("margin", "0")
                    .style("color", "#718096")
            }
        }
        .style("background", "white")
        .style("padding", "2rem")
        .style("border", "1px solid #e2e8f0")
        .style("border-radius", "12px")
        .style("text-align", "center")
    }
    
    @HTMLBuilder
    func benefitsSection() -> some HTMLElement {
        Section {
            VStack(spacing: 30) {
                H2("Why This Architecture?")
                    .style("font-size", "2rem")
                    .style("font-weight", "700")
                    .style("text-align", "center")
                
                VStack(spacing: 20) {
                    P("✓ Hot reload that actually works")
                        .style("font-size", "1.125rem")
                    P("✓ Perfect isolation between routes")
                        .style("font-size", "1.125rem")
                    P("✓ Independent scaling and optimization")
                        .style("font-size", "1.125rem")
                    P("✓ Simple debugging and testing")
                        .style("font-size", "1.125rem")
                }
            }
        }
    }
    
    @HTMLBuilder
    func footer() -> some HTMLElement {
        Footer {
            Container(maxWidth: .large) {
                HStack {
                    P("© 2025 Swiftlets Project")
                        .style("margin", "0")
                        .style("color", "#718096")
                    Spacer()
                    HStack(spacing: 20) {
                        Link(href: "/docs/concepts", "← Back to Concepts")
                            .style("color", "#667eea")
                        Link(href: "/docs/concepts/routing", "Next: Routing →")
                            .style("color", "#667eea")
                    }
                }
                .style("align-items", "center")
            }
        }
        .style("padding", "2rem 0")
        .style("border-top", "1px solid #e2e8f0")
        .style("margin-top", "3rem")
    }
}
