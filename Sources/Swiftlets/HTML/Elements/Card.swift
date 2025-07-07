/// Card component for grouping related content
public struct Card<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    
    public enum Style {
        case `default`
        case elevated
        case outlined
        case filled
    }
    
    public init(
        style: Style = .default,
        padding: Int? = nil,
        @HTMLBuilder content: () -> Content
    ) {
        self.content = content()
        
        // Apply card styles based on style
        switch style {
        case .default:
            self.attributes.styles["background"] = "#ffffff"
            self.attributes.styles["border"] = "1px solid #e2e8f0"
        case .elevated:
            self.attributes.styles["background"] = "#ffffff"
            self.attributes.styles["box-shadow"] = "0 4px 6px rgba(0, 0, 0, 0.1)"
        case .outlined:
            self.attributes.styles["background"] = "transparent"
            self.attributes.styles["border"] = "2px solid #e2e8f0"
        case .filled:
            self.attributes.styles["background"] = "#f7fafc"
            self.attributes.styles["border"] = "none"
        }
        
        // Common styles
        self.attributes.styles["border-radius"] = "8px"
        self.attributes.styles["padding"] = "\(padding ?? 24)px"
        
        // Add default class for custom styling
        self.attributes.classes.insert("card")
        if style != .default {
            self.attributes.classes.insert("card-\(style)")
        }
    }
    
    public func render() -> String {
        "<div\(attributes.render())>\(content.render())</div>"
    }
}

/// Card header component
public struct CardHeader<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
        
        // Apply header styles
        self.attributes.styles["padding-bottom"] = "1rem"
        self.attributes.styles["border-bottom"] = "1px solid #e2e8f0"
        self.attributes.styles["margin-bottom"] = "1rem"
        self.attributes.classes.insert("card-header")
    }
    
    public func render() -> String {
        "<div\(attributes.render())>\(content.render())</div>"
    }
}

/// Card body component
public struct CardBody<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
        self.attributes.classes.insert("card-body")
    }
    
    public func render() -> String {
        "<div\(attributes.render())>\(content.render())</div>"
    }
}

/// Card footer component
public struct CardFooter<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
        
        // Apply footer styles
        self.attributes.styles["padding-top"] = "1rem"
        self.attributes.styles["border-top"] = "1px solid #e2e8f0"
        self.attributes.styles["margin-top"] = "1rem"
        self.attributes.classes.insert("card-footer")
    }
    
    public func render() -> String {
        "<div\(attributes.render())>\(content.render())</div>"
    }
}