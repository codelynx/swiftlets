// Japan-wide shared components - available to all pages under japan/

func japanMenu() -> some HTMLElement {
    Div {
        H3("Explore Japan")
            .style("color", "#d32f2f")  // Japanese red
        
        HStack(spacing: 15) {
            Link(href: "/japan", "Overview")
                .style("color", "#666")
            Text("•").style("color", "#ccc")
            Link(href: "/japan/tokyo", "Tokyo")
                .style("color", "#666")
            Text("•").style("color", "#ccc")
            Link(href: "/japan/osaka", "Osaka")
                .style("color", "#666")
            Text("•").style("color", "#ccc")
            Link(href: "/japan/kyoto", "Kyoto")
                .style("color", "#666")
        }
    }
    .style("background", "#fff5f5")
    .style("padding", "1rem")
    .style("border-radius", "8px")
    .style("margin", "1rem 0")
}

func japanInfoBox(title: String, content: String) -> some HTMLElement {
    Div {
        H4(title)
            .style("margin", "0 0 0.5rem 0")
            .style("color", "#d32f2f")
        P(content)
            .style("margin", "0")
            .style("color", "#666")
    }
    .style("background", "#fff")
    .style("border", "1px solid #ffebee")
    .style("padding", "1rem")
    .style("border-radius", "4px")
}

// Japan-specific currency formatter
func yenPrice(_ amount: Int) -> some HTMLElement {
    Span("¥\(amount.formatted())")
        .style("font-weight", "bold")
        .style("color", "#d32f2f")
}