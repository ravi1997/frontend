# Changelog: ISSUE-0006 Conditional Logic Engine

## Feature

- Implemented **Conditional Logic Schema** & **Engine**.
- Validation logic to show/hide fields based on rules.

## Code Changes

### `src/types/index.ts`

- Added `LogicOperator` and `ILogicRule` types.
- Updated `IQuestion` to include `visibility_rules: ILogicRule[]`.

### `src/lib/logicEngine.ts`

- Created `evaluateRule`: Core comparison logic (equals, not_equals, gt, etc.).
- Created `shouldShowField`: Evaluates all field rules (AND logic).

## Tests

- Added `src/lib/__tests__/logicEngine.test.ts` covering all operators and visibility scenarios.
