import Swiftlets

@main
struct TroubleshootingPage: SwiftletMain {
    var title = "Troubleshooting - Swiftlets"
    
    var body: some HTMLElement {
        Fragment {
            troubleshootingStyles()
            navigation()
            heroSection()
            mainContent()
            footer()
        }
    }
    
    @HTMLBuilder
    func troubleshootingStyles() -> some HTMLElement {
        Style("""
        /* Troubleshooting Page Styles */
        body { 
            margin: 0; 
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            color: #1a202c;
            line-height: 1.6;
            background: #ffffff;
        }
        
        /* Navigation */
        .troubleshoot-nav {
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
            content: '🔧';
            position: absolute;
            top: -10%;
            right: -5%;
            font-size: 12rem;
            opacity: 0.05;
            animation: toolFloat 20s ease-in-out infinite;
        }
        
        @keyframes toolFloat {
            0%, 100% { transform: translateY(0) rotate(-15deg); }
            50% { transform: translateY(-30px) rotate(15deg); }
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
        
        /* Problem Cards */
        .problem-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 2rem;
            margin: 3rem 0;
        }
        
        .problem-card {
            background: white;
            border: 2px solid #fee2e2;
            border-radius: 12px;
            padding: 2rem;
            position: relative;
            overflow: hidden;
            transition: all 0.3s ease;
        }
        
        .problem-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(90deg, #ef4444 0%, #dc2626 100%);
        }
        
        .problem-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 24px rgba(239, 68, 68, 0.15);
        }
        
        .problem-icon {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            animation: problemPulse 2s ease-in-out infinite;
        }
        
        @keyframes problemPulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.1); }
        }
        
        /* Solution Cards */
        .solution-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 2rem;
            margin: 3rem 0;
        }
        
        .solution-card {
            background: white;
            border: 2px solid #dcfce7;
            border-radius: 12px;
            padding: 2rem;
            position: relative;
            overflow: hidden;
            transition: all 0.3s ease;
        }
        
        .solution-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(90deg, #22c55e 0%, #16a34a 100%);
        }
        
        .solution-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 24px rgba(34, 197, 94, 0.15);
        }
        
        /* Code Examples */
        .code-comparison {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2rem;
            margin: 2rem 0;
        }
        
        .code-block {
            background: #1a202c;
            color: #e2e8f0;
            padding: 1.5rem;
            border-radius: 8px;
            font-family: 'SF Mono', Monaco, Consolas, monospace;
            font-size: 0.9rem;
            line-height: 1.6;
            overflow-x: auto;
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
        
        .code-block.problem {
            border-left: 4px solid #ef4444;
        }
        
        .code-block.solution {
            border-left: 4px solid #22c55e;
        }
        
        /* Warning Box */
        .warning-box {
            background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
            border-left: 4px solid #f59e0b;
            padding: 1.5rem;
            border-radius: 8px;
            margin: 2rem 0;
            position: relative;
            overflow: hidden;
        }
        
        .warning-box::after {
            content: '⚠️';
            position: absolute;
            bottom: -20%;
            right: -5%;
            font-size: 4rem;
            opacity: 0.1;
            animation: warningPulse 3s ease-in-out infinite;
        }
        
        @keyframes warningPulse {
            0%, 100% { transform: scale(1) rotate(-5deg); }
            50% { transform: scale(1.1) rotate(5deg); }
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
        
        /* FAQ Section */
        .faq-item {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            margin: 1rem 0;
            overflow: hidden;
            transition: all 0.3s ease;
        }
        
        .faq-item:hover {
            box-shadow: 0 4px 8px rgba(0,0,0,0.08);
        }
        
        .faq-question {
            padding: 1.5rem;
            background: #f7fafc;
            font-weight: 600;
            border-bottom: 1px solid #e2e8f0;
            cursor: pointer;
            position: relative;
        }
        
        .faq-question::after {
            content: '+';
            position: absolute;
            right: 1.5rem;
            top: 50%;
            transform: translateY(-50%);
            font-size: 1.5rem;
            color: #667eea;
        }
        
        .faq-answer {
            padding: 1.5rem;
        }
        
        /* Tips Grid */
        .tips-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1.5rem;
            margin: 2rem 0;
        }
        
        .tip-card {
            background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
            border-radius: 12px;
            padding: 1.5rem;
            position: relative;
            overflow: hidden;
            transition: all 0.3s ease;
        }
        
        .tip-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 16px rgba(59, 130, 246, 0.15);
        }
        
        .tip-card::before {
            content: '💡';
            position: absolute;
            bottom: -10%;
            right: -5%;
            font-size: 3rem;
            opacity: 0.1;
        }
        
        .tip-number {
            background: #3b82f6;
            color: white;
            width: 24px;
            height: 24px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 0.875rem;
            margin-bottom: 1rem;
        }
        
        /* Footer */
        .troubleshoot-footer {
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
            .problem-grid { grid-template-columns: 1fr; }
            .solution-grid { grid-template-columns: 1fr; }
            .code-comparison { grid-template-columns: 1fr; }
            .tips-grid { grid-template-columns: 1fr; }
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
        .class("troubleshoot-nav")
    }
    
    @HTMLBuilder
    func heroSection() -> some HTMLElement {
        Section {
            Container(maxWidth: .large) {
                // Breadcrumb
                Div {
                    Link(href: "/docs", "Docs")
                    Span(" → ")
                    Span("Troubleshooting")
                }
                .class("breadcrumb")
                
                H1("Troubleshooting Guide")
                    .class("hero-title")
                
                P("Common issues and their solutions when working with Swiftlets. Get unstuck and back to building amazing web apps.")
                    .class("hero-subtitle")
            }
        }
        .class("hero-section")
    }
    
    @HTMLBuilder
    func mainContent() -> some HTMLElement {
        Container(maxWidth: .large) {
            VStack(spacing: 60) {
                commonProblems()
                expressionComplexity()
                buildErrors()
                quickTips()
                frequentlyAsked()
                gettingHelp()
            }
        }
        .style("padding", "3rem 0 0 0")
    }
    
    @HTMLBuilder
    func commonProblems() -> some HTMLElement {
        Section {
            H2 {
                Span("🚨")
                    .class("section-icon")
                Text("Common Problems")
            }
            .class("section-header")
            
            Div {
                Div {
                    Span("🔄")
                        .class("problem-icon")
                    H3("Build Hangs or Timeouts")
                        .style("margin", "0 0 1rem 0")
                        .style("color", "#dc2626")
                    P("Swift compiler gets stuck on complex HTML expressions, causing builds to hang indefinitely or timeout after 30 seconds.")
                        .style("margin", "0")
                }
                .class("problem-card")
                
                Div {
                    Span("❌")
                        .class("problem-icon")
                    H3("Type Checking Errors")
                        .style("margin", "0 0 1rem 0")
                        .style("color", "#dc2626")
                    P("Generic parameter inference failures when using conditionals or complex expressions in HTML builders.")
                        .style("margin", "0")
                }
                .class("problem-card")
                
                Div {
                    Span("🔧")
                        .class("problem-icon")
                    H3("Property Wrapper Issues")
                        .style("margin", "0 0 1rem 0")
                        .style("color", "#dc2626")
                    P("Incorrect syntax with @Query, @FormValue, @Cookie, or other property wrappers causing compilation errors.")
                        .style("margin", "0")
                }
                .class("problem-card")
                
                Div {
                    Span("📝")
                        .class("problem-icon")
                    H3("Method Not Found")
                        .style("margin", "0 0 1rem 0")
                        .style("color", "#dc2626")
                    P("Using outdated method names like .attr() instead of .attribute(), or missing imports.")
                        .style("margin", "0")
                }
                .class("problem-card")
            }
            .class("problem-grid")
        }
    }
    
    @HTMLBuilder
    func expressionComplexity() -> some HTMLElement {
        Section {
            H2 {
                Span("🧠")
                    .class("section-icon")
                Text("Expression Too Complex")
            }
            .class("section-header")
            
            P("The most common issue is Swift's type checker struggling with complex HTML structures. Here's how to fix it:")
                .style("margin-bottom", "2rem")
                .style("font-size", "1.125rem")
            
            Div {
                P("⚠️ When the build script times out after 30 seconds, it means your HTML structure is too complex for Swift's type checker. The solution is function decomposition.")
                    .style("margin", "0")
                    .style("color", "#92400e")
            }
            .class("warning-box")
            
            H3("Before: Problematic Code")
                .style("margin", "2rem 0 1rem 0")
                .style("color", "#dc2626")
            
            Pre {
                Code("""
                Body {
                    Nav {
                        Container {
                            HStack {
                                Link(href: "/") { H1("Title") }
                                Spacer()
                                HStack(spacing: 20) {
                                    Link(href: "/docs", "Docs")
                                    Link(href: "/about", "About")
                                    // Many more links...
                                }
                            }
                        }
                    }
                    
                    Container {
                        VStack(spacing: 40) {
                            Section {
                                H2("Overview")
                                P("Long content...")
                                Grid(columns: .count(2)) {
                                    // Many grid items...
                                }
                            }
                            // Many more sections...
                        }
                    }
                    
                    Footer {
                        // Complex footer...
                    }
                }
                """)
            }
            .class("code-block problem")
            .attribute("data-lang", "Swift")
            
            H3("After: Decomposed Solution")
                .style("margin", "2rem 0 1rem 0")
                .style("color", "#16a34a")
            
            Pre {
                Code("""
                @main
                struct MyPage: SwiftletMain {
                    var title = "My Page"
                    
                    var body: some HTMLElement {
                        Fragment {
                            navigation()
                            mainContent()
                            footer()
                        }
                    }
                    
                    @HTMLBuilder
                    func navigation() -> some HTMLElement {
                        Nav {
                            Container {
                                HStack {
                                    Link(href: "/") { H1("Title") }
                                    Spacer()
                                    navigationLinks()
                                }
                            }
                        }
                    }
                    
                    @HTMLBuilder
                    func navigationLinks() -> some HTMLElement {
                        HStack(spacing: 20) {
                            Link(href: "/docs", "Docs")
                            Link(href: "/about", "About")
                        }
                    }
                    
                    @HTMLBuilder
                    func mainContent() -> some HTMLElement {
                        Container {
                            VStack(spacing: 40) {
                                overviewSection()
                                detailsSection()
                            }
                        }
                    }
                }
                """)
            }
            .class("code-block solution")
            .attribute("data-lang", "Swift")
        }
    }
    
    @HTMLBuilder
    func buildErrors() -> some HTMLElement {
        Section {
            H2 {
                Span("🔨")
                    .class("section-icon")
                Text("Common Build Errors")
            }
            .class("section-header")
            
            VStack(spacing: 30) {
                errorSolution(
                    problem: "Generic parameter 'E' could not be inferred",
                    cause: "Using 'if' statements in HTMLBuilder contexts",
                    badCode: """
                    if showButton {
                        Button("Click me")
                    }
                    """,
                    goodCode: """
                    If(showButton) {
                        Button("Click me")
                    }
                    """
                )
                
                errorSolution(
                    problem: "Value of type 'Link' has no member 'attr'",
                    cause: "Using outdated method names",
                    badCode: """
                    Link(href: "/example", "Link")
                        .attr("target", "_blank")
                    """,
                    goodCode: """
                    Link(href: "/example", "Link")
                        .attribute("target", "_blank")
                    """
                )
                
                errorSolution(
                    problem: "Property wrapper initialization error",
                    cause: "Incorrect property wrapper syntax",
                    badCode: """
                    @Cookie var theme: String?
                    """,
                    goodCode: """
                    @Cookie("theme", default: "light") var theme: String?
                    """
                )
            }
        }
    }
    
    @HTMLBuilder
    func errorSolution(problem: String, cause: String, badCode: String, goodCode: String) -> some HTMLElement {
        Div {
            H4(problem)
                .style("margin", "0 0 1rem 0")
                .style("color", "#dc2626")
            P("Cause: " + cause)
                .style("margin", "0 0 1.5rem 0")
                .style("color", "#4a5568")
            
            Div {
                Div {
                    H5("❌ Problematic")
                        .style("margin", "0 0 0.5rem 0")
                        .style("color", "#dc2626")
                    Pre {
                        Code(badCode)
                    }
                    .class("code-block problem")
                    .attribute("data-lang", "Swift")
                }
                
                Div {
                    H5("✅ Correct")
                        .style("margin", "0 0 0.5rem 0")
                        .style("color", "#16a34a")
                    Pre {
                        Code(goodCode)
                    }
                    .class("code-block solution")
                    .attribute("data-lang", "Swift")
                }
            }
            .class("code-comparison")
        }
        .style("background", "white")
        .style("border", "1px solid #e2e8f0")
        .style("border-radius", "12px")
        .style("padding", "2rem")
    }
    
    @HTMLBuilder
    func quickTips() -> some HTMLElement {
        Section {
            H2 {
                Span("💡")
                    .class("section-icon")
                Text("Quick Tips")
            }
            .class("section-header")
            
            Div {
                Div {
                    Div {
                        Text("1")
                    }
                    .class("tip-number")
                    H4("Break Down Complex HTML")
                        .style("margin", "0 0 0.75rem 0")
                    P("Use @HTMLBuilder functions returning 'some HTMLElement' for logical sections")
                        .style("margin", "0")
                        .style("font-size", "0.9rem")
                }
                .class("tip-card")
                
                Div {
                    Div {
                        Text("2")
                    }
                    .class("tip-number")
                    H4("Use If Helper")
                        .style("margin", "0 0 0.75rem 0")
                    P("Replace 'if' statements with 'If()' helper in HTMLBuilder contexts")
                        .style("margin", "0")
                        .style("font-size", "0.9rem")
                }
                .class("tip-card")
                
                Div {
                    Div {
                        Text("3")
                    }
                    .class("tip-number")
                    H4("Check Method Names")
                        .style("margin", "0 0 0.75rem 0")
                    P("Use .attribute() not .attr(), ensure you have the latest API")
                        .style("margin", "0")
                        .style("font-size", "0.9rem")
                }
                .class("tip-card")
                
                Div {
                    Div {
                        Text("4")
                    }
                    .class("tip-number")
                    H4("Property Wrapper Syntax")
                        .style("margin", "0 0 0.75rem 0")
                    P("Include parameter names and defaults for @Cookie, @Query, etc.")
                        .style("margin", "0")
                        .style("font-size", "0.9rem")
                }
                .class("tip-card")
                
                Div {
                    Div {
                        Text("5")
                    }
                    .class("tip-number")
                    H4("Use .body for Components")
                        .style("margin", "0 0 0.75rem 0")
                    P("Custom HTMLComponent instances need .body property or helper functions")
                        .style("margin", "0")
                        .style("font-size", "0.9rem")
                }
                .class("tip-card")
                
                Div {
                    Div {
                        Text("6")
                    }
                    .class("tip-number")
                    H4("Move Shared Code")
                        .style("margin", "0 0 0.75rem 0")
                    P("Place reusable components in src/shared/ directory")
                        .style("margin", "0")
                        .style("font-size", "0.9rem")
                }
                .class("tip-card")
            }
            .class("tips-grid")
        }
    }
    
    @HTMLBuilder
    func frequentlyAsked() -> some HTMLElement {
        Section {
            H2 {
                Span("❓")
                    .class("section-icon")
                Text("Frequently Asked Questions")
            }
            .class("section-header")
            
            VStack(spacing: 15) {
                faqItem(
                    question: "Why does my build hang indefinitely?",
                    answer: "This usually happens when Swift's type checker encounters overly complex HTML expressions. Break your HTML into smaller @HTMLBuilder functions that return 'some HTMLElement'."
                )
                
                faqItem(
                    question: "What's the difference between 'some HTML' and 'some HTMLElement'?",
                    answer: "Use 'some HTMLElement' for @HTMLBuilder functions. 'some HTML' is for complete page structures. The type system expects HTMLElement in most contexts."
                )
                
                faqItem(
                    question: "How do I debug what's causing a build timeout?",
                    answer: "The build script will show which file is hanging. Look for deeply nested HTML, many chained modifiers, or complex expressions. Start by extracting the largest sections into separate functions."
                )
                
                faqItem(
                    question: "Can I use regular Swift 'if' statements in HTML builders?",
                    answer: "No, use the 'If()' helper instead. Regular 'if' statements cause generic parameter inference issues in result builder contexts."
                )
                
                faqItem(
                    question: "Why can't I declare structs inside my HTML builder?",
                    answer: "Swift's result builders don't allow declarations. Move your struct definitions outside the HTML builder closure or to separate files."
                )
                
                faqItem(
                    question: "How do I know when to break down my HTML?",
                    answer: "Consider decomposition when you have: 3-4+ levels of nesting, sections over 50-60 lines, multiple complex modifiers, or compilation taking more than a few seconds."
                )
            }
        }
    }
    
    @HTMLBuilder
    func faqItem(question: String, answer: String) -> some HTMLElement {
        Div {
            Div {
                Text(question)
            }
            .class("faq-question")
            
            Div {
                P(answer)
                    .style("margin", "0")
                    .style("color", "#4a5568")
            }
            .class("faq-answer")
        }
        .class("faq-item")
    }
    
    @HTMLBuilder
    func gettingHelp() -> some HTMLElement {
        Section {
            H2 {
                Span("🆘")
                    .class("section-icon")
                Text("Getting Help")
            }
            .class("section-header")
            
            Div {
                Div {
                    H3("Still Stuck?")
                        .style("margin", "0 0 1rem 0")
                        .style("color", "#16a34a")
                    P("If these solutions don't help, here are additional resources:")
                        .style("margin", "0 0 1.5rem 0")
                    
                    UL {
                        LI {
                            Link(href: "https://github.com/codelynx/swiftlets/issues", "Report an issue on GitHub")
                                .attribute("target", "_blank")
                                .style("color", "#667eea")
                        }
                        LI {
                            Link(href: "/docs/concepts", "Review the core concepts")
                                .style("color", "#667eea")
                        }
                        LI {
                            Link(href: "/showcase", "Check working examples")
                                .style("color", "#667eea")
                        }
                        LI {
                            Text("Include your error message and code snippet when asking for help")
                        }
                    }
                    .style("padding-left", "1.5rem")
                }
                .style("position", "relative")
                .style("z-index", "1")
            }
            .class("solution-card")
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
                        Link(href: "/docs", "← Back to Docs")
                        Link(href: "/docs/concepts", "Core Concepts")
                        Link(href: "/showcase", "Examples")
                    }
                    .class("footer-nav")
                }
                .style("align-items", "center")
            }
        }
        .class("troubleshoot-footer")
    }
}