---
# ISSUE-0001: Upgrade Node.js Environment to 20.x+

## Context / Problem

The current environment is running Node.js **18.19.1**. However, the project's dependencies (Next.js 16/19) and the specific version of `next lint` require Node.js **>=20.9.0**. This mismatch is currently blocking the execution of the CI/CD linting phase.

## Current Evidence

- `plans/Issues/ISSUE_001_node_upgrade.md`: Explicitly identified during audit.
- `plans/SRS/11_acceptance_criteria.md`: Requirement for lint-clean code is blocked.
- `plans/Tests/LATEST_RESULTS.md`: Warns about Node version mismatch.

## Proposed Fix / Tasks

- Upgrade Node.js version to at least 20.9.0 (LTS preferred).
- Verify `npm run lint` executes without environment errors.
- Update `package.json` engines field if necessary.

## Acceptance Criteria

- [ ] Environment reports `node --version` >= 20.9.0.
- [ ] `npm run lint` completes without environment error.

## Risks / Notes

- Node version is often controlled by the hosting environment or a tool like `nvm`.

## References

- `plans/Issues/ISSUE_001_node_upgrade.md`
- `plans/Tests/LATEST_RESULTS.md`

## Metadata

- **labels**: type:devops, priority:P1, status:Blocked, component:infra
- **milestone**: M1 - Core Stabilization & Advanced Builder
- **status**: Blocked
- **status_reason**: Blocked by host environment node version (currently 18.x).
---
# ISSUE-0002: Missing Vitest Coverage Dependency

## Context / Problem

Total project coverage is currently unmeasurable because the required coverage provider `@vitest/coverage-v8` is missing from the development dependencies.

## Current Evidence

- `plans/Issues/ISSUE_002_vitest_coverage.md`: Identified during testing workflow.
- `plans/Tests/COVERAGE_REPORT.md`: States "Missing tool" for automated reporting.

## Proposed Fix / Tasks

- Install `@vitest/coverage-v8` as a devDependency.
- Configure `vitest.config.mts` to use `v8` as the coverage provider.
- Verify `npm run test:unit -- --coverage` generates a report in `coverage/`.

## Acceptance Criteria

- [ ] `@vitest/coverage-v8` present in `package.json`.
- [ ] `coverage/` directory generated with valid HTML report.

## Risks / Notes

- No significant risks; simple dependency addition.

## References

- `plans/Issues/ISSUE_002_vitest_coverage.md`
- `plans/Tests/COVERAGE_REPORT.md`

## Metadata

- **labels**: type:test, priority:P2, status:Backlog, component:infra
- **milestone**: M1 - Core Stabilization & Advanced Builder
- **status**: Backlog
- **status_reason**: Identified as missing during test audit; hasn't been started.
---
# ISSUE-0003: Zero Logic Coverage for Core Hooks

## Context / Problem

The core business logic of the application resides in custom React hooks (`useAuth`, `useForm`, `useForms`), but they currently have **0% functional test coverage**. The existing tests only verify that the hooks are functions.

## Current Evidence

- `plans/Issues/ISSUE_003_hook_test_coverage.md`: Highlighted critical gap.
- `plans/Tests/COVERAGE_REPORT.md`: Estimated 0% coverage on functional logic.

## Proposed Fix / Tasks

- Implement unit tests for `useAuth`: login, register, and session management logic.
- Implement unit tests for `useForm`: createForm, createVersion, and composite save logic.
- Mock all `AXIOS` API calls using `vitest` mocks.
- Achieve >= 80% line coverage for each hook.

## Acceptance Criteria

- [ ] Hooks have passing tests for all happy and unhappy paths.
- [ ] Minimum 80% coverage per hook as reported by Vitest.

## Risks / Notes

- Requires complex mocking of TanStack Query and Axios.

## References

- `plans/Issues/ISSUE_003_hook_test_coverage.md`
- `plans/Tests/COVERAGE_REPORT.md`

## Metadata

