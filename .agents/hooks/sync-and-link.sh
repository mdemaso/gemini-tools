#!/usr/bin/env bash
# Sync and Link Hook
# Verifies proxy files, pulls the latest version of the tools, and sets up configuration symlinks.
set -e

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
# Tools root is 2 levels up from hooks/ in the merged structure
TOOLS_ROOT="$( cd "$SCRIPT_DIR/../.." && pwd )"
CURRENT_DIR="$(pwd)"

# Calculate relative path from $1 (target) to $2 (current) using pure shell
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

# 1. Sync from remote
echo "🔄 Checking for tool updates..."

# Identify the project root and current tools location
PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)

# Try to find if we are running as a submodule and update accordingly
SUBMODULE_PATH=$(cd "$PROJECT_ROOT" && git submodule foreach --quiet 'if [ "$PWD" = "'"$TOOLS_ROOT"'" ]; then echo $sm_path; fi' 2>/dev/null | head -n 1)

if [ -n "$SUBMODULE_PATH" ]; then
    echo "  📦 Updating $SUBMODULE_PATH submodule..."
    (cd "$PROJECT_ROOT" && git submodule update --remote --init "$SUBMODULE_PATH" --quiet || true)
fi

# Also sync the tools repo itself if it has a remote
(
    cd "$TOOLS_ROOT"
    if git remote -v 2>/dev/null | grep -q "origin"; then
        git pull origin main --quiet --no-rebase 2>/dev/null || echo "  ⚠️  Warning: Could not sync tools with remote. Using local versions."
    fi
)

# 2. Setup configuration and symlinks
REL_BASE=$(get_relative_path "$TOOLS_ROOT" "$CURRENT_DIR")
echo "🔧 Tools Base: $REL_BASE"

# Link the .agents configuration folder
if [[ "$REL_BASE" != "." ]]; then
    echo "📂 Linking .agents configuration folder..."
    
    # Remove existing .agents if it's a symlink or directory
    if [ -L ".agents" ] || [ -d ".agents" ]; then
        rm -rf ".agents"
    fi
    
    ln -s "$REL_BASE/.agents" ".agents"
fi

# Generate tool-specific settings.json
write_gemini_settings() {
    local target=".gemini/settings.json"
    mkdir -p "$(dirname "$target")"
    cat > "$target" <<EOF
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": ".agents/hooks/sync-and-link.sh"
          }
        ]
      }
    ],
    "BeforeModel": [
      {
        "hooks": [
          {
            "type": "command",
            "command": ".agents/hooks/security-scan.sh"
          }
        ]
      }
    ]
  }
}
EOF
    echo "✅ Generated Gemini settings: $target"
}

write_claude_settings() {
    local target=".claude/settings.json"
    mkdir -p "$(dirname "$target")"
    cat > "$target" <<EOF
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": ".agents/hooks/sync-and-link.sh"
          }
        ]
      }
    ],
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": ".agents/hooks/security-scan.sh"
          }
        ]
      }
    ]
  }
}
EOF
    echo "✅ Generated Claude settings: $target"
}

write_copilot_settings() {
    local target=".github/copilot/settings.json"
    mkdir -p "$(dirname "$target")"
    cat > "$target" <<EOF
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": ".agents/hooks/sync-and-link.sh"
          }
        ]
      }
    ]
  }
}
EOF
    echo "✅ Generated Copilot settings: $target"
}

# Execute generation
write_gemini_settings
write_claude_settings
write_copilot_settings

# 3. Generate Gemini command TOMLs
GENERATOR_SCRIPT="$TOOLS_ROOT/.agents/scripts/generate-gemini-commands.sh"
if [ -f "$GENERATOR_SCRIPT" ]; then
    bash "$GENERATOR_SCRIPT"
else
    echo "⚠️ Warning: Gemini command generator not found at $GENERATOR_SCRIPT"
fi

echo "✅ AI configurations synced and generated successfully."
