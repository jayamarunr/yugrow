/**
 * DS-004A — Design Token Migration Script
 * 
 * Mechanically replaces hardcoded Color(0x...) values with AppColors.* tokens.
 * Run: node scripts/ds-004a-migrate-colors.js
 * 
 * CAUTION: Backup or commit before running.
 */

const fs = require('fs');
const path = require('path');

// Colour mapping: old hex -> AppColors token (use uppercase hex digits)
const COLOR_MAP = {
  '0xFF0F766E': 'AppColors.primary',
  '0xFFF8F9FB': 'AppColors.background',
  '0xFF111827': 'AppColors.textPrimary',
  '0xFF6B7280': 'AppColors.textSecondary',
  '0xFFD1D5DB': 'AppColors.border',
  '0xFFE5E7EB': 'AppColors.border',
  '0xFFF3F4F6': 'AppColors.surfaceHover',
  '0xFF9CA3AF': 'AppColors.textDisabled',
  '0xFFF9FAFB': 'AppColors.surface',
  '0xFF16A34A': 'AppColors.success',
  '0xFFF59E0B': 'AppColors.warning',
  '0xFFD97706': 'AppColors.warning',
  '0xFFDC2626': 'AppColors.error',
  '0xFF2563EB': 'AppColors.info',
  '0xFF3B82F6': 'AppColors.info',
  '0xFF374151': 'AppColors.textPrimary',
  '0xFF856404': 'AppColors.warning',
  '0xFF0284C7': 'AppColors.info',
  '0xFF115E59': 'AppColors.primary',
  '0xFF0D4F4A': 'AppColors.primaryHover',
  '0xFFD1FAF5': 'AppColors.primarySoft',
  '0xFF4338CA': 'AppColors.primary',
  '0xFFE0E7FF': 'AppColors.surface',
  '0xFF64748B': 'AppColors.textDisabled',
  '0xFF525252': 'AppColors.textDisabledDark',
  '0xFF0A0A0A': 'AppColors.backgroundDark',
  '0xFF1A1A1A': 'AppColors.surfaceDark',
  '0xFF262626': 'AppColors.surfaceElevatedDark',
  '0xFF333333': 'AppColors.borderDark',
  '0xFFF5F5F5': 'AppColors.textPrimaryDark',
  '0xFFA3A3A3': 'AppColors.textSecondaryDark',
  '0xFF166534': 'AppColors.primary',
  '0xFFEF4444': 'AppColors.error',
  '0xFFE2E8F0': 'AppColors.border',
  '0xFF1F2937': 'AppColors.textPrimary',
};

// Colours that should NOT be replaced (need design conformance in DS-004B)
const SKIP_COLORS = new Set([
  '0xFFFFF3CD', // warm yellow bg - needs design conformance
  '0xFFFFE58F', // yellow border - needs design conformance
  '0xFFF0FDF4', // light green bg - needs design conformance
  '0xFFFEF2F2', // light red bg - needs design conformance  
  '0xFFFECACA', // light red - needs design conformance
  '0xFFBBF7D0', // light green - needs design conformance
  '0xFFEFF6FF', // light blue bg - needs design conformance
  '0xFFBFDBFE', // light blue border - needs design conformance
  '0xFFBAE6FD', // light blue - needs design conformance
  '0xFFF0F9FF', // light sky blue - needs design conformance
  '0xFFFEF3C7', // light amber - needs design conformance
  '0xFFFFF7ED', // light orange - needs design conformance
  '0xFFFFE5B4', // light peach - needs design conformance
  '0xFF92400E', // dark amber text - needs design conformance
  '0xFF1A1A2E', // dark mode bg variant - needs design conformance
  '0xFF16213E', // dark mode card variant - needs design conformance
]);

const BASE_DIR = path.resolve(__dirname, '..', 'apps', 'mobile', 'lib');

// Files to process (exclude theme files already done)
const FILES = [
  'core/widgets/founder_mode_banner.dart',
  'core/widgets/main_shell.dart',
  'features/auth/login_screen.dart',
  'features/auth/onboarding_screen.dart',
  'features/auth/signup_screen.dart',
  'features/checkin/checkin_complete_screen.dart',
  'features/checkin/home_screen.dart',
  'features/debug/debug_screen.dart',
  'features/debug/founder_console_screen.dart',
  'features/events/public_event_screen.dart',
  'features/host/host_event_screen.dart',
  'features/messaging/message_screen.dart',
  'features/messaging/widgets/announcement_card.dart',
  'features/messaging/widgets/feedback_status_card.dart',
  'features/messaging/widgets/message_renderer.dart',
  'features/messaging/widgets/release_message_card.dart',
  'features/network/network_screen.dart',
  'features/profile/screens/edit_profile_screen.dart',
  'features/profile/widgets/profile_card.dart',
  'features/venue/widgets/create_venue_dialog.dart',
  'features/venue/widgets/create_venue_page.dart',
  'features/venue/widgets/venue_search_field.dart',
  'features/venue/widgets/venue_search_sheet.dart',
];

