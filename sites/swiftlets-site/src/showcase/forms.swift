import Swiftlets

@main
struct FormsShowcase: SwiftletMain {
    @Query("submitted") var wasSubmitted: String?
    @FormValue("username") var username: String?
    @FormValue("email") var email: String?
    @FormValue("country") var country: String?
    
    var title = "Form Elements - Swiftlets Showcase"
    
    var body: some HTMLElement {
        Fragment {
            showcaseStyles()
            formStyles()
            navigation()
            header()
            mainContent()
        }
    }
    
    @HTMLBuilder
    func formStyles() -> some HTMLElement {
        Style("""
        /* Form-specific styles */
        input, textarea, select {
            width: 100%;
            padding: 0.5rem 0.75rem;
            border: 1px solid #e9ecef;
            border-radius: 0.375rem;
            font-size: 1rem;
            transition: border-color 0.15s ease-in-out;
        }
        
        input:focus, textarea:focus, select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: #374151;
        }
        
        .btn {
            padding: 0.5rem 1rem;
            border: none;
            border-radius: 0.375rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        
        .btn-success {
            background: #10b981;
            color: white;
        }
        
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2rem;
        }
        
        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
        }
        """)
    }
    
    @HTMLBuilder
    func navigation() -> some HTMLElement {
        Div {
            Div {
                Link(href: "/", "Swiftlets")
                    .class("nav-brand")
                Div {
                    Link(href: "/docs", "Documentation")
                    Link(href: "/showcase", "Showcase")
                        .class("active")
                    Link(href: "/about", "About")
                }
                .class("nav-links")
            }
            .class("nav-content")
        }
        .class("nav-container")
    }
    
    @HTMLBuilder
    func header() -> some HTMLElement {
        Div {
            Div {
                H1("Form Elements")
                P("Interactive form inputs, buttons, and form handling examples")
            }
            .class("showcase-container")
        }
        .class("showcase-header")
    }
    
    @HTMLBuilder
    func mainContent() -> some HTMLElement {
        Div {
            // Breadcrumb
            Div {
                Link(href: "/showcase", "← Back to Showcase")
            }
            .style("margin-bottom", "2rem")
            
            // Show submitted data if form was posted
            If(wasSubmitted == "true") {
                Div {
                    H3("✅ Form Submitted Successfully!")
                    P("Received values:")
                    UL {
                        LI("Username: \(username ?? "not provided")")
                        LI("Email: \(email ?? "not provided")")
                        LI("Country: \(country ?? "not provided")")
                    }
                }
                .style("background", "linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%)")
                .style("border", "1px solid #c3e6cb")
                .style("border-radius", "0.75rem")
                .style("padding", "1.5rem")
                .style("margin-bottom", "2rem")
                .style("box-shadow", "0 4px 6px rgba(0,0,0,0.05)")
            }
            
            textInputsSection()
            selectAndTextAreaSection()
            buttonsSection()
            completeFormSection()
            
            // Navigation links
            Div {
                Link(href: "/showcase/list-examples", "Lists")
                    .class("nav-button")
                Link(href: "/showcase/media-elements", "Media Elements")
                    .class("nav-button nav-button-next")
            }
            .class("navigation-links")
        }
        .class("showcase-container")
    }
    
    @HTMLBuilder
    func textInputsSection() -> some HTMLElement {
        Div {
            H2("Text Input Types")
                .style("margin-bottom", "2rem")
            
            Div {
                // Basic Text Input
                inputExample(
                    title: "Text Input",
                    code: """
                    Input(type: "text", name: "username", placeholder: "Enter username")
                    """,
                    input: Input(type: "text", name: "demo-username", placeholder: "Enter username")
                )
                
                // Email Input
                inputExample(
                    title: "Email Input",
                    code: """
                    Input(type: "email", name: "email", placeholder: "user@example.com")
                    """,
                    input: Input(type: "email", name: "demo-email", placeholder: "user@example.com")
                )
                
                // Password Input
                inputExample(
                    title: "Password Input",
                    code: """
                    Input(type: "password", name: "password", placeholder: "Enter password")
                    """,
                    input: Input(type: "password", name: "demo-password", placeholder: "Enter password")
                )
                
                // Number Input
                inputExample(
                    title: "Number Input",
                    code: """
                    Input(type: "number", name: "age", placeholder: "Age")
                        .attribute("min", "0")
                        .attribute("max", "120")
                    """,
                    input: Input(type: "number", name: "demo-age", placeholder: "Age")
                        .attribute("min", "0")
                        .attribute("max", "120")
                )
            }
            .class("form-grid")
        }
        .style("margin-bottom", "3rem")
    }
    
