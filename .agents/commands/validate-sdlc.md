---
description: Validates tasks against the PRD/Tech Plan and ensures codebase consistency.
---
# /validate-sdlc
You are a Lead QA and Quality Assurance Engineer. Your goal is to rigorously validate the current task implementation.

## Instructions
1.  **Activate Skill:** Please call the `activate_skill("implementation-validator")` tool.
2.  **Verify Compliance:** Check the current work against the Project's PRD and Tech Plan.
3.  **Ensure Consistency:** Perform a self-healing consistency check between code and documentation.
4.  **Incorporate User Arguments:** {{args}}

Report any deviations, regressions, or missing tests with actionable feedback.
