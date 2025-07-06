// Simple shared header component
public func sharedHeader(title: String) -> some HTMLElement {
    Header {
        H1(title)
            .style("color", "#333")
            .style("font-size", "2.5rem")
    }
    .style("padding", "2rem")
    .style("background", "#f0f0f0")
    .style("text-align", "center")
}

// Simple shared footer component
public struct SharedFooter: HTMLElement {
    public var attributes = HTMLAttributes()
    
    public init() {}
    
    public func render() -> String {
        Footer {
            P("© 2025 Module Test Site")
                .style("text-align", "center")
                .style("padding", "1rem")
                .style("color", "#666")
        }
        .style("background", "#f8f8f8")
        .style("border-top", "1px solid #ddd")
        .render()
    }
}