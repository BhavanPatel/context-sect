# Part 3: Complete Rule Library

## Architecture Overview

The rule library is modular. Each rule is independently activatable and works across all supported AI coding agents. Rules are designed to compose without conflict when properly profiled.

---

## Skill 1: output-compression

### Purpose
Enforce concise, dense output that eliminates conversational filler while preserving full technical accuracy. The single highest-ROI optimization available.

### Skill Content

```markdown
---
name: output-compression
description: >-
  Enforces concise technical output. Strips filler, pleasantries, hedging, and
  unnecessary explanation. Preserves code accuracy, error messages, and structured
  data. Activated automatically. Reduces output tokens 40-65%.
---

# Output Compression

## Rules

1. No conversational filler (Sure/Certainly/Of course/Happy to/Great question)
2. No introductory paragraphs restating the question
3. No concluding summaries unless explicitly requested
4. No hedging (might/perhaps/maybe/possibly) — state facts or state uncertainty directly
5. Fragments preferred over full sentences for explanations
6. Shortest exact synonym: "fix" not "implement a solution for"
7. Pattern: `[thing] [action] [reason]. [next step].`

## Code Output Rules

8. SEARCH/REPLACE blocks for modifications to existing files
9. Never output unchanged code — show only the delta
10. Unified diff format for multi-line changes when SEARCH/REPLACE is impractical
11. Explanations of code only when explicitly requested by user
12. No narration of tool calls ("Let me read the file..." / "I'll now search for...")

## Structural Rules

13. Code blocks use exact language identifiers
14. File paths, class names, error messages always verbatim
15. Markdown structure (headers/lists/bold) retained for scannability
16. Tables only when data genuinely tabular, never decorative

## Exceptions (use full clarity)

- Security warnings and destructive action confirmations
- Multi-step sequences where brevity creates ordering ambiguity
- When user explicitly asks "explain", "why", or "walk me through"
```

### Expected Input Token Savings
+300 tokens (skill content loaded into context)

### Expected Output Token Savings
-40–65% on all conversational and explanatory output

### Implementation Rationale
Output tokens cost 5x input tokens. This is the single highest cost-reduction lever. The caveman skill proves 65% reduction is achievable without quality loss. This skill uses professional tone rather than caveman style, making it suitable for all contexts.

### Risks
- Over-compression can make multi-step instructions ambiguous
- New team members may find terse output harder to learn from
- Safety exceptions must be honored strictly

### When to Enable
Always. This should be the default for all development work.

### When NOT to Enable
- Onboarding sessions where detailed explanations help learning
- Documentation generation tasks requiring prose
- User explicitly requests verbose/detailed output

### Compatibility
Compatible with ALL other skills. Does not conflict with any skill. Applied as a post-processing constraint on output style.

---

## Skill 2: alignment-gate

### Purpose
Intercept vague or ambiguous prompts and require objective alignment before expensive operations begin. Prevents the most common source of wasted tokens: implementing the wrong thing.

### Skill Content

```markdown
---
name: alignment-gate
description: >-
  Detects vague or ambiguous prompts and requires alignment before execution.
  Presents: Objective, Proposed Path, and ONE clarifying question. Proceeds only
  after user confirms "Go" or answers the question. Prevents wasted exploration tokens.
---

# Alignment Gate

## Trigger Conditions

Activate alignment check when ANY of these are true:

1. Task affects 3+ files
2. Prompt contains no specific file path, function name, or error message
3. Task involves architectural decisions
4. Prompt uses vague verbs: "improve", "refactor", "fix", "update", "clean up" without specific target
5. Task could reasonably be interpreted 2+ ways
6. Implementation would exceed 100 lines of changes

## Alignment Response Format

When triggered, respond with EXACTLY this structure:

```
**Objective:** [one sentence restating what will be accomplished]

**Path:** [numbered list of 2-5 concrete steps]

**Check:** [ONE high-impact question that would change the approach if answered differently]

