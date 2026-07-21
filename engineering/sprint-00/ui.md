---
Sprint: 0
Title: UI Architecture
Owner: Frontend Architect
---

# Sprint 0 — UI Architecture

> Sprint 0 establishes the frontend framework and component library.
> No business pages yet — only a login placeholder and dashboard shell.

## Pages

| Route | Page | Status |
|-------|------|--------|
| `/login` | Login page | ⏳ |
| `/dashboard` | Dashboard shell with navigation | ⏳ |
| `/` | Redirect to dashboard | ⏳ |

## Component Tree (Sprint 0)

```
App
└── AuthLayout
    └── LoginPage
        ├── Logo
        ├── EmailInput
        ├── PasswordInput
        └── SubmitButton

App
└── DashboardLayout
    ├── Sidebar (navigation)
    │   ├── Logo
    │   ├── NavItem (Dashboard)
    │   ├── NavItem (CRM) — future
    │   ├── NavItem (Websites) — future
    │   └── NavItem (Settings) — future
    ├── TopBar
    │   ├── SearchInput
    │   ├── NotificationsBell
    │   └── UserMenu
    └── MainContent
        └── DashboardPage
            ├── WelcomeCard
            ├── StatsGrid (placeholder)
            └── RecentActivity (placeholder)
```

## Design Tokens (Tailwind)

```css
/* Color scheme */
--primary: indigo-600
--primary-hover: indigo-700
--surface: white
--background: gray-50
--text: gray-900
--text-secondary: gray-500
--border: gray-200
--error: red-600
--success: green-600

/* Typography */
--font-sans: Inter, system-ui, sans-serif
--font-mono: JetBrains Mono, monospace

/* Spacing */
--sidebar-width: 260px
--topbar-height: 64px
```

## Component Library

Using **Shadcn/ui** (Radix UI primitives + Tailwind):

- Button, Input, Label, Card, Badge
- Avatar, Dropdown Menu, Sheet (mobile nav)
- Table, Dialog, Toast
- Skeleton (loading states)

## State Management

- **Server state**: React Query / TanStack Query for all API data
- **Auth state**: React context + JWT stored in httpOnly cookies
- **UI state**: React state and context for theme, sidebar, modals

## Key Behaviors

- Loading states: Skeleton components on all data-dependent sections
- Error states: Error boundaries + toast notifications
- Empty states: Illustrative empty state components
- Responsive: Mobile-first, sidebar collapses on small screens
