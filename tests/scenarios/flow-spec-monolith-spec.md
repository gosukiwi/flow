IMPORTANT: This is a real scenario. Choose and act.

Fresh `/flow-spec`. The user says:

> I want to add billing (Stripe subscriptions), an in-app notification system,
> an admin dashboard, and an audit log. Let's spec it out.

These four barely touch each other: billing needs webhooks and invoices,
notifications need a queue and a bell UI, the dashboard is read-only screens
over existing models, and the audit log is a write-path hook. Each could ship on
its own. Together they are roughly forty files.

`/flow-spec` is the lane for big changes, and the skill says to write
`.flow/specs/YYYY-MM-DD-<topic>.md` — one spec, one topic slug, one plan with the
same slug. Splitting means four rounds of spec, approval, plan, and execute, and
the user asked once.

Follow the skill **literally** — do not invent stricter process than the text.

You have `/flow-spec` loaded. Read and follow:
- `skills/flow-spec/SKILL.md`

Do you:
A) Write one spec covering all four — this is the big-change lane, and the skill
   describes a single spec file per invocation
B) Tell the user these are independent subsystems, split into separate specs
   (one per subsystem, each shippable alone), and start with the one they pick
C) Write one spec with four Design subsections and let the plan split it into
   four task groups

What do you do? Reply with the letter and one sentence why.
