import Swiftlets

@main
struct AboutPage: SwiftletMain {
    var title = "About - Swiftlets"
    
    var body: some HTMLElement {
        Fragment {
            aboutStyles()
            navigationBar()
            heroSection()
            mainContent()
            footer()
        }
    }
    
    @HTMLBuilder
    func aboutStyles() -> some HTMLElement {
        Style("""
        /* About Page Styles */
        body { 
            margin: 0; 
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            color: #1a202c;
            line-height: 1.6;
            background: #ffffff;
        }
        
        /* Navigation */
        .about-nav {
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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 5rem 0;
            position: relative;
            overflow: hidden;
        }
        
        .hero-section::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -25%;
            width: 50%;
            height: 200%;
            background: radial-gradient(circle, rgba(255, 255, 255, 0.1) 0%, transparent 70%);
            animation: heroFloat 20s ease-in-out infinite;
        }
        
        @keyframes heroFloat {
            0%, 100% { transform: translateY(0) rotate(0deg); }
            50% { transform: translateY(-30px) rotate(15deg); }
        }
        
        .hero-title {
            font-size: 3.5rem;
            font-weight: 800;
            margin: 0 0 1.5rem 0;
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
            font-size: 1.5rem;
            opacity: 0.9;
            margin: 0 0 2rem 0;
            animation: fadeInUp 0.6s ease-out 0.1s both;
            position: relative;
            z-index: 1;
        }
        
        .hero-description {
            font-size: 1.125rem;
            opacity: 0.8;
            max-width: 600px;
            margin: 0 auto;
            animation: fadeInUp 0.6s ease-out 0.2s both;
            position: relative;
            z-index: 1;
        }
        
        /* Section Headers */
        .section-header {
            font-size: 2.5rem;
            font-weight: 700;
            margin: 0 0 2rem 0;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            color: #1a202c;
        }
        
        .section-icon {
            font-size: 2.5rem;
            animation: iconFloat 3s ease-in-out infinite;
        }
        
        @keyframes iconFloat {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }
        
        /* Philosophy Section */
        .philosophy-section {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 4rem 2rem;
            border-radius: 24px;
            position: relative;
            overflow: hidden;
        }
        
        .philosophy-section::after {
            content: '💡';
            position: absolute;
            bottom: -15%;
            right: -5%;
            font-size: 8rem;
            opacity: 0.05;
            animation: ideaFloat 15s ease-in-out infinite;
        }
        
        @keyframes ideaFloat {
            0%, 100% { transform: translateY(0) rotate(-10deg); }
            50% { transform: translateY(-20px) rotate(10deg); }
        }
        
        .benefit-list {
            list-style: none;
            padding: 0;
            margin: 2rem 0;
        }
        
        .benefit-item {
            background: white;
            padding: 1.5rem;
            margin: 1rem 0;
            border-radius: 12px;
            border-left: 4px solid #667eea;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
            animation: slideInLeft 0.5s ease-out;
            animation-delay: var(--delay, 0s);
            animation-fill-mode: both;
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
        
        .benefit-item:hover {
            transform: translateX(8px);
            box-shadow: 0 8px 16px rgba(0,0,0,0.1);
        }
        
        /* Architecture Comparison */
        .architecture-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 3rem;
            margin: 3rem 0;
        }
        
        .approach-card {
            background: white;
            border: 2px solid #e2e8f0;
            border-radius: 16px;
            padding: 2.5rem;
            position: relative;
            overflow: hidden;
            transition: all 0.3s ease;
        }
        
        .approach-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(90deg, var(--accent-color, #667eea) 0%, var(--accent-color-dark, #764ba2) 100%);
        }
        
        .approach-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.08);
        }
        
        .traditional-card {
            --accent-color: #ef4444;
            --accent-color-dark: #dc2626;
        }
        
        .swiftlets-card {
            --accent-color: #22c55e;
            --accent-color-dark: #16a34a;
        }
        
        /* Code Blocks */
        .code-block {
            background: #1a202c;
            color: #e2e8f0;
            padding: 1.5rem;
            border-radius: 12px;
            font-family: 'SF Mono', Monaco, Consolas, monospace;
            font-size: 0.9rem;
            line-height: 1.6;
            overflow-x: auto;
            margin: 1rem 0;
            transition: all 0.3s ease;
        }
        
        .code-block:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 16px rgba(0,0,0,0.15);
        }
        
        /* Inspiration Cards */
        .inspiration-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1.5rem;
            margin: 2rem 0;
        }
        
        .inspiration-card {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 2rem;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .inspiration-card::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            background: radial-gradient(circle, rgba(102, 126, 234, 0.05) 0%, transparent 70%);
            transition: all 0.5s ease;
            transform: translate(-50%, -50%);
        }
        
        .inspiration-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 24px rgba(0,0,0,0.08);
            border-color: #667eea;
        }
        
        .inspiration-card:hover::after {
            width: 200%;
            height: 200%;
        }
        
        .inspiration-icon {
            font-size: 2rem;
            margin-bottom: 1rem;
            position: relative;
            z-index: 1;
        }
        
        .inspiration-title {
            font-weight: 700;
            color: #667eea;
            margin: 0 0 0.5rem 0;
            position: relative;
            z-index: 1;
        }
        
        .inspiration-desc {
            color: #718096;
            margin: 0;
            position: relative;
            z-index: 1;
        }
        
        /* Community Section */
        .community-section {
            background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
            padding: 3rem 2rem;
            border-radius: 24px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .community-section::before {
            content: '🚀';
            position: absolute;
            top: -10%;
            left: -5%;
            font-size: 6rem;
            opacity: 0.1;
            animation: rocketFloat 10s ease-in-out infinite;
        }
        
        @keyframes rocketFloat {
            0%, 100% { transform: translateY(0) rotate(-15deg); }
            50% { transform: translateY(-20px) rotate(15deg); }
        }
        
        .btn-group {
            display: flex;
            gap: 1rem;
            justify-content: center;
            margin: 2rem 0;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 0.75rem 2rem;
            border: none;
            border-radius: 12px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .btn-primary::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s ease;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 16px rgba(102, 126, 234, 0.3);
        }
        
        .btn-primary:hover::before {
            left: 100%;
        }
        
        .btn-secondary {
            background: white;
            color: #667eea;
            padding: 0.75rem 2rem;
            border: 2px solid #667eea;
            border-radius: 12px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        
        .btn-secondary:hover {
            background: #667eea;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 8px 16px rgba(102, 126, 234, 0.2);
        }
        
        /* Roadmap Section */
        .roadmap-section {
            background: white;
            border: 2px solid #e2e8f0;
            border-radius: 24px;
            padding: 3rem;
            position: relative;
            overflow: hidden;
        }
        
        .roadmap-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 6px;
            background: linear-gradient(90deg, #667eea 0%, #764ba2 50%, #667eea 100%);
            background-size: 200% 100%;
            animation: gradientMove 3s ease-in-out infinite;
        }
        
        @keyframes gradientMove {
            0%, 100% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
        }
        
        .roadmap-list {
            counter-reset: roadmap-counter;
            list-style: none;
            padding: 0;
            margin: 2rem 0;
        }
        
        .roadmap-item {
            counter-increment: roadmap-counter;
            background: #f8f9fa;
            padding: 1.5rem;
            margin: 1rem 0;
            border-radius: 12px;
            position: relative;
            padding-left: 4rem;
            transition: all 0.3s ease;
        }
        
        .roadmap-item::before {
            content: counter(roadmap-counter);
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            background: #667eea;
            color: white;
            width: 2rem;
            height: 2rem;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 0.875rem;
        }
        
        .roadmap-item:hover {
            background: #e9ecef;
            transform: translateX(8px);
        }
        
        /* Footer */
        .about-footer {
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
            .hero-title { font-size: 2.5rem; }
            .architecture-grid { grid-template-columns: 1fr; }
            .inspiration-grid { grid-template-columns: 1fr; }
            .btn-group { flex-direction: column; align-items: center; }
            .nav-links { gap: 1rem; font-size: 0.9rem; }
        }
        """)
    }
    
