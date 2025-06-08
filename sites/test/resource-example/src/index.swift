import Foundation

@main
struct ResourceTestPage {
    static func main() async throws {
        // Parse request from stdin
        let requestData = FileHandle.standardInput.readDataToEndOfFile()
        let request = try JSONDecoder().decode(Request.self, from: requestData)
        
        // Create context from request
        let context: DefaultSwiftletContext
        if let contextData = request.context {
            context = DefaultSwiftletContext(from: contextData)
            
            // Try to read a resource
            do {
                let configData = try context.resources.read(named: "config.json")
                let configString = try configData.string()
                
                // Try storage
                let testData = "Test at \(Date())".data(using: .utf8)!
                try context.storage.write(testData, to: "test.txt")
                
                // Build response
                let html = Html {
                    Head {
                        Title("Resource Test Success")
                    }
                    Body {
                        H1("Resources Working!")
                        P("Route: \(context.routePath)")
                        P("Config: \(configString.prefix(100))...")
                        P("Storage: Wrote test.txt")
                    }
                }
                
                let response = Response(
                    status: 200,
                    headers: ["Content-Type": "text/html; charset=utf-8"],
                    body: html.render()
                )
                
                let responseData = try JSONEncoder().encode(response)
                print(responseData.base64EncodedString())
                
            } catch {
                sendError("Resource error: \(error)")
            }
        } else {
            sendError("No context provided")
        }
    }
    
    static func sendError(_ message: String) {
        let html = Html {
            Head {
                Title("Error")
            }
            Body {
                H1("Error")
                P(message)
            }
        }
        
        let response = Response(
            status: 500,
            headers: ["Content-Type": "text/html; charset=utf-8"],
            body: html.render()
        )
        
        if let responseData = try? JSONEncoder().encode(response) {
            print(responseData.base64EncodedString())
        }
    }
}