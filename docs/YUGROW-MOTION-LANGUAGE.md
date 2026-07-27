---
Title: Yugrow Motion Language
Version: 1.0
Status: Approved
Owner: Design
Last Updated: 2026-07-28
Dependencies: YUGROW-DESIGN-LANGUAGE.md, YUGROW-FLOW-EXPERIENCE-SYSTEM.md
Related Documents: YUGROW-DESIGN-LANGUAGE.md, YUGROW-BRAND-LANGUAGE.md
---

# Yugrow Motion Language

> Animation isn't decoration. It teaches.

---

## Table of Contents

1. [Philosophy](#1-philosophy)
2. [Timing & Easing](#2-timing--easing)
3. [The Four Allowed Animations](#3-the-four-allowed-animations)
4. [Micro-interactions](#4-micro-interactions)
5. [Page Transitions](#5-page-transitions)
6. [Loading & Progress](#6-loading--progress)
7. [Accessibility](#7-accessibility)
8. [Sound & Haptics](#8-sound--haptics)

---

## 1. Philosophy

### Core beliefs

| Belief | What it means |
|--------|--------------|
| Motion communicates state | Every animation answers: "What just happened?" If it doesn't, remove it. |
| Less is more | Yugrow animates exactly **4 moments**. Everything else is static. |
| Speed is respect | All animations complete in **≤250ms**. The user never waits for the animation. |
| Motion is earned | A component must justify why it deserves to move. Default is static. |
| Sound reinforces motion | Sound and haptics accompany the 4 animations — never used alone. |

### What we never animate

- Page scroll (native behaviour only)
- Hover states (instant opacity change, no transition)
- Parallax (unprofessional, distracting)
- Decorative loading (spinners only — no animated logos)
- Background effects (no animated gradients, particles, confetti)

---

## 2. Timing & Easing

### Duration map

| Token | Duration | Usage |
|-------|----------|-------|
| instant | 100ms | Feedback on tap, button press |
| fast | 150ms | Micro-interactions, tooltips |
| normal | 200ms | Default animation speed |
| slow | 250ms | Complex transitions, screen changes |

**All four durations are ≤250ms.** Nothing in Yugrow animates longer than a quarter-second.

### Easing

```
cubic-bezier(0.16, 1, 0.3, 1)
```

- Starts fast (0.16), decelerates naturally
- Overshoots slightly (1 on the y-axis), settles smoothly (0.3)
- Never linear. Never bouncy. Never elastic.

### Opacity transitions

| State | Opacity | Timing |
|-------|---------|--------|
| Disabled | 0.4 | instant (100ms) |
| Hint text | 0.6 | — |
| Overlay backdrop | 0.5 | normal (200ms) |
| Skeleton shimmer | 0.1 → 0.3 | loop 1.5s |

---

## 3. The Four Allowed Animations

Only four things in Yugrow animate. Everything else is static.

### 1. Check-in Success

**Trigger:** User taps "I'm Here"

**Sequence (300ms total):**

```
┌─────────────────────────────────────────────┐
│  0ms    Map pin drops → small bounce         │
│  100ms  Ripple expands from pin (opacity 1→0)│
│  200ms  "You're in" text fades in            │
│  300ms  Complete — card slides into Live     │
└─────────────────────────────────────────────┘
```

**Duration:** 300ms (slightly longer to communicate significance)
**Haptic:** Light impact on tap

### 2. Connection Accepted

**Trigger:** User accepts or receives a connection

**Sequence (350ms total):**

```
┌─────────────────────────────────────────────┐
│  0ms    Heart icon appears (scale 0→1)       │
│  100ms  Heart pulse (scale 1→1.15→1)         │
│  150ms  Green glow fades in/out (200ms)      │
│  200ms  "Connected ✓" text slides up (10px)  │
│  350ms  Card settles — chat button appears   │
└─────────────────────────────────────────────┘
```

**Duration:** 350ms (most meaningful moment in the app)
**Haptic:** Medium impact + C major chime (200ms)
**Sound:** Short ascending tone, 200ms

### 3. Message Received

**Trigger:** New message arrives in active conversation

**Sequence (200ms total):**

```
┌─────────────────────────────────────────────┐
│  0ms    Message bubble slides in (from left) │
│  50ms   Subtle scale bounce (1→1.03→1)      │
│  100ms  Read indicator updates               │
│  200ms  Complete                             │
└─────────────────────────────────────────────┘
```

**Duration:** 200ms
**Haptic:** Light impact
**Sound:** OS default message sound

### 4. Broadcast Sent

**Trigger:** User sends a broadcast (future product)

**Sequence (250ms total):**

```
┌─────────────────────────────────────────────┐
│  0ms    Send icon transforms to check        │
│  100ms  Confirmation pulse (scale 1→1.1→1)   │
│  200ms  "Sent to N connections" fades in     │
│  250ms  Complete                             │
└─────────────────────────────────────────────┘
```

**Duration:** 250ms
**Haptic:** Medium impact
**Sound:** Whoosh, 250ms

---

## 4. Micro-interactions

### Button press

| State | Change | Duration |
|-------|--------|----------|
| Default | Full opacity | — |
| Hover | 95% opacity | instant (100ms) |
| Pressed | 90% opacity | instant (100ms) |
| Disabled | 0.4 opacity | instant (100ms) |

### Card tap

Cards lift subtly on press using surface elevation change:
- Surface 1 → Surface 2 (150ms)

### Tab switch

- Active tab icon transitions colour instantly
- No sliding indicator animation
- No cross-fade

### Pull to refresh

- Standard OS pull-to-refresh
- No custom animation
- Haptic on trigger

---

## 5. Page Transitions

### Mobile (Flutter)

| Transition | Duration | Easing |
|------------|----------|--------|
| Push screen | 250ms | ease-out |
| Pop screen | 200ms | ease-out |
| Bottom sheet | 200ms slide-up | ease-out |
| Dialog | 200ms fade + scale | ease-out |

No hero transitions. No shared element transitions.

### Web (Next.js)

| Transition | Duration | Easing |
|------------|----------|--------|
| Route change | 200ms fade | ease-out |
| Dropdown | 150ms fade | ease-out |
| Modal | 200ms fade + scale | ease-out |

No route transition animations between pages (instant navigation preferred).

---

## 6. Loading & Progress

### Loading states

| State | Visual | Duration |
|-------|--------|----------|
| Full page | Centered circular spinner | Until loaded |
| Button action | Spinner replaces icon | Until complete |
| Card / list | Skeleton shimmer (3 rows) | Until loaded |
| Image | Colour placeholder (#E5E7EB) | Until loaded |

### Skeleton shimmer

- Opacity oscillates: 0.1 → 0.3 → 0.1
- Duration: 1.5s per cycle
- Easing: ease-in-out
- Never add skeleton shimmer for items that load in <200ms

### No progress bars

- No linear progress bars in any Yugrow product
- No percentage loaders
- If something takes >2s, show a spinner with a message

---

## 7. Accessibility

### Reduced motion

If the user's system has **Reduce Motion** enabled:

- All animations are disabled
- All transitions become instant (0ms)
- Skeleton shimmer becomes static placeholder
- Sound and haptics still function (separate setting)

### Implementation

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}
```

```dart
// Flutter: check via MediaQuery
final reduceMotion = MediaQuery.of(context).disableAnimations;
```

---

## 8. Sound & Haptics

### Sound map

| Moment | Sound | Duration | Note |
|--------|-------|----------|------|
| Check-in | Short ascending tone | 150ms | Light, rising |
| Connection accepted | C major chime | 200ms | Warm, resonant |
| Message received | OS default | OS-dependent | Not custom |
| Broadcast sent | Whoosh | 250ms | Quick, satisfying |

### Haptic map

| Moment | Haptic | Type |
|--------|--------|------|
| Check-in tap | Light | Touch feedback |
| Connection accepted | Medium | Celebratory |
| Message received | Light | Touch feedback |
| Broadcast sent | Medium | Confirmation |
| Error | Heavy | Alert |

### Rules

- Sound and haptics never appear alone — they always accompany an animation
- All sounds <250ms
- User can disable sound separately from haptics
- Never play sound for notifications
- Never play sound for errors

### Implementation guidance

Sound files should be:
- Format: `.mp3` or `.wav`
- Max size: 50KB per file
- Loaded eagerly on app start (not streamed)

Haptics use OS-native APIs:
- Flutter: `HapticFeedback.lightImpact()`, `.mediumImpact()`, `.heavyImpact()`
- Web: Not supported (skip)
