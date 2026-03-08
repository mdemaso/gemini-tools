---
name: tech-plan-generator
description: "Generates a Technical Design Document (Tech Plan) based on a Product Requirements Document (PRD) and supporting documentation. Use this when the user needs to define the technical implementation, architecture, and C4 diagrams for a project."
---

# Tech Plan Generator Skill

This skill translates Product Requirements into technical designs, generating atomic technical decisions and a high-level System Architecture.

## Workflow

1.  **Locate Project Context**:
    *   Identify the target project directory: `projects/{domain}/{project_id}/`.
    *   Read `product-requirements.md` and atomic `requirements/R-*.md` files.
2.  **Resolve Technical Ambiguity**:
    *   If technical constraints are unclear, pause and ask the user for clarification using the [Clarification Strategy](../../../shared-references/clarification-strategy.md).
3.  **Generate Atomic Tech Decisions**:
    *   For each major technical choice, create an Architectural Decision Record (ADR).
    *   **Output**: Create `tech-decisions/D-*.md` files following the template in `scratch.md`.
    *   **Index**: Create `tech-decisions/index.md` to track technical evolution.
    *   **Human Gate**: Wait for user approval of technical decisions. Mark "Tech Decisions Approved" in `status.md`.
4.  **Generate System Architecture**:
    *   Synthesize technical decisions into a cohesive system design.
    *   **Output**: Create `systems-architecture.md` in the project root.
    *   **C4 Diagrams**: Include Mermaid context, container, and component diagrams.
    *   **Human Gate**: Wait for user approval of the System Architecture. Mark "System Architecture Approved" in `status.md`.
5.  **Update Artifact Map**:
    *   Map Technical Decisions (`D-*`) to Requirements (`R-*`) in `artifact-map.md`.

## Constraints
- Decisions MUST be atomic and uniquely identified (e.g., D-001).
- Diagrams MUST be valid Mermaid syntax.
