<div align="center">

# 🌀 Flow

**Enter flow state with your AI Agents.**

Spec-driven software development workflow for teams and solo developers
working with AI coding agents. Guide an agent through brainstorming, specs,
TDD, review, verification, and merge.

</div>

---

## Quick start

```
/flow add email validation to the signup form
```

Flow suggests the next `/flow-*` command — **you invoke it** when ready.

## What to expect

Flow is a simple, explicit, solid workflow that focuses on correctness.

- **Describe the work** — one small change? `/flow-patch`. Several steps or a new feature? `/flow-spec` (see [Commands](#commands)).
- **Branches and worktrees** — implementation stays off `main`; the agent asks before creating a branch or worktree.
- **TDD by default** — each task starts with a failing test, then implementation, then green.
- **Review built in** — each task is reviewed for spec fit and correctness before the next.
- **Verify after work** — full test suite and code review before merge or push.

For full workflow details: [`docs/workflow.md`](docs/workflow.md)

## Commands

| Command | When to use |
|---------|-------------|
| `/flow` | Not sure where to start — triage only; suggests one command, **you invoke it** |
| `/flow-debug` | Bug, test failure, or unexpected behavior — root cause before fixes |
| `/flow-patch` | Small bounded change (≤3 files, one concern) — micro-spec + **inline** TDD + per-task review |
| `/flow-brainstorm` | Idea still fuzzy — explore options and design; then numbered handoff gate (patch, spec, or stop) — continues in-session after you pick |
| `/flow-spec` | Clear feature or multi-step change — spec gate → plan → branch gate → **subagent** tasks → verify (one session) |
| `/flow-execute` | Resume or cold start when the plan exists but the spec session ended (`phase: planned` or partial execute) |
| `/flow-verify` | Full test suite + requirements checklist + merge/push menu — auto-runs when spec implement or patch finishes; invoke standalone to re-check |
| `/flow-finish` | Merge locally, push, sync after GitHub PR merge, or close out — STATE, worktree, branch cleanup |

### Example usage

**"I want to add OAuth login"** (new feature, multiple steps)  
Start with `/flow-brainstorm` if the approach is still fuzzy — after the brief, pick **continue to spec** on the handoff gate (or patch if you prefer a micro-spec path). Spec runs through branch gate, artifact commit, subagent tasks, and verify. Merge or push from the verify menu or `/flow-finish`.

**"Fix a typo in the error message"** (small, one concern)  
`/flow-patch` → verify → `/flow-finish`.

**"This test started failing after the deploy"**  
`/flow-debug` to find root cause → `/flow-patch` to fix → verify → `/flow-finish`.

**"The spec and plan are already approved but I closed the session"**  
`/flow-execute` to resume from branch gate or Task 1 → verify → `/flow-finish`.

**"Tests pass — merge to main"**  
`/flow-finish`, or use the merge/push options from the verify menu.

**"Not sure where to start"**  
`/flow` — it suggests one next command; you invoke it.

**"PR merged on GitHub — sync local"**  
`/flow-finish` — pull main, delete local branch, remove worktree, clear `STATE.md`.

More detail: [`docs/workflow.md`](docs/workflow.md)

## Install

```bash
npx skills add gosukiwi/flow -a cursor --skill '*' -y
```

Installs to `.agents/skills/` (project). Add `-g` for global (`~/.cursor/skills/`). From a clone: `make install` or `npx skills add ./skills -a cursor --skill '*' -y`.

### Optional: [clean-code-skills](https://github.com/gosukiwi/clean-code-skills)

Enhances `/flow-verify` option 2 with full style + correctness review. Without it, Flow uses the bundled `correctness-reviewer` (branch mode).

```bash
npx skills add gosukiwi/clean-code-skills -a cursor --skill '*' -y
```

## In your project

Flow writes artifacts in your repo — not in the skill package:

```
docs/flow/
  brainstorms/   # optional exploration briefs (tracked)
  specs/         # approved requirements (tracked)
  plans/         # self-reviewed implementation plans (tracked)
  patches/       # patch micro-specs (tracked)
  STATE.md       # local session bookmark — add to .gitignore (agent offers on first write)
```

Specs, plans, patches, and brainstorms belong in git. `STATE.md` is a per-checkout resume pointer (phase, branch, workspace) — gitignore it so worktree sessions do not pollute `main`. Flow offers to add the gitignore entry before the first STATE write.

## Contributing

This repo ships skills to `skills/` and tests under `tests/`. After editing skills:

```bash
make test
npx skills add ./skills -a cursor --skill '*' -y --copy
```

Skill authoring and scenario testing: [`tests/writing-skills.md`](tests/writing-skills.md)

## License

MIT
