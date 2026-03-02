# Gemini-Tools: AI SDLC Orchestration Engine

Gemini-Tools is a high-performance, standardized framework designed to automate the entire Software Development Lifecycle (SDLC) through AI agents. It centralizes specialized knowledge into a "write once, run everywhere" architecture that works across Gemini CLI, Claude Code, and GitHub Copilot.

## 🚀 Key Features

- **SDLC Orchestrator**: A master "Project Manager" skill that manages phase handoffs and execution loops.
- **Parallel Multi-Agent Execution**: Utilizes **Git Worktrees** to run multiple AI agents or developers in isolated, conflict-free environments.
- **Self-Healing Documentation**: Automatically updates PRDs and Tech Plans when intentional code deviations occur, maintaining a "Living Document" state.
- **Automated TDD**: Generates failing test suites based on requirements *before* implementation starts.
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
2.  **Hybrid Proxy Setup**: It runs `setup-ai-symlinks.sh` to generate **Real Proxy Files** in your project root (e.g., `.gemini/`, `.claude/`, `.github/copilot/`). 
    -   Unlike brittle symlinks, these are actual files (shell script wrappers and Markdown bridges) that point back to the central intelligence in the submodule.
    -   This ensures maximum compatibility with AI agents that may not follow symlinks or require specific file structures.
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
   - Generate missing `PRD.md` or `TECH_PLAN.md`.
   - Create a dependency-aware implementation guide.
   - Execute tasks in parallel using isolated Git Worktrees.

## 📁 Artifacts & Project Structure

After installation, your project directory will contain the following artifacts:

```text
.
├── .sdlc/                      # The core "Intelligence" (Git Submodule)
│   ├── .shared-ai/             # Shared skills, hooks, and agents
│   ├── setup-ai-symlinks.sh    # The tool-agnostic setup engine
│   └── ...
├── .gemini/                    # Gemini CLI configuration
│   ├── skills/                 # Markdown bridges to shared skills
│   └── hooks/                  # Script wrappers for shared hooks
├── .claude/                    # Claude Code configuration
│   ├── skills/                 # Markdown bridges to shared skills
│   └── hooks/                  # Script wrappers for shared hooks
├── .github/copilot/            # GitHub Copilot configuration
│   └── ...
├── projects/                   # The "Workbench" for AI-managed tasks
│   └── {project-name}/         # Isolated project context
│       ├── documentation/      # Inputs, PRDs, and Tech Plans
│       ├── WORK_ITEMS.md       # The live roadmap for the project
│       └── ...
```

### Why "Hybrid Proxies"?

AI agents have varying levels of support for symlinks and directory structures. **Gemini-Tools** solves this by generating:
-   **Markdown Bridges**: Small `.md` files that instruct the AI agent on where to find the full skill definitions in the submodule.
-   **Script Wrappers**: Small `.sh` files that `exec` the shared hooks from the submodule, ensuring consistent behavior across all agents.

## 🔍 Troubleshooting

| Issue | Cause | Solution |
| :--- | :--- | :--- |
| **Proxy Out of Sync** | Submodule updated but proxies are old. | Re-run `bash .sdlc/setup-ai-symlinks.sh` to refresh the proxy files. |
| **Worktree Conflicts** | Attempting to add a worktree for a branch that is already checked out. | The orchestrator handles this, but if manual intervention is needed, use `git worktree list` and `git worktree remove`. |
| **Context Overflow** | Project documents are extremely large. | Use the `context-manager` skill to summarize and trim irrelevant sections. |
| **Missing Tasks** | `WORK_ITEMS.md` is out of sync. | Run the `implementation-planner` again to regenerate the roadmap based on current code state. |
| **Hook Blocked** | `security-scan.sh` triggered. | Check your input context for accidentally included secrets or API keys. |

## 🤝 Contributing

This system is designed to be modular. You can add new specialized skills to `.shared-ai/skills/` and they will be instantly available across all your AI agents.
