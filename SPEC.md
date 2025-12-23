<!-- doc-audience: ai -->

# ai-human-docs Specification

**Version:** 1.0.0
**Status:** Stable
**Last Updated:** 2024

This specification defines the **ai-human-docs** standard for tagging documentation files by intended audience (human or AI) and editing permissions.

---

## 1. Overview

The ai-human-docs standard provides:

1. **Audience tagging** — Mark files as intended for humans or AI
2. **Edit permissions** — Control whether AI agents may modify content
3. **Voice preservation** — Protect human-crafted documentation from AI expansion
4. **Machine parseability** — Enable tooling to enforce boundaries automatically

---

## 2. Terminology

| Term | Definition |
|------|------------|
| **Audience** | The intended reader: `human` or `ai` |
| **Modifier** | Additional constraint: `preserve-voice` or `ai-editable` |
| **Tag** | The complete audience + modifier declaration |
| **Protected document** | Any file tagged `human, preserve-voice` or `human` without modifier |
| **Editable document** | Any file tagged `ai` or `human, ai-editable` |

---

## 3. Syntax

Two formats are supported. Both are valid. Use whichever fits your workflow.

### 3.1 HTML Comment Format (Recommended)

```html
<!-- doc-audience: <audience>[, <modifier>] -->
```

**Placement:** MUST appear on **line 1** of the file, before any other content.

**Examples:**
```html
<!-- doc-audience: human, preserve-voice -->
<!-- doc-audience: human, ai-editable -->
<!-- doc-audience: human -->
<!-- doc-audience: ai -->
```

### 3.2 YAML Frontmatter Format

```yaml
---
doc-audience: <audience>
preserve-voice: <boolean>
---
```

**Placement:** MUST start on **line 1** of the file.

**Examples:**
```yaml
---
doc-audience: human
preserve-voice: true
---
```

```yaml
---
doc-audience: ai
---
```

### 3.3 Format Selection Guide

| Scenario | Recommended Format |
|----------|-------------------|
| Plain markdown, no frontmatter | HTML comment |
| Already using YAML frontmatter | YAML frontmatter |
| Static site generators (Jekyll, Hugo) | YAML frontmatter |
| MDX files | YAML frontmatter |
| Maximum portability | HTML comment |

---

## 4. Valid Values

### 4.1 Audiences

| Value | Description |
|-------|-------------|
| `human` | Documentation for human readers. Concise, narrative, scannable. |
| `ai` | Documentation for AI agents. Verbose, explicit, redundant. |

### 4.2 Modifiers

| Value | Applies To | Description |
|-------|------------|-------------|
| `preserve-voice` | `human` | AI MUST NOT edit. Protected. |
| `ai-editable` | `human` | AI MAY edit, but MUST preserve concise voice. |

### 4.3 Defaults

| Condition | Default Behavior |
|-----------|------------------|
| `human` with no modifier | Treat as `preserve-voice` |
| `ai` with no modifier | Fully editable |
| No tag | Ask before editing |

---

## 5. Precedence Rules

The explicit tag in the file is definitive. When no tag exists, ask before editing.

**Modifier precedence:**

```
preserve-voice > ai-editable > (no modifier)
```

If a file is tagged `human` with no modifier, treat as `preserve-voice` (safe default).

---

## 6. JSON Schema

