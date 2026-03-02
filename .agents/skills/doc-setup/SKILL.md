---
name: doc-setup
description: "Initializes a high-quality MkDocs documentation site with the Material theme, Mermaid diagrams, and Panzoom functionality."
---

# Documentation Setup Skill

This skill automates the creation of a professional documentation site using MkDocs, styled with the Material theme and enhanced with interactive diagrams and image zoom capabilities.

## Workflow

1.  **Locate Document Root**:
    *   Ask the user for the **Document Root** (the directory containing existing `.md` files).
    *   If not provided, default to a new `docs/` folder in the current directory.

2.  **Environment Preparation**:
    *   Check for Python 3 and pip.
    *   Recommend or create a virtual environment (`python -m venv .venv`).

3.  **Package Installation**:
    *   Install core components:
        ```bash
        pip install mkdocs mkdocs-material mkdocs-panzoom-plugin
        ```

4.  **Project Initialization & Structure**:
    *   Run `mkdocs new .` if no `mkdocs.yml` exists.
    *   If a custom **Document Root** was provided (and it is not the default `docs/` folder):
        *   Option A: Update `mkdocs.yml` to set `docs_dir: {document_root}`.
        *   Option B: Copy/Move files from the root into the `docs/` folder.

5.  **Configuration**:
    *   Update `mkdocs.yml` with the following essential configuration:
        ```yaml
        site_name: Project Documentation
        docs_dir: docs  # Update this if using a custom document root
        theme:
          name: material
          features:
            - content.code.copy
            - navigation.top
        
        plugins:
          - search
          - panzoom:
              full_screen: true

        markdown_extensions:
          - pymdownx.superfences:
              custom_fences:
                - name: mermaid
                  class: mermaid
                  format: !!python/name:pymdownx.superfences.fence_code_format
        ```

5.  **Verification**:
    *   Suggest running `mkdocs serve` to preview the site.
    *   Create a sample diagram in `docs/index.md` to verify Mermaid support.

## Constraints
- Ensure `mkdocs.yml` is at the root of the project.
- If a virtual environment is used, remind the user to add it to `.gitignore`.
- Always set `full_screen: true` for the `panzoom` plugin as requested.
