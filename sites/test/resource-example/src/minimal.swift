import Foundation

@main
struct MinimalResourceTest {
    static func main() async throws {
        // Parse request from stdin
        let requestData = FileHandle.standardInput.readDataToEndOfFile()
        
        // For now, just echo back what we got
        let request = try JSONDecoder().decode(Request.self, from: requestData)
        
        var html = "<html><head><title>Resource Test</title></head><body>"
        html += "<h1>Resource Test</h1>"
        html += "<p>Path: \(request.path)</p>"
        html += "<p>Context provided: \(request.context != nil)</p>"
        
        if let context = request.context {
            html += "<p>Route path: \(context.routePath)</p>"
            html += "<p>Resource paths: \(context.resourcePaths.count) paths</p>"
            html += "<p>Storage path: \(context.storagePath)</p>"
            
            // Test resource reading
            let resourceContext = DefaultSwiftletContext(from: context)
            do {
                let configData = try resourceContext.resources.read(named: "config.json")
                html += "<p>Config found: \(configData.count) bytes</p>"
                
                // Test storage
                let testData = "Test \(Date())".data(using: .utf8)!
                try resourceContext.storage.write(testData, to: "test.txt")
                html += "<p>Storage write: success</p>"
                
                let readBack = try resourceContext.storage.read(from: "test.txt")
                html += "<p>Storage read: \(String(data: readBack, encoding: .utf8) ?? "failed")</p>"
            } catch {
                html += "<p>Error: \(error)</p>"
            }
        }
        
        html += "</body></html>"
        
        let response = Response(
            status: 200,
            headers: ["Content-Type": "text/html; charset=utf-8"],
            body: html
        )
        
        let responseData = try JSONEncoder().encode(response)
        print(responseData.base64EncodedString())
    }
}