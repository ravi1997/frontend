# Plan - Fix API Payload Mismatch and Improved Error Reporting

The goal is to fix the "BAD REQUEST" error when creating form versions by aligning the frontend payload with backend expectations and enhancing API error extraction.

## Problem

1. **Payload Mismatch**: The backend expects different field names (`label` instead of `question_text`) and field type values (`input` instead of `short_text`). It also rejects fields like `order_index` and `is_repeatable` in some contexts.
2. **Opaque Errors**: `api.ts` logs "Bad Request" instead of the detailed validation errors returned by the backend, making debugging difficult.

## Proposed Changes

### 1. Enhance `src/lib/api.ts`

- Modify the error handling block to better extract messages from structured objects.
- If `message` and `error` are missing, but the response is an object, stringify it or summarize it for the `ErrorMessage`.

### 2. Implement Payload Mapping in `src/hooks/useForm.ts` (or a utility)

- Create a `mapFrontendToBackend` helper to transform `ISection` and `IQuestion` objects.
- Mapping:
  - `question_text` -> `label`
  - `short_text`, `email`, `url`, `mobile`, `number` -> `input`
  - `long_text` -> `textarea`
  - `dropdown` -> `select`
  - `file_upload` -> `file_upload`
  - Remove `order_index` and `is_repeatable` (from sections) if they cause "Unknown field" errors.

### 3. Update `useForm.ts` to use the mapping

- Apply the mapping in `createVersion` and `saveNewForm`.

## Verification Plan

1. **Unit Test for `api.ts`**: Update `repro_api_error.test.ts` to verify it now extracts detailed error messages.
2. **Unit Test for Mapping**: Create a test to verify the transformation logic.
3. **Manual Verification**: (If possible) Verify that form saving no longer results in validation errors.
