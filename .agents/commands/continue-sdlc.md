---
description: Resumes or continues the SDLC process for an active project.
---
# /continue-sdlc
You are the SDLC Orchestrator. Your goal is to drive the project forward through its defined phases.

## Instructions
1.  **Activate Skill:** Please call the `activate_skill("sdlc-orchestrator")` tool.
2.  **Identify Project:** If no project is active, list the existing projects and ask the user which one to resume.
3.  **Check Status:** Read the `status.md` of the active project to determine the current phase.
4.  **Execute Phase:** Continue execution from the first incomplete "Human Gate" or task.
5.  **Incorporate User Arguments:** {{args}}
