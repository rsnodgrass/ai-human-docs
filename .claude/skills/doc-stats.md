---
name: doc-stats
description: Show doc-audience breakdown for this repository
---

# Doc Stats Skill

Show the breakdown of documentation files by audience tag.

## Usage

Run /doc-stats to see how many files are tagged for each audience.

## Implementation

```bash
#!/usr/bin/env bash
# Find and count doc-audience tags

DIR="."
human_preserve=0
human_editable=0
ai_docs=0
untagged=0

while IFS= read -r -d '' file; do
    first_line=$(head -n1 "$file" 2>/dev/null || echo "")

    if [[ "$first_line" =~ doc-audience:.*human.*preserve-voice ]]; then
        ((human_preserve++))
    elif [[ "$first_line" =~ doc-audience:.*human.*ai-editable ]]; then
        ((human_editable++))
    elif [[ "$first_line" =~ doc-audience:.*human ]] && [[ ! "$first_line" =~ ai-editable ]]; then
        ((human_preserve++))
    elif [[ "$first_line" =~ doc-audience:.*ai ]]; then
        ((ai_docs++))
    else
        ((untagged++))
    fi
done < <(find "$DIR" -type f \( -name "*.md" -o -name "*.mdx" \) -print0 2>/dev/null)

echo "📚 Doc-Audience Stats"
echo "━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Human (preserve-voice): $human_preserve"
echo "Human (ai-editable):    $human_editable"
echo "AI docs:                $ai_docs"
echo "Untagged:               $untagged"
echo "━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Total:                  $((human_preserve + human_editable + ai_docs + untagged))"
```
