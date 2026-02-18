# Plan for Code Review Improvements

## Phase 1: Frontend Component Refactoring & Optimization [COMPLETED]

**Goal**: Improve readability and performance of `FormBuilderPage`.

1. **Extract Top Bar**: Created `FormBuilderTopBar` widget in `frontend/lib/features/form_builder/presentation/widgets/form_builder_top_bar.dart`. [x]
2. **Optimize Rebuilds**:
    * Used `ref.watch(provider.select(...))` in `FormBuilderTopBar` to minimize rebuilds. [x]
    * Refactored `FormBuilderPage` to use the new widget. [x]

## Phase 2: Repository Refactoring [COMPLETED]

**Goal**: Clean up `FormBuilderRepositoryImpl` by separating data mapping logic.

1. **Create Mapper**: Created `frontend/lib/features/form_builder/data/mappers/form_mapper.dart`. [x]
2. **Move Logic**: Moved parsing and AI mapping logic to `FormMapper`. [x]
3. **Update Repository**: Refactored `FormBuilderRepositoryImpl` to use `FormMapper`. [x]

## Phase 3: Network Security & Stability [COMPLETED]

**Goal**: Prevent race conditions during token refresh.

1. **Update AuthInterceptor**: added locking mechanism with `Completer` to `frontend/lib/core/network/auth_interceptor.dart`. [x]

## Phase 4: Type Safety & Data Layer Refactoring [COMPLETED]

**Goal**: Improve Type Safety in `ApiService`.

1. **Create DTOs**: Created `FormDto` and `FormVersionDto` in `frontend/lib/features/form_builder/data/dto/form_dto.dart`. [x]
2. **Robust Data Parsing**: Added default values and custom date parsing to `FormDto` to prevent crashes. [x]
3. **Update ApiService**: Updated `getForm`, `createForm`, `updateForm`, `listForms` to return `FormDto`. [x]
4. **Update Repository**: Refactored `FormBuilderRepositoryImpl` to use `FormDto` and `FormMapper.fromDto`. [x]

---
**Status**: All critical Form Builder type safety tasks completed.

## Phase 5: Error Handling & UI Stability [IN PROGRESS]

**Goal**: Standardize error reporting and resolve technical debt in UI widgets.

1. **Expand Exception Hierarchy**: Add `NetworkException` and `AuthException` to `app_exception.dart`. [ ]
2. **Resolve Analysis Warnings**: Fix deprecated `value` usages and `prefer_single_quotes` issues (16 issues remaining). [ ]
3. **UI Test Stabilization**: Resolve size/visibility issues in `form_builder_page_test.dart`. [ ]
4. **Global Error Mapping**: Update `ErrorHandler` to map `AppException` to user-friendly messages. [ ]
