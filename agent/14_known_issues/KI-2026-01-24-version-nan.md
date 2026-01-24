# Known Issue: Version NaN Error

## Symptoms

Console Error: `Version NaN already exists`.
This occurs when the version calculation logic encounters an invalid number (like `NaN`) when trying to determine the next version number.

## Root Cause

The previous logic `Math.max(...versions.map(v => v.version_number))` was fragile.

1. If `v.version_number` was a string (which can happen with API responses), it might not have been parsed correctly depending on context.
2. If any version number was invalid, `Math.max` could return `NaN`.
3. The previous increment logic was `+ 1` (Major version), but the requirement was for minor version increments (`+ 0.1`).

## Resolution

Updated the version calculation logic in `src/app/builder/[id]/page.tsx` to be robust:

```typescript
let nextVersion = '1.0';
if (versions && versions.length > 0) {
    const validVersions = versions
        .map(v => typeof v.version_number === 'string' ? parseFloat(v.version_number) : v.version_number)
        .filter(v => typeof v === 'number' && !isNaN(v));
    
    if (validVersions.length > 0) {
        const maxVersion = Math.max(...validVersions);
        nextVersion = (maxVersion + 0.1).toFixed(1);
    }
}
```

This logic safely parses strings, filters out invalid numbers (`NaN`), and increments by `0.1` for minor version updates.
