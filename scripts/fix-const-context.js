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

  // Remove const from widgets that use AppTypography method calls
  // Pattern: const Text(..., style: AppTypography.*(...), ...)
  content = content.replace(
    /const (Text|Column|Row|Container|Padding|Center|SizedBox|Icon)\((?:[^)]*)\)[^;]*\bAppTypography\./g,
    (match) => match.replace(/^const /, '')
  );

  // Also handle the specific case: const Text(label, style: AppTypography.captionStyle())
  content = content.replace(
    /const Text\(([^)]*AppTypography\.[a-zA-Z]+\([^)]*\)[^)]*)\)/g,
    'Text($1)'
  );

  // Remove const before any widget containing AppTypography.*Style()
  content = content.replace(
    /const (Text|Row|Column|Container)\(([^)]*AppTypography\.[a-zA-Z]+Style\([^)]*\)[^)]*)\)/g,
    '$1($2)'
  );

  // Also handle the case where label: Text(...) is used
  content = content.replace(
    /label:\s*const Text\(/g,
    'label: Text('
  );

  if (content !== fs.readFileSync(fp, 'utf8')) {
    fs.writeFileSync(fp, content, 'utf8');
    console.log('Fixed: ' + path.relative(BASE, fp));
  }
}

processDir(path.join(BASE, 'features'));
processDir(path.join(BASE, 'core', 'widgets'));
console.log('Done');
