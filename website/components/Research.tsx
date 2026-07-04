"use client";

const sources = [
  { name: "SkillReducer", type: "Academic", finding: "60% of skill content is non-actionable waste", url: "https://arxiv.org/abs/2603.29919" },
  { name: "AGENTS.md Impact", type: "Academic", finding: "17% output reduction, 29% runtime reduction", url: "https://arxiv.org/abs/2601.20404" },
  { name: "Context Engineering", type: "Academic", finding: "64% fewer tokens, +8% task completion", url: "https://arxiv.org/abs/2606.10209" },
  { name: "GitHub Agentic Workflows", type: "Production", finding: "62% savings eliminating unnecessary tool turns", url: "https://github.blog/ai-and-ml/github-copilot/improving-token-efficiency-in-github-agentic-workflows/" },
  { name: "Caveman Skill", type: "Community", finding: "65% output reduction benchmarked (83k ⭐)", url: "https://github.com/JuliusBrussee/caveman" },
  { name: "Lost in the Middle", type: "Academic", finding: "Context position critically affects quality", url: "https://arxiv.org/html/2307.03172" },
  { name: "Prompt Caching", type: "Production", finding: "60–90% input cost reduction", url: "https://claude.com/blog/lessons-from-building-claude-code-prompt-caching-is-everything" },
  { name: "AgentDiet", type: "Academic", finding: "40–60% input reduction, same performance", url: "https://arxiv.org/abs/2509.23586v1" },
];

export default function Research() {
  return (
    <section className="max-w-5xl mx-auto px-6 py-24">
      <h2 className="text-3xl md:text-4xl font-bold mb-4" style={{ color: '#f0f4ff' }}>
        Research-Backed
      </h2>
      <p className="text-base mb-10" style={{ color: '#6b7394' }}>
        Every decision backed by peer-reviewed papers, production measurements, or benchmarked community tools.
      </p>

      <div className="grid gap-2">
        {sources.map((s) => (
          <a
            key={s.name}
            href={s.url}
            target="_blank"
            rel="noopener noreferrer"
            className="flex items-center gap-4 p-4 rounded-lg transition-all hover:bg-white/5"
            style={{ border: '1px solid #1e2130' }}
          >
            <div className="shrink-0">
              <span
                className="text-[10px] font-mono px-2 py-1 rounded"
                style={{
                  background: s.type === "Academic" ? 'rgba(99,102,241,0.15)' : s.type === "Production" ? 'rgba(16,185,129,0.15)' : 'rgba(245,158,11,0.15)',
                  color: s.type === "Academic" ? '#6366f1' : s.type === "Production" ? '#10b981' : '#f59e0b',
                }}
              >
                {s.type}
              </span>
            </div>
            <div className="flex-1">
              <span className="text-sm font-medium" style={{ color: '#f0f4ff' }}>{s.name}</span>
              <span className="ml-2 text-sm" style={{ color: '#5a6480' }}>{s.finding}</span>
            </div>
            <span className="text-xs" style={{ color: '#5a6480' }}>↗</span>
          </a>
        ))}
      </div>
    </section>
  );
}
