const fs = require('fs');
const path = require('path');
const BASE = 'apps/mobile/lib';
const { execSync } = require('child_process');

console.log('=== DS-004A.1 Final Comprehensive Migration ===\n');

// Step 1: Run colour migration
console.log('Step 1: Colour migration...');
execSync('node scripts/ds-004a-migrate-colors.js 2>nul', { stdio: 'inherit', cwd: process.cwd(), timeout: 60000 });

// Step 2: Run spacing/radius/motion migration (ignore grep error)
console.log('\nStep 2: Spacing/radius/motion migration...');
const result2 = execSync('node scripts/ds-004a1-migrate.js 2>&1', { 
  encoding: 'utf8', cwd: process.cwd(), timeout: 60000 
});
// Only output non-grep lines
result2.split('\n').filter(l => !l.includes('grep') && !l.includes('Error:') && l.trim()).forEach(l => console.log(l));

// Step 3: Run typography migration
console.log('\nStep 3: Typography migration...');
execSync('node scripts/ds-004a1-typography.js 2>nul', { stdio: 'inherit', cwd: process.cwd(), timeout: 60000 });

// Step 4: Fix theme drift
console.log('\nStep 4: Fixing theme drift...');
const colorsFile = path.join(BASE, 'core', 'theme', 'app_colors.dart');
let c = fs.readFileSync(colorsFile, 'utf8');
const fixes = [
  ['Color(0xFFF8F9FB)', 'Color(0xFFFAFAFA)'], ['Color(0xFFF3F4F6)', 'Color(0xFFFFFFFF)'],
  ['Color(0xFFE5E7EB)', 'Color(0xFFE2E8F0)'], ['Color(0xFF115E59)', 'Color(0xFF0F8B6D)'],
  ['Color(0xFF111827)', 'Color(0xFF0F172A)'], ['Color(0xFF6B7280)', 'Color(0xFF475569)'],
  ['Color(0xFFD1D5DB)', 'Color(0xFF94A3B8)'], ['Color(0xFF0D4F4A)', 'Color(0xFF0B755C)'],
  ['Color(0xFFD1FAF5)', 'Color(0xFFE8F8F2)'], ['Color(0xFF16A34A)', 'Color(0xFF059669)'],
  ['Color(0xFFF59E0B)', 'Color(0xFFD97706)'], ['Color(0xFF0A0A0A)', 'Color(0xFF0F172A)'],
  ['Color(0xFF1A1A1A)', 'Color(0xFF1E293B)'], ['Color(0xFF262626)', 'Color(0xFF334155)'],
  ['Color(0xFF333333)', 'Color(0xFF334155)'], ['Color(0xFFF5F5F5)', 'Color(0xFFF1F5F9)'],
  ['Color(0xFFA3A3A3)', 'Color(0xFF94A3B8)'], ['Color(0xFF525252)', 'Color(0xFF64748B)'],
];
for (const [f, t] of fixes) c = c.replace(f, t);
if (!c.includes('static const info')) {
  c = c.replace('static const success',
    'static const info=Color(0xFF2563EB);\n' +
    '  static const successSoft=Color(0xFFECFDF5);\n' +
    '  static const warningSoft=Color(0xFFFFFBEB);\n' +
    '  static const errorSoft=Color(0xFFFEF2F2);\n' +
    '  static const success');
}
// Remove surfaceHover if missing — add it
if (!c.includes('surfaceHover')) {
  c = c.replace('static const surface',
    'static const surfaceHover=Color(0xFFF8FAFC);\n  static const surface');
}
fs.writeFileSync(colorsFile, c, 'utf8');
console.log('  app_colors.dart fixed ✓');

// AppRadius — add xs
const radiusFile = path.join(BASE, 'core', 'theme', 'app_radius.dart');
let r = fs.readFileSync(radiusFile, 'utf8');
if (!r.includes('static const double xs')) {
  r = r.replace('static const double sm', 'static const double xs=4;\n  static const double sm');
}
if (!r.includes('xsCircular')) {
  r = r.replace('static BorderRadius get smCircular',
    'static BorderRadius get xsCircular=>BorderRadius.circular(xs);\n  static BorderRadius get smCircular');
}
fs.writeFileSync(radiusFile, r, 'utf8');
console.log('  app_radius.xs added ✓');

// AppSpacing — add none
const spaceFile = path.join(BASE, 'core', 'theme', 'app_spacing.dart');
let s = fs.readFileSync(spaceFile, 'utf8');
if (!s.includes('static const double none')) {
  s = s.replace('static const double xs', 'static const double none=0;\n  static const double xs');
  fs.writeFileSync(spaceFile, s, 'utf8');
  console.log('  app_spacing.none added ✓');
}

// AppMotion — create
const motionFile = path.join(BASE, 'core', 'theme', 'app_motion.dart');
if (!fs.existsSync(motionFile)) {
  fs.writeFileSync(motionFile,
`/// YDS Motion Tokens — matches packages/design-system/lib/src/motion.dart
class AppMotion {
  AppMotion._();
  static const Duration fast   = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow   = Duration(milliseconds: 350);
}
`, 'utf8');
  console.log('  app_motion.dart created ✓');
}

