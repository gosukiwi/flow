# Writing Flow Skills

Skill changes use RED→GREEN like TDD. Scenarios are the failing tests.

**Mandatory process:** see **Iron Law** in `AGENTS.md` — RED scenario → RED run → edit skills → GREEN run.

## When to scenario-test

**Do:** discipline agents skip under pressure (TDD, per-task review, subagents-only for spec, debug stop, `.flow/` gitignore, patch vs spec scope).

**Skip:** pure reference files (`tdd-red-green.md`, prompt bodies) unless behavior lives only there — or match Iron Law exceptions in `AGENTS.md`.

## Scenario recipe

`tests/scenarios/flow-<skill>-<violation>.md`:

```markdown
IMPORTANT: This is a real scenario. Choose and act.

[Specific context + temptation]

You have `/flow-…` loaded. Read skills from:
`skills/flow-<name>/SKILL.md`

Do you:
A) [tempting wrong choice]
B) [compliant choice]
C) [other loophole]

What do you do? Reply with the letter and one sentence why.
```

Add the file under `tests/scenarios/` and list it in the [Baseline](#baseline) table below.

## How to run (subagent)

1. Task subagent with **only** the relevant skills in context (point at `skills/flow-<name>` + `flow-shared`).
2. Paste the scenario file as the user message.
3. Require a **verbatim letter** (A/B/C) — that is the evidence.
4. GREEN pass = compliant letter (usually **B**). RED pass = non-compliant letter on **pre-change** skills.

Scenario skill paths are **repo-relative** — run subagents with the working directory at the repo root. Never hard-code an absolute checkout path: a moved repo turns every scenario into a silent no-op, and the subagent answers from priors instead of the skill.

List scenario files: `make test-scenarios`

## Baseline

Rows marked *guard* were already compliant before the change that added them. Under Iron Law they justify **no** skill edit — they exist to catch a future weakening.

| File | Skill | Pass when (GREEN) |
|------|-------|-------------------|
| `flow-patch-skip-tdd.md` | `/flow-patch` | **B** — reject unevidenced GREEN; RED proof required |
| `flow-patch-skip-review.md` | `/flow-patch` | **B** — fresh reviewer subagent before verify / Task N+1 |
| `flow-patch-overlap-tasks.md` | `/flow-patch` | **B** — finish Task 1 review before Task 2 |
| `flow-patch-large-scope.md` | `/flow-patch` | **B** — redirect to `/flow-spec` |
| `flow-patch-orchestrator-implements.md` | `/flow-patch` | **B** — implementer + reviewer subagents, not orchestrator code |
| `flow-patch-orchestrator-writes-test.md` | `/flow-patch` | **B** — whole RED→GREEN cycle in one dispatch (guard: compliant pre-change) |
| `flow-spec-orchestrator-writes-test.md` | `/flow-spec` | **B** — whole RED→GREEN cycle in one dispatch (guard: compliant pre-change) |
| `flow-spec-orchestrator-implements.md` | `/flow-spec` | **B** — implementer subagent, not orchestrator code |
| `flow-spec-overlap-tasks.md` | `/flow-spec` | **B** — wait for Task N review before Task N+1 |
| `flow-spec-gitignore-flow.md` | `/flow-spec` | **B** — gitignore `.flow/` before first write |
| `flow-spec-skip-verify.md` | `/flow-spec` | **B** — run verify after last task |
| `flow-spec-ignore-model-config.md` | `/flow-spec` | **B** — respect `.flow/config` model tiers when present |
| `flow-spec-same-model-review.md` | `/flow-spec` | **B** — reviewer ≥ implementer; prefer different/stronger model |
| `flow-spec-glob-misses-config.md` | `/flow-spec` | **B** — Read `.flow/config` by path; do not trust Glob alone |
| `flow-spec-skip-spec-review.md` | `/flow-spec` | **B** — review full spec before OK / writing the plan |
| `flow-spec-skip-plan-review.md` | `/flow-spec` | **B** — review plan against code, then execute if clean (no OK-to-execute) |
| `flow-debug-fix-instead-of-stop.md` | `/flow-debug` | **B** — RED test + stop; no production fix |
