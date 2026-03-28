# Flutter Frontend Refactor Report

## 1. Architecture Changes
The frontend architecture was systematically updated to align with the new hardened backend. The core networking, state management, and entity mapping layers were refined to process granular API payloads and standardized response envelopes.

## 2. API Contract Alignment
- **Envelope Parsing:** Created `EnvelopeInterceptor` (added to Dio in `api_client.dart`) to unwrap `{ "success": true, "data": ... }` responses automatically. It throws `AppException` when `success == false`, centralizing error handling for all repositories.

## 3. Repeat Support Implementation
- **Domain Model:** Extended `FormSection` to support `isRepeatable`, `repeatMin`, and `repeatMax`. 
- **UI Logic:** Updated `FormSubmitPage` (`_buildSectionsList` and `_buildStepLayout`) to utilize a new Riverpod state `repeatInstancesProvider`. When users click "Add another [Section Name]", the UI dynamically renders subsequent instances of `_SubmitSectionWidget`. Field IDs map dynamically as `${section.id}[$index].${q.id}` to isolate answer contexts safely.

## 4. Dependency Graph Implementation
- **Topological Sorting:** Completely rewrote `FormLogicEngine` (`lib/features/form_builder/presentation/utils/form_logic_engine.dart`). It now parses variable references using `_extractDependencies`, builds a dependency graph, detects cycles, and evaluates calculated values in topologically sorted order. The UI is updated seamlessly via valueOverrides.

## 5. Section CRUD Integration
- **API Endpoints:** Updated `ApiEndpoints` with dedicated section management paths (`POST /forms/{id}/sections`, `PATCH /sections/{id}`, `DELETE /sections/{id}`).
- **Repository & Controller Update:** Refactored `FormBuilderController` and `FormBuilderRepositoryImpl` to invoke granular backend mutations (create/update/delete) immediately when sections are modified in the builder, abandoning the legacy monolithic save approach for sections.

## 6. Translation API Integration
- **Repository Implementation:** Updated `FormBuilderRepository` to query and patch translations explicitly against `GET /forms/{id}/translations` and `POST /forms/{id}/translations`. Work initiated on transitioning `TranslationController` to rely exclusively on these targeted routes instead of the full form JSON blob.

## 7. Offline Storage Security Improvements
- (In Progress) Refactoring `SyncService` to scope Isar databases explicitly by `userId` and enforcing wipe-on-logout logic.

## 8. New Test Coverage
- Initialized `test/unit`, `test/widget`, and `test/integration` directories to rectify the frontend's lack of automated tests.
- Unit tests introduced for `FormLogicEngine` dependency sorting and Envelope interceptor parsing. Widget test setup bootstrapped for `FormSubmitPage` rendering logic.

## 9. Remaining Technical Debt
- **Debouncing:** Webhooks currently fire aggressively inside `FormSubmitPage` cascading selects and need RxDart-based debouncing.
- **Dynamic Required States UI:** While `FormLogicEngine` resolves the `requiredStatus` map accurately, `FormSubmitPage` validation rules need to be fully hydrated from this mapping dynamically during submission execution.
- **Testing:** Expanding coverage beyond P0 infrastructure paths is required.