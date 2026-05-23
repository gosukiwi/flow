# Flow

**Enter flow state with your AI Agents.**

A solid yet simple development rhythm for Cursor and compatible agents: explicit `/flow-*` commands, TDD, subagents, and clear gates — without heavyweight process.

Repo: [github.com/gosukiwi/flow](https://github.com/gosukiwi/flow)

## Commands

| Command | Purpose |
|---------|---------|
| `/flow` | Router and path resolver |
| `/flow-brainstorm` | Explore ideas and design before formal spec |
| `/flow-spec` | Spec (user-approved) + plan (AI self-reviewed) |
| `/flow-execute` | Execute plan via subagents + two-stage review |
| `/flow-patch` | Micro-spec + subagents for small changes |
| `/flow-debug` | Root cause investigation before fixes |
| `/flow-verify` | Fresh verification before claiming done |

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
/flow-brainstorm → explore (optional) → /flow-spec → user approves spec → AI self-reviews plan
/flow-execute  → subagents (TDD → spec review → code quality review)
/flow-verify   → run tests + requirements checklist
```

Small changes: `/flow-patch`. Bugs: `/flow-debug` → `/flow-patch`.

Code review for style/team standards is **out of scope** — use your external code review skillset after `/flow-verify`.

## Branch rules

- Feature branch for all implementation
- Never commit on `main`/`master` without explicit approval

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
