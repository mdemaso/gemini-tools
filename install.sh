#!/usr/bin/env bash

# Remote Installation Script for Gemini/Claude Tools
# Usage: curl -sSL https://raw.githubusercontent.com/mdemaso/gemini-tools/main/install.sh | bash

set -e

REPO_URL="https://github.com/mdemaso/gemini-tools.git"
SUBMODULE_DIR=".sdlc"

echo "🚀 Installing Gemini/Claude SDLC Orchestration System..."

# 1. Ensure we are in a git repository
if [ ! -d ".git" ]; then
    echo "📦 Initializing a new git repository..."
    git init
fi

# 2. Add or update the submodule
if [ -d "$SUBMODULE_DIR" ]; then
    echo "Info: $SUBMODULE_DIR already exists. Forcing update to latest main..."
    
    # Sync submodule configuration
    git submodule sync --quiet "$SUBMODULE_DIR"
    
    # Ensure it is initialized
    git submodule update --init --recursive "$SUBMODULE_DIR"
    
    # Force fetch and reset to origin/main inside the submodule
    (
        cd "$SUBMODULE_DIR"
        git fetch origin main --quiet
        git checkout -B main origin/main --quiet
        git reset --hard origin/main --quiet
        git pull origin main --quiet # Extra insurance
    )
    
    # Update the parent's tracking branch config
    git config -f .gitmodules "submodule.$SUBMODULE_DIR.branch" main || true
else
    echo "📦 Adding gemini-tools submodule tracking main branch..."
    # Clear any stale index entries or directories
    git rm -r --cached "$SUBMODULE_DIR" 2>/dev/null || true
    rm -rf "$SUBMODULE_DIR"
    
    git submodule add --force -b main "$REPO_URL" "$SUBMODULE_DIR"
    git submodule update --init --recursive "$SUBMODULE_DIR"
fi

# 3. Verify the setup script exists before running
# This script handles all symlinks, AI settings, and command generation.
if [ -f "$SUBMODULE_DIR/.agents/hooks/sync-and-link.sh" ]; then
    echo "🔗 Running core setup and configuration..."
    bash "$SUBMODULE_DIR/.agents/hooks/sync-and-link.sh"
else
    echo "❌ Error: $SUBMODULE_DIR/.agents/hooks/sync-and-link.sh not found. Submodule may not have initialized correctly."
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
echo "To begin, ask your AI agent to 'Run the sdlc-orchestrator' or use '/init-sdlc'."
