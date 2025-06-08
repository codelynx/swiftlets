import Foundation

@main
struct ShowcaseListsPage {
    static func main() async throws {
        let request = try JSONDecoder().decode(Request.self, from: FileHandle.standardInput.readDataToEndOfFile())
        
        let html = Html {
                Head {
                    Title("Lists - Swiftlets Showcase")
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
                    .class("navbar")
                    
                    // Content
                    Div {
                        Div {
                            // Breadcrumb
                            Div {
                                Link(href: "/showcase", "Showcase")
                                Text(" → ")
                                Text("Lists")
                            }
                            .class("breadcrumb")
                            
                            H1("Lists")
                            P("Examples of HTML list elements including unordered lists, ordered lists, and definition lists.")
                            
                            
                            // Example 1: Unordered List
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
                                        }
                                    }
                                }
                            ).render()
                            
                            // Example 2: Ordered List
                            CodeExample(
                                title: "Ordered List",
                                swift: """
OL {
    LI("First step")
    LI("Second step")
    LI("Third step")
    LI("Fourth step")
}
.class("custom-numbered")
""",
                                html: """
<ol class="custom-numbered">
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
                                    .class("custom-numbered")
                                }
                            ).render()
                            
                            // Example 3: Definition List
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
.class("styled-dl")
""",
                                html: """
<dl class="styled-dl">
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
                                        DD("HyperText Markup Language - the standard markup language for web pages")
                                        
                                        DT("CSS")
                                        DD("Cascading Style Sheets - describes how HTML elements are displayed")
                                        
                                        DT("JavaScript")
                                        DD("A programming language that enables interactive web pages")
                                    }
                                    .class("styled-dl")
                                }
                            ).render()
                            
                            // Example 4: Styled List
                            CodeExample(
                                title: "Styled List",
                                swift: """
UL {
    LI("Featured item with custom styling")
    LI("Another styled item")
    LI("Third styled item")
}
.class("styled-list")
""",
                                html: """
<ul class="styled-list">
    <li>Featured item with custom styling</li>
    <li>Another styled item</li>
    <li>Third styled item</li>
</ul>
""",
                                preview: {
                                    UL {
                                        LI("Featured item with custom styling")
                                        LI("Another styled item")
                                        LI("Third styled item")
                                    }
                                    .class("styled-list")
                                }
                            ).render()
                            
                            // Example 5: Mixed List Types
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
                                        OL {
                                            LI {
                                                Text("Gather ingredients:")
                                                UL {
                                                    LI("2 cups flour")
                                                    LI("1 cup sugar")
                                                    LI("3 eggs")
                                                }
                                            }
                                            LI("Mix dry ingredients")
                                            LI("Add wet ingredients")
                                            LI("Bake at 350°F for 30 minutes")
                                        }
                                    }
                                }
                            ).render()
                            
                            // Navigation
                            Div {
                                Link(href: "/showcase/text-formatting", "Text Formatting")
                                    .class("nav-button")
                                Link(href: "/showcase/tables", "Tables")
                                    .class("nav-button nav-button-next")
                            }
                            .class("navigation-links")
                        }
                        .class("content")
                    }
                    .class("container")
                    
                }
            }
        
        let response = Response(
            status: 200,
            headers: ["Content-Type": "text/html"],
            body: html.render()
        )
        
        let responseData = try JSONEncoder().encode(response)
        FileHandle.standardOutput.write(responseData)
    }
}