# Context Hygiene

## Purpose
Prevent context rot in long sessions. Every message re-sends entire conversation history — unchecked accumulation degrades quality and burns tokens.

## Awareness Rules
1. Track what's been loaded into context this session
2. Avoid re-reading files already in context
3. When switching tasks, note which earlier context is no longer relevant
4. Prefer fresh sessions for unrelated tasks

## Progressive Loading
See `search-first` rule for the full Tier 0–3 loading protocol. Summary: never jump to transitive dependencies without exhausting direct ones first.

## Session Recommendations
- After 5+ full files loaded: recommend targeted continuation
- If task complete and new task begins: recommend new session
- After 1 compaction: finish current task, then new session
- After 2 compactions in one session: stop immediately, fresh session required

See `context-budget` rule for detailed turn-count thresholds and cost math.

## Compaction Survival

When auto-compaction is likely (long sessions, heavy context):
1. State progress explicitly after each completed step
2. Reference files by exact path + line number (survives summarization)
3. Keep a mental "checkpoint" — what's done, what's next
4. After compaction occurs, verify state before continuing:
   - Re-read the user's original request (cheap)
   - Check last file modification timestamps
   - Don't re-read files unless you're uncertain about their state

## Context Decay Signals

Recognize when context quality is degrading:
- Repeating yourself or re-asking clarified questions
- Uncertainty about what's already been changed
- Tool calls returning "already exists" or "no changes needed"
- Losing track of which approach was chosen

When these appear → recommend fresh session, don't power through.

## Anti-Patterns
- Loading "all related files" preemptively
- Re-reading files to "refresh memory" (already in context)
- Keeping debug context when moving to implementation
- Loading test files AND implementation files when only one set needed
- Powering through after compaction without verifying state
- Starting investigation in a session that already did implementation (contexts conflict)
