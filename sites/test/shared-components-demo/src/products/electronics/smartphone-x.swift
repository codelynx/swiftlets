// Specific product page - demonstrates access to all levels of shared components

@main
struct SmartphoneXPage: SwiftletMain {
    var title = "Smartphone X - Electronics - Demo Store"
    
    var body: some HTMLElement {
        Fragment {
            siteHeader()  // From src/shared/
            
            Main {
                Container(maxWidth: .large) {
                    // Breadcrumb
                    Nav {
                        HStack(spacing: 10) {
                            Link(href: "/") { Text("Home") }
                            Text("/")
                            Link(href: "/products") { Text("Products") }
                            Text("/")
                            Link(href: "/products/electronics") { Text("Electronics") }
                            Text("/")
                            Text("Smartphone X")
                                .style("color", "#666")
                        }
                        .style("a", "text-decoration: none; color: #0066cc;")
                        .style("margin", "1rem 0")
                    }
                    
                    Grid(columns: .count(2), spacing: 40) {
                        // Left column - Product image placeholder
                        Div {
                            Div {
                                Text("Product Image")
                                    .style("color", "#999")
                            }
                            .style("background", "#f0f0f0")
                            .style("height", "400px")
                            .style("display", "flex")
                            .style("align-items", "center")
                            .style("justify-content", "center")
                            .style("border-radius", "8px")
                        }
                        
                        // Right column - Product details
                        VStack(spacing: 20) {
                            H1("Smartphone X")
                                .style("margin", "0")
                            
                            Text("$699")
                                .style("font-size", "2rem")
                                .style("font-weight", "bold")
                                .style("color", "#0066cc")
                            
                            warrantyBadge(years: 2)  // From electronics/shared/
                            
                            P("Experience the future of mobile technology with Smartphone X. Featuring cutting-edge performance, stunning display, and revolutionary camera system.")
                            
                            // Using electronics-specific spec table
                            H3("Technical Specifications")
                            electronicsSpecTable(specs: [
                                ("Display", "6.5\" Super AMOLED"),
                                ("Processor", "Octa-core 3.0 GHz"),
                                ("RAM", "6GB"),
                                ("Storage", "128GB (expandable)"),
                                ("Camera", "48MP + 12MP + 5MP"),
                                ("Battery", "4500 mAh"),
                                ("5G", "Yes"),
                                ("Water Resistance", "IP68")
                            ])
                            
                            // Add to cart button
                            Button {
                                Text("Add to Cart")
                            }
                            .style("background", "#4CAF50")
                            .style("color", "white")
                            .style("padding", "1rem 2rem")
                            .style("border", "none")
                            .style("border-radius", "4px")
                            .style("font-size", "1.125rem")
                            .style("cursor", "pointer")
                            .style("&:hover", "background: #45a049;")
                        }
                    }
                    
                    // Related products section
                    VStack(spacing: 20) {
                        H2("Related Products")
                            .style("margin-top", "3rem")
                        
                        Grid(columns: .count(3), spacing: 20) {
                            productCard(
                                name: "Phone Case Pro",
                                price: "$29",
                                category: "Electronics",
                                description: "Premium protection"
                            )
                            
                            productCard(
                                name: "Wireless Charger",
                                price: "$49",
                                category: "Electronics",
                                description: "Fast charging pad"
                            )
                            
                            productCard(
                                name: "Screen Protector",
                                price: "$19",
                                category: "Electronics",
                                description: "Crystal clear protection"
                            )
                        }
                    }
                }
            }
            
            siteFooter()  // From src/shared/
        }
    }
}