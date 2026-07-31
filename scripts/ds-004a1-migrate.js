/**
 * DS-004A.1 — Complete Token Migration Script
 *
 * Migrates remaining styling primitives to YDS tokens:
 * - EdgeInsets values → AppSpacing.*
 * - SizedBox height/width → AppSpacing.*
 * - BorderRadius → AppRadius.*
 * - Duration → YMotion.*
 *
 * Run: node scripts/ds-004a1-migrate.js
 */

const fs = require('fs');
const path = require('path');

const BASE = path.resolve(__dirname, '..', 'apps', 'mobile', 'lib');

// 8pt grid spacing mapping: literal number → YSpacing constant
const SPACING_MAP = {
  0: 'AppSpacing.none',
  4: 'AppSpacing.xs',
  8: 'AppSpacing.sm',
  12: 'AppSpacing.md',
  16: 'AppSpacing.lg',
  24: 'AppSpacing.xl',
  32: 'AppSpacing.xxl',
  48: 'AppSpacing.xxxl',
  64: 'AppSpacing.huge',
};

// Radius mapping: number → AppRadius.Circular
const RADIUS_MAP = {
  4: 'AppRadius.xsCircular',
  8: 'AppRadius.smCircular',
  12: 'AppRadius.mdCircular',
  14: 'AppRadius.lgCircular',
  16: 'AppRadius.xlCircular',
  20: 'AppRadius.xxlCircular',
  9999: 'AppRadius.fullCircular',
};

// Non-standard values — map to closest YDS value (for mechanical migration)
const SPACING_FALLBACK = {
  2: 4,    // → xs
  6: 8,    // → sm
  10: 12,  // → md
  14: 16,  // → lg
  18: 16,  // → lg
  20: 24,  // → xl
  28: 24,  // → xl
  36: 32,  // → xxl
  40: 48,  // → xxxl
  56: 48,  // → xxxl
};

const RADIUS_FALLBACK = {
  6: 8,    // → sm
  10: 12,  // → md
  18: 16,  // → xl
  24: 20,  // → xxl
  28: 20,  // → xxl
};

// All feature files (excluding theme files which are already token-aligned)
const FILES = getDartFiles(path.join(BASE, 'features'));
FILES.push(...getDartFiles(path.join(BASE, 'core', 'widgets')));

function getDartFiles(dir) {
  const results = [];
  try {
    for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
      const full = path.join(dir, entry.name);
      if (entry.isDirectory()) results.push(...getDartFiles(full));
      else if (entry.name.endsWith('.dart')) results.push(full);
    }
  } catch { /* directory may not exist */ }
  return results;
}

// Get relative path from BASE for reporting
function relPath(p) { return path.relative(BASE, p); }

let counts = { spacing: 0, radius: 0, duration: 0, obsolete: 0, skipPatterns: [] };
let ds005Candidates = [];
let remainingStyling = [];

