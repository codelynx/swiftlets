# POST Request Handling in SwiftUI-Style Swiftlets

## The Challenge

POST requests can contain various types of data:
- Form data (application/x-www-form-urlencoded)
- JSON data (application/json)
- File uploads (multipart/form-data)
- Raw body data

## Design Options

### Option 1: Property Wrappers for Each Type

```swift
@main
struct CreateUser: Swiftlet {
    @FormData("name") var name: String?
    @FormData("email") var email: String?
    @FormData("age") var age: Int?
    
    var body: some HTML {
        if let name = name, let email = email {
            H1("Created user: \(name)")
            P("Email: \(email)")
        } else {
            H1("Missing required fields")
        }
    }
}
```

### Option 2: Typed Body Decoding

```swift
@main
struct CreateUser: Swiftlet {
    struct UserData: Codable {
        let name: String
        let email: String
        let age: Int?
    }
    
    @JSONBody var userData: Result<UserData, Error>
    
    var body: some HTML {
        switch userData {
        case .success(let user):
            H1("Created user: \(user.name)")
            P("Email: \(user.email)")
        case .failure(let error):
            ErrorView(error)
        }
    }
}
```

### Option 3: Method-Aware Swiftlets

```swift
@main
struct UserEndpoint: Swiftlet {
    @Method var method
    @Query("id") var userId: String?
    @JSONBody(UserData.self) var userData: UserData?
    
    var body: some HTML {
        switch method {
        case .get:
            showUser()
        case .post:
            createUser()
        case .put:
            updateUser()
        case .delete:
            deleteUser()
        default:
            methodNotAllowed()
        }
    }
    
    @HTMLBuilder
    func createUser() -> some HTML {
        if let data = userData {
            H1("Created: \(data.name)")
        } else {
            H1("Invalid data")
        }
    }
}
```

### Option 4: Separate Protocols for Different Operations

```swift
protocol GetSwiftlet: Swiftlet {
    var body: Body { get }
}

protocol PostSwiftlet: Swiftlet {
    associatedtype Input: Decodable
    var input: Input { get }
    func handle() -> some HTML
}

@main
struct CreateUser: PostSwiftlet {
    struct Input: Decodable {
        let name: String
        let email: String
    }
    
    @JSONBody var input: Input
    
    func handle() -> some HTML {
        // Save user...
        H1("Created: \(input.name)")
    }
}
```

## Recommended Approach: Smart Property Wrappers

```swift
// The framework provides these property wrappers:

@propertyWrapper
public struct Body<T: Decodable> {
    public var wrappedValue: Result<T, Error> {
        guard let env = SwiftletEnvironmentKey.current else {
            return .failure(EnvironmentError())
        }
        
        do {
            // Auto-detect content type and decode appropriately
            let contentType = env.request.headers["Content-Type"] ?? ""
            
            if contentType.contains("application/json") {
                let decoded = try JSONDecoder().decode(T.self, from: env.request.body)
                return .success(decoded)
            } else if contentType.contains("application/x-www-form-urlencoded") {
                // Parse form data into dictionary, then decode
                let formData = parseFormData(env.request.body)
                let decoded = try FormDecoder().decode(T.self, from: formData)
                return .success(decoded)
            } else {
                return .failure(UnsupportedContentType(contentType))
            }
        } catch {
            return .failure(error)
        }
    }
}

@propertyWrapper
public struct FormValue {
    let key: String
    
    public var wrappedValue: String? {
        guard let env = SwiftletEnvironmentKey.current else { return nil }
        guard let body = env.request.body else { return nil }
        
        let formData = parseFormData(body)
        return formData[key]
    }
    
    public init(_ key: String) {
        self.key = key
    }
}

@propertyWrapper
public struct FileUpload {
    let name: String
    
    public var wrappedValue: UploadedFile? {
        guard let env = SwiftletEnvironmentKey.current else { return nil }
        // Parse multipart data...
        return nil
    }
}
```

## Real-World Examples

### Simple Form Submission

