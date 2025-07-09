import Swiftlets

@main
struct TestSimple: SwiftletMain {
    var title = "Test Simple"
    
    var body: some HTMLElement {
        Fragment {
            H1("Simple Test Page")
            P("This is a very simple test page.")
            Link(href: "/showcase", "Back to Showcase")
        }
    }
}