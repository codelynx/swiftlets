# Hello World Example

The simplest possible Swiftlets site. This example demonstrates:

- Basic swiftlet structure
- Reading request data from environment variables
- Outputting HTTP response format
- No dependencies or result builders

## Structure

```
hello/
├── site.yaml      # Site configuration
├── src/
│   └── index.swift   # Main swiftlet
└── README.md      # This file
```

## Running

```bash
# From the swiftlets root directory
swiftlets dev --site sites/core/hello

# Or manually
cd sites/core/hello
swift build -c release
# Server will compile and run the swiftlet
```

## How It Works

The `index.swift` swiftlet:
1. Reads HTTP request info from environment variables
2. Generates HTML content
3. Outputs HTTP response to stdout
4. The server captures this output and sends it to the client

## Example Output

```
Status: 200
Content-Type: text/html; charset=utf-8

<!DOCTYPE html>
<html>
  <head>
    <title>Hello from Swiftlet</title>
  </head>
  <body>
    <h1>🚀 Hello from Swiftlet!</h1>
  </body>
</html>
```