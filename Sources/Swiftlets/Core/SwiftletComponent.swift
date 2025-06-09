import Foundation

// MARK: - Core Protocol for HTML Components

/// Protocol for components that generate content
public protocol HTMLComponent {
    associatedtype Body
    
    /// The content of this component
    var body: Body { get }
}

// MARK: - Protocol for HTML Page Metadata

/// Protocol for defining HTML page metadata (title, meta tags, etc.)
public protocol HTMLHeader {
    /// The page title (appears in <title> tag)
    var title: String { get }
    
    /// Additional meta tags as key-value pairs
    var meta: [String: String] { get }
}

// MARK: - Default implementation for optional metadata

public extension HTMLHeader {
    var meta: [String: String] { [:] }
}

// MARK: - Combined Protocol for Complete Pages

/// Protocol combining HTML content and metadata for complete pages
public protocol SwiftletComponent: HTMLComponent, HTMLHeader {
    init()
}

// MARK: - Main entry point for SwiftUI-style Swiftlets

/// Protocol for SwiftUI-style Swiftlets with @main support
public protocol SwiftletMain: SwiftletComponent {
    static func main() async throws
}

// MARK: - Protocol for handling different body return types

public protocol SwiftletBody {
    func buildResponse(with metadata: any HTMLHeader) -> Response
}

// HTML elements can be body
extension HTMLElement {
    public func buildResponse(with metadata: any HTMLHeader) -> Response {
        let htmlContent = self.render()
        let completeHTML = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <title>\(metadata.title)</title>
            \(metadata.meta.map { "<meta name=\"\($0.key)\" content=\"\($0.value)\">" }.joined(separator: "\n    "))
        </head>
        <body>
            \(htmlContent)
        </body>
        </html>
        """
        
        return Response(
            status: 200,
            headers: ["Content-Type": "text/html; charset=utf-8"],
            body: completeHTML
        )
    }
}

// Type eraser for any HTML
public struct AnyHTMLBody: HTMLElement, SwiftletBody {
    public var attributes = HTMLAttributes()
    private let _render: () -> String
    private let _buildResponse: (any HTMLHeader) -> Response
    
    public init<H: HTMLElement>(_ html: H) {
        self._render = { html.render() }
        self._buildResponse = { metadata in
            html.buildResponse(with: metadata)
        }
    }
    
    public func render() -> String {
        _render()
    }
    
    public func buildResponse(with metadata: any HTMLHeader) -> Response {
        _buildResponse(metadata)
    }
}

// ResponseBuilder can be body
extension ResponseBuilder: SwiftletBody {
    public func buildResponse(with metadata: any HTMLHeader) -> Response {
        // ResponseBuilder already has complete HTML, just build it
        return self.build()
    }
}

// MARK: - Default main implementation

public extension SwiftletMain {
    static func main() async throws {
        // Get request from stdin
        guard let inputData = try? FileHandle.standardInput.readToEnd(),
              let request = try? JSONDecoder().decode(Request.self, from: inputData) else {
            let errorResponse = Response(
                status: 400,
                headers: [:],
                body: "Invalid request"
            )
            let output = try JSONEncoder().encode(errorResponse)
            print(String(data: output, encoding: .utf8) ?? "{}")
            return
        }
        
        // Initialize swiftlet with context
        let context = DefaultSwiftletContext(request: request)
        try SwiftletContextKey.$current.withValue(context) {
            let swiftlet = Self()
            
            // Build response based on body type
            let response: Response
            if let htmlElement = swiftlet.body as? any HTMLElement {
                response = htmlElement.buildResponse(with: swiftlet)
            } else if let responseBuilder = swiftlet.body as? ResponseBuilder {
                response = responseBuilder.buildResponse(with: swiftlet)
            } else {
                // Fallback error response
                response = Response(
                    status: 500,
                    headers: [:],
                    body: "Invalid body type"
                )
            }
            
            // Output response
            let output = try JSONEncoder().encode(response)
            print(String(data: output, encoding: .utf8) ?? "{}")
        }
    }
}