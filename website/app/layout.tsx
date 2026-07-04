import type { Metadata } from "next";
import { Space_Grotesk, JetBrains_Mono } from "next/font/google";
import "./globals.css";

const spaceGrotesk = Space_Grotesk({
  variable: "--font-space-grotesk",
  subsets: ["latin"],
  weight: ["300", "400", "500", "600", "700"],
});

const jetbrainsMono = JetBrains_Mono({
  variable: "--font-jetbrains-mono",
  subsets: ["latin"],
  weight: ["400", "500"],
});

export const metadata: Metadata = {
  title: "ContextSect — Agent-Agnostic Token Optimization",
  description:
    "One framework, every AI coding client. Evidence-based token optimization that saves 45-60% without reducing quality.",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" className={`${spaceGrotesk.variable} ${jetbrainsMono.variable}`}>
      <body className="antialiased" style={{ background: '#050510', color: '#f0f4ff', fontFamily: 'var(--font-space-grotesk), Space Grotesk, system-ui, sans-serif' }}>
        {children}
      </body>
    </html>
  );
}
