// SwiftletsLambdaAdapter.swift
// Adapter to run Swiftlets as AWS Lambda functions

import AWSLambdaRuntime
import AWSLambdaEvents
import Foundation

/// Lambda handler that adapts Swiftlets executables to Lambda runtime
struct SwiftletsLambdaHandler: SimpleLambdaHandler {
    typealias Event = APIGatewayV2Request
    typealias Output = APIGatewayV2Response
    
    /// Path to the Swiftlets executable
    let executablePath: String
    
    /// Environment variables to pass to the swiftlet
    let environment: [String: String]
    
    init(executablePath: String, environment: [String: String] = [:]) {
        self.executablePath = executablePath
        self.environment = environment
    }
    
    func handle(_ event: Event, context: LambdaContext) async throws -> Output {
        // Convert API Gateway event to Swiftlets request format
        let swiftletRequest = convertToSwiftletRequest(event)
        
        // Create process to run the swiftlet
        let process = Process()
        process.executableURL = URL(fileURLWithPath: executablePath)
        process.environment = ProcessInfo.processInfo.environment.merging(environment) { _, new in new }
        
        // Set up pipes for communication
        let inputPipe = Pipe()
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        
        process.standardInput = inputPipe
        process.standardOutput = outputPipe
        process.standardError = errorPipe
        
        // Encode request as JSON and write to stdin
        let encoder = JSONEncoder()
        let requestData = try encoder.encode(swiftletRequest)
        
        // Start the process
        try process.run()
        
        // Write request data
        inputPipe.fileHandleForWriting.write(requestData)
        try inputPipe.fileHandleForWriting.close()
        
        // Read response
        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        
        // Wait for process to complete
        process.waitUntilExit()
        
        // Log any errors
        if !errorData.isEmpty {
            let errorString = String(data: errorData, encoding: .utf8) ?? "Unknown error"
            context.logger.error("Swiftlet error: \(errorString)")
        }
        
        // Parse swiftlet response
        let decoder = JSONDecoder()
        let swiftletResponse = try decoder.decode(SwiftletResponse.self, from: outputData)
        
        // Convert to API Gateway response
        return APIGatewayV2Response(
            statusCode: HTTPResponseStatus(code: swiftletResponse.statusCode),
            headers: swiftletResponse.headers,
            body: swiftletResponse.body,
            isBase64Encoded: false
        )
    }
    
    private func convertToSwiftletRequest(_ event: APIGatewayV2Request) -> SwiftletRequest {
        SwiftletRequest(
            method: event.context.http.method.rawValue,
            path: event.context.http.path,
            queryParameters: event.queryStringParameters ?? [:],
            headers: event.headers,
            body: event.body,
            cookies: extractCookies(from: event.headers)
        )
    }
    
    private func extractCookies(from headers: [String: String]) -> [String: String] {
        guard let cookieHeader = headers["cookie"] ?? headers["Cookie"] else {
            return [:]
        }
        
        var cookies: [String: String] = [:]
        let pairs = cookieHeader.split(separator: ";")
        
        for pair in pairs {
            let trimmed = pair.trimmingCharacters(in: .whitespaces)
            if let equalIndex = trimmed.firstIndex(of: "=") {
                let name = String(trimmed[..<equalIndex])
                let value = String(trimmed[trimmed.index(after: equalIndex)...])
                cookies[name] = value
            }
        }
        
        return cookies
    }
}

// MARK: - Data Models

struct SwiftletRequest: Codable {
    let method: String
    let path: String
    let queryParameters: [String: String]
    let headers: [String: String]
    let body: String?
    let cookies: [String: String]
}

struct SwiftletResponse: Codable {
    let statusCode: Int
    let headers: [String: String]
    let body: String
}

// MARK: - Lambda Router

/// Routes Lambda requests to appropriate Swiftlets based on path
struct SwiftletsRouter: SimpleLambdaHandler {
    typealias Event = APIGatewayV2Request
    typealias Output = APIGatewayV2Response
    
    /// Base directory containing swiftlet executables
    let baseDirectory: String
    
    /// Platform-specific binary path
    let binaryPath: String
    
    init(baseDirectory: String = "/var/task") {
        self.baseDirectory = baseDirectory
        
        // Lambda runs on Amazon Linux (x86_64 or arm64)
        #if arch(arm64)
        self.binaryPath = "bin/linux/aarch64"
        #else
        self.binaryPath = "bin/linux/x86_64"
        #endif
    }
    
    func handle(_ event: Event, context: LambdaContext) async throws -> Output {
        // Map request path to executable
        let executablePath = resolveExecutable(for: event.context.http.path)
        
        // Check if executable exists
        guard FileManager.default.fileExists(atPath: executablePath) else {
            return APIGatewayV2Response(
                statusCode: .notFound,
                headers: ["Content-Type": "text/html"],
                body: "<h1>404 Not Found</h1>"
            )
        }
        
        // Create handler for this specific swiftlet
        let handler = SwiftletsLambdaHandler(
            executablePath: executablePath,
            environment: [
                "SWIFTLETS_ENV": "lambda",
                "AWS_LAMBDA_REQUEST_ID": context.requestID,
                "AWS_LAMBDA_FUNCTION_NAME": context.invokedFunctionARN
            ]
        )
        
        // Execute the swiftlet
        return try await handler.handle(event, context: context)
    }
    
    private func resolveExecutable(for path: String) -> String {
        // Remove leading slash and query parameters
        let cleanPath = path
            .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            .components(separatedBy: "?").first ?? ""
        
        // Map to executable name
        let executableName = cleanPath.isEmpty ? "index" : cleanPath.replacingOccurrences(of: "/", with: "-")
        
        return "\(baseDirectory)/\(binaryPath)/\(executableName)"
    }
}

// MARK: - Main Entry Point

@main
struct SwiftletsLambda {
    static func main() async throws {
        // Initialize the router
        let router = SwiftletsRouter()
        
        // Run the Lambda runtime
        let runtime = LambdaRuntime.init(handler: router)
        try await runtime.run()
    }
}