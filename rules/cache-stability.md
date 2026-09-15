# Cache Stability

## Purpose
Keep the prompt prefix byte-stable so provider prompt caching stays warm. Cache reads cost roughly 10% of normal input price, but matching is byte-exact: one changed character early in the prompt invalidates every cached token after it. A stable prefix is worth more than a small prefix.

## Rules

1. Treat the prompt prefix as append-only within a session. Stable content first, volatile content last:
   - Order: system rules → tool definitions → project context → conversation → current turn
   - Never inject changing values (timestamps, counters, random IDs, session stats) into early context

2. Do not restate or re-summarise earlier context mid-session. Rewriting history rewrites the prefix and drops the cache.

3. When referencing files, use stable identifiers (`path:line`) rather than pasting content that may change between turns.

4. Prefer appending new information over editing prior information.

5. If a tool returns a deterministic cache marker for unchanged content, pass it through unchanged — do not re-expand it.

## Why This Beats Shrinking Context

| Approach | Effect on input cost |
|---|---|
| Remove 30% of a stable prefix | ~30% off an already-discounted rate |
| Break the prefix with volatile content | Full price on 100% of it |

Stability dominates size. A larger stable prefix beats a smaller volatile one.

## Anti-Patterns
- Injecting the current date/time into system rules or steering
- Reordering rules or tool definitions between turns
- Re-summarising the conversation into the prefix
- Pasting file contents that change, instead of citing `path:line`
- Rewriting earlier turns to "clean them up"
