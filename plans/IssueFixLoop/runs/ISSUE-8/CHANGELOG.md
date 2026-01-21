# CHANGELOG: Issue #8 - AI Form Generation Assistant

## Added

- **src/components/form-builder/ai/AIAssistant.tsx**: Chat interface for generating forms from natural language.
- **src/lib/aiService.ts**: Mock service simulating AI processing and generating `ISection` structures.
- **src/lib/constants.ts**: Added `API_ENDPOINTS.AI` namespace.

## Changed

- **src/components/form-builder/BuilderSidebar.tsx**: Integrated `AIAssistant` button into the field library sidebar.
- **src/store/builderStore.ts**: Added `setSections` action to support bulk update of form structure.

## Dependencies

- **uuid**: Used in `aiService` for generating IDs.
