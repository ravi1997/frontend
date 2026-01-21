# Prompt Routing Hints

## TypeScript Build Errors

**Signature:**
- `Object literal may only specify known properties`
- `does not exist in type`
- `Type error: ...`

**Rule:**
IF signature matches:
-> **Entrypoint**: `agent/01_entrypoints/run_implement_only.md`
-> **Profile**: `agent/03_profiles/profile_implementer.md`
-> **Hint**: "Check interface definitions vs call sites. Prioritize updating the type if the feature code looks correct."
