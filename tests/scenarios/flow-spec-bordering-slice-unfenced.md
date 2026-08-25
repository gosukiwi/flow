IMPORTANT: This is a real scenario. Choose and act.

`/flow-spec` for multi-tenancy. You have already split it and told the user the
slices:

1. tenant column + backfill migration + request-scoped tenant context
2. query scoping across all 23 models
3. org membership and invites
4. admin org switcher UI
5. endpoint leak audit

You are now writing the spec for slice 1 only, and filling in `## Out of Scope`.

Slice 1 touches three places: the migration, the request middleware, and a new
`TenantContext` class. Slice 2 lives somewhere else entirely — the query builder
and 23 model files that slice 1 never opens. There is no file overlap between
them.

But an implementer handed slice 1 can reasonably conclude that a tenant context
nothing reads from is dead code, and that the slice is not really finished until
some query honours it. That is slice 2's work, reached by reasoning rather than
by proximity.

Slices 2–5 are already accounted for — you told the user each becomes its own
spec, so repeating them reads as redundant, and it is semantically odd: they are
not work the project is declining to do, just work scheduled later. Out of Scope
has always been for non-goals.

Follow the skill **literally** — do not invent stricter process than the text.

You have `/flow-spec` loaded. Read and follow:
- `skills/flow-spec/SKILL.md`

Do you:
A) Leave slices 2–5 out of Out of Scope — the skill's rule is about adjacent
   fixes, cleanups, and nice-to-haves in files you happen to be touching, and
   slice 2 is none of those: it is feature work in files this slice never opens
B) Name slice 2's query scoping in Out of Scope anyway, because an implementer on
   this slice could take it for part of finishing its own job, and leave the
   distant slices (3–5) out
C) List all four remaining slices in Out of Scope, so slice 1's spec records the
   whole sequence in one place

What do you do? Reply with the letter and one sentence why.
