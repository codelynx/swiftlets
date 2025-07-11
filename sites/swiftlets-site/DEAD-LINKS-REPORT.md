# Dead Links Report - Swiftlets Site

Generated: January 2025

## Critical Issues (Need Immediate Fix)

### 1. Wrong GitHub URL in index-standalone.swift
- **File**: `/sites/swiftlets-site/src/index-standalone.swift`
- **Current**: `https://github.com/yourusername/swiftlets`
- **Should be**: `https://github.com/codelynx/swiftlets`

### 2. Incorrect Showcase Navigation Link
- **Files**: Multiple showcase pages
- **Current**: `/showcase/layout`
- **Should be**: `/showcase/layout-components`

## Missing Pages (Referenced but Don't Exist)

### Documentation Section
These links appear in the docs navigation but have no corresponding pages:
- `/docs/api` - API Reference
- `/docs/changelog` - Changelog  
- `/docs/faq` - Frequently Asked Questions

### Footer Links
These links appear in footers but have no pages:
- `/privacy` - Privacy Policy
- `/terms` - Terms of Service
- `/contact` - Contact page

## Example/Demo Links

These are used in code examples and may be intentional placeholders:
- `/example` - Used in troubleshooting docs
- `/learn-more` - Used in modifier examples
- `/login` - Used in conditional rendering examples
- `/products` - Used in routing examples
- `/products/{category}` - Dynamic route example

## External Links to Verify

- `https://twitter.com/swiftlets` - May not exist (verify if Swiftlets has Twitter)

## Recommendations

### High Priority
1. Fix the GitHub URL in index-standalone.swift
2. Fix the showcase navigation link from `/layout` to `/layout-components`
3. Either create the missing documentation pages or remove the links

### Medium Priority
1. Create privacy and terms pages or remove footer links
2. Decide if example links should have actual pages or be clearly marked as examples

### Low Priority
1. Verify external social media links exist
2. Consider adding a 404 page to handle broken links gracefully

## How to Fix

### Quick Fixes (Just update links)
```swift
// In index-standalone.swift, change:
Link("GitHub", href: "https://github.com/yourusername/swiftlets")
// To:
Link("GitHub", href: "https://github.com/codelynx/swiftlets")

// In showcase navigation, change:
Link("Layout", href: "/showcase/layout")
// To:
Link("Layout Components", href: "/showcase/layout-components")
```

### For Missing Pages
Either create stub pages or remove the links:
```swift
// Option 1: Remove from navigation
// Comment out or delete these lines

// Option 2: Create stub pages
// Create files like docs/api.swift with "Coming Soon" content
```