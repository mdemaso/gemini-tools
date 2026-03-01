---
name: tech-plan-generator
description: "Generates a Technical Design Document (Tech Plan) based on a Product Requirements Document (PRD) and supporting documentation. Use this when the user needs to define the technical implementation, architecture, and C4 diagrams for a project."
---

# Tech Plan Generator Skill

This skill translates the "Why" and "What" of a Product Requirements Document (PRD) into a technical "How" through a structured Technical Design Document.

## Workflow

1.  **Locate Project Context**: 
    *   If running in a standalone repository: Use the root directory.
    *   If running in a workspace: Identify the target project directory in the `projects/` folder.
    *   Read the `PRD.md` file from the project root (Primary source).
    *   Read files in the `documentation/` subfolder (Secondary context).
    *   **Analyze Existing Codebase**: Perform a broad scan of the existing project codebase (if applicable) to understand established patterns, naming conventions, and architectural styles.

2.  **Resolve Technical Ambiguity**:
    *   If technical constraints, platform choices, or architectural directions are unclear or contradictory, you MUST pause and ask the user for clarification.
    *   Strictly follow the [Clarification Strategy](../../../shared-references/clarification-strategy.md) for these prompts.

3.  **Generate the Tech Plan**: Create a `TECH_PLAN.md` file in the project root with the following sections:
    *   **Architecture (C4 Model)**: 
        *   Provide a **C4 System Context diagram** using Mermaid.js syntax.
        *   Provide a **C4 Container diagram** (and Component diagram if necessary) using Mermaid.js.
    *   **Technical Solution**: 
        *   **Tech Stack**: Defined choices for frontend, backend, database, and infrastructure.
        *   **Patterns & Standards**: Explicitly document how the solution follows existing project patterns, coding standards, and best practices discovered during the codebase analysis.
        *   **Data Model**: High-level schema or data flow descriptions.
        *   **API Design**: Outline of key endpoints or interface contracts.
    *   **Implementation Strategy**:
        *   Phased approach for building the MVP defined in the PRD.
        *   Specific technical hurdles and proposed mitigations.
    *   **Infrastructure & DevOps**: Deployment strategy, CI/CD, and monitoring approach.

4.  **Output**: Write the content to a `TECH_PLAN.md` file in the root of the project folder. Notify the user upon completion.

## Constraints
- Diagrams MUST be valid Mermaid.js code blocks.
- The plan must remain strictly aligned with the requirements defined in the PRD.
