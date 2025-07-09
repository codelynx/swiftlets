import Swiftlets

@main
struct RoutingPage: SwiftletMain {
    var title = "Routing - Swiftlets"
    
    var body: some HTMLElement {
        Fragment {
            routingStyles()
            navigation()
            heroSection()
            mainContent()
            footer()
        }
    }
    
    @HTMLBuilder
    func routingStyles() -> some HTMLElement {
        Style("""
        /* Routing Page Styles */
        body { 
            margin: 0; 
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            color: #1a202c;
            line-height: 1.6;
            background: #ffffff;
        }
        
        /* Navigation */
        .routing-nav {
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
        
        .hero-section::before {
            content: '📁→🌐';
            position: absolute;
            top: -15%;
            right: -5%;
            font-size: 8rem;
            color: rgba(102, 126, 234, 0.05);
            animation: routeFlow 20s ease-in-out infinite;
        }
        
        @keyframes routeFlow {
            0%, 100% { transform: translateX(0) scale(1); }
            50% { transform: translateX(-30px) scale(1.1); }
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
            position: relative;
            z-index: 1;
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
            position: relative;
            z-index: 1;
        }
        
        /* Section Headers */
        .section-header {
            font-size: 2rem;
            font-weight: 700;
            margin: 0 0 1.5rem 0;
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
        
        /* Routing Demo */
        .routing-demo {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 2rem;
            border-radius: 12px;
            position: relative;
            overflow: hidden;
        }
        
        .routing-demo::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent 0%, rgba(102, 126, 234, 0.1) 50%, transparent 100%);
            animation: routeAnimation 4s ease-in-out infinite;
        }
        
        @keyframes routeAnimation {
            0% { transform: translateX(-100%); }
            50% { transform: translateX(100%); }
            100% { transform: translateX(200%); }
        }
        
        .routing-columns {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2rem;
            position: relative;
            z-index: 1;
        }
        
        .route-column h4 {
            margin: 0 0 1rem 0;
            color: #2d3748;
            text-align: center;
        }
        
        /* File Structure */
        .file-structure {
            background: #1a202c;
            color: #e2e8f0;
            padding: 1.5rem;
            border-radius: 8px;
            font-family: 'SF Mono', Monaco, Consolas, monospace;
            font-size: 0.9rem;
            line-height: 1.6;
            position: relative;
            overflow: hidden;
        }
        
        .file-structure::before {
            content: 'File Structure';
            position: absolute;
            top: 0.5rem;
            right: 0.75rem;
            font-size: 0.75rem;
            color: #718096;
            text-transform: uppercase;
        }
        
        /* Special Routes Cards */
        .routes-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2rem;
            margin: 2rem 0;
        }
        
        .route-card {
            background: white;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            padding: 2rem;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .route-card::before {
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
        
        .route-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 24px rgba(0,0,0,0.08);
        }
        
        .route-card:hover::before {
            transform: scaleX(1);
        }
        
        .route-card h3 {
            color: #1a202c;
            margin: 0 0 1rem 0;
            font-size: 1.25rem;
        }
        
        /* Code Examples */
        .code-block {
            background: #1a202c;
            color: #e2e8f0;
            padding: 1rem;
            border-radius: 8px;
            font-family: 'SF Mono', Monaco, Consolas, monospace;
            font-size: 0.85rem;
            line-height: 1.5;
            overflow-x: auto;
            margin: 1rem 0;
            transition: all 0.3s ease;
        }
        
        .code-block:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 16px rgba(0,0,0,0.15);
        }
        
        /* Tip Boxes */
        .tip-box {
            background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
            border-left: 4px solid #3b82f6;
            padding: 1.25rem;
            border-radius: 8px;
            margin: 1.5rem 0;
            position: relative;
            overflow: hidden;
        }
        
        .tip-box::after {
            content: '💡';
            position: absolute;
            bottom: -20%;
            right: -5%;
            font-size: 4rem;
            opacity: 0.1;
            animation: tipFloat 3s ease-in-out infinite;
        }
        
        @keyframes tipFloat {
            0%, 100% { transform: translateY(0) rotate(-5deg); }
            50% { transform: translateY(-10px) rotate(5deg); }
        }
        
        /* Coming Soon Section */
        .coming-soon {
            background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
            padding: 2rem;
            border-radius: 12px;
            border: 2px solid #f59e0b;
            position: relative;
            overflow: hidden;
        }
        
        .coming-soon::before {
            content: '🚀';
            position: absolute;
            top: -10%;
            right: -5%;
            font-size: 6rem;
            opacity: 0.2;
            animation: rocketFloat 4s ease-in-out infinite;
        }
        
        @keyframes rocketFloat {
            0%, 100% { transform: translateY(0) rotate(-15deg); }
            50% { transform: translateY(-20px) rotate(15deg); }
        }
        
        .coming-soon h2 {
            color: #92400e;
            margin: 0 0 1.5rem 0;
        }
        
        /* Benefits Grid */
        .benefits-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1.5rem;
            margin: 2rem 0;
        }
        
        .benefit-card {
            text-align: center;
            padding: 2rem;
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            transition: all 0.3s ease;
        }
        
        .benefit-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 16px 32px rgba(0,0,0,0.08);
            border-color: #cbd5e0;
        }
        
        .benefit-icon {
            font-size: 2rem;
            display: inline-block;
            margin-bottom: 1rem;
            animation: iconPulse 2s ease-in-out infinite;
            animation-delay: var(--delay, 0s);
        }
        
        @keyframes iconPulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.2); }
        }
        
        .benefit-card h4 {
            margin: 0 0 0.75rem 0;
            color: #1a202c;
        }
        
        .benefit-card p {
            color: #718096;
            margin: 0;
            font-size: 0.9rem;
        }
        
        /* Related Topics */
        .related-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1.5rem;
            margin: 3rem 0;
        }
        
        .related-card {
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
        
        .related-card::after {
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
        
        .related-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 16px 32px rgba(0,0,0,0.08);
            border-color: #667eea;
        }
        
        .related-card:hover::after {
            opacity: 1;
            right: 1rem;
        }
        
        .related-card h4 {
            color: #667eea;
            margin: 0 0 0.5rem 0;
            font-size: 1.25rem;
        }
        
        .related-card p {
            color: #718096;
            margin: 0;
        }
        
        /* Footer */
        .routing-footer {
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
            .routing-columns { grid-template-columns: 1fr; }
            .routes-grid { grid-template-columns: 1fr; }
            .benefits-grid { grid-template-columns: 1fr; }
            .related-grid { grid-template-columns: 1fr; }
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
                    Link(href: "https://github.com/codelynx/swiftlets", "GitHub")
                        .attribute("target", "_blank")
                }
                .class("nav-links")
            }
            .class("nav-content")
        }
        .class("routing-nav")
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
                    Span("Routing")
                }
                .class("breadcrumb")
                
                H1("Simple, File-Based Routing")
                    .class("hero-title")
                
                P("In Swiftlets, routing is refreshingly simple: URLs map directly to executables. No configuration files, no route definitions - just organize your files.")
                    .class("hero-subtitle")
            }
        }
        .class("hero-section")
    }
    
    @HTMLBuilder
    func mainContent() -> some HTMLElement {
        Container(maxWidth: .large) {
            VStack(spacing: 60) {
                howItWorksSection()
                projectStructureSection()
                specialRoutesSection()
                staticFilesSection()
                navigationExample()
                comingSoonSection()
                benefitsSection()
                relatedTopics()
            }
        }
        .style("padding", "3rem 0 0 0")
    }
    
    @HTMLBuilder
    func howItWorksSection() -> some HTMLElement {
        Section {
            H2 {
                Span("📁")
                    .class("section-icon")
                Text("How It Works")
            }
            .class("section-header")
            
            Div {
                P("The URL path maps directly to your file structure:")
                    .style("margin-bottom", "1.5rem")
                    .style("text-align", "center")
                
                Div {
                    Div {
                        H4("URL Request")
                        Pre {
                            Code("""
                            GET /
                            GET /about
                            GET /products
                            GET /products/list
                            GET /api/users
                            """)
                        }
                        .class("code-block")
                    }
                    
                    Div {
                        H4("Executable Path")
                        Pre {
                            Code("""
                            bin/index
                            bin/about
                            bin/products
                            bin/products/list
                            bin/api/users
                            """)
                        }
                        .class("code-block")
                    }
                }
                .class("routing-columns")
            }
            .class("routing-demo")
        }
    }
    
    @HTMLBuilder
    func projectStructureSection() -> some HTMLElement {
        Section {
            H2 {
                Span("🏗️")
                    .class("section-icon")
                Text("Project Structure")
            }
            .class("section-header")
            
            P("Your source files mirror your URL structure:")
                .style("margin-bottom", "2rem")
            
            Pre {
                Code("""
                src/
                ├── index.swift          → /
                ├── about.swift          → /about
                ├── products.swift       → /products
                ├── products/
                │   └── list.swift       → /products/list
                └── api/
                    └── users.swift      → /api/users
                
                bin/  (after building)
                ├── index
                ├── about
                ├── products
                ├── products/
                │   └── list
                └── api/
                    └── users
                """)
            }
            .class("file-structure")
        }
    }
    
    @HTMLBuilder
    func specialRoutesSection() -> some HTMLElement {
        Section {
            H2 {
                Span("🎯")
                    .class("section-icon")
                Text("Special Routes")
            }
            .class("section-header")
            
            Div {
                Div {
                    H3("Index Routes")
                    P("Files named `index.swift` handle directory roots:")
                    Pre {
                        Code("""
                        src/index.swift         → /
                        src/blog/index.swift    → /blog
                        src/shop/index.swift    → /shop
                        """)
                    }
                    .class("code-block")
                }
                .class("route-card")
                
                Div {
                    H3("Nested Routes")
                    P("Create subdirectories for nested URLs:")
                    Pre {
                        Code("""
                        src/docs/getting-started.swift
                        → /docs/getting-started
                        
                        src/api/v1/products.swift
                        → /api/v1/products
                        """)
                    }
                    .class("code-block")
                }
                .class("route-card")
            }
            .class("routes-grid")
        }
    }
    
    @HTMLBuilder
    func staticFilesSection() -> some HTMLElement {
        Section {
            H2 {
                Span("📄")
                    .class("section-icon")
                Text("Static Files")
            }
            .class("section-header")
            
            P("Static files (CSS, images, etc.) are served directly from the `web/` directory:")
                .style("margin-bottom", "2rem")
            
            Pre {
                Code("""
                web/
                ├── styles/
                │   └── main.css         → /styles/main.css
                ├── images/
                │   └── logo.png         → /images/logo.png
                └── favicon.ico          → /favicon.ico
                """)
            }
            .class("code-block")
            
            Div {
                P("💡 Tip: The server checks for static files first. If found, it serves them directly without running any executable.")
                    .style("margin", "0")
            }
            .class("tip-box")
        }
    }
    
    @HTMLBuilder
    func navigationExample() -> some HTMLElement {
        Section {
            H2 {
                Span("🔗")
                    .class("section-icon")
                Text("Building Navigation")
            }
            .class("section-header")
            
            P("Creating links between pages is straightforward:")
                .style("margin-bottom", "2rem")
            
            Pre {
                Code("""
                // In your layout or component
                Nav {
                    HStack(spacing: 20) {
                        Link(href: "/", "Home")
                        Link(href: "/about", "About")
                        Link(href: "/products", "Products")
                        Link(href: "/docs/getting-started", "Docs")
                    }
                }
                
                // Dynamic navigation
                ForEach(categories) { category in
                    Link(href: "/products/\\(category.slug)") {
                        Text(category.name)
                    }
                }
                """)
            }
            .class("code-block")
        }
    }
    
    @HTMLBuilder
    func comingSoonSection() -> some HTMLElement {
        Div {
            H2 {
                Span("🚀")
                    .class("section-icon")
                Text("Coming Soon")
            }
            .class("section-header")
            
            Div {
                Div {
                    H4("Dynamic Routes")
                        .style("margin", "0 0 0.75rem 0")
                        .style("color", "#92400e")
                    P("Support for parameters like `/products/:id` is planned, allowing dynamic segments in URLs.")
                        .style("color", "#78350f")
                        .style("margin", "0")
                }
                
                Div {
                    H4("Route Patterns")
                        .style("margin", "0 0 0.75rem 0")
                        .style("color", "#92400e")
                    P("Wildcard routes and pattern matching for more flexible URL handling.")
                        .style("color", "#78350f")
                        .style("margin", "0")
                }
            }
            .class("routes-grid")
        }
        .class("coming-soon")
    }
    
    @HTMLBuilder
    func benefitsSection() -> some HTMLElement {
        Section {
            H2 {
                Span("✨")
                    .class("section-icon")
                Text("Why File-Based Routing?")
            }
            .class("section-header")
            
            Div {
                Div {
                    Span("👀")
                        .class("benefit-icon")
                        .style("--delay", "0s")
                    H4("Intuitive")
                    P("See your site structure at a glance. No mental mapping between routes and handlers.")
                }
                .class("benefit-card")
                
                Div {
                    Span("🚫")
                        .class("benefit-icon")
                        .style("--delay", "0.1s")
                    H4("No Configuration")
                    P("No route files to maintain. Add a file, get a route. Delete a file, remove a route.")
                }
                .class("benefit-card")
                
                Div {
                    Span("🎯")
                        .class("benefit-icon")
                        .style("--delay", "0.2s")
                    H4("Predictable")
                    P("URLs match your file structure exactly. Easy to debug and understand.")
                }
                .class("benefit-card")
            }
            .class("benefits-grid")
        }
    }
    
    @HTMLBuilder
    func relatedTopics() -> some HTMLElement {
        Section {
            H2 {
                Span("📚")
                    .class("section-icon")
                Text("Related Topics")
            }
            .class("section-header")
            
            Div {
                Link(href: "/docs/concepts/request-response") {
                    Div {
                        H4("Request & Response")
                        P("Handle incoming data")
                    }
                    .class("related-card")
                }
                
                Link(href: "/showcase") {
                    Div {
                        H4("Examples")
                        P("See routing in action")
                    }
                    .class("related-card")
                }
                
                Link(href: "/docs/getting-started") {
                    Div {
                        H4("Getting Started")
                        P("Build your first site")
                    }
                    .class("related-card")
                }
            }
            .class("related-grid")
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
                        Link(href: "/docs/concepts/request-response", "← Request & Response")
                        Link(href: "/docs/concepts", "Back to Concepts")
                    }
                    .class("footer-nav")
                }
                .style("align-items", "center")
            }
        }
        .class("routing-footer")
    }
}