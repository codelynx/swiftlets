# Documentation Updates Summary

This document summarizes the documentation updates made to reflect recent code changes.

## Changes Made

### 1. Platform Path Updates (darwin → macos)

Updated binary paths from `bin/darwin/` to `bin/macos/` in:
- `docs/project-structure.md` - Line 213
- `docs/SITE-MANAGEMENT.md` - Line 60  
- `docs/CONFIGURATION.md` - Lines 42 & 45

### 2. Request Format Updates

Updated JSON request format from using `"path"` to `"url"` and removed `"queryParameters"` field:

- `docs/routing-internals.md` - Updated request JSON example to show:
  - Changed `"path": "/sample/path/to/"` to `"url": "/sample/path/to/?name=John&page=2"`
  - Removed separate `"queryItems"` field
  
- `docs/swiftlet-architecture.md` - Line 196:
  - Changed `"path": "/api/users"` to `"url": "/api/users"`
  - Removed `"params": {}` field
  
- `docs/ROUTING.md` - Lines 132-137:
  - Changed `"path": "/hello"` to `"url": "/hello?name=World"`
  - Removed `"queryParameters"` field

### 3. Files Reviewed (No Changes Needed)

- `docs/SWIFTUI-API-MIGRATION-GUIDE.md` - References to `queryParameters` are correct as they refer to the computed property on the Request struct
- `docs/SWIFTUI-API-PARAMETER-PASSING.md` - Contains outdated conceptual information but doesn't affect current implementation

## Key Points

1. **URL Format**: The server now sends the full URL (including query parameters) in a single `"url"` field
2. **Query Parameters**: Are automatically parsed from the URL by the Request struct's computed property
3. **Platform Naming**: Consistently using `macos` instead of `darwin` for macOS platform paths
4. **Backward Compatibility**: The Request struct still provides `queryParameters` as a computed property, so existing code continues to work

## Implementation Details

The Request struct (in `Sources/Swiftlets/Core/Request.swift`) stores the full URL and provides:
- `url`: The full URL including query parameters
- `queryParameters`: A computed property that parses parameters from the URL
- `path`: A legacy property that returns the URL (for backward compatibility)

This design provides a single source of truth (the URL) while maintaining convenient access to parsed query parameters.