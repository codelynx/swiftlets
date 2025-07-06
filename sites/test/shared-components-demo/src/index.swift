// Home page - only has access to global shared components

@main
struct HomePage: SwiftletMain {
    var title = "Demo Store - Home"
    
    var body: some HTMLElement {
        Fragment {
            siteHeader()  // From src/shared/
            
            Main {
                Container(maxWidth: .large) {
                    VStack(spacing: 30) {
                        // Hero section
                        VStack(spacing: 20) {
                            H1("Welcome to Demo Store")
                                .style("text-align", "center")
                                .style("font-size", "3rem")
                                .style("margin", "2rem 0")
                            
                            P("Discover amazing products across multiple categories")
                                .style("text-align", "center")
                                .style("font-size", "1.25rem")
                                .style("color", "#666")
                        }
                        
                        // Categories grid
                        H2("Shop by Category")
                        Grid(columns: .count(3), spacing: 20) {
                            categoryCard("Electronics", "Latest gadgets and devices", "/products/electronics")
                            categoryCard("Clothing", "Fashion for everyone", "/products/clothing") 
                            categoryCard("Home & Garden", "Everything for your home", "/products/home")
                        }
                        
                        // Note: Cannot use productCard() or productsNavigation() here
                        // They are not in scope for the home page
                    }
                }
            }
            
            siteFooter()  // From src/shared/
        }
    }
    
    func categoryCard(_ title: String, _ description: String, _ href: String) -> some HTMLElement {
        Link(href: href) {
            VStack(spacing: 10) {
                H3(title)
                    .style("margin", "0")
                P(description)
                    .style("margin", "0")
                    .style("color", "#666")
            }
            .style("padding", "2rem")
            .style("background", "#f8f9fa")
            .style("border-radius", "8px")
            .style("text-align", "center")
            .style("transition", "background 0.2s")
        }
        .style("text-decoration", "none")
        .style("color", "inherit")
        .style("&:hover", "background: #e9ecef;")
    }
}