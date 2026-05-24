# 🌀 Flow

**Enter flow state with your AI Agents.**

A solid, explicit, and minimal development workflow for Cursor and compatible agents: explicit `/flow-*` commands, TDD, subagents, and verification gates.

## TLDR

**New feature?** Start with `/flow-brainstorm`. Eg:

```
/flow-brainstorm let's implement this new feature
```

**Not sure?** Start with `/flow` — it routes you to the right step.

The agents will guide you from there. See below for detailed information on all included workflows.

## Commands

| Command | Purpose |
|---------|---------|
| `/flow` | Router and path resolver |
| `/flow-brainstorm` | Explore ideas and design before formal spec |
| `/flow-spec` | Spec (user-approved) + plan (AI self-reviewed) |
| `/flow-execute` | Execute plan via subagents + two-stage review per task |
| `/flow-patch` | Micro-spec + inline TDD + per-task review |
| `/flow-debug` | Root cause investigation before fixes |
| `/flow-verify` | Tests + spec checklist; user menu when done |

## Install

From GitHub:

```bash
npx skills add gosukiwi/flow -a cursor --skill '*' -y
```

From a local clone:

```bash
git clone https://github.com/gosukiwi/flow.git
cd flow
npx skills add ./skills -a cursor --skill '*' -y
# or
make install
```

Global install:

```bash
npx skills add gosukiwi/flow -a cursor --skill '*' -g -y
```

Installs to `.agents/skills/` (project) or `~/.cursor/skills/` (global). Includes `flow-shared` (prompts bundle).

## Layout

```
skills/                    # installed into consumer project
  flow/
  flow-brainstorm/
  flow-spec/
  flow-execute/
  flow-patch/
  flow-debug/
  flow-verify/
  flow-shared/             # internal — prompts + references
tests/                     # maintainer only — not installed
```

### Shared prompts

Live in `skills/flow-shared/prompts/`:

- `implementer.md`
- `spec-reviewer.md`
- `code-quality-reviewer.md`

Orchestrator skills resolve paths via the resolver in `flow/SKILL.md`:

1. `.agents/skills/flow-shared/`
2. `.cursor/skills/flow-shared/`
3. `~/.cursor/skills/flow-shared/`

### Project artifacts

Created in the **consumer project**, not in the skill package:

```
docs/flow/
  brainstorms/
  specs/
  plans/
  STATE.md
```

## Workflow

```
/flow-brainstorm → explore (optional) → small scope? → /flow-patch
                                      → larger scope? → /flow-spec → user approves spec → AI self-reviews plan
/flow-execute    → subagents (TDD → spec review → code quality review per task)
/flow-patch      → inline TDD → self-review → spec + code quality review per task
/flow-verify     → tests + requirements checklist → user menu (merge / push / review / done)
```

Small changes: `/flow-patch` → `/flow-verify`. Bugs: `/flow-debug` → `/flow-patch`.

Per-task reviews run during execute and patch. For an extra whole-change pass, review the diff yourself or invoke a project skill (e.g. `clean-code-reviewer`) — optional, via verify option 3.

## Branch rules

- Feature branch for all implementation; never commit on `main`/`master` without explicit approval
- **Ask before creating or switching branches** — propose a name or wait for the user to say where to work

**Planned:** Git worktree support — isolated checkout per feature without switching branches in the main workspace. Not in v1; branch gate + user confirmation is the current model.

## Testing this repo

```bash
make test           # Layer 1 static validators
make test-scenarios # Layer 2 scenario list + manual agent runs
```

Layer 2 uses RED→GREEN→REFACTOR for skill changes. See [`tests/writing-skills.md`](tests/writing-skills.md).

## Development

After editing skills:

```bash
make test
npx skills add ./skills -a cursor --skill '*' -y --copy
```

**Hardening a discipline skill?** Follow [`tests/writing-skills.md`](tests/writing-skills.md) — write a pressure scenario, RED on old skill, GREEN after fix, log in [`tests/regression/`](tests/regression/).

## License

MIT
