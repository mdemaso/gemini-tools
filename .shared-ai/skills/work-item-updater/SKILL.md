---
name: work-item-updater
description: "Updates the status of specific tasks in a project's WORK_ITEMS.md file. Use this when a task is started, finished, or blocked to keep the project index accurate."
---

# Work Item Updater Skill

This skill keeps the project's task list up to date by modifying the `WORK_ITEMS.md` file located in the project root.

## Workflow

1.  **Identify the Task**: Determine the **Task ID** and the **New Status** (e.g., "Done", "In Progress", "Blocked") for the work being updated.
2.  **Locate WORK_ITEMS.md**: Find the `WORK_ITEMS.md` file in the root of the active project folder.
3.  **Execute Update**:
    *   Use the provided script to ensure the Markdown table format is maintained:
        `node scripts/update_task.cjs <path/to/WORK_ITEMS.md> <taskId> <newStatus>`
    *   The script safely replaces the status in the corresponding row.
4.  **Confirm**: Verify the change and inform the user of the new status.

## Resolve Ambiguity
If the Task ID provided is not found or is ambiguous, follow the [Clarification Strategy](../../../shared-references/clarification-strategy.md) to ask the user which task should be updated.
