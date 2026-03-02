# Gemini-Tools: AI SDLC Orchestration Engine

Gemini-Tools is a high-performance, standardized framework designed to automate the entire Software Development Lifecycle (SDLC) through AI agents. It centralizes specialized knowledge into a "write once, run everywhere" architecture that works across Gemini CLI, Claude Code, and GitHub Copilot.

## 🚀 Key Features

- **SDLC Orchestrator**: A master "Project Manager" skill that manages phase handoffs and execution loops.
- **Parallel Multi-Agent Execution**: Utilizes **Git Worktrees** to run multiple AI agents or developers in isolated, conflict-free environments.
- **Self-Healing Documentation**: Automatically updates PRDs and Tech Plans when intentional code deviations occur, maintaining a "Living Document" state.
- **Automated TDD**: Generates failing test suites based on requirements *before* implementation starts.
- **Documentation Engine**: Automates the setup of professional MkDocs sites with Material theme, Mermaid diagrams, and interactive pan/zoom.
- **Context Optimization**: Dynamically trims and summarizes project context to keep AI agents focused and reduce token usage.
- **Human-in-the-Loop**: A formal review gate for user approval of code changes and documentation updates.
- **Hybrid Proxy System**: Uses real wrapper scripts and bridge files for cross-agent compatibility instead of brittle symlinks.

## 🛠 Installation

You can install this system into any existing codebase with a single command:

```bash
curl -sSL https://raw.githubusercontent.com/mdemaso/gemini-tools/main/install.sh | bash
```

### The Installation Process

1.  **Submodule Initialization**: The script adds `gemini-tools` as a git submodule in the `.sdlc/` directory. This keeps the orchestration logic isolated and easily updatable.
2.  **Configuration Setup**: It runs `setup-ai-symlinks.sh` to initialize your AI tool configurations (e.g., `.agents/`, `.github/copilot/`).
    -   **Unified Configuration**: A single `.agents/` directory is created, with `.gemini` and `.claude` symlinked to it for cross-tool compatibility.
    -   **Individual Symlinks**: Within `.agents/`, the script creates individual symbolic links for each skill, hook, and agent from the shared core.
### The Installation Process

1.  **Submodule Initialization**: The script adds `gemini-tools` as a git submodule in the `.sdlc/` directory. This keeps the orchestration logic isolated and easily updatable.
2.  **Configuration Setup**: It runs `setup-ai-symlinks.sh` to initialize your AI tool configurations.
    -   **Unified Core**: A single `.agents/` folder is symlinked from the submodule into your project root.
    -   **Tool Discovery**: Symlinks for `.gemini`, `.claude`, and `.github/copilot` are created pointing to `.agents/`, ensuring all tools share the same configuration, skills, and hooks.
3.  **Project Container**: A `projects/` directory is created to house isolated, task-specific workspaces managed by the orchestrator.
4.  **Security Hooks**: Local git hooks are configured to run security scans and synchronization checks.

## 📖 How to Use

1. **Start the Orchestrator**:
   Simply say:
   > "Run the sdlc-orchestrator."

2. **Project Selection**:
   The orchestrator will ask if you want to:
   - **Start a New Project**: Invokes `project-setup` to create a new workspace.
   - **Resume an Existing Project**: Lists the 5 most recently modified projects in `projects/` for selection.

3. **Lifecycle Management**:
   Once a project is selected or created, the orchestrator will automatically:
   - **Initialize high-quality documentation** using the `doc-setup` skill.
   - Generate missing `PRD.md` or `TECH_PLAN.md`.
   - Create a dependency-aware implementation guide.
   - Execute tasks in parallel using isolated Git Worktrees.

## 📁 Artifacts & Project Structure

After installation, your project directory will contain the following artifacts:

```text
.
├── .sdlc/                      # The core "Intelligence" (Git Submodule)
│   ├── .agents/                # Unified skills, hooks, and settings
│   ├── setup-ai-symlinks.sh    # The tool-agnostic setup engine
│   └── ...
├── .agents/                    # Symlink to .sdlc/.agents/
├── .gemini/                    # Symlink to .agents/
├── .claude/                    # Symlink to .agents/
├── .github/copilot/            # Symlink to .agents/
├── projects/                   # The "Workbench" for AI-managed tasks
```

### Why a Unified `.agents` Folder?

By merging all core logic into a single `.agents` folder and using folder-level symlinks:
-   **Zero Maintenance**: Any new skill or hook added to the repository is immediately available to all tools without any script updates.
-   **Consistent Experience**: Your custom `settings.json`, specialized skills, and security hooks are identical across Gemini, Claude, and Copilot.
-   **Cleaner Root**: Tool-specific folders become simple aliases, keeping your repository root focused and organized.

## 🔍 Troubleshooting

| Issue | Cause | Solution |
| :--- | :--- | :--- |
| **Out of Sync** | Submodule updated but links are broken. | Re-run `bash .sdlc/setup-ai-symlinks.sh` to refresh the symlinks. |
| **Worktree Conflicts** | Attempting to add a worktree for a branch that is already checked out. | The orchestrator handles this, but if manual intervention is needed, use `git worktree list` and `git worktree remove`. |
| **Context Overflow** | Project documents are extremely large. | Use the `context-manager` skill to summarize and trim irrelevant sections. |
| **Missing Tasks** | `WORK_ITEMS.md` is out of sync. | Run the `implementation-planner` again to regenerate the roadmap based on current code state. |
| **Hook Blocked** | `security-scan.sh` triggered. | Check your input context for accidentally included secrets or API keys. |

## 🤝 Contributing

This system is designed to be modular. You can add new specialized skills to `.agents/skills/` and they will be instantly available across all your AI agents.
