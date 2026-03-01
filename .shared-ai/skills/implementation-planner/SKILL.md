---
name: implementation-planner
description: "Generates a parallelizable, dependency-aware implementation guide with a Git Worktree strategy for multi-agent execution."
---

# Implementation Planner Skill

This skill breaks down a Technical Design and PRD into a concrete, executable roadmap optimized for parallel AI-driven development.

## Workflow

1.  **Locate Project Context**:
    *   Read `PRD.md`, `TECH_PLAN.md`, and the project codebase.

2.  **Define Dependency Graph (DAG)**:
    *   Analyze components and identify prerequisites to maximize parallel execution.

3.  **Git Worktree Strategy**:
    *   For multi-agent parallelization, define a branching and worktree convention:
        *   **Main Branch**: `main` or `develop`.
        *   **Task Branches**: `task/{task-id}-{short-desc}`.
        *   **Worktree Paths**: `.worktrees/{task-id}`.
    *   Specify how independent `Parallel Class` tracks will be isolated into their own worktrees to prevent file system conflicts between agents.

4.  **Generate Implementation Guide**:
    *   Create `IMPLEMENTATION_GUIDE.md`.
    *   **Parallelization Strategy**: Explicitly tag tasks that can be performed in parallel.
    *   **Worktree Instructions**: Provide the specific `git worktree add` commands for each parallel track.

5.  **Initialize Work Item Index**:
    *   Create `WORK_ITEMS.md` with: Task ID, Description, Dependencies, Parallel Class, and Status.

6.  **Output**: Notify the user that the parallel roadmap and worktree strategy are ready.

## Constraints
- The Work Item Index must be a Markdown table.
- Tasks in the same `Parallel Class` MUST be assigned unique worktree paths.
