# 🌀 Flow

**Enter flow state with your AI Agents.**

A **simple, minimal, and explicit** software development workflow for Cursor and compatible agents: `/flow-*` commands, TDD, subagents, verification gates, and worktrees.

## Quick start

```
/flow add email validation to the signup form
```

Flow suggests the next `/flow-*` command — **you invoke it** when ready.

## Commands

| Command | Purpose |
|---------|---------|
| `/flow` | Triage — suggests which `/flow-*` command to run next |
| `/flow-brainstorm` | Explore ideas and design before formal spec |
| `/flow-spec` | Spec (user-approved) + plan (AI self-reviewed) |
| `/flow-execute` | Execute plan via **subagents** + two-stage review per task |
| `/flow-patch` | Micro-spec + **inline** TDD + per-task review |
| `/flow-debug` | Root cause investigation before fixes |
| `/flow-verify` | Tests + spec checklist; user menu when done |

## Which command?

| Situation | Start with |
|-----------|------------|
| Not sure | `/flow` |
| Bug or test failure | `/flow-debug` |
| Small fix (≤3 files, one concern) | `/flow-patch` |
| Idea still fuzzy | `/flow-brainstorm` |
| Clear feature, needs spec + plan | `/flow-spec` |
| Plan already approved | `/flow-execute` |
| Implementation done | `/flow-verify` |

More detail: [`docs/workflow.md`](docs/workflow.md)

## Install

```bash
npx skills add gosukiwi/flow -a cursor --skill '*' -y
```

Installs to `.agents/skills/` (project). Add `-g` for global (`~/.cursor/skills/`). From a clone: `make install` or `npx skills add ./skills -a cursor --skill '*' -y`.

### Optional: [clean-code-skills](https://github.com/gosukiwi/clean-code-skills)

Enhances `/flow-verify` option 3 with full style + correctness review. Without it, Flow uses a bundled correctness-only reviewer.

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
- **`/flow-verify`** before calling work done — tests + requirements checklist.

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
