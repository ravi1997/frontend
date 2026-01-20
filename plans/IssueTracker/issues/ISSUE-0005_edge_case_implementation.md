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
