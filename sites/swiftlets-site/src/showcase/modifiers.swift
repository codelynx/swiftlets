import Swiftlets

@main
struct ModifiersShowcase: SwiftletMain {
    var title = "Modifiers - Swiftlets Showcase"
    
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
            H1("Modifiers")
            
            Div {
            Link(href: "/showcase", "← Back to Showcase")
                .style("display", "inline-block")
                .style("margin-bottom", "1rem")
                .style("color", "#007bff")
            }
            
            P("Transform and style HTML elements with chainable modifiers for classes, styles, attributes, and more.")
            
            // Class and ID Modifiers
            Section {
            CodeExample(
                title: "Class and ID Modifiers",
                swift: """
// Single class
Button("Submit")
    .class("btn-primary")

// Multiple classes
Div {
    Text("Alert message")
}
.class("alert alert-warning alert-dismissible")

// ID modifier
Input(type: "email", name: "email")
    .id("email-input")

// Combining class and ID
Section {
    H2("Features")
}
.id("features-section")
.class("container py-5")
""",
                html: """
<!-- Single class -->
<button class="btn-primary">Submit</button>

<!-- Multiple classes -->
<div class="alert alert-warning alert-dismissible">
    Alert message
</div>

<!-- ID modifier -->
<input type="email" name="email" id="email-input">

<!-- Combining class and ID -->
<section id="features-section" class="container py-5">
    <h2>Features</h2>
</section>
""",
                preview: {
                    VStack(spacing: 20) {
                        // Single class
                        Div {
                            P("Single class:")
                            Button("Submit")
                                .class("btn-primary")
                                .style("padding", "0.5rem 1rem")
                                .style("background", "#007bff")
                                .style("color", "white")
                                .style("border", "none")
                                .style("border-radius", "4px")
                        }
                        
                        // Multiple classes
                        Div {
                            P("Multiple classes (alert styles):")
                            Div {
                                Text("⚠️ Alert message")
                            }
                            .class("alert alert-warning")
                            .style("background", "#fff3cd")
                            .style("border", "1px solid #ffeaa7")
                            .style("color", "#856404")
                            .style("padding", "0.75rem 1.25rem")
                            .style("border-radius", "0.25rem")
                        }
                        
                        // ID and class
                        Div {
                            P("ID and class combined:")
                            Section {
                                H3("Features Section")
                                    .style("margin", "0")
                                P("This section has id='features-section' and class='container py-5'")
                                    .style("margin", "0.5rem 0 0 0")
                                    .style("color", "#6c757d")
                            }
                            .id("features-section")
                            .class("container")
                            .style("background", "#f8f9fa")
                            .style("padding", "2rem")
                            .style("border-radius", "0.5rem")
                        }
                    }
                },
                description: "Add CSS classes and unique IDs to elements for styling and JavaScript interaction."
            ).render()
            }
            
