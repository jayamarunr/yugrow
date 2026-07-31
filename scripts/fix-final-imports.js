const fs = require('fs');
const path = require('path');
const BASE = 'apps/mobile/lib';

const IMPORT_SOURCES = {
  'AppSpacing.': { name: 'app_spacing.dart', pkg: 'core/theme/app_spacing.dart' },
  'AppRadius.': { name: 'app_radius.dart', pkg: 'core/theme/app_radius.dart' },
  'AppMotion.': { name: 'app_motion.dart', pkg: 'core/theme/app_motion.dart' },
  'AppTypography.': { name: 'app_typography.dart', pkg: 'core/theme/app_typography.dart' },
  'surfaceHover': { name: 'surfaceHover', special: 'add to AppColors' },
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
  const rel = path.relative(BASE, fp);

  // Skip theme files — they define the classes
  if (rel.startsWith('core\\theme')) return;

  const existingImports = (content.match(/import[^;]+;/g) || []).join(' ');

  for (const [token, info] of Object.entries(IMPORT_SOURCES)) {
    if (info.special) continue; // Handle separately
    if (content.includes(token) && !existingImports.includes(info.name)) {
      const depth = rel.split('\\').length - 1;
      const prefix = depth > 0 ? '../'.repeat(depth) : './';
      const importLine = "import '" + prefix + info.pkg + "';\n";
      const lastImport = content.lastIndexOf(';');
      const insertAt = content.indexOf('\n', lastImport) + 1;
      content = content.slice(0, insertAt) + importLine + content.slice(insertAt);
      changed = true;
      console.log('  + ' + info.name + ' → ' + rel);
    }
  }

  if (changed) {
    fs.writeFileSync(fp, content, 'utf8');
  }
}

// Process all feature and core/widget files
processDir(path.join(BASE, 'features'));
processDir(path.join(BASE, 'core', 'widgets'));

// Also add surfaceHover to AppColors if missing
const colorsFile = path.join(BASE, 'core', 'theme', 'app_colors.dart');
let cc = fs.readFileSync(colorsFile, 'utf8');
if (!cc.includes('surfaceHover')) {
  cc = cc.replace('static const surface', 'static const surfaceHover = Color(0xFFF8FAFC);\n  static const surface');
  fs.writeFileSync(colorsFile, cc, 'utf8');
  console.log('  + surfaceHover added to AppColors');
}

console.log('Done. Run flutter analyze.');
