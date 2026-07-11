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

```bash
npx skills add gosukiwi/flow --skill '*'
```

### Manual

Copy (or symlink) each skill directory into your agent's skills folder:

**Project-local:**

```bash
mkdir -p .agents/skills # this will depend on your coding agent (Claude, Cursor, Codex, etc)
cp -R /path/to/flow/skills/* .agents/skills/
```

**Global:**

```bash
mkdir -p ~/.agents/skills
cp -R /path/to/flow/skills/* ~/.agents/skills/
```

You need all four directories: `flow-spec`, `flow-patch`, `flow-debug`, and `flow-shared`.

## Testing

Pressure scenarios live under `tests/scenarios/`. List them with `make test-scenarios`. Run via Task subagent — see `tests/writing-skills.md`.
