---
Title: Yugrow Illustration Language
Version: 1.0
Status: Approved
Owner: Design
Last Updated: 2026-07-28
Dependencies: YUGROW-DESIGN-LANGUAGE.md, YUGROW-BRAND-LANGUAGE.md
Related Documents: YUGROW-DESIGN-LANGUAGE.md, YUGROW-MOTION-LANGUAGE.md
---

# Yugrow Illustration Language

> What people see when nothing is happening yet.

---

## Table of Contents

1. [Philosophy](#1-philosophy)
2. [Empty States](#2-empty-states)
3. [Success Screens](#3-success-screens)
4. [Onboarding & Welcome](#4-onboarding--welcome)
5. [Error & Offline States](#5-error--offline-states)
6. [Photography](#6-photography)
7. [Illustration Style](#7-illustration-style)
8. [Asset Specifications](#8-asset-specifications)

---

## 1. Philosophy

### Core beliefs

| Belief | What it means |
|--------|--------------|
| Empty states are opportunities | Every empty state is a chance to say: "Something good is about to happen." |
| People, not data | Show humans, not charts. Connection > metrics. |
| Photography over illustration | Real people in real environments. Never generic vector illustrations. |
| Warmth without decoration | Every visual has purpose. If it doesn't communicate, remove it. |
| Consistency is trust | Same visual language on every screen. No mixed styles. |

### The emotional arc of an empty state

```
Curiosity ──→ Anticipation ──→ Action
```

1. **Curiosity:** The visual catches attention ("What's this?")
2. **Anticipation:** The copy promises value ("Professionals will appear here")
3. **Action:** The button gives direction ("Share this event")

---

## 2. Empty States

### Structure

Every empty state follows this layout:

```
┌──────────────────────────┐
│                          │
│       [Visual]           │  ← 160px max height
│                          │
│     [Title]              │  ← headlineMedium, weight 600
│                          │
│     [Description]        │  ← bodyMedium, text secondary
│                          │
│     [Action Button]      │  ← Primary or Outline, md
│                          │
└──────────────────────────┘
```

Centered vertically on the screen. No secondary actions.

### Screen-specific empty states

#### Live — No one checked in yet

```
Visual:   Single silhouette with a question mark
Title:    "You're early."
Body:     "Waiting for other professionals to arrive."
Action:   "Share this event"
Emotion:  Optimistic — the first person always arrives early.
```

#### Live — User not checked in

```
Visual:   Map pin with a person walking toward it
Title:    "Not checked in yet."
Body:     "Tap 'I'm Here' to let others know you're at this event."
Action:   "Check In"
Emotion:  Inviting — the action is clear and easy.
```

#### Connections — No connections

```
Visual:   Two silhouettes with a dotted line between them
Title:    "No connections yet."
Body:     "Check in at an event to discover professionals near you."
Action:   "Find Events"
Emotion:  Hopeful — the first connection is just one event away.
```

#### Messages — No conversations

```
Visual:   Speech bubble with a + inside
Title:    "No conversations yet."
Body:     "Connect with someone at an event and your conversations will appear here."
Action:   "Discover Events"
Emotion:  Inviting — connection is the prerequisite.
```

#### Events — No active events

```
Visual:   Calendar with a star on a future date
Title:    "No events yet."
Body:     "Create an event or check back when events are happening near you."
Action:   "Create Event"
Emotion:  Empowering — the user can create their own opportunity.
```

#### Broadcast — No broadcasts (future)

```
Visual:   Megaphone with sound waves
Title:    "No broadcasts yet."
Body:     "Share an update with your network. Broadcasts help you find opportunities."
Action:   "Create Broadcast"
Emotion:  Encouraging — the network is ready to hear from you.
```

#### Profile — Incomplete

```
Visual:   Silhouette with a dotted outline
Title:    "Complete your profile."
Body:     "Add your photo, title, and company so others know who you are."
Action:   "Edit Profile"
Emotion:  Gentle nudge — not a demand.
```

---

## 3. Success Screens

### Structure

```
┌──────────────────────────┐
│                          │
│       [Icon]             │  ← 64px, Primary colour
│                          │
│     [Title]              │  ← headlineMedium
│                          │
│     [Description]        │  ← bodyMedium (optional)
│                          │
│     [Duration indicator] │  ← auto-dismiss progress (1.5s)
│                          │
└──────────────────────────┘
```

Auto-dismisses after 1.5s. No user action required.

### Screen-specific success states

#### Check-in complete

```
Icon:     check-circle (filled, #0F766E)
Title:    "You're in!"
Body:     (none — auto-dismiss)
Action:   Auto-dismiss → Live screen
Timing:   1.5s
```

#### Connection accepted

```
Icon:     heart (filled, #0F766E)
Title:    "Connected ✓"
Body:     "Met at [Event Name]"
Action:   Auto-dismiss → Conversation screen
Timing:   2s (slightly longer for emotional weight)
```

#### Connection request sent

```
Icon:     user-plus (filled, #0F766E)
Title:    "Request sent!"
Body:     "Waiting for [Name] to accept."
Action:   Auto-dismiss → Previous screen
Timing:   1.5s
```

#### Event created

```
Icon:     calendar-check (filled, #0F766E)
Title:    "Event created!"
Body:     "Share the link to invite attendees."
Action:   "Share" button + auto-dismiss
Timing:   2s
```

---

## 4. Onboarding & Welcome

### Welcome screen

```
┌──────────────────────────┐
│                          │
│       [Logo]             │  ← 80px, centred
│                          │
│     [Tagline]            │  ← displayLarge
│                          │
│     [Description]        │  ← bodyLarge
│                          │
│     [Get Started]        │  ← Primary button, xl
│                          │
│     [Sign In]            │  ← Ghost button
│                          │
└──────────────────────────┘
```

- No illustrations on the welcome screen — the logo is the visual
- Clean, minimal, no distractions
- Background: Surface colour (light) or dark

### Onboarding steps

Each step follows the same layout:

```
┌──────────────────────────┐
│                          │
│       [Photo/Visual]     │  ← 240px max, centred
│                          │
│     [Step Title]         │  ← headlineMedium
│                          │
│     [Step Description]   │  ← bodyMedium
│                          │
│     [Continue]           │  ← Primary button
│                          │
│     [Progress dots]      │  ← 3 or 4 dots
│                          │
└──────────────────────────┘
```

Steps:
1. **Add your photo** — Professional headshot area
2. **Your details** — Name, title, company
3. **Your interests** — Industries, skills (optional)

---

## 5. Error & Offline States

### Error state

```
┌──────────────────────────┐
│                          │
│     [Alert icon]         │  ← 48px, Error colour
│                          │
│     [Title]              │  ← titleLarge
│                          │
│     [Description]        │  ← bodyMedium
│                          │
│     [Try Again]          │  ← Outline button
│                          │
└──────────────────────────┘
```

### Offline state

```
┌──────────────────────────┐
│                          │
│     [Cloud-off icon]     │  ← 48px, Warning colour
│                          │
│     [Title]              │  ← titleLarge
│                          │
│     [Description]        │  ← bodyMedium
│                          │
│     [Retry]              │  ← Outline button
│                          │
└──────────────────────────┘
```

### No illustrations for errors

Errors use **icons only** — no illustrations, no photography. Icons communicate the problem quickly; illustrations add noise during a stressful moment.

---

## 6. Photography

### Style guide

| Attribute | Direction |
|-----------|-----------|
| Subjects | Real humans in real professional environments |
| Lighting | Natural light, warm tones |
| Composition | Candid over posed. No one looking directly at the camera. |
| Colour | Desaturated with warm tint. No oversaturated colours. |
| Context | Events, conferences, coffee meetings, co-working spaces |
| Avoid | Stock photography clichés (handshake, whiteboard, laptop alone) |

### Photography rules

- Never use generic stock photography
- Never use illustration-style photos (cut-out people on coloured backgrounds)
- Never use photos with text overlays
- Photos should feel like they were taken at a real Yugrow event

### Where photography is used

| Context | Photography style |
|---------|-------------------|
| Hero section (website) | Full-bleed, candid event photo, dark overlay |
| Empty states | 160px illustration-style (not photo) |
| Event cards | 16:9 venue or event photo |
| Person avatars | User-uploaded headshot |
| Success screens | No photo — icon only |

---

## 7. Illustration Style

For the rare cases where illustration is needed (empty states, onboarding), follow this style:

| Attribute | Direction |
|-----------|-----------|
| Style | Minimal line art with subtle fills |
| Lines | 2px stroke, rounded caps |
| Colours | Surface colours only — never primary or accent |
| Human figures | Simplified, no facial features |
| Environment | Abstract shapes suggesting context (calendar, map pin, speech bubble) |
| Animation | None — static illustrations |

### Colour palette for illustrations

```
Fill:  #F3F4F6 (light grey)
Line:  #9CA3AF (medium grey)
Accent: #0F766E (Primary — sparingly, for key elements only)
```

### What we never illustrate

- Complex scenes (office, conference hall, city)
- Multiple human figures interacting
- Technology (phones, laptops, servers)
- Abstract concepts (growth, connection, trust)

---

## 8. Asset Specifications

### Image formats

| Use case | Format | Max size |
|----------|--------|----------|
| Photographs | WebP (preferred) or JPEG | 200KB |
| Illustrations | SVG (preferred) or PNG @2x | 50KB |
| Icons | SVG | 5KB |
| Empty state visuals | SVG (preferred) or PNG @2x | 30KB |

### Responsive breakpoints

| Breakpoint | Width | Asset size |
|------------|-------|------------|
| Mobile | < 768px | 1× resolution |
| Tablet | 768–1024px | 1.5× resolution |
| Desktop | > 1024px | 2× resolution |

### Accessibility

- All images require `alt` text
- Decorative images use `alt=""`
- No images used to convey critical information without text alternatives
- No animated images (GIF, APNG, animated WebP)

### Asset naming convention

```
yugrow-{context}-{name}-{variant}.{ext}

Examples:
yugrow-empty-live-early.svg
yugrow-empty-connections-none.svg
yugrow-success-checkin.svg
yugrow-onboarding-photo.svg
```
