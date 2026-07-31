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
  const before = content;

  // Remove 'const' from widgets whose args contain AppTypography.*.copyWith or AppMotion
  // These are genuinely non-constant expressions
  const widgetPattern = /const\s+(Text|Container|Row|Column|Center|Padding|SizedBox|Icon)\s*\(/g;
  let match;
  const replacements = [];

  while ((match = widgetPattern.exec(content)) !== null) {
    const widgetName = match[1];
    const start = match.index;
    // Find the matching closing paren
    let depth = 0;
    let end = start;
    for (let i = start; i < content.length; i++) {
      if (content[i] === '(') depth++;
      if (content[i] === ')') depth--;
      if (depth === 0) { end = i + 1; break; }
    }
    const widgetText = content.slice(start, end);
    // Check if this widget contains a .copyWith or AppMotion reference
    if (widgetText.includes('.copyWith(') || widgetText.includes('AppMotion.')) {
      replacements.push({ start, end, widgetName });
    }
  }

  // Apply replacements in reverse order
  for (let i = replacements.length - 1; i >= 0; i--) {
    const { start, end, widgetName } = replacements[i];
    const replacement = widgetName + '(';
    const constLen = 'const '.length;
    content = content.slice(0, start + constLen) + replacement + content.slice(start + constLen + replacement.length);
    // Actually simpler: just remove 'const ' prefix
    content = content.slice(0, start) + content.slice(start + 6);
  }

  if (content !== before) {
    fs.writeFileSync(fp, content, 'utf8');
    console.log('  ' + path.relative(BASE, fp));
  }
}

processDir(path.join(BASE, 'features'));
processDir(path.join(BASE, 'core', 'widgets'));
console.log('Done');