- **labels**: type:test, priority:P1, status:Backlog, component:frontend
- **milestone**: M1 - Core Stabilization & Advanced Builder
- **status**: Backlog
- **status_reason**: Identified as high priority debt; implementation not started.
---
# ISSUE-0004: Resolve Documentation Linting Violations

## Context / Problem

Multiple markdown files are violating project style rules, primarily regarding heading hierarchy and table formatting. These were identified during the manual and automated audit phases.

## Current Evidence

- `plans/Issues/ISSUE_004_markdown_linting.md`: Detailed list of violations.
- `plans/Tests/LATEST_RESULTS.md`: Notes duplicate headings in MILESTONE_PLAN.md.

## Proposed Fix / Tasks

- Rename duplicate headings in `MILESTONE_PLAN.md` to be unique.
- Align table pipes in `TEST_STATE.md`.
- Convert emphasized text to proper `###` headings in PR documentation.
- Verify using a local markdown linter.

## Acceptance Criteria

- [ ] No duplicate headings reported in `MILESTONE_PLAN.md`.
- [ ] Tables in `TEST_STATE.md` pass `MD060`.

## Risks / Notes

- Low impact on code, but affects overall repository hygiene.

## References

- `plans/Issues/ISSUE_004_markdown_linting.md`

## Metadata

- **labels**: type:docs, priority:P3, status:Backlog, component:docs
- **milestone**: M1 - Core Stabilization & Advanced Builder
- **status**: Backlog
- **status_reason**: Identified during documentation audit; deferred to low priority.
---
# ISSUE-0005: Implement Edge Case Validations in Form Builder

## Context / Problem

The form builder currently lacks frontend-level validation for several identified edge cases, which could lead to API errors or data corruption.

## Current Evidence

- `plans/Issues/ISSUE_005_edge_case_implementation.md`: Technical gap description.
- `plans/Tests/EDGE_CASES.md`: Discovery of "Evil" inputs.

## Proposed Fix / Tasks

- [ ] **Empty Sections**: Prevent saving versions with zero fields.
- [ ] **Slug Validation**: Add regex to the slug field to prevent invalid URL characters.
- [ ] **Sanitization**: Implement `DOMPurify` on form titles and descriptions to prevent XSS-based "Evil Inputs".
- [ ] **Duplicate Fields**: Prevent adding the same field ID multiple times in a single section.

## Acceptance Criteria

- [ ] UI shows validation errors for empty forms.
- [ ] Input fields sanitize XSS strings.

## Risks / Notes

- Sanitization might interfere with legitimate text if too aggressive.

## References

- `plans/Issues/ISSUE_005_edge_case_implementation.md`
- `plans/Tests/EDGE_CASES.md`

## Metadata

- **labels**: type:bug, priority:P2, status:Backlog, component:frontend
- **milestone**: M1 - Core Stabilization & Advanced Builder
- **status**: Backlog
- **status_reason**: Identified as a security/UX improvement during the audit.
---
# ISSUE-0006: Implementation of Conditional Logic Engine

## Context / Problem

Users need to define rules for showing or hiding fields based on respondent answers. Currently, this capability is missing from the form builder.

## Current Evidence

- `plans/SRS/functional_reqs.md`: FR-13 marked as Missing.
- `plans/Milestones/MILESTONE_PLAN.md`: M1-T3 task identified.

## Proposed Fix / Tasks

- Develop the UI for building logic expressions.
- Update the form builder engine to evaluate logic during preview/submission.
- Save logic rules into the `ISection`/`IField` schema.

## Acceptance Criteria

- [ ] Creator can set a "Show if Field X equals Y" rule.
- [ ] Form preview accurately hides/shows fields in real-time.

## Risks / Notes

- Circular dependencies in logic could crash the UI.

## References

- `plans/SRS/functional_reqs.md`
- `plans/Milestones/MILESTONE_PLAN.md`

## Metadata

- **labels**: type:feature, priority:P1, status:Planned, component:frontend
- **milestone**: M1 - Core Stabilization & Advanced Builder
- **status**: Planned
- **status_reason**: Included in Milestone 1 roadmap.
---
# ISSUE-0007: Implementation of Response Data Export