```swift
@main
struct ContactForm: Swiftlet {
    @FormValue("name") var name: String?
    @FormValue("email") var email: String?
    @FormValue("message") var message: String?
    
    var body: some HTML {
        Html {
            Head { Title("Contact Form") }
            Body {
                if request.method == .post {
                    handleSubmission()
                } else {
                    showForm()
                }
            }
        }
    }
    
    @HTMLBuilder
    func handleSubmission() -> some HTML {
        if let name = name, let email = email, let message = message {
            Container {
                H1("Thank you, \(name)!")
                P("We received your message and will reply to \(email)")
            }
        } else {
            Container {
                H1("Error")
                P("Please fill all required fields")
                Link(href: "/contact", "Try again")
            }
        }
    }
    
    @HTMLBuilder
    func showForm() -> some HTML {
        Container {
            H1("Contact Us")
            Form(action: "/contact", method: "post") {
                Label("Name:")
                Input(type: "text", name: "name").required()
                
                Label("Email:")
                Input(type: "email", name: "email").required()
                
                Label("Message:")
                TextArea(name: "message").required()
                
                Button(type: "submit", "Send Message")
            }
        }
    }
}
```

### JSON API Endpoint

```swift
@main
struct CreateUserAPI: Swiftlet {
    struct UserRequest: Codable {
        let name: String
        let email: String
        let password: String
    }
    
    @Body var userRequest: Result<UserRequest, Error>
    @Environment(\.storage) var storage
    
    var body: some HTML {
        // For API endpoints, return JSON-like HTML or use a different response type
        switch userRequest {
        case .success(let req):
            do {
                // Save user
                let user = User(name: req.name, email: req.email)
                try storage.save(user, to: "users/\(user.id).json")
                
                // Return success
                Div {
                    Text("{\"success\": true, \"id\": \"\(user.id)\"}")
                }
                .attribute("data-content-type", "application/json")
            } catch {
                errorResponse(error)
            }
            
        case .failure(let error):
            errorResponse(error)
        }
    }
}
```

### File Upload

```swift
@main
struct ProfilePictureUpload: Swiftlet {
    @FileUpload("avatar") var avatar: UploadedFile?
    @FormValue("userId") var userId: String?
    @Environment(\.storage) var storage
    
    var body: some HTML {
        if let file = avatar, let userId = userId {
            // Save file
            let path = "avatars/\(userId).\(file.extension)"
            do {
                try storage.write(file.data, to: path)
                
                H1("Upload successful!")
                Img(src: "/\(path)")
            } catch {
                H1("Upload failed: \(error)")
            }
        } else {
            // Show upload form
            Form(action: "/upload", method: "post", enctype: "multipart/form-data") {
                Input(type: "hidden", name: "userId", value: "123")
                Input(type: "file", name: "avatar", accept: "image/*")
                Button(type: "submit", "Upload")
            }
        }
    }
}
```

## Method Detection

```swift
@main
struct RESTfulResource: Swiftlet {
    @Environment(\.request) var request
    @Query("id") var resourceId: String?
    @Body var updateData: Result<ResourceData, Error>
    
    var body: some HTML {
        switch request.method {
        case .get:
            showResource()
        case .post:
            createResource()
        case .put, .patch:
            updateResource()
        case .delete:
            deleteResource()
        default:
            methodNotAllowed()
        }
    }
}
```

## Best Practices

1. **Use Result types** for body parsing to handle errors gracefully
2. **Check request method** when the same route handles multiple methods
3. **Validate input** before processing
4. **Return appropriate status codes** (framework should handle this)
5. **Keep forms and handlers together** for better maintainability

## Framework Considerations

The framework should:
- Automatically parse body based on Content-Type
- Provide convenient property wrappers for common cases
- Handle multipart parsing for file uploads
- Support custom decoders for special formats
- Allow raw body access when needed

## Status Code Handling

```swift
// Future: Support custom status codes
@main
struct APIEndpoint: Swiftlet {
    @Status var status: Int = 200
    
    var body: some HTML {
        if authorized {
            // Content...
        } else {
            status = 401
            return ErrorView("Unauthorized")
        }
    }
}
```