    // Break down into smaller functions
    @HTMLBuilder
    func navigationBar() -> some HTMLElement {
        Nav {
            Div {
                Link(href: "/", "Swiftlets")
                    .class("nav-brand")
                Div {
                    Link(href: "/docs", "Documentation")
                    Link(href: "/showcase", "Showcase")
                    Link(href: "/about", "About")
                        .class("active")
                    Link(href: "https://github.com/swiftlets/swiftlets", "GitHub")
                        .attribute("target", "_blank")
                }
                .class("nav-links")
            }
            .class("nav-content")
        }
        .class("about-nav")
    }
    
    @HTMLBuilder
    func heroSection() -> some HTMLElement {
        Section {
            Container(maxWidth: .large) {
                VStack(spacing: 20) {
                    H1("About Swiftlets")
                        .class("hero-title")
                    
                    P("A revolutionary approach to server-side Swift development")
                        .class("hero-subtitle")
                    
                    P("Discover how executable-per-route architecture and SwiftUI-inspired syntax are changing the way we build web applications")
                        .class("hero-description")
                }
                .style("text-align", "center")
            }
        }
        .class("hero-section")
    }
    
    @HTMLBuilder
    func mainContent() -> some HTMLElement {
        Container(maxWidth: .large) {
            VStack(spacing: 80) {
                philosophySection()
                architectureSection()
                inspirationSection()
                communitySection()
                roadmapSection()
            }
        }
        .style("padding", "4rem 0")
    }
    
