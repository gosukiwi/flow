#!/usr/bin/env python3
"""Validate flow artifact fixtures and optional project artifacts."""

from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
FIXTURES = ROOT / "tests" / "fixtures" / "artifacts"

REQUIRED_SPEC_SECTIONS = [
    "## Goal",
    "## Success Criteria",
    "## Scope",
    "## Out of Scope",
    "## Design",
    "## Testing Approach",
    "## Open Questions",
]

PLACEHOLDER_PATTERN = re.compile(
    r"\b(TBD|TODO|FIXME|implement later|handle edge cases)\b", re.IGNORECASE
)


def validate_spec(path: Path, *, should_pass: bool) -> bool:
    text = path.read_text()
    ok = True

    for section in REQUIRED_SPEC_SECTIONS:
        if section not in text:
            print(f"  ✗ {path.name}: missing section {section}")
            ok = False

    has_placeholder = bool(PLACEHOLDER_PATTERN.search(text))
    open_q = "## Open Questions" in text and "None" not in text.split("## Open Questions")[-1][:200]

    if should_pass:
        if has_placeholder:
            print(f"  ✗ {path.name}: contains placeholder (expected clean)")
            ok = False
        if open_q and "None" not in text:
            # good-spec should have Open Questions: None
            if "None" not in text.split("## Open Questions")[-1][:80]:
                print(f"  ✗ {path.name}: open questions not resolved")
                ok = False
    else:
        if not has_placeholder and not open_q:
            print(f"  ✗ {path.name}: expected to fail validation but looked clean")
            ok = False

    if ok:
        label = "pass" if should_pass else "correctly fails"
        print(f"  ✓ {path.name}: {label}")
    return ok


def validate_plan(path: Path, *, should_pass: bool) -> bool:
    text = path.read_text()
    ok = True

    if "- [ ]" not in text:
        print(f"  ✗ {path.name}: missing checkbox tasks")
        ok = False

    has_placeholder = bool(PLACEHOLDER_PATTERN.search(text))
    has_tdd = "verify fail" in text.lower() or "verify red" in text.lower() or "FAIL" in text

    if should_pass:
        if has_placeholder:
            print(f"  ✗ {path.name}: contains placeholder")
            ok = False
        if not has_tdd:
            print(f"  ✗ {path.name}: missing TDD verification steps")
            ok = False
    else:
        if not has_placeholder:
            print(f"  ✗ {path.name}: expected placeholder content")
            ok = False

    if ok:
        label = "pass" if should_pass else "correctly fails"
        print(f"  ✓ {path.name}: {label}")
    return ok


def main() -> int:
    print("=== validate-artifacts ===")
    failed = False

    checks = [
        (FIXTURES / "good-spec.md", validate_spec, True),
        (FIXTURES / "bad-spec-tbd.md", validate_spec, False),
        (FIXTURES / "good-plan.md", validate_plan, True),
        (FIXTURES / "bad-plan-no-tdd.md", validate_plan, False),
    ]

    for path, fn, should_pass in checks:
        if not path.exists():
            print(f"  ✗ Missing fixture {path}")
            failed = True
            continue
        if not fn(path, should_pass=should_pass):
            failed = True

    if failed:
        print("Artifact validation failed.")
        return 1
    print("Artifact validation passed.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
