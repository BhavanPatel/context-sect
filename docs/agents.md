# Supported Agents

| Agent | Config Format | Install Location | Auto-Detected? |
|-------|---|---|:---:|
| **Kiro** | `.kiro/steering/*.md` + skills + hooks | `~/.kiro/` | ✅ |
| **Claude Code** | `CLAUDE.md` (single markdown) | `~/.claude/CLAUDE.md` | ✅ |
| **Cursor** | `.mdc` files with YAML frontmatter | `~/.cursor/rules/` | ✅ |
| **Windsurf** | Plain markdown in rules directory | `~/.windsurf/rules/` | ✅ |
| **Cline** | Plain markdown in rules directory | `~/.clinerules/` | ✅ |
| **OpenCode** | Single markdown file | `~/opencode.md` | ✅ |
| **Aider** | YAML config + conventions markdown | `~/.aider.conventions.md` | ✅ |
| **RooCode** | Plain markdown in rules directory | `~/.roo/rules/` | ✅ |
| **GitHub Copilot** | Instructions markdown | `~/.github/copilot-instructions.md` | ✅ |
| **OpenAI Codex** | AGENTS.md | `~/AGENTS.md` | ✅ |

---

## Detection Logic

The install script auto-detects agents by checking:

- **CLI binaries** — `kiro`, `claude`, `aider`, `codex`, `opencode`
- **Config directories** — `~/.kiro`, `~/.claude`, `~/.cursor`, `~/.windsurf`
- **Application bundles** — `/Applications/Cursor.app`, `/Applications/Windsurf.app`
- **VS Code extensions** — `~/.vscode/extensions/*cline*`, `*copilot*`, `*roo*`

If none detected, falls back to interactive selection.
