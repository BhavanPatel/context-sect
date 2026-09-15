#!/usr/bin/env bash
set -euo pipefail

# ContextSect — Agent-Agnostic Token Optimization Framework
# Detects installed AI coding agents and installs optimized rules for each.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RULES_DIR="${SCRIPT_DIR}/rules"
ADAPTERS_DIR="${SCRIPT_DIR}/adapters"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# ════════════════════════════════════════════════════════════════
# Agent detection
# ════════════════════════════════════════════════════════════════

declare -a DETECTED_AGENTS=()

detect_agents() {
  echo -e "${CYAN}Detecting installed AI coding agents...${NC}"
  echo ""

  # Kiro CLI
  if command -v kiro-cli &>/dev/null || command -v kiro &>/dev/null || [[ -d "${HOME}/.kiro" ]]; then
    DETECTED_AGENTS+=("kiro")
    echo -e "  ${GREEN}✓${NC} Kiro CLI"
  fi

  # Claude Code
  if command -v claude &>/dev/null || [[ -d "${HOME}/.claude" ]]; then
    DETECTED_AGENTS+=("claude-code")
    echo -e "  ${GREEN}✓${NC} Claude Code"
  fi

  # Cursor
  if [[ -d "${HOME}/.cursor" ]] || [[ -d "/Applications/Cursor.app" ]] || [[ -d "${HOME}/Library/Application Support/Cursor" ]]; then
    DETECTED_AGENTS+=("cursor")
    echo -e "  ${GREEN}✓${NC} Cursor"
  fi

  # Windsurf
  if [[ -d "${HOME}/.windsurf" ]] || [[ -d "/Applications/Windsurf.app" ]] || [[ -d "${HOME}/Library/Application Support/Windsurf" ]]; then
    DETECTED_AGENTS+=("windsurf")
    echo -e "  ${GREEN}✓${NC} Windsurf"
  fi

  # Cline (VS Code extension)
  if [[ -d "${HOME}/.cline" ]] || find "${HOME}/.vscode/extensions" -maxdepth 1 -name "*cline*" -print -quit 2>/dev/null | grep -q .; then
    DETECTED_AGENTS+=("cline")
    echo -e "  ${GREEN}✓${NC} Cline"
  fi

  # OpenCode
  if command -v opencode &>/dev/null || [[ -f "${HOME}/.config/opencode/config.json" ]]; then
    DETECTED_AGENTS+=("opencode")
    echo -e "  ${GREEN}✓${NC} OpenCode"
  fi

  # Aider
  if command -v aider &>/dev/null || [[ -f "${HOME}/.aider.conf.yml" ]]; then
    DETECTED_AGENTS+=("aider")
    echo -e "  ${GREEN}✓${NC} Aider"
  fi

  # RooCode (VS Code extension)
  if [[ -d "${HOME}/.roo" ]] || find "${HOME}/.vscode/extensions" -maxdepth 1 -name "*roo*" -print -quit 2>/dev/null | grep -q .; then
    DETECTED_AGENTS+=("roocode")
    echo -e "  ${GREEN}✓${NC} RooCode"
  fi

  # GitHub Copilot
  if find "${HOME}/.vscode/extensions" -maxdepth 1 -name "*copilot*" -print -quit 2>/dev/null | grep -q . || command -v gh &>/dev/null; then
    DETECTED_AGENTS+=("github-copilot")
    echo -e "  ${GREEN}✓${NC} GitHub Copilot"
  fi

  # Codex
  if command -v codex &>/dev/null || [[ -f "${HOME}/.codex/config.toml" ]]; then
    DETECTED_AGENTS+=("codex")
    echo -e "  ${GREEN}✓${NC} OpenAI Codex"
  fi

  echo ""

  if [[ ${#DETECTED_AGENTS[@]} -eq 0 ]]; then
    echo -e "${YELLOW}No agents auto-detected. Choose manually:${NC}"
    select_agents_manually
  fi
}

select_agents_manually() {
  echo ""
  echo "Available agents:"
  echo "  1) Kiro CLI"
  echo "  2) Claude Code"
  echo "  3) Cursor"
  echo "  4) Windsurf"
  echo "  5) Cline"
  echo "  6) OpenCode"
  echo "  7) Aider"
  echo "  8) RooCode"
  echo "  9) GitHub Copilot"
  echo " 10) OpenAI Codex"
  echo "  a) All"
  echo ""
  read -rp "Select agents (comma-separated numbers, or 'a' for all): " selection </dev/tty

  if [[ "$selection" == "a" ]]; then
    DETECTED_AGENTS=("kiro" "claude-code" "cursor" "windsurf" "cline" "opencode" "aider" "roocode" "github-copilot" "codex")
  else
    IFS=',' read -ra choices <<< "$selection"
    for choice in "${choices[@]}"; do
      choice=$(echo "$choice" | tr -d ' ')
      case "$choice" in
        1) DETECTED_AGENTS+=("kiro") ;;
        2) DETECTED_AGENTS+=("claude-code") ;;
        3) DETECTED_AGENTS+=("cursor") ;;
        4) DETECTED_AGENTS+=("windsurf") ;;
        5) DETECTED_AGENTS+=("cline") ;;
        6) DETECTED_AGENTS+=("opencode") ;;
        7) DETECTED_AGENTS+=("aider") ;;
        8) DETECTED_AGENTS+=("roocode") ;;
        9) DETECTED_AGENTS+=("github-copilot") ;;
        10) DETECTED_AGENTS+=("codex") ;;
      esac
    done
  fi
}

