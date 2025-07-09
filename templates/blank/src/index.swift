import Foundation

@main
struct HomePage {
    static func main() async throws {
        // Read request from stdin
        let request = try JSONDecoder().decode(Request.self, 
            from: FileHandle.standardInput.readDataToEndOfFile())
        
        // Build HTML response
        let html = Html {
            Head {
                Title("Welcome to Swiftlets")
                Meta(charset: "UTF-8")
                Meta(name: "viewport", content: "width=device-width, initial-scale=1.0")
            }
            Body {
                Container(maxWidth: .large, padding: 20) {
                    VStack(spacing: 20) {
                        H1("Welcome to Swiftlets!")
                        P("Edit src/index.swift to customize this page.")
                        
                        HR()
                        
                        P {
                            Text("Powered by ")
                            Link(href: "https://github.com/codelynx/swiftlets", "Swiftlets")
                        }
                        .style("color", "#666")
                        .style("font-size", "0.9em")
                    }
                }
            }
        }
        
        // Send response to stdout
        let response = Response(
            status: 200,
            headers: ["Content-Type": "text/html"],
            body: html.render()
        )
        
        let output = try JSONEncoder().encode(response)
        print(String(data: output, encoding: .utf8)!)
    }
}