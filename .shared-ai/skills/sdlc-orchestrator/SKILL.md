---
name: sdlc-orchestrator
description: "Master project manager that drives end-to-end SDLC with parallel multi-agent execution using Git Worktrees, automated testing, and self-healing docs."
---

# SDLC Orchestrator Skill (Master Flow)

This orchestrator manages high-level SDLC states and isolation for parallel multi-agent execution.

## Workflow

1.  **Phase 1: Project Initiation**
    *   Initialize workspace, docs, and the parallel roadmap with its **Git Worktree strategy**.

2.  **Phase 2: Configuration & Injection**
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
