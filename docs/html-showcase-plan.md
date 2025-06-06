# HTML Showcase Plan for Swiftlets Site

## Overview

Create comprehensive HTML examples showing both Swift DSL code and generated HTML output, organized by category.

**Status: Partially Implemented** (as of January 2025)

## Current Implementation Status

✅ **Completed:**
- Showcase index page with category navigation
- Basic Elements showcase page  
- CodeExample and CategoryCard components
- Clean, responsive CSS styling
- Proper routing with trailing slash support
- Security fix: executables moved outside web root

🚧 **In Progress:**
- Additional category pages (text-formatting, lists, tables, etc.)

📋 **Planned:**
- Remaining 8 showcase categories
- Search functionality
- Copy code buttons

## Actual Implementation Structure

```
sites/examples/swiftlets-site/
├── src/
│   ├── Components.swift             # Shared components (CodeExample, CategoryCard)
│   ├── showcase/
│   │   ├── index.swift             # Main showcase index ✅
│   │   ├── basic-elements.swift    # Basic HTML elements ✅
│   │   ├── text-formatting.swift   # Text and inline elements 📋
│   │   ├── lists.swift             # All list types 📋
│   │   ├── tables.swift            # Table examples 📋
│   │   ├── forms.swift             # Form elements and inputs 📋
│   │   ├── media.swift             # Images, video, audio 📋
│   │   ├── semantic.swift          # Semantic HTML5 elements 📋
│   │   ├── layout.swift            # HStack, VStack, Grid 📋
│   │   └── modifiers.swift         # Style and attribute modifiers 📋
│   └── [other pages]
├── bin/                            # Compiled executables (OUTSIDE web root for security)
│   ├── showcase/
│   │   ├── index                   # Executable for showcase index
│   │   └── basic-elements          # Executable for basic elements
│   └── [other executables]
└── web/                            # Web root (public files only)
    ├── showcase/
    │   ├── index.webbin            # Route marker
    │   └── basic-elements.webbin   # Route marker
    └── styles/
        └── main.css                # Enhanced with showcase styles
```

## Categories and Content

### 1. Basic Elements
**Route:** `/showcase/basic-elements`

- Headings (H1-H6)
- Paragraphs
- Div and Span
- Links
- Breaks and Horizontal Rules

```swift
// Example structure
VStack {
    H2("Headings")
    CodeExample(
        swift: """
        H1("Main Heading")
        H2("Subheading")
        H3("Section Heading")
        """,
        output: """
        <h1>Main Heading</h1>
        <h2>Subheading</h2>
        <h3>Section Heading</h3>
        """
    )
}
```

### 2. Text Formatting
**Route:** `/showcase/text-formatting`

- Strong, Em, Mark
- Code, Pre, BlockQuote
- Small, Sub, Sup
- Del, Ins
- Abbr, Time

### 3. Lists
**Route:** `/showcase/lists`

- Unordered lists (UL)
- Ordered lists (OL)
- Nested lists
- Definition lists (DL, DT, DD)
- Custom list styles

### 4. Tables
**Route:** `/showcase/tables`

- Basic table structure
- Headers and footers
- Captions
- Column groups
- Responsive tables
- Styled tables

### 5. Forms
**Route:** `/showcase/forms`

- Input types (text, email, password, etc.)
- TextArea
- Select and Options
- Checkboxes and Radio buttons
- Buttons
- Labels and Fieldsets
- Form validation attributes

### 6. Media
**Route:** `/showcase/media`

- Images with attributes
- Picture element
- Video controls
- Audio players
- IFrames
- Figure and FigCaption

### 7. Semantic HTML
**Route:** `/showcase/semantic`

- Header, Footer, Nav
- Main, Article, Section
- Aside, Details, Summary
- Address, Time
- Progress, Meter

### 8. Layout Components
**Route:** `/showcase/layout`

- HStack with alignment
- VStack with spacing
- Grid layouts
- Container widths
- Spacer usage
- Responsive layouts

### 9. Modifiers
**Route:** `/showcase/modifiers`

- Class and ID
- Inline styles
- Data attributes
- ARIA attributes
- Event handlers
- Custom attributes

### 10. Advanced Examples
**Route:** `/showcase/advanced`

- Navigation bars
- Card components
- Modal dialogs
- Accordion/Collapse
- Tab interfaces
- Complete form examples

## Implementation Strategy

### 1. Create CodeExample Component

```swift
struct CodeExample: HTMLElement {
    let swift: String
    let output: String
    let title: String?
    
    var body: some HTMLElement {
        Div {
            if let title = title {
                H4(title)
            }
            
            Div {
                H5("Swift Code:")
                Pre {
                    Code(swift)
                        .class("language-swift")
                }
            }
            .class("code-section")
            
            Div {
                H5("Generated HTML:")
                Pre {
                    Code(output.escaped())
                        .class("language-html")
                }
            }
            .class("output-section")
            
            Div {
                H5("Rendered Output:")
                Div {
                    // Render the actual HTML
                    Fragment(html: output)
                }
                .class("preview-box")
            }
            .class("preview-section")
        }
        .class("code-example")
    }
}
```

### 2. Create Syntax Highlighting

Add CSS for code highlighting:
```css
.code-example {
    margin: 2rem 0;
    border: 1px solid #e0e0e0;
    border-radius: 8px;
}

.code-section, .output-section {
    background: #f5f5f5;
    padding: 1rem;
}

.preview-box {
    border: 1px dashed #ccc;
    padding: 1rem;
    background: white;
}
```

### 3. Navigation Structure

Update showcase index to list all categories:
```swift
// showcase.swift
VStack {
    H1("HTML Elements Showcase")
    
    P("Explore all HTML elements available in Swiftlets with live examples")
    
    Grid(columns: 2) {
        CategoryCard(
            title: "Basic Elements",
            description: "Headings, paragraphs, links",
            href: "/showcase/basic-elements"
        )
        
        CategoryCard(
            title: "Text Formatting",
            description: "Bold, italic, code blocks",
            href: "/showcase/text-formatting"
        )
        
        // ... more categories
    }
}
```

## Benefits

1. **Learning Resource**: Developers can see Swift code and output side-by-side
2. **Copy-Paste Ready**: Examples can be copied directly
3. **Comprehensive Coverage**: All HTML elements documented
4. **Interactive**: See rendered output immediately
5. **Searchable**: Organized by category for easy discovery

## Future Enhancements

1. **Live Editor**: Allow editing Swift code and see results
2. **Search**: Full-text search across examples
3. **Playground**: Interactive playground for testing
4. **Export**: Download examples as Swift files
5. **Themes**: Different CSS themes for previews

## Implementation Order

1. Create CodeExample component and helper utilities
2. Implement basic-elements page as proof of concept
3. Add syntax highlighting CSS
4. Create remaining category pages
5. Update main showcase index
6. Add navigation between sections
7. Polish with better styling and organization