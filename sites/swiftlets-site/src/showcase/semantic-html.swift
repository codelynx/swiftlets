import Swiftlets

@main
struct SemanticShowcase: SwiftletMain {
    var title = "Semantic HTML - Swiftlets Showcase"
    
    var body: some HTMLElement {
        Fragment {
            Nav {
            Div {
            Link(href: "/", "Swiftlets")
                .class("nav-brand")
            
            Div {
                Link(href: "/", "Home")
                Link(href: "/docs", "Docs")
                Link(href: "/showcase", "Showcase")
                    .class("active")
            }
            .class("nav-links")
            }
            .class("nav-content")
            }
            .class("nav-container")
            
            Div {
            H1("Semantic HTML Elements")
            
            Div {
            Link(href: "/showcase", "← Back to Showcase")
                .style("display", "inline-block")
                .style("margin-bottom", "1rem")
                .style("color", "#007bff")
            }
            
            P("Semantic HTML elements clearly describe their meaning to both the browser and the developer.")
            
            // Page Structure Elements
            Section {
            CodeExample(
                title: "Page Structure Elements",
                swift: """
Header {
    H1("My Website")
    Nav {
        Link(href: "/", "Home")
        Link(href: "/about", "About")
        Link(href: "/contact", "Contact")
    }
}

Main {
    Article {
        H2("Article Title")
        P("Article content goes here...")
    }
    
    Aside {
        H3("Related Links")
        UL {
            LI { Link(href: "#", "Link 1") }
            LI { Link(href: "#", "Link 2") }
        }
    }
}

Footer {
    P("© 2025 My Company. All rights reserved.")
}
""",
                html: """
<header>
    <h1>My Website</h1>
    <nav>
        <a href="/">Home</a>
        <a href="/about">About</a>
        <a href="/contact">Contact</a>
    </nav>
</header>

<main>
    <article>
        <h2>Article Title</h2>
        <p>Article content goes here...</p>
    </article>
    
    <aside>
        <h3>Related Links</h3>
        <ul>
            <li><a href="#">Link 1</a></li>
            <li><a href="#">Link 2</a></li>
        </ul>
    </aside>
</main>

<footer>
    <p>© 2025 My Company. All rights reserved.</p>
</footer>
""",
                preview: {
                    Fragment {
                        Header {
                            H2("My Website")
                            Nav {
                                Link(href: "#", "Home")
                                Text(" | ")
                                Link(href: "#", "About")
                                Text(" | ")
                                Link(href: "#", "Contact")
                            }
                            .style("margin", "0.5rem 0")
                        }
                        .style("background", "#f8f9fa")
                        .style("padding", "1rem")
                        .style("margin-bottom", "1rem")
                        .style("border-radius", "0.25rem")
                        
                        Main {
                            Article {
                                H3("Article Title")
                                P("This is the main article content. It contains the primary information for this page.")
                            }
                            .style("background", "#fff")
                            .style("padding", "1rem")
                            .style("margin-bottom", "1rem")
                            .style("border", "1px solid #dee2e6")
                            .style("border-radius", "0.25rem")
                            
                            Aside {
                                H4("Related Links")
                                UL {
                                    LI { Link(href: "#", "Related Article 1") }
                                    LI { Link(href: "#", "Related Article 2") }
                                }
                            }
                            .style("background", "#e9ecef")
                            .style("padding", "1rem")
                            .style("border-radius", "0.25rem")
                        }
                        
                        Footer {
                            P("© 2025 Swiftlets. All rights reserved.")
                                .style("margin", "0")
                                .style("text-align", "center")
                        }
                        .style("background", "#212529")
                        .style("color", "#fff")
                        .style("padding", "1rem")
                        .style("margin-top", "1rem")
                        .style("border-radius", "0.25rem")
                    }
                },
                description: "Header, Nav, Main, Article, Aside, and Footer elements provide semantic structure to web pages."
            ).render()
            }
            
            // Section and Article
            Section {
            CodeExample(
                title: "Section and Article Elements",
                swift: """
Section {
    H2("News Section")
    
    Article {
        H3("Breaking News")
        Time("January 15, 2025", datetime: "2025-01-15")
        P("Important news content...")
    }
    
    Article {
        H3("Technology Update")
        Time("January 14, 2025", datetime: "2025-01-14")
        P("Latest tech news...")
    }
}
""",
                html: """
<section>
    <h2>News Section</h2>
    
    <article>
        <h3>Breaking News</h3>
        <time datetime="2025-01-15">January 15, 2025</time>
        <p>Important news content...</p>
    </article>
    
    <article>
        <h3>Technology Update</h3>
        <time datetime="2025-01-14">January 14, 2025</time>
        <p>Latest tech news...</p>
    </article>
</section>
""",
                preview: {
                    Section {
                        H2("News Section")
                        
                        Article {
                            H3("Breaking News")
                            Time("January 15, 2025", datetime: "2025-01-15")
                                .style("display", "block")
                                .style("color", "#6c757d")
                                .style("font-size", "0.875rem")
                                .style("margin-bottom", "0.5rem")
                            P("Important news about the latest Swiftlets framework updates and improvements.")
                        }
                        .style("background", "#f8f9fa")
                        .style("padding", "1rem")
                        .style("margin-bottom", "1rem")
                        .style("border-radius", "0.25rem")
                        
                        Article {
                            H3("Technology Update")
                            Time("January 14, 2025", datetime: "2025-01-14")
                                .style("display", "block")
                                .style("color", "#6c757d")
                                .style("font-size", "0.875rem")
                                .style("margin-bottom", "0.5rem")
                            P("New features added to the HTML DSL including semantic elements support.")
                        }
                        .style("background", "#f8f9fa")
                        .style("padding", "1rem")
                        .style("border-radius", "0.25rem")
                    }
                    .style("border", "2px solid #007bff")
                    .style("padding", "1rem")
                    .style("border-radius", "0.5rem")
                },
                description: "Section groups related content, while Article represents self-contained compositions."
            ).render()
            }
            
            // Figure and FigCaption
            Section {
            CodeExample(
                title: "Figure and FigCaption",
                swift: """
// Figure with chart visualization
Figure {
    Div {
        // Bar chart using CSS styles
        Div { Text("Q1 2025 Sales Data") }
            .style("padding", "1rem")
            .style("background", "#f8f9fa")
            .style("text-align", "center")
    }
    FigCaption("Figure 1: Q1 2025 Sales Performance")
}

// Figure with code
Figure {
    Pre {
        Code("let greeting = \\"Hello, World!\\"\\nprint(greeting)")
    }
    FigCaption("Example 1: Basic Swift code")
}
""",
                html: """
<!-- Figure with chart visualization -->
<figure>
    <div>
        <div style="padding: 1rem; background: #f8f9fa; text-align: center;">
            Q1 2025 Sales Data
        </div>
    </div>
    <figcaption>Figure 1: Q1 2025 Sales Performance</figcaption>
</figure>

<!-- Figure with code -->
<figure>
    <pre><code>let greeting = "Hello, World!"
print(greeting)</code></pre>
    <figcaption>Example 1: Basic Swift code</figcaption>
</figure>
""",
                preview: {
                    Fragment {
                        Figure {
                            Div {
                                // Simple bar chart using CSS
                                Div {
                                    Div {
                                        Div {
                                            Span("Oct: 80%")
                                                .style("position", "absolute")
                                                .style("right", "10px")
                                                .style("top", "5px")
                                                .style("color", "white")
                                                .style("font-size", "14px")
                                                .style("z-index", "1")
                                        }
                                        .style("width", "80%")
                                        .style("height", "30px")
                                        .style("background", "#007bff")
                                        .style("border-radius", "0 4px 4px 0")
                                        .style("position", "relative")
                                    }
                                    .style("background", "#e9ecef")
                                    .style("margin-bottom", "10px")
                                    .style("border-radius", "4px")
                                    .style("position", "relative")
                                    
                                    Div {
                                        Div {
                                            Span("Nov: 95%")
                                                .style("position", "absolute")
                                                .style("right", "10px")
                                                .style("top", "5px")
                                                .style("color", "white")
                                                .style("font-size", "14px")
                                                .style("z-index", "1")
                                        }
                                        .style("width", "95%")
                                        .style("height", "30px")
                                        .style("background", "#28a745")
                                        .style("border-radius", "0 4px 4px 0")
                                        .style("position", "relative")
                                    }
                                    .style("background", "#e9ecef")
                                    .style("margin-bottom", "10px")
                                    .style("border-radius", "4px")
                                    .style("position", "relative")
                                    
                                    Div {
                                        Div {
                                            Span("Dec: 70%")
                                                .style("position", "absolute")
                                                .style("right", "10px")
                                                .style("top", "5px")
                                                .style("color", "black")
                                                .style("font-size", "14px")
                                                .style("z-index", "1")
                                        }
                                        .style("width", "70%")
                                        .style("height", "30px")
                                        .style("background", "#ffc107")
                                        .style("border-radius", "0 4px 4px 0")
                                        .style("position", "relative")
                                    }
                                    .style("background", "#e9ecef")
                                    .style("border-radius", "4px")
                                    .style("position", "relative")
                                }
                                .style("padding", "20px")
                            }
                            .style("background", "white")
                            .style("border", "1px solid #dee2e6")
                            .style("border-radius", "0.25rem")
                            .style("padding", "1rem")
                            
                            FigCaption("Figure 1: Q1 2025 Sales Performance")
                                .style("text-align", "center")
                                .style("margin-top", "0.5rem")
                                .style("color", "#6c757d")
                                .style("font-style", "italic")
                        }
                        .style("margin", "1rem 0")
                        .style("padding", "1rem")
                        .style("background", "#f8f9fa")
                        .style("border-radius", "0.5rem")
                        
                        Figure {
                            Pre {
                                Code("let greeting = \"Hello, World!\"\nprint(greeting)")
                            }
                            .style("background", "#282c34")
                            .style("color", "#abb2bf")
                            .style("padding", "1rem")
                            .style("border-radius", "0.25rem")
                            .style("overflow-x", "auto")
                            
                            FigCaption("Example 1: Basic Swift code")
                                .style("text-align", "center")
                                .style("margin-top", "0.5rem")
                                .style("color", "#6c757d")
                                .style("font-style", "italic")
                        }
                        .style("margin", "1rem 0")
                    }
                },
                description: "Figure represents self-contained content with an optional caption provided by FigCaption."
            ).render()
            }
            
            // Details and Summary
            Section {
            CodeExample(
                title: "Details and Summary",
                swift: """
Details {
    Summary("Click to expand")
    P("This content is hidden by default and revealed when clicked.")
}

Details(open: true) {
    Summary("Advanced Settings")
    Div {
        Label("Enable notifications")
        Input(type: "checkbox", name: "notifications")
    }
    Div {
        Label("Dark mode")
        Input(type: "checkbox", name: "darkmode")
    }
}
""",
                html: """
<details>
    <summary>Click to expand</summary>
    <p>This content is hidden by default and revealed when clicked.</p>
</details>

<details open="open">
    <summary>Advanced Settings</summary>
    <div>
        <label>Enable notifications</label>
        <input type="checkbox" name="notifications">
    </div>
    <div>
        <label>Dark mode</label>
        <input type="checkbox" name="darkmode">
    </div>
</details>
""",
                preview: {
                    Fragment {
                        Details {
                            Summary("Click to expand")
                            P("This content is hidden by default and revealed when the summary is clicked. It's perfect for FAQs, toggleable content, or progressive disclosure patterns.")
                                .style("margin", "1rem 0 0 0")
                        }
                        .style("margin-bottom", "1rem")
                        .style("padding", "0.5rem")
                        .style("background", "#f8f9fa")
                        .style("border", "1px solid #dee2e6")
                        .style("border-radius", "0.25rem")
                        
                        Details(open: true) {
                            Summary("Advanced Settings")
                                .style("cursor", "pointer")
                                .style("font-weight", "600")
                            
                            Div {
                                Div {
                                    Label("Enable notifications")
                                        .style("margin-right", "0.5rem")
                                    Input(type: "checkbox", name: "notifications")
                                        .attribute("checked", "checked")
                                }
                                .style("margin", "0.5rem 0")
                                
                                Div {
                                    Label("Dark mode")
                                        .style("margin-right", "0.5rem")
                                    Input(type: "checkbox", name: "darkmode")
                                }
                                .style("margin", "0.5rem 0")
                            }
                            .style("margin-left", "1rem")
                            .style("margin-top", "0.5rem")
                        }
                        .style("padding", "0.5rem")
                        .style("background", "#e9ecef")
                        .style("border", "1px solid #adb5bd")
                        .style("border-radius", "0.25rem")
                    }
                },
                description: "Details creates a disclosure widget with Summary as the visible heading."
            ).render()
            }
            
            // Progress and Meter
            Section {
            CodeExample(
                title: "Progress and Meter Elements",
                swift: """
// Progress indicators
Progress(value: 0.7, max: 1.0)
Progress(value: 25, max: 100)
Progress() // Indeterminate progress

// Meter gauges
Meter(value: 6, min: 0, max: 10)
    .attribute("title", "6 out of 10")

Meter(value: 0.8, low: 0.25, high: 0.75, optimum: 0.5)
    .style("width", "200px")
""",
                html: """
<!-- Progress indicators -->
<progress value="0.7" max="1.0"></progress>
<progress value="25" max="100"></progress>
<progress></progress> <!-- Indeterminate -->

<!-- Meter gauges -->
<meter value="6" min="0" max="10" title="6 out of 10"></meter>

<meter value="0.8" low="0.25" high="0.75" optimum="0.5" style="width: 200px;"></meter>
""",
                preview: {
                    Fragment {
                        Div {
                            H4("Progress Indicators")
                            Div {
                                P("Download progress (70%):")
                                Progress(value: 0.7, max: 1.0)
                                    .style("width", "100%")
                            }
                            .style("margin-bottom", "1rem")
                            
                            Div {
                                P("Task completion (25/100):")
                                Progress(value: 25, max: 100)
                                    .style("width", "100%")
                            }
                            .style("margin-bottom", "1rem")
                            
                            Div {
                                P("Loading...")
                                Progress()
                                    .style("width", "100%")
                            }
                        }
                        .style("margin-bottom", "2rem")
                        
                        Div {
                            H4("Meter Gauges")
                            Div {
                                P("Disk usage (6GB of 10GB):")
                                Meter(value: 6, min: 0, max: 10)
                                    .attribute("title", "6 out of 10 GB used")
                                    .style("width", "200px")
                            }
                            .style("margin-bottom", "1rem")
                            
                            Div {
                                P("Performance score:")
                                Meter(value: 0.8, low: 0.25, high: 0.75, optimum: 0.5)
                                    .style("width", "200px")
                            }
                        }
                    }
                },
                description: "Progress shows task completion, while Meter displays a gauge within a known range."
            ).render()
            }
            
            // Data Element
            Section {
            CodeExample(
                title: "Data Element",
                swift: """
P {
    Text("The product code is ")
    Data("ABC123", value: "product-abc-123")
    Text(" and the price is ")
    Data("$99.99", value: "99.99")
        .class("price")
}
""",
                html: """
<p>
    The product code is 
    <data value="product-abc-123">ABC123</data>
    and the price is 
    <data value="99.99" class="price">$99.99</data>
</p>
""",
                preview: {
                    P {
                        Text("The product code is ")
                        Data("ABC123", value: "product-abc-123")
                            .style("font-weight", "600")
                            .style("color", "#007bff")
                        Text(" and the price is ")
                        Data("$99.99", value: "99.99")
                            .class("price")
                            .style("font-weight", "600")
                            .style("color", "#28a745")
                    }
                },
                description: "The Data element links content with machine-readable values."
            ).render()
            }
            
            Div {
            Link(href: "/showcase/media-elements", "Media Elements")
                .class("nav-button")
            Link(href: "/showcase/layout-components", "Layout Components")
                .class("nav-button nav-button-next")
            }
            .class("navigation-links")
            }
            .class("showcase-container")
            
        }
    }
}