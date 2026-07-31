# Yugrow Design System — Screen Patterns (YDS-SCREEN-PATTERNS)

> **Status:** Active — v1.0
> **Rule:** Every screen follows one of these templates. Do not invent new layouts. If no template fits, propose an addition to YDS.

---

## 1. Event List

```
┌─────────────────────────────────┐
│ Header (title + action button)  │
├─────────────────────────────────┤
│ Search bar                      │
├─────────────────────────────────┤
│ Filter chips (scrollable row)   │
├─────────────────────────────────┤
│                                 │
│ Event Card                      │
│ Event Card                      │
│ Event Card                      │
│                                 │
├─────────────────────────────────┤
│ FAB (Create Event) [mobile]     │
└─────────────────────────────────┘
```

**Used for:** Home/Events screen, My Events, Search Results

---

## 2. Detail Page

```
┌─────────────────────────────────┐
│ Back button + title             │
├─────────────────────────────────┤
│ Hero image / gradient header    │
├─────────────────────────────────┤
│ Type badge                      │
│ Title (28px)                    │
│ Host: Organisation Name         │
├─────────────────────────────────┤
│ Metadata chips (date, time,     │
│ venue, attendees)               │
├─────────────────────────────────┤
│ Primary action button           │
├─────────────────────────────────┤
│ Description / About             │
├─────────────────────────────────┤
│ Topics / Tags                   │
├─────────────────────────────────┤
│ Related events (horizontal      │
│ scroll)                         │
└─────────────────────────────────┘
```

**Used for:** Event Detail, Venue Detail, Professional Profile

---

## 3. Dashboard

```
┌─────────────────────────────────┐
│ Header (title + date range)     │
├─────────────────────────────────┤
│ Summary row (3-4 metric cards)  │
├─────────────────────────────────┤
│ Chart (connections over time)   │
├─────────────────────────────────┤
│ Insights (2-3 insight cards)    │
├─────────────────────────────────┤
│ Recent Activity list            │
├─────────────────────────────────┤
│ Quick actions row               │
└─────────────────────────────────┘
```

**Used for:** Organiser Dashboard, Home Dashboard

---

## 4. Conversation / Messages

```
┌─────────────────────────────────┐
│ Back + Name + Status            │
├─────────────────────────────────┤
│                                 │
│ Message bubble (right, sent)    │
│ Message bubble (left, received) │
│ System message (center)         │
│                                 │
│                                 │
│                                 │
├─────────────────────────────────┤
│ Composer (input + send button)  │
└─────────────────────────────────┘
```

**Used for:** Chat, Messages, System Conversation

---

## 5. List (with filters)

```
┌─────────────────────────────────┐
│ Header (title + count)          │
├─────────────────────────────────┤
│ Segmented control / tabs        │
├─────────────────────────────────┤
│ Filter bar (2-3 dropdowns)      │
├─────────────────────────────────┤
│                                 │
│ List item                       │
│ List item                       │
│ List item                       │
│                                 │
└─────────────────────────────────┘
```

**Used for:** Connections, Network, Attendees, Participants

**List Item spec:**
```
[height: 64px]
[padding: 0 16px]
[content: Avatar (40px) | Name + subtitle (flex) | Action icon]
[border-bottom: 1px --y-border]
```

---

## 6. Form / Creation

```
┌─────────────────────────────────┐
│ Header (title + Cancel)         │
├─────────────────────────────────┤
│ Section heading                 │
│ Input field                     │
│ Input field                     │
│                                 │
│ Section heading                 │
│ Input field                     │
│                                 │
├─────────────────────────────────┤
│ Primary button (full width)     │
└─────────────────────────────────┘
```

**Used for:** Create Event, Edit Profile, Check-in, Feedback Form

---

## 7. Auth Flow

```
┌─────────────────────────────────┐
│                                 │
│        Logo (centered)          │
│                                 │
│   Heading (20px, centered)      │
│   Subtitle (16px, centered)     │
│                                 │
│   Email input                   │
│   Password input                │
│                                 │
│   Primary button (full width)   │
│                                 │
│   Bottom link (Text button)     │
│                                 │
└─────────────────────────────────┘
```

**Used for:** Login, Signup, Forgot Password, OTP Verification

---

## 8. Empty State Screen

```
┌─────────────────────────────────┐
│ Header                          │
├─────────────────────────────────┤
│                                 │
│                                 │
│         (centered)              │
│          Icon                   │
│                                 │
│        Heading                  │
│                                 │
│       Description               │
│                                 │
│      [Action button]            │
│                                 │
│                                 │
└─────────────────────────────────┘
```

---

## 9. Settings / Profile

```
┌─────────────────────────────────┐
│ Header (title)                  │
├─────────────────────────────────┤
│ Profile header (avatar, name,   │
│   title, company)               │
├─────────────────────────────────┤
│ Section heading                 │
│ Settings row (icon + label +    │
│   value + chevron)              │
│ Settings row                    │
│ Settings row                    │
├─────────────────────────────────┤
│ Section heading                 │
│ Settings row                    │
│ Settings row                    │
└─────────────────────────────────┘
```

**Settings Row spec:**
```
[height: 48px]
[padding: 0 16px]
[content: Icon (20px, --y-text-secondary) | Label (16px) | Value (14px, secondary) | Chevron (right)]
[border-bottom: 1px --y-border]
```

---

## Design Compliance Checklist

Every new screen must pass before shipping:

- [ ] Uses only YDS colours from palette
- [ ] Spacing follows 8pt grid (4/8/16/24/32/48/64)
- [ ] Typography uses Inter, weights from scale (400/500/600/700)
- [ ] Radius values from scale (8/12/16/20/9999)
- [ ] Uses YDS components only (no invented buttons, cards, etc.)
- [ ] Follows one of the screen pattern templates above
- [ ] Has loading state (skeleton, not spinner)
- [ ] Has empty state (message + action)
- [ ] Has error state (message + retry)
- [ ] Obvious primary action on screen
- [ ] No dead buttons
- [ ] No mixed icon sets
- [ ] Host identity visible on event cards
- [ ] 80% neutral, colour only for meaning
- [ ] Would I be proud to show this to an organiser?