            // Style Modifiers
            Section {
            CodeExample(
                title: "Style Modifiers",
                swift: """
// Basic styles
Text("Styled text")
    .style("color", "#dc3545")
    .style("font-size", "1.25rem")
    .style("font-weight", "bold")

// Layout styles
Div {
    Text("Centered content")
}
.style("display", "flex")
.style("justify-content", "center")
.style("align-items", "center")
.style("height", "100px")
.style("background", "#e9ecef")

// Complex styling
Button("Gradient Button")
    .style("background", "linear-gradient(45deg, #667eea 0%, #764ba2 100%)")
    .style("color", "white")
    .style("padding", "12px 24px")
    .style("border", "none")
    .style("border-radius", "25px")
    .style("box-shadow", "0 4px 15px rgba(0,0,0,0.2)")
    .style("cursor", "pointer")
    .style("transition", "transform 0.2s")

// Responsive styles
Img(src: "/logo.png", alt: "Logo")
    .style("width", "100%")
    .style("max-width", "400px")
    .style("height", "auto")
""",
                html: """
<!-- Basic styles -->
<span style="color: #dc3545; font-size: 1.25rem; font-weight: bold;">Styled text</span>

<!-- Layout styles -->
<div style="display: flex; justify-content: center; align-items: center; height: 100px; background: #e9ecef;">
    Centered content
</div>

<!-- Complex styling -->
<button style="background: linear-gradient(45deg, #667eea 0%, #764ba2 100%); color: white; padding: 12px 24px; border: none; border-radius: 25px; box-shadow: 0 4px 15px rgba(0,0,0,0.2); cursor: pointer; transition: transform 0.2s;">
    Gradient Button
</button>

<!-- Responsive styles -->
<img src="/logo.png" alt="Logo" style="width: 100%; max-width: 400px; height: auto;">
""",
                preview: {
                    VStack(spacing: 25) {
                        // Basic styles
                        Div {
                            P("Basic styles:")
                            Text("Styled text")
                                .style("color", "#dc3545")
                                .style("font-size", "1.25rem")
                                .style("font-weight", "bold")
                        }
                        
                        // Layout styles
                        Div {
                            P("Layout styles (flexbox centering):")
                            Div {
                                Text("Centered content")
                            }
                            .style("display", "flex")
                            .style("justify-content", "center")
                            .style("align-items", "center")
                            .style("height", "100px")
                            .style("background", "#e9ecef")
                            .style("border-radius", "0.5rem")
                        }
                        
                        // Complex styling
                        Div {
                            P("Complex styling (gradient button):")
                            Button("Gradient Button")
                                .style("background", "linear-gradient(45deg, #667eea 0%, #764ba2 100%)")
                                .style("color", "white")
                                .style("padding", "12px 24px")
                                .style("border", "none")
                                .style("border-radius", "25px")
                                .style("box-shadow", "0 4px 15px rgba(0,0,0,0.2)")
                                .style("cursor", "pointer")
                                .style("transition", "transform 0.2s")
                                .style("font-size", "16px")
                                .style("font-weight", "600")
                        }
                        
                        // Responsive image
                        Div {
                            P("Responsive styles:")
                            Div {
                                Text("🖼️")
                                    .style("font-size", "4rem")
                                    .style("text-align", "center")
                                    .style("line-height", "1")
                            }
                            .style("width", "100%")
                            .style("max-width", "200px")
                            .style("background", "#f8f9fa")
                            .style("padding", "2rem")
                            .style("border", "2px dashed #dee2e6")
                            .style("border-radius", "0.5rem")
                            .style("margin", "0 auto")
                        }
                    }
                },
                description: "Apply inline CSS styles directly to elements with type-safe style modifiers."
            ).render()
            }
            
            // Attribute Modifiers
            Section {
            CodeExample(
                title: "Attribute Modifiers",
                swift: """
// Standard attributes
Input(type: "text", name: "username")
    .attribute("placeholder", "Enter username")
    .attribute("required", "required")
    .attribute("autofocus", "autofocus")

// Data attributes
Button("Delete")
    .data("user-id", "123")
    .data("action", "delete")
    .data("confirm", "true")

// ARIA attributes for accessibility
Nav {
    Link(href: "#main", "Skip to main content")
}
.attribute("role", "navigation")
.attribute("aria-label", "Main navigation")

// Custom attributes
Div {
    Text("Tooltip example")
}
.attribute("data-bs-toggle", "tooltip")
.attribute("data-bs-placement", "top")
.attribute("title", "This is a tooltip!")

// Multiple attributes
Video(src: "/demo.mp4")
    .attribute("controls", "controls")
    .attribute("loop", "loop")
    .attribute("muted", "muted")
    .attribute("playsinline", "playsinline")
    .style("width", "100%")
""",
                html: """
<!-- Standard attributes -->
<input type="text" name="username" placeholder="Enter username" required="required" autofocus="autofocus">

<!-- Data attributes -->
<button data-user-id="123" data-action="delete" data-confirm="true">Delete</button>

<!-- ARIA attributes -->
<nav role="navigation" aria-label="Main navigation">
    <a href="#main">Skip to main content</a>
</nav>

<!-- Custom attributes -->
<div data-bs-toggle="tooltip" data-bs-placement="top" title="This is a tooltip!">
    Tooltip example
</div>

<!-- Multiple attributes -->
<video src="/demo.mp4" controls="controls" loop="loop" muted="muted" playsinline="playsinline" style="width: 100%;"></video>
""",
                preview: {
                    VStack(spacing: 25) {
                        // Standard attributes
                        Div {
                            P("Standard attributes:")
                            Input(type: "text", name: "username")
                                .attribute("placeholder", "Enter username")
                                .attribute("required", "required")
                                .style("width", "100%")
                                .style("padding", "0.5rem")
                                .style("border", "1px solid #ced4da")
                                .style("border-radius", "4px")
                        }
                        
                        // Data attributes
                        Div {
                            P("Data attributes (inspect element to see):")
                            Button("Delete")
                                .data("user-id", "123")
                                .data("action", "delete")
                                .data("confirm", "true")
                                .style("background", "#dc3545")
                                .style("color", "white")
                                .style("padding", "0.5rem 1rem")
                                .style("border", "none")
                                .style("border-radius", "4px")
                        }
                        
                        // ARIA attributes
                        Div {
                            P("ARIA attributes for accessibility:")
                            Nav {
                                Link(href: "#main", "Skip to main content")
                                    .style("background", "#007bff")
                                    .style("color", "white")
                                    .style("padding", "0.5rem 1rem")
                                    .style("text-decoration", "none")
                                    .style("border-radius", "4px")
                                    .style("display", "inline-block")
                            }
                            .attribute("role", "navigation")
                            .attribute("aria-label", "Main navigation")
                            .style("background", "#f8f9fa")
                            .style("padding", "1rem")
                            .style("border-radius", "0.5rem")
                        }
                        
                        // Tooltip attributes
                        Div {
                            P("Custom attributes (tooltip):")
                            Div {
                                Text("🔍 Hover for tooltip")
                            }
                            .attribute("data-bs-toggle", "tooltip")
                            .attribute("data-bs-placement", "top")
                            .attribute("title", "This is a tooltip!")
                            .style("background", "#e9ecef")
                            .style("padding", "1rem")
                            .style("border-radius", "0.5rem")
                            .style("text-align", "center")
                            .style("cursor", "help")
                        }
                    }
                },
                description: "Set HTML attributes including data attributes, ARIA attributes, and custom attributes."
            ).render()
            }
            
