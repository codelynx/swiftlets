// Note: In real implementation, we'd have:
// import Swiftlets
// import SimpleComponents

@main
struct HomePage: SwiftletMain {
    var title = "Module POC - Home"
    
    var body: some HTMLElement {
        Fragment {
            sharedHeader(title: "Welcome to Module POC")
            
            Main {
                Container(maxWidth: .medium) {
                    VStack(spacing: 20) {
                        P("This page demonstrates using shared components via Swift modules.")
                            .style("font-size", "1.2rem")
                        
                        P("The header and footer are imported from SimpleComponents module.")
                        
                        Link(href: "/about", "Go to About Page →")
                            .style("color", "#0066cc")
                    }
                }
                .style("padding", "2rem 0")
                .style("min-height", "400px")
            }
            
            SharedFooter()
        }
    }
}