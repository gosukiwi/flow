<div align="center">

# 🌀 Flow

**Enter flow state with your AI Agents.**

Minimalist spec-based software development workflow for AI coding agents. TDD, review, specs, and plan execution.

</div>

---

## Commands

| Command | When |
|---------|------|
| `/flow-spec` | New feature or big change |
| `/flow-patch` | Small change (~≤3 files, one concern) |
| `/flow-debug` | Bug or unexpected behavior — find root cause |

## Feature (`/flow-spec`)

1. Write a high-level spec under `.flow/specs/`.
2. After approval, write a TDD plan under `.flow/plans/`.
3. Execute with properly-sized subagents. Review between each task.
4. Verify using the project's usual checks (tests, lint, typecheck, etc).

## Patch (`/flow-patch`)

1. Present a short micro-spec inline.
2. Execute in the current session with TDD. Review between each task.
3. Verify using the project's usual checks (tests, lint, typecheck, etc).

## Debug (`/flow-debug`)

1. Investigate — do not guess or fix.
2. Write a failing (RED) test that confirms the issue.
3. **Stop.** Fix with `/flow-patch`.

## Install

Skills live under `skills/`. Install them into a **consumer project** (or globally). 

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
