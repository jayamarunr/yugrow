---
Title: Yugrow Design Kit v1.0
Version: 1.0
Status: Approved
Owner: Founder / CPO
Last Updated: 2026-07-22
Dependencies:
  - docs/YUGROW-FLOW-EXPERIENCE-SYSTEM.md
  - docs/YUGROW-DESIGN-PRINCIPLES.md
Related Documents:
  - packages/ui/src/
  - apps/mobile/lib/core/theme/
  - apps/web/src/styles/
---

# Yugrow Design Kit v1.0

> **A practical implementation reference for every screen in the Yugrow platform.**
>
> This kit translates the Yugrow Flow experience system into concrete components, tokens, and patterns for both Flutter and Next.js. Every screen in the product should be composable from pieces defined here.
>
> **If it's not in this kit, it doesn't exist yet. Build it, add it here, then use it.**

---

## Table of Contents

1. [Mobile Tokens](#1-mobile-tokens)
2. [Web Tokens](#2-web-tokens)
3. [Typography Scale](#3-typography-scale)
4. [Icon System](#4-icon-system)
5. [Button Library](#5-button-library)
6. [Card Library](#6-card-library)
7. [Avatar System](#7-avatar-system)
8. [Empty States](#8-empty-states)
9. [Motion Guidelines](#9-motion-guidelines)
10. [Workspace Switcher](#10-workspace-switcher)
11. [CheckIN Components](#11-checkin-components)
12. [Inputs & Forms](#12-inputs--forms)
13. [Navigation Components](#13-navigation-components)
14. [Status & Feedback](#14-status--feedback)
15. [Layout Templates](#15-layout-templates)
16. [Code References](#16-code-references)

---

## 1. Mobile Tokens

### 1.1 Color Tokens (Flutter)

```dart
// lib/core/theme/app_colors.dart

class AppColors {
  // Neutrals
  static const background = Color(0xFFF8F9FB);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceElevated = Color(0xFFF3F4F6);
  static const border = Color(0xFFE5E7EB);
  static const borderActive = Color(0xFF0F766E);

  // Text
  static const textPrimary = Color(0xFF111827);
  static const textSecondary = Color(0xFF6B7280);
  static const textDisabled = Color(0xFFD1D5DB);
  static const textInverse = Color(0xFFFFFFFF);

  // Primary — Deep Emerald (Relationships)
  static const primary = Color(0xFF0F766E);
  static const primaryHover = Color(0xFF115E59);
  static const primarySoft = Color(0xFFCCFBF1);

  // Secondary — Warm Indigo (AI)
  static const secondary = Color(0xFF4338CA);
  static const secondarySoft = Color(0xFFE0E7FF);

  // Semantic
  static const success = Color(0xFF16A34A);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFDC2626);

  // Dark mode
  static const backgroundDark = Color(0xFF0A0A0A);
  static const surfaceDark = Color(0xFF1A1A1A);
  static const borderDark = Color(0xFF333333);
  static const textPrimaryDark = Color(0xFFF5F5F5);
  static const textSecondaryDark = Color(0xFFA3A3A3);
}
```

### 1.2 Spacing Tokens (Flutter)

```dart
class AppSpacing {
  static const double xs = 4;    // space-1
  static const double sm = 8;    // space-2
  static const double md = 12;   // space-3
  static const double lg = 16;   // space-4
  static const double xl = 24;   // space-5
  static const double xxl = 32;  // space-6
  static const double xxxl = 48; // space-7
  static const double huge = 64; // space-8

  // Screen margins
  static const double screenMobile = 24;
  static const double screenDesktop = 32;

  // Card padding
  static const double cardDense = 16;
  static const double cardComfortable = 24;

  // Touch targets
  static const double touchMin = 44;
}
```

### 1.3 Radius Tokens (Flutter)

```dart
class AppRadius {
  static const double sm = 6;
  static const double md = 10;
  static const double lg = 12;
  static const double xl = 16;
  static const double xxl = 24;
  static const double full = 9999;
}
```

### 1.4 Surface Levels (Flutter)

```dart
class AppElevation {
  // Surface 1 — Cards, list items
  static const surface1 = [
    BoxShadow(
      offset: Offset(0, 1),
      blurRadius: 2,
      color: Color.fromRGBO(0, 0, 0, 0.05),
    ),
  ];

  // Surface 2 — Hover, bottom nav
  static const surface2 = [
    BoxShadow(
      offset: Offset(0, 4),
      blurRadius: 6,
      color: Color.fromRGBO(0, 0, 0, 0.07),
    ),
  ];

  // Surface 3 — Modals, dialogs
  static const surface3 = [
    BoxShadow(
      offset: Offset(0, 10),
      blurRadius: 15,
      color: Color.fromRGBO(0, 0, 0, 0.1),
    ),
  ];

  // Surface 4 — Bottom sheets
  static const surface4 = [
    BoxShadow(
      offset: Offset(0, 20),
      blurRadius: 25,
      color: Color.fromRGBO(0, 0, 0, 0.15),
    ),
  ];
}
```

---

## 2. Web Tokens

### 2.1 CSS Custom Properties

```css
/* styles/tokens.css */

:root {
  /* Colors */
  --y-bg: #F8F9FB;
  --y-surface: #FFFFFF;
  --y-surface-elevated: #F3F4F6;
  --y-border: #E5E7EB;
  --y-border-active: #0F766E;

  --y-text-primary: #111827;
  --y-text-secondary: #6B7280;
  --y-text-disabled: #D1D5DB;
  --y-text-inverse: #FFFFFF;

  --y-primary: #0F766E;
  --y-primary-hover: #115E59;
  --y-primary-soft: #CCFBF1;
  --y-secondary: #4338CA;
  --y-success: #16A34A;
  --y-warning: #F59E0B;
  --y-error: #DC2626;

  /* Surfaces */
  --y-surface-1: 0 1px 2px rgba(0,0,0,0.05);
  --y-surface-2: 0 4px 6px rgba(0,0,0,0.07);
  --y-surface-3: 0 10px 15px rgba(0,0,0,0.10);
  --y-surface-4: 0 20px 25px rgba(0,0,0,0.15);

  /* Radii */
  --y-radius-sm: 6px;
  --y-radius-md: 10px;
  --y-radius-lg: 12px;
  --y-radius-xl: 16px;
  --y-radius-2xl: 24px;
  --y-radius-full: 9999px;

  /* Spacing */
  --y-space-1: 4px;
  --y-space-2: 8px;
  --y-space-3: 12px;
  --y-space-4: 16px;
  --y-space-5: 24px;
  --y-space-6: 32px;
  --y-space-7: 48px;
  --y-space-8: 64px;

  /* Motion */
  --y-motion-instant: 100ms;
  --y-motion-fast: 150ms;
  --y-motion-normal: 200ms;
  --y-motion-slow: 250ms;
  --y-ease-out: cubic-bezier(0.16, 1, 0.3, 1);
}

.dark {
  --y-bg: #0A0A0A;
  --y-surface: #1A1A1A;
  --y-surface-elevated: #262626;
  --y-border: #333333;
  --y-text-primary: #F5F5F5;
  --y-text-secondary: #A3A3A3;
  --y-text-disabled: #525252;

  /* Dark mode: no shadows */
  --y-surface-1: none;
  --y-surface-2: none;
  --y-surface-3: none;
  --y-surface-4: none;
}
```

---

## 3. Typography Scale

### 3.1 Flutter TextTheme

```dart
// lib/core/theme/app_theme.dart

TextTheme(
  displayLarge: GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.02,
  ),
  headlineMedium: GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: -0.01,
  ),
  titleLarge: GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
  ),
  bodyLarge: GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
  ),
  bodyMedium: GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  ),
  bodySmall: GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0.01,
  ),
  labelLarge: GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1,
  ),
  labelMedium: GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1,
    letterSpacing: 0.01,
  ),
  labelSmall: GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.33,
    letterSpacing: 0.02,
  ),
)
```

### 3.2 Web Typography (Tailwind)

```js
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter', 'system-ui', '-apple-system', 'sans-serif'],
        mono: ['JetBrains Mono', 'monospace'],
      },
      fontSize: {
        'y-display': ['32px', { lineHeight: '1.2', fontWeight: '700', letterSpacing: '-0.02em' }],
        'y-heading': ['24px', { lineHeight: '1.3', fontWeight: '600', letterSpacing: '-0.01em' }],
        'y-title': ['18px', { lineHeight: '1.4', fontWeight: '600' }],
        'y-body': ['16px', { lineHeight: '1.6', fontWeight: '400' }],
        'y-body-sm': ['14px', { lineHeight: '1.5', fontWeight: '400' }],
        'y-caption': ['12px', { lineHeight: '1.4', fontWeight: '400', letterSpacing: '0.01em' }],
        'y-label': ['12px', { lineHeight: '1.33', fontWeight: '500', letterSpacing: '0.02em' }],
        'y-btn': ['16px', { lineHeight: '1', fontWeight: '600' }],
        'y-btn-sm': ['14px', { lineHeight: '1', fontWeight: '500', letterSpacing: '0.01em' }],
      },
    },
  },
};
```

### 3.3 Typography Usage Rules

| Context | Token | Max Width | Spacing |
|---------|-------|-----------|---------|
| Hero text | `text-display` | 600px | 32px below |
| Screen title | `text-heading` | 400px | 24px below |
| Card title | `text-title` | 300px | 8px below |
| Body paragraph | `text-body` | 65ch | 1em paragraph gap |
| Caption | `text-caption` | 100% | 4px above/below |
| Label | `text-label` (uppercase) | 100% | 4px below |
| Stat/number | `text-heading` with tabular-nums | auto | — |

---

## 4. Icon System

### 4.1 Installation

**Flutter:** `flutter pub add lucide_icons`

```dart
import 'package:lucide_icons/lucide_icons.dart';

// Usage
Icon(LucideIcons.users, size: 20, color: AppColors.textSecondary);
```

**Web:** `npm install lucide-react`

```tsx
import { Users } from 'lucide-react';

// Usage
<Users size={20} className="text-y-text-secondary" />
```

### 4.2 Icon Sizing

| Context | Size | Container |
|---------|------|-----------|
| Tab bar | 24px | 44x44px hit area |
| Button (with label) | 16px | Inline with text |
| Button (icon only) | 20px | 44x44px hit area |
| Card | 16-20px | Inline |
| Empty state | 48px | Centered |
| Notification | 16px | Inline |
| Avatar badge | 12px | Overlay on avatar |

### 4.3 Icon Color

Icons inherit text color by default. Only override for specific contexts:

| Context | Color |
|---------|-------|
| Default | `color-text-secondary` |
| Active tab | `color-primary` |
| Button icon | Button text color |
| Connected ✓ | `color-success` |
| Error | `color-error` |
| AI feature | `color-secondary` |

---

## 5. Button Library

### 5.1 Button Specs

| Property | Primary | Secondary | Outline | Ghost | Danger |
|----------|---------|-----------|---------|-------|--------|
| Background | `primary` | `secondary` | Transparent | Transparent | `error` |
| Text color | White | White | `text-primary` | `text-secondary` | White |
| Border | None | None | 1px `border` | None | None |
| Hover | 95% opacity | 95% opacity | bg `surface-elevated` | bg `surface-elevated` | 95% opacity |
| Pressed | 90% opacity | 90% opacity | bg darker | bg darker | 90% opacity |
| Disabled | `opacity-disabled` | `opacity-disabled` | `opacity-disabled` | `opacity-disabled` | `opacity-disabled` |

### 5.2 Button Sizes

| Size | Height | Padding H | Font | Icon Gap | Radius |
|------|--------|-----------|------|----------|--------|
| `sm` | 32px | 12px | `text-button-small` | 6px | `radius-lg` (12px) |
| `md` | 44px | 20px | `text-button` | 8px | `radius-lg` (12px) |
| `lg` | 52px | 24px | `text-button` | 8px | `radius-lg` (12px) |
| `xl` | 64px | 32px | `text-button` | 10px | `radius-lg` (12px) |

### 5.3 Button States

```
default ───────── hover ───────── pressed ──────── disabled ──────── loading
[Primary]         [Primary]       [Primary]         [Primary]         [Primary]
                                                  (opacity 0.4)      [⟳]
```

### 5.4 Flutter Implementation

```dart
// lib/core/widgets/yugrow_button.dart

class YugrowButton extends StatelessWidget {
  const YugrowButton({
    super.key,
    required this.label,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.md,
    this.icon,
    this.loading = false,
    this.disabled = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed =
        (loading || disabled) ? null : onPressed;

    final button = switch (variant) {
      ButtonVariant.primary => ElevatedButton(
        style: _primaryStyle(context),
        onPressed: effectiveOnPressed,
        child: _content,
      ),
      ButtonVariant.outline => OutlinedButton(
        style: _outlineStyle(context),
        onPressed: effectiveOnPressed,
        child: _content,
      ),
      ButtonVariant.ghost => TextButton(
        style: _ghostStyle(context),
        onPressed: effectiveOnPressed,
        child: _content,
      ),
      ButtonVariant.danger => ElevatedButton(
        style: _dangerStyle(context),
        onPressed: effectiveOnPressed,
        child: _content,
      ),
    };

    return switch (size) {
      ButtonSize.sm => SizedBox(height: 32, child: button),
      ButtonSize.md => SizedBox(height: 44, child: button),
      ButtonSize.lg => SizedBox(height: 52, child: button),
      ButtonSize.xl => SizedBox(height: 64, child: button),
    };
  }

  Widget get _content => loading
      ? const SizedBox(
          width: 20, height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        )
      : Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: size == ButtonSize.sm ? 16 : 20),
              const SizedBox(width: size == ButtonSize.sm ? 6 : 8),
            ],
            Text(label, style: _textStyle),
          ],
        );
}
```

### 5.5 Key Buttons

| Button | Variant | Size | Icon | Usage |
|--------|---------|------|------|-------|
| I'm Here | Primary | xl | `map-pin` | CheckIN home |
| Connect | Outline | md | `user-plus` | Live discovery cards |
| Send Message | Primary | md | `send` | Chat input |
| Accept | Primary | sm | `check` | Connection request |
| Decline | Ghost | sm | `x` | Connection request |
| Create Event | Primary | md | `plus` | Events screen |
| Edit Profile | Outline | sm | `edit-3` | Profile screen |
| Save | Primary | md | `check` | Forms |
| Cancel | Ghost | sm | `x` | Forms |
| View All | Ghost | sm | `chevron-right` | Section footers |

---

## 6. Card Library

### 6.1 Base Card

```dart
// lib/core/widgets/yugrow_card.dart

class YugrowCard extends StatelessWidget {
  const YugrowCard({
    super.key,
    required this.child,
    this.padding = 16.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: AppElevation.surface1,
      ),
      child: child,
    );
  }
}
```

### 6.2 Person Card (Profile Preview)

```dart
// lib/core/widgets/person_card.dart

// ┌──────────────────────────────────────┐
// │  [Avatar]  Name                      │
// │            Company · Role            │
// │            {skill} {skill}           │
// │            3 mutual connections      │
// │                      [Connect]       │
// └──────────────────────────────────────┘

// Specifications:
// - Avatar: 48px, radius-full
// - Name: text-title, text-primary
// - Company/role: text-body-small, text-secondary
// - Skills: chips, 8px gap, radius-sm
// - Mutual connections: text-caption, primary color
// - Connect button: outline, sm size
```

### 6.3 Event Card

```dart
// ┌──────────────────────────────────────┐
// │  [Photo]                             │
// │                                      │
// │  Event Name                          │
// │  Venue Name · City                   │
// │  Today, 4:00 PM                      │
// │                      [Check In]      │
// └──────────────────────────────────────┘

// Specifications:
// - Photo: 16:9 ratio, radius-xl top corners
// - Event name: text-title, text-primary
// - Venue: text-body-small, text-secondary
// - Time: text-caption, text-secondary
// - Check-in button: primary, sm size
// - Card padding: 20px (comfortable)
```

### 6.4 Connection Request Card

```dart
// ┌──────────────────────────────────────┐
// │  [Avatar]  Name                      │
// │            "Investment"              │
// │            Met at: AI Expo Chennai   │
// │                         [Accept][X]  │
// └──────────────────────────────────────┘

// Specifications:
// - Intent badge: pill, primary-soft bg, primary text
// - Context line: text-caption, text-secondary
// - Actions: Accept (primary, sm) + Decline (ghost, sm, error color)
```

### 6.5 Opportunity Card (Broadcast)

```dart
// ┌──────────────────────────────────────┐
// │  Looking for Investment Partner      │
// │  Chennai · Remote OK                 │
// │  Seed stage SaaS startup             │
// │  7 mutual connections in space       │
// │                      [View Details]  │
// └──────────────────────────────────────┘

// Specifications:
// - Title: text-title, text-primary
// - Location: text-body-small, text-secondary
// - Description: text-body-small, text-primary
// - Mutual context: text-caption, primary color
// - Action: outline button, sm size
```

### 6.6 Venue Card

```dart
// ┌──────────────────────────────────────┐
// │  [Photo]                             │
// │                                      │
// │  Chennai Trade Centre                 │
// │  Chennai, Tamil Nadu                 │
// │  3 events this week                  │
// └──────────────────────────────────────┘

// Specifications:
// - Photo: 16:9 ratio
// - Name: text-title
// - Location: text-body-small, text-secondary
// - Event count: text-caption, primary color
```

---

## 7. Avatar System

### 7.1 Avatar Sizes

| Size | Pixels | Radius | Font Size | Usage |
|------|--------|--------|-----------|-------|
| `sm` | 32px | `full` | 14px | Lists, comments |
| `md` | 48px | `full` | 18px | Person cards, profiles |
| `lg` | 64px | `full` | 24px | Profile header |
| `xl` | 80px | `full` | 32px | Full profile page |

### 7.2 Avatar Fallback

When no photo is available, show the first letter of the person's name on a `primary-soft` background.

```dart
Widget _fallback(String name) {
  final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
  return Container(
    decoration: BoxDecoration(
      color: AppColors.primarySoft,
      borderRadius: BorderRadius.circular(AppRadius.full),
    ),
    alignment: Alignment.center,
    child: Text(
      initial,
      style: TextStyle(
        color: AppColors.primary,
        fontWeight: FontWeight.w600,
        fontSize: _fontSize,
      ),
    ),
  );
}
```

### 7.3 Avatar with Status

```dart
// Stack with positioned indicator
Stack(
  children: [
    YugrowAvatar(size: AvatarSize.md, imageUrl: url),
    Positioned(
      right: 0, bottom: 0,
      child: Container(
        width: 12, height: 12,
        decoration: BoxDecoration(
          color: isOnline ? AppColors.success : AppColors.textDisabled,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.surface, width: 2),
        ),
      ),
    ),
  ],
)
```

### 7.4 Avatar Group (Mutual Connections)

```dart
// Overflowing avatars to show "3 mutual connections"
// Max show 3, remaining as +N badge
Row(
  children: [
    ...avatars.take(3).map((a) => YugrowAvatar(
      size: AvatarSize.sm,
      imageUrl: a,
      // Negative margin to overlap
      margin: EdgeInsets.only(right: -8),
    )),
    if (avatars.length > 3)
      Container(
        width: 32, height: 32,
        decoration: BoxDecoration(
          color: AppColors.primarySoft,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '+${avatars.length - 3}',
            style: TextStyle(fontSize: 10, color: AppColors.primary),
          ),
        ),
      ),
  ],
)
```

---

## 8. Empty States

See **[Part 9 — Empty States](docs/YUGROW-FLOW-EXPERIENCE-SYSTEM.md#part-9--empty-states)** in Flow document for complete design and copy.

### 8.1 Flutter Implementation

```dart
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image (160px height, radius-xl)
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.xl),
              child: Image.asset(
                image,
                height: 160,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            // Title
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            // Description
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null) ...[
              const SizedBox(height: AppSpacing.xl),
              YugrowButton(
                label: actionLabel!,
                variant: ButtonVariant.primary,
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

---

## 9. Motion Guidelines

### 9.1 Duration Map

| Action | Duration | Easing | Notes |
|--------|----------|--------|-------|
| Button press | 100ms | ease-out | Scale to 0.97 |
| Icon toggle | 150ms | ease-out | Check/uncheck |
| Message slide | 150ms | ease-out | New message appears |
| Connect success | 200ms | ease-out | Pulse + checkmark |
| Page transition | 200ms | ease-out | Slide or fade |
| Modal appear | 200ms | ease-out | Fade + scale |
| Check-in success | 250ms | ease-out | Ripple from button |
| List item insert | 200ms | ease-out | Slide from top/bottom |

### 9.2 Flutter Motion Wrapper

```dart
class YugrowAnimatedOpacity extends StatelessWidget {
  const YugrowAnimatedOpacity({
    super.key,
    required this.show,
    required this.child,
    this.duration = 200,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: show ? 1.0 : 0.0,
      duration: Duration(milliseconds: duration),
      curve: Curves.easeOut,
      child: child,
    );
  }
}
```

### 9.3 Connection Success Animation

```dart
// 1. Tap Connect → button shows spinner (100ms)
// 2. Request sent → button changes to "Requested ✓" (150ms)
// 3. On acceptance → card pulses green → "Connected ✓" (200ms)
// 4. Chat input appears with slide-up (200ms)

// Implementation note: Use AnimatedContainer for card pulse
// Use AnimatedSwitcher for button text transition
```

---

## 10. Workspace Switcher

### 10.1 Mobile (Bottom Sheet)

```dart
// Trigger: Tap avatar in top-right of app bar
// Opens: Modal bottom sheet (radius-2xl)
// Content:
//   - Current workspace (highlighted with checkmark)
//   - Other workspaces
//   - "Create workspace" button at bottom
// Each item shows:
//   - Avatar (32px, sm)
//   - Workspace name (text-body)
//   - Workspace type badge (text-caption)

void _showWorkspaceSwitcher(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppRadius.xxl),
      ),
    ),
    builder: (ctx) => Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 32, height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          ...workspaces.map((ws) => _WorkspaceItem(workspace: ws)),
          const SizedBox(height: AppSpacing.lg),
          YugrowButton(
            label: 'Create workspace',
            variant: ButtonVariant.outline,
            icon: LucideIcons.plus,
            onPressed: () {},
          ),
        ],
      ),
    ),
  );
}
```

### 10.2 Web (Dropdown)

```html
<!-- Top-right of sidebar -->
<div class="workspace-switcher">
  <button class="ghost" aria-haspopup="true">
    <Building2 size={16} />
    <span>Company A</span>
    <ChevronDown size={14} />
  </button>
  <!-- Dropdown: same content as mobile sheet -->
</div>
```

---

## 11. CheckIN Components

### 11.1 "I'm Here" Button

```dart
YugrowButton(
  label: "I'm here",
  variant: ButtonVariant.primary,
  size: ButtonSize.xl,
  icon: LucideIcons.mapPin,
  onPressed: _checkIn,
)
```

Full width, centered on the home screen. On press:
1. Show workspace selector bottom sheet (if first time)
2. Check-in animation (ripple from button, 250ms)
3. Transition to Live screen

### 11.2 Live Attendee List

```dart
// ListView of PersonCard widgets
// Pull-to-refresh: standard platform
// Header: Event name + attendee count
// Empty state: "You're early. The first people will appear..."
// Sort: By mutual connections (highest first)

// Flutter:
ListView.builder(
  itemCount: attendees.length,
  itemBuilder: (ctx, i) => Padding(
    padding: EdgeInsets.only(
      bottom: AppSpacing.sm,
      left: AppSpacing.screenMobile,
      right: AppSpacing.screenMobile,
    ),
    child: PersonCard(
      person: attendees[i],
      onConnect: () => _sendRequest(attendees[i].id),
    ),
  ),
)
```

### 11.3 Check-In Complete Screen

```dart
// Shown briefly after successful check-in (auto-dismiss after 1.5s):
// ┌──────────────────────┐
// │                      │
// │       ✓              │
// │   You're visible     │
// │                      │
// │   AI Expo 2028       │
// │   Chennai Trade Centre│
// │                      │
// └──────────────────────┘

// Animation: Scale up checkmark, fade in text
// Auto-navigates to Live screen
```

### 11.4 Event Card (Home Screen)

```dart
// Shown on home screen before check-in
// CardEvent with:
// - Event photo
// - Event name
// - Venue · Location
// - Date/time
// - Attendee count
// - "Check in" button
```

---

## 12. Inputs & Forms

### 12.1 Text Input Specs

| Property | Value |
|----------|-------|
| Height | 48px |
| Padding | 12px 16px |
| Border | 1px solid `color-border` |
| Radius | `radius-md` (10px) |
| Focus | 2px solid `color-border-active` |
| Error | Border turns `color-error` + error text below |
| Label | `text-label`, 4px above input |
| Placeholder | `text-secondary` at 0.6 opacity |
| Disabled | 0.4 opacity |

### 12.2 Flutter Input

```dart
TextField(
  decoration: InputDecoration(
    labelText: 'Full name',
    hintText: 'Enter your full name',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: BorderSide(color: AppColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: BorderSide(color: AppColors.borderActive, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: BorderSide(color: AppColors.error),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),
  ),
)
```

### 12.3 Form Pattern

```
┌──────────────────────────┐
│  Screen title            │
│                          │
│  Label                   │
│  ┌──────────────────────┐│
│  │ Input                ││
│  └──────────────────────┘│
│                          │
│  Label                   │
│  ┌──────────────────────┐│
│  │ Input                ││
│  └──────────────────────┘│
│                          │
│       [Save]   [Cancel]  │
└──────────────────────────┘

- Single column on mobile
- Max 2 columns on desktop (for longer forms)
- Primary action right-aligned, secondary left
- 24px between form fields
```

---

## 13. Navigation Components

### 13.1 Mobile Bottom Tab Bar

```dart
// lib/core/widgets/main_shell.dart

BottomNavigationBar(
  type: BottomNavigationBarType.fixed,
  backgroundColor: AppColors.surface,
  selectedItemColor: AppColors.primary,
  unselectedItemColor: AppColors.textSecondary,
  selectedFontSize: 12,
  unselectedFontSize: 12,
  items: const [
    BottomNavigationBarItem(icon: Icon(LucideIcons.users), label: 'Live'),
    BottomNavigationBarItem(icon: Icon(LucideIcons.link2), label: 'Connections'),
    BottomNavigationBarItem(icon: Icon(LucideIcons.messageSquare), label: 'Messages'),
    BottomNavigationBarItem(icon: Icon(LucideIcons.user), label: 'Profile'),
  ],
)
```

### 13.2 Web Sidebar

```tsx
// Sidebar component
// Collapsible: 64px (collapsed) / 224px (expanded)

const navItems = [
  { icon: Target, label: 'Dashboard', route: '/dashboard' },
  { icon: Package, label: 'Apps', route: '/apps' },
  { icon: Users, label: 'Connections', route: '/connections' },
  { icon: MessageSquare, label: 'Messages', route: '/messages' },
  { icon: Globe, label: 'Websites', route: '/sites' },
  { icon: Edit3, label: 'Content', route: '/content' },
  { icon: Radio, label: 'Broadcast', route: '/broadcast' },
];
```

---

## 14. Status & Feedback

### 14.1 Snackbar

```dart
// Success
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('Connected successfully'),
    backgroundColor: AppColors.success,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
    ),
    duration: Duration(seconds: 3),
  ),
);

// Error (persistent until dismissed)
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('Connection failed. Try again.'),
    backgroundColor: AppColors.error,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
    ),
    action: SnackBarAction(
      label: 'Dismiss',
      textColor: Colors.white,
      onPressed: () {},
    ),
    duration: Duration(seconds: 10), // Longer for errors
  ),
);
```

### 14.2 Status Chip

```dart
class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    required this.variant,
  });

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg, IconData icon) = switch (variant) {
      StatusVariant.connected => (
        AppColors.success.withOpacity(0.1),
        AppColors.success,
        LucideIcons.checkCircle,
      ),
      StatusVariant.pending => (
        AppColors.warning.withOpacity(0.1),
        AppColors.warning,
        LucideIcons.clock,
      ),
      StatusVariant.expired => (
        AppColors.textDisabled.withOpacity(0.1),
        AppColors.textSecondary,
        LucideIcons.xCircle,
      ),
      StatusVariant.active => (
        AppColors.primary.withOpacity(0.1),
        AppColors.primary,
        LucideIcons.circle,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: fg, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
```

### 14.3 Loading States

| Context | Component | Notes |
|---------|-----------|-------|
| Full page load | Centered spinner (40px, primary color) | — |
| Card content | Skeleton shimmer | Animated gradient, `opacity-skeleton` |
| Button action | Inline spinner on button | Disable interaction during load |
| Pull to refresh | Standard platform | iOS/Android native |
| List load more | Bottom spinner (24px) | Show at list end |

---

## 15. Layout Templates

### 15.1 Mobile Screen Template

```dart
// Standard screen layout
Scaffold(
  backgroundColor: AppColors.background,
  appBar: AppBar(
    backgroundColor: AppColors.surface,
    elevation: 0,
    scrolledUnderElevation: 0.5,
    title: Text('Screen Title', style: Theme.of(context).textTheme.headlineMedium),
    actions: [
      // Workspace switcher trigger (avatar)
      // Notification bell
    ],
  ),
  body: SafeArea(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMobile),
      child: // Content here
    ),
  ),
)
```

### 15.2 List Screen Template

```dart
// Standard scrollable list
Scaffold(
  body: SafeArea(
    child: Column(
      children: [
        // App bar (if not built into Scaffold)
        // Section header / filter chips (optional)
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.screenMobile,
              vertical: AppSpacing.sm,
            ),
            itemCount: items.length,
            itemBuilder: (ctx, i) => Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.sm),
              child: // Card item
            ),
          ),
        ),
      ],
    ),
  ),
)
```

### 15.3 Detail Screen Template

```dart
// Person profile, event detail, etc.
Scaffold(
  body: CustomScrollView(
    slivers: [
      // Hero section (photo or avatar, full width)
      SliverToBoxAdapter(child: _HeroSection()),
      // Content
      SliverPadding(
        padding: EdgeInsets.all(AppSpacing.lg),
        sliver: SliverList(
          delegate: SliverChildListDelegate([
            // Title, metadata
            // Description
            // Action buttons
            // Related items (mutual connections, etc.)
          ]),
        ),
      ),
    ],
  ),
)
```

---

## 16. Code References

### 16.1 File Map

| Component | Flutter | Next.js |
|-----------|---------|---------|
| Theme | `mobile/lib/core/theme/app_theme.dart` | `web/src/styles/globals.css` |
| Buttons | `mobile/lib/core/widgets/yugrow_button.dart` | `ui/src/components/button.tsx` |
| Cards | `mobile/lib/core/widgets/yugrow_card.dart` | `ui/src/components/card.tsx` |
| Person Card | `mobile/lib/core/widgets/person_card.dart` | `ui/src/components/person-card.tsx` |
| Avatar | `mobile/lib/core/widgets/yugrow_avatar.dart` | `ui/src/components/avatar.tsx` |
| Empty State | `mobile/lib/core/widgets/empty_state.dart` | `ui/src/components/empty-state.tsx` |
| Status Chip | `mobile/lib/core/widgets/status_chip.dart` | `ui/src/components/status-chip.tsx` |
| Bottom Nav | `mobile/lib/core/widgets/main_shell.dart` | N/A (sidebar) |
| Workspace Switcher | `mobile/lib/core/widgets/workspace_switcher.dart` | `ui/src/components/workspace-switcher.tsx` |
| CheckIN Home | `mobile/lib/features/checkin/home_screen.dart` | `web/src/app/checkin/page.tsx` |
| Live List | `mobile/lib/features/checkin/live_screen.dart` | `web/src/app/checkin/live/page.tsx` |
| Connection Request | `mobile/lib/features/connections/connections_screen.dart` | `web/src/app/connections/page.tsx` |
| Messages | `mobile/lib/features/messaging/message_screen.dart` | `web/src/app/messages/page.tsx` |

### 16.2 Package Dependencies

**Flutter:**
```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.1.0
  lucide_icons: ^0.1.0
  shimmer: ^3.0.0
  flutter_secure_storage: ^9.0.0
```

**Web (Next.js):**
```json
{
  "dependencies": {
    "lucide-react": "^0.300.0",
    "next": "^14.0.0",
    "react": "^18.0.0"
  },
  "devDependencies": {
    "tailwindcss": "^3.4.0",
    "@tailwindcss/typography": "^0.5.0"
  }
}
```

---

> **This kit is frozen after review. Every new component must be added here before it can be used in the product.**
>
> The Yugrow Design Kit is the single source of truth for how every component looks, behaves, and is implemented. If a developer needs to build a screen, they should be able to do it entirely from this document.
>
> *"Build it once. Build it right. Use it everywhere."*
