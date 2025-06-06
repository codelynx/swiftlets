/// HTML details element
public struct Details<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    private let open: Bool
    
    public init(open: Bool = false, @HTMLBuilder content: () -> Content) {
        self.open = open
        self.content = content()
    }
    
    public func render() -> String {
        var attrs = attributes
        if open {
            attrs.custom.append(("open", "open"))
        }
        return "<details\(attrs.render())>\(content.render())</details>"
    }
}

/// HTML summary element
public struct Summary<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }
    
    public init(_ text: String) where Content == Text {
        self.content = Text(text)
    }
    
    public func render() -> String {
        "<summary\(attributes.render())>\(content.render())</summary>"
    }
}

/// HTML progress element
public struct Progress: HTMLElement {
    public var attributes = HTMLAttributes()
    private let value: Double?
    private let max: Double
    
    public init(value: Double? = nil, max: Double = 1.0) {
        self.value = value
        self.max = max
    }
    
    public func render() -> String {
        var attrs = attributes
        if let value = value {
            attrs.custom.append(("value", "\(value)"))
        }
        attrs.custom.append(("max", "\(max)"))
        return "<progress\(attrs.render())></progress>"
    }
}

/// HTML meter element
public struct Meter: HTMLElement {
    public var attributes = HTMLAttributes()
    private let value: Double
    private let min: Double?
    private let max: Double?
    private let low: Double?
    private let high: Double?
    private let optimum: Double?
    
    public init(
        value: Double,
        min: Double? = nil,
        max: Double? = nil,
        low: Double? = nil,
        high: Double? = nil,
        optimum: Double? = nil
    ) {
        self.value = value
        self.min = min
        self.max = max
        self.low = low
        self.high = high
        self.optimum = optimum
    }
    
    public func render() -> String {
        var attrs = attributes
        attrs.custom.append(("value", "\(value)"))
        
        if let min = min {
            attrs.custom.append(("min", "\(min)"))
        }
        if let max = max {
            attrs.custom.append(("max", "\(max)"))
        }
        if let low = low {
            attrs.custom.append(("low", "\(low)"))
        }
        if let high = high {
            attrs.custom.append(("high", "\(high)"))
        }
        if let optimum = optimum {
            attrs.custom.append(("optimum", "\(optimum)"))
        }
        
        return "<meter\(attrs.render())></meter>"
    }
}

/// HTML time element
public struct Time<Content: HTMLElement>: HTMLContainer {
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
        return "<time\(attrs.render())>\(content.render())</time>"
    }
}

/// HTML data element
public struct Data<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    private let value: String
    
    public init(value: String, @HTMLBuilder content: () -> Content) {
        self.value = value
        self.content = content()
    }
    
    public init(_ text: String, value: String) where Content == Text {
        self.value = value
        self.content = Text(text)
    }
    
    public func render() -> String {
        var attrs = attributes
        attrs.custom.append(("value", value))
        return "<data\(attrs.render())>\(content.render())</data>"
    }
}