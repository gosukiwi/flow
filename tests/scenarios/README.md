# Pressure Scenarios (Layer 2)

Manual agent regression tests. Run before tagging a release.

**Full process:** [`../writing-skills.md`](../writing-skills.md) — RED→GREEN→REFACTOR, scenario recipe, when to test.

## How to run

1. Open a fresh Cursor agent session in a test project
2. Install skills: `npx skills add gosukiwi/flow -a cursor --skill '*' -y`
3. Load the scenario file content as the user message (or paste scenario + skill command)
4. Record pass/fail and any rationalizations in your notes or PR description

## Scenarios

| File | Skill | Tests |
|------|-------|-------|
| `flow-router-manual-handoff.md` | `/flow` | Agent suggests a `/flow-*` command; user must invoke it — no auto-start |
| `flow-router-suggest-spec.md` | `/flow` | Large/multi-step work → suggests `/flow-spec` only, no micro-spec or patch |
| `flow-router-suggest-debug.md` | `/flow` | Unknown test failures → suggests `/flow-debug` only, no auto-investigation |
| `flow-router-suggest-brainstorm.md` | `/flow` | Fuzzy idea → suggests `/flow-brainstorm` only, no spec or exploration start |
| `flow-patch-skip-tdd.md` | `/flow-patch` | Agent refuses to commit without TDD |
| `flow-patch-skip-review.md` | `/flow-patch` | Agent dispatches reviewers; doesn't skip when user says patch is tiny |
| `flow-patch-custom-finish-menu.md` | `/flow-patch` | Agent presents flow-verify numbered menu; no ad hoc merge/PR next steps |
| `flow-patch-auto-verify.md` | `/flow-patch` | Agent auto-runs verify after all tasks; does not hand off when user says patch is tiny |
| `flow-patch-test-after-fix.md` | `/flow-patch` | Agent rejects test-after-fix; requires RED→GREEN cycle |
| `flow-patch-skip-branch-gate.md` | `/flow-patch` | Agent sends branch ask only — no starting TDD in same message |
| `flow-spec-skip-questions.md` | `/flow-spec` | Agent asks questions instead of jumping to code |
| `flow-spec-structure-contradiction.md` | `/flow-spec` | Agent blocks user gate on path/tree contradictions; fixes spec first |
| `flow-brainstorm-skip-spec.md` | `/flow-brainstorm` | Agent explores options, does not write spec or code |
| `flow-brainstorm-small-scope-patch.md` | `/flow-brainstorm` | Agent hands off to `/flow-patch` for small bounded scope |
| `flow-execute-skip-review.md` | `/flow-execute` | Agent dispatches reviewers, doesn't skip |
| `flow-execute-spec-reviewer-trust-report.md` | `/flow-execute` | Agent runs spec review with diff inspection; doesn't trust report or skip because tests pass |
| `flow-execute-auto-verify.md` | `/flow-execute` | Agent auto-runs verify after all tasks; does not hand off when user asks to invoke verify themselves |
| `flow-execute-skip-branch-gate.md` | `/flow-execute` | Agent sends branch ask only — no "Starting Task 1" in same message |
| `flow-execute-overlap-tasks.md` | `/flow-execute` | Agent waits for Task N reviews before Task N+1 |
| `flow-verify-without-run.md` | `/flow-verify` | Agent runs tests before claiming done |
| `flow-verify-skip-auto-review.md` | `/flow-verify` | Agent does not auto-run option 3 when user wants merge |
| `flow-verify-option3-fallback.md` | `/flow-verify` | Option 3 uses correctness-reviewer (branch mode) when clean-code-reviewer absent |
| `flow-execute-worktree-skip-gate.md` | `/flow-execute` | Agent sends workspace gate only — no worktree creation or Task 1 in same message |
| `flow-patch-concurrent-unrelated-work.md` | `/flow-patch` | Unrelated work on active feature branch → worktree recommended, not branch switch |
| `flow-execute-resume-no-worktree.md` | `/flow-execute` | Continuing matched STATE work → resume on current branch, no worktree |
| `flow-worktree-ignore-check.md` | `/flow-execute` | Agent adds worktree dir to `.gitignore` before `git worktree add` |
| `flow-brainstorm-concurrent-unrelated-state.md` | `/flow-brainstorm` | Unrelated brainstorm with active STATE → session gate; no STATE write |
| `flow-spec-concurrent-unrelated-state.md` | `/flow-spec` | Unrelated spec with active STATE → gate before spec save |
| `flow-debug-during-execute-same-topic.md` | `/flow-debug` | Same-plan test failure → allow debug; no worktree |
| `flow-brainstorm-skip-session-gate.md` | `/flow-brainstorm` | Session gate only — no brief save or STATE update in same message |

See also [`../writing-skills.md`](../writing-skills.md) for the RED→GREEN→REFACTOR cycle and when to add new scenarios.

