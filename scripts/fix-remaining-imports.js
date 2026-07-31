const fs = require('fs');
const path = require('path');

const BASE = 'apps/mobile/lib';
const IMPORT_MAP = {
  'AppMotion.': { pattern: 'AppMotion\\.', file: 'app_motion.dart', pkg: 'core/theme/app_motion.dart' },
  'AppTypography.': { pattern: 'AppTypography\\.', file: 'app_typography.dart', pkg: 'core/theme/app_typography.dart' },
};

function processDir(dir) {
  for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, e.name);
    if (e.isDirectory()) processDir(full);
    else if (e.name.endsWith('.dart')) processFile(full);
  }
}

function processFile(fp) {
  const rel = path.relative(BASE, fp);
  if (rel.startsWith('..')) return;
  let content = fs.readFileSync(fp, 'utf8');
  const lines = content.split('\n');
  let changed = false;

  for (const [token, info] of Object.entries(IMPORT_MAP)) {
    const tokenRegex = new RegExp(info.pattern);
    if (!tokenRegex.test(content)) continue;
    if (content.includes(info.file)) continue;
    
    // Find last import line to insert after
    let lastImportIdx = -1;
    for (let i = 0; i < lines.length; i++) {
      if (lines[i].match(/^\s*import\s/)) lastImportIdx = i;
    }
    if (lastImportIdx === -1) continue;
    
    const importLine = "import 'package:yugrow_mobile/" + info.pkg + "';";
    lines.splice(lastImportIdx + 1, 0, importLine);
    changed = true;
    console.log('  + ' + info.file + ' → ' + rel);
  }

  if (changed) {
    fs.writeFileSync(fp, lines.join('\n'), 'utf8');
  }
}

processDir(path.join(BASE, 'features'));
processDir(path.join(BASE, 'core', 'widgets'));
console.log('Done');
