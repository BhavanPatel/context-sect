"use client";

import { motion } from "framer-motion";

export default function Hero() {
  return (
    <div className="relative z-10 h-full flex flex-col items-center justify-center px-6 text-center">
      <motion.h1
        initial={{ opacity: 0, y: 30, filter: "blur(10px)" }}
        animate={{ opacity: 1, y: 0, filter: "blur(0px)" }}
        transition={{ duration: 1.5, ease: [0.16, 1, 0.3, 1] }}
        className="text-[3rem] md:text-[6rem] lg:text-[8rem] leading-none tracking-[-0.04em] select-none animated-gradient-text"
        style={{
          fontWeight: 900,
          WebkitBackgroundClip: 'text',
          WebkitTextFillColor: 'transparent',
          backgroundClip: 'text',
          backgroundSize: '300% 300%',
          backgroundImage: 'linear-gradient(135deg, #f0f4ff, #a78bfa, #6366f1, #10b981, #f0f4ff)',
          filter: 'drop-shadow(0 0 80px rgba(167,139,250,0.4))',
        }}
      >
        ContextSect
      </motion.h1>

      <motion.p
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.8, duration: 1 }}
        className="mt-4 text-xl md:text-2xl font-light tracking-tight"
        style={{ color: '#6b7394' }}
      >
        Spend less. Ship more.
      </motion.p>

      <motion.p
        initial={{ opacity: 0, y: 15 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 1.2, duration: 0.8 }}
        className="mt-4 text-sm md:text-base max-w-lg leading-relaxed"
        style={{ color: '#4a5268' }}
      >
        Agent-agnostic token optimization. One framework, every AI coding client.
        Evidence-based rules that save 45–60% tokens without reducing quality.
      </motion.p>

      <motion.div
        initial={{ opacity: 0, y: 10 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 1.8, duration: 0.8 }}
        className="mt-8 flex gap-4"
      >
        <a
          href="#install"
          className="px-6 py-3 rounded-lg text-sm font-medium transition-all pulse-glow"
          style={{ background: 'rgba(167,139,250,0.15)', border: '1px solid rgba(167,139,250,0.4)', color: '#a78bfa' }}
        >
          Get Started
        </a>
        <a
          href="https://github.com/BhavanPatel/ContextSect"
          className="px-6 py-3 rounded-lg text-sm font-medium transition-all hover:bg-white/5"
          style={{ border: '1px solid #1e2130', color: '#6b7394' }}
        >
          GitHub
        </a>
      </motion.div>

      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 0.4 }}
        transition={{ delay: 2.5, duration: 1 }}
        className="absolute bottom-10"
      >
        <motion.div
          animate={{ y: [0, 6, 0] }}
          transition={{ repeat: Infinity, duration: 2, ease: "easeInOut" }}
          className="w-5 h-8 rounded-full flex justify-center pt-2"
          style={{ border: '1px solid #1e2130' }}
        >
          <div className="w-1 h-2 rounded-full" style={{ background: '#a78bfa', opacity: 0.7 }} />
        </motion.div>
      </motion.div>
    </div>
  );
}
