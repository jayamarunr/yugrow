/**
 * DS-004A.1 — TextStyle → YTypography Migration
 *
 * Migrates common TextStyle patterns to YTypography.*Style() calls.
 * Non-standard sizes (13, 11, 10, 15, 18px) are reported but not migrated.
 * Patterns appearing in 3+ files are flagged as DS-005 candidates.
 */

const fs = require('fs');
const path = require('path');

const BASE = path.resolve(__dirname, '..', 'apps', 'mobile', 'lib');

// Exact TextStyle pattern → YTypography replacement
// Ordered from most specific to least specific
const TEXT_STYLE_MAP = [
  // Caption (12px, 500 weight)
  { from: "TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSecondary)", to: "YTypography.captionStyle(color: AppColors.textSecondary)" },
  { from: "TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: mutedColor)", to: "YTypography.captionStyle(color: mutedColor)" },
  { from: "TextStyle(fontSize: 12, fontWeight: FontWeight.w500)", to: "YTypography.captionStyle()" },
  { from: "TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500)", to: "YTypography.captionStyle(color: AppColors.textSecondary)" },
  { from: "TextStyle(fontSize: 12, color: mutedColor)", to: "YTypography.captionStyle(color: mutedColor)" },
  { from: "TextStyle(fontSize: 12, color: AppColors.textSecondary)", to: "YTypography.captionStyle(color: AppColors.textSecondary)" },
  { from: "TextStyle(fontSize: 12, color: AppColors.textDisabled)", to: "YTypography.captionStyle(color: AppColors.textDisabled)" },
  { from: "TextStyle(fontSize: 12, color: AppColors.warning)", to: "YTypography.captionStyle(color: AppColors.warning)" },
  { from: "TextStyle(fontSize: 12, color: AppColors.error)", to: "YTypography.captionStyle(color: AppColors.error)" },
  { from: "TextStyle(fontSize: 12, color: textColor)", to: "YTypography.captionStyle(color: textColor)" },
  { from: "TextStyle(fontSize: 12, color: color)", to: "YTypography.captionStyle(color: color)" },
  { from: "TextStyle(fontSize: 12, fontWeight: FontWeight.w600)", to: "YTypography.captionStyle().copyWith(fontWeight: FontWeight.w600)" },
  { from: "TextStyle(fontSize: 12)", to: "YTypography.captionStyle()" },

  // Body Small (14px, 400 weight)
  { from: "TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textSecondary)", to: "YTypography.bodySmallStyle(color: AppColors.textSecondary)" },
  { from: "TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: mutedColor)", to: "YTypography.bodySmallStyle(color: mutedColor)" },
  { from: "TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: textColor)", to: "YTypography.bodySmallStyle(color: textColor)" },
  { from: "TextStyle(fontSize: 14, fontWeight: FontWeight.w400)", to: "YTypography.bodySmallStyle()" },
  { from: "TextStyle(fontSize: 14, color: AppColors.textSecondary, fontWeight: FontWeight.w500)", to: "YTypography.bodySmallStyle(color: AppColors.textSecondary).copyWith(fontWeight: FontWeight.w500)" },
  { from: "TextStyle(fontSize: 14, color: AppColors.textSecondary)", to: "YTypography.bodySmallStyle(color: AppColors.textSecondary)" },
  { from: "TextStyle(fontSize: 14, color: textColor)", to: "YTypography.bodySmallStyle(color: textColor)" },
  { from: "TextStyle(fontSize: 14, color: mutedColor)", to: "YTypography.bodySmallStyle(color: mutedColor)" },
  { from: "TextStyle(fontSize: 14, color: AppColors.textPrimary)", to: "YTypography.bodySmallStyle(color: AppColors.textPrimary)" },
  { from: "TextStyle(fontSize: 14, color: AppColors.error)", to: "YTypography.bodySmallStyle(color: AppColors.error)" },
  { from: "TextStyle(fontSize: 14, color: AppColors.warning)", to: "YTypography.bodySmallStyle(color: AppColors.warning)" },
  { from: "TextStyle(fontSize: 14, color: AppColors.primary)", to: "YTypography.bodySmallStyle(color: AppColors.primary)" },
  { from: "TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary)", to: "YTypography.buttonSmallStyle(color: AppColors.textSecondary)" },
  { from: "TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor)", to: "YTypography.buttonSmallStyle(color: textColor)" },
  { from: "TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: mutedColor)", to: "YTypography.buttonSmallStyle(color: mutedColor)" },
  { from: "TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: color)", to: "YTypography.buttonSmallStyle(color: color)" },
  { from: "TextStyle(fontSize: 14, fontWeight: FontWeight.w600)", to: "YTypography.buttonSmallStyle()" },
  { from: "TextStyle(fontSize: 14)", to: "YTypography.bodySmallStyle()" },

  // Body (16px, 400 weight)
  { from: "TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textPrimary)", to: "YTypography.bodyStyle(color: AppColors.textPrimary)" },
  { from: "TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textSecondary)", to: "YTypography.bodyStyle(color: AppColors.textSecondary)" },
  { from: "TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: textColor)", to: "YTypography.bodyStyle(color: textColor)" },
  { from: "TextStyle(fontSize: 16, fontWeight: FontWeight.w400)", to: "YTypography.bodyStyle()" },
  { from: "TextStyle(fontSize: 16, color: AppColors.textPrimary, fontWeight: FontWeight.w600)", to: "YTypography.bodyBoldStyle(color: AppColors.textPrimary)" },
  { from: "TextStyle(fontSize: 16, color: AppColors.primary, fontWeight: FontWeight.w600)", to: "YTypography.bodyBoldStyle(color: AppColors.primary)" },
  { from: "TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)", to: "YTypography.bodyBoldStyle(color: AppColors.textPrimary)" },
  { from: "TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.primary)", to: "YTypography.bodyBoldStyle(color: AppColors.primary)" },
  { from: "TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textColor)", to: "YTypography.bodyBoldStyle(color: textColor)" },
  { from: "TextStyle(fontSize: 16, fontWeight: FontWeight.w600)", to: "YTypography.bodyBoldStyle()" },
  { from: "TextStyle(fontSize: 16)", to: "YTypography.bodyStyle()" },

  // H3 (20px, 600 weight)
  { from: "TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary)", to: "YTypography.h3Style(color: AppColors.textPrimary)" },
  { from: "TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textSecondary)", to: "YTypography.h3Style(color: AppColors.textSecondary)" },
  { from: "TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: textColor)", to: "YTypography.h3Style(color: textColor)" },
  { from: "TextStyle(fontSize: 20, fontWeight: FontWeight.w600)", to: "YTypography.h3Style()" },

  // H2 (24px, 600 weight)
  { from: "TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary)", to: "YTypography.h1Style(color: AppColors.textPrimary)" },
  { from: "TextStyle(fontSize: 24, fontWeight: FontWeight.w700)", to: "YTypography.h1Style()" },
  { from: "TextStyle(fontSize: 24, fontWeight: FontWeight.w600)", to: "YTypography.h2Style()" },
  { from: "TextStyle(fontSize: 24)", to: "YTypography.h2Style()" },

  // Non-standard sizes to report (13, 11, 10, 15, 18)
  // These will be captured by the remainder report
];

