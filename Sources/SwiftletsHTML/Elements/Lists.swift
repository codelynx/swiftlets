/// HTML unordered list element
public struct UL<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }
    
    public func render() -> String {
        "<ul\(attributes.render())>\(content.render())</ul>"
    }
}

/// HTML ordered list element
public struct OL<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }
    
    public func render() -> String {
        "<ol\(attributes.render())>\(content.render())</ol>"
    }
}

/// HTML list item element
public struct LI<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }
    
    public init(_ text: String) where Content == Text {
        self.content = Text(text)
    }
    
    public func render() -> String {
        "<li\(attributes.render())>\(content.render())</li>"
    }
}

/// HTML definition list element
public struct DL<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }
    
    public func render() -> String {
        "<dl\(attributes.render())>\(content.render())</dl>"
    }
}

/// HTML definition term element
public struct DT<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }
    
    public init(_ text: String) where Content == Text {
        self.content = Text(text)
    }
    
    public func render() -> String {
        "<dt\(attributes.render())>\(content.render())</dt>"
    }
}

/// HTML definition description element
public struct DD<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }
    
    public init(_ text: String) where Content == Text {
        self.content = Text(text)
    }
    
    public func render() -> String {
        "<dd\(attributes.render())>\(content.render())</dd>"
    }
}