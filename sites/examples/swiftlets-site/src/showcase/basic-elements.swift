import Swiftlets

@main
struct BasicElementsShowcase: SwiftletMain {
    var title = "Basic HTML Elements - Swiftlets Showcase"
    var meta = ["description": "Examples of basic HTML elements in Swiftlets"]
    
    var body: some HTMLElement {
        Div {
            // Navigation
            NavigationBar()
            
            // Header
            Container(maxWidth: .large) {
                VStack(spacing: 30) {
                    H1("Basic HTML Elements")
                        .style("margin-top", "2rem")
                    
                    P("Examples of fundamental HTML elements with their Swiftlets syntax")
                        .style("font-size", "1.25rem")
                        .style("color", "#6c757d")
                    
                    // Headings Section
                    ShowcaseSection(title: "Headings") {
                        VStack(spacing: 20) {
                            ShowcaseExample(
                                title: "All Heading Levels",
                                code: """
                                H1("Heading Level 1")
                                H2("Heading Level 2")
                                H3("Heading Level 3")
                                H4("Heading Level 4")
                                H5("Heading Level 5")
                                H6("Heading Level 6")
                                """
                            ) {
                                VStack(spacing: 10) {
                                    H1("Heading Level 1")
                                    H2("Heading Level 2")
                                    H3("Heading Level 3")
                                    H4("Heading Level 4")
                                    H5("Heading Level 5")
                                    H6("Heading Level 6")
                                }
                            }
                        }
                    }
                    
                    // Paragraphs Section
                    ShowcaseSection(title: "Paragraphs & Text") {
                        VStack(spacing: 20) {
                            ShowcaseExample(
                                title: "Basic Paragraph",
                                code: """
                                P("This is a paragraph with some text content.")
                                """
                            ) {
                                P("This is a paragraph with some text content.")
                            }
                            
                            ShowcaseExample(
                                title: "Multiple Paragraphs",
                                code: """
                                P("First paragraph with some introductory text.")
                                P("Second paragraph that continues the narrative.")
                                """
                            ) {
                                VStack(spacing: 10) {
                                    P("First paragraph with some introductory text.")
                                    P("Second paragraph that continues the narrative.")
                                }
                            }
                        }
                    }
                    
                    // Links Section
                    ShowcaseSection(title: "Links") {
                        VStack(spacing: 20) {
                            ShowcaseExample(
                                title: "Basic Link",
                                code: """
                                Link(href: "https://example.com", "Visit Example")
                                """
                            ) {
                                Link(href: "https://example.com", "Visit Example")
                            }
                            
                            ShowcaseExample(
                                title: "Link with Target",
                                code: """
                                Link(href: "https://github.com", "Open GitHub")
                                    .attr("target", "_blank")
                                """
                            ) {
                                Link(href: "https://github.com", "Open GitHub")
                                    .attr("target", "_blank")
                            }
                        }
                    }
                    
                    // Divs and Spans Section
                    ShowcaseSection(title: "Containers") {
                        VStack(spacing: 20) {
                            ShowcaseExample(
                                title: "Div Container",
                                code: """
                                Div {
                                    H3("Inside a Div")
                                    P("Content within a div container")
                                }
                                .style("padding", "1rem")
                                .style("background", "#f8f9fa")
                                """
                            ) {
                                Div {
                                    H3("Inside a Div")
                                    P("Content within a div container")
                                }
                                .style("padding", "1rem")
                                .style("background", "#f8f9fa")
                                .style("border-radius", "0.5rem")
                            }
                            
                            ShowcaseExample(
                                title: "Inline Span",
                                code: """
                                P {
                                    Text("This is ")
                                    Span("highlighted")
                                        .style("color", "#007bff")
                                        .style("font-weight", "bold")
                                    Text(" text.")
                                }
                                """
                            ) {
                                P {
                                    Text("This is ")
                                    Span("highlighted")
                                        .style("color", "#007bff")
                                        .style("font-weight", "bold")
                                    Text(" text.")
                                }
                            }
                        }
                    }
                }
                .style("padding-bottom", "4rem")
            }
        }
    }
}

// Reusable Components
struct NavigationBar: HTMLComponent {
    var body: some HTMLElement {
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
    }
}

struct ShowcaseSection<Content: HTMLElement>: HTMLComponent {
    let title: String
    let content: Content
    
    init(title: String, @HTMLBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some HTMLElement {
        Section {
            VStack(spacing: 20) {
                H2(title)
                    .style("margin-top", "3rem")
                content
            }
        }
    }
}

struct ShowcaseExample<DemoContent: HTMLElement>: HTMLComponent {
    let title: String
    let code: String
    let demo: DemoContent
    
    init(title: String, code: String, @HTMLBuilder demo: () -> DemoContent) {
        self.title = title
        self.code = code
        self.demo = demo()
    }
    
    var body: some HTMLElement {
        Div {
            VStack(spacing: 15) {
                H4(title)
                
                Grid(columns: .count(2), spacing: 20) {
                    Div {
                        H5("Code")
                            .style("margin-bottom", "0.5rem")
                            .style("color", "#6c757d")
                        Pre {
                            Code(code)
                        }
                        .class("language-swift")
                        .style("margin", "0")
                    }
                    
                    Div {
                        H5("Result")
                            .style("margin-bottom", "0.5rem")
                            .style("color", "#6c757d")
                        Div {
                            demo
                        }
                        .style("padding", "1rem")
                        .style("background", "#f8f9fa")
                        .style("border", "1px solid #dee2e6")
                        .style("border-radius", "0.375rem")
                    }
                }
            }
        }
        .style("padding", "1.5rem")
        .style("background", "white")
        .style("border", "1px solid #e2e8f0")
        .style("border-radius", "0.5rem")
        .style("margin-bottom", "1rem")
    }
}