// Modern Navigation Component
// Note: Swiftlets types are available when compiled together
struct ModernNav: HTMLElement {
    let activePage: String
    var attributes = HTMLAttributes()
    
    init(activePage: String = "") {
        self.activePage = activePage
    }
    
    func render() -> String {
        Nav {
            Container(maxWidth: .xl) {
                HStack {
                    Link(href: "/") {
                        H1("Swiftlets")
                            .style("margin", "0")
                            .style("font-size", "1.75rem")
                            .style("background", "linear-gradient(135deg, #5B21B6, #EC4899)")
                            .style("-webkit-background-clip", "text")
                            .style("-webkit-text-fill-color", "transparent")
                    }
                    Spacer()
                    HStack(spacing: 8) {
                        navLink(href: "/docs", label: "Documentation", isActive: activePage == "docs")
                        navLink(href: "/showcase", label: "Showcase", isActive: activePage == "showcase")
                        navLink(href: "/about", label: "About", isActive: activePage == "about")
                        Link(href: "https://github.com/codelynx/swiftlets") {
                            Button("GitHub →")
                                .class("btn btn-ghost")
                        }
                        .attribute("target", "_blank")
                    }
                }
                .style("align-items", "center")
            }
            .style("padding", "1rem 0")
        }
        .class("nav-modern")
        .render()
    }
    
    @HTMLBuilder
    func navLink(href: String, label: String, isActive: Bool) -> some HTMLElement {
        Link(href: href, label)
            .class(isActive ? "nav-link active" : "nav-link")
    }
}

// Modern Footer Component
struct ModernFooter: HTMLElement {
    var attributes = HTMLAttributes()
    
    func render() -> String {
        Footer {
            Container(maxWidth: .xl) {
                VStack(spacing: 32) {
                    footerGrid()
                    footerBottom()
                }
            }
        }
        .style("background", "#18181B")
        .style("color", "#E4E4E7")
        .style("padding", "3rem 0 2rem")
        .render()
    }
    
    @HTMLBuilder
    func footerGrid() -> some HTMLElement {
        Grid(columns: .count(4), spacing: 40) {
            footerSection(
                title: "Product",
                links: [
                    ("Documentation", "/docs"),
                    ("Showcase", "/showcase"),
                    ("Examples", "/showcase")
                    // ("Tutorials", "/docs/tutorials") // TODO: Create tutorials
                ]
            )
            footerSection(
                title: "Resources",
                links: [
                    ("Getting Started", "/docs/getting-started"),
                    // ("API Reference", "/docs/api"), // TODO: Create API reference
                    // ("Best Practices", "/docs/best-practices"), // TODO: Create best practices guide
                    ("Troubleshooting", "/docs/troubleshooting")
                    // ("FAQ", "/docs/faq") // TODO: Create FAQ page
                ]
            )
            footerSection(
                title: "Community",
                links: [
                    ("GitHub", "https://github.com/codelynx/swiftlets"),
                    ("Discussions", "https://github.com/codelynx/swiftlets/discussions"),
                    ("Issues", "https://github.com/codelynx/swiftlets/issues"),
                    ("Contributing", "/docs/contributing")
                ]
            )
            
            VStack(spacing: 16) {
                H4("Swiftlets")
                    .style("color", "white")
                P("Modern web development with Swift")
                    .style("margin", "0")
                    .style("opacity", "0.7")
                    .style("font-size", "0.875rem")
                
                HStack(spacing: 12) {
                    socialIcon(href: "https://github.com/codelynx/swiftlets", icon: "GitHub")
                    socialIcon(href: "https://twitter.com/swiftlets", icon: "Twitter")
                }
            }
        }
    }
    
    @HTMLBuilder
    func footerSection(title: String, links: [(String, String)]) -> some HTMLElement {
        VStack(spacing: 16) {
            H4(title).style("color", "white")
            VStack(spacing: 8) {
                ForEach(links) { link in
                    Link(href: link.1, link.0)
                        .style("color", "#A1A1AA")
                        .style("font-size", "0.875rem")
                        .style("transition", "color 0.2s")
                        .attribute("target", link.1.starts(with: "http") ? "_blank" : "")
                }
            }
        }
    }
    
    @HTMLBuilder
    func socialIcon(href: String, icon: String) -> some HTMLElement {
        Link(href: href) {
            Div {
                Text(String(icon.first ?? "?"))
                    .style("color", "#A1A1AA")
            }
            .style("width", "36px")
            .style("height", "36px")
            .style("background", "#27272A")
            .style("border-radius", "50%")
            .style("display", "flex")
            .style("align-items", "center")
            .style("justify-content", "center")
            .style("transition", "all 0.2s")
        }
        .attribute("target", "_blank")
    }
    
