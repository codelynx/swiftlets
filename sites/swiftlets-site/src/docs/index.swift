import Swiftlets

@main
struct DocsIndex: SwiftletMain {
    var title = "Documentation - Swiftlets"
    
    var body: some HTMLElement {
        Fragment {
            docStyles()
            navigation()
            hero()
            swiftuiAnnouncement()
            quickStartCards()
            whySwiftlets()
            gettingStartedCTA()
            footer()
        }
    }
    
    @HTMLBuilder
    func docStyles() -> some HTMLElement {
        Style("""
        /* Documentation Styles */
        body { 
            margin: 0; 
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            color: #1a202c;
            line-height: 1.6;
        }
        
        /* Navigation */
        .doc-nav {
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
            background: linear-gradient(to bottom, #f7fafc 0%, #ffffff 100%);
            padding: 5rem 0;
            text-align: center;
        }
        
        .hero-title {
            font-size: 3.5rem;
            font-weight: 700;
            margin: 0 0 1rem 0;
            background: linear-gradient(135deg, #1a202c 0%, #2d3748 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        
        .hero-subtitle {
            font-size: 1.5rem;
            color: #718096;
            margin: 0;
            max-width: 600px;
            margin: 0 auto;
        }
        
        /* Announcement Banner */
        .announcement-banner {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 3rem;
            border-radius: 1rem;
            box-shadow: 0 20px 40px rgba(102, 126, 234, 0.15);
            margin: 3rem 0;
            position: relative;
            overflow: hidden;
        }
        
        .announcement-banner::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
            animation: pulse 3s ease-in-out infinite;
        }
        
        @keyframes pulse {
            0%, 100% { transform: scale(1); opacity: 0.5; }
            50% { transform: scale(1.1); opacity: 0.8; }
        }
        
        .announcement-content {
            position: relative;
            z-index: 1;
        }
        
        .new-badge {
            background: #10b981;
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 0.375rem;
            font-weight: 700;
            font-size: 0.875rem;
            display: inline-block;
            margin-bottom: 1rem;
            animation: bounce 2s infinite;
        }
        
        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-5px); }
        }
        
        /* Documentation Cards */
        .doc-card {
            background: white;
            border: 2px solid #e2e8f0;
            border-radius: 0.75rem;
            padding: 2rem;
            transition: all 0.3s ease;
            height: 100%;
            display: flex;
            flex-direction: column;
            position: relative;
            overflow: hidden;
        }
        
        .doc-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
            transform: translateX(-100%);
            transition: transform 0.3s ease;
        }
        
        .doc-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 24px rgba(0,0,0,0.08);
            border-color: #cbd5e0;
        }
        
        .doc-card:hover::before {
            transform: translateX(0);
        }
        
        .doc-card-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
            display: block;
            animation: float 3s ease-in-out infinite;
        }
        
        @keyframes float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }
        
        .doc-card h3 {
            color: #2d3748;
            margin: 0 0 0.75rem 0;
            font-size: 1.5rem;
        }
        
        .doc-card p {
            color: #718096;
            margin: 0;
            flex: 1;
        }
        
        /* Feature Grid */
        .feature-item {
            padding: 2rem;
            background: #f7fafc;
            border-radius: 0.75rem;
            transition: background 0.2s;
        }
        
        .feature-item:hover {
            background: #edf2f7;
        }
        
        .feature-icon {
            font-size: 2rem;
            margin-bottom: 0.75rem;
            display: inline-block;
        }
        
        /* CTA Section */
        .cta-box {
            background: white;
            border: 2px solid #e2e8f0;
            border-radius: 1rem;
            padding: 3rem;
            text-align: center;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
        }
        
        .cta-box:hover {
            box-shadow: 0 8px 16px rgba(0,0,0,0.08);
            transform: translateY(-2px);
        }
        
        /* Buttons */
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 0.75rem 2rem;
            border: none;
            border-radius: 0.5rem;
            font-weight: 600;
            font-size: 1.125rem;
            cursor: pointer;
            transition: all 0.2s;
            display: inline-block;
            text-decoration: none;
            box-shadow: 0 4px 6px rgba(102, 126, 234, 0.2);
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(102, 126, 234, 0.3);
        }
        
        .btn-secondary {
            background: white;
            color: #667eea;
            padding: 0.75rem 2rem;
            border: 2px solid #667eea;
            border-radius: 0.5rem;
            font-weight: 600;
            font-size: 1.125rem;
            cursor: pointer;
            transition: all 0.2s;
            display: inline-block;
            text-decoration: none;
        }
        
        .btn-secondary:hover {
            background: #667eea;
            color: white;
            transform: translateY(-2px);
        }
        
        /* Code Block */
        .code-preview {
            background: #1a202c;
            color: #e2e8f0;
            padding: 1.5rem;
            border-radius: 0.75rem;
            font-family: 'SF Mono', Monaco, Consolas, monospace;
            font-size: 0.9rem;
            line-height: 1.6;
            overflow-x: auto;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        
        /* Footer */
        .doc-footer {
            background: #f7fafc;
            border-top: 1px solid #e2e8f0;
            padding: 3rem 0;
            margin-top: 5rem;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .hero-title { font-size: 2.5rem; }
            .hero-subtitle { font-size: 1.25rem; }
            .nav-links { gap: 1rem; font-size: 0.9rem; }
            .announcement-banner { padding: 2rem; }
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
        .class("doc-nav")
    }
    
    @HTMLBuilder
    func hero() -> some HTMLElement {
        Section {
            Container(maxWidth: .large) {
                H1("Welcome to Swiftlets")
                    .class("hero-title")
                P("Build modern web applications with Swift and SwiftUI-like syntax")
                    .class("hero-subtitle")
            }
        }
        .class("hero-section")
    }
    
    @HTMLBuilder
    func swiftuiAnnouncement() -> some HTMLElement {
        Section {
            Container(maxWidth: .large) {
                Div {
                    Div {
                        Span("🎉 NEW")
                            .class("new-badge")
                        H2("SwiftUI-Style API with @main")
                            .style("margin", "0 0 1rem 0")
                            .style("font-size", "2rem")
                        P("Write Swiftlets with zero boilerplate using our new declarative API")
                            .style("font-size", "1.25rem")
                            .style("opacity", "0.9")
                            .style("margin-bottom", "2rem")
                        
                        Pre {
                            Code("""
                            @main
                            struct HomePage: SwiftletMain {
                                @Query("name") var userName: String?
                                
                                var title = "Welcome"
                                var body: some HTMLElement {
                                    H1("Hello, \\(userName ?? "World")!")
                                }
                            }
                            """)
                        }
                        .class("code-preview")
                        .style("max-width", "600px")
                        .style("margin", "0 auto 2rem")
                        
                        HStack(spacing: 20) {
                            Link(href: "/showcase/swiftui-style", "Try Interactive Demo")
                                .class("btn-primary")
                            Link(href: "/docs/getting-started#swiftui-style", "Learn More")
                                .class("btn-secondary")
                        }
                        .style("justify-content", "center")
                    }
                    .class("announcement-content")
                }
                .class("announcement-banner")
            }
        }
    }
    
    @HTMLBuilder
    func quickStartCards() -> some HTMLElement {
        Section {
            Container(maxWidth: .large) {
                Grid(columns: .count(3), spacing: 30) {
                    // Getting Started
                    Link(href: "/docs/getting-started") {
                        Div {
                            Span("🚀")
                                .class("doc-card-icon")
                            H3("Getting Started")
                            P("Get up and running with Swiftlets in minutes")
                        }
                        .class("doc-card")
                    }
                    .style("text-decoration", "none")
                    
                    // Core Concepts
                    Link(href: "/docs/concepts") {
                        Div {
                            Span("💡")
                                .class("doc-card-icon")
                            H3("Core Concepts")
                            P("Understand how Swiftlets works under the hood")
                        }
                        .class("doc-card")
                    }
                    .style("text-decoration", "none")
                    
                    // Components
                    Link(href: "/showcase") {
                        Div {
                            Span("🧩")
                                .class("doc-card-icon")
                            H3("Components")
                            P("Explore all available HTML components")
                        }
                        .class("doc-card")
                    }
                    .style("text-decoration", "none")
                }
            }
        }
        .style("padding", "4rem 0")
    }
    
    @HTMLBuilder
    func whySwiftlets() -> some HTMLElement {
        Section {
            Container(maxWidth: .large) {
                VStack(spacing: 48) {
                    H2("Why Choose Swiftlets?")
                        .style("text-align", "center")
                        .style("font-size", "2.5rem")
                        .style("margin", "0")
                    
                    Grid(columns: .count(2), spacing: 24) {
                        Div {
                            Span("🎯")
                                .class("feature-icon")
                            H3("Focused on Developer Experience")
                                .style("margin", "0 0 0.75rem 0")
                            P("Write web applications using familiar Swift syntax. If you know SwiftUI, you'll feel right at home.")
                                .style("margin", "0")
                                .style("color", "#718096")
                        }
                        .class("feature-item")
                        
                        Div {
                            Span("⚡")
                                .class("feature-icon")
                            H3("Lightning Fast")
                                .style("margin", "0 0 0.75rem 0")
                            P("Built on SwiftNIO for exceptional performance. Each route runs as an independent process.")
                                .style("margin", "0")
                                .style("color", "#718096")
                        }
                        .class("feature-item")
                        
                        Div {
                            Span("🔧")
                                .class("feature-icon")
                            H3("Simple Architecture")
                                .style("margin", "0 0 0.75rem 0")
                            P("No complex build steps or bundlers. Just write Swift code and run.")
                                .style("margin", "0")
                                .style("color", "#718096")
                        }
                        .class("feature-item")
                        
                        Div {
                            Span("🎨")
                                .class("feature-icon")
                            H3("Full HTML5 Support")
                                .style("margin", "0 0 0.75rem 0")
                            P("Access to 60+ HTML elements with type-safe modifiers and attributes.")
                                .style("margin", "0")
                                .style("color", "#718096")
                        }
                        .class("feature-item")
                    }
                }
            }
        }
        .style("padding", "5rem 0")
        .style("background", "#f7fafc")
    }
    
    @HTMLBuilder
    func gettingStartedCTA() -> some HTMLElement {
        Section {
            Container(maxWidth: .medium) {
                Div {
                    H2("Ready to Build?")
                        .style("margin", "0 0 0.75rem 0")
                        .style("font-size", "2rem")
                    P("Start building your first Swiftlets application in minutes")
                        .style("margin", "0 0 2rem 0")
                        .style("color", "#718096")
                        .style("font-size", "1.25rem")
                    Link(href: "/docs/getting-started", "Get Started →")
                        .class("btn-primary")
                        .style("font-size", "1.25rem")
                        .style("padding", "1rem 2.5rem")
                }
                .class("cta-box")
            }
        }
        .style("padding", "5rem 0")
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
                    HStack(spacing: 24) {
                        Link(href: "https://github.com/codelynx/swiftlets", "GitHub")
                        Link(href: "/docs", "Docs")
                        Link(href: "/showcase", "Examples")
                    }
                    .style("color", "#4a5568")
                }
            }
        }
        .class("doc-footer")
    }
}