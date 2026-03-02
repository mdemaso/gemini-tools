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

# Helper to copy proxy/bridge files as REAL files
# This removes the top-level symlinks and replaces them with real folders/files
setup_tool_proxies() {
    local target_folder="$1" # e.g., .gemini
    local source_folder="${SCRIPT_DIR}/${target_folder}"

    # If the source and target folders are the same, we are likely running in the tool repo itself
    if [ -d "$source_folder" ] && [ -d "$target_folder" ] && [ "$source_folder" -ef "$target_folder" ]; then
        echo "⏭ Skipping $target_folder (source and target are the same)"
        return
    fi

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
