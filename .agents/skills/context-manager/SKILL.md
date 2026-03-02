---
name: context-manager
description: "Trims, summarizes, and optimizes the context window for implementation agents to reduce noise and prevent context overflow."
---

# Context Manager Skill

This skill optimizes the information passed to AI agents to ensure they focus only on the relevant parts of the project.

## Workflow

1.  **Extract Relevant Context**:
    *   Given a Task ID, extract only the related sections from `PRD.md` and `TECH_PLAN.md`.
    *   Include only the file structure and API signatures relevant to the current task.

2.  **Summarize Current State**:
    *   Analyze `WORK_ITEMS.md` and the last 3-5 completed task logs to build a "Current State" summary.
    *   Provide a "Delta" of changes made since the project started.

3.  **Optimize Prompt**:
    *   Format the final context into a concise prompt, removing redundant boilerplate or unrelated architectural details.
