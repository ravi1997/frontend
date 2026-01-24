# Known Issue: Missing Key Warning in BuilderCanvas

## Symptoms

Console warning:
`Each child in a list should have a unique "key" prop.`
`Check the render method of SortableContext. It was passed a child from BuilderCanvas.`

This often happens when editing an existing form that was loaded from the backend.

## Root Cause

The `sections` and `questions` arrays loaded from the backend did not always include an `id` field. The frontend `ISection` and `IQuestion` types expect an `id` for rendering keys and for `dnd-kit`'s sortable functionality. If the backend schema differs or omits these IDs, the frontend loop in `BuilderCanvas.tsx` would use `undefined` as a key, triggering the React warning.

## Resolution

Modified the `BuilderStore` to ensure that every section and question has a unique ID when loaded from the backend.

### Fixed Pattern

In `src/store/builderStore.ts`, the `loadForm` and `loadVersion` methods now map over the incoming sections and questions to inject a `uuidv4()` if an `id` is missing.

```typescript
const sections = (latestVersion?.sections || []).map(s => ({
  ...s,
  id: s.id || uuidv4(),
  questions: (s.questions || []).map(q => ({
    ...q,
    id: q.id || uuidv4()
  }))
}));
```

This ensures that `key={section.id}` in `BuilderCanvas.tsx` and `key={question.id}` in `SortableSection.tsx` always receive a unique, defined value.
