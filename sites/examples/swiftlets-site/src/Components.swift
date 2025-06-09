import Swiftlets

// Helper component to show Swift code and generated HTML
public struct CodeExample {
    let title: String?
    let swift: String
    let description: String?
    let html: String
    let preview: () -> any HTMLElement
    
    public init(title: String? = nil, swift: String, html: String, preview: @escaping () -> any HTMLElement, description: String? = nil) {
        self.title = title
        self.swift = swift
        self.html = html
        self.preview = preview
        self.description = description
    }
    
    public func render() -> any HTMLElement {
        return Div {
            // Header with title
            If(title != nil) {
            Div {
            H3(title!)
            }
            .class("code-example-header")
            }
            
            // Description
            If(description != nil) {
            Div {
            P(description!)
            }
            .class("code-example-description")
            }
            
            // Code content
            Div {
            // Swift code section
            Div {
            H4("Swift Code")
            .style("font-size", "0.875rem")
            .style("text-transform", "uppercase")
            .style("letter-spacing", "0.05em")
            .style("color", "#6c757d")
            .style("margin-bottom", "0.75rem")
            Pre {
            Code(swift)
            }
            }
            .style("margin-bottom", "1.5rem")
            
            // Generated HTML section
            Div {
            H4("Generated HTML")
            .style("font-size", "0.875rem")
            .style("text-transform", "uppercase")
            .style("letter-spacing", "0.05em")
            .style("color", "#6c757d")
            .style("margin-bottom", "0.75rem")
            Pre {
            Code(html)
            }
            }
            }
            .class("code-example-content")
            
            // Live preview section
            Div {
            H4("Preview")
            .style("font-size", "0.875rem")
            .style("text-transform", "uppercase")
            .style("letter-spacing", "0.05em")
            .style("color", "#6c757d")
            .style("margin-bottom", "1rem")
            preview()
            }
            .class("preview-section")
        }
        .class("code-example")
    }
}

// Navigation card for showcase categories
public struct CategoryCard {
    let title: String
    let description: String
    let href: String
    let icon: String?
    
    public init(title: String, description: String, href: String, icon: String? = nil) {
        self.title = title
        self.description = description
        self.href = href
        self.icon = icon
    }
    
    public func render() -> any HTMLElement {
        return Link(href: href) {
            If(icon != nil) {
            Span(icon!)
            .class("category-icon")
            }
            H3(title)
            .class("category-title")
            P(description)
            .class("category-description")
        }
        .class("category-card")
    }
}