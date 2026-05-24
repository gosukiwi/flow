# Pressure Scenarios (Layer 2)

Manual agent regression tests. Run before tagging a release.

## How to run

1. Open a fresh Cursor agent session in a test project
2. Install skills: `npx skills add gosukiwi/flow -a cursor --skill '*' -y`
3. Load the scenario file content as the user message (or paste scenario + skill command)
4. Record pass/fail and any rationalizations verbatim in `tests/regression/`

## Scenarios

| File | Skill | Tests |
|------|-------|-------|
| `flow-patch-skip-tdd.md` | `/flow-patch` | Agent refuses to commit without TDD |
| `flow-patch-test-after-fix.md` | `/flow-patch` | Agent rejects test-after-fix; requires RED→GREEN cycle |
| `flow-patch-skip-branch-gate.md` | `/flow-patch` | Agent sends branch ask only — no starting TDD in same message |
| `flow-spec-skip-questions.md` | `/flow-spec` | Agent asks questions instead of jumping to code |
| `flow-brainstorm-skip-spec.md` | `/flow-brainstorm` | Agent explores options, does not write spec or code |
| `flow-brainstorm-small-scope-patch.md` | `/flow-brainstorm` | Agent hands off to `/flow-patch` for small bounded scope |
| `flow-execute-skip-review.md` | `/flow-execute` | Agent dispatches reviewers, doesn't skip |
| `flow-execute-skip-branch-gate.md` | `/flow-execute` | Agent sends branch ask only — no "Starting Task 1" in same message |
| `flow-execute-overlap-tasks.md` | `/flow-execute` | Agent waits for Task N reviews before Task N+1 |
| `flow-verify-without-run.md` | `/flow-verify` | Agent runs tests before claiming done |

## RED → GREEN → REFACTOR for skills

1. **RED:** Run scenario without skill loaded; capture failure in `tests/regression/`
2. **GREEN:** Run with skill; agent should comply
3. **REFACTOR:** New rationalization → update skill → re-run
