#!/usr/bin/env bash
set -e

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
CURRENT_DIR="$(pwd)"

# Portable relative path calculation (macOS compatible)
python_rel_path() {
    python3 -c "import os; print(os.path.relpath('$1', '$2'))"
}

# Try to calculate REL_BASE
if command -v python3 &> /dev/null; then
    REL_BASE=$(python_rel_path "$SCRIPT_DIR" "$CURRENT_DIR")
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    REL_BASE=$(realpath --relative-to="$CURRENT_DIR" "$SCRIPT_DIR")
else
    # Fallback: if we are running from the root and script is in .sdlc
    if [[ "$SCRIPT_DIR" == *"$CURRENT_DIR/.sdlc"* ]]; then
        REL_BASE=".sdlc"
    else
        echo "Error: Could not calculate relative path. Please install python3 or coreutils."
        exit 1
    fi
fi

SHARED_DIR_NAME=".shared-ai"
SHARED_DIR_PATH="${REL_BASE}/${SHARED_DIR_NAME}"

echo "🔧 Using base: $REL_BASE"

# Create shared base directories if they don't exist
mkdir -p "$SHARED_DIR_PATH/skills" "$SHARED_DIR_PATH/agents" "$SHARED_DIR_PATH/commands" "$SHARED_DIR_PATH/hooks"

# Helper function to create symlinks with correct relative paths
create_symlinks() {
    local target_base="$1"
    shift
    local subdirs=("$@")

    echo "📂 Setting up $target_base..."
    mkdir -p "$target_base"
    
    # Calculate relative prefix to get back to the project root from target_base
    local to_root="../"
    local slashes="${target_base//[^\/]}"
    for ((i=0; i<${#slashes}; i++)); do
        to_root="../${to_root}"
    done

    for dir in "${subdirs[@]}"; do
        local link_path="$target_base/$dir"
        local target_path="${to_root}${REL_BASE}/${SHARED_DIR_NAME}/${dir}"
        
        echo "  🔗 Linking $dir..."
        # If symlink doesn't exist, create it
        if [ ! -e "$link_path" ] && [ ! -L "$link_path" ]; then
            ln -s "$target_path" "$link_path"
        elif [ -L "$link_path" ]; then
            # Symlink already exists, update it
            ln -sf "$target_path" "$link_path"
        else
            echo "  ⚠️ Warning: $link_path exists and is not a symlink. Skipping."
        fi
    done
}

# Set up for Gemini CLI
create_symlinks ".gemini" "skills" "agents" "commands" "hooks"

# Set up for Claude Code
create_symlinks ".claude" "skills" "agents" "commands" "hooks"

# Set up for Github Copilot / Codex
create_symlinks ".github/copilot" "skills" "agents" "commands" "hooks"

echo "✅ AI agent configurations symlinked successfully."
