import Foundation

@main
struct FormsShowcase {
    static func main() async throws {
        let request = try JSONDecoder().decode(Request.self, from: FileHandle.standardInput.readDataToEndOfFile())
        
        let html = Html {
                Head {
                    Title("Forms - Swiftlets Showcase")
                    LinkElement(rel: "stylesheet", href: "/styles/main.css")
                    LinkElement(rel: "stylesheet", href: "/styles/prism.css")
                }
                Body {
                    // Navigation
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
                    .class("navbar")
                    
                    // Content
                    Div {
                        Div {
                            // Breadcrumb
                            Div {
                                Link(href: "/showcase", "Showcase")
                                Text(" → ")
                                Text("Forms")
                            }
                            .class("breadcrumb")
                            
                            H1("Forms")
                            P("Examples of HTML form elements including inputs, selects, textareas, and form layouts.")
                            
                            // Example 1: Basic Form Elements
                            CodeExample(
                                title: "Basic Form Elements",
                                swift: """
Form(action: "/submit", method: "POST") {
    Div {
        Label("Username:")
            .attribute("for", "username")
        Input(type: "text", name: "username")
            .id("username")
            .attribute("placeholder", "Enter username")
            .attribute("required", "")
    }
    .class("form-group")
    
    Div {
        Label("Email:")
            .attribute("for", "email")
        Input(type: "email", name: "email")
            .id("email")
            .attribute("placeholder", "user@example.com")
            .attribute("required", "")
    }
    .class("form-group")
    
    Div {
        Label("Password:")
            .attribute("for", "password")
        Input(type: "password", name: "password")
            .id("password")
            .attribute("required", "")
    }
    .class("form-group")
    
    Button("Submit", type: "submit")
        .class("btn btn-primary")
}
""",
                                html: """
<form action="/submit" method="POST">
    <div class="form-group">
        <label for="username">Username:</label>
        <input type="text" name="username" id="username" placeholder="Enter username" required>
    </div>
    
    <div class="form-group">
        <label for="email">Email:</label>
        <input type="email" name="email" id="email" placeholder="user@example.com" required>
    </div>
    
    <div class="form-group">
        <label for="password">Password:</label>
        <input type="password" name="password" id="password" required>
    </div>
    
    <button type="submit" class="btn btn-primary">Submit</button>
</form>
""",
                                preview: {
                                    Form(action: "/submit", method: "POST") {
                                        Div {
                                            Label("Username:")
                                                .attribute("for", "username")
                                            Input(type: "text", name: "username")
                                                .id("username")
                                                .attribute("placeholder", "Enter username")
                                                .attribute("required", "")
                                        }
                                        .class("form-group")
                                        
                                        Div {
                                            Label("Email:")
                                                .attribute("for", "email")
                                            Input(type: "email", name: "email")
                                                .id("email")
                                                .attribute("placeholder", "user@example.com")
                                                .attribute("required", "")
                                        }
                                        .class("form-group")
                                        
                                        Div {
                                            Label("Password:")
                                                .attribute("for", "password")
                                            Input(type: "password", name: "password")
                                                .id("password")
                                                .attribute("required", "")
                                        }
                                        .class("form-group")
                                        
                                        Button("Submit", type: "submit")
                                            .class("btn btn-primary")
                                    }
                                }
                            ).render()
                            
                            // Example 2: Input Types
                            CodeExample(
                                title: "Input Types",
                                swift: """
Form(action: "#", method: "GET") {
    // Text inputs
    Input(type: "text", name: "text")
        .attribute("placeholder", "Text input")
    
    // Number input
    Input(type: "number", name: "age")
        .attribute("min", "0")
        .attribute("max", "120")
        .attribute("placeholder", "Age")
    
    // Date input
    Input(type: "date", name: "birthdate")
    
    // Time input
    Input(type: "time", name: "appointment")
    
    // Color picker
    Input(type: "color", name: "favorite_color")
        .attribute("value", "#007bff")
    
    // Range slider
    Label("Volume: ")
    Input(type: "range", name: "volume")
        .attribute("min", "0")
        .attribute("max", "100")
        .attribute("value", "50")
    
    // File upload
    Input(type: "file", name: "upload")
        .attribute("accept", "image/*")
    
    // Search
    Input(type: "search", name: "query")
        .attribute("placeholder", "Search...")
    
    // URL
    Input(type: "url", name: "website")
        .attribute("placeholder", "https://example.com")
    
    // Tel
    Input(type: "tel", name: "phone")
        .attribute("placeholder", "+1 (555) 123-4567")
}
""",
                                html: """
<form>
    <input type="text" name="text" placeholder="Text input">
    <input type="number" name="age" min="0" max="120" placeholder="Age">
    <input type="date" name="birthdate">
    <input type="time" name="appointment">
    <input type="color" name="favorite_color" value="#007bff">
    <label>Volume: </label>
    <input type="range" name="volume" min="0" max="100" value="50">
    <input type="file" name="upload" accept="image/*">
    <input type="search" name="query" placeholder="Search...">
    <input type="url" name="website" placeholder="https://example.com">
    <input type="tel" name="phone" placeholder="+1 (555) 123-4567">
</form>
""",
                                preview: {
                                    Form(action: "#", method: "GET") {
                                        Div {
                                            Input(type: "text", name: "text")
                                                .attribute("placeholder", "Text input")
                                        }
                                        .class("form-group")
                                        
                                        Div {
                                            Input(type: "number", name: "age")
                                                .attribute("min", "0")
                                                .attribute("max", "120")
                                                .attribute("placeholder", "Age")
                                        }
                                        .class("form-group")
                                        
                                        Div {
                                            Input(type: "date", name: "birthdate")
                                        }
                                        .class("form-group")
                                        
                                        Div {
                                            Input(type: "time", name: "appointment")
                                        }
                                        .class("form-group")
                                        
                                        Div {
                                            Label("Favorite Color: ")
                                            Input(type: "color", name: "favorite_color")
                                                .attribute("value", "#007bff")
                                        }
                                        .class("form-group")
                                        
                                        Div {
                                            Label("Volume: ")
                                            Input(type: "range", name: "volume")
                                                .attribute("min", "0")
                                                .attribute("max", "100")
                                                .attribute("value", "50")
                                        }
                                        .class("form-group")
                                        
                                        Div {
                                            Input(type: "file", name: "upload")
                                                .attribute("accept", "image/*")
                                        }
                                        .class("form-group")
                                        
                                        Div {
                                            Input(type: "search", name: "query")
                                                .attribute("placeholder", "Search...")
                                        }
                                        .class("form-group")
                                        
                                        Div {
                                            Input(type: "url", name: "website")
                                                .attribute("placeholder", "https://example.com")
                                        }
                                        .class("form-group")
                                        
                                        Div {
                                            Input(type: "tel", name: "phone")
                                                .attribute("placeholder", "+1 (555) 123-4567")
                                        }
                                        .class("form-group")
                                    }
                                }
                            ).render()
                            
                            // Example 3: Select and TextArea
                            CodeExample(
                                title: "Select and TextArea",
                                swift: """
Form(action: "#", method: "GET") {
    Div {
        Label("Country:")
            .attribute("for", "country")
        Select(name: "country") {
            Option("Select a country", value: "")
                .attribute("disabled", "")
                .attribute("selected", "")
            Option("United States", value: "us")
            Option("United Kingdom", value: "uk")
            Option("Canada", value: "ca")
            Option("Australia", value: "au")
            Option("Germany", value: "de")
        }
        .id("country")
    }
    .class("form-group")
    
    Div {
        Label("Programming Languages:")
            .attribute("for", "languages")
        Select(name: "languages[]") {
            Option("-- Frontend --", value: "")
                .attribute("disabled", "")
            Option("JavaScript", value: "js")
            Option("TypeScript", value: "ts")
            Option("CSS", value: "css")
            Option("-- Backend --", value: "")
                .attribute("disabled", "")
            Option("Swift", value: "swift")
            Option("Python", value: "python")
            Option("Ruby", value: "ruby")
            Option("Go", value: "go")
        }
        .id("languages")
        .attribute("multiple", "")
        .attribute("size", "8")
    }
    .class("form-group")
    
    Div {
        Label("Comments:")
            .attribute("for", "comments")
        TextArea(name: "comments", rows: 4)
            .id("comments")
            .attribute("placeholder", "Enter your comments here...")
            .style("width", "100%")
    }
    .class("form-group")
}
""",
                                html: """
<form>
    <div class="form-group">
        <label for="country">Country:</label>
        <select name="country" id="country">
            <option value="" disabled selected>Select a country</option>
            <option value="us">United States</option>
            <option value="uk">United Kingdom</option>
            <option value="ca">Canada</option>
            <option value="au">Australia</option>
            <option value="de">Germany</option>
        </select>
    </div>
    
    <div class="form-group">
        <label for="languages">Programming Languages:</label>
        <select name="languages[]" id="languages" multiple size="8">
            <option value="" disabled>-- Frontend --</option>
            <option value="js">JavaScript</option>
            <option value="ts">TypeScript</option>
            <option value="css">CSS</option>
            <option value="" disabled>-- Backend --</option>
            <option value="swift">Swift</option>
            <option value="python">Python</option>
            <option value="ruby">Ruby</option>
            <option value="go">Go</option>
        </select>
    </div>
    
    <div class="form-group">
        <label for="comments">Comments:</label>
        <textarea name="comments" id="comments" rows="4" placeholder="Enter your comments here..." style="width: 100%"></textarea>
    </div>
</form>
""",
                                preview: {
                                    Form(action: "#", method: "GET") {
                                        Div {
                                            Label("Country:")
                                                .attribute("for", "country")
                                            Select(name: "country") {
                                                Option("Select a country", value: "")
                                                    .attribute("disabled", "")
                                                    .attribute("selected", "")
                                                Option("United States", value: "us")
                                                Option("United Kingdom", value: "uk")
                                                Option("Canada", value: "ca")
                                                Option("Australia", value: "au")
                                                Option("Germany", value: "de")
                                            }
                                            .id("country")
                                        }
                                        .class("form-group")
                                        
                                        Div {
                                            Label("Programming Languages:")
                                                .attribute("for", "languages")
                                            Select(name: "languages[]") {
                                                Option("-- Frontend --", value: "")
                                                    .attribute("disabled", "")
                                                Option("JavaScript", value: "js")
                                                Option("TypeScript", value: "ts")
                                                Option("CSS", value: "css")
                                                Option("-- Backend --", value: "")
                                                    .attribute("disabled", "")
                                                Option("Swift", value: "swift")
                                                Option("Python", value: "python")
                                                Option("Ruby", value: "ruby")
                                                Option("Go", value: "go")
                                            }
                                            .id("languages")
                                            .attribute("multiple", "")
                                            .attribute("size", "8")
                                        }
                                        .class("form-group")
                                        
                                        Div {
                                            Label("Comments:")
                                                .attribute("for", "comments")
                                            TextArea(name: "comments", rows: 4)
                                                .id("comments")
                                                .attribute("placeholder", "Enter your comments here...")
                                                .style("width", "100%")
                                        }
                                        .class("form-group")
                                    }
                                }
                            ).render()
                            
                            // Example 4: Checkboxes and Radio Buttons
                            CodeExample(
                                title: "Checkboxes and Radio Buttons",
                                swift: """
Form(action: "#", method: "POST") {
    FieldSet {
        Legend("Select your interests:")
        
        Div {
            Input(type: "checkbox", name: "interests", value: "coding")
                .id("coding")
            Label(" Coding")
                .attribute("for", "coding")
        }
        
        Div {
            Input(type: "checkbox", name: "interests", value: "design")
                .id("design")
                .attribute("checked", "")
            Label(" Design")
                .attribute("for", "design")
        }
        
        Div {
            Input(type: "checkbox", name: "interests", value: "music")
                .id("music")
            Label(" Music")
                .attribute("for", "music")
        }
    }
    .class("form-group")
    
    FieldSet {
        Legend("Choose your plan:")
        
        Div {
            Input(type: "radio", name: "plan", value: "free")
                .id("plan-free")
                .attribute("checked", "")
            Label(" Free Plan")
                .attribute("for", "plan-free")
        }
        
        Div {
            Input(type: "radio", name: "plan", value: "pro")
                .id("plan-pro")
            Label(" Pro Plan ($9/month)")
                .attribute("for", "plan-pro")
        }
        
        Div {
            Input(type: "radio", name: "plan", value: "enterprise")
                .id("plan-enterprise")
            Label(" Enterprise Plan ($99/month)")
                .attribute("for", "plan-enterprise")
        }
    }
    .class("form-group")
}
""",
                                html: """
<form>
    <fieldset class="form-group">
        <legend>Select your interests:</legend>
        
        <div>
            <input type="checkbox" name="interests" value="coding" id="coding">
            <label for="coding"> Coding</label>
        </div>
        
        <div>
            <input type="checkbox" name="interests" value="design" id="design" checked>
            <label for="design"> Design</label>
        </div>
        
        <div>
            <input type="checkbox" name="interests" value="music" id="music">
            <label for="music"> Music</label>
        </div>
    </fieldset>
    
    <fieldset class="form-group">
        <legend>Choose your plan:</legend>
        
        <div>
            <input type="radio" name="plan" value="free" id="plan-free" checked>
            <label for="plan-free"> Free Plan</label>
        </div>
        
        <div>
            <input type="radio" name="plan" value="pro" id="plan-pro">
            <label for="plan-pro"> Pro Plan ($9/month)</label>
        </div>
        
        <div>
            <input type="radio" name="plan" value="enterprise" id="plan-enterprise">
            <label for="plan-enterprise"> Enterprise Plan ($99/month)</label>
        </div>
    </fieldset>
</form>
""",
                                preview: {
                                    Form(action: "#", method: "POST") {
                                        FieldSet {
                                            Legend("Select your interests:")
                                            
                                            Div {
                                                Input(type: "checkbox", name: "interests", value: "coding")
                                                    .id("coding")
                                                Label(" Coding")
                                                    .attribute("for", "coding")
                                            }
                                            
                                            Div {
                                                Input(type: "checkbox", name: "interests", value: "design")
                                                    .id("design")
                                                    .attribute("checked", "")
                                                Label(" Design")
                                                    .attribute("for", "design")
                                            }
                                            
                                            Div {
                                                Input(type: "checkbox", name: "interests", value: "music")
                                                    .id("music")
                                                Label(" Music")
                                                    .attribute("for", "music")
                                            }
                                        }
                                        .class("form-group")
                                        
                                        FieldSet {
                                            Legend("Choose your plan:")
                                            
                                            Div {
                                                Input(type: "radio", name: "plan", value: "free")
                                                    .id("plan-free")
                                                    .attribute("checked", "")
                                                Label(" Free Plan")
                                                    .attribute("for", "plan-free")
                                            }
                                            
                                            Div {
                                                Input(type: "radio", name: "plan", value: "pro")
                                                    .id("plan-pro")
                                                Label(" Pro Plan ($9/month)")
                                                    .attribute("for", "plan-pro")
                                            }
                                            
                                            Div {
                                                Input(type: "radio", name: "plan", value: "enterprise")
                                                    .id("plan-enterprise")
                                                Label(" Enterprise Plan ($99/month)")
                                                    .attribute("for", "plan-enterprise")
                                            }
                                        }
                                        .class("form-group")
                                    }
                                }
                            ).render()
                            
                            // Example 5: Complete Contact Form
                            CodeExample(
                                title: "Complete Contact Form",
                                swift: """
Form(action: "/contact", method: "POST") {
    H3("Contact Us")
    
    Div {
        Div {
            Label("Name:")
                .attribute("for", "name")
                .class("required")
            Input(type: "text", name: "name")
                .id("name")
                .attribute("required", "")
                .class("form-control")
        }
        .class("form-group")
        
        Div {
            Label("Email:")
                .attribute("for", "email")
                .class("required")
            Input(type: "email", name: "email")
                .id("email")
                .attribute("required", "")
                .class("form-control")
        }
        .class("form-group")
        
        Div {
            Label("Subject:")
                .attribute("for", "subject")
            Select(name: "subject") {
                Option("General Inquiry", value: "general")
                Option("Technical Support", value: "support")
                Option("Sales", value: "sales")
                Option("Other", value: "other")
            }
            .id("subject")
            .class("form-control")
        }
        .class("form-group")
        
        Div {
            Label("Message:")
                .attribute("for", "message")
                .class("required")
            TextArea(name: "message", rows: 6)
                .id("message")
                .attribute("required", "")
                .class("form-control")
        }
        .class("form-group")
        
        Div {
            Input(type: "checkbox", name: "newsletter")
                .id("newsletter")
            Label(" Subscribe to newsletter")
                .attribute("for", "newsletter")
        }
        .class("form-check")
        
        Div {
            Button("Send Message", type: "submit")
                .class("btn btn-primary")
            Button("Reset", type: "reset")
                .class("btn btn-secondary")
                .style("margin-left", "10px")
        }
        .class("form-group")
    }
    .class("contact-form")
}
""",
                                html: """
<form action="/contact" method="POST">
    <h3>Contact Us</h3>
    
    <div class="contact-form">
        <div class="form-group">
            <label for="name" class="required">Name:</label>
            <input type="text" name="name" id="name" required class="form-control">
        </div>
        
        <div class="form-group">
            <label for="email" class="required">Email:</label>
            <input type="email" name="email" id="email" required class="form-control">
        </div>
        
        <div class="form-group">
            <label for="subject">Subject:</label>
            <select name="subject" id="subject" class="form-control">
                <option value="general">General Inquiry</option>
                <option value="support">Technical Support</option>
                <option value="sales">Sales</option>
                <option value="other">Other</option>
            </select>
        </div>
        
        <div class="form-group">
            <label for="message" class="required">Message:</label>
            <textarea name="message" id="message" rows="6" required class="form-control"></textarea>
        </div>
        
        <div class="form-check">
            <input type="checkbox" name="newsletter" id="newsletter">
            <label for="newsletter"> Subscribe to newsletter</label>
        </div>
        
        <div class="form-group">
            <button type="submit" class="btn btn-primary">Send Message</button>
            <button type="reset" class="btn btn-secondary" style="margin-left: 10px">Reset</button>
        </div>
    </div>
</form>
""",
                                preview: {
                                    Form(action: "/contact", method: "POST") {
                                        H3("Contact Us")
                                        
                                        Div {
                                            Div {
                                                Label("Name:")
                                                    .attribute("for", "name")
                                                    .class("required")
                                                Input(type: "text", name: "name")
                                                    .id("name")
                                                    .attribute("required", "")
                                                    .class("form-control")
                                            }
                                            .class("form-group")
                                            
                                            Div {
                                                Label("Email:")
                                                    .attribute("for", "email")
                                                    .class("required")
                                                Input(type: "email", name: "email")
                                                    .id("email")
                                                    .attribute("required", "")
                                                    .class("form-control")
                                            }
                                            .class("form-group")
                                            
                                            Div {
                                                Label("Subject:")
                                                    .attribute("for", "subject")
                                                Select(name: "subject") {
                                                    Option("General Inquiry", value: "general")
                                                    Option("Technical Support", value: "support")
                                                    Option("Sales", value: "sales")
                                                    Option("Other", value: "other")
                                                }
                                                .id("subject")
                                                .class("form-control")
                                            }
                                            .class("form-group")
                                            
                                            Div {
                                                Label("Message:")
                                                    .attribute("for", "message")
                                                    .class("required")
                                                TextArea(name: "message", rows: 6)
                                                    .id("message")
                                                    .attribute("required", "")
                                                    .class("form-control")
                                            }
                                            .class("form-group")
                                            
                                            Div {
                                                Input(type: "checkbox", name: "newsletter")
                                                    .id("newsletter")
                                                Label(" Subscribe to newsletter")
                                                    .attribute("for", "newsletter")
                                            }
                                            .class("form-check")
                                            
                                            Div {
                                                Button("Send Message", type: "submit")
                                                    .class("btn btn-primary")
                                                Button("Reset", type: "reset")
                                                    .class("btn btn-secondary")
                                                    .style("margin-left", "10px")
                                            }
                                            .class("form-group")
                                        }
                                        .class("contact-form")
                                    }
                                }
                            ).render()
                            
                            // Navigation
                            Div {
                                Link(href: "/showcase/tables", "Tables")
                                    .class("nav-button")
                                Link(href: "/showcase/media", "Media")
                                    .class("nav-button nav-button-next")
                            }
                            .class("navigation-links")
                        }
                        .class("content")
                    }
                    .class("container")
                    
                    Script(src: "/scripts/prism.js")
                }
            }
        
        let response = Response(
            status: 200,
            headers: ["Content-Type": "text/html"],
            body: html.render()
        )
        
        let responseData = try JSONEncoder().encode(response)
        FileHandle.standardOutput.write(responseData)
    }
}