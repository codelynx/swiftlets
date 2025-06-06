/// HTML table element
public struct Table<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }
    
    public func render() -> String {
        "<table\(attributes.render())>\(content.render())</table>"
    }
}

/// HTML table header element
public struct THead<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }
    
    public func render() -> String {
        "<thead\(attributes.render())>\(content.render())</thead>"
    }
}

/// HTML table body element
public struct TBody<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }
    
    public func render() -> String {
        "<tbody\(attributes.render())>\(content.render())</tbody>"
    }
}

/// HTML table footer element
public struct TFoot<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }
    
    public func render() -> String {
        "<tfoot\(attributes.render())>\(content.render())</tfoot>"
    }
}

/// HTML table row element
public struct TR<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }
    
    public func render() -> String {
        "<tr\(attributes.render())>\(content.render())</tr>"
    }
}

/// HTML table header cell element
public struct TH<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }
    
    public init(_ text: String) where Content == Text {
        self.content = Text(text)
    }
    
    public func render() -> String {
        "<th\(attributes.render())>\(content.render())</th>"
    }
}

/// HTML table data cell element
public struct TD<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }
    
    public init(_ text: String) where Content == Text {
        self.content = Text(text)
    }
    
    public func render() -> String {
        "<td\(attributes.render())>\(content.render())</td>"
    }
}

/// HTML table caption element
public struct Caption<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }
    
    public init(_ text: String) where Content == Text {
        self.content = Text(text)
    }
    
    public func render() -> String {
        "<caption\(attributes.render())>\(content.render())</caption>"
    }
}