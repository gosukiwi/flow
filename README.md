<div align="center">

# 🌀 Flow

**Enter flow state with your AI Agents.**

Minimalist spec-based software development workflow for AI coding agents. TDD, review, specs, and plan execution.

</div>

---

## Commands

| Command | When |
|---------|------|
| `/flow-spec` | New feature or multi-step change — spec → plan → subagent tasks → verify |
| `/flow-patch` | Small change (~≤3 files, one concern) — micro-spec → inline TDD + inline review → verify |
| `/flow-debug` | Bug or unexpected behavior — find root cause, write a RED test, stop |

## Feature (`/flow-spec`)

1. Write a high-level, unambiguous spec under `.flow/specs/` (files touched, contracts: types, persistence, APIs/boundaries).
2. After the user is happy with the spec, write a sequential TDD plan under `.flow/plans/`.
3. Execute each plan task with a **subagent**. After each task, a **review** subagent checks the work before the next task.
4. When all tasks are done: **verify** — project's usual checks (tests, lint, typecheck, formatters, build) + Success Criteria. User owns merge/push.

## Patch (`/flow-patch`)

1. Present a short micro-spec **inline** (problem, success criteria, files, TDD tasks) — no artifact file.
2. Execute **inline** in the current session with TDD.
3. Review each task **inline** before the next (same checklist as the reviewer prompt — no subagent).
4. Verify (tests, lint, typecheck, formatters, build + Success Criteria). User owns merge/push.

## Debug (`/flow-debug`)

1. Investigate — do not guess or fix.
2. Write a failing (RED) test that confirms the issue.
3. **Stop.** Fix with `/flow-patch`.

## Artifacts

All local, gitignored:

```
.flow/
  specs/YYYY-MM-DD-topic.md
  plans/YYYY-MM-DD-topic.md
```

Patches stay in chat only (no `.flow/` file).

Add to the consumer project's `.gitignore`:

```
.flow/
```

## Install

Skills live under `skills/`. Install them into a **consumer project** (or globally). After install, add `.flow/` to that project's `.gitignore` (see [Artifacts](#artifacts)).

### With `npx skills` (recommended)

From a clone of this repo, in the consumer project:

```bash
npx skills add /path/to/flow/skills -a cursor --skill '*' -y
```

| Flag | Meaning |
|------|---------|
| `-a cursor` | Cursor agent skills |
| `--skill '*'` | All skills (`flow-spec`, `flow-patch`, `flow-debug`, `flow-shared`) |
| `-y` | Non-interactive |
| `-g` | Global install → `~/.cursor/skills/` (omit for project → `.agents/skills/`) |
| `--copy` | Copy files instead of linking — use when iterating on skill text |

Examples:

```bash
# Project-local
npx skills add /path/to/flow/skills -a cursor --skill '*' -y

# Global
npx skills add /path/to/flow/skills -a cursor --skill '*' -y -g

# Reinstall while editing skills (copy so updates land immediately)
npx skills add /path/to/flow/skills -a cursor --skill '*' -y --copy
```

If this package is published on GitHub, you can point at the repo instead of a local path (same flags):

```bash
npx skills add <owner>/<repo> -a cursor --skill '*' -y
```

### Manual

Copy (or symlink) each skill directory into Cursor's skills folder:

**Project-local** (shared with the repo):

```bash
mkdir -p .cursor/skills   # or .agents/skills
cp -R /path/to/flow/skills/* .cursor/skills/
```

**Global** (all projects):

```bash
mkdir -p ~/.cursor/skills
cp -R /path/to/flow/skills/* ~/.cursor/skills/
```

You need all four directories: `flow-spec`, `flow-patch`, `flow-debug`, and `flow-shared` (shared prompts/references).

### Verify

In Cursor, invoke `/flow-spec`, `/flow-patch`, or `/flow-debug` — the matching skill should load.

## Testing

Pressure scenarios live under `tests/scenarios/`. List them with `make test-scenarios`. Run via Task subagent — see `tests/writing-skills.md`.
