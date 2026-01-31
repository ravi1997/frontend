# Feature Specification: Form Versioning

## 1. Context & Goal

- **Task ID**: M-12 (Calculated next based on Audit)
- **Parent Requirement**: FR-FORM-02 (Form Versioning)
- **Objective**: Implement a robust mechanism to capture snapshots of form structures, allowing creators to track changes and maintain data integrity across different published states.

## 2. Technical Design

- **New Files**:
  - `lib/features/form_builder/domain/entities/form_version.dart`: Entity to represent a snapshot.
- **Modified files**:
  - `lib/features/form_builder/domain/entities/builder_form.dart`: Add versioning fields.
  - `lib/features/form_builder/domain/repositories/form_builder_repository.dart`: Add version-related fetching.
  - `lib/features/form_builder/data/repositories/mock_form_builder_repository.dart`: Update mock implementations.
- **Dependencies**: freezed, riverpod

## 3. Data Model Changes

- **Schema Updates**:
  - `BuilderForm`: Add `String currentVersion` and `List<FormVersion> history`.
  - `FormVersion`: Contains `id`, `versionNumber`, `snapshot` (The full BuilderForm state at that time), and `createdAt`.

## 4. API Contracts (Mocked)

- **Fetch Version History**: `GET /form/<id>/versions`
- **Create Version**: `POST /form/<id>/versions` (Triggered on Publish)
- **Fetch Specific Version**: `GET /form/<id>/versions/<v>`

## 5. Acceptance Criteria

- [ ] Users can see the current version of the form in the builder UI.
- [ ] Every time a "Publish" action occurs, a new version snapshot is created.
- [ ] Users can retrieve the configuration of a previous version.
- [ ] Version numbers increment automatically (e.g., 1.0 -> 1.1 or 2.0).

## 6. Testing Strategy

- **Test Spec**: `agent/07_templates/feature/TEST_SPEC.md`
- **Unit Tests**:
  - `test/features/form_builder/domain/entities/form_version_test.dart`
  - `test/features/form_builder/presentation/controllers/versioning_test.dart`

## 7. Rollback Plan

- Revert entity changes and remove versioning specific controllers.
