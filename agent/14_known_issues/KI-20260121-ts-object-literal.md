Issue-Key: KI-20260121-ts-object-literal

# Known Issue: TypeScript Object Literal Property Mismatch

## 1. Detection Signature

**Error Snippet:**
```
Type error: Object literal may only specify known properties, and 'X' does not exist in type 'Y'.
```

**Context:**
- TypeScript build or check.
- Occurs when passing an object literal to a function or hook where the interface definition is strictly smaller than the provided object.

## 2. Root Cause
The interface defining the expected payload (e.g., in a hook or API client) allows fewer properties than the consuming component is providing. This often happens when features are added to the UI/Component but the type definition (usually in a separate file like `types.ts` or within a hook) is not updated.

## 3. Fix Procedure
1.  **Identify the interface** named in the error message (e.g., `CreateFormPayload`).
2.  **Locate the definition** (usually via grep or Go to Definition).
3.  **Verify intent**: Should the extra property be there?
    - If **YES**: Add the property to the interface.
    - If **NO**: Remove the property from the call site.
4.  **Action**: Edit the interface file to include the missing property (e.g., `slug: string;`).

## 4. Regression Prevention
- **Type Guard**: The TypeScript compiler itself handles regression prevention.
- **CI Enforcement**: Ensure `tsc --noEmit` or `npm run build` runs in the CI pipeline.
- **Validation Command**: `npx tsc --noEmit`

## 5. Related Resources
- **Rules**: `agent/11_rules/typescript_rules.md` (Ensure strict coding standards).
- **Gates**: `agent/05_gates/global/gate_global_quality.md` (Must pass build).
