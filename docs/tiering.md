# Activation Tiers

## The problem this solves

The most common criticism of a rules framework is a fair one: **it is always loaded.**

Fourteen rules in an always-on instruction file are re-sent every turn, including turns that will never use them. A `git status` still carries the alignment gate, the planning rules and the investigation protocol. The framework meant to save tokens becomes a fixed tax.

The naive fix — convert everything to on-demand skills — trades one failure for another:

| Mechanism | Cost | Failure mode |
|---|---|---|
| Always-on | small, constant, every turn | none — it cannot be forgotten |
| On-demand skill | ~nothing until invoked | the model forgets to invoke it |

Neither is free. Picking a side does not escape the trade.

## The third option

Hooks are **conditionally always-on**. They do not sit in context, and they are fired by the agent runtime rather than chosen by the model. That makes them deterministic where a prompt is probabilistic — a rule as a hook can neither be forgotten nor charged for until its event occurs.

So rules are sorted by *when they actually need to act*:

| Tier | Meaning | Cost when idle |
|---|---|---|
| `steering` | applies to every response | full, but cache-warm |
| `hook` | applies at one lifecycle event | zero |
| `skill` | applies to one kind of task | description only |

## Current assignment

| Tier | Rules |
|---|---|
| **steering** (2) | `output-contract`, `cache-stability` |
| **hook** (6) | `alignment-gate`, `loop-breaker`, `search-first`, `shell-output-hygiene`, `context-budget`, `diff-only` |
| **skill** (6) | `plan-before-act`, `investigation-mode`, `context-hygiene`, `tool-selection`, `subagent-isolation`, `session-handover` |

Effect on Kiro: always-on content drops from 14 rules to 2 — measured at ~4,300 words down to ~700.

Only two rules earn always-on status. `output-contract` shapes every response; `cache-stability` governs how all other context is ordered. Everything else has an identifiable trigger.

## Why always-on is cheaper than it looks

Prompt caching reads a stable prefix at roughly 10% of normal input price, and always-on rules sit in exactly that prefix. The cost of the `steering` tier is therefore not its size but its **volatility** — cache matching is byte-exact, so one changed character early invalidates everything after it.

Two consequences, both implemented:

- The profile header contains **no timestamp**. It previously wrote `# Generated: <date>`, which invalidated the cache daily for no benefit.
- Rule ordering is pinned with `LC_ALL=C sort` rather than left to locale-dependent glob order.

So the answer to "it's always loaded" is not only "we load less" but "what is loaded is stable, and stable is cheap."

## Graceful degradation

Agents differ in mechanism, so tiers degrade rather than drop. **No rule is ever lost** — the worst case is that it costs more than it should.

| Agent | steering | hook | skill |
|---|---|---|---|
| Kiro | yes | yes | yes |
| Claude Code | yes | yes | yes |
| Cursor | yes | degraded to always-on | yes, via `alwaysApply: false` |
| Codex, Copilot, Windsurf, Cline, RooCode, OpenCode, Aider | yes | degraded | degraded |

Cursor does have hooks, with events `sessionStart`, `beforeSubmitPrompt`, `beforeReadFile`, `beforeShellExecution`, `beforeMCPExecution`, `afterFileEdit` and `stop`. Two gaps prevent full use today: there is no pre-edit or generic pre-tool event, so `diff-only` and `loop-breaker` have nowhere to attach; and the per-event contract for injecting context is unverified. Cursor therefore ships without hooks rather than with guessed JSON. Tracked as a follow-up.

## Adding a rule

Rules stay plain, agent-agnostic markdown. Tier metadata deliberately lives in `install.sh`, not in rule frontmatter, because several agents copy rule files verbatim and would render YAML as body text.

1. Add `rules/<name>.md`
2. Add the rule to `get_rule_tier()` and `get_rule_description()` in `install.sh`
3. If it is `hook` tier, add an entry to the relevant `adapters/*-hooks.json`

Rules absent from `get_rule_tier()` default to `steering`. That is deliberate: an unclassified rule is over-charged rather than silently skipped.

## Descriptions matter

For the `skill` tier, the description **is** the activation mechanism. A vague description means the skill never fires, which silently drops the rule — the exact failure this design exists to avoid. Descriptions are written as trigger conditions ("Use when…", "Use before…"), not summaries.

Skills are not free either: names and descriptions load every session. At around fifty skills that is roughly 2.5K tokens of catalog before any work begins. Six skill-tier rules is a deliberate ceiling, not an oversight.

## Migration

Earlier versions installed every rule into steering **and** skills **and** hooks simultaneously — three copies of each rule. Re-running the installer prunes the duplicates and reports each move.

Pruning is conservative:

- Only files matching a known rule name are touched.
- Skills are removed only when they carry the `<!-- contextsect:managed -->` marker, so hand-written skills survive even if they share a rule's name.
- `CLAUDE.md`, `AGENTS.md` and the other combined files are written inside a `BEGIN/END contextsect` block; content outside it is preserved. Earlier versions overwrote these files wholesale.
