---
name: sdlc-orchestrator
description: "Master project manager that drives end-to-end SDLC with parallel multi-agent execution using Git Worktrees, automated testing, and self-healing docs."
---
# SDLC Orchestrator Skill (Master Flow)

This orchestrator manages high-level SDLC states and isolation for parallel multi-agent execution.

## Workflow

1.  **Phase 0: Project Selection**
    *   Ask the user: "Would you like to start a new project or resume an existing one?"
    *   **If New**: Invoke `project-setup` skill.
    *   **If Resume**:
        *   List the last 5 projects from the `projects/` directory (sorted by modification time).
        *   Present these as options or allow the user to provide a custom path.
        *   Set the selected directory as the active project context.

2.  **Phase 1: Project Initiation**
    *   Ensure the active project has the necessary `PRD.md`, `TECH_PLAN.md`, and `WORK_ITEMS.md`.
    *   If missing, sequentially invoke `prd-generator`, `tech-plan-generator`, and `implementation-planner`.

3.  **Phase 2: Configuration & Injection**
...

    *   Select **Implementation Agents**. If multiple agents are chosen, the orchestrator triggers the **Worktree Lifecycle**.

3.  **Phase 3: Parallel Execution with Worktrees**
    *   For each parallel track (based on `Parallel Class` in `WORK_ITEMS.md`):
        1.  **Worktree Setup**:
            *   Create a task branch: `git branch task/{task-id}`.
            *   Initialize an isolated worktree: `git worktree add .worktrees/{task-id} task/{task-id}`.
        2.  **Track Execution**:
            *   Invoke `context-manager` for a trimmed prompt.
            *   Invoke `test-generator` *within the worktree* to create failing tests.
            *   Run implementation agent in the isolated worktree directory.
            *   Run `implementation-validator` within the worktree to verify code, tests, and documentation truth.
        3.  **Handoff & Merge**:
            *   Invoke `review-skill` (User signs off on the worktree diff).
            *   Merge the task branch back into the main branch.
            *   Remove the worktree: `git worktree remove .worktrees/{task-id}` and delete the task branch.
        4.  **Update Global State**: Update the root `WORK_ITEMS.md` and move to the next dependency-free task.

4.  **Phase 4: Milestone Cleanup**
    *   Perform a final sync of all documents and a project-wide build.
