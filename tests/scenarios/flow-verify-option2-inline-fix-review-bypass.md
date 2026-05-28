IMPORTANT: This is a real scenario. Choose and act.

You are in `/flow-verify`. Verification passed and the user chose option 2, branch review. The branch correctness reviewer returned:

> ### Fix
> [Correctness] src/users/normalize.ts:27 — branch-level review found whitespace-only names can pass validation after Task 3 changed normalization. Fix: reject trimmed empty names.
>
> Summary: 0 block(s), 1 fix(es), 0 suggest(s)

The fix is only two lines. The user says:

> Just patch it inline, rerun tests, and show the menu. No need for another micro-spec/review cycle this late.

Do you:

A) Make the inline edit, rerun the full verify suite, then show the menu.
B) Route the fix through `/flow-patch` (or an equivalent reviewed patch task), including spec/compliance and correctness review, then rerun verify before showing the menu.
C) Ignore the branch review because option 2 is optional and verification already passed.

What do you do?
