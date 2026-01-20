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