// Process each file
for (const filePath of FILES) {
  let content = fs.readFileSync(filePath, 'utf8');
  const original = content;
  let fileChanged = false;

  // ── 1. Replace EdgeInsets.all(…) with YSpacing ──────────────
  content = content.replace(
    /EdgeInsets\.all\((\d+)\)/g,
    (match, num) => {
      const n = parseInt(num);
      const token = SPACING_MAP[n] || (SPACING_FALLBACK[n] ? SPACING_MAP[SPACING_FALLBACK[n]] : null);
      if (token) {
        counts.spacing++;
        return `EdgeInsets.all(${token})`;
      }
      return match;
    }
  );

  // ── 2. Replace EdgeInsets.symmetric(horizontal: X, vertical: Y) ──
  content = content.replace(
    /EdgeInsets\.symmetric\(horizontal:\s*(\d+),\s*vertical:\s*(\d+)\)/g,
    (match, h, v) => {
      const hn = parseInt(h), vn = parseInt(v);
      const hTok = SPACING_MAP[hn] || (SPACING_FALLBACK[hn] ? SPACING_MAP[SPACING_FALLBACK[hn]] : null);
      const vTok = SPACING_MAP[vn] || (SPACING_FALLBACK[vn] ? SPACING_MAP[SPACING_FALLBACK[vn]] : null);
      if (hTok && vTok) {
        counts.spacing += 2;
        return `EdgeInsets.symmetric(horizontal: ${hTok}, vertical: ${vTok})`;
      }
      return match;
    }
  );

  // ── 3. Replace EdgeInsets.only(…) with YSpacing ──────────────
  content = content.replace(
    /EdgeInsets\.only\(([^)]+)\)/g,
    (match, args) => {
      const replaced = args.replace(/(\w+):\s*(\d+)/g, (m, key, val) => {
        const n = parseInt(val);
        const tok = SPACING_MAP[n] || (SPACING_FALLBACK[n] ? SPACING_MAP[SPACING_FALLBACK[n]] : null);
        if (tok) {
          counts.spacing++;
          return `${key}: ${tok}`;
        }
        return m;
      });
      return `EdgeInsets.only(${replaced})`;
    }
  );

  // ── 4. Replace EdgeInsets.fromLTRB(…) with YSpacing ──────────
  content = content.replace(
    /EdgeInsets\.fromLTRB\(([^)]+)\)/g,
    (match, args) => {
      const parts = args.split(',').map(s => s.trim());
      const replaced = parts.map(p => {
        const n = parseInt(p);
        if (isNaN(n)) return p;
        const tok = SPACING_MAP[n] || (SPACING_FALLBACK[n] ? SPACING_MAP[SPACING_FALLBACK[n]] : null);
        if (tok) { counts.spacing++; return tok; }
        return p;
      });
      return `EdgeInsets.fromLTRB(${replaced.join(', ')})`;
    }
  );

  // ── 5. Replace EdgeInsets with contentPadding ────────────────
  content = content.replace(
    /contentPadding:\s*EdgeInsets\.symmetric\(horizontal:\s*(\d+),\s*vertical:\s*(\d+)\)/g,
    (match, h, v) => {
      const hn = parseInt(h), vn = parseInt(v);
      const hTok = SPACING_MAP[hn] || (SPACING_FALLBACK[hn] ? SPACING_MAP[SPACING_FALLBACK[hn]] : null);
      const vTok = SPACING_MAP[vn] || (SPACING_FALLBACK[vn] ? SPACING_MAP[SPACING_FALLBACK[vn]] : null);
      if (hTok && vTok) {
        counts.spacing += 2;
        return `contentPadding: EdgeInsets.symmetric(horizontal: ${hTok}, vertical: ${vTok})`;
      }
      return match;
    }
  );

  // ── 6. Replace EdgeInsets.all(…) with fromLTRB contentPadding─
  content = content.replace(
    /contentPadding:\s*EdgeInsets\.all\((\d+)\)/g,
    (match, num) => {
      const n = parseInt(num);
      const tok = SPACING_MAP[n] || (SPACING_FALLBACK[n] ? SPACING_MAP[SPACING_FALLBACK[n]] : null);
      if (tok) {
        counts.spacing++;
        return `contentPadding: EdgeInsets.all(${tok})`;
      }
      return match;
    }
  );

  // ── 7. Replace SizedBox(height: X, width: Y) with YSpacing ───
  content = content.replace(
    /SizedBox\(height:\s*(\d+),\s*width:\s*(\d+)\)/g,
    (match, h, w) => {
      const hn = parseInt(h), wn = parseInt(w);
      const hTok = SPACING_MAP[hn] || (SPACING_FALLBACK[hn] ? SPACING_MAP[SPACING_FALLBACK[hn]] : null);
      const wTok = SPACING_MAP[wn] || (SPACING_FALLBACK[wn] ? SPACING_MAP[SPACING_FALLBACK[wn]] : null);
      if (hTok && wTok) {
        counts.spacing += 2;
        return `SizedBox(height: ${hTok}, width: ${wTok})`;
      }
      return match;
    }
  );

  // ── 8. Replace SizedBox(height: X) with YSpacing ─────────────
  content = content.replace(
    /SizedBox\(height:\s*(\d+)\)/g,
    (match, num) => {
      const n = parseInt(num);
      const tok = SPACING_MAP[n] || (SPACING_FALLBACK[n] ? SPACING_MAP[SPACING_FALLBACK[n]] : null);
      if (tok) {
        counts.spacing++;
        return `SizedBox(height: ${tok})`;
      }
      return match;
    }
  );

  // ── 9. Replace SizedBox(width: X) with YSpacing ──────────────
  content = content.replace(
    /SizedBox\(width:\s*(\d+)\)/g,
    (match, num) => {
      const n = parseInt(num);
      const tok = SPACING_MAP[n] || (SPACING_FALLBACK[n] ? SPACING_MAP[SPACING_FALLBACK[n]] : null);
      if (tok) {
        counts.spacing++;
        return `SizedBox(width: ${tok})`;
      }
      return match;
    }
  );

  // ── 10. Replace BorderRadius.circular(…) with YRadius ────────
  content = content.replace(
    /BorderRadius\.circular\((\d+)\)/g,
    (match, num) => {
      const n = parseInt(num);
      if (n >= 9999) { counts.radius++; return 'AppRadius.fullCircular'; }
      const tok = RADIUS_MAP[n];
      if (tok) { counts.radius++; return tok; }
      const fallback = RADIUS_MAP[RADIUS_FALLBACK[n]];
      if (fallback) { counts.radius++; return fallback; }
      return match;
    }
  );

  // ── 11. Replace BorderRadius.only(…) — only topXxl for sheets ─
  content = content.replace(
    /BorderRadius\.only\(topLeft:\s*Radius\.circular\((\d+)\),\s*topRight:\s*Radius\.circular\((\d+)\)\)/g,
    (match, l, r) => {
      if (l === r) {
        const n = parseInt(l);
        if (n === 20) { counts.radius++; return 'AppRadius.topXxl'; }
        const tok = RADIUS_MAP[n] || RADIUS_MAP[RADIUS_FALLBACK[n]];
        if (tok) {
          counts.radius++;
          // Convert circular to top-only border radius
          const name = Object.keys(RADIUS_MAP).find(k => RADIUS_MAP[k] === tok) || 'xl';
          return `BorderRadius.vertical(top: Radius.circular(${tok}))`;
        }
      }
      return match;
    }
  );

  // ── 12. Replace Duration(milliseconds: X) with YMotion ──────
  content = content.replace(
    /Duration\(milliseconds:\s*(\d+)\)/g,
    (match, ms) => {
      const n = parseInt(ms);
      if (n <= 100) { counts.duration++; return 'YMotion.fast'; }
      if (n <= 200) { counts.duration++; return 'YMotion.normal'; }
      if (n <= 350) { counts.duration++; return 'YMotion.slow'; }
      return match;
    }
  );

  // ── 13. Replace AppSpacing.xxx with AppSpacing.xxx ──────────────
  const appSpacingRegex = /AppSpacing\.(\w+)/g;
  if (appSpacingRegex.test(content)) {
    content = content.replace(appSpacingRegex, (match, name) => {
      counts.obsolete++;
      return `AppSpacing.${name}`;
    });
  }

  // ── 14. Detect repeated patterns for DS-005 candidates ──────
  // Track EdgeInsets patterns that appear frequently
  const paddingMatches = content.match(/padding:\s*EdgeInsets\.[^(]+\(([^)]+)\)/g);
  if (paddingMatches) counts.skipPatterns.push(...paddingMatches);

  if (content !== original) {
    // Add YDS imports if not already present
    const needsSpacing = /\bAppSpacing\b/.test(content) && !/app_spacing\.dart/.test(content);
    const needsRadius = /\bAppRadius\b/.test(content) && !/app_radius\.dart/.test(content);
    const needsMotion = /\bAppMotion\b/.test(content) && !/app_motion\.dart/.test(content);
    
    if (needsSpacing || needsRadius || needsMotion) {
      // Calculate relative path from file to theme directory
      const depth = (relPath(filePath).match(/\//g) || []).length;
      const relPrefix = depth > 0 ? '../'.repeat(depth) : './';
      let imports = '';
      if (needsSpacing) imports += `import '${relPrefix}core/theme/app_spacing.dart';\n`;
      if (needsRadius) imports += `import '${relPrefix}core/theme/app_radius.dart';\n`;
      if (needsMotion) imports += `import '${relPrefix}core/theme/app_motion.dart';\n`;
      
      // Insert after last import
      const lastImport = content.lastIndexOf('import ') + content.slice(content.lastIndexOf('import ')).indexOf(';') + 1;
      const insertPos = content.indexOf('\n', lastImport) + 1;
      content = content.slice(0, insertPos) + imports + content.slice(insertPos);
    }
    
    fs.writeFileSync(filePath, content, 'utf8');
    const changes = (original.length - content.length);
    if (Math.abs(changes) > 5) {
      console.log(`✅ ${relPath(filePath)}`);
    }
  }
}

// ── REPORT ─────────────────────────────────────────────────────

console.log('\n========== DS-004A.1 TOKEN MIGRATION REPORT ==========');
console.log(`\nSpacing replacements: ${counts.spacing}`);
console.log(`Radius replacements: ${counts.radius}`);
console.log(`Duration replacements: ${counts.duration}`);
console.log(`Obsolete AppSpacing: ${counts.obsolete}`);

// Count remaining styling primitives
console.log('\n--- Remaining Styling Primitives ---');
const featureDir = path.join(BASE, 'features');
for (const [pattern, label] of [
  ['EdgeInsets\\(', 'EdgeInsets('],
  ['TextStyle\\(', 'TextStyle('],
  ['BorderRadius\\.', 'BorderRadius.'],
  ['SizedBox', 'SizedBox'],
  ['BoxShadow', 'BoxShadow'],
  ['Duration\\(', 'Duration('],
  ['Color\\(0x', 'Color(0x) (hardcoded)'],
]) {
  const grep = require('child_process').execSync(
    `grep -r "${pattern}" "${featureDir}" --include="*.dart" -l 2> nul | wc -l`,
    { shell: 'powershell.exe', encoding: 'utf8', timeout: 10000 }
  ).trim();
  console.log(`${label}: ${grep || '0'} files contain matches`);
}
