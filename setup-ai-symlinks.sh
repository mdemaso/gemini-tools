#!/usr/bin/env bash
set -e

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
# Calculate relative path from the current working directory to the script's directory
REL_BASE="$(realpath --relative-to="$(pwd)" "$SCRIPT_DIR")"

SHARED_DIR_NAME=".shared-ai"
SHARED_DIR_PATH="${REL_BASE}/${SHARED_DIR_NAME}"

# Create shared base directories if they don't exist
mkdir -p "$SHARED_DIR_PATH/skills" "$SHARED_DIR_PATH/agents" "$SHARED_DIR_PATH/commands" "$SHARED_DIR_PATH/hooks"

# Helper function to create symlinks with correct relative paths
create_symlinks() {
    local target_base="$1"
    shift
    local subdirs=("$@")

    mkdir -p "$target_base"
    
    # Calculate relative prefix to get back to the project root from target_base
    local to_root=""
    local slashes="${target_base//[^\/]}"
    for ((i=0; i<${#slashes}; i++)); do
        to_root="../${to_root}"
    done
    [ -z "$slashes" ] && to_root="./"

    for dir in "${subdirs[@]}"; do
        local link_path="$target_base/$dir"
        # The target path for the symlink should point to the .shared-ai directory inside the submodule/repo
        local target_path="${to_root}${REL_BASE}/${SHARED_DIR_NAME}/${dir}"
        
        # If symlink doesn't exist, create it
        if [ ! -e "$link_path" ] && [ ! -L "$link_path" ]; then
            echo "Linking $link_path -> $target_path"
            ln -s "$target_path" "$link_path"
        elif [ -L "$link_path" ]; then
            # Symlink already exists, update it to ensure it points to the right place
            ln -sf "$target_path" "$link_path"
        else
            echo "Warning: $link_path exists and is not a symlink. Skipping."
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
