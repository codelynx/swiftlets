import Foundation
import Swiftlets

// Advanced DSL features showcase

struct User {
    let id: Int
    let name: String
    let email: String
    let role: String
}

let users = [
    User(id: 1, name: "Alice Johnson", email: "alice@example.com", role: "Admin"),
    User(id: 2, name: "Bob Smith", email: "bob@example.com", role: "User"),
    User(id: 3, name: "Charlie Brown", email: "charlie@example.com", role: "User"),
    User(id: 4, name: "Diana Prince", email: "diana@example.com", role: "Moderator")
]

let isLoggedIn = true
let currentUser = "Alice"

let page = Html {
    Head {
        Meta(charset: "utf-8")
        Title("Advanced DSL Features - Swiftlets")
        Style("""
            body { 
                font-family: system-ui, sans-serif; 
                max-width: 1200px; 
                margin: 0 auto; 
                padding: 20px;
                background: #f5f5f5;
            }
            .card {
                background: white;
                padding: 20px;
                margin: 20px 0;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }
            table {
                width: 100%;
                border-collapse: collapse;
            }
            th, td {
                padding: 12px;
                text-align: left;
                border-bottom: 1px solid #ddd;
            }
            th {
                background: #f8f9fa;
                font-weight: 600;
            }
            .role-admin { color: #dc3545; }
            .role-moderator { color: #ffc107; }
            .role-user { color: #28a745; }
            details {
                margin: 10px 0;
            }
            summary {
                cursor: pointer;
                font-weight: 600;
                padding: 10px;
                background: #e9ecef;
                border-radius: 4px;
            }
            .metric {
                display: inline-block;
                margin: 10px 20px 10px 0;
            }
            kbd {
                background: #f8f9fa;
                padding: 2px 6px;
                border: 1px solid #dee2e6;
                border-radius: 3px;
                font-family: monospace;
            }
        """)
    }
    Body {
        Header {
            H1("Advanced SwiftletsHTML Features")
            Nav {
                If(isLoggedIn, then: {
                    P {
                        Text("Welcome, ")
                        Strong(currentUser)
                        Text(" | ")
                        A(href: "/logout", "Logout")
                    }
                }, else: {
                    P {
                        A(href: "/login", "Login")
                        Text(" | ")
                        A(href: "/signup", "Sign Up")
                    }
                })
            }
        }
        
        Main {
            // Dynamic content with ForEach
            Section {
                H2("User Management")
                    .class("card")
                
                Div {
                    Table {
                        THead {
                            TR {
                                TH("ID")
                                TH("Name")
                                TH("Email")
                                TH("Role")
                                TH("Actions")
                            }
                        }
                        TBody {
                            ForEach(users) { user in
                                TR {
                                    TD("\(user.id)")
                                    TD(user.name)
                                    TD {
                                        A(href: "mailto:\(user.email)", user.email)
                                    }
                                    TD {
                                        Span(user.role)
                                            .class("role-\(user.role.lowercased())")
                                    }
                                    TD {
                                        Button("Edit").class("btn-sm")
                                        Text(" ")
                                        Button("Delete").class("btn-sm btn-danger")
                                    }
                                }
                            }
                        }
                    }
                }
                .class("card")
            }
            
            // Progress indicators
            Section {
                H2("System Status")
                    .class("card")
                
                Div {
                    Div {
                        Label("CPU Usage:")
                        Progress(value: 0.65, max: 1.0)
                        Text(" 65%")
                    }
                    .class("metric")
                    
                    Div {
                        Label("Memory:")
                        Meter(value: 7.2, min: 0, max: 16, low: 4, high: 12, optimum: 8)
                        Text(" 7.2 GB / 16 GB")
                    }
                    .class("metric")
                    
                    Div {
                        Label("Disk Space:")
                        Progress(value: 0.80, max: 1.0)
                        Text(" 80% used")
                    }
                    .class("metric")
                }
                .class("card")
            }
            
            // Details/Summary for collapsible content
            Section {
                H2("Documentation")
                    .class("card")
                
                Div {
                    Details(open: true) {
                        Summary("Keyboard Shortcuts")
                        UL {
                            LI {
                                Kbd("Cmd")
                                Text(" + ")
                                Kbd("S")
                                Text(" - Save document")
                            }
                            LI {
                                Kbd("Cmd")
                                Text(" + ")
                                Kbd("Shift")
                                Text(" + ")
                                Kbd("P")
                                Text(" - Command palette")
                            }
                            LI {
                                Kbd("Esc")
                                Text(" - Close dialog")
                            }
                        }
                    }
                    
                    Details {
                        Summary("Mathematical Notations")
                        P {
                            Text("Einstein's famous equation: E = mc")
                            Sup("2")
                        }
                        P {
                            Text("Water formula: H")
                            Sub("2")
                            Text("O")
                        }
                        P {
                            Text("Variables in code: ")
                            Code("let ")
                            Var("x")
                            Code(" = 42")
                        }
                    }
                    
                    Details {
                        Summary("Text Formatting Examples")
                        P {
                            Text("You can use ")
                            Strong("bold")
                            Text(", ")
                            Em("italic")
                            Text(", ")
                            Mark("highlighted")
                            Text(", ")
                            Del("deleted")
                            Text(", and ")
                            Ins("inserted")
                            Text(" text.")
                        }
                        BlockQuote {
                            P("SwiftletsHTML makes HTML generation type-safe and enjoyable.")
                            Footer {
                                Cite("— SwiftletsHTML Documentation")
                            }
                        }
                    }
                }
                .class("card")
            }
            
            // Advanced form with conditional fields
            Section {
                H2("Dynamic Form Example")
                    .class("card")
                
                Form(action: "/submit", method: "POST") {
                    FieldSet {
                        Legend("Account Type")
                        
                        ForEach(["Personal", "Business", "Developer"]) { type in
                            Label {
                                Input(type: "radio", name: "account_type", value: type.lowercased())
                                Text(" \(type)")
                            }
                            BR()
                        }
                    }
                    
                    FieldSet {
                        Legend("Preferences")
                        
                        // Using ForEachWithIndex for numbered options
                        ForEachWithIndex(["Email", "SMS", "Push Notifications"]) { index, option in
                            Label {
                                Input(type: "checkbox", name: "pref_\(index)", value: "yes")
                                Text(" \(option)")
                            }
                            BR()
                        }
                    }
                    
                    Button("Submit", type: "submit")
                        .class("btn btn-primary")
                }
                .class("card")
            }
            
            // Time-based content
            Section {
                H2("Temporal Data")
                    .class("card")
                
                Div {
                    P {
                        Text("Current time: ")
                        Time(Date().description, datetime: ISO8601DateFormatter().string(from: Date()))
                    }
                    P {
                        Text("Last updated: ")
                        Time("5 minutes ago", datetime: ISO8601DateFormatter().string(from: Date().addingTimeInterval(-300)))
                    }
                    P {
                        Text("Server version: ")
                        Data("2.1.0", value: "2.1.0")
                    }
                }
                .class("card")
            }
        }
        
        Footer {
            HR()
            P {
                Small {
                    Text("© 2025 Swiftlets • Built with ")
                    Abbr("HTML", title: "HyperText Markup Language")
                    Text(" ")
                    Abbr("DSL", title: "Domain Specific Language")
                    Text(" • Process: ")
                    Samp("\(ProcessInfo.processInfo.processIdentifier)")
                }
            }
            .center()
        }
    }
}

// Output HTTP response
print("Status: 200")
print("Content-Type: text/html; charset=utf-8")
print("")
print(page.render())