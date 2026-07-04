"use client";

export default function Footer() {
  return (
    <footer className="max-w-5xl mx-auto px-6 py-16 mt-12" style={{ borderTop: '1px solid #1e2130' }}>
      <div className="flex flex-col md:flex-row justify-between items-center gap-6">
        <div>
          <div className="text-lg font-bold" style={{ color: '#a78bfa' }}>ContextSect</div>
          <div className="text-sm mt-1" style={{ color: '#5a6480' }}>Agent-agnostic token optimization</div>
        </div>

        <div className="flex gap-6">
          <a href="https://github.com/BhavanPatel/ContextSect" className="text-sm hover:underline" style={{ color: '#6b7394' }}>
            GitHub
          </a>
          <a href="https://github.com/BhavanPatel/ContextSect/blob/main/docs/01-research-summary.md" className="text-sm hover:underline" style={{ color: '#6b7394' }}>
            Research
          </a>
          <a href="https://github.com/BhavanPatel/ContextSect/blob/main/docs/06-final-recommendation.md" className="text-sm hover:underline" style={{ color: '#6b7394' }}>
            Docs
          </a>
        </div>

        <div className="text-xs" style={{ color: '#5a6480' }}>
          Built by{" "}
          <a href="https://github.com/BhavanPatel" className="hover:underline" style={{ color: '#a78bfa' }}>
            Bhavan Patel
          </a>
        </div>
      </div>
    </footer>
  );
}
