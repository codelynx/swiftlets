/// Conditional rendering helper
public struct If: HTMLElement {
    public var attributes = HTMLAttributes()
    private let condition: Bool
    private let content: () -> any HTMLElement
    private let elseContent: (() -> any HTMLElement)?
    
    public init(_ condition: Bool, @HTMLBuilder then content: @escaping () -> any HTMLElement) {
        self.condition = condition
        self.content = content
        self.elseContent = nil
    }
    
    public init(
        _ condition: Bool,
        @HTMLBuilder then content: @escaping () -> any HTMLElement,
        @HTMLBuilder else elseContent: @escaping () -> any HTMLElement
    ) {
        self.condition = condition
        self.content = content
        self.elseContent = elseContent
    }
    
    public func render() -> String {
        if condition {
            return content().render()
        } else if let elseContent = elseContent {
            return elseContent().render()
        } else {
            return ""
        }
    }
}

/// Switch-like conditional rendering
public struct Switch<Value: Equatable>: HTMLElement {
    public var attributes = HTMLAttributes()
    private let value: Value
    private let cases: [(Value, () -> any HTMLElement)]
    private let defaultCase: (() -> any HTMLElement)?
    
    public init(
        _ value: Value,
        @CaseBuilder cases: () -> [(Value, () -> any HTMLElement)],
        default defaultCase: (() -> any HTMLElement)? = nil
    ) {
        self.value = value
        self.cases = cases()
        self.defaultCase = defaultCase
    }
    
    public func render() -> String {
        for (caseValue, content) in cases {
            if value == caseValue {
                return content().render()
            }
        }
        return defaultCase?().render() ?? ""
    }
}

/// Case builder for Switch
@resultBuilder
public struct CaseBuilder {
    public static func buildBlock(_ cases: (any Equatable, () -> any HTMLElement)...) -> [(any Equatable, () -> any HTMLElement)] {
        cases
    }
}

/// Case helper for Switch
public func Case<Value: Equatable>(_ value: Value, @HTMLBuilder content: @escaping () -> any HTMLElement) -> (Value, () -> any HTMLElement) {
    (value, content)
}