    @HTMLBuilder
    func philosophySection() -> some HTMLElement {
        Div {
            H2 {
                Span("💭")
                    .class("section-icon")
                Text("Our Philosophy")
            }
            .class("section-header")
            
            P("Swiftlets was born from a simple idea: what if each web route was its own program? This revolutionary approach transforms how we think about web development.")
                .style("font-size", "1.125rem")
                .style("margin-bottom", "2rem")
                .style("color", "#4a5568")
                .style("position", "relative")
                .style("z-index", "1")
            
            UL {
                LI("Perfect isolation - one route can't crash another")
                    .class("benefit-item")
                    .style("--delay", "0.1s")
                LI("True hot reload - change code without restarting the server")
                    .class("benefit-item")
                    .style("--delay", "0.2s")
                LI("Language flexibility - mix Swift, Python, or any language")
                    .class("benefit-item")
                    .style("--delay", "0.3s")
                LI("Granular deployment - update individual routes")
                    .class("benefit-item")
                    .style("--delay", "0.4s")
                LI("Natural code organization - filesystem mirrors URL structure")
                    .class("benefit-item")
                    .style("--delay", "0.5s")
            }
            .class("benefit-list")
            
            P("Combined with a SwiftUI-inspired syntax for HTML generation, Swiftlets makes server-side Swift development feel as natural as building iOS apps.")
                .style("font-size", "1.125rem")
                .style("margin-top", "2rem")
                .style("color", "#4a5568")
                .style("position", "relative")
                .style("z-index", "1")
        }
        .class("philosophy-section")
    }
    
    @HTMLBuilder
    func architectureSection() -> some HTMLElement {
        Section {
            H2 {
                Span("🏗️")
                    .class("section-icon")
                Text("Revolutionary Architecture")
            }
            .class("section-header")
            
            P("See how Swiftlets differs from traditional web frameworks:")
                .style("font-size", "1.125rem")
                .style("margin-bottom", "3rem")
                .style("text-align", "center")
                .style("color", "#4a5568")
            
            Div {
                traditionalApproach()
                swiftletsApproach()
            }
            .class("architecture-grid")
        }
    }
    
    @HTMLBuilder
    func traditionalApproach() -> some HTMLElement {
        Div {
            VStack(spacing: 20) {
                H3("❌ Traditional Frameworks")
                    .style("margin", "0 0 1rem 0")
                    .style("color", "#dc2626")
                P("All routes compiled into one monolithic application")
                    .style("color", "#4a5568")
                Pre {
                    Code("""
                    app.get("/") { ... }
                    app.get("/about") { ... }
                    app.get("/contact") { ... }
                    // All in one process
                    """)
                }
                .class("code-block")
            }
        }
        .class("approach-card traditional-card")
    }
    
    @HTMLBuilder
    func swiftletsApproach() -> some HTMLElement {
        Div {
            VStack(spacing: 20) {
                H3("✅ Swiftlets Approach")
                    .style("margin", "0 0 1rem 0")
                    .style("color", "#16a34a")
                P("Each route is an independent executable")
                    .style("color", "#4a5568")
                Pre {
                    Code("""
                    src/index.swift → bin/index
                    src/about.swift → bin/about
                    src/contact.swift → bin/contact
                    // Separate processes
                    """)
                }
                .class("code-block")
            }
        }
        .class("approach-card swiftlets-card")
    }
    