            // Convenience Modifiers
            Section {
            CodeExample(
                title: "Convenience Modifiers",
                swift: """
// Padding and margin shortcuts
Div {
    Text("Spaced content")
}
.padding(20)                    // All sides
.margin(10)                     // All sides

// Size modifiers
Img(src: "/photo.jpg", alt: "Photo")
    .width(300)
    .height(200)

// Display and visibility
Span("Hidden on mobile")
    .hidden()                   // display: none
    
Div {
    Text("Centered text")
}
.center()                       // text-align: center
.width(300)
.padding(20)

// Background and colors
Section {
    H2("Colored Section")
}
.background("#f8f9fa")
.foregroundColor("#212529")

// Text styling
Text("Important notice")
    .bold()
    .fontSize(18)
    .foregroundColor("#dc3545")

// Border and corners
Div {
    Text("Rounded card")
}
.border(2, "solid", "#dee2e6")
.cornerRadius(12)
.padding(24)
""",
                html: """
<!-- Padding and margin -->
<div style="padding: 20px; margin: 10px;">
    Spaced content
</div>

<!-- Size modifiers -->
<img src="/photo.jpg" alt="Photo" style="width: 300px; height: 200px;">

<!-- Display and visibility -->
<span style="display: none;">Hidden on mobile</span>

<div style="text-align: center; width: 300px; padding: 20px;">
    Centered text
</div>

<!-- Background and colors -->
<section style="background-color: #f8f9fa; color: #212529;">
    <h2>Colored Section</h2>
</section>

<!-- Text styling -->
<span style="font-weight: bold; font-size: 18px; color: #dc3545;">Important notice</span>

<!-- Border and corners -->
<div style="border: 2px solid #dee2e6; border-radius: 12px; padding: 24px;">
    Rounded card
</div>
""",
                preview: {
                    VStack(spacing: 25) {
                        // Padding and margin
                        Div {
                            P("Padding and margin:")
                            Div {
                                Text("Spaced content")
                            }
                            .style("padding", "20px")
                            .style("margin", "10px 0")
                            .style("background", "#e7f3ff")
                            .style("border", "1px solid #b8daff")
                        }
                        
                        // Size modifiers
                        Div {
                            P("Size modifiers:")
                            Div {
                                Text("📷 300x200")
                                    .style("font-size", "2rem")
                                    .style("text-align", "center")
                                    .style("line-height", "200px")
                            }
                            .style("width", "300px")
                            .style("height", "200px")
                            .style("background", "#f8f9fa")
                            .style("border", "2px dashed #dee2e6")
                        }
                        
                        // Display and visibility
                        Div {
                            P("Centered text and visibility:")
                            Div {
                                Text("Centered text")
                            }
                            .center()
                            .width(300)
                            .padding(20)
                            .style("background", "#e9ecef")
                            .style("border", "1px solid #dee2e6")
                        }
                        
                        // Colors and text styling
                        Div {
                            P("Colors and text styling:")
                            Section {
                                H3("Colored Section")
                                    .style("margin", "0 0 1rem 0")
                                Text("Important notice")
                                    .bold()
                                    .fontSize(18)
                                    .foregroundColor("#dc3545")
                            }
                            .background("#f8f9fa")
                            .foregroundColor("#212529")
                            .padding(20)
                            .style("border-radius", "0.5rem")
                        }
                        
                        // Border and corners
                        Div {
                            P("Border and corner radius:")
                            Div {
                                Text("Rounded card with border")
                            }
                            .border(2, "solid", "#dee2e6")
                            .cornerRadius(12)
                            .padding(24)
                            .background("white")
                            .center()
                        }
                    }
                },
                description: "Swiftlets provides convenience modifiers for common styling patterns."
            ).render()
            }
            
