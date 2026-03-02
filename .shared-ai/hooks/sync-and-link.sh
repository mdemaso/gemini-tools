#!/usr/bin/env bash
# Sync and Link Hook
# Verifies proxy files and pulls the latest version of the tools if in the gemini-tools repo.
set -e

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
# Setup script is two levels up from .shared-ai/hooks
TOOLS_ROOT="$( cd "$SCRIPT_DIR/../.." && pwd )"
SETUP_SCRIPT="$TOOLS_ROOT/setup-ai-symlinks.sh"

# 1. Sync from remote
# We cd into the tools root to ensure git commands run against the tools repository
echo "🔄 Checking for tool updates..."
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

echo "✅ System synchronized and verified."
