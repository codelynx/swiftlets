// Blue Bottle Coffee page - uses components from all levels

@main
struct BlueCafePage: SwiftletMain {
    var title = "Blue Bottle Coffee - Shibuya, Tokyo"
    
    var body: some HTMLElement {
        Fragment {
            globalNav()  // From src/shared/
            
            Main {
                Container(maxWidth: .large) {
                    // Breadcrumb
                    HStack(spacing: 10) {
                        Link(href: "/", "Home")
                        Text("›")
                        Link(href: "/japan", "Japan")
                        Text("›")
                        Link(href: "/japan/tokyo", "Tokyo")
                        Text("›")
                        Link(href: "/japan/tokyo/shibuya", "Shibuya")
                        Text("›")
                        Text("Blue Bottle Coffee")
                    }
                    .style("color", "#666")
                    .style("margin", "1rem 0")
                    
                    H1("Blue Bottle Coffee Shibuya")
                    
                    // Using japan-level component
                    japanMenu()
                    
                    // Using tokyo-level component
                    tokyoDistrictMenu()
                    
                    // Page specific content
                    VStack(spacing: 30) {
                        cafeInfo()
                        menuSection()
                        locationSection()
                    }
                    
                    // Using tokyo-level component
                    tokyoTransportInfo()
                }
            }
            
            globalFooter()  // From src/shared/
        }
    }
    
    func cafeInfo() -> some HTMLElement {
        VStack(spacing: 20) {
            Img(src: "/images/blue-bottle-shibuya.jpg", alt: "Blue Bottle Coffee Shibuya")
                .style("width", "100%")
                .style("height", "400px")
                .style("object-fit", "cover")
                .style("border-radius", "8px")
            
            P("Experience artisanal coffee culture in the heart of Shibuya. Our minimalist space offers a peaceful retreat from the bustling streets outside.")
                .style("font-size", "1.2rem")
                .style("line-height", "1.6")
            
            // Using japan-level component
            japanInfoBox(
                title: "Opening Hours",
                content: "Daily 8:00 AM - 7:00 PM"
            )
        }
    }
    
    func menuSection() -> some HTMLElement {
        VStack(spacing: 15) {
            H2("Popular Menu Items")
            
            Grid(columns: .count(2), spacing: 20) {
                menuItem("Drip Coffee", 500)
                menuItem("Cappuccino", 600)
                menuItem("Gibraltar", 650)
                menuItem("New Orleans Iced Coffee", 700)
            }
        }
    }
    
    func menuItem(_ name: String, _ price: Int) -> some HTMLElement {
        HStack {
            Text(name)
            Spacer()
            yenPrice(price)  // Using japan-level component
        }
        .style("padding", "1rem")
        .style("background", "#f8f9fa")
        .style("border-radius", "4px")
    }
    
    func locationSection() -> some HTMLElement {
        VStack(spacing: 15) {
            H3("Location")
            
            P("〒150-0042 Tokyo, Shibuya City, Udagawacho, 23-5")
                .style("color", "#666")
            
            P("5-minute walk from Shibuya Station (Hachiko Exit)")
                .style("color", "#666")
                .style("font-style", "italic")
        }
    }
}