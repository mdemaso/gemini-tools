---
name: review-skill
description: "Human-in-the-loop review gate that presents changes and a diff for user approval before marking a task as Done."
---

# Review Skill

This skill provides a human oversight layer to ensure the AI's work aligns with the user's vision.

## Workflow

1.  **Prepare Review Material**:
    *   Generate a `git diff` of the changes made during the current task.
    *   Summarize the changes in plain language, highlighting any deviations from the `TECH_PLAN.md`.

2.  **Present to User**:
    *   Display the diff and the summary.
    *   Ask: "Do you approve these changes? (Yes/No/Request Fixes)"

3.  **Handle Feedback**:
    *   If **Approved**: Proceed to update the task status.
    *   If **Request Fixes**: Capture the user's feedback and return it to the implementation agent for another iteration.
    *   If **Rejected**: Revert the changes or pause the orchestrator for manual intervention.
