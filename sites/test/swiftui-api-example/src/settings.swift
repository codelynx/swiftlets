import Swiftlets

@main
struct SettingsPage: SwiftletMain {
    @Cookie("theme") var currentTheme: String?
    
    var title = "Settings"
    var meta = ["description": "User settings page"]
    
    var body: some HTMLElement {
        Div {
            H1("Settings")
            
            P("Current theme: \(currentTheme ?? "default")")
            
            Form(action: "/settings-cookie", method: "POST") {
                Label("Choose theme:")
                Select(name: "theme") {
                    Option("Light", value: "light", selected: currentTheme == "light")
                    Option("Dark", value: "dark", selected: currentTheme == "dark")
                    Option("Auto", value: "auto", selected: currentTheme == "auto")
                }
                
                Button("Save Settings", type: "submit")
            }
        }
    }
}