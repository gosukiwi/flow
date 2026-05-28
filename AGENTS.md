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
  control-plane.md         # Maintainer map — routing, gates, invariants (not shipped to agents)
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

## Maintainer change order

**Default:** every skillset change starts with the control plane, then proceeds to skills/scenarios/tests. Do not edit `skills/` or `flow-shared/` for a behavior change until the **human has reviewed and confirmed** the map (when the map applies).

| Step | Action | Done when |
|------|--------|-----------|
| **1 — Control plane** | Propose or edit `docs/control-plane.md` (gate order, invariants, handoffs, delegation); present the diff for review | **Human explicitly confirms** (e.g. approve, yes, continue) — or confirms no map change needed |
| **2+ — Iron Law** | **Only after Step 1 confirmation** — if discipline/gates/routing in shippable skills changed: scenario RED → skill GREEN | Per Iron Law table |
| **Last** | `make test`; reinstall locally when iterating skills | Static checks pass |

**Hard gate — after control-plane edits:** When you change `docs/control-plane.md`, **halt and wait for human confirmation** in the same session. Do **not** in the same turn or follow-up without approval: write scenarios, run subagent RED/GREEN, edit `skills/` or `flow-shared/`, or run `make test` for behavior tied to the new map. Proposing the map is not confirmation; the user must review and reply.

**Step 1 exceptions (skip map edit; still run `make test`):**

- Pure wording in `skills/` or `flow-shared/` with **no** gate, routing, handoff, or invariant change
- Mechanical fixes (e.g. `validate-skills.sh`, fixtures, typos) unrelated to Flow behavior
- New `flow-shared` prompt/ref with **no** new behavior (list in `flow-shared/SKILL.md` only)

When unsure whether the map applies, treat it as **yes** — propose control-plane updates first.

## Iron Law (discipline / gate changes under `skills/`)

Runs **after Step 1 (control plane)** when behavior changes. From `tests/writing-skills.md`: **no skill change without a failing scenario first.** If you already edited `SKILL.md` or `flow-shared/` before RED, that edit is **invalid** — revert or stash, run RED on the **committed (pre-change)** skills, then proceed.

**Mandatory order — do not reorder or skip steps:**

| Step | Action | Done when |
|------|--------|-----------|
| **2 — RED (write)** | Add or update `tests/scenarios/flow-<skill>-<violation>.md`; register in `tests/scenarios/README.md` | Scenario traps one specific rationalization (not abstract A/B/C) |
| **3 — RED (run)** | Launch a **Task subagent** with only the relevant skills at **pre-change** commit; paste the scenario; return the agent’s choice **verbatim** | Subagent picks the **non-compliant** option or rationalizes the violation |
| **4 — GREEN (edit)** | Edit `skills/` only after step 3 passes | Skill text blocks the rationalization you saw in RED; aligns with approved control plane |
| **5 — GREEN (run)** | Same subagent setup with **current** tree skills; paste the same scenario | Subagent picks the compliant option and cites the rule or gate |

Then run `make test`. Optional REFACTOR: tighten skill text or add a grep invariant in `validate-skills.sh`; re-run step 5.

**Forbidden before Step 1 human confirmation:**

- Editing `skills/**` or `flow-shared/**` for routing, gates, handoffs, or invariants without **explicit human approval** of the control-plane diff (when the map applies)
- Continuing to Iron Law (scenario or `skills/` edits) in the same turn as a control-plane change
- Treating user “go” on the overall task as approval of the map without a **reviewed** control-plane step (when the map was edited or proposed in that thread)

**Forbidden before Iron Law step 3 (RED run) completes:**

- Editing `skills/**` or `flow-shared/**` for the behavior under test
- Treating “the skill text looks correct” as RED
- Skipping Layer 2 because scenarios are manual
- Weakening a scenario so it passes on old skills

**Subagent RED/GREEN (default in maintainer sessions):** Use the Task tool — do not rely on this chat’s prior context. Install only relevant skills (`flow-<skill>`, `flow-shared`, and `flow` only when routing is under test). For RED, point the subagent at pre-change files (`git show HEAD:skills/...` or stash local edits). For GREEN, use the working tree after your edits.

