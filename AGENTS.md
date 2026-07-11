# AGENTS.md

Guidance for AI agents working on **this repository** — the Flow skillset maintainer repo.

## What this repo is

**Flow** is a minimalist spec-driven development workflow shipped as Cursor agent skills:

- **Published as:** [github.com/gosukiwi/flow](https://github.com/gosukiwi/flow)

| Command | Role |
|---------|------|
| `/flow-spec` | Spec → plan → **subagent** tasks + review → verify |
| `/flow-patch` | Micro-spec → **inline** TDD + inline review → verify |
| `/flow-debug` | Root cause + RED test → **stop** (fix via `/flow-patch`) |

- **Not an application repo.** No app server or runtime. Source of truth is Markdown under `skills/` plus scenario tests under `tests/`.
- Skills install into **consumer projects** (`.cursor/skills/` / `.agents/skills/`). Consumer artifacts live in `.flow/` (gitignored) in those projects — not here.

Human overview: `README.md`.

## Repository layout

```
skills/
  flow-spec/SKILL.md       # Multi-step: spec, plan, subagent execute
  flow-patch/SKILL.md      # Small change: inline TDD + review
  flow-debug/SKILL.md      # Investigate; RED only; no fix
  flow-shared/             # Shared assets (not invoked directly)
    prompts/               # implementer.md, reviewer.md (prompt bodies)
    references/            # tdd-red-green.md, subagent-model-size.md

tests/
  writing-skills.md        # Scenario recipe + baseline catalog
  scenarios/               # Pressure scenarios (flow-*.md)
    run-scenarios.sh       # Lists scenario files

Makefile                   # make test-scenarios
README.md                  # User-facing install + workflow
AGENTS.md                  # This file — maintainer agents read first
```

## What to read first

| Task | Read |
|------|------|
| **Any skill / shared prompt / reference change** | This file — **Iron Law** — then `tests/writing-skills.md` |
| Add or sharpen a scenario | `tests/writing-skills.md` (recipe + catalog) |
| User-facing workflow / install | `README.md` |
| List scenarios | `make test-scenarios` |

### `tests/writing-skills.md`

Maintainer guide for pressure scenarios — **not installed** to consumer projects, **not** a skill agents invoke at runtime.

Use it for:

- When a change needs a scenario vs when to skip
- Scenario file recipe (pressure context + A/B/C traps)
- How to run scenarios with a Task subagent
- Baseline catalog (files + GREEN pass letters)

Iron Law in this file is mandatory even if you already know the recipe.

## Commands

| Command | Purpose |
|---------|---------|
| `make test-scenarios` | List scenario files (does not run agents) |
| `npx skills add ./skills -a cursor --skill '*' -y --copy` | Reinstall into a consumer project while iterating |

## Iron Law

```
NO SKILL CHANGE WITHOUT A FAILING SCENARIO FIRST
```

Any change to behavior under `skills/` (including `flow-shared/` prompts and references that agents follow) **must** follow this order. Do not reorder or skip.

| Step | Action | Done when |
|------|--------|-----------|
| **1 — RED (write)** | Add or update `tests/scenarios/flow-<skill>-<violation>.md`; register it in the Baseline table in `tests/writing-skills.md` | Scenario traps one specific rationalization under pressure |
| **2 — RED (run)** | Launch a **Task subagent** pointed at **pre-change** skills (`git show HEAD:skills/...` or stash edits); paste the scenario; return the choice **verbatim** | Subagent picks the **non-compliant** option (or rationalizes the violation) |
| **3 — GREEN (edit)** | Edit `skills/` only after step 2 passes | Skill text blocks the rationalization seen in RED |
| **4 — GREEN (run)** | Same subagent setup with **current** tree skills; paste the same scenario | Subagent picks the **compliant** option and cites the rule |

If you already edited `skills/` before RED: that edit is **invalid** — revert or stash, run RED on the committed (pre-change) skills, then continue.

If RED passes on old skills (agent already compliant): the scenario is **too weak** — sharpen it; do not edit skills yet.

### Forbidden before RED run (step 2) completes

- Editing `skills/**` for the behavior under test
- Treating “the skill text looks correct” as RED evidence
- Skipping scenarios because they are “manual”
- Weakening a scenario so it passes on old skills

### Subagent RED/GREEN (default in maintainer sessions)

Use the Task tool — do not rely on this chat’s prior context.

- Give the subagent **only** relevant skills (`flow-<skill>` + `flow-shared` when needed)
- Paste the scenario file content as the user message
- Require a verbatim letter (A/B/C) — that is the evidence
- **RED:** pre-change skill text only
- **GREEN:** working-tree skills after your edit

### Exceptions (no scenario)

- Pure wording / typos with **no** behavior or discipline change
- Docs-only (`README.md`, `AGENTS.md`, `tests/writing-skills.md`) with no skill edit
- New shared file listed in `flow-shared/SKILL.md` that introduces **no** new agent behavior

When unsure whether behavior changed: **treat it as discipline** — follow Iron Law.

Full recipe: `tests/writing-skills.md`.

## Skill conventions

Every invokable skill under `skills/<name>/`:

1. Frontmatter: `name` matches directory; `description` says when to invoke; `disable-model-invocation: true`
2. Resolve shared assets via path resolver in `flow-shared/SKILL.md`
3. Prompt files under `flow-shared/prompts/` are **bodies only** — orchestration (subagent vs inline, model size) lives in the calling `SKILL.md`

### Invariants (do not break)

| Rule | Where |
|------|--------|
| `/flow-spec` orchestrator does **not** implement production code — subagents do | `flow-spec/SKILL.md` |
| `/flow-patch` implements and reviews **inline** | `flow-patch/SKILL.md` |
| Per-task review before Task N+1 (both lanes) | `flow-spec`, `flow-patch` |
| TDD: no production code without a failing test first | `tdd-red-green.md` |
| `/flow-debug` does not fix — RED then stop → `/flow-patch` | `flow-debug/SKILL.md` |
| `.flow/` gitignored before first write; never commit `.flow/` artifacts | `flow-spec/SKILL.md` |
| Verify after last task (tests/lint/typecheck/formatters/build + Success Criteria) | `flow-spec`, `flow-patch` |

## Editing guidelines

- Follow **Iron Law** for any skill behavior change
- Prefer precise counters for rationalizations agents actually use (“just this once”, “it’s tiny”, “batch reviews later”)
- Keep skills succinct — lite by design; do not port full Flow gates unless asked
- Do not add consumer-project `.flow/` artifacts to this repo
- Commit only when the user explicitly asks

## Consumer project vs this repo

| | This repo (maintainer) | Consumer project |
|---|------------------------|------------------|
| Skills live in | `skills/` | `.agents/skills/` or `.cursor/skills/` via `npx skills add gosukiwi/flow …` |
| Workflow artifacts | none | `.flow/specs`, `.flow/plans` (gitignored) |
| Scenarios / AGENTS | yes | no |
