#!/usr/bin/env bash
# Sync and Link Hook
# Verifies proxy files and pulls the latest version of the tools if in the gemini-tools repo.
set -e

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
# Tools root is 2 levels up from hooks/ in the merged structure
TOOLS_ROOT="$( cd "$SCRIPT_DIR/../.." && pwd )"
SETUP_SCRIPT="$TOOLS_ROOT/setup-ai-symlinks.sh"

# 1. Sync from remote
echo "🔄 Checking for tool updates..."

# If we are in a parent project that uses the .sdlc submodule
if [ -d ".sdlc" ] && ([ -d ".sdlc/.git" ] || [ -f ".sdlc/.git" ]); then
    echo "  📦 Updating .sdlc submodule..."
    git submodule update --remote --init .sdlc --quiet || true
fi

# Also sync the tools repo itself if we are inside it or it's standalone
(
    cd "$TOOLS_ROOT"
    if git remote -v 2>/dev/null | grep -q "gemini-tools.git"; then
        # Try to pull latest from main. This works whether it is a standalone repo or a submodule.
        git pull origin main --quiet --no-rebase || echo "Warning: Could not sync with remote. Using local versions."
    fi
)

# 2. Run the proxy setup script
if [ -f "$SETUP_SCRIPT" ]; then
    echo "🔗 Verifying AI configurations..."
    bash "$SETUP_SCRIPT" "$@"
else
    echo "Error: setup-ai-symlinks.sh not found at $SETUP_SCRIPT"
    exit 1
fi
