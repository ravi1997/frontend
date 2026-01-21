# Changes Summary

**File:** `src/hooks/useForm.ts`
- Added `slug: string` and `is_public: boolean` to the `CreateFormPayload` interface.

**Reason:**
To support the fields being passed by `src/app/builder/new/page.tsx` when creating a new form, aligning the local type with the implemented logic.

