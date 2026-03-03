#!/usr/bin/env bash
# Shared Security Scan Hook
# Scans input context for potential secrets, API keys, and sensitive patterns.

# Receive JSON input from stdin
INPUT=$(cat)

# Extract the message content (this depends on the hook type and JSON structure)
# For simplicity, we'll scan the entire input JSON for common secret patterns.

# Basic patterns for AWS keys, Generic API keys, and private keys
PATTERNS=(
  "AKIA[0-9A-Z]{16}"                    # AWS Access Key ID
  "SG\.[0-9a-zA-Z._-]{22,64}"           # SendGrid API Key
  "-----BEGIN (RSA|EC|DSA|OPENSSH) PRIVATE KEY-----" # Private Keys
  "sk_live_[0-9a-zA-Z]{24}"             # Stripe Live Key
)

for pattern in "${PATTERNS[@]}"; do
  if echo "$INPUT" | grep -qE "$pattern"; then
    # Detect the caller
    # Claude passes hook_event_name (e.g., UserPromptSubmit)
    if echo "$INPUT" | grep -q "hook_event_name"; then
        # Claude format
        echo '{"decision": "block", "reason": "Potential secret or API key detected in context. Blocked for security."}'
    else
        # Default/Gemini format
        echo '{"decision": "deny", "message": "Potential secret or API key detected in context. Blocked for security."}'
    fi
    exit 0
  fi
done

# If no secrets found, allow the action
echo '{"decision": "allow"}'
