# Reproduction Report: ISSUE-0006 Conditional Logic

## Issue Description

Users need to define rules such as "Show this field IF other field equals X".
Currently, the schema has a `visibility_condition` string field (JSON), but there is no parser, no UI to edit it, and no engine to evaluate it.

## Gap Analysis

1. **Schema**: `IQuestion` has `visibility_condition?: string`. This is too opaque. We need a structured type.
2. **UI**: `BuilderProperties.tsx` does not have a "Logic" or "Conditions" tab.
3. **Engine**: No logic exists to evaluate these conditions at runtime/preview.

## Reproduction

1. Open Builder.
2. Select a field.
3. Look for "Conditional Logic" settings in the Properties panel.
4. **Result**: Not found.
