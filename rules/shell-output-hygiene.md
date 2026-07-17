# Shell Output Hygiene

## Purpose
Prevent bloated command outputs from flooding context. A single `npm test` can dump 25,000 tokens of noise when only 5 lines of failure matter. Control what enters context at the command level.

## Rules

1. Always prefer compact/quiet flags when available:
   - `git status --short` over `git status`
   - `git diff --stat` before full `git diff` (scan first, then target)
   - `git log --oneline -10` over `git log`
   - `npm test -- --reporter=dot` over default verbose
   - `pytest -q` over `pytest -v`
   - `cargo test 2>&1 | tail -20` when only failures matter
   - `ls -1` over `ls -la` when permissions aren't needed

2. Pipe and filter large outputs:
   - `command | head -50` when exploring
   - `command | grep -A 3 "ERROR\|FAIL"` for test/build output
   - `command 2>&1 | tail -30` for build logs (errors are at the end)

3. Never dump full output when a summary exists:
   - Use `--summary` / `--brief` / `--quiet` flags first
   - If the summary shows a problem, THEN get verbose output for just that section

4. For repetitive commands (git status, test runs), use the shortest form that answers the question

## Command Substitution Table

| Wasteful | Compact | Tokens saved |
|----------|---------|-------------|
| `git status` | `git status -s` | ~80% |
| `git log` | `git log --oneline -10` | ~85% |
| `git diff` | `git diff --stat` then targeted | ~70% |
| `npm test` | `npm test -- --reporter=dot 2>&1 \| tail -30` | ~90% |
| `pytest` | `pytest -q --tb=short` | ~80% |
| `find . -name "*.ts"` | `find . -name "*.ts" \| head -20` | bounded |
| `cat large-file` | `head -50 large-file` or grep target | ~95% |
| `docker ps` | `docker ps --format "table {{.Names}}\t{{.Status}}"` | ~60% |
| `ls -laR` | `tree -L 2` or `ls -1` | ~70% |

## Progressive Command Strategy
1. **Scout:** Run compact version first (summary/quiet/short)
2. **Target:** If issue found, run verbose on just the failing area
3. **Never:** Run verbose globally "just to see everything"

## Anti-Patterns
- Running `cat` on files >50 lines (use search or head)
- Full `git diff` when `--stat` would identify which files changed
- Verbose test output when tests pass (only need failures)
- Running the same command repeatedly without filtering output
- `find` without depth limits or head constraints on large repos
