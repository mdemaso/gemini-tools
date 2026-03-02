#!/usr/bin/env bash
# Sync and Link Hook
# Verifies proxy files and pulls the latest version of the tools if in the gemini-tools repo.
set -e

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
# Setup script is two levels up from .shared-ai/hooks
SETUP_SCRIPT="$SCRIPT_DIR/../../setup-ai-symlinks.sh"

# 1. Sync from remote (only if this is the gemini-tools repository itself)
# We check if the root of the current git repo is the gemini-tools repo
if [ -f "setup-ai-symlinks.sh" ] && git remote -v 2>/dev/null | grep -q "gemini-tools.git"; then
    echo "🔄 Syncing with remote repository..."
    git pull origin main --quiet || echo "Warning: Could not sync with remote. Using local versions."
fi

# 2. Run the proxy setup script
if [ -f "$SETUP_SCRIPT" ]; then
    echo "🔗 Verifying AI proxies..."
    bash "$SETUP_SCRIPT"
else
    echo "Error: setup-ai-symlinks.sh not found at $SETUP_SCRIPT"
    exit 1
fi

echo "✅ System synchronized and verified."