For tooling that needs structured representation:

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "DocAudience",
  "type": "object",
  "required": ["audience"],
  "properties": {
    "audience": {
      "type": "string",
      "enum": ["human", "ai"],
      "description": "The intended reader of this document"
    },
    "modifier": {
      "type": "string",
      "enum": ["preserve-voice", "ai-editable"],
      "description": "Edit permission modifier (human docs only)"
    },
    "preserve_voice": {
      "type": "boolean",
      "description": "Whether AI is prohibited from editing",
      "default": true
    },
    "ai_editable": {
      "type": "boolean",
      "description": "Whether AI may edit while preserving voice",
      "default": false
    }
  },
  "if": {
    "properties": { "audience": { "const": "human" } }
  },
  "then": {
    "properties": {
      "preserve_voice": { "default": true }
    }
  }
}
```

**Parsed output example:**

```json
{
  "audience": "human",
  "modifier": "preserve-voice",
  "preserve_voice": true,
  "ai_editable": false
}
```

---

## 7. Regex Patterns

### 7.1 HTML Comment Pattern

```regex
^<!--\s*doc-audience:\s*(human|ai)(?:\s*,\s*(preserve-voice|ai-editable))?\s*-->
```

**Capture groups:**
1. `audience` — "human" or "ai"
2. `modifier` — "preserve-voice", "ai-editable", or undefined

### 7.2 YAML Frontmatter Pattern

```regex
^---\n([\s\S]*?)\n---
```

Then within captured frontmatter:
```regex
doc-audience:\s*(human|ai)
preserve-voice:\s*(true|false)
```

---

## 8. Compliance Examples

### 8.1 Valid (Compliant)

```html
<!-- doc-audience: human, preserve-voice -->
# Architecture Overview
...
```
✅ Tag on line 1, valid audience, valid modifier

```html
<!-- doc-audience: ai -->
# API Reference
...
```
✅ Tag on line 1, valid audience, no modifier needed for AI

```yaml
---
doc-audience: human
preserve-voice: true
---
# Quickstart Guide
```
✅ YAML frontmatter on line 1, valid values

```html
<!-- doc-audience: human -->
# Runbook
```
✅ Valid — defaults to `preserve-voice`

### 8.2 Invalid (Non-Compliant)

```html
# My Document
<!-- doc-audience: human -->
```
❌ Tag not on line 1

```html
<!-- doc-audience: robot -->
```
❌ Invalid audience value

```html
<!-- doc-audience: human, read-only -->
```
❌ Invalid modifier value

```html
<!--doc-audience:human-->
```
❌ Missing required whitespace after `:`

```html
<!-- doc-audience: ai, preserve-voice -->
```
❌ `preserve-voice` modifier invalid for `ai` audience

---

## 9. Parsing Implementation

### 9.1 JavaScript

```javascript
function parseDocAudience(content) {
  // HTML comment
  const htmlMatch = content.match(
    /^<!--\s*doc-audience:\s*(human|ai)(?:\s*,\s*(preserve-voice|ai-editable))?\s*-->/
  );

  if (htmlMatch) {
    const audience = htmlMatch[1];
    const modifier = htmlMatch[2] || (audience === 'human' ? 'preserve-voice' : null);
    return {
      audience,
      modifier,
      preserve_voice: modifier === 'preserve-voice',
      ai_editable: modifier === 'ai-editable' || audience === 'ai'
    };
  }

  // YAML frontmatter
  const yamlMatch = content.match(/^---\n([\s\S]*?)\n---/);
  if (yamlMatch) {
    const fm = yamlMatch[1];
    const audMatch = fm.match(/doc-audience:\s*(human|ai)/);
    if (audMatch) {
      const audience = audMatch[1];
      const preserveVoice = /preserve-voice:\s*true/.test(fm);
      const explicitFalse = /preserve-voice:\s*false/.test(fm);

      const preserve_voice = audience === 'human' && !explicitFalse;
      const ai_editable = audience === 'ai' || explicitFalse;

      return {
        audience,
        modifier: preserve_voice ? 'preserve-voice' : (audience === 'human' ? 'ai-editable' : null),
        preserve_voice,
        ai_editable
      };
    }
  }

  return null;
}
```

### 9.2 Python

```python
import re
from dataclasses import dataclass

@dataclass
class DocAudience:
    audience: str
    modifier: str | None
    preserve_voice: bool
    ai_editable: bool

def parse_doc_audience(content: str) -> DocAudience | None:
    # HTML comment
    html_pattern = r'^<!--\s*doc-audience:\s*(human|ai)(?:\s*,\s*(preserve-voice|ai-editable))?\s*-->'
    match = re.match(html_pattern, content)

    if match:
        audience = match.group(1)
        modifier = match.group(2) or ('preserve-voice' if audience == 'human' else None)
        return DocAudience(
            audience=audience,
            modifier=modifier,
            preserve_voice=(modifier == 'preserve-voice'),
            ai_editable=(modifier == 'ai-editable' or audience == 'ai')
        )

    # YAML frontmatter
    yaml_match = re.match(r'^---\n(.*?)\n---', content, re.DOTALL)
    if yaml_match:
        fm = yaml_match.group(1)
        aud_match = re.search(r'doc-audience:\s*(human|ai)', fm)
        if aud_match:
            audience = aud_match.group(1)
            explicit_false = bool(re.search(r'preserve-voice:\s*false', fm))
            preserve_voice = audience == 'human' and not explicit_false

            return DocAudience(
                audience=audience,
                modifier='preserve-voice' if preserve_voice else ('ai-editable' if audience == 'human' else None),
                preserve_voice=preserve_voice,
                ai_editable=(audience == 'ai' or explicit_false)
            )

    return None
