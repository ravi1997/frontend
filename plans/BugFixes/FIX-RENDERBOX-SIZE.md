# FIX-RENDERBOX-SIZE

## Issue

"Cannot hit test a render box with no size" or infinite size usage in Column.
The root cause is `AppGlassCard` defaulting to `double.infinity` for both height and width.
When used inside a `Column` (as in `FieldLibraryWidget`), `double.infinity` height causes layout conflicts (unbounded vertical space meets forced infinite height).

## Diagnosis

- `lib/core/widgets/app_glass_card.dart` has `height: double.infinity` and `width: double.infinity`.
- `lib/features/form_builder/presentation/widgets/field_library_widget.dart` uses `AppGlassCard` inside a `Colum`.
- This creates a layout violation.

## Plan

1. Modify `AppGlassCard` to allow nullable `width` and `height`, defaulting to `null` (shrink wrap) instead of `double.infinity`.
2. Pass specific width/height if needed (not needed for `FieldLibraryWidget` AI button, which should shrink wrap).

## Verification

- Run analyze.
- Note: Cannot run app visually, but this is a standard Flutter layout fix.
