"use client";

const layers = [
  {
    number: 1,
    name: "Behavioral Rules",
    tool: "ContextSect",
    desc: "Teaches agents to search, plan, use compact commands",
    savings: "40–75%",
    color: "#a78bfa",
    isSelf: true,
  },
  {
    number: 2,
    name: "CLI Compression",
    tool: "RTK / Token Juice",
    desc: "Filters shell output before it enters context",
    savings: "60–90%",
    color: "#10b981",
    isSelf: false,
  },
  {
    number: 3,
    name: "API Proxy",
    tool: "Headroom",
    desc: "Compresses payloads in transit to LLM",
    savings: "60–94%",
    color: "#f59e0b",
    isSelf: false,
  },
  {
    number: 4,
    name: "Knowledge Graph",
    tool: "Graphify",
    desc: "Pre-indexes repo for O(1) navigation",
    savings: "49–71x",
    color: "#3b82f6",
    isSelf: false,
  },
];

export default function CompanionStack() {
  return (
    <section className="max-w-5xl mx-auto px-6 py-24">
      <h2 className="text-3xl md:text-4xl font-bold mb-4" style={{ color: '#f0f4ff' }}>
        Companion Stack
      </h2>
      <p className="text-base mb-10" style={{ color: '#6b7394' }}>
        ContextSect is Layer 1. Stack companion tools for 85–95% total savings.
      </p>

      <div className="grid gap-3">
        {layers.map((layer) => (
          <div
            key={layer.number}
            className="flex items-center gap-4 px-5 py-4 rounded-lg"
            style={{
              background: layer.isSelf ? 'rgba(167,139,250,0.08)' : 'rgba(255,255,255,0.02)',
              border: `1px solid ${layer.isSelf ? 'rgba(167,139,250,0.3)' : '#1e2130'}`,
            }}
          >
            <div
              className="w-8 h-8 rounded-full flex items-center justify-center text-sm font-bold shrink-0"
              style={{ background: `${layer.color}20`, color: layer.color }}
            >
              {layer.number}
            </div>
            <div className="flex-1 min-w-0">
              <div className="flex items-center gap-2">
                <span className="text-sm font-semibold" style={{ color: layer.color }}>
                  {layer.tool}
                </span>
                <span className="text-xs px-2 py-0.5 rounded" style={{ background: '#1e2130', color: '#5a6480' }}>
                  {layer.name}
                </span>
              </div>
              <div className="text-sm mt-0.5" style={{ color: '#b4bcd0' }}>
                {layer.desc}
              </div>
            </div>
            <div className="text-right shrink-0">
              <div className="text-sm font-mono font-bold" style={{ color: layer.color }}>
                {layer.savings}
              </div>
              <div className="text-xs" style={{ color: '#5a6480' }}>savings</div>
            </div>
          </div>
        ))}
      </div>

      <div className="mt-6 p-4 rounded-lg font-mono text-sm" style={{ background: '#0a0a1a', border: '1px solid #1e2130', color: '#b4bcd0' }}>
        <span style={{ color: '#5a6480' }}>$</span> contextsect companions
        <span style={{ color: '#5a6480' }}> &nbsp;# shows install commands for each layer</span>
      </div>

      <div className="mt-4 text-xs" style={{ color: '#5a6480' }}>
        Each layer operates independently. No conflicts. ContextSect never auto-installs companions — just shows you what to run.
      </div>
    </section>
  );
}
