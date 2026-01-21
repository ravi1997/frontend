# Reproduction Report: ISSUE-0011 Workflow Automation

## Issue Description

Ideally, users should be able to configure actions (like sending emails or Slack notifications) that trigger when a form response is submitted.
Currently, there is no UI or data structure to support this.

## Gap Analysis

1. **Data Model**: `src/types/index.ts` lacks `IWorkflow` or similar structures.
2. **State Management**: `src/store/builderStore.ts` does not track workflows.
3. **UI**: `src/app/builder/new/page.tsx` has no entry point for workflow configuration.

## Reproduction Steps

1. Open Form Builder (`/builder/new`).
2. Observe only "Preview", "Save", "Publish" buttons.
3. Observe Sidebar (Fields), Canvas, and Properties.
4. **Conclusion**: Feature is missing.
