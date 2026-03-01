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

# 2. Run the symlink setup script from the submodule
echo "🔗 Setting up AI agent symlinks..."
bash "$SUBMODULE_DIR/setup-ai-symlinks.sh"

# 3. Create projects directory in submodule and link parent
echo "📁 Linking current project to the SDLC workspace..."
mkdir -p "$SUBMODULE_DIR/projects"
PROJECT_NAME=$(basename "$(pwd)")
# Symlink current directory into the submodule's project view
if [ ! -L "$SUBMODULE_DIR/projects/$PROJECT_NAME" ]; then
    ln -s "../../" "$SUBMODULE_DIR/projects/$PROJECT_NAME"
fi

# 4. Expose the projects directory at the root if it doesn't exist
if [ ! -e "projects" ]; then
    ln -s "$SUBMODULE_DIR/projects" "projects"
fi

# 5. Copy base configuration for Gemini if missing
if [ ! -d ".gemini" ]; then
    mkdir .gemini
    cp "$SUBMODULE_DIR/.gemini/settings.json" .gemini/
fi

echo ""
echo "✅ Installation Complete!"
echo "-------------------------------------------------------"
echo "Your codebase is now AI-ready (Tools isolated in .sdlc)"
echo "-------------------------------------------------------"
echo "To begin, ask your AI agent to 'Run the sdlc-orchestrator'."
