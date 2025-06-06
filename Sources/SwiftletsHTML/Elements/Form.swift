/// HTML form element
public struct Form<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    private let action: String
    private let method: String
    
    public init(action: String, method: String = "POST", @HTMLBuilder content: () -> Content) {
        self.action = action
        self.method = method
        self.content = content()
    }
    
    public func render() -> String {
        var attrs = attributes
        attrs.custom.append(("action", action))
        attrs.custom.append(("method", method))
        return "<form\(attrs.render())>\(content.render())</form>"
    }
}

/// HTML input element
public struct Input: HTMLElement {
    public var attributes = HTMLAttributes()
    private let type: String
    private let name: String?
    private let value: String?
    private let placeholder: String?
    
    public init(type: String = "text", name: String? = nil, value: String? = nil, placeholder: String? = nil) {
        self.type = type
        self.name = name
        self.value = value
        self.placeholder = placeholder
    }
    
    public func render() -> String {
        var attrs = attributes
        attrs.custom.append(("type", type))
        if let name = name {
            attrs.custom.append(("name", name))
        }
        if let value = value {
            attrs.custom.append(("value", value))
        }
        if let placeholder = placeholder {
            attrs.custom.append(("placeholder", placeholder))
        }
        return "<input\(attrs.render())>"
    }
}

/// HTML textarea element
public struct TextArea: HTMLElement {
    public var attributes = HTMLAttributes()
    private let name: String?
    private let rows: Int?
    private let cols: Int?
    private let placeholder: String?
    private let content: String
    
    public init(name: String? = nil, rows: Int? = nil, cols: Int? = nil, placeholder: String? = nil, content: String = "") {
        self.name = name
        self.rows = rows
        self.cols = cols
        self.placeholder = placeholder
        self.content = content
    }
    
    public func render() -> String {
        var attrs = attributes
        if let name = name {
            attrs.custom.append(("name", name))
        }
        if let rows = rows {
            attrs.custom.append(("rows", "\(rows)"))
        }
        if let cols = cols {
            attrs.custom.append(("cols", "\(cols)"))
        }
        if let placeholder = placeholder {
            attrs.custom.append(("placeholder", placeholder))
        }
        return "<textarea\(attrs.render())>\(content.escapedContent())</textarea>"
    }
}

/// HTML select element
public struct Select<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    private let name: String?
    
    public init(name: String? = nil, @HTMLBuilder content: () -> Content) {
        self.name = name
        self.content = content()
    }
    
    public func render() -> String {
        var attrs = attributes
        if let name = name {
            attrs.custom.append(("name", name))
        }
        return "<select\(attrs.render())>\(content.render())</select>"
    }
}

/// HTML option element
public struct Option: HTMLElement {
    public var attributes = HTMLAttributes()
    private let value: String?
    private let text: String
    private let selected: Bool
    
    public init(_ text: String, value: String? = nil, selected: Bool = false) {
        self.text = text
        self.value = value ?? text
        self.selected = selected
    }
    
    public func render() -> String {
        var attrs = attributes
        if let value = value {
            attrs.custom.append(("value", value))
        }
        if selected {
            attrs.custom.append(("selected", "selected"))
        }
        return "<option\(attrs.render())>\(text.escapedContent())</option>"
    }
}

/// HTML button element
public struct Button<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    private let type: String
    
    public init(type: String = "button", @HTMLBuilder content: () -> Content) {
        self.type = type
        self.content = content()
    }
    
    public init(_ text: String, type: String = "button") where Content == Text {
        self.type = type
        self.content = Text(text)
    }
    
    public func render() -> String {
        var attrs = attributes
        attrs.custom.append(("type", type))
        return "<button\(attrs.render())>\(content.render())</button>"
    }
}

/// HTML label element
public struct Label<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    private let forInput: String?
    
    public init(for inputName: String? = nil, @HTMLBuilder content: () -> Content) {
        self.forInput = inputName
        self.content = content()
    }
    
    public init(_ text: String, for inputName: String? = nil) where Content == Text {
        self.forInput = inputName
        self.content = Text(text)
    }
    
    public func render() -> String {
        var attrs = attributes
        if let forInput = forInput {
            attrs.custom.append(("for", forInput))
        }
        return "<label\(attrs.render())>\(content.render())</label>"
    }
}

/// HTML fieldset element
public struct FieldSet<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }
    
    public func render() -> String {
        "<fieldset\(attributes.render())>\(content.render())</fieldset>"
    }
}

/// HTML legend element
public struct Legend<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }
    
    public init(_ text: String) where Content == Text {
        self.content = Text(text)
    }
    
    public func render() -> String {
        "<legend\(attributes.render())>\(content.render())</legend>"
    }
}