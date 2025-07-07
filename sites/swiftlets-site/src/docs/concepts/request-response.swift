import Swiftlets

@main
struct RequestResponsePage: SwiftletMain {
    var title = "Request & Response - Swiftlets"
    
    var body: some HTMLElement {
        Fragment {
            reqResStyles()
            navigation()
            heroSection()
            mainContent()
            footer()
        }
    }
    
    @HTMLBuilder
    func reqResStyles() -> some HTMLElement {
        Style("""
        /* Request & Response Page Styles */
        body { 
            margin: 0; 
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            color: #1a202c;
            line-height: 1.6;
            background: #ffffff;
        }
        
        /* Navigation */
        .reqres-nav {
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
            content: '{ }';
            position: absolute;
            top: -10%;
            left: -5%;
            font-size: 12rem;
            font-weight: 700;
            color: rgba(102, 126, 234, 0.03);
            font-family: 'SF Mono', Monaco, Consolas, monospace;
            animation: dataFlow 25s linear infinite;
        }
        
        @keyframes dataFlow {
            from { transform: translateX(-100%) rotate(-15deg); }
            to { transform: translateX(100vw) rotate(-15deg); }
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
        
        /* Flow Diagram */
        .flow-diagram {
            background: linear-gradient(135deg, #f7fafc 0%, #edf2f7 100%);
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            position: relative;
            overflow: hidden;
        }
        
        .flow-diagram::before {
            content: '';
            position: absolute;
            top: 50%;
            left: -10%;
            width: 120%;
            height: 2px;
            background: linear-gradient(90deg, transparent 0%, #667eea 50%, transparent 100%);
            animation: flowLine 3s linear infinite;
        }
        
        @keyframes flowLine {
            from { transform: translateX(-100%); }
            to { transform: translateX(100%); }
        }
        
        .flow-code {
            background: #1a202c;
            color: #e2e8f0;
            padding: 1.5rem;
            border-radius: 8px;
            line-height: 1.8;
            font-family: 'SF Mono', Monaco, Consolas, monospace;
            font-size: 0.9rem;
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
            animation: iconPulse 2s ease-in-out infinite;
        }
        
        @keyframes iconPulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.1); }
        }
        
        /* Code Examples */
        .code-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2rem;
            margin: 2rem 0;
        }
        
        .code-column h4 {
            margin: 0 0 1rem 0;
            color: #2d3748;
        }
        
        .code-block {
            background: #1a202c;
            color: #e2e8f0;
            padding: 1rem;
            border-radius: 8px;
            font-family: 'SF Mono', Monaco, Consolas, monospace;
            font-size: 0.85rem;
            line-height: 1.5;
            overflow-x: auto;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            position: relative;
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
        
        /* Complete Example */
        .example-section {
            background: white;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            padding: 2.5rem;
            margin: 2rem 0;
            position: relative;
            overflow: hidden;
        }
        
        .example-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
        }
        
        /* Status Code Cards */
        .status-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1.5rem;
            margin: 2rem 0;
        }
        
        .status-card {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            padding: 1.5rem;
            transition: all 0.3s ease;
        }
        
        .status-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 16px rgba(0,0,0,0.08);
        }
        
        .status-card h4 {
            margin: 0 0 1rem 0;
            font-size: 1.125rem;
        }
        
        .status-card ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .status-card li {
            padding: 0.25rem 0;
            color: #4a5568;
        }
        
        /* Tips Section */
        .tips-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2rem;
            margin: 2rem 0;
        }
        
        .tip-card {
            background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
            border-left: 4px solid #3b82f6;
            padding: 1.5rem;
            border-radius: 8px;
            position: relative;
            overflow: hidden;
        }
        
        .tip-card::after {
            content: '💡';
            position: absolute;
            bottom: -20%;
            right: -5%;
            font-size: 5rem;
            opacity: 0.1;
            animation: tipFloat 3s ease-in-out infinite;
        }
        
        @keyframes tipFloat {
            0%, 100% { transform: translateY(0) rotate(-10deg); }
            50% { transform: translateY(-10px) rotate(10deg); }
        }
        
        .tip-card h4 {
            margin: 0 0 0.75rem 0;
            color: #1e40af;
        }
        
        .tip-code {
            background: #dbeafe;
            color: #1e3a8a;
            padding: 1rem;
            border-radius: 6px;
            font-family: 'SF Mono', Monaco, Consolas, monospace;
            font-size: 0.85rem;
            position: relative;
            z-index: 1;
        }
        
        /* Next Steps */
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
        .reqres-footer {
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
            .code-grid { grid-template-columns: 1fr; }
            .status-grid { grid-template-columns: 1fr; }
            .tips-grid { grid-template-columns: 1fr; }
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
        .class("reqres-nav")
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
                    Span("Request & Response")
                }
                .class("breadcrumb")
                
                H1("Understanding Data Flow")
                    .class("hero-title")
                
                P("Swiftlets uses a simple JSON-based protocol for communication between the server and your executables. Here's everything you need to know.")
                    .class("hero-subtitle")
            }
        }
        .class("hero-section")
    }
    
    @HTMLBuilder
    func mainContent() -> some HTMLElement {
        Container(maxWidth: .large) {
            VStack(spacing: 60) {
                flowSection()
                requestSection()
                responseSection()
                completeExample()
                formHandling()
                statusCodes()
                proTips()
                nextSteps()
            }
        }
        .style("padding", "3rem 0 0 0")
    }
    
    @HTMLBuilder
    func flowSection() -> some HTMLElement {
        Section {
            H2 {
                Span("🔄")
                    .class("section-icon")
                Text("The Flow")
            }
            .class("section-header")
            
            Div {
                Pre {
                    Code("""
                    1. Browser makes request → Server
                    2. Server creates Request JSON → Sends to executable via stdin
                    3. Executable processes → Creates Response JSON
                    4. Executable sends Response → Server via stdout (Base64)
                    5. Server sends HTML → Browser
                    """)
                }
                .class("flow-code")
            }
            .class("flow-diagram")
        }
    }
    
    @HTMLBuilder
    func requestSection() -> some HTMLElement {
        Section {
            H2 {
                Span("📥")
                    .class("section-icon")
                Text("The Request Object")
            }
            .class("section-header")
            
            P("Every swiftlet receives a Request object with all the information about the incoming HTTP request:")
                .style("margin-bottom", "2rem")
            
            Div {
                Div {
                    H4("Request Structure")
                    Pre {
                        Code("""
                        struct Request: Codable {
                            let path: String
                            let method: String
                            let headers: [String: String]
                            let queryParameters: [String: String]
                            let body: String?
                        }
                        """)
                    }
                    .class("code-block")
                    .attribute("data-lang", "Swift")
                }
                .class("code-column")
                
                Div {
                    H4("Example Request")
                    Pre {
                        Code("""
                        {
                          "path": "/products",
                          "method": "GET",
                          "headers": {
                            "user-agent": "Mozilla/5.0...",
                            "accept": "text/html"
                          },
                          "queryParameters": {
                            "category": "electronics",
                            "sort": "price"
                          },
                          "body": null
                        }
                        """)
                    }
                    .class("code-block")
                    .attribute("data-lang", "JSON")
                }
                .class("code-column")
            }
            .class("code-grid")
        }
    }
    
    @HTMLBuilder
    func responseSection() -> some HTMLElement {
        Section {
            H2 {
                Span("📤")
                    .class("section-icon")
                Text("The Response Object")
            }
            .class("section-header")
            
            P("Your swiftlet sends back a Response object that tells the server what to return:")
                .style("margin-bottom", "2rem")
            
            Div {
                Div {
                    H4("Response Structure")
                    Pre {
                        Code("""
                        struct Response: Codable {
                            let status: Int
                            let headers: [String: String]
                            let body: String
                        }
                        """)
                    }
                    .class("code-block")
                    .attribute("data-lang", "Swift")
                }
                .class("code-column")
                
                Div {
                    H4("Example Response")
                    Pre {
                        Code("""
                        {
                          "status": 200,
                          "headers": {
                            "Content-Type": "text/html; charset=utf-8",
                            "Cache-Control": "max-age=3600"
                          },
                          "body": "<html>...</html>"
                        }
                        """)
                    }
                    .class("code-block")
                    .attribute("data-lang", "JSON")
                }
                .class("code-column")
            }
            .class("code-grid")
        }
    }
    
    @HTMLBuilder
    func completeExample() -> some HTMLElement {
        Div {
            H2 {
                Span("💻")
                    .class("section-icon")
                Text("Complete Example")
            }
            .class("section-header")
            
            P("Here's a real swiftlet that uses request data to generate a personalized response:")
                .style("margin-bottom", "2rem")
            
            Pre {
                Code("""
                import Foundation
                import Swiftlets
                
                @main
                struct GreetingPage: SwiftletMain {
                    @Query("name") var userName: String?
                    
                    var title = "Welcome"
                    
                    var body: some HTMLElement {
                        Container {
                            H1("Hello, \\(userName ?? "Guest")! 👋")
                            
                            If(request.method == "POST") {
                                P("Thanks for submitting the form!")
                            }
                            
                            P("You're visiting from: \\(request.headers["user-agent"] ?? "Unknown")")
                        }
                    }
                }
                """)
            }
            .class("code-block")
            .attribute("data-lang", "Swift")
        }
        .class("example-section")
    }
    
    @HTMLBuilder
    func formHandling() -> some HTMLElement {
        Section {
            H2 {
                Span("📝")
                    .class("section-icon")
                Text("Handling Forms")
            }
            .class("section-header")
            
            P("When users submit forms, the data comes through the request:")
                .style("margin-bottom", "2rem")
            
            Div {
                Div {
                    H4("HTML Form")
                    Pre {
                        Code("""
                        Form(method: "POST", action: "/contact") {
                            Input(type: "text", name: "name")
                                .attribute("placeholder", "Your name")
                            
                            Input(type: "email", name: "email")
                                .attribute("placeholder", "Email")
                            
                            TextArea(name: "message")
                                .attribute("placeholder", "Message")
                            
                            Button("Send", type: "submit")
                        }
                        """)
                    }
                    .class("code-block")
                    .attribute("data-lang", "Swift")
                }
                .class("code-column")
                
                Div {
                    H4("Processing with @FormValue")
                    Pre {
                        Code("""
                        @main
                        struct ContactForm: SwiftletMain {
                            @FormValue("name") var name: String?
                            @FormValue("email") var email: String?
                            @FormValue("message") var message: String?
                            
                            var body: some HTMLElement {
                                If(request.method == "POST") {
                                    // Process form data
                                    saveContact(name, email, message)
                                    successMessage()
                                } else: {
                                    showForm()
                                }
                            }
                        }
                        """)
                    }
                    .class("code-block")
                    .attribute("data-lang", "Swift")
                }
                .class("code-column")
            }
            .class("code-grid")
        }
    }
    
    @HTMLBuilder
    func statusCodes() -> some HTMLElement {
        Section {
            H2 {
                Span("🚦")
                    .class("section-icon")
                Text("Common Status Codes")
            }
            .class("section-header")
            
            Div {
                Div {
                    H4("✅ Success (2xx)")
                    UL {
                        LI("200 - OK")
                        LI("201 - Created")
                        LI("204 - No Content")
                    }
                }
                .class("status-card")
                
                Div {
                    H4("↩️ Redirects (3xx)")
                    UL {
                        LI("301 - Moved Permanently")
                        LI("302 - Found (Temporary)")
                        LI("303 - See Other")
                    }
                }
                .class("status-card")
                
                Div {
                    H4("❌ Errors (4xx/5xx)")
                    UL {
                        LI("400 - Bad Request")
                        LI("404 - Not Found")
                        LI("500 - Server Error")
                    }
                }
                .class("status-card")
            }
            .class("status-grid")
            
            // Redirect Example
            Div {
                H4("Example: Redirect After Form Submission")
                    .style("margin", "2rem 0 1rem 0")
                Pre {
                    Code("""
                    // Using ResponseBuilder for redirects
                    var body: some HTMLElement {
                        ResponseBuilder()
                            .status(303)
                            .header("Location", "/thank-you")
                            .build {
                                Html { Body { Text("Redirecting...") } }
                            }
                    }
                    """)
                }
                .class("code-block")
                .attribute("data-lang", "Swift")
            }
        }
    }
    
    @HTMLBuilder
    func proTips() -> some HTMLElement {
        Section {
            H2 {
                Span("💡")
                    .class("section-icon")
                Text("Pro Tips")
            }
            .class("section-header")
            
            Div {
                Div {
                    H4("🔍 Debug Request Data")
                    Pre {
                        Code("""
                        // During development, log the request
                        @Environment("debug") var isDebug: Bool
                        
                        if isDebug {
                            print(request, to: &standardError)
                        }
                        """)
                    }
                    .class("tip-code")
                }
                .class("tip-card")
                
                Div {
                    H4("⚡ JSON Responses")
                    Pre {
                        Code("""
                        // Return JSON for APIs
                        @JSONBody var apiData: APIResponse?
                        
                        var body: some HTMLElement {
                            ResponseBuilder()
                                .json(apiData ?? APIResponse())
                        }
                        """)
                    }
                    .class("tip-code")
                }
                .class("tip-card")
            }
            .class("tips-grid")
        }
    }
    
    @HTMLBuilder
    func nextSteps() -> some HTMLElement {
        Section {
            H2 {
                Span("📚")
                    .class("section-icon")
                Text("What's Next?")
            }
            .class("section-header")
            
            Div {
                Link(href: "/showcase/forms") {
                    Div {
                        H4("Form Examples")
                        P("Interactive form demos")
                    }
                    .class("next-step-card")
                }
                
                Link(href: "/showcase/api-demo") {
                    Div {
                        H4("API Demo")
                        P("JSON endpoints example")
                    }
                    .class("next-step-card")
                }
                
                Link(href: "/docs/concepts/routing") {
                    Div {
                        H4("Routing")
                        P("File-based routing system")
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
                        Link(href: "/docs/concepts/html-dsl", "← HTML DSL")
                        Link(href: "/docs/concepts/routing", "Routing →")
                    }
                    .class("footer-nav")
                }
                .style("align-items", "center")
            }
        }
        .class("reqres-footer")
    }
}