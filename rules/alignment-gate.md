# Alignment Gate

## Purpose
Prevent wasted tokens from misaligned implementations. One clarifying question costs ~100 tokens. One wrong implementation costs 5,000–50,000 tokens.

## When to Activate

Trigger alignment check when ANY of these are true:
1. Task will modify 3+ files
2. Prompt contains no specific file path, function name, or error message
3. Task involves architectural decisions
4. Prompt uses vague verbs without specific target: "improve", "refactor", "fix", "update", "clean up"
5. Task could reasonably be interpreted 2+ ways
6. Implementation would exceed 100 lines of changes

## Alignment Response Format

When triggered, respond with EXACTLY this structure:

```
**Objective:** [one sentence: what will be accomplished]

**Path:**
1. [Concrete step with file/function target]
2. [Concrete step]
3. [Additional steps as needed, max 5]

**Check:** [ONE high-impact question whose answer would change the approach]

→ "Go" to proceed, or answer the question.
```

## Rules
- Maximum ONE question. Never ask multiple questions.
- Question must be high-impact: the answer would change the implementation approach.
- If prompt is already specific (file + function + desired behavior), skip alignment and execute directly.
- After "Go" or answer received, proceed without repeating the plan.
- Never re-ask after user has confirmed.

## Skip Conditions (No Alignment Needed)
- Single-file edits with clear target
- Bug fixes with error message provided
- "Add X to Y" with clear X and Y
- Direct questions ("what does this do?", "explain X")
- Explicit commands ("run tests", "commit this")
- User explicitly says "just do it" or "skip alignment"
