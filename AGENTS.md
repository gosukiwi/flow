# AGENTS.md

Guidance for Cursor AI agents working on **this repository** — the Flow skillset maintainer repo.

## What this repo is

**Flow** is a spec-driven development workflow shipped as Cursor agent skills (`/flow`, `/flow-brainstorm`, `/flow-spec`, `/flow-execute`, `/flow-patch`, `/flow-debug`, `/flow-verify`, `/flow-finish`).

- **Published as:** [github.com/gosukiwi/flow](https://github.com/gosukiwi/flow)
- **Not an application repo.** There is no app server, build step, or runtime. Source of truth is Markdown skill files under `skills/` plus bash/Python validation scripts.

Flow skills are installed into **consumer projects** via `npx skills add`. Workflow artifacts (`docs/flow/…`) live in those consumer repos, not here.

## Repository layout

```
skills/                    # Shippable skill package (published in npm "files")
  flow/SKILL.md            # Router — triage only, manual handoff
  flow-brainstorm/         # Exploration before spec
  flow-spec/               # User-approved spec + self-reviewed plan
  flow-execute/            # Subagent execution (never inline)
  flow-patch/              # Small changes, inline TDD
  flow-debug/              # Root cause before fixes
  flow-verify/             # Tests + checklist + user menu
  flow-finish/             # Merge/push/done + STATE and worktree cleanup
  flow-shared/             # Shared prompts + references (not invoked directly)
    prompts/               # Subagent prompt templates
    references/            # Gates, TDD, worktree, session rules

docs/
  workflow.md              # Human-facing workflow reference (agents read skills/)

tests/
  run.sh                   # Layer 1 entrypoint (via make test)
  static/
    validate-skills.sh     # Structure + invariant grep checks
    validate-artifacts.py  # Spec/plan template validation
  fixtures/artifacts/      # good/bad spec and plan fixtures
  scenarios/               # Layer 2 pressure scenarios (manual — run before release)
  writing-skills.md        # Maintainer guide — read before editing skills

scripts/install.sh         # Local install helper
Makefile                   # test, test-static, test-scenarios, install
```

## Commands

| Command | Purpose |
|---------|---------|
| `make test` | **Run before every commit.** Static skill validation + artifact fixtures. |
| `make test-static` | Same as above without the Layer 2 reminder. |
| `make test-scenarios` | Lists scenario files for manual runs (before release). |
| `make install` | Install skills from this clone into current project. |
| `npx skills add ./skills -a cursor --skill '*' -y --copy` | Reinstall after local skill edits (use `--copy` when iterating). |

**Dependencies:** `bash`, `python3`, `grep`, `find`. No Node build step in this repo (Node only for `npx skills` at install time).

## Iron Law (any change under `skills/`)

From `tests/writing-skills.md`: **no skill change without a failing scenario first.** If you already edited `SKILL.md` or `flow-shared/` before RED, that edit is **invalid** — revert or stash, run RED on the **committed (pre-change)** skills, then proceed.

**Mandatory order — do not reorder or skip steps:**

| Step | Action | Done when |
|------|--------|-----------|
| **1 — RED (write)** | Add or update `tests/scenarios/flow-<skill>-<violation>.md`; register in `tests/scenarios/README.md` | Scenario traps one specific rationalization (not abstract A/B/C) |
| **2 — RED (run)** | Launch a **Task subagent** with only the relevant skills at **pre-change** commit; paste the scenario; return the agent’s choice **verbatim** | Subagent picks the **non-compliant** option or rationalizes the violation |
| **3 — GREEN (edit)** | Edit `skills/` only after step 2 passes | Skill text blocks the rationalization you saw in RED |
| **4 — GREEN (run)** | Same subagent setup with **current** tree skills; paste the same scenario | Subagent picks the compliant option and cites the rule or gate |

Then run `make test`. Optional REFACTOR: tighten skill text or add a grep invariant in `validate-skills.sh`; re-run step 4.

**Forbidden before step 2 completes:**

- Editing `skills/**` or `flow-shared/**` for the behavior under test
- Treating “the skill text looks correct” as RED
- Skipping Layer 2 because scenarios are manual
- Weakening a scenario so it passes on old skills

**Subagent RED/GREEN (default in maintainer sessions):** Use the Task tool — do not rely on this chat’s prior context. Install only relevant skills (`flow-<skill>`, `flow-shared`, and `flow` only when routing is under test). For RED, point the subagent at pre-change files (`git show HEAD:skills/...` or stash local edits). For GREEN, use the working tree after your edits.

**Exceptions (no scenario):** Pure wording with no gate/discipline change; new `flow-shared` prompts/refs with no new behavior — still run `make test`. When unsure, treat it as discipline and follow all four steps.

Full detail: `tests/writing-skills.md` (authoring principles, scenario recipe, REFACTOR).

## What to read first

| Task | Read |
|------|------|
| Any skill edit | `tests/writing-skills.md` — **Iron Law section first** |
| Understand user-facing workflow | `README.md`, `docs/workflow.md` |
| Router / STATE / path resolver | `skills/flow/SKILL.md` |
| Branch, session, worktree gates | `skills/flow-shared/references/{branch-gate,session-gate,worktree-setup}.md` |
| Adding a discipline scenario | `tests/scenarios/README.md` |

## Skill authoring conventions

Every invokable skill under `skills/<name>/`:

1. **`name`** in frontmatter must match the directory name exactly.
2. **`description`** — when to invoke; not a workflow summary.
3. **`disable-model-invocation: true`** — all flow skills except internal patterns.
4. **`Triggered by:`** line with the `/flow-*` command.
5. **Shared assets** — resolve via the **path resolver** in `skills/flow/SKILL.md`:
   - `.agents/skills/flow-shared/`
   - `.cursor/skills/flow-shared/`
   - `~/.cursor/skills/flow-shared/`
6. **Never reference** repo-root `prompts/` or `tests/` from skill files — use `flow-shared/` paths only. `validate-skills.sh` enforces this.

### Architectural invariants (do not break)

| Rule | Where enforced |
|------|----------------|
| `/flow` triages only — suggest one command, then **stop** | `flow/SKILL.md`, scenarios |
| `/flow-execute` = **subagents only**, never inline implementation | `flow-execute/SKILL.md`, validate-skills.sh |
| `/flow-patch` = **inline** implementation + subagent review | `flow-patch/SKILL.md`, validate-skills.sh |
| Session gate before STATE writes on unrelated work | `session-gate.md`, brainstorm/spec/patch/execute/verify |
| Branch gate — ask before branch/worktree; **stop until confirmed** | `branch-gate.md` |
| Worktree dir must be gitignored before `git worktree add` | `worktree-setup.md` |
| `/flow-brainstorm` hands off to both `/flow-patch` and `/flow-spec` | validate-skills.sh |
| Spec sections: Goal, Success Criteria, Scope, Out of Scope, Design, Testing Approach, Open Questions | `flow-spec/SKILL.md`, fixtures |
| Plans must include TDD verification steps (`verify fail` / RED) | fixtures, `flow-spec/SKILL.md` |

`flow-shared` is **not invoked directly** — orchestrator skills load its prompts and references.

## Testing pyramid

| Layer | Command | When |
|-------|---------|------|
| **1 — Static** | `make test` | Every skill change, before commit |
| **2 — Scenarios** | **Iron Law:** Task subagent + scenario (maintainer); or fresh session (human, before release) | Every discipline/gate change — not optional |
| **3 — Dogfood** | Use `/flow-*` on real work in Cursor | Ongoing |

Discipline skills require **Iron Law** (four steps) — not just `make test`. See `tests/writing-skills.md`.

## RED → GREEN → REFACTOR (detail)

Same four steps as **Iron Law** above. This section adds mechanics; the table there is the contract.

### Scenario file (step 1)

Write `tests/scenarios/flow-<skill>-<violation>.md` using the recipe in `tests/writing-skills.md`. Register in `tests/scenarios/README.md`. Trap a **specific rationalization** (same-turn bundling, "no commit yet", skipping a gate) — not an abstract A/B/C quiz.

### Subagent run (steps 2 and 4)

1. **Task subagent** — required in maintainer/agent sessions (no prior chat context). Fresh user session is an alternative when the human runs Layer 2 manually before release.
2. Install **only** relevant skills (unrelated skills can override Flow):
   ```bash
   npx skills add ./skills -a cursor --skill 'flow-<skill>' --skill flow-shared -y --copy
   ```
   Add `flow` only when the scenario tests routing.
3. Prompt the subagent with: scenario file content; which `/flow-*` to invoke; for RED, explicit instruction to use **pre-change** skill text (`git show HEAD:skills/...` paths or “stash local edits first”); for GREEN, use current `skills/` after your edit.
4. Require the subagent to return **verbatim** what it would do (choice letter, gate cited, or draft message) — that output is the RED/GREEN evidence.

**RED:** pre-change skills only. If the subagent already passes, sharpen the scenario — do not edit skills yet.

**GREEN:** current skills. If the subagent still fails, iterate on skill text — do not weaken the scenario.

Run `make test` after GREEN. Before release: `make test-scenarios` and re-run affected scenarios.

### If you cannot run a subagent

Stop before commit; ask the user to run the scenario in a fresh session, or run it yourself in the next turn via Task. Do not skip RED/GREEN.

### REFACTOR (optional)

- New rationalization in GREEN → counter in skill text; re-run step 4.
- Cheap grep invariant → `tests/static/validate-skills.sh` after GREEN proved the rule matters.

## Typical maintainer workflow

1. Identify which skill(s) and shared references need changes.
2. **Any discipline or gate change:** follow **Iron Law** — scenario → subagent RED → edit skills → subagent GREEN → `make test`. Never edit `skills/` first.
3. **Non-discipline changes** (wording only, no new gates): edit directly, then `make test`.
4. Reinstall locally when iterating: `npx skills add ./skills -a cursor --skill '*' -y --copy`.
5. Commit only when the user asks.

## Editing guidelines

- **Iron Law first.** See table at top — subagent RED before any `skills/` edit for discipline changes.
- **Minimize scope.** Skill changes should be precise — one gate, one rationalization, one handoff at a time when hardening discipline.
- **Prefer hard gates** over soft suggestions for rules agents rationalize away ("just this once", "no commit yet", same-turn bundling).
- **Use existing patterns:** `Hard gate`, `Stop until`, `Forbidden in the same message`, red-flag tables — copy from `branch-gate.md` / `session-gate.md`.
- **Do not add** application code, CI, or consumer-project artifacts to this repo unless explicitly requested.
- **Do not create** `docs/flow/` artifacts here — those belong in projects where Flow is installed.
- **Do not edit** `README.md` or `docs/workflow.md` unless the user-facing workflow actually changed.

## Git and commits

- **Only commit when the user explicitly asks.**
- Recent commit style: short imperative subject (`Add session gate…`, `Simplify README…`).
- No pre-commit hooks or CI in this repo currently — `make test` is the static quality gate; run `make test-scenarios` manually before release.
- Do not push unless asked.

## Common tasks

### Add or tighten a gate

Follow **Iron Law** (four steps): scenario → **Task subagent RED** on pre-change skills → edit `flow-shared/references/*.md` or `SKILL.md` → **Task subagent GREEN** → optional REFACTOR in `validate-skills.sh` → `make test`.

### Add a new shared prompt or reference

1. Create file under `skills/flow-shared/prompts/` or `references/`.
2. List it in `skills/flow-shared/SKILL.md` Contents section.
3. Add existence check to `REQUIRED_*` arrays in `validate-skills.sh` if applicable.
4. Reference it from orchestrator skills via path resolver wording (match existing `"resolve via path resolver in flow/SKILL.md"` pattern).

### Fix a failing static check

Read the failure from `validate-skills.sh` — checks are documented inline with `pass`/`fail` messages. Most failures are missing frontmatter fields, broken cross-references, or removed gate language.

## Consumer project vs this repo

| | This repo (maintainer) | Consumer project |
|---|------------------------|------------------|
| Skills live in | `skills/` | `.agents/skills/` or `.cursor/skills/` |
| Workflow artifacts | `tests/fixtures/` only | `docs/flow/{brainstorms,specs,plans}` tracked; `STATE.md` local/gitignored |
| Install command | `make install` or local path | `npx skills add gosukiwi/flow …` |

When dogfooding Flow on real features, do that in a separate project with skills installed — not by adding `docs/flow/` here.

## Optional integration

**[clean-code-skills](https://github.com/gosukiwi/clean-code-skills)** enhances `/flow-verify` option 2. Without it, Flow uses the bundled `correctness-reviewer.md` (branch mode). Do not assume clean-code-skills is present when editing verify behavior.

## Quick reference — skill commands

| Command | Implements | Does not |
|---------|------------|----------|
| `/flow` | Suggest next command | Auto-start child workflows |
| `/flow-brainstorm` | Exploration brief | Spec, plan, or code |
| `/flow-spec` | Spec + plan | Production code |
| `/flow-execute` | Plan via subagents | Inline implementation |
| `/flow-patch` | Micro-spec + inline TDD | Subagent implementers |
| `/flow-debug` | Root cause analysis | Fixes before cause found |
| `/flow-verify` | Full test run + checklist | Auto-merge/push without user menu |
| `/flow-finish` | Merge/push/done + STATE/worktree cleanup | Re-run full verify (use `/flow-verify`) |
