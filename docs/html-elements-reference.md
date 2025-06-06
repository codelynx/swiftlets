# SwiftletsHTML Elements Reference

## Complete List of HTML Elements

### Document Structure
- `Html` - Root HTML element
- `Head` - Document head
- `Body` - Document body
- `Title` - Page title
- `Meta` - Metadata
- `Style` - Embedded CSS
- `Script` - JavaScript
- `LinkElement` - External resources
- `NoScript` - Fallback for no-JS

### Text Content
- `H1` through `H6` - Headings
- `P` - Paragraph
- `Div` - Generic container
- `Section` - Thematic section
- `Article` - Self-contained content
- `Span` - Inline container
- `BR` - Line break
- `HR` - Horizontal rule

### Text Formatting
- `Strong` - Bold/important text
- `Em` - Italic/emphasized text
- `Code` - Inline code
- `Pre` - Preformatted text
- `BlockQuote` - Block quotation
- `Q` - Inline quotation
- `Cite` - Citation
- `Mark` - Highlighted text
- `Small` - Small print
- `Abbr` - Abbreviation
- `Kbd` - Keyboard input
- `Samp` - Sample output
- `Var` - Variable
- `Sub` - Subscript
- `Sup` - Superscript
- `Del` - Deleted text
- `Ins` - Inserted text

### Lists
- `UL` - Unordered list
- `OL` - Ordered list
- `LI` - List item
- `DL` - Definition list
- `DT` - Definition term
- `DD` - Definition description

### Links & Navigation
- `A` / `Link` - Hyperlink
- `Nav` - Navigation section

### Tables
- `Table` - Table container
- `Caption` - Table caption
- `THead` - Table header group
- `TBody` - Table body group
- `TFoot` - Table footer group
- `TR` - Table row
- `TH` - Table header cell
- `TD` - Table data cell

### Forms
- `Form` - Form container
- `FieldSet` - Group related fields
- `Legend` - FieldSet caption
- `Label` - Input label
- `Input` - Various input types
- `TextArea` - Multi-line text input
- `Select` - Dropdown list
- `Option` - Dropdown option
- `Button` - Button element

### Semantic Elements
- `Header` - Page/section header
- `Footer` - Page/section footer
- `Main` - Main content
- `Aside` - Side content
- `Figure` - Self-contained figure
- `FigCaption` - Figure caption

### Media
- `Img` - Image
- `Picture` - Responsive images
- `Source` - Media resource
- `Video` - Video player
- `Audio` - Audio player
- `IFrame` - Embedded frame

### Interactive Elements
- `Details` - Collapsible details
- `Summary` - Details summary
- `Progress` - Progress indicator
- `Meter` - Gauge/measurement
- `Time` - Time/date
- `Data` - Machine-readable data

### Layout Components
- `HStack` - Horizontal stack (flexbox row)
- `VStack` - Vertical stack (flexbox column)
- `ZStack` - Z-axis stack (layered positioning)
- `Spacer` - Flexible space
- `Grid` - CSS Grid container
- `Container` - Max-width container

### Helpers & Utilities
- `Text` - Plain text content
- `RawHTML` - Unescaped HTML
- `ForEach` - Iterate collections
- `ForEachWithIndex` - Iterate with index
- `If` - Conditional rendering
- `Fragment` / `Group` - Group without wrapper
- `EmptyHTML` - Empty placeholder

## Usage Examples

### Basic Page Structure
```swift
Html {
    Head {
        Meta(charset: "utf-8")
        Title("My Page")
    }
    Body {
        H1("Welcome")
        P("Hello, world!")
    }
}
```

### Lists
```swift
UL {
    ForEach(items) { item in
        LI(item.name)
    }
}
```

### Tables
```swift
Table {
    THead {
        TR {
            TH("Name")
            TH("Email")
        }
    }
    TBody {
        ForEach(users) { user in
            TR {
                TD(user.name)
                TD(user.email)
            }
        }
    }
}
```

### Forms
```swift
Form(action: "/submit", method: "POST") {
    Label("Email:", for: "email")
    Input(type: "email", name: "email")
    
    Button("Submit", type: "submit")
}
```

### Conditional Rendering
```swift
If(isLoggedIn) {
    P("Welcome back!")
} else: {
    P("Please log in")
}
```

### Layout Examples
```swift
// Horizontal layout with spacing
HStack(spacing: 16) {
    Text("Left")
    Spacer()
    Text("Right")
}

// Vertical layout with alignment
VStack(alignment: .center, spacing: 12) {
    H2("Title")
    P("Description")
    Button("Action")
}

// Grid layout
Grid(columns: .count(3), spacing: 16) {
    ForEach(items) { item in
        Card(item: item)
    }
}

// Responsive container
Container(maxWidth: .large, padding: 24) {
    // Content constrained to 1024px
}
```

All elements support the standard modifier system for attributes and styles.