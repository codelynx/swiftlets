import Swiftlets

@main
struct HTMLDSLPage: SwiftletMain {
    var title = "HTML DSL - Swiftlets"
    
    var body: some HTMLElement {
        Fragment {
            dslStyles()
            navigation()
            heroSection()
            mainContent()
            footer()
        }
    }
    
    @HTMLBuilder
    func dslStyles() -> some HTMLElement {
        Style("""
        /* HTML DSL Page Styles */
        body { 
            margin: 0; 
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            color: #1a202c;
            line-height: 1.6;
            background: #ffffff;
        }
        
        /* Navigation */
        .dsl-nav {
            background: rgba(255, 255, 255, 0.98);
            backdrop-filter: blur(10px);
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            position: sticky;
            top: 0;
            z-index: 100;
            padding: 1rem 0;
        }
        
        .nav-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 1rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        
        .nav-brand {
            font-size: 1.5rem;
            font-weight: 700;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-decoration: none;
        }
        
        .nav-links {
            display: flex;
            gap: 2rem;
            align-items: center;
        }
        
        .nav-links a {
            color: #4a5568;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.2s;
        }
        
        .nav-links a:hover,
        .nav-links a.active {
            color: #667eea;
        }
        
        /* Hero Section */
        .hero-section {
            background: linear-gradient(180deg, #ffffff 0%, #f7fafc 100%);
            padding: 3rem 0;
            position: relative;
            overflow: hidden;
        }
        
        .hero-section::after {
            content: '{...}';
            position: absolute;
            bottom: -20%;
            right: -5%;
            font-size: 10rem;
            font-weight: 700;
            color: rgba(102, 126, 234, 0.05);
            font-family: 'SF Mono', Monaco, Consolas, monospace;
            animation: codeFloat 20s ease-in-out infinite;
        }
        
        @keyframes codeFloat {
            0%, 100% { transform: translateY(0) rotate(-10deg); }
            50% { transform: translateY(-20px) rotate(-5deg); }
        }
        
        .breadcrumb {
            display: flex;
            gap: 0.5rem;
            color: #718096;
            font-size: 0.875rem;
            margin-bottom: 2rem;
            position: relative;
            z-index: 1;
        }
        
        .breadcrumb a {
            color: #667eea;
            text-decoration: none;
            transition: color 0.2s;
        }
        
        .breadcrumb a:hover {
            color: #764ba2;
        }
        
        .hero-title {
            font-size: 3rem;
            font-weight: 800;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin: 0 0 1rem 0;
            animation: fadeInUp 0.6s ease-out;
        }
        
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .hero-subtitle {
            font-size: 1.25rem;
            line-height: 1.8;
            color: #4a5568;
            max-width: 800px;
            margin: 0 auto;
            animation: fadeInUp 0.6s ease-out 0.1s both;
        }
        
        /* Code Comparison */
        .comparison-section {
            margin: 3rem 0;
        }
        
        .section-header {
            font-size: 2rem;
            font-weight: 700;
            margin: 0 0 2rem 0;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        
        .section-icon {
            font-size: 2rem;
            animation: iconBounce 2s ease-in-out infinite;
        }
        
        @keyframes iconBounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-5px); }
        }
        
        .code-comparison {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2rem;
            margin: 2rem 0;
        }
        
        .code-column h4 {
            margin: 0 0 0.75rem 0;
            color: #2d3748;
        }
        
        .code-block {
            background: #1a202c;
            color: #e2e8f0;
            padding: 1.5rem;
            border-radius: 0.75rem;
            font-family: 'SF Mono', Monaco, Consolas, monospace;
            font-size: 0.9rem;
            line-height: 1.6;
            overflow-x: auto;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            position: relative;
            transition: all 0.3s ease;
        }
        
        .code-block:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 16px rgba(0,0,0,0.15);
        }
        
        .code-block::before {
            content: attr(data-lang);
            position: absolute;
            top: 0.5rem;
            right: 0.75rem;
            font-size: 0.75rem;
            color: #718096;
            text-transform: uppercase;
        }
        
        /* Concept Cards */
        .concept-card {
            background: white;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            padding: 2rem;
            margin: 2rem 0;
            position: relative;
            overflow: hidden;
            transition: all 0.3s ease;
        }
        
        .concept-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
            transform: scaleX(0);
            transform-origin: left;
            transition: transform 0.3s ease;
        }
        
        .concept-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 24px rgba(0,0,0,0.08);
        }
        
        .concept-card:hover::before {
            transform: scaleX(1);
        }
        
        .concept-card h3 {
            color: #1a202c;
            margin: 0 0 1rem 0;
            font-size: 1.5rem;
        }
        
        /* Layout Grid */
        .layout-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1.5rem;
            margin: 2rem 0;
        }
        
        .layout-card {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            padding: 1.5rem;
            transition: all 0.3s ease;
        }
        
        .layout-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 16px rgba(0,0,0,0.08);
            border-color: #cbd5e0;
        }
        
        .layout-card h4 {
            color: #667eea;
            margin: 0 0 0.75rem 0;
        }
        
        .small-code {
            background: #f7fafc;
            padding: 0.75rem;
            border-radius: 6px;
            font-size: 0.85rem;
            font-family: 'SF Mono', Monaco, Consolas, monospace;
            overflow-x: auto;
        }
        
        /* Type Safety Box */
        .type-safety-box {
            background: linear-gradient(135deg, #ecfdf5 0%, #d1fae5 100%);
            border-left: 4px solid #10b981;
            padding: 2rem;
            margin: 3rem 0;
            border-radius: 8px;
            position: relative;
            overflow: hidden;
        }
        
        .type-safety-box::after {
            content: '✓';
            position: absolute;
            top: -20%;
            right: -5%;
            font-size: 8rem;
            color: rgba(16, 185, 129, 0.1);
            animation: checkFloat 3s ease-in-out infinite;
        }
        
        @keyframes checkFloat {
            0%, 100% { transform: translateY(0) rotate(0deg); }
            50% { transform: translateY(-10px) rotate(10deg); }
        }
        
        .type-safety-box h3 {
            margin: 0 0 0.75rem 0;
            color: #065f46;
        }
        
        /* Next Steps Cards */
        .next-steps-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1.5rem;
            margin: 3rem 0;
        }
        
        .next-step-card {
            background: white;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            padding: 2rem;
            text-decoration: none;
            color: inherit;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .next-step-card::after {
            content: '→';
            position: absolute;
            right: 1.5rem;
            top: 50%;
            transform: translateY(-50%);
            font-size: 1.5rem;
            color: #667eea;
            opacity: 0;
            transition: all 0.3s ease;
        }
        
        .next-step-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 16px 32px rgba(0,0,0,0.08);
            border-color: #667eea;
        }
        
        .next-step-card:hover::after {
            opacity: 1;
            right: 1rem;
        }
        
        .next-step-card h4 {
            color: #667eea;
            margin: 0 0 0.5rem 0;
            font-size: 1.25rem;
        }
        
        .next-step-card p {
            color: #718096;
            margin: 0;
        }
        
        /* Footer */
        .dsl-footer {
            background: #f7fafc;
            padding: 3rem 0;
            border-top: 1px solid #e2e8f0;
            margin-top: 5rem;
        }
        
        .footer-nav {
            display: flex;
            gap: 1.5rem;
        }
        
        .footer-nav a {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.2s;
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
        }
        
        .footer-nav a:hover {
            background: #667eea10;
            transform: translateY(-2px);
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .hero-title { font-size: 2rem; }
            .code-comparison { grid-template-columns: 1fr; }
            .layout-grid { grid-template-columns: 1fr; }
            .next-steps-grid { grid-template-columns: 1fr; }
            .nav-links { gap: 1rem; font-size: 0.9rem; }
        }
        """)
    }
    
