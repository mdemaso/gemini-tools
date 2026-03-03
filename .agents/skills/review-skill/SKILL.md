---
name: review-skill
description: "Human-in-the-loop review gate that presents changes in logical, digestible pieces for user approval. Use this when a task is ready for review to ensure alignment with PRD/Tech Plan."
---

# Review Skill

This skill provides a structured, human-centric review process. Instead of presenting a single massive diff, it breaks changes down into logical segments and guides the user through them sequentially.

## Workflow

### 1. Analyze and Segment Changes
Categorize all changes into logical "Review Units". A Review Unit is a cohesive set of changes that should be understood together.

**Logical Ordering Strategy:**
1.  **Definitions & Interfaces**: New types, interfaces, or abstract classes.
2.  **Foundations**: New classes, constants, or utility functions before they are used.
3.  **Implementations**: The core logic that fulfills the requirements.
4.  **Integrations**: Changes to existing code that utilize the new foundations or implementations.
5.  **Tests & Documentation**: Supporting tests and non-architectural documentation updates.

### 2. Iterative Review Loop
For each Review Unit, follow this sequence:

#### A. Present the Unit Context
- **Summary**: A concise explanation of what this unit accomplishes.
- **Justification**: The technical rationale (referencing the PRD, Tech Plan, or specific task).
- **Files Involved**: A list of paths included in this unit.

#### B. File-by-File Walkthrough
Present the diff for each file in the unit one by one. After each file (or a small group of highly coupled files), pause for user feedback.

#### C. Handle User Feedback & Inquiries
- **Questions**: Provide clear, technical answers. If the answer reveals a flaw or a needed change in direction, treat it as a "Request Fix".
- **Request Fix / Course Correction**:
    1.  Evaluate if the change impacts higher-level documents (**PRD**, **Tech Plan**, or **Implementation Plan**).
    2.  If it does, **you MUST update those documents first** to maintain the source of truth.
    3.  Apply the fixes to the code.
    4.  Verify the fix and then resume/restart the review for the impacted units.
- **Approval**: Once the user confirms the unit is correct, proceed to the next one.

### 3. Finalization
Once all Review Units are approved:
1.  Perform a final consistency check between the code, PRD, and Tech Plan.
2.  Mark the task as Done in `WORK_ITEMS.md`.

## Guidelines for Effective Reviews
- **Be Surgical**: Focus only on the changes relevant to the current unit.
- **Explain "Why", Not Just "What"**: Use the justification to connect code patterns to the original project goals.
- **Bi-directional Alignment**: If code deviates from the Tech Plan during implementation for a good reason, use the review to confirm the deviation and update the Tech Plan accordingly.
- **Interactive Engagement**: Encourage the user to scrutinize specific areas of complexity.
