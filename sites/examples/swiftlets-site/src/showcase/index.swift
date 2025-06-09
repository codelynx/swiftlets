import Swiftlets

@main
struct ShowcasePage: SwiftletMain {
    var title = "Showcase - Swiftlets"
    var meta = [
        "description": "Explore the components and layouts available in Swiftlets",
        "viewport": "width=device-width, initial-scale=1.0"
    ]
    
    var body: some HTMLElement {
        Div {
            // Navigation
            Div {
                Div {
                    Link(href: "/", "Swiftlets")
                        .class("nav-brand")
                    Div {
                        Link(href: "/docs", "Documentation")
                        Link(href: "/showcase", "Showcase")
                            .class("active")
                        Link(href: "/about", "About")
                        Link(href: "https://github.com/swiftlets/swiftlets", "GitHub")
                            .attribute("target", "_blank")
                    }
                    .class("nav-links")
                }
                .class("nav-content")
            }
            .class("nav-container")
            
            // Header
            Div {
                Div {
                    H1("Component Showcase")
                    P("Explore the components and layouts available in Swiftlets")
                        .style("font-size", "1.25rem")
                        .style("color", "#6c757d")
                }
                .class("showcase-container")
                .style("text-align", "center")
            }
            .class("showcase-header")
            
            // Main Content
            Div {
                Div {
                    // Category Navigation
                    Section {
                        H2("HTML Element Categories")
                        P("Browse comprehensive examples showing Swift DSL code and generated HTML")
                        
                        Grid(columns: .count(3), spacing: 20) {
                            CategoryCard(
                                title: "Basic Elements",
                                description: "Headings, paragraphs, divs, spans, links, and more",
                                href: "/showcase/basic-elements",
                                icon: "📝"
                            ).render()
                            
                            CategoryCard(
                                title: "Text Formatting",
                                description: "Bold, italic, code, quotes, and text styling",
                                href: "/showcase/text-formatting",
                                icon: "✨"
                            ).render()
                            
                            CategoryCard(
                                title: "Lists",
                                description: "Ordered, unordered, and definition lists",
                                href: "/showcase/lists",
                                icon: "📋"
                            ).render()
                            
                            CategoryCard(
                                title: "Tables",
                                description: "Table structures with headers, bodies, and styling",
                                href: "/showcase/tables",
                                icon: "📊"
                            ).render()
                            
                            CategoryCard(
                                title: "Forms",
                                description: "Input fields, buttons, selects, and form layouts",
                                href: "/showcase/forms",
                                icon: "📝"
                            ).render()
                            
                            CategoryCard(
                                title: "Media",
                                description: "Images, videos, audio, and embedded content",
                                href: "/showcase/media",
                                icon: "🖼️"
                            ).render()
                            
                            CategoryCard(
                                title: "Semantic HTML",
                                description: "Header, footer, nav, article, section, and more",
                                href: "/showcase/semantic-html",
                                icon: "🏗️"
                            ).render()
                            
                            CategoryCard(
                                title: "Layout Components",
                                description: "HStack, VStack, Grid, Container, and spacing",
                                href: "/showcase/layout-components",
                                icon: "📐"
                            ).render()
                            
                            CategoryCard(
                                title: "Modifiers",
                                description: "Classes, styles, attributes, and chaining",
                                href: "/showcase/modifiers",
                                icon: "🎨"
                            ).render()
                            
                            CategoryCard(
                                title: "SwiftUI-Style API",
                                description: "Build components with HTMLComponent protocol",
                                href: "/showcase/swiftui-style",
                                icon: "🚀"
                            ).render()
                            
                            CategoryCard(
                                title: "API Demo (@main)",
                                description: "Interactive demo of the new @main API with property wrappers",
                                href: "/showcase/api-demo",
                                icon: "✨"
                            ).render()
                        }
                    }
                    
                    // Quick Examples
                    Section {
                        H2("Quick Examples")
                        
                        VStack(spacing: 30) {
                            // HStack Example
                            ExamplePreview(
                                title: "HStack",
                                description: "Horizontal stack with spacing",
                                code: """
                                HStack(spacing: 20) {
                                    Button("Button 1")
                                    Button("Button 2")
                                    Button("Button 3")
                                }
                                """
                            ) {
                                HStack(spacing: 20) {
                                    Button("Button 1")
                                    Button("Button 2")
                                    Button("Button 3")
                                }
                                .style("padding", "1rem")
                                .style("background", "#f8f9fa")
                                .style("border-radius", "0.5rem")
                            }
                            
                            // Grid Example
                            ExamplePreview(
                                title: "Grid",
                                description: "Responsive grid layout",
                                code: """
                                Grid(columns: .count(3), spacing: 20) {
                                    ForEach(1...6) { i in
                                        Card(number: i)
                                    }
                                }
                                """
                            ) {
                                Grid(columns: .count(3), spacing: 20) {
                                    ForEach(1...6) { i in
                                        Div {
                                            H4("Card \(i)")
                                            P("This is a sample card component")
                                        }
                                        .style("padding", "1.5rem")
                                        .style("background", "white")
                                        .style("border", "1px solid #dee2e6")
                                        .style("border-radius", "0.5rem")
                                        .style("box-shadow", "0 1px 3px rgba(0,0,0,0.1)")
                                    }
                                }
                            }
                        }
                    }
                    .style("margin-top", "4rem")
                }
                .class("showcase-container")
            }
            .class("showcase-content")
            
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
}

// Reusable Components

struct CategoryCard: HTMLComponent {
    let title: String
    let description: String
    let href: String
    let icon: String
    
    var body: some HTMLElement {
        Link(href: href) {
            Div {
                VStack(spacing: 15) {
                    Text(icon)
                        .style("font-size", "3rem")
                        .style("text-align", "center")
                    H3(title)
                        .style("margin", "0")
                    P(description)
                        .style("color", "#6c757d")
                        .style("margin", "0")
                }
            }
            .style("padding", "2rem")
            .style("height", "100%")
            .style("transition", "transform 0.2s")
            .class("category-card")
        }
        .style("text-decoration", "none")
        .style("color", "inherit")
    }
}

struct ExamplePreview<Content: HTMLElement>: HTMLComponent {
    let title: String
    let description: String
    let code: String
    let demo: Content
    
    init(title: String, description: String, code: String, @HTMLBuilder demo: () -> Content) {
        self.title = title
        self.description = description
        self.code = code
        self.demo = demo()
    }
    
    var body: some HTMLElement {
        Div {
            H3(title)
            P(description)
            
            Div {
                H4("Code:")
                    .style("margin-bottom", "0.5rem")
                Pre {
                    Code(code)
                }
                .class("language-swift")
            }
            
            Div {
                H4("Result:")
                    .style("margin-bottom", "0.5rem")
                demo
            }
        }
    }
}