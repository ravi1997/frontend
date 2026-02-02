# Test Specification: Multi-language Form Support (i18n)

## 1. Overview

- **Connected Feature**: M-19 i18n
- **Quality Goal**: Ensure form accessibility across different languages with reliable fallback.

## 2. Test Cases (Success Path)

| ID | Scenario | Input | Expected Output | Status |
| --- | --- | --- | --- | --- |
| TS-001 | Create Translated Form | Add "es" translation for "Name" -> "Nombre" | Form stores both languages in JSON | |
| TS-002 | Switch Rendering Language | Change locale to "es" in Preview | Question labels update from "Name" to "Nombre" | |
| TS-003 | Default Fallback | Switch to "fr" (not provided) | Displays "Name" (en) | |

## 3. Edge Cases & Error Handling

| ID | Scenario | Input | Expected Behavior |
| --- | --- | --- | --- |
| TE-001 | Empty Translation Map | `{}` | Display "Untitled" or field ID |
| TE-002 | Corrupt Locale Code | "invalid_code" | Fallback to "en" |
| TE-003 | Mixed Translations | Some fields translated, others not | Translated fields show target language, others show default |

## 4. Environment Requirements

- [ ] `easy_localization` or simple Map-based state provider.
- [ ] Updated mock data with multi-language strings.

## 5. Verification Command

`flutter test test/features/form_builder/i18n_flow_test.dart`
