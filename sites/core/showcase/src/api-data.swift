import Foundation

// API example - returns JSON data

struct APIResponse: Codable {
    let status: String
    let timestamp: Date
    let data: DataInfo
    let meta: MetaInfo
}

struct DataInfo: Codable {
    let message: String
    let items: [Item]
    let count: Int
}

struct Item: Codable {
    let id: Int
    let name: String
    let value: Double
}

struct MetaInfo: Codable {
    let version: String
    let processId: Int
    let method: String
    let path: String
}

// Get request info from environment
let method = ProcessInfo.processInfo.environment["REQUEST_METHOD"] ?? "GET"
let path = ProcessInfo.processInfo.environment["REQUEST_PATH"] ?? "/api/data"

// Create sample data
let items = [
    Item(id: 1, name: "Alpha", value: 42.5),
    Item(id: 2, name: "Beta", value: 87.3),
    Item(id: 3, name: "Gamma", value: 15.9),
    Item(id: 4, name: "Delta", value: 63.7)
]

let response = APIResponse(
    status: "success",
    timestamp: Date(),
    data: DataInfo(
        message: "Sample data from Swiftlet API",
        items: items,
        count: items.count
    ),
    meta: MetaInfo(
        version: "1.0.0",
        processId: Int(ProcessInfo.processInfo.processIdentifier),
        method: method,
        path: path
    )
)

// Encode to JSON
let encoder = JSONEncoder()
encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
encoder.dateEncodingStrategy = .iso8601

do {
    let jsonData = try encoder.encode(response)
    let jsonString = String(data: jsonData, encoding: .utf8) ?? "{}"
    
    // Output HTTP response
    print("Status: 200")
    print("Content-Type: application/json")
    print("X-API-Version: 1.0.0")
    print("")
    print(jsonString)
} catch {
    // Error response
    print("Status: 500")
    print("Content-Type: application/json")
    print("")
    print(#"{"error": "Failed to encode response"}"#)
}