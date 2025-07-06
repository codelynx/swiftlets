// Global navigation component - available to all pages

func globalNav() -> some HTMLElement {
    Nav {
        Container(maxWidth: .xl) {
            HStack {
                Link(href: "/") {
                    H1("Travel Site")
                        .style("margin", "0")
                        .style("font-size", "1.5rem")
                }
                Spacer()
                HStack(spacing: 20) {
                    Link(href: "/", "Home")
                    Link(href: "/japan", "Japan")
                    Link(href: "/korea", "Korea") 
                    Link(href: "/about", "About")
                }
            }
        }
    }
    .style("background", "#f8f9fa")
    .style("padding", "1rem 0")
    .style("border-bottom", "1px solid #dee2e6")
}

func globalFooter() -> some HTMLElement {
    Footer {
        Container(maxWidth: .xl) {
            P("© 2025 Travel Site - Explore Asia")
                .style("text-align", "center")
                .style("color", "#666")
        }
    }
    .style("padding", "2rem 0")
    .style("background", "#f8f9fa")
    .style("margin-top", "3rem")
}