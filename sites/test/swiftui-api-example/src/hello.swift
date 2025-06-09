import Swiftlets

@main
struct HelloPage: SwiftletMain {
    @Query("name") var userName: String?
    @Cookie("theme") var theme: String?
    
    var title = "Hello SwiftUI API"
    var meta = ["description": "Testing the new SwiftUI-style API"]
    
    var body: some HTMLElement {
        Div {
            H1("Hello, \(userName ?? "World")!")
            
            if let theme = theme {
                P("Your theme preference is: \(theme)")
            } else {
                EmptyHTML()
            }
            
            Form(action: "/hello", method: "GET") {
                Label("Enter your name:")
                Input(type: "text", name: "name", value: userName ?? "")
                Button("Submit", type: "submit")
            }
        }
        .classes("container")
    }
}