// AppTypography — add YDS canonical methods
const typoFile = path.join(BASE, 'core', 'theme', 'app_typography.dart');
let t = fs.readFileSync(typoFile, 'utf8');
if (!t.includes('YDS Canonical API')) {
  t = t.replace(/\n\}$/, '\n' +
`  // ── YDS Canonical API (matches packages/design-system/lib/src/typography.dart) ──
  static TextStyle bodyStyle({Color? color}) =>
      TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w400, height: 1.6, color: color ?? AppColors.textPrimary);

  static TextStyle bodyBoldStyle({Color? color}) =>
      TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w600, height: 1.6, color: color ?? AppColors.textPrimary);

  static TextStyle bodySmallStyle({Color? color}) =>
      TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w400, height: 1.5, color: color ?? AppColors.textSecondary);

  static TextStyle captionStyle({Color? color}) =>
      TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w500, height: 1.4, letterSpacing: 0.01, color: color ?? AppColors.textSecondary);

  static TextStyle h3Style({Color? color}) =>
      TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w600, height: 1.4, color: color ?? AppColors.textPrimary);

  static TextStyle h2Style({Color? color}) =>
      TextStyle(fontFamily: 'Inter', fontSize: 24, fontWeight: FontWeight.w600, height: 1.3, letterSpacing: -0.01, color: color ?? AppColors.textPrimary);

  static TextStyle h1Style({Color? color}) =>
      TextStyle(fontFamily: 'Inter', fontSize: 32, fontWeight: FontWeight.w700, height: 1.2, letterSpacing: -0.02, color: color ?? AppColors.textPrimary);

  static TextStyle buttonStyle({Color? color}) =>
      TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w600, height: 1.0, color: color ?? AppColors.textInverse);

  static TextStyle buttonSmallStyle({Color? color}) =>
      TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, height: 1.0, color: color ?? AppColors.primary);
}
`);
  fs.writeFileSync(typoFile, t, 'utf8');
  console.log('  app_typography YDS methods added ✓');
}

// Step 5: Fix references and add imports
console.log('\nStep 5: Fixing references and imports...');
const IMPORT_SOURCES = {
  'AppSpacing.': 'app_spacing.dart',
  'AppRadius.': 'app_radius.dart',
  'AppMotion.': 'app_motion.dart',
  'AppTypography.': 'app_typography.dart',
};

function processDir(dir) {
  for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, e.name);
    if (e.isDirectory()) processDir(full);
    else if (e.name.endsWith('.dart')) processFile(full);
  }
}

function processFile(fp) {
  let content = fs.readFileSync(fp, 'utf8');
  let changed = false;

  // Rename incorrect names
  if (content.includes('YTypography.')) { content = content.replace(/YTypography\./g, 'AppTypography.'); changed = true; }
  if (content.includes('YMotion.')) { content = content.replace(/YMotion\./g, 'AppMotion.'); changed = true; }

  // Fix wrong import paths: ./core/theme/ → package:yugrow_mobile/core/theme/
  if (content.includes("import './core/theme/")) {
    content = content.replace(/import '\.\/core\/theme\//g, "import 'package:yugrow_mobile/core/theme/");
    changed = true;
  }

  // Remove const before method calls
  if (content.includes('const AppTypography.')) { content = content.replace(/const AppTypography\./g, 'AppTypography.'); changed = true; }
  if (content.includes('const AppMotion.')) { content = content.replace(/const AppMotion\./g, 'AppMotion.'); changed = true; }

  // Add missing imports (at TOP of file, after first import)
  const firstImportLine = content.indexOf("import '");
  if (firstImportLine === -1) { if (changed) fs.writeFileSync(fp, content, 'utf8'); return; }
  const firstImportEnd = content.indexOf('\n', firstImportLine);
  
  for (const [token, sourceFile] of Object.entries(IMPORT_SOURCES)) {
    if (content.includes(token) && !content.includes(sourceFile)) {
      const importLine = "import 'package:yugrow_mobile/core/theme/" + sourceFile + "';\n";
      content = content.slice(0, firstImportEnd + 1) + importLine + content.slice(firstImportEnd + 1);
      changed = true;
    }
  }

  if (changed) {
    // Clean up any duplicate identical import lines
    const lines = content.split('\n');
    const seen = new Set();
    const deduped = lines.filter(l => {
      if (l.startsWith("import 'package:") || l.startsWith("import '") && l.includes('/')) {
        const key = l.replace(/\s+/g, '');
        if (seen.has(key)) return false;
        seen.add(key);
      }
      return true;
    });
    fs.writeFileSync(fp, deduped.join('\n'), 'utf8');
  }
}

processDir(path.join(BASE, 'features'));
processDir(path.join(BASE, 'core', 'widgets'));

console.log('\n✅ DS-004A.1 Complete!');
console.log('Run: cd apps/mobile && flutter analyze');
