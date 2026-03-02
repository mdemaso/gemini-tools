#!/usr/bin/env bash
set -e

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
CURRENT_DIR="$(pwd)"

# Calculate REL_BASE relative to the current project root
python_rel_path() {
    python3 -c "import os; print(os.path.relpath('$1', '$2'))"
}

# Portable relative path calculation (macOS compatible)
if command -v python3 &> /dev/null; then
    REL_BASE=$(python_rel_path "$SCRIPT_DIR" "$CURRENT_DIR")
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    REL_BASE=$(realpath --relative-to="$CURRENT_DIR" "$SCRIPT_DIR")
else
    # Fallback to .sdlc if we are running in a project root
    REL_BASE=".sdlc"
fi

echo "🔧 Tools Base: $REL_BASE"

# Helper to copy proxy/bridge files as REAL files
# This removes the top-level symlinks and replaces them with real folders/files
setup_tool_proxies() {
    local target_folder="$1" # e.g., .gemini
    local source_folder="${SCRIPT_DIR}/${target_folder}"

    echo "📂 Setting up real proxy files for $target_folder..."

    # If the target exists as a symlink, remove it
    if [ -L "$target_folder" ]; then
        echo "  🗑 Removing symlink: $target_folder"
        rm "$target_folder"
    fi

    # Create real directories
    mkdir -p "$target_folder/skills" "$target_folder/hooks"

    # Copy Bridge/Wrapper files from the submodule repo to the parent repo
    # We use -n to not overwrite settings.json if it exists, but -f for skills/hooks
    if [ -f "$source_folder/settings.json" ]; then
        cp -n "$source_folder/settings.json" "$target_folder/" || true
    fi

    # Process Skills
    if [ -d "$source_folder/skills" ]; then
        for f in "$source_folder/skills"/*.md; do
            [ -e "$f" ] || continue
            cp -f "$f" "$target_folder/skills/"
        done
    fi

    # Process Hooks
    if [ -d "$source_folder/hooks" ]; then
        for f in "$source_folder/hooks"/*.sh; do
            [ -e "$f" ] || continue
            cp -f "$f" "$target_folder/hooks/"
            chmod +x "$target_folder/hooks/$(basename "$f")"
        done
    fi
}

# Run setup for each tool
setup_tool_proxies ".gemini"
setup_tool_proxies ".claude"
setup_tool_proxies ".github/copilot"

echo "✅ AI agent proxy files (REAL files) initialized successfully."
