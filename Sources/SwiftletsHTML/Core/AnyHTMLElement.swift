/// Type-erasing wrapper for HTMLElement
public struct AnyHTMLElement: HTMLElement {
    private let wrapped: any HTMLElement
    public var attributes: HTMLAttributes
    
    public init<E: HTMLElement>(_ element: E) {
        // If already wrapped, extract the inner element
        if let any = element as? AnyHTMLElement {
            self.wrapped = any.wrapped
            self.attributes = any.attributes
        } else {
            self.wrapped = element
            self.attributes = element.attributes
        }
    }
    
    public func render() -> String {
        // Create a copy of the wrapped element with updated attributes
        var element = wrapped
        element.attributes = attributes
        return element.render()
    }
}

/// Collection of HTML elements
public struct HTMLGroup: HTMLElement {
    public let elements: [any HTMLElement]
    public var attributes = HTMLAttributes()
    
    public init(elements: [any HTMLElement]) {
        self.elements = elements
    }
    
    public func render() -> String {
        elements.map { $0.render() }.joined()
    }
}