import Foundation

@main
struct IndexPage {
    static func main() async throws {
        let request = try JSONDecoder().decode(Request.self, from: FileHandle.standardInput.readDataToEndOfFile())
        
        let html = Html {
            Head {
                Title("Swiftlets Home")
                LinkElement(rel: "stylesheet", href: "/style.css")
            }
            Body {
                Container(maxWidth: .large, padding: 20) {
                    VStack(spacing: 20) {
                        H1("Welcome to Swiftlets!")
                        P("This is the new webbin routing system in action.")
                        
                        H2("Try these routes:")
                        UL {
                            LI {
                                Link(href: "/hello", "Hello page (dynamic)")
                            }
                            LI {
                                Link(href: "/style.css", "Stylesheet (static)")
                            }
                            LI {
                                Link(href: "/api/config.json", "Config API (static)")
                            }
                            LI {
                                Link(href: "/api/users.json", "Users API (dynamic)")
                            }
                        }
                        
                        HR()
                        
                        P {
                            Text("Built with ")
                            Code("SwiftletsHTML")
                            Text(" DSL")
                        }
                        .style("color", "#666")
                        .style("font-size", "0.9em")
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