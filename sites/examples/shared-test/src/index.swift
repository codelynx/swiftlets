@main
struct HomePage: SwiftletMain {
    var title = "Home - Shared Components Demo"
    
    var body: some HTMLElement {
        PageLayout(activePage: "home") {
            VStack(spacing: 32) {
                H1("Welcome to Shared Components Demo")
                
                P("This page demonstrates how Swiftlets can use shared components across multiple pages.")
                    .style("font-size", "1.25rem")
                    .style("color", "#666")
                
                Div {
                    H2("Benefits of Shared Components")
                    UL {
                        LI("Code reuse across pages")
                        LI("Consistent UI elements")
                        LI("Easier maintenance")
                        LI("Smaller binary sizes")
                    }
                }
                .style("background", "#f8f9fa")
                .style("padding", "2rem")
                .style("border-radius", "8px")
                
                P("Navigate to other pages to see the same navigation and footer components in use.")
            }
        }
    }
}