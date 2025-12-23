#!/usr/bin/env bash
# Claude Code pre-edit hook for ai-human-docs
# Warns before editing files with preserve-voice tag
#
# Installation:
#   1. Copy this file to your repo's .claude/hooks/pre-edit.sh
#   2. Make it executable: chmod +x .claude/hooks/pre-edit.sh
#   3. The hook runs automatically before Edit tool calls

set -euo pipefail

# Get the file being edited from the first argument
FILE="${1:-}"

if [[ -z "$FILE" || ! -f "$FILE" ]]; then
    exit 0
fi

# Check first line for doc-audience tag
first_line=$(head -n1 "$FILE" 2>/dev/null || echo "")

if [[ "$first_line" =~ \<\!--[[:space:]]*doc-audience:[[:space:]]*human[[:space:]]*,[[:space:]]*preserve-voice[[:space:]]*--\> ]]; then
    echo "⚠️  WARNING: This file has <!-- doc-audience: human, preserve-voice -->" >&2
    echo "   AI agents should NOT edit, expand, or rephrase this document." >&2
    echo "   Consider creating a separate AI-audience version instead." >&2
    echo "" >&2
fi

# Check for human without modifier (defaults to preserve-voice)
if [[ "$first_line" =~ \<\!--[[:space:]]*doc-audience:[[:space:]]*human[[:space:]]*--\> ]] && \
   [[ ! "$first_line" =~ ai-editable ]]; then
    echo "⚠️  WARNING: This file has <!-- doc-audience: human -->" >&2
    echo "   Default behavior is preserve-voice. AI should NOT edit." >&2
    echo "" >&2
fi

exit 0
