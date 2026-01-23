# Backend LLM Integration Documentation

This document outlines the requirements and implementation plan for the Backend service to support the AI Form Builder functionality.

## Overview

The AI Assistant allows users to generate complex form structures (sections, questions, options, and logic) from a natural language prompt. The backend must securely interface with an LLM provider and return a structured JSON response that the frontend can immediately apply to the builder canvas.

---

## Milestone 1: Core LLM Infrastructure

**Goal**: Establish a secure connection to an external LLM provider.

### Core Steps

1. **Environment Configuration**:
   * Implement support for `LLM_API_KEY`, `LLM_API_URL`, and `LLM_MODEL`.
   * Support standard OpenAI-compatible chat completion endpoints (e.g., Mistral, Groq, Ollama).

2. **API Endpoint Creation**:
   * Expose a POST endpoint: `/api/ai/generate`.
   * Secure the endpoint with standard JWT authentication (matching the rest of the backend).

3. **Prompt Engineering**:
   * Implement a **System Prompt** that defines:
     * The exact JSON schema required (Sections and Questions).
     * The restricted list of supported `FieldType` values (`short_text`, `paragraph`, `number`, `date`, `dropdown`, `checkboxes`, `radio`, `file_upload`, `email`, `mobile`, `url`).
     * Formatting rules (no Markdown blocks, pure JSON output).

### Expected Results

* Backend can receive a string prompt and return a valid JSON object.
* API Keys are stored securely in backend environment variables.

---

## Milestone 2: Schema Processing & Verification

**Goal**: Ensure the LLM output is production-ready and database-compatible.

### Processing Steps

1. **JSON Sanitization**:
   * The backend must parse the LLM's string output into a typed object.
   * Handle cases where the LLM might wrap the JSON in markdown code blocks (` ```json ... ``` `).

2. **ID & Index Normalization**:
   * Iterate through generated sections and questions.
   * Replace any LLM-provided placeholders with valid **UUID v4** strings.
   * Ensure `order_index` is sequential and starts from 0 for all lists.

3. **Field Validation**:
   * Verify that `field_type` values match the allowed enum.
   * Ensure that question options have both `option_label` and `option_value`.

### Resulting Output

* The API returns a fully validated `IForm` structure (specifically `sections` and `questions`) that exactly matches the frontend's TypeScript interfaces.

---

## Milestone 3: Advanced Features & Logic

**Goal**: Support complex form behaviors like conditional logic.

### Advancement Steps

1. **Logic Generation Support**:
   * Instruct the LLM to generate `visibility_rules` if the prompt implies dependency (e.g., "Show field X if Y is Yes").

2. **Context Injection**:
   * Optionally allow the frontend to send "current form state" so the AI can *suggest* additions rather than just generating a new form from scratch.

### Future Results

* AI can generate forms with basic "Show/Hide" logic already configured.

---

## API Contract (Specification)

### Request: `POST /api/ai/generate`

**Headers**: `Authorization: Bearer <token>`
**Body**:

```json
{
  "prompt": "Create a job application form with experience and contact info"
}
```

### Response: `200 OK`

**Body**:

```json
{
  "sections": [
    {
      "id": "uuid-1",
      "title": "Contact Information",
      "order_index": 0,
      "questions": [
        {
          "id": "uuid-2",
          "question_text": "Full Name",
          "field_type": "short_text",
          "is_required": true,
          "order_index": 0
        }
      ]
    }
  ]
}
```

---

## Checklist for Backend Team

* Implement secure REST endpoint `/api/ai/generate`.
* Configure `axios` or equivalent for external LLM calls.
* Port the `SYSTEM_PROMPT` from the frontend proxy to the backend.
* Add post-processing logic for UUID generation and index sorting.
* Implement error handling for "Provider Down" or "Rate Limit Exceeded" scenarios.
