# Yugrow Design System — Components (YDS-COMPONENTS)

> **Status:** Active — v1.0
> **Rule:** If a component isn't listed here, don't invent it. Use the closest existing pattern or propose an addition to YDS.

---

## Buttons

Exactly four button styles. No fifth.

### Primary Button
```
[background: --y-brand-primary (#0F8B6D)]
[color: white]
[radius: 14px]
[padding: 12px 24px]
[font: Inter 600, 16px]
[hover: opacity 0.9]
[disabled: opacity 0.5, cursor not-allowed]
```

### Secondary Button
```
[background: transparent]
[border: 1.5px solid --y-border]
[color: --y-text-primary]
[radius: 14px]
[padding: 12px 24px]
[font: Inter 600, 16px]
[hover: border --y-border-hover]
```

### Text Button
```
[background: transparent]
[border: none]
[color: --y-brand-primary]
[padding: 8px 12px]
[font: Inter 500, 14px]
[hover: opacity 0.8]
```

### Danger Button
```
[background: --y-error (#DC2626)]
[color: white]
[radius: 14px]
[padding: 12px 24px]
[font: Inter 600, 16px]
[hover: opacity 0.9]
```

---

## Cards

Exactly five card types. No random cards.

### Event Card
```
[background: --y-surface (white)]
[radius: 16px]
[shadow: 0 1px 3px rgba(0,0,0,0.06)]
[padding: 24px]
[content: Event type badge | Title | Host identity | Date/Time | Venue | Topics]
```

### Professional Card
```
[background: --y-surface (white)]
[radius: 16px]
[shadow: 0 1px 3px rgba(0,0,0,0.06)]
[padding: 16px]
[content: Avatar | Name | Title | Company | Connection status]
```

### Venue Card
```
[background: --y-surface (white)]
[radius: 16px]
[shadow: 0 1px 3px rgba(0,0,0,0.06)]
[padding: 24px]
[content: Venue name | Address | Map | Events count]
```

### Conversation Card
```
[background: --y-surface (white)]
[radius: 16px]
[shadow: 0 1px 3px rgba(0,0,0,0.06)]
[padding: 16px]
[content: Avatar | Name | Last message preview | Time | Unread indicator]
```

### Analytics Card (Dashboard Widget)
```
[background: --y-surface (white)]
[radius: 16px]
[shadow: 0 1px 3px rgba(0,0,0,0.06)]
[padding: 24px]
[content: Metric label | Value | Trend indicator | Optional mini-chart]
```

---

## Inputs

### Text Input
```
[background: --y-surface]
[border: 1px solid --y-border]
[radius: 12px]
[padding: 12px 16px]
[font: Inter 400, 16px]
[focus: 2px solid --y-brand-primary ring]
[placeholder: --y-text-disabled]
[error: 1px solid --y-error]
[disabled: opacity 0.5]
[label: 14px Inter 500, above input]
```

### Search Input
```
[same as Text Input]
[icon: search (Lucide) on left, 20px]
[clear button on right when value present]
```

### Dropdown
```
[same as Text Input appearance]
[icon: chevron-down (Lucide) on right]
[options panel: --y-elevated, 12px radius, shadow, max-h 300px scroll]
```

### Date / Time Input
```
[same as Text Input appearance]
[icon: calendar / clock (Lucide) on right]
```

### Phone Input
```
[same as Text Input appearance]
[country code prefix: dropdown of flag + code]
```

### OTP Input
```
[6 individual boxes]
[48x56px each]
[12px radius]
[1px --y-border]
[center-aligned text, 24px Inter 700]
[focus: --y-brand-primary ring]
```

---

## Chips / Badges

### Status Chips

| Chip | Background | Text | Icon |
|------|-----------|------|------|
| **Official** | `--y-success` light | Emerald 700 | ✓ |
| **Community** | Slate 100 | Slate 700 | 👥 |
| **Networking** | Neutral 100 | Neutral 700 | 📍 |
| **Present** | Green 100 | Green 700 | ● |
| **Verified** | Emerald light | Emerald dark | ✓ |
| **Draft** | Grey 100 | Grey 600 | ○ |
| **Cancelled** | Red 100 | Red 700 | ✕ |

```
[radius: 9999px (full)]
[padding: 4px 12px]
[font: Inter 500, 12px]
[icon: 14px, left of text, 4px gap]
```

### Topic Chips
```
[background: --y-surface]
[border: 1px solid --y-border]
[radius: 9999px]
[padding: 4px 12px]
[font: Inter 400, 12px]
[color: --y-text-secondary]
```

---

## Dialogs

Exactly one dialog layout.

```
[overlay: rgba(0,0,0,0.4)]
[dialog: --y-elevated, 20px radius, max-w 480px, padding 32px]
[shadow: 0 20px 60px rgba(0,0,0,0.08)]
[header: 20px Inter 600, close X button]
[content: body text, 16px Inter 400]
[actions: Primary + Secondary button, right-aligned, 16px gap]
```

---

## Bottom Sheet

Exactly one bottom sheet layout.

```
[overlay: rgba(0,0,0,0.4)]
[sheet: --y-elevated, 20px top-radius, padding 24px]
[drag handle: 32px wide, 4px tall, --y-border, centered top]
[header: 18px Inter 600]
[content: scrollable, max-h 70vh]
[close: swipe down or tap overlay]
```

---

## Empty State

Exactly one empty state layout.

```
[layout: centered column, 64px gap from top]
[icon: 64px, --y-text-disabled]
[heading: 20px Inter 600, --y-text-primary]
[description: 16px Inter 400, --y-text-secondary, max-w 320px]
[action: Primary button]
```

Example:
```
       📭
  No upcoming events
  Create your first networking event
  [Create Event]
```

---

## Error State

Exactly one error state layout.

```
[layout: centered column, 64px gap from top]
[icon: 48px, --y-error]
[heading: 20px Inter 600, --y-text-primary]
[description: 16px Inter 400, --y-text-secondary]
[action: "Try Again" text button or Primary button]
```

---

## Skeleton Loading

Exactly one skeleton pattern. Never use spinners for content loading.

```
[base: linear-gradient(90deg, --y-surface 25%, --y-border 50%, --y-surface 75%)]
[animation: shimmer 1.5s infinite]
[background-size: 200px 100%]
[radius: 8px]

Variants:
- Text line: h 16px, w 60-100%
- Avatar: 48x48px, radius-full
- Card: h 120px, radius 16px
- Image: h 200px, radius 12px
```

```css
@keyframes shimmer {
  0% { background-position: -200px 0; }
  100% { background-position: calc(200px + 100%) 0; }
}
```

---

## Navigation

### Top Bar
```
[height: 56px]
[background: --y-surface]
[border-bottom: 1px solid --y-border]
[padding: 0 24px]
[content: Logo (left) | Search (center) | Actions (right)]
```

### Sidebar (Desktop)
```
[width: 240px]
[background: --y-surface]
[border-right: 1px solid --y-border]
[padding: 16px]
[items: 40px height, 12px radius, hover bg, active: 2px emerald left border]
```

### Bottom Tab Bar (Mobile)
```
[height: 56px]
[background: --y-surface]
[border-top: 1px solid --y-border]
[items: 5 max, icon + label, active: emerald]
```

---

## Avatars

```
S: 32px, radius-full
M: 40px, radius-full
L: 48px, radius-full
XL: 64px, radius-full

Fallback: initials on --y-brand-primary background, white text
```

---

## Dividers

```
[height: 1px]
[background: --y-border]
[margin: 16px 0]
```