    @HTMLBuilder
    func navigation() -> some HTMLElement {
        Nav {
            Div {
                Link(href: "/", "Swiftlets")
                    .class("nav-brand")
                Div {
                    Link(href: "/docs", "Documentation")
                        .class("active")
                    Link(href: "/showcase", "Showcase")
                    Link(href: "/about", "About")
                    Link(href: "https://github.com/swiftlets/swiftlets", "GitHub")
                        .attribute("target", "_blank")
                }
                .class("nav-links")
            }
            .class("nav-content")
        }
        .class("dsl-nav")
    }
    
    @HTMLBuilder
    func heroSection() -> some HTMLElement {
        Section {
            Container(maxWidth: .large) {
                // Breadcrumb
                Div {
                    Link(href: "/docs", "Docs")
                    Span(" → ")
                    Link(href: "/docs/concepts", "Core Concepts")
                    Span(" → ")
                    Span("HTML DSL")
                }
                .class("breadcrumb")
                
                H1("SwiftUI-Like Syntax for the Web")
                    .class("hero-title")
                
                P("If you've used SwiftUI, you'll feel right at home. Swiftlets brings the same declarative, composable approach to web development.")
                    .class("hero-subtitle")
            }
        }
        .class("hero-section")
    }
    
    @HTMLBuilder
    func mainContent() -> some HTMLElement {
        Container(maxWidth: .large) {
            VStack(spacing: 60) {
                syntaxComparison()
                coreConceptsSection()
                layoutComponentsSection()
                dynamicContentSection()
                typeSafetySection()
                practicalExample()
                nextStepsSection()
            }
        }
        .style("padding", "3rem 0 0 0")
    }
    
