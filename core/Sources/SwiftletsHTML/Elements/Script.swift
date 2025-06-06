/// HTML script element
public struct Script: HTMLElement {
    public var attributes = HTMLAttributes()
    private let src: String?
    private let content: String?
    private let type: String
    private let async: Bool
    private let `defer`: Bool
    
    public init(src: String, type: String = "text/javascript", async: Bool = false, defer: Bool = false) {
        self.src = src
        self.content = nil
        self.type = type
        self.async = async
        self.`defer` = `defer`
    }
    
    public init(_ content: String, type: String = "text/javascript") {
        self.src = nil
        self.content = content
        self.type = type
        self.async = false
        self.`defer` = false
    }
    
    public func render() -> String {
        var attrs = attributes
        attrs.custom.append(("type", type))
        
        if let src = src {
            attrs.custom.append(("src", src))
            if async {
                attrs.custom.append(("async", "async"))
            }
            if self.`defer` {
                attrs.custom.append(("defer", "defer"))
            }
            return "<script\(attrs.render())></script>"
        } else if let content = content {
            return "<script\(attrs.render())>\(content)</script>"
        } else {
            return "<script\(attrs.render())></script>"
        }
    }
}

/// HTML noscript element
public struct NoScript<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }
    
    public func render() -> String {
        "<noscript\(attributes.render())>\(content.render())</noscript>"
    }
}

/// HTML style element
public struct Style: HTMLElement {
    public var attributes = HTMLAttributes()
    private let css: String
    
    public init(_ css: String) {
        self.css = css
    }
    
    public func render() -> String {
        "<style\(attributes.render())>\(css)</style>"
    }
}

/// HTML link element
public struct LinkElement: HTMLElement {
    public var attributes = HTMLAttributes()
    private let rel: String
    private let href: String
    private let type: String?
    
    public init(rel: String, href: String, type: String? = nil) {
        self.rel = rel
        self.href = href
        self.type = type
    }
    
    public func render() -> String {
        var attrs = attributes
        attrs.custom.append(("rel", rel))
        attrs.custom.append(("href", href))
        if let type = type {
            attrs.custom.append(("type", type))
        }
        return "<link\(attrs.render())>"
    }
}