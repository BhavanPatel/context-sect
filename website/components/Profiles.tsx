"use client";

const profiles = [
  { name: "Conservative", input: "15–25%", output: "20–30%", risk: "Zero", best: "Learning, prototyping", color: "#10b981", active: false },
  { name: "Balanced", input: "40–55%", output: "50–65%", risk: "Low", best: "Daily development", color: "#a78bfa", active: true },
  { name: "Aggressive", input: "60–75%", output: "70–85%", risk: "Medium", best: "Familiar codebases", color: "#f59e0b", active: false },
  { name: "Ultra-Aggressive", input: "80–90%", output: "85–95%", risk: "High", best: "Automated agents", color: "#ef4444", active: false },
];

export default function Profiles() {
  return (
    <section className="max-w-5xl mx-auto px-6 py-24">
      <h2 className="text-3xl md:text-4xl font-bold mb-4" style={{ color: '#f0f4ff' }}>
        Configuration Profiles
      </h2>
      <p className="text-base mb-10" style={{ color: '#6b7394' }}>
        Choose your intensity level. The installer configures everything automatically.
      </p>

      <div className="grid md:grid-cols-4 gap-4">
        {profiles.map((p) => (
          <div
            key={p.name}
            className="p-5 rounded-xl relative"
            style={{
              background: p.active ? 'rgba(167,139,250,0.08)' : 'rgba(255,255,255,0.02)',
              border: `1px solid ${p.active ? 'rgba(167,139,250,0.4)' : '#1e2130'}`,
            }}
          >
            {p.active && (
              <div className="absolute -top-2 right-3 text-[10px] px-2 py-0.5 rounded-full"
                style={{ background: 'rgba(167,139,250,0.2)', color: '#a78bfa', border: '1px solid rgba(167,139,250,0.3)' }}>
                recommended
              </div>
            )}
            <div className="text-sm font-bold mb-3" style={{ color: p.color }}>{p.name}</div>
            <div className="space-y-2 text-xs" style={{ color: '#b4bcd0' }}>
              <div className="flex justify-between">
                <span>Input ↓</span>
                <span className="font-mono" style={{ color: '#10b981' }}>{p.input}</span>
              </div>
              <div className="flex justify-between">
                <span>Output ↓</span>
                <span className="font-mono" style={{ color: '#f59e0b' }}>{p.output}</span>
              </div>
              <div className="flex justify-between">
                <span>Risk</span>
                <span className="font-mono" style={{ color: p.color }}>{p.risk}</span>
              </div>
            </div>
            <div className="mt-3 pt-3 text-[11px]" style={{ borderTop: '1px solid #1e2130', color: '#5a6480' }}>
              {p.best}
            </div>
          </div>
        ))}
      </div>

      <div className="mt-8 p-4 rounded-lg font-mono text-sm" style={{ background: '#0a0a1a', border: '1px solid #1e2130', color: '#b4bcd0' }}>
        <span style={{ color: '#5a6480' }}>$</span> contextsect profile <span style={{ color: '#a78bfa' }}>balanced</span>
      </div>
    </section>
  );
}
