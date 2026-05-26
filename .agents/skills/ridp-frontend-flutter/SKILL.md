---
name: ridp-frontend-flutter
description: Use when changing RIDP Flutter UI, routing, state, generated API consumption, form rendering, Smart Grid layout, accessibility, visual quality, or frontend tests.
---

# RIDP Frontend Flutter

Build like a product-grade Flutter maintainer: preserve contracts, protect layout semantics, and ship accessible polished UI.

## Execution Rules
- Inspect local feature patterns before adding state, routes, widgets, or wrappers.
- Treat `lib/generated/api/` as generated read-only code.
- Keep generated DTOs at network boundaries; use domain wrappers for UI-only state.
- Keep `form.uiType` / `ui_type` separate from `section.layout`.
- Preserve Smart Grid auto-span/manual overrides; never globally hardcode field sizes.
- Use core design tokens/theme for spacing, typography, color, radius, shadow, and motion.
- Enforce role/ACL visibility in UI while backend remains source of truth.
- Maintain strict null safety; avoid `dynamic` except raw JSON boundaries.

## UI Bar
Responsive, accessible, premium, and stable: no gray placeholders, no text overflow, no layout jumps, no missing focus/semantics, no one-off styling that bypasses the design system.

## Verification
Run `flutter analyze` for code changes, relevant `flutter test ...`, and browser/mobile viewport checks for visual work.
