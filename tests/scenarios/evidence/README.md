# Scenario evidence (Layer 2)

Record RED and GREEN runs for discipline/gate changes here before commit.

**File naming:** same basename as the scenario, e.g. `flow-state-gitignore-check.md` for `tests/scenarios/flow-state-gitignore-check.md`.

**Required sections per file:**

```markdown
## RED (pre-change commit: <sha>)

- Choice: A|B|C
- Rationalization: (verbatim)
- Pass: yes if non-compliant choice

## GREEN (post-change commit: <sha>)

- Choice: A|B|C
- Rule cited: (gate/reference)
- Pass: yes if compliant + cites rule
```

See `AGENTS.md` §Evidence gate.
