import Swiftlets

@main
struct TextFormattingSimple: SwiftletMain {
    var title = "Text Formatting - Swiftlets Showcase"
    
    var body: some HTMLElement {
        Fragment {
            basicStyles()
            simpleNav()
            
            Main {
                Container(maxWidth: .large) {
                    hero()
                    
                    VStack(spacing: 60) {
                        basicTextSection()
                        codeSection()
                        quotationsSection()
                        specialTextSection()
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
        .code { background: #2d3748; color: #e2e8f0; padding: 1rem; border-radius: 0.25rem; overflow-x: auto; margin: 1rem 0; font-family: monospace; white-space: pre; }
        .preview { background: white; border: 2px dashed #e9ecef; border-radius: 0.25rem; padding: 1.5rem; margin-top: 1rem; }
        pre { margin: 0; }
        code { background: #e9ecef; padding: 0.125rem 0.25rem; border-radius: 0.125rem; }
        blockquote { border-left: 4px solid #667eea; margin: 1rem 0; padding-left: 1rem; color: #6c757d; }
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
            H1("Text Formatting")
            P("Rich text formatting elements and styles")
        }
        .class("hero")
    }
    
    @HTMLBuilder
    func basicTextSection() -> some HTMLElement {
        Section {
            H2("Basic Text Formatting")
            
            Div {
                H3("Emphasis and Strong")
                
                Div {
                    Pre("Strong(\"Bold text using Strong\")\nEm(\"Italic text using Em\")\nMark(\"Highlighted text\")\nSmall(\"Small text\")")
                }
                .class("code")
                
                Div {
                    P { Strong("Bold text using Strong") }
                    P { Em("Italic text using Em") }
                    P { Mark("Highlighted text") }
                    P { Small("Small text") }
                    P {
                        Text("Combined: ")
                        Strong("bold")
                        Text(", ")
                        Em("italic")
                        Text(", and ")
                        Mark("highlighted")
                        Text(" text.")
                    }
                }
                .class("preview")
            }
            .class("example")
        }
        .class("section")
    }
    
    @HTMLBuilder
    func codeSection() -> some HTMLElement {
        Section {
            H2("Code and Preformatted")
            
            Div {
                H3("Inline and Block Code")
                
                Div {
                    Pre("Code(\"inline code\")\nPre(\"Preformatted text\\n  preserves spacing\")")
                }
                .class("code")
                
                Div {
                    P {
                        Text("Use ")
                        Code("inline code")
                        Text(" for small snippets.")
                    }
                    Pre("function example() {\n  return 'Preformatted text';\n}")
                        .style("background", "#f0f0f0")
                        .style("padding", "1rem")
                        .style("border-radius", "0.25rem")
                }
                .class("preview")
            }
            .class("example")
        }
        .class("section")
    }
    
    @HTMLBuilder
    func quotationsSection() -> some HTMLElement {
        Section {
            H2("Quotations")
            
            Div {
                H3("Blockquotes")
                
                Div {
                    Pre("BlockQuote {\n    P(\"This is a quoted paragraph.\")\n    P(\"- Author Name\")\n}")
                }
                .class("code")
                
                Div {
                    BlockQuote {
                        P("This is a quoted paragraph with some meaningful text that demonstrates how blockquotes appear.")
                        P("- Author Name")
                            .style("font-style", "italic")
                            .style("text-align", "right")
                    }
                }
                .class("preview")
            }
            .class("example")
        }
        .class("section")
    }
    
    @HTMLBuilder
    func specialTextSection() -> some HTMLElement {
        Section {
            H2("Special Text Elements")
            
            Div {
                H3("Various Text Modifiers")
                
                Div {
                    Pre("Del(\"Deleted text\")\nIns(\"Inserted text\")\nS(\"Strikethrough text\")\nU(\"Underlined text\")")
                }
                .class("code")
                
                Div {
                    P { Del("Deleted text") }
                    P { Ins("Inserted text") }
                    P {
                        Span("Strikethrough text")
                            .style("text-decoration", "line-through")
                    }
                    P {
                        Span("Underlined text")
                            .style("text-decoration", "underline")
                    }
                    P {
                        Text("Price: ")
                        Del("$99")
                        Text(" ")
                        Ins("$79")
                            .style("color", "green")
                            .style("font-weight", "bold")
                    }
                }
                .class("preview")
            }
            .class("example")
            
            Div {
                H3("Subscript and Superscript")
                
                Div {
                    Pre("P {\n    Text(\"H\")\n    Sub(\"2\")\n    Text(\"O and E=mc\")\n    Sup(\"2\")\n}")
                }
                .class("code")
                
                Div {
                    P {
                        Text("H")
                        Sub("2")
                        Text("O is water")
                    }
                    P {
                        Text("E = mc")
                        Sup("2")
                        Text(" is Einstein's equation")
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