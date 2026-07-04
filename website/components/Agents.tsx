"use client";

const agents = [
  { name: "Kiro", format: ".kiro/steering/*.md + hooks", color: "#10b981" },
  { name: "Claude Code", format: "~/.claude/CLAUDE.md", color: "#f59e0b" },
  { name: "Cursor", format: ".cursor/rules/*.mdc", color: "#a78bfa" },
  { name: "Windsurf", format: ".windsurf/rules/*.md", color: "#06b6d4" },
  { name: "Cline", format: ".clinerules/*.md", color: "#ec4899" },
  { name: "OpenCode", format: "~/opencode.md", color: "#8b5cf6" },
  { name: "Aider", format: ".aider.conventions.md", color: "#14b8a6" },
  { name: "RooCode", format: ".roo/rules/*.md", color: "#f97316" },
  { name: "GitHub Copilot", format: "copilot-instructions.md", color: "#6366f1" },
  { name: "OpenAI Codex", format: "~/AGENTS.md", color: "#22c55e" },
];

export default function Agents() {
  return (
    <section className="max-w-5xl mx-auto px-6 py-24">
      <h2 className="text-3xl md:text-4xl font-bold mb-4" style={{ color: '#f0f4ff' }}>
        10 Agents. One Framework.
      </h2>
      <p className="text-base mb-10" style={{ color: '#6b7394' }}>
        Write rules once → auto-adapted to each agent&apos;s native format on install.
      </p>

      <div className="grid grid-cols-2 md:grid-cols-5 gap-3">
        {agents.map((agent) => (
          <div
            key={agent.name}
            className="p-4 rounded-lg text-center transition-all hover:scale-105"
            style={{ background: 'rgba(255,255,255,0.02)', border: `1px solid ${agent.color}33` }}
          >
            <div className="text-sm font-semibold mb-1" style={{ color: agent.color }}>
              {agent.name}
            </div>
            <div className="text-[10px] font-mono" style={{ color: '#5a6480' }}>
              {agent.format}
            </div>
          </div>
        ))}
      </div>

      <div className="mt-8 p-4 rounded-lg" style={{ background: 'rgba(16,185,129,0.05)', border: '1px solid rgba(16,185,129,0.15)' }}>
        <p className="text-sm" style={{ color: '#b4bcd0' }}>
          <strong style={{ color: '#10b981' }}>Auto-detection:</strong> The installer scans your system for installed agents
          and configures each one — no manual config file editing needed.
        </p>
      </div>
    </section>
  );
}