# ════════════════════════════════════════════════════════════════
# Profile selection
# ════════════════════════════════════════════════════════════════

SELECTED_PROFILE=""

get_profile_desc() {
  case "$1" in
    conservative)     echo "Zero risk. Full exploration. Minimal constraints." ;;
    balanced)         echo "Recommended. Significant savings with minimal friction." ;;
    aggressive)       echo "Maximum savings for familiar codebases. Tight budgets." ;;
    ultra-aggressive) echo "Absolute minimum tokens. Automated/repetitive tasks only." ;;
  esac
}

get_profile_settings() {
  case "$1" in
    conservative) cat <<'SETTINGS'
alignment-gate: disabled (no blocking)
output-compression: lite (no filler, but full sentences)
search-first: advisory (prefer search, allow full reads)
loop-detection: 5 repetitions before halt
plan-required: disabled
investigation-budget: 10 tool calls
shell-output-hygiene: advisory (suggest compact flags, allow verbose)
context-budget: monitor only (no session-limit enforcement)
tool-selection: advisory (prefer specific tools, allow generic)
SETTINGS
      ;;
    balanced) cat <<'SETTINGS'
alignment-gate: active on 3+ file changes
output-compression: full (fragments OK, no filler, diff-only)
search-first: enforced (search before reading files >50 lines)
loop-detection: 3 repetitions before halt
plan-required: 3+ file modifications
investigation-budget: 5 tool calls
shell-output-hygiene: enforced (always use compact flags)
context-budget: enforced (warn at 50K, recommend fresh at 100K)
tool-selection: enforced (prefer specific tools, budget per task)
SETTINGS
      ;;
    aggressive) cat <<'SETTINGS'
alignment-gate: active on 2+ file changes
output-compression: ultra (maximum density)
search-first: strict (never read full files >30 lines)
loop-detection: 2 repetitions before halt
plan-required: 2+ file modifications
investigation-budget: 3 tool calls
shell-output-hygiene: strict (always quiet/summary first, never verbose)
context-budget: strict (hard stop at 100K, fresh session at 15 turns)
tool-selection: strict (minimum calls, batch aggressively)
SETTINGS
      ;;
    ultra-aggressive) cat <<'SETTINGS'
alignment-gate: active on ALL multi-step tasks
output-compression: ultra-max (no explanations unless asked)
search-first: strict symbol-only (no grep, no broad reads)
loop-detection: 1 repetition before halt
plan-required: ALL tasks with >1 file
investigation-budget: 2 tool calls
session-limit: single task per session
shell-output-hygiene: maximum (pipe everything through head/tail, no raw output)
context-budget: maximum (hard stop at 50K, fresh session at 10 turns)
tool-selection: maximum (1-2 calls per step, zero exploratory calls)
SETTINGS
      ;;
  esac
}

get_profile_savings() {
  case "$1" in
    conservative)     echo "Input: -15–25% | Output: -20–30% | Risk: Zero" ;;
    balanced)         echo "Input: -40–55% | Output: -50–65% | Risk: Low" ;;
    aggressive)       echo "Input: -60–75% | Output: -70–85% | Risk: Medium" ;;
    ultra-aggressive) echo "Input: -80–90% | Output: -85–95% | Risk: High" ;;
  esac
}

