<!-- doc-audience: ai -->

# AI Agent Policy

This document defines **mandatory behavior** for AI agents operating in repositories that follow the ai-human-docs standard.

These are rules, not suggestions.

---

## 1. Core Rules

### 1.1 MUST: Check Before Editing

Before editing ANY documentation file, agents MUST:

1. Read line 1 of the file
2. Parse the `doc-audience` tag
3. Apply the corresponding behavior policy

**Rationale:** Human-crafted documentation is protected by explicit tagging. Failing to check destroys human work.

### 1.2 MUST NOT: Edit Protected Documents

When `preserve-voice` applies, agents MUST NOT:

| Action | Allowed |
|--------|---------|
| Edit content | ❌ NO |
| Add content | ❌ NO |
| Remove content | ❌ NO |
| Reformat | ❌ NO |
| Restructure | ❌ NO |
| "Improve" grammar | ❌ NO |
| Expand abbreviations | ❌ NO |
| Add examples | ❌ NO |

**What agents MAY do:**
- Read and reference the content
- Quote in responses
- Create a separate AI-audience version elsewhere

### 1.3 MUST: Preserve Voice in ai-editable Docs

When editing `human, ai-editable` documents, agents MUST:

- Match existing tone and style
- Keep content concise
- Avoid adding verbosity
- Avoid adding redundancy

### 1.4 SHOULD: Be Verbose in AI Docs

When editing `ai` documents, agents SHOULD:

- Be explicit and verbose
- Document all edge cases
- Include redundant context for safety
- Add examples
- Document assumptions

---

## 2. Tag Reference

| Tag | Meaning | Agent Behavior |
|-----|---------|----------------|
| `<!-- doc-audience: human, preserve-voice -->` | Protected human doc | DO NOT EDIT |
| `<!-- doc-audience: human, ai-editable -->` | Editable human doc | Edit, but stay concise |
| `<!-- doc-audience: human -->` | Human doc (no modifier) | Treat as `preserve-voice` |
| `<!-- doc-audience: ai -->` | AI reference doc | Edit freely, be verbose |
| No tag | Ambiguous | Ask before editing |

---

## 3. Directory Structure (Optional)

Some teams organize docs into separate directories. This is **optional** — the line 1 tag is what matters.

One example:
```
docs/
├── human/
└── ai/
```

Teams may use any structure that works for them. The explicit `<!-- doc-audience: ... -->` tag always takes precedence.

---

## 4. Commit Message Requirements

When editing documentation, agents MUST include a `Docs edited:` section in commit messages.

### 4.1 Format

```
<summary of changes>

Docs edited:
- path/to/file.md (audience)
- path/to/other.md (audience, modifier)
```

### 4.2 Example

```
Add error handling documentation

Docs edited:
- docs/ai/api-reference.md (ai)
- docs/human/quickstart.md (human, ai-editable)
```

### 4.3 Rationale

This creates an audit trail. Humans reviewing git history can:
- Immediately see which docs were AI-touched
- Verify voice was preserved in human docs
- Track documentation drift over time

---

## 5. Platform-Specific Guidance

### 5.1 Claude Code / CLAUDE.md

Add to your CLAUDE.md:

```markdown
## Documentation Audiences

Before editing any file, check for `<!-- doc-audience: ... -->` on line 1.

| Tag | Behavior |
|-----|----------|
| `human, preserve-voice` | DO NOT edit, expand, or rephrase |
| `human, ai-editable` | May edit, but preserve concise voice |
| `ai` | Edit freely, be verbose |

When editing docs, label them in your commit message:
```
Docs edited:
- path/to/file.md (audience)
```

See:
- https://raw.githubusercontent.com/modern-tooling/ai-human-docs/main/AGENTS-GUIDANCE.md (behavior)
- https://raw.githubusercontent.com/modern-tooling/ai-human-docs/main/SPEC.md (parsing)
```

### 5.2 Cursor / .cursorrules

Add to your `.cursorrules`:

```
# Documentation Audiences

Before editing any documentation file, check line 1 for `<!-- doc-audience: ... -->`.

Rules:
- human, preserve-voice: DO NOT edit
- human, ai-editable: May edit, stay concise
- ai: Edit freely, be verbose
See:
- https://raw.githubusercontent.com/modern-tooling/ai-human-docs/main/AGENTS-GUIDANCE.md (behavior)
- https://raw.githubusercontent.com/modern-tooling/ai-human-docs/main/SPEC.md (parsing)
```

### 5.3 Windsurf / Project AGENTS.md

Add to your project's AGENTS.md:

```markdown
## Documentation Audiences

This repo follows ai-human-docs. Check `<!-- doc-audience: ... -->` on line 1 before editing.

- `human, preserve-voice` → DO NOT EDIT
- `human, ai-editable` → Edit, but stay concise
- `ai` → Edit freely, be verbose

See:
- https://raw.githubusercontent.com/modern-tooling/ai-human-docs/main/AGENTS-GUIDANCE.md (behavior)
- https://raw.githubusercontent.com/modern-tooling/ai-human-docs/main/SPEC.md (parsing)
```

---

## 6. Decision Tree

```
┌─────────────────────────────────────────┐
│ Agent wants to edit a documentation file │
└─────────────────────────────────────────┘
                    │
                    ▼
        ┌───────────────────────┐
        │ Check line 1 for tag  │
        └───────────────────────┘
                    │
        ┌───────────┴───────────┐
        ▼                       ▼
   [Tag found]            [No tag found]
        │                       │
        ▼                       ▼
┌───────────────┐         ┌───────────┐
│ Parse audience│         │ Ask before│
│ and modifier  │         │ editing   │
└───────────────┘         └───────────┘
        │
        ▼
┌───────────────┐
│ Apply policy  │
│ from table    │
└───────────────┘
```

---

## 7. Why These Rules Exist

### Protecting Human Craft

Human documentation carries team culture, intent, and shared mental models. When AI flattens this into verbose, mechanical prose, teams lose:
- Onboarding clarity
- Architectural intuition
- Pleasant reading experience
- Trust in documentation

### Enabling AI Power

AI agents perform better with exhaustive context. By giving them dedicated space, they can:
- Be as verbose as needed
- Document every edge case
- Include redundant safety context
- Maintain their own grounding docs

### Scaling with Agent Count

As teams deploy more AI agents, boundaries become critical. Without explicit rules, agents compete to "improve" docs, each making them longer and more mechanical.

---

## 8. README Badge

Projects following ai-human-docs SHOULD add the badge to their root README.md:

```markdown
[![docs: ai-human-docs](https://raw.githubusercontent.com/modern-tooling/ai-human-docs/main/badges/ai-human-docs.svg)](https://github.com/modern-tooling/ai-human-docs)
```

Place near the top of README.md with other project badges. This:
- Signals the repo follows ai-human-docs conventions
- Links to the standard for reference
- Helps other agents discover the policy

---

## 9. This Repository

This repository follows its own standard:

| File | Audience | Editable by AI |
|------|----------|----------------|
| `README.md` | human, preserve-voice | ❌ |
| `RATIONALE.md` | human, preserve-voice | ❌ |
| `SPEC.md` | ai | ✅ |
| `AGENTS-GUIDANCE.md` | ai | ✅ |

---

## 10. References

- [SPEC.md](SPEC.md) — Formal specification with JSON schema
- [RATIONALE.md](RATIONALE.md) — Philosophy and motivation
- [README.md](README.md) — Human-oriented overview
