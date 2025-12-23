#!/usr/bin/env bash
# Show doc-audience breakdown for a repository
# Usage: ./stats.sh [directory]

set -euo pipefail

DIR="${1:-.}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Counters
human_preserve=0
human_editable=0
ai_docs=0
untagged=0

# Find all markdown files
while IFS= read -r -d '' file; do
    first_line=$(head -n1 "$file" 2>/dev/null || echo "")

    if [[ "$first_line" =~ \<\!--[[:space:]]*doc-audience:[[:space:]]*human[[:space:]]*,[[:space:]]*preserve-voice[[:space:]]*--\> ]]; then
        ((human_preserve++))
    elif [[ "$first_line" =~ \<\!--[[:space:]]*doc-audience:[[:space:]]*human[[:space:]]*,[[:space:]]*ai-editable[[:space:]]*--\> ]]; then
        ((human_editable++))
    elif [[ "$first_line" =~ \<\!--[[:space:]]*doc-audience:[[:space:]]*human[[:space:]]*--\> ]]; then
        ((human_preserve++))  # Default for human without modifier
    elif [[ "$first_line" =~ \<\!--[[:space:]]*doc-audience:[[:space:]]*ai[[:space:]]*--\> ]]; then
        ((ai_docs++))
    else
        ((untagged++))
    fi
done < <(find "$DIR" -type f \( -name "*.md" -o -name "*.mdx" \) -print0 2>/dev/null) || true

total=$((human_preserve + human_editable + ai_docs + untagged))

echo ""
echo "📚 Doc-Audience Stats for: $DIR"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
printf "${GREEN}Human (preserve-voice):${NC} %3d\n" "$human_preserve"
printf "${BLUE}Human (ai-editable):${NC}    %3d\n" "$human_editable"
printf "${YELLOW}AI docs:${NC}                %3d\n" "$ai_docs"
printf "${RED}Untagged:${NC}               %3d\n" "$untagged"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
printf "Total:                  %3d\n" "$total"
echo ""

if [[ $untagged -gt 0 ]]; then
    echo "⚠️  $untagged files without doc-audience tags"
    echo ""
fi