            // Modifier Chaining
            Section {
            CodeExample(
                title: "Modifier Chaining",
                swift: """
// Complex button with multiple modifiers
Button("Get Started")
    .class("btn btn-lg")
    .id("cta-button")
    .style("background", "linear-gradient(135deg, #667eea 0%, #764ba2 100%)")
    .style("color", "white")
    .style("padding", "1rem 2rem")
    .style("font-size", "1.125rem")
    .style("font-weight", "600")
    .style("border", "none")
    .style("border-radius", "50px")
    .style("box-shadow", "0 10px 30px rgba(0,0,0,0.3)")
    .style("cursor", "pointer")
    .style("transition", "all 0.3s ease")
    .attribute("data-action", "signup")
    .attribute("aria-label", "Get started with our service")

// Card component with extensive styling
Article {
    Img(src: "/feature.jpg", alt: "Feature")
        .style("width", "100%")
        .style("height", "200px")
        .style("object-fit", "cover")
    
    Div {
        H3("Feature Title")
            .style("margin", "0 0 0.5rem 0")
            .style("color", "#212529")
        
        P("Description of this amazing feature.")
            .style("color", "#6c757d")
            .style("margin", "0 0 1rem 0")
        
        Link(href: "/learn-more", "Learn More →")
            .class("read-more-link")
            .style("color", "#007bff")
            .style("text-decoration", "none")
            .style("font-weight", "500")
    }
    .style("padding", "1.5rem")
}
.class("feature-card")
.style("background", "white")
.style("border-radius", "0.5rem")
.style("box-shadow", "0 2px 8px rgba(0,0,0,0.1)")
.style("overflow", "hidden")
.style("transition", "transform 0.2s, box-shadow 0.2s")
.attribute("data-category", "features")

// Form field with validation styling
Div {
    Label("Email Address")
        .attribute("for", "email")
        .style("display", "block")
        .style("margin-bottom", "0.5rem")
        .style("font-weight", "600")
    
    Input(type: "email", name: "email")
        .id("email")
        .class("form-control")
        .attribute("placeholder", "you@example.com")
        .attribute("required", "required")
        .style("width", "100%")
        .style("padding", "0.75rem")
        .style("border", "2px solid #ced4da")
        .style("border-radius", "0.375rem")
        .style("font-size", "1rem")
        .style("transition", "border-color 0.15s")
        .data("validation", "email")
}
.class("form-group")
.style("margin-bottom", "1.5rem")
""",
                html: """
<!-- Complex button -->
<button class="btn btn-lg" id="cta-button" 
    style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 1rem 2rem; font-size: 1.125rem; font-weight: 600; border: none; border-radius: 50px; box-shadow: 0 10px 30px rgba(0,0,0,0.3); cursor: pointer; transition: all 0.3s ease;"
    data-action="signup" 
    aria-label="Get started with our service">
    Get Started
</button>

<!-- Feature card -->
<article class="feature-card" 
    style="background: white; border-radius: 0.5rem; box-shadow: 0 2px 8px rgba(0,0,0,0.1); overflow: hidden; transition: transform 0.2s, box-shadow 0.2s;"
    data-category="features">
    <img src="/feature.jpg" alt="Feature" style="width: 100%; height: 200px; object-fit: cover;">
    <div style="padding: 1.5rem;">
        <h3 style="margin: 0 0 0.5rem 0; color: #212529;">Feature Title</h3>
        <p style="color: #6c757d; margin: 0 0 1rem 0;">Description of this amazing feature.</p>
        <a href="/learn-more" class="read-more-link" style="color: #007bff; text-decoration: none; font-weight: 500;">Learn More →</a>
    </div>
</article>

<!-- Form field -->
<div class="form-group" style="margin-bottom: 1.5rem;">
    <label for="email" style="display: block; margin-bottom: 0.5rem; font-weight: 600;">Email Address</label>
    <input type="email" name="email" id="email" class="form-control"
        placeholder="you@example.com" required="required"
        style="width: 100%; padding: 0.75rem; border: 2px solid #ced4da; border-radius: 0.375rem; font-size: 1rem; transition: border-color 0.15s;"
        data-validation="email">
</div>
""",
                preview: {
                    VStack(spacing: 30) {
                        // Complex button
                        Div {
                            P("Complex button with chained modifiers:")
                            Button("Get Started")
                                .class("btn btn-lg")
                                .id("cta-button")
                                .style("background", "linear-gradient(135deg, #667eea 0%, #764ba2 100%)")
                                .style("color", "white")
                                .style("padding", "1rem 2rem")
                                .style("font-size", "1.125rem")
                                .style("font-weight", "600")
                                .style("border", "none")
                                .style("border-radius", "50px")
                                .style("box-shadow", "0 10px 30px rgba(0,0,0,0.3)")
                                .style("cursor", "pointer")
                                .style("transition", "all 0.3s ease")
                                .attribute("data-action", "signup")
                                .attribute("aria-label", "Get started with our service")
                        }
                        
                        // Feature card
                        Div {
                            P("Feature card with extensive styling:")
                            Article {
                                Div {
                                    Text("🖼️")
                                        .style("font-size", "3rem")
                                        .style("text-align", "center")
                                        .style("line-height", "200px")
                                }
                                .style("width", "100%")
                                .style("height", "200px")
                                .style("background", "#e9ecef")
                                
                                Div {
                                    H3("Feature Title")
                                        .style("margin", "0 0 0.5rem 0")
                                        .style("color", "#212529")
                                    
                                    P("Description of this amazing feature that showcases modifier chaining.")
                                        .style("color", "#6c757d")
                                        .style("margin", "0 0 1rem 0")
                                    
                                    Link(href: "#", "Learn More →")
                                        .class("read-more-link")
                                        .style("color", "#007bff")
                                        .style("text-decoration", "none")
                                        .style("font-weight", "500")
                                }
                                .style("padding", "1.5rem")
                            }
                            .class("feature-card")
                            .style("background", "white")
                            .style("border-radius", "0.5rem")
                            .style("box-shadow", "0 2px 8px rgba(0,0,0,0.1)")
                            .style("overflow", "hidden")
                            .style("transition", "transform 0.2s, box-shadow 0.2s")
                            .style("max-width", "350px")
                            .attribute("data-category", "features")
                        }
                        
                        // Form field
                        Div {
                            P("Form field with validation styling:")
                            Div {
                                Label("Email Address")
                                    .attribute("for", "email")
                                    .style("display", "block")
                                    .style("margin-bottom", "0.5rem")
                                    .style("font-weight", "600")
                                
                                Input(type: "email", name: "email")
                                    .id("email")
                                    .class("form-control")
                                    .attribute("placeholder", "you@example.com")
                                    .attribute("required", "required")
                                    .style("width", "100%")
                                    .style("padding", "0.75rem")
                                    .style("border", "2px solid #ced4da")
                                    .style("border-radius", "0.375rem")
                                    .style("font-size", "1rem")
                                    .style("transition", "border-color 0.15s")
                                    .data("validation", "email")
                            }
                            .class("form-group")
                            .style("margin-bottom", "1.5rem")
                            .style("max-width", "400px")
                        }
                    }
                },
                description: "Chain multiple modifiers together to build complex styled components."
            ).render()
            }
            