select_profile() {
  echo -e "${CYAN}Select optimization profile:${NC}"
  echo ""
  echo -e "  ${GREEN}1) conservative${NC}    — $(get_profile_desc conservative)"
  echo -e "     Savings: $(get_profile_savings conservative)"
  echo ""
  echo -e "  ${GREEN}2) balanced${NC} ⭐     — $(get_profile_desc balanced)"
  echo -e "     Savings: $(get_profile_savings balanced)"
  echo ""
  echo -e "  ${GREEN}3) aggressive${NC}      — $(get_profile_desc aggressive)"
  echo -e "     Savings: $(get_profile_savings aggressive)"
  echo ""
  echo -e "  ${GREEN}4) ultra-aggressive${NC} — $(get_profile_desc ultra-aggressive)"
  echo -e "     Savings: $(get_profile_savings ultra-aggressive)"
  echo ""
  echo -e "  ${YELLOW}Recommended: balanced (best tradeoff for daily development)${NC}"
  echo ""
  read -rp "  Choose profile [1-4, default=2]: " choice </dev/tty

  case "${choice:-2}" in
    1) SELECTED_PROFILE="conservative" ;;
    2) SELECTED_PROFILE="balanced" ;;
    3) SELECTED_PROFILE="aggressive" ;;
    4) SELECTED_PROFILE="ultra-aggressive" ;;
    conservative) SELECTED_PROFILE="conservative" ;;
    balanced) SELECTED_PROFILE="balanced" ;;
    aggressive) SELECTED_PROFILE="aggressive" ;;
    ultra-aggressive) SELECTED_PROFILE="ultra-aggressive" ;;
    *) SELECTED_PROFILE="balanced" ;;
  esac

  echo ""
  echo -e "  ${GREEN}✓${NC} Profile: ${SELECTED_PROFILE}"
  echo ""
}

generate_profile_header() {
  local settings
  settings="$(get_profile_settings "$SELECTED_PROFILE")"
  cat <<EOF
# ContextSect — Active Profile: ${SELECTED_PROFILE}
# Re-run: contextsect install --profile ${SELECTED_PROFILE}
# NOTE: intentionally no timestamp — this file heads the cached prompt prefix,
# and a changing byte here invalidates every cached token after it.

## Profile Settings
${settings}

---

EOF
}

# ════════════════════════════════════════════════════════════════
# Installation functions per agent
# ════════════════════════════════════════════════════════════════

# ════════════════════════════════════════════════════════════════
# Rule tiering
# ════════════════════════════════════════════════════════════════
#
# Not every rule needs to be always-on. Three activation tiers:
#
#   steering — applies to every response. Always loaded. Cache-warm, so the
#              per-turn cost is ~10% of list price once the prefix is stable.
#   hook     — only relevant at a specific lifecycle event (a read, a write,
#              a shell command, a prompt). Costs nothing until the event fires.
#   skill    — situational. Costs only its description until activated.
#
# Agents that lack a mechanism degrade gracefully: a "hook" rule on an agent
# with no hooks is installed as always-on instead. Nothing is ever dropped.
#
# Unknown/new rules default to "steering" — the safe choice, since an always-on
# rule is never silently skipped.

get_rule_tier() {
  case "$1" in
    # T1 — genuinely every turn
    output-contract|cache-stability)
      echo "steering" ;;
    # T2 — event-scoped, zero cost until fired
    alignment-gate|loop-breaker|search-first|shell-output-hygiene|context-budget|diff-only)
      echo "hook" ;;
    # T3 — situational, on-demand
    plan-before-act|investigation-mode|context-hygiene|tool-selection|subagent-isolation|session-handover)
      echo "skill" ;;
    *)
      echo "steering" ;;
  esac
}

