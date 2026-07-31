# Yugrow Design System (YDS) — v1.0

> **Status:** Active
> **Philosophy:** Human Minimalism — Professional. Calm. Trusted. Human.
> **Last Updated:** 2026-07-30

Yugrow should feel like *"LinkedIn if Apple designed the networking experience."* Not flashy. Not trendy. Calm, trustworthy, and premium.

---

## 1. Brand Philosophy

| Attribute | Position |
|-----------|----------|
| **Style** | Human Minimalism (between Linear, Notion, Stripe Dashboard, Apple) |
| **Feeling** | Calm, not exciting. Trustworthy, not impressive. |
| **80% Grey Rule** | 80% of every screen should be neutral. Colour is reserved for meaning. |
| **AI trap** | If it looks AI-generated (gradients, shadows, icons everywhere), remove something. |

### What Yugrow is NOT
❌ Social media app | ❌ Crypto startup | ❌ AI toy | ❌ Flashy event app
❌ Neumorphism | ❌ Glassmorphism | ❌ Claymorphism | ❌ Skeuomorphism | ❌ Aurora UI

---

## 2. Brand Colour: Yugrow Emerald

### Primary Palette

| Token | Hex | Usage |
|-------|-----|-------|
| **Yugrow Emerald** | `#0F8B6D` | Primary brand — buttons, links, active states |
| **Emerald Hover** | `#0B755C` | Hover state for primary actions |
| **Emerald Light** | `#E8F8F2` | Subtle backgrounds, badges, alert backgrounds |
| **Emerald Dark** | `#065F46` | Dark mode primary, active nav, pressed states |

### Why Emerald, not Blue

Blue belongs to everyone (LinkedIn, Facebook, PayPal, Jira). Blue says "corporate software."
Emerald says **"professional networking in the real world"** — presence, trust, growth, connection.

### Semantic Colour

| Token | Hex | Meaning |
|-------|-----|---------|
| `--y-success` | `#059669` | Verified, Present, Connected, Success |
| `--y-info` | `#2563EB` | Information, Details |
| `--y-warning` | `#D97706` | Attention, Pending |
| `--y-error` | `#DC2626` | Problem, Error, Blocked |

### Neutral Palette

| Token | Hex Light | Hex Dark | Usage |
|-------|-----------|----------|-------|
| `--y-bg` | `#FAFAFA` | `#0F172A` | Page background |
| `--y-surface` | `#FFFFFF` | `#1E293B` | Card, sidebar |
| `--y-surface-elevated` | `#FFFFFF` | `#334155` | Modal, dropdown |
| `--y-text-primary` | `#0F172A` | `#F1F5F9` | Primary text |
| `--y-text-secondary` | `#475569` | `#94A3B8` | Secondary text |
| `--y-text-disabled` | `#94A3B8` | `#64748B` | Disabled text |
| `--y-border` | `#E2E8F0` | `#334155` | Borders, dividers |
| `--y-border-hover` | `#CBD5E1` | `#475569` | Hover border |

### Product Accent Strategy

**The brand never changes.** Emerald is always the primary colour. Products do not get their own colour schemes.

Products may use **micro-accents** — subtle shifts (≤5% of UI) for differentiation. Not different UIs.

| Product | Primary | Micro-Accent |
|---------|---------|--------------|
| Yugrow Platform | Emerald | Slate (neutral) |
| Yugrow Events | Emerald | Warm gold (5% of touches) |
| Yugrow CRM | Emerald | Indigo (5%) |
| Yugrow Broadcast | Emerald | Orange (5%) |
| Yugrow Discovery | Emerald | Cyan (5%) |
| Yugrow Finance | Emerald | Teal (5%) |

**Rule:** If you removed the accent colour, the product should still look like Yugrow. Emerald defines the ecosystem. Accents are barely noticeable — they prevent boredom, not create identity.

---

## 3. Typography

| Token | Size | Weight | Usage |
|-------|------|--------|-------|
| **Hero** | 48px / 3rem | 700 | Landing page hero |
| **Heading 1** | 32px / 2rem | 700 | Page title |
| **Heading 2** | 24px / 1.5rem | 600 | Section heading |
| **Heading 3** | 20px / 1.25rem | 600 | Card title |
| **Body** | 16px / 1rem | 400 | Paragraphs, labels |
| **Body Small** | 14px / 0.875rem | 400 | Secondary text |
| **Caption** | 12px / 0.75rem | 500 | Metadata, timestamps |

**Font:** Inter. One font. Nothing else.
**Weights used:** 400, 500, 600, 700. Nothing else.
**Line height:** 1.5 (body), 1.2 (headings).

---

## 4. Spacing (8pt Grid)

```
4px    →  --space-1
8px    →  --space-2
16px   →  --space-3
24px   →  --space-4
32px   →  --space-5
48px   →  --space-6
64px   →  --space-7
```

**Rule:** Never use random spacing. Every gap, padding, and margin must be one of these values.

---

## 5. Border Radius

| Token | Value | Usage |
|-------|-------|-------|
| `--radius-sm` | 8px | Chips, tags |
| `--radius-md` | 12px | Inputs |
| `--radius-lg` | 16px | Cards, dialogs |
| `--radius-xl` | 20px | Modals, sheets |
| `--radius-full` | 9999px | Pills, avatars |

**Rule:** Never use arbitrary radius values. Choose from this scale.

---

## 6. Elevation / Shadows

