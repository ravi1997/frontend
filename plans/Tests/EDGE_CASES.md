# Edge Case Analysis

Based on the core hooks (`useAuth`, `useForm`), the following edge cases have been identified for future implementation/testing.

## Input-Specific Edge Cases

### 1. Authentication (`useAuth`)

- **Malformed Email**: Invalid email format in login.
- **Empty OTP**: Submitting OTP verification with empty string.
- **Long Password**: Passwords exceeding database limits (e.g., > 255 chars).
- **Session Expiry**: Behavior when JWT expires mid-interaction.

### 2. Form Builder (`useForm`)

- **Empty Sections**: Creating a form version with no sections/fields.
- **Duplicate Version Names**: Attempting to create a version with an existing name.
- **Max Field Count**: Dragging a very large number of fields (>100) into a form.
- **Invalid Slug**: URL slugs with special characters not handled by backend.

## Environment Edge Cases

- **Offline Mode**: Submitting a form or creating a draft while disconnected.
- **Slow Network**: High latency responses from API endpoints.
- **API Error 500**: Graceful handling of backend internal errors.

## Recommended "Evil" Inputs

- `<script>alert(1)</script>` (XSS in form title)
- `' OR '1'='1` (SQL Injection in search fields)
- `NaN`, `Infinity`, `undefined` strings in numeric fields.
