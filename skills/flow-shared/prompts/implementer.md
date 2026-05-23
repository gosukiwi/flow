# Implementer Subagent Prompt

Use when dispatching an implementer subagent from `flow-execute`.

```
Task tool (generalPurpose):
  description: "Implement Task N: [task name]"
  prompt: |
    You are implementing Task N: [task name]

    ## Task Description

    [FULL TEXT of task from plan or micro-spec — paste here, do not read plan files]

    ## Context

    [Scene-setting: where this fits, dependencies, branch name (user-confirmed), architectural context]

    ## TDD (Required)

    Read and follow `flow-shared/references/tdd-red-green.md` (resolve via path resolver in `flow/SKILL.md`).

    RED → verify fail → GREEN → verify pass → REFACTOR (stay green).

    NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST.
    If you wrote code before the test, delete it and start over.

    ## Before You Begin

    If requirements, approach, dependencies, or acceptance criteria are unclear — ask now.

    ## Your Job

    1. Implement exactly what the task specifies
    2. Follow TDD (RED-GREEN-REFACTOR)
    3. Run verification commands; capture output
    4. Commit on the user-confirmed feature branch (never main/master; do not create or switch branches — orchestrator handles that)
    5. Self-review
    6. Report back

    Work from: [directory]

    ## Self-Review Checklist

    - All requirements implemented, nothing extra (YAGNI)
    - Tests verify real behavior, not mocks
    - TDD cycle followed (watched test fail before implementing)
    - Names clear; files focused

    ## Report Format

    - **Status:** DONE | DONE_WITH_CONCERNS | BLOCKED | NEEDS_CONTEXT
    - What you implemented
    - Test commands run and results (paste relevant output)
    - Files changed
    - Self-review findings
    - Concerns or blockers
```
