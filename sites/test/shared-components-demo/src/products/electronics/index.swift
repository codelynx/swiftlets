// Electronics category page - has access to all three levels of shared components

@main
struct ElectronicsPage: SwiftletMain {
    var title = "Electronics - Demo Store"
    
    var body: some HTMLElement {
        Fragment {
            siteHeader()  // From src/shared/
            
            Main {
                Container(maxWidth: .large) {
                    content()
                }
            }
            
            siteFooter()  // From src/shared/
        }
    }
    
    @HTMLBuilder
    func content() -> some HTMLElement {
        VStack(spacing: 20) {
            H1("Electronics")
                .style("margin", "2rem 0 1rem 0")
            
            productsNavigation(activeCategory: "electronics")  // From src/products/shared/
            
            // Category description
            categoryDescription()
            
            // Products grid
            productsGrid()
            
            // Sample spec table
            specTableSection()
        }
    }
    
    @HTMLBuilder
    func categoryDescription() -> some HTMLElement {
        Div {
            P("Discover the latest in technology and innovation")
                .style("font-size", "1.125rem")
                .style("color", "#666")
            warrantyBadge(years: 2)  // From src/products/electronics/shared/
        }
        .style("margin-bottom", "2rem")
    }
    
    @HTMLBuilder
    func productsGrid() -> some HTMLElement {
        Grid(columns: .count(2), spacing: 20) {
            productCard(
                name: "Smartphone X Pro",
                price: "$999",
                category: "Electronics",
                description: "Flagship phone with pro features"
            )
            
            productCard(
                name: "Laptop Ultra",
                price: "$1,599",
                category: "Electronics",
                description: "Ultra-thin powerhouse"
            )
            
            productCard(
                name: "Wireless Headphones",
                price: "$249",
                category: "Electronics",
                description: "Premium noise cancellation"
            )
            
            productCard(
                name: "Smart Watch",
                price: "$399",
                category: "Electronics",
                description: "Health and fitness tracking"
            )
        }
    }
    
    @HTMLBuilder
    func specTableSection() -> some HTMLElement {
        VStack(spacing: 10) {
            H3("Featured Product Specs")
            electronicsSpecTable(specs: [
                ("Display", "6.7\" OLED 120Hz"),
                ("Processor", "A17 Bionic"),
                ("RAM", "8GB"),
                ("Storage", "256GB")
            ])
        }
    }
}