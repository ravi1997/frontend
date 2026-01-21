# Fix Plan

**Objective:** Align `CreateFormPayload` type with the actual data requirements of the application (as seen in usage and global `IForm` type).

**Changes:**
1.  **File:** `src/hooks/useForm.ts`
    *   **Action:** Update `CreateFormPayload` interface.
    *   **Code:** Add `slug: string` and `is_public: boolean`.

**Validation:**
1.  Run `npx tsc --noEmit` to verify the type error is resolved.
2.  (Implicit) `npm run build` would also pass the type check phase.

**Rollback:**
Revert changes to `src/hooks/useForm.ts`.

