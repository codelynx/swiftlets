import Swiftlets

@main
struct GettingStartedPage: SwiftletMain {
    var title = "Getting Started - Swiftlets"
    
    var body: some HTMLElement {
        Fragment {
            getStartedStyles()
            navigation()
            hero()
            installationSection()
            tryShowcaseSection()
            architectureSection()
            workingSitesSection()
            swiftuiStyleSection()
            nextStepsSection()
            footer()
        }
    }
    
    @HTMLBuilder
    func getStartedStyles() -> some HTMLElement {
        Style("""
        /* Getting Started Styles */
        body { 
            margin: 0; 
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            color: #1a202c;
            line-height: 1.6;
            background: #ffffff;
        }
        
        /* Navigation */
        .docs-nav {
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
            background: linear-gradient(135deg, #f7fafc 0%, #edf2f7 100%);
            padding: 4rem 0 3rem;
            border-bottom: 1px solid #e2e8f0;
        }
        
        .breadcrumb {
            display: flex;
            gap: 0.5rem;
            color: #718096;
            font-size: 0.9rem;
            margin-bottom: 2rem;
        }
        
        .breadcrumb a {
            color: #667eea;
            text-decoration: none;
        }
        
        .breadcrumb a:hover {
            text-decoration: underline;
        }
        
        .hero-title {
            font-size: 3rem;
            font-weight: 700;
            margin: 0 0 1rem 0;
            background: linear-gradient(135deg, #1a202c 0%, #2d3748 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        
        .hero-lead {
            font-size: 1.25rem;
            color: #4a5568;
            margin: 0;
            max-width: 800px;
        }
        
        /* Section Styles */
        .content-section {
            padding: 3rem 0;
            border-bottom: 1px solid #e2e8f0;
        }
        
        .content-section:last-child {
            border-bottom: none;
        }
        
        .section-number {
            display: inline-flex;
            width: 2.5rem;
            height: 2.5rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            font-weight: 700;
            border-radius: 50%;
            align-items: center;
            justify-content: center;
            margin-right: 1rem;
            flex-shrink: 0;
        }
        
        .section-title {
            font-size: 2rem;
            font-weight: 700;
            color: #1a202c;
            margin: 0 0 1.5rem 0;
            display: flex;
            align-items: center;
        }
        
        /* Code Blocks */
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
            margin: 1rem 0;
        }
        
        .code-inline {
            background: #f7fafc;
            color: #764ba2;
            padding: 0.125rem 0.375rem;
            border-radius: 0.25rem;
            font-family: 'SF Mono', Monaco, Consolas, monospace;
            font-size: 0.875em;
            border: 1px solid #e2e8f0;
        }
        
        /* Tip Boxes */
        .tip-box {
            background: #f0f9ff;
            border-left: 4px solid #3b82f6;
            padding: 1.25rem;
            border-radius: 0.5rem;
            margin: 1.5rem 0;
        }
        
        .tip-box p {
            margin: 0;
            color: #1e40af;
        }
        
        /* Feature Lists */
        .feature-list {
            list-style: none;
            padding: 0;
            margin: 1.5rem 0;
        }
        
        .feature-list li {
            padding: 0.75rem 0;
            padding-left: 2rem;
            position: relative;
            color: #4a5568;
        }
        
        .feature-list li::before {
            content: "✓";
            position: absolute;
            left: 0;
            color: #10b981;
            font-weight: 700;
            font-size: 1.25rem;
        }
        
        .feature-list strong {
            color: #1a202c;
            font-weight: 600;
        }
        
        /* Next Steps Cards */
        .next-steps-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 1.5rem;
            margin: 2rem 0;
        }
        
        .next-step-card {
            background: white;
            border: 2px solid #e2e8f0;
            border-radius: 0.75rem;
            padding: 1.5rem;
            transition: all 0.2s;
            text-decoration: none;
            color: inherit;
            display: block;
        }
        
        .next-step-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 16px rgba(0,0,0,0.08);
            border-color: #cbd5e0;
        }
        
        .next-step-card h3 {
            color: #667eea;
            margin: 0 0 0.5rem 0;
            font-size: 1.25rem;
        }
        
        .next-step-card p {
            color: #718096;
            margin: 0;
            font-size: 0.95rem;
        }
        
        /* SwiftUI Demo Button */
        .demo-button {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 0.875rem 2rem;
            border: none;
            border-radius: 0.5rem;
            font-weight: 600;
            font-size: 1.125rem;
            cursor: pointer;
            transition: all 0.2s;
            display: inline-block;
            text-decoration: none;
            box-shadow: 0 4px 6px rgba(102, 126, 234, 0.2);
            margin-top: 1.5rem;
        }
        
        .demo-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(102, 126, 234, 0.3);
        }
        
        /* Architecture Diagram */
        .architecture-box {
            background: #f7fafc;
            border: 2px solid #e2e8f0;
            border-radius: 0.75rem;
            padding: 1.5rem;
            margin: 1.5rem 0;
        }
        
        /* Footer */
        .docs-footer {
            background: #f7fafc;
            border-top: 1px solid #e2e8f0;
            padding: 3rem 0;
            margin-top: 5rem;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .hero-title { font-size: 2rem; }
            .section-title { font-size: 1.5rem; }
            .nav-links { gap: 1rem; font-size: 0.9rem; }
            .next-steps-grid { grid-template-columns: 1fr; }
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
        .class("docs-nav")
    }
    
    @HTMLBuilder
    func hero() -> some HTMLElement {
        Section {
            Container(maxWidth: .large) {
                // Breadcrumb
                Div {
                    Link(href: "/docs", "Docs")
                    Span(" → ")
                    Span("Getting Started")
                }
                .class("breadcrumb")
                
                H1("Getting Started with Swiftlets")
                    .class("hero-title")
                
                P("Get up and running with Swiftlets in just a few minutes. This guide will walk you through installation, creating your first project, and understanding the basics.")
                    .class("hero-lead")
            }
        }
        .class("hero-section")
    }
    
    @HTMLBuilder
    func installationSection() -> some HTMLElement {
        Section {
            Container(maxWidth: .large) {
                H2 {
                    Span("1")
                        .class("section-number")
                    Text("Clone and Build")
                }
                .class("section-title")
                
                P("First, ensure you have Swift installed (5.7 or later), then clone the Swiftlets repository and build the server:")
                
                Pre {
                    Code("""
                    # Clone the repository
                    git clone https://github.com/codelynx/swiftlets.git
                    cd swiftlets
                    
                    # Build the server (one time setup)
                    ./build-server
                    """)
                }
                .class("code-block")
                
                P {
                    Text("This builds the server binary and places it in the platform-specific directory (e.g., ")
                    Code("bin/macos/arm64/")
                        .class("code-inline")
                    Text(").")
                }
            }
        }
        .class("content-section")
    }
    
    @HTMLBuilder
    func tryShowcaseSection() -> some HTMLElement {
        Section {
            Container(maxWidth: .large) {
                H2 {
                    Span("2")
                        .class("section-number")
                    Text("Try the Showcase Site")
                }
                .class("section-title")
                
                P("Before creating your own project, let's explore what Swiftlets can do! The repository includes a complete example site with documentation and component showcases - all built with Swiftlets.")
                
                P("Build and run the example site:")
                
                Pre {
                    Code("""
                    # Build the site
                    ./build-site sites/swiftlets-site
                    
                    # Run the site
                    ./run-site sites/swiftlets-site
                    
                    # Or combine build and run
                    ./run-site sites/swiftlets-site --build
                    """)
                }
                .class("code-block")
                
                P {
                    Text("Visit ")
                    Link(href: "http://localhost:8080", "http://localhost:8080")
                        .style("color", "#667eea")
                    Text(" and explore:")
                }
                
                UL {
                    LI {
                        Strong("/showcase")
                        Text(" - See all HTML components in action")
                    }
                    LI {
                        Strong("/docs")
                        Text(" - Read documentation (also built with Swiftlets!)")
                    }
                    LI {
                        Strong("View source")
                        Text(" - Check ")
                        Code("sites/swiftlets-site/src/")
                            .class("code-inline")
                        Text(" to see how it's built")
                    }
                }
                .class("feature-list")
                
                Div {
                    P("💡 Tip: The entire documentation site you're reading right now is built with Swiftlets! Check out the source code to see real-world examples.")
                }
                .class("tip-box")
            }
        }
        .class("content-section")
    }
    
    @HTMLBuilder
    func architectureSection() -> some HTMLElement {
        Section {
            Container(maxWidth: .large) {
                H2 {
                    Span("3")
                        .class("section-number")
                    Text("Understanding the Architecture")
                }
                .class("section-title")
                
                P("Swiftlets uses a unique architecture where each route is a standalone executable:")
                
                Div {
                    Pre {
                        Code("""
                        sites/swiftlets-site/
                        ├── src/              # Swift source files
                        │   ├── index.swift   # Homepage route
                        │   ├── about.swift   # About page route
                        │   └── docs/
                        │       └── index.swift  # Docs index route
                        ├── web/              # Static files + .webbin markers
                        │   ├── styles/       # CSS files
                        │   ├── *.webbin      # Route markers (generated)
                        │   └── images/       # Static assets
                        └── bin/              # Compiled executables (generated)
                            ├── index         # Executable for /
                            ├── about         # Executable for /about
                            └── docs/
                                └── index     # Executable for /docs
                        """)
                    }
                    .class("code-block")
                }
                .class("architecture-box")
                
                P("Key concepts:")
                UL {
                    LI {
                        Strong("File-based routing:")
                        Text(" Your file structure defines your routes")
                    }
                    LI {
                        Strong("Independent executables:")
                        Text(" Each route compiles to its own binary")
                    }
                    LI {
                        Strong("No Makefiles needed:")
                        Text(" The build-site script handles everything")
                    }
                    LI {
                        Strong("Hot reload ready:")
                        Text(" Executables can be rebuilt without restarting the server")
                    }
                }
                .class("feature-list")
            }
        }
        .class("content-section")
    }
    
    @HTMLBuilder
    func workingSitesSection() -> some HTMLElement {
        Section {
            Container(maxWidth: .large) {
                H2 {
                    Span("4")
                        .class("section-number")
                    Text("Working with Sites")
                }
                .class("section-title")
                
                P("The build scripts make it easy to work with any site:")
                
                Pre {
                    Code("""
                    # Build a site (incremental - only changed files)
                    ./build-site path/to/site
                    
                    # Force rebuild all files
                    ./build-site path/to/site --force
                    
                    # Clean build artifacts
                    ./build-site path/to/site --clean
                    
                    # Run a site
                    ./run-site path/to/site
                    
                    # Run with custom port
                    ./run-site path/to/site --port 3000
                    
                    # Build and run in one command
                    ./run-site path/to/site --build
                    """)
                }
                .class("code-block")
                
                Div {
                    P("💡 Tip: The scripts automatically detect your platform (macOS/Linux) and architecture (x86_64/arm64).")
                }
                .class("tip-box")
            }
        }
        .class("content-section")
    }
    
    @HTMLBuilder
    func swiftuiStyleSection() -> some HTMLElement {
        Section {
            Container(maxWidth: .large) {
                H2 {
                    Span("5")
                        .class("section-number")
                    Text("SwiftUI-Style Components")
                }
                .class("section-title")
                
                P("Swiftlets now supports a zero-boilerplate API with @main, inspired by SwiftUI:")
                
                Pre {
                    Code("""
                    @main
                    struct HomePage: SwiftletMain {
                        @Query("name") var userName: String?
                        
                        var title = "Welcome"
                        
                        var body: some HTMLElement {
                            VStack(spacing: 20) {
                                H1("Hello, \\(userName ?? "World")!")
                                P("Welcome to Swiftlets")
                                    .style("font-size", "1.25rem")
                            }
                            .style("text-align", "center")
                            .style("padding", "3rem")
                        }
                    }
                    """)
                }
                .class("code-block")
                
                P("This approach enables building complex UIs from simple, composable components - just like SwiftUI!")
                
                Link(href: "/showcase/swiftui-style", "See SwiftUI-Style Examples →")
                    .class("demo-button")
            }
        }
        .class("content-section")
    }
    
    @HTMLBuilder
    func nextStepsSection() -> some HTMLElement {
        Section {
            Container(maxWidth: .large) {
                H2("Next Steps")
                    .style("font-size", "2rem")
                    .style("margin-bottom", "2rem")
                
                Div {
                    Link(href: "/docs/concepts") {
                        Div {
                            H3("Core Concepts")
                            P("Understand how Swiftlets works")
                        }
                        .class("next-step-card")
                    }
                    
                    Link(href: "/showcase") {
                        Div {
                            H3("Component Showcase")
                            P("See all available components")
                        }
                        .class("next-step-card")
                    }
                    
                    Link(href: "/showcase/swiftui-style") {
                        Div {
                            H3("SwiftUI-Style API")
                            P("Build with declarative syntax")
                        }
                        .class("next-step-card")
                    }
                    
                    Link(href: "https://github.com/codelynx/swiftlets/tree/main/sites/swiftlets-site") {
                        Div {
                            H3("Study the Source")
                            P("Learn from real examples")
                        }
                        .class("next-step-card")
                    }
                    .attribute("target", "_blank")
                    
                    Link(href: "/docs/concepts/html-dsl") {
                        Div {
                            H3("HTML DSL Guide")
                            P("Master the SwiftUI-like syntax")
                        }
                        .class("next-step-card")
                    }
                }
                .class("next-steps-grid")
            }
        }
        .class("content-section")
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
        .class("docs-footer")
    }
}