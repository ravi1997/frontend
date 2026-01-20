# Coverage Report - 2026-01-20

## Manual Coverage Assessment

Due to missing environment support for `@vitest/coverage-v8`, the following is a physical assessment of the test coverage for core files.

| File | Functions Tested | Coverage (Est.) | Missing Tests |
| --- | --- | --- | --- |
| `src/hooks/useAuth.ts` | 0/4 | 0% | login, logout, register, getSession |
| `src/hooks/useForm.ts` | 0/3 | 0% | createForm, createVersion, saveNewForm |
| `src/hooks/useForms.ts` | 0/1 | 0% | fetchForms |

## Technical Blockers

- **Dependency**: `@vitest/coverage-v8` is not present in `package.json`.
- **Environment**: Node.js 18.x is used, but Next.js 16/19 dependencies prefer 20.x+.

## Future Coverage Targets

1. **Critical Path**: 100% on all `src/hooks/`.
2. **Components**: 80% on interactive builder components.
3. **API**: 100% mocking coverage for all `AXIOS` interactions.
