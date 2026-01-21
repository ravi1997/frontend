# PLAN: Implementation of Conditional Logic Engine

## Objective

Enable form creators to define "Show/Hide" rules for fields based on the values of other fields.

## Tasks

1. [ ] **Logic Engine Verification**: Ensure `src/lib/logicEngine.ts` is robust and fully tested.
2. [ ] **Logic Builder Component**: Create `src/components/form-builder/properties/LogicBuilder.tsx` to manage visibility rules.
    - [ ] Selector for "Source Field" (the field that triggers the rule).
    - [ ] Selector for "Operator" (equals, contains, etc.).
    - [ ] Input for "Value".
    - [ ] List existing rules with delete functionality.
3. [ ] **UI Integration**: Add `LogicBuilder` to `src/components/form-builder/BuilderProperties.tsx`.
4. [ ] **Store Integration**: Ensure `updateField` correctly persists `visibility_rules`.
5. [ ] **Preview Integration**: Update `BuilderCanvas` (or individual input components) to respect visibility rules during preview.
    - Note: The current preview might just be a visual layout. If it's interactive, we need local state for form data.

## Strategy

- Use `useBuilderStore` to access form schema.
- Prevent circular dependencies by only allowing rules based on *other* fields (ideally preceding ones, but for MVP just 'not self').
- Evaluate rules in real-time within the canvas if the canvas allows data entry. If not, maybe add a "Preview Mode" toggle? For now, I'll assume the canvas is just for building, but I should check if it captures values.
