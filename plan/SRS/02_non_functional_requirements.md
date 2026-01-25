# 02. Non-Functional Requirements

## 1. Usability
- **NFR-USE-01**: The UI must adhere to Material Design (Android) and Cupertino (iOS) standards where appropriate, while maintaining a unique brand identity.
- **NFR-USE-02**: App should be accessible (Screen reader support, Dynamic font sizes).

## 2. Reliability
- **NFR-REL-01**: The app must handle network failures gracefully without losing user data during form filling.
- **NFR-REL-02**: Data persistence should use a reliable local database (e.g., Hive or Drift).

## 3. Performance
- **NFR-PERF-01**: Initial app load time should be under 2 seconds on modern devices.
- **NFR-PERF-02**: UI should maintain a consistent 60 FPS (or 120 FPS on supported screens).
- **NFR-PERF-03**: Memory usage should be optimized to prevent crashes on low-end devices.

## 4. Security
- **NFR-SEC-01**: Sensitive data must be encrypted in storage (Secure Storage for tokens).
- **NFR-SEC-02**: API communication must strictly use HTTPS.
- **NFR-SEC-03**: Implement SSL Pinning to prevent Man-in-the-Middle attacks.

## 5. Portability
- **NFR-PORT-01**: The codebase should be 90%+ shared across iOS, Android, and Web platforms.
