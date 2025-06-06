import Foundation

// Showcase index page - lists all examples

let examples = [
    ("Elements", "/elements", "HTML elements and styling"),
    ("All Elements (DSL)", "/all-elements", "Complete HTML elements showcase using SwiftletsHTML"),
    ("Forms", "/forms", "Form handling and validation"),
    ("API Data", "/api/data", "JSON API example"),
    ("API Users", "/api/users/123", "Dynamic routing example")
]

let html = """
<!DOCTYPE html>
<html>
<head>
    <title>Swiftlets Showcase</title>
    <style>
        body {
            font-family: -apple-system, system-ui, sans-serif;
            max-width: 1200px;
            margin: 0 auto;
            padding: 40px 20px;
            background: #f5f5f5;
        }
        h1 {
            color: #333;
            margin-bottom: 10px;
        }
        .subtitle {
            color: #666;
            margin-bottom: 40px;
        }
        .examples {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }
        .example {
            background: white;
            padding: 24px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            text-decoration: none;
            color: inherit;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .example:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 16px rgba(0,0,0,0.15);
        }
        .example h2 {
            color: #0066cc;
            margin: 0 0 8px 0;
            font-size: 20px;
        }
        .example p {
            color: #666;
            margin: 0;
            line-height: 1.5;
        }
        .path {
            font-family: 'SF Mono', Monaco, monospace;
            font-size: 12px;
            color: #999;
            margin-top: 8px;
        }
    </style>
</head>
<body>
    <h1>🎨 Swiftlets Showcase</h1>
    <p class="subtitle">Explore examples demonstrating various Swiftlets features</p>
    
    <div class="examples">
        \(examples.map { (title, path, description) in
            """
            <a href="\(path)" class="example">
                <h2>\(title)</h2>
                <p>\(description)</p>
                <div class="path">\(path)</div>
            </a>
            """
        }.joined(separator: "\n"))
    </div>
    
    <div style="margin-top: 60px; padding-top: 40px; border-top: 1px solid #e0e0e0; color: #666; text-align: center;">
        <p>Powered by Swiftlets • Process ID: \(ProcessInfo.processInfo.processIdentifier)</p>
    </div>
</body>
</html>
"""

// Output HTTP response
print("Status: 200")
print("Content-Type: text/html; charset=utf-8")
print("")
print(html)