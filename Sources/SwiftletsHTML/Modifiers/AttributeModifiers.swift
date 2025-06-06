// MARK: - Attribute Modifiers

extension HTMLElement {
    /// Sets the ID attribute
    public func id(_ id: String) -> AnyHTMLElement {
        var modified = self
        modified.attributes.id = id
        return AnyHTMLElement(modified)
    }
    
    /// Adds a CSS class
    public func `class`(_ className: String) -> AnyHTMLElement {
        var modified = self
        modified.attributes.classes.insert(className)
        return AnyHTMLElement(modified)
    }
    
    /// Adds multiple CSS classes
    public func classes(_ classNames: String...) -> AnyHTMLElement {
        var modified = self
        modified.attributes.classes.formUnion(classNames)
        return AnyHTMLElement(modified)
    }
    
    /// Sets an inline style
    public func style(_ key: String, _ value: String) -> AnyHTMLElement {
        var modified = self
        modified.attributes.styles[key] = value
        return AnyHTMLElement(modified)
    }
    
    /// Sets a data attribute
    public func data(_ key: String, _ value: String) -> AnyHTMLElement {
        var modified = self
        modified.attributes.data[key] = value
        return AnyHTMLElement(modified)
    }
    
    /// Sets a custom attribute
    public func attribute(_ key: String, _ value: String) -> AnyHTMLElement {
        var modified = self
        modified.attributes.custom.append((key, value))
        return AnyHTMLElement(modified)
    }
    
    /// Sets an event handler
    public func on(_ event: String, _ handler: String) -> AnyHTMLElement {
        var modified = self
        modified.attributes.events[event] = handler
        return AnyHTMLElement(modified)
    }
}