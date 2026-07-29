---
Title: First Meetup — Go/No-Go Checklist
Version: 1.0
Status: Living (update before each meetup)
Owner: Founder
Last Updated: 2026-07-28
---

# 🎯 First Meetup — Go/No-Go Checklist

> Complete this checklist **before** inviting anyone to the first real meetup.
> If any item is marked ❌, do **not** host the meetup until it is resolved.
> This is the production readiness gate for the First Independent Success milestone.

---

## 1. Build Health

| # | Check | Status | Notes |
|---|-------|--------|-------|
| 1.1 | `pnpm install` completes without errors | ⬜ | |
| 1.2 | `flutter pub get` completes without errors | ⬜ | |
| 1.3 | `prisma generate` completes without errors | ⬜ | |
| 1.4 | `prisma migrate status` shows no pending migrations | ⬜ | |
| 1.5 | TypeScript compiles (`pnpm build`) without errors | ⬜ | |
| 1.6 | `flutter analyze` passes with zero errors | ⬜ | |
| 1.7 | `flutter build web` succeeds | ⬜ | |
| 1.8 | `flutter build apk --debug` succeeds | ⬜ | |
| 1.9 | No stale caches (clean build verified) | ⬜ | |

---

## 2. Server Health

| # | Check | Status | Notes |
|---|-------|--------|-------|
| 2.1 | Docker containers are running | ⬜ | |
| 2.2 | Database is accessible | ⬜ | |
| 2.3 | API starts without errors | ⬜ | |
| 2.4 | Swagger docs load at `/api/docs` | ⬜ | |
| 2.5 | Health endpoint returns 200 | ⬜ | |
| 2.6 | CORS configured for all expected origins | ⬜ | |
| 2.7 | Rate limiting is active | ⬜ | |
| 2.8 | No 500 errors on any endpoint | ⬜ | |
| 2.9 | No 404 errors on any endpoint | ⬜ | |

---

## 3. Infrastructure & Network

| # | Check | Status | Notes |
|---|-------|--------|-------|
| 3.1 | API accessible from mobile devices on same LAN | ⬜ | |
| 3.2 | Flutter Web accessible from other devices | ⬜ | |
| 3.3 | All expected ports are open (3000, 3001, 3002, 3003) | ⬜ | |
| 3.4 | No firewall blocking mobile API calls | ⬜ | |
| 3.5 | Internet connectivity confirmed (not just localhost) | ⬜ | |

---

## 4. Authentication

| # | Check | Status | Notes |
|---|-------|--------|-------|
| 4.1 | Signup flow completes end-to-end | ⬜ | |
| 4.2 | Login flow completes end-to-end | ⬜ | |
| 4.3 | JWT token is issued and stored | ⬜ | |
| 4.4 | Token persists across app restarts | ⬜ | |
| 4.5 | Logout clears session correctly | ⬜ | |
| 4.6 | Login again after logout works | ⬜ | |
| 4.7 | Error messages for invalid credentials are helpful | ⬜ | |

---

## 5. Onboarding

| # | Check | Status | Notes |
|---|-------|--------|-------|
| 5.1 | Onboarding screen appears after signup | ⬜ | |
| 5.2 | Step 1 (Name) saves correctly | ⬜ | |
| 5.3 | Step 2 (Company + Role) saves correctly | ⬜ | |
| 5.4 | Step 3 (City + Interests) can be skipped | ⬜ | |
| 5.5 | Onboarding completion redirects to home | ⬜ | |
| 5.6 | Profile reflects onboarding data | ⬜ | |
| 5.7 | Onboarding cannot be re-triggered | ⬜ | |

---

## 6. Event Creation

| # | Check | Status | Notes |
|---|-------|--------|-------|
| 6.1 | Create Event button is visible and tappable | ⬜ | |
| 6.2 | Event name field accepts input | ⬜ | |
| 6.3 | Venue search returns results | ⬜ | |
| 6.4 | New venue can be created if not found | ⬜ | |
| 6.5 | Event appears in event list after creation | ⬜ | |
| 6.6 | Event details screen loads correctly | ⬜ | |
| 6.7 | Event time display is correct and localised | ⬜ | |

---

## 7. Check-In & Discovery

| # | Check | Status | Notes |
|---|-------|--------|-------|
| 7.1 | Check-In button is visible when event is live | ⬜ | |
| 7.2 | Workspace selection works during check-in | ⬜ | |
| 7.3 | Presence is recorded correctly | ⬜ | |
| 7.4 | Live screen shows attendees after check-in | ⬜ | |
| 7.5 | Discovery (People tab) loads attendee list | ⬜ | |
| 7.6 | Profile preview opens for other attendees | ⬜ | |

---

## 8. Connection & Conversation

