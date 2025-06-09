import Foundation
import Swiftlets

// MARK: - SwiftUI-Style Components

struct ProductCard: HTMLComponent {
    let name: String
    let price: Double
    let imageURL: String
    
    var body: some HTMLElement {
        Div {
            Img(src: imageURL, alt: name)
            .style("width", "100%")
            .style("height", "200px")
            .style("object-fit", "cover")
            
            Div {
            H3(name)
            .style("margin", "0.5rem 0")
            
            P("$\(String(format: "%.2f", price))")
            .style("color", "#007bff")
            .style("font-weight", "bold")
            .style("margin", "0.5rem 0")
            
            Button("Add to Cart")
            .class("btn btn-primary")
            .style("width", "100%")
            }
            .style("padding", "1rem")
        }
        .class("product-card")
        .style("border", "1px solid #dee2e6")
        .style("border-radius", "0.5rem")
        .style("overflow", "hidden")
        .style("transition", "transform 0.2s")
        .style("cursor", "pointer")
    }
}

struct FeatureSection: HTMLComponent {
    let icon: String
    let title: String
    let description: String
    
    var body: some HTMLElement {
        VStack(spacing: 15) {
            Div {
            Text(icon)
            .style("font-size", "3rem")
            }
            
            H3(title)
            .style("margin", "0")
            
            P(description)
            .style("color", "#6c757d")
            .style("margin", "0")
        }
        .style("text-align", "center")
        .style("padding", "2rem")
    }
}

struct CodeComparison: HTMLComponent {
    let swiftUICode: String
    let swiftletsCode: String
    
    var body: some HTMLElement {
        Grid(columns: .count(2), spacing: 20) {
            VStack(spacing: 10) {
            H4("SwiftUI")
            .style("margin", "0")
            Pre {
            Code(swiftUICode)
            }
            .style("background", "#f5f5f5")
            .style("padding", "1rem")
            .style("border-radius", "6px")
            .style("overflow-x", "auto")
            }
            
            VStack(spacing: 10) {
            H4("Swiftlets")
            .style("margin", "0")
            Pre {
            Code(swiftletsCode)
            }
            .style("background", "#f5f5f5")
            .style("padding", "1rem")
            .style("border-radius", "6px")
            .style("overflow-x", "auto")
            }
        }
    }
}

// MARK: - Main Page

@main
struct SwiftUIStyleShowcase: SwiftletMain {
    var title: String { "SwiftUI-Style API - Swiftlets" }
    
    var meta: [String: String] {
        ["viewport": "width=device-width, initial-scale=1.0"]
    }
    
