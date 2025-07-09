import Swiftlets

@main
struct HomePage: SwiftletMain {
    var title = "Swiftlets - Swift Web Framework"
    var meta = [
        "description": "Build modern web applications with Swift and SwiftUI-like syntax",
        "viewport": "width=device-width, initial-scale=1.0"
    ]
    
    var body: some HTMLElement {
        Fragment {
            navigationBar()
            mainContent()
            footer()
        }
    }
    
    @HTMLBuilder
    func navigationBar() -> some HTMLElement {
        Nav {
            Div {
                Link(href: "/") {
                    H1("Swiftlets")
                }
                .style("margin", "0")
                
                Div {
                    Link(href: "/docs", "Documentation")
                        .style("margin-right", "20px")
                    Link(href: "/showcase", "Showcase")
                        .style("margin-right", "20px")
                    Link(href: "/about", "About")
                        .style("margin-right", "20px")
                    Link(href: "https://github.com/codelynx/swiftlets", "GitHub")
                        .attribute("target", "_blank")
                }
            }
            .style("display", "flex")
            .style("justify-content", "space-between")
            .style("align-items", "center")
            .style("max-width", "1200px")
            .style("margin", "0 auto")
            .style("padding", "0 20px")
        }
        .style("background", "#fff")
        .style("padding", "1rem 0")
        .style("box-shadow", "0 2px 4px rgba(0,0,0,0.1)")
    }
    
    @HTMLBuilder
    func mainContent() -> some HTMLElement {
        Main {
            heroSection()
            developmentNotice()
            featuresSection()
        }
    }
    
    @HTMLBuilder
    func heroSection() -> some HTMLElement {
        Section {
            Div {
                H1("Build Swift Web Apps")
                    .style("font-size", "3.5rem")
                    .style("margin", "0 0 1rem 0")
                
                P("Modern web development with SwiftUI-like syntax")
                    .style("font-size", "1.5rem")
                    .style("margin-bottom", "2rem")
                
                Div {
                    Link(href: "/docs/getting-started", "Get Started →")
                        .style("padding", "0.75rem 2rem")
                        .style("background", "white")
                        .style("color", "#667eea")
                        .style("border-radius", "8px")
                        .style("text-decoration", "none")
                        .style("font-weight", "600")
                        .style("margin-right", "1rem")
                    
                    Link(href: "/showcase", "View Examples")
                        .style("padding", "0.75rem 2rem")
                        .style("background", "transparent")
                        .style("color", "white")
                        .style("border", "2px solid white")
                        .style("border-radius", "8px")
                        .style("text-decoration", "none")
                        .style("font-weight", "600")
                }
            }
            .style("max-width", "1024px")
            .style("margin", "0 auto")
            .style("text-align", "center")
            .style("padding", "0 20px")
        }
        .style("padding", "5rem 0")
        .style("background", "linear-gradient(135deg, #667eea 0%, #764ba2 100%)")
        .style("color", "white")
    }
    
    @HTMLBuilder
    func developmentNotice() -> some HTMLElement {
        Section {
            Div {
                Div {
                    Text("🚧 ")
                    Strong("Development Status: ")
                    Text("Swiftlets is under active development and not ready for production use.")
                }
                .style("margin-bottom", "0.5rem")
                
                P {
                    Text("We're building something special and would love your feedback! ")
                    Link(href: "https://github.com/codelynx/swiftlets", "Join us on GitHub")
                        .style("color", "#667eea")
                        .style("font-weight", "600")
                    Text(" to contribute, report issues, or share ideas.")
                }
                .style("margin", "0")
            }
            .style("background", "#fef3c7")
            .style("border", "1px solid #fbbf24")
            .style("border-radius", "8px")
            .style("padding", "1.5rem")
            .style("max-width", "1024px")
            .style("margin", "0 auto")
        }
        .style("padding", "2rem 20px")
    }
    
    @HTMLBuilder
    func featuresSection() -> some HTMLElement {
        Section {
            Div {
                H2("Why Swiftlets?")
                    .style("text-align", "center")
                    .style("font-size", "2.5rem")
                    .style("margin-bottom", "3rem")
                
                Div {
                    featureCard(icon: "🚀", title: "Blazing Fast", description: "Compiled Swift performance with zero JavaScript overhead")
                    featureCard(icon: "🎨", title: "SwiftUI-like Syntax", description: "Familiar declarative API for Swift developers")
                    featureCard(icon: "🔧", title: "Type-Safe", description: "Catch errors at compile time, not runtime")
                    featureCard(icon: "📦", title: "No Build Step", description: "Just write Swift and run - no webpack or bundlers")
                    featureCard(icon: "🌍", title: "SEO Friendly", description: "Server-side rendering for perfect SEO scores")
                    featureCard(icon: "⚡", title: "Hot Reload", description: "See changes instantly during development")
                }
                .style("display", "grid")
                .style("grid-template-columns", "repeat(auto-fit, minmax(300px, 1fr))")
                .style("gap", "2rem")
            }
            .style("max-width", "1024px")
            .style("margin", "0 auto")
            .style("padding", "0 20px")
        }
        .style("padding", "5rem 0")
    }
    
    @HTMLBuilder
    func featureCard(icon: String, title: String, description: String) -> some HTMLElement {
        Div {
            Text(icon)
                .style("font-size", "3rem")
                .style("margin-bottom", "1rem")
            
            H3(title)
                .style("margin", "0 0 0.5rem 0")
                .style("font-size", "1.25rem")
            
            P(description)
                .style("margin", "0")
                .style("color", "#718096")
                .style("line-height", "1.6")
        }
        .style("text-align", "center")
        .style("padding", "2rem")
        .style("background", "#f7fafc")
        .style("border-radius", "12px")
    }
    
    @HTMLBuilder
    func footer() -> some HTMLElement {
        Footer {
            Div {
                Div {
                    Text("© 2025 Swiftlets. Built with Swift.")
                    .style("margin-bottom", "0.5rem")
                    
                    Div {
                        Link(href: "/docs", "Documentation")
                            .style("color", "#cbd5e0")
                            .style("margin-right", "20px")
                        Link(href: "https://github.com/codelynx/swiftlets", "GitHub")
                            .style("color", "#cbd5e0")
                            .style("margin-right", "20px")
                        Link(href: "/about", "About")
                            .style("color", "#cbd5e0")
                    }
                }
                .style("text-align", "center")
            }
            .style("max-width", "1024px")
            .style("margin", "0 auto")
            .style("padding", "0 20px")
        }
        .style("background", "#2d3748")
        .style("color", "#e2e8f0")
        .style("padding", "2rem 0")
        .style("margin-top", "5rem")
    }
}