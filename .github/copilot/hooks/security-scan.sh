#!/usr/bin/env bash
# Wrapper for shared SDLC hook
exec "$(dirname "$0")/../../../.shared-ai/hooks/security-scan.sh" "$@"
