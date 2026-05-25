# Flow workflow (detailed)

Reference for users who want more than the [README](../README.md). Agents read the skill files under `skills/` — this doc is for humans.

## Typical paths

| Situation | Path |
|-----------|------|
| Small fix (≤3 files, one concern) | `/flow-patch` → verify → `/flow-finish` (merge/push) |
| Bug or failing test | `/flow-debug` → `/flow-patch` → verify → `/flow-finish` |
| New feature (multi-step) | `/flow-brainstorm` (optional) → `/flow-spec` (auto-continues to execute) → verify → `/flow-finish` |
| Plan already written | `/flow-execute` → verify → `/flow-finish` |
| Tests done, ready to merge/push | `/flow-finish` (or verify menu options 1–4) |
| Not sure where to start | `/flow` — preferred entrypoint; stale post-PR cleanup or new work |
| PR merged on GitHub, local branch/STATE left over | `/flow-finish` → sync after remote merge (or `/flow` to detect first) |

## Execute vs patch

| | `/flow-execute` | `/flow-patch` |
|---|-----------------|---------------|
| **When** | Approved plan with multiple tasks | Single bounded change |
| **Who implements** | Subagents (orchestrator coordinates) | Inline in your session |
| **Reviews** | Spec + correctness reviewer per task | Same, per task |
| **TDD** | Required per plan task | Required per micro-spec task |

Do not run plan execution inline — that is what `/flow-patch` is for on small scope, or split the work into a proper plan for `/flow-execute`.

## What happens in each phase

- **`/flow-brainstorm`** — explore options; no production code. Saves brief to `docs/flow/brainstorms/`.
- **`/flow-spec`** — user-approved spec + AI self-reviewed plan. No production code.
- **`/flow-execute`** — subagents run plan tasks serially: implement → spec review → correctness review → next task.
- **`/flow-patch`** — micro-spec approval, then inline TDD with the same review loop per task.
- **`/flow-debug`** — root cause before fixes; routes to patch or spec.
- **`/flow-verify`** — full test run + requirements checklist; user menu (merge / push / review / done).
- **`/flow-finish`** — merge locally, push, sync after remote PR merge, or close out with STATE and worktree cleanup.
- **`/flow`** — triage first; detects stale local branch + `STATE.md` after GitHub merge before routing new work.

Per-task reviews run during execute and patch. `/flow-verify` is not a full diff review — optional **option 3** is a whole-branch review before merge or push (see [clean-code-skills](https://github.com/gosukiwi/clean-code-skills) in the README). Finish actions (merge, push, `phase: done`, worktree remove) live in `/flow-finish` and `finish-gate.md`.

## STATE.md

`docs/flow/STATE.md` is the agent's **local session bookmark**: current phase, branch, workspace, and paths to brief/spec/plan. One file per checkout (worktrees get their own copy).

**Gitignore it** in consumer projects. Specs, plans, and brainstorms are the durable record — STATE is ephemeral (phase churn, worktree paths). Flow offers to add `docs/flow/STATE.md` to `.gitignore` before the first write (`state-setup.md`). Opt out explicitly if you want STATE in git history.

**Worktree note:** STATE in the worktree is also local/gitignored — never commit stale main-workspace STATE while work runs in a worktree.

## Branch, workspace, and concurrent sessions

- All implementation on a **feature branch** — never on `main`/`master` without explicit approval.
- The agent **asks before** creating branches or worktrees.
- **In-place** — switch branch in this workspace.
- **Worktree** — new branch in `.worktrees/<slug>/` (must be gitignored); main workspace stays unchanged. Each worktree has its own `STATE.md`.
- **Session gate** — before overwriting `STATE.md`, unrelated new work on an occupied checkout stops and offers resume vs worktree.
- **Same branch, two terminals** — git cannot isolate two checkouts on one branch; coordinate manually or use a worktree with a different branch for unrelated work.

Skill references (installed with Flow): `flow-shared/references/branch-gate.md`, `session-gate.md`, `worktree-setup.md`, `state-setup.md`.

## Router behavior

`/flow` triages only — it suggests one command and **stops**. It does not auto-start brainstorm, spec, patch, or execute. Invoke the suggested `/flow-*` command yourself.
