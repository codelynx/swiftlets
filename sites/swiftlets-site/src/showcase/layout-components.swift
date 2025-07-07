import Swiftlets

@main
struct LayoutShowcase: SwiftletMain {
    var title = "Layout Components - Swiftlets Showcase"
    
    var body: some HTMLElement {
        Fragment {
            showcaseStyles()
            layoutStyles()
            navigation()
            header()
            mainContent()
        }
    }
    
    @HTMLBuilder
    func layoutStyles() -> some HTMLElement {
        Style("""
        /* Layout-specific styles */
        .layout-demo {
            border: 2px dashed #dee2e6;
            border-radius: 0.5rem;
            padding: 1rem;
            background: #f8f9fa;
        }
        
        .layout-item {
            padding: 1rem;
            text-align: center;
            background: white;
            border: 1px solid #e9ecef;
            border-radius: 0.375rem;
        }
        
        .stat-card {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 1.5rem;
            border-radius: 0.75rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            transition: transform 0.2s;
        }
        
        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        
        .dashboard-card {
            background: white;
            border: 1px solid #e9ecef;
            border-radius: 0.5rem;
            padding: 1.5rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }
        
        .activity-item {
            padding: 0.75rem;
            background: #f8f9fa;
            border-radius: 0.375rem;
            border-left: 3px solid #28a745;
            margin-bottom: 0.5rem;
        }
        
        .hero-overlay {
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.9) 0%, rgba(118, 75, 162, 0.9) 100%);
        }
        """)
    }
    
    @HTMLBuilder
    func navigation() -> some HTMLElement {
        Div {
            Div {
                Link(href: "/", "Swiftlets")
                    .class("nav-brand")
                Div {
                    Link(href: "/docs", "Documentation")
                    Link(href: "/showcase", "Showcase")
                        .class("active")
                    Link(href: "/about", "About")
                }
                .class("nav-links")
            }
            .class("nav-content")
        }
        .class("nav-container")
    }
    
    @HTMLBuilder
    func header() -> some HTMLElement {
        Div {
            Div {
                H1("Layout Components")
                P("SwiftUI-inspired layout components for building modern, responsive web interfaces")
            }
            .class("showcase-container")
        }
        .class("showcase-header")
    }
    
    @HTMLBuilder
    func mainContent() -> some HTMLElement {
        Div {
            // Breadcrumb
            Div {
                Link(href: "/showcase", "← Back to Showcase")
            }
            .style("margin-bottom", "2rem")
            
            hstackSection()
            vstackSection()
            zstackSection()
            gridSection()
            containerSection()
            spacerSection()
            complexLayoutSection()
            
            // Navigation links
            Div {
                Link(href: "/showcase/media-elements", "Media Elements")
                    .class("nav-button")
                Link(href: "/showcase", "Back to Showcase")
                    .class("nav-button nav-button-next")
            }
            .class("navigation-links")
        }
        .class("showcase-container")
    }
    
