"use client";

const rules = [
  { name: "output-contract", desc: "Zero filler, diff-only, no narration", input: "—", output: "-40–65%", always: true },
  { name: "diff-only", desc: "SEARCH/REPLACE format, never full files", input: "—", output: "-60–90%", always: true },
  { name: "search-first", desc: "Targeted search before file reads", input: "-40–80%", output: "-20–30%", always: true },
  { name: "loop-breaker", desc: "Halt stuck execution patterns", input: "∞ prevent", output: "∞ prevent", always: true },
  { name: "alignment-gate", desc: "Clarify before complex tasks", input: "-50–70%", output: "-50–70%", always: false },
  { name: "plan-before-act", desc: "Plan multi-file changes", input: "+5%", output: "-50–70%", always: false },
  { name: "investigation-mode", desc: "Evidence-first debugging", input: "-40–60%", output: "-50%", always: false },
  { name: "context-hygiene", desc: "Progressive loading, session awareness", input: "-30–50%", output: "indirect", always: false },
];

export default function Rules() {
  return (
    <section className="max-w-5xl mx-auto px-6 py-24">
      <h2 className="text-3xl md:text-4xl font-bold mb-4" style={{ color: '#f0f4ff' }}>
        8 Modular Rules
      </h2>
      <p className="text-base mb-10" style={{ color: '#6b7394' }}>
        Each rule works independently. Enable what you need, disable what you don&apos;t.
      </p>

      <div className="grid gap-2">
        {/* Header */}
        <div className="grid grid-cols-12 gap-2 px-4 py-2 text-xs font-mono" style={{ color: '#5a6480' }}>
          <div className="col-span-3">Rule</div>
          <div className="col-span-4">Purpose</div>
          <div className="col-span-2 text-center">Input ↓</div>
          <div className="col-span-2 text-center">Output ↓</div>
          <div className="col-span-1 text-center">On?</div>
        </div>

        {rules.map((rule) => (
          <div
            key={rule.name}
            className="grid grid-cols-12 gap-2 items-center px-4 py-3 rounded-lg"
            style={{ background: 'rgba(255,255,255,0.02)', border: '1px solid #1e2130' }}
          >
            <div className="col-span-3 text-sm font-mono font-medium" style={{ color: '#a78bfa' }}>
              {rule.name}
            </div>
            <div className="col-span-4 text-sm" style={{ color: '#b4bcd0' }}>
              {rule.desc}
            </div>
            <div className="col-span-2 text-center text-xs font-mono" style={{ color: '#10b981' }}>
              {rule.input}
            </div>
            <div className="col-span-2 text-center text-xs font-mono" style={{ color: '#f59e0b' }}>
              {rule.output}
            </div>
            <div className="col-span-1 text-center text-sm">
              {rule.always ? "✅" : "⚡"}
            </div>
          </div>
        ))}
      </div>

      <div className="mt-4 flex gap-4 text-xs" style={{ color: '#5a6480' }}>
        <span>✅ Always on (zero risk)</span>
        <span>⚡ Task-specific (auto-triggered)</span>
      </div>
    </section>
  );
}
