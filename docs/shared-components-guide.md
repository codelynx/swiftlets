# Shared Components Guide

Swiftlets supports a hierarchical shared components system that allows you to share code between pages while maintaining the framework's core principle of isolation.

## Overview

Shared components in Swiftlets use a **file-based discovery system** based on directory structure. Components are organized in `shared/` directories at different levels of your site hierarchy, providing natural scoping without complex module systems or imports.

## How It Works

When building a swiftlet, the build system automatically discovers and includes shared components by walking up the directory tree from the source file location. No import statements are needed - all discovered components are compiled together with your page.

### Discovery Process

For a page at `src/products/electronics/phones/iphone.swift`, the build system will look for and include components from:

1. `src/products/electronics/phones/shared/` (if exists)
2. `src/products/electronics/shared/`
3. `src/products/shared/`
4. `src/shared/` (global components)

Components in deeper directories have access to all components from parent directories.

## Directory Structure

```
sites/your-site/
├── src/
│   ├── shared/                    # Global components (available to ALL pages)
│   │   ├── site_header.swift
│   │   └── site_footer.swift
│   ├── products/
│   │   ├── shared/                # Product-level components
│   │   │   ├── product_card.swift
│   │   │   └── product_nav.swift
│   │   ├── electronics/
│   │   │   ├── shared/            # Electronics-specific components
│   │   │   │   └── specs_table.swift
│   │   │   ├── phones.swift
│   │   │   └── laptops.swift
│   │   └── index.swift
│   └── index.swift
```

## Creating Shared Components

Shared components are regular Swift functions that return HTML elements:

### Global Component (src/shared/site_header.swift)
```swift
func siteHeader() -> some HTMLElement {
    Header {
        Nav {
            Container(maxWidth: .xl) {
                H1("My Site")
                // Navigation items...
            }
        }
    }
}
```

### Category Component (src/products/shared/product_card.swift)
```swift
func productCard(name: String, price: String, category: String) -> some HTMLElement {
    Link(href: "#") {
        VStack {
            H3(name)
            Text(price)
            Text(category)
                .style("color", "#666")
        }
    }
}
```

### Specialized Component (src/products/electronics/shared/specs_table.swift)
```swift
func specsTable(specs: [(String, String)]) -> some HTMLElement {
    Table {
        THead {
            TR {
                TH("Specification")
                TH("Value")
            }
        }
        TBody {
            ForEach(specs) { spec in
                TR {
                    TD(spec.0)
                    TD(spec.1)
                }
            }
        }
    }
}
```

## Using Shared Components

Simply call the functions in your page - no imports needed:

```swift
@main
struct ElectronicsPage: SwiftletMain {
    var body: some HTMLElement {
        Fragment {
            siteHeader()  // From src/shared/
            
            Main {
                Container {
                    H1("Electronics")
                    
                    productNavigation()  // From src/products/shared/
                    
                    Grid(columns: .count(3)) {
                        productCard(
                            name: "Laptop Pro",
                            price: "$1,299",
                            category: "Electronics"
                        )
                        // More products...
                    }
                    
                    specsTable(specs: [  // From src/products/electronics/shared/
                        ("CPU", "Intel i7"),
                        ("RAM", "16GB")
                    ])
                }
            }
            
            siteFooter()  // From src/shared/
        }
    }
}
```

## Scoping Rules

1. **Natural Hierarchy**: Pages can only access components from their directory level and above
2. **No Lateral Access**: Pages cannot access components from sibling directories
3. **Compilation Enforcement**: The compiler enforces these rules - using an out-of-scope component results in a compilation error

### Example Scoping

Given this structure:
```
src/
├── shared/
│   └── global_nav.swift
├── japan/
│   ├── shared/
│   │   └── japan_menu.swift
│   ├── tokyo/
│   │   ├── shared/
│   │   │   └── tokyo_districts.swift
│   │   └── shibuya.swift
│   └── kyoto/
│       └── temples.swift
```

Access rules:
- `shibuya.swift` can access: `tokyo_districts()`, `japan_menu()`, `global_nav()`
- `temples.swift` can access: `japan_menu()`, `global_nav()` (but NOT `tokyo_districts()`)
- `japan_menu()` cannot access `tokyo_districts()` (child component)

## Best Practices

1. **Component Naming**: Use descriptive names that indicate the component's purpose
2. **Parameter Design**: Make components flexible with parameters rather than creating many similar components
3. **Avoid State**: Shared components should be pure functions without side effects
4. **Documentation**: Add comments explaining component usage and parameters
5. **Organization**: Group related components in the same file

## Legacy Support

The build system still supports the legacy `Components.swift` file at the site root for backward compatibility. However, the hierarchical `shared/` directory approach is recommended for new projects.

## Performance Considerations

- Shared components are compiled into each executable that uses them
- There's no runtime overhead - components become part of the compiled binary
- Build times may increase slightly as more components are discovered and compiled
- The build system caches based on modification times to avoid unnecessary rebuilds

## Troubleshooting

### Component Not Found
If a component isn't found during compilation:
1. Verify the component is in a `shared/` directory at or above your page's level
2. Check the function name matches exactly (Swift is case-sensitive)
3. Ensure the shared component file has a `.swift` extension
4. Run with `--verbose` flag to see which directories are being searched

### Build Performance
If builds are slow with many shared components:
1. Consider breaking very large component files into smaller, focused files
2. Use the timestamp-based caching (don't use `--force` unless needed)
3. Avoid complex expressions in shared components (see troubleshooting guide)

## Example Project

See `/sites/test/shared-components-demo/` for a complete example demonstrating:
- Global site header and footer
- Product category components
- Electronics-specific components
- Proper scoping and hierarchy