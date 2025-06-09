import Swiftlets

@main
struct RequestResponsePage: SwiftletMain {
    var title = "Request & Response - Swiftlets"
    
    var body: some HTMLElement {
        Fragment {
            // Navigation
            Nav {
            Container(maxWidth: .xl) {
            HStack {
                Link(href: "/") {
                    H1("Swiftlets").style("margin", "0")
                }
                Spacer()
                HStack(spacing: 20) {
                    Link(href: "/docs", "Documentation").class("active")
                    Link(href: "/showcase", "Showcase")
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
            
            // Content
            Container(maxWidth: .large) {
            VStack(spacing: 40) {
            // Breadcrumb
            HStack(spacing: 10) {
                Link(href: "/docs", "Docs")
                Text("→")
                Link(href: "/docs/concepts", "Core Concepts")
                Text("→")
                Text("Request & Response")
            }
            .style("color", "#6c757d")
            
            H1("Understanding Data Flow")
            
            P("Swiftlets uses a simple JSON-based protocol for communication between the server and your executables. Here's everything you need to know.")
                .style("font-size", "1.25rem")
                .style("line-height", "1.8")
            
            // Overview
            Section {
                H2("🔄 The Flow")
                
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
                    .style("background", "#f5f5f5")
                    .style("padding", "1.5rem")
                    .style("border-radius", "8px")
                    .style("line-height", "1.8")
                }
            }
            
            // Request Structure
            Section {
                H2("📥 The Request Object")
                
                P("Every swiftlet receives a Request object with all the information about the incoming HTTP request:")
                
                Grid(columns: .count(2), spacing: 30) {
                    VStack(spacing: 15) {
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
                        .style("background", "#f5f5f5")
                        .style("padding", "1rem")
                        .style("border-radius", "6px")
                    }
                    
                    VStack(spacing: 15) {
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
                        .style("background", "#f5f5f5")
                        .style("padding", "1rem")
                        .style("border-radius", "6px")
                    }
                }
            }
            
            // Response Structure
            Section {
                H2("📤 The Response Object")
                
                P("Your swiftlet sends back a Response object that tells the server what to return:")
                
                Grid(columns: .count(2), spacing: 30) {
                    VStack(spacing: 15) {
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
                        .style("background", "#f5f5f5")
                        .style("padding", "1rem")
                        .style("border-radius", "6px")
                    }
                    
                    VStack(spacing: 15) {
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
                        .style("background", "#f5f5f5")
                        .style("padding", "1rem")
                        .style("border-radius", "6px")
                    }
                }
            }
            
            // Complete Example
            Section {
                H2("💻 Complete Example")
                
                P("Here's a real swiftlet that uses request data to generate a personalized response:")
                
                Pre {
                    Code("""
                    import Foundation
                    import Swiftlets
                    
                    @main
                    struct GreetingPage {
                        static func main() async throws {
                            // 1. Receive request from stdin
                            let request = try JSONDecoder().decode(Request.self, 
                                from: FileHandle.standardInput.readDataToEndOfFile())
                            
                            // 2. Extract data from request
                            let name = request.queryParameters["name"] ?? "Guest"
                            let userAgent = request.headers["user-agent"] ?? "Unknown"
                            
                            // 3. Build HTML using the data
                            let html = Html {
                                Head {
                                    Title("Greeting for \\(name)")
                                }
                                Body {
                                    Container {
                                        H1("Hello, \\(name)! 👋")
                                        P("You're visiting from: \\(userAgent)")
                                        
                                        If(request.method == "POST") {
                                            P("Thanks for submitting the form!")
                                        }
                                    }
                                }
                            }
                            
                            // 4. Create response
                            let response = Response(
                                status: 200,
                                headers: ["Content-Type": "text/html; charset=utf-8"],
                                body: html.render()
                            )
                            
                            // 5. Send response via stdout (Base64 encoded)
                            print(try JSONEncoder().encode(response).base64EncodedString())
                        }
                    }
                    """)
                }
                .style("background", "#f5f5f5")
                .style("padding", "1rem")
                .style("border-radius", "8px")
            }
            
            // Working with Forms
            Section {
                H2("📝 Handling Forms")
                
                P("When users submit forms, the data comes through the request:")
                
                Grid(columns: .count(2), spacing: 20) {
                    VStack(spacing: 15) {
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
                        .style("background", "#f5f5f5")
                        .style("padding", "0.75rem")
                        .style("border-radius", "6px")
                        .style("font-size", "0.9rem")
                    }
                    
                    VStack(spacing: 15) {
                        H4("Processing Submission")
                        Pre {
                            Code("""
                            // Form data comes in request.body
                            if request.method == "POST" {
                                // Parse form data
                                let formData = parseFormData(request.body ?? "")
                                let name = formData["name"] ?? ""
                                let email = formData["email"] ?? ""
                                let message = formData["message"] ?? ""
                                
                                // Process the submission
                                // Save to database, send email, etc.
                            }
                            """)
                        }
                        .style("background", "#f5f5f5")
                        .style("padding", "0.75rem")
                        .style("border-radius", "6px")
                        .style("font-size", "0.9rem")
                    }
                }
            }
            
            // Status Codes
            Section {
                H2("🚦 Common Status Codes")
                
                Grid(columns: .count(3), spacing: 20) {
                    VStack(spacing: 10) {
                        H4("✅ Success (2xx)")
                        UL {
                            LI("200 - OK")
                            LI("201 - Created")
                            LI("204 - No Content")
                        }
                    }
                    
                    VStack(spacing: 10) {
                        H4("↩️ Redirects (3xx)")
                        UL {
                            LI("301 - Moved Permanently")
                            LI("302 - Found (Temporary)")
                            LI("303 - See Other")
                        }
                    }
                    
                    VStack(spacing: 10) {
                        H4("❌ Errors (4xx/5xx)")
                        UL {
                            LI("400 - Bad Request")
                            LI("404 - Not Found")
                            LI("500 - Server Error")
                        }
                    }
                }
                
                // Redirect Example
                Div {
                    H4("Example: Redirect After Form Submission")
                    Pre {
                        Code("""
                        // After processing a form, redirect to success page
                        let response = Response(
                            status: 303,
                            headers: [
                                "Location": "/thank-you",
                                "Content-Type": "text/html"
                            ],
                            body: "<html><body>Redirecting...</body></html>"
                        )
                        """)
                    }
                    .style("background", "#f5f5f5")
                    .style("padding", "1rem")
                    .style("border-radius", "6px")
                }
                .style("margin-top", "1.5rem")
            }
            
            // Tips
            Section {
                H2("💡 Pro Tips")
                
                Grid(columns: .count(2), spacing: 30) {
                    Div {
                        H4("🔍 Debug Request Data")
                        Pre {
                            Code("""
                            // During development, log the request
                            let requestJSON = try JSONEncoder().encode(request)
                            FileHandle.standardError.write(requestJSON)
                            """)
                        }
                        .style("background", "#f0f9ff")
                        .style("padding", "1rem")
                        .style("border-radius", "6px")
                    }
                    
                    Div {
                        H4("⚡ JSON Responses")
                        Pre {
                            Code("""
                            // Return JSON for APIs
                            let response = Response(
                                status: 200,
                                headers: ["Content-Type": "application/json"],
                                body: #"{"success": true}"#
                            )
                            """)
                        }
                        .style("background", "#f0f9ff")
                        .style("padding", "1rem")
                        .style("border-radius", "6px")
                    }
                }
            }
            
            // Next Steps
            Section {
                H2("📚 What's Next?")
                
                Grid(columns: .count(3), spacing: 20) {
                    Link(href: "/docs/tutorials/forms") {
                        Div {
                            H4("Form Handling →")
                            P("Build interactive forms")
                                .style("color", "#6c757d")
                        }
                        .class("doc-card")
                        .style("padding", "1.5rem")
                    }
                    .style("text-decoration", "none")
                    .style("color", "inherit")
                    
                    Link(href: "/docs/tutorials/api") {
                        Div {
                            H4("Building APIs →")
                            P("Create JSON endpoints")
                                .style("color", "#6c757d")
                        }
                        .class("doc-card")
                        .style("padding", "1.5rem")
                    }
                    .style("text-decoration", "none")
                    .style("color", "inherit")
                    
                    Link(href: "/docs/components") {
                        Div {
                            H4("Components →")
                            P("All HTML elements")
                                .style("color", "#6c757d")
                        }
                        .class("doc-card")
                        .style("padding", "1.5rem")
                    }
                    .style("text-decoration", "none")
                    .style("color", "inherit")
                }
            }
            }
            }
            .style("padding", "3rem 0")
            
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