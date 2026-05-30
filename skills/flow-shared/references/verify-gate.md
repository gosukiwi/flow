# Verify Gate

Read before **any** Flow verify phase: standalone `/flow-verify`, auto-run from `/flow-execute` or `/flow-patch`, or re-check after fixes.

Resolve via path resolver in `flow/SKILL.md`.

Tests + spec checklist — not a substitute for per-task reviews during `/flow-execute` or `/flow-patch`.

## Hard gate

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

**Forbidden:** Claiming done, fixed, or passing without running the full verify process below in this session.

**Forbidden:** Replacing the numbered user menu with an implementation summary, "say if you want commits/PR", or treating a plan's last "verification" task as verify finish — see `plan-execution.md` §5.

Ad hoc user messages ("merge back into main", "push the branch", "looks good — merge") after verify passes → route to `/flow-finish` or follow **Ad hoc finish requests** below — do not raw merge or auto-run branch review.

## Process

1. Read `flow-shared/references/verification-gate.md` (resolve via path resolver in `flow/SKILL.md`) — follow the Iron Law for all completion claims
2. Run the **full** test suite (or project-standard equivalent); read complete output
3. Requirements checklist against spec, plan, or micro-spec — verify each requirement line by line:

| Requirement | Evidence |
|-------------|----------|
| ... | file/test/command reference |

**Structure specs:** When the spec requires mirrored or matching paths (or documents explicit exceptions), verify segment-for-segment alignment between paired trees per that rule (e.g. `src/` ↔ `tests/`, or colocated `Foo.tsx` ↔ `Foo.test.tsx`). List any path pairs that diverge. Do not mark verify complete if Success Criteria claim mirror but trees differ.

List gaps explicitly. Do not claim complete with open gaps.

4. Report only after steps 2–3. If anything fails, do **not** claim done. Route to `/flow-debug` or `/flow-patch`.

**Before updating STATE:** read `flow-shared/references/session-gate.md` (resolve via path resolver in `flow/SKILL.md`). Confirm STATE branch/plan matches the work being verified. Unrelated active STATE → stop and session-gate.

Update `docs/flow/STATE.md`: `phase: verify` when starting.

## User menu

Before presenting the menu, check whether **`clean-code-reviewer`** is in your available skills.

After verification passes, present:

```
Verification complete:
- Tests: [command] → [result with counts]
- Requirements: [N/N met] or [gaps listed]

What would you like to do?

1. Push the branch — I'll push; you open the PR when ready (I'll sync local after you merge on GitHub)
2. Review the diff — optional full-branch review
3. Merge locally — merge this branch into your base branch
4. Done for now — I'll stop here; you take it from there
```

**User-facing menu** — no skill names (`clean-code-reviewer`), bracketed alternates, or `/flow-*` commands in the fenced template.

**Option 2 label at send time:** if `clean-code-reviewer` is available, you may say **Full code review** in the message body when the user picks 2; otherwise run branch-mode `correctness-reviewer.md`. Do not expose internal skill IDs in the numbered menu.

**Option actions:**

| Option | Agent action |
|--------|--------------|
| 1 Push branch | Read `finish-gate.md` (push branch section) — push, `phase: done`, keep worktree; tell user to run `/flow-finish` → sync after remote merge after PR merges on GitHub |
| 2 Review diff | See **Option 2 — branch review** below |
| 3 Merge locally | Read `flow-finish/SKILL.md` or `finish-gate.md` (merge locally section) — confirm base, merge, worktree remove if applicable, `phase: done`, offer branch delete |
| 4 Done for now | Read `finish-gate.md` (done for now section) — `phase: done`, no git actions |

Set `docs/flow/STATE.md`: `phase: done` when finish-gate steps complete for options 1, 3, or 4.

## Option 2 — branch review

Optional extra pass before merge or push. Per-task reviews already ran during implementation; this reviews the **full branch** for cross-task issues.

**Do not run option 2 automatically** — only when the user chooses it from the menu.

1. Determine git range: `BASE_SHA` = merge-base with main (or first commit on branch); `HEAD_SHA` = `HEAD`
2. **If `clean-code-reviewer` is in available skills:** read and follow its `SKILL.md` on the full branch diff
3. **If not available:** dispatch a subagent using `flow-shared/prompts/correctness-reviewer.md` (branch mode) (resolve via path resolver in `flow/SKILL.md`) with `BASE_SHA`, `HEAD_SHA`, and brief spec/plan/micro-spec context
4. If review returns ❌ Needs changes: route the fix through `/flow-patch` (or reopen a reviewed patch task in the active patch lane). The fix must get task-level spec compliance and correctness review before returning here. Then re-run verify process steps 2–3 and re-run option 2 until ✅ Approved
5. When ✅ Approved, re-present the user menu (options 1–4). No git actions unless the user picks 1 or 3.

Flow does not run a branch review unless the user chooses option 2.

## Ad hoc finish requests

When the user asks to merge, push, or close out **without** picking from the menu above (e.g. "merge back into local main"):

- Read and follow `flow-finish/SKILL.md` — same cleanup as menu options
- **Forbidden:** Raw `git merge` / `git push` without finish-gate (STATE must reach `phase: done` after merge/push)

## Red flags — never

- Claim done from an earlier test run without re-running the full suite after changes
- "Should work", "probably", "seems to" — see `verification-gate.md`
- **Auto-run option 2** when the user asks to merge or push — present the menu or follow ad hoc finish
- **Patch option 2 findings with unreviewed inline edits** — branch-review fixes go through `/flow-patch` or an equivalent reviewed patch task, then verify reruns
- **Hand off verify** instead of running it after execute/patch tasks complete
- **Wait for `/flow-verify` invocation** after execute/patch when implementation succeeded
- **Treat a plan "Final verification" / last-task test run as Flow verify finish** — still present the numbered verify menu
- **Stop with implementation summary + "commits or PR?"** instead of the verify user menu (options 1–4)
- **Raw merge without finish-gate** — ad hoc merge requests use `/flow-finish` or finish-gate sections

## Skills that use this reference

- `flow-verify` — primary orchestrator for standalone verify
- `plan-execution.md` — auto-run after all execute tasks
- `flow-patch` — auto-run after all patch tasks
