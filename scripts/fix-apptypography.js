const fs = require('fs');

let c = fs.readFileSync('apps/mobile/lib/core/theme/app_typography.dart', 'utf8');

// Remove self-import
c = c.replace(/\nimport '\.\.\/\.\.\/core\/theme\/app_typography\.dart';/, '');

// Remove legacy body getter and its comment
c = c.replace(/  \/\/ ── Body Text ──[─]+[\s\S]*?static TextStyle get body => const TextStyle\(\s*fontFamily: 'Inter',\s*fontSize: 14,\s*fontWeight: FontWeight\.w400,\s*color: AppColors\.textSecondary,\s*height: 1\.4,\s*\);/, '');

// Add YDS const properties before closing brace
const ydsBlock = `
  // ── YDS Canonical API (matches packages/design-system/lib/src/typography.dart) ──
  static const TextStyle body = TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w400, height: 1.6, color: AppColors.textPrimary);
  static const TextStyle bodyBold = TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w600, height: 1.6, color: AppColors.textPrimary);
  static const TextStyle bodySmall = TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w400, height: 1.5, color: AppColors.textSecondary);
  static const TextStyle caption = TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w500, height: 1.4, letterSpacing: 0.01, color: AppColors.textSecondary);
  static const TextStyle h3 = TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w600, height: 1.4, color: AppColors.textPrimary);
  static const TextStyle h2 = TextStyle(fontFamily: 'Inter', fontSize: 24, fontWeight: FontWeight.w600, height: 1.3, letterSpacing: -0.01, color: AppColors.textPrimary);
  static const TextStyle h1 = TextStyle(fontFamily: 'Inter', fontSize: 32, fontWeight: FontWeight.w700, height: 1.2, letterSpacing: -0.02, color: AppColors.textPrimary);
  static const TextStyle button = TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w600, height: 1.0, color: AppColors.textInverse);
  static const TextStyle buttonSmall = TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, height: 1.0, color: AppColors.primary);
}
`;

c = c.replace(/\n\}$/, ydsBlock);

fs.writeFileSync('apps/mobile/lib/core/theme/app_typography.dart', c, 'utf8');
console.log('AppTypography fixed');
