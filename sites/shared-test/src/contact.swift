@main
struct ContactPage: SwiftletMain {
    @FormValue("name") var name: String?
    @FormValue("email") var email: String?
    @FormValue("message") var message: String?
    
    var title = "Contact - Shared Components Demo"
    
    var body: some HTMLElement {
        PageLayout(activePage: "contact") {
            VStack(spacing: 32) {
                H1("Contact Us")
                
                P("This page demonstrates form handling with shared layout components.")
                
                If(name != nil || email != nil) {
                    Div {
                        H3("Thank you for your submission!")
                        P("We received:")
                        UL {
                            If(name != nil) {
                                LI("Name: \(name!)")
                            }
                            If(email != nil) {
                                LI("Email: \(email!)")
                            }
                            If(message != nil) {
                                LI("Message: \(message!)")
                            }
                        }
                    }
                    .style("background", "#d4edda")
                    .style("border", "1px solid #c3e6cb")
                    .style("color", "#155724")
                    .style("padding", "1rem")
                    .style("border-radius", "4px")
                }
                
                Form(action: "/contact", method: "POST") {
                    VStack(spacing: 20) {
                        Div {
                            Label("Name", for: "name")
                            Input(type: "text", name: "name")
                                .id("name")
                                .style("width", "100%")
                                .style("padding", "0.5rem")
                                .style("border", "1px solid #ccc")
                                .style("border-radius", "4px")
                        }
                        
                        Div {
                            Label("Email", for: "email")
                            Input(type: "email", name: "email")
                                .id("email")
                                .style("width", "100%")
                                .style("padding", "0.5rem")
                                .style("border", "1px solid #ccc")
                                .style("border-radius", "4px")
                        }
                        
                        Div {
                            Label("Message", for: "message")
                            TextArea(name: "message", rows: 5)
                                .id("message")
                                .style("width", "100%")
                                .style("padding", "0.5rem")
                                .style("border", "1px solid #ccc")
                                .style("border-radius", "4px")
                        }
                        
                        Button("Submit", type: "submit")
                            .style("background", "#0066cc")
                            .style("color", "white")
                            .style("padding", "0.5rem 2rem")
                            .style("border", "none")
                            .style("border-radius", "4px")
                            .style("cursor", "pointer")
                    }
                }
            }
        }
    }
}