import Foundation

public struct Response: Codable {
    public let status: Int
    public let headers: [String: String]
    public let body: String
    
    public init(status: Int = 200, headers: [String: String] = [:], body: String = "") {
        self.status = status
        var mergedHeaders = headers
        if !mergedHeaders.keys.contains("Content-Type") {
            mergedHeaders["Content-Type"] = "text/html; charset=utf-8"
        }
        self.headers = mergedHeaders
        self.body = body
    }
    
    public init(html: String) {
        self.init(status: 200, headers: ["Content-Type": "text/html; charset=utf-8"], body: html)
    }
    
    public init(text: String) {
        self.init(status: 200, headers: ["Content-Type": "text/plain; charset=utf-8"], body: text)
    }
    
    public init(json: String) {
        self.init(status: 200, headers: ["Content-Type": "application/json"], body: json)
    }
}