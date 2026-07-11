---
name: flow-spec
description: Spec + plan + subagent TDD tasks for multi-step features. Invoke with /flow-spec.
disable-model-invocation: true
---

# Flow Spec

Multi-step feature work. Orchestrator writes spec/plan and coordinates; **subagents** implement. No production code in the orchestrator.

Resolve `flow-shared` via path resolver in `flow-shared/SKILL.md`.

## 1. Spec

Before the first write under `.flow/`, ensure `.flow/` is gitignored:

```bash
git check-ignore -q .flow 2>/dev/null || echo '.flow/' >> .gitignore
```

Skip the append if already ignored. Do not commit `.flow/` artifacts.

Write `.flow/specs/YYYY-MM-DD-<topic>.md`:

```markdown
# [Topic]

## Goal
## Success Criteria
## Scope
## Out of Scope
## Design
## Files
(paths created or modified)
## Contracts
(types/models, persistence, public APIs/events/module boundaries)
## Testing
```

Keep it high-level and unambiguous. Get the user's OK before planning.

## 2. Plan

Write `.flow/plans/YYYY-MM-DD-<topic>.md` (same slug). Sequential TDD tasks — each task has RED → GREEN steps a subagent can finish alone.

## 3. Execute (subagents)

Before each dispatch, pick a model per `flow-shared/references/subagent-model-size.md` (smallest capable tier; map to the host's model names). Resolve `flow-shared` paths before pasting prompts. Paste the filled template only — do not tell subagents to read plan files.

For each task, in order:

1. Note `BASE_SHA` (`git rev-parse HEAD`)
2. Dispatch implementer subagent — paste `flow-shared/prompts/implementer.md` (fill placeholders)
3. Note `HEAD_SHA`
4. Dispatch reviewer subagent — paste `flow-shared/prompts/reviewer.md` (fill placeholders)
5. If REJECTED → fix (subagent) → review again
6. Only then start Task N+1

TDD: `flow-shared/references/tdd-red-green.md`.

## 4. Verify

Run the project's usual checks — tests, lint, typecheck, formatters, build — whichever exist. Check each Success Criterion. Report pass/fail. Stop — user owns merge/push.
