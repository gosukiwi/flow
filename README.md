# Flow Skillset

Minimal explicit workflow for spec-driven development with TDD, subagents, and verification gates.

Designed for Cursor CLI + Composer where ambient skill auto-trigger is unreliable. Invoke phases explicitly with `/flow-*` commands.

## Commands

| Command | Purpose |
|---------|---------|
| `/flow` | Router and path resolver |
| `/flow-spec` | Spec (user-approved) + plan (AI self-reviewed) |
| `/flow-execute` | Execute plan via subagents + two-stage review |
| `/flow-patch` | Micro-spec + subagents for small changes |
| `/flow-debug` | Root cause investigation before fixes |
| `/flow-verify` | Fresh verification before claiming done |

## Install

From GitHub (once published):

```bash
npx skills add <owner>/flow-skillset -a cursor --skill '*' -y
```

From this repo locally:

```bash
npx skills add ./skills -a cursor --skill '*' -y
# or
make install
# or
FLOW_SKILLS_REPO=you/flow-skillset ./scripts/install.sh
```

Global install:

```bash
npx skills add <owner>/flow-skillset -a cursor --skill '*' -g -y
```

Installs to `.agents/skills/` (project) or `~/.cursor/skills/` (global). Includes `flow-shared` (prompts bundle).

## Layout

```
skills/                    # installed into consumer project
  flow/
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
  specs/
  plans/
  STATE.md
```

## Workflow

```
/flow-spec     → user approves spec → AI writes + self-reviews plan
/flow-execute  → subagents (TDD → spec review → code quality review)
/flow-verify   → run tests + requirements checklist
```

Small changes: `/flow-patch`. Bugs: `/flow-debug` → `/flow-patch`.

Code review for style/team standards is **out of scope** — use your external code review skillset after `/flow-verify`.

## Branch rules

- Feature branch for all implementation
- Never commit on `main`/`master` without explicit approval
- Git worktrees: planned for a future version

## Testing this repo

```bash
make test           # Layer 1 static validators
make test-scenarios # Layer 2 manual (see tests/scenarios/)
```

## Development

After editing skills:

```bash
make test
npx skills add ./skills -a cursor --skill '*' -y --copy
```

## License

MIT
