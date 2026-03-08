---
name: context-manager
description: "Trims, summarizes, and optimizes the context window for implementation agents to reduce noise and prevent context overflow."
---

# Context Manager Skill

This skill optimizes the information passed to AI agents to ensure they focus only on the relevant parts of the project.

## Workflow

1.  **Extract Relevant Context**:
    *   Given a Task ID (`W-*`), identify its related `D-*` (Tech Decisions) and `R-*` (Requirements) via the `artifact-map.md`.
    *   Read the atomic files: `work-items/W-*.md`, `tech-decisions/D-*.md`, and `requirements/R-*.md`.
    *   Include only the file structure and API signatures relevant to the current task.

2.  **Summarize Current State**:
    *   Analyze the `work-items/index.md` and the last 3-5 completed task logs to build a "Current State" summary.
    *   Check `status.md` for any "Dirty" `[!]` flags that might affect the context.

3.  **Optimize Prompt**:
    *   Format the final context into a concise prompt, removing redundant boilerplate or unrelated architectural details.
