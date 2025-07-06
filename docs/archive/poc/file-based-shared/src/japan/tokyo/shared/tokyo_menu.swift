// Tokyo-specific shared components - available to all pages under japan/tokyo/

func tokyoDistrictMenu() -> some HTMLElement {
    Div {
        H4("Tokyo Districts")
            .style("margin", "0 0 1rem 0")
        
        Grid(columns: .count(3), spacing: 10) {
            districtLink("Shibuya", "/japan/tokyo/shibuya", "🌆")
            districtLink("Shinjuku", "/japan/tokyo/shinjuku", "🏙️")
            districtLink("Harajuku", "/japan/tokyo/harajuku", "🛍️")
            districtLink("Asakusa", "/japan/tokyo/asakusa", "⛩️")
            districtLink("Ginza", "/japan/tokyo/ginza", "💎")
            districtLink("Roppongi", "/japan/tokyo/roppongi", "🌃")
        }
    }
    .style("background", "#f0f4ff")
    .style("padding", "1.5rem")
    .style("border-radius", "8px")
    .style("margin", "1rem 0")
}

func districtLink(_ name: String, _ href: String, _ emoji: String) -> some HTMLElement {
    Link(href: href) {
        VStack(spacing: 5) {
            Text(emoji).style("font-size", "2rem")
            Text(name).style("color", "#333")
        }
        .style("text-align", "center")
    }
    .style("text-decoration", "none")
    .style("padding", "1rem")
    .style("background", "white")
    .style("border-radius", "8px")
    .style("transition", "transform 0.2s")
    .class("district-card")
}

func tokyoTransportInfo() -> some HTMLElement {
    Div {
        H5("Getting Around Tokyo")
            .style("margin", "0 0 0.5rem 0")
        UL {
            LI("JR Yamanote Line - Circle line connecting major districts")
            LI("Tokyo Metro - Extensive subway network")
            LI("Toei Subway - Additional subway lines")
        }
        .style("margin", "0")
        .style("padding-left", "1.5rem")
        .style("color", "#666")
    }
    .style("background", "#e3f2fd")
    .style("padding", "1rem")
    .style("border-radius", "4px")
    .style("font-size", "0.9rem")
}