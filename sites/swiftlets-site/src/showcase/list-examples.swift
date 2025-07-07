import Swiftlets

@main
struct ShowcaseListsPage: SwiftletMain {
    var title = "Lists - Swiftlets Showcase"
    
    var body: some HTMLElement {
        Fragment {
            showcaseStyles()
            navigation()
            header()
            mainContent()
        }
    }
    
    @HTMLBuilder
    func navigation() -> some HTMLElement {
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
    }
    
    @HTMLBuilder
    func header() -> some HTMLElement {
        Div {
            Div {
                H1("Lists")
                P("Examples of HTML list elements including unordered lists, ordered lists, and definition lists")
            }
            .class("showcase-container")
        }
        .class("showcase-header")
    }
    
    @HTMLBuilder
    func mainContent() -> some HTMLElement {
        Div {
            // Breadcrumb
            Div {
                Link(href: "/showcase", "← Back to Showcase")
            }
            .style("margin-bottom", "2rem")
            
            unorderedListExample()
            orderedListExample()
            definitionListExample()
            styledListExample()
            mixedListExample()
            
            // Navigation links
            Div {
                Link(href: "/showcase/text-formatting", "Text Formatting")
                    .class("nav-button")
                Link(href: "/showcase/forms", "Forms")
                    .class("nav-button nav-button-next")
            }
            .class("navigation-links")
        }
        .class("showcase-container")
    }
    
    @HTMLBuilder
    func unorderedListExample() -> some HTMLElement {
        CodeExample(
            title: "Unordered List",
            swift: """
            UL {
                LI("First item")
                LI("Second item")
                LI("Third item with nested list") {
                    UL {
                        LI("Nested item 1")
                        LI("Nested item 2")
                    }
                }
            }
            """,
            html: """
            <ul>
                <li>First item</li>
                <li>Second item</li>
                <li>Third item with nested list
                    <ul>
                        <li>Nested item 1</li>
                        <li>Nested item 2</li>
                    </ul>
                </li>
            </ul>
            """,
            preview: {
                UL {
                    LI("First item")
                    LI("Second item")
                    LI {
                        Text("Third item with nested list")
                        UL {
                            LI("Nested item 1")
                            LI("Nested item 2")
                        }
                        .style("margin-top", "0.5rem")
                    }
                }
            },
            description: "Basic unordered list with nested items."
        ).render()
    }
    
    @HTMLBuilder
    func orderedListExample() -> some HTMLElement {
        CodeExample(
            title: "Ordered List",
            swift: """
            OL {
                LI("First step")
                LI("Second step")
                LI("Third step")
                LI("Fourth step")
            }
            .style("counter-reset", "item")
            """,
            html: """
            <ol style="counter-reset: item">
                <li>First step</li>
                <li>Second step</li>
                <li>Third step</li>
                <li>Fourth step</li>
            </ol>
            """,
            preview: {
                OL {
                    LI("First step")
                    LI("Second step")
                    LI("Third step")
                    LI("Fourth step")
                }
            },
            description: "Numbered list for sequential items or steps."
        ).render()
    }
    
