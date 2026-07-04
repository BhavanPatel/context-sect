"use client";

export default function Install() {
  return (
    <section id="install" className="max-w-5xl mx-auto px-6 py-24">
      <h2 className="text-3xl md:text-4xl font-bold mb-4" style={{ color: '#f0f4ff' }}>
        Install
      </h2>
      <p className="text-base mb-8" style={{ color: '#6b7394' }}>
        Three commands. Auto-detects your agents. Configures everything.
      </p>

      <div className="rounded-xl overflow-hidden" style={{ background: '#0a0a1a', border: '1px solid #1e2130' }}>
        <div className="flex items-center gap-2 px-4 py-2" style={{ background: '#12122a', borderBottom: '1px solid #1e2130' }}>
          <div className="w-3 h-3 rounded-full" style={{ background: '#ef4444' }} />
          <div className="w-3 h-3 rounded-full" style={{ background: '#f59e0b' }} />
          <div className="w-3 h-3 rounded-full" style={{ background: '#10b981' }} />
          <span className="ml-2 text-xs" style={{ color: '#5a6480' }}>terminal</span>
        </div>
        <pre className="p-6 text-sm font-mono overflow-x-auto" style={{ color: '#b4bcd0' }}>
          <code>{`$ git clone https://github.com/BhavanPatel/ContextSect.git
$ cd ContextSect
$ ./install.sh

╔══════════════════════════════════════════════════════╗
║  ContextSect — Token Optimization Framework         ║
║  Agent-Agnostic • Evidence-Based • Modular          ║
╚══════════════════════════════════════════════════════╝

Detecting installed AI coding agents...

  ✓ Kiro CLI
  ✓ Claude Code
  ✓ Cursor

Select optimization profile:

  1) conservative    — Zero risk. Full exploration.
  2) balanced ⭐     — Recommended. Significant savings.
  3) aggressive      — Maximum savings. Tight budgets.
  4) ultra-aggressive — Absolute minimum tokens.

  Choose profile [1-4, default=2]: 2

  ✓ Profile: balanced

Installing for 3 agent(s) with profile 'balanced'...

  ✓ Kiro: steering + skills + hooks
  ✓ Claude Code: ~/.claude/CLAUDE.md
  ✓ Cursor: .cursor/rules/*.mdc

════════════════════════════════════════════════════════
  ✅ Installation complete!
════════════════════════════════════════════════════════`}</code>
        </pre>
      </div>

      <div className="mt-6 grid md:grid-cols-3 gap-4">
        <div className="p-4 rounded-lg" style={{ background: 'rgba(255,255,255,0.02)', border: '1px solid #1e2130' }}>
          <div className="text-xs font-mono mb-1" style={{ color: '#10b981' }}>Set profile</div>
          <code className="text-sm" style={{ color: '#b4bcd0' }}>./install.sh --profile aggressive</code>
        </div>
        <div className="p-4 rounded-lg" style={{ background: 'rgba(255,255,255,0.02)', border: '1px solid #1e2130' }}>
          <div className="text-xs font-mono mb-1" style={{ color: '#10b981' }}>Specific agents</div>
          <code className="text-sm" style={{ color: '#b4bcd0' }}>./install.sh --agent kiro,cursor</code>
        </div>
        <div className="p-4 rounded-lg" style={{ background: 'rgba(255,255,255,0.02)', border: '1px solid #1e2130' }}>
          <div className="text-xs font-mono mb-1" style={{ color: '#10b981' }}>Update</div>
          <code className="text-sm" style={{ color: '#b4bcd0' }}>git pull && ./install.sh</code>
        </div>
      </div>
    </section>
  );
}
