# Known Issue: Blank Form on Edit (Loading Schema Mismatch)

## Symptoms

When editing an existing form, the user sees a blank form or empty sections, even though the API returns data.
API response contains fields like `label` and `field_type: "input"`, but the UI expects `question_text` and specific `FieldType` enums (e.g., `short_text`).

## Root Cause

The schema used by the backend differs from the frontend state model:

- Backend: `_id`, `label`, `field_type` ("input", "textarea", etc.)
- Frontend: `id`, `question_text`, `field_type` ("short_text", "long_text", etc.)

Previously, `loadForm` only injected missing IDs but did not transform the field names or values.

## Resolution

Implemented a robust `transformBackendToFrontend` utility in `src/lib/transformers.ts` and integrated it into the `builderStore`'s `loadForm` and `loadVersion` methods.

### Transformation Logic

1. `id` <- `_id` or `id` (or fallback to `uuidv4()`)
2. `question_text` <- `label` or `question_text`
3. `field_type` <- Mapped from backend string (e.g., "input" -> "short_text") to frontend Enum.

This ensures that data loaded from the API is correctly visualized in the Form Builder.
