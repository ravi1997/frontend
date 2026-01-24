# Plan - Fix "Version NaN" Error and Use Minor Versioning

The goal is to fix the `Version NaN` error and implement minor version increments (e.g., 1.0 -> 1.1).

## Problem

The error `Version NaN already exists` indicates that the calculation `Math.max(...versions.map(v => v.version_number))` resulted in `NaN`. This happens if:

1. `versions` contains elements where `version_number` is undefined, null, or not a number.
2. The `IFormVersion` interface expects `version_number` to be a `number`, but if the API returns it as a string (e.g., "1.0"), passing it directly to `Math.max` without parsing might be safe in modern JS/TS if it is cast well, but if it has non-numeric characters it will fail.
3. Also, `Math.max()` on an empty array returns `-Infinity`, but the check `versions.length > 0` handles that.

However, the user wants **minor version increments**. The current logic `+ 1` increments the major version.

## Proposed Changes

### 1. Robust Version Parsing and Increment

- Parse `version_number` safely (handle string/number).
- Increment by `0.1` instead of `1`.
- Use `parseFloat` to ensure we are working with numbers.
- Handle edge cases where `version_number` might be missing.

### 2. Update `src/app/builder/[id]/page.tsx`

- Refine the `nextVersion` calculation.
- E.g., `(currentMax + 0.1).toFixed(1)`.

## Verification Plan

- Update `src/lib/version_logic.test.ts` to test minor increments and robustness against "NaN" causes.
- Verify `NaN` fix by simulating bad data.
