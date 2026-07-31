const fs = require('fs');
const path = require('path');
const BASE = 'apps/mobile/lib';

// Mapping: old method call → new const property
const METHOD_MAP = {
  'bodyStyle': 'body',
  'bodyBoldStyle': 'bodyBold',
  'bodySmallStyle': 'bodySmall',
  'captionStyle': 'caption',
  'h1Style': 'h1',
  'h2Style': 'h2',
  'h3Style': 'h3',
  'buttonStyle': 'button',
  'buttonSmallStyle': 'buttonSmall',
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

  for (const [oldMethod, newProp] of Object.entries(METHOD_MAP)) {
    const pattern = 'AppTypography.' + oldMethod;
    if (!content.includes(pattern)) continue;

    // Replace: AppTypography.captionStyle() → AppTypography.caption
    const noArgRegex = new RegExp('AppTypography\\.' + oldMethod + '\\(\\)', 'g');
    content = content.replace(noArgRegex, 'AppTypography.' + newProp);

    // Replace: AppTypography.captionStyle(color: X) → AppTypography.caption.copyWith(color: X)
    const withColorRegex = new RegExp('AppTypography\\.' + oldMethod + '\\(color:\\s*([^)]+)\\)', 'g');
    content = content.replace(withColorRegex, 'AppTypography.' + newProp + '.copyWith(color: $1)');

    // Replace any remaining bare references (shouldn't happen, but just in case)
    const bareRegex = new RegExp('AppTypography\\.' + oldMethod + '\\b', 'g');
    content = content.replace(bareRegex, 'AppTypography.' + newProp);

    changed = true;
  }

  if (changed) {
    fs.writeFileSync(fp, content, 'utf8');
    console.log('  ' + path.relative(BASE, fp));
  }
}

processDir(path.join(BASE, 'features'));
processDir(path.join(BASE, 'core', 'widgets'));
// Also fix the theme file itself (app_typography.dart references itself for class name)
const typoFile = path.join(BASE, 'core', 'theme', 'app_typography.dart');
let typo = fs.readFileSync(typoFile, 'utf8');
// Replace any old method references in the file itself (there shouldn't be any)
for (const [oldMethod, newProp] of Object.entries(METHOD_MAP)) {
  const pattern = 'AppTypography.' + oldMethod;
  if (typo.includes(pattern) && !typo.includes('oldMethod')) {
    typo = typo.replace(new RegExp('AppTypography\\.' + oldMethod + '\\b', 'g'), 'AppTypography.' + newProp);
  }
}
fs.writeFileSync(typoFile, typo, 'utf8');

console.log('Done');
