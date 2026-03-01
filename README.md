# Gemini-Tools: AI SDLC Orchestration Engine

Gemini-Tools is a high-performance, standardized framework designed to automate the entire Software Development Lifecycle (SDLC) through AI agents. It centralizes specialized knowledge into a "write once, run everywhere" architecture that works across Gemini CLI, Claude Code, and GitHub Copilot.

## 🚀 Key Features

- **SDLC Orchestrator**: A master "Project Manager" skill that manages phase handoffs and execution loops.
- **Parallel Multi-Agent Execution**: Utilizes **Git Worktrees** to run multiple AI agents or developers in isolated, conflict-free environments.
- **Self-Healing Documentation**: Automatically updates PRDs and Tech Plans when intentional code deviations occur, maintaining a "Living Document" state.
- **Automated TDD**: Generates failing test suites based on requirements *before* implementation starts.
- **Context Optimization**: Dynamically trims and summarizes project context to keep AI agents focused and reduce token usage.
- **Human-in-the-Loop**: A formal review gate for user approval of code changes and documentation updates.

## 🛠 Installation

You can install this system into any existing codebase with a single command:

```bash
curl -sSL https://raw.githubusercontent.com/mdemaso/gemini-tools/main/install.sh | bash
```

This will:
1. Add `gemini-tools` as a git submodule in `.sdlc/`.
2. Symlink your current project into the SDLC workspace.
3. Set up the necessary symlinks for Gemini, Claude, and Copilot.
4. Initialize the base configuration.

## 📖 How to Use

1. **Initialize your Project**:
   If starting from scratch, tell your AI agent:
   > "Run the project-setup skill."

2. **Generate Requirements & Design**:
   Place any initial notes in the `documentation/` folder and run:
   > "Generate the PRD and Tech Plan."

3. **Start Orchestration**:
   To begin the automated development loop, simply say:
   > "Run the sdlc-orchestrator."

   The orchestrator will guide you through:
   - Defining the roadmap.
   - Injecting implementation agents.
   - Running parallel tasks in isolated worktrees.
   - Validating work against generated tests.
   - Final human review.

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
└── documentation/          # Project-specific input/docs (Created during install)
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
