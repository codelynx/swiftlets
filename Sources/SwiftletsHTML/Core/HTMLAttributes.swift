import Foundation

/// Storage for HTML element attributes
public struct HTMLAttributes {
    /// Element ID
    public var id: String?
    
    /// CSS classes
    public var classes: Set<String> = []
    
    /// Inline styles
    public var styles: [String: String] = [:]
    
    /// Data attributes
    public var data: [String: String] = [:]
    
    /// Custom attributes
    public var custom: [(String, String)] = []
    
    /// Event handlers (onclick, etc.)
    public var events: [String: String] = [:]
    
    public init() {}
    
    /// Renders attributes to HTML string
    public func render() -> String {
        var parts: [String] = []
        
        // ID
        if let id = id {
            parts.append(#"id="\#(id.escaped())""#)
        }
        
        // Classes
        if !classes.isEmpty {
            let classString = classes.sorted().joined(separator: " ")
            parts.append(#"class="\#(classString.escaped())""#)
        }
        
        // Inline styles
        if !styles.isEmpty {
            let styleString = styles
                .sorted { $0.key < $1.key }
                .map { "\($0.key): \($0.value)" }
                .joined(separator: "; ")
            parts.append(#"style="\#(styleString.escaped())""#)
        }
        
        // Data attributes
        for (key, value) in data.sorted(by: { $0.key < $1.key }) {
            parts.append(#"data-\#(key)="\#(value.escaped())""#)
        }
        
        // Event handlers
        for (event, handler) in events.sorted(by: { $0.key < $1.key }) {
            parts.append(#"\#(event)="\#(handler.escaped())""#)
        }
        
        // Custom attributes
        for (key, value) in custom {
            parts.append(#"\#(key)="\#(value.escaped())""#)
        }
        
        return parts.isEmpty ? "" : " " + parts.joined(separator: " ")
    }
}

// MARK: - String escaping

extension String {
    /// Escapes HTML attribute values
    func escaped() -> String {
        self.replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
            .replacingOccurrences(of: "'", with: "&#39;")
    }
    
    /// Escapes HTML content
    func escapedContent() -> String {
        self.replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
    }
}