#!/usr/bin/env bash
# Generate Gemini TOML commands from Markdown sources
set -e

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
# Default project root is 2 levels up from scripts/ (the tools repo root)
TOOLS_ROOT="$( cd "$SCRIPT_DIR/../.." && pwd )"
# If an argument is provided, use it as the target project root
PROJECT_ROOT="${1:-$TOOLS_ROOT}"

SOURCE_DIR="$TOOLS_ROOT/.agents/commands"
TARGET_DIR="$PROJECT_ROOT/.gemini/commands"

mkdir -p "$TARGET_DIR"

echo "🛠️  Generating Gemini commands from Markdown sources..."

# Find all .md files in the source directory
find "$SOURCE_DIR" -name "*.md" | while read -r md_file; do
    filename=$(basename "$md_file")
    command_name="${filename%.md}"
    toml_file="$TARGET_DIR/${command_name}.toml"
    
    # Extract description from YAML frontmatter (between first two ---)
    # This sed command finds the line containing 'description:' between the first and second '---'
    description=$(sed -n '/^---$/,/^---$/p' "$md_file" | grep "^description:" | sed 's/^description:[[:space:]]*//' | sed 's/^"//;s/"$//' | sed "s/^'//;s/'$//" || echo "SDLC Command: $command_name")

    if [ -z "$description" ]; then
        description="SDLC Command: $command_name"
    fi

    # Generate the TOML file
    cat > "$toml_file" <<EOF
description = "$description"
prompt = """
@{.agents/commands/$filename}

User Request/Arguments: {{args}}
"""
EOF
    echo "  ✅ Generated $toml_file"
done

echo "✅ Gemini command generation complete."
