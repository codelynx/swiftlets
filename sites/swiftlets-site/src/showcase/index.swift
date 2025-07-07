import Swiftlets

@main
struct ShowcasePage: SwiftletMain {
    var title = "Showcase - Swiftlets"
    
    var body: some HTMLElement {
        Fragment {
            modernStyles()
            navBar()
            hero()
            categories()
            footer()
        }
    }
    
    @HTMLBuilder
    func modernStyles() -> some HTMLElement {
        Style("""
        /* Modern Showcase Styles */
        body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; }
        
        .nav-modern {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            box-shadow: 0 2px 4px rgba(0,0,0,0.06);
            position: sticky;
            top: 0;
            z-index: 100;
        }
        
        .showcase-hero {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 5rem 0;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .showcase-hero h1 {
            font-size: 3.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
        }
        
        .showcase-hero p {
            font-size: 1.5rem;
            opacity: 0.9;
        }
        
        .showcase-card {
            background: white;
            border-radius: 0.75rem;
            padding: 2rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.07);
            transition: all 0.3s ease;
            border: 1px solid #e9ecef;
        }
        
        .showcase-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 25px rgba(0,0,0,0.1);
            border-color: transparent;
        }
        
        .showcase-card-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
            display: block;
        }
        
        .showcase-card h3 {
            color: #2c3e50;
            margin-bottom: 0.5rem;
            font-size: 1.5rem;
        }
        
        .showcase-card p {
            color: #6c757d;
            line-height: 1.6;
            margin: 0;
        }
        
        a { text-decoration: none; color: inherit; }
        a:hover { opacity: 0.8; }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .animate-fadeIn {
            animation: fadeIn 0.6s ease-out;
        }
        """)
    }
    
    @HTMLBuilder
    func navBar() -> some HTMLElement {
        showcaseNav()
    }
    
    @HTMLBuilder 
    func hero() -> some HTMLElement {
        showcaseHero(
            title: "Component Showcase",
            subtitle: "Explore beautiful, modern components built with Swiftlets"
        )
    }
    
    @HTMLBuilder
    func categories() -> some HTMLElement {
        Section {
            Container(maxWidth: .large) {
                H2("Browse by Category")
                    .style("margin-bottom", "2rem")
                    .style("color", "#2c3e50")
                
                Grid(columns: .count(3), spacing: 24) {
                    categoryCard("Basic Elements", "Headings, paragraphs, and more", "/showcase/basic-elements", "📝")
                    categoryCard("Text Formatting", "Bold, italic, code, quotes", "/showcase/text-formatting", "✨")
                    categoryCard("Lists & Tables", "Ordered, unordered lists", "/showcase/list-examples", "📋")
                    categoryCard("Forms", "Input types and form elements", "/showcase/forms", "📝")
                    categoryCard("Media", "Images, audio, video", "/showcase/media-elements", "🎬")
                    categoryCard("Layout", "HStack, VStack, Grid", "/showcase/layout-components", "🏗️")
                }
            }
        }
        .style("padding", "4rem 0")
        .style("background", "#f8f9fa")
    }
    
    @HTMLBuilder
    func categoryCard(_ title: String, _ desc: String, _ href: String, _ icon: String) -> some HTMLElement {
        showcaseCard(
            title: title,
            description: desc,
            href: href,
            icon: icon
        )
    }
    
    @HTMLBuilder
    func footer() -> some HTMLElement {
        showcaseFooter()
    }
}