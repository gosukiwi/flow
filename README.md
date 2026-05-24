# 🌀 Flow

**Enter flow state with your AI Agents.**

A **simple, minimal, and explicit** software development workflow for Cursor and compatible agents: `/flow-*` commands, TDD, subagents, verification gates, and worktrees.

## Quick start

```
/flow add email validation to the signup form
```

Flow suggests the next `/flow-*` command — **you invoke it** when ready.

## Commands

| Command | When to use |
|---------|-------------|
| `/flow` | Not sure where to start — triage only; suggests one command, **you invoke it** |
| `/flow-debug` | Bug, test failure, or unexpected behavior — root cause before fixes |
| `/flow-patch` | Small bounded change (≤3 files, one concern) — micro-spec + **inline** TDD + per-task review |
| `/flow-brainstorm` | Idea still fuzzy — explore options and design before formal spec |
| `/flow-spec` | Clear feature or multi-step change — user-approved spec + AI self-reviewed plan |
| `/flow-execute` | Plan already approved — **subagents** run tasks with two-stage review per task |
| `/flow-verify` | Full test suite + requirements checklist + merge/push menu — auto-runs when execute or patch finishes; invoke standalone to re-check or resume |

Typical paths: new feature → `/flow-brainstorm` → `/flow-spec` → `/flow-execute` → verify; small fix → `/flow-patch` → verify; bug → `/flow-debug` → patch or spec. More detail: [`docs/workflow.md`](docs/workflow.md)

## Install

```bash
npx skills add gosukiwi/flow -a cursor --skill '*' -y
```

Installs to `.agents/skills/` (project). Add `-g` for global (`~/.cursor/skills/`). From a clone: `make install` or `npx skills add ./skills -a cursor --skill '*' -y`.

### Optional: [clean-code-skills](https://github.com/gosukiwi/clean-code-skills)

Enhances `/flow-verify` option 3 with full style + correctness review. Without it, Flow uses the bundled `correctness-reviewer` (branch mode).

```bash
npx skills add gosukiwi/clean-code-skills -a cursor --skill '*' -y
```

## In your project

Flow writes artifacts in your repo — not in the skill package:

```
docs/flow/
  brainstorms/   # optional exploration briefs
  specs/         # approved requirements
  plans/         # self-reviewed implementation plans
  STATE.md       # resume pointer: phase, branch, artifact paths
```

## Key rules

- **Feature branch** for implementation — agent asks before switching branches or creating worktrees.
- **`/flow-execute` = subagents.** **`/flow-patch` = inline.** Don't mix them for the same plan.
- **`/flow-verify`** runs automatically when execute or patch finish — full tests + requirements checklist before the merge/push menu.

Branch, worktree, and concurrent-session details: [`docs/workflow.md`](docs/workflow.md)

## Contributing

This repo ships skills to `skills/` and tests under `tests/`. After editing skills:

```bash
make test
npx skills add ./skills -a cursor --skill '*' -y --copy
```

Skill authoring and scenario testing: [`tests/writing-skills.md`](tests/writing-skills.md)

## License

MIT