    @HTMLBuilder
    func definitionListExample() -> some HTMLElement {
        CodeExample(
            title: "Definition List",
            swift: """
            DL {
                DT("HTML")
                DD("HyperText Markup Language - the standard markup language for web pages")
                
                DT("CSS")
                DD("Cascading Style Sheets - describes how HTML elements are displayed")
                
                DT("JavaScript")
                DD("A programming language that enables interactive web pages")
            }
            """,
            html: """
            <dl>
                <dt>HTML</dt>
                <dd>HyperText Markup Language - the standard markup language for web pages</dd>
                
                <dt>CSS</dt>
                <dd>Cascading Style Sheets - describes how HTML elements are displayed</dd>
                
                <dt>JavaScript</dt>
                <dd>A programming language that enables interactive web pages</dd>
            </dl>
            """,
            preview: {
                DL {
                    DT("HTML")
                        .style("font-weight", "600")
                        .style("color", "#2c3e50")
                    DD("HyperText Markup Language - the standard markup language for web pages")
                        .style("margin-left", "2rem")
                        .style("margin-bottom", "1rem")
                        .style("color", "#6c757d")
                    
                    DT("CSS")
                        .style("font-weight", "600")
                        .style("color", "#2c3e50")
                    DD("Cascading Style Sheets - describes how HTML elements are displayed")
                        .style("margin-left", "2rem")
                        .style("margin-bottom", "1rem")
                        .style("color", "#6c757d")
                    
                    DT("JavaScript")
                        .style("font-weight", "600")
                        .style("color", "#2c3e50")
                    DD("A programming language that enables interactive web pages")
                        .style("margin-left", "2rem")
                        .style("color", "#6c757d")
                }
            },
            description: "Definition lists for terms and their descriptions."
        ).render()
    }
    
    @HTMLBuilder
    func styledListExample() -> some HTMLElement {
        CodeExample(
            title: "Styled List",
            swift: """
            UL {
                LI("✅ Featured item with custom styling")
                LI("🎯 Another styled item")
                LI("🚀 Third styled item")
            }
            .style("list-style", "none")
            .style("padding-left", "0")
            """,
            html: """
            <ul style="list-style: none; padding-left: 0">
                <li>✅ Featured item with custom styling</li>
                <li>🎯 Another styled item</li>
                <li>🚀 Third styled item</li>
            </ul>
            """,
            preview: {
                UL {
                    LI("✅ Featured item with custom styling")
                        .style("padding", "0.5rem 0")
                    LI("🎯 Another styled item")
                        .style("padding", "0.5rem 0")
                    LI("🚀 Third styled item")
                        .style("padding", "0.5rem 0")
                }
                .style("list-style", "none")
                .style("padding-left", "0")
                .style("background", "#f8f9fa")
                .style("padding", "1rem")
                .style("border-radius", "0.5rem")
            },
            description: "Custom styled lists with icons and formatting."
        ).render()
    }
    
    @HTMLBuilder
    func mixedListExample() -> some HTMLElement {
        CodeExample(
            title: "Mixed List Types",
            swift: """
            Div {
                H3("Recipe Instructions")
                OL {
                    LI("Gather ingredients:")
                    UL {
                        LI("2 cups flour")
                        LI("1 cup sugar")
                        LI("3 eggs")
                    }
                    LI("Mix dry ingredients")
                    LI("Add wet ingredients")
                    LI("Bake at 350°F for 30 minutes")
                }
            }
            """,
            html: """
            <div>
                <h3>Recipe Instructions</h3>
                <ol>
                    <li>Gather ingredients:</li>
                    <ul>
                        <li>2 cups flour</li>
                        <li>1 cup sugar</li>
                        <li>3 eggs</li>
                    </ul>
                    <li>Mix dry ingredients</li>
                    <li>Add wet ingredients</li>
                    <li>Bake at 350°F for 30 minutes</li>
                </ol>
            </div>
            """,
            preview: {
                Div {
                    H3("Recipe Instructions")
                        .style("color", "#2c3e50")
                        .style("margin-bottom", "1rem")
                    OL {
                        LI {
                            Text("Gather ingredients:")
                            UL {
                                LI("2 cups flour")
                                LI("1 cup sugar")
                                LI("3 eggs")
                            }
                            .style("margin", "0.5rem 0 0.5rem 1rem")
                            .style("list-style-type", "circle")
                        }
                        LI("Mix dry ingredients")
                        LI("Add wet ingredients")
                        LI("Bake at 350°F for 30 minutes")
                    }
                }
                .style("background", "#fff5f5")
                .style("padding", "1.5rem")
                .style("border-radius", "0.5rem")
                .style("border", "1px solid #fed7d7")
            },
            description: "Combining ordered and unordered lists for complex content."
        ).render()
    }
}