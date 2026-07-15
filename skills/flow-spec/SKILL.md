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

Keep it high-level and unambiguous. After writing the spec — and after any later change the user asks for — review it for inconsistencies and unresolved ambiguity. Don't guess: read the code to confirm, or ask the user when the code can't settle it. Get the user's OK before planning.

## 2. Plan

Read the TDD guidelines (`flow-shared/references/tdd-red-green.md`), then write `.flow/plans/YYYY-MM-DD-<topic>.md` (same slug). Break the work into sequential tasks a subagent can finish alone. Structure each as RED → GREEN where a test makes sense; follow the guidelines on when a test isn't warranted.

## 3. Execute (subagents)

Before each dispatch, pick a model per `flow-shared/references/subagent-model-size.md` (smallest capable tier). Resolve `flow-shared` paths before pasting prompts. Paste the filled template only — do not tell subagents to read plan files.

For each task, in order:

1. Note `BASE_SHA` (`git rev-parse HEAD`)
2. Dispatch implementer subagent — paste `flow-shared/prompts/implementer.md` (fill placeholders)
3. Note `HEAD_SHA`
4. Dispatch reviewer subagent — paste `flow-shared/prompts/reviewer.md` (fill placeholders)
5. If REJECTED → fix (subagent) → review again → repeat until APPROVED
6. Only then start Task N+1

## 4. Verify

Run the project's usual checks — tests, lint, typecheck, formatters, build — whichever exist. Check each Success Criterion. Report pass/fail. Stop — user owns merge/push.
