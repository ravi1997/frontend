# REPRO: Issue #11 Workflow Automation UI Bugs

## Issue

The `WorkflowManager.tsx` component contains malformed JSX and redundant buttons (Visual bug/Syntax error).

## Location

`src/components/form-builder/workflow/WorkflowManager.tsx` lines 186-189.

## Evidence

```tsx
<X className="h-3 w-3" /> // Note: Need to import X, I imported simple Trash2 before. Wait, I imported X for Dialog but not here.
{/* I also imported Trash2, I'll use Trash2 */}
<Trash2 className="h-3 w-3" />
```

This renders distinct artifacts and duplicate actions.

## Goal

Clean up the UI, ensure "Remove Action" works correctly, and add unit tests to prevent regression.
