# KI-20260127-glasscontainer-infinite-size

## Symptom

Application throws "Cannot hit test a render box with no size" or "BoxConstraints forces an infinite height" when using widgets that wrap `GlassContainer`.

## Root Cause

Custom `AppGlassCard` widget was hardcoding `height: double.infinity` and `width: double.infinity`.
When placed inside unbounded parents like `Column`, `ListView`, or `Row`, this causes layout explosions or hit-test failures if the constraint becomes 0 or infinite.

## Solution

Remove forced infinity. Make width/height nullable and default to `null` (shrink wrap) or rely on parent constraints properly.

```dart
// Before
GlassContainer(
  height: double.infinity,
  width: double.infinity,
  // ...
)

// After
GlassContainer(
  height: height, // nullable
  width: width,   // nullable
  // ...
)
```

## Related Skills

- `skill_flutter_layout`
