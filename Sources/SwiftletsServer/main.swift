import ArgumentParser
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

// Configuration
struct ServerConfig {
    let siteRoot: String
    let host: String
    let port: Int
    let debug: Bool
    
    // Computed properties
    var webRoot: String {
        "\(siteRoot)/web"
    }
    
    var binRoot: String {
        "\(siteRoot)/bin"
    }
    
    static func resolve(siteRoot: String, cliHost: String?, cliPort: Int?, debug: Bool) -> ServerConfig {
        // Host: CLI argument > environment variable > default
        let host = cliHost 
            ?? ProcessInfo.processInfo.environment["SWIFTLETS_HOST"] 
            ?? "127.0.0.1"
            
        // Port: CLI argument > environment variable > default
        let port = cliPort 
            ?? Int(ProcessInfo.processInfo.environment["SWIFTLETS_PORT"] ?? "") 
            ?? 8080
        
        return ServerConfig(
            siteRoot: siteRoot,
            host: host,
            port: port,
            debug: debug
        )
    }
}

// Global debug flag - using nonisolated(unsafe) since it's only set once at startup
nonisolated(unsafe) var globalDebugEnabled = false

func log(_ level: LogLevel, _ message: String) {
    let timestamp = ISO8601DateFormatter().string(from: Date())
    let prefix: String
    
    switch level {
    case .debug:
        if !globalDebugEnabled {
            return
        }
        prefix = "[DEBUG]"
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
    
    private let config: ServerConfig
    private var accumulatedData = Data()
    private var requestHead: HTTPRequestHead?
    
    init(config: ServerConfig) {
        self.config = config
    }
    
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
        
        // 1. Check for static file in web root directory first
        let staticPath = "\(config.webRoot)/\(cleanPath)"
        let fileManager = FileManager.default
        
        var isDirectory: ObjCBool = false
        if fileManager.fileExists(atPath: staticPath, isDirectory: &isDirectory) && !isDirectory.boolValue {
            log(.debug, "Serving static file: \(staticPath)")
            serveStaticFile(path: staticPath, context: context)
            return
        }
        
        // 2. Look for .webbin file for dynamic route
        let webbinPath = "\(config.webRoot)/\(cleanPath).webbin"
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
        
        // 2b. If path ends with / or no .webbin found, try index
        if path.hasSuffix("/") || (!fileManager.fileExists(atPath: webbinPath)) {
            let indexPath = cleanPath.hasSuffix("/") ? "\(cleanPath)index" : "\(cleanPath)/index"
            let indexWebbinPath = "\(config.webRoot)/\(indexPath).webbin"
            
            if fileManager.fileExists(atPath: indexWebbinPath) {
                log(.debug, "Found index webbin file: \(indexWebbinPath)")
                
                guard let executablePath = readWebbinFile(indexWebbinPath) else {
                    log(.error, "Failed to read webbin file: \(indexWebbinPath)")
                    sendErrorResponse(context: context, status: .internalServerError, message: "Invalid webbin file")
                    return
                }
                
                // Execute the dynamic route
                executeSwiftlet(executablePath: executablePath, originalPath: path, request: request, body: body, context: context)
                return
            }
        }
        
        // 3. TODO: Check for pattern-based routes (e.g., [slug])
        // For now, just return 404
        log(.warning, "No route found for path: \(path)")
        sendErrorResponse(context: context, status: .notFound, message: "Not Found")
    }
    
    private func readWebbinFile(_ webbinPath: String) -> String? {
        // Read MD5 hash from webbin file (for future use)
        guard let md5Hash = try? String(contentsOfFile: webbinPath, encoding: .utf8) else {
            return nil
        }
        let hash = md5Hash.trimmingCharacters(in: .whitespacesAndNewlines)
        log(.debug, "Webbin file contains MD5: \(hash)")
        
        // Derive executable path from webbin path
        // SECURITY: Executables are in bin/ directory OUTSIDE web root
        // sites/examples/swiftlets-site/web/hello.webbin -> sites/examples/swiftlets-site/bin/hello
        // sites/examples/swiftlets-site/web/showcase/index.webbin -> sites/examples/swiftlets-site/bin/showcase/index
        
        let webbinURL = URL(fileURLWithPath: webbinPath)
        let filename = webbinURL.lastPathComponent.replacingOccurrences(of: ".webbin", with: "")
        
        // Get relative path from web root
        let webRootURL = URL(fileURLWithPath: config.webRoot)
        let webbinDirURL = webbinURL.deletingLastPathComponent()
        let relativePath: String
        if webbinDirURL.path == webRootURL.path {
            relativePath = ""
        } else {
            // Remove web root path and any leading slashes
            relativePath = webbinDirURL.path
                .replacingOccurrences(of: webRootURL.path + "/", with: "")
                .replacingOccurrences(of: webRootURL.path, with: "")
                .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        }
        
        let executablePath: String
        if relativePath.isEmpty {
            executablePath = "\(config.siteRoot)/bin/\(filename)"
        } else {
            executablePath = "\(config.siteRoot)/bin/\(relativePath)/\(filename)"
        }
        
        log(.debug, "Derived executable path: \(executablePath)")
        return executablePath
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
        
        // Build context information
        let routePath = originalPath.replacingOccurrences(of: ".webbin", with: "")
        let contextData = buildSwiftletContext(routePath: routePath)
        
        // Create var directory
        let varPath = "\(config.siteRoot)/var\(routePath)"
        do {
            try fileManager.createDirectory(atPath: varPath, withIntermediateDirectories: true, attributes: nil)
            log(.debug, "Created/verified var directory: \(varPath)")
        } catch {
            log(.error, "Failed to create var directory: \(error)")
        }
        
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
        process.currentDirectoryURL = URL(fileURLWithPath: varPath)
        
        // Setup pipes
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        let inputPipe = Pipe()
        
        process.standardOutput = outputPipe
        process.standardError = errorPipe
        process.standardInput = inputPipe
        
        // Create Request JSON with context
        var requestDict: [String: Any] = [
            "method": request.method.rawValue,
            "url": request.uri,
            "headers": headers,
            "context": [
                "routePath": contextData.routePath,
                "resourcePaths": contextData.resourcePaths,
                "storagePath": contextData.storagePath
            ]
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
        
        // First, try to decode as Base64-encoded JSON (new format)
        let trimmedOutput = output.trimmingCharacters(in: .whitespacesAndNewlines)
        if let base64Data = Data(base64Encoded: trimmedOutput),
           let json = try? JSONSerialization.jsonObject(with: base64Data) as? [String: Any],
           let statusCode = json["status"] as? Int,
           let responseHeaders = json["headers"] as? [String: String],
           let responseBody = json["body"] as? String {
            
            status = HTTPResponseStatus(statusCode: statusCode)
            for (name, value) in responseHeaders {
                headers.add(name: name, value: value)
            }
            body = responseBody
            
        }
        // Try to parse as plain JSON (old format)
        else if let data = output.data(using: .utf8),
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
    
    private func buildSwiftletContext(routePath: String) -> (routePath: String, resourcePaths: [String], storagePath: String) {
        // Build resource paths with hierarchical lookup
        var resourcePaths: [String] = []
        
        // Start with the most specific path
        let components = routePath.split(separator: "/").map(String.init)
        
        // Add paths from most specific to least specific
        // For /blog/tutorial, we want:
        // 1. src/blog/tutorial/.res/
        // 2. src/blog/.res/
        // 3. src/.res/
        
        for i in (0...components.count).reversed() {
            let path = components.prefix(i).joined(separator: "/")
            let resPath = "\(config.siteRoot)/src\(path.isEmpty ? "" : "/")\(path)/.res/"
            resourcePaths.append(resPath)
        }
        
        // Storage path is relative (working directory will be changed)
        let storagePath = "."
        
        return (routePath: routePath, resourcePaths: resourcePaths, storagePath: storagePath)
    }
}

// Main command
@main
struct SwiftletsServer: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "swiftlets-server",
        abstract: "Swiftlets web server with file-based routing",
        version: "1.0.0"
    )
    
    @Argument(help: "Site root directory containing web/ and bin/ subdirectories")
    var siteRoot: String?
    
    @Option(name: [.short, .customLong("port")], help: "Port to listen on")
    var port: Int?
    
    @Option(name: [.short, .customLong("host")], help: "Host address to bind to")
    var host: String?
    
    @Flag(name: .long, help: "Enable debug logging")
    var debug: Bool = false
    
    func run() throws {
        // Enable debug logging if requested
        globalDebugEnabled = debug
        
        // Determine site root
        let sitePath = siteRoot ?? FileManager.default.currentDirectoryPath
        
        // Create configuration
        let config = ServerConfig.resolve(
            siteRoot: sitePath,
            cliHost: host,
            cliPort: port,
            debug: debug
        )
        
        // Log configuration
        log(.info, "Server Configuration:")
        log(.info, "  Site Root: \(config.siteRoot)")
        log(.info, "  Web Root: \(config.webRoot)")
        log(.info, "  Host: \(config.host)")
        log(.info, "  Port: \(config.port)")
        log(.info, "  Platform: \(detectPlatform())/\(detectArchitecture())")
        
        // Check if web root exists
        let fileManager = FileManager.default
        var isDirectory: ObjCBool = false
        if !fileManager.fileExists(atPath: config.webRoot, isDirectory: &isDirectory) || !isDirectory.boolValue {
            log(.warning, "Web root directory not found: \(config.webRoot)")
            log(.info, "Creating web root directory...")
            try? fileManager.createDirectory(atPath: config.webRoot, withIntermediateDirectories: true)
        }
        
        
        // Start server
        let group = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
        defer {
            try! group.syncShutdownGracefully()
        }
        
        let bootstrap = ServerBootstrap(group: group)
            .serverChannelOption(ChannelOptions.backlog, value: 256)
            .serverChannelOption(ChannelOptions.socketOption(.so_reuseaddr), value: 1)
            .childChannelInitializer { channel in
                channel.pipeline.configureHTTPServerPipeline().flatMap {
                    channel.pipeline.addHandler(SwiftletHTTPHandler(config: config))
                }
            }
            .childChannelOption(ChannelOptions.socketOption(.so_reuseaddr), value: 1)
            .childChannelOption(ChannelOptions.maxMessagesPerRead, value: 16)
            .childChannelOption(ChannelOptions.recvAllocator, value: AdaptiveRecvByteBufferAllocator())
        
        log(.info, "Starting Swiftlets server on \(config.host):\(config.port)")
        log(.info, "Visit http://\(config.host):\(config.port)/ to test")
        
        let channel = try bootstrap.bind(host: config.host, port: config.port).wait()
        
        // Wait for server to close
        try channel.closeFuture.wait()
    }
}