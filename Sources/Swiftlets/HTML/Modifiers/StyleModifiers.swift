// MARK: - Style Convenience Modifiers

extension HTMLElement {
    /// Sets padding
    public func padding(_ value: Int) -> AnyHTMLElement {
        style("padding", "\(value)px")
    }
    
    /// Sets padding with specific values
    public func padding(top: Int? = nil, right: Int? = nil, bottom: Int? = nil, left: Int? = nil) -> AnyHTMLElement {
        let values = [top, right, bottom, left].compactMap { $0 }
        if values.isEmpty { return AnyHTMLElement(self) }
        
        let paddingValue = values.map { "\($0)px" }.joined(separator: " ")
        return style("padding", paddingValue)
    }
    
    /// Sets margin
    public func margin(_ value: Int) -> AnyHTMLElement {
        style("margin", "\(value)px")
    }
    
    /// Sets background color
    public func background(_ color: String) -> AnyHTMLElement {
        style("background-color", color)
    }
    
    /// Sets text color
    public func foregroundColor(_ color: String) -> AnyHTMLElement {
        style("color", color)
    }
    
    /// Sets font size
    public func fontSize(_ size: Int) -> AnyHTMLElement {
        style("font-size", "\(size)px")
    }
    
    /// Sets font weight
    public func fontWeight(_ weight: String) -> AnyHTMLElement {
        style("font-weight", weight)
    }
    
    /// Makes text bold
    public func bold() -> AnyHTMLElement {
        fontWeight("bold")
    }
    
    /// Sets text alignment
    public func textAlign(_ alignment: String) -> AnyHTMLElement {
        style("text-align", alignment)
    }
    
    /// Centers text
    public func center() -> AnyHTMLElement {
        textAlign("center")
    }
    
    /// Sets display property
    public func display(_ value: String) -> AnyHTMLElement {
        style("display", value)
    }
    
    /// Hides the element
    public func hidden(_ isHidden: Bool = true) -> AnyHTMLElement {
        isHidden ? style("display", "none") : AnyHTMLElement(self)
    }
    
    /// Sets width
    public func width(_ value: Int) -> AnyHTMLElement {
        style("width", "\(value)px")
    }
    
    /// Sets height
    public func height(_ value: Int) -> AnyHTMLElement {
        style("height", "\(value)px")
    }
    
    /// Sets border
    public func border(_ width: Int = 1, _ style: String = "solid", _ color: String = "#000") -> AnyHTMLElement {
        self.style("border", "\(width)px \(style) \(color)")
    }
    
    /// Sets border radius
    public func cornerRadius(_ radius: Int) -> AnyHTMLElement {
        style("border-radius", "\(radius)px")
    }
}