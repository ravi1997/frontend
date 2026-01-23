# Non-Functional Requirements

## 1. Performance

- **NFR-01**: Form rendering must occur under 200ms (Client-Side optimized).
- **NFR-02**: Static generation (SSG/ISR) for high-traffic public forms.
- **NFR-03**: Optimized images and assets for PWA Performance.

## 2. Security

- **NFR-04**: Input sanitization using `DOMPurify` to prevent XSS.
- **NFR-05**: Auth tokens must be managed securely (HTTPOnly cookies preferred).
- **NFR-06**: Zod schema validation for all inputs.

## 3. Reliability & PWA

- **NFR-07**: Application must function offline (PWA Service Worker).
- **NFR-08**: Graceful degradation if API is unreachable.

## 4. Maintainability

- **NFR-09**: Strict TypeScript types (>95% coverage).
- **NFR-10**: Component-driven architecture using Shadcn UI.
