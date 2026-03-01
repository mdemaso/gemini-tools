#!/usr/bin/env bash
# Sync and Link Hook
# Verifies symlinks and pulls the latest version of the tools if in the gemini-tools repo.
set -e

# 1. Sync from remote (only if this is the gemini-tools repository)
if git remote -v | grep -q "gemini-tools.git"; then
    echo "🔄 Syncing with remote repository..."
    git pull origin main --quiet || echo "Warning: Could not sync with remote. Using local versions."
fi

# 2. Run the symlink setup script
if [ -f "./setup-ai-symlinks.sh" ]; then
    echo "🔗 Verifying AI symlinks..."
    ./setup-ai-symlinks.sh
else
    echo "Error: setup-ai-symlinks.sh not found."
    exit 1
fi

echo "✅ System synchronized and verified."
