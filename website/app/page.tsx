"use client";

import { motion } from "framer-motion";
import Hero from "../components/Hero";
import Problem from "../components/Problem";
import Solution from "../components/Solution";
import Agents from "../components/Agents";
import Rules from "../components/Rules";
import CompanionStack from "../components/CompanionStack";
import Profiles from "../components/Profiles";
import Install from "../components/Install";
import Research from "../components/Research";
import Footer from "../components/Footer";

function Reveal({ children, delay = 0 }: { children: React.ReactNode; delay?: number }) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 40 }}
      whileInView={{ opacity: 1, y: 0 }}
      viewport={{ once: true, margin: "-100px" }}
      transition={{ duration: 0.8, delay, ease: [0.16, 1, 0.3, 1] }}
    >
      {children}
    </motion.div>
  );
}

export default function Home() {
  return (
    <main className="relative">
      <div className="relative z-10">
        <section className="h-screen flex items-center justify-center">
          <Hero />
        </section>
        <Reveal><Problem /></Reveal>
        <Reveal delay={0.1}><Solution /></Reveal>
        <Reveal><Agents /></Reveal>
        <Reveal><Rules /></Reveal>
        <Reveal delay={0.1}><CompanionStack /></Reveal>
        <Reveal><Profiles /></Reveal>
        <Reveal><Install /></Reveal>
        <Reveal><Research /></Reveal>
        <Footer />
      </div>
    </main>
  );
}
