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
    local is_internal=false

    # Check if we are running inside the gemini-tools repo itself
    if [ -d "$source_folder" ] && [ -d "$target_folder" ] && [ "$source_folder" -ef "$target_folder" ]; then
        is_internal=true
    fi

    echo "📂 Setting up AI proxies for $target_folder..."

    # If the target exists as a symlink, remove it
    if [ -L "$target_folder" ]; then
        echo "  🗑 Removing symlink: $target_folder"
        rm "$target_folder"
    fi

    # Create real directories
    mkdir -p "$target_folder/skills" "$target_folder/hooks"

    # 1. Sync Settings (if they exist in source)
    if [ -f "$source_folder/settings.json" ] && [ "$is_internal" = false ]; then
        cp -n "$source_folder/settings.json" "$target_folder/" || true
    fi

    # 2. Process Skills (Source of truth is .shared-ai/skills)
    local shared_skills_dir="${SCRIPT_DIR}/.shared-ai/skills"
    if [ -d "$shared_skills_dir" ]; then
        for skill_dir in "$shared_skills_dir"/*; do
            [ -d "$skill_dir" ] || continue
            local skill_name=$(basename "$skill_dir")
            local target_bridge="$target_folder/skills/${skill_name}.md"
            
            # Calculate the relative path back to the shared skill
            # For .gemini/.claude it is ../../
            # For .github/copilot it is ../../../
            local depth=2
            [[ "$target_folder" == *"/"* ]] && depth=3
            
            local to_shared=""
            for ((i=0; i<$depth; i++)); do to_shared="../${to_shared}"; done
            
            local shared_path="${to_shared}${REL_BASE}/.shared-ai/skills/${skill_name}/SKILL.md"
            # Remove redundant ./ if REL_BASE is .
            shared_path=$(echo "$shared_path" | sed 's|/\./|/|g')

            echo "  🔗 Bridging skill: $skill_name"
            cat <<EOF > "$target_bridge"
# Bridge: ${skill_name}
This is a bridge to the shared AI skill instructions.
To use this skill, you MUST read and follow the full instructions at:
${shared_path}
EOF
        done
    fi

    # 3. Process Hooks (Source of truth is .shared-ai/hooks)
    local shared_hooks_dir="${SCRIPT_DIR}/.shared-ai/hooks"
    if [ -d "$shared_hooks_dir" ]; then
        for hook_file in "$shared_hooks_dir"/*.sh; do
            [ -f "$hook_file" ] || continue
            local hook_name=$(basename "$hook_file")
            local target_hook="$target_folder/hooks/${hook_name}"
            
            local depth=2
            [[ "$target_folder" == *"/"* ]] && depth=3
            
            local to_shared=""
            for ((i=0; i<$depth; i++)); do to_shared="../${to_shared}"; done
            
            local shared_path="${to_shared}${REL_BASE}/.shared-ai/hooks/${hook_name}"
            shared_path=$(echo "$shared_path" | sed 's|/\./|/|g')

            echo "  🔗 Wrapping hook: $hook_name"
            cat <<EOF > "$target_hook"
#!/usr/bin/env bash
# Wrapper for shared SDLC hook
exec "\$(dirname "\$0")/${shared_path}" "\$@"
EOF
            chmod +x "$target_hook"
        done
    fi
}

# Run setup for each tool
setup_tool_proxies ".gemini"
setup_tool_proxies ".claude"
setup_tool_proxies ".github/copilot"

echo "✅ AI agent proxy files (REAL files) initialized successfully."
