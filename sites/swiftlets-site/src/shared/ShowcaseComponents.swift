// Modern showcase card component
@HTMLBuilder
func showcaseCard(
    title: String,
    description: String,
    href: String,
    icon: String? = nil,
    tags: [String] = []
) -> some HTMLElement {
    Link(href: href) {
        Div {
            If(icon != nil) {
                Div {
                    Text(icon!)
                }
                .class("showcase-card-icon")
            }
            
            H3(title)
            P(description)
            
            If(!tags.isEmpty) {
                Div {
                    ForEach(tags) { tag in
                        Span(tag)
                            .class("tag")
                    }
                }
                .style("margin-top", "1rem")
            }
        }
        .class("showcase-card animate-fadeIn")
    }
    .style("text-decoration", "none")
    .style("display", "block")
}

// Hero section component
@HTMLBuilder
func showcaseHero(
    title: String,
    subtitle: String? = nil,
    ctaText: String? = nil,
    ctaHref: String? = nil
) -> some HTMLElement {
    Section {
        Container(maxWidth: .large) {
            H1(title)
            If(subtitle != nil) {
                P(subtitle!)
            }
            If(ctaText != nil && ctaHref != nil) {
                Link(href: ctaHref!, ctaText!)
                    .class("btn-modern")
                    .style("margin-top", "2rem")
            }
        }
    }
    .class("showcase-hero")
}

// Code example component with preview
@HTMLBuilder
func codeExample(
    title: String,
    description: String? = nil,
    code: String,
    language: String = "swift"
) -> some HTMLElement {
    Div {
        Div {
            H3(title)
            If(description != nil) {
                P(description!)
                    .style("color", "#6c757d")
            }
        }
        .class("code-example-header")
        
        Pre {
            Code(code)
        }
        .class("language-\(language)")
    }
    .class("code-example")
}

// Live example with code and preview
@HTMLBuilder
func liveExample<Content: HTMLElement>(
    title: String,
    code: String,
    @HTMLBuilder preview: () -> Content
) -> some HTMLElement {
    Div {
        codeExample(title: title, code: code)
        
        Div {
            H4("Preview:")
                .style("margin-bottom", "1rem")
                .style("color", "#6c757d")
            preview()
        }
        .class("preview-box")
    }
}

// Feature section
@HTMLBuilder
func featureSection(
    title: String,
    description: String? = nil,
    @HTMLBuilder content: () -> some HTMLElement
) -> some HTMLElement {
    Section {
        Container(maxWidth: .large) {
            H2(title)
                .style("margin-bottom", "1rem")
            If(description != nil) {
                P(description!)
                    .style("font-size", "1.25rem")
                    .style("color", "#6c757d")
                    .style("margin-bottom", "2rem")
            }
            content()
        }
    }
    .class("showcase-section")
}

// Modern navigation for showcase
@HTMLBuilder
func showcaseNav() -> some HTMLElement {
    Nav {
        Container(maxWidth: .xl) {
            HStack {
                Link(href: "/", "Swiftlets")
                    .style("font-weight", "700")
                    .style("font-size", "1.25rem")
                
                Spacer()
                
                HStack(spacing: 10) {
                    Link(href: "/docs", "Documentation")
                    Link(href: "/showcase", "Showcase")
                        .class("active")
                    Link(href: "/about", "About")
                    Link(href: "https://github.com/swiftlets/swiftlets", "GitHub")
                        .attribute("target", "_blank")
                }
            }
            .style("align-items", "center")
            .style("padding", "1rem 0")
        }
    }
    .class("nav-modern")
}

// Footer component
@HTMLBuilder
func showcaseFooter() -> some HTMLElement {
    Footer {
        Container(maxWidth: .large) {
            HStack {
                P("© 2025 Swiftlets Project")
                    .style("color", "#6c757d")
                Spacer()
                HStack(spacing: 20) {
                    Link(href: "https://github.com/swiftlets/swiftlets", "GitHub")
                    Link(href: "/docs", "Docs")
                    Link(href: "/showcase", "Examples")
                }
                .style("gap", "1.5rem")
            }
            .style("align-items", "center")
        }
    }
    .style("padding", "3rem 0")
    .style("border-top", "1px solid #e9ecef")
    .style("margin-top", "5rem")
}