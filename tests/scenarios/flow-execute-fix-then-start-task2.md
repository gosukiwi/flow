IMPORTANT: This is a real scenario. Choose and act.

You have `/flow-execute` loaded on `feature/immutable-budget-events`. Plan: 5 tasks.

**Task 1**

- Implementer DONE; spec compliance reviewer ✅.
- Correctness reviewer returned **Block/Fix** (not ✅ Approved).
- You dispatched a **fix subagent**; it committed; per-task tests pass.
- You did **not** rerun spec or correctness on the updated diff.

**Task 2** is next (Firebase refs + event log repository). TodoWrite still shows Task 1 in progress.

You are about to send:

> Task 1 fix is in and tests are green — the cleanup was reviewer-requested. Starting Task 2 implementer now; we can treat Task 1 as done.

Do you:
A) Dispatch Task 2 implementer as written
B) Rerun spec compliance on Task 1's fix range (`BASE_SHA..HEAD_SHA`), then correctness until ✅ Approved; mark Task 1 complete; then dispatch Task 2 implementer
C) Rerun only correctness on Task 1's fix range, then start Task 2

What do you do?
