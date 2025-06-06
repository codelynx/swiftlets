import Foundation

// Elements showcase page

let html = """
<!DOCTYPE html>
<html>
<head>
    <title>Elements - Swiftlets Showcase</title>
    <style>
        body {
            font-family: -apple-system, system-ui, sans-serif;
            max-width: 900px;
            margin: 0 auto;
            padding: 40px 20px;
            background: #f5f5f5;
        }
        .container {
            background: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        h1 { color: #333; }
        h2 { 
            color: #666; 
            margin-top: 40px;
            padding-top: 30px;
            border-top: 1px solid #eee;
        }
        h2:first-of-type { 
            margin-top: 20px; 
            border-top: none;
            padding-top: 0;
        }
        .example {
            background: #f8f8f8;
            padding: 20px;
            border-radius: 8px;
            margin: 15px 0;
        }
        .nav {
            margin-bottom: 30px;
        }
        .nav a {
            color: #0066cc;
            text-decoration: none;
            margin-right: 20px;
        }
        .nav a:hover {
            text-decoration: underline;
        }
        button {
            background: #0066cc;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
        }
        button:hover {
            background: #0052a3;
        }
        .grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin: 20px 0;
        }
        .card {
            background: #f0f0f0;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="nav">
        <a href="/">← Back to Showcase</a>
    </div>
    
    <div class="container">
        <h1>🎨 HTML Elements</h1>
        <p>This page demonstrates various HTML elements that will be available through Swiftlets' result builders.</p>
        
        <h2>Text Elements</h2>
        <div class="example">
            <h3>Headings</h3>
            <h1>Heading 1</h1>
            <h2>Heading 2</h2>
            <h3>Heading 3</h3>
            <h4>Heading 4</h4>
            
            <h3>Paragraphs</h3>
            <p>This is a paragraph with <strong>bold text</strong> and <em>italic text</em>.</p>
            <p>Another paragraph with a <a href="#">link</a> and <code>inline code</code>.</p>
        </div>
        
        <h2>Lists</h2>
        <div class="example">
            <h3>Unordered List</h3>
            <ul>
                <li>First item</li>
                <li>Second item</li>
                <li>Third item with nested list:
                    <ul>
                        <li>Nested item 1</li>
                        <li>Nested item 2</li>
                    </ul>
                </li>
            </ul>
            
            <h3>Ordered List</h3>
            <ol>
                <li>Step one</li>
                <li>Step two</li>
                <li>Step three</li>
            </ol>
        </div>
        
        <h2>Interactive Elements</h2>
        <div class="example">
            <button onclick="alert('Button clicked!')">Click Me</button>
            
            <p style="margin-top: 20px;">
                <input type="text" placeholder="Text input" style="padding: 8px;">
            </p>
            
            <p>
                <select style="padding: 8px;">
                    <option>Option 1</option>
                    <option>Option 2</option>
                    <option>Option 3</option>
                </select>
            </p>
        </div>
        
        <h2>Layout Examples</h2>
        <div class="example">
            <h3>Grid Layout</h3>
            <div class="grid">
                <div class="card">Card 1</div>
                <div class="card">Card 2</div>
                <div class="card">Card 3</div>
                <div class="card">Card 4</div>
                <div class="card">Card 5</div>
                <div class="card">Card 6</div>
            </div>
        </div>
        
        <h2>Future Result Builder Syntax</h2>
        <div class="example">
            <pre><code>// This is how you'll write it with result builders:
            
VStack {
    H1("HTML Elements")
    
    Text("This is a paragraph with ")
        .bold("bold text")
        .text(" and ")
        .italic("italic text")
    
    Button("Click Me") {
        // Server-side action
        showAlert = true
    }
    
    Grid(columns: 3) {
        ForEach(1...6) { i in
            Card("Card \\(i)")
        }
    }
}</code></pre>
        </div>
        
        <div style="margin-top: 40px; text-align: center; color: #666;">
            <p>Process ID: \(ProcessInfo.processInfo.processIdentifier) • Generated at: \(Date().description)</p>
        </div>
    </div>
</body>
</html>
"""

// Output HTTP response
print("Status: 200")
print("Content-Type: text/html; charset=utf-8")
print("")
print(html)