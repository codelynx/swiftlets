import Foundation
import SwiftletsCore
import SwiftletsHTML

@main
struct RoutingTest {
    static func main() async throws {
        let request = try JSONDecoder().decode(Request.self, from: FileHandle.standardInput.readDataToEndOfFile())
        
        let html = Html {
            Head { Title("Routing Test") }
            Body {
                H1("Testing Route: \(request.path)")
                Pre {
                    Text("Method: \(request.method)\n")
                    Text("Path: \(request.path)\n")
                    Text("Query: \(String(describing: request.query))\n")
                }
            }
        }
        
        let response = Response(html: html.render())
        let jsonData = try JSONEncoder().encode(response)
        FileHandle.standardOutput.write(jsonData)
    }
}