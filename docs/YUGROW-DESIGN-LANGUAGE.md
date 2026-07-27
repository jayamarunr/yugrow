---
Title: Yugrow Design Language
Version: 1.0
Status: Approved
Owner: Design
Last Updated: 2026-07-28
Dependencies: YUGROW-DESIGN-PRINCIPLES.md, YUGROW-FLOW-EXPERIENCE-SYSTEM.md
Related Documents: YUGROW-BRAND-LANGUAGE.md, YUGROW-MOTION-LANGUAGE.md, YUGROW-ILLUSTRATION-LANGUAGE.md
---

# Yugrow Design Language

> The single source of truth for every visual decision in the Yugrow ecosystem.
> Every product — CheckIn, CRM, Broadcast, Builder — uses exactly this language.

---

## Table of Contents

1. [Philosophy](#1-philosophy)
2. [Colour Palette](#2-colour-palette)
3. [Typography](#3-typography)
4. [Spacing System](#4-spacing-system)
5. [Radius & Elevation](#5-radius--elevation)
6. [Icon System](#6-icon-system)
7. [Button Library](#7-button-library)
8. [Card Library](#8-card-library)
9. [Input Library](#9-input-library)
10. [Avatar System](#10-avatar-system)
11. [Navigation](#11-navigation)
12. [Status & Feedback](#12-status--feedback)
13. [Layout Templates](#13-layout-templates)
14. [Implementation Map](#14-implementation-map)
15. [Design Governance](#15-design-governance)

---

## 1. Philosophy

**Warm Professional** — confidence of Stripe + humanity of Airbnb + precision of Linear.

> *"Remove more than you add. Add warmth where others add chrome."*

### Core beliefs

| Belief | What it means |
|--------|--------------|
| Relationships are the colour | Deep Emerald appears only at meaningful moments (Connected, Opportunity Found, Accepted). 90%+ of UI stays neutral. |
| People before dashboards | Profile > pipeline. Conversation > chart. Person > data point. |
| One decision per screen | Every screen has exactly one primary action. If it has more, it's a dashboard, not a screen. |
| Whitespace is part of the interface | If tempted to add info, remove something instead. Test: *"Would Apple ship this screen?"* |
| Consistency is trust | Same component = same behaviour everywhere. Same colour = same meaning everywhere. |

### Visual direction

| Attribute | Direction |
|-----------|-----------|
| Style | Ambient Depth — layered, not flat, not glass. Matte surfaces, soft gradients (2-4%), strong typography, generous whitespace. |
| Avoid | Full glassmorphism, neumorphism, overly rounded cards, bright gradients, neon, cyberpunk, stock Material Design, generic SaaS dashboard patterns. |
| Influences | Leica, Bang & Olufsen, Porsche, Muji, Aesop, Apple Hardware, Japanese Architecture, Nordic Interiors. |

---

## 2. Colour Palette

### Light mode

| Token | Hex | Usage |
|-------|-----|-------|
| **Primary** | `#0F766E` | Deep Emerald — buttons, links, active states, connection moments |
| Primary Hover | `#115E59` | Button hover states |
| Primary Soft | `#CCFBF1` | Background tints, selected states |
| **Secondary** | `#4338CA` | Warm Indigo — AI features, technology indicators |
| Secondary Soft | `#E0E7FF` | AI-related backgrounds |
| **Accent** | `#F59E0B` | Amber — opportunities, broadcasts, CTAs |
| Background | `#F8F9FB` | Page background |
| Surface | `#FFFFFF` | Card, sheet, elevated backgrounds |
| Border | `#E5E7EB` | Default borders, dividers |
| Border Hover | `#D1D5DB` | Hovered borders |
| Text Primary | `#111827` | Headings, body |
| Text Secondary | `#6B7280` | Subtle body, captions |
| Text Disabled | `#D1D5DB` | Disabled text |
| Success | `#16A34A` | Positive actions, confirmations |
| Warning | `#F59E0B` | Warnings, pending states |
| Error | `#DC2626` | Errors, destructive actions |

### Dark mode

| Token | Hex | Usage |
|-------|-----|-------|
| Background | `#0A0A0A` | Page background |
| Surface | `#1A1A1A` | Card, sheet backgrounds |
| Border | `#333333` | Default borders (no shadows in dark mode) |
| Text Primary | `#F5F5F5` | Headings, body |
| Primary | `#14B8A6` | Brighter emerald for dark mode legibility |
| Secondary | `#818CF8` | Brighter indigo for dark mode |

### Rules

- User should see Deep Emerald at most **3–5 times per session**
- Never use colour alone to convey information (accessibility)
- 4.5:1 minimum contrast ratio on all text
- Dark mode uses borders instead of shadows (Surface 1–4 = border thickness)

---

## 3. Typography

### Font family

| Context | Font | Fallback |
|---------|------|----------|
| UI (all products) | Inter | `-apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif` |
| Admin / Code | JetBrains Mono | `'Fira Code', 'Cascadia Code', monospace` |

### Type scale

| Token | Size | Weight | Line Height | Letter Spacing | Usage |
|-------|------|--------|-------------|----------------|-------|
| displayLarge | 32px | 700 | 1.2 | -0.02em | Hero headings, feature headers |
| headlineMedium | 24px | 600 | 1.3 | -0.01em | Section headers |
| titleLarge | 18px | 600 | 1.4 | 0 | Card titles, screen titles |
| bodyLarge | 16px | 400 | 1.6 | 0 | Primary body text |
| bodyMedium | 14px | 400 | 1.5 | 0 | Secondary body, descriptions |
| bodySmall | 12px | 400 | 1.4 | 0.01em | Captions, timestamps, metadata |
| labelLarge | 16px | 600 | 1 | 0 | Button text |
| labelMedium | 14px | 500 | 1 | 0.01em | Small buttons, tabs |
| labelSmall | 12px | 500 | 1.33 | 0.02em | Badges, chips |
| statLarge | 24px | 700 | 1 | 0 | Numbers, counts |
| statMedium | 16px | 600 | 1 | 0 | Secondary stats |

### Rules

- Max line length: **65ch** for body, **40ch** for titles
- Never use more than **2 font sizes per card**
- Sentence case only — never ALL CAPS or Title Case
- Font weights: 400 (Regular), 500 (Medium), 600 (SemiBold), 700 (Bold)

---

## 4. Spacing System

8-point grid. All spacing values are multiples of 4px.

| Token | Value | Usage |
|-------|-------|-------|
| space-1 | 4px | Tiny gaps, icon margins |
| space-2 | 8px | Tight spacing, chip gaps |
| space-3 | 12px | Between related elements |
| space-4 | 16px | Card padding (dense), button padding |
| space-5 | 24px | Card padding (comfortable), section gaps |
| space-6 | 32px | Screen margins (desktop), large sections |
| space-7 | 48px | Hero spacing, major section separation |
| space-8 | 64px | Page-level spacing |

### Screen margins

| Device | Margin |
|--------|--------|
| Mobile | 24px |
| Tablet | 32px |
| Desktop | 32px (auto-centered, max 1200px) |

### Touch targets

Minimum **44×44px** for all interactive elements.

### Card padding

| Density | Value |
|---------|-------|
| Dense | 16px |
| Comfortable | 24px |

---

## 5. Radius & Elevation

### Border radius

| Token | Value | Usage |
|-------|-------|-------|
| radius-sm | 6px | Chips, badges, small indicators |
| radius-md | 10px | Inputs, text fields |
| radius-lg | 12px | Cards, buttons, dialogs |
| radius-xl | 16px | Large cards, modals |
| radius-xxl | 24px | Bottom sheets, large dialogs |
| radius-full | 9999px | Avatars, pills |

### Elevation (Surface Levels)

Light mode uses shadows. Dark mode replaces shadows with borders.

| Level | Light (shadow) | Dark (border) | Usage |
|-------|---------------|---------------|-------|
| Surface 1 | `0 1px 2px rgba(0,0,0,0.05)` | 1px border | Default cards |
| Surface 2 | `0 4px 6px rgba(0,0,0,0.07)` | 1px border | Elevated cards, dropdowns |
| Surface 3 | `0 10px 15px rgba(0,0,0,0.1)` | 2px border | Modals, sheets |
| Surface 4 | `0 20px 25px rgba(0,0,0,0.15)` | 2px border | Dialogs, alerts |

---

## 6. Icon System

| Property | Value |
|----------|-------|
| Icon set | **Lucide** only — never mix icon sets |
| Style | Outline preferred. Stroke width **1.5px** fixed. |
| Sizing | Tab bar: 24px, Buttons: 16–20px, Empty states: 48px, Badges: 12px |

### Common icon mappings

| Context | Icon |
|---------|------|
| "I'm Here" | `map-pin` |
| Connect | `user-plus` |
| Send Message | `send` |
| Events | `calendar` |
| Live | `radio` |
| Network | `users` |
| Profile | `user` |
| Settings | `settings` |
| Notifications | `bell` |
| Search | `search` |
| Check-in success | `check-circle` |
| Connection accepted | `heart` |

---

## 7. Button Library

### Variants

| Variant | Style | Usage |
|---------|-------|-------|
| Primary | Filled `#0F766E`, white text | Primary actions, "I'm Here", Submit |
| Secondary | Filled `#4338CA`, white text | AI-related actions, secondary CTAs |
| Outline | 1px border, transparent bg, primary text | Connect, Cancel, secondary actions |
| Ghost | No border, no bg, primary text on hover | Tertiary actions, menu items |
| Danger | Filled `#DC2626`, white text | Destructive actions, Delete, Remove |

### Sizes

| Size | Height | Padding | Font |
|------|--------|---------|------|
| sm | 32px | 12×16px | labelMedium |
| md | 44px | 16×20px | labelLarge |
| lg | 52px | 20×24px | labelLarge |
| xl | 64px | 24×32px | labelLarge |

### States

```
default → hover (95% opacity) → pressed (90% opacity) → disabled (0.4 opacity) → loading (spinner replaces icon)
```

### Key button map

| Button | Variant | Size | Icon |
|--------|---------|------|------|
| "I'm Here" | Primary | xl, full-width | `map-pin` |
| Connect | Outline | md | `user-plus` |
| Send Message | Primary | md | `send` |
| Accept | Primary | sm | `check` |
| Decline | Ghost | sm | `x` |

---

## 8. Card Library

### Base Card
- 16px padding
- `radius-lg` (12px)
- 1px border (`#E5E7EB`)
- Surface 1 shadow

### Card types

| Type | Content | Actions |
|------|---------|---------|
| Person Card | 48px avatar, name, title, company, skills, mutual connections | Connect button |
| Event Card | 16:9 photo, name, venue, time, attendee count | "I'm Here" button |
| Connection Request Card | Person info, intent badge, context line ("Met at...") | Accept / Decline |
| Opportunity Card | Title, location, description, mutual connections | View / Apply |
| Venue Card | Photo, name, location, event count | View events |

---

## 9. Input Library

| Property | Value |
|----------|-------|
| Height | 48px |
| Padding | 12px horizontal, 16px vertical |
| Border | 1px solid `#E5E7EB` |
| Radius | `radius-md` (10px) |
| Focus ring | 2px solid Primary (20% opacity) |
| Label | Above input, `bodySmall` weight 500 |
| Helper text | Below input, `bodySmall` |
| Error | Border turns Error colour, helper text turns Error |

### Layout
- Single column on mobile
- Max 2 columns on desktop
- Labels always above (never placeholder-as-label)

---

## 10. Avatar System

| Size | Value | Usage |
|------|-------|-------|
| sm | 32px | Comments, lists |
| md | 48px | Cards, person rows |
| lg | 64px | Profile header |
| xl | 80px | Hero profile, empty states |

- All avatars `radius-full`
- Fallback: first letter on Primary Soft background
- Status indicator: 12px dot (green = active, grey = offline)
- Avatar groups: overlap by 8px, +N badge for overflow

---

## 11. Navigation

### Mobile — 4-tab Bottom Bar

| Tab | Icon | Screen |
|-----|------|--------|
| Live | `radio` | Live Discovery |
| Network | `users` | Connections |
| Messages | `message-square` | Conversations |
| Profile | `user` | Profile / Settings |

- No hamburger menus
- Max 2 levels deep from any tab
- Active tab uses Primary colour

### Web — Collapsible Sidebar

| State | Width |
|-------|-------|
| Collapsed | 64px (icons only) |
| Expanded | 224px (icons + labels) |

- 7 items: Dashboard, Apps, Connections, Messages, Websites, Content, Broadcast
- Top bar with search, notifications, profile avatar

---

## 12. Status & Feedback

### Snackbars

| Type | Duration | Style |
|------|----------|-------|
| Success | 3s | Green background, white text, check icon |
| Error | 10s (persistent) | Red background, white text, dismiss button |
| Info | 3s | Neutral background, white text |

### Status Chips

| Variant | Colour | Usage |
|---------|--------|-------|
| Connected | Green | Connection established |
| Pending | Amber | Connection request sent |
| Expired | Grey | Past events, expired presence |
| Active | Green | Currently checked in |

### Loading states

| Type | Usage |
|------|-------|
| Circular spinner | Full-page loading, action loading |
| Skeleton | Card loading (shimmer animation) |
| Inline spinner | Button loading |
| Pull-to-refresh | List refresh |

---

## 13. Layout Templates

### Mobile Screen

```
┌──────────────────┐
│   AppBar (title)  │  ← 56px
├──────────────────┤
│                   │
│   Scrollable     │  ← Main content
│   content here   │
│                   │
├──────────────────┤
│  Live  Net  Msg  │  ← Bottom nav (64px)
└──────────────────┘
```

### List Screen

```
┌──────────────────┐
│ Search bar        │  ← Sticky top
├──────────────────┤
│ Card              │
│ Card              │
│ Card              │  ← Scrollable list
│ ...               │
└──────────────────┘
```

---

## 14. Implementation Map

| Component | Flutter | Web (Next.js) |
|-----------|---------|---------------|
| Colour tokens | `lib/core/theme/colors.dart` | CSS vars in `globals.css` |
| Typography | `lib/core/theme/typography.dart` | CSS classes |
| Button | `lib/shared/widgets/yugrow_button.dart` | Tailwind classes |
| Card | `lib/shared/widgets/yugrow_card.dart` | Tailwind classes |
| Avatar | `lib/shared/widgets/yugrow_avatar.dart` | Tailwind classes |
| Input | `lib/shared/widgets/yugrow_input.dart` | Tailwind classes |
| Bottom nav | `lib/shared/widgets/bottom_nav.dart` | N/A |
| Sidebar | N/A | `ui/src/layout/sidebar.tsx` |

---

## 15. Design Governance

- All new products must reference this document before implementation
- Component additions require approval
- Changes require an RFC in `docs/design-rfcs/`
- Every PR that touches UI must verify against this language
- Violations of the Design Language are code review blockers