Very subtle. Never floating glass.

```css
/* Card */
box-shadow: 0 1px 3px rgba(0,0,0,0.06), 0 1px 2px rgba(0,0,0,0.04);

/* Elevated (modal, dropdown) */
box-shadow: 0 4px 12px rgba(0,0,0,0.05), 0 2px 4px rgba(0,0,0,0.04);

/* Dialog */
box-shadow: 0 20px 60px rgba(0,0,0,0.08), 0 8px 20px rgba(0,0,0,0.06);
```

---

## 7. Iconography

**Single consistent set:** Use only one icon family per platform.

| Platform | Icon Set |
|----------|----------|
| Web | Lucide (consistent with `@ui` package) |
| Mobile | `flutter_lucide` (already used) |

**Rule:** Never mix Heroicons, FontAwesome, Material, and Lucide in the same product.

---

## 8. Motion

| Property | Value |
|----------|-------|
| Duration | 250–300ms |
| Easing | `cubic-bezier(0.4, 0, 0.2, 1)` |
| Transitions | opacity + transform only |
| Hover | opacity 0.9, no scale/rotate |

**Rule:** Human apps move. AI apps animate. Every transition should feel like a single consistent system, not a collection of effects.

---

## 9. Components

### Primary Button
- Emerald filled (`--y-brand-primary` background)
- White text
- 14px radius
- 16px horizontal padding, 12px vertical
- Font weight 600
- Hover: `--y-brand-primary` at 90% opacity

### Secondary Button
- White background
- 1.5px `--y-border` border
- `--y-text-primary` text
- Same sizing as primary

### Cards
- White (`--y-surface`)
- 16px radius (`--radius-lg`)
- Subtle shadow
- 24px padding (`--space-4`)

### Form Inputs
- 12px radius (`--radius-md`)
- 1px `--y-border` border
- 16px horizontal padding, 12px vertical
- Focus: 2px `--y-brand-primary` ring

### Status Chips

| Chip | Colour | Meaning |
|------|--------|---------|
| 🟢 Official | Emerald | Verified, Official |
| 🔵 Info | Blue | Information |
| 🟠 Attention | Orange | Warning, Pending |
| 🔴 Issue | Red | Error, Blocked |
| ⚪ Draft | Grey | Inactive, Draft |

---

## 10. Event Identity Visual Treatment

| Type | Badge | Icon | Colour | Host Label |
|------|-------|------|--------|------------|
| **Official** | ✓ OFFICIAL | 🏢 | Emerald | Hosted by [Organisation] |
| **Community** | COMMUNITY | 👥 | Slate | Hosted by [Name] |
| **Networking** | NETWORKING | 📍 | Neutral | Hosted by [Name] |
| **Private** | PRIVATE | 🔒 | Charcoal | Hosted by [Name] |

**Design rule:** Never use colour alone. Combine badge + icon + host identity for accessibility.

---

## 11. Empty States

Instead of "No events found":

```
You're ready.

Create your first networking event.
[Create Event]
```

Every empty state must include:
1. A brief, positive message
2. A clear next action
3. An illustration or icon (from Illustration Language)

---

## 12. Loading States

Use skeleton screens, not spinners.

```css
/* Skeleton animation */
@keyframes shimmer {
  0% { background-position: -200px 0; }
  100% { background-position: calc(200px + 100%) 0; }
}

.skeleton {
  background: linear-gradient(90deg, var(--y-surface) 25%, var(--y-border) 50%, var(--y-surface) 75%);
  background-size: 200px 100%;
  animation: shimmer 1.5s infinite;
  border-radius: var(--radius-sm);
}
```

---

## 13. Do's & Don'ts

| ✅ Do | ❌ Don't |
|-------|----------|
| Use Emerald as primary brand colour | Use random gradients |
| Use semantic colour (green=success only) | Use colour for decoration |
| Use one icon set consistently | Mix Heroicons + Lucide + FontAwesome |
| Use 8pt spacing grid | Use arbitrary spacing values |
| Use Inter everywhere | Use multiple fonts |
| Use radius from the scale | Use arbitrary radius values |
| Use very subtle shadows | Use floating glass effects |
| Use skeleton loading | Use spinning loaders |
| Use 250-300ms consistent motion | Use random animation durations |
| Reserve green for meaning (OFFICIAL, Present) | Make everything green |
| Use human labels ("I'm Here" over "Check In") | Use technical labels |
| Keep 80% of screen neutral | Add colour, shadows, icons to everything |

---

## 14. How to Use YDS

1. **Before building a screen**, read YDS sections relevant to that component.
2. **After building**, run the Design Review Checklist (below).
3. **If something isn't in YDS**, default to the closest existing pattern. Do not invent.
4. **To add to YDS**, propose the addition with rationale and examples.

### Design Review Checklist

Every screen must pass:

- [ ] Visual hierarchy — "What is most important?" answered in 1s
- [ ] Spacing follows 8pt grid
- [ ] All radius values from scale
- [ ] Typography uses Inter, weights from scale
- [ ] Colours from palette — no invented colours
- [ ] Icons from chosen set — no mixing
- [ ] Empty state has message + action
- [ ] Loading uses skeleton, not spinner
- [ ] Motion is 250-300ms consistent
- [ ] No gradients unless explicitly specified
- [ ] No floating shadows
- [ ] 80% neutral, colour only for meaning
- [ ] Accessible contrast ratios maintained
- [ ] Host identity visible on event cards
