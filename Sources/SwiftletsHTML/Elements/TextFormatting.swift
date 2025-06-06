/// HTML abbr element (abbreviation)
public struct Abbr<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    private let title: String?
    
    public init(title: String? = nil, @HTMLBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    public init(_ text: String, title: String? = nil) where Content == Text {
        self.title = title
        self.content = Text(text)
    }
    
    public func render() -> String {
        var attrs = attributes
        if let title = title {
            attrs.custom.append(("title", title))
        }
        return "<abbr\(attrs.render())>\(content.render())</abbr>"
    }
}

/// HTML cite element
public struct Cite<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }
    
    public init(_ text: String) where Content == Text {
        self.content = Text(text)
    }
    
    public func render() -> String {
        "<cite\(attributes.render())>\(content.render())</cite>"
    }
}

/// HTML q element (inline quotation)
public struct Q<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    private let cite: String?
    
    public init(cite: String? = nil, @HTMLBuilder content: () -> Content) {
        self.cite = cite
        self.content = content()
    }
    
    public init(_ text: String, cite: String? = nil) where Content == Text {
        self.cite = cite
        self.content = Text(text)
    }
    
    public func render() -> String {
        var attrs = attributes
        if let cite = cite {
            attrs.custom.append(("cite", cite))
        }
        return "<q\(attrs.render())>\(content.render())</q>"
    }
}

/// HTML kbd element (keyboard input)
public struct Kbd<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }
    
    public init(_ text: String) where Content == Text {
        self.content = Text(text)
    }
    
    public func render() -> String {
        "<kbd\(attributes.render())>\(content.render())</kbd>"
    }
}

/// HTML samp element (sample output)
public struct Samp<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }
    
    public init(_ text: String) where Content == Text {
        self.content = Text(text)
    }
    
    public func render() -> String {
        "<samp\(attributes.render())>\(content.render())</samp>"
    }
}

/// HTML var element (variable)
public struct Var<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }
    
    public init(_ text: String) where Content == Text {
        self.content = Text(text)
    }
    
    public func render() -> String {
        "<var\(attributes.render())>\(content.render())</var>"
    }
}

/// HTML sub element (subscript)
public struct Sub<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }
    
    public init(_ text: String) where Content == Text {
        self.content = Text(text)
    }
    
    public func render() -> String {
        "<sub\(attributes.render())>\(content.render())</sub>"
    }
}

/// HTML sup element (superscript)
public struct Sup<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }
    
    public init(_ text: String) where Content == Text {
        self.content = Text(text)
    }
    
    public func render() -> String {
        "<sup\(attributes.render())>\(content.render())</sup>"
    }
}

/// HTML del element (deleted text)
public struct Del<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    private let datetime: String?
    
    public init(datetime: String? = nil, @HTMLBuilder content: () -> Content) {
        self.datetime = datetime
        self.content = content()
    }
    
    public init(_ text: String, datetime: String? = nil) where Content == Text {
        self.datetime = datetime
        self.content = Text(text)
    }
    
    public func render() -> String {
        var attrs = attributes
        if let datetime = datetime {
            attrs.custom.append(("datetime", datetime))
        }
        return "<del\(attrs.render())>\(content.render())</del>"
    }
}

/// HTML ins element (inserted text)
public struct Ins<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    private let datetime: String?
    
    public init(datetime: String? = nil, @HTMLBuilder content: () -> Content) {
        self.datetime = datetime
        self.content = content()
    }
    
    public init(_ text: String, datetime: String? = nil) where Content == Text {
        self.datetime = datetime
        self.content = Text(text)
    }
    
    public func render() -> String {
        var attrs = attributes
        if let datetime = datetime {
            attrs.custom.append(("datetime", datetime))
        }
        return "<ins\(attrs.render())>\(content.render())</ins>"
    }
}