import Foundation

// MARK: - Response Builder

/// A wrapper for HTML content that allows setting HTTP response properties
public struct ResponseBuilder {
    private var status: Int = 200
    private var headers: [String: String] = ["Content-Type": "text/html; charset=utf-8"]
    private var cookies: [SetCookie] = []
    private let content: () -> String
    
    public init(@HTMLBuilder content: @escaping () -> some HTMLElement) {
        self.content = { content().render() }
    }
    
    public init(html: String) {
        self.content = { html }
    }
    
    // MARK: - Status
    
    public func status(_ code: Int) -> ResponseBuilder {
        var copy = self
        copy.status = code
        return copy
    }
    
    // MARK: - Headers
    
    public func header(_ name: String, value: String) -> ResponseBuilder {
        var copy = self
        copy.headers[name] = value
        return copy
    }
    
    public func contentType(_ type: String) -> ResponseBuilder {
        header("Content-Type", value: type)
    }
    
    // MARK: - Cookies
    
    public func cookie(
        _ name: String,
        value: String,
        expires: Date? = nil,
        maxAge: Int? = nil,
        domain: String? = nil,
        path: String = "/",
        secure: Bool = false,
        httpOnly: Bool = false,
        sameSite: SameSite? = nil
    ) -> ResponseBuilder {
        var copy = self
        copy.cookies.append(SetCookie(
            name: name,
            value: value,
            expires: expires,
            maxAge: maxAge,
            domain: domain,
            path: path,
            secure: secure,
            httpOnly: httpOnly,
            sameSite: sameSite
        ))
        return copy
    }
    
    public func deleteCookie(_ name: String, path: String = "/", domain: String? = nil) -> ResponseBuilder {
        cookie(name, value: "", maxAge: 0, domain: domain, path: path)
    }
    
    // MARK: - Build Response
    
    internal func build() -> Response {
        var finalHeaders = headers
        
        // Add Set-Cookie headers
        if !cookies.isEmpty {
            let cookieStrings = cookies.map { $0.headerValue }
            // Multiple Set-Cookie headers are handled by joining with a special separator
            finalHeaders["Set-Cookie"] = cookieStrings.joined(separator: "\n")
        }
        
        return Response(
            status: status,
            headers: finalHeaders,
            body: content()
        )
    }
}

// MARK: - Cookie Types

public enum SameSite: String {
    case strict = "Strict"
    case lax = "Lax"
    case none = "None"
}

struct SetCookie {
    let name: String
    let value: String
    let expires: Date?
    let maxAge: Int?
    let domain: String?
    let path: String
    let secure: Bool
    let httpOnly: Bool
    let sameSite: SameSite?
    
    var headerValue: String {
        var parts = ["\(name)=\(value)"]
        
        if let expires = expires {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss 'GMT'"
            formatter.timeZone = TimeZone(identifier: "GMT")
            formatter.locale = Locale(identifier: "en_US_POSIX")
            parts.append("Expires=\(formatter.string(from: expires))")
        }
        
        if let maxAge = maxAge {
            parts.append("Max-Age=\(maxAge)")
        }
        
        if let domain = domain {
            parts.append("Domain=\(domain)")
        }
        
        parts.append("Path=\(path)")
        
        if secure {
            parts.append("Secure")
        }
        
        if httpOnly {
            parts.append("HttpOnly")
        }
        
        if let sameSite = sameSite {
            parts.append("SameSite=\(sameSite.rawValue)")
        }
        
        return parts.joined(separator: "; ")
    }
}

// MARK: - Convenience function

/// Create a response with the given content and optional modifiers
public func ResponseWith(
    @HTMLBuilder content: @escaping () -> some HTMLElement
) -> ResponseBuilder {
    ResponseBuilder(content: content)
}