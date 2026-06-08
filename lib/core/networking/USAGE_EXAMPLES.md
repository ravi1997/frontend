# Networking Usage Notes

This app now keeps auth on direct `Dio` calls through `AuthService` and `AuthController`.

Use:
- `authControllerProvider` for login, OTP, register, logout, refresh, password reset, and revoke-all flows.
- feature repositories such as `formBuilderRepositoryProvider`, `workflowRepositoryProvider`, and `responseRepositoryProvider` for non-auth API features.
- `dioProvider` when a lower-level transport is required by a repository.
