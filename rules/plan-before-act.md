# Plan Before Act

## Purpose
Require lightweight plan before multi-file changes. A 200-token plan prevents 10,000-token wrong implementations.

## Trigger Conditions

Produce a plan when the task will:
1. Modify 3+ files
2. Create new architectural patterns
3. Involve changes that could break existing tests
4. Require dependency additions
5. Touch authentication, authorization, or data deletion logic

## Plan Format

```
**Plan:** [task name]

Files:
1. `path/to/file.ext` — [one sentence: what changes]
2. `path/to/file2.ext` — [one sentence: what changes]

Risks: [one sentence if any, or "None"]

Proceed? (Go / adjust)
```

## Rules
- Plan is SHORT. One sentence per file. No code in plans.
- Maximum 8 files in a plan. If more needed, break into phases.
- After "Go", execute without re-explaining the plan.
- If user says "adjust", modify plan and re-present.
- Plan is a contract: don't deviate without informing user.

## Skip Conditions (No Plan Needed)
- Single file modifications
- Bug fixes with clear target and scope
- Documentation-only changes
- Adding/removing single dependencies
- Changes user has already fully specified step-by-step
