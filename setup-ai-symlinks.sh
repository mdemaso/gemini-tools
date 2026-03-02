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

# Helper to symlink whole folder
link_folder() {
    local target="$1"
    local source="${REL_BASE}/${target}"
    
    echo "📂 Linking AI config: $target -> $source"
    
    # If it's .github/copilot, we need to make sure the parents exist
    mkdir -p "$(dirname "$target")"
    
    if [ ! -L "$target" ] && [ ! -d "$target" ]; then
        ln -s "$source" "$target"
    elif [ -L "$target" ]; then
        ln -sf "$source" "$target"
    else
        echo "  ⚠️ Warning: $target exists and is not a symlink. Skipping."
    fi
}

# Symlink the entire AI-specific folders
link_folder ".gemini"
link_folder ".claude"
link_folder ".github/copilot"

echo "✅ Parent project now points to SDLC tool folders."
