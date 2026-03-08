---
name: prd-generator
description: "Generates a Product Requirements Document (PRD) by analyzing files in a project's documentation folder. Use this when the user asks to create a PRD, summarize project requirements, or draft an executive summary based on supporting documents."
---

# PRD Generator Skill

This skill analyzes documents in a project's `inputs/` folder to generate atomic requirements and a high-level Product Requirements Document (PRD).

## Workflow

1.  **Locate Project Context**:
    *   Identify the target project directory: `projects/{domain}/{project_id}/`.
2.  **Analyze Inputs**:
    *   Read all supporting files found within the project's `inputs/` subfolder.
    *   **Multimodal Analysis**: Process text, Markdown, diagrams, and photos to extract raw requirements.
3.  **Resolve Ambiguity**:
    *   If missing info or contradictions exist, pause and ask the user for clarification using the [Clarification Strategy](../../../shared-references/clarification-strategy.md).
    *   **Human Gate**: Once inputs are clear, mark "Inputs Gathered" in `status.md`.
4.  **Generate Atomic Requirements**:
    *   Break down raw information into atomic, testable requirements.
    *   **Output**: Create `requirements/R-*.md` files (one per requirement) following the template in `scratch.md`.
    *   **Index**: Create `requirements/index.md` to organize these files into logical categories.
    *   **Human Gate**: Wait for user approval of atomic requirements. Mark "Requirements Approved" in `status.md`.
5.  **Generate High-Level PRD**:
    *   Synthesize atomic requirements into a cohesive vision.
    *   **Output**: Create `product-requirements.md` in the project root.
    *   **Traceability**: Ensure `product-requirements.md` links to the relevant `R-*` items.
    *   **Human Gate**: Wait for user approval of the PRD. Mark "Product Requirements Approved" in `status.md`.
6.  **Update Artifact Map**:
    *   Add the new requirements to the `artifact-map.md`.

## Constraints
- Requirements MUST be atomic and uniquely identified (e.g., R-001).
- The index MUST be categorized logically.