    @HTMLBuilder
    func syntaxComparison() -> some HTMLElement {
        Section {
            H2 {
                Span("📱")
                    .class("section-icon")
                Text("Familiar Syntax")
            }
            .class("section-header")
            
            Div {
                Div {
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
                    .class("code-block")
                    .attribute("data-lang", "Swift")
                }
                .class("code-column")
                
                Div {
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
                    .class("code-block")
                    .attribute("data-lang", "Swift")
                }
                .class("code-column")
            }
            .class("code-comparison")
            
            P("The concepts translate directly - stacks, modifiers, and declarative composition.")
                .style("margin-top", "1rem")
                .style("font-style", "italic")
                .style("text-align", "center")
                .style("color", "#718096")
        }
        .class("comparison-section")
    }
    
    @HTMLBuilder
    func coreConceptsSection() -> some HTMLElement {
        Section {
            H2 {
                Span("🎯")
                    .class("section-icon")
                Text("Core Concepts")
            }
            .class("section-header")
            
            VStack(spacing: 30) {
                // Result Builders
                Div {
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
                    .class("code-block")
                    .attribute("data-lang", "Swift")
                }
                .class("concept-card")
                
                // Composability
                Div {
                    H3("2. Composability")
                    P("Build complex UIs from simple, reusable components:")
                    
                    Pre {
                        Code("""
                        func Card(title: String, content: String) -> some HTMLElement {
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
                    .class("code-block")
                    .attribute("data-lang", "Swift")
                }
                .class("concept-card")
                
                // Modifiers
                Div {
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
                    .class("code-block")
                    .attribute("data-lang", "Swift")
                }
                .class("concept-card")
            }
        }
    }
    
    @HTMLBuilder
    func layoutComponentsSection() -> some HTMLElement {
        Section {
            H2 {
                Span("📐")
                    .class("section-icon")
                Text("Layout Components")
            }
            .class("section-header")
            
            P("Swiftlets provides familiar layout primitives:")
                .style("margin-bottom", "2rem")
            
            Div {
                Div {
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
                    .class("small-code")
                }
                .class("layout-card")
                
                Div {
                    H4("HStack")
                    Pre {
                        Code("""
                        HStack(spacing: 10) {
                            Button("Save")
                            Button("Cancel")
                        }
                        """)
                    }
                    .class("small-code")
                }
                .class("layout-card")
                
                Div {
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
                    .class("small-code")
                }
                .class("layout-card")
            }
            .class("layout-grid")
        }
    }
    
    @HTMLBuilder
    func dynamicContentSection() -> some HTMLElement {
        Section {
            H2 {
                Span("🔄")
                    .class("section-icon")
                Text("Dynamic Content")
            }
            .class("section-header")
            
            P("Build dynamic UIs with control flow:")
                .style("margin-bottom", "2rem")
            
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
            .class("code-block")
            .attribute("data-lang", "Swift")
        }
    }
    
    @HTMLBuilder
    func typeSafetySection() -> some HTMLElement {
        Div {
            H3("🛡️ Type Safety Built In")
            P("Unlike template languages, Swiftlets gives you full type safety. Typos become compile errors, not runtime bugs. Your IDE provides autocomplete for every element and modifier.")
                .style("margin", "0")
        }
        .class("type-safety-box")
    }
    
    @HTMLBuilder
    func practicalExample() -> some HTMLElement {
        Section {
            H2 {
                Span("💡")
                    .class("section-icon")
                Text("Putting It Together")
            }
            .class("section-header")
            
            P("Here's a complete example showing how natural it feels:")
                .style("margin-bottom", "2rem")
            
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
                                        ProductCard(product: product).body
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
            .class("code-block")
            .attribute("data-lang", "Swift")
        }
    }
    
    @HTMLBuilder
    func nextStepsSection() -> some HTMLElement {
        Section {
            H2 {
                Span("📚")
                    .class("section-icon")
                Text("Keep Learning")
            }
            .class("section-header")
            
            Div {
                Link(href: "/showcase") {
                    Div {
                        H4("Live Examples")
                        P("See the DSL in action")
                    }
                    .class("next-step-card")
                }
                
                Link(href: "/docs/concepts/request-response") {
                    Div {
                        H4("Request & Response")
                        P("Handle dynamic data")
                    }
                    .class("next-step-card")
                }
                
                Link(href: "/docs/concepts/routing") {
                    Div {
                        H4("Routing")
                        P("Connect pages together")
                    }
                    .class("next-step-card")
                }
            }
            .class("next-steps-grid")
        }
    }
    
    @HTMLBuilder
    func footer() -> some HTMLElement {
        Footer {
            Container(maxWidth: .large) {
                HStack {
                    P("© 2025 Swiftlets Project")
                        .style("margin", "0")
                        .style("color", "#718096")
                    Spacer()
                    Div {
                        Link(href: "/docs/concepts/architecture", "← Architecture")
                        Link(href: "/docs/concepts/request-response", "Request & Response →")
                    }
                    .class("footer-nav")
                }
                .style("align-items", "center")
            }
        }
        .class("dsl-footer")
    }
}