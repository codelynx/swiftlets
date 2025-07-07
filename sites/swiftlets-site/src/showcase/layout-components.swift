import Swiftlets

@main
struct LayoutShowcase: SwiftletMain {
    var title = "Layout Components - Swiftlets Showcase"
    
    var body: some HTMLElement {
        Fragment {
            Nav {
            Div {
            Link(href: "/", "Swiftlets")
                .class("nav-brand")
            
            Div {
                Link(href: "/", "Home")
                Link(href: "/docs", "Docs")
                Link(href: "/showcase", "Showcase")
                    .class("active")
            }
            .class("nav-links")
            }
            .class("nav-content")
            }
            .class("nav-container")
            
            Div {
            H1("Layout Components")
            
            Div {
            Link(href: "/showcase", "← Back to Showcase")
                .style("display", "inline-block")
                .style("margin-bottom", "1rem")
                .style("color", "#007bff")
            }
            
            P("SwiftUI-inspired layout components for building responsive web interfaces.")
            
            // HStack Examples
            Section {
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
HStack(alignment: .top) {
    Div { Text("Top") }.style("height", "100px").style("background", "#f0f0f0")
    Div { Text("Aligned") }.style("height", "60px").style("background", "#e0e0e0")
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

<!-- Different alignments -->
<div style="display: flex; flex-direction: row; align-items: flex-start;">
    <div style="height: 100px; background: #f0f0f0;">Top</div>
    <div style="height: 60px; background: #e0e0e0;">Aligned</div>
</div>
""",
                preview: {
                    VStack(spacing: 30) {
                        // Basic HStack
                        Div {
                            P("Basic HStack:")
                            HStack {
                                Button("Previous")
                                    .style("padding", "0.5rem 1rem")
                                    .style("background", "#007bff")
                                    .style("color", "white")
                                    .style("border", "none")
                                    .style("border-radius", "4px")
                                Button("Next")
                                    .style("padding", "0.5rem 1rem")
                                    .style("background", "#28a745")
                                    .style("color", "white")
                                    .style("border", "none")
                                    .style("border-radius", "4px")
                            }
                        }
                        
                        // With spacing
                        Div {
                            P("With spacing and alignment:")
                            HStack(alignment: .center, spacing: 20) {
                                Div {
                                    Text("🎯")
                                        .style("font-size", "2rem")
                                }
                                .style("width", "40px")
                                .style("height", "40px")
                                Text("User Profile")
                                    .style("font-weight", "600")
                                Spacer()
                                Button("Edit")
                                    .style("padding", "0.25rem 0.75rem")
                                    .style("background", "#6c757d")
                                    .style("color", "white")
                                    .style("border", "none")
                                    .style("border-radius", "4px")
                            }
                            .style("background", "#f8f9fa")
                            .style("padding", "1rem")
                            .style("border-radius", "0.5rem")
                            .style("width", "100%")
                        }
                        
                        // Different alignments
                        Div {
                            P("Different alignments (top):")
                            HStack(alignment: .top, spacing: 10) {
                                Div { 
                                    Text("Tall Box")
                                        .style("padding", "1rem")
                                }
                                .style("height", "100px")
                                .style("background", "#e3f2fd")
                                .style("display", "flex")
                                .style("align-items", "center")
                                
                                Div { 
                                    Text("Short Box")
                                        .style("padding", "1rem")
                                }
                                .style("height", "60px")
                                .style("background", "#f3e5f5")
                                .style("display", "flex")
                                .style("align-items", "center")
                                
                                Div { 
                                    Text("Medium Box")
                                        .style("padding", "1rem")
                                }
                                .style("height", "80px")
                                .style("background", "#e8f5e9")
                                .style("display", "flex")
                                .style("align-items", "center")
                            }
                        }
                    }
                },
                description: "Arrange elements horizontally with customizable alignment and spacing."
            ).render()
            }
            
            // VStack Examples
            Section {
            CodeExample(
                title: "VStack - Vertical Stack",
                swift: """
// Basic VStack
VStack {
    H3("Settings")
    P("Configure your preferences")
}

// With spacing and alignment
VStack(alignment: .leading, spacing: 16) {
    Label("Username")
    Input(type: "text", name: "username")
    Label("Email")
    Input(type: "email", name: "email")
    Button("Save Changes")
}

// Center aligned with spacing
VStack(alignment: .center, spacing: 24) {
    Img(src: "/logo.png", alt: "Logo")
    H2("Welcome Back!")
    P("Sign in to continue")
}
""",
                html: """
<div style="display: flex; flex-direction: column;">
    <h3>Settings</h3>
    <p>Configure your preferences</p>
</div>

<!-- With spacing and alignment -->
<div style="display: flex; flex-direction: column; align-items: flex-start; gap: 16px;">
    <label>Username</label>
    <input type="text" name="username">
    <label>Email</label>
    <input type="email" name="email">
    <button>Save Changes</button>
</div>

<!-- Center aligned with spacing -->
<div style="display: flex; flex-direction: column; align-items: center; gap: 24px;">
    <img src="/logo.png" alt="Logo">
    <h2>Welcome Back!</h2>
    <p>Sign in to continue</p>
</div>
""",
                preview: {
                    HStack(spacing: 30) {
                        // Basic VStack
                        Div {
                            P("Basic VStack:")
                            VStack {
                                H3("Settings")
                                P("Configure your preferences")
                            }
                            .style("background", "#f8f9fa")
                            .style("padding", "1rem")
                            .style("border-radius", "0.5rem")
                        }
                        .style("flex", "1")
                        
                        // With form elements
                        Div {
                            P("Form with VStack:")
                            VStack(alignment: .leading, spacing: 12) {
                                Label("Username")
                                    .style("font-weight", "600")
                                Input(type: "text", name: "username")
                                    .style("width", "100%")
                                    .style("padding", "0.5rem")
                                    .style("border", "1px solid #ced4da")
                                    .style("border-radius", "4px")
                                
                                Label("Email")
                                    .style("font-weight", "600")
                                Input(type: "email", name: "email")
                                    .style("width", "100%")
                                    .style("padding", "0.5rem")
                                    .style("border", "1px solid #ced4da")
                                    .style("border-radius", "4px")
                                
                                Button("Save Changes")
                                    .style("padding", "0.5rem 1rem")
                                    .style("background", "#007bff")
                                    .style("color", "white")
                                    .style("border", "none")
                                    .style("border-radius", "4px")
                                    .style("margin-top", "0.5rem")
                            }
                            .style("background", "#e7f3ff")
                            .style("padding", "1.5rem")
                            .style("border-radius", "0.5rem")
                        }
                        .style("flex", "1")
                    }
                },
                description: "Arrange elements vertically with customizable alignment and spacing."
            ).render()
            }
            
            // ZStack Examples
            Section {
            CodeExample(
                title: "ZStack - Layered Stack",
                swift: """
// Card with overlay badge
ZStack(alignment: .topTrailing) {
    Div {
        Img(src: "/product.jpg", alt: "Product")
        H4("Premium Package")
        P("$99/month")
    }
    .class("card")
    
    Span("NEW")
        .class("badge")
        .style("margin", "10px")
}

// Centered overlay
ZStack(alignment: .center) {
    Img(src: "/hero.jpg", alt: "Hero")
        .style("width", "100%")
        .style("height", "300px")
    
    VStack {
        H1("Welcome")
        Button("Get Started")
    }
    .style("color", "white")
}
""",
                html: """
<div style="position: relative;">
    <div class="card">
        <img src="/product.jpg" alt="Product">
        <h4>Premium Package</h4>
        <p>$99/month</p>
    </div>
    <span class="badge" style="position: absolute; top: 0; right: 0; margin: 10px;">NEW</span>
</div>

<!-- Centered overlay -->
<div style="position: relative;">
    <img src="/hero.jpg" alt="Hero" style="width: 100%; height: 300px;">
    <div style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); color: white;">
        <h1>Welcome</h1>
        <button>Get Started</button>
    </div>
</div>
""",
                preview: {
                    HStack(spacing: 30) {
                        // Card with badge
                        Div {
                            P("Card with overlay badge:")
                            ZStack(alignment: .topTrailing) {
                                Div {
                                    Div {
                                        Text("📦")
                                            .style("font-size", "4rem")
                                            .style("text-align", "center")
                                            .style("margin", "1rem 0")
                                    }
                                    H4("Premium Package")
                                        .style("margin", "0.5rem 0")
                                    P("$99/month")
                                        .style("color", "#6c757d")
                                        .style("margin", "0")
                                }
                                .style("background", "white")
                                .style("border", "1px solid #dee2e6")
                                .style("border-radius", "0.5rem")
                                .style("padding", "2rem")
                                .style("text-align", "center")
                                .style("width", "200px")
                                
                                Span("NEW")
                                    .style("background", "#dc3545")
                                    .style("color", "white")
                                    .style("padding", "0.25rem 0.5rem")
                                    .style("border-radius", "0.25rem")
                                    .style("font-size", "0.75rem")
                                    .style("font-weight", "bold")
                                    .style("margin", "10px")
                            }
                        }
                        
                        // Hero with centered content
                        Div {
                            P("Hero with centered overlay:")
                            ZStack(alignment: .center) {
                                Div {
                                    Text("")
                                }
                                .style("background", "linear-gradient(135deg, #667eea 0%, #764ba2 100%)")
                                .style("width", "100%")
                                .style("height", "200px")
                                .style("border-radius", "0.5rem")
                                
                                VStack(spacing: 16) {
                                    H2("Welcome")
                                        .style("color", "white")
                                        .style("margin", "0")
                                    Button("Get Started")
                                        .style("background", "white")
                                        .style("color", "#667eea")
                                        .style("padding", "0.5rem 1.5rem")
                                        .style("border", "none")
                                        .style("border-radius", "2rem")
                                        .style("font-weight", "600")
                                }
                            }
                        }
                        .style("flex", "1")
                    }
                },
                description: "Layer elements on top of each other with 9-point alignment system."
            ).render()
            }
            
            // Grid Examples
            Section {
            CodeExample(
                title: "Grid Layout",
                swift: """
// Fixed column count
Grid(columns: .count(3), spacing: 20) {
    ForEach(1...6) { i in
        Card(number: i)
    }
}

// Responsive columns with minimum width
Grid(columns: .custom("repeat(auto-fit, minmax(200px, 1fr))"), spacing: 16) {
    ForEach(products) { product in
        ProductCard(product)
    }
}

// Custom column definitions
Grid(
    columns: .custom("2fr 1fr 100px"),
    rowGap: 10,
    columnGap: 20
) {
    MainContent()
    Sidebar()
    Ads()
}
""",
                html: """
<!-- Fixed column count -->
<div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px;">
    <div>Card 1</div>
    <div>Card 2</div>
    <div>Card 3</div>
    <div>Card 4</div>
    <div>Card 5</div>
    <div>Card 6</div>
</div>

<!-- Responsive columns -->
<div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px;">
    <div>Product 1</div>
    <div>Product 2</div>
    <div>Product 3</div>
</div>

<!-- Custom columns -->
<div style="display: grid; grid-template-columns: 2fr 1fr 100px; row-gap: 10px; column-gap: 20px;">
    <div>Main Content</div>
    <div>Sidebar</div>
    <div>Ads</div>
</div>
""",
                preview: {
                    VStack(spacing: 30) {
                        // Fixed columns
                        Div {
                            P("Fixed 3-column grid:")
                            Grid(columns: .count(3), spacing: 15) {
                                ForEach(1...6) { i in
                                    Div {
                                        Text("Card \(i)")
                                            .style("text-align", "center")
                                            .style("font-weight", "600")
                                    }
                                    .style("background", "#f8f9fa")
                                    .style("padding", "2rem 1rem")
                                    .style("border", "1px solid #dee2e6")
                                    .style("border-radius", "0.5rem")
                                }
                            }
                        }
                        
                        // Flexible columns
                        Div {
                            P("Flexible columns (resize window to see responsiveness):")
                            Grid(columns: .custom("repeat(auto-fit, minmax(150px, 1fr))"), spacing: 12) {
                                ForEach(["Primary", "Success", "Warning", "Danger", "Info"]) { type in
                                    Div {
                                        Text(type)
                                            .style("text-align", "center")
                                            .style("color", "white")
                                            .style("font-weight", "600")
                                    }
                                    .style("background", type == "Primary" ? "#007bff" : 
                                                       type == "Success" ? "#28a745" :
                                                       type == "Warning" ? "#ffc107" :
                                                       type == "Danger" ? "#dc3545" : "#17a2b8")
                                    .style("padding", "1.5rem")
                                    .style("border-radius", "0.5rem")
                                }
                            }
                        }
                    }
                },
                description: "Create responsive grid layouts with flexible column definitions."
            ).render()
            }
            
            // Container Examples
            Section {
            CodeExample(
                title: "Container",
                swift: """
// Small container (max-width: 576px)
Container(maxWidth: .small) {
    H2("Narrow Content")
    P("Perfect for focused reading experiences.")
}

// Large container (max-width: 1140px)
Container(maxWidth: .large, padding: 20) {
    Header { H1("Main Site Header") }
    Main { /* content */ }
    Footer { /* footer */ }
}

// Full-width sections with contained content
Section {
    Container(maxWidth: .medium) {
        H2("Features")
        Grid(columns: .count(3)) { /* ... */ }
    }
}
.style("background", "#f8f9fa")
""",
                html: """
<!-- Small container -->
<div style="max-width: 576px; margin: 0 auto;">
    <h2>Narrow Content</h2>
    <p>Perfect for focused reading experiences.</p>
</div>

<!-- Large container with padding -->
<div style="max-width: 1140px; margin: 0 auto; padding: 20px;">
    <header><h1>Main Site Header</h1></header>
    <main><!-- content --></main>
    <footer><!-- footer --></footer>
</div>

<!-- Full-width section with contained content -->
<section style="background: #f8f9fa;">
    <div style="max-width: 768px; margin: 0 auto;">
        <h2>Features</h2>
        <div style="display: grid; grid-template-columns: repeat(3, 1fr);">
            <!-- grid content -->
        </div>
    </div>
</section>
""",
                preview: {
                    VStack(spacing: 30) {
                        // Different container sizes
                        ForEach([
                            ("small", "576px", "#e3f2fd"),
                            ("medium", "768px", "#f3e5f5"),
                            ("large", "1140px", "#e8f5e9")
                        ]) { size, maxWidth, color in
                            Div {
                                P("Container.\(size) (max-width: \(maxWidth)):")
                                Div {
                                    Container(maxWidth: size == "small" ? .small : 
                                                      size == "medium" ? .medium : .large,
                                             padding: 20) {
                                        Text("This content is contained within a \(maxWidth) max-width container. Resize your window to see how it behaves.")
                                    }
                                }
                                .style("background", color)
                                .style("padding", "1rem 0")
                            }
                        }
                    }
                },
                description: "Responsive container with predefined max-width breakpoints."
            ).render()
            }
            
            // Spacer Examples
            Section {
            CodeExample(
                title: "Spacer",
                swift: """
// Navigation bar with spacer
HStack {
    H3("Logo")
    Spacer()
    Link(href: "/home", "Home")
    Link(href: "/about", "About")
    Link(href: "/contact", "Contact")
}

// Center content with spacers
HStack {
    Spacer()
    Button("Centered Button")
    Spacer()
}

// Spacer with minimum width
HStack {
    Text("Left")
    Spacer(minLength: 50)
    Text("Right")
}
""",
                html: """
<!-- Navigation with spacer -->
<div style="display: flex; flex-direction: row; align-items: center;">
    <h3>Logo</h3>
    <div style="flex: 1;"></div>
    <a href="/home">Home</a>
    <a href="/about">About</a>
    <a href="/contact">Contact</a>
</div>

<!-- Centered content -->
<div style="display: flex; flex-direction: row; align-items: center;">
    <div style="flex: 1;"></div>
    <button>Centered Button</button>
    <div style="flex: 1;"></div>
</div>

<!-- Spacer with min width -->
<div style="display: flex; flex-direction: row; align-items: center;">
    Left
    <div style="flex: 1; min-width: 50px;"></div>
    Right
</div>
""",
                preview: {
                    VStack(spacing: 30) {
                        // Navigation example
                        Div {
                            P("Navigation with Spacer:")
                            HStack {
                                H3("SwiftLogo")
                                    .style("margin", "0")
                                    .style("color", "#007bff")
                                Spacer()
                                HStack(spacing: 20) {
                                    Link(href: "#", "Home")
                                    Link(href: "#", "About")
                                    Link(href: "#", "Contact")
                                }
                            }
                            .style("background", "#f8f9fa")
                            .style("padding", "1rem")
                            .style("border-radius", "0.5rem")
                        }
                        
                        // Centered content
                        Div {
                            P("Centered with Spacers:")
                            HStack {
                                Spacer()
                                Button("Centered Button")
                                    .style("padding", "0.5rem 2rem")
                                    .style("background", "#28a745")
                                    .style("color", "white")
                                    .style("border", "none")
                                    .style("border-radius", "2rem")
                                Spacer()
                            }
                            .style("background", "#e7f3ff")
                            .style("padding", "2rem")
                            .style("border-radius", "0.5rem")
                        }
                        
                        // Min length spacer
                        Div {
                            P("Spacer with minimum length:")
                            HStack {
                                Div {
                                    Text("Left Side")
                                        .style("padding", "0.5rem 1rem")
                                        .style("background", "#ffc107")
                                        .style("border-radius", "4px")
                                }
                                Spacer(minLength: 100)
                                Div {
                                    Text("Right Side")
                                        .style("padding", "0.5rem 1rem")
                                        .style("background", "#17a2b8")
                                        .style("color", "white")
                                        .style("border-radius", "4px")
                                }
                            }
                            .style("background", "#f0f0f0")
                            .style("padding", "1rem")
                            .style("border-radius", "0.5rem")
                        }
                    }
                },
                description: "Flexible space that expands to push content apart."
            ).render()
            }
            
            // Complex Layout Example
            Section {
            CodeExample(
                title: "Complex Layout Composition",
                swift: """
Container(maxWidth: .large, padding: 20) {
    VStack(spacing: 24) {
        // Header
        HStack {
            H1("Dashboard")
            Spacer()
            HStack(spacing: 12) {
            Button("Settings")
            Button("Logout")
            }
        }
        
        // Stats Grid
        Grid(columns: .count(4), spacing: 16) {
            ForEach(stats) { stat in
            VStack(alignment: .leading) {
            Text(stat.label).style("color", "#6c757d")
            H3(stat.value)
            }
            .style("background", "#f8f9fa")
            .style("padding", "1rem")
            .style("border-radius", "0.5rem")
            }
        }
        
        // Main Content Area
        HStack(alignment: .top, spacing: 24) {
            VStack(spacing: 16) {
            // Main content
            ForEach(items) { item in
            Card(item: item)
            }
            }
            .style("flex", "2")
            
            VStack(spacing: 16) {
            // Sidebar
            H4("Recent Activity")
            ActivityList()
            }
            .style("flex", "1")
        }
    }
}
""",
                html: """
<div style="max-width: 1140px; margin: 0 auto; padding: 20px;">
    <div style="display: flex; flex-direction: column; gap: 24px;">
        <!-- Header -->
        <div style="display: flex; flex-direction: row; align-items: center;">
            <h1>Dashboard</h1>
            <div style="flex: 1;"></div>
            <div style="display: flex; flex-direction: row; gap: 12px;">
            <button>Settings</button>
            <button>Logout</button>
            </div>
        </div>
        
        <!-- Stats Grid -->
        <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px;">
            <!-- stat cards -->
        </div>
        
        <!-- Main Content Area -->
        <div style="display: flex; flex-direction: row; align-items: flex-start; gap: 24px;">
            <div style="display: flex; flex-direction: column; gap: 16px; flex: 2;">
            <!-- main content -->
            </div>
            <div style="display: flex; flex-direction: column; gap: 16px; flex: 1;">
            <!-- sidebar -->
            </div>
        </div>
    </div>
</div>
""",
                preview: {
                    Container(maxWidth: .large, padding: 20) {
                        VStack(spacing: 20) {
                            // Header
                            HStack {
                                H2("Dashboard")
                                    .style("margin", "0")
                                Spacer()
                                HStack(spacing: 10) {
                                    Button("⚙️ Settings")
                                        .style("padding", "0.5rem 1rem")
                                        .style("background", "#6c757d")
                                        .style("color", "white")
                                        .style("border", "none")
                                        .style("border-radius", "4px")
                                    Button("Logout")
                                        .style("padding", "0.5rem 1rem")
                                        .style("background", "#dc3545")
                                        .style("color", "white")
                                        .style("border", "none")
                                        .style("border-radius", "4px")
                                }
                            }
                            .style("padding-bottom", "1rem")
                            .style("border-bottom", "2px solid #dee2e6")
                            
                            // Stats
                            Grid(columns: .count(4), spacing: 12) {
                                ForEach([
                                    ("Users", "1,234", "#007bff"),
                                    ("Revenue", "$12.5K", "#28a745"),
                                    ("Orders", "456", "#ffc107"),
                                    ("Growth", "+23%", "#17a2b8")
                                ]) { label, value, color in
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(label)
                                            .style("color", "#6c757d")
                                            .style("font-size", "0.875rem")
                                        H3(value)
                                            .style("margin", "0")
                                            .style("color", color)
                                    }
                                    .style("background", "#f8f9fa")
                                    .style("padding", "1rem")
                                    .style("border-radius", "0.5rem")
                                    .style("border", "1px solid #e9ecef")
                                }
                            }
                            
                            // Content Area
                            HStack(alignment: .top, spacing: 20) {
                                VStack(spacing: 12) {
                                    H3("Recent Orders")
                                        .style("margin", "0 0 1rem 0")
                                    ForEach(1...3) { i in
                                        Div {
                                            HStack {
                                                VStack(alignment: .leading) {
                                                    Text("Order #\(1000 + i)")
                                                        .style("font-weight", "600")
                                                    Text("2 items • $\(25 * i).00")
                                                        .style("color", "#6c757d")
                                                        .style("font-size", "0.875rem")
                                                }
                                                Spacer()
                                                Span("Processing")
                                                    .style("background", "#fff3cd")
                                                    .style("color", "#856404")
                                                    .style("padding", "0.25rem 0.75rem")
                                                    .style("border-radius", "1rem")
                                                    .style("font-size", "0.75rem")
                                            }
                                        }
                                        .style("background", "white")
                                        .style("padding", "1rem")
                                        .style("border", "1px solid #dee2e6")
                                        .style("border-radius", "0.5rem")
                                    }
                                }
                                .style("flex", "2")
                                
                                VStack(spacing: 12) {
                                    H4("Recent Activity")
                                        .style("margin", "0 0 1rem 0")
                                    VStack(spacing: 8) {
                                        ForEach([
                                            "New user registered",
                                            "Order #1003 completed",
                                            "Payment received",
                                            "Inventory updated"
                                        ]) { activity in
                                            HStack {
                                                Text("•")
                                                    .style("color", "#28a745")
                                                    .style("font-weight", "bold")
                                                Text(activity)
                                                    .style("font-size", "0.875rem")
                                            }
                                            .style("padding", "0.5rem")
                                            .style("background", "#f8f9fa")
                                            .style("border-radius", "4px")
                                        }
                                    }
                                }
                                .style("flex", "1")
                                .style("background", "white")
                                .style("padding", "1rem")
                                .style("border", "1px solid #dee2e6")
                                .style("border-radius", "0.5rem")
                            }
                        }
                    }
                    .style("background", "#ffffff")
                    .style("border", "1px solid #dee2e6")
                    .style("border-radius", "0.5rem")
                },
                description: "Combining multiple layout components to create sophisticated interfaces."
            ).render()
            }
            
            Div {
            Link(href: "/showcase/semantic-html", "Semantic HTML")
                .class("nav-button")
            Link(href: "/showcase/modifiers", "Modifiers")
                .class("nav-button nav-button-next")
            }
            .class("navigation-links")
            }
            .class("showcase-container")
            
        }
    }
}