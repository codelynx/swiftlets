import Swiftlets

@main
struct SettingsCookiePage: SwiftletMain {
    @FormValue("theme") var newTheme: String?
    @Cookie("theme") var currentTheme: String?
    
    var title = "Settings"
    var meta = ["description": "User settings page with cookie handling"]
    
    var body: ResponseBuilder {
        // If we have a new theme, set the cookie
        if let newTheme = newTheme {
            return ResponseWith {
                Div {
                    H1("Settings Updated!")
                    P("Theme changed to: \(newTheme)")
                    Link(href: "/settings", "Go back")
                }
            }
            .cookie("theme", value: newTheme, maxAge: 86400, httpOnly: true)
        }
        
        // Otherwise show the form
        return ResponseWith {
            Div {
                H1("Settings")
                
                P("Current theme: \(currentTheme ?? "default")")
                
                Form(action: "/settings", method: "POST") {
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
}