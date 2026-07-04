# Diff-Only Output

## Purpose
All code modifications presented as SEARCH/REPLACE blocks or unified diffs. Never output unchanged code. Cuts code output tokens 60-90% on modification tasks.

## Rules

1. For single-region changes: use SEARCH/REPLACE format
2. For multi-region changes in one file: use multiple SEARCH/REPLACE blocks
3. For changes spanning many regions: use unified diff format
4. NEVER output a complete file when only parts changed
5. Include enough context in SEARCH blocks for unambiguous matching (2-3 lines above/below)

## SEARCH/REPLACE Format

```
File: path/to/file.ext

<<<<<<< SEARCH
[exact existing code including context lines]
=======
[replacement code]
>>>>>>> REPLACE
```

## Unified Diff Format (complex multi-region changes)

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
