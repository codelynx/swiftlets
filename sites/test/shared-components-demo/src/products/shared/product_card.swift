// Product-level shared components available to all product pages

func productCard(name: String, price: String, category: String, description: String = "") -> some HTMLElement {
    Link(href: "#") {
        VStack(spacing: 10) {
            // Product category badge
            Text(category)
                .style("background", categoryColor(category))
                .style("color", "white")
                .style("padding", "0.25rem 0.5rem")
                .style("border-radius", "4px")
                .style("font-size", "0.875rem")
                .style("display", "inline-block")
            
            H3(name)
                .style("margin", "0")
                .style("color", "#333")
            
            Text(price)
                .style("font-size", "1.25rem")
                .style("font-weight", "bold")
                .style("color", "#0066cc")
            
            If(!description.isEmpty) {
                P(description)
                    .style("margin", "0")
                    .style("color", "#666")
                    .style("font-size", "0.875rem")
            }
        }
        .style("padding", "1.5rem")
        .style("background", "#fff")
        .style("border", "1px solid #e0e0e0")
        .style("border-radius", "8px")
        .style("transition", "transform 0.2s, box-shadow 0.2s")
        .style("display", "block")
    }
    .style("text-decoration", "none")
    .style("&:hover", "transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0,0,0,0.1);")
}

func categoryColor(_ category: String) -> String {
    switch category.lowercased() {
    case "electronics": return "#4CAF50"
    case "clothing": return "#2196F3"
    case "home": return "#FF9800"
    case "books": return "#9C27B0"
    default: return "#757575"
    }
}

func productsNavigation(activeCategory: String? = nil) -> some HTMLElement {
    Nav {
        HStack(spacing: 0) {
            categoryLink("All Products", href: "/products", active: activeCategory == nil)
            categoryLink("Electronics", href: "/products/electronics", active: activeCategory == "electronics")
            categoryLink("Clothing", href: "/products/clothing", active: activeCategory == "clothing")
        }
        .style("border-bottom", "2px solid #e0e0e0")
        .style("margin-bottom", "2rem")
    }
}

func categoryLink(_ text: String, href: String, active: Bool) -> some HTMLElement {
    Link(href: href) {
        Text(text)
            .style("padding", "1rem 1.5rem")
            .style("display", "inline-block")
            .style("border-bottom", active ? "2px solid #0066cc" : "2px solid transparent")
            .style("margin-bottom", "-2px")
            .style("color", active ? "#0066cc" : "#666")
            .style("font-weight", active ? "600" : "400")
    }
    .style("text-decoration", "none")
    .style("&:hover", "color: #0066cc;")
}