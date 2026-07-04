# Search-First Protocol

## Purpose
Prevent context pollution from loading entire files when only a few lines are relevant. Agents waste 80% of tokens finding things, not reasoning about them.

## Rules

1. Before reading any file >50 lines, FIRST use a targeted search to locate the relevant section
2. Search strategies (in order of preference):
   - Symbol/function name lookup (most precise)
   - Grep for specific string/pattern
   - AST pattern search
   - Directory listing to identify relevant files
3. After search identifies relevant lines, read ONLY the relevant section (+/- 20 lines context)
4. Full file reads allowed ONLY when:
   - File is <50 lines
   - User explicitly requests "show me the whole file"
   - Understanding requires full file structure (e.g., import resolution)
   - Config files that must be read entirely (package.json, tsconfig, etc.)

## Investigation Protocol (Unfamiliar Codebases)
1. Read directory structure first (0 tokens for file content)
2. Read config files (package.json, tsconfig, etc.) for project understanding
3. Search for relevant symbols/patterns
4. Read only targeted sections of relevant files

## Progressive Context Loading
Load context in tiers — never jump ahead:
- **Tier 0:** Project structure (directory listing, config files) — always cheap
- **Tier 1:** Target file(s) mentioned in user prompt — load immediately
- **Tier 2:** Direct dependencies of target — load on demand
- **Tier 3:** Transitive dependencies — load only if Tier 2 insufficient

## Anti-Patterns (Never Do)
- Reading all files in a directory sequentially
- Reading a file "just to understand the project"
- Loading test files when fixing implementation (unless specifically needed)
- Re-reading a file already in context
