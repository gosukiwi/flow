---
name: flow-patch
description: Small bounded changes with micro-spec, TDD, and subagents. Invoke with /flow-patch.
disable-model-invocation: true
metadata:
  flow:
    command: /flow-patch
---

# Flow Patch

**Triggered by:** `/flow-patch`

For **single bounded changes** — too small for a full spec doc, still requiring TDD and review.

## When to use

| Use `/flow-patch` | Redirect to `/flow-spec` |
|-------------------|--------------------------|
| ≤3 files, one concern | >3 files or multiple concerns |
| Clear success criteria | Needs design exploration |
| Bug fix with known cause | Architectural change |

## Branch rule

Same as flow-execute: feature branch; never commit on main/master without explicit approval.

## Process

### 1. Micro-spec (required)

Write inline before any code:

```markdown
## Micro-spec

**Problem:** [what's wrong or needed]
**Success criteria:** [how we know it's done]
**Files:** [expected touch list]
**Out of scope:** [what we will NOT do]
```

### 2. User gate

> Micro-spec above. Approve to proceed?

**Stop until approved.**

### 3. Subagent execution

Read prompt templates from `flow-shared/prompts/` (resolve directory via `flow/SKILL.md` path resolver). Dispatch subagents using the same protocol as `/flow-execute`:

1. Implementer (full micro-spec text + TDD)
2. Spec compliance reviewer (against micro-spec)
3. Code quality reviewer (after spec ✅)

Never implement inline in the orchestrator session.

### 4. Verify

Run `/flow-verify` against the micro-spec.

## Redirect rules

- User scope grows during patch → stop and switch to `/flow-spec`
- Root cause unclear → `/flow-debug` first
