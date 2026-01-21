# CHANGELOG: Issue #6 - Conditional Logic Engine

## Added

- **src/components/form-builder/properties/LogicBuilder.tsx**: New component for defining visibility rules (Show/Hide logic) on fields.
- **src/components/form-builder/FormPreview.tsx**: New interactive preview dialog that evaluates logic rules in real-time.
- **src/components/form-builder/FormInput.tsx**: Reusable input renderer for the preview mode.
- **src/components/ui/checkbox.tsx**: Validation UI component.

## Changed

- **src/components/form-builder/BuilderProperties.tsx**: Integrated `LogicBuilder` into the properties panel.
- **src/app/builder/new/page.tsx**: Added "Preview" button functionality to open the `FormPreview` dialog.

## Dependencies

- **uuid**: Added for generating unique rule IDs.
