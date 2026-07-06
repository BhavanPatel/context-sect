# Agent Adaptation

How universal rules get transformed into each agent's native format.

## How Rules Get Adapted Per Agent

The same rule (`rules/output-contract.md`) becomes:

| Agent | Transformation | Result |
|-------|---|---|
| **Kiro** | → steering file + SKILL.md + hook | `.kiro/steering/output-contract.md` |
| **Claude Code** | → combined into single CLAUDE.md | `~/.claude/CLAUDE.md` |
| **Cursor** | → .mdc with YAML frontmatter | `.cursor/rules/9output-contract.mdc` |
| **Windsurf** | → plain markdown copy | `.windsurf/rules/output-contract.md` |
| **Cline** | → plain markdown copy | `.clinerules/output-contract.md` |
| **RooCode** | → plain markdown copy | `.roo/rules/output-contract.md` |
| **Aider** | → combined conventions file | `~/.aider.conventions.md` |
| **OpenCode** | → combined markdown | `~/opencode.md` |
| **GitHub Copilot** | → combined instructions | `~/.github/copilot-instructions.md` |
| **Codex** | → combined AGENTS.md | `~/AGENTS.md` |

---

## Agents that use plain markdown (no transformation needed)

Windsurf, Cline, RooCode — rules copied directly as `.md` files.

## Agents that combine into single file

Claude Code, OpenCode, Aider, GitHub Copilot, Codex — all rules concatenated into one markdown file in their expected location.

## Agents needing format transformation

### Cursor

Adds YAML frontmatter for activation:

```yaml
---
description: "Token optimization: output-contract"
globs:
alwaysApply: true
---

# Output Contract
[rule content]
```

### Kiro

Full native integration:
- Rules → `.kiro/steering/*.md` (always loaded)
- Rules → `.kiro/skills/*/SKILL.md` (with frontmatter for routing)
- Hooks → `.kiro/hooks/token-optimization.json` (triggers on UserPromptSubmit, PreToolUse)

---

## Adding New Agents

To add support for a new agent:

1. Add detection logic in `detect_agents()` function
2. Create `install_<agent>()` function implementing the agent's config format
3. Add to the `main()` case statement

The universal rules in `rules/` don't need to change — only the installation adapter.
