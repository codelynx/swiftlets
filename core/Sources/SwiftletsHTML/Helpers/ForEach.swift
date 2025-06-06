/// ForEach construct for iterating over collections
public struct ForEach<Data: Collection>: HTMLElement {
    public var attributes = HTMLAttributes()
    private let data: Data
    private let content: (Data.Element) -> any HTMLElement
    
    public init(_ data: Data, @HTMLBuilder content: @escaping (Data.Element) -> any HTMLElement) {
        self.data = data
        self.content = content
    }
    
    public func render() -> String {
        data.map { content($0).render() }.joined()
    }
}

/// ForEach with index
public struct ForEachWithIndex<Data: Collection>: HTMLElement {
    public var attributes = HTMLAttributes()
    private let data: Data
    private let content: (Int, Data.Element) -> any HTMLElement
    
    public init(_ data: Data, @HTMLBuilder content: @escaping (Int, Data.Element) -> any HTMLElement) {
        self.data = data
        self.content = content
    }
    
    public func render() -> String {
        data.enumerated().map { content($0.offset, $0.element).render() }.joined()
    }
}

