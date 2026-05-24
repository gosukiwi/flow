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

## What to read first

| Task | Read |
|------|------|
| Any skill edit | `tests/writing-skills.md` |
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
| **2 — Scenarios** | Manual: paste `tests/scenarios/flow-*.md` into fresh agent session | Before release; when hardening discipline |
| **3 — Dogfood** | Use `/flow-*` on real work in Cursor | Ongoing |

Discipline skills (gates, TDD, review loops) require the **RED → GREEN → REFACTOR** cycle below — not just static checks. See also `tests/writing-skills.md`.

## RED → GREEN → REFACTOR (skill changes)

**Required for any discipline or gate change.** Do not edit skills first and write the scenario afterward — the scenario must fail on the old behavior before you change anything.

### 1. RED — create the scenario test

Write `tests/scenarios/flow-<skill>-<violation>.md` using the recipe in `tests/writing-skills.md`. Register it in `tests/scenarios/README.md`.

The scenario must trap a **specific rationalization** (same-turn bundling, "no commit yet", skipping a gate, etc.) — not an abstract A/B/C quiz.

### 2. RED — run the scenario and see it fail

1. Open a **fresh Cursor agent session** (no prior context from this edit) **or** launch a Task subagent with only the relevant skills at the pre-change commit — see **When you cannot open a fresh session** below.
2. Install **only the relevant skills** — not unrelated skills that could override Flow behavior:
   ```bash
   npx skills add ./skills -a cursor --skill 'flow-<skill>' --skill flow-shared -y --copy
   ```
   Add `flow` (router) only when the scenario tests routing. For execute/patch scenarios, include `flow-shared` (shared gates/refs).
3. Paste the scenario file content as the user message. Invoke the matching `/flow-*` command if the scenario expects it.
4. **Confirm RED:** the agent chooses the non-compliant option or rationalizes the violation. Record the choice (notes or PR — optional). If the agent already passes, the scenario is too weak — sharpen it before proceeding.

Use the **committed (pre-change) skills** for this run — stash local edits or test from the last good commit (`git show <base>:skills/...` for subagent runs).

### 3. GREEN — update skills

Edit `SKILL.md` and/or `flow-shared/references/*.md` to block the rationalization you observed in RED.

Reinstall the changed skills:

```bash
npx skills add ./skills -a cursor --skill 'flow-<skill>' --skill flow-shared -y --copy
```

### 4. GREEN — run the scenario again and see it pass

Same setup as step 2 (fresh session or subagent, **only relevant skills**). Paste the same scenario.

**Confirm GREEN:** the agent chooses the compliant option and cites the rule or gate. If it still fails, iterate on the skill text — do not weaken the scenario to match sloppy behavior.

Run `make test` after GREEN. Re-run the scenario manually before release (`make test-scenarios` lists files).

### When you cannot open a fresh session

1. **Task subagent** — paste the scenario; point the subagent at skills via `git show <base>:skills/...` (RED) or current tree (GREEN); return choice verbatim.
2. **Ask the user** — stop before commit and request a manual Layer 2 run (`make test-scenarios` lists files).

Never skip RED/GREEN because Layer 2 is manual or because the skill text "looks correct."

### 5. REFACTOR — plug remaining holes (optional)

- New rationalization in the GREEN run → add counter (red flag, forbidden same-turn action) and re-run the scenario.
- If the rule is cheap to grep and the scenario proved it matters, add an invariant to `tests/static/validate-skills.sh`.
- Re-run the scenario; stay GREEN.

## Typical maintainer workflow

1. Identify which skill(s) and shared references need changes.
2. **Discipline/gate changes:** follow **RED → GREEN → REFACTOR** during development — scenario first, fail on old skills, then edit skills, then pass. Run affected scenarios manually before release.
3. **Non-discipline changes** (wording, docs in skills): edit directly, then `make test`.
4. Reinstall locally when iterating: `npx skills add ./skills -a cursor --skill '*' -y --copy`.
5. Commit only when the user asks.

## Editing guidelines

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

Follow **RED → GREEN → REFACTOR** in order:

1. Write the pressure scenario → run in a fresh agent with only relevant skills → **see RED**.
2. Update `flow-shared/references/*.md` or skill `SKILL.md` → reinstall → run scenario again → **see GREEN**.
3. Optionally add a grep invariant to `tests/static/validate-skills.sh` (REFACTOR).
4. `make test`.

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

**[clean-code-skills](https://github.com/gosukiwi/clean-code-skills)** enhances `/flow-verify` option 3. Without it, Flow uses the bundled `correctness-reviewer.md` (branch mode). Do not assume clean-code-skills is present when editing verify behavior.

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
