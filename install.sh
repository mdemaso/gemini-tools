#!/usr/bin/env bash

# Remote Installation Script for Gemini/Claude Tools
# Usage: curl -sSL https://raw.githubusercontent.com/mdemaso/gemini-tools/main/install.sh | bash

set -e

REPO_URL="https://github.com/mdemaso/gemini-tools.git"
SUBMODULE_DIR=".sdlc"

echo "🚀 Installing Gemini/Claude SDLC Orchestration System as Submodule..."

# 1. Ensure we are in a git repository
if [ ! -d ".git" ]; then
    echo "📦 Initializing a new git repository..."
    git init
fi

# 2. Add or update the submodule
if [ -d "$SUBMODULE_DIR" ]; then
    echo "Info: $SUBMODULE_DIR already exists. Updating to latest..."
    # Ensure it's tracking main
    git config -f .gitmodules "submodule.$SUBMODULE_DIR.branch" main || true
    git submodule update --remote --init --recursive "$SUBMODULE_DIR"
else
    echo "📦 Adding gemini-tools submodule tracking main branch..."
    git submodule add --force -b main "$REPO_URL" "$SUBMODULE_DIR"
    git submodule update --init --recursive "$SUBMODULE_DIR"
fi

# 3. Verify the setup script exists before running
if [ -f "$SUBMODULE_DIR/setup-ai-symlinks.sh" ]; then
    echo "🔗 Setting up AI proxy configurations..."
    bash "$SUBMODULE_DIR/setup-ai-symlinks.sh"
else
    echo "❌ Error: $SUBMODULE_DIR/setup-ai-symlinks.sh not found. Submodule may not have initialized correctly."
    exit 1
fi

# 4. Ensure a local projects folder exists
if [ ! -d "projects" ]; then
    echo "📁 Creating local projects folder..."
    mkdir projects
fi

echo ""
echo "✅ Installation/Update Complete!"

echo "-------------------------------------------------------"
echo "Your codebase is now AI-ready (Tools isolated in .sdlc)"
echo "-------------------------------------------------------"
echo "To begin, ask your AI agent to 'Run the sdlc-orchestrator'."
