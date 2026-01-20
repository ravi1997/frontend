# Project Questions & Unknowns

## Business Rules

- What are the specific user roles (beyond code-level enums) and their permissions?
- Is there a specific approval workflow for forms? The code mentions `approval_steps`.
- What are the "employee" and "general" user types exactly?

## Technical Unknowns

- Where is the backend source code? The frontend expects it at `http://127.0.0.1:5000/form/api/v1`.
- Why are there no tests in the `src` directory despite `vitest` and `playwright` being configured?
- Is there a CI/CD pipeline currently in use (none found in `.github`)?

## Process Assumptions

- Assumption: The project is in early MVP stage given the lack of tests and CI/CD.
- Assumption: The external API is a Python/Flask or similar service (judging by the port 5000).