    var body: some HTMLElement {
        Html {
            Head {
            Title(title)
            Meta(name: "viewport", content: "width=device-width, initial-scale=1.0")
            LinkElement(rel: "stylesheet", href: "/styles/main.css")
            Style("""
            .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            }
            .example-section {
            background: #f8f9fa;
            padding: 2rem;
            border-radius: 0.5rem;
            margin: 2rem 0;
            }
            .code-example {
            background: #282c34;
            color: #abb2bf;
            padding: 1.5rem;
            border-radius: 0.5rem;
            overflow-x: auto;
            font-family: 'Monaco', 'Menlo', monospace;
            font-size: 0.9rem;
            line-height: 1.5;
            }
            """)
            }
            Body {
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
            
            // Main Content
            Container(maxWidth: .large) {
            VStack(spacing: 50) {
            // Header
            VStack(spacing: 20) {
                H1("SwiftUI-Style Components")
                    .style("text-align", "center")
                    .style("margin-top", "3rem")
                
                P("Build web UIs with the same declarative, component-based approach as SwiftUI")
                    .style("text-align", "center")
                    .style("font-size", "1.25rem")
                    .style("color", "#6c757d")
            }
            
            // Introduction
            Section {
                H2("🎨 The Power of SwiftUI-Style Components")
                
                P("""
                Swiftlets brings the elegance of SwiftUI to web development. Define reusable components 
                with the HTMLComponent protocol, compose them together, and build complex UIs from simple parts.
                """)
                .style("font-size", "1.1rem")
                .style("line-height", "1.8")
                
                // Feature Grid
                Grid(columns: .count(3), spacing: 30) {
                    FeatureSection(
                        icon: "🧩",
                        title: "Composable",
                        description: "Build complex UIs from simple, reusable components"
                    ).body
                    
                    FeatureSection(
                        icon: "🛡️",
                        title: "Type-Safe",
                        description: "Catch errors at compile time, not runtime"
                    ).body
                    
                    FeatureSection(
                        icon: "🚀",
                        title: "Familiar",
                        description: "If you know SwiftUI, you already know Swiftlets"
                    ).body
                }
                .style("margin", "3rem 0")
            }
            
            // Basic Component Example
            Section {
                H2("📦 Creating Components")
                
                P("Define components using the HTMLComponent protocol:")
                
                Pre {
                    Code("""
                    struct Greeting: HTMLComponent {
                        let name: String
                        
                        var body: some HTMLElement {
                            VStack(spacing: 10) {
                                H2("Hello, \\(name)!")
                                    .style("color", "#007bff")
                                
                                P("Welcome to Swiftlets")
                                    .style("font-size", "1.1rem")
                            }
                            .style("text-align", "center")
                            .style("padding", "2rem")
                            .style("background", "#f8f9fa")
                            .style("border-radius", "0.5rem")
                        }
                    }
                    
                    // Use it anywhere:
                    Greeting(name: "Developer").body
                    """)
                }
                .class("code-example")
                
                // Live example
                Div {
                    H3("Result:")
                    struct LiveGreeting: HTMLComponent {
                        let name: String
                        
                        var body: some HTMLElement {
                            VStack(spacing: 10) {
                                H2("Hello, \(name)!")
                                    .style("color", "#007bff")
                                
                                P("Welcome to Swiftlets")
                                    .style("font-size", "1.1rem")
                            }
                            .style("text-align", "center")
                            .style("padding", "2rem")
                            .style("background", "#f8f9fa")
                            .style("border-radius", "0.5rem")
                        }
                    }
                    LiveGreeting(name: "Developer").body
                }
                .class("example-section")
            }
            
            // Product Grid Example
            Section {
                H2("🛍️ Real-World Example: Product Grid")
                
                P("Here's a complete example showing a product grid with reusable components:")
                
                Pre {
                    Code("""
                    struct ProductGrid: HTMLComponent {
                        struct Product {
                            let name: String
                            let price: Double
                            let imageURL: String
                        }
                        
                        let products: [Product]
                        
                        var body: some HTMLElement {
                            VStack(spacing: 30) {
                                H2("Featured Products")
                                
                                If(products.isEmpty) {
                                    P("No products available")
                                        .style("text-align", "center")
                                        .style("color", "#6c757d")
                                } else: {
                                    Grid(columns: .count(3), spacing: 20) {
                                        ForEach(products) { product in
                                            ProductCard(
                                                name: product.name,
                                                price: product.price,
                                                imageURL: product.imageURL
                                            ).body
                                        }
                                    }
                                }
                            }
                        }
                    }
                    """)
                }
                .class("code-example")
                
                // Live demo
                Div {
                    H3("Live Demo:")
                    
                    struct Product {
                        let name: String
                        let price: Double
                        let imageURL: String
                    }
                    
                    let sampleProducts = [
                        Product(name: "Wireless Headphones", price: 99.99, imageURL: "https://via.placeholder.com/300x200/4f46e5/ffffff?text=Headphones"),
                        Product(name: "Smart Watch", price: 249.99, imageURL: "https://via.placeholder.com/300x200/0891b2/ffffff?text=Smart+Watch"),
                        Product(name: "Laptop Stand", price: 49.99, imageURL: "https://via.placeholder.com/300x200/059669/ffffff?text=Laptop+Stand")
                    ]
                    
                    VStack(spacing: 30) {
                        H2("Featured Products")
                        
                        Grid(columns: .count(3), spacing: 20) {
                            ForEach(sampleProducts) { product in
                                ProductCard(
                                    name: product.name,
                                    price: product.price,
                                    imageURL: product.imageURL
                                ).body
                            }
                        }
                    }
                }
                .class("example-section")
            }
            
            // Comparison with SwiftUI
            Section {
                H2("🔄 SwiftUI to Swiftlets")
                
                P("The syntax is intentionally similar to SwiftUI, making it easy to transition:")
                
                CodeComparison(
                    swiftUICode: """
                    struct ContentView: View {
                        var body: some View {
                            VStack(spacing: 20) {
                                Text("Hello, SwiftUI!")
                                    .font(.title)
                                    .foregroundColor(.blue)
                                
                                Button("Click Me") {
                                    print("Clicked!")
                                }
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                            }
                        }
                    }
                    """,
                    swiftletsCode: """
                    struct ContentView: HTMLComponent {
                        var body: some HTMLElement {
                            VStack(spacing: 20) {
                                H1("Hello, Swiftlets!")
                                    .style("color", "blue")
                                
                                Button("Click Me")
                                    .style("padding", "10px 20px")
                                    .style("background", "blue")
                                    .style("color", "white")
                                    .style("border-radius", "8px")
                                    .style("border", "none")
                            }
                        }
                    }
                    """
                ).body
            }
            
            // Advanced Features
            Section {
                H2("🚀 Advanced Features")
                
                Grid(columns: .count(2), spacing: 30) {
                    VStack(spacing: 15) {
                        H3("Control Flow")
                        Pre {
                            Code("""
                            // Conditional rendering
                            If(isLoggedIn) {
                                UserDashboard(user: currentUser).body
                            } else: {
                                LoginForm().body
                            }
                            
                            // Loops with ForEach
                            ForEach(items) { item in
                                ItemRow(item: item).body
                            }
                            """)
                        }
                        .style("background", "#f5f5f5")
                        .style("padding", "1rem")
                        .style("border-radius", "6px")
                        .style("font-size", "0.9rem")
                    }
                    
                    VStack(spacing: 15) {
                        H3("Composition")
                        Pre {
                            Code("""
                            struct Page: HTMLComponent {
                                var body: some HTMLElement {
                                    VStack {
                                        Header().body
                                        MainContent().body
                                        Footer().body
                                    }
                                }
                            }
                            """)
                        }
                        .style("background", "#f5f5f5")
                        .style("padding", "1rem")
                        .style("border-radius", "6px")
                        .style("font-size", "0.9rem")
                    }
                }
            }
            
            // Call to Action
            Section {
                VStack(spacing: 20) {
                    H2("Ready to Build?")
                        .style("text-align", "center")
                    
                    P("Start creating your own SwiftUI-style components with Swiftlets today!")
                        .style("text-align", "center")
                        .style("font-size", "1.2rem")
                    
                    HStack(spacing: 20) {
                        Link(href: "/docs/concepts/html-dsl") {
                            Button("Read the Docs")
                                .class("btn btn-primary")
                                .style("padding", "12px 30px")
                                .style("font-size", "1.1rem")
                        }
                        
                        Link(href: "https://github.com/codelynx/swiftlets") {
                            Button("View on GitHub")
                                .class("btn btn-secondary")
                                .style("padding", "12px 30px")
                                .style("font-size", "1.1rem")
                        }
                        .attribute("target", "_blank")
                    }
                    .style("justify-content", "center")
                }
                .style("padding", "3rem")
                .style("background", "#f8f9fa")
                .style("border-radius", "0.5rem")
                .style("margin", "3rem 0")
            }
            }
            }
            .style("padding", "2rem 0 4rem 0")
            
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
}