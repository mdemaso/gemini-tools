---
name: doc-setup
description: "Initializes a high-quality MkDocs documentation site for the project artifacts."
---

# Documentation Setup Skill

This skill automates the creation of a professional documentation site for the project's requirements, architecture, and work items.

## Workflow

1.  **Locate Project Context**:
    *   Target directory: `projects/{domain}/{project_id}/`.
2.  **Configuration**:
    *   Update `mkdocs.yml` to organize the navigation logically:
        ```yaml
        nav:
          - Overview: index.md
          - Status: status.md
          - Requirements:
            - High-level: product-requirements.md
            - Atomic: requirements/index.md
          - Architecture:
            - High-level: systems-architecture.md
            - Decisions: tech-decisions/index.md
          - Implementation:
            - Plan: implementation-plan.md
            - Work Items: work-items/index.md
          - Quality:
            - Verifications: verifications/index.md
          - Changes:
            - Log: changes/index.md
        ```
3.  **Enhancements**:
    *   Enable Mermaid diagrams and Panzoom for the architectural documents.
4.  **Verification**:
    *   Confirm the site builds and all artifact folders are included.
