---
name: implementation-validator
description: "Validates tasks against the PRD/Tech Plan and performs a self-healing consistency check between code and documentation."
---

# Implementation Validator Skill

This skill ensures that all code changes are traceably correct and consistent with the project's requirements and architecture.

## Workflow

1.  **Locate Project Context**:
    *   Identify the target project directory: `projects/{domain}/{project_id}/`.
    *   Read the `artifact-map.md` for traceability rules.
2.  **Verify Traceability**:
    *   Ensure every Work Item (`W-*`) is linked to a Technical Decision (`D-*`) or Requirement (`R-*`).
    *   Ensure every code change is linked to a Work Item.
    *   Ensure every Work Item has a corresponding Verification Item (`V-*`).
3.  **Validate Execution**:
    *   Run tests and scripts defined in `verifications/V-*.md`.
    *   Compare actual output with the "Expected Results" defined in the artifact.
4.  **Consistency Check**:
    *   Verify that the implementation follows the architectural patterns defined in `systems-architecture.md` and `tech-decisions/D-*.md`.
5.  **Self-Healing**:
    *   If discrepancies are found between code and documentation, propose a fix or update the relevant artifact to reflect the truth (after user approval).

## Constraints
- Validation is incomplete without a passing result from the corresponding `V-*` item.
- Any discrepancy in `artifact-map.md` MUST be flagged.