// Colour reference mapping for Colors.* patterns
// Colors.white and Colors.black are NOT included — they're context-dependent and need manual review
// All Colors.grey[X] shades must be listed BEFORE the bare Colors.grey entry
const COLOR_REF_MAP = [
  { from: 'Colors.grey[900]', to: 'AppColors.textPrimary' },
  { from: 'Colors.grey[800]', to: 'AppColors.textPrimary' },
  { from: 'Colors.grey[700]', to: 'AppColors.textPrimary' },
  { from: 'Colors.grey[600]', to: 'AppColors.textSecondary' },
  { from: 'Colors.grey[500]', to: 'AppColors.textSecondary' },
  { from: 'Colors.grey[400]', to: 'AppColors.textDisabled' },
  { from: 'Colors.grey[350]', to: 'AppColors.border' },
  { from: 'Colors.grey[300]', to: 'AppColors.border' },
  { from: 'Colors.grey[200]', to: 'AppColors.border' },
  { from: 'Colors.grey[100]', to: 'AppColors.surfaceHover' },
  { from: 'Colors.grey[50]', to: 'AppColors.background' },
  { from: 'Colors.grey', to: 'AppColors.textSecondary' },
  { from: 'Colors.black87', to: 'AppColors.textPrimary' },
  { from: 'Colors.black54', to: 'AppColors.textSecondary' },
  { from: 'Colors.black26', to: 'AppColors.textDisabled' },
  { from: 'Colors.black12', to: 'AppColors.border' },
  { from: 'Colors.red[700]', to: 'AppColors.error' },
  { from: 'Colors.red[600]', to: 'AppColors.error' },
  { from: 'Colors.red[500]', to: 'AppColors.error' },
  { from: 'Colors.red', to: 'AppColors.error' },
  { from: 'Colors.green', to: 'AppColors.success' },
  { from: 'Colors.blue', to: 'AppColors.info' },
];

let totalReplaced = 0;
let totalSkipped = 0;
let remaining = {};

for (const relPath of FILES) {
  const filePath = path.join(BASE_DIR, relPath);
  if (!fs.existsSync(filePath)) {
    console.log(`⚠️  MISSING: ${relPath}`);
    continue;
  }
  
  let content = fs.readFileSync(filePath, 'utf8');
  let original = content;
  let fileReplaced = 0;
  let fileSkipped = 0;

  // Ensure AppColors is imported
  const needsImport = !content.includes("import 'package:yugrow_mobile/core/theme/app_colors.dart'") &&
                      !content.includes("import '../");
  // We'll check if any replacements were made first

  // Replace Color(0x...) patterns
  const colorRegex = /(const\s+)?Color\((0x[0-9A-Fa-f]+)\)/g;
  content = content.replace(colorRegex, (match, constKw, hex) => {
    // Normalize: preserve 0x case but uppercase the hex digits
    const prefix = hex.startsWith('0X') ? '0X' : '0x';
    const digits = hex.slice(2).toUpperCase();
    const normalizedHex = prefix + digits;
    
    if (SKIP_COLORS.has(normalizedHex)) {
      fileSkipped++;
      return match;
    }
    
    if (COLOR_MAP[normalizedHex]) {
      fileReplaced++;
      // Don't preserve const — AppColors.* are already static const
      return COLOR_MAP[normalizedHex];
    }
    
    // Unknown colour - track it
    if (!remaining[normalizedHex]) remaining[normalizedHex] = [];
    remaining[normalizedHex].push(relPath);
    return match;
  });

  // Replace Colors.* patterns (ordered: most specific first)
  for (const { from, to } of COLOR_REF_MAP) {
    const escaped = from.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
    const refRegex = new RegExp(escaped, 'g');
    const before = content;
    content = content.replace(refRegex, to);
    if (before !== content) fileReplaced++;
  }

  // Replace Colors.white in button contexts (foregroundColor on buttons)
  const whiteBtnRegex = /foregroundColor:\s+Colors\.white/g;
  let whiteBtnBefore = content;
  content = content.replace(whiteBtnRegex, 'foregroundColor: AppColors.textInverse');
  if (content !== whiteBtnBefore) fileReplaced++;

  // Strip trailing '!' that followed Colors.grey[X] patterns (now non-nullable AppColors.*)
  const bangRegex = /(AppColors\.[a-zA-Z]+)!/g;
  content = content.replace(bangRegex, '$1');

  if (content !== original) {
    // Add import if not already present
    const hasAppColorsImport = /\bapp_colors\.dart/.test(content);
    if (!hasAppColorsImport) {
      // Calculate relative path depth from file location
      const depth = (relPath.match(/\//g) || []).length;
      const relPrefix = depth > 0 ? '../'.repeat(depth) : './';
      const importLine = `import '${relPrefix}core/theme/app_colors.dart';`;
      // Find position after last import to insert
      const importMatch = content.match(/^(import .*;)$/m);
      if (importMatch) {
        const lastImport = content.lastIndexOf(importMatch[1]) + importMatch[1].length;
        content = content.slice(0, lastImport) + '\n' + importLine + content.slice(lastImport);
      } else {
        content = importLine + '\n' + content;
      }
    }
    
    fs.writeFileSync(filePath, content, 'utf8');
    console.log(`✅ ${relPath}: ${fileReplaced} replaced, ${fileSkipped} skipped`);
    totalReplaced += fileReplaced;
    totalSkipped += fileSkipped;
  } else {
    console.log(`➖ ${relPath}: no changes (${fileSkipped} skipped)`);
  }
}

console.log('\n========== TOKEN MIGRATION REPORT ==========');
console.log(`Total colours replaced: ${totalReplaced}`);
console.log(`Total skipped (needs DS-004B): ${totalSkipped}`);

if (Object.keys(remaining).length > 0) {
  console.log('\n--- Remaining Unknown Hardcoded Colours ---');
  for (const [hex, files] of Object.entries(remaining)) {
    console.log(`${hex}: found in ${files.length} file(s) — ${files.join(', ')}`);
  }
}
