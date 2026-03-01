---
name: prd-generator
description: "Generates a Product Requirements Document (PRD) by analyzing files in a project's documentation folder. Use this when the user asks to create a PRD, summarize project requirements, or draft an executive summary based on supporting documents."
---

# PRD Generator Skill

This skill analyzes documents in a project's `documentation` folder to generate a comprehensive Product Requirements Document (PRD).

## Workflow

1.  **Locate the Project**: Identify the project directory in the `projects/` folder that the user wants to process.
2.  **Analyze Documentation**: 
    *   Read all supporting files found within the project's `documentation/` subfolder.
    *   **Diverse Format Support**: Process text files, Markdown, PDFs, and images (e.g., diagrams, whiteboard photos) using your multimodal capabilities to extract relevant requirements and context.
3.  **Resolve Ambiguity**: 
    *   If you encounter missing information, ambiguity, or contradictory statements across the documents, you MUST pause and ask the user for clarification.
    *   To do this, read and strictly follow the [Clarification Strategy](../../../shared-references/clarification-strategy.md) when formulating your questions.
4.  **Generate the PRD**: Once all ambiguities are resolved (or if none exist), generate a PRD with the following required sections:
    *   **Executive Summary**: A high-level overview of the project's goals, target audience, and primary value proposition.
    *   **Requirements**:
        *   **Functional Requirements**: What the product must do.
        *   **Non-Functional Requirements**: How the product must perform (e.g., performance, security, scale).
    *   **MVP Details**: Specifically define the scope for the Minimum Viable Product, isolating core features from nice-to-haves.
    *   **Follow Up Items**: A list of unresolved questions, next steps, or dependencies that need attention before development begins.
5.  **Output**: Write the generated content to a `PRD.md` file in the root of the project folder (e.g., `projects/{project_id}-{project_name}/PRD.md`). Briefly summarize the document and notify the user when complete.
