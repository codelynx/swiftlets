import Swiftlets

@main
struct FormsShowcase: SwiftletMain {
    @Query("submitted") var wasSubmitted: String?
    @FormValue("username") var username: String?
    @FormValue("email") var email: String?
    @FormValue("country") var country: String?
    
    var title = "Form Elements - Swiftlets Showcase"
    var meta = ["description": "Examples of form elements and input types in Swiftlets"]
    
    var body: some HTMLElement {
        Div {
            // Navigation
            ShowcaseNav()
            
            // Header
            Container(maxWidth: .large) {
                VStack(spacing: 30) {
                    H1("Form Elements")
                        .style("margin-top", "2rem")
                    
                    P("Examples of form inputs, buttons, and form handling")
                        .style("font-size", "1.25rem")
                        .style("color", "#6c757d")
                    
                    // Show submitted data if form was posted
                    if wasSubmitted == "true" {
                        Div {
                            H3("Form Submitted!")
                            P("Received values:")
                            UL {
                                LI("Username: \(username ?? "not provided")")
                                LI("Email: \(email ?? "not provided")")
                                LI("Country: \(country ?? "not provided")")
                            }
                        }
                        .style("background", "#d4edda")
                        .style("border", "1px solid #c3e6cb")
                        .style("border-radius", "0.375rem")
                        .style("padding", "1rem")
                        .style("margin-bottom", "2rem")
                    }
                    
                    // Text Inputs
                    FormSection(title: "Text Inputs") {
                        FormExample(
                            title: "Basic Text Input",
                            code: """
                            Input(type: "text", name: "username", placeholder: "Enter username")
                            """
                        ) {
                            Input(type: "text", name: "username", placeholder: "Enter username")
                        }
                        
                        FormExample(
                            title: "Email Input",
                            code: """
                            Input(type: "email", name: "email", placeholder: "user@example.com")
                            """
                        ) {
                            Input(type: "email", name: "email", placeholder: "user@example.com")
                        }
                        
                        FormExample(
                            title: "Password Input",
                            code: """
                            Input(type: "password", name: "password", placeholder: "Enter password")
                            """
                        ) {
                            Input(type: "password", name: "password", placeholder: "Enter password")
                        }
                        
                        FormExample(
                            title: "Number Input",
                            code: """
                            Input(type: "number", name: "age", placeholder: "Age")
                                .attr("min", "0")
                                .attr("max", "120")
                            """
                        ) {
                            Input(type: "number", name: "age", placeholder: "Age")
                                .attr("min", "0")
                                .attr("max", "120")
                        }
                    }
                    
                    // Select and TextArea
                    FormSection(title: "Select & TextArea") {
                        FormExample(
                            title: "Select Dropdown",
                            code: """
                            Select(name: "country") {
                                Option("Choose a country", value: "")
                                Option("United States", value: "us")
                                Option("United Kingdom", value: "uk")
                                Option("Canada", value: "ca")
                            }
                            """
                        ) {
                            Select(name: "country") {
                                Option("Choose a country", value: "")
                                Option("United States", value: "us")
                                Option("United Kingdom", value: "uk")
                                Option("Canada", value: "ca")
                            }
                        }
                        
                        FormExample(
                            title: "TextArea",
                            code: """
                            TextArea(name: "message", rows: 4, placeholder: "Enter your message...")
                            """
                        ) {
                            TextArea(name: "message", rows: 4, placeholder: "Enter your message...")
                        }
                    }
                    
                    // Buttons
                    FormSection(title: "Buttons") {
                        FormExample(
                            title: "Button Types",
                            code: """
                            HStack(spacing: 10) {
                                Button("Submit", type: "submit")
                                    .classes("btn", "btn-primary")
                                Button("Reset", type: "reset")
                                    .classes("btn", "btn-secondary")
                                Button("Click Me", type: "button")
                                    .classes("btn", "btn-success")
                            }
                            """
                        ) {
                            HStack(spacing: 10) {
                                Button("Submit", type: "submit")
                                    .classes("btn", "btn-primary")
                                Button("Reset", type: "reset")
                                    .classes("btn", "btn-secondary")
                                Button("Click Me", type: "button")
                                    .classes("btn", "btn-success")
                            }
                        }
                    }
                    
                    // Complete Form Example
                    FormSection(title: "Complete Form Example") {
                        Div {
                            H4("Working Form with SwiftUI-Style Property Wrappers")
                            P("This form uses @FormValue property wrappers to access submitted data")
                            
                            Form(action: "/showcase/forms?submitted=true", method: "POST") {
                                VStack(spacing: 20) {
                                    Div {
                                        Label("Username", for: "username")
                                        Input(type: "text", name: "username", value: username ?? "", placeholder: "Enter username")
                                    }
                                    
                                    Div {
                                        Label("Email", for: "email")
                                        Input(type: "email", name: "email", value: email ?? "", placeholder: "user@example.com")
                                    }
                                    
                                    Div {
                                        Label("Country", for: "country")
                                        Select(name: "country") {
                                            Option("Choose a country", value: "", selected: country == nil)
                                            Option("United States", value: "us", selected: country == "us")
                                            Option("United Kingdom", value: "uk", selected: country == "uk")
                                            Option("Canada", value: "ca", selected: country == "ca")
                                        }
                                    }
                                    
                                    Div {
                                        Button("Submit Form", type: "submit")
                                            .classes("btn", "btn-primary")
                                    }
                                }
                            }
                            .style("background", "#f8f9fa")
                            .style("padding", "2rem")
                            .style("border-radius", "0.5rem")
                        }
                    }
                }
                .style("padding-bottom", "4rem")
            }
        }
    }
}

