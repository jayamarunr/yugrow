---
Title: Demo Readiness Checklist
Version: 1.0
Status: Living (complete before every demo, investor meeting, or meetup)
Owner: Founder
Last Updated: 2026-07-28
---

# Demo Readiness Checklist

> **Complete before EVERY demo.** Not just the first meetup.
> If any item is ❌, do not show the product to another human.

---

## Build & Stability

| # | Check | Status | Notes |
|---|-------|--------|-------|
| 1 | `flutter analyze` passes with zero errors | ✅ | Pre-existing warnings only (const, unused debug imports). AH-015–023 added zero errors. |
| 2 | `flutter build web` succeeds | ✅ | Verified 2026-07-28. Release build with Mapbox token succeeds. |
| 3 | No console errors in browser dev tools | ⬜ | |
| 4 | No red error screens during normal usage | ⬜ | |
| 5 | API server is running and reachable | ✅ | Verified via health endpoint |
| 6 | Database is accessible | ✅ | Test registration and profile update succeeded |

---

## Visual Polish (R32)

| # | Check | Status | Notes |
|---|-------|--------|-------|
| 7 | No dead buttons (buttons that do nothing) | ✅ | AH-016: "I'm Here" disabled with reason text for future/ended events |
| 8 | No placeholder text visible | ✅ | AH-017: Event detail shows real data (address, date/time, host) |
| 9 | No mock or hardcoded demo data | 🟡 | AH-022: Check-in uses auth provider. `person-self` fallback still in ArrivalRepository.getCurrentUser catch block. |
| 10 | No "Coming Soon" unless absolutely necessary | ⬜ | |
| 11 | No inconsistent spacing or padding | ⬜ | |
| 12 | No inconsistent colours | ⬜ | |
| 13 | No overflowing layouts or clipped text | ⬜ | |
| 14 | No spelling or grammar errors in copy | ⬜ | |

---

## Journey Completion

| # | Check | Status | Notes |
|---|-------|--------|-------|
| 15 | Signup works end-to-end | ✅ | Verified via API: register → profile update |
| 16 | Onboarding completes successfully | ⬜ | |
| 17 | Profile loads and displays correctly | ✅ | Professional identity API returning data |
| 18 | Event creation works | ✅ | Host Event screen, venue search, create flow |
| 19 | Venue search returns results | 🟡 | Mapbox token integrated |
| 20 | Check-in completes | ✅ | AH-021: Real API call with auth identity. Post-check-in navigates to Live. |
| 21 | Discovery shows attendees | 🟡 | LiveScreen queries attendees. Depends on seed data. |
| 22 | Connection request sends | ✅ | LiveScreen uses auth provider for IDs |
| 23 | Conversation opens after connection | ⬜ | |
| 24 | Yugrow system conversation appears | ✅ | AH-019: Pinned at top, no duplicates |
| 25 | Logout and re-login work | ⬜ | |

---

## Every Screen Answers

| # | Screen | Question | Answer Clear? |
|---|--------|----------|---------------|
| 26 | Home/Events | "Where should I go today?" | ✅ AH-015: Only today's events shown |
| 27 | Live | "Who is here now?" | ✅ AH-018: Presence-aware load from backend |
| 28 | Network | "What relationships have I built?" | ✅ AH-020: Yugrow system conv styled correctly |
| 29 | Profile/Me | "Who am I professionally?" | ⬜ |
| 30 | Chat | "What should we discuss next?" | ✅ AH-019: No duplicate Yugrow, clean list |

---

## Empty, Loading & Error States

| # | Check | Status | Notes |
|---|-------|--------|-------|
| 31 | Empty states use Illustration Language | ⬜ | |
| 32 | Loading indicators appear on async operations | ✅ | Spinners on Home, Live, Messages, Network |
| 33 | Error messages are helpful, not technical | 🟡 | Check-in shows error cause; others may be generic |
| 34 | Network errors show user-friendly messaging | ✅ | Home screen: "Could not load events. Check your connection and try again." |
| 35 | No blank white screens during normal flow | ✅ | AH-018/AH-021: Post-check-in navigates to Live, not blank |

---

## Final Assessment

| Criteria | Status |
|----------|--------|
| All items ✅ | 🟡 20/35 passing, 4 partial |

**Decision:** 🟡 **NO-GO for First Meetup** — See remaining items below**