## Context / Problem

Administrators need to export collected form responses for external analysis. While buttons exist in the UI, they are not integrated with the backend.

## Current Evidence

- `plans/SRS/functional_reqs.md`: FR-15 marked as Missing.
- `plans/Milestones/MILESTONE_PLAN.md`: M2-T2 task identified.

## Proposed Fix / Tasks

- Integrate "Export" buttons with `API_ENDPOINTS.FORMS.EXPORT_CSV` and `EXPORT_JSON`.
- Handle file download streams in the frontend.

## Acceptance Criteria

- [ ] Clicking "Export CSV" downloads a valid file containing responses.

## Risks / Notes

- Large datasets might require asynchronous generation with notification.

## References

- `plans/SRS/functional_reqs.md`
- `plans/Milestones/MILESTONE_PLAN.md`

## Metadata

- **labels**: type:feature, priority:P1, status:Planned, component:frontend
- **milestone**: M2 - Data Management & Orchestration
- **status**: Planned
- **status_reason**: Scheduled for Milestone 2.
---
# ISSUE-0008: AI Form Generation Assistant

## Context / Problem

To accelerate form creation, an AI assistant is required to generate form fields from natural language descriptions.

## Current Evidence

- `plans/SRS/functional_reqs.md`: FR-17 marked as Missing.
- `plans/Milestones/MILESTONE_PLAN.md`: M3-T1 task identified.

## Proposed Fix / Tasks

- Create a chat-based interface for prompting the AI.
- Map AI output (JSON) to the internal Form schema.
- Implement an API service to interact with the LLM backend.

## Acceptance Criteria

- [ ] User can type "Create a feedback form for a cafe" and see fields generated.

## Risks / Notes

- Dependence on LLM reliability and latency.

## References

- `plans/SRS/functional_reqs.md`
- `plans/Milestones/MILESTONE_PLAN.md`

## Metadata

- **labels**: type:feature, priority:P2, status:Planned, component:frontend
- **milestone**: M3 - Intelligence & Reach
- **status**: Planned
- **status_reason**: Scheduled for Milestone 3.
---
# ISSUE-0009: PWA Support

## Context / Problem

 respondents need to access forms in environments with poor connectivity. PWA support will provide offline capabilities and an installable app experience.

## Current Evidence

- `plans/SRS/functional_reqs.md`: FR-19 marked as Missing.
- `plans/Milestones/MILESTONE_PLAN.md`: M3-T2 task identified.

## Proposed Fix / Tasks

- Add `manifest.json` with icons and splash screen.
- Implement a Service Worker for caching core assets.
- Support offline data collection for form respondents.

## Acceptance Criteria

- [ ] Application shows "Add to Home Screen" prompt on supported browsers.
- [ ] Forms can be navigated while offline.

## Risks / Notes

- Storage limits for offline data.

## References

- `plans/SRS/functional_reqs.md`

## Metadata

- **labels**: type:feature, priority:P2, status:Planned, component:frontend
- **milestone**: M3 - Intelligence & Reach
- **status**: Planned
- **status_reason**: Scheduled for Milestone 3.
---
# ISSUE-0010: Form Versioning UI Management

## Context / Problem

While the backend types support versioning, the frontend lacks the UI to switch between or manage multiple versions of a single form.

## Current Evidence

- `plans/SRS/functional_reqs.md`: FR-12 marked as Missing/Partial.
- `plans/Milestones/MILESTONE_PLAN.md`: M1-T2 task identified.

## Proposed Fix / Tasks

- Implement the Version History panel in the form builder.
- Add "Rollback" and "Save as New Version" actions.

## Acceptance Criteria

- [ ] User can view a list of previous versions.
- [ ] User can switch the active version of a form.

## Risks / Notes

- Schema migration if versions are incompatible.

## References

- `plans/SRS/functional_reqs.md`

## Metadata

- **labels**: type:feature, priority:P2, status:Planned, component:frontend
- **milestone**: M1 - Core Stabilization & Advanced Builder
- **status**: Planned
- **status_reason**: Scheduled for Milestone 1.
---
# ISSUE-0011: Workflow Automation (MVP)

