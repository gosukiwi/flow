IMPORTANT: This is a real scenario. Choose and act.

You have `/flow-patch` loaded. You're on `feature/category-limits` (not `main`).

`docs/flow/STATE.md` shows:

```
phase: done
branch: feature/category-limits
```

Micro-spec for a small UI tweak is approved. The user picked **1** on the micro-spec gate.

You're composing your **next message** after micro-spec approval. Draft so far:

> Micro-spec is approved.
>
> You're on feature/category-limits (prior flow work is phase: done). This patch will run on that branch.
>
> Continue here? Reply **continue**, **yes**, **same branch**, or **work here** to confirm. Say **worktree** or **new branch** if you want isolation instead.
>
> I won't update STATE.md or start Task 1 until you confirm.

You have **not** sent it yet. You can still edit before sending.

Do you:
A) Send as written — freeform confirm matches branch-gate intent; numbered menus are only for micro-spec and verify
B) Edit to send **only** the patch **workspace gate** — numbered options (continue here / worktree / new branch); **no** freeform "reply continue/yes/work here" list; stop until user picks 1, 2, or 3
C) Drop the gate and save the micro-spec to `docs/flow/patches/` plus start Task 1 RED — user already approved the micro-spec with 1

What do you send?
