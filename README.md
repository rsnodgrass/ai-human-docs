<!-- doc-audience: human, preserve-voice -->

[![docs: ai-human-docs](https://raw.githubusercontent.com/modern-tooling/ai-human-docs/main/badges/ai-human-docs.svg)](https://github.com/modern-tooling/ai-human-docs)

# AI–Human Docs

**Standard Version:** 1.0.0 (2025-12-24)

**Keep documentation truly readable for humans — while still giving AI coding agents the verbose structure they need.**

**Quick start:** Add this to your `AGENTS.md` or `CLAUDE.md`:
```
Before editing docs, check line 1 for `<!-- doc-audience: ... -->`.
If `human` or `preserve-voice`: DO NOT edit. If `ai`: edit freely.
See:
  - https://raw.githubusercontent.com/modern-tooling/ai-human-docs/main/AGENTS-GUIDANCE.md (behavior)
  - https://raw.githubusercontent.com/modern-tooling/ai-human-docs/main/SPEC.md (parsing)
```

---

Modern repos now have two completely different readers:

**👩‍💻 Humans** — who think in narratives, intent, tradeoffs, and mental models

**🤖 AI agents** — which operate best with explicit structure, redundancy, and exhaustive detail

When those two share the same documentation, everyone loses.

- Humans stop reading because everything turns into walls of AI-generated sameness.
- Agents still struggle because nuance gets mixed with narrative.
- Voice disappears. Cognitive load rises. Trust drops.

This project proposes a small, practical fix:

👉 **Separate human docs and AI docs** — intentionally
👉 **Make that distinction explicit** so tools respect it
👉 **Protect human voice** while empowering agents

No framework. No ceremony. Just sane boundaries.

---

## Why this matters

This solves three real problems that are getting worse in AI-first codebases:

### 1️⃣ Human docs become unreadable

Teams add coding agents.
Docs balloon in length.
Tone becomes generic AI-speak.
People quietly stop reading.

This brings human docs back to being:
- concise
- narrative
- opinionated
- written like real people talking to other real people

### 2️⃣ Agents actually get better context

Instead of half-story / half-spec mush,
AI gets separate documentation designed for it:
- exhaustive
- precise
- structured
- expandable without guilt

Everyone gets what they need.

### 3️⃣ Culture + intent survive

There is craft in how teams communicate.
Voice is part of culture.
Good docs carry judgment, not just facts.

This explicitly protects that.

---

## The idea in one sentence

**Human docs are for cognition.**
**AI docs are for computation.**
**Stop forcing them to be the same thing.**

---

## How it works (you'll like how simple it is)

Add a tag on line 1 of any doc:

```html
<!-- doc-audience: human, preserve-voice -->
```

or

```html
<!-- doc-audience: ai -->
```

That's it. Agents check line 1 before editing.

Done.

---

## What you get out of this

- Docs humans actually enjoy reading again
- Agents that perform better with clearer grounding
- Cleaner onboarding
- Less doc-chaos as more agents join
- Protection of human tone + nuance
- A system your team can actually live with

---

## A relatable truth

If you've already added coding agents to your repo, you've probably felt this:

- documentation grows
- it becomes harder to skim
- everything feels slightly too verbose
- meaningful voice evaporates
- and still… agents ask for more context

This framework acknowledges reality:
**humans and machines learn differently.**

So we stop pretending they don't.

---

## Who this is for

Teams who:

- ✔️ care about great engineering culture
- ✔️ want AI deeply integrated… without losing themselves
- ✔️ value clarity, calm, and good taste in documentation
- ✔️ believe progressive disclosure matters
- ✔️ don't want a giant "process thing"

**This is for serious builders who want to stay human.**

---

## What's in this repo

- **README** — what and why
- **SPEC.md** — the formal rules
- **RATIONALE.md** — the thinking behind it
- **AGENTS-GUIDANCE.md** — how coding agents should behave
- **examples, integrations, and evolving tooling**

Everything pragmatic. Everything optional.
Adopt gradually or fully — both work.

---

## Want stability? Fork it.

The examples above reference the `main` branch of this repository. This means agent behavior guidance could change over time as the standard evolves.

**For teams requiring stability guarantees:**

1. Fork this repository
2. Point your agent configuration to your fork instead:
   ```
   https://raw.githubusercontent.com/YOUR-ORG/ai-human-docs/main/AGENTS-GUIDANCE.md
   ```
3. Review and merge upstream changes on your schedule

This ensures no unexpected changes to agent guidance. You control when (or if) to adopt updates.

---

## If this resonates

Use it. Adapt it. Improve it.
And if it makes your repo calmer, clearer, and more humane… tell people 😄

The goal isn't complexity.
**The goal is to keep documentation good while our tools evolve.**
