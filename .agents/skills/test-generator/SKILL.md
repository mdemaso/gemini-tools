---
name: test-generator
description: "Automatically generates test suites (unit/integration) based on the PRD and Tech Plan to provide a source of truth for validation."
---

# Verification Generator Skill

This skill translates Work Items into concrete verification tests, generating atomic verification items.

## Workflow

1.  **Locate Project Context**:
    *   Identify the target project directory: `projects/{domain}/{project_id}/`.
    *   Read atomic `work-items/W-*.md` files.
2.  **Generate Atomic Verification Items**:
    *   For each work item, define how to verify its correctness (e.g., unit tests, integration tests, manual QA).
    *   **Output**: Create `verifications/V-*.md` files following the template in `scratch.md`.
    *   **Index**: Create `verifications/index.md` to track verification status and results.
    *   **Human Gate**: Wait for user approval of verification items. Mark "Verification Items Approved" in `status.md`.
3.  **Update Artifact Map**:
    *   Map Verification Items (`V-*`) to Work Items (`W-*`) in `artifact-map.md`.

## Constraints
- Verifications MUST be atomic and uniquely identified (e.g., V-001).
- Each Verification MUST link to at least one Work Item (`W-*`).
