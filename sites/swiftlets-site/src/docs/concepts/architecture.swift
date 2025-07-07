import Swiftlets

@main
struct ArchitecturePage: SwiftletMain {
    var title = "Architecture - Swiftlets"
    
    var body: some HTMLElement {
        Fragment {
            architectureStyles()
            navigation()
            heroSection()
            mainContent()
            footer()
        }
    }
    
    @HTMLBuilder
    func architectureStyles() -> some HTMLElement {
        Style("""
        /* Architecture Page Styles */
        body { 
            margin: 0; 
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            color: #1a202c;
            line-height: 1.6;
            background: #ffffff;
        }
        
        /* Navigation */
        .arch-nav {
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
            content: '';
            position: absolute;
            top: -50%;
            left: -25%;
            width: 80%;
            height: 200%;
            background: radial-gradient(circle, rgba(102, 126, 234, 0.05) 0%, transparent 60%);
            animation: rotate 30s linear infinite;
        }
        
        @keyframes rotate {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
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
            font-size: 1.375rem;
            color: #4a5568;
            max-width: 700px;
            margin: 0 auto;
            text-align: center;
            animation: fadeInUp 0.6s ease-out 0.1s both;
        }
        
        /* Intro Section */
        .intro-highlight {
            background: linear-gradient(135deg, #667eea15 0%, #764ba215 100%);
            border-left: 4px solid #667eea;
            padding: 1.5rem;
            border-radius: 8px;
            margin: 1.5rem 0;
            animation: slideInLeft 0.6s ease-out;
        }
        
        @keyframes slideInLeft {
            from {
                opacity: 0;
                transform: translateX(-20px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }
        
        /* Architecture Diagram */
        .arch-diagram {
            background: #f7fafc;
            padding: 3rem;
            border-radius: 16px;
            position: relative;
            overflow: hidden;
        }
        
        .arch-diagram::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 100%;
            height: 100%;
            background: radial-gradient(circle, #667eea08 0%, transparent 70%);
            animation: pulse 3s ease-in-out infinite;
        }
        
        @keyframes pulse {
            0%, 100% { transform: scale(1); opacity: 0.5; }
            50% { transform: scale(1.2); opacity: 0.8; }
        }
        
        .server-box {
            background: white;
            padding: 2rem;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            text-align: center;
            position: relative;
            z-index: 1;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
        }
        
        .server-box:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 16px rgba(0,0,0,0.1);
        }
        
        .arrow-down {
            font-size: 2rem;
            color: #667eea;
            text-align: center;
            animation: bounce 2s infinite;
        }
        
        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(10px); }
        }
        
        .exec-card {
            background: white;
            padding: 1.5rem;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            text-align: center;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .exec-card::before {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
            transform: translateX(-100%);
            transition: transform 0.3s ease;
        }
        
        .exec-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 24px rgba(0,0,0,0.08);
            border-color: #cbd5e0;
        }
        
        .exec-card:hover::before {
            transform: translateX(0);
        }
        
        .exec-emoji {
            font-size: 2rem;
            display: inline-block;
            animation: float 3s ease-in-out infinite;
            animation-delay: var(--delay, 0s);
        }
        
        @keyframes float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }
        
        /* Component Cards */
        .component-card {
            background: white;
            padding: 2rem;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            text-align: center;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .component-card::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            background: radial-gradient(circle, #667eea10 0%, transparent 70%);
            transition: all 0.5s ease;
            transform: translate(-50%, -50%);
        }
        
        .component-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 16px rgba(0,0,0,0.08);
            border-color: #667eea;
        }
        
        .component-card:hover::after {
            width: 200%;
            height: 200%;
        }
        
        .component-icon {
            font-size: 2.5rem;
            display: inline-block;
            margin-bottom: 1rem;
            position: relative;
            z-index: 1;
        }
        
        /* Benefits Section */
        .benefits-list {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 3rem;
            border-radius: 16px;
            text-align: center;
        }
        
        .benefit-item {
            font-size: 1.125rem;
            margin: 0.75rem 0;
            opacity: 0;
            animation: fadeInLeft 0.5s ease-out forwards;
            animation-delay: var(--delay, 0s);
        }
        
        @keyframes fadeInLeft {
            from {
                opacity: 0;
                transform: translateX(-20px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }
        
        /* Footer */
        .arch-footer {
            padding: 2rem 0;
            border-top: 1px solid #e2e8f0;
            margin-top: 3rem;
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
        
        /* Code Styles */
        .code-inline {
            background: #edf2f7;
            color: #764ba2;
            padding: 0.25rem 0.5rem;
            border-radius: 4px;
            font-family: 'SF Mono', Monaco, Consolas, monospace;
            font-size: 0.875rem;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .hero-title { font-size: 2rem; }
            .nav-links { gap: 1rem; font-size: 0.9rem; }
            .arch-diagram { padding: 2rem; }
            .component-card { padding: 1.5rem; }
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
        .class("arch-nav")
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
                    Span("Architecture")
                }
                .class("breadcrumb")
                
                // Hero Content
                VStack(spacing: 20) {
                    H1("How Swiftlets Works")
                        .class("hero-title")
                    
                    P("A revolutionary architecture that treats each route as an independent executable")
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
                // Introduction
                introSection()
                
                // Architecture Diagram
                architectureDiagram()
                
                // Key Components
                keyComponents()
                
                // Benefits
                benefitsSection()
            }
        }
        .style("padding", "3rem 0 5rem 0")
    }
    
    @HTMLBuilder
    func introSection() -> some HTMLElement {
        VStack(spacing: 20) {
            P("Swiftlets takes a unique approach to web development: each route in your application is a standalone Swift executable. This might sound unusual at first, but it provides remarkable benefits.")
                .style("font-size", "1.25rem")
                .style("line-height", "1.8")
                .style("color", "#2d3748")
                
            Div {
                P("💡 Unlike traditional web frameworks that run everything in a single process, Swiftlets gives each route its own isolated environment.")
                    .style("margin", "0")
            }
            .class("intro-highlight")
        }
    }
    
    @HTMLBuilder
    func architectureDiagram() -> some HTMLElement {
        Section {
            VStack(spacing: 30) {
                H2("Architecture Overview")
                    .style("font-size", "2rem")
                    .style("font-weight", "700")
                    .style("text-align", "center")
                
                // Visual representation
                Div {
                    VStack(spacing: 30) {
                        // Web Server
                        Div {
                            VStack(spacing: 10) {
                                Span("🌐")
                                    .style("font-size", "2rem")
                                H3("Web Server")
                                    .style("margin", "0")
                                P("Routes requests to executables")
                                    .style("margin", "0")
                                    .style("color", "#718096")
                                    .style("font-size", "0.875rem")
                            }
                        }
                        .class("server-box")
                        
                        // Arrow
                        Div {
                            Text("↓")
                        }
                        .class("arrow-down")
                        
                        // Executables
                        Grid(columns: .count(3), spacing: 20) {
                            executableCard(emoji: "🏠", name: "index", path: "/", delay: "0s")
                            executableCard(emoji: "📖", name: "about", path: "/about", delay: "0.1s")
                            executableCard(emoji: "📞", name: "contact", path: "/contact", delay: "0.2s")
                        }
                    }
                }
                .class("arch-diagram")
            }
        }
    }
    
    @HTMLBuilder
    func executableCard(emoji: String, name: String, path: String, delay: String) -> some HTMLElement {
        Div {
            VStack(spacing: 10) {
                Span(emoji)
                    .class("exec-emoji")
                    .style("--delay", delay)
                Code(name)
                    .class("code-inline")
                Text(path)
                    .style("font-size", "0.75rem")
                    .style("color", "#718096")
            }
        }
        .class("exec-card")
    }
    
    @HTMLBuilder
    func keyComponents() -> some HTMLElement {
        Section {
            VStack(spacing: 30) {
                H2("Key Components")
                    .style("font-size", "2rem")
                    .style("font-weight", "700")
                
                Grid(columns: .count(2), spacing: 30) {
                    simpleComponentCard(
                        title: "Web Server",
                        icon: "🌐",
                        description: "Routes requests to executables based on URL patterns"
                    )
                    
                    simpleComponentCard(
                        title: "Build System",
                        icon: "🔨",
                        description: "Compiles Swift files into standalone executables"
                    )
                    
                    simpleComponentCard(
                        title: "Swiftlets",
                        icon: "🚀",
                        description: "Independent executables handling specific routes"
                    )
                    
                    simpleComponentCard(
                        title: "HTML DSL",
                        icon: "🎨",
                        description: "SwiftUI-style syntax for building type-safe HTML"
                    )
                }
            }
        }
    }
    
    @HTMLBuilder
    func simpleComponentCard(title: String, icon: String, description: String) -> some HTMLElement {
        Div {
            VStack(spacing: 15) {
                Span(icon)
                    .class("component-icon")
                H3(title)
                    .style("margin", "0")
                P(description)
                    .style("margin", "0")
                    .style("color", "#718096")
            }
        }
        .class("component-card")
    }
    
    @HTMLBuilder
    func benefitsSection() -> some HTMLElement {
        Section {
            VStack(spacing: 30) {
                H2("Why This Architecture?")
                    .style("font-size", "2rem")
                    .style("font-weight", "700")
                    .style("text-align", "center")
                
                Div {
                    VStack(spacing: 20) {
                        P("✓ Hot reload that actually works")
                            .class("benefit-item")
                            .style("--delay", "0.1s")
                        P("✓ Perfect isolation between routes")
                            .class("benefit-item")
                            .style("--delay", "0.2s")
                        P("✓ Independent scaling and optimization")
                            .class("benefit-item")
                            .style("--delay", "0.3s")
                        P("✓ Simple debugging and testing")
                            .class("benefit-item")
                            .style("--delay", "0.4s")
                    }
                }
                .class("benefits-list")
            }
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
                        Link(href: "/docs/concepts", "← Back to Concepts")
                        Link(href: "/docs/concepts/routing", "Next: Routing →")
                    }
                    .class("footer-nav")
                }
                .style("align-items", "center")
            }
        }
        .class("arch-footer")
    }
}
