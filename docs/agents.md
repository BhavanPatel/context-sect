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


---

## Mechanism Support (verified Sept 2026)

Rule count is not the same as always-on cost. What matters is which activation mechanisms an agent supports, since that determines how much of the rule set must be always-loaded. See [tiering.md](tiering.md).

| Agent | Always-on file | Event hooks | On-demand skills | Tiers usable |
|---|---|---|---|---|
| **Kiro** | `.kiro/steering/` | yes | yes | all three |
| **Claude Code** | `CLAUDE.md` | yes (`settings.json`) | yes (`~/.claude/skills/`) | all three |
| **Cursor** | `.mdc` rules | yes, but see note | yes (`alwaysApply: false`) | steering + skill |
| **Codex** | `AGENTS.md` | — | SKILL.md widely read | steering |
| **GitHub Copilot** | `copilot-instructions.md` | — | `applyTo` globs | steering |
| **Windsurf** | `.windsurf/rules/` | — | glob-scoped rules | steering |
| **Cline** | `.clinerules/` | — | — | steering |
| **RooCode** | `.roo/rules/` | — | — | steering |
| **OpenCode** | `opencode.md` | — | — | steering |
| **Aider** | `.aider.conventions.md` | — | — | steering |

### Note on Cursor hooks

Cursor **does** support hooks, configured in `~/.cursor/hooks.json`, with events `sessionStart`, `beforeSubmitPrompt`, `beforeReadFile`, `beforeShellExecution`, `beforeMCPExecution`, `afterFileEdit` and `stop`. It can also load third-party Claude Code hooks.

ContextSect does not ship Cursor hooks yet, for two reasons:

1. There is no pre-edit or generic pre-tool event, so `diff-only` and `loop-breaker` have nowhere to attach.
2. The per-event contract for injecting context back into the session is unverified here.

Shipping guessed hook JSON would be worse than shipping none, so Cursor gets two tiers today and its hook-tier rules degrade to always-on. Contributions welcome.

### On AGENTS.md

`AGENTS.md` is an open standard stewarded by the Linux Foundation and read by many tools, including Codex, Cursor and Claude Code. ContextSect writes `~/AGENTS.md` for Codex.

It does **not** replace the native paths for Windsurf, Cline, RooCode, OpenCode or Aider, because their support for `AGENTS.md` is unverified — silently relocating their rules could break a working install. Those six single-file adapters share one install function internally, but each still writes to its own documented location.
