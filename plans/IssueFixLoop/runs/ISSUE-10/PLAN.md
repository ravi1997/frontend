# PLAN: Zero Logic Coverage for Core Hooks

## Objective

Implement comprehensive unit tests for `useAuth`, `useForm`, and `useForms` hooks, achieving at least 80% coverage on functional logic.

## Strategy

1. **Utility Setup**: Create a `renderWithProviders` helper to wrap hooks in `QueryClientProvider`.
2. **Implement `useAuth` Tests**:
   - Mock `api.post` and `api.get`.
   - Test `login` success/failure.
   - Test `register` and `logout`.
   - Test `user-status` fetch on mount.
3. **Implement `useForm` Tests**:
   - Mock form creation and versioning endpoints.
   - Test `saveForm` logic.
4. **Implement `useForms` Tests**:
   - Mock form listing and deletion.
5. **Coverage Verification**: Run tests with coverage flag.

## Tasks

1. [ ] Setup test utilities and mocks.
2. [ ] Enhance `useAuth.test.ts`.
3. [ ] Create `useForm.test.ts`.
4. [ ] Create `useForms.test.ts`.
5. [ ] Verify coverage.

## Risks

- **Mocking TanStack Query**: Mutations require careful handling of `onSuccess` callbacks.
- **Node/JSDOM Environment**: LocalStorage and Cookies must be mocked accurately.
