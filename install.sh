#!/usr/bin/env bash

# Remote Installation Script for Gemini/Claude Tools
# Usage: curl -sSL https://raw.githubusercontent.com/user/repo/main/install.sh | bash

set -e

REPO_URL="https://github.com/mdemaso/gemini-tools.git"
TEMP_DIR=".gemini-tools-temp"

echo "🚀 Installing Gemini/Claude SDLC Orchestration System..."

# 1. Clone the shared tools into a temporary directory
if [ -d "$TEMP_DIR" ]; then rm -rf "$TEMP_DIR"; fi
git clone --depth 1 "$REPO_URL" "$TEMP_DIR"

# 2. Copy the .shared-ai core into the current project
echo "📦 Copying .shared-ai core..."
cp -r "$TEMP_DIR/.shared-ai" .

# 3. Copy the symlink script
cp "$TEMP_DIR/setup-ai-symlinks.sh" .
chmod +x setup-ai-symlinks.sh

# 4. Copy base configuration for Gemini
if [ ! -d ".gemini" ]; then
    mkdir .gemini
    cp "$TEMP_DIR/.gemini/settings.json" .gemini/
fi

# 5. Run the symlink setup
echo "🔗 Setting up AI agent symlinks..."
./setup-ai-symlinks.sh

# 6. Cleanup
rm -rf "$TEMP_DIR"

echo ""
echo "✅ Installation Complete!"
echo "-------------------------------------------------------"
echo "Your codebase is now AI-ready with the following skills:"
ls .shared-ai/skills
echo "-------------------------------------------------------"
echo "To begin, ask your AI agent to 'Run the sdlc-orchestrator'."
