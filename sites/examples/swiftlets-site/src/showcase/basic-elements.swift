import Foundation
import Swiftlets

@main
struct BasicElementsShowcase {
    static func main() async throws {
        let request = try JSONDecoder().decode(Request.self, from: FileHandle.standardInput.readDataToEndOfFile())
        
        let html = Html {
                Head {
                    Title("Basic HTML Elements - Swiftlets Showcase")
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
                            H1("Basic HTML Elements")
                            P("Examples of fundamental HTML elements in Swiftlets")
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
                        
                        // Headings Example
                        CodeExample(
                            title: "Headings (H1-H6)",
                            swift: """
H1("Main Heading")
H2("Section Heading")
H3("Subsection Heading")
H4("Sub-subsection Heading")
H5("Minor Heading")
H6("Smallest Heading")
""",
                            html: """
<h1>Main Heading</h1>
<h2>Section Heading</h2>
<h3>Subsection Heading</h3>
<h4>Sub-subsection Heading</h4>
<h5>Minor Heading</h5>
<h6>Smallest Heading</h6>
""",
                            preview: {
                                Fragment {
                                    H1("Main Heading")
                                    H2("Section Heading")
                                    H3("Subsection Heading")
                                    H4("Sub-subsection Heading")
                                    H5("Minor Heading")
                                    H6("Smallest Heading")
                                }
                            },
                            description: "Headings are used to create a hierarchical structure in your content."
                        ).render()
                        
                        // Paragraph Example
                        CodeExample(
                            title: "Paragraphs",
                            swift: """
P("This is a paragraph with regular text.")

P {
    Text("Paragraphs can also contain ")
    Strong("bold text")
    Text(", ")
    Em("italic text")
    Text(", and other inline elements.")
}
""",
                            html: """
<p>This is a paragraph with regular text.</p>

<p>Paragraphs can also contain <strong>bold text</strong>, <em>italic text</em>, and other inline elements.</p>
""",
                            preview: {
                                Fragment {
                                    P("This is a paragraph with regular text.")
                                    P {
                                        Text("Paragraphs can also contain ")
                                        Strong("bold text")
                                        Text(", ")
                                        Em("italic text")
                                        Text(", and other inline elements.")
                                    }
                                }
                            },
                            description: "Paragraphs are the basic building blocks for text content."
                        ).render()
                        
                        // Div Example
                        CodeExample(
                            title: "Div Containers",
                            swift: """
Div {
    H3("Container Section")
    P("Content inside a div container.")
    Div {
        P("Nested div with its own content.")
    }
    .class("nested-box")
    .style("padding", "10px")
    .style("border", "1px solid #ddd")
}
.class("container-box")
.style("background-color", "#f5f5f5")
.style("padding", "20px")
""",
                            html: """
<div class="container-box" style="background-color: #f5f5f5; padding: 20px;">
    <h3>Container Section</h3>
    <p>Content inside a div container.</p>
    <div class="nested-box" style="padding: 10px; border: 1px solid #ddd;">
        <p>Nested div with its own content.</p>
    </div>
</div>
""",
                            preview: {
                                Div {
                                    H3("Container Section")
                                    P("Content inside a div container.")
                                    Div {
                                        P("Nested div with its own content.")
                                    }
                                    .class("nested-box")
                                    .style("padding", "10px")
                                    .style("border", "1px solid #ddd")
                                }
                                .class("container-box")
                                .style("background-color", "#f5f5f5")
                                .style("padding", "20px")
                            },
                            description: "Div elements are generic containers for grouping content."
                        ).render()
                        
                        // Span Example
                        CodeExample(
                            title: "Inline Spans",
                            swift: """
P {
    Text("This paragraph contains ")
    Span("highlighted text")
        .style("background-color", "yellow")
    Text(" and ")
    Span("colored text")
        .style("color", "blue")
        .style("font-weight", "bold")
    Text(".")
}
""",
                            html: """
<p>This paragraph contains <span style="background-color: yellow;">highlighted text</span> and <span style="color: blue; font-weight: bold;">colored text</span>.</p>
""",
                            preview: {
                                P {
                                    Text("This paragraph contains ")
                                    Span("highlighted text")
                                        .style("background-color", "yellow")
                                    Text(" and ")
                                    Span("colored text")
                                        .style("color", "blue")
                                        .style("font-weight", "bold")
                                    Text(".")
                                }
                            },
                            description: "Span elements are inline containers for styling portions of text."
                        ).render()
                        
                        // Links Example
                        CodeExample(
                            title: "Links",
                            swift: """
// Simple link
Link(href: "https://swiftlets.dev", "Visit Swiftlets")

// Link with attributes
Link(href: "https://example.com", "Open in new tab")
    .attribute("target", "_blank")
    .attribute("rel", "noopener noreferrer")

// Link with custom styling
Link(href: "#", "Styled Link")
    .class("btn btn-primary")
    .style("text-decoration", "none")
    .style("padding", "10px 20px")

// Link containing multiple elements
Link(href: "/products") {
    Div {
        H4("Product Card")
        P("Click to view details")
    }
    .class("card-link")
}
""",
                            html: """
<!-- Simple link -->
<a href="https://swiftlets.dev">Visit Swiftlets</a>

<!-- Link with attributes -->
<a href="https://example.com" target="_blank" rel="noopener noreferrer">Open in new tab</a>

<!-- Link with custom styling -->
<a href="#" class="btn btn-primary" style="text-decoration: none; padding: 10px 20px;">Styled Link</a>

<!-- Link containing multiple elements -->
<a href="/products">
    <div class="card-link">
        <h4>Product Card</h4>
        <p>Click to view details</p>
    </div>
</a>
""",
                            preview: {
                                Fragment {
                                    Div {
                                        Text("Simple link: ")
                                        Link(href: "https://swiftlets.dev", "Visit Swiftlets")
                                    }
                                    Div {
                                        Text("Link with attributes: ")
                                        Link(href: "https://example.com", "Open in new tab")
                                            .attribute("target", "_blank")
                                            .attribute("rel", "noopener noreferrer")
                                    }
                                    Div {
                                        Text("Styled link: ")
                                        Link(href: "#", "Styled Link")
                                            .class("btn btn-primary")
                                            .style("text-decoration", "none")
                                            .style("padding", "10px 20px")
                                            .style("background", "#007bff")
                                            .style("color", "white")
                                            .style("border-radius", "4px")
                                            .style("display", "inline-block")
                                    }
                                    Div {
                                        Text("Link with content: ")
                                        Link(href: "/products") {
                                            Div {
                                                H4("Product Card")
                                                P("Click to view details")
                                            }
                                            .class("card-link")
                                            .style("border", "1px solid #ddd")
                                            .style("padding", "10px")
                                            .style("border-radius", "4px")
                                        }
                                    }
                                }
                            },
                            description: "Links connect pages and resources together."
                        ).render()
                        
                        // Navigation
                        Div {
                            Link(href: "/showcase", "Showcase Index")
                                .class("nav-button")
                            Link(href: "/showcase/text-formatting", "Text Formatting")
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