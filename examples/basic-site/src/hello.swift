import Foundation

@main
struct HelloPage {
    static func main() async throws {
        let request = try JSONDecoder().decode(Request.self, from: FileHandle.standardInput.readDataToEndOfFile())
        
        let html = Html {
            Head {
                Title("Hello from Swiftlets")
                LinkElement(rel: "stylesheet", href: "/style.css")
            }
            Body {
                Container(maxWidth: .large, padding: 20) {
                    VStack(spacing: 20) {
                        H1("Hello, World!")
                        P("This page is generated dynamically by a Swift executable via webbin routing.")
                        
                        P {
                            Link(href: "/", "← Back to home")
                        }
                        
                        P("Request method: \(request.method)")
                            .style("font-family", "monospace")
                            .style("background", "#f0f0f0")
                            .style("padding", "10px")
                            .style("border-radius", "4px")
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