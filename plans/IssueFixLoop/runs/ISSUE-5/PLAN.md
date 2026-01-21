# PLAN: Implement Edge Case Validations

## Objective

Strengthen the form builder by implementing robust client-side validation and sanitization.

## Tasks

1. [ ] Install `dompurify` and its types.
2. [ ] Implement `validateForm` utility to check for:
    - Non-empty sections/fields.
    - Slug regex (`/^[a-z0-9-]+$/`).
    - Unique field IDs.
3. [ ] Integrate validation into `useForm` hook.
4. [ ] Implement sanitization for form metadata.
5. [ ] Add unit tests for edge cases.

## Strategy

Update the `useForm` hook to run a series of validation checks before proceeding with the `api.post` calls. Sanitization will be applied to the payload strings.
