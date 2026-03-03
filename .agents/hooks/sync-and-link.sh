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

# Identify the project root and current tools location
PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)

# Try to find if we are running as a submodule and update accordingly
# We use git submodule foreach to accurately find which submodule matches our TOOLS_ROOT
SUBMODULE_PATH=$(cd "$PROJECT_ROOT" && git submodule foreach --quiet 'if [ "$PWD" = "'"$TOOLS_ROOT"'" ]; then echo $sm_path; fi' 2>/dev/null | head -n 1)

if [ -n "$SUBMODULE_PATH" ]; then
    echo "  📦 Updating $SUBMODULE_PATH submodule..."
    (cd "$PROJECT_ROOT" && git submodule update --remote --init "$SUBMODULE_PATH" --quiet || true)
fi

# Also sync the tools repo itself if it has a remote, ensuring we get the latest from main
(
    cd "$TOOLS_ROOT"
    if git remote -v 2>/dev/null | grep -q "origin"; then
        # Try to pull latest from main. This works for both standalone and submodule (on branch).
        # We use origin main specifically as requested.
        git pull origin main --quiet --no-rebase 2>/dev/null || echo "  ⚠️  Warning: Could not sync tools with remote. Using local versions."
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
