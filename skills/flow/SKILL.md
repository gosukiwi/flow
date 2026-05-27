---
name: flow
description: Router for the flow development workflow. Invoke with /flow to triage and suggest the right /flow-* command.
disable-model-invocation: true
metadata:
  flow:
    command: /flow
    role: router
---

# Flow Router

**Triggered by:** `/flow`

Explicit workflow for spec-driven development with TDD, subagents, and verification gates.

## Commands

| Command | When to use |
|---------|-------------|
| `/flow-brainstorm` | Fuzzy idea — explore options and design before spec |
| `/flow-spec` | New feature or multi-step change — needs spec + plan |
| `/flow-execute` | Approved spec exists; run the plan with subagents |
| `/flow-patch` | Single bounded change (≤3 files, one concern) |
| `/flow-debug` | Bug, test failure, or unexpected behavior |
| `/flow-verify` | Full test suite + requirements checklist + merge/push menu — auto-runs when execute or patch finishes |
| `/flow-finish` | Merge locally, push branch, or close out — STATE + worktree cleanup; use when user says "merge to main" outside the menu |

## Decision Tree

```
New work?
├─ Bug or test failure? → /flow-debug
├─ Small bounded change? → /flow-patch
├─ Idea fuzzy or needs exploration? → /flow-brainstorm
│   ├─ Small bounded scope? → /flow-patch
│   └─ Multi-step or multi-concern? → /flow-spec
├─ Direction clear, ready to lock requirements? → /flow-spec
└─ Plan already written? → /flow-execute

Implementation done?
├─ Tests/checklist not confirmed? → /flow-verify
└─ Verify passed or user says merge/push/done? → /flow-finish (or verify menu → finish-gate)
```

## path resolver

Before reading shared prompts or references, resolve `flow-shared`:

1. `.agents/skills/flow-shared/`
2. `.cursor/skills/flow-shared/`
3. `~/.cursor/skills/flow-shared/`

Prompt files live at `{flow-shared}/prompts/{name}.md`.

Project artifacts live in the **consumer project** (not in the skill package):

```
docs/flow/
  brainstorms/   # tracked — optional exploration briefs
  specs/         # tracked — approved requirements
  plans/         # tracked — self-reviewed implementation plans
  STATE.md       # local only — gitignore (session bookmark; see state-setup.md)
```

Update `docs/flow/STATE.md` when starting or finishing a phase. **Gitignore recommended** — read `flow-shared/references/state-setup.md` before first write if not ignored. Specs, plans, and brainstorms stay in version control.

```markdown
# Flow State

phase: brainstorm | spec | planned | execute | patch | debug | verify | done
brainstorm: docs/flow/brainstorms/YYYY-MM-DD-topic.md
spec: docs/flow/specs/YYYY-MM-DD-topic.md
plan: docs/flow/plans/YYYY-MM-DD-topic.md
workspace: in-place | worktree
worktree: .worktrees/feature-topic   # when workspace: worktree
branch: feature/topic
updated: YYYY-MM-DD
```

Do not invoke `flow-shared` directly — resolve it via the path resolver above for prompts and references.

Implementation skills (`flow-execute`, `flow-patch`) must follow `flow-shared/references/session-gate.md` and `flow-shared/references/branch-gate.md` (resolve via path resolver in `flow/SKILL.md`) — ask before overwriting STATE or mutating branches/worktrees.

## When `/flow` is invoked

`/flow` is a **triage concierge** — not brainstorm, spec, patch, debug, execute, verify, or finish. Help the user pick the right `/flow-*` command; **do not run that workflow** until they invoke it.

1. Read the user's message and `docs/flow/STATE.md` (if present) for current phase and artifact paths
2. If `STATE.md` `branch` differs from `git branch --show-current`, run `git worktree list` — if a worktree matches the STATE branch, suggest `cd` to that path to resume
3. If active STATE + unrelated user message, warn about possible conflict — suggest resume or worktree before recommending `/flow-brainstorm` or `/flow-spec`
4. Apply the decision tree above — ask **one clarifying question at a time** if the route is unclear (skip if intent is obvious)
5. **Merge/push/done with verify already passed** (`phase: verify`, or user confirms tests green) → recommend **`/flow-finish`**, not another `/flow-verify`
6. Recommend **one** `/flow-*` command with a short **why** and, if helpful, what **not** to use
7. If `STATE.md` shows work in progress, mention **resume** (e.g. plan exists → suggest `/flow-execute`)
8. **Stop.** Wait for the user to manually invoke the suggested command

**Hard gate:** Do not proceed to §How to Start for a child skill in the same turn as your suggestion. Do not read child `SKILL.md` files, write micro-specs, write specs/plans, edit code, or run tests while triaging under `/flow`.

**Forbidden in the same message as a suggestion:**

- Starting micro-spec, spec, plan, debug, execute, verify, or finish work
- "Loading `/flow-patch`…", "Starting Task 1…", or equivalent auto-start language
- Bundling suggestion + first step of the target workflow

If the user already invoked a specific `/flow-*` command (not `/flow`), read that skill's `SKILL.md` per **How to Start** below — do not triage.

## How to Start

Read the skill matching the user's command:

- `/flow` → triage only (see **When `/flow` is invoked** above); do not load child skills until user invokes them
- `/flow-brainstorm` → read `flow-brainstorm/SKILL.md`
- `/flow-spec` → read `flow-spec/SKILL.md`
- `/flow-execute` → read `flow-execute/SKILL.md`
- `/flow-patch` → read `flow-patch/SKILL.md`
- `/flow-debug` → read `flow-debug/SKILL.md`
- `/flow-verify` → read `flow-verify/SKILL.md`
- `/flow-finish` → read `flow-finish/SKILL.md`

Follow that skill exactly. Do not skip gates.
