/// HTML strong element (bold)
public struct Strong<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }
    
    public init(_ text: String) where Content == Text {
        self.content = Text(text)
    }
    
    public func render() -> String {
        "<strong\(attributes.render())>\(content.render())</strong>"
    }
}

/// HTML em element (italic)
public struct Em<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }
    
    public init(_ text: String) where Content == Text {
        self.content = Text(text)
    }
    
    public func render() -> String {
        "<em\(attributes.render())>\(content.render())</em>"
    }
}

/// HTML code element
public struct Code<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }
    
    public init(_ text: String) where Content == Text {
        self.content = Text(text)
    }
    
    public func render() -> String {
        "<code\(attributes.render())>\(content.render())</code>"
    }
}

/// HTML pre element (preformatted text)
public struct Pre<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }
    
    public init(_ text: String) where Content == Text {
        self.content = Text(text)
    }
    
    public func render() -> String {
        "<pre\(attributes.render())>\(content.render())</pre>"
    }
}

/// HTML blockquote element
public struct BlockQuote<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }
    
    public func render() -> String {
        "<blockquote\(attributes.render())>\(content.render())</blockquote>"
    }
}

/// HTML br element (line break)
public struct BR: HTMLElement {
    public var attributes = HTMLAttributes()
    
    public init() {}
    
    public func render() -> String {
        "<br\(attributes.render())>"
    }
}

/// HTML hr element (horizontal rule)
public struct HR: HTMLElement {
    public var attributes = HTMLAttributes()
    
    public init() {}
    
    public func render() -> String {
        "<hr\(attributes.render())>"
    }
}

/// HTML small element
public struct Small<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }
    
    public init(_ text: String) where Content == Text {
        self.content = Text(text)
    }
    
    public func render() -> String {
        "<small\(attributes.render())>\(content.render())</small>"
    }
}

/// HTML mark element (highlighted text)
public struct Mark<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }
    
    public init(_ text: String) where Content == Text {
        self.content = Text(text)
    }
    
    public func render() -> String {
        "<mark\(attributes.render())>\(content.render())</mark>"
    }
}