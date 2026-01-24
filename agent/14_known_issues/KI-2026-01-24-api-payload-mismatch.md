# Known Issue: API Payload Mismatch (Form Versions)

## Symptoms

Console Error during form version creation/update:
`BAD REQUEST` or `Validation Error: {"sections": ...}`

The error message indicates:

- `label` is missing for required field in questions.
- `field_type` must be one of: `input, textarea, select, checkbox, radio, boolean, rating, date, file_upload, api_search, calculated, file.`
- `order_index`, `question_text`, `is_repeatable` are "Unknown field".

## Root Cause

The frontend uses a different schema for `Section` and `Question` objects than what the backend expects for the `/versions` endpoint.

- Frontend uses `question_text`, backend expects `label`.
- Frontend has more granular field types (e.g., `short_text`, `email`, `url`), backend groups them as `input`.
- Backend restricts fields to a subset that excludes `order_index` and `is_repeatable`.

## Resolution

Implement a transformer that maps frontend models to backend-compatible objects before sending the request.

### Fixed Pattern

In `src/hooks/useForm.ts`, the `createVersion` mutation now applies `transformFormPayload` to the `sections` array.

```typescript
const backendPayload = {
    ...payload,
    sections: transformFormPayload(payload.sections)
};
```

The transformer:

1. Maps `question_text` to `label`.
2. Maps granular field types to backend-supported values (`input`, `textarea`, etc.).
3. Removes unsupported fields like `order_index` and `is_repeatable`.

## Improved Error Reporting

Modified `src/lib/api.ts` to extract detailed validation errors from the backend response even if they don't follow the `{message: string}` format. This ensures that future schema mismatches are immediately obvious in the console.
