# Decision: Fix Strategy

**Selected Strategy:** Strategy A — `slug` is REQUIRED by API/backend

**Evidence:**
1. Call site `src/app/builder/new/page.tsx` explicitly constructs `slug` using a `slugify` helper and timestamp, clearly intending to define it client-side.
2. `src/types/index.ts` (Global Types) defines `IForm` with `slug: string` and `is_public: boolean` as required fields.
3. The local interface `CreateFormPayload` in `src/hooks/useForm.ts` is incomplete, missing `slug` and `is_public`, causing the type error.
4. The error `Object literal may only specify known properties` confirms the mismatch.

**Plan:**
1. Update `src/hooks/useForm.ts` to include `slug` and `is_public` in `CreateFormPayload`.
2. This aligns the client-side payload with the likely backend data model (`IForm`) and the feature code's intent.

