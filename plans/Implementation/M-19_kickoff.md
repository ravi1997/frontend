# Feature Kickoff: Multi-language Form Support (i18n)

## Name: Multi-language Form Support (i18n)

## Linked Task: M-19

## Description

Implement support for internationalization (i18n) at the form level. This allows form creators to provide translations for form titles, section headers, question labels, and placeholders. The system should detect the user's language or allow manual selection.

## Implementation Plan

1. **Domain Layer Update**:
    * Update `BuilderForm`, `FormSection`, and `FormQuestion` to support localized strings.
    * Instead of a single `String` for labels, use a `Map<String, String>` (e.g., `{"en": "Name", "es": "Nombre"}`).
2. **i18n Service**:
    * Create a `LocaleController` to manage the app's current locale using `flutter_localization` or a custom Riverpod provider.
3. **UI: Translator Mode**:
    * Add a "Translator" tab or mode in the Form Builder.
    * Allow users to select a target language and provide translations for all existing fields.
4. **UI: Form Rendering**:
    * Update `FormRenderWidget` to fetch strings based on the current locale.
    * Add a language switcher to the `FormPreviewPage`.
5. **Persistence**:
    * Ensure the JSON structure correctly stores the new multi-language map.

## Tests

* [ ] **Locale Switch**: Verify that switching the app locale updates the form content instantly.
* [ ] **Fallback Mechanism**: Ensure that if a translation for a specific language is missing, it falls back to the default (English).
* [ ] **Builder UX**: Verify that the translator UI correctly highlights untranslated fields.

## Checkpoints

* [ ] Data models updated to support maps for localized fields.
* [ ] LocaleController implemented with Riverpod.
* [ ] Translator UI added to Form Builder.
* [ ] Form Rendering updated for dynamic translation.