→ "Go" to proceed, or answer the question.
```

## Rules

- Maximum ONE question. Never ask multiple questions.
- Question must be high-impact: the answer would change the implementation approach.
- If user's prompt is already specific (file + function + desired behavior), skip alignment and execute directly.
- After "Go" or answer received, proceed without repeating the plan.
- Never re-ask after user has confirmed.

## Skip Conditions (no alignment needed)

- Single-file edits with clear target
- Bug fixes with error message provided
- "Add X to Y" with clear X and Y
- Direct questions ("what does this do?", "explain X")
- Explicit commands ("run tests", "commit this")
```

### Expected Input Token Savings
-50–70% on misaligned tasks (prevents entire wrong exploration paths)

### Expected Output Token Savings
-50–70% on wrong implementations that would need redoing

### Implementation Rationale
The most expensive token waste is implementing the wrong thing entirely. One alignment question costs ~100 tokens but prevents 5,000–50,000 tokens of wrong work. Research shows plan-first workflows reduce retries 50–70%.

### Risks
- Over-triggering annoys users on simple tasks (mitigated by skip conditions)
- Slows down rapid iteration on obvious changes
- Must correctly detect "already specific enough" prompts

### When to Enable
Always for multi-file changes and architectural work. Consider disabling for rapid single-file iteration sessions.

### When NOT to Enable
- Pair programming mode where user is giving rapid sequential instructions
- Tasks where user explicitly says "just do it"
- Single-file, single-function changes

### Compatibility
Compatible with all skills. Works upstream of execution skills — gates before they activate.

---

## Skill 3: search-first

### Purpose
Enforce targeted search operations before reading full files. Prevents context pollution from loading entire files when only a few lines are relevant.

### Skill Content

```markdown
---
name: search-first
description: >-
  Enforces search-before-read workflow. Agent must use targeted search (grep,
  symbol lookup, AST search) before reading full files. Prevents context pollution.
  Saves 40-80% on file reading tokens.
---

# Search-First Protocol

## Rules

1. Before reading any file >50 lines, FIRST use a targeted search to locate the relevant section
2. Search strategies (in order of preference):
   - Symbol/function name lookup (most precise)
   - Grep for specific string/pattern
   - AST pattern search
   - Directory listing to identify relevant files
3. After search identifies relevant lines, read ONLY the relevant section (+/- 20 lines context)
4. Full file reads are allowed ONLY when:
   - File is <50 lines
   - User explicitly requests "show me the whole file"
   - Understanding requires full file structure (e.g., import resolution)
   - Config files that must be read entirely (package.json, tsconfig, etc.)

## Investigation Protocol

For unfamiliar codebases:
1. Read directory structure first (0 tokens for file content)
2. Read config files (package.json, tsconfig, etc.) for project understanding
3. Search for relevant symbols/patterns
4. Read only targeted sections of relevant files

## Anti-Patterns (never do)

- Reading all files in a directory sequentially
- Reading a file "just to understand the project"
- Loading test files when fixing implementation (and vice versa) unless specifically needed
- Re-reading a file already in context
```

### Expected Input Token Savings
-40–80% on file reading operations

### Expected Output Token Savings
-20–30% (more focused context → shorter answers)

### Implementation Rationale
Research shows agents waste 80% of tokens finding things, not reasoning. A code knowledge graph approach saved 40–95%. This skill enforces the discipline without requiring infrastructure changes.

### Risks
- May miss relevant context that isn't in the searched section
- Could cause incomplete understanding of complex interdependencies
- Slightly slower for small projects where reading everything is cheap

### When to Enable
Always for repositories >1000 lines. Essential for large monorepos.

### When NOT to Enable
- Tiny projects (<10 files, <500 total lines)
- Initial project exploration where broad understanding is needed
- Code review tasks where full diff context is required

### Compatibility
Compatible with all skills. Works well with alignment-gate (search informs better alignment responses).

---

## Skill 4: loop-breaker

### Purpose
Detect and halt runaway agent loops that waste tokens without making progress. A single misconfigured rule can cause 64-turn loops.

### Skill Content

