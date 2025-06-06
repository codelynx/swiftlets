/// Fragment for grouping elements without adding a wrapper element
public struct Fragment<Content: HTMLElement>: HTMLElement {
    public var attributes = HTMLAttributes() // Not used for fragments
    public let content: Content
    
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }
    
    public func render() -> String {
        // Fragment doesn't render any wrapper, just its content
        content.render()
    }
}

/// Group alias for Fragment
public typealias Group = Fragment