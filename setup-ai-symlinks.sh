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

# If we are running in the tool repo itself, REL_BASE is "."
# We only want to symlink if we are in a parent project
if [[ "$REL_BASE" != "." ]]; then
    echo "📂 Linking .agents configuration folder..."
    
    # Remove existing .agents if it's a symlink or directory
    if [ -L ".agents" ] || [ -d ".agents" ]; then
        rm -rf ".agents"
    fi
    
    ln -s "$REL_BASE/.agents" ".agents"
fi

# 2. Link only settings.json into tool-specific folders
# This avoids skill conflicts since agents scan both .agents and tool-specific folders
setup_tool_settings() {
    local target_folder="$1"
    if [ -d ".agents" ]; then
        echo "📂 Setting up tool-specific settings for $target_folder..."

        # Remove if it's a symlink (old strategy)
        if [ -L "$target_folder" ]; then
            rm "$target_folder"
        fi

        mkdir -p "$target_folder"

        # Calculate depth for the symlink back to .agents/settings.json
        local depth=1
        [[ "$target_folder" == *"/"* ]] && depth=2
        local to_agents=""
        for ((i=0; i<$depth; i++)); do to_agents="../${to_agents}"; done

        ln -sf "${to_agents}.agents/settings.json" "$target_folder/settings.json"
    fi
}

setup_tool_settings ".gemini"
setup_tool_settings ".claude"
setup_tool_settings ".github/copilot"

echo "✅ AI configurations linked successfully (settings only)."

