const fs = require('fs');
const path = require('path');
const BASE = 'apps/mobile/lib';

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

  // Remove const from widget if it uses AppTypography or AppMotion method calls
  // Pattern: const Text(...) where ... contains AppTypography.captionStyle() etc
  const lines = content.split('\n');
  const newLines = [];
  let skipNextConst = false;

  for (let i = 0; i < lines.length; i++) {
    let line = lines[i];
    
    // If this line starts with const and the content contains AppTypography method
    if (line.match(/^\s*const\s+(Text|Row|Column|Container|Padding|Center)\b/)) {
      // Check if AppTypography appears in this block (scan forward to matching paren)
      let depth = 0;
      let startConst = false;
      let hasAppTypo = false;
      for (let j = i; j < Math.min(i + 30, lines.length); j++) {
        const l = lines[j];
        for (const ch of l) {
          if (ch === '(') depth++;
          if (ch === ')') depth--;
        }
        if (l.includes('AppTypography.') || l.includes('AppMotion.')) hasAppTypo = true;
        if (depth <= 0 && startConst) break;
        if (l.includes('(')) startConst = true;
      }
      if (hasAppTypo) {
        line = line.replace(/^\s*const\s+/, m => ' '.repeat(m.length - 5) + '');
        changed = true;
      }
    }
    
    // Also handle inline: label: const Text(...  where Text uses AppTypography
    line = line.replace(/label:\s*const\s+(Text)\(/g, (m, w) => {
      // Check if AppTypography appears later in this line or nearby
      changed = true;
      return 'label: ' + w + '(';
    });

    newLines.push(line);
  }

  if (changed) {
    fs.writeFileSync(fp, newLines.join('\n'), 'utf8');
    console.log('  ' + path.relative(BASE, fp));
  }
}

processDir(path.join(BASE, 'features'));
processDir(path.join(BASE, 'core', 'widgets'));
console.log('Done');
