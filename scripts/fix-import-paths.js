const fs = require('fs');
const path = require('path');

function processDir(dir) {
  for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, e.name);
    if (e.isDirectory()) processDir(full);
    else if (e.name.endsWith('.dart')) processFile(full);
  }
}

function processFile(fp) {
  let c = fs.readFileSync(fp, 'utf8');
  if (!c.includes("import './core/theme/")) return;
  const rel = path.relative('apps/mobile/lib', fp);
  const depth = rel.split(path.sep).length - 1;
  const prefix = depth > 0 ? '../'.repeat(depth) : './';
  const oldPattern = "import './core/theme/";
  const newPattern = "import '" + prefix + "core/theme/";
  const newC = c.replace(new RegExp(oldPattern.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'), 'g'), newPattern);
  if (newC !== c) {
    fs.writeFileSync(fp, newC, 'utf8');
    console.log('Fixed: ' + rel + ' (depth=' + depth + ')');
  }
}

processDir('apps/mobile/lib/features');
processDir('apps/mobile/lib/core/widgets');
console.log('Done');
