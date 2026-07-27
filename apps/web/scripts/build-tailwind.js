/**
 * ─── Build Tailwind CSS ───────────────────────────────────────────
 * Precompiles Tailwind directives and inlines them into globals.css.
 *
 * This is a temporary workaround for Next.js 14.2 + pnpm monorepo
 * where the tailwindcss PostCSS plugin isn't resolved correctly.
 *
 * Run:  node scripts/build-tailwind.js
 * Fix:  Resolve PostCSS plugin resolution before Beta (FD-032).
 */

const postcss = require('postcss');
const tailwindcss = require('tailwindcss');
const autoprefixer = require('autoprefixer');
const fs = require('fs');
const path = require('path');

const GLOBALS_PATH = path.join(__dirname, '..', 'src', 'app', 'globals.css');

async function build() {
  // 1. Generate Tailwind CSS from directives
  const css = '@tailwind base; @tailwind components; @tailwind utilities;';
  const result = await postcss([
    tailwindcss({ config: path.join(__dirname, '..', 'tailwind.config.js') }),
    autoprefixer,
  ]).process(css, { from: undefined });

  const tailwindBlock = `/* ─── Tailwind CSS (precompiled) ─────────────────────────── */\n${result.css}`;

  // 2. Read current globals.css and strip any existing Tailwind block
  const currentGlobals = fs.readFileSync(GLOBALS_PATH, 'utf8');
  const cleaned = currentGlobals.replace(
    /\/\* ─── Tailwind CSS \(precompiled\) ─────────────────────────── \*\/[\s\S]*?\n(?=\/\* ─── Yugrow Design)/,
    ''
  );

  // 3. Write back: Tailwind block + separator + original custom styles
  fs.writeFileSync(
    GLOBALS_PATH,
    tailwindBlock + '\n\n' + cleaned
  );

  console.log(`✅ Tailwind CSS regenerated — ${(result.css.length / 1024).toFixed(1)} KB`);
}

build().catch(err => {
  console.error('❌ Failed:', err.message);
  process.exit(1);
});
