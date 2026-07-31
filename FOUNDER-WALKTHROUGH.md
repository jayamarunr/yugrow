# Founder Walkthrough Checklist

> **Purpose:** Verify every release candidate before sharing with testers or the public.
> **Rule:** Run this before every release. If any step fails or confuses, record it in CUSTOMER-EVIDENCE.md and fix before shipping.

---

## Before You Start

- [ ] Build the APK (`flutter build apk --debug`)
- [ ] Install on physical Android device (not emulator)
- [ ] Clear app data / fresh install
- [ ] Open stopwatch
- [ ] You are a **stranger** who has never seen Yugrow before

---

## Walkthrough

### 1. Launch

| Step | Expected | Time | Issues |
|------|----------|------|--------|
| Tap app icon | App launches within 5 seconds | — | — |
| Splash screen | Visible, branded, ≤2s | — | — |
| First screen | Login or landing page | — | — |

### 2. Signup

| Step | Expected | Time | Issues |
|------|----------|------|--------|
| Tap "Create Account" | Navigates to signup form | — | — |
| Enter name | Field responds immediately | — | — |
| Enter email | Field validates format | — | — |
| Enter password | Password visible/toggle works | — | — |
| Submit | Loading state shown, then OTP screen | — | — |
| Enter OTP | Auto-advances or manual submit works | — | — |
| Profile creation | Photo + company + role + interests | — | — |
| **Total signup time** | — | — | — |

**Hesitations / Confusions:**

### 3. Login

| Step | Expected | Time | Issues |
|------|----------|------|--------|
| Enter email + password | Fields clear, keyboard works | — | — |
| Tap "Login" | Loading state, then dashboard | — | — |
| **Total login time** | — | — | — |

**Hesitations / Confusions:**

### 4. Home / Events

| Step | Expected | Time | Issues |
|------|----------|------|--------|
| Dashboard loads | Events visible or empty state | — | — |
| Empty state | Helpful message + action button | — | — |
| Scroll events | Smooth, no jank | — | — |
| Tap an event | Event detail opens | — | — |
| Event detail | Hero, description, metadata, CTA visible | — | — |

**Hesitations / Confusions:**

### 5. Create Event

| Step | Expected | Time | Issues |
|------|----------|------|--------|
| Tap "Create Event" | Form opens | — | — |
| Fill event name | Field works | — | — |
| Set date/time | Date picker works | — | — |
| Search venue | Results appear (or create venue) | — | — |
| Set description | Text area works | — | — |
| Submit | Event created, visible on dashboard | — | — |
| **Total create time** | — | — | — |

**Hesitations / Confusions:**

### 6. Check-in / Live

| Step | Expected | Time | Issues |
|------|----------|------|--------|
| Open event | Detail page loads | — | — |
| "I'm Here" button | Visible and tappable | — | — |
| Tap "I'm Here" | Processing state, then confirmation | — | — |
| Check-in confirmation | Celebration screen | — | — |
| Live tab | Shows active presence | — | — |

**Hesitations / Confusions:**

### 7. Network / Discovery

| Step | Expected | Time | Issues |
|------|----------|------|--------|
| Open Network tab | Shows professionals | — | — |
| View a profile | Profile card with details | — | — |
| Send connection request | Request sent confirmation | — | — |

**Hesitations / Confusions:**

### 8. Messages

| Step | Expected | Time | Issues |
|------|----------|------|--------|
| Open Messages tab | Conversations list | — | — |
| Open a conversation | Chat history loads | — | — |
| Send a message | Message appears, sent indicator | — | — |
| Receive a message | Notification or badge | — | — |

**Hesitations / Confusions:**

### 9. Profile

| Step | Expected | Time | Issues |
|------|----------|------|--------|
| Open Profile tab | Profile screen with data | — | — |
| Edit profile | Edit screen opens, saves correctly | — | — |
| Logout | Confirmation, then login screen | — | — |

**Hesitations / Confusions:**

---

## Summary

| Metric | Value |
|--------|-------|
| **Total walkthrough time** | — |
| **Hesitations recorded** | — |
| **Critical issues** | — |
| **Minor issues** | — |
| **Ideas generated** | — |

## Verdict

- [ ] **PASS** — Ready for independent user testing
- [ ] **CONDITIONAL** — Fix critical issues before sharing
- [ ] **FAIL** — Do not distribute this build

---

## Rules for Future Releases

1. Run this checklist before EVERY release candidate
2. Time every action with a stopwatch
3. Write down every hesitation — if you paused to think, it's a design issue
4. If three friends have the same confusion, it's not their fault — it's the product's
5. Record all findings in `CUSTOMER-EVIDENCE.md`
