# Analytics Integration - Taskboard

## Task Summary

**Feature**: M-11 Analytics Dashboard Integration  
**Objective**: Connect pre-built Analytics UI to backend API endpoints  
**Priority**: HIGH  
**Estimation**: 1-2 hours

---

## Task Breakdown

| Task ID | Assigned Profile | Dependencies | Expected Outputs | Success Criteria |
| --- | :--- | :--- | :--- | :--- |
| T-01 | `profile_implementer.md` | None | `lib/features/analytics/data/repositories/analytics_repository_impl.dart` | Repository compiles, follows existing patterns |
| T-02 | `profile_implementer.md` | T-01 | `lib/features/analytics/presentation/controllers/analytics_controller.dart` | Controller extends `AnalyticsControllerBase`, handles loading/error states |
| T-03 | `profile_implementer.md` | T-02 | Modified `lib/features/analytics/presentation/pages/analytics_page.dart` | UI displays real data from controller |
| T-04 | `profile_tester.md` | T-03 | `test/features/analytics/integration_test.dart` | All 3 charts render with real data |
| T-05 | `profile_pr_reviewer.md` | T-04 | PR review checklist completed | Passes `gate_flutter_tests.md` and `gate_flutter_build.md` |

---

## Task Details

### T-01: Create AnalyticsRepositoryImpl

**Profile**: Implementer  
**Dependencies**: None  
**Expected Output**: `lib/features/analytics/data/repositories/analytics_repository_impl.dart`  
**Success Criteria**:

- Implements `AnalyticsRepository` interface
- Uses `ApiClient` for HTTP calls
- Handles the 3 endpoints:
  - `GET /forms/{id}/analytics/summary`
  - `GET /forms/{id}/analytics/timeline`
  - `GET /forms/{id}/analytics/distribution`
- Includes proper error handling

### T-02: Create AnalyticsController

**Profile**: Implementer  
**Dependencies**: T-01  
**Expected Output**: `lib/features/analytics/presentation/controllers/analytics_controller.dart`  
**Success Criteria**:

- Extends `StateNotifier` or `AutoDisposeAsyncNotifier`
- Exposes `AsyncData<AnalyticsData>` states
- Handles loading and error states
- Follows existing controller patterns in project

### T-03: Wire UI to Controller

**Profile**: Implementer  
**Dependencies**: T-02  
**Expected Output**: Modified `lib/features/analytics/presentation/pages/analytics_page.dart`  
**Success Criteria**:

- Replaces mock data with `ref.watch(analyticsController)`
- All 3 chart widgets display real data
- Loading states shown during fetch
- Error states handled gracefully

### T-04: Integration Testing

**Profile**: Tester  
**Dependencies**: T-03  
**Expected Output**: `test/features/analytics/integration_test.dart`  
**Success Criteria**:

- Tests that charts render with API data
- Tests loading state transitions
- Tests error handling
- All tests pass

### T-05: End-to-End Validation

**Profile**: PR Reviewer  
**Dependencies**: T-04  
**Expected Output**: PR review checklist completed  
**Success Criteria**:

- Passes `gate_flutter_build.md`
- Passes `gate_flutter_tests.md`
- Passes `gate_flutter_style.md`
- Code follows Clean Architecture patterns

---

## Gate Requirements

| Gate | Applied To | Criteria |
| --- | :--- | :--- |
| `gate_flutter_build.md` | All tasks | `flutter build apk --debug` succeeds |
| `gate_flutter_tests.md` | T-04, T-05 | `flutter test` passes with 100% coverage on analytics |
| `gate_flutter_style.md` | All tasks | `flutter analyze` reports no errors |

---

## File References

### Source Files

- Analytics Page: `lib/features/analytics/presentation/pages/analytics_page.dart`
- Analytics Controller Base: `lib/features/analytics/presentation/controllers/analytics_controller_base.dart`
- Existing Repository Pattern: `lib/features/dashboard/data/repositories/dashboard_repository_impl.dart`

### API Endpoints

- Summary: `GET /forms/{id}/analytics/summary`
- Timeline: `GET /forms/{id}/analytics/timeline`
- Distribution: `GET /forms/{id}/analytics/distribution`

### Related Plans

- Prompt Routing: `plans/Orchestration/prompt_routing.md`
- Integration Progress: `plans/INTEGRATION_PROGRESS.md`
