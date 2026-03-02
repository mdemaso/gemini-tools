#!/usr/bin/env bash
set -e

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
CURRENT_DIR="$(pwd)"

# Calculate relative path from $2 to $1 using pure shell
get_relative_path() {
    local target="$1"
    local current="$2"
    local common_part="$current"
    local result=""

    # Remove trailing slashes
    target="${target%/}"
    current="${current%/}"
    common_part="${common_part%/}"

    if [[ "$target" == "$current" ]]; then
        echo "."
        return
    fi

    while [[ "${target#$common_part}" == "$target" && "$common_part" != "/" ]]; do
        common_part=$(dirname "$common_part")
        result="../$result"
    done

    local forward_part="${target#$common_part}"
    forward_part="${forward_part#/}"

    if [[ -n "$result" && -n "$forward_part" ]]; then
        echo "${result}${forward_part}"
    elif [[ -n "$result" ]]; then
        echo "${result%/}"
    else
        echo "${forward_part:-.}"
    fi
}

# Portable relative path calculation
REL_BASE=$(get_relative_path "$SCRIPT_DIR" "$CURRENT_DIR")

echo "🔧 Tools Base: $REL_BASE"

# Helper to create symlinks for individual items
# target_folder: e.g. .agents
# category: e.g. skills, hooks, agents, commands
setup_category_symlinks() {
    local target_folder="$1"
    local category="$2"
    local source_dir="${SCRIPT_DIR}/.shared-ai/${category}"
    local target_dir="${target_folder}/${category}"

    if [ ! -d "$source_dir" ]; then return; fi

    echo "  📂 Linking $category..."
    mkdir -p "$target_dir"

    # Calculate depth to get back to root from target_dir
    local depth=2 # base depth for .agents/skills
    [[ "$target_folder" == *"/"* ]] && depth=3 # e.g. .github/copilot/skills

    local to_root=""
    for ((i=0; i<$depth; i++)); do to_root="../${to_root}"; done

    for item in "$source_dir"/*; do
        [ -e "$item" ] || continue
        local name=$(basename "$item")
        local rel_target_path="${to_root}${REL_BASE}/.shared-ai/${category}/${name}"
        
        # Clean up path (remove redundant ./ if REL_BASE is .)
        rel_target_path=$(echo "$rel_target_path" | sed 's|/\./|/|g')

        # For skills, if it's a directory containing SKILL.md, we can either link the dir 
        # or link SKILL.md as {name}.md. Linking as {name}.md is often better for discovery.
        if [ "$category" == "skills" ] && [ -d "$item" ] && [ -f "$item/SKILL.md" ]; then
            ln -sf "${rel_target_path}/SKILL.md" "${target_dir}/${name}.md"
        else
            ln -sf "$rel_target_path" "${target_dir}/${name}"
        fi
    done
}

setup_tool_configs() {
    local target_folder="$1" # e.g., .agents
    local source_folder="${SCRIPT_DIR}/${target_folder}"

    # If the source and target folders are the same, we are likely running in the tool repo itself
    local is_internal=false
    if [ -d "$source_folder" ] && [ -d "$target_folder" ] && [ "$source_folder" -ef "$target_folder" ]; then
        is_internal=true
    fi

    echo "📂 Setting up AI configurations for $target_folder..."

    # If the target exists as a symlink (old strategy), remove it
    if [ -L "$target_folder" ]; then
        echo "  🗑 Removing top-level symlink: $target_folder"
        rm "$target_folder"
    fi

    # Create target folder if it doesn't exist
    mkdir -p "$target_folder"

    # 1. Sync Settings (if they exist in source and NOT already in target)
    if [ -f "$source_folder/settings.json" ] && [ "$is_internal" = false ]; then
        if [ ! -f "$target_folder/settings.json" ]; then
            cp "$source_folder/settings.json" "$target_folder/"
        fi
    fi

    # 2. Symlink each category
    setup_category_symlinks "$target_folder" "skills"
    setup_category_symlinks "$target_folder" "hooks"
    setup_category_symlinks "$target_folder" "agents"
    setup_category_symlinks "$target_folder" "commands"
}

# Run setup
if [ -n "$1" ]; then
    setup_tool_configs "$1"
else
    # 1. Setup the primary .agents folder
    setup_tool_configs ".agents"
    
    # 2. Setup Copilot if it exists
    setup_tool_configs ".github/copilot"

    # 3. Create symlinks for tool-specific discovery
    if [ -d ".agents" ]; then
        echo "🔗 Linking tool-specific discovery folders (.gemini, .claude)..."
        ln -sf ".agents" ".gemini"
        ln -sf ".agents" ".claude"
    fi
fi

echo "✅ AI agent configurations linked successfully."
