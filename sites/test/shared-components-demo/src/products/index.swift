// Products index - has access to global and products shared components

@main
struct ProductsPage: SwiftletMain {
    var title = "All Products - Demo Store"
    
    var body: some HTMLElement {
        Fragment {
            siteHeader()  // From src/shared/
            
            Main {
                Container(maxWidth: .large) {
                    H1("All Products")
                        .style("margin", "2rem 0 1rem 0")
                    
                    productsNavigation()  // From src/products/shared/
                    
                    // Featured products grid
                    Grid(columns: .count(3), spacing: 20) {
                        // Electronics
                        productCard(
                            name: "Smartphone X",
                            price: "$699",
                            category: "Electronics",
                            description: "Latest flagship with amazing camera"
                        )
                        
                        productCard(
                            name: "Laptop Pro",
                            price: "$1,299",
                            category: "Electronics",
                            description: "Powerful laptop for professionals"
                        )
                        
                        // Clothing
                        productCard(
                            name: "Classic T-Shirt",
                            price: "$29",
                            category: "Clothing",
                            description: "100% cotton comfort"
                        )
                        
                        productCard(
                            name: "Denim Jeans",
                            price: "$79",
                            category: "Clothing",
                            description: "Premium quality denim"
                        )
                        
                        // Home
                        productCard(
                            name: "Coffee Maker",
                            price: "$149",
                            category: "Home",
                            description: "Start your day right"
                        )
                        
                        productCard(
                            name: "Desk Lamp",
                            price: "$59",
                            category: "Home",
                            description: "LED lighting for your workspace"
                        )
                    }
                    
                    // Note: Cannot use electronicsSpecTable() or warrantyBadge() here
                    // They are in products/electronics/shared/ which is not in scope
                }
            }
            
            siteFooter()  // From src/shared/
        }
    }
}