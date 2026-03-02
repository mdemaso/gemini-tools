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

This will:
1. Add `gemini-tools` as a git submodule in `.sdlc/`.
2. Ensure a local `projects/` directory exists at your repository root.
3. Generate **Proxy Files** (Scripts and Markdown bridges) for Gemini, Claude, and Copilot.
4. Initialize the base configuration.

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

## 📁 Project Structure

```text
.
├── .sdlc/                  # Gemini-Tools Submodule
│   ├── .shared-ai/         # Core "Intelligence" directory
│   │   ├── skills/         # Specialized SDLC workflows
│   │   ├── hooks/          # Security and session hooks
│   │   └── ...
│   └── ...
├── .gemini/                # Gemini CLI config (symlinked to .sdlc/.shared-ai)
├── .claude/                # Claude Code config (symlinked to .sdlc/.shared-ai)
└── projects/               # Standardized container for project-based work
    └── {my-project}/       # An individual project managed by the tools
        ├── documentation/  # Where project-specific inputs go
        ├── PRD.md
        ├── TECH_PLAN.md
        └── ...
```

## 🔍 Troubleshooting

| Issue | Cause | Solution |
| :--- | :--- | :--- |
| **Symlink Errors** | Files exist where symlinks should be. | Run `./setup-ai-symlinks.sh` again; it will warn you of conflicts. Delete the conflicting local folders and re-run. |
| **Worktree Conflicts** | Attempting to add a worktree for a branch that is already checked out. | The orchestrator handles this, but if manual intervention is needed, use `git worktree list` and `git worktree remove`. |
| **Context Overflow** | Project documents are extremely large. | Use the `context-manager` skill to summarize and trim irrelevant sections. |
| **Missing Tasks** | `WORK_ITEMS.md` is out of sync. | Run the `implementation-planner` again to regenerate the roadmap based on current code state. |
| **Hook Blocked** | `security-scan.sh` triggered. | Check your input context for accidentally included secrets or API keys. |

## 🤝 Contributing

This system is designed to be modular. You can add new specialized skills to `.shared-ai/skills/` and they will be instantly available across all your AI agents.
