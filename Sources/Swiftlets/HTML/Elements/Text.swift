/// Plain text content
public struct Text: HTMLInline {
    public let content: String
    public var attributes = HTMLAttributes()
    
    public init(_ content: String) {
        self.content = content
    }
    
    public init<T: CustomStringConvertible>(_ value: T) {
        self.content = String(describing: value)
    }
    
    public func render() -> String {
        content.escapedContent()
    }
}

/// Raw HTML content (not escaped)
public struct RawHTML: HTMLElement {
    public let html: String
    public var attributes = HTMLAttributes()
    
    public init(_ html: String) {
        self.html = html
    }
    
    public func render() -> String {
        html
    }
}