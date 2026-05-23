---
name: flow
description: Router for the flow development workflow. Invoke with /flow to choose spec, execute, patch, debug, or verify.
disable-model-invocation: true
metadata:
  flow:
    command: /flow
    role: router
---

# Flow Router

**Triggered by:** `/flow`

Explicit workflow for spec-driven development with TDD, subagents, and verification gates.

## Commands

| Command | When to use |
|---------|-------------|
| `/flow-brainstorm` | Fuzzy idea — explore options and design before spec |
| `/flow-spec` | New feature or multi-step change — needs spec + plan |
| `/flow-execute` | Approved spec exists; run the plan with subagents |
| `/flow-patch` | Single bounded change (≤3 files, one concern) |
| `/flow-debug` | Bug, test failure, or unexpected behavior |
| `/flow-verify` | Final gate before claiming work is done |

## Decision Tree

```
New work?
├─ Bug or test failure? → /flow-debug
├─ Small bounded change? → /flow-patch
├─ Idea fuzzy or needs exploration? → /flow-brainstorm
├─ Direction clear, ready to lock requirements? → /flow-spec
└─ Plan already written? → /flow-execute

Implementation done?
└─ /flow-verify (then external code review skillset if you use one)
```

## path resolver

Before reading shared prompts or references, resolve `flow-shared`:

1. `.agents/skills/flow-shared/`
2. `.cursor/skills/flow-shared/`
3. `~/.cursor/skills/flow-shared/`

Prompt files live at `{flow-shared}/prompts/{name}.md`.

Project artifacts live in the **consumer project** (not in the skill package):

```
docs/flow/
  brainstorms/
  specs/
  plans/
  STATE.md
```

Update `docs/flow/STATE.md` when starting or finishing a phase:

```markdown
# Flow State

phase: brainstorm | spec | execute | patch | debug | verify | done
brainstorm: docs/flow/brainstorms/YYYY-MM-DD-topic.md
spec: docs/flow/specs/YYYY-MM-DD-topic.md
plan: docs/flow/plans/YYYY-MM-DD-topic.md
branch: feature/topic
updated: YYYY-MM-DD
```

## Install

```bash
npx skills add gosukiwi/flow -a cursor --skill '*' -y
```

Install includes `flow-shared` (internal bundle with prompts). Do not invoke `flow-shared` directly.

## How to Start

Read the skill matching the user's command:

- `/flow-brainstorm` → read `flow-brainstorm/SKILL.md`
- `/flow-spec` → read `flow-spec/SKILL.md`
- `/flow-execute` → read `flow-execute/SKILL.md`
- `/flow-patch` → read `flow-patch/SKILL.md`
- `/flow-debug` → read `flow-debug/SKILL.md`
- `/flow-verify` → read `flow-verify/SKILL.md`

Follow that skill exactly. Do not skip gates.
