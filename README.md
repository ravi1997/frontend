# RIDP Form Platform Frontend

Flutter web/mobile client for the RIDP multi-tenant form platform.

## Local Development

```bash
flutter pub get
flutter analyze
flutter test
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8051
```

The API base URL is the backend origin only. The client appends
`/form/api/v1` internally.

## Contract Workflow

Backend exports the API contract from
`/home/ravi/workspace/docker/apps/form-backend`:

```bash
make openapi
make generate-dart-client
```

Generated transport clients must remain isolated under `lib/generated/api`.
Existing Freezed/domain models may wrap generated transport DTOs for UI state.

## Quality Gates

Required before merge:

- `flutter analyze`
- `flutter test --coverage`
- `flutter build web --release --no-tree-shake-icons`
- API contract tests in `test/unit/api_contract_test.dart`
- Accessibility tests in `test/accessibility_audit_test.dart`

## Production Configuration

Set build-time values with Dart defines:

- `API_BASE_URL`: backend origin, for example `https://api.example.com`
- `FRONTEND_ORIGIN`: deployed frontend origin
- `USE_COOKIE_CREDENTIALS`: default `false`; bearer JWT is canonical