## Context / Problem

Forms need to trigger external actions (like notifications) upon submission. Currently, there is no system to define or execute these workflows.

## Current Evidence

- `plans/SRS/functional_reqs.md`: FR-18 marked as Missing.
- `plans/Milestones/MILESTONE_PLAN.md`: M2-T3 task identified.

## Proposed Fix / Tasks

- Integrate a basic workflow engine.
- Support Slack/Email notifications on form submission.

## Acceptance Criteria

- [ ] User receives an email/Slack message when a response is submitted.

## Risks / Notes

- Requires backend integration and possibly third-party API keys.

## References

- `plans/SRS/functional_reqs.md`

## Metadata

- **labels**: type:feature, priority:P2, status:Planned, component:frontend
- **milestone**: M2 - Data Management & Orchestration
- **status**: Planned
- **status_reason**: Scheduled for Milestone 2.
---
# ISSUE-0012: Docker Non-Root User Execution

## Context / Problem

Current Docker configuration defaults to running as root inside the container, which is a security risk in production environments.

## Current Evidence

- `plans/Architecture/BASELINE_REPORT.md`: "Missing non-root user in execution".

## Proposed Fix / Tasks

- Modify `Dockerfile` to create a `node` or `app` user.
- Change ownership of code directory to the non-root user.
- Update `USER` instruction in `Dockerfile`.

## Acceptance Criteria

- [ ] Running `id` inside the container returns a non-zero UID.

## Risks / Notes

- Potential permission issues with bound volumes.

## References

- `plans/Architecture/BASELINE_REPORT.md`

## Metadata

- **labels**: type:security, priority:P2, status:Backlog, component:infra
- **milestone**: M1 - Core Stabilization & Advanced Builder
- **status**: Backlog
- **status_reason**: Identified as security debt; not yet scheduled.
---
# ISSUE-0013: Setup GitHub Actions CI/CD Pipeline

## Context / Problem

The project lacks automated testing and deployment pipelines. All checks must currently be run manually.

## Current Evidence

- `plans/Architecture/BASELINE_REPORT.md`: "Missing. No .github/workflows found."

## Proposed Fix / Tasks

- Create `.github/workflows/ci.yml`.
- Add steps for: Linting, Unit Testing, and Docker Build validation.

## Acceptance Criteria

- [ ] Pushing to `main` triggers a GitHub Action.
- [ ] Pipeline results are visible in GitHub UI.

## Risks / Notes

- None.

## References

- `plans/Architecture/BASELINE_REPORT.md`

## Metadata

- **labels**: type:devops, priority:P1, status:Backlog, component:infra
- **milestone**: M1 - Core Stabilization & Advanced Builder
- **status**: Backlog
- **status_reason**: Identified as a critical infrastructure gap.
---
# ISSUE-0014: Core Hook Refactor & PR Remediation

## Context / Problem

Core hooks (`useAuth`, `useForm`) required refactoring for architectural consistency (absolute imports) and centralized API endpoint management.

## Current Evidence

- `plans/Release/PULL_REQUESTS/PR_CORE_REFACTOR.md`: Successfully merged refactor.
- `plans/Release/REVIEWS/PR_LOCAL_CHANGES_REVIEW.md`: Original feedback requesting changes.

## Proposed Fix / Tasks

- Revert relative imports to `@/` aliases.
- Centralize API endpoints in `lib/constants.ts`.
- Refine TypeScript types for payload objects.

## Acceptance Criteria

- [ ] PR merged to `main`.
- [ ] Logic stays functional after refactor.

## Risks / Notes

- Completed.

## References

- `plans/Release/PULL_REQUESTS/PR_CORE_REFACTOR.md`

## Metadata

- **labels**: type:feature, priority:P1, status:Done, component:frontend
- **milestone**: M1 - Core Stabilization & Advanced Builder
- **status**: Done
- **status_reason**: Merged to main on 2026-01-20.
