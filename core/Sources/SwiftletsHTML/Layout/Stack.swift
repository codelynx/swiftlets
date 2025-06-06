/// Horizontal stack layout using flexbox
public struct HStack<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    private let alignment: VerticalAlignment
    private let spacing: Int?
    
    public enum VerticalAlignment {
        case top
        case center
        case bottom
        case stretch
        case baseline
        
        var cssValue: String {
            switch self {
            case .top: return "flex-start"
            case .center: return "center"
            case .bottom: return "flex-end"
            case .stretch: return "stretch"
            case .baseline: return "baseline"
            }
        }
    }
    
    public init(
        alignment: VerticalAlignment = .center,
        spacing: Int? = nil,
        @HTMLBuilder content: () -> Content
    ) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content()
        
        // Apply flexbox styles
        self.attributes.styles["display"] = "flex"
        self.attributes.styles["flex-direction"] = "row"
        self.attributes.styles["align-items"] = alignment.cssValue
        
        if let spacing = spacing {
            self.attributes.styles["gap"] = "\(spacing)px"
        }
    }
    
    public func render() -> String {
        "<div\(attributes.render())>\(content.render())</div>"
    }
}

/// Vertical stack layout using flexbox
public struct VStack<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    private let alignment: HorizontalAlignment
    private let spacing: Int?
    
    public enum HorizontalAlignment {
        case leading
        case center
        case trailing
        case stretch
        
        var cssValue: String {
            switch self {
            case .leading: return "flex-start"
            case .center: return "center"
            case .trailing: return "flex-end"
            case .stretch: return "stretch"
            }
        }
    }
    
    public init(
        alignment: HorizontalAlignment = .stretch,
        spacing: Int? = nil,
        @HTMLBuilder content: () -> Content
    ) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content()
        
        // Apply flexbox styles
        self.attributes.styles["display"] = "flex"
        self.attributes.styles["flex-direction"] = "column"
        self.attributes.styles["align-items"] = alignment.cssValue
        
        if let spacing = spacing {
            self.attributes.styles["gap"] = "\(spacing)px"
        }
    }
    
    public func render() -> String {
        "<div\(attributes.render())>\(content.render())</div>"
    }
}

/// Z-axis stack layout using absolute positioning
public struct ZStack<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    private let alignment: Alignment
    
    public enum Alignment {
        case topLeading
        case top
        case topTrailing
        case leading
        case center
        case trailing
        case bottomLeading
        case bottom
        case bottomTrailing
        
        var cssValues: (justify: String, align: String) {
            switch self {
            case .topLeading: return ("flex-start", "flex-start")
            case .top: return ("center", "flex-start")
            case .topTrailing: return ("flex-end", "flex-start")
            case .leading: return ("flex-start", "center")
            case .center: return ("center", "center")
            case .trailing: return ("flex-end", "center")
            case .bottomLeading: return ("flex-start", "flex-end")
            case .bottom: return ("center", "flex-end")
            case .bottomTrailing: return ("flex-end", "flex-end")
            }
        }
    }
    
    public init(
        alignment: Alignment = .center,
        @HTMLBuilder content: () -> Content
    ) {
        self.alignment = alignment
        self.content = content()
        
        // Apply positioning styles
        self.attributes.styles["position"] = "relative"
        self.attributes.styles["display"] = "flex"
        let (justify, align) = alignment.cssValues
        self.attributes.styles["justify-content"] = justify
        self.attributes.styles["align-items"] = align
    }
    
    public func render() -> String {
        "<div\(attributes.render())>\(content.render())</div>"
    }
}

/// Flexible spacer that expands to fill available space
public struct Spacer: HTMLElement {
    public var attributes = HTMLAttributes()
    private let minLength: Int?
    
    public init(minLength: Int? = nil) {
        self.minLength = minLength
        
        // Apply flex grow
        self.attributes.styles["flex-grow"] = "1"
        
        if let minLength = minLength {
            self.attributes.styles["min-width"] = "\(minLength)px"
            self.attributes.styles["min-height"] = "\(minLength)px"
        }
    }
    
    public func render() -> String {
        "<div\(attributes.render())></div>"
    }
}

/// Grid layout using CSS Grid
public struct Grid<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    
    public init(
        columns: GridTrack,
        rows: GridTrack? = nil,
        spacing: Int? = nil,
        @HTMLBuilder content: () -> Content
    ) {
        self.content = content()
        
        // Apply grid styles
        self.attributes.styles["display"] = "grid"
        self.attributes.styles["grid-template-columns"] = columns.cssValue
        
        if let rows = rows {
            self.attributes.styles["grid-template-rows"] = rows.cssValue
        }
        
        if let spacing = spacing {
            self.attributes.styles["gap"] = "\(spacing)px"
        }
    }
    
    public func render() -> String {
        "<div\(attributes.render())>\(content.render())</div>"
    }
}

/// Grid track definition
public enum GridTrack {
    case count(Int)
    case fixed(Int)
    case flexible(min: Int, max: Int)
    case fractional(Int)
    case auto
    case custom(String)
    
    var cssValue: String {
        switch self {
        case .count(let n):
            return "repeat(\(n), 1fr)"
        case .fixed(let size):
            return "\(size)px"
        case .flexible(let min, let max):
            return "minmax(\(min)px, \(max)px)"
        case .fractional(let fr):
            return "\(fr)fr"
        case .auto:
            return "auto"
        case .custom(let value):
            return value
        }
    }
    
    public static func columns(_ tracks: GridTrack...) -> GridTrack {
        let values = tracks.map { $0.cssValue }.joined(separator: " ")
        return .custom(values)
    }
    
    public static func rows(_ tracks: GridTrack...) -> GridTrack {
        let values = tracks.map { $0.cssValue }.joined(separator: " ")
        return .custom(values)
    }
}

/// Container with max-width constraint
public struct Container<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    
    public enum Width {
        case small  // 640px
        case medium // 768px
        case large  // 1024px
        case xl     // 1280px
        case xxl    // 1536px
        case full   // 100%
        case custom(Int)
        
        var cssValue: String {
            switch self {
            case .small: return "640px"
            case .medium: return "768px"
            case .large: return "1024px"
            case .xl: return "1280px"
            case .xxl: return "1536px"
            case .full: return "100%"
            case .custom(let px): return "\(px)px"
            }
        }
    }
    
    public init(
        maxWidth: Width = .large,
        padding: Int? = nil,
        @HTMLBuilder content: () -> Content
    ) {
        self.content = content()
        
        // Apply container styles
        self.attributes.styles["max-width"] = maxWidth.cssValue
        self.attributes.styles["margin-left"] = "auto"
        self.attributes.styles["margin-right"] = "auto"
        self.attributes.styles["width"] = "100%"
        
        if let padding = padding {
            self.attributes.styles["padding-left"] = "\(padding)px"
            self.attributes.styles["padding-right"] = "\(padding)px"
        }
    }
    
    public func render() -> String {
        "<div\(attributes.render())>\(content.render())</div>"
    }
}