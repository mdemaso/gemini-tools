---
name: test-generator
description: "Automatically generates test suites (unit/integration) based on the PRD and Tech Plan to provide a source of truth for validation."
---

# Test Generator Skill

This skill ensures that the implementation has a corresponding test suite to verify behavioral correctness.

## Workflow

1.  **Analyze Context**:
    *   Read `PRD.md` and `TECH_PLAN.md`.
    *   Identify the target component or feature to be tested.

2.  **Generate Test Strategy**:
    *   Determine the appropriate testing framework (e.g., Jest, Pytest, Go Test) based on the codebase.
    *   Define the test cases (happy path, edge cases, error conditions) derived from the requirements.

3.  **Execute Creation**:
    *   Create a test file following the project's naming convention (e.g., `src/__tests__/auth.test.ts`).
    *   Write the test code using boilerplate for mock dependencies.
    *   **Goal**: The test should *initially fail* (TDD style) until the implementation agent completes the work.

4.  **Confirm**: Notify the user and the orchestrator that the test suite is ready.
