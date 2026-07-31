const fs = require('fs');
const path = require('path');
const BASE = 'apps/mobile/lib';

// Step 2: AppTypography YDS methods
const tf = path.join(BASE, 'core', 'theme', 'app_typography.dart');
let t = fs.readFileSync(tf, 'utf8');
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
  fs.writeFileSync(tf, t, 'utf8');
  console.log('AppTypography: YDS canonical methods added');
}

// Step 3: Theme drift fixes
const cf = path.join(BASE, 'core', 'theme', 'app_colors.dart');
let c = fs.readFileSync(cf, 'utf8');
const colorFixes = [
  ['Color(0xFFF8F9FB)', 'Color(0xFFFAFAFA)'],
  ['Color(0xFFF3F4F6)', 'Color(0xFFFFFFFF)'],
  ['Color(0xFFE5E7EB)', 'Color(0xFFE2E8F0)'],
  ['Color(0xFF115E59)', 'Color(0xFF0F8B6D)'],
  ['Color(0xFF111827)', 'Color(0xFF0F172A)'],
  ['Color(0xFF6B7280)', 'Color(0xFF475569)'],
  ['Color(0xFFD1D5DB)', 'Color(0xFF94A3B8)'],
  ['Color(0xFF0D4F4A)', 'Color(0xFF0B755C)'],
  ['Color(0xFFD1FAF5)', 'Color(0xFFE8F8F2)'],
  ['Color(0xFF16A34A)', 'Color(0xFF059669)'],
  ['Color(0xFFF59E0B)', 'Color(0xFFD97706)'],
  ['Color(0xFF0A0A0A)', 'Color(0xFF0F172A)'],
  ['Color(0xFF1A1A1A)', 'Color(0xFF1E293B)'],
  ['Color(0xFF262626)', 'Color(0xFF334155)'],
  ['Color(0xFF333333)', 'Color(0xFF334155)'],
  ['Color(0xFFF5F5F5)', 'Color(0xFFF1F5F9)'],
  ['Color(0xFFA3A3A3)', 'Color(0xFF94A3B8)'],
  ['Color(0xFF525252)', 'Color(0xFF64748B)'],
];
for (const [from, to] of colorFixes) c = c.replace(from, to);
if (!c.includes('static const info')) {
  c = c.replace('static const success',
    'static const info=Color(0xFF2563EB);\n' +
    '  static const successSoft=Color(0xFFECFDF5);\n' +
    '  static const warningSoft=Color(0xFFFFFBEB);\n' +
    '  static const errorSoft=Color(0xFFFEF2F2);\n' +
    '  static const success');
}
fs.writeFileSync(cf, c, 'utf8');
console.log('Theme drift fixed');

// AppRadius xs
const rf = path.join(BASE, 'core', 'theme', 'app_radius.dart');
let r = fs.readFileSync(rf, 'utf8');
if (!r.includes('static const double xs')) {
  r = r.replace('static const double sm', 'static const double xs=4;\n  static const double sm');
}
if (!r.includes('xsCircular')) {
  r = r.replace('static BorderRadius get smCircular',
    'static BorderRadius get xsCircular=>BorderRadius.circular(xs);\n  static BorderRadius get smCircular');
}
fs.writeFileSync(rf, r, 'utf8');
console.log('AppRadius xs added');

// AppSpacing none
const sf = path.join(BASE, 'core', 'theme', 'app_spacing.dart');
let s = fs.readFileSync(sf, 'utf8');
if (!s.includes('static const double none')) {
  s = s.replace('static const double xs', 'static const double none=0;\n  static const double xs');
  fs.writeFileSync(sf, s, 'utf8');
  console.log('AppSpacing none added');
}

// AppMotion
const mf = path.join(BASE, 'core', 'theme', 'app_motion.dart');
if (!fs.existsSync(mf)) {
  fs.writeFileSync(mf,
`/// YDS Motion Tokens — matches packages/design-system/lib/src/motion.dart
class AppMotion {
  AppMotion._();
  static const Duration fast   = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow   = Duration(milliseconds: 350);
}
`, 'utf8');
  console.log('AppMotion created');
}

// Step 4: Fix imports, rename YTypography/YMotion, remove const before methods
console.log('\nFixing imports and references...');
const IMPORT_MAP = {
  'AppSpacing.': { name: 'app_spacing.dart', pkg: 'core/theme/app_spacing.dart' },
  'AppRadius.': { name: 'app_radius.dart', pkg: 'core/theme/app_radius.dart' },
  'AppMotion.': { name: 'app_motion.dart', pkg: 'core/theme/app_motion.dart' },
  'AppTypography.': { name: 'app_typography.dart', pkg: 'core/theme/app_typography.dart' },
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

  // Rename YTypography→AppTypography, YMotion→AppMotion
  if (content.includes('YTypography.')) { content = content.replace(/YTypography\./g, 'AppTypography.'); changed = true; }
  if (content.includes('YMotion.')) { content = content.replace(/YMotion\./g, 'AppMotion.'); changed = true; }

  // Remove const before method calls
  if (content.includes('const AppTypography.')) { content = content.replace(/const AppTypography\./g, 'AppTypography.'); changed = true; }
  if (content.includes('const AppMotion.')) { content = content.replace(/const AppMotion\./g, 'AppMotion.'); changed = true; }

  // Add missing imports
  const rel = path.relative(BASE, fp);
  if (rel.startsWith('..')) return;
  const existing = (content.match(/import[^;]+;/g) || []).join(' ');

  for (const [token, info] of Object.entries(IMPORT_MAP)) {
    if (content.includes(token) && !existing.includes(info.name)) {
      const depth = rel.split(path.sep).length - 1;
      const prefix = depth > 0 ? '../'.repeat(depth) : './';
      const il = "import '" + prefix + info.pkg + "';\n";
      const insert = content.lastIndexOf(';') + 1;
      content = content.slice(0, insert) + '\n' + il + content.slice(insert);
      changed = true;
    }
  }

  if (changed) {
    fs.writeFileSync(fp, content, 'utf8');
    console.log('  ' + rel);
  }
}

processDir(path.join(BASE, 'features'));
processDir(path.join(BASE, 'core', 'widgets'));
processDir(path.join(BASE, 'core', 'theme'));

console.log('\nDone. Run: cd apps/mobile && flutter analyze');
