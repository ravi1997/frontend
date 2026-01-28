# Implementation Plan - Advanced Form Layout & Styling

This plan outlines the steps to implement comprehensive layout and UI styling controls for the Form Builder, allowing users to customize the appearance of questions, sections, and the overall form.

## Phase 1: Domain & Data Layer

- [x] Create `QuestionStyle`, `SectionStyle`, and `FormStyle` entities in `lib/features/form_builder/domain/entities/form_style.dart`.
- [x] Update `FormQuestion` to include `QuestionStyle` and `columnSpan`.
- [x] Update `FormSection` to include `SectionStyle`.
- [x] Update `BuilderForm` to include `FormStyle`.
- [x] Run `flutter pub run build_runner build --delete-conflicting-outputs` to regenerate code.

## Phase 2: UI - Stylist Controllers

- [x] Implement a "Tabbable" properties panel (Settings | Style) in:
  - `FieldPropertiesWidget`
  - `SectionPropertiesWidget`
  - `FormPropertiesWidget`
- [x] Add Form/Field-specific styling controls:
  - Color pickers (Hex input + presets)
  - Sliders (Padding, Border Radius, Font Size)
  - Dropdowns (Border styles, Label alignment)

## Phase 3: Rendering Engine

- [x] Update `BuilderFieldWidget` to respect `QuestionStyle`.
- [x] Update `FormCanvasWidget` to:
  - Apply `SectionStyle` (cards, shadows, background).
  - Implement a wrapping grid that respects `columnSpan`.
  - Apply global `FormStyle` (background, primary colors).

## Phase 4: Polish & Themes

- [x] Add "Style Presets" (e.g., Glassmorphism, Brutalist, Minimalist).
- [x] Ensure full responsiveness across all layout configurations.
