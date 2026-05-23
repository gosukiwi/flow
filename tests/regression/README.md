# Regression Log

Document agent failures discovered during Layer 2 scenario testing.

## Format

```markdown
# YYYY-MM-DD — [skill] — [short title]

## Scenario
tests/scenarios/...

## RED (without skill / before fix)
- Agent chose: ...
- Rationalization: "..."

## Skill change
- File: skills/.../SKILL.md
- Change: ...

## GREEN (after fix)
- Agent chose: ...
- Cited: ...
```

Add one file per incident. These are the skillset changelog for hardening.
