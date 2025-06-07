import Foundation
import Swiftlets

@main
struct TextFormattingShowcase {
    static func main() async throws {
        let request = try JSONDecoder().decode(Request.self, from: FileHandle.standardInput.readDataToEndOfFile())
        
        let html = Html {
            Head {
                Title("Text Formatting - Swiftlets Showcase")
                LinkElement(rel: "stylesheet", href: "/styles/main.css")
            }
            Body {
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
                        }
                        .class("nav-links")
                    }
                    .class("nav-content")
                }
                .class("nav-container")
                
                // Header
                Div {
                    Div {
                        H1("Text Formatting")
                        P("Examples of text styling and inline formatting elements")
                            .style("font-size", "1.25rem")
                            .style("color", "#6c757d")
                    }
                    .class("showcase-container")
                }
                .class("showcase-header")
                
                // Main content
                Div {
                    // Breadcrumb
                    Div {
                        Link(href: "/showcase", "← Back to Showcase")
                            .style("color", "#007bff")
                    }
                    .style("margin-bottom", "2rem")
                    
                    // Basic Text Formatting
                    CodeExample(
                        title: "Basic Text Formatting",
                        swift: """
Strong("Bold text using Strong")
Em("Italic text using Em")
Mark("Highlighted text using Mark")
Small("Small text using Small")

// Combined formatting
P {
    Text("This paragraph contains ")
    Strong("bold")
    Text(", ")
                            Em("italic")
    Text(", and ")
    Mark("highlighted")
    Text(" text.")
}
""",
                        html: """
<strong>Bold text using Strong</strong>
<em>Italic text using Em</em>
<mark>Highlighted text using Mark</mark>
<small>Small text using Small</small>

<p>This paragraph contains <strong>bold</strong>, <em>italic</em>, and <mark>highlighted</mark> text.</p>
""",
                        preview: {
                            Fragment {
                                Strong("Bold text using Strong")
                                BR()
                                Em("Italic text using Em")
                                BR()
                                Mark("Highlighted text using Mark")
                                BR()
                                Small("Small text using Small")
                                
                                P {
                                    Text("This paragraph contains ")
                                    Strong("bold")
                                    Text(", ")
                                    Em("italic")
                                    Text(", and ")
                                    Mark("highlighted")
                                    Text(" text.")
                                }
                            }
                        },
                        description: "Basic text formatting elements for emphasis and styling."
                    ).render()
                    
                    // Code and Preformatted Text
                    CodeExample(
                        title: "Code and Preformatted Text",
                        swift: """
// Inline code
P {
    Text("Use ")
    Code("let x = 42")
    Text(" to declare a constant.")
}

// Code block with Pre
Pre {
    Code(\"\"\"
func greet(name: String) -> String {
    return "Hello, \\(name)!"
}
\"\"\")
}

// Preformatted text without code
Pre(\"\"\"
    ASCII Art Example:
     _____
    /     \\
   | ^   ^ |
   |   >   |
    \\_____/
\"\"\")
""",
                        html: """
<p>Use <code>let x = 42</code> to declare a constant.</p>

<pre><code>func greet(name: String) -> String {
    return "Hello, \\(name)!"
}</code></pre>

<pre>    ASCII Art Example:
     _____
    /     \\
   | ^   ^ |
   |   >   |
    \\_____/</pre>
""",
                        preview: {
                            Fragment {
                                P {
                                    Text("Use ")
                                    Code("let x = 42")
                                    Text(" to declare a constant.")
                                }
                                
                                Pre {
                                    Code("""
func greet(name: String) -> String {
    return "Hello, \\(name)!"
}
""")
                                }
                                
                                Pre("""
    ASCII Art Example:
     _____
    /     \\
   | ^   ^ |
   |   >   |
    \\_____/
""")
                            }
                        },
                        description: "Code elements for displaying inline code and code blocks."
                    ).render()
                    
                    // Quotations
                    CodeExample(
                        title: "Quotations",
                        swift: """
// Block quote
BlockQuote {
    P("The only way to do great work is to love what you do.")
    P("- Steve Jobs")
}

// Inline quote
P {
    Text("As Einstein said, ")
    Q("Imagination is more important than knowledge.")
}

// Cite element
P {
    Q("To be or not to be")
    Text(" from ")
    Cite("Hamlet")
}
""",
                        html: """
<blockquote>
    <p>The only way to do great work is to love what you do.</p>
    <p>- Steve Jobs</p>
</blockquote>

<p>As Einstein said, <q>Imagination is more important than knowledge.</q></p>

<p><q>To be or not to be</q> from <cite>Hamlet</cite></p>
""",
                        preview: {
                            Fragment {
                                BlockQuote {
                                    P("The only way to do great work is to love what you do.")
                                    P("- Steve Jobs")
                                }
                                
                                P {
                                    Text("As Einstein said, ")
                                    Q("Imagination is more important than knowledge.")
                                }
                                
                                P {
                                    Q("To be or not to be")
                                    Text(" from ")
                                    Cite("Hamlet")
                                }
                            }
                        },
                        description: "Elements for quotations and citations."
                    ).render()
                    
                    // Subscript and Superscript
                    CodeExample(
                        title: "Subscript and Superscript",
                        swift: """
// Chemical formula
P {
    Text("Water is H")
    Sub("2")
    Text("O")
}

// Mathematical expression
P {
    Text("E = mc")
    Sup("2")
}

// Footnote reference
P {
    Text("This needs a citation")
    Sup {
        Link(href: "#ref1", "[1]")
    }
}
""",
                        html: """
<p>Water is H<sub>2</sub>O</p>

<p>E = mc<sup>2</sup></p>

<p>This needs a citation<sup><a href="#ref1">[1]</a></sup></p>
""",
                        preview: {
                            Fragment {
                                P {
                                    Text("Water is H")
                                    Sub("2")
                                    Text("O")
                                }
                                
                                P {
                                    Text("E = mc")
                                    Sup("2")
                                }
                                
                                P {
                                    Text("This needs a citation")
                                    Sup {
                                        Link(href: "#ref1", "[1]")
                                    }
                                }
                            }
                        },
                        description: "Subscript and superscript for scientific notation and footnotes."
                    ).render()
                    
                    // Insertions and Deletions
                    CodeExample(
                        title: "Insertions and Deletions",
                        swift: """
// Track changes
P {
    Text("The event is on ")
    Del("Saturday")
    Text(" ")
    Ins("Sunday")
    Text(".")
}

// With attributes
P {
    Text("Price: ")
    Del {
        Text("$99")
    }
    .attribute("datetime", "2024-01-01")
    Text(" ")
    Ins {
        Text("$79")
    }
    .attribute("datetime", "2024-01-15")
}

// Strike through (using Del as alternative)
Del("This text is no longer accurate")
""",
                        html: """
<p>The event is on <del>Saturday</del> <ins>Sunday</ins>.</p>

<p>Price: <del datetime="2024-01-01">$99</del> <ins datetime="2024-01-15">$79</ins></p>

<del>This text is no longer accurate</del>
""",
                        preview: {
                            Fragment {
                                P {
                                    Text("The event is on ")
                                    Del("Saturday")
                                    Text(" ")
                                    Ins("Sunday")
                                    Text(".")
                                }
                                
                                P {
                                    Text("Price: ")
                                    Del {
                                        Text("$99")
                                    }
                                    .attribute("datetime", "2024-01-01")
                                    Text(" ")
                                    Ins {
                                        Text("$79")
                                    }
                                    .attribute("datetime", "2024-01-15")
                                }
                                
                                Del("This text is no longer accurate")
                            }
                        },
                        description: "Elements for showing document edits and changes."
                    ).render()
                    
                    // Abbreviations and Definitions
                    CodeExample(
                        title: "Abbreviations and Definitions",
                        swift: """
// Abbreviation with title
P {
    Text("The ")
    Abbr("HTML", title: "HyperText Markup Language")
    Text(" specification is maintained by the W3C.")
}

// Keyboard shortcut with Kbd
P {
    Text("Press ")
    Kbd("Ctrl")
    Text(" + ")
    Kbd("C")
    Text(" to copy.")
}
""",
                        html: """
<p>The <abbr title="HyperText Markup Language">HTML</abbr> specification is maintained by the W3C.</p>

<p>Press <kbd>Ctrl</kbd> + <kbd>C</kbd> to copy.</p>
""",
                        preview: {
                            Fragment {
                                P {
                                    Text("The ")
                                    Abbr("HTML", title: "HyperText Markup Language")
                                    Text(" specification is maintained by the W3C.")
                                }
                                
                                P {
                                    Text("Press ")
                                    Kbd("Ctrl")
                                    Text(" + ")
                                    Kbd("C")
                                    Text(" to copy.")
                                }
                            }
                        },
                        description: "Elements for abbreviations, definitions, and annotations."
                    ).render()
                    
                    // Special Text Elements
                    CodeExample(
                        title: "Special Text Elements",
                        swift: """
// Keyboard input
P {
    Text("Press ")
                            Kbd("Cmd")
    Text(" + ")
    Kbd("S")
    Text(" to save.")
}

// Sample output
P {
    Text("The command outputs: ")
    Samp("Hello, World!")
}

// Variable
P {
    Text("The ")
    Var("x")
    Text(" variable stores the result.")
}

// Time element
P {
    Text("Published on ")
    Time("January 1, 2025", datetime: "2025-01-01")
}

// Data element with value
P {
    Text("Product ID: ")
    Data("12345", value: "prod-12345")
}
""",
                        html: """
<p>Press <kbd>Cmd</kbd> + <kbd>S</kbd> to save.</p>

<p>The command outputs: <samp>Hello, World!</samp></p>

<p>The <var>x</var> variable stores the result.</p>

<p>Published on <time datetime="2025-01-01">January 1, 2025</time></p>

<p>Product ID: <data value="prod-12345">12345</data></p>
""",
                        preview: {
                            Fragment {
                                P {
                                    Text("Press ")
                                    Kbd("Cmd")
                                    Text(" + ")
                                    Kbd("S")
                                    Text(" to save.")
                                }
                                
                                P {
                                    Text("The command outputs: ")
                                    Samp("Hello, World!")
                                }
                                
                                P {
                                    Text("The ")
                                    Var("x")
                                    Text(" variable stores the result.")
                                }
                                
                                P {
                                    Text("Published on ")
                                    Time("January 1, 2025", datetime: "2025-01-01")
                                }
                                
                                P {
                                    Text("Product ID: ")
                                    Data("12345", value: "prod-12345")
                                }
                            }
                        },
                        description: "Special purpose text elements for technical content."
                    ).render()
                    
                    // Navigation
                    Div {
                        Link(href: "/showcase/basic-elements", "Basic Elements")
                            .class("nav-button")
                        Link(href: "/showcase/lists", "Lists")
                            .class("nav-button nav-button-next")
                    }
                    .class("navigation-links")
                }
                .class("showcase-container")
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