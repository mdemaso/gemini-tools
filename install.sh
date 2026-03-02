#!/usr/bin/env bash

# Remote Installation Script for Gemini/Claude Tools
# Usage: curl -sSL https://raw.githubusercontent.com/mdemaso/gemini-tools/main/install.sh | bash

set -e

REPO_URL="https://github.com/mdemaso/gemini-tools.git"
SUBMODULE_DIR=".sdlc"

echo "🚀 Installing Gemini/Claude SDLC Orchestration System as Submodule..."
# 1. Add as a submodule
if [ -d "$SUBMODULE_DIR" ]; then
    echo "Info: $SUBMODULE_DIR already exists. Updating..."
    git submodule update --init --recursive
else
    git submodule add --force "$REPO_URL" "$SUBMODULE_DIR"
fi

# 2. Run the folder-level symlink setup script from the submodule
echo "🔗 Symlinking AI config folders..."
bash "$SUBMODULE_DIR/setup-ai-symlinks.sh"

# 3. Ensure a local projects folder exists
if [ ! -d "projects" ]; then
    echo "📁 Creating local projects folder..."
    mkdir projects
fi

# 4. Add .sdlc to .gitignore if not already present
...

if [ -f ".gitignore" ]; then
    if ! grep -q "^.sdlc$" .gitignore; then
        echo "🙈 Adding .sdlc to .gitignore..."
        echo -e "\n# Gemini-Tools Submodule\n.sdlc" >> .gitignore
    fi
else
    echo "🙈 Creating .gitignore and adding .sdlc..."
    echo -e "# Gemini-Tools Submodule\n.sdlc" > .gitignore
fi

echo ""
echo "✅ Installation Complete!"

echo "-------------------------------------------------------"
echo "Your codebase is now AI-ready (Tools isolated in .sdlc)"
echo "-------------------------------------------------------"
echo "To begin, ask your AI agent to 'Run the sdlc-orchestrator'."
