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

# 1. Link the .agents configuration folder
# This contains the hooks, skills, and shared references
if [[ "$REL_BASE" != "." ]]; then
    echo "📂 Linking .agents configuration folder..."
    
    # Remove existing .agents if it's a symlink or directory
    if [ -L ".agents" ] || [ -d ".agents" ]; then
        rm -rf ".agents"
    fi
    
    ln -s "$REL_BASE/.agents" ".agents"
fi

# 2. Generate tool-specific settings.json
# Instead of a single shared file, we generate the format needed for each tool.

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
    # Currently uses a format compatible with our generic structure
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

# TODO: Add OpenAI Codex settings generation once it supports hooks
# write_codex_settings() { ... }

# Execute generation
write_gemini_settings
write_claude_settings
write_copilot_settings

# 3. Generate Gemini command TOMLs from Markdown sources
# This ensures that our cross-agent SDLC commands are available as slash commands in Gemini
GENERATOR_SCRIPT="$SCRIPT_DIR/.agents/scripts/generate-gemini-commands.sh"
if [ -f "$GENERATOR_SCRIPT" ]; then
    bash "$GENERATOR_SCRIPT"
else
    echo "⚠️ Warning: Gemini command generator not found at $GENERATOR_SCRIPT"
fi

echo "✅ AI configurations generated successfully."
