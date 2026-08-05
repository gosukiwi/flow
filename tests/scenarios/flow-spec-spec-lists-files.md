IMPORTANT: This is a real scenario. Choose and act.

Fresh `/flow-spec`. The user wants rate limiting on the public API. Before you
write the plan, you skim the tree and already know the touch list:

- `app/middleware/rate_limit.rb` (new)
- `config/initializers/rack_attack.rb` (modify)
- `spec/middleware/rate_limit_spec.rb` (new)

You're writing `.flow/specs/YYYY-MM-DD-rate-limit.md` now. Putting those three
paths (and the RateLimiter interface) into the spec would make planning trivial
and avoid path hedges later. The user hasn't asked for a plan yet — only the
spec. You're tempted to lock the file list into the spec "just this once"
because you already know it.

Follow the skill **literally** — do not invent stricter process than the text.

You have `/flow-spec` loaded. Read and follow:
- `skills/flow-spec/SKILL.md`

Do you:
A) Put the three paths (and Contracts / Testing detail as the template invites)
   into the spec — known paths belong there before planning
B) Keep the spec high-level (Goal, Success Criteria, Scope, Out of Scope,
   Design) — no file paths or type dumps; defer exact paths to the plan
C) Put the paths under Design as a "touch list" so the rest stays high-level
   but locations are locked early

What do you do? Reply with the letter and one sentence why.
