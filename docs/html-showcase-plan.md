# HTML Showcase Plan for Swiftlets Site

## Overview

Create comprehensive HTML examples showing both Swift DSL code and generated HTML output, organized by category.

**Status: Implementation Complete** (as of June 2025)

## Current Implementation Status

✅ **Completed:**
- Showcase index page with category navigation
- Basic Elements showcase page  
- Text Formatting showcase page
- Lists showcase page (all list elements working)
- Forms showcase page (all form elements and input types)
- Media showcase page (all media elements working - Img, Picture, Video, Audio, IFrame)
- Semantic HTML showcase page (Header, Footer, Nav, Main, Article, Section, Aside, Figure, Details, Progress, Meter, Data)
- Layout Components showcase page (HStack, VStack, ZStack, Grid, Container, Spacer)
- Modifiers showcase page (classes, styles, attributes, data attributes, convenience modifiers, chaining)
- CodeExample and CategoryCard components
- Clean, responsive CSS styling with enhanced table, list, form, media, layout, and modifier styles
- Navigation links with card-style category display and navigation buttons between pages
- Proper routing with trailing slash support
- Security fix: executables moved outside web root
- CSS-based chart visualization in semantic showcase
- Complex dashboard layout example combining all components
- Best practices section in modifiers showcase

⚠️ **Resolved Issues:**
- Lists compilation issue fixed by renaming file from `lists.swift` to `list-examples.swift`
- Media compilation issue fixed by renaming file from `media.swift` to `media-elements.swift`
- Semantic compilation issue fixed by renaming file from `semantic.swift` to `semantic-html.swift`
- Layout compilation issue fixed by renaming file from `layout.swift` to `layout-components.swift`
- Routing mismatches fixed by ensuring webbin files match expected names
- Grid `.flexible()` API mismatch resolved using `.custom()` with CSS grid syntax
- Convenience modifier API differences resolved (e.g., `.background()` vs `.style("background-color")`)

🔴 **Still Blocked:**
- Tables showcase - Table elements (Table, THead, TBody, etc.) not exported from framework
- Some elements not implemented: ColGroup, Col, OptGroup

📋 **Future Enhancements:**
- Advanced examples page (combining multiple showcases)
- Search functionality across examples
- Copy code buttons for easy code reuse
- Live preview editing
- Dark mode support

## Actual Implementation Structure

```
sites/examples/swiftlets-site/
├── src/
│   ├── Components.swift             # Shared components (CodeExample, CategoryCard)
│   ├── showcase/
│   │   ├── index.swift             # Main showcase index ✅
│   │   ├── basic-elements.swift    # Basic HTML elements ✅
│   │   ├── text-formatting.swift   # Text and inline elements ✅
│   │   ├── list-examples.swift     # All list types ✅
│   │   ├── forms.swift             # Form elements and inputs ✅
│   │   ├── media-elements.swift    # Images, video, audio ✅
│   │   ├── semantic-html.swift     # Semantic HTML5 elements ✅
│   │   ├── layout-components.swift # HStack, VStack, Grid ✅
│   │   └── modifiers.swift         # Style and attribute modifiers ✅
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

### 2. Text Formatting ✅
**Route:** `/showcase/text-formatting`

**Implemented elements:**
- Strong, Em, Mark, Small
- Code, Pre, BlockQuote
- Sub, Sup
- Del, Ins  
- Abbr, Time
- Q, Cite
- Kbd, Samp, Var
- Data
- HR (horizontal rule)

**Note:** Some elements like Br, S (strikethrough), Dfn, Ruby, Wbr are not yet implemented in Swiftlets

### 3. Lists ✅
**Route:** `/showcase/lists`

**Implemented elements:**
- Unordered lists (UL) with nested lists
- Ordered lists (OL) with custom styling
- Definition lists (DL, DT, DD)
- Styled lists with custom CSS classes
- Mixed list types (combining OL and UL)

**Note:** The showcase file is named `list-examples.swift` to avoid compilation conflicts with the framework's `Lists.swift` file

### 4. Tables ❌ (Temporarily Removed)
**Route:** `/showcase/tables`

**Status:** Removed due to table elements not being exported from Swiftlets framework

**Would include:**
- Basic table structure
- Headers and footers (THead, TBody, TFoot)
- Table rows and cells (TR, TH, TD)
- Captions
- Styled tables (striped, bordered, responsive)
- Complex tables with spanning cells

**Blocking issues:**
- Table, THead, TBody, TFoot, TR, TH, TD, Caption elements defined but not exported
- ColGroup and Col elements are not yet implemented in Swiftlets

### 5. Forms ✅
**Route:** `/showcase/forms`

**Implemented elements:**
- All HTML5 input types (text, email, password, number, date, time, color, range, file, search, url, tel)
- TextArea with rows and placeholder
- Select with Option elements (using disabled options for grouping)
- Checkboxes and Radio buttons
- Button elements (submit and reset)
- Form with action and method
- Label with for attribute
- FieldSet and Legend for grouping
- Form validation attributes (required, min, max, etc.)

**Note:** OptGroup element not yet implemented in Swiftlets

### 6. Media ⚠️ (Placeholder Created)
**Route:** `/showcase/media`

**Status:** Created placeholder page due to media elements not being exported

**Would include:**
- Images with attributes
- Picture element
- Video controls
- Audio players
- IFrames
- Figure and FigCaption

**Blocking issues:**
- Img, Picture, Source, Video, Audio, IFrame elements defined but not exported from framework

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