# Static File Serving in Swiftlets

## Current Implementation

Swiftlets already includes basic static file serving functionality in the server. Here's how it works:

### File Resolution Order

1. **Static Files First**: The server checks for static files in the `web/` directory before looking for swiftlets
2. **Webbin Files**: If no static file is found, it looks for `.webbin` files that map to executable swiftlets
3. **Index Files**: For directory paths, it automatically tries `index.webbin`

### Supported MIME Types

The server already supports common file types:

```swift
- HTML: text/html; charset=utf-8
- CSS: text/css; charset=utf-8
- JavaScript: application/javascript; charset=utf-8
- JSON: application/json; charset=utf-8
- Images: image/png, image/jpeg, image/gif, image/svg+xml
- PDF: application/pdf
- Text: text/plain; charset=utf-8
- XML: application/xml; charset=utf-8
- Default: application/octet-stream
```

### Usage

Simply place static files in your site's `web/` directory:

```
sites/my-site/
├── web/
│   ├── styles/
│   │   └── main.css
│   ├── scripts/
│   │   └── app.js
│   ├── images/
│   │   └── logo.png
│   └── favicon.ico
└── src/
    └── index.swift
```

These files will be served directly:
- `/styles/main.css` → `web/styles/main.css`
- `/scripts/app.js` → `web/scripts/app.js`
- `/images/logo.png` → `web/images/logo.png`

### Limitations

Current implementation is missing:

1. **Caching Headers**: No ETag or Last-Modified headers
2. **Compression**: No gzip/deflate support
3. **Range Requests**: No support for partial content (video streaming)
4. **Security Headers**: No X-Content-Type-Options, X-Frame-Options, etc.
5. **Directory Listings**: No automatic index generation

## Future Enhancements

### Caching Headers

Add proper caching support:
```swift
headers.add(name: "ETag", value: calculateETag(data))
headers.add(name: "Last-Modified", value: lastModifiedDate)
headers.add(name: "Cache-Control", value: "public, max-age=3600")
```

### Compression

Add gzip support for text files:
```swift
if request.headers["Accept-Encoding"].contains("gzip") {
    let compressed = gzipCompress(data)
    headers.add(name: "Content-Encoding", value: "gzip")
    // serve compressed data
}
```

### Security Headers

Add standard security headers:
```swift
headers.add(name: "X-Content-Type-Options", value: "nosniff")
headers.add(name: "X-Frame-Options", value: "SAMEORIGIN")
headers.add(name: "X-XSS-Protection", value: "1; mode=block")
```

### Alternative Directories

Support both `web/` and `public/` directories:
```swift
let staticPaths = [
    "\(config.webRoot)/\(cleanPath)",     // web/ directory
    "\(config.siteRoot)/public/\(cleanPath)" // public/ directory
]
```

## Configuration

Future configuration options via environment variables:

```bash
SWIFTLETS_STATIC_CACHE=3600        # Cache duration in seconds
SWIFTLETS_STATIC_COMPRESS=true     # Enable gzip compression
SWIFTLETS_STATIC_LISTINGS=false    # Enable directory listings
SWIFTLETS_STATIC_HEADERS=strict    # Security header profile
```