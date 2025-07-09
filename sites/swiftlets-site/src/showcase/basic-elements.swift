import Swiftlets

@main
struct BasicElementsShowcase: SwiftletMain {
    var title = "Basic HTML Elements - Swiftlets Showcase"
    
    var body: some HTMLElement {
        Fragment {
            showcaseStyles()
            showcaseNav()
            pageHeader()
            mainContent()
            showcaseFooter()
        }
    }
    
    @HTMLBuilder
    func showcaseStyles() -> some HTMLElement {
        Style("""
        body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; }
        
        .nav-modern {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            box-shadow: 0 2px 4px rgba(0,0,0,0.06);
            position: sticky;
            top: 0;
            z-index: 100;
        }
        
        .showcase-hero {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 5rem 0;
            text-align: center;
        }
        
        .showcase-hero h1 {
            font-size: 3.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
        }
        
        .showcase-hero p {
            font-size: 1.5rem;
            opacity: 0.9;
        }
        
        .showcase-section {
            padding: 4rem 0;
        }
        
        .showcase-section h2 {
            color: #2c3e50;
            margin-bottom: 2rem;
        }
        
        .code-example {
            background: #f8f9fa;
            border-radius: 0.75rem;
            padding: 2rem;
            margin: 2rem 0;
        }
        
        .code-example h3 {
            color: #2c3e50;
            margin-bottom: 1rem;
        }
        
        .code-example pre {
            background: #2d3748;
            color: #e2e8f0;
            padding: 1.5rem;
            border-radius: 0.5rem;
            overflow-x: auto;
            margin: 1rem 0;
        }
        
        .preview-box {
            background: white;
            border: 2px dashed #e9ecef;
            border-radius: 0.5rem;
            padding: 2rem;
            margin-top: 1rem;
        }
        
        .btn-modern {
            display: inline-block;
            padding: 0.75rem 2rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-decoration: none;
            border-radius: 0.5rem;
            font-weight: 500;
            transition: all 0.3s ease;
            box-shadow: 0 4px 6px rgba(0,0,0,0.07);
        }
        
        .btn-modern:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 15px rgba(0,0,0,0.1);
        }
        
        a { text-decoration: none; }
        """)
    }
    
    @HTMLBuilder
    func pageHeader() -> some HTMLElement {
        showcaseHero(
            title: "Basic HTML Elements",
            subtitle: "Fundamental building blocks with Swiftlets syntax"
        )
    }
    
    @HTMLBuilder
    func mainContent() -> some HTMLElement {
        Main {
            Container(maxWidth: .large) {
                VStack(spacing: 60) {
                    headingsSection()
                    textSection()
                    linksSection()
                    containersSection()
                }
                .style("padding", "3rem 0")
            }
        }
    }
    
    @HTMLBuilder
    func headingsSection() -> some HTMLElement {
        featureSection(title: "Headings") {
            liveExample(
                title: "All Heading Levels",
                code: """
                H1("Heading Level 1")
                H2("Heading Level 2")
                H3("Heading Level 3")
                H4("Heading Level 4")
                H5("Heading Level 5")
                H6("Heading Level 6")
                """,
                preview: headingsPreview
            )
        }
    }
    
    @HTMLBuilder
    func headingsPreview() -> some HTMLElement {
        VStack(alignment: .leading, spacing: 10) {
            H1("Heading Level 1")
            H2("Heading Level 2")
            H3("Heading Level 3")
            H4("Heading Level 4")
            H5("Heading Level 5")
            H6("Heading Level 6")
        }
    }
    
    @HTMLBuilder
    func textSection() -> some HTMLElement {
        featureSection(title: "Text Elements") {
            VStack(spacing: 30) {
                paragraphExample()
                textModifiersExample()
            }
        }
    }
    
    @HTMLBuilder
    func paragraphExample() -> some HTMLElement {
        liveExample(
            title: "Paragraphs",
            code: """
            P("This is a paragraph with some text content.")
            P("Another paragraph with different content.")
                .style("color", "#6c757d")
            """,
            preview: paragraphPreview
        )
    }
    
    @HTMLBuilder
    func paragraphPreview() -> some HTMLElement {
        VStack(alignment: .leading, spacing: 16) {
            P("This is a paragraph with some text content.")
            P("Another paragraph with different content.")
                .style("color", "#6c757d")
        }
    }
    
    @HTMLBuilder
    func textModifiersExample() -> some HTMLElement {
        liveExample(
            title: "Text Modifiers",
            code: """
            Text("Plain text without paragraph wrapper")
            Span("Inline span element")
                .style("color", "#667eea")
            """,
            preview: textModifiersPreview
        )
    }
    
    @HTMLBuilder
    func textModifiersPreview() -> some HTMLElement {
        VStack(alignment: .leading, spacing: 16) {
            Text("Plain text without paragraph wrapper")
            Span("Inline span element")
                .style("color", "#667eea")
                .style("font-weight", "500")
        }
    }
    
    @HTMLBuilder
    func linksSection() -> some HTMLElement {
        featureSection(title: "Links") {
            liveExample(
                title: "Various Link Types",
                code: """
                Link(href: "/", "Home Link")
                Link(href: "https://example.com", "External Link")
                    .attribute("target", "_blank")
                Link(href: "#section", "Anchor Link")
                    .class("btn-modern")
                """,
                preview: linksPreview
            )
        }
    }
    
    @HTMLBuilder
    func linksPreview() -> some HTMLElement {
        VStack(alignment: .leading, spacing: 16) {
            Link(href: "/", "Home Link")
                .style("color", "#667eea")
            Link(href: "https://example.com", "External Link →")
                .attribute("target", "_blank")
                .style("color", "#764ba2")
            Link(href: "#section", "Anchor Link")
                .class("btn-modern")
        }
    }
    
    @HTMLBuilder
    func containersSection() -> some HTMLElement {
        featureSection(title: "Container Elements") {
            VStack(spacing: 30) {
                divExample()
                spanExample()
            }
        }
    }
    
    @HTMLBuilder
    func divExample() -> some HTMLElement {
        liveExample(
            title: "Div Containers",
            code: """
            Div {
                H3("Container Title")
                P("Content inside a div container")
            }
            .style("padding", "1.5rem")
            .style("background", "#f8f9fa")
            .style("border-radius", "0.5rem")
            """,
            preview: divPreview
        )
    }
    
    @HTMLBuilder
    func divPreview() -> some HTMLElement {
        Div {
            H3("Container Title")
            P("Content inside a div container")
        }
        .style("padding", "1.5rem")
        .style("background", "#f8f9fa")
        .style("border-radius", "0.5rem")
        .style("border", "1px solid #e9ecef")
    }
    
    @HTMLBuilder
    func spanExample() -> some HTMLElement {
        liveExample(
            title: "Inline Spans",
            code: """
            P {
                Text("This paragraph contains ")
                Span("highlighted text")
                    .style("background", "#ffd93d")
                    .style("padding", "0.2rem 0.4rem")
                Text(" within it.")
            }
            """,
            preview: spanPreview
        )
    }
    
    @HTMLBuilder
    func spanPreview() -> some HTMLElement {
        P {
            Text("This paragraph contains ")
            Span("highlighted text")
                .style("background", "linear-gradient(135deg, #ffd93d 0%, #ffb74d 100%)")
                .style("padding", "0.2rem 0.5rem")
                .style("border-radius", "0.25rem")
                .style("font-weight", "500")
            Text(" within it.")
        }
    }
}