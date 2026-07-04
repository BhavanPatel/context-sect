"use client";

export default function Solution() {
  return (
    <section className="max-w-5xl mx-auto px-6 py-24">
      <h2 className="text-3xl md:text-4xl font-bold mb-4" style={{ color: '#f0f4ff' }}>
        Two-Pillar Architecture
      </h2>
      <p className="text-base mb-10" style={{ color: '#6b7394' }}>
        ContextSect attacks the problem from both sides — reducing what goes IN and compressing what comes OUT.
      </p>

      <div className="grid md:grid-cols-2 gap-6">
        {/* Pillar 1 */}
        <div className="p-6 rounded-xl" style={{ background: 'rgba(16,185,129,0.05)', border: '1px solid rgba(16,185,129,0.2)' }}>
          <div className="text-xs font-mono mb-2" style={{ color: '#10b981' }}>PILLAR 1</div>
          <h3 className="text-xl font-bold mb-4" style={{ color: '#f0f4ff' }}>Input Optimization</h3>
          <p className="text-sm mb-4" style={{ color: '#6b7394' }}>
            Prevents unnecessary context expansion BEFORE work begins.
          </p>
          <ul className="space-y-2">
            {[
              "Alignment gate — catch vague prompts early",
              "Search-first — targeted reads only",
              "Progressive loading — tiers, not dumps",
              "Loop detection — halt stuck patterns",
            ].map((item) => (
              <li key={item} className="flex items-start gap-2 text-sm" style={{ color: '#b4bcd0' }}>
                <span style={{ color: '#10b981' }}>→</span>
                {item}
              </li>
            ))}
          </ul>
          <div className="mt-4 text-xs font-mono" style={{ color: '#10b981' }}>-40–55% input tokens</div>
        </div>

        {/* Pillar 2 */}
        <div className="p-6 rounded-xl" style={{ background: 'rgba(245,158,11,0.05)', border: '1px solid rgba(245,158,11,0.2)' }}>
          <div className="text-xs font-mono mb-2" style={{ color: '#f59e0b' }}>PILLAR 2</div>
          <h3 className="text-xl font-bold mb-4" style={{ color: '#f0f4ff' }}>Output Optimization</h3>
          <p className="text-sm mb-4" style={{ color: '#6b7394' }}>
            Minimizes generated tokens AFTER reasoning completes.
          </p>
          <ul className="space-y-2">
            {[
              "Zero filler — no pleasantries or narration",
              "Diff-only — SEARCH/REPLACE, never full files",
              "No restatement — start with the answer",
              "Explain only when asked",
            ].map((item) => (
              <li key={item} className="flex items-start gap-2 text-sm" style={{ color: '#b4bcd0' }}>
                <span style={{ color: '#f59e0b' }}>→</span>
                {item}
              </li>
            ))}
          </ul>
          <div className="mt-4 text-xs font-mono" style={{ color: '#f59e0b' }}>-50–65% output tokens</div>
        </div>
      </div>

      {/* Combined result */}
      <div className="mt-8 p-6 rounded-xl text-center" style={{ background: 'rgba(167,139,250,0.05)', border: '1px solid rgba(167,139,250,0.3)' }}>
        <div className="text-3xl font-bold" style={{ color: '#a78bfa' }}>45–60%</div>
        <div className="text-sm mt-1" style={{ color: '#6b7394' }}>total cost reduction (weighted by 5× output multiplier)</div>
      </div>
    </section>
  );
}
