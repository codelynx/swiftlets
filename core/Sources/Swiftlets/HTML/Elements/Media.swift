/// HTML img element
public struct Img: HTMLElement {
    public var attributes = HTMLAttributes()
    private let src: String
    private let alt: String
    
    public init(src: String, alt: String) {
        self.src = src
        self.alt = alt
    }
    
    public func render() -> String {
        var attrs = attributes
        attrs.custom.append(("src", src))
        attrs.custom.append(("alt", alt))
        return "<img\(attrs.render())>"
    }
}

/// HTML picture element
public struct Picture<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }
    
    public func render() -> String {
        "<picture\(attributes.render())>\(content.render())</picture>"
    }
}

/// HTML source element
public struct Source: HTMLElement {
    public var attributes = HTMLAttributes()
    private let srcset: String?
    private let media: String?
    private let type: String?
    private let src: String?
    
    public init(srcset: String? = nil, media: String? = nil, type: String? = nil, src: String? = nil) {
        self.srcset = srcset
        self.media = media
        self.type = type
        self.src = src
    }
    
    public func render() -> String {
        var attrs = attributes
        if let srcset = srcset {
            attrs.custom.append(("srcset", srcset))
        }
        if let media = media {
            attrs.custom.append(("media", media))
        }
        if let type = type {
            attrs.custom.append(("type", type))
        }
        if let src = src {
            attrs.custom.append(("src", src))
        }
        return "<source\(attrs.render())>"
    }
}

/// HTML video element
public struct Video<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    private let src: String?
    private let controls: Bool
    private let autoplay: Bool
    private let loop: Bool
    private let muted: Bool
    
    public init(
        src: String? = nil,
        controls: Bool = true,
        autoplay: Bool = false,
        loop: Bool = false,
        muted: Bool = false,
        @HTMLBuilder content: () -> Content
    ) {
        self.src = src
        self.controls = controls
        self.autoplay = autoplay
        self.loop = loop
        self.muted = muted
        self.content = content()
    }
    
    public func render() -> String {
        var attrs = attributes
        if let src = src {
            attrs.custom.append(("src", src))
        }
        if controls {
            attrs.custom.append(("controls", "controls"))
        }
        if autoplay {
            attrs.custom.append(("autoplay", "autoplay"))
        }
        if loop {
            attrs.custom.append(("loop", "loop"))
        }
        if muted {
            attrs.custom.append(("muted", "muted"))
        }
        return "<video\(attrs.render())>\(content.render())</video>"
    }
}

/// HTML audio element
public struct Audio<Content: HTMLElement>: HTMLContainer {
    public var attributes = HTMLAttributes()
    public let content: Content
    private let src: String?
    private let controls: Bool
    private let autoplay: Bool
    private let loop: Bool
    private let muted: Bool
    
    public init(
        src: String? = nil,
        controls: Bool = true,
        autoplay: Bool = false,
        loop: Bool = false,
        muted: Bool = false,
        @HTMLBuilder content: () -> Content
    ) {
        self.src = src
        self.controls = controls
        self.autoplay = autoplay
        self.loop = loop
        self.muted = muted
        self.content = content()
    }
    
    public func render() -> String {
        var attrs = attributes
        if let src = src {
            attrs.custom.append(("src", src))
        }
        if controls {
            attrs.custom.append(("controls", "controls"))
        }
        if autoplay {
            attrs.custom.append(("autoplay", "autoplay"))
        }
        if loop {
            attrs.custom.append(("loop", "loop"))
        }
        if muted {
            attrs.custom.append(("muted", "muted"))
        }
        return "<audio\(attrs.render())>\(content.render())</audio>"
    }
}

/// HTML iframe element
public struct IFrame: HTMLElement {
    public var attributes = HTMLAttributes()
    private let src: String
    private let title: String?
    
    public init(src: String, title: String? = nil) {
        self.src = src
        self.title = title
    }
    
    public func render() -> String {
        var attrs = attributes
        attrs.custom.append(("src", src))
        if let title = title {
            attrs.custom.append(("title", title))
        }
        return "<iframe\(attrs.render())></iframe>"
    }
}