---
name: retro
description: "Performs a retrospective on the session to summarize progress, provide feedback on used skills, and identify areas for system improvement."
---

# Retrospective Skill

This skill is designed to be the final step of any major workflow. It focuses on continuous improvement by analyzing the session's successes and friction points.

## Workflow

1.  **Summarize Progress**:
    *   Review the conversation and identify the key accomplishments (e.g., tasks completed, features implemented, bugs fixed).
    *   Verify if the original objectives were met.

2.  **Skill Feedback Loop**:
    *   List every skill that was invoked during the session (e.g., `prd-generator`, `implementation-planner`, `sdlc-orchestrator`).
    *   For each skill, evaluate:
        *   **Effectiveness**: Did it achieve its goal efficiently?
        *   **Friction**: Were there any "illegal options," path errors, or confusing instructions?
        *   **Gaps**: Was there anything missing from the skill's instructions that caused a manual detour?

3.  **System Improvement Recommendations**:
    *   Propose specific updates to the `SKILL.md` files of any skills that encountered issues.
    *   Suggest new shared references or hook improvements if applicable.

4.  **Closing**:
    *   Present the summary and improvement list to the user.
    *   Ask if the user would like to apply any of the suggested skill updates now.

## Constraints
- Be brutally honest about friction points; the goal is to eliminate them.
- Focus on actionable improvements that can be committed back to the `.agents` core.
