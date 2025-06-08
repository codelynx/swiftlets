# Naming Clarity: PageMeta vs HTMLHead

## Current Name: PageMeta

```swift
protocol PageMeta {
    var title: String { get }
    var description: String? { get }
    // ...
}
```

## Alternative Names to Consider

### Option 1: HTMLHead
```swift
protocol HTMLHead {
    var title: String { get }
    // ...
}
```
**Pro**: Directly maps to `<head>` element
**Con**: Might imply HTML building, not data

### Option 2: HeadMetadata
```swift
protocol HeadMetadata {
    var title: String { get }
    // ...
}
```
**Pro**: Clear it's metadata for head
**Con**: Redundant (metadata metadata)

### Option 3: PageHead
```swift
protocol PageHead {
    var title: String { get }
    // ...
}
```
**Pro**: Clear and concise
**Con**: Still might imply HTML

### Option 4: DocumentMetadata
```swift
protocol DocumentMetadata {
    var title: String { get }
    // ...
}
```
**Pro**: Professional, clear
**Con**: Longer

## Recommendation

Keep `PageMeta` but clarify in documentation:

```swift
// Protocol that defines metadata for the HTML <head> section
// These properties are converted to HTML elements by the framework
protocol PageMeta {
    var title: String { get }          // → <title>
    var description: String? { get }   // → <meta name="description">
    var keywords: [String]? { get }    // → <meta name="keywords">
    var stylesheets: [String]? { get } // → <link rel="stylesheet">
}
```

The name `PageMeta` works because:
1. It's short and clear
2. "Meta" indicates it's data about the page
3. Doesn't imply HTML construction
4. Distinguishes from body content