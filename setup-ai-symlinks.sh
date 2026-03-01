#!/usr/bin/env bash
set -e

SHARED_DIR=".shared-ai"

# Create shared base directories if they don't exist
mkdir -p "$SHARED_DIR/skills" "$SHARED_DIR/agents" "$SHARED_DIR/commands" "$SHARED_DIR/hooks"

# Helper function to create symlinks with correct relative paths
create_symlinks() {
    local target_base="$1"
    shift
    local subdirs=("$@")

    mkdir -p "$target_base"
    
    # Calculate relative prefix based on the number of slashes in target_base
    local rel_prefix="../"
    local slashes="${target_base//[^\/]}"
    for ((i=0; i<${#slashes}; i++)); do
        rel_prefix="../${rel_prefix}"
    done

    for dir in "${subdirs[@]}"; do
        local link_path="$target_base/$dir"
        local target_path="${rel_prefix}${SHARED_DIR}/${dir}"
        
        # If symlink doesn't exist, create it
        if [ ! -e "$link_path" ] && [ ! -L "$link_path" ]; then
            echo "Linking $link_path -> $target_path"
            ln -s "$target_path" "$link_path"
        elif [ -L "$link_path" ]; then
            # Symlink already exists, skipping quietly
            :
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
