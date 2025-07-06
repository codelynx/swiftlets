// HTML Builder POC - Demonstrating the concept

import Foundation

// MARK: - Core Protocols

protocol HTMLElement {
    var attributes: HTMLAttributes { get set }
    func render() -> String
}

protocol HTMLContainer: HTMLElement {
    associatedtype Content: HTMLElement
    var content: Content { get }
}

// MARK: - Attributes

struct HTMLAttributes {
    var classes: Set<String> = []
    var styles: [String: String] = [:]
    var id: String?
    
    func render() -> String {
        var parts: [String] = []
        
        if let id = id {
            parts.append(#"id="\#(id)""#)
        }
        
        if !classes.isEmpty {
            let classString = classes.sorted().joined(separator: " ")
            parts.append(#"class="\#(classString)""#)
        }
        
        if !styles.isEmpty {
            let styleString = styles.map { "\($0.key): \($0.value)" }.sorted().joined(separator: "; ")
            parts.append(#"style="\#(styleString)""#)
        }
        
        return parts.isEmpty ? "" : " " + parts.joined(separator: " ")
    }
}

// MARK: - Type Erasure

struct AnyHTMLElement: HTMLElement {
    private let _render: () -> String
    var attributes: HTMLAttributes
    
    init<E: HTMLElement>(_ element: E) {
        self.attributes = element.attributes
        self._render = element.render
    }
    
    func render() -> String {
        _render()
    }
}

struct HTMLGroup: HTMLElement {
    let elements: [any HTMLElement]
    var attributes = HTMLAttributes()
    
    func render() -> String {
        elements.map { $0.render() }.joined()
    }
}

struct EmptyHTML: HTMLElement {
    var attributes = HTMLAttributes()
    func render() -> String { "" }
}

// MARK: - Result Builder

@resultBuilder
struct HTMLBuilder {
    static func buildBlock() -> EmptyHTML {
        EmptyHTML()
    }
    
    static func buildBlock<E: HTMLElement>(_ element: E) -> E {
        element
    }
    
    static func buildBlock(_ elements: any HTMLElement...) -> HTMLGroup {
        HTMLGroup(elements: elements)
    }
    
    static func buildOptional<E: HTMLElement>(_ element: E?) -> any HTMLElement {
        element ?? EmptyHTML()
    }
    
    static func buildEither<T: HTMLElement>(first: T) -> T {
        first
    }
    
    static func buildEither<F: HTMLElement>(second: F) -> F {
        second
    }
    
    static func buildArray<E: HTMLElement>(_ elements: [E]) -> HTMLGroup {
        HTMLGroup(elements: elements)
    }
}

// MARK: - Basic Elements

struct Text: HTMLElement {
    let content: String
    var attributes = HTMLAttributes()
    
    init(_ content: String) {
        self.content = content
    }
    
    func render() -> String {
        content.replacingOccurrences(of: "<", with: "&lt;")
               .replacingOccurrences(of: ">", with: "&gt;")
    }
}

struct Div<Content: HTMLElement>: HTMLContainer {
    var attributes = HTMLAttributes()
    let content: Content
    
    init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }
    
    func render() -> String {
        "<div\(attributes.render())>\(content.render())</div>"
    }
}

struct H1: HTMLElement {
    let text: String
    var attributes = HTMLAttributes()
    
    init(_ text: String) {
        self.text = text
    }
    
    func render() -> String {
        "<h1\(attributes.render())>\(text)</h1>"
    }
}

struct Button: HTMLElement {
    let text: String
    var attributes = HTMLAttributes()
    
    init(_ text: String) {
        self.text = text
    }
    
    func render() -> String {
        "<button\(attributes.render())>\(text)</button>"
    }
}

// MARK: - Layout Components

struct VStack<Content: HTMLElement>: HTMLContainer {
    var attributes = HTMLAttributes()
    let spacing: Int
    let content: Content
    
    init(spacing: Int = 0, @HTMLBuilder content: () -> Content) {
        self.spacing = spacing
        self.content = content()
        self.attributes.styles["display"] = "flex"
        self.attributes.styles["flex-direction"] = "column"
        self.attributes.styles["gap"] = "\(spacing)px"
    }
    
    func render() -> String {
        "<div\(attributes.render())>\(content.render())</div>"
    }
}

// MARK: - Modifiers

extension HTMLElement {
    func `class`(_ className: String) -> AnyHTMLElement {
        var modified = self
        modified.attributes.classes.insert(className)
        return AnyHTMLElement(modified)
    }
    
    func id(_ id: String) -> AnyHTMLElement {
        var modified = self
        modified.attributes.id = id
        return AnyHTMLElement(modified)
    }
    
    func style(_ key: String, _ value: String) -> AnyHTMLElement {
        var modified = self
        modified.attributes.styles[key] = value
        return AnyHTMLElement(modified)
    }
    
    func padding(_ value: Int) -> AnyHTMLElement {
        style("padding", "\(value)px")
    }
    
    func background(_ color: String) -> AnyHTMLElement {
        style("background-color", color)
    }
}

// MARK: - Page Component

protocol Component {
    associatedtype Body: HTMLElement
    @HTMLBuilder var body: Body { get }
}

struct Page<Content: HTMLElement>: HTMLElement {
    var attributes = HTMLAttributes()
    let title: String
    let content: Content
    
    init(title: String, @HTMLBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    func render() -> String {
        """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="utf-8">
            <title>\(title)</title>
            <style>
                body { font-family: -apple-system, system-ui, sans-serif; margin: 0; }
                .container { max-width: 800px; margin: 0 auto; padding: 40px 20px; }
                .btn-primary { background: #007bff; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; }
                .btn-primary:hover { background: #0056b3; }
            </style>
        </head>
        <body>
            \(content.render())
        </body>
        </html>
        """
    }
}

// MARK: - Example Usage

struct HomePage: Component {
    let userName: String?
    
    var body: some HTMLElement {
        Page(title: "Swiftlets Demo") {
            Div {
                VStack(spacing: 20) {
                    H1("Welcome to Swiftlets!")
                        .class("title")
                    
                    if let name = userName {
                        Text("Hello, \(name)!")
                            .class("greeting")
                    } else {
                        Text("Please log in to continue")
                    }
                    
                    Button("Get Started")
                        .class("btn-primary")
                        .id("start-button")
                }
                .padding(40)
                .background("#f5f5f5")
            }
            .class("container")
        }
    }
}

// MARK: - Demo

// Create and render a page
let homePage = HomePage(userName: "Alice")
let html = homePage.body.render()
print(html)

// Example with array
struct ItemList: Component {
    let items: [String]
    
    var body: some HTMLElement {
        VStack(spacing: 10) {
            H1("Items")
            
            // Using buildArray
            ForEach(items) { item in
                Text("• \(item)")
            }
        }
    }
}

// Helper for arrays (simplified ForEach)
struct ForEach<Element>: HTMLElement {
    var attributes = HTMLAttributes()
    let elements: [any HTMLElement]
    
    init<C: Collection>(_ data: C, @HTMLBuilder content: (C.Element) -> any HTMLElement) where C.Element == Element {
        self.elements = data.map(content)
    }
    
    func render() -> String {
        HTMLGroup(elements: elements).render()
    }
}