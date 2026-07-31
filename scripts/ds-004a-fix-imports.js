const fs = require('fs');
const path = require('path');
const BASE = 'apps/mobile/lib';

function getDartFiles(dir) {
  const results = [];
  try {
    for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
      const full = path.join(dir, e.name);
      if (e.isDirectory()) results.push(...getDartFiles(full));
      else if (e.name.endsWith('.dart')) results.push(full);
    }
  } catch {}
  return results;
}

const allFiles = getDartFiles(path.join(BASE, 'features'));
allFiles.push(...getDartFiles(path.join(BASE, 'core', 'widgets')));

const importMap = {
  'AppSpacing.': 'app_spacing.dart',
  'AppRadius.': 'app_radius.dart',
  'AppMotion.': 'app_motion.dart',
  'AppTypography.': 'app_typography.dart',
};

// Add missing imports
for (const fp of allFiles) {
  let content = fs.readFileSync(fp, 'utf8');
  let changed = false;
  const rel = path.relative(BASE, fp);
  const depth = rel.split(path.sep).length - 1;
  const prefix = depth > 0 ? '../'.repeat(depth) : './';

  for (const [token, importFile] of Object.entries(importMap)) {
    if (content.includes(token) && !content.includes(importFile)) {
      const importLine = "import '" + prefix + "core/theme/" + importFile + "';\n";
      const lastSemi = content.lastIndexOf(';') + 1;
      content = content.slice(0, lastSemi) + '\n' + importLine + content.slice(lastSemi);
      changed = true;
    }
  }

  // Fix const before method calls
  if (content.includes('const AppTypography.')) {
    content = content.replace(/const AppTypography\./g, 'AppTypography.');
    changed = true;
  }
  if (content.includes('const AppMotion.')) {
    content = content.replace(/const AppMotion\./g, 'AppMotion.');
    changed = true;
  }

  if (changed) {
    fs.writeFileSync(fp, content, 'utf8');
    console.log('Fixed: ' + rel);
  }
}

// Update app_colors.dart values
const colorsFile = BASE + '/core/theme/app_colors.dart';
let cc = fs.readFileSync(colorsFile, 'utf8');
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
for (const [from, to] of colorFixes) {
  cc = cc.replace(from, to);
}
if (!cc.includes('static const info')) {
  cc = cc.replace('static const success', 
    'static const info=Color(0xFF2563EB);\n' +
    '  static const successSoft=Color(0xFFECFDF5);\n' +
    '  static const warningSoft=Color(0xFFFFFBEB);\n' +
    '  static const errorSoft=Color(0xFFFEF2F2);\n' +
    '  static const success');
}
fs.writeFileSync(colorsFile, cc);
console.log('Updated app_colors.dart');

// Add xs to AppRadius
const radiusFile = BASE + '/core/theme/app_radius.dart';
let rc = fs.readFileSync(radiusFile, 'utf8');
if (!rc.includes('static const double xs')) {
  rc = rc.replace('static const double sm', 'static const double xs=4;\n  static const double sm');
}
if (!rc.includes('xsCircular')) {
  rc = rc.replace('static BorderRadius get smCircular', 
    'static BorderRadius get xsCircular=>BorderRadius.circular(xs);\n' +
    '  static BorderRadius get smCircular');
}
fs.writeFileSync(radiusFile, rc);
console.log('Updated app_radius.dart');

// Add none to AppSpacing
const spaceFile = BASE + '/core/theme/app_spacing.dart';
let sc = fs.readFileSync(spaceFile, 'utf8');
if (!sc.includes('static const double none')) {
  sc = sc.replace('static const double xs', 'static const double none=0;\n  static const double xs');
  fs.writeFileSync(spaceFile, sc);
  console.log('Updated app_spacing.dart');
}

console.log('\nAll fixes applied. Run flutter analyze.');
