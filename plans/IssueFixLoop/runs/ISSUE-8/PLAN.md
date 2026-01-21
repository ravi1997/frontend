# PLAN: AI Form Generation Assistant

## Objective

Implement a chat interface that allows users to generate form structures using natural language.

## Tasks

1. [ ] **API Configuration**: Add `API_ENDPOINTS.AI.GENERATE` to constants.
2. [ ] **AI Assistant Component**: Create `src/components/form-builder/ai/AIAssistant.tsx`.
    - Chat UI (User message, AI loading, AI response).
    - "Apply" button to merge generated schema into the builder.
3. [ ] **Schema Parser**: Utility to validate and sanitize AI output before applying to store.
4. [ ] **Integration**: Add button in `BuilderSidebar` to toggle AI Assistant.
5. [ ] **Mock Service**: Since backend might not be ready, mock the API call with a predefined delay and response for testing.

## Strategy

- Use a Sidebar or Floating Sheet for the Assistant.
- The AI response is expected to be a JSON object matching `ISection[]`.
- We will mock the backend call for now to demonstrate UI and State Logic.
