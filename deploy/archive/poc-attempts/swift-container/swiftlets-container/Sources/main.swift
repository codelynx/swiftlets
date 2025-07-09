import NIO
import NIOHTTP1

// Simple HTTP server that serves static Swiftlets pages
@available(macOS 10.15, *)
final class HTTPHandler: ChannelInboundHandler, @unchecked Sendable {
    typealias InboundIn = HTTPServerRequestPart
    typealias OutboundOut = HTTPServerResponsePart
    
    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        let reqPart = unwrapInboundIn(data)
        
        switch reqPart {
        case .head(let request):
            handleRequest(request, context: context)
        case .body, .end:
            break
        }
    }
    
    private func handleRequest(_ request: HTTPRequestHead, context: ChannelHandlerContext) {
        print("[\(request.method)] \(request.uri)")
        
        let html: String
        let status: HTTPResponseStatus
        
        switch request.uri {
        case "/":
            html = homePage()
            status = .ok
        case "/about":
            html = aboutPage()
            status = .ok
        default:
            html = notFoundPage()
            status = .notFound
        }
        
        var headers = HTTPHeaders()
        headers.add(name: "Content-Type", value: "text/html; charset=utf-8")
        headers.add(name: "Content-Length", value: String(html.utf8.count))
        
        let head = HTTPResponseHead(version: .http1_1, status: status, headers: headers)
        context.write(wrapOutboundOut(.head(head)), promise: nil)
        
        let buffer = context.channel.allocator.buffer(string: html)
        context.write(wrapOutboundOut(.body(.byteBuffer(buffer))), promise: nil)
        context.writeAndFlush(wrapOutboundOut(.end(nil)), promise: nil)
    }
    
    func homePage() -> String {
        """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <title>Swiftlets Container Demo</title>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
        </head>
        <body>
            <h1>🚀 Swiftlets Running in Container!</h1>
            <p>This is a containerized Swift web application running on EC2.</p>
            <p>Platform: \(getPlatformInfo())</p>
            <nav>
                <a href="/">Home</a> |
                <a href="/about">About</a>
            </nav>
        </body>
        </html>
        """
    }
    
    func aboutPage() -> String {
        """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <title>About - Swiftlets Container</title>
        </head>
        <body>
            <h1>About Swiftlets Container</h1>
            <p>This demonstrates cross-platform Swift deployment using containers.</p>
            <h2>Benefits:</h2>
            <ul>
                <li>Build once on Mac, run anywhere</li>
                <li>No Swift installation needed on server</li>
                <li>Consistent deployments</li>
                <li>Fast startup times</li>
            </ul>
            <a href="/">← Back to Home</a>
        </body>
        </html>
        """
    }
    
    func notFoundPage() -> String {
        """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <title>404 - Not Found</title>
        </head>
        <body>
            <h1>404 - Page Not Found</h1>
            <p>The requested page does not exist.</p>
            <a href="/">← Back to Home</a>
        </body>
        </html>
        """
    }
    
    func getPlatformInfo() -> String {
        #if os(Linux)
        let os = "Linux"
        #elseif os(macOS)
        let os = "macOS"
        #else
        let os = "Unknown"
        #endif
        
        #if arch(x86_64)
        let arch = "x86_64"
        #elseif arch(arm64) || arch(aarch64)
        let arch = "ARM64"
        #else
        let arch = "Unknown"
        #endif
        
        return "\(os) \(arch)"
    }
}

@main
struct SwiftletsContainer {
    static func main() throws {
        let group = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
        defer {
            try! group.syncShutdownGracefully()
        }
        
        let bootstrap = ServerBootstrap(group: group)
            .serverChannelOption(ChannelOptions.backlog, value: 256)
            .serverChannelOption(ChannelOptions.socketOption(.so_reuseaddr), value: 1)
            .childChannelInitializer { channel in
                channel.pipeline.configureHTTPServerPipeline().flatMap {
                    channel.pipeline.addHandler(HTTPHandler())
                }
            }
        
        let host = "0.0.0.0"
        let port = 8080
        
        print("🚀 Swiftlets Container Server")
        print("Platform: \(getPlatformInfo())")
        print("Listening on \(host):\(port)")
        
        let channel = try bootstrap.bind(host: host, port: port).wait()
        try channel.closeFuture.wait()
    }
    
    static func getPlatformInfo() -> String {
        #if os(Linux)
        let os = "Linux"
        #elseif os(macOS)
        let os = "macOS"
        #else
        let os = "Unknown"
        #endif
        
        #if arch(x86_64)
        let arch = "x86_64"
        #elseif arch(arm64) || arch(aarch64)
        let arch = "ARM64"
        #else
        let arch = "Unknown"
        #endif
        
        return "\(os) \(arch)"
    }
}