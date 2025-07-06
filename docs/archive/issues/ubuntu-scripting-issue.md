# Ubuntu Scripting Issue - Build-Site Loop Problem

## Issue Description

When running the `build-site` script on Ubuntu/Linux, only one Swift file was being processed instead of all files in the site. The script worked correctly on macOS but failed on Linux distributions.

## Root Cause

The issue was caused by differences in how bash handles loops with process substitution between macOS and Linux. The original code used:

```bash
find "$SITE_ROOT/src" -name "*.swift" -type f | sort | while IFS= read -r file; do
    # Process file
    ((built_count++))  # Variables modified in subshell
done
```

### Why This Failed on Linux

1. **Subshell Behavior**: On Linux, the pipe creates a subshell for the while loop, meaning any variables modified inside the loop (like counters) are lost when the subshell exits.

2. **Process Substitution Issues**: Attempts to use process substitution also failed:
   ```bash
   while IFS= read -r file; do
       # Process file
   done < <(find "$SITE_ROOT/src" -name "*.swift" -type f | sort)
   ```
   This syntax, while valid in bash, behaved differently on Ubuntu's bash implementation.

## Solution

The solution was to use a temporary file to store the file list:

```bash
# Create temporary file for the file list
local tmpfile=$(mktemp)
find "$SITE_ROOT/src" -name "*.swift" -type f | sort > "$tmpfile"

# Process each file from the temporary file
while IFS= read -r file; do
    # Process file
    ((built_count++))  # Variables now persist correctly
done < "$tmpfile"

# Clean up temporary file
rm -f "$tmpfile"
```

## Why This Works

1. **No Subshell**: Reading from a file doesn't create a subshell, so variables modified in the loop persist.
2. **Cross-Platform**: This approach works identically on both macOS and Linux.
3. **Reliable**: Avoids shell-specific behaviors and edge cases.

## Other Cross-Platform Fixes

### MD5 Command Differences

macOS and Linux use different MD5 commands:
- macOS: `md5 -q file`
- Linux: `md5sum file | cut -d' ' -f1`

Fixed with platform detection:
```bash
if [[ "$OSTYPE" == "darwin"* ]]; then
    MD5_CMD="md5 -q"
else
    MD5_CMD="md5sum | cut -d' ' -f1"
fi
```

## Testing

The fix was tested on:
- macOS (both Intel and Apple Silicon)
- Ubuntu 22.04 LTS
- Other Linux distributions

All platforms now successfully build all Swift files in a site.

## Lessons Learned

1. **Avoid Pipes in Loops**: When modifying variables inside loops, avoid piping into while loops.
2. **Test on Multiple Platforms**: Shell scripts can behave differently across Unix-like systems.
3. **Use Temporary Files**: For maximum compatibility, temporary files are more reliable than process substitution.
4. **Platform Detection**: Always check for platform-specific commands (like md5 vs md5sum).

## Impact

This fix ensures the Swiftlets build system works reliably across all supported platforms, maintaining the project's cross-platform goals.