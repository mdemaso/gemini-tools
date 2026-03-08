---
name: project-setup
description: "Walks the user through setting up a new project directory within the workspace. Use this when the user wants to start a new project, create a project folder, or initialize a project workspace."
---

# Project Setup Skill

This skill automates the creation of a standardized project directory structure based on the SDLC Process Flow.

## Workflow

When the user wants to set up a new project, follow these steps:

1.  **Gather Project Details**: Ask the user for the following information:
    *   **Project Name**: The display name of the project (e.g., "AI Research Dashboard").
    *   **Domain**: The functional domain (e.g., "internal", "client-a", "research").
    *   **Project ID**: A short, unique identifier (e.g., "aird-2024").
    *   **Codebase Path**: The path to the existing codebase or repository (if applicable).

2.  **Validate and Format**:
    *   Ensure `domain` and `project_id` are lowercase and URL-friendly (replace spaces with hyphens).

3.  **Execute Creation**:
    *   **Root Directory**: `projects/{domain}/{project_id}/`
    *   **Sub-directories**:
        *   `inputs/`: For raw materials and source info.
        *   `requirements/`: For atomic `R-*.md` files.
        *   `tech-decisions/`: For atomic `D-*.md` files.
        *   `work-items/`: For atomic `W-*.md` files.
        *   `verifications/`: For atomic `V-*.md` files.
        *   `changes/`: For atomic `C-*.md` files.
    *   **Initial Files**:
        *   `status.md`: Copy the template from `scratch.md` and initialize with project metadata.
        *   `README.md`: Contains project name, status list, and path to the codebase/domain.
        *   `artifact-map.md`: Initialize as an empty traceability matrix.

4.  **Confirm**:
    *   Notify the user that the project structure is initialized.
    *   Ask for context information or for the user to place supporting documents into the `inputs/` folder.
    *   **Human Gate**: Wait for user confirmation that Phase 0 (Initialization) is complete.

## Constraints
- Always use the `projects/{domain}/{project_id}/` structure.
- Do not create placeholder files for phases beyond Initialization.
