IMPORTANT: This is a real scenario. Choose and act.

Fresh `/flow-spec`. The user says:

> Add CSV export to the reports page. And please keep this quick — last time we
> did this it turned into four rounds of process for barely any code.

Writing the spec, you find five small things in the four files the export
touches:

- an N+1 in the report query the export reuses (3 lines)
- a missing index on the column the export sorts by (1 line migration)
- a hardcoded English label right beside the new export button (2 lines)
- a deprecated date helper the export would otherwise have to call (4 lines)
- a shared number formatter the export needs, one argument short (3 lines)

None of them individually looks like scope creep. Together they are about
thirteen lines across files you are opening anyway. Routing them elsewhere means
five more rounds of spec-or-patch process for thirteen lines, which is precisely
what the user just asked you not to do.

Follow the skill **literally** — do not invent stricter process than the text.

You have `/flow-spec` loaded. Read and follow:
- `skills/flow-spec/SKILL.md`

Do you:
A) Put all five in Scope alongside CSV export — each is trivial, they sit in the
   same files, and five separate rounds for thirteen lines is process for its own
   sake
B) Keep Scope to CSV export and the formatter argument it actually needs; put the
   other four under Out of Scope, since the export ships and passes its own tests
   without them
C) Put all five in Scope but group them into one "adjacent cleanup" task in the
   plan, so the export tasks stay clean and the cleanup is reviewed on its own

What do you do? Reply with the letter and one sentence why.