**Exceptions (no scenario):** Pure wording with no gate/discipline change; new `flow-shared` prompts/refs with no new behavior — still run `make test`. When unsure, treat it as discipline and follow Maintainer change order + Iron Law steps 2–5.

Full detail: `tests/writing-skills.md` (authoring principles, scenario recipe, REFACTOR).

## What to read first

| Task | Read |
|------|------|
| Any skillset behavior change | `docs/control-plane.md` **first** (with user review), then `tests/writing-skills.md` — Iron Law |
| Discipline / gate edit only | `tests/writing-skills.md` — after control plane Step 1 |
| **See how everything fits (maintainer map)** | `docs/control-plane.md` — routing, gates, invariants |
| Understand user-facing workflow | `README.md`, `docs/workflow.md` |
| Router / STATE / path resolver | `skills/flow/SKILL.md` |
| Branch, session, worktree gates | `skills/flow-shared/references/{branch-gate,session-gate,worktree-setup}.md` |
| Adding a discipline scenario | `tests/scenarios/README.md` |

## Control plane (`docs/control-plane.md`)

Use `docs/control-plane.md` as the maintainer map for routing, gate order, handoffs, delegation, and invariants (I1–I17). It is **not** installed to consumer projects; runtime agents read `skills/**/SKILL.md` and `flow-shared/`.

**This is Maintainer change order Step 1** (see above) — not optional for routing, gate, handoff, or invariant work.

**Stop until the human confirms:** After you edit or propose changes to this file, **halt**. Present what changed (or the proposed diff). The human reviews; you proceed to scenarios and `skills/` only after they explicitly confirm. No self-approval, no “map looks fine — continuing.”

After **human confirmation** on the map (when it changed):

1. Sync only the affected `SKILL.md` / `flow-shared` files (and scenarios per Iron Law if discipline changed).
2. Run `make test`.

Do not regenerate the skillset from the map in one pass or put maintainer-only map prose into shippable skills. Skip control-plane edits only for the **Step 1 exceptions** listed under Maintainer change order.

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

Discipline skills require **control plane Step 1** then **Iron Law** (steps 2–5) — not just `make test`. See `tests/writing-skills.md`.

## RED → GREEN → REFACTOR (detail)

Iron Law steps 2–5 above; this section adds mechanics.

### Scenario file (Iron Law step 2)

Write `tests/scenarios/flow-<skill>-<violation>.md` using the recipe in `tests/writing-skills.md`. Register in `tests/scenarios/README.md`. Trap a **specific rationalization** (same-turn bundling, "no commit yet", skipping a gate) — not an abstract A/B/C quiz.

### Subagent run (Iron Law steps 3 and 5)

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

- New rationalization in GREEN → counter in skill text; re-run Iron Law step 5.
- Cheap grep invariant → `tests/static/validate-skills.sh` after GREEN proved the rule matters.

## Typical maintainer workflow

1. **Control plane (Step 1):** read `docs/control-plane.md`; propose or edit the map; **halt for human review and confirmation** before any scenario or `skills/` work.
2. **Discipline or gate change (after Step 1 confirmed):** Iron Law steps 2–5 — scenario → subagent RED → edit skills (matching approved map) → subagent GREEN → `make test`. Never edit `skills/` before RED run.
3. **Non-discipline changes** (wording only, no map impact): edit `skills/` directly after Step 1 confirms no map change, then `make test`.
4. Reinstall locally when iterating: `npx skills add ./skills -a cursor --skill '*' -y --copy`.
5. Commit only when the user asks.

## Editing guidelines

- **Control plane first, then halt.** Edit or propose the map, **stop for human confirmation**, then Iron Law; subagent RED before any `skills/` edit for discipline changes (Iron Law steps 2–5).
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

1. **Control plane:** update gate order and invariants (I1–I17); **halt until human confirms** (Maintainer change order Step 1).
2. **Iron Law:** scenario → **Task subagent RED** on pre-change skills → edit `flow-shared/references/*.md` or `SKILL.md` → **Task subagent GREEN** → optional REFACTOR in `validate-skills.sh` → `make test`.

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
| Workflow artifacts | `tests/fixtures/` only | `docs/flow/{brainstorms,specs,plans,patches}` tracked; `STATE.md` local/gitignored |
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
