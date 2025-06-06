import Foundation
import SwiftletsCore
import SwiftletsHTML

@main
struct LayoutShowcase {
    static func main() async throws {
        // Read input from stdin
        guard let input = readLine(strippingNewline: false) else {
            fatalError("Error: No input received")
        }
        
        let _ = try JSONDecoder().decode(Request.self, from: Data(input.utf8))
        
        let html = Html {
            Head {
                Title("Layout Components Showcase")
                Meta(charset: "UTF-8")
                Meta(name: "viewport", content: "width=device-width, initial-scale=1.0")
                Style("""
                    body {
                        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                        line-height: 1.6;
                        margin: 0;
                        background-color: #f5f5f5;
                    }
                    
                    .demo-section {
                        background: white;
                        border-radius: 8px;
                        padding: 24px;
                        margin-bottom: 24px;
                        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                    }
                    
                    .demo-title {
                        font-size: 1.5rem;
                        font-weight: 600;
                        margin-bottom: 16px;
                        color: #333;
                    }
                    
                    .demo-box {
                        background: #e3f2fd;
                        padding: 16px;
                        border-radius: 4px;
                        text-align: center;
                        min-height: 60px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                    }
                    
                    .demo-tall {
                        min-height: 120px;
                    }
                    
                    .demo-short {
                        min-height: 40px;
                    }
                    
                    .demo-grid-item {
                        background: #fff3e0;
                        padding: 12px;
                        border-radius: 4px;
                        text-align: center;
                    }
                    
                    .demo-zstack-bg {
                        background: #ffebee;
                        width: 200px;
                        height: 200px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        border-radius: 8px;
                    }
                    
                    .demo-zstack-fg {
                        background: #e8f5e9;
                        padding: 16px;
                        border-radius: 4px;
                        position: absolute;
                    }
                """)
            }
            
            Body {
                Container(maxWidth: .xl, padding: 24) {
                    VStack(spacing: 32) {
                        // Header
                        H1("Layout Components Showcase")
                            .style("text-align", "center")
                            .style("color", "#333")
                        
                        // HStack Demo
                        Div {
                            H2("HStack - Horizontal Layout")
                                .class("demo-title")
                            
                            P("Default alignment (center):")
                            HStack(spacing: 16) {
                                Div { Text("Item 1") }.class("demo-box")
                                Div { Text("Item 2") }.class("demo-box demo-tall")
                                Div { Text("Item 3") }.class("demo-box demo-short")
                            }
                            
                            P("Top alignment:")
                            HStack(alignment: .top, spacing: 16) {
                                Div { Text("Item 1") }.class("demo-box")
                                Div { Text("Item 2") }.class("demo-box demo-tall")
                                Div { Text("Item 3") }.class("demo-box demo-short")
                            }
                            
                            P("With Spacer:")
                            HStack(spacing: 16) {
                                Div { Text("Left") }.class("demo-box")
                                Spacer()
                                Div { Text("Right") }.class("demo-box")
                            }
                        }
                        .class("demo-section")
                        
                        // VStack Demo
                        Div {
                            H2("VStack - Vertical Layout")
                                .class("demo-title")
                            
                            P("Default alignment (stretch):")
                            VStack(spacing: 12) {
                                Div { Text("Row 1") }.class("demo-box")
                                Div { Text("Row 2") }.class("demo-box")
                                Div { Text("Row 3") }.class("demo-box")
                            }
                            
                            P("Center alignment:")
                            VStack(alignment: .center, spacing: 12) {
                                Div { Text("Short") }.class("demo-box").style("width", "100px")
                                Div { Text("Medium length") }.class("demo-box").style("width", "200px")
                                Div { Text("This is a longer item") }.class("demo-box").style("width", "300px")
                            }
                        }
                        .class("demo-section")
                        
                        // Grid Demo
                        Div {
                            H2("Grid Layout")
                                .class("demo-title")
                            
                            P("3-column grid:")
                            Grid(columns: .count(3), spacing: 16) {
                                ForEach(1...6) { i in
                                    Div { Text("Cell \(i)") }.class("demo-grid-item")
                                }
                            }
                            
                            P("Custom column sizes:")
                            Grid(columns: .custom("100px 1fr 100px"), spacing: 16) {
                                Div { Text("Fixed") }.class("demo-grid-item")
                                Div { Text("Flexible") }.class("demo-grid-item")
                                Div { Text("Fixed") }.class("demo-grid-item")
                            }
                        }
                        .class("demo-section")
                        
                        // ZStack Demo
                        Div {
                            H2("ZStack - Layered Layout")
                                .class("demo-title")
                            
                            P("Center aligned (default):")
                            ZStack {
                                Div { Text("Background") }.class("demo-zstack-bg")
                                Div { Text("Foreground") }.class("demo-zstack-fg")
                            }
                            .style("height", "250px")
                            
                            P("Top-left aligned:")
                            ZStack(alignment: .topLeading) {
                                Div { Text("Background") }.class("demo-zstack-bg")
                                Div { Text("Top Left") }.class("demo-zstack-fg")
                            }
                            .style("height", "250px")
                        }
                        .class("demo-section")
                        
                        // Container Demo
                        Div {
                            H2("Container - Width Constraints")
                                .class("demo-title")
                            
                            P("Small container:")
                            Container(maxWidth: .small, padding: 16) {
                                Div { Text("This content is constrained to 640px max width") }
                                    .class("demo-box")
                            }
                            
                            P("Large container with padding:")
                            Container(maxWidth: .large, padding: 24) {
                                Div { Text("This content is constrained to 1024px max width with 24px padding") }
                                    .class("demo-box")
                            }
                        }
                        .class("demo-section")
                        
                        // Complex Layout Demo
                        Div {
                            H2("Complex Layout Example")
                                .class("demo-title")
                            
                            Container(maxWidth: .large) {
                                VStack(spacing: 24) {
                                    // Header
                                    HStack {
                                        H3("Dashboard")
                                        Spacer()
                                        HStack(spacing: 12) {
                                            Button("Settings")
                                            Button("Profile")
                                        }
                                    }
                                    .style("padding", "16px")
                                    .style("background", "#f0f0f0")
                                    .style("border-radius", "8px")
                                    
                                    // Main content
                                    HStack(alignment: .top, spacing: 24) {
                                        // Sidebar
                                        VStack(alignment: .stretch, spacing: 8) {
                                            Button("Home").style("width", "100%")
                                            Button("Analytics").style("width", "100%")
                                            Button("Reports").style("width", "100%")
                                            Spacer(minLength: 20)
                                            Button("Help").style("width", "100%")
                                        }
                                        .style("min-width", "200px")
                                        .style("padding", "16px")
                                        .style("background", "#fafafa")
                                        .style("border-radius", "8px")
                                        
                                        // Main area
                                        VStack(spacing: 16) {
                                            H4("Recent Activity")
                                            
                                            Grid(columns: .count(2), spacing: 16) {
                                                ForEach(1...4) { i in
                                                    Div {
                                                        H5("Card \(i)")
                                                        P("Some content for card \(i)")
                                                    }
                                                    .style("padding", "16px")
                                                    .style("background", "white")
                                                    .style("border", "1px solid #e0e0e0")
                                                    .style("border-radius", "4px")
                                                }
                                            }
                                        }
                                        .style("flex", "1")
                                    }
                                }
                            }
                        }
                        .class("demo-section")
                    }
                }
            }
        }
        
        let response = Response(
            status: 200,
            headers: ["Content-Type": "text/html"],
            body: html.render()
        )
        
        let output = try JSONEncoder().encode(response)
        print(String(data: output, encoding: .utf8)!)
    }
}

