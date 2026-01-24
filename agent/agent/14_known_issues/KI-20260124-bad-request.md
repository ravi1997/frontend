# Known Issue: "BAD REQUEST" Error during Form Creation/Update

## Symptoms

- User sees "BAD REQUEST" alert when trying to save a new form or update metadata.
- Console shows `at request (src/lib/api.ts:90:21)`.
- Network tab shows 400 Bad Request.

## Root Cause

1. **Error Message Extraction**: `src/lib/api.ts` was only looking for a `message` field in the error response. Many backend errors use an `error` field, causing the frontend to fall back to the generic "BAD REQUEST" status text.
2. **Method Mismatch**: `useForm.ts` was using `PATCH` for form updates, while the backend only supported `PUT` for the `/<form_id>` route.
3. **Model Mismatch (workflows)**: The frontend was sending a `workflows` field which does not exist in the backend `Form` model. (Partially mitigated by backend field filtering).
4. **Model Mismatch (approval_steps)**: `IApprovalStep` fields (`step_number`, `approver_role`, `required_count`) did not match backend `ApprovalStep` model fields (`name`, `required_role`, `order`), causing validation errors if approvals were enabled.

## Fix / Workaround

1. **Update `src/lib/api.ts`**: Extract error from both `message` and `error` fields.

   ```typescript
   const responseDataObj = responseData as { message?: string, error?: string };
   const errorMessage = responseDataObj?.message || responseDataObj?.error || response.statusText || 'Request failed';
   ```

2. **Update `src/hooks/useForm.ts`**: Use `api.put` instead of `api.patch` for form updates.
3. **Align Model Types**: Updated `IApprovalStep` to match backend fields and updated components accordingly.

## Date

2026-01-24
