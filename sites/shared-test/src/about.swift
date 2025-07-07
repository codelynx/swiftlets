@main
struct AboutPage: SwiftletMain {
    var title = "About - Shared Components Demo"
    
    var body: some HTMLElement {
        PageLayout(activePage: "about") {
            VStack(spacing: 24) {
                H1("About This Demo")
                
                P("This page uses the same SharedNav and SharedFooter components as the home page.")
                
                H2("How It Works")
                
                P("The shared components are compiled into a dynamic library that each page links against.")
                
                Pre {
                    Code("""
                    // shared/Components.swift
                    public struct SharedNav: HTMLElement { ... }
                    
                    // src/about.swift
                    PageLayout(activePage: "about") {
                        // Page content here
                    }
                    """)
                }
                .style("background", "#f8f9fa")
                .style("padding", "1rem")
                .style("border-radius", "4px")
                .style("overflow-x", "auto")
            }
        }
    }
}