    @HTMLBuilder
    func footerBottom() -> some HTMLElement {
        Div {
            HStack {
                P("© 2025 Swiftlets Project. All rights reserved.")
                    .style("margin", "0")
                    .style("opacity", "0.7")
                    .style("font-size", "0.875rem")
                Spacer()
                HStack(spacing: 20) {
                    // TODO: Add these pages
                    // Link(href: "/privacy", "Privacy")
                    //     .style("color", "#A1A1AA")
                    //     .style("font-size", "0.875rem")
                    // Link(href: "/terms", "Terms")
                    //     .style("color", "#A1A1AA")
                    //     .style("font-size", "0.875rem")
                    Link(href: "https://github.com/codelynx/swiftlets", "GitHub")
                        .style("color", "#A1A1AA")
                        .style("font-size", "0.875rem")
                        .attribute("target", "_blank")
                }
            }
        }
        .style("padding-top", "2rem")
        .style("border-top", "1px solid #3F3F46")
    }
}

// Modern Hero Component
struct ModernHero: HTMLElement {
    let title: String
    let subtitle: String
    let showButtons: Bool
    var attributes = HTMLAttributes()
    
    init(title: String, subtitle: String, showButtons: Bool = false) {
        self.title = title
        self.subtitle = subtitle
        self.showButtons = showButtons
    }
    
    func render() -> String {
        Section {
            Container(maxWidth: .large) {
                VStack(spacing: 32) {
                    VStack(spacing: 24) {
                        H1(title)
                            .style("font-size", "4rem")
                            .style("font-weight", "800")
                            .style("line-height", "1.1")
                            .style("margin", "0")
                            .class("text-gradient")
                        
                        P(subtitle)
                            .style("font-size", "1.5rem")
                            .style("color", "#71717A")
                            .style("max-width", "700px")
                            .style("margin", "0 auto")
                    }
                    .style("text-align", "center")
                    
                    If(showButtons) {
                        HStack(spacing: 16) {
                            Link(href: "/docs/getting-started") {
                                Button("Get Started →")
                                    .class("btn btn-primary")
                                    .style("padding", "1rem 2rem")
                                    .style("font-size", "1.125rem")
                            }
                            Link(href: "/showcase") {
                                Button("View Examples")
                                    .class("btn btn-secondary")
                                    .style("padding", "1rem 2rem")
                                    .style("font-size", "1.125rem")
                            }
                        }
                        .style("justify-content", "center")
                    }
                }
            }
        }
        .style("padding", "5rem 0")
        .style("background", "linear-gradient(to bottom, #FAFAFA, white)")
        .render()
    }
}

// Modern Card Component
struct ModernCard: HTMLElement {
    let title: String
    let description: String
    let icon: String?
    let href: String?
    var attributes = HTMLAttributes()
    
    init(title: String, description: String, icon: String? = nil, href: String? = nil) {
        self.title = title
        self.description = description
        self.icon = icon
        self.href = href
    }
    
    func render() -> String {
        let content = VStack(spacing: 20) {
            If(icon != nil) {
                Div {
                    Text(icon!)
                        .style("font-size", "3rem")
                }
                .style("text-align", "center")
            }
            
            VStack(spacing: 12) {
                H3(title)
                    .style("margin", "0")
                    .style("font-size", "1.5rem")
                
                P(description)
                    .style("margin", "0")
                    .style("color", "#71717A")
                    .style("line-height", "1.6")
            }
        }
        .class("card")
        .style("height", "100%")
        
        if let href = href {
            return Link(href: href) { content }
                .style("text-decoration", "none")
                .style("color", "inherit")
                .render()
        } else {
            return content.render()
        }
    }
}

// Section Header Component
struct SectionHeader: HTMLElement {
    let title: String
    let subtitle: String?
    var attributes = HTMLAttributes()
    
    init(title: String, subtitle: String? = nil) {
        self.title = title
        self.subtitle = subtitle
    }
    
    func render() -> String {
        VStack(spacing: 16) {
            H2(title)
                .style("text-align", "center")
                .style("font-size", "3rem")
                .style("font-weight", "700")
                .class("text-gradient")
            
            If(subtitle != nil) {
                P(subtitle!)
                    .style("text-align", "center")
                    .style("font-size", "1.25rem")
                    .style("color", "#71717A")
                    .style("max-width", "600px")
                    .style("margin", "0 auto")
            }
        }
        .style("margin-bottom", "3rem")
        .render()
    }
}