```

### 9.3 Bash

```bash
parse_doc_audience() {
  local file="$1"
  local first_line=$(head -n1 "$file")

  # HTML comment
  if [[ "$first_line" =~ ^\<\!--[[:space:]]*doc-audience:[[:space:]]*(human|ai)([[:space:]]*,[[:space:]]*(preserve-voice|ai-editable))?[[:space:]]*--\> ]]; then
    local audience="${BASH_REMATCH[1]}"
    local modifier="${BASH_REMATCH[3]}"

    [[ -z "$modifier" && "$audience" == "human" ]] && modifier="preserve-voice"

    echo "audience=$audience"
    echo "modifier=$modifier"
    echo "preserve_voice=$([[ "$modifier" == "preserve-voice" ]] && echo true || echo false)"
    echo "ai_editable=$([[ "$modifier" == "ai-editable" || "$audience" == "ai" ]] && echo true || echo false)"
    return 0
  fi

  # YAML frontmatter
  if [[ "$first_line" == "---" ]]; then
    local fm=$(sed -n '2,/^---$/p' "$file" | head -n -1)
    local audience=$(echo "$fm" | grep -oP 'doc-audience:\s*\K(human|ai)')

    if [[ -n "$audience" ]]; then
      local preserve_voice=true
      local ai_editable=false

      if echo "$fm" | grep -qE 'preserve-voice:\s*false'; then
        preserve_voice=false
        ai_editable=true
      fi

      [[ "$audience" == "ai" ]] && ai_editable=true && preserve_voice=false

      echo "audience=$audience"
      echo "preserve_voice=$preserve_voice"
      echo "ai_editable=$ai_editable"
      return 0
    fi
  fi

  return 1
}
```

---

## 10. Behavior Expectations

### 10.1 For AI Agents

#### When `preserve-voice` applies:

| Action | Allowed |
|--------|---------|
| Read and reference content | ✅ YES |
| Quote in responses | ✅ YES |
| Create separate AI version | ✅ YES |
| Edit content | ❌ NO |
| Add content | ❌ NO |
| Reformat or restructure | ❌ NO |
| "Improve" grammar or style | ❌ NO |
| Expand abbreviations | ❌ NO |

#### When `ai-editable` applies:

| Action | Allowed |
|--------|---------|
| Edit as requested | ✅ YES |
| Fix factual errors | ✅ YES |
| Match existing tone | ✅ YES (required) |
| Add verbosity | ❌ NO |
| Add redundancy | ❌ NO |
| Convert to AI style | ❌ NO |

#### When `ai` applies:

| Action | Allowed |
|--------|---------|
| Edit freely | ✅ YES |
| Be verbose | ✅ YES |
| Add redundancy | ✅ YES |
| Document edge cases | ✅ YES |
| Add examples | ✅ YES |

### 10.2 For Tooling

Tools implementing this standard SHOULD:

1. Parse doc-audience tag before any file modification
2. Block or warn on edits to protected documents
3. Log when AI-style edits occur on human documents
4. Provide audience distribution stats
5. Support both HTML comment and YAML formats

---

## 11. File Extensions

This specification applies to:

| Extension | Format |
|-----------|--------|
| `.md` | Markdown |
| `.mdx` | MDX |
| `.rst` | reStructuredText |
| `.txt` | Plain text |
| `.adoc` | AsciiDoc |

---

## 12. Directory Conventions (Optional)

Teams may organize docs however they prefer. One example:

```
docs/
├── human/
└── ai/
```

Directory structure is **optional**. The explicit `<!-- doc-audience: ... -->` tag on line 1 is what matters.

---

## 13. AI Documentation Template

For `ai`-audience documents, use this structure:

```markdown
<!-- doc-audience: ai -->

# [Component Name] — Reference

> FACTUAL GROUNDING — DO NOT SUMMARIZE

## Purpose
[Exact description, machine-optimized]

## Guarantees
- [Deterministic statement 1]
- [Deterministic statement 2]

## Interfaces
[Precise inputs/outputs]

## Constraints
[Hard limits, invariants]

## Failure Modes
- Condition → Outcome
- Condition → Outcome

## Implementation Notes
[Concrete details]
```

---

## 14. Versioning

This specification uses semantic versioning.

| Version | Status | Notes |
|---------|--------|-------|
| 1.0.0 | Stable | Initial release |

---

## 15. References

- [RATIONALE.md](RATIONALE.md) — Philosophy and motivation
- [AGENTS-GUIDANCE.md](AGENTS-GUIDANCE.md) — Agent behavior policy
- [README.md](README.md) — Human-oriented overview
