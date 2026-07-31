# Yugrow Design Tokens — ARCHIVED

> **The YDS tokens have moved to `packages/design-system/`.**
>
> This file is preserved for reference. Do not edit. Make all token changes in the code package.

## Single Source of Truth

| Platform | Location |
|----------|----------|
| **Flutter / Dart** | `packages/design-system/lib/src/` — `colors.dart`, `spacing.dart`, `radius.dart`, `typography.dart`, `motion.dart`, `elevation.dart`, `sizing.dart`, `opacity.dart` |
| **Flutter Theme** | `packages/design-system/lib/src/theme.dart` — `YTheme.light` / `YTheme.dark` |
| **Web CSS** | `packages/design-system/web/css-variables.css` |
| **Web Tailwind** | `packages/design-system/web/tailwind.tokens.js` |

## Usage

### Flutter
```dart
import 'package:yugrow_design_system/yds.dart';

// Use tokens directly
YColors.primary          // #0F8B6D
YSpacing.xl              // 24px
YRadius.lg               // 14px
YTypography.h2Style()    // TextStyle

// Or apply full theme
MaterialApp(
  theme: YTheme.light,
  darkTheme: YTheme.dark,
)
```

### Web (CSS)
```css
@import 'packages/design-system/web/css-variables.css';

.card {
  background: var(--y-surface);
  border-radius: var(--y-radius-xl);
  padding: var(--y-space-5);
  box-shadow: var(--y-shadow-1);
}
```

### Web (Tailwind)
```js
// tailwind.config.js
const yds = require('./packages/design-system/web/tailwind.tokens');
module.exports = {
  theme: { extend: yds },
};
```

## Design Compliance Scoring

| Category | Weight |
|----------|--------|
| Typography | 15% |
| Spacing | 15% |
| Colour | 10% |
| Components | 20% |
| Accessibility | 10% |
| Motion | 5% |
| Empty/Loading/Error | 10% |
| Interaction | 10% |
| Brand Presence | 5% |

Each category: deduct 5 per violation, minimum 0. Total = weighted average.

## Screen Ownership Maturity

| Level | Definition |
|-------|------------|
| 🥇 **Gold** | Fully YDS compliant, accessible, polished, production-ready |
| 🥈 **Silver** | Functional and consistent, with only minor polish remaining |
| 🥉 **Bronze** | Works, but still carries pre-YDS design debt |

See `DESIGN-DEBT.md` for tracked debt items.