# Descriptions drive skill auto-activation. A vague description means the skill
# never fires, which silently drops the rule — so these are written as trigger
# conditions, not summaries.
get_rule_description() {
  case "$1" in
    output-contract)      echo "Minimize output tokens: no filler, no restatement, no tool narration, diffs over full files." ;;
    cache-stability)      echo "Keep the prompt prefix byte-stable so prompt caching stays warm. Use when ordering context or referencing files." ;;
    diff-only)            echo "Present code modifications as SEARCH/REPLACE blocks or unified diffs. Use when editing existing files." ;;
    search-first)         echo "Search to locate the relevant section before reading a file. Use before reading any file over 50 lines." ;;
    loop-breaker)         echo "Detect and halt repeated tool calls, repeated errors, and runaway loops. Use when the same action repeats." ;;
    shell-output-hygiene) echo "Use compact flags and pipe through head/tail/grep. Use before running git, test, build, or install commands." ;;
    context-budget)       echo "Track context consumption and session length. Use when many files are loaded or the session is long." ;;
    alignment-gate)       echo "Confirm intent before expensive work. Use when a request is vague, ambiguous, or spans 3+ files." ;;
    plan-before-act)      echo "Produce a short file-by-file plan before multi-file changes, new patterns, or dependency additions." ;;
    investigation-mode)   echo "Evidence-first debugging. Use for why is this failing, what is causing, investigate, debug, figure out why." ;;
    context-hygiene)      echo "Avoid re-reading files and context rot. Use in long sessions or after compaction." ;;
    tool-selection)       echo "Pick the most specific tool and avoid wasted calls. Use when choosing between tools or facing MCP schema bloat." ;;
    subagent-isolation)   echo "Delegate read-heavy exploration to a subagent so raw material never enters the main context." ;;
    session-handover)     echo "Write a handover file so state survives compaction. Use before switching tasks or when context is filling up." ;;
    *)                    echo "ContextSect token optimization rule: $1" ;;
  esac
}

