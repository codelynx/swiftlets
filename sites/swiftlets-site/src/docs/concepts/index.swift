import Swiftlets

@main
struct ConceptsIndex: SwiftletMain {
    var title = "Core Concepts - Swiftlets"
    
    var body: some HTMLElement {
        Fragment {
            conceptStyles()
            navigation()
            heroSection()
            mainContent()
            footer()
        }
    }
    
    @HTMLBuilder
    func conceptStyles() -> some HTMLElement {
        Style("""
        /* Core Concepts Styles */
        body { 
            margin: 0; 
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            color: #1a202c;
            line-height: 1.6;
            background: #ffffff;
        }
        
        /* Navigation */
        .concept-nav {
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
            padding: 4rem 0 3rem;
            overflow: hidden;
            position: relative;
        }
        
        .hero-section::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -25%;
            width: 50%;
            height: 200%;
            background: radial-gradient(circle, rgba(102, 126, 234, 0.1) 0%, transparent 70%);
            animation: float 20s ease-in-out infinite;
        }
        
        @keyframes float {
            0%, 100% { transform: translateY(0) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(10deg); }
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
            font-size: 3.5rem;
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
            font-size: 1.375rem;
            color: #4a5568;
            max-width: 600px;
            margin: 0 auto;
            text-align: center;
            animation: fadeInUp 0.6s ease-out 0.1s both;
            position: relative;
            z-index: 1;
        }
        
        /* Concept Cards */
        .concept-card {
            background: white;
            border: 2px solid #e2e8f0;
            border-radius: 16px;
            padding: 2.5rem;
            height: 100%;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            cursor: pointer;
            position: relative;
            overflow: hidden;
        }
        
        .concept-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
            transform: translateY(-100%);
            transition: transform 0.3s ease;
        }
        
        .concept-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.08);
            border-color: transparent;
        }
        
        .concept-card:hover::before {
            transform: translateY(0);
        }
        
        .concept-icon {
            font-size: 3.5rem;
            display: inline-block;
            animation: iconFloat 3s ease-in-out infinite;
        }
        
        @keyframes iconFloat {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }
        
        /* Learning Path */
        .learning-path {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 4rem 2rem;
            border-radius: 24px;
            color: white;
            position: relative;
            overflow: hidden;
        }
        
        .learning-path::after {
            content: '';
            position: absolute;
            bottom: -50%;
            left: -25%;
            width: 50%;
            height: 200%;
            background: radial-gradient(circle, rgba(255, 255, 255, 0.1) 0%, transparent 70%);
            animation: float 15s ease-in-out infinite reverse;
        }
        
        .learning-step {
            background: rgba(255, 255, 255, 0.1);
            padding: 1.5rem;
            border-radius: 16px;
            border: 2px solid rgba(255, 255, 255, 0.2);
            transition: all 0.3s ease;
            align-items: center;
            position: relative;
            z-index: 1;
        }
        
        .learning-step:hover {
            background: rgba(255, 255, 255, 0.15);
            transform: translateX(8px);
            border-color: rgba(255, 255, 255, 0.3);
        }
        
        .step-number {
            width: 60px;
            height: 60px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            font-size: 1.5rem;
            font-weight: 800;
            backdrop-filter: blur(10px);
        }
        
        /* Key Principles */
        .principle-card {
            text-align: center;
            padding: 2rem;
            background: #f7fafc;
            border-radius: 12px;
            transition: all 0.3s ease;
        }
        
        .principle-card:hover {
            background: #edf2f7;
            transform: translateY(-4px);
        }
        
        .principle-icon {
            font-size: 2.5rem;
            display: inline-block;
            margin-bottom: 1rem;
            animation: iconPulse 2s ease-in-out infinite;
        }
        
        @keyframes iconPulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.1); }
        }
        
        /* Footer */
        .concept-footer {
            background: #f7fafc;
            padding: 4rem 0 2rem 0;
            margin-top: 5rem;
            border-top: 1px solid #e2e8f0;
        }
        
        .footer-heading {
            font-size: 1.125rem;
            font-weight: 700;
            color: #1a202c;
            margin: 0 0 1rem 0;
        }
        
        .footer-links {
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
        }
        
        .footer-links a {
            color: #718096;
            text-decoration: none;
            font-size: 0.875rem;
            transition: color 0.2s;
        }
        
        .footer-links a:hover {
            color: #667eea;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .hero-title { font-size: 2.5rem; }
            .nav-links { gap: 1rem; font-size: 0.9rem; }
            .concept-card { padding: 2rem; }
            .learning-path { padding: 3rem 1.5rem; }
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
        .class("concept-nav")
    }
    
    @HTMLBuilder
    func heroSection() -> some HTMLElement {
        Section {
            Container(maxWidth: .large) {
                // Breadcrumb
                Div {
                    Link(href: "/docs", "Docs")
                    Span(" → ")
                    Span("Core Concepts")
                }
                .class("breadcrumb")
                
                // Hero Content
                VStack(spacing: 20) {
                    H1("Core Concepts")
                        .class("hero-title")
                    
                    P("Understand the fundamental ideas that power Swiftlets and make it unique")
                        .class("hero-subtitle")
                }
                .style("text-align", "center")
            }
        }
        .class("hero-section")
    }
    
    @HTMLBuilder
    func mainContent() -> some HTMLElement {
        Container(maxWidth: .large) {
            VStack(spacing: 60) {
            
                // Concept Cards Grid
                conceptCards()
                
                // Learning Path Section
                learningPath()
                
                // Key Principles
                keyPrinciples()
            }
        }
        .style("padding", "3rem 0 5rem 0")
    }
    
    @HTMLBuilder
    func conceptCards() -> some HTMLElement {
        VStack(spacing: 20) {
            H2("Explore the Concepts")
                .style("font-size", "2.25rem")
                .style("font-weight", "700")
                .style("text-align", "center")
                .style("margin-bottom", "1rem")
            
            Grid(columns: .count(2), spacing: 30) {
                Link(href: "/docs/concepts/architecture") {
                    Div {
                        VStack(spacing: 20) {
                            Span("🏗️")
                                .class("concept-icon")
                            
                            VStack(spacing: 10) {
                                H3("Architecture")
                                    .style("margin", "0")
                                    .style("font-size", "1.5rem")
                                    .style("color", "#1a202c")
                                P("Executable-per-route architecture for true isolation and hot reload")
                                    .style("color", "#718096")
                                    .style("margin", "0")
                                    .style("line-height", "1.6")
                            }
                        }
                    }
                    .class("concept-card")
                }
                .style("text-decoration", "none")
                .style("color", "inherit")
                
                Link(href: "/docs/concepts/html-dsl") {
                    Div {
                        VStack(spacing: 20) {
                            Span("🎨")
                                .class("concept-icon")
                            
                            VStack(spacing: 10) {
                                H3("HTML DSL")
                                    .style("margin", "0")
                                    .style("font-size", "1.5rem")
                                    .style("color", "#1a202c")
                                P("SwiftUI-inspired syntax for building beautiful, type-safe web pages")
                                    .style("color", "#718096")
                                    .style("margin", "0")
                                    .style("line-height", "1.6")
                            }
                        }
                    }
                    .class("concept-card")
                }
                .style("text-decoration", "none")
                .style("color", "inherit")
                
                Link(href: "/docs/concepts/routing") {
                    Div {
                        VStack(spacing: 20) {
                            Span("🛣️")
                                .class("concept-icon")
                            
                            VStack(spacing: 10) {
                                H3("Routing")
                                    .style("margin", "0")
                                    .style("font-size", "1.5rem")
                                    .style("color", "#1a202c")
                                P("File-based routing that maps URLs directly to Swift executables")
                                    .style("color", "#718096")
                                    .style("margin", "0")
                                    .style("line-height", "1.6")
                            }
                        }
                    }
                    .class("concept-card")
                }
                .style("text-decoration", "none")
                .style("color", "inherit")
                
                Link(href: "/docs/concepts/request-response") {
                    Div {
                        VStack(spacing: 20) {
                            Span("🔄")
                                .class("concept-icon")
                            
                            VStack(spacing: 10) {
                                H3("Request & Response")
                                    .style("margin", "0")
                                    .style("font-size", "1.5rem")
                                    .style("color", "#1a202c")
                                P("Simple, powerful API for handling HTTP requests and responses")
                                    .style("color", "#718096")
                                    .style("margin", "0")
                                    .style("line-height", "1.6")
                            }
                        }
                    }
                    .class("concept-card")
                }
                .style("text-decoration", "none")
                .style("color", "inherit")
                
            }
        }
    }
    
    @HTMLBuilder
    func learningPath() -> some HTMLElement {
        Section {
            VStack(spacing: 30) {
                H2("Learning Path")
                    .style("font-size", "2rem")
                    .style("font-weight", "700")
                    .style("text-align", "center")
                
                P("Follow this recommended order to master Swiftlets concepts")
                    .style("text-align", "center")
                    .style("color", "#718096")
                    .style("margin-bottom", "2rem")
                
                VStack(spacing: 20) {
                    learningStep(number: "1", title: "Architecture", description: "Start here to understand how Swiftlets is fundamentally different", href: "/docs/concepts/architecture")
                    learningStep(number: "2", title: "Routing", description: "Learn how file paths become URLs and how routing works", href: "/docs/concepts/routing")
                    learningStep(number: "3", title: "HTML DSL", description: "Master the SwiftUI-inspired syntax for building pages", href: "/docs/concepts/html-dsl")
                    learningStep(number: "4", title: "Request & Response", description: "Handle dynamic data and user interactions", href: "/docs/concepts/request-response")
                }
            }
        }
        .class("learning-path")
    }
    
    @HTMLBuilder
    func learningStep(number: String, title: String, description: String, href: String) -> some HTMLElement {
        Link(href: href) {
            HStack(spacing: 20) {
                Div {
                    Text(number)
                }
                .class("step-number")
                
                VStack(spacing: 5) {
                    H3(title)
                        .style("margin", "0")
                        .style("font-size", "1.25rem")
                        .style("color", "white")
                    P(description)
                        .style("margin", "0")
                        .style("opacity", "0.9")
                        .style("font-size", "0.95rem")
                }
                .style("text-align", "left")
                
                Div {
                    Text("→")
                        .style("font-size", "1.5rem")
                        .style("opacity", "0.7")
                }
                .style("margin-left", "auto")
            }
            .class("learning-step")
        }
        .style("text-decoration", "none")
        .style("color", "white")
        .style("display", "block")
    }
    
    @HTMLBuilder
    func keyPrinciples() -> some HTMLElement {
        Section {
            VStack(spacing: 30) {
                H2("Key Principles")
                    .style("font-size", "2rem")
                    .style("font-weight", "700")
                    .style("text-align", "center")
                
                Grid(columns: .count(3), spacing: 30) {
                    principleCard(icon: "🏝️", title: "True Isolation", description: "Each route is a separate process. No shared state, no memory leaks, no cascading failures.")
                    principleCard(icon: "🚀", title: "Hot Reload", description: "Changes take effect immediately without restarting the server or losing state.")
                    principleCard(icon: "🎯", title: "Simplicity", description: "No complex abstractions. Just Swift code that produces HTML.")
                    principleCard(icon: "🔒", title: "Security", description: "Process isolation provides natural security boundaries between routes.")
                    principleCard(icon: "🌈", title: "Language Freedom", description: "Mix Swift, Python, Ruby, or any language that can produce HTML.")
                    principleCard(icon: "⚡", title: "Performance", description: "Efficient process pooling and caching for production workloads.")
                }
            }
        }
    }
    
    @HTMLBuilder
    func principleCard(icon: String, title: String, description: String) -> some HTMLElement {
        Div {
            VStack(spacing: 15) {
                Span(icon)
                    .class("principle-icon")
                H3(title)
                    .style("margin", "0")
                    .style("font-size", "1.125rem")
                P(description)
                    .style("margin", "0")
                    .style("color", "#718096")
                    .style("font-size", "0.95rem")
                    .style("line-height", "1.6")
            }
        }
        .class("principle-card")
    }
    
    @HTMLBuilder
    func footer() -> some HTMLElement {
        Footer {
            Container(maxWidth: .large) {
                VStack(spacing: 40) {
                    // Main footer content
                    Grid(columns: .count(4), spacing: 40) {
                        VStack(spacing: 15) {
                            H4("Swiftlets")
                                .class("footer-heading")
                            P("A revolutionary approach to building web applications with Swift")
                                .style("margin", "0")
                                .style("color", "#718096")
                                .style("font-size", "0.875rem")
                        }
                        
                        VStack(spacing: 15) {
                            H4("Documentation")
                                .class("footer-heading")
                            Div {
                                Link(href: "/docs/getting-started", "Getting Started")
                                Link(href: "/docs/concepts", "Core Concepts")
                                Link(href: "/docs/api", "API Reference")
                            }
                            .class("footer-links")
                        }
                        
                        VStack(spacing: 15) {
                            H4("Community")
                                .class("footer-heading")
                            Div {
                                Link(href: "https://github.com/swiftlets/swiftlets", "GitHub")
                                    .attribute("target", "_blank")
                                Link(href: "/showcase", "Examples")
                                Link(href: "/about", "About")
                            }
                            .class("footer-links")
                        }
                        
                        VStack(spacing: 15) {
                            H4("Resources")
                                .class("footer-heading")
                            Div {
                                Link(href: "/docs/troubleshooting", "Troubleshooting")
                                Link(href: "/docs/faq", "FAQ")
                                Link(href: "/docs/changelog", "Changelog")
                            }
                            .class("footer-links")
                        }
                    }
                    
                    // Bottom bar
                    Div {
                        HStack {
                            P("© 2025 Swiftlets Project. MIT Licensed.")
                                .style("margin", "0")
                                .style("color", "#718096")
                                .style("font-size", "0.875rem")
                            Spacer()
                            P("Built with ❤️ using Swiftlets")
                                .style("margin", "0")
                                .style("color", "#718096")
                                .style("font-size", "0.875rem")
                        }
                        .style("align-items", "center")
                    }
                    .style("padding-top", "2rem")
                    .style("border-top", "1px solid #e2e8f0")
                }
            }
        }
        .class("concept-footer")
    }
}