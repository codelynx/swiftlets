import Foundation
import SwiftletsHTML

// Get request info from environment
let method = ProcessInfo.processInfo.environment["REQUEST_METHOD"] ?? "GET"
let path = ProcessInfo.processInfo.environment["REQUEST_PATH"] ?? "/"

// Build page using HTML DSL
let page = Html {
    Head {
        Meta(charset: "utf-8")
        Title("Hello from Swiftlets DSL")
        RawHTML("""
        <style>
            body {
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                max-width: 800px;
                margin: 50px auto;
                padding: 20px;
                background: #f5f5f5;
            }
            .container {
                background: white;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            .info {
                background: #f0f0f0;
                padding: 15px;
                border-radius: 5px;
                margin: 10px 0;
                font-family: 'Courier New', monospace;
            }
            .label {
                font-weight: bold;
                color: #666;
            }
        </style>
        """)
    }
    Body {
        Div {
            H1("🚀 Hello from Swiftlets DSL!")
                .class("title")
            
            P("This page was generated using the new HTML DSL with SwiftUI-like syntax.")
            
            Div {
                Span("Method: ")
                    .class("label")
                Text(method)
            }
            .class("info")
            
            Div {
                Span("Path: ")
                    .class("label")
                Text(path)
            }
            .class("info")
            
            Div {
                Span("Time: ")
                    .class("label")
                Text(Date().description)
            }
            .class("info")
            
            Div {
                Span("Process ID: ")
                    .class("label")
                Text("\(ProcessInfo.processInfo.processIdentifier)")
            }
            .class("info")
            
            H2("Features Demonstrated")
            
            Div {
                P("✓ Type-safe HTML generation")
                P("✓ SwiftUI-like declarative syntax")
                P("✓ Composable elements")
                P("✓ Modifier chaining")
                P("✓ Conditional rendering")
            }
            .padding(20)
            .background("#e8f4f8")
            .cornerRadius(8)
            
            P {
                Text("Learn more at ")
                A(href: "https://github.com/swiftlets/swiftlets", "GitHub")
            }
            .margin(20)
        }
        .class("container")
    }
}

// Output HTTP response
print("Status: 200")
print("Content-Type: text/html; charset=utf-8")
print("")
print(page.render())