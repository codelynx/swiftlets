/// Base protocol for all HTML elements
public protocol HTMLElement {
    /// HTML attributes for this element
    var attributes: HTMLAttributes { get set }
    
    /// Renders this element to HTML string
    func render() -> String
}

/// Protocol for HTML elements that can contain other elements
public protocol HTMLContainer: HTMLElement {
    associatedtype Content: HTMLElement
    
    /// The content of this container
    var content: Content { get }
}

/// Protocol for inline HTML elements (text-level semantics)
public protocol HTMLInline: HTMLElement { }

/// Protocol for page-level components
public protocol Component {
    associatedtype Body: HTMLElement
    
    /// The body content of this component
    @HTMLBuilder var body: Body { get }
}

/// Empty HTML element for conditional rendering
public struct EmptyHTML: HTMLElement {
    public var attributes = HTMLAttributes()
    
    public init() {}
    
    public func render() -> String {
        ""
    }
}