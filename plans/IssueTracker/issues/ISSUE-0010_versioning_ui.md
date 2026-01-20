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
