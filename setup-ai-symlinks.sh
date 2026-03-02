#!/usr/bin/env bash
set -e

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
CURRENT_DIR="$(pwd)"

# Portable relative path calculation (macOS compatible)
python_rel_path() {
    python3 -c "import os; print(os.path.relpath('$1', '$2'))"
}

# Calculate REL_BASE
if command -v python3 &> /dev/null; then
    REL_BASE=$(python_rel_path "$SCRIPT_DIR" "$CURRENT_DIR")
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    REL_BASE=$(realpath --relative-to="$CURRENT_DIR" "$SCRIPT_DIR")
else
    if [[ "$SCRIPT_DIR" == *"$CURRENT_DIR/.sdlc"* ]]; then
        REL_BASE=".sdlc"
    else
        echo "Error: Could not calculate relative path."
        exit 1
    fi
fi

SHARED_DIR_NAME=".shared-ai"
SHARED_DIR_PATH="${REL_BASE}/${SHARED_DIR_NAME}"

echo "🔧 Using SDLC Tools Base: $REL_BASE"

# Helper to create proxy files
create_proxies() {
    local target_base="$1"
    local category="$2" # "skills", "hooks", "agents", "commands"
    
    echo "📂 Setting up proxies for $target_base/$category..."
    mkdir -p "$target_base/$category"
    
    local source_dir="${SHARED_DIR_PATH}/${category}"
    if [ ! -d "$source_dir" ]; then return; fi

    # Calculate depth to get back to root from target_base/category
    local depth=1
    local slashes="${target_base//[^\/]}"
    depth=$((${#slashes} + 2)) # +1 for target_base, +1 for category
    
    local to_root=""
    for ((i=0; i<$depth; i++)); do to_root="../${to_root}"; done

    for item in "$source_dir"/*; do
        [ -e "$item" ] || continue
        local name=$(basename "$item")
        
        case "$category" in
            hooks)
                if [[ "$name" == *.sh ]]; then
                    local proxy_path="${target_base}/${category}/${name}"
                    echo "  🔗 Creating script wrapper: $name"
                    echo "#!/usr/bin/env bash" > "$proxy_path"
                    echo "# Proxy for shared SDLC hook" >> "$proxy_path"
                    echo "exec \"\$(dirname \"\$0\")/${to_root}${REL_BASE}/${SHARED_DIR_NAME}/${category}/${name}\" \"\$@\"" >> "$proxy_path"
                    chmod +x "$proxy_path"
                fi
                ;;
            skills)
                if [ -d "$item" ]; then
                    local proxy_path="${target_base}/${category}/${name}.md"
                    echo "  🔗 Creating skill bridge: $name"
                    echo "# Bridge: ${name}" > "$proxy_path"
                    echo "This is a bridge to the shared AI skill instructions." >> "$proxy_path"
                    echo "To use this skill, you MUST read and follow the full instructions at:" >> "$proxy_path"
                    echo "${to_root}${REL_BASE}/${SHARED_DIR_NAME}/${category}/${name}/SKILL.md" >> "$proxy_path"
                fi
                ;;
            agents|commands)
                # Future expansion for agent/command definitions
                ;;
        esac
    done
}

# Process each AI tool
for tool_dir in ".gemini" ".claude" ".github/copilot"; do
    # Remove old symlinks if they exist to prevent conflicts
    for cat in "skills" "hooks" "agents" "commands"; do
        if [ -L "$tool_dir/$cat" ]; then
            echo "🗑 Removing old symlink: $tool_dir/$cat"
            rm "$tool_dir/$cat"
        fi
    done

    # Create new proxy files
    create_proxies "$tool_dir" "skills"
    create_proxies "$tool_dir" "hooks"
done

echo "✅ AI agent proxy files generated successfully."
