const fs = require('fs');

// Fix [N] bracket patterns in venue files
const files = [
  'apps/mobile/lib/features/venue/widgets/create_venue_page.dart',
  'apps/mobile/lib/features/venue/widgets/venue_search_field.dart',
];

for (const fp of files) {
  let c = fs.readFileSync(fp, 'utf8');
  const before = c;
  // Replace AppColors.xxx[N] with AppColors.xxx (strip brackets)
  c = c.replace(/(AppColors\.[a-zA-Z]+)\[\d+\]/g, '$1');
  // Also strip trailing '!' after AppColors references
  c = c.replace(/(AppColors\.[a-zA-Z]+)!/g, '$1');
  if (c !== before) {
    fs.writeFileSync(fp, c, 'utf8');
    console.log('Fixed: ' + fp.split('/').pop());
  }
}

// Fix Colors.orange[800] in feedback_inbox
const f2 = 'apps/mobile/lib/features/debug/feedback_inbox_screen.dart';
let c2 = fs.readFileSync(f2, 'utf8');
const b2 = c2;
c2 = c2.replace(/Colors\.orange\[800\]/g, 'AppColors.warning');
c2 = c2.replace(/Colors\.grey\[500\]/g, 'AppColors.textSecondary');
if (c2 !== b2) {
  fs.writeFileSync(f2, c2, 'utf8');
  console.log('Fixed: feedback_inbox_screen.dart');
}

console.log('Done');
