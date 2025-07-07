import Swiftlets

@main
struct ShowcasePage: SwiftletMain {
    var title = "Showcase - Swiftlets"
    var stylesheets = ["/styles/showcase.css", "/styles/main.css"]
    var meta = [
        "description": "Explore the modern components and layouts available in Swiftlets",
        "viewport": "width=device-width, initial-scale=1.0"
    ]
    
    var body: some HTMLElement {
        Fragment {
            showcaseNav()
            showcaseHero(
                title: "Component Showcase",
                subtitle: "Explore beautiful, modern components built with Swiftlets",
                ctaText: "View Documentation",
                ctaHref: "/docs"
            )
            mainContent()
            showcaseFooter()
        }
    }
    
    // Break down main content into smaller functions
    @HTMLBuilder
    func mainContent() -> some HTMLElement {
        Main {
            elementCategories()
            quickExamples()
        }
    }
    
    @HTMLBuilder
    func elementCategories() -> some HTMLElement {
        featureSection(
            title: "Browse by Category",
            description: "Comprehensive examples with Swift DSL code and live previews"
        ) {
            Div {
                categoryGrid()
            }
            .class("feature-grid")
        }
    }
    
    @HTMLBuilder
    func categoryGrid() -> some HTMLElement {
        Fragment {
            showcaseCard(
                title: "Basic Elements",
                description: "Headings, paragraphs, divs, spans, links, and more",
                href: "/showcase/basic-elements",
                icon: "📝",
                tags: ["HTML", "Fundamentals"]
            )
            
            showcaseCard(
                title: "Text Formatting",
                description: "Bold, italic, code, quotes, and advanced text styling",
                href: "/showcase/text-formatting",
                icon: "✨",
                tags: ["Typography", "Styling"]
            )
            
            showcaseCard(
                title: "Lists & Tables",
                description: "Ordered, unordered, definition lists, and tables",
                href: "/showcase/list-examples",
                icon: "📋",
                tags: ["Structure", "Data"]
            )
            
            showcaseCard(
                title: "Forms & Inputs",
                description: "All input types, validation, and form elements",
                href: "/showcase/forms",
                icon: "📝",
                tags: ["Interactive", "Forms"]
            )
            
            showcaseCard(
                title: "Media Elements",
                description: "Images, audio, video, and embedded content",
                href: "/showcase/media-elements",
                icon: "🎬",
                tags: ["Media", "Embed"]
            )
            
            showcaseCard(
                title: "Layout Components",
                description: "HStack, VStack, Grid, and responsive layouts",
                href: "/showcase/layout-components",
                icon: "🏗️",
                tags: ["Layout", "Responsive"]
            )
            
            showcaseCard(
                title: "Semantic HTML",
                description: "Header, footer, article, section, and more",
                href: "/showcase/semantic-html",
                icon: "🏷️",
                tags: ["Semantic", "Structure"]
            )
            
            showcaseCard(
                title: "Modifiers & Styling",
                description: "Classes, IDs, attributes, and style modifiers",
                href: "/showcase/modifiers",
                icon: "🎨",
                tags: ["Styling", "CSS"]
            )
            
            showcaseCard(
                title: "SwiftUI-Style API",
                description: "Modern @main API with property wrappers",
                href: "/showcase/swiftui-style",
                icon: "🚀",
                tags: ["API", "SwiftUI"]
            )
        }
    }
    
    @HTMLBuilder
    func quickExamples() -> some HTMLElement {
        featureSection(title: "Quick Examples") {
            VStack(spacing: 40) {
                gridExample()
                stackExample()
                formExample()
            }
        }
    }
    
    @HTMLBuilder
    func gridExample() -> some HTMLElement {
        liveExample(
            title: "Responsive Grid Layout",
            code: """
            Grid(columns: .count(3), spacing: 20) {
                ForEach(1...6) { i in
                    Div {
                        H4("Item \\(i)")
                        P("Grid item content")
                    }
                    .class("showcase-card")
                }
            }
            """
        ) {
            Grid(columns: .count(3), spacing: 20) {
                ForEach(1...6) { i in
                    Div {
                        H4("Item \(i)")
                        P("Grid item content")
                    }
                    .style("padding", "1.5rem")
                    .style("background", "white")
                    .style("border-radius", "0.5rem")
                    .style("box-shadow", "0 2px 4px rgba(0,0,0,0.1)")
                }
            }
        }
    }
    
    @HTMLBuilder
    func stackExample() -> some HTMLElement {
        liveExample(
            title: "HStack with Spacing",
            code: """
            HStack(spacing: 20) {
                Button("Primary")
                    .class("btn-modern")
                Button("Secondary")
                    .style("padding", "0.75rem 2rem")
                Button("Tertiary")
                    .style("padding", "0.75rem 2rem")
            }
            """
        ) {
            HStack(spacing: 20) {
                Button("Primary")
                    .class("btn-modern")
                Button("Secondary")
                    .style("padding", "0.75rem 2rem")
                    .style("border", "2px solid #667eea")
                    .style("background", "transparent")
                    .style("color", "#667eea")
                    .style("border-radius", "0.5rem")
                    .style("font-weight", "500")
                Button("Tertiary")
                    .style("padding", "0.75rem 2rem")
                    .style("background", "#f8f9fa")
                    .style("color", "#6c757d")
                    .style("border-radius", "0.5rem")
                    .style("font-weight", "500")
            }
        }
    }
    
    @HTMLBuilder
    func formExample() -> some HTMLElement {
        liveExample(
            title: "Modern Form Elements",
            code: """
            VStack(spacing: 16) {
                Input(type: "text", placeholder: "Enter your name")
                    .style("padding", "0.75rem")
                    .style("border-radius", "0.5rem")
                Input(type: "email", placeholder: "Enter your email")
                    .style("padding", "0.75rem")
                    .style("border-radius", "0.5rem")
                Button("Submit")
                    .class("btn-modern")
            }
            """
        ) {
            VStack(alignment: .stretch, spacing: 16) {
                Input(type: "text", placeholder: "Enter your name")
                    .style("padding", "0.75rem")
                    .style("border", "2px solid #e9ecef")
                    .style("border-radius", "0.5rem")
                    .style("font-size", "1rem")
                Input(type: "email", placeholder: "Enter your email")
                    .style("padding", "0.75rem")
                    .style("border", "2px solid #e9ecef")
                    .style("border-radius", "0.5rem")
                    .style("font-size", "1rem")
                Button("Submit")
                    .class("btn-modern")
                    .style("width", "100%")
            }
            .style("max-width", "400px")
        }
    }
}