    @HTMLBuilder
    func selectAndTextAreaSection() -> some HTMLElement {
        Div {
            H2("Select & TextArea")
                .style("margin-bottom", "2rem")
            
            CodeExample(
                title: "Select Dropdown",
                swift: """
                Select(name: "country") {
                    Option("Choose a country", value: "")
                    Option("United States", value: "us")
                    Option("United Kingdom", value: "uk")
                    Option("Canada", value: "ca")
                }
                """,
                html: """
                <select name="country">
                    <option value="">Choose a country</option>
                    <option value="us">United States</option>
                    <option value="uk">United Kingdom</option>
                    <option value="ca">Canada</option>
                </select>
                """,
                preview: {
                    Select(name: "demo-country") {
                        Option("Choose a country", value: "")
                        Option("United States", value: "us")
                        Option("United Kingdom", value: "uk")
                        Option("Canada", value: "ca")
                    }
                },
                description: "Dropdown selection with multiple options."
            ).render()
            
            CodeExample(
                title: "TextArea",
                swift: """
                TextArea(name: "message", rows: 4, placeholder: "Enter your message...")
                """,
                html: """
                <textarea name="message" rows="4" placeholder="Enter your message..."></textarea>
                """,
                preview: {
                    TextArea(name: "demo-message", rows: 4, placeholder: "Enter your message...")
                },
                description: "Multi-line text input for longer content."
            ).render()
        }
        .style("margin-bottom", "3rem")
    }
    
    @HTMLBuilder
    func buttonsSection() -> some HTMLElement {
        Div {
            H2("Buttons")
                .style("margin-bottom", "2rem")
            
            CodeExample(
                title: "Button Types",
                swift: """
                HStack(spacing: 16) {
                    Button("Submit", type: "submit")
                        .class("btn btn-primary")
                    Button("Reset", type: "reset")
                        .class("btn btn-secondary")
                    Button("Click Me", type: "button")
                        .class("btn btn-success")
                }
                """,
                html: """
                <div class="hstack" style="gap: 16px">
                    <button type="submit" class="btn btn-primary">Submit</button>
                    <button type="reset" class="btn btn-secondary">Reset</button>
                    <button type="button" class="btn btn-success">Click Me</button>
                </div>
                """,
                preview: {
                    HStack(spacing: 16) {
                        Button("Submit", type: "submit")
                            .class("btn btn-primary")
                        Button("Reset", type: "reset")
                            .class("btn btn-secondary")
                        Button("Click Me", type: "button")
                            .class("btn btn-success")
                    }
                },
                description: "Different button types with custom styling."
            ).render()
        }
        .style("margin-bottom", "3rem")
    }
    
    @HTMLBuilder
    func completeFormSection() -> some HTMLElement {
        Div {
            H2("Complete Form Example")
                .style("margin-bottom", "2rem")
            
            Div {
                H3("Working Form with SwiftUI-Style Property Wrappers")
                    .style("color", "#2c3e50")
                    .style("margin-bottom", "1rem")
                P("This form uses @FormValue property wrappers to access submitted data")
                    .style("color", "#6c757d")
                    .style("margin-bottom", "2rem")
                
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
                                .class("btn btn-primary")
                                .style("width", "auto")
                                .style("padding", "0.75rem 2rem")
                        }
                    }
                }
                .style("background", "linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%)")
                .style("padding", "2rem")
                .style("border-radius", "0.75rem")
                .style("box-shadow", "0 4px 6px rgba(0,0,0,0.05)")
            }
            .class("code-example")
        }
    }
    
    @HTMLBuilder
    func inputExample<InputType: HTMLElement>(title: String, code: String, input: InputType) -> some HTMLElement {
        Div {
            H4(title)
                .style("margin-bottom", "1rem")
                .style("color", "#2c3e50")
            Pre {
                Code(code)
            }
            .style("background", "#2d3748")
            .style("color", "#e2e8f0")
            .style("padding", "1rem")
            .style("border-radius", "0.5rem")
            .style("margin-bottom", "1rem")
            .style("font-size", "0.875rem")
            
            Div {
                input
            }
            .style("padding", "1rem")
            .style("background", "white")
            .style("border", "2px dashed #e9ecef")
            .style("border-radius", "0.5rem")
        }
        .style("padding", "1.5rem")
        .style("background", "#f8f9fa")
        .style("border-radius", "0.75rem")
    }
}