# Deterministic rule ordering. Glob order is locale-dependent, and a reordered
# prefix is a cache miss, so ordering is pinned with LC_ALL=C.
list_rules() {
  local f
  for f in "${RULES_DIR}"/*.md; do
    [[ -f "$f" ]] || continue
    basename "$f" .md
  done | LC_ALL=C sort
}

# Emits rules of a given tier, or all rules when tier is "all".
list_rules_by_tier() {
  local want="$1" name
  while IFS= read -r name; do
    if [[ "$want" == "all" || "$(get_rule_tier "$name")" == "$want" ]]; then
      echo "$name"
    fi
  done < <(list_rules)
}

combine_rules() {
  # Profile header + rule bodies, concatenated into one always-on block.
  # Pass a tier to filter, or omit for every rule (agents with no hook/skill
  # mechanism, where all rules necessarily become always-on).
  local tier="${1:-all}" output="" name
  output+="$(generate_profile_header)"
  while IFS= read -r name; do
    output+="$(cat "${RULES_DIR}/${name}.md")"
    output+=$'\n\n---\n\n'
  done < <(list_rules_by_tier "$tier")
  echo "$output"
}

# Removes rule files that no longer exist in source
cleanup_removed_rules() {
  local target_dir="$1"
  local ext="$2"  # md or mdc

  for installed_file in "${target_dir}"/*.${ext}; do
    [[ -f "$installed_file" ]] || continue
    local fname
    fname="$(basename "$installed_file")"

    # Skip profile file
    [[ "$fname" == "000-profile.md" || "$fname" == "000-profile.mdc" ]] && continue

    # Strip cursor prefix (e.g., "9context-hygiene.mdc" -> "context-hygiene")
    local base="${fname%.${ext}}"
    base="${base#[0-9]}"

    # Check if source rule still exists
    if [[ ! -f "${RULES_DIR}/${base}.md" ]]; then
      rm -f "$installed_file"
      echo -e "    ${RED}✗${NC} ${fname} (removed — rule no longer exists)"
    fi
  done
}

install_kiro() {
  echo -e "\n  ${BLUE}Installing for Kiro...${NC}"
  local target="${HOME}/.kiro"
  mkdir -p "${target}/steering" "${target}/skills" "${target}/hooks"

  # Profile steering file (heads the cached prefix — keep it byte-stable)
  generate_profile_header > "${target}/steering/000-profile.md"
  echo -e "    ${GREEN}✓${NC} steering/000-profile.md (${SELECTED_PROFILE})"

  # T1 — always-on steering
  local name
  while IFS= read -r name; do
    cp "${RULES_DIR}/${name}.md" "${target}/steering/${name}.md"
    echo -e "    ${GREEN}✓${NC} steering/${name}.md ${CYAN}[always-on]${NC}"
  done < <(list_rules_by_tier steering)

  # T2 — hooks. Kiro fires these on lifecycle events, so they cost nothing
  # until the matching event occurs and cannot be "forgotten" by the model.
  if [[ -f "${ADAPTERS_DIR}/kiro-hooks.json" ]]; then
    cp "${ADAPTERS_DIR}/kiro-hooks.json" "${target}/hooks/token-optimization.json"
    echo -e "    ${GREEN}✓${NC} hooks/token-optimization.json ${CYAN}[event-triggered]${NC}"
  fi

  # T3 — on-demand skills
  while IFS= read -r name; do
    write_skill "${target}/skills/${name}" "$name"
    echo -e "    ${GREEN}✓${NC} skills/${name}/SKILL.md ${CYAN}[on-demand]${NC}"
  done < <(list_rules_by_tier skill)

  prune_stale_steering "${target}/steering"
  prune_stale_skills "${target}/skills"
}

# Marker written into every generated SKILL.md. Pruning only ever touches
# directories carrying this marker, so hand-written user skills are never
# deleted even if they happen to share a name with a rule.
CS_MARKER="<!-- contextsect:managed -->"

write_skill() {
  local dir="$1" name="$2"
  mkdir -p "$dir"
  {
    echo "---"
    echo "name: ${name}"
    echo "description: $(get_rule_description "$name")"
    echo "---"
    echo "$CS_MARKER"
    echo ""
    cat "${RULES_DIR}/${name}.md"
  } > "${dir}/SKILL.md"
}

# Removes always-on files for rules that have since moved to a cheaper tier,
# or that no longer exist in rules/.
prune_stale_steering() {
  local dir="$1" f base tier
  for f in "${dir}"/*.md; do
    [[ -f "$f" ]] || continue
    base="$(basename "$f" .md)"
    [[ "$base" == "000-profile" ]] && continue
    if [[ ! -f "${RULES_DIR}/${base}.md" ]]; then
      rm -f "$f"
      echo -e "    ${RED}✗${NC} steering/${base}.md (rule no longer exists)"
    else
      tier="$(get_rule_tier "$base")"
      if [[ "$tier" != "steering" ]]; then
        rm -f "$f"
        echo -e "    ${YELLOW}→${NC} steering/${base}.md (now ${tier} tier — no longer always-on)"
      fi
    fi
  done
}

prune_stale_skills() {
  local dir="$1" d base tier
  for d in "${dir}"/*; do
    [[ -d "$d" ]] || continue
    base="$(basename "$d")"
    # Only ever prune skills this installer generated.
    grep -qF "$CS_MARKER" "${d}/SKILL.md" 2>/dev/null || continue
    if [[ ! -f "${RULES_DIR}/${base}.md" ]]; then
      rm -rf "$d"
      echo -e "    ${RED}✗${NC} skills/${base} (rule no longer exists)"
    else
      tier="$(get_rule_tier "$base")"
      if [[ "$tier" != "skill" ]]; then
        rm -rf "$d"
        echo -e "    ${YELLOW}→${NC} skills/${base} (now ${tier} tier)"
      fi
    fi
  done
}

# Writes content into a marker-delimited block, preserving anything the user
# has outside it. Earlier installs wholesale-overwrote CLAUDE.md/AGENTS.md,
# which silently destroyed user content.
CS_BEGIN="<!-- BEGIN contextsect (managed — edits inside are overwritten) -->"
CS_END="<!-- END contextsect -->"

write_managed_block() {
  local file="$1" content="$2" preserved=""

  if [[ -f "$file" ]]; then
    preserved="$(awk -v b="$CS_BEGIN" -v e="$CS_END" '
      $0 == b { skip = 1; next }
      $0 == e { skip = 0; next }
      !skip   { print }
    ' "$file")"
  fi

  {
    echo "$CS_BEGIN"
    printf '%s\n' "$content"
    echo "$CS_END"
    if [[ -n "${preserved//[[:space:]]/}" ]]; then
      echo ""
      printf '%s\n' "$preserved"
    fi
  } > "${file}.contextsect.tmp"
  mv "${file}.contextsect.tmp" "$file"
}

install_claude_code() {
  echo -e "\n  ${BLUE}Installing for Claude Code...${NC}"
  local target="${HOME}/.claude"
  mkdir -p "${target}" "${target}/skills"

  # T1 — always-on in CLAUDE.md
  write_managed_block "${target}/CLAUDE.md" "$(
    echo "# Token Optimization Rules"
    echo ""
    echo "Source: ContextSect (https://github.com/BhavanPatel/context-sect)"
    echo "Event-scoped rules live in hooks; situational rules live in skills."
    echo ""
    combine_rules steering
  )"
  echo -e "    ${GREEN}✓${NC} ~/.claude/CLAUDE.md ${CYAN}[always-on]${NC}"

  # T2 — hooks. Never clobber an existing settings.json: merge with jq when
  # available, otherwise drop the fragment beside it with instructions.
  local hooks_src="${ADAPTERS_DIR}/claude-hooks.json"
  local settings="${target}/settings.json"
  if [[ -f "$hooks_src" ]]; then
    if command -v jq &>/dev/null; then
      if [[ -f "$settings" ]]; then
        if jq -s '.[0] * .[1]' "$settings" "$hooks_src" > "${settings}.tmp" 2>/dev/null; then
          mv "${settings}.tmp" "$settings"
          echo -e "    ${GREEN}✓${NC} ~/.claude/settings.json ${CYAN}[event-triggered, merged]${NC}"
        else
          rm -f "${settings}.tmp"
          cp "$hooks_src" "${target}/contextsect-hooks.json"
          echo -e "    ${YELLOW}⚠${NC} settings.json is not valid JSON — wrote contextsect-hooks.json instead"
        fi
      else
        cp "$hooks_src" "$settings"
        echo -e "    ${GREEN}✓${NC} ~/.claude/settings.json ${CYAN}[event-triggered]${NC}"
      fi
    else
      cp "$hooks_src" "${target}/contextsect-hooks.json"
      echo -e "    ${YELLOW}⚠${NC} jq not found — wrote ~/.claude/contextsect-hooks.json"
      echo -e "      ${YELLOW}Merge its \"hooks\" key into ~/.claude/settings.json manually.${NC}"
    fi
  fi

  # T3 — on-demand skills
  local name
  while IFS= read -r name; do
    write_skill "${target}/skills/${name}" "$name"
    echo -e "    ${GREEN}✓${NC} skills/${name}/SKILL.md ${CYAN}[on-demand]${NC}"
  done < <(list_rules_by_tier skill)

  prune_stale_skills "${target}/skills"
}

install_cursor() {
  echo -e "\n  ${BLUE}Installing for Cursor...${NC}"
  local target="${HOME}/.cursor/rules"
  mkdir -p "${target}"

  # Profile file (000 prefix loads first)
  {
    echo "---"
    echo "description: \"ContextSect active profile: ${SELECTED_PROFILE}\""
    echo "globs:"
    echo "alwaysApply: true"
    echo "---"
    echo ""
    generate_profile_header
  } > "${target}/000-profile.mdc"
  echo -e "    ${GREEN}✓${NC} rules/000-profile.mdc (${SELECTED_PROFILE})"

  # Cursor does have hooks, but its events are sessionStart, beforeSubmitPrompt,
  # beforeReadFile, beforeShellExecution, beforeMCPExecution, afterFileEdit and
  # stop — there is no pre-edit or generic pre-tool event, and the per-event
  # contract for injecting context is unverified here. T2 rules therefore
  # degrade to always-on rather than shipping guessed hook JSON. See docs.
  local name tier apply
  while IFS= read -r name; do
    tier="$(get_rule_tier "$name")"
    case "$tier" in
      skill) apply="false" ;;   # agent-requested: costs only its description
      *)     apply="true"  ;;   # steering, plus hook-tier degraded to always-on
    esac

    {
      echo "---"
      echo "description: \"$(get_rule_description "$name")\""
      echo "globs:"
      echo "alwaysApply: ${apply}"
      echo "---"
      echo ""
      cat "${RULES_DIR}/${name}.md"
    } > "${target}/9${name}.mdc"

    if [[ "$apply" == "true" ]]; then
      echo -e "    ${GREEN}✓${NC} rules/9${name}.mdc ${CYAN}[always-on]${NC}"
    else
      echo -e "    ${GREEN}✓${NC} rules/9${name}.mdc ${CYAN}[on-demand]${NC}"
    fi
  done < <(list_rules)

  cleanup_removed_rules "${target}" "mdc"
}

# ────────────────────────────────────────────────────────────────
# Agents with a single always-on instruction file
# ────────────────────────────────────────────────────────────────
#
# These have no hook or skill mechanism, so every rule necessarily becomes
# always-on. One shared function replaces six near-identical adapters.
#
# Each agent's native path is still written: AGENTS.md is confirmed for Codex,
# Cursor and Claude Code, but not for Windsurf, Cline, RooCode, OpenCode or
# Aider — so their own paths are kept rather than risking a silent break.

# Older versions wrote one file per rule into these directories. Now that a
# single combined file is used, remove the per-rule leftovers.
prune_per_rule_files() {
  local dir="$1" name
  [[ -d "$dir" ]] || return 0
  while IFS= read -r name; do
    if [[ -f "${dir}/${name}.md" ]]; then
      rm -f "${dir}/${name}.md"
      echo -e "    ${YELLOW}→${NC} removed ${name}.md (consolidated)"
    fi
  done < <(list_rules)
}

install_combined() {
  local file="$1"
  mkdir -p "$(dirname "$file")"
  write_managed_block "$file" "$(
    echo "# Token Optimization Rules"
    echo ""
    echo "Source: ContextSect (https://github.com/BhavanPatel/context-sect)"
    echo "This agent has no hook or skill mechanism, so all rules are always-on."
    echo ""
    combine_rules
  )"
  echo -e "    ${GREEN}✓${NC} ${file/#$HOME/~} ${CYAN}[all rules always-on]${NC}"
}

install_windsurf() {
  echo -e "\n  ${BLUE}Installing for Windsurf...${NC}"
  prune_per_rule_files "${HOME}/.windsurf/rules"
  install_combined "${HOME}/.windsurf/rules/contextsect.md"
}

install_cline() {
  echo -e "\n  ${BLUE}Installing for Cline...${NC}"
  prune_per_rule_files "${HOME}/.clinerules"
  install_combined "${HOME}/.clinerules/contextsect.md"
}

install_roocode() {
  echo -e "\n  ${BLUE}Installing for RooCode...${NC}"
  prune_per_rule_files "${HOME}/.roo/rules"
  install_combined "${HOME}/.roo/rules/contextsect.md"
}

install_opencode() {
  echo -e "\n  ${BLUE}Installing for OpenCode...${NC}"
  install_combined "${HOME}/opencode.md"
}

install_github_copilot() {
  echo -e "\n  ${BLUE}Installing for GitHub Copilot...${NC}"
  install_combined "${HOME}/.github/copilot-instructions.md"
}

install_codex() {
  echo -e "\n  ${BLUE}Installing for OpenAI Codex...${NC}"
  # AGENTS.md is the Linux Foundation-stewarded standard, read by many tools.
  install_combined "${HOME}/AGENTS.md"
}

install_aider() {
  echo -e "\n  ${BLUE}Installing for Aider...${NC}"
  install_combined "${HOME}/.aider.conventions.md"

  # Aider needs an explicit read reference
  local aider_conf="${HOME}/.aider.conf.yml"
  if [[ -f "$aider_conf" ]]; then
    if ! grep -q "conventions" "$aider_conf" 2>/dev/null; then
      echo "read: [\".aider.conventions.md\"]" >> "$aider_conf"
      echo -e "    ${GREEN}✓${NC} .aider.conf.yml updated with read reference"
    fi
  else
    echo "read: [\".aider.conventions.md\"]" > "$aider_conf"
    echo -e "    ${GREEN}✓${NC} .aider.conf.yml created"
  fi
}

# ════════════════════════════════════════════════════════════════
# Companion Stack Info (display only — no auto-install)
# ════════════════════════════════════════════════════════════════

install_companions() {
  echo ""
  echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
  echo -e "${CYAN}║  Companion Stack — Maximize Token Savings            ║${NC}"
  echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"
  echo ""
  echo -e "  ContextSect handles behavioral optimization (Layer 1)."
  echo -e "  For maximum savings, add these companion tools:"
  echo ""
  echo -e "  ${BLUE}Layer 2: CLI Output Compression (60-90% savings)${NC}"
  echo -e "    RTK:         brew install rtk && rtk init -g"
  echo -e "    Token Juice: tokenjuice install claude-code"
  echo -e "    ${YELLOW}→ https://github.com/rtk-ai/rtk${NC}"
  echo -e "    ${YELLOW}→ https://github.com/vincentkoc/tokenjuice${NC}"
  echo ""
  echo -e "  ${BLUE}Layer 3: API Payload Compression (60-94% savings)${NC}"
  echo -e "    Headroom:    pip install headroom-ai && headroom wrap claude"
  echo -e "    ${YELLOW}→ https://github.com/headroomlabs-ai/headroom${NC}"
  echo ""
  echo -e "  ${BLUE}Layer 4: Codebase Knowledge Graph (49-71x reduction)${NC}"
  echo -e "    Graphify:    pip install graphifyy && graphify index ."
  echo -e "    ${YELLOW}→ https://github.com/safishamsi/graphify${NC}"
  echo ""
  echo -e "  ${GREEN}Full guide: docs/companion-stack.md${NC}"
}

# ════════════════════════════════════════════════════════════════
# Main
# ════════════════════════════════════════════════════════════════

main() {
  echo ""
  echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
  echo -e "${CYAN}║  ContextSect — Token Optimization Framework         ║${NC}"
  echo -e "${CYAN}║  Agent-Agnostic • Evidence-Based • Modular          ║${NC}"
  echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"
  echo ""

  # Parse arguments
  local WITH_COMPANIONS=false
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --agent)
        IFS=',' read -ra DETECTED_AGENTS <<< "$2"
        echo -e "${CYAN}Using specified agents: ${DETECTED_AGENTS[*]}${NC}"
        shift 2
        ;;
      --profile)
        SELECTED_PROFILE="$2"
        echo -e "${CYAN}Using specified profile: ${SELECTED_PROFILE}${NC}"
        shift 2
        ;;
      --with-companions)
        WITH_COMPANIONS=true
        shift
        ;;
      *)
        shift
        ;;
    esac
  done

  # Agent detection (if not specified via flag)
  if [[ ${#DETECTED_AGENTS[@]} -eq 0 ]]; then
    detect_agents
  fi

  if [[ ${#DETECTED_AGENTS[@]} -eq 0 ]]; then
    echo -e "${RED}No agents selected. Exiting.${NC}"
    exit 1
  fi

  # Profile selection (if not specified via flag)
  echo ""
  if [[ -z "$SELECTED_PROFILE" ]]; then
    select_profile
  else
    echo -e "  ${GREEN}✓${NC} Profile: ${SELECTED_PROFILE}"
    echo ""
  fi

  echo -e "${CYAN}Installing for ${#DETECTED_AGENTS[@]} agent(s) with profile '${SELECTED_PROFILE}'...${NC}"

  for agent in "${DETECTED_AGENTS[@]}"; do
    case "$agent" in
      kiro)           install_kiro ;;
      claude-code)    install_claude_code ;;
      cursor)         install_cursor ;;
      windsurf)       install_windsurf ;;
      cline)          install_cline ;;
      opencode)       install_opencode ;;
      aider)          install_aider ;;
      roocode)        install_roocode ;;
      github-copilot) install_github_copilot ;;
      codex)          install_codex ;;
      *)              echo -e "  ${YELLOW}⚠ Unknown agent: ${agent}${NC}" ;;
    esac
  done

  # Companion stack installation
  if [[ "$WITH_COMPANIONS" == true ]]; then
    install_companions
  fi

  echo ""
  echo -e "${GREEN}════════════════════════════════════════════════════════${NC}"
  echo -e "${GREEN}  ✅ Installation complete!${NC}"
  echo ""
  echo -e "  Profile:           ${SELECTED_PROFILE}"
  echo -e "  Agents configured: ${DETECTED_AGENTS[*]}"
  echo -e "  Rules installed:   $(ls "${RULES_DIR}"/*.md 2>/dev/null | wc -l | tr -d ' ') files"
  echo ""
  echo -e "  ${YELLOW}Change profile:${NC}  contextsect profile aggressive"
  echo -e "  ${YELLOW}Update rules:${NC}    contextsect update"
  echo -e "  ${YELLOW}Disable/enable:${NC}  contextsect disable | contextsect enable"
  echo -e "  ${YELLOW}Check status:${NC}    contextsect status"
  echo -e "  ${YELLOW}Companions:${NC}      contextsect companions"
  echo -e "${GREEN}════════════════════════════════════════════════════════${NC}"
}

main "$@"
