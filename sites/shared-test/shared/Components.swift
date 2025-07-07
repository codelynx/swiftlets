// Shared navigation component
public struct SharedNav: HTMLElement {
    public let activePage: String
    public var attributes = HTMLAttributes()
    
    public init(activePage: String = "") {
        self.activePage = activePage
    }
    
    public func render() -> String {
        Nav {
            Container(maxWidth: .xl) {
                HStack {
                    Link(href: "/") {
                        H1("Shared Components Demo")
                            .style("margin", "0")
                            .style("font-size", "1.5rem")
                    }
                    Spacer()
                    HStack(spacing: 20) {
                        navLink(href: "/", label: "Home", isActive: activePage == "home")
                        navLink(href: "/about", label: "About", isActive: activePage == "about")
                        navLink(href: "/contact", label: "Contact", isActive: activePage == "contact")
                    }
                }
                .style("align-items", "center")
            }
            .style("padding", "1rem 0")
        }
        .style("background", "#f8f9fa")
        .style("border-bottom", "1px solid #e2e8f0")
        .render()
    }
    
    @HTMLBuilder
    private func navLink(href: String, label: String, isActive: Bool) -> some HTMLElement {
        Link(href: href, label)
            .style("color", isActive ? "#0066cc" : "#333")
            .style("font-weight", isActive ? "600" : "400")
            .style("text-decoration", "none")
    }
}

// Shared footer component
public struct SharedFooter: HTMLElement {
    public var attributes = HTMLAttributes()
    
    public init() {}
    
    public func render() -> String {
        Footer {
            Container(maxWidth: .xl) {
                VStack(spacing: 20) {
                    HStack {
                        P("© 2025 Shared Components Demo")
                            .style("margin", "0")
                        Spacer()
                        HStack(spacing: 20) {
                            Link(href: "/privacy", "Privacy")
                            Link(href: "/terms", "Terms")
                        }
                    }
                    .style("align-items", "center")
                    
                    P("This site demonstrates shared components in Swiftlets")
                        .style("margin", "0")
                        .style("text-align", "center")
                        .style("color", "#666")
                        .style("font-size", "0.875rem")
                }
            }
            .style("padding", "2rem 0")
        }
        .style("background", "#f8f9fa")
        .style("border-top", "1px solid #e2e8f0")
        .render()
    }
}

// Shared layout wrapper
public struct PageLayout: HTMLElement {
    public let activePage: String
    public let content: HTMLElement
    public var attributes = HTMLAttributes()
    
    public init(activePage: String, @HTMLBuilder content: () -> HTMLElement) {
        self.activePage = activePage
        self.content = content()
    }
    
    public func render() -> String {
        Fragment {
            SharedNav(activePage: activePage)
            Main {
                Container(maxWidth: .large) {
                    content
                }
                .style("padding", "3rem 0")
            }
            SharedFooter()
        }
        .render()
    }
}