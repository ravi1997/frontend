# Root Cause Analysis

**Issue:** Type Error `Object literal may only specify known properties` for `slug`.

**Location:**
- Consumer: `src/app/builder/new/page.tsx:28`
- Definition: `src/hooks/useForm.ts:8`

**Cause:**
The `CreateFormPayload` interface in `useForm.ts` defines the contract for creating a form. It currently accepts only `title` and `description`. However, the consumer in `page.tsx` tries to pass `slug` and `is_public`. This mismatch causes TypeScript to flag the extra properties as errors because object literals are strictly checked against their target type.

**Violation:**
TypeScript strict object literal checking rule. The API contract used in the React component does not match the Type definition in the hook.

