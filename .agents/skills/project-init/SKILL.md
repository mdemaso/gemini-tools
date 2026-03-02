---
name: project-setup
description: "Walks the user through setting up a new project directory within the workspace. Use this when the user wants to start a new project, create a project folder, or initialize a project workspace."
---

# Project Setup Skill

This skill automates the creation of a standardized project directory structure.

## Workflow

When the user wants to set up a new project, follow these steps:

1.  **Gather Project Details**: Ask the user for the following information:
    *   **Project Name**: The display name of the project (e.g., "AI Research Dashboard").
    *   **Project ID**: A short identifier (e.g., "AIRD-2024").

2.  **Validate and Format**:
    *   Transform the Project Name by replacing all spaces with hyphens (`-`).
    *   Construct the final directory name using the format: `{project_id}-{formatted_project_name}`.

3.  **Execute Creation**:
    *   **Root Directory**: Ensure the `projects/` root directory exists (create it if missing).
    *   **Project Directory**: Create a directory at `projects/{project_id}-{formatted_project_name}`.
    *   **Documentation Folder**: Inside the project directory, ensure a `documentation/` subfolder exists (create it if missing).
    *   Add a placeholder `README.md` inside the project folder summarizing the project metadata.
    *   **Register Project**: Add an entry to the `projects/INDEX.md` file (create it if it doesn't exist) with the Project ID, Project Name, and the path to the project folder.

4.  **Confirm**: Notify the user that the project directory is ready and prompt them to place any supporting documentation in the new `documentation/` folder.

## Constraints
- Always use the `projects/` root directory.
- Ensure the directory name is lowercase and URL-friendly.
