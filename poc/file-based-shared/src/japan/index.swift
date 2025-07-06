// Japan overview page - only has access to japan/shared and global shared

@main
struct JapanPage: SwiftletMain {
    var title = "Travel Japan - Discover the Land of the Rising Sun"
    
    var body: some HTMLElement {
        Fragment {
            globalNav()  // From src/shared/
            
            Main {
                Container(maxWidth: .large) {
                    H1("Discover Japan")
                        .style("text-align", "center")
                        .style("margin", "2rem 0")
                    
                    // Using japan-level component
                    japanMenu()
                    
                    // Page content
                    VStack(spacing: 30) {
                        P("From ancient temples to modern skyscrapers, Japan offers a unique blend of tradition and innovation.")
                            .style("font-size", "1.2rem")
                            .style("text-align", "center")
                        
                        Grid(columns: .count(3), spacing: 20) {
                            cityCard("Tokyo", "Modern metropolis", "/japan/tokyo")
                            cityCard("Kyoto", "Ancient capital", "/japan/kyoto")
                            cityCard("Osaka", "Food paradise", "/japan/osaka")
                        }
                        
                        // Using japan-level components
                        japanInfoBox(
                            title: "Best Time to Visit",
                            content: "Spring (March-May) for cherry blossoms, Autumn (September-November) for fall colors"
                        )
                        
                        japanInfoBox(
                            title: "Currency",
                            content: "Japanese Yen (¥) - Credit cards accepted in major cities"
                        )
                    }
                    
                    // Note: Cannot use tokyoDistrictMenu() here - not in scope!
                    // This would cause compilation error
                }
            }
            
            globalFooter()  // From src/shared/
        }
    }
    
    func cityCard(_ name: String, _ description: String, _ href: String) -> some HTMLElement {
        Link(href: href) {
            VStack(spacing: 10) {
                H3(name).style("margin", "0")
                P(description)
                    .style("margin", "0")
                    .style("color", "#666")
            }
            .style("padding", "2rem")
            .style("background", "#f8f9fa")
            .style("border-radius", "8px")
            .style("text-align", "center")
        }
        .style("text-decoration", "none")
        .style("color", "inherit")
    }
}