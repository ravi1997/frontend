# Risk and Technical Debt Report (Revised)

## 1. Top 5 System Risks

| Risk | Impact | Severity | Description |
| :--- | :--- | :--- | :--- |
| **Build Fracture** | High | 🔴 CRITICAL | 52 build-breaking errors in the Form Builder module. |
| **UI Fragmentation** | Medium | ⚠️ HIGH | RenderFlex overflows on standard dashboard items. |
| **Internal State Leak** | High | ⚠️ HIGH | Interceptors accessing protected Riverpod members. |
| **Logic Regression** | High | ⚠️ HIGH | Complex form logic completely untested. |
| **Dependency Rot** | Medium | ⚠️ MEDIUM | Legacy Next.js artifacts and unused node_modules in root. |

## 2. Technical Debt Catalog (Specifics)

- **Path Wiring**: Many UI widgets have incorrect relative paths for imports, suggesting a partial refactor occurred but wasn't completed.
- **Code Gen Mismatch**: entities and generated files are out of sync (`recent_form.dart`).
- **Configuration**: Hardcoded API URLs persist in `api_client.dart`.
- **Lint Suppression**: Widespread ignoring of "Curly Braces" and "Deprecated Member Use" rules.

## 3. Summary

The technical debt is no longer "localized" to infrastructure. It has seeped into the feature modules (`form_builder` specifically), leading to a state where large parts of the code are currently non-executable and non-testable.
