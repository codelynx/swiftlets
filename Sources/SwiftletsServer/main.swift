import Foundation
import NIO
import NIOHTTP1
import NIOFoundationCompat

// Simple HTTP handler that executes swiftlets
final class SwiftletHTTPHandler: ChannelInboundHandler {
    typealias InboundIn = HTTPServerRequestPart
    typealias OutboundOut = HTTPServerResponsePart
    
    private var accumulatedData = Data()
    private var requestHead: HTTPRequestHead?
    
    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        let reqPart = unwrapInboundIn(data)
        
        switch reqPart {
        case .head(let head):
            requestHead = head
            accumulatedData = Data()
            
        case .body(let buffer):
            var data = Data()
            buffer.withUnsafeReadableBytes { bytes in
                data.append(contentsOf: bytes)
            }
            accumulatedData.append(data)
            
        case .end:
            guard let head = requestHead else { return }
            
            // Extract path without query string
            let path = head.uri.split(separator: "?").first.map(String.init) ?? "/"
            
            // Route to swiftlet based on path
            let swiftletPath: String
            
            // For development, we'll use a simple routing based on current site
            // In production, this would read from site.yaml or routes config
            let currentSite = ProcessInfo.processInfo.environment["SWIFTLETS_SITE"] ?? "sites/core/hello"
            
            // Simple routing for POC
            // Remove leading slash and use as swiftlet name
            let cleanPath = path.hasPrefix("/") ? String(path.dropFirst()) : path
            
            // Handle empty path as index
            if cleanPath.isEmpty || cleanPath == "/" {
                swiftletPath = "index"
            } else {
                swiftletPath = cleanPath
            }
            
            // Execute swiftlet
            executeSwiftlet(path: swiftletPath, request: head, body: accumulatedData, context: context)
        }
    }
    
    private func executeSwiftlet(path: String, request: HTTPRequestHead, body: Data, context: ChannelHandlerContext) {
        // Detect platform and architecture
        let platform = "macos"  // For POC, hardcoded
        let arch = "arm64"      // For POC, hardcoded
        
        // Get current site from environment or default
        let currentSite = ProcessInfo.processInfo.environment["SWIFTLETS_SITE"] ?? "sites/core/hello"
        let siteName = URL(fileURLWithPath: currentSite).lastPathComponent
        
        let executablePath = "bin/\(platform)/\(arch)/\(siteName)/\(path)"
        
        // Check if executable exists
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: executablePath) {
            print("Swiftlet not found: \(executablePath)")
            sendErrorResponse(context: context, status: .notFound, message: "Swiftlet not found: \(path)")
            return
        }
        
        print("Executing swiftlet: \(executablePath)")
        
        // Prepare environment variables
        var environment = ProcessInfo.processInfo.environment
        environment["REQUEST_METHOD"] = request.method.rawValue
        environment["REQUEST_PATH"] = request.uri
        environment["REQUEST_VERSION"] = String(describing: request.version)
        
        // Convert headers to JSON
        var headers: [String: String] = [:]
        for (name, value) in request.headers {
            headers[name.lowercased()] = value
        }
        if let headersData = try? JSONSerialization.data(withJSONObject: headers),
           let headersJSON = String(data: headersData, encoding: .utf8) {
            environment["REQUEST_HEADERS"] = headersJSON
        }
        
        // Create process
        let process = Process()
        process.executableURL = URL(fileURLWithPath: executablePath)
        process.environment = environment
        
        // Setup pipes
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        let inputPipe = Pipe()
        
        process.standardOutput = outputPipe
        process.standardError = errorPipe
        process.standardInput = inputPipe
        
        // Create Request JSON
        var requestDict: [String: Any] = [
            "method": request.method.rawValue,
            "path": request.uri,
            "headers": headers,
            "queryParameters": [:] // TODO: Parse query parameters
        ]
        
        if !body.isEmpty {
            requestDict["body"] = body.base64EncodedString()
        } else {
            requestDict["body"] = NSNull()
        }
        
        // Write request JSON to stdin
        if let requestData = try? JSONSerialization.data(withJSONObject: requestDict),
           let requestJSON = String(data: requestData, encoding: .utf8) {
            print("Sending request JSON: \(requestJSON)")
            inputPipe.fileHandleForWriting.write(requestJSON.data(using: .utf8)!)
        }
        inputPipe.fileHandleForWriting.closeFile()
        
        // Run process
        do {
            try process.run()
            process.waitUntilExit()
            
            // Read output
            let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
            let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
            
            if !errorData.isEmpty {
                let errorString = String(data: errorData, encoding: .utf8) ?? "Unknown error"
                print("Swiftlet error: \(errorString)")
            }
            
            // Parse swiftlet output
            if let output = String(data: outputData, encoding: .utf8) {
                print("Swiftlet output: \(output.prefix(200))...")
                parseAndSendResponse(output: output, context: context)
            } else {
                sendErrorResponse(context: context, status: .internalServerError, message: "Invalid swiftlet output")
            }
            
        } catch {
            print("Failed to execute swiftlet: \(error)")
            sendErrorResponse(context: context, status: .internalServerError, message: "Failed to execute swiftlet")
        }
    }
    
    private func parseAndSendResponse(output: String, context: ChannelHandlerContext) {
        var status = HTTPResponseStatus.ok
        var headers = HTTPHeaders()
        var body = ""
        
        // Try to parse as JSON first
        if let data = output.data(using: .utf8),
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let statusCode = json["status"] as? Int,
           let responseHeaders = json["headers"] as? [String: String],
           let responseBody = json["body"] as? String {
            
            status = HTTPResponseStatus(statusCode: statusCode)
            for (name, value) in responseHeaders {
                headers.add(name: name, value: value)
            }
            body = responseBody
            
        } else {
            // Fall back to plain text parsing
            let parts = output.components(separatedBy: "\n\n")
            
            if parts.count >= 2 {
                // Parse headers
                let headerLines = parts[0].components(separatedBy: "\n")
                for line in headerLines {
                    if line.hasPrefix("Status:") {
                        let statusCode = line.replacingOccurrences(of: "Status:", with: "").trimmingCharacters(in: .whitespaces)
                        if let code = Int(statusCode) {
                            status = HTTPResponseStatus(statusCode: code)
                        }
                    } else if let colonIndex = line.firstIndex(of: ":") {
                        let name = String(line[..<colonIndex]).trimmingCharacters(in: .whitespaces)
                        let value = String(line[line.index(after: colonIndex)...]).trimmingCharacters(in: .whitespaces)
                        headers.add(name: name, value: value)
                    }
                }
                
                // Rest is body
                body = parts[1...].joined(separator: "\n\n")
            } else {
                // No headers, entire output is body
                body = output
                headers.add(name: "Content-Type", value: "text/html; charset=utf-8")
            }
        }
        
        // Send response
        let head = HTTPResponseHead(version: .http1_1, status: status, headers: headers)
        context.write(wrapOutboundOut(.head(head)), promise: nil)
        
        if !body.isEmpty {
            let buffer = context.channel.allocator.buffer(string: body)
            context.write(wrapOutboundOut(.body(.byteBuffer(buffer))), promise: nil)
        }
        
        context.writeAndFlush(wrapOutboundOut(.end(nil)), promise: nil)
    }
    
    private func sendErrorResponse(context: ChannelHandlerContext, status: HTTPResponseStatus, message: String) {
        var headers = HTTPHeaders()
        headers.add(name: "Content-Type", value: "text/plain; charset=utf-8")
        
        let head = HTTPResponseHead(version: .http1_1, status: status, headers: headers)
        context.write(wrapOutboundOut(.head(head)), promise: nil)
        
        let buffer = context.channel.allocator.buffer(string: message)
        context.write(wrapOutboundOut(.body(.byteBuffer(buffer))), promise: nil)
        
        context.writeAndFlush(wrapOutboundOut(.end(nil)), promise: nil)
    }
}

// Main server
let group = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
defer {
    try! group.syncShutdownGracefully()
}

let bootstrap = ServerBootstrap(group: group)
    .serverChannelOption(ChannelOptions.backlog, value: 256)
    .serverChannelOption(ChannelOptions.socketOption(.so_reuseaddr), value: 1)
    .childChannelInitializer { channel in
        channel.pipeline.configureHTTPServerPipeline().flatMap {
            channel.pipeline.addHandler(SwiftletHTTPHandler())
        }
    }
    .childChannelOption(ChannelOptions.socketOption(.so_reuseaddr), value: 1)
    .childChannelOption(ChannelOptions.maxMessagesPerRead, value: 16)
    .childChannelOption(ChannelOptions.recvAllocator, value: AdaptiveRecvByteBufferAllocator())

let host = "127.0.0.1"
let port = 8080

print("Starting Swiftlets server on \(host):\(port)")
print("Visit http://\(host):\(port)/hello to test")

let channel = try bootstrap.bind(host: host, port: port).wait()

// Wait for server to close
try channel.closeFuture.wait()