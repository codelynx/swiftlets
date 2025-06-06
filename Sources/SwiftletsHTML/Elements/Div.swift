/// HTML div element
public struct Div<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }
    
    public func render() -> String {
        "<div\(attributes.render())>\(content.render())</div>"
    }
}

/// HTML section element
public struct Section<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }
    
    public func render() -> String {
        "<section\(attributes.render())>\(content.render())</section>"
    }
}

/// HTML article element
public struct Article<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }
    
    public func render() -> String {
        "<article\(attributes.render())>\(content.render())</article>"
    }
}