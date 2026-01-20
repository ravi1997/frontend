# Pull Request Review: Local Changes Review

## Summary

- **Decision**: **REQUEST_CHANGES**
- **Quality Score**: 6/10
- **Total Issues**: 4
- **Categories**: Style (2), Correctness (1), Maintainability (1)

---

## Detailed Feedback

### 1. Style: Regression to Relative Imports

Across `useAuth.ts`, `useForm.ts`, and `useForms.ts`, imports were changed from `@/` (absolute alias) to `../` (relative).

- **Issue**: The project defines `@/*` in `tsconfig.json`. Absolute imports are preferred for readability and robustness against file moves.
- **Action**: Revert relative imports to absolute `@/` imports.

### 2. Maintainability: Hardcoded Endpoint in `useForm.ts`

The `createVersion` mutation still uses a hardcoded URL string:

```typescript
const response = await api.post(`/form/${formId}/versions`, payload);
```

- **Issue**: This should be moved to `API_ENDPOINTS` in `lib/constants.ts` to maintain consistency with the rest of the file.
- **Action**: Add `VERSIONS` to `API_ENDPOINTS.FORMS` and use it here.

### 3. Correctness: Missing Error Variable Usage

In `src/app/builder/new/page.tsx`:

```typescript
} catch {
  // Error handled in hook
}
```

- **Observation**: While syntactically correct, ensure that the error isn't actually needed for any telemetry or local logging if the hook fails unexpectedly. (Low priority)

### 4. Style: Inconsistent Typing in `useAuth.ts`

Good job removing `any`, but `Record<string, string | undefined>` is quite broad.

- **Action**: Consider using a more specific type if the payload structure is known, or keep it as is if dynamic keys are truly required.

---

## Rubric Scores

| Category | Score | Notes |
| --- | --- | --- |
| **Logic** | 8/10 | Core logic is sound and improved by constant usage. |
| **Style** | 5/10 | Deducted for relative import regression. |
| **Testability** | 6/10 | Use of custom hooks makes it testable, but no new tests were added for these changes. |

## Action Items

1. [ ] Revert `../` imports to `@/`.
2. [ ] Update `lib/constants.ts` to include `VERSIONS` endpoint.
3. [ ] Refactor `useForm.ts` to use the new constant.
4. [ ] (Optional) Add a unit test for `useAuth` login payload transformation logic.
