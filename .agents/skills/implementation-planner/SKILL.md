---
name: implementation-planner
description: "Generates a parallelizable, dependency-aware implementation guide with a Git Worktree strategy for multi-agent execution."
---

# Implementation Planner Skill

This skill translates Technical Architecture into actionable tasks, generating atomic work items and a strategic Implementation Plan.

## Workflow

1.  **Locate Project Context**:
    *   Identify the target project directory: `projects/{domain}/{project_id}/`.
    *   Read `systems-architecture.md` and atomic `tech-decisions/D-*.md` files.
2.  **Generate Atomic Work Items**:
    *   For each component or feature, define concrete, executable tasks.
    *   **Output**: Create `work-items/W-*.md` files following the template in `scratch.md`.
    *   **Index**: Create `work-items/index.md` to track status and dependencies.
    *   **Human Gate**: Wait for user approval of work items. Mark "Work Items Approved" in `status.md`.
3.  **Generate Implementation Plan**:
    *   Define a high-level roadmap and parallel execution strategy.
    *   **Output**: Create `implementation-plan.md` in the project root.
    *   **Parallelization Strategy**: Identify `Parallel Class` groups for concurrent execution.
    *   **Human Gate**: Wait for user approval of the Implementation Plan. Mark "Implementation Plan Approved" in `status.md`.
4.  **Update Artifact Map**:
    *   Map Work Items (`W-*`) to Technical Decisions (`D-*`) and Requirements (`R-*`) in `artifact-map.md`.

## Constraints
- Work Items MUST be atomic and uniquely identified (e.g., W-001).
- Dependencies MUST be clearly defined in `W-*.md` files.
