import Foundation
import NIO
import NIOHTTP1
import NIOFoundationCompat

// Simple logger for server messages
enum LogLevel {
    case debug, info, warning, error
}

// Platform and architecture detection
func detectPlatform() -> String {
    #if os(macOS)
    return "macos"
    #elseif os(Linux)
    return "linux"
    #else
    return "unknown"
    #endif
}

func detectArchitecture() -> String {
    #if arch(x86_64)
    return "x86_64"
    #elseif arch(arm64)
    return "arm64"
    #else
    return "unknown"
    #endif
}

func log(_ level: LogLevel, _ message: String) {
    let timestamp = ISO8601DateFormatter().string(from: Date())
    let prefix: String
    
    switch level {
    case .debug:
        #if DEBUG
        prefix = "[DEBUG]"
        print("\(timestamp) \(prefix) \(message)")
        #endif
        return
    case .info:
        prefix = "[INFO]"
    case .warning:
        prefix = "[WARN]"
    case .error:
        prefix = "[ERROR]"
    }
    
    print("\(timestamp) \(prefix) \(message)")
}

// Simple HTTP handler that executes swiftlets
// Marked as @unchecked Sendable because NIO ensures this handler is only used on a single event loop
final class SwiftletHTTPHandler: ChannelInboundHandler, @unchecked Sendable {
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
            
            // Handle webbin routing
            handleWebbinRequest(path: path, request: head, body: accumulatedData, context: context)
        }
    }
    
    private func handleWebbinRequest(path: String, request: HTTPRequestHead, body: Data, context: ChannelHandlerContext) {
        // Normalize path: remove leading slash, handle empty path as index
        let cleanPath: String
        if path == "/" || path.isEmpty {
            cleanPath = "index"
        } else {
            cleanPath = path.hasPrefix("/") ? String(path.dropFirst()) : path
        }
        
        log(.debug, "Handling request for path: \(path) → \(cleanPath)")
        
        // 1. Check for static file in web/ directory first
        let staticPath = "web/\(cleanPath)"
        let fileManager = FileManager.default
        
        var isDirectory: ObjCBool = false
        if fileManager.fileExists(atPath: staticPath, isDirectory: &isDirectory) && !isDirectory.boolValue {
            log(.debug, "Serving static file: \(staticPath)")
            serveStaticFile(path: staticPath, context: context)
            return
        }
        
        // 2. Look for .webbin file for dynamic route
        let webbinPath = "web/\(cleanPath).webbin"
        if fileManager.fileExists(atPath: webbinPath) {
            log(.debug, "Found webbin file: \(webbinPath)")
            
            guard let executablePath = readWebbinFile(webbinPath) else {
                log(.error, "Failed to read webbin file: \(webbinPath)")
                sendErrorResponse(context: context, status: .internalServerError, message: "Invalid webbin file")
                return
            }
            
            // Execute the dynamic route
            executeSwiftlet(executablePath: executablePath, originalPath: path, request: request, body: body, context: context)
            return
        }
        
        // 3. TODO: Check for pattern-based routes (e.g., [slug])
        // For now, just return 404
        log(.warning, "No route found for path: \(path)")
        sendErrorResponse(context: context, status: .notFound, message: "Not Found")
    }
    
    private func readWebbinFile(_ path: String) -> String? {
        guard let content = try? String(contentsOfFile: path, encoding: .utf8) else {
            return nil
        }
        return content.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func serveStaticFile(path: String, context: ChannelHandlerContext) {
        guard let data = FileManager.default.contents(atPath: path) else {
            sendErrorResponse(context: context, status: .notFound, message: "File not found")
            return
        }
        
        // Detect MIME type based on file extension
        let mimeType = getMimeType(for: path)
        
        var headers = HTTPHeaders()
        headers.add(name: "Content-Type", value: mimeType)
        headers.add(name: "Content-Length", value: String(data.count))
        
        let head = HTTPResponseHead(version: .http1_1, status: .ok, headers: headers)
        context.write(wrapOutboundOut(.head(head)), promise: nil)
        
        let buffer = context.channel.allocator.buffer(bytes: data)
        context.write(wrapOutboundOut(.body(.byteBuffer(buffer))), promise: nil)
        context.writeAndFlush(wrapOutboundOut(.end(nil)), promise: nil)
        
        log(.info, "Served static file: \(path) (\(data.count) bytes)")
    }
    
    private func getMimeType(for path: String) -> String {
        let ext = URL(fileURLWithPath: path).pathExtension.lowercased()
        switch ext {
        case "html", "htm": return "text/html; charset=utf-8"
        case "css": return "text/css; charset=utf-8"
        case "js": return "application/javascript; charset=utf-8"
        case "json": return "application/json; charset=utf-8"
        case "png": return "image/png"
        case "jpg", "jpeg": return "image/jpeg"
        case "gif": return "image/gif"
        case "svg": return "image/svg+xml"
        case "pdf": return "application/pdf"
        case "txt": return "text/plain; charset=utf-8"
        case "xml": return "application/xml; charset=utf-8"
        default: return "application/octet-stream"
        }
    }
    
    private func executeSwiftlet(executablePath: String, originalPath: String, request: HTTPRequestHead, body: Data, context: ChannelHandlerContext) {
        // Check if executable exists
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: executablePath) && fileManager.isExecutableFile(atPath: executablePath) else {
            log(.error, "Executable not found or not executable: \(executablePath)")
            sendErrorResponse(context: context, status: .internalServerError, message: "Executable not found")
            return
        }
        
        log(.debug, "Executing swiftlet: \(executablePath)")
        
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
            log(.debug, "Sending request JSON: \(requestJSON)")
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
                log(.error, "Swiftlet stderr: \(errorString)")
            }
            
            // Parse swiftlet output
            if let output = String(data: outputData, encoding: .utf8) {
                log(.debug, "Swiftlet output: \(output.prefix(200))...")
                parseAndSendResponse(output: output, context: context)
            } else {
                sendErrorResponse(context: context, status: .internalServerError, message: "Invalid swiftlet output")
            }
            
        } catch {
            log(.error, "Failed to execute swiftlet: \(error)")
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

log(.info, "Starting Swiftlets server on \(host):\(port)")
log(.info, "Visit http://\(host):\(port)/ to test")

let channel = try bootstrap.bind(host: host, port: port).wait()

// Wait for server to close
try channel.closeFuture.wait()