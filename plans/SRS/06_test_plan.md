# 06. Test Plan

## 1. Testing Strategy
We will follow the testing pyramid for Flutter apps.

### Unit Tests
- **Scope**: Business logic in Use Cases, Domain Entities, and Repository implementations (using mocks).
- **Tool**: `flutter_test`.

### Widget Tests
- **Scope**: Individual UI components and small screen fragments.
- **Goal**: Ensure widgets render correctly and respond to user interactions (taps, scrolls).
- **Tool**: `flutter_test`.

### Integration Tests
- **Scope**: End-to-end flows like "Complete form creation" or "Login flow".
- **Goal**: Verify that all layers work together correctly on a real device/emulator.
- **Tool**: `integration_test` (standard Flutter package) or `patrol`.

## 2. CI/CD Integration
- **GitHub Actions**:
    - Run `flutter analyze` on every PR.
    - Run all unit and widget tests.
    - Fail build if coverage drops below 80%.

## 3. Manual QA
- Cross-device testing (iPhone 13, Samsung S22, Pixel 6).
- Offline mode verification (toggling airplane mode DURING form submission).
