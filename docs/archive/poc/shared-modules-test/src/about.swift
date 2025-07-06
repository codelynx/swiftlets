import Swiftlets
import SimpleComponents

@main
struct AboutPage: SwiftletMain {
    var title = "Module POC - About"
    
    var body: some HTMLElement {
        Fragment {
            sharedHeader(title: "About This POC")
            
            Main {
                Container(maxWidth: .medium) {
                    VStack(spacing: 20) {
                        P("This page also uses the same shared components.")
                        
                        P("Both pages import SimpleComponents module for consistent UI.")
                        
                        Link(href: "/", "← Back to Home")
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