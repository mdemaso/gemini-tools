---
name: example-skill
description: "An example shared skill demonstrating cross-tool compatibility. Use this when the user asks for a demonstration of the shared AI setup."
---

# Example Shared Skill

This is an example skill located in `.shared-ai/skills/example-skill`. It demonstrates how a single skill definition can be shared across multiple AI CLIs (like Gemini CLI, Claude Code, and Codex) via symlinks.

## Instructions

When triggered, inform the user that:
1. The shared skill was successfully loaded.
2. The `.shared-ai` structure is working correctly via symlinks.
3. This setup enables them to write instructions, skills, agents, commands, and hooks once, and use them across their favorite AI agents.
