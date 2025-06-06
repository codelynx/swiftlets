import Foundation
import SwiftletsHTML

// Comprehensive showcase of all HTML elements

let page = Html {
    Head {
        Meta(charset: "utf-8")
        Title("All HTML Elements - Swiftlets Showcase")
        RawHTML("""
        <style>
            body {
                font-family: -apple-system, system-ui, sans-serif;
                max-width: 1200px;
                margin: 0 auto;
                padding: 20px;
                line-height: 1.6;
            }
            section {
                margin: 40px 0;
                padding: 20px;
                border: 1px solid #e0e0e0;
                border-radius: 8px;
            }
            h2 {
                color: #333;
                border-bottom: 2px solid #007bff;
                padding-bottom: 10px;
            }
            table {
                border-collapse: collapse;
                width: 100%;
                margin: 20px 0;
            }
            th, td {
                border: 1px solid #ddd;
                padding: 8px;
                text-align: left;
            }
            th {
                background-color: #f5f5f5;
            }
            form {
                display: flex;
                flex-direction: column;
                gap: 15px;
                max-width: 500px;
            }
            label {
                font-weight: bold;
            }
            input, textarea, select {
                padding: 8px;
                border: 1px solid #ddd;
                border-radius: 4px;
            }
            button {
                background: #007bff;
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
            }
            button:hover {
                background: #0056b3;
            }
            .example {
                background: #f8f9fa;
                padding: 15px;
                border-radius: 4px;
                margin: 10px 0;
            }
        </style>
        """)
    }
    Body {
        Header {
            H1("Swiftlets HTML Elements Showcase")
            Nav {
                UL {
                    LI { A(href: "#lists", "Lists") }
                    LI { A(href: "#tables", "Tables") }
                    LI { A(href: "#forms", "Forms") }
                    LI { A(href: "#semantic", "Semantic") }
                    LI { A(href: "#inline", "Inline") }
                }
                .style("list-style", "none")
                .style("display", "flex")
                .style("gap", "20px")
                .padding(0)
            }
        }
        
        Main {
            // Lists Section
            Section {
                H2("Lists")
                    .id("lists")
                
                Div {
                    H3("Unordered List")
                    UL {
                        LI("Swift")
                        LI("SwiftUI")
                        LI("Swiftlets")
                    }
                }
                .class("example")
                
                Div {
                    H3("Ordered List")
                    OL {
                        LI("Install Swift")
                        LI("Create Package")
                        LI("Write Code")
                        LI("Build & Run")
                    }
                }
                .class("example")
                
                Div {
                    H3("Definition List")
                    DL {
                        DT("HTML")
                        DD("HyperText Markup Language - the standard markup language for web pages")
                        
                        DT("CSS")
                        DD("Cascading Style Sheets - describes how HTML elements are displayed")
                        
                        DT("JavaScript")
                        DD("Programming language that enables interactive web pages")
                    }
                }
                .class("example")
            }
            
            // Tables Section
            Section {
                H2("Tables")
                    .id("tables")
                
                Table {
                    Caption("Framework Comparison")
                    THead {
                        TR {
                            TH("Framework")
                            TH("Language")
                            TH("Type")
                            TH("Year")
                        }
                    }
                    TBody {
                        TR {
                            TD("Swiftlets")
                            TD("Swift")
                            TD("Dynamic SSR")
                            TD("2025")
                        }
                        TR {
                            TD("Ignite")
                            TD("Swift")
                            TD("Static Site")
                            TD("2024")
                        }
                        TR {
                            TD("Vapor")
                            TD("Swift")
                            TD("Full Stack")
                            TD("2016")
                        }
                    }
                }
            }
            
            // Forms Section
            Section {
                H2("Forms")
                    .id("forms")
                
                Form(action: "/submit", method: "POST") {
                    FieldSet {
                        Legend("Personal Information")
                        
                        Label("Name:", for: "name")
                        Input(type: "text", name: "name", placeholder: "John Doe")
                        
                        Label("Email:", for: "email")
                        Input(type: "email", name: "email", placeholder: "john@example.com")
                        
                        Label("Country:", for: "country")
                        Select(name: "country") {
                            Option("Select a country", value: "")
                            Option("United States", value: "us")
                            Option("Canada", value: "ca")
                            Option("United Kingdom", value: "uk")
                            Option("Australia", value: "au")
                        }
                    }
                    
                    FieldSet {
                        Legend("Additional Information")
                        
                        Label("Message:", for: "message")
                        TextArea(name: "message", rows: 5, placeholder: "Tell us about yourself...")
                        
                        Label {
                            Input(type: "checkbox", name: "subscribe", value: "yes")
                            Text(" Subscribe to newsletter")
                        }
                    }
                    
                    Button("Submit Form", type: "submit")
                }
            }
            
            // Semantic Elements Section
            Section {
                H2("Semantic Elements")
                    .id("semantic")
                
                Article {
                    Header {
                        H3("The Power of Semantic HTML")
                        Small("Published on \(Date().description)")
                    }
                    
                    P("Semantic HTML elements clearly describe their meaning to both the browser and the developer.")
                    
                    Figure {
                        BlockQuote {
                            P("The goal of HTML5 is to make the web more semantic.")
                        }
                        FigCaption("- W3C HTML5 Specification")
                    }
                    
                    Footer {
                        P {
                            Text("Tags: ")
                            Code("semantic")
                            Text(", ")
                            Code("html5")
                            Text(", ")
                            Code("accessibility")
                        }
                    }
                }
                .class("example")
            }
            
            // Inline Elements Section
            Section {
                H2("Inline Elements")
                    .id("inline")
                
                P {
                    Text("This paragraph demonstrates various inline elements: ")
                    Strong("bold text")
                    Text(", ")
                    Em("italic text")
                    Text(", ")
                    Code("inline code")
                    Text(", ")
                    Mark("highlighted text")
                    Text(", and ")
                    Small("small text")
                    Text(".")
                }
                
                P {
                    Text("You can also use ")
                    A(href: "#", "links")
                    Text(" and insert")
                    BR()
                    Text("line breaks.")
                }
                
                Pre {
                    Code("""
                    // Code block example
                    func greet(name: String) {
                        print("Hello, \\(name)!")
                    }
                    """)
                }
                
                HR()
                
                BlockQuote {
                    P("SwiftUI-like syntax makes HTML generation intuitive and type-safe.")
                    Footer {
                        Text("— ")
                        Em("Swiftlets Documentation")
                    }
                }
            }
            
            // Media Elements Section
            Aside {
                H2("Media Elements")
                
                P("Images, video, and audio elements are also supported:")
                
                Figure {
                    Img(src: "/placeholder.jpg", alt: "Placeholder image")
                        .style("max-width", "100%")
                    FigCaption("Example image with caption")
                }
                
                P {
                    Text("IFrame example: ")
                    IFrame(src: "https://example.com", title: "Example iframe")
                        .width(300)
                        .height(200)
                }
            }
        }
        
        Footer {
            HR()
            P {
                Text("© 2025 Swiftlets • Process ID: ")
                Code("\(ProcessInfo.processInfo.processIdentifier)")
                Text(" • Generated with ")
                Strong("SwiftletsHTML")
            }
            .center()
        }
    }
}

// Output HTTP response
print("Status: 200")
print("Content-Type: text/html; charset=utf-8")
print("")
print(page.render())