```markdown
---
name: loop-breaker
description: >-
  Detects and halts runaway execution loops. Triggers when agent repeats tool calls,
  hits the same error 3+ times, or exceeds turn budget without measurable progress.
  Prevents catastrophic token waste from stuck agents.
---

# Loop Breaker

## Detection Rules

Flag a potential loop when ANY of these occur:

1. Same tool called 3+ times with identical or near-identical arguments
2. Same error message encountered 3+ times
3. Agent has used >10 tool calls without producing a code change
4. File read-edit-read cycle repeated on same file 3+ times
5. Search results being re-searched with minor variations >3 times

## Response Protocol

When loop detected:

```
⚠️ Loop detected: [pattern description]

**Turns used:** [N]
**Pattern:** [what's repeating]
**Root cause hypothesis:** [best guess]

Options:
1. [Alternative approach]
2. [Different tool/strategy]
3. Stop and report findings

Which approach?
```

## Budget Awareness

- Simple tasks: budget 5 tool calls
- Medium tasks: budget 15 tool calls
- Complex tasks: budget 30 tool calls
- If budget exceeded without deliverable, pause and report

## Anti-Patterns

- Never retry the exact same command hoping for different results
- Never re-read a file that's already in context
- If a tool is consistently failing, try a different tool or approach
```

### Expected Input Token Savings
Prevents 10x–100x waste on failure cases (tail risk protection)

### Expected Output Token Savings
Proportional (prevents futile output generation)

### Implementation Rationale
GitHub documented a 64-turn loop from one misconfigured rule. This skill is insurance against catastrophic token waste — low frequency but extreme impact.

### Risks
- False positive: might halt legitimate long operations (large refactors)
- Budget limits may be too tight for genuinely complex tasks
- Detection requires turn-counting which varies by agent implementation

### When to Enable
Always. This is a safety net with minimal downside.

### When NOT to Enable
- Never disable this. Adjust budget thresholds instead.

### Compatibility
Compatible with all skills. Acts as a circuit breaker that overrides other skills when triggered.

---

## Skill 5: diff-only

### Purpose
Enforce that code modifications are always presented as minimal diffs rather than full file rewrites. Directly reduces output tokens for the most common operation.

### Skill Content

```markdown
---
name: diff-only
description: >-
  All code modifications presented as SEARCH/REPLACE blocks or unified diffs.
  Never outputs unchanged code. Never rewrites entire files when only lines change.
  Cuts code output tokens 60-90% on modification tasks.
---

# Diff-Only Output

## Rules

1. For single-region changes: use SEARCH/REPLACE format
2. For multi-region changes in one file: use multiple SEARCH/REPLACE blocks
3. For changes spanning many regions: use unified diff format
4. NEVER output a complete file when only parts changed
5. Include enough context in SEARCH blocks for unambiguous matching (typically 2-3 lines above/below)

## SEARCH/REPLACE Format

```
File: path/to/file.ext

<<<<<<< SEARCH
[exact existing code including context lines]
=======
[replacement code]
>>>>>>> REPLACE
```

## Unified Diff Format (for complex multi-region changes)

```diff
--- a/path/to/file.ext
+++ b/path/to/file.ext
@@ -10,6 +10,8 @@
 context line
-removed line
+added line
 context line
```

## When to Use Full File Output

ONLY when:
- Creating a new file (no existing content to diff against)
- User explicitly requests "show me the whole file"
- File is <20 lines total
- Changes affect >80% of lines (rare; ask first)

## Anti-Patterns

- Never "Here's the updated file:" followed by entire file content
- Never include unchanged imports/headers unless they frame the change
- Never repeat code the user just showed you
```

### Expected Input Token Savings
None (this is output-focused)

### Expected Output Token Savings
-60–90% on code modification outputs

### Implementation Rationale
The most token-expensive operation is outputting full files. A 200-line file modification touching 5 lines wastes 195 lines of output tokens at 5x input cost. SEARCH/REPLACE format is proven across Aider, Claude Code, and Cursor.

### Risks
- SEARCH block must be unique enough to match; ambiguous matches cause errors
- User must have tooling that can apply SEARCH/REPLACE (or manually apply)
- Complex refactors across many locations may be clearer as full file

### When to Enable
Always for code modification tasks.

### When NOT to Enable
- File creation tasks (no existing content)
- When user explicitly asks for complete file output
- Teaching/learning sessions where seeing full context helps understanding

### Compatibility
Compatible with all skills. output-compression applies to prose around diffs; this skill applies to code content specifically.

---

## Skill 6: context-hygiene

### Purpose
Prevent context pollution from accumulating over long sessions. Enforce awareness of context budget and recommend cleanup at appropriate points.

### Skill Content

```markdown
---
name: context-hygiene
description: >-
  Monitors session context accumulation and recommends hygiene actions. Prevents
  context rot in long sessions. Enforces relevant-only context loading and
  recommends compaction when context grows large.
---

# Context Hygiene

## Awareness Rules

1. Track what's been loaded into context this session
2. Avoid re-reading files already in context (check before reading)
3. When switching tasks within a session, note which earlier context is no longer relevant
4. Prefer fresh sessions for unrelated tasks over continuing a long session

## Progressive Loading

Load context in tiers:
1. **Tier 0:** Project structure (directory listing, package.json) — always cheap
2. **Tier 1:** Target file(s) mentioned in user prompt — load immediately
3. **Tier 2:** Direct dependencies of target — load on demand
4. **Tier 3:** Transitive dependencies — load only if Tier 2 insufficient

Never jump to Tier 3 without exhausting Tier 1 and 2.

## Session Length Recommendations

- After 15+ turns: consider whether a fresh session would be cleaner
- After context includes 5+ full files: strongly recommend targeted continuation
- If task is complete and new task begins: recommend new session

## Anti-Patterns

- Loading "all related files" preemptively
- Re-reading files to "refresh memory" (they're already in context)
- Keeping debug/investigation context when moving to implementation
- Loading test files AND implementation files when only one set is needed
```

### Expected Input Token Savings
-30–50% over long sessions

### Expected Output Token Savings
Indirect (cleaner context → more focused output)

### Implementation Rationale
Context accumulates silently. Every message resends entire conversation history. A 30-minute session can consume a daily quota. Progressive loading and session boundaries prevent this.

### Risks
- May recommend session breaks at inconvenient points
- Progressive loading might miss important context in early tiers
- Session freshness recommendations require user judgment

### When to Enable
Always for sessions expected to exceed 10 turns.

### When NOT to Enable
- Quick single-question interactions
- Tasks that inherently require broad context (large refactors spanning many files)

### Compatibility
Compatible with all skills. Complements search-first by providing session-level hygiene on top of per-read hygiene.

---

## Skill 7: plan-before-act

### Purpose
Require an explicit plan before multi-file implementations. Uses a lightweight planning format that catches misalignment early without consuming excessive planning tokens.

### Skill Content

```markdown
---
name: plan-before-act
description: >-
  Requires explicit lightweight plan before multi-file changes. Plan includes: files
  to modify, changes per file (one sentence each), and risks. Executes only after
  user approves plan. Prevents wrong-direction implementation waste.
---

# Plan Before Act

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

## Skip Conditions (no plan needed)

- Single file modifications
- Bug fixes with clear target and scope
- Documentation-only changes
- Adding/removing single dependencies
- Changes user has already fully specified step-by-step
```

### Expected Input Token Savings
+200 tokens (plan output), -60% on retry savings (net massive positive)

### Expected Output Token Savings
-50–70% by eliminating wrong implementations

### Implementation Rationale
The most expensive token event is implementing the wrong thing and having to redo it. A 200-token plan prevents a 10,000-token wrong implementation. VS Code docs and multiple practitioners confirm plan-first workflows prevent the majority of costly retries.

### Risks
- Slows down obvious changes (mitigated by skip conditions)
- Planning phase itself must be concise (avoid over-planning)
- User may approve plan but still disagree with implementation details

### When to Enable
Always for multi-file work. Essential for large production codebases.

### When NOT to Enable
- Rapid iteration on single files
- When user is providing step-by-step instructions
- Exploratory/investigative tasks (investigating doesn't need a plan)

### Compatibility
Compatible with all skills. alignment-gate handles vague prompts; plan-before-act handles specific-but-complex prompts. They complement each other.

---

## Skill 8: investigation-mode

### Purpose
For diagnostic and research tasks, enforce a structured investigation workflow that gathers evidence before proposing solutions. Prevents premature implementation.

### Skill Content

```markdown
---
name: investigation-mode
description: >-
  For diagnostic tasks (debugging, performance issues, understanding unfamiliar code),
  enforces evidence-first investigation. Gathers facts before proposing solutions.
  Prevents premature implementation that wastes tokens on wrong fixes.
---

# Investigation Mode

## Activation

Activate when user prompt includes:
- "why is this failing/broken/slow"
- "what's causing"
- "investigate"
- "debug"
- "figure out why"
- "understand how X works"

## Investigation Protocol

1. **State hypothesis** (one sentence)
2. **Gather evidence** (targeted searches/reads — minimum needed)
3. **Report findings** (facts only, no solution yet)
4. **Propose fix** (only after evidence supports it)

## Output Format

```
**Hypothesis:** [one sentence]
**Evidence:** [what was found, with file:line references]
**Conclusion:** [root cause]
**Fix:** [proposed change, if obvious; or "Need more info: [specific question]"]
```

## Rules

- Never propose a fix before stating evidence
- Never modify code during investigation (investigate ≠ fix)
- State confidence level: certain / likely / uncertain
- If uncertain after investigation, ask ONE targeted question rather than guessing
- Maximum 5 tool calls per investigation round before reporting interim findings

## Anti-Patterns

- Jumping to a fix without reading error context
- Modifying code to "try" a fix before understanding the cause
- Reading 10 files to "understand the system" when the bug is in one file
- Proposing multiple speculative fixes instead of investigating further
```

### Expected Input Token Savings
-40–60% (targeted investigation vs. broad exploration)

### Expected Output Token Savings
-50% (prevents speculative fix implementations)

### Implementation Rationale
Debugging without evidence is the second most common source of wasted tokens (after wrong implementations). Structured investigation prevents fix-try-fail-retry loops.

### Risks
- May feel slow when the fix is "obvious" to the user
- Over-structured investigation on trivial bugs adds overhead
- Hypothesis-driven approach requires minimum familiarity with the codebase

### When to Enable
When debugging, diagnosing performance issues, or understanding unfamiliar code.

### When NOT to Enable
- When user already knows the fix and just wants it applied
- Feature implementation tasks
- Code review or documentation tasks

### Compatibility
Compatible with all skills. Particularly synergistic with search-first (investigation uses targeted search) and loop-breaker (prevents investigation from becoming a loop).

---

## Skill Compatibility Matrix

| Skill | output-compression | alignment-gate | search-first | loop-breaker | diff-only | context-hygiene | plan-before-act | investigation-mode |
|-------|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
| **output-compression** | — | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **alignment-gate** | ✅ | — | ✅ | ✅ | ✅ | ✅ | Complementary | ✅ |
| **search-first** | ✅ | ✅ | — | ✅ | ✅ | Synergistic | ✅ | Synergistic |
| **loop-breaker** | ✅ | ✅ | ✅ | — | ✅ | ✅ | ✅ | ✅ |
| **diff-only** | ✅ | ✅ | ✅ | ✅ | — | ✅ | ✅ | N/A (no code changes) |
| **context-hygiene** | ✅ | ✅ | Synergistic | ✅ | ✅ | — | ✅ | ✅ |
| **plan-before-act** | ✅ | Complementary | ✅ | ✅ | ✅ | ✅ | — | Complementary |
| **investigation-mode** | ✅ | ✅ | Synergistic | ✅ | N/A | ✅ | Complementary | — |

**Legend:** ✅ = Fully compatible | Synergistic = Works especially well together | Complementary = Covers different aspects of same goal | N/A = Doesn't apply in same context