| # | Check | Status | Notes |
|---|-------|--------|-------|
| 8.1 | Send Connection Request works | ⬜ | |
| 8.2 | Accept Connection Request works | ⬜ | |
| 8.3 | Conversation opens after connection | ⬜ | |
| 8.4 | Messages send and display correctly | ⬜ | |
| 8.5 | Timestamps display correctly | ⬜ | |
| 8.6 | Keyboard does not break layout | ⬜ | |
| 8.7 | Network tab shows connected people | ⬜ | |

---

## 9. System Conversation (Yugrow Chat)

| # | Check | Status | Notes |
|---|-------|--------|-------|
| 9.1 | Yugrow conversation appears after onboarding | ⬜ | |
| 9.2 | Welcome message is displayed | ⬜ | |
| 9.3 | Yugrow conversation is pinned at top | ⬜ | |
| 9.4 | Professional can send feedback messages | ⬜ | |
| 9.5 | Messages appear in the conversation | ⬜ | |

---

## 10. Founder Console

| # | Check | Status | Notes |
|---|-------|--------|-------|
| 10.1 | Founder Console is accessible (long-press or debug route) | ⬜ | |
| 10.2 | API health check shows connected | ⬜ | |
| 10.3 | Events list loads correctly | ⬜ | |
| 10.4 | Test event can be created | ⬜ | |
| 10.5 | Test attendees can be seeded | ⬜ | |
| 10.6 | Presence can be cleared | ⬜ | |
| 10.7 | Feedback Inbox loads and shows messages | ⬜ | |
| 10.8 | Founder reply as Yugrow works | ⬜ | |
| 10.9 | Release note can be sent | ⬜ | |
| 10.10 | Announcement can be sent | ⬜ | |
| 10.11 | Feedback status can be sent | ⬜ | |

---

## 11. UI & UX Final Review

| # | Check | Status | Notes |
|---|-------|--------|-------|
| 11.1 | No dead buttons or placeholder actions visible | ⬜ | |
| 11.2 | All empty states use Illustration Language | ⬜ | |
| 11.3 | Error messages are helpful, not technical | ⬜ | |
| 11.4 | Loading states exist on all async actions | ⬜ | |
| 11.5 | Typography is consistent across all screens | ⬜ | |
| 11.6 | Spacing and padding are consistent | ⬜ | |
| 11.7 | Colour usage follows Design Language | ⬜ | |
| 11.8 | Dark mode does not break any screen | ⬜ | |
| 11.9 | Touch targets are large enough on mobile | ⬜ | |
| 11.10 | No console errors in browser dev tools | ⬜ | |

---

## 12. Performance Benchmarks

| # | Check | Target | Measured | Status |
|---|-------|--------|----------|--------|
| 12.1 | Signup | < 2 seconds | ⬜ | ⬜ |
| 12.2 | Login | < 1.5 seconds | ⬜ | ⬜ |
| 12.3 | Create Event | < 1 second | ⬜ | ⬜ |
| 12.4 | Venue Search | < 1 second | ⬜ | ⬜ |
| 12.5 | Open Chat | < 500 ms | ⬜ | ⬜ |
| 12.6 | Send Message | < 500 ms | ⬜ | ⬜ |
| 12.7 | Profile Load | < 1 second | ⬜ | ⬜ |

---

## 13. Backup & Recovery

| # | Check | Status | Notes |
|---|-------|--------|-------|
| 13.1 | Database backup taken before meetup | ⬜ | |
| 13.2 | Known rollback procedure documented | ⬜ | |
| 13.3 | Founder can reset demo data if needed | ⬜ | |
| 13.4 | Offline/network error handling tested | ⬜ | |

---

## 14. Final Go/No-Go Assessment

| Criteria | Status |
|----------|--------|
| All P0 items are ✅ | ⬜ |
| All P1 items are ✅ | ⬜ |
| All server health items are ✅ | ⬜ |
| All authentication items are ✅ | ⬜ |
| All journey items are ✅ | ⬜ |
| All Founder Console items are ✅ | ⬜ |

**Decision:** ⬜ **GO** / ⬜ **NO-GO**

**Signed off by:**

| Role | Name | Date |
|------|------|------|
| Founder | | |

---

## Instructions for use

1. Print or open this checklist on a device separate from the demo device.
2. Go through every item in order. Do not skip sections.
3. Mark each item ✅ (pass), ❌ (fail), or ⬜ (not tested).
4. If any P0 item is ❌, the meetup is **NO-GO** until it's resolved.
5. If any P1 item is ❌, assess impact. If it blocks the user journey, it's **NO-GO**.
6. Document any ⬜ items and why they were skipped.
7. Only mark **GO** when every mandatory item is ✅.
8. After the meetup, return to this checklist and note what broke or surprised you.
