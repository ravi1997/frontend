# Changes Summary

**File:** `src/hooks/useForm.ts`
- Extended `CreateFormPayload` interface to include:
  - `slug: string`
  - `is_public: boolean`

**Reason:**
- Fixes TypeScript build error in `src/app/builder/new/page.tsx` where these fields were being passed but rejected by the strict type definition.
- Aligns payload type with `IForm` definition in `src/types/index.ts`.

