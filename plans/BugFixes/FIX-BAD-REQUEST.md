---
description: Fix "BAD REQUEST" error by improved error message extraction and fixing payload mismatches
---

# Problem

The frontend shows "BAD REQUEST" instead of the actual error message from the backend. This happens because `src/lib/api.ts` only looks for a `message` field in the response data, while the backend often uses an `error` field.
Additionally, the backend `Form` model does not have a `workflows` field, which was causing issues previously. Although the backend now filters unknown fields, the frontend still sends `workflows` which might be causing confusion or other issues if further validation is added.

# Proposed Changes

## 1. Improve Error Message Extraction in `src/lib/api.ts`

- Update `request` function to check for both `message` and `error` fields in `responseData`.

## 2. Address `workflows` field in `useForm.ts`

- Ensure `workflows` is either properly handled or removed if not supported by the basic form creation endpoint.
- Actually, the backend `create_form` ignores unknown fields, but it's better to keep the frontend in sync with the model.

# Verification Plan

- Create a test case that mocks a 400 response with an `error` field and verify it's correctly extracted.
- Verify that form creation works (once we know the real error if it persists).
