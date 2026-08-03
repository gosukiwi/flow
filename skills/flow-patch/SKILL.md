---
name: flow-patch
description: Small bounded change with micro-spec, subagent TDD, and per-task review. Invoke with /flow-patch.
disable-model-invocation: true
---

# Flow Patch

Single bounded change (roughly ≤3 files, one concern). Larger → `/flow-spec`.

Same execution discipline as `/flow-spec`. The only difference is gate weight: the micro-spec stays **inline in chat** — no spec file, no plan file, no separate review pass over either. **Subagents implement and review. No production code in this session.**

Resolve `flow-shared` via path resolver in `flow-shared/SKILL.md`.

## 1. Micro-spec

Present inline in chat. Do not write a file.

```markdown
## Micro-spec

**Problem:**
**Success criteria:**
**Files:**
**Out of scope:**

### Task 1: [name]
**Change:** [what to build]
**Acceptance:** [observable behavior that proves it works]
```

One task per commit-sized step. Each task must stand alone — a subagent gets only what you paste, so write the briefing for someone who has never seen this conversation. Do not spell out the RED/GREEN ritual; the implementer prompt already carries it.

Get the user's OK before dispatching.

## 2. Execute (subagents)

"It's only a few lines" is not an exemption. A change small enough to tempt you into typing it yourself is small enough for a small-tier subagent — and the briefing costing more than the diff is not a reason to skip it. Never implement or review in this session, no matter who asks.

Before each dispatch, pick a model per `flow-shared/references/subagent-model-size.md` (smallest capable tier — patches usually land in small). Resolve `flow-shared` paths before pasting prompts. Paste the filled template only — do not tell subagents to read the micro-spec from chat history.

For each task, in order:

1. Note `BASE_SHA` (`git rev-parse HEAD`)
2. Dispatch implementer subagent — paste `flow-shared/prompts/implementer.md` (fill placeholders)
3. Note `HEAD_SHA`
4. Dispatch reviewer subagent — paste `flow-shared/prompts/reviewer.md` (fill placeholders)
5. If REJECTED → fix (subagent) → review again → repeat until APPROVED
6. Only then start Task N+1

A green report from the implementer is not review. The reviewer reads the diff.

## 3. Verify

Run the project's usual checks — tests, lint, typecheck, formatters, build — whichever exist. Check each Success Criterion. Report pass/fail. Stop — user owns merge/push.