    @HTMLBuilder
    func hstackSection() -> some HTMLElement {
        CodeExample(
            title: "HStack - Horizontal Stack",
            swift: """
            // Basic HStack
            HStack {
                Button("Previous")
                Button("Next")
            }
            
            // With spacing and alignment
            HStack(alignment: .center, spacing: 20) {
                Img(src: "/icon.png", alt: "Icon")
                    .style("width", "40px")
                    .style("height", "40px")
                Text("User Profile")
                Spacer()
                Button("Edit")
            }
            
            // Different alignments
            HStack(alignment: .top, spacing: 16) {
                Div { Text("Tall Box") }.style("height", "100px")
                Div { Text("Short Box") }.style("height", "60px")
                Div { Text("Medium Box") }.style("height", "80px")
            }
            """,
            html: """
            <div style="display: flex; flex-direction: row; align-items: center;">
                <button>Previous</button>
                <button>Next</button>
            </div>
            
            <!-- With spacing and alignment -->
            <div style="display: flex; flex-direction: row; align-items: center; gap: 20px;">
                <img src="/icon.png" alt="Icon" style="width: 40px; height: 40px;">
                User Profile
                <div style="flex: 1;"></div>
                <button>Edit</button>
            </div>
            """,
            preview: {
                VStack(spacing: 24) {
                    // Basic HStack
                    Div {
                        P("Basic HStack:")
                            .style("margin-bottom", "0.75rem")
                            .style("font-weight", "500")
                            .style("color", "#6c757d")
                        HStack(spacing: 12) {
                            Button("← Previous")
                                .class("btn-modern")
                            Button("Next →")
                                .class("btn-modern")
                        }
                    }
                    
                    // With spacing and Spacer
                    Div {
                        P("Profile bar with Spacer:")
                            .style("margin-bottom", "0.75rem")
                            .style("font-weight", "500")
                            .style("color", "#6c757d")
                        HStack(alignment: .center, spacing: 16) {
                            Div {
                                Text("👤")
                                    .style("font-size", "2rem")
                            }
                            .style("width", "48px")
                            .style("height", "48px")
                            .style("background", "linear-gradient(135deg, #667eea 0%, #764ba2 100%)")
                            .style("border-radius", "50%")
                            .style("display", "flex")
                            .style("align-items", "center")
                            .style("justify-content", "center")
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("John Doe")
                                    .style("font-weight", "600")
                                    .style("color", "#2c3e50")
                                Text("Premium Member")
                                    .style("font-size", "0.875rem")
                                    .style("color", "#6c757d")
                            }
                            
                            Spacer()
                            
                            Button("Edit Profile")
                                .style("padding", "0.5rem 1rem")
                                .style("background", "transparent")
                                .style("color", "#667eea")
                                .style("border", "2px solid #667eea")
                                .style("border-radius", "0.375rem")
                                .style("font-weight", "500")
                                .style("transition", "all 0.2s")
                        }
                        .class("dashboard-card")
                    }
                    
                    // Different alignments
                    Div {
                        P("Alignment variations:")
                            .style("margin-bottom", "0.75rem")
                            .style("font-weight", "500")
                            .style("color", "#6c757d")
                        VStack(spacing: 16) {
                            ForEach([("top", "flex-start"), ("center", "center"), ("bottom", "flex-end")]) { align, css in
                                Div {
                                    P("alignment: .\(align)")
                                        .style("font-size", "0.75rem")
                                        .style("color", "#6c757d")
                                        .style("margin-bottom", "0.5rem")
                                    HStack(alignment: align == "top" ? .top : align == "center" ? .center : .bottom, spacing: 12) {
                                        Div { Text("100px") }
                                            .style("height", "100px")
                                            .style("background", "linear-gradient(135deg, #667eea 0%, #764ba2 100%)")
                                            .style("color", "white")
                                            .style("padding", "1rem")
                                            .style("border-radius", "0.5rem")
                                            .style("display", "flex")
                                            .style("align-items", "center")
                                            .style("justify-content", "center")
                                        
                                        Div { Text("60px") }
                                            .style("height", "60px")
                                            .style("background", "linear-gradient(135deg, #f093fb 0%, #f5576c 100%)")
                                            .style("color", "white")
                                            .style("padding", "1rem")
                                            .style("border-radius", "0.5rem")
                                            .style("display", "flex")
                                            .style("align-items", "center")
                                            .style("justify-content", "center")
                                        
                                        Div { Text("80px") }
                                            .style("height", "80px")
                                            .style("background", "linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)")
                                            .style("color", "white")
                                            .style("padding", "1rem")
                                            .style("border-radius", "0.5rem")
                                            .style("display", "flex")
                                            .style("align-items", "center")
                                            .style("justify-content", "center")
                                    }
                                }
                                .class("layout-demo")
                            }
                        }
                    }
                }
            },
            description: "Arrange elements horizontally with customizable alignment and spacing."
        ).render()
    }
    
    @HTMLBuilder
    func vstackSection() -> some HTMLElement {
        CodeExample(
            title: "VStack - Vertical Stack",
            swift: """
            // Basic VStack
            VStack {
                H3("Settings")
                P("Configure your preferences")
            }
            
            // Form with VStack
            VStack(alignment: .leading, spacing: 16) {
                Label("Username")
                Input(type: "text", name: "username")
                Label("Email")
                Input(type: "email", name: "email")
                Button("Save Changes")
            }
            
            // Card with centered content
            VStack(alignment: .center, spacing: 24) {
                Img(src: "/logo.png", alt: "Logo")
                H2("Welcome Back!")
                P("Sign in to continue")
                Button("Sign In")
            }
            """,
            html: """
            <div style="display: flex; flex-direction: column;">
                <h3>Settings</h3>
                <p>Configure your preferences</p>
            </div>
            
            <!-- Form with VStack -->
            <div style="display: flex; flex-direction: column; align-items: flex-start; gap: 16px;">
                <label>Username</label>
                <input type="text" name="username">
                <label>Email</label>
                <input type="email" name="email">
                <button>Save Changes</button>
            </div>
            """,
            preview: {
                HStack(spacing: 24) {
                    // Settings card
                    Div {
                        VStack(alignment: .leading, spacing: 12) {
                            H3("Settings")
                                .style("margin", "0")
                                .style("color", "#2c3e50")
                            P("Configure your preferences below")
                                .style("margin", "0")
                                .style("color", "#6c757d")
                            
                            VStack(spacing: 8) {
                                ForEach(["Notifications", "Privacy", "Security"]) { setting in
                                    HStack {
                                        Text(setting)
                                        Spacer()
                                        Text("→")
                                            .style("color", "#6c757d")
                                    }
                                    .style("padding", "0.75rem")
                                    .style("background", "#f8f9fa")
                                    .style("border-radius", "0.375rem")
                                    .style("cursor", "pointer")
                                    .style("transition", "background 0.2s")
                                }
                            }
                        }
                        .class("dashboard-card")
                    }
                    .style("flex", "1")
                    
                    // Sign in card
                    Div {
                        VStack(alignment: .center, spacing: 20) {
                            Div {
                                Text("🔐")
                                    .style("font-size", "3rem")
                            }
                            H3("Welcome Back!")
                                .style("margin", "0")
                                .style("color", "#2c3e50")
                            P("Sign in to continue to your dashboard")
                                .style("margin", "0")
                                .style("color", "#6c757d")
                                .style("text-align", "center")
                            
                            VStack(spacing: 12) {
                                Input(type: "email", placeholder: "Email address")
                                    .style("width", "100%")
                                    .style("padding", "0.75rem")
                                    .style("border", "1px solid #e9ecef")
                                    .style("border-radius", "0.375rem")
                                
                                Input(type: "password", placeholder: "Password")
                                    .style("width", "100%")
                                    .style("padding", "0.75rem")
                                    .style("border", "1px solid #e9ecef")
                                    .style("border-radius", "0.375rem")
                                
                                Button("Sign In")
                                    .class("btn-modern")
                                    .style("width", "100%")
                                    .style("padding", "0.75rem")
                            }
                        }
                        .class("dashboard-card")
                        .style("max-width", "320px")
                    }
                }
            },
            description: "Arrange elements vertically with customizable alignment and spacing."
        ).render()
    }
    
    @HTMLBuilder
    func zstackSection() -> some HTMLElement {
        CodeExample(
            title: "ZStack - Layered Stack",
            swift: """
            // Card with badge overlay
            ZStack(alignment: .topTrailing) {
                Div {
                    Img(src: "/product.jpg", alt: "Product")
                    H4("Premium Package")
                    P("$99/month")
                }
                .class("product-card")
                
                Span("NEW")
                    .class("badge")
                    .style("margin", "10px")
            }
            
            // Hero section with overlay
            ZStack(alignment: .center) {
                Img(src: "/hero.jpg", alt: "Hero")
                    .style("width", "100%")
                    .style("height", "400px")
                
                VStack(spacing: 16) {
                    H1("Welcome to Swiftlets")
                    P("Build beautiful web apps with Swift")
                    Button("Get Started")
                }
                .style("color", "white")
                .style("text-align", "center")
            }
            """,
            html: """
            <div style="position: relative;">
                <div class="product-card">
                    <img src="/product.jpg" alt="Product">
                    <h4>Premium Package</h4>
                    <p>$99/month</p>
                </div>
                <span class="badge" style="position: absolute; top: 0; right: 0; margin: 10px;">NEW</span>
            </div>
            """,
            preview: {
                VStack(spacing: 32) {
                    // Product cards with badges
                    Div {
                        P("Product cards with overlay badges:")
                            .style("margin-bottom", "1rem")
                            .style("font-weight", "500")
                            .style("color", "#6c757d")
                        HStack(spacing: 16) {
                            ForEach([
                                ("📱", "Starter", "$9", "POPULAR", "#28a745"),
                                ("💼", "Professional", "$29", "BEST VALUE", "#007bff"),
                                ("🚀", "Enterprise", "$99", "NEW", "#dc3545")
                            ]) { icon, name, price, badge, color in
                                ZStack(alignment: .topTrailing) {
                                    VStack(spacing: 12) {
                                        Div {
                                            Text(icon)
                                                .style("font-size", "3rem")
                                        }
                                        H4(name)
                                            .style("margin", "0")
                                            .style("color", "#2c3e50")
                                        P("\(price)/month")
                                            .style("margin", "0")
                                            .style("color", "#6c757d")
                                            .style("font-size", "1.25rem")
                                            .style("font-weight", "600")
                                        
                                        Button("Choose Plan")
                                            .style("padding", "0.5rem 1.5rem")
                                            .style("background", color)
                                            .style("color", "white")
                                            .style("border", "none")
                                            .style("border-radius", "0.375rem")
                                            .style("font-weight", "500")
                                    }
                                    .class("dashboard-card")
                                    .style("text-align", "center")
                                    .style("padding", "2rem 1.5rem")
                                    .style("min-width", "180px")
                                    
                                    Span(badge)
                                        .style("background", color)
                                        .style("color", "white")
                                        .style("padding", "0.25rem 0.75rem")
                                        .style("border-radius", "0.25rem")
                                        .style("font-size", "0.75rem")
                                        .style("font-weight", "700")
                                        .style("margin", "12px")
                                        .style("box-shadow", "0 2px 4px rgba(0,0,0,0.1)")
                                }
                            }
                        }
                    }
                    
                    // Hero with overlay
                    Div {
                        P("Hero section with centered overlay:")
                            .style("margin-bottom", "1rem")
                            .style("font-weight", "500")
                            .style("color", "#6c757d")
                        ZStack(alignment: .center) {
                            Div { Text("") }
                                .style("background", "url('https://via.placeholder.com/800x300/667eea/ffffff?text=Background+Image')")
                                .style("background-size", "cover")
                                .style("background-position", "center")
                                .style("width", "100%")
                                .style("height", "300px")
                                .style("border-radius", "0.75rem")
                                .style("position", "relative")
                                .style("overflow", "hidden")
                            
                            Div { Text("") }
                                .class("hero-overlay")
                                .style("position", "absolute")
                                .style("inset", "0")
                            
                            VStack(spacing: 16) {
                                H2("Build Amazing Apps")
                                    .style("color", "white")
                                    .style("margin", "0")
                                    .style("font-size", "2rem")
                                P("Create beautiful web experiences with SwiftUI-style syntax")
                                    .style("color", "rgba(255,255,255,0.9)")
                                    .style("margin", "0")
                                    .style("max-width", "400px")
                                Button("Start Building →")
                                    .style("background", "white")
                                    .style("color", "#667eea")
                                    .style("padding", "0.75rem 2rem")
                                    .style("border", "none")
                                    .style("border-radius", "2rem")
                                    .style("font-weight", "600")
                                    .style("box-shadow", "0 4px 12px rgba(0,0,0,0.15)")
                            }
                            .style("text-align", "center")
                            .style("z-index", "10")
                        }
                    }
                }
            },
            description: "Layer elements on top of each other with precise alignment control."
        ).render()
    }
    
    @HTMLBuilder
    func gridSection() -> some HTMLElement {
        CodeExample(
            title: "Grid Layout",
            swift: """
            // Fixed column count
            Grid(columns: .count(3), spacing: 20) {
                ForEach(1...6) { i in
                    Card(number: i)
                }
            }
            
            // Responsive columns
            Grid(columns: .custom("repeat(auto-fit, minmax(250px, 1fr))"), spacing: 16) {
                ForEach(features) { feature in
                    FeatureCard(feature)
                }
            }
            
            // Custom grid template
            Grid(
                columns: .custom("2fr 1fr"),
                rowGap: 20,
                columnGap: 30
            ) {
                MainContent()
                Sidebar()
            }
            """,
            html: """
            <!-- Fixed columns -->
            <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px;">
                <!-- cards -->
            </div>
            
            <!-- Responsive columns -->
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 16px;">
                <!-- features -->
            </div>
            """,
            preview: {
                VStack(spacing: 32) {
                    // Stats grid
                    Div {
                        P("Dashboard stats grid:")
                            .style("margin-bottom", "1rem")
                            .style("font-weight", "500")
                            .style("color", "#6c757d")
                        Grid(columns: .count(4), spacing: 16) {
                            ForEach([
                                ("👥", "Users", "12,543", "+12%", "#667eea"),
                                ("💰", "Revenue", "$48.2K", "+23%", "#28a745"),
                                ("📦", "Orders", "3,421", "+8%", "#ffc107"),
                                ("📈", "Growth", "87.3%", "+5%", "#17a2b8")
                            ]) { icon, label, value, change, color in
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text(icon)
                                            .style("font-size", "1.5rem")
                                        Spacer()
                                        Text(change)
                                            .style("color", color)
                                            .style("font-size", "0.875rem")
                                            .style("font-weight", "600")
                                    }
                                    Text(label)
                                        .style("color", "#6c757d")
                                        .style("font-size", "0.875rem")
                                    H3(value)
                                        .style("margin", "0")
                                        .style("color", "#2c3e50")
                                }
                                .class("stat-card")
                            }
                        }
                    }
                    
                    // Feature grid
                    Div {
                        P("Responsive feature grid (resize window to see reflow):")
                            .style("margin-bottom", "1rem")
                            .style("font-weight", "500")
                            .style("color", "#6c757d")
                        Grid(columns: .custom("repeat(auto-fit, minmax(200px, 1fr))"), spacing: 16) {
                            ForEach([
                                ("⚡", "Fast", "Lightning quick performance"),
                                ("🛡️", "Secure", "Enterprise-grade security"),
                                ("📱", "Responsive", "Works on all devices"),
                                ("🎨", "Beautiful", "Modern, clean design"),
                                ("🔧", "Flexible", "Highly customizable"),
                                ("🚀", "Scalable", "Grows with your needs")
                            ]) { icon, title, desc in
                                VStack(spacing: 12) {
                                    Text(icon)
                                        .style("font-size", "2.5rem")
                                    H4(title)
                                        .style("margin", "0")
                                        .style("color", "#2c3e50")
                                    P(desc)
                                        .style("margin", "0")
                                        .style("color", "#6c757d")
                                        .style("font-size", "0.875rem")
                                        .style("line-height", "1.5")
                                }
                                .class("dashboard-card")
                                .style("text-align", "center")
                                .style("transition", "transform 0.2s")
                                .style("cursor", "pointer")
                            }
                        }
                    }
                }
            },
            description: "Create powerful grid layouts with flexible column configurations."
        ).render()
    }
    
    @HTMLBuilder
    func containerSection() -> some HTMLElement {
        CodeExample(
            title: "Container",
            swift: """
            // Small container (max-width: 576px)
            Container(maxWidth: .small) {
                H2("Article Title")
                P("Perfect for blog posts and focused reading.")
            }
            
            // Medium container (max-width: 768px)
            Container(maxWidth: .medium, padding: 20) {
                ContactForm()
            }
            
            // Large container (max-width: 1140px)
            Container(maxWidth: .large) {
                NavigationBar()
                HeroSection()
                Features()
            }
            
            // Full-width section with contained content
            Section {
                Container(maxWidth: .medium) {
                    H2("Contained within full-width section")
                }
            }
            .style("background", "#f8f9fa")
            """,
            html: """
            <!-- Small container -->
            <div style="max-width: 576px; margin: 0 auto;">
                <h2>Article Title</h2>
                <p>Perfect for blog posts and focused reading.</p>
            </div>
            
            <!-- Large container with padding -->
            <div style="max-width: 1140px; margin: 0 auto; padding: 20px;">
                <!-- content -->
            </div>
            """,
            preview: {
                VStack(spacing: 24) {
                    ForEach([
                        ("small", "576px", "Blog posts, articles", "#e8f5e9"),
                        ("medium", "768px", "Forms, focused content", "#f3e5f5"),
                        ("large", "1140px", "Main site content", "#e3f2fd")
                    ]) { size, width, use, bg in
                        Div {
                            Div {
                                P("Container.\(size) • max-width: \(width)")
                                    .style("margin", "0")
                                    .style("font-weight", "600")
                                    .style("color", "#2c3e50")
                                P("Use for: \(use)")
                                    .style("margin", "0.5rem 0 0 0")
                                    .style("color", "#6c757d")
                                    .style("font-size", "0.875rem")
                            }
                            .style("text-align", "center")
                            .style("padding", "2rem")
                            .style("background", bg)
                            .style("border-radius", "0.5rem")
                            .style("max-width", width)
                            .style("margin", "0 auto")
                        }
                        .style("background", "#f8f9fa")
                        .style("padding", "1rem")
                        .style("border-radius", "0.5rem")
                    }
                }
            },
            description: "Responsive containers with predefined breakpoints for consistent layouts."
        ).render()
    }
    
    @HTMLBuilder
    func spacerSection() -> some HTMLElement {
        CodeExample(
            title: "Spacer",
            swift: """
            // Navigation bar
            HStack {
                H3("Logo")
                Spacer()
                Link(href: "/", "Home")
                Link(href: "/about", "About")
                Link(href: "/contact", "Contact")
            }
            
            // Center content
            HStack {
                Spacer()
                Button("Centered")
                Spacer()
            }
            
            // Spacer with minimum length
            HStack {
                Text("Left")
                Spacer(minLength: 100)
                Text("Right")
            }
            """,
            html: """
            <div style="display: flex; align-items: center;">
                <h3>Logo</h3>
                <div style="flex: 1;"></div>
                <a href="/">Home</a>
                <a href="/about">About</a>
                <a href="/contact">Contact</a>
            </div>
            """,
            preview: {
                VStack(spacing: 20) {
                    // Navigation
                    Div {
                        HStack {
                            H3("🚀 Swiftlets")
                                .style("margin", "0")
                                .style("background", "linear-gradient(135deg, #667eea 0%, #764ba2 100%)")
                                .style("-webkit-background-clip", "text")
                                .style("-webkit-text-fill-color", "transparent")
                            Spacer()
                            HStack(spacing: 24) {
                                Link(href: "#", "Features")
                                    .style("color", "#4a5568")
                                    .style("font-weight", "500")
                                Link(href: "#", "Pricing")
                                    .style("color", "#4a5568")
                                    .style("font-weight", "500")
                                Link(href: "#", "Docs")
                                    .style("color", "#4a5568")
                                    .style("font-weight", "500")
                                Button("Get Started")
                                    .class("btn-modern")
                            }
                        }
                        .class("dashboard-card")
                    }
                    
                    // Centered buttons
                    Div {
                        P("Social media bar:")
                            .style("margin-bottom", "1rem")
                            .style("font-weight", "500")
                            .style("color", "#6c757d")
                        HStack {
                            Button("Share")
                                .style("padding", "0.5rem 1rem")
                                .style("background", "#1877f2")
                                .style("color", "white")
                                .style("border", "none")
                                .style("border-radius", "0.375rem")
                            Spacer()
                            HStack(spacing: 12) {
                                Button("👍 Like")
                                    .style("padding", "0.5rem 1rem")
                                    .style("background", "#e4e6eb")
                                    .style("color", "#1c1e21")
                                    .style("border", "none")
                                    .style("border-radius", "0.375rem")
                                Button("💬 Comment")
                                    .style("padding", "0.5rem 1rem")
                                    .style("background", "#e4e6eb")
                                    .style("color", "#1c1e21")
                                    .style("border", "none")
                                    .style("border-radius", "0.375rem")
                                Button("↗️ Share")
                                    .style("padding", "0.5rem 1rem")
                                    .style("background", "#e4e6eb")
                                    .style("color", "#1c1e21")
                                    .style("border", "none")
                                    .style("border-radius", "0.375rem")
                            }
                        }
                        .class("dashboard-card")
                    }
                    
                    // Min length demo
                    Div {
                        P("Spacer with minimum length ensures spacing:")
                            .style("margin-bottom", "1rem")
                            .style("font-weight", "500")
                            .style("color", "#6c757d")
                        VStack(spacing: 12) {
                            HStack {
                                Text("Short")
                                    .style("padding", "0.5rem 1rem")
                                    .style("background", "#ffd93d")
                                    .style("border-radius", "0.375rem")
                                Spacer(minLength: 50)
                                Text("Apart")
                                    .style("padding", "0.5rem 1rem")
                                    .style("background", "#6bcf7f")
                                    .style("border-radius", "0.375rem")
                            }
                            .style("background", "#f8f9fa")
                            .style("padding", "1rem")
                            .style("border-radius", "0.375rem")
                            
                            P("Even in small containers, minimum spacing is maintained")
                                .style("font-size", "0.875rem")
                                .style("color", "#6c757d")
                                .style("font-style", "italic")
                        }
                    }
                }
            },
            description: "Flexible space that expands to push adjacent content apart."
        ).render()
    }
    
    @HTMLBuilder
    func complexLayoutSection() -> some HTMLElement {
        CodeExample(
            title: "Complex Layout Composition",
            swift: """
            Container(maxWidth: .large) {
                VStack(spacing: 24) {
                    // Header
                    HStack {
                        H1("Dashboard")
                        Spacer()
                        HStack(spacing: 12) {
                            Button("Settings")
                            Button("Profile")
                        }
                    }
                    
                    // Stats Grid
                    Grid(columns: .count(4), spacing: 16) {
                        ForEach(stats) { stat in
                            StatCard(stat)
                        }
                    }
                    
                    // Main Content
                    HStack(alignment: .top, spacing: 24) {
                        // Main area
                        VStack(spacing: 16) {
                            ForEach(posts) { post in
                                PostCard(post)
                            }
                        }
                        .style("flex", "2")
                        
                        // Sidebar
                        VStack(spacing: 16) {
                            ActivityFeed()
                            QuickActions()
                        }
                        .style("flex", "1")
                    }
                }
            }
            """,
            html: """
            <div style="max-width: 1140px; margin: 0 auto;">
                <!-- Complex nested layout -->
            </div>
            """,
            preview: {
                Container(maxWidth: .large) {
                    VStack(spacing: 24) {
                        // Header
                        HStack {
                            H2("Analytics Dashboard")
                                .style("margin", "0")
                                .style("color", "#2c3e50")
                            Spacer()
                            HStack(spacing: 12) {
                                Button("Export")
                                    .style("padding", "0.5rem 1rem")
                                    .style("background", "#6c757d")
                                    .style("color", "white")
                                    .style("border", "none")
                                    .style("border-radius", "0.375rem")
                                Button("⚙️ Settings")
                                    .style("padding", "0.5rem 1rem")
                                    .style("background", "#007bff")
                                    .style("color", "white")
                                    .style("border", "none")
                                    .style("border-radius", "0.375rem")
                            }
                        }
                        
                        // Stats
                        Grid(columns: .count(4), spacing: 16) {
                            ForEach([
                                ("📊", "Views", "45.2K", "+12%"),
                                ("👥", "Users", "8,421", "+23%"),
                                ("💬", "Comments", "1,893", "+8%"),
                                ("⭐", "Rating", "4.8/5", "+0.2")
                            ]) { icon, label, value, change in
                                VStack(spacing: 8) {
                                    HStack {
                                        Text(icon)
                                            .style("font-size", "1.5rem")
                                        Spacer()
                                        Text(change)
                                            .style("color", change.starts(with: "+") ? "#28a745" : "#dc3545")
                                            .style("font-size", "0.75rem")
                                            .style("font-weight", "600")
                                    }
                                    Text(label)
                                        .style("color", "#6c757d")
                                        .style("font-size", "0.875rem")
                                    H4(value)
                                        .style("margin", "0")
                                        .style("color", "#2c3e50")
                                }
                                .class("stat-card")
                            }
                        }
                        
                        // Content area
                        HStack(alignment: .top, spacing: 20) {
                            // Main feed
                            VStack(spacing: 16) {
                                H3("Recent Activity")
                                    .style("margin", "0 0 1rem 0")
                                    .style("color", "#2c3e50")
                                
                                ForEach(1...3) { i in
                                    HStack(spacing: 16) {
                                        Div {
                                            Text("📝")
                                                .style("font-size", "1.5rem")
                                        }
                                        .style("width", "48px")
                                        .style("height", "48px")
                                        .style("background", "#f8f9fa")
                                        .style("border-radius", "0.5rem")
                                        .style("display", "flex")
                                        .style("align-items", "center")
                                        .style("justify-content", "center")
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("New blog post published")
                                                .style("font-weight", "600")
                                                .style("color", "#2c3e50")
                                            Text("\(i) hours ago • 234 views")
                                                .style("font-size", "0.875rem")
                                                .style("color", "#6c757d")
                                        }
                                        
                                        Spacer()
                                        
                                        Button("View")
                                            .style("padding", "0.25rem 0.75rem")
                                            .style("background", "transparent")
                                            .style("color", "#667eea")
                                            .style("border", "1px solid #667eea")
                                            .style("border-radius", "0.375rem")
                                            .style("font-size", "0.875rem")
                                    }
                                    .class("dashboard-card")
                                }
                            }
                            .style("flex", "2")
                            
                            // Sidebar
                            VStack(spacing: 16) {
                                Div {
                                    H4("Quick Actions")
                                        .style("margin", "0 0 1rem 0")
                                        .style("color", "#2c3e50")
                                    
                                    VStack(spacing: 8) {
                                        ForEach([
                                            ("📝", "New Post", "#667eea"),
                                            ("📊", "View Analytics", "#28a745"),
                                            ("👥", "Manage Team", "#ffc107"),
                                            ("⚙️", "Settings", "#6c757d")
                                        ]) { icon, action, color in
                                            HStack {
                                                Text(icon)
                                                Text(action)
                                                    .style("font-weight", "500")
                                                Spacer()
                                            }
                                            .style("padding", "0.75rem")
                                            .style("background", color)
                                            .style("color", "white")
                                            .style("border-radius", "0.375rem")
                                            .style("cursor", "pointer")
                                            .style("transition", "transform 0.2s")
                                        }
                                    }
                                }
                                .class("dashboard-card")
                                
                                Div {
                                    H4("Performance")
                                        .style("margin", "0 0 1rem 0")
                                        .style("color", "#2c3e50")
                                    
                                    VStack(spacing: 12) {
                                        ForEach([
                                            ("CPU", 65, "#007bff"),
                                            ("Memory", 82, "#ffc107"),
                                            ("Storage", 45, "#28a745")
                                        ]) { label, percent, color in
                                            VStack(alignment: .leading, spacing: 4) {
                                                HStack {
                                                    Text(label)
                                                        .style("font-size", "0.875rem")
                                                        .style("color", "#6c757d")
                                                    Spacer()
                                                    Text("\(percent)%")
                                                        .style("font-size", "0.875rem")
                                                        .style("font-weight", "600")
                                                        .style("color", color)
                                                }
                                                Div {
                                                    Div { Text("") }
                                                        .style("width", "\(percent)%")
                                                        .style("height", "6px")
                                                        .style("background", color)
                                                        .style("border-radius", "3px")
                                                        .style("transition", "width 0.3s")
                                                }
                                                .style("background", "#e9ecef")
                                                .style("border-radius", "3px")
                                                .style("overflow", "hidden")
                                            }
                                        }
                                    }
                                }
                                .class("dashboard-card")
                            }
                            .style("flex", "1")
                        }
                    }
                }
                .style("padding", "2rem")
                .style("background", "#ffffff")
                .style("border-radius", "0.75rem")
                .style("box-shadow", "0 4px 6px rgba(0,0,0,0.07)")
            },
            description: "Combine layout components to build sophisticated, responsive interfaces."
        ).render()
    }
}