// Reusable Components

struct ShowcaseNav: HTMLComponent {
    var body: some HTMLElement {
        Div {
            Div {
                Link(href: "/", "Swiftlets")
                    .class("nav-brand")
                Div {
                    Link(href: "/docs", "Documentation")
                    Link(href: "/showcase", "Showcase")
                        .class("active")
                    Link(href: "/about", "About")
                    Link(href: "https://github.com/swiftlets/swiftlets", "GitHub")
                        .attribute("target", "_blank")
                }
                .class("nav-links")
            }
            .class("nav-content")
        }
        .class("nav-container")
    }
}

struct FormSection<Content: HTMLElement>: HTMLComponent {
    let title: String
    let content: Content
    
    init(title: String, @HTMLBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some HTMLElement {
        Section {
            VStack(spacing: 20) {
                H2(title)
                    .style("margin-top", "3rem")
                content
            }
        }
    }
}

struct FormExample<Demo: HTMLElement>: HTMLComponent {
    let title: String
    let code: String
    let demo: Demo
    
    init(title: String, code: String, @HTMLBuilder demo: () -> Demo) {
        self.title = title
        self.code = code
        self.demo = demo()
    }
    
    var body: some HTMLElement {
        Div {
            VStack(spacing: 15) {
                H4(title)
                
                Grid(columns: .count(2), spacing: 20) {
                    Div {
                        H5("Code")
                            .style("margin-bottom", "0.5rem")
                            .style("color", "#6c757d")
                        Pre {
                            Code(code)
                        }
                        .class("language-swift")
                        .style("margin", "0")
                    }
                    
                    Div {
                        H5("Result")
                            .style("margin-bottom", "0.5rem")
                            .style("color", "#6c757d")
                        Div {
                            demo
                        }
                        .style("padding", "1rem")
                        .style("background", "#f8f9fa")
                        .style("border", "1px solid #dee2e6")
                        .style("border-radius", "0.375rem")
                    }
                }
            }
        }
        .style("padding", "1.5rem")
        .style("background", "white")
        .style("border", "1px solid #e2e8f0")
        .style("border-radius", "0.5rem")
        .style("margin-bottom", "1rem")
    }
}