# Recommended Action Plan (Revised)

## Phase 1: Build Recovery (Critical - 48h)

1. **URI Repair**: Fix all broken relative paths in `lib/features/form_builder/presentation/widgets/properties/`.
2. **Gen-Code Sync**: Fix the `RecentForm` constructor in `recent_form.dart` to match the Freezed redirect. Run `build_runner`.
3. **Refactor Interceptors**: Remove `ref.state` usage in `AuthInterceptor`. Use a proper notifier access or watch the provider.

## Phase 2: UI Stability & QA (Short Term)

1. **Layout Fixes**: Implement `Expanded` or `Flexible` in the Dashboard card Column to resolve the 1.4px overflow.
2. **Lint Sweep**: Run `dart fix --apply` and manually add braces to complex logic flows in `form_logic_evaluator.dart`.
3. **Environment Setup**: Implement `flutter_config` or similar for API URL management.

## Phase 3: Testing Foundation (Short Term)

1. **Smoke Test Recovery**: Ensure `test/widget_test.dart` passes.
2. **Logic Verification**: Implement unit tests for the Form Builder logic engine.

## Phase 4: Root Cleanup

1. **Artifact Removal**: Delete `node_modules`, `.next`, and `.env.local` (after moving configurations to a secure system).
2. **Ops Setup**: Standardize the `Dockerfile` for Flutter Web production.
