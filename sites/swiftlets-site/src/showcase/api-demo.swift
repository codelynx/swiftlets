import Swiftlets

// This page demonstrates the new SwiftUI-style @main API
@main
struct APIDemo: SwiftletMain {
    // Property wrappers for accessing request data
    @Query("name") var userName: String?
    @Query("filter") var filter: String?
    @Cookie("theme", default: "light") var theme: String?
    
    // Page metadata
    var title = "SwiftUI-Style API Demo"
    var meta = ["description": "Interactive demo of the new SwiftUI-style Swiftlets API"]
    
    // The body property defines the page content
    var body: some HTMLElement {
        Fragment {
            // Navigation
            Nav {
                Container(maxWidth: .xl) {
                    HStack {
                        Link(href: "/") {
                            H1("Swiftlets").style("margin", "0")
                        }
                        Spacer()
                        HStack(spacing: 20) {
                            Link(href: "/docs", "Documentation")
                            Link(href: "/showcase", "Showcase").class("active")
                            Link(href: "/about", "About")
                        }
                    }
                    .style("align-items", "center")
                }
            }
            .style("background", "#f8f9fa")
            .style("padding", "1rem 0")
            .style("border-bottom", "1px solid #dee2e6")
            
            Main {
                heroSection()
                interactiveDemo()
                codeExample()
                featuresSection()
            }
            .style("max-width", "1024px")
            .style("margin", "0 auto")
            .style("padding", "2rem 20px")
            
            // Footer
            Footer {
                Container(maxWidth: .large) {
                    HStack {
                        P("© 2025 Swiftlets Project. MIT Licensed.")
                            .style("margin", "0")
                            .style("color", "#718096")
                        Spacer()
                        Link(href: "https://github.com/codelynx/swiftlets", "GitHub")
                            .style("color", "#667eea")
                    }
                    .style("align-items", "center")
                }
            }
            .style("padding", "2rem 0")
            .style("border-top", "1px solid #e2e8f0")
            .style("margin-top", "3rem")
        }
    }
    
    @HTMLBuilder
    func heroSection() -> some HTMLElement {
        Div {
            H1("SwiftUI-Style API Demo")
            P("This page is built using the new @main API with zero boilerplate!")
                .style("font-size", "1.25rem")
                .style("color", "#718096")
        }
        .style("text-align", "center")
        .style("padding", "3rem 0")
        .style("border-bottom", "1px solid #e2e8f0")
        .style("margin-bottom", "3rem")
    }
    
    @HTMLBuilder
    func interactiveDemo() -> some HTMLElement {
        Div {
            H2("Try It Out!")
                .style("margin-bottom", "2rem")
            
            // Show current values
            Div {
                P("Current values from property wrappers:")
                    .style("font-weight", "600")
                UL {
                    LI("@Query(\"name\"): \(userName ?? "not set")")
                    LI("@Query(\"filter\"): \(filter ?? "not set")")
                    LI("@Cookie(\"theme\"): \(theme ?? "light")")
                }
            }
            .style("background", "#e6f3ff")
            .style("border", "1px solid #3182ce")
            .style("border-radius", "8px")
            .style("padding", "1rem")
            .style("margin-bottom", "2rem")
            
            // Form to test query parameters
            formSection()
        }
        .style("background", "#f7fafc")
        .style("padding", "2rem")
        .style("border-radius", "12px")
        .style("margin-bottom", "3rem")
    }
    
    @HTMLBuilder
    func formSection() -> some HTMLElement {
        Div {
            H3("Test Query Parameters")
                .style("margin-bottom", "1.5rem")
            
            Form(action: "/showcase/api-demo", method: "GET") {
                Div {
                    Label("Your Name:")
                        .style("display", "block")
                        .style("margin-bottom", "0.5rem")
                        .style("font-weight", "600")
                    Input(type: "text", name: "name", value: userName ?? "", placeholder: "Enter your name")
                        .style("width", "100%")
                        .style("padding", "0.5rem")
                        .style("border", "1px solid #cbd5e0")
                        .style("border-radius", "4px")
                }
                .style("margin-bottom", "1rem")
                
                Div {
                    Label("Filter:")
                        .style("display", "block")
                        .style("margin-bottom", "0.5rem")
                        .style("font-weight", "600")
                    Select(name: "filter") {
                        Option("All", value: "all", selected: filter == "all" || filter == nil)
                        Option("Active", value: "active", selected: filter == "active")
                        Option("Completed", value: "completed", selected: filter == "completed")
                    }
                    .style("width", "100%")
                    .style("padding", "0.5rem")
                    .style("border", "1px solid #cbd5e0")
                    .style("border-radius", "4px")
                }
                .style("margin-bottom", "1.5rem")
                
                Button("Update", type: "submit")
                    .style("background", "#667eea")
                    .style("color", "white")
                    .style("padding", "0.75rem 2rem")
                    .style("border", "none")
                    .style("border-radius", "8px")
                    .style("font-weight", "600")
                    .style("cursor", "pointer")
            }
        }
    }
    
    @HTMLBuilder
    func codeExample() -> some HTMLElement {
        Div {
            H2("How This Page Works")
                .style("margin-bottom", "1rem")
            P("This entire page is created with just a few lines of declarative code:")
                .style("margin-bottom", "1.5rem")
            
            Pre {
                Code(codeSnippet)
            }
            .style("background", "#2d3748")
            .style("color", "#e2e8f0")
            .style("padding", "1.5rem")
            .style("border-radius", "8px")
            .style("overflow-x", "auto")
        }
        .style("background", "white")
        .style("padding", "2rem")
        .style("border-radius", "12px")
        .style("box-shadow", "0 2px 4px rgba(0,0,0,0.1)")
        .style("margin-bottom", "3rem")
    }
    
    @HTMLBuilder
    func featuresSection() -> some HTMLElement {
        Div {
            H2("Key Features")
                .style("margin-bottom", "2rem")
            
            Div {
                featureItem(icon: "🎯", title: "Zero Boilerplate", description: "No JSON encoding/decoding, no request parsing, no response building. Just declare what you need.")
                featureItem(icon: "📝", title: "Property Wrappers", description: "@Query, @FormValue, @JSONBody, @Cookie, and @Environment give you direct access to request data.")
                featureItem(icon: "🔧", title: "Type-Safe", description: "All property wrappers are strongly typed with automatic conversions.")
                featureItem(icon: "⚡", title: "SwiftUI-Like", description: "If you know SwiftUI, you already know how to use this API.")
            }
            .style("display", "grid")
            .style("grid-template-columns", "repeat(auto-fit, minmax(250px, 1fr))")
            .style("gap", "2rem")
        }
        .style("background", "#f7fafc")
        .style("padding", "2rem")
        .style("border-radius", "12px")
    }
    
    @HTMLBuilder
    func featureItem(icon: String, title: String, description: String) -> some HTMLElement {
        Div {
            H4(icon + " " + title)
                .style("margin-bottom", "0.5rem")
            P(description)
                .style("color", "#718096")
                .style("line-height", "1.6")
        }
    }
    
    // Store code snippet as a static string to avoid inline complexity
    let codeSnippet = """
@main
struct APIDemo: SwiftletMain {
    @Query("name") var userName: String?
    @Query("filter") var filter: String?
    @Cookie("theme", default: "light") var theme: String?
    
    var title = "SwiftUI-Style API Demo"
    var meta = ["description": "Interactive demo"]
    
    var body: some HTMLElement {
        // Your content here
    }
}
"""
}