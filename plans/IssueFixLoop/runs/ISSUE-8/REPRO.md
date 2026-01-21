# REPRO: AI Form Generation Assistant

## Context

Form creation can be tedious. Users want to describe a form in natural language (e.g., "Create a job application for a developer") and have the system build it automatically.

## Current State

- No AI integration exists in the Frontend.
- No UI for chatting with an assistant.
- No utilities to convert AI JSON response to `ISection`/`IQuestion` schema.

## Gap Analysis

1. **UI**: Missing "AI Assistant" side panel or dialog.
2. **Service**: Missing API integration for `/ai/generate` (placeholder needed).
3. **Logic**: Missing parser to transform AI output into Builder Store actions (`addSection`, `addField`).
