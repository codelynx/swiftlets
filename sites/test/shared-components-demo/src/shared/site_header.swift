// Global site header component available to all pages

func siteHeader() -> some HTMLElement {
    Header {
        Nav {
            Container(maxWidth: .xl) {
                HStack {
                    Link(href: "/") {
                        H1("Demo Store")
                            .style("margin", "0")
                            .style("font-size", "1.5rem")
                    }
                    .style("text-decoration", "none")
                    .style("color", "inherit")
                    
                    Spacer()
                    
                    HStack(spacing: 20) {
                        Link(href: "/products") { Text("Products") }
                        Link(href: "/products/electronics") { Text("Electronics") }
                        Link(href: "/products/clothing") { Text("Clothing") }
                        Link(href: "/about") { Text("About") }
                    }
                    .style("a", "text-decoration: none; color: #0066cc;")
                }
                .style("padding", "1rem 0")
            }
        }
        .style("background", "#f8f9fa")
        .style("border-bottom", "1px solid #ddd")
    }
}

func siteFooter() -> some HTMLElement {
    Footer {
        Container(maxWidth: .xl) {
            HStack {
                Text("© 2025 Demo Store")
                    .style("color", "#666")
                Spacer()
                Text("Built with Swiftlets")
                    .style("color", "#666")
            }
            .style("padding", "2rem 0")
        }
    }
    .style("background", "#f8f9fa")
    .style("border-top", "1px solid #ddd")
    .style("margin-top", "3rem")
}