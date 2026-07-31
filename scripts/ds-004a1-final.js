/**
 * DS-004A.1 Final — Complete & Verify
 * Run from clean git state.
 * Does NOT use PowerShell — all Node.js.
 */
const fs = require('fs');
const path = require('path');

const BASE = path.resolve('apps/mobile/lib');

// ── Step 1: Run migrations ──────────────────────────────────
console.log('Step 1: Running migrations...');
require('./ds-004a-migrate-colors.js');
require('./ds-004a1-migrate.js');
require('./ds-004a1-typography.js');

// ── Step 2: Add YDS canonical methods to AppTypography ──────
console.log('\nStep 2: Adding YDS canonical methods to AppTypography...');
const typographyFile = path.join(BASE, 'core', 'theme', 'app_typography.dart');
let typography = fs.readFileSync(typographyFile, 'utf8');

// Add canonical YDS methods before the closing brace
const ydsMethods = `
  // ── YDS Canonical API (matches packages/design-system/lib/src/typography.dart) ──
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
`;

if (!typography.includes('YDS Canonical API')) {
  typography = typography.replace(/\n\}$/, ydsMethods);
  fs.writeFileSync(typographyFile, typography, 'utf8');
  console.log('  Added YDS canonical methods to AppTypography');
}

// ── Step 3: Update theme files ──────────────────────────────
console.log('\nStep 3: Updating theme files...');

// app_colors.dart — fix drift values
const colorsFile = path.join(BASE, 'core', 'theme', 'app_colors.dart');
let colors = fs.readFileSync(colorsFile, 'utf8');
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
for (const [from, to] of colorFixes) colors = colors.replace(from, to);
if (!colors.includes('static const info')) {
  colors = colors.replace('static const success',
    'static const info=Color(0xFF2563EB);\n' +
    '  static const successSoft=Color(0xFFECFDF5);\n' +
    '  static const warningSoft=Color(0xFFFFFBEB);\n' +
    '  static const errorSoft=Color(0xFFFEF2F2);\n' +
    '  static const success');
}
// Remove duplicate info line if it was already there incorrectly
const infoLines = colors.match(/static const info.*/g);
if (infoLines && infoLines.length > 1) {
  const first = colors.indexOf(infoLines[0]);
  const second = colors.indexOf(infoLines[1], first + 1);
  colors = colors.slice(0, second) + colors.slice(second + infoLines[1].length);
}
fs.writeFileSync(colorsFile, colors, 'utf8');
console.log('  app_colors.dart drift fixed');

// app_radius.dart — add xs
const radiusFile = path.join(BASE, 'core', 'theme', 'app_radius.dart');
let radii = fs.readFileSync(radiusFile, 'utf8');
if (!radii.includes('static const double xs')) {
  radii = radii.replace('static const double sm', 'static const double xs=4;\n  static const double sm');
}
if (!radii.includes('xsCircular')) {
  radii = radii.replace('static BorderRadius get smCircular',
    'static BorderRadius get xsCircular=>BorderRadius.circular(xs);\n  static BorderRadius get smCircular');
}
fs.writeFileSync(radiusFile, radii, 'utf8');
console.log('  app_radius.dart xs added');

// app_spacing.dart — add none
const spaceFile = path.join(BASE, 'core', 'theme', 'app_spacing.dart');
let spacing = fs.readFileSync(spaceFile, 'utf8');
if (!spacing.includes('static const double none')) {
  spacing = spacing.replace('static const double xs', 'static const double none=0;\n  static const double xs');
  fs.writeFileSync(spaceFile, spacing, 'utf8');
  console.log('  app_spacing.dart none added');
}

// app_motion.dart — create if missing
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
  console.log('  app_motion.dart created');
}

// ── Step 4: Fix imports, YMotion→AppMotion, YTypography→AppTypography, const ──
console.log('\nStep 4: Fixing imports and references...');

function processDir(dirPath) {
  const entries = fs.readdirSync(dirPath, { withFileTypes: true });
  for (const e of entries) {
    const full = path.join(dirPath, e.name);
    if (e.isDirectory()) processDir(full);
    else if (e.name.endsWith('.dart')) processFile(full);
  }
}

const IMPORT_MAP = {
  'AppSpacing.': { file: 'app_spacing.dart', package: 'core/theme/app_spacing.dart' },
  'AppRadius.': { file: 'app_radius.dart', package: 'core/theme/app_radius.dart' },
  'AppMotion.': { file: 'app_motion.dart', package: 'core/theme/app_motion.dart' },
  'AppTypography.': { file: 'app_typography.dart', package: 'core/theme/app_typography.dart' },
};

function processFile(filePath) {
  let content = fs.readFileSync(filePath, 'utf8');
  let changed = false;

  // Fix YTypography→AppTypography, YMotion→AppMotion
  if (content.includes('YTypography.')) {
    content = content.replace(/YTypography\./g, 'AppTypography.');
    changed = true;
  }
  if (content.includes('YMotion.')) {
    content = content.replace(/YMotion\./g, 'AppMotion.');
    changed = true;
  }

  // Remove const before method calls (AppTypography.*() and AppMotion.* are methods, not const)
  content = content.replace(/const AppTypography\./g, 'AppTypography.');
  content = content.replace(/const AppMotion\./g, 'AppMotion.');

  // Add missing imports
  const relPath = path.relative(BASE, filePath);
  if (relPath.startsWith('..')) return; // outside lib/
  
  // Get the imports already present
  const existingImports = (content.match(/import[^;]+;/g) || []).join(' ');

  for (const [token, info] of Object.entries(IMPORT_MAP)) {
    if (content.includes(token) && !existingImports.includes(info.file)) {
      // Calculate correct relative path
      const depth = relPath.split(path.sep).length - 1;
      const prefix = depth > 0 ? '../'.repeat(depth) : './';
      const importLine = `import '${prefix}${info.package}';\n`;
      
      // Insert after the LAST import in the file
      const lastImportEnd = content.lastIndexOf(';') + 1;
      content = content.slice(0, lastImportEnd) + '\n' + importLine + content.slice(lastImportEnd);
      changed = true;
      console.log(`  + ${info.file} → ${relPath}`);
    }
  }

  if (changed) {
    fs.writeFileSync(filePath, content, 'utf8');
  }
}

// Process features/ and core/widgets/
processDir(path.join(BASE, 'features'));
processDir(path.join(BASE, 'core', 'widgets'));

// Also fix the theme files' own imports if needed
processDir(path.join(BASE, 'core', 'theme'));

console.log('\n✅ DS-004A.1 Complete.');
console.log('Run: cd apps/mobile && flutter analyze');
