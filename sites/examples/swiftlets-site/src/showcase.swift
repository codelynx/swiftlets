import Foundation
import Swiftlets

@main
struct ShowcasePage {
    static func main() async throws {
        let request = try JSONDecoder().decode(Request.self, from: FileHandle.standardInput.readDataToEndOfFile())
        
        let html = Html {
            Head {
                Title("Showcase - Swiftlets")
                Meta(name: "viewport", content: "width=device-width, initial-scale=1.0")
                LinkElement(rel: "stylesheet", href: "/styles/main.css")
            }
            Body {
                // Navigation
                Nav {
                    Container(maxWidth: .xxl) {
                        HStack {
                            Link(href: "/") {
                                H1("Swiftlets").style("margin", "0")
                            }
                            Spacer()
                            HStack(spacing: 20) {
                                Link(href: "/docs", "Documentation")
                                Link(href: "/showcase", "Showcase").class("active")
                                Link(href: "/about", "About")
                                Link(href: "https://github.com/swiftlets/swiftlets", "GitHub")
                                    .attribute("target", "_blank")
                            }
                        }
                        .style("align-items", "center")
                    }
                }
                .style("background", "#f8f9fa")
                .style("padding", "1rem 0")
                .style("border-bottom", "1px solid #dee2e6")
                
                // Showcase Content
                Container(maxWidth: .xxl) {
                    VStack(spacing: 50) {
                        // Header
                        VStack(spacing: 20) {
                            H1("Component Showcase")
                                .style("text-align", "center")
                            P("Explore the components and layouts available in Swiftlets")
                                .style("text-align", "center")
                                .style("font-size", "1.25rem")
                        }
                        
                        // Layout Examples
                        Section {
                            H2("Layouts")
                            
                            VStack(spacing: 30) {
                                // HStack Example
                                Div {
                                    H3("HStack")
                                    P("Horizontal stack with spacing")
                                    
                                    HStack(spacing: 20) {
                                        Button("Button 1")
                                        Button("Button 2")
                                        Button("Button 3")
                                    }
                                    .style("padding", "1rem")
                                    .style("background", "#f8f9fa")
                                    .style("border-radius", "0.5rem")
                                }
                                
                                // Grid Example
                                Div {
                                    H3("Grid")
                                    P("Responsive grid layout")
                                    
                                    Grid(columns: .count(3), spacing: 20) {
                                        ForEach(1...6) { i in
                                            Div {
                                                H4("Card \(i)")
                                                P("This is a sample card component")
                                            }
                                            .style("padding", "1.5rem")
                                            .style("background", "white")
                                            .style("border", "1px solid #dee2e6")
                                            .style("border-radius", "0.5rem")
                                            .style("box-shadow", "0 1px 3px rgba(0,0,0,0.1)")
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Form Components
                        Section {
                            H2("Form Components")
                            
                            Form(action: "/submit", method: "POST") {
                                VStack(spacing: 20) {
                                    Div {
                                        Label("Text Input")
                                        Input(type: "text", name: "username", placeholder: "Enter username")
                                    }
                                    
                                    Div {
                                        Label("Email Input")
                                        Input(type: "email", name: "email", placeholder: "user@example.com")
                                    }
                                    
                                    Div {
                                        Label("Select")
                                        Select(name: "country") {
                                            Option("Choose a country", value: "")
                                            Option("United States", value: "us")
                                            Option("United Kingdom", value: "uk")
                                            Option("Canada", value: "ca")
                                        }
                                    }
                                    
                                    Div {
                                        Label("Textarea")
                                        TextArea(name: "message", rows: 4, placeholder: "Enter your message")
                                    }
                                    
                                    Button("Submit", type: "submit")
                                        .class("btn-primary")
                                }
                            }
                            .style("max-width", "500px")
                        }
                        
                        // Typography
                        Section {
                            H2("Typography")
                            
                            VStack(spacing: 20) {
                                H1("Heading 1")
                                H2("Heading 2")
                                H3("Heading 3")
                                H4("Heading 4")
                                H5("Heading 5")
                                H6("Heading 6")
                                
                                P {
                                    Text("This is a paragraph with some ")
                                    Strong("bold text")
                                    Text(", some ")
                                    Em("italic text")
                                    Text(", and some ")
                                    Code("inline code")
                                    Text(".")
                                }
                                
                                BlockQuote {
                                    P("This is a blockquote. It's great for highlighting important information or quotes.")
                                }
                            }
                        }
                        
                        // Tables
                        Section {
                            H2("Tables")
                            
                            Table {
                                THead {
                                    TR {
                                        TH("Name")
                                        TH("Language")
                                        TH("Platform")
                                    }
                                }
                                TBody {
                                    TR {
                                        TD("Swiftlets")
                                        TD("Swift")
                                        TD("Server-side")
                                    }
                                    TR {
                                        TD("SwiftUI")
                                        TD("Swift")
                                        TD("iOS/macOS")
                                    }
                                    TR {
                                        TD("React")
                                        TD("JavaScript")
                                        TD("Web")
                                    }
                                }
                            }
                            .class("table")
                        }
                    }
                }
                .style("padding", "3rem 0")
                
                // Footer
                Footer {
                    Container(maxWidth: .large) {
                        HStack {
                            P("© 2025 Swiftlets Project")
                            Spacer()
                            HStack(spacing: 20) {
                                Link(href: "https://github.com/swiftlets/swiftlets", "GitHub")
                                Link(href: "/docs", "Docs")
                                Link(href: "/showcase", "Examples")
                            }
                        }
                        .style("align-items", "center")
                    }
                }
                .style("padding", "2rem 0")
                .style("border-top", "1px solid #dee2e6")
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