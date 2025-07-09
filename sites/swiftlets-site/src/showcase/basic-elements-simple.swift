import Swiftlets

@main
struct BasicElementsSimple: SwiftletMain {
    var title = "Basic HTML Elements - Swiftlets Showcase"
    
    var body: some HTMLElement {
        Fragment {
            basicStyles()
            simpleNav()
            
            Main {
                Container(maxWidth: .large) {
                    hero()
                    
                    VStack(spacing: 60) {
                        headingsSection()
                        textSection()
                        linksSection()
                        containersSection()
                    }
                    .style("padding", "3rem 0")
                }
            }
            
            simpleFooter()
        }
    }
    
    @HTMLBuilder
    func basicStyles() -> some HTMLElement {
        Style("""
        body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; }
        .hero { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 3rem 0; text-align: center; }
        .hero h1 { font-size: 3rem; margin-bottom: 1rem; }
        .section { padding: 2rem 0; }
        .section h2 { color: #2c3e50; margin-bottom: 2rem; }
        .example { background: #f8f9fa; border-radius: 0.5rem; padding: 1.5rem; margin: 1.5rem 0; }
        .example h3 { margin-bottom: 1rem; }
        .code { background: #2d3748; color: #e2e8f0; padding: 1rem; border-radius: 0.25rem; overflow-x: auto; margin: 1rem 0; font-family: monospace; }
        .preview { background: white; border: 2px dashed #e9ecef; border-radius: 0.25rem; padding: 1.5rem; margin-top: 1rem; }
        """)
    }
    
    @HTMLBuilder
    func simpleNav() -> some HTMLElement {
        Nav {
            Container(maxWidth: .xl) {
                HStack {
                    Link(href: "/", "Swiftlets")
                        .style("font-weight", "700")
                    Spacer()
                    HStack(spacing: 20) {
                        Link(href: "/showcase", "Back to Showcase")
                    }
                }
                .style("padding", "1rem 0")
            }
        }
        .style("background", "white")
        .style("box-shadow", "0 2px 4px rgba(0,0,0,0.1)")
    }
    
    @HTMLBuilder
    func hero() -> some HTMLElement {
        Section {
            H1("Basic HTML Elements")
            P("Fundamental building blocks with Swiftlets syntax")
        }
        .class("hero")
    }
    
    @HTMLBuilder
    func headingsSection() -> some HTMLElement {
        Section {
            H2("Headings")
            
            Div {
                H3("All Heading Levels")
                
                Div {
                    Pre("H1(\"Heading Level 1\")\nH2(\"Heading Level 2\")\nH3(\"Heading Level 3\")\nH4(\"Heading Level 4\")\nH5(\"Heading Level 5\")\nH6(\"Heading Level 6\")")
                }
                .class("code")
                
                Div {
                    H1("Heading Level 1")
                    H2("Heading Level 2")
                    H3("Heading Level 3")
                    H4("Heading Level 4")
                    H5("Heading Level 5")
                    H6("Heading Level 6")
                }
                .class("preview")
            }
            .class("example")
        }
        .class("section")
    }
    
    @HTMLBuilder
    func textSection() -> some HTMLElement {
        Section {
            H2("Text Elements")
            
            // Paragraph example
            Div {
                H3("Paragraphs")
                
                Div {
                    Pre("P(\"This is a paragraph with some text content.\")\nP(\"Another paragraph with different content.\")\n    .style(\"color\", \"#6c757d\")")
                }
                .class("code")
                
                Div {
                    P("This is a paragraph with some text content.")
                    P("Another paragraph with different content.")
                        .style("color", "#6c757d")
                }
                .class("preview")
            }
            .class("example")
            
            // Text modifiers example
            Div {
                H3("Text Modifiers")
                
                Div {
                    Pre("Text(\"Plain text without paragraph wrapper\")\nSpan(\"Inline span element\")\n    .style(\"color\", \"#667eea\")")
                }
                .class("code")
                
                Div {
                    P("Plain text without paragraph wrapper")
                    P {
                        Span("Inline span element")
                            .style("color", "#667eea")
                            .style("font-weight", "500")
                    }
                }
                .class("preview")
            }
            .class("example")
        }
        .class("section")
    }
    
    @HTMLBuilder
    func linksSection() -> some HTMLElement {
        Section {
            H2("Links")
            
            Div {
                H3("Various Link Types")
                
                Div {
                    Pre("Link(href: \"/\", \"Home Link\")\nLink(href: \"https://example.com\", \"External Link\")\n    .attribute(\"target\", \"_blank\")\nLink(href: \"#section\", \"Anchor Link\")")
                }
                .class("code")
                
                Div {
                    P {
                        Link(href: "/", "Home Link")
                            .style("color", "#667eea")
                    }
                    P {
                        Link(href: "https://example.com", "External Link →")
                            .attribute("target", "_blank")
                            .style("color", "#764ba2")
                    }
                    P {
                        Link(href: "#section", "Anchor Link")
                            .style("background", "#667eea")
                            .style("color", "white")
                            .style("padding", "0.5rem 1rem")
                            .style("border-radius", "0.25rem")
                            .style("display", "inline-block")
                    }
                }
                .class("preview")
            }
            .class("example")
        }
        .class("section")
    }
    
    @HTMLBuilder
    func containersSection() -> some HTMLElement {
        Section {
            H2("Container Elements")
            
            // Div example
            Div {
                H3("Div Containers")
                
                Div {
                    Pre("Div {\n    H3(\"Container Title\")\n    P(\"Content inside a div container\")\n}\n.style(\"padding\", \"1.5rem\")\n.style(\"background\", \"#f8f9fa\")")
                }
                .class("code")
                
                Div {
                    Div {
                        H3("Container Title")
                        P("Content inside a div container")
                    }
                    .style("padding", "1.5rem")
                    .style("background", "#f0f0f0")
                    .style("border-radius", "0.5rem")
                }
                .class("preview")
            }
            .class("example")
            
            // Span example
            Div {
                H3("Inline Spans")
                
                Div {
                    Pre("P {\n    Text(\"This paragraph contains \")\n    Span(\"highlighted text\")\n        .style(\"background\", \"#ffd93d\")\n        .style(\"padding\", \"0.2rem 0.4rem\")\n    Text(\" within it.\")\n}")
                }
                .class("code")
                
                Div {
                    P {
                        Text("This paragraph contains ")
                        Span("highlighted text")
                            .style("background", "#ffd93d")
                            .style("padding", "0.2rem 0.5rem")
                            .style("border-radius", "0.25rem")
                        Text(" within it.")
                    }
                }
                .class("preview")
            }
            .class("example")
        }
        .class("section")
    }
    
    @HTMLBuilder
    func simpleFooter() -> some HTMLElement {
        Footer {
            Container(maxWidth: .large) {
                P("© 2025 Swiftlets Project")
                    .style("text-align", "center")
                    .style("color", "#6c757d")
            }
        }
        .style("padding", "2rem 0")
        .style("border-top", "1px solid #e9ecef")
        .style("margin-top", "3rem")
    }
}