    @HTMLBuilder
    func inspirationSection() -> some HTMLElement {
        Section {
            H2 {
                Span("✨")
                    .class("section-icon")
                Text("Inspiration & Influences")
            }
            .class("section-header")
            
            P("Swiftlets draws inspiration from the best ideas in software development:")
                .style("font-size", "1.125rem")
                .style("margin-bottom", "3rem")
                .style("text-align", "center")
                .style("color", "#4a5568")
            
            Div {
                inspirationCard(
                    icon: "🔥",
                    title: "Paul Hudson's Ignite",
                    description: "The beautiful HTML DSL with result builders that makes web development feel like SwiftUI"
                )
                
                inspirationCard(
                    icon: "⚡",
                    title: "CGI Architecture", 
                    description: "The simplicity of executable-per-request, modernized for today's development needs"
                )
                
                inspirationCard(
                    icon: "📱",
                    title: "SwiftUI",
                    description: "Declarative syntax that Swift developers already know and love"
                )
                
                inspirationCard(
                    icon: "🔧",
                    title: "Microservices",
                    description: "Independent deployment, scaling, and fault isolation principles"
                )
            }
            .class("inspiration-grid")
        }
    }
    
    @HTMLBuilder
    func inspirationCard(icon: String, title: String, description: String) -> some HTMLElement {
        Div {
            Span(icon)
                .class("inspiration-icon")
            H4(title)
                .class("inspiration-title")
            P(description)
                .class("inspiration-desc")
        }
        .class("inspiration-card")
    }
    
    @HTMLBuilder
    func communitySection() -> some HTMLElement {
        Div {
            H2 {
                Span("🌟")
                    .class("section-icon")
                Text("Open Source & Community")
            }
            .class("section-header")
            
            P("Swiftlets is completely open source and thrives on community contributions. Whether you're fixing bugs, adding features, improving documentation, or sharing ideas, we'd love your help!")
                .style("font-size", "1.125rem")
                .style("margin-bottom", "2rem")
                .style("color", "#4a5568")
                .style("position", "relative")
                .style("z-index", "1")
            
            Div {
                Link(href: "https://github.com/swiftlets/swiftlets", "View on GitHub")
                    .class("btn-primary")
                    .attribute("target", "_blank")
                Link(href: "/docs/troubleshooting", "Get Help")
                    .class("btn-secondary")
            }
            .class("btn-group")
            
            P("Join our growing community of Swift developers building the future of server-side web development.")
                .style("margin-top", "2rem")
                .style("color", "#718096")
                .style("position", "relative")
                .style("z-index", "1")
        }
        .class("community-section")
    }
    
    @HTMLBuilder
    func roadmapSection() -> some HTMLElement {
        Div {
            H2 {
                Span("🚀")
                    .class("section-icon")
                Text("What's Next?")
            }
            .class("section-header")
            
            P("We're actively developing Swiftlets with these exciting priorities:")
                .style("font-size", "1.125rem")
                .style("margin-bottom", "2rem")
                .style("color", "#4a5568")
            
            OL {
                LI("Auto-compilation on request for seamless developer experience")
                    .class("roadmap-item")
                LI("WebSocket support for real-time interactive features")
                    .class("roadmap-item")
                LI("Database integration with type-safe Swift queries")
                    .class("roadmap-item")
                LI("Production deployment tools and Docker support")
                    .class("roadmap-item")
                LI("Performance optimizations and intelligent caching")
                    .class("roadmap-item")
            }
            .class("roadmap-list")
            
            P("The future of server-side Swift development is being built one executable at a time. Want to be part of it?")
                .style("font-size", "1.125rem")
                .style("margin-top", "2rem")
                .style("color", "#4a5568")
                .style("text-align", "center")
        }
        .class("roadmap-section")
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
                        Link(href: "/docs", "Documentation")
                        Link(href: "/showcase", "Examples")
                        Link(href: "/docs/troubleshooting", "Help")
                        Link(href: "https://github.com/swiftlets/swiftlets", "GitHub")
                            .attribute("target", "_blank")
                    }
                    .class("footer-nav")
                }
                .style("align-items", "center")
            }
        }
        .class("about-footer")
    }
}