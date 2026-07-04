"use client";

const problems = [
  { label: "Wrong direction", waste: "5k–50k tokens", cause: "Vague prompt → agent guesses → wrong implementation → redo" },
  { label: "Context pollution", waste: "40–80% input", cause: "Reading full files when only one function matters" },
  { label: "Output bloat", waste: "40–65% output", cause: "Filler, restatements, full-file rewrites, narration" },
  { label: "Runaway loops", waste: "10x–100x normal", cause: "Stuck tool calls repeating without progress" },
  { label: "Session accumulation", waste: "30–50% waste", cause: "Old context never pruned, resent every turn" },
];

export default function Problem() {
  return (
    <section className="max-w-5xl mx-auto px-6 py-24">
      <h2 className="text-3xl md:text-4xl font-bold mb-4" style={{ color: '#f0f4ff' }}>
        The Problem
      </h2>
      <p className="text-base mb-10" style={{ color: '#6b7394' }}>
        AI coding agents waste <span style={{ color: '#ef4444' }}>40–80% of tokens</span> on context they don&apos;t need,
        output nobody reads, and implementations that go in the wrong direction.
      </p>

      <div className="grid gap-3">
        {problems.map((p) => (
          <div
            key={p.label}
            className="flex items-center gap-4 p-4 rounded-lg"
            style={{ background: 'rgba(239,68,68,0.05)', border: '1px solid rgba(239,68,68,0.15)' }}
          >
            <div className="shrink-0 w-32 text-right">
              <span className="text-xs font-mono" style={{ color: '#ef4444' }}>{p.waste}</span>
            </div>
            <div>
              <span className="font-semibold text-sm" style={{ color: '#f0f4ff' }}>{p.label}</span>
              <span className="ml-2 text-sm" style={{ color: '#5a6480' }}>{p.cause}</span>
            </div>
          </div>
        ))}
      </div>

      <div className="mt-8 p-4 rounded-lg" style={{ background: 'rgba(167,139,250,0.05)', border: '1px solid rgba(167,139,250,0.2)' }}>
        <p className="text-sm" style={{ color: '#b4bcd0' }}>
          <strong style={{ color: '#a78bfa' }}>Key insight:</strong> Output tokens cost <strong>5×</strong> input tokens ($15/M vs $3/M).
          A single unnecessary full-file rewrite wastes more money than reading 4,000 tokens of input.
        </p>
      </div>
    </section>
  );
}
