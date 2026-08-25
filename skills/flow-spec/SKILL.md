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

Write `.flow/specs/YYYY-MM-DD-HH-MM-<topic>.md`:

```markdown
# [Topic]

## Goal
## Success Criteria
## Scope
## Out of Scope
## Design
```

Keep it high-level and unambiguous. Success Criteria must be falsifiable (pass/fail at Verify). Design is approach and decisions — not file paths or type dumps.

A spec is one slice: small enough for one agent session to hold its spec, plan, and task coordination; shippable on its own; testable on its own. Work exceeding any of these is more than one spec — split it, spec only the first slice, and tell the user the rest follow as their own specs. One tightly-coupled subsystem is not exempt; size and shippability decide, not independence.

Scope holds only what this slice needs to ship and pass its own tests. Out of Scope names what a subagent on this slice could reasonably take for its own job: adjacent fixes and cleanups in the files it touches, however small — proximity is not scope — plus any deferred work that borders this slice. Not every deferred slice; only what could be drifted into.

Iterate with the user as needed.

## 2. Plan

1. Review the full spec for inconsistencies and unresolved ambiguity. Don't guess: read the code to confirm, or ask the user when the code can't settle it. Pre-write research does not replace this pass.
2. Get the user's OK to write the plan. Do not write the plan until steps 1–2 are done.
3. Read the TDD guidelines (`flow-shared/references/tdd-red-green.md`), then write `.flow/plans/YYYY-MM-DD-HH-MM-<topic>.md` (same slug). Break the work into sequential tasks a subagent can finish alone. Structure each as RED → GREEN where a test makes sense; follow the guidelines on when a test isn't warranted. A plan has no unresolved alternatives left for the implementer — paths, names, commit splits, or hedge phrases (`or`, `either`, `equivalent`, `prefer X if Y`, "implementer decides"). Unsettled → read the code or ask the user before leaving them in the plan. Don't guess.
4. Review the plan against the codebase: match existing conventions, confirm APIs/helpers exist. Re-check that the plan is clean (zero such alternatives).
5. If the plan is clean, start Execute. Do not ask for a separate OK to execute. Only stop if you have questions for the user.

## 3. Execute (subagents)

Follow `flow-shared/references/execute-loop.md`. Task text comes from the plan — paste it into the prompt; do not tell subagents to read plan files.

## 4. Verify

Run the project's usual checks — tests, lint, typecheck, formatters, build — whichever exist. Check each Success Criterion. Report pass/fail. Stop — user owns merge/push.
