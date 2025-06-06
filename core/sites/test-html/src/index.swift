import Foundation
import SwiftletsCore
import SwiftletsHTML

@main
struct HTMLTest {
    static func main() async throws {
        let request = try JSONDecoder().decode(Request.self, from: FileHandle.standardInput.readDataToEndOfFile())
        
        let html = Html {
            Head { 
                Title("HTML DSL Test") 
                Meta(name: "charset", content: "utf-8")
            }
            Body {
                H1("HTML DSL Test Suite")
                
                // Test escaping
                Section {
                    H2("Escaping Test")
                    P("Testing < > & \" ' characters")
                    Pre {
                        Code("<script>alert('xss')</script>")
                    }
                }
                
                // Test nesting
                Section {
                    H2("Deep Nesting Test")
                    Div {
                        Div {
                            Div {
                                P("Deeply nested content")
                            }
                        }
                    }
                }
                
                // Test attributes
                Section {
                    H2("Attributes Test")
                    Div()
                        .id("test-id")
                        .classes("class1", "class2", "class3")
                        .attribute("data-test", "value")
                        .style("color", "red")
                        .style("background", "blue")
                }
            }
        }
        
        let response = Response(html: html.render())
        let jsonData = try JSONEncoder().encode(response)
        FileHandle.standardOutput.write(jsonData)
    }
}