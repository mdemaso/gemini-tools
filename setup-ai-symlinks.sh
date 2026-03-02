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

# 1. Setup the primary .agents configuration folder
if [[ "$REL_BASE" != "." ]]; then
    echo "📂 Linking .agents configuration folder..."

    # Remove existing .agents if it's a symlink or directory
    if [ -L ".agents" ] || [ -d ".agents" ]; then
        rm -rf ".agents"
    fi

    ln -s "$REL_BASE/.agents" ".agents"
fi

# 2. Link tool discovery folders (.gemini, .claude, .github/copilot) to .agents
if [ -d ".agents" ]; then
    echo "🔗 Linking tool discovery folders (.gemini, .claude) -> .agents"
    ln -sf ".agents" ".gemini"
    ln -sf ".agents" ".claude"

    echo "🔗 Linking .github/copilot -> .agents"
    mkdir -p .github
    ln -sf "../.agents" ".github/copilot"
fi

echo "✅ AI configurations linked successfully."

