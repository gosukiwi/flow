# Root Cause Tracing

## Core principle

Trace backward through the call chain until you find the original trigger. Fix at the source, not where the error appears.

## When to use

- Error deep in the stack, not at the entry point
- Unclear where bad data originated
- Fixing the symptom point didn't stick

For the full investigate phase, read this when Phase 1 hits a dead end at the failure site.

## Process

1. **Observe the symptom** — exact error, file, line
2. **Find immediate cause** — what code directly produces this?
3. **Ask what called it** — walk up the call chain
4. **Track bad values** — what was passed in? where did it come from?
5. **Find original trigger** — first place the bad state was introduced

## When manual tracing isn't enough

Add instrumentation before the failing operation:

```typescript
const stack = new Error().stack;
console.error("DEBUG:", { relevantVars, cwd: process.cwd(), stack });
```

In tests, use `console.error()` — loggers may be suppressed. Run tests, grep debug output, read stack for the triggering test or caller.

## Rule

**Never fix only where the error appears** if you can trace further up. Route to `/flow-patch` only after you know the source fix.
