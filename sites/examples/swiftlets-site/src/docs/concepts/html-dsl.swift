import Swiftlets

@main
struct HTMLDSLPage: SwiftletMain {
    var title = "HTML DSL - Swiftlets"
    
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
                    Link(href: "/docs", "Documentation").class("active")
                    Link(href: "/showcase", "Showcase")
                    Link(href: "/about", "About")
                    Link(href: "https://github.com/codelynx/swiftlets", "GitHub")
                        .attribute("target", "_blank")
                }
            }
            .style("align-items", "center")
            }
            }
            .style("background", "#f8f9fa")
            .style("padding", "1rem 0")
            .style("border-bottom", "1px solid #dee2e6")
            
            // Content
            Container(maxWidth: .large) {
            VStack(spacing: 40) {
            // Breadcrumb
            HStack(spacing: 10) {
                Link(href: "/docs", "Docs")
                Text("→")
                Link(href: "/docs/concepts", "Core Concepts")
                Text("→")
                Text("HTML DSL")
            }
            .style("color", "#6c757d")
            
            H1("SwiftUI-Like Syntax for the Web")
            
            P("If you've used SwiftUI, you'll feel right at home. Swiftlets brings the same declarative, composable approach to web development.")
                .style("font-size", "1.25rem")
                .style("line-height", "1.8")
            
            // Side by Side Comparison
            Section {
                H2("📱 Familiar Syntax")
                
                Grid(columns: .count(2), spacing: 30) {
                    VStack(spacing: 10) {
                        H4("SwiftUI")
                        Pre {
                            Code("""
                            VStack(spacing: 20) {
                                Text("Hello, World!")
                                    .font(.title)
                                    .foregroundColor(.blue)
                                
                                Button("Click Me") {
                                    print("Clicked!")
                                }
                            }
                            .padding()
                            """)
                        }
                        .style("background", "#f5f5f5")
                        .style("padding", "1rem")
                        .style("border-radius", "6px")
                    }
                    
                    VStack(spacing: 10) {
                        H4("Swiftlets")
                        Pre {
                            Code("""
                            VStack(spacing: 20) {
                                H1("Hello, World!")
                                    .style("color", "blue")
                                
                                Button("Click Me")
                                    .style("padding", "10px")
                            }
                            .style("padding", "1rem")
                            """)
                        }
                        .style("background", "#f5f5f5")
                        .style("padding", "1rem")
                        .style("border-radius", "6px")
                    }
                }
                
                P("The concepts translate directly - stacks, modifiers, and declarative composition.")
                    .style("margin-top", "1rem")
                    .style("font-style", "italic")
            }
            
            // Core Concepts
            Section {
                H2("🎯 Core Concepts")
                
                VStack(spacing: 30) {
                    // Result Builders
                    VStack(spacing: 15) {
                        H3("1. Result Builders")
                        P("Just like SwiftUI uses @ViewBuilder, Swiftlets uses @HTMLBuilder to create declarative syntax:")
                        
                        Pre {
                            Code("""
                            Html {
                                Head {
                                    Title("My Page")
                                }
                                Body {
                                    H1("Welcome!")
                                    P("This is declarative HTML")
                                }
                            }
                            """)
                        }
                        .style("background", "#f5f5f5")
                        .style("padding", "1rem")
                        .style("border-radius", "6px")
                    }
                    
                    // Composability
                    VStack(spacing: 15) {
                        H3("2. Composability")
                        P("Build complex UIs from simple, reusable components:")
                        
                        Pre {
                            Code("""
                            func Card(title: String, content: String) -> some HTML {
                                Div {
                                    H3(title)
                                    P(content)
                                }
                                .class("card")
                                .style("padding", "1rem")
                            }
                            
                            // Use it anywhere
                            Card(title: "Hello", content: "World")
                            """)
                        }
                        .style("background", "#f5f5f5")
                        .style("padding", "1rem")
                        .style("border-radius", "6px")
                    }
                    
                    // Modifiers
                    VStack(spacing: 15) {
                        H3("3. Chainable Modifiers")
                        P("Style and configure elements with familiar modifier syntax:")
                        
                        Pre {
                            Code("""
                            Button("Submit")
                                .class("btn btn-primary")
                                .style("background", "#007bff")
                                .style("color", "white")
                                .attribute("type", "submit")
                                .attribute("data-action", "save")
                            """)
                        }
                        .style("background", "#f5f5f5")
                        .style("padding", "1rem")
                        .style("border-radius", "6px")
                    }
                }
            }
            
            // Layout Components
            Section {
                H2("📐 Layout Components")
                
                P("Swiftlets provides familiar layout primitives:")
                
                Grid(columns: .count(3), spacing: 20) {
                    VStack(spacing: 10) {
                        H4("VStack")
                        Pre {
                            Code("""
                            VStack(spacing: 20) {
                                Text("Top")
                                Text("Middle")
                                Text("Bottom")
                            }
                            """)
                        }
                        .style("background", "#f5f5f5")
                        .style("padding", "0.75rem")
                        .style("border-radius", "6px")
                        .style("font-size", "0.9rem")
                    }
                    
                    VStack(spacing: 10) {
                        H4("HStack")
                        Pre {
                            Code("""
                            HStack(spacing: 10) {
                                Button("Save")
                                Button("Cancel")
                            }
                            """)
                        }
                        .style("background", "#f5f5f5")
                        .style("padding", "0.75rem")
                        .style("border-radius", "6px")
                        .style("font-size", "0.9rem")
                    }
                    
                    VStack(spacing: 10) {
                        H4("Grid")
                        Pre {
                            Code("""
                            Grid(columns: .count(3)) {
                                ForEach(items) { item in
                                    ItemCard(item)
                                }
                            }
                            """)
                        }
                        .style("background", "#f5f5f5")
                        .style("padding", "0.75rem")
                        .style("border-radius", "6px")
                        .style("font-size", "0.9rem")
                    }
                }
            }
            
            // Dynamic Content
            Section {
                H2("🔄 Dynamic Content")
                
                P("Build dynamic UIs with control flow:")
                
                VStack(spacing: 20) {
                    Pre {
                        Code("""
                        // Conditional rendering
                        If(user.isLoggedIn) {
                            P("Welcome, \\(user.name)!")
                        } else: {
                            Link(href: "/login", "Please log in")
                        }
                        
                        // Loops
                        ForEach(products) { product in
                            Div {
                                H3(product.name)
                                P("$\\(product.price)")
                            }
                        }
                        
                        // With index
                        ForEach(items.enumerated()) { index, item in
                            LI("\\(index + 1). \\(item)")
                        }
                        """)
                    }
                    .style("background", "#f5f5f5")
                    .style("padding", "1rem")
                    .style("border-radius", "6px")
                }
            }
            
            // Type Safety
            Section {
                Div {
                    H3("🛡️ Type Safety Built In")
                    P("Unlike template languages, Swiftlets gives you full type safety. Typos become compile errors, not runtime bugs. Your IDE provides autocomplete for every element and modifier.")
                }
                .style("background", "#ecfdf5")
                .style("border-left", "4px solid #10b981")
                .style("padding", "1.5rem")
                .style("margin", "2rem 0")
            }
            
            // Practical Example
            Section {
                H2("💡 Putting It Together")
                
                P("Here's a complete example showing how natural it feels:")
                
                Pre {
                    Code("""
                    struct ProductList: HTMLComponent {
                        let products: [Product]
                        
                        var body: some HTMLElement {
                            Container {
                                H1("Our Products")
                                
                                If(products.isEmpty) {
                                    P("No products available")
                                        .style("color", "#6c757d")
                                } else: {
                                    Grid(columns: .count(3), spacing: 20) {
                                        ForEach(products) { product in
                                            ProductCard(product: product)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    struct ProductCard: HTMLComponent {
                        let product: Product
                        
                        var body: some HTMLElement {
                            Div {
                                Img(src: product.imageURL, alt: product.name)
                                H3(product.name)
                                P("$\\(product.price)")
                                Button("Add to Cart")
                                    .class("btn btn-primary")
                            }
                            .class("product-card")
                        }
                    }
                    """)
                }
                .style("background", "#f5f5f5")
                .style("padding", "1rem")
                .style("border-radius", "6px")
            }
            
            // Next Steps
            Section {
                H2("📚 Keep Learning")
                
                Grid(columns: .count(3), spacing: 20) {
                    Link(href: "/docs/components") {
                        Div {
                            H4("Components Reference →")
                            P("See all available elements")
                                .style("color", "#6c757d")
                        }
                        .class("doc-card")
                        .style("padding", "1.5rem")
                    }
                    .style("text-decoration", "none")
                    .style("color", "inherit")
                    
                    Link(href: "/showcase") {
                        Div {
                            H4("Live Examples →")
                            P("See the DSL in action")
                                .style("color", "#6c757d")
                        }
                        .class("doc-card")
                        .style("padding", "1.5rem")
                    }
                    .style("text-decoration", "none")
                    .style("color", "inherit")
                    
                    Link(href: "/docs/concepts/routing") {
                        Div {
                            H4("Routing →")
                            P("Connect pages together")
                                .style("color", "#6c757d")
                        }
                        .class("doc-card")
                        .style("padding", "1.5rem")
                    }
                    .style("text-decoration", "none")
                    .style("color", "inherit")
                }
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
                    Link(href: "https://github.com/codelynx/swiftlets", "GitHub")
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
}