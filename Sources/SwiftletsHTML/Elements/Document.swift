/// HTML document structure
public struct Html<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }
    
    public func render() -> String {
        """
        <!DOCTYPE html>
        <html\(attributes.render())>
        \(content.render())
        </html>
        """
    }
}

/// HTML head element
public struct Head<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }
    
    public func render() -> String {
        "<head\(attributes.render())>\(content.render())</head>"
    }
}

/// HTML body element
public struct Body<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }
    
    public func render() -> String {
        "<body\(attributes.render())>\(content.render())</body>"
    }
}

/// HTML title element
public struct Title: HTMLElement {
    public var attributes = HTMLAttributes()
    private let text: String
    
    public init(_ text: String) {
        self.text = text
    }
    
    public func render() -> String {
        "<title\(attributes.render())>\(text.escapedContent())</title>"
    }
}

/// HTML meta element
public struct Meta: HTMLElement {
    public var attributes = HTMLAttributes()
    
    public init(charset: String? = nil, name: String? = nil, content: String? = nil) {
        if let charset = charset {
            attributes.custom.append(("charset", charset))
        }
        if let name = name {
            attributes.custom.append(("name", name))
        }
        if let content = content {
            attributes.custom.append(("content", content))
        }
    }
    
    public func render() -> String {
        "<meta\(attributes.render())>"
    }
}