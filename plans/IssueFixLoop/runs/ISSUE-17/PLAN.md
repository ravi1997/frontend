# Implementation Plan: Conditional Logic Engine (MVP)

## Objectives

- defined `ILogicCondition` schema.
- Create a "Logic Engine" utility to evaluate conditions against form data.
- Update `BuilderProperties` to allow setting simple "Show If" rules.

## 1. Schema Updates (`src/types/index.ts`)

- Define `LogicOperator`: 'equals' | 'not_equals' | 'contains' | 'greater_than' | 'less_than'.
- Define `ILogicRule`:
  - `field_id`: string (the target field to check)
  - `operator`: LogicOperator
  - `value`: string | number | boolean
- Update `IQuestion.visibility_rules`: `ILogicRule[]` (Change from string to structured array).

## 2. Logic Engine (`src/lib/logicEngine.ts`)

- `evaluateRule(rule: ILogicRule, formData: Record<string, any>): boolean`
- `evaluateFieldVisibility(field: IQuestion, formData: Record<string, any>): boolean`

## 3. UI Components (`src/components/form-builder/properties/LogicEditor.tsx`)

- A component to be used inside `BuilderProperties`.
- Select `Field` (from available fields in form).
- Select `Operator`.
- Input `Value`.

## 4. Integration

- Update `BuilderProperties` to include the `LogicEditor`.
- *Note*: Validating "Real-time" preview might require a "Preview Mode" where we actually hold state. For now, we just implement the configuration UI and the Engine logic. The "Live Preview" might be out of scope for *this* specific issue if it requires a full "Form Runner", but we can ensure the Schema and Engine are ready. I will add a simple check in `BuilderCanvas` or a test to verify engine logic.

## Context Budget

- Estimated tokens: 4500
