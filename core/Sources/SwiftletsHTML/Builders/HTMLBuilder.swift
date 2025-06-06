/// Result builder for constructing HTML element hierarchies
@resultBuilder
public struct HTMLBuilder {
    // Empty block
    public static func buildBlock() -> EmptyHTML {
        EmptyHTML()
    }
    
    // Single element
    public static func buildBlock<E: HTMLElement>(_ element: E) -> E {
        element
    }
    
    // Multiple elements
    public static func buildBlock(_ elements: any HTMLElement...) -> HTMLGroup {
        HTMLGroup(elements: elements)
    }
    
    // Optional element
    public static func buildOptional<E: HTMLElement>(_ element: E?) -> any HTMLElement {
        element ?? EmptyHTML()
    }
    
    // If statement
    public static func buildIf<E: HTMLElement>(_ element: E?) -> any HTMLElement {
        element ?? EmptyHTML()
    }
    
    // Either branch (if)
    public static func buildEither<T: HTMLElement>(first: T) -> T {
        first
    }
    
    // Either branch (else)
    public static func buildEither<F: HTMLElement>(second: F) -> F {
        second
    }
    
    // Array of elements
    public static func buildArray<E: HTMLElement>(_ elements: [E]) -> HTMLGroup {
        HTMLGroup(elements: elements)
    }
    
    // Limited availability (if #available)
    public static func buildLimitedAvailability<E: HTMLElement>(_ element: E) -> E {
        element
    }
}