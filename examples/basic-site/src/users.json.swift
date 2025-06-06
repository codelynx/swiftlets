import Foundation

struct User: Codable {
    let id: Int
    let name: String
    let email: String
}

@main
struct UsersAPI {
    static func main() async throws {
        let request = try JSONDecoder().decode(Request.self, from: FileHandle.standardInput.readDataToEndOfFile())
        
        // In a real app, this would query a database
        let users = [
            User(id: 1, name: "Alice", email: "alice@example.com"),
            User(id: 2, name: "Bob", email: "bob@example.com"),
            User(id: 3, name: "Charlie", email: "charlie@example.com"),
            User(id: 4, name: "Diana", email: "diana@example.com"),
            User(id: 5, name: "Eve", email: "eve@example.com")
        ]
        
        let jsonData = try JSONEncoder().encode(users)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        
        let response = Response(
            status: 200,
            headers: ["Content-Type": "application/json"],
            body: jsonString
        )
        
        let output = try JSONEncoder().encode(response)
        print(String(data: output, encoding: .utf8)!)
    }
}