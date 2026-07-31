---
Title: Yugrow Flow — Experience System
Version: 2.0
Status: Approved
Owner: Founder / CPO
Last Updated: 2026-07-22
Dependencies:
  - PLATFORM-CONSTITUTION.md
  - Volume-1-Product/PRODUCT-STRATEGY-BIBLE.md
  - DECISIONS.md
Related Documents:
  - Volume-2-Architecture/ENGINEERING-BLUEPRINT.md
  - Volume-2-Architecture/BUSINESS-OBJECT-BIBLE.md
---

# Yugrow Flow — Experience System v2.0

> **This document is frozen after review. Every Flutter screen and every Next.js page must follow it.**
>
> Google has Material. IBM has Carbon. Microsoft has Fluent.
> Yugrow has **Flow** — because everything we build is about flow: relationship flow, opportunity flow, business flow, presence flow.

---

## Table of Contents

1. [Brand Philosophy](#part-1--brand-philosophy)
2. [Experience Principles](#part-2--experience-principles)
3. [Visual Identity](#part-3--visual-identity)
4. [Typography](#part-4--typography)
5. [Spacing System](#part-5--spacing-system)
6. [Experience Tokens](#part-6--experience-tokens)
7. [Icons](#part-7--icons)
8. [Photography & Imagery](#part-8--photography--imagery)
9. [Empty States](#part-9--empty-states)
10. [Sound & Haptics](#part-10--sound--haptics)
11. [Component Library](#part-11--component-library)
12. [Mobile Navigation](#part-12--mobile-navigation)
13. [Web Navigation](#part-13--web-navigation)
14. [Motion](#part-14--motion)
15. [Accessibility](#part-15--accessibility)
16. [Product-Specific Patterns](#part-16--product-specific-patterns)
17. [Flutter Implementation](#part-17--flutter-implementation)
18. [Next.js Implementation](#part-18--nextjs-implementation)
19. [Design Governance](#part-19--design-governance)

---

## Part 1 — Brand Philosophy

### Why Yugrow Exists

Yugrow exists to make business relationships effortless. Not to manage contacts, not to track deals—to help professionals discover, connect, and grow with each other.

### Design Philosophy: Warm Professional

Confidence of Stripe + humanity of Airbnb + precision of Linear. Not cold, not casual — **warm professional**.

Yugrow's UI never screams. It whispers. The goal is for someone to see a screenshot—without a logo—and know it's Yugrow.

**Influences:** Our influences are not SaaS companies. They are masters of material, light, space, and proportion.

| Influence | What We Learn |
|-----------|--------------|
| **Leica** | Every element has a purpose. Nothing unnecessary. |
| **Bang & Olufsen** | Premium materials speak for themselves. Touch, sound, presence. |
| **Porsche** | Function determines form. Performance is beauty. |
| **Muji** | Emptiness is not absence — it's potential. |
| **Aesop** | Typography + space + restraint = unmistakable identity. |
| **Apple Hardware** | The seam between materials is the most important detail. |
| **Japanese Architecture** | Light moves through space. Transitions are experiences. |
| **Nordic Interiors** | Warmth through texture, not decoration. |

Not copied — distilled.

### One-Line Philosophy

> **"Remove more than you add. Add warmth where others add chrome."**

### Relationships Are the Color

Most of Yugrow is neutral. Color is reserved for relationships — the moments when people connect.

Deep Emerald appears only when something meaningful happens:

| Moment | Why Emerald |
|--------|-------------|
| **Connected** ✓ | A new relationship formed |
| **Opportunity Found** | A meaningful match discovered |
| **Broadcast Match** | The right opportunity reached the right person |
| **Accepted** | Someone said yes |

Between these moments, the UI stays quiet. The color earns its meaning through scarcity.

> **"When the screen turns green, something good just happened."**

### Design Around People, Not Data

Most business software says:

```
Revenue · Charts · Pipeline · Tasks
```

Yugrow says:

```
Raj · Founder · Met 2 hours ago · 3 mutual connections · Say Hello
```

**People are the primary interface.** Profiles, conversations, and relationships come before dashboards, analytics, and reports. When a user opens Yugrow, they should see people before they see data.

### Emotional Response

When someone uses Yugrow, they should feel:

| Feeling | How It Manifests |
|---------|-----------------|
| **Warm Professional** | Not cold SaaS — approachable but not casual. Confidence with humanity |
| **Premium** | Restrained design, deliberate whitespace, nothing flashy |
| **Trustworthy** | Consistent interactions, predictable patterns, transparent AI |
| **Human** | Conversational copy, approachable microcopy, generous spacing |
| **Modern** | Minimal chrome, smooth motion, excellent typography |
| **Effortless** | One primary action per screen, nothing unnecessary |

### Keywords (Always)

Warm · Professional · Premium · Trustworthy · Modern · Restrained · Human · Intentional · People-first

### Keywords (Never)

Corporate · Sales-heavy · Social-media clutter · Gamification · Noisy · Dense · Neon · Cold · Robotic · Charts-first · Dashboard-spam

### What We Avoid

| Style | Why |
|-------|-----|
| ❌ Full Glassmorphism | Already feels dated — thousands of AI-generated UIs use it |
| ❌ Neumorphism | Impractical, low contrast |
| ❌ Overly rounded "AI startup" cards | Generic, lacks identity |
| ❌ Bright gradients everywhere | Screams for attention |
| ❌ Neon cyberpunk | Wrong tone for business relationships |
| ❌ Apple clone | No identity |
| ❌ Material Design out of the box | Generic, no differentiation |
| ❌ SaaS dashboards with charts | People first, data second |

### Visual Style: Ambient Depth

Not flat, not glass — **layered**.

```
Background (#F8F9FB)
  └─ Surface 1 (barely elevated)
      └─ Thin border (#E5E7EB, 1px)
          └─ Surface 2 (white card)
              └─ Rich spacing
                  └─ Excellent typography
```

Depth comes from layers, not transparency. Matte surfaces. Soft gradients (2–4% tint, imperceptible). Strong typography. Lots of whitespace. Subtle surface separation. Elegant motion — fast, almost invisible.

### Core Message

> **"Business relationships made effortless."**

Every screen, every notification, every interaction should reinforce this.

---

## Part 2 — Experience Principles

### Every Screen Answers One Question

This is the hardest UX discipline: every screen should answer exactly one question for the user.

| Screen | The Question It Answers |
|--------|------------------------|
| **Home** | Who can I meet? |
| **Live Discovery** | Who is here right now? |
| **Broadcast** | Which opportunities matter to me? |
| **CRM** | Who needs my attention? |
| **Messages** | What did they say? |
| **Website Editor** | What am I publishing? |
| **Profile** | Who am I representing? |
| **Connections** | Who do I know? |
| **Finance** | What needs approval? |
| **HR** | Who is available? |

If a screen cannot answer its question in one sentence, redesign it. If a screen answers two questions, split it.

### 10 Non-Negotiable UX Principles

#### P1. One Primary Action Per Screen

Every screen has exactly one thing the user should do. Everything else is secondary or hidden.

**CheckIN home:** "I'm Here" is the button. Not "Events," "Profile," "Settings."
**Live discovery:** "Connect" is the action. Not "Message," "Save," "Share."
**Connected state:** "Say Hello" is the next step. Not "Add to CRM," "Schedule Meeting."

#### P2. Reduce Cognitive Load

If a user has to think about what to do next, the design failed. Surface the next logical action. Hide everything else behind progressive disclosure.

#### P3. Context Before Navigation

The app should know where the user is before asking what they want. If they're at an event, show the event. If they just connected with someone, show the conversation.

#### P4. Relationships Before Transactions

People first, business second. The profile comes before the deal. The conversation comes before the invoice. Trust comes before the transaction.

#### P5. Presence Before Discovery

A user must be visible before they can discover others. The "I'm Here" action precedes everything else. Presence is the gateway to the network.

#### P6. Speed Over Decoration

Performance is a feature. Fast load times, instant transitions, optimistic updates. Animation should communicate state, never decorate. If it doesn't make the experience faster or clearer, remove it.

#### P7. Trust Over Engagement

Yugrow optimizes for meaningful connections, not time spent. If a user achieves their goal in 30 seconds and closes the app, that's success. No engagement tricks, no notification spam, no "streaks."

#### P8. AI Should Assist, Never Interrupt

AI features suggest, recommend, and summarize—they never act without confirmation. No auto-sends, no auto-posts, no invisible decisions. Every AI action must be explainable.

#### P9. Consistency Across Web and Flutter

The same component renders the same way on mobile and desktop. Same colors, same spacing, same motion, same naming. One design system, two implementations.

#### P10. Accessibility by Default

Not a checklist at the end. Every component is built with accessibility from the first line of code. Minimum WCAG 2.1 AA.

---

## Part 3 — Visual Identity

### 3.1 Color Philosophy

**Relationships are the color.** Most of Yugrow is neutral. Color is emotional currency — spent only when something meaningful happens.

- **Deep Emerald** = relationships, connection, growth, trust. Appears only at meaningful moments: Connected, Accepted, Opportunity Found, Broadcast Match.
- **Warm Indigo** = AI, technology, innovation (secondary). Used for AI suggestions and recommendations.
- **Amber** = opportunities, broadcasts, active states (accent). Attention-grabbing but rare.
- **Neutrals** = clarity, professionalism, minimalism (canvas). 90%+ of the UI.

> **A user should see Deep Emerald at most 3-5 times per session. That scarcity is what makes it powerful.**

### 3.2 Color Palette — Mostly Neutral

Yugrow is mostly neutral. Color is used sparingly so every important action stands out. The majority of the screen is background, cards, borders, and text — all neutral.

#### Neutrals (90% of the UI)

| Token | Light | Dark | Usage |
|-------|-------|------|-------|
| `color-bg` | `#F8F9FB` | `#0A0A0A` | Page background — very subtle warmth |
| `color-surface` | `#FFFFFF` | `#1A1A1A` | Cards, modals, sheets |
| `color-surface-elevated` | `#F3F4F6` | `#262626` | Hover states, pressed states |
| `color-border` | `#E5E7EB` | `#333333` | Card borders, dividers |
| `color-border-active` | `#0F766E` | `#14B8A6` | Focus rings, active borders |
| `color-text-primary` | `#111827` | `#F5F5F5` | Primary text |
| `color-text-secondary` | `#6B7280` | `#A3A3A3` | Secondary text, captions |
| `color-text-disabled` | `#D1D5DB` | `#525252` | Disabled text |
| `color-text-inverse` | `#FFFFFF` | `#111827` | Text on primary backgrounds |

#### Primary — Deep Emerald (Growth & Trust)

The single accent color. Used for primary actions — nothing else gets this color.

| Token | Light | Dark | Usage |
|-------|-------|------|-------|
| `color-primary` | `#0F766E` | `#14B8A6` | Primary buttons, links, active states ONLY |
| `color-primary-hover` | `#115E59` | `#2DD4BF` | Button hover |
| `color-primary-soft` | `#CCFBF1` | `#134E4A` | Soft backgrounds, badges |

#### Secondary — Soft Indigo (AI & Technology)

| Token | Light | Dark | Usage |
|-------|-------|------|-------|
| `color-secondary` | `#4338CA` | `#818CF8` | AI features, recommended content |
| `color-secondary-soft` | `#E0E7FF` | `#1E1B4B` | AI suggestion backgrounds |

#### Semantic Colors

| Token | Light | Dark | Usage |
|-------|-------|------|-------|
| `color-success` | `#16A34A` | `#4ADE80` | Connected, completed, verified |
| `color-warning` | `#F59E0B` | `#FBBF24` | Expiring soon, attention needed |
| `color-error` | `#DC2626` | `#F87171` | Errors, declined, blocked |

#### Gradients

Very subtle. Not purple→blue. Backgrounds with a 2–4% tint shift. Users shouldn't notice the gradient — they should notice the atmosphere.

---

## Part 4 — Typography

Typography carries approximately 40% of the perceived quality of the product. It must be treated with the same precision as a print publication.

### 4.1 Font Family

**Inter** — primary font for all UI (both Flutter and Web). Available via Google Fonts. Variable weight axis supported.

**JetBrains Mono** — code blocks and technical data (admin panels only).

**Fallback:** system-ui, -apple-system, sans-serif

### 4.2 Type Scale

#### Display

| Token | Size | Weight | Line Height | Letter Spacing | Case | Usage |
|-------|------|--------|-------------|----------------|------|-------|
| `text-display` | 32px / 2rem | Bold (700) | 1.2 | -0.02em | Sentence | Hero screens, welcome, feature headers |

#### Heading

| Token | Size | Weight | Line Height | Letter Spacing | Case | Usage |
|-------|------|--------|-------------|----------------|------|-------|
| `text-heading` | 24px / 1.5rem | Semibold (600) | 1.3 | -0.01em | Sentence | Screen titles, page headers |

#### Title

| Token | Size | Weight | Line Height | Letter Spacing | Case | Usage |
|-------|------|--------|-------------|----------------|------|-------|
| `text-title` | 18px / 1.125rem | Semibold (600) | 1.4 | 0 | Sentence | Card titles, section headers |

#### Body

| Token | Size | Weight | Line Height | Letter Spacing | Case | Usage |
|-------|------|--------|-------------|----------------|------|-------|
| `text-body` | 16px / 1rem | Regular (400) | 1.6 | 0 | Sentence | Primary reading text |
| `text-body-small` | 14px / 0.875rem | Regular (400) | 1.5 | 0 | Sentence | Secondary text, descriptions |

#### Caption

| Token | Size | Weight | Line Height | Letter Spacing | Case | Usage |
|-------|------|--------|-------------|----------------|------|-------|
| `text-caption` | 12px / 0.75rem | Regular (400) | 1.4 | 0.01em | Sentence | Labels, timestamps, metadata |

#### Label

| Token | Size | Weight | Line Height | Letter Spacing | Case | Usage |
|-------|------|--------|-------------|----------------|------|-------|
| `text-label` | 12px / 0.75rem | Medium (500) | 1.33 | 0.02em | Uppercase | Form labels, badge text, section headers |

#### Button

| Token | Size | Weight | Line Height | Letter Spacing | Case | Usage |
|-------|------|--------|-------------|----------------|------|-------|
| `text-button` | 16px / 1rem | Semibold (600) | 1 | 0 | Sentence | Primary button labels |
| `text-button-small` | 14px / 0.875rem | Medium (500) | 1 | 0.01em | Sentence | Small buttons, chips |

#### Number / Stat

| Token | Size | Weight | Line Height | Letter Spacing | Case | Usage |
|-------|------|--------|-------------|----------------|------|-------|
| `text-stat` | 24px / 1.5rem | Bold (700) | 1 | -0.03em | Tabular | Metrics, counts, stats |
| `text-stat-small` | 16px / 1rem | Semibold (600) | 1 | -0.02em | Tabular | Small stats, badges |

#### Tables (Web Admin)

| Token | Size | Weight | Line Height | Letter Spacing | Case | Usage |
|-------|------|--------|-------------|----------------|------|-------|
| `text-table-header` | 12px / 0.75rem | Semibold (600) | 1.2 | 0.03em | Uppercase | Column headers |
| `text-table-cell` | 14px / 0.875rem | Regular (400) | 1.4 | 0 | Sentence | Table body cells |

### 4.3 Typography Rules

- **Max line length:** Body text never exceeds 65 characters per line. Titles and headings: 40 characters max.
- **Paragraph spacing:** 1em between paragraphs. No extra space after last element.
- **Character spacing:** Default 0 for body. Negative for display/headings (tighten). Positive for labels (widen).
- **Case:** Headings and body text use sentence case. Labels use uppercase (sparingly). Never use Title Case.
- **Hierarchy:** Never use more than 2 font sizes on a single card. The user should immediately know what to read first.
- **Rag:** Left-aligned text should have a clean rag. Avoid single words on the last line (orphans).
- **Fluid:** On mobile, all sizes scale down by 1px except body and caption, which remain fixed.

---

## Part 5 — Spacing System

### 5.1 8-Point Grid

All spacing is based on multiples of 4 (for fine-tuning) and 8 (for layout).

| Token | Pixels | Usage |
|-------|--------|-------|
| `space-1` | 4px | Icon padding, tight spacing |
| `space-2` | 8px | Between related elements |
| `space-3` | 12px | Between label and input |
| `space-4` | 16px | Card padding, between sections |
| `space-5` | 24px | Between major sections |
| `space-6` | 32px | Screen margins, hero spacing |
| `space-7` | 48px | Large section separation |
| `space-8` | 64px | Page-level spacing |

### 5.2 Layout Rules

- Screen margins: 24px on mobile, 32px on desktop
- Card padding: 16px (dense), 24px (comfortable)
- List spacing between items: 8px
- Between independent sections: 32px
- Maximum content width on desktop: 480px (mobile-first even on desktop)
- Touch targets: minimum 44x44px

---

## Part 6 — Experience Tokens

Experience Tokens encompass all the sensory dimensions of the product: spacing, motion, typography, colors, sound, haptics, and elevation. They are called *Experience* Tokens because they define how Yugrow feels, not just how it looks.

### 6.1 Border Radius

Premium, not playful. Not everything has 30px rounded corners.

| Token | Value | Usage |
|-------|-------|-------|
| `radius-sm` | 6px | Small chips, inputs |
| `radius-md` | 10px | Input fields |
| `radius-lg` | 12px | Cards, dialogs, buttons |
| `radius-xl` | 16px | Cards with media, person cards |
| `radius-2xl` | 24px | Bottom sheets, modals |
| `radius-full` | 9999px | Avatars, pills, badges |

### 6.2 Surface Levels

Think in layers, not shadows. Surfaces sit at different heights in the interface. Each level defines its own shadow, but the mental model is elevation, not decoration.

| Token | Shadow | Usage |
|-------|--------|-------|
| `surface-flat` | none | Page background, non-interactive areas |
| `surface-1` | `0 1px 2px rgba(0,0,0,0.05)` | Card resting state, list items |
| `surface-2` | `0 4px 6px rgba(0,0,0,0.07)` | Cards hover state, bottom navigation |
| `surface-3` | `0 10px 15px rgba(0,0,0,0.1)` | Modals, dialogs, pickers |
| `surface-4` | `0 20px 25px rgba(0,0,0,0.15)` | Bottom sheets, full-screen modals |

**Dark mode:** No shadows. Use border luminance to separate surfaces instead.

| Token | Dark Border | Usage |
|-------|-------------|-------|
| `surface-flat` | `#0A0A0A` | Background |
| `surface-1` | `#1A1A1A` + `1px #262626` | Cards, list items |
| `surface-2` | `#262626` | Surface-2 without border |
| `surface-3` | `#333333` | Modals |
| `surface-4` | `#404040` | Bottom sheets |

### 6.3 Animation

| Token | Duration | Easing |
|-------|----------|--------|
| `motion-instant` | 100ms | ease-out |
| `motion-fast` | 150ms | ease-out |
| `motion-normal` | 200ms | ease-out |
| `motion-slow` | 250ms | ease-in-out |

> **All animations complete in 250ms or less.** Speed before flourish. Linear's animations feel amazing because they're almost invisible.

### 6.4 Opacity

| Token | Value | Usage |
|-------|-------|-------|
| `opacity-disabled` | 0.4 | Disabled states |
| `opacity-hint` | 0.6 | Placeholder text, hints |
| `opacity-overlay` | 0.5 | Modal backdrops |
| `opacity-skeleton` | 0.1 | Loading skeletons |

---

## Part 7 — Icons

### 7.1 Chosen Set

**Lucide** — one set, never mixed.

### 7.2 Rules

- Use only Lucide icons. Never mix with Phosphor, FontAwesome, or any other set.
- Prefer outline variants over filled. Filled icons used only for active tab bar states.
- Stroke width: 1.5px (Lucide default). Never change.
- Icon size follows text: 16px (caption/label), 20px (body/button), 24px (title/heading).
- Always pair icons with text labels (exception: tab bar icons may stand alone).
- Never use animated icons (spinning, pulsing, changing).
- Icon color inherits from text color of the container.

### 7.3 Common Icons

| Context | Icon | Note |
|---------|------|------|
| Home / Live | `users` | — |
| Connections | `link-2` or `handshake` | — |
| Messages | `message-square` | — |
| Profile | `user` | — |
| Check In | `map-pin` | "I'm Here" |
| Connect | `user-plus` | — |
| Connected | `check-circle` | Filled variant, Deep Emerald |
| Broadcast | `radio` | — |
| Search | `search` | — |
| Settings | `settings` | — |
| Add | `plus` | — |
| Close | `x` | — |
| Back | `chevron-left` | — |
| More | `more-horizontal` | — |
| Workspace | `building-2` | — |
| Event | `calendar` | — |
| Venue | `map-pin` | — |
| Notification | `bell` | — |

---

## Part 8 — Photography & Imagery

### 8.1 Philosophy

Yugrow is about people. Therefore the imagery is about people.

**No generic illustrations.** No abstract geometric patterns. No blob shapes. No isometric 3D renders of office buildings.

**Real human interactions.** Professional portraits. Business environments. Conferences. Coffee meetings. Factories. Offices. Trade expos. Workshops. Handshakes. Conversations.

### 8.2 Photography Style

| Attribute | Standard |
|-----------|----------|
| **Subjects** | Real professionals in real environments |
| **Lighting** | Natural light preferred. Warm tones. |
| **Composition** | Candid over posed. Context matters — show the environment. |
| **Color grade** | Desaturated slightly. Warm tint. Not Instagram-filtered. |
| **Diversity** | Must reflect real business world diversity — roles, industries, regions. |
| **No stock clichés** | No staged boardroom laughs. No chin-stroking thinkers. No arrow-up graphs. |

### 8.3 Where Photography Appears

| Location | Usage |
|----------|-------|
| **Onboarding** | Full-bleed hero images showing business interactions |
| **Empty states** | Warm, contextual photography (see Part 9) |
| **Event cards** | Venue/event photography |
| **Profile** | Avatar photos, not illustrations |
| **Marketing site** | Real team photos, real customer stories |
| **App store screenshots** | Show the app in context — a hand holding the phone at a conference |

### 8.4 What We Never Use

- ❌ Abstract gradients as hero imagery
- ❌ 3D isometric illustrations
- ❌ Blob shapes or organic abstract forms
- ❌ Stock photos of people laughing at salad
- ❌ Generic "team collaboration" illustrations
- ❌ AI-generated impossible architecture

---

## Part 9 — Empty States

Empty states are not afterthoughts. They are the user's first experience with every screen. They must be delightful, contextual, and encouraging.

### 9.1 Structure

Every empty state follows this structure:

```
┌──────────────────────────────┐
│                              │
│       [Contextual Image]     │
│                              │
│    You're early.             │
│                              │
│    The first people will     │
│    appear as they check in.  │
│                              │
│         [Action Button]      │
│                              │
└──────────────────────────────┘
```

### 9.2 Empty States by Screen

| Screen | Image | Title | Description | Action |
|--------|-------|-------|-------------|--------|
| **Live** (no attendees) | Beautiful photo of an empty conference hall with morning light | You're early. | The first people will appear as they check in. | Be the first to check in |
| **Live** (no check-in) | Professional holding phone at event entrance | Not checked in yet. | Check in at an event to see who's here. | Check in now |
| **Connections** | Two professionals shaking hands at a cafe | No connections yet. | Your network starts with a single connection. | Find people to meet |
| **Messages** | Person smiling at their phone | No conversations. | Say hello to a connection and start the conversation. | View connections |
| **Events** | Calendar with a conference pin | No events yet. | Events near you will appear here. | Create an event |
| **Broadcast** | Person speaking at a podium | No broadcasts yet. | Share an opportunity with the right people. | Create broadcast |
| **Profile** (empty) | Person at a desk with notebook | Complete your profile. | Help others know who you are. | Complete profile |

### 9.3 Image Guidelines

- Use the photography style defined in Part 8
- Images should feel aspirational, not empty/depressing
- Warm lighting preferred
- Avoid generic "empty box" illustrations
- Dark mode: lower brightness on images (0.7 opacity overlay)

### 9.4 Emotional Principle

The empty state should make the user feel:

> **"Something good is about to happen."**

Not:
> "This is empty and sad."

---

## Part 10 — Sound & Haptics

You may laugh. Users will remember.

Sound and haptics are not decorations — they are feedback channels that make interactions feel complete. Used sparingly, they create moments of delight that users subconsciously associate with the product.

### 10.1 When Sound Plays

| Moment | Sound | Haptic | Rationale |
|--------|-------|--------|-----------|
| **Connected** ✓ | Single soft chime (C major, 200ms) | Light tap | The most important moment — deserves sensory feedback |
| **Check-in success** | Quick ascending tone (150ms) | Light tap | Confirmation that presence is live |
| **Message received** | None (notification sound from OS) | Subtle thud | Avoid alert fatigue |
| **Broadcast sent** | Whoosh (250ms) | Medium tap | Confirmation of distribution |
| **Error** | None | Error buzz | Standard OS error feedback |

### 10.2 Sound Design Principles

- **All sounds under 250ms.** Instant feedback, not musical loops.
- **Use system haptics where possible** (`HapticFeedbackType.lightImpact` on iOS, `VibrationEffect` on Android).
- **Never require sound** for critical feedback. Sound is enhancement, not necessity.
- **Respect system settings:** Silent mode = no sounds. Reduce motion = no haptics.
- **No notification spam.** Only the moments above trigger sound. Not new followers, not likes, not system alerts.

### 10.3 Implementation

```dart
// Flutter — Haptic feedback for connection
HapticFeedback.lightImpact();
```

```dart
// Flutter — Sound playback (minimal, 200ms audio files)
final player = AudioPlayer();
await player.setSourceAsset('sounds/connected_chime.mp3');
await player.play();
```

### 10.4 Future

As Yugrow grows, sound may expand to:
- Workspace switch (subtle ambient shift)
- Broadcast match found
- Opportunity accepted
- Video call connect tone (Phase 3+)

Every new sound must be approved through the same process as a new component.

---

## Part 11 — Component Library

### 11.1 Buttons

| Variant | Background | Text | Border | Usage |
|---------|-----------|------|--------|-------|
| `primary` | `color-primary` | White | None | Primary action on screen |
| `secondary` | `color-secondary` | White | None | AI actions, recommendations |
| `outline` | Transparent | `color-text-primary` | `color-border` | Alternative actions |
| `ghost` | Transparent | `color-text-secondary` | None | Tertiary actions |
| `danger` | `color-error` | White | None | Destructive actions |

**States:** default, hover (95% opacity), pressed (90% opacity), disabled (opacity-disabled), loading (show spinner, disable interaction).

**Sizes:** `sm` (32px height), `md` (44px height), `lg` (52px height), `xl` (64px height for "I'm Here").

### 11.2 Inputs

- Height: 48px default
- Border: 1px `color-border`
- Focus: 2px `color-border-active` ring
- Error: red border + error text below
- Label: above input, `text-caption` weight
- Placeholder: `color-text-secondary` at `opacity-hint`
- Disabled: `opacity-disabled`

### 11.3 Cards

| Component | Padding | Radius | Elevation | Usage |
|-----------|---------|--------|-----------|-------|
| `Card` | 16px | `radius-md` | `elevation-sm` | Generic content |
| `CardPerson` | 16px | `radius-md` | `elevation-sm` | Attendee, profile preview |
| `CardConnection` | 16px | `radius-md` | `elevation-sm` | Connection request |
| `CardEvent` | 20px | `radius-md` | `elevation-sm` | Event card |
| `CardVenue` | 16px | `radius-md` | `elevation-sm` | Venue card |
| `CardBroadcast` | 20px | `radius-md` | `elevation-sm` | Broadcast/opportunity |

**All cards share:** white background (light), `#1A1A1A` (dark), 1px `color-border` stroke, no elevation in dark mode.

### 11.4 Person Card Pattern

```
┌──────────────────────────────────────┐
│  [Avatar]  Name                      │
│            Company · Role            │
│            {skill} {skill}           │
│            3 mutual connections      │
│                      [Connect]       │
└──────────────────────────────────────┘
```

- Avatar: 48px, `radius-full`, first letter if no photo
- Name: `text-title`
- Company/role: `text-body-small`, `color-text-secondary`
- Skills: inline chips, 8px apart
- Mutual connections: `text-caption`, `color-primary`
- Connect button: always `outline` variant

### 11.5 Connection Request Card

```
┌──────────────────────────────────────┐
│  [Avatar]  Name                      │
│            "Investment"              │
│            Met at: AI Expo Chennai   │
│                         [Accept][X]  │
└──────────────────────────────────────┘
```

- Intent badge: small pill with `color-primary-soft`
- Context line: `text-caption`, `color-text-secondary`
- Accept: primary button. Decline: ghost button with error color.

### 11.6 Empty States

See **[Part 9 — Empty States](#part-9--empty-states)** for full empty state specifications including photography, copy, and emotional principles.

Component-level specifications:
- Icon: Lucide icon, 48px, `color-text-disabled`
- Title: `text-title`, `color-text-primary`
- Description: `text-body-small`, `color-text-secondary`
- Action: Optional button (only if there's a clear next step)

### 11.7 Loading States

- Full page: centered spinner (40px, `color-primary`)
- Card/partial: skeleton shimmer (animated gradient)
- Action: inline spinner on button, disable interaction
- Pull-to-refresh: standard platform implementation

### 11.8 Snackbars

- Position: bottom (mobile), bottom-center (desktop)
- Duration: 3s for success, persistent for errors
- Action button optional (max 12 chars)
- Slide up animation, `motion-normal`

### 11.9 Avatars

| Size | Pixels | Usage |
|------|--------|-------|
| `avatar-sm` | 32px | Lists, comments |
| `avatar-md` | 48px | Person cards, profiles |
| `avatar-lg` | 64px | Profile header |
| `avatar-xl` | 80px | Full profile page |

Fallback: first letter of name on `color-primary-soft` background.

### 11.10 Status Chips

| Variant | Background | Text Color | Icon |
|---------|-----------|------------|------|
| `connected` | `color-success` at 10% | `color-success` | ✓ |
| `pending` | `color-accent` at 10% | `color-accent` | ○ |
| `expired` | `color-text-disabled` at 10% | `color-text-secondary` | — |
| `active` | `color-primary` at 10% | `color-primary` | ● |

---

## Part 12 — Mobile Navigation

### 12.1 Structure

```
Bottom Tab Bar (always visible)
┌────────────┬──────────────┬────────────┬──────────┐
│  Live      │  Connections │ Messages   │ Profile  │
│  `users`   │  `link-2`    │ `messages` │ `user`   │
└────────────┴──────────────┴────────────┴──────────┘
```

### 12.2 Principles

- **No hamburger menus.** Four tabs is the maximum. If a fifth is needed, one becomes a "more" tab.
- **No deep nesting.** Max 2 levels deep from any tab.
- **Back behavior:** Swipe right to go back (iOS), hardware back (Android), back arrow in app bar.
- **Tab persistence:** Switching tabs preserves scroll position. Re-tapping the active tab scrolls to top.

### 12.3 Screen Hierarchy

```
Auth
 └─ Login / OTP

Main (Tab Bar)
 ├─ Live (default tab)
 │   ├─ Home / "I'm Here"
 │   ├─ Attendee list
 │   └─ Person profile → Connect
 ├─ Connections
 │   ├─ Incoming requests
 │   ├─ Outgoing requests
 │   └─ Accepted connections
 ├─ Messages
 │   ├─ Conversation list
 │   └─ Chat screen
 └─ Profile
     ├─ My profile
     ├─ Skills
     ├─ Settings
     └─ Workspace switcher
```

---

## Part 13 — Web Navigation

### 9.1 Structure

```
┌─────────────────────────────────────────────────┐
│  Sidebar (collapsible, 64px | 224px)            │
│  ┌──────┬──────────────────────────────────────┐│
│  │ Logo │  Topbar                              ││
│  │      │  [Workspace ▼]  [Search...]  [🔔👤]  ││
│  │ Nav  ├──────────────────────────────────────┤│
│  │      │                                      ││
│  │ [target]│  Content area                     ││
│  │ [package]│                                   ││
│  │ [users]  │                                   ││
│  │ [message-square]│                             ││
│  │      │                                      ││
│  │ [WS] │                                      ││
│  └──────┴──────────────────────────────────────┘│
└─────────────────────────────────────────────────┘
```

### 13.2 Sidebar Items

| Icon | Label | Route |
|------|-------|-------|
| `target` | Dashboard | `/dashboard` |
| `package` | Apps | Product Launcher |
| `users` | Connections | `/connections` |
| `message-square` | Messages | `/messages` |
| `globe` | Websites | `/sites` |
| `edit-3` | Content | `/content` |
| `radio` | Broadcast | `/broadcast` |

### 13.3 Workspace Switcher

Top-right of sidebar. Dropdown showing all workspaces. Current workspace highlighted with checkmark. "Create workspace" at bottom.

---

## Part 14 — Motion

### 14.1 Philosophy

**Everything under 250ms.** Linear's animations feel amazing because they're almost invisible. That's the standard.

**Fast is premium.** Every animation completes in 250ms or less. No exceptions. Speed communicates confidence. Slow animations feel hesitant.

**Animate only what matters.** Most AI UIs animate everything. Yugrow animates only meaningful state changes.

**Animate these four things:**
1. Connection accepted
2. Message received
3. Check-in success
4. Broadcast sent

**Everything else is static.** No parallax, no hover animations on cards, no loading spinners that dance. Restraint is the goal.

| State | Animation | Duration | Easing |
|-------|-----------|----------|--------|
| Connect success | Heartbeat pulse on avatar + "Connected ✓" fade | 200ms | ease-out |
| Check-in success | Ripple from "I'm Here" button + card transition | 250ms | ease-out |
| Message received | Gentle slide-in of new message bubble | 150ms | ease-out |
| Page transition | Slide left/right | 200ms | ease-out |
| Button press | Scale to 0.97 | 100ms | ease-out |
| Modal open | Fade backdrop + scale content | 200ms | ease-out |

### 14.2 Connection Success Animation

The most important microinteraction:

1. User taps "Connect" → button shows spinner
2. Request sent → button changes to "Requested ✓" with subtle checkmark animation
3. On acceptance → card pulses green briefly → "Connected ✓" with avatar animation
4. Chat input appears with gentle slide-up

No confetti. No fireworks. A premium, subtle acknowledgment.

---

## Part 15 — Accessibility

### 15.1 Standards

- WCAG 2.1 Level AA minimum
- All interactive elements keyboard-navigable
- Screen reader support (semantic labels on all elements)
- Touch targets minimum 44x44px

### 15.2 Implementation

| Requirement | Implementation |
|-------------|---------------|
| Color contrast | All text/background combos pass 4.5:1 ratio |
| Focus indicators | 2px `color-border-active` ring on all interactive elements |
| Reduced motion | `prefers-reduced-motion` disables all animations |
| Screen readers | `aria-label` on icon-only buttons, semantic heading hierarchy |
| Touch targets | All buttons and links minimum 44x44px hit area |

---

## Part 16 — Product-Specific Patterns

### 16.1 CheckIN Pattern

```
1. Auth → Phone → OTP
2. Home → Shows nearest active event → "I'm Here" button
3. Workspace selector → Personal / Company
4. Presence confirmed → "You're visible" animation
5. Live → List of attendees with Connect buttons
6. Profile preview → Tap attendee → Quick profile card
7. Connect → One tap → "Request sent" confirmation
8. Incoming → Accept → "Connected ✓" animation
9. Chat → Context banner shows "Met at [Event]"
10. Message → Text input → Send
```

### 16.2 Broadcast Pattern (Future)

```
1. Create → Title, description, skills required, geographic scope
2. Preview → Distribution estimate, audience composition
3. Publish → Opportunity distributed via Intelligence Layer
4. Responses → Incoming replies with context
5. Connect → Reply leads to connection request
```

### 16.3 Relationship Pattern

```
1. Request → Intent + context auto-attached
2. Accept → Relationship created + conversation unlocked
3. Timeline → Origin context preserved (Event + Venue + Date)
4. Strength → Signals accumulate over time
```

### 16.4 CRM Pattern (Future)

```
1. People → List of connections with relationship strength
2. Context → Origin event, mutual connections, trust evidence
3. Activity → Timeline of interactions across all products
4. Opportunities → Deals born from relationships
```

---

## Part 17 — Flutter Implementation

### 17.1 Theme Configuration

```dart
// ColorScheme
ColorScheme(
  primary: const Color(0xFF0F766E),       // Deep Emerald
  secondary: const Color(0xFF4338CA),      // Warm Indigo
  tertiary: const Color(0xFFF59E0B),       // Amber
  error: const Color(0xFFDC2626),
  surface: const Color(0xFFFFFFFF),
  background: const Color(0xFFFAFAFA),
  onPrimary: Colors.white,
  onSecondary: Colors.white,
  onSurface: const Color(0xFF171717),
  brightness: Brightness.light,
)

// TextTheme
TextTheme(
  displayLarge: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w700, height: 1.2),
  headlineMedium: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w600, height: 1.3),
  titleLarge: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, height: 1.4),
  bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, height: 1.5),
  bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, height: 1.5),
  bodySmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, height: 1.4),
  labelLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, height: 1),
  labelSmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, height: 1.33),
)
```

### 17.2 Widget Mapping

| Flow Component | Flutter Widget |
|----------------|---------------|
| Card | `Card` with `CardThemeData` |
| PersonCard | Custom `PersonCard` widget |
| Button primary | `ElevatedButton` |
| Button outline | `OutlinedButton` |
| Button ghost | `TextButton` |
| Input | `TextField` with `InputDecoration` |
| Snackbar | `SnackBar` with custom theme |
| Bottom nav | `BottomNavigationBar` |
| Avatar | `CircleAvatar` with fallback text |
| Chip | `Chip` or custom `StatusChip` |
| Skeleton | `Shimmer` package or custom |
| Modal | `showModalBottomSheet` |
| Dialog | `AlertDialog` with custom theme |

---

## Part 18 — Next.js Implementation

### 18.1 CSS Variables

```css
:root {
  --y-color-primary: #0F8B6D;
  --y-color-primary-hover: #115E59;
  --y-color-primary-soft: #CCFBF1;
  --y-color-secondary: #4338CA;
  --y-color-accent: #F59E0B;
  --y-color-success: #16A34A;
  --y-color-warning: #F59E0B;
  --y-color-error: #DC2626;
  --y-color-info: #2563EB;
  --y-color-bg: #FAFAFA;
  --y-color-surface: #FFFFFF;
  --y-color-surface-elevated: #F5F5F5;
  --y-color-border: #E5E5E5;
  --y-color-border-active: #0F766E;
  --y-color-text-primary: #171717;
  --y-color-text-secondary: #737373;
  --y-color-text-disabled: #D4D4D4;

  --y-radius-sm: 6px;
  --y-radius-md: 12px;
  --y-radius-lg: 16px;
  --y-radius-xl: 24px;
  --y-radius-full: 9999px;

  --y-space-1: 4px;
  --y-space-2: 8px;
  --y-space-3: 12px;
  --y-space-4: 16px;
  --y-space-5: 24px;
  --y-space-6: 32px;
  --y-space-7: 48px;
  --y-space-8: 64px;

  --y-elevation-sm: 0 1px 2px rgba(0,0,0,0.05);
  --y-elevation-md: 0 4px 6px rgba(0,0,0,0.07);
  --y-elevation-lg: 0 10px 15px rgba(0,0,0,0.1);

  --y-motion-fast: 200ms;
  --y-motion-normal: 300ms;
}

.dark {
  --y-color-primary: #14B8A6;
  --y-color-bg: #0A0A0A;
  --y-color-surface: #1A1A1A;
  --y-color-surface-elevated: #262626;
  --y-color-border: #333333;
  --y-color-text-primary: #F5F5F5;
  --y-color-text-secondary: #A3A3A3;
  /* Continue for all tokens... */
}
```

### 18.2 Tailwind Extension

```js
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        y: {
          primary: '#0F766E',
          'primary-hover': '#115E59',
          'primary-soft': '#CCFBF1',
          secondary: '#4338CA',
          accent: '#F59E0B',
          success: '#16A34A',
          error: '#DC2626',
          bg: '#FAFAFA',
          surface: '#FFFFFF',
          border: '#E5E5E5',
          'text-primary': '#171717',
          'text-secondary': '#737373',
        },
      },
      borderRadius: {
        y: '12px',
      },
      spacing: {
        18: '72px',
      },
    },
  },
};
```

### 18.3 Component Mapping

| Flow Component | Next.js Component |
|----------------|-------------------|
| Card | `Card` from `@ui/components` |
| Button | `Button` with variant prop |
| Input | `Input` with label/error |
| PersonCard | Composed from Card + Avatar + Text |
| Bottom nav | N/A (web uses sidebar) |
| Skeleton | `Skeleton` from `@ui/components` |

---

## Part 19 — Design Governance

### 19.1 How New Products Adopt Flow

Every new product must:
1. Reference this document in its PRD
2. Use only colors, typography, and spacing defined here
3. Reuse existing components before creating new ones
4. Pass a visual audit before release

### 19.2 Versioning

| Version | Status |
|---------|--------|
| v1.0 | ✅ Approved |
| v2.0 | ✅ Approved (current) — Warm Professional, 19 parts, "Relationships are the color" |
| v2.x | Minor additions (new components, tokens) |
| v3.0 | Major revision (requires full review) |

### 19.3 Component Approval

- New components require approval from CPO
- Component variants must be justified (why can't the existing component work?)
- Deprecated components get a 90-day removal notice

### 19.4 Change Management

- This document is frozen after approval
- Changes require an RFC in `docs/design-rfcs/`
- RFCs are reviewed monthly
- Breaking changes require a major version bump

---

> **Every pixel, every animation, every interaction must feel intentional.**
>
> Yugrow Flow is not a theme. It is the visual expression of the platform philosophy.
>
> *"Business relationships made effortless."*
>
> When a user opens Yugrow on any device, they should feel the same thing:
> **Professional. Trustworthy. Modern. Minimal. Optimistic. Human.**
>
> That is the standard.