            // Best Practices
            Section {
            CodeExample(
                title: "Best Practices",
                swift: """
// 1. Use semantic class names over inline styles
// Good: Reusable classes
Button("Submit")
    .class("btn btn-primary btn-lg")

// Avoid: Repetitive inline styles
Button("Submit")
    .style("background", "#007bff")
    .style("color", "white")
    .style("padding", "0.75rem 1.5rem")
    // ... many more styles

// 2. Group related modifiers logically
Card {
    // Content structure
    H3("Title")
    P("Description")
}
// Visual styling
.class("card shadow")
.style("background", "white")
.style("border-radius", "0.5rem")
// Behavior
.attribute("data-clickable", "true")
.style("cursor", "pointer")

// 3. Use data attributes for JavaScript hooks
Button("Save")
    .id("save-btn")              // For unique elements
    .class("js-save-trigger")    // For behavior hooks
    .data("endpoint", "/api/save") // For data passing

// 4. Always include accessibility attributes
Img(src: "/chart.png", alt: "Sales chart showing Q4 growth")
    .attribute("role", "img")
    .attribute("aria-label", "Sales increased 25% in Q4")

// 5. Leverage modifier functions for common patterns
extension HTMLElement {
    func primaryButton() -> some HTMLElement {
        self
            .class("btn btn-primary")
            .style("padding", "0.5rem 1rem")
            .style("border-radius", "0.25rem")
    }
}

// Usage:
Button("Click Me").primaryButton()
""",
                html: """
<!-- Use semantic classes -->
<button class="btn btn-primary btn-lg">Submit</button>

<!-- Grouped modifiers -->
<div class="card shadow" 
     style="background: white; border-radius: 0.5rem; cursor: pointer;"
     data-clickable="true">
    <h3>Title</h3>
    <p>Description</p>
</div>

<!-- JavaScript hooks -->
<button id="save-btn" class="js-save-trigger" data-endpoint="/api/save">Save</button>

<!-- Accessibility -->
<img src="/chart.png" 
     alt="Sales chart showing Q4 growth"
     role="img" 
     aria-label="Sales increased 25% in Q4">
""",
                preview: {
                    VStack(spacing: 20) {
                        Div {
                            H4("Best Practices Examples")
                                .style("color", "#212529")
                                .style("margin-bottom", "1rem")
                            
                            // Semantic classes
                            Div {
                                P("1. Use semantic class names:")
                                    .style("font-weight", "600")
                                Button("Submit")
                                    .class("btn btn-primary")
                                    .style("background", "#007bff")
                                    .style("color", "white")
                                    .style("padding", "0.5rem 1rem")
                                    .style("border", "none")
                                    .style("border-radius", "0.25rem")
                            }
                            
                            HR()
                                .style("margin", "1.5rem 0")
                            
                            // Grouped modifiers
                            Div {
                                P("2. Group related modifiers:")
                                    .style("font-weight", "600")
                                Div {
                                    H3("Card Title")
                                        .style("margin", "0 0 0.5rem 0")
                                    P("Card with grouped visual and behavior modifiers")
                                        .style("margin", "0")
                                }
                                .class("card")
                                .style("background", "white")
                                .style("border", "1px solid #dee2e6")
                                .style("border-radius", "0.5rem")
                                .style("padding", "1rem")
                                .style("box-shadow", "0 2px 4px rgba(0,0,0,0.1)")
                                .style("cursor", "pointer")
                                .attribute("data-clickable", "true")
                            }
                            
                            HR()
                                .style("margin", "1.5rem 0")
                            
                            // JavaScript hooks
                            Div {
                                P("3. JavaScript hooks with data attributes:")
                                    .style("font-weight", "600")
                                Button("Save")
                                    .id("save-btn")
                                    .class("js-save-trigger")
                                    .data("endpoint", "/api/save")
                                    .style("background", "#28a745")
                                    .style("color", "white")
                                    .style("padding", "0.5rem 1rem")
                                    .style("border", "none")
                                    .style("border-radius", "0.25rem")
                            }
                            
                            HR()
                                .style("margin", "1.5rem 0")
                            
                            // Accessibility
                            Div {
                                P("4. Always include accessibility:")
                                    .style("font-weight", "600")
                                Div {
                                    Text("📊")
                                        .style("font-size", "3rem")
                                        .style("text-align", "center")
                                }
                                .attribute("role", "img")
                                .attribute("aria-label", "Sales increased 25% in Q4")
                                .style("background", "#f8f9fa")
                                .style("padding", "1rem")
                                .style("border-radius", "0.5rem")
                            }
                        }
                        .style("background", "#f8f9fa")
                        .style("padding", "1.5rem")
                        .style("border-radius", "0.5rem")
                    }
                },
                description: "Tips for effective use of modifiers in your Swiftlets applications."
            ).render()
            }
            
            Div {
            Link(href: "/showcase/layout-components", "Layout Components")
                .class("nav-button")
            Link(href: "/showcase", "Back to Showcase")
                .class("nav-button nav-button-next")
            }
            .class("navigation-links")
            }
            .class("showcase-container")
            
        }
    }
}