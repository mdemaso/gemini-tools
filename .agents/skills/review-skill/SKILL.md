---
name: review-skill
description: "Human-in-the-loop review gate that presents changes in logical, digestible pieces for user approval. Use this when a task is ready for review to ensure alignment with Requirements and Architecture."
---

# Review Skill

This skill provides a structured, human-centric review process. It breaks changes down into logical segments and guides the user through them sequentially to clear Human Gates.

## Workflow

### 1. Analyze and Segment Changes
Categorize all changes into logical "Review Units".

**Logical Ordering Strategy:**
1.  **Foundations**: New classes, constants, or utility functions.
2.  **Implementations**: The core logic fulfilling `R-*` and `D-*` artifacts.
3.  **Integrations**: Changes to existing code.
4.  **Verifications**: Corresponding `V-*` tests and results.

### 2. Iterative Review Loop
For each Review Unit, follow this sequence:

#### A. Present the Unit Context
- **Summary**: Concise explanation.
- **Traceability**: Reference the specific `W-*`, `D-*`, and `R-*` items.
- **Files Involved**: List of paths.

#### B. File-by-File Walkthrough
Present diffs and pause for feedback.

#### C. Handle User Feedback & Inquiries
- **Request Fix**:
    1.  If the change impacts `R-*` or `D-*`, **you MUST update those atomic artifacts first**.
    2.  Mark subsequent phases as "Dirty" `[!]` in `status.md` if necessary.
    3.  Apply fixes, verify, and resume review.

### 3. Finalization
Once all Review Units are approved:
1.  Perform a final consistency check via `implementation-validator`.
2.  Update the status in `work-items/W-*.md` and `work-items/index.md`.
3.  **Human Gate**: Ask the user to sign off on the specific phase gate in `status.md`.

## Guidelines for Effective Reviews
- **Traceability First**: Always link code back to the atomic requirement it fulfills.
- **Bi-directional Alignment**: If implementation forces a change in architecture, update the `D-*` artifact immediately.
