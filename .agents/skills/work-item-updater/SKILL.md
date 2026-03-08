---
name: work-item-updater
description: "Updates the status of specific tasks in a project's work-items/ folder. Use this when a task is started, finished, or blocked to keep the project index accurate."
---

# Work Item Updater Skill

This skill keeps the project's task list up to date by modifying the atomic `W-*.md` files and the `work-items/index.md` file.

## Workflow

1.  **Identify the Task**: Determine the **Task ID** (e.g., `W-001`) and the **New Status** (e.g., `Todo`, `In Progress`, `Blocked`, `Completed`, `Verified`).
2.  **Locate Artifacts**:
    *   Find the `work-items/W-{id}.md` file.
    *   Find the `work-items/index.md` file.
3.  **Execute Update**:
    *   Update the status in the individual `W-*.md` file.
    *   Update the status in the `work-items/index.md` table.
4.  **Confirm**: Verify the change and inform the user of the new status.

## Resolve Ambiguity
If the Task ID provided is not found or is ambiguous, follow the [Clarification Strategy](../../../shared-references/clarification-strategy.md) to ask the user which task should be updated.
