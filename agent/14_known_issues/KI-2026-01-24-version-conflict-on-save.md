# Known Issue: Version Conflict on Form Save

## Symptoms

Console Error when saving changes to an existing form:
`Version 1.0 already exists`

This prevents users from saving their progress more than once.

## Root Cause

The `handleSave` function in the form builder page (`src/app/builder/[id]/page.tsx`) had a hardcoded version string `'1.0'` in the payload for the `createVersion` mutation.

```typescript
await createVersion.mutateAsync({
    formId: id,
    payload: {
        version: '1.0', // Hardcoded version
        sections,
        activate: true
    }
});
```

Since the backend enforces unique version numbers for a given form, the second save attempt would fail because version 1.0 was already created during the initial save (or when the form was first created).

## Resolution

Modified the save logic to dynamically calculate the next version number based on the existing versions stored in the `BuilderStore`.

### Fixed Pattern

Calculated based on the maximum version number currently present in the form:

```typescript
const nextVersion = versions.length > 0 
    ? (Math.max(...versions.map(v => v.version_number)) + 1).toFixed(1)
    : '1.0';

await createVersion.mutateAsync({
    formId: id,
    payload: {
        version: nextVersion,
        sections,
        activate: true
    }
});
```

This ensures that every save creates a new incremented version (e.g., 2.0, 3.0, etc.), avoiding conflicts with existing entries.
