/// HTML anchor (link) element
public struct A<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    private let href: String
    
    public init(href: String, @HTMLBuilder content: () -> Content) {
        self.href = href
        self.content = content()
    }
    
    public init(href: String, _ text: String) where Content == Text {
        self.href = href
        self.content = Text(text)
    }
    
    public func render() -> String {
        var attrs = attributes
        attrs.custom.append(("href", href))
        return "<a\(attrs.render())>\(content.render())</a>"
    }
}

/// Convenience alias for anchor element
public typealias Link = A