function getDartFiles(dir) {
  const results = [];
  try {
    for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
      const full = path.join(dir, entry.name);
      if (entry.isDirectory()) results.push(...getDartFiles(full));
      else if (entry.name.endsWith('.dart')) results.push(full);
    }
  } catch { }
  return results;
}

function relPath(p) {
  return path.relative(BASE, p);
}

const files = getDartFiles(path.join(BASE, 'features'));
files.push(...getDartFiles(path.join(BASE, 'core', 'widgets')));

let totalReplaced = 0;
let remainingPatterns = {};
let nonStandardSizes = {};
let ds005Candidates = {};

for (const filePath of files) {
  let content = fs.readFileSync(filePath, 'utf8');
  const original = content;
  let fileReplaced = 0;

  for (const { from, to } of TEXT_STYLE_MAP) {
    // Escape the pattern for regex
    const escaped = from.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
    const regex = new RegExp(escaped, 'g');
    const before = content;
    content = content.replace(regex, to);
    if (content !== before) fileReplaced++;
  }

  if (fileReplaced > 0) {
    fs.writeFileSync(filePath, content, 'utf8');
    totalReplaced += fileReplaced;
    console.log(`✅ ${relPath(filePath)}: ${fileReplaced} TextStyle replacements`);
  }

  // Track remaining non-YTypography TextStyle patterns
  const textStyles = content.match(/TextStyle\([^)]*\)/g);
  if (textStyles) {
    for (const ts of textStyles) {
      // Check for non-standard font sizes
      const sizeMatch = ts.match(/fontSize:\s*(\d+)/);
      if (sizeMatch) {
        const size = parseInt(sizeMatch[1]);
        if (![12, 14, 16, 20, 24, 28, 32, 48].includes(size)) {
          if (!nonStandardSizes[size]) nonStandardSizes[size] = [];
          nonStandardSizes[size].push(`${relPath(filePath)}: ${ts}`);
        }
      }
      if (!ts.includes('YTypography')) {
        const key = ts.substring(0, 80);
        if (!remainingPatterns[key]) remainingPatterns[key] = [];
        remainingPatterns[key].push(relPath(filePath));
      }
    }
  }
}

console.log(`\n========== TEXTSTYLE MIGRATION REPORT ==========`);
console.log(`Total TextStyle replacements: ${totalReplaced}`);

if (Object.keys(nonStandardSizes).length > 0) {
  console.log(`\n--- Non-standard font sizes remaining (DS-004B) ---`);
  for (const [size, occurrences] of Object.entries(nonStandardSizes).sort((a, b) => a[0] - b[0])) {
    console.log(`${size}px: ${occurrences.length} occurrences`);
    for (const occ of occurrences.slice(0, 3)) console.log(`  ${occ}`);
    if (occurrences.length > 3) console.log(`  ... and ${occurrences.length - 3} more`);
  }
}

if (Object.keys(remainingPatterns).length > 0) {
  console.log(`\n--- Remaining TextStyle patterns (not migrated) ---`);
  const sorted = Object.entries(remainingPatterns).sort((a, b) => b[1].length - a[1].length);
  for (const [pattern, files] of sorted.slice(0, 15)) {
    console.log(`[${files.length} files] ${pattern}`);
  }
  if (sorted.length > 15) console.log(`... and ${sorted.length - 15} more patterns`);
}
