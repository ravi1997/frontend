# REPRO: Implement Edge Case Validations

## Context

The form builder lacks client-side validation for critical edge cases, which could lead to poor user experience, invalid URLs (slugs), and potential XSS vulnerabilities.

## Identified Gaps

1. **Empty Forms**: Possible to save a form with no sections or fields.
2. **Invalid Slugs**: Slugs don't enforce URL-safe characters in the frontend.
3. **XSS Risk**: Titles and descriptions are not sanitized before submission.
4. **ID Collisions**: Duplicate field/section IDs are not caught.
