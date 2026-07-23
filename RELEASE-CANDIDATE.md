---
Title: Yugrow Alpha Release Candidate
Version: 0.1.1-alpha
Status: Ready for Testing
Date: 2026-07-23
Build: v0.1.1-data-foundation
---

# Yugrow Alpha Release Candidate

## Feature Checklist

### Core Flow
| Feature | Status | Notes |
|---------|--------|-------|
| App Launch | ✅ | Splash → Arrival screen |
| Auth / Login | ✅ | OTP flow with demo mode (any 4-digit code works) |
| Event Discovery | ✅ | Active events loaded from API |
| Event Detail | ✅ | Venue, schedule, people breakdown |
| Check-in ("I'm Here") | ✅ | Presence created with 60-min window |
| Live Presence | ✅ | Real-time list of checked-in attendees |
| Discovery (Professionals) | ✅ | API-backed with title, company, industry, skills, lookingFor |
| Profile View | ✅ | Lightweight business intro |
| Quick Connect | ✅ | One-tap connection request |
| Connection Accept | ✅ | Simulated acceptance |
| First Message | ✅ | Conversation starters |
| Conversations | ✅ | Message list and send |
| Presence Expiry | ✅ | 60-minute auto-expiry |
| Profile Screen | ⚠️ | Basic — uses API data |

### Edge Cases
| Scenario | Status | Notes |
|----------|--------|-------|
| Empty state (no events) | ✅ | Graceful "No events nearby" |
| Empty state (no attendees) | ✅ | "No one else here yet" |
| Network failure | ⚠️ | Falls back to empty lists — no crash, but no retry UI |
| Offline mode | ❌ | No offline support in v1 |
| Long event names | ⚠️ | May overflow on small screens |
| Rapid check-in/check-out | ✅ | Presence engine handles multiple events |

### UI/UX
| Aspect | Status | Notes |
|--------|--------|-------|
| Typography | ✅ | Inter font, Yugrow Design Kit tokens |
| Spacing | ✅ | Consistent padding |
| Dark mode | ✅ | Full dark theme |
| Bottom navigation | ✅ | 4 tabs: Live, Connections, Messages, Profile |
| Animations | ✅ | Connection accepted, check-in success |
| Haptics | ✅ | Light/medium/heavy on key interactions |
| Accessibility | ⚠️ | No VoiceOver/TalkBack labels yet |

---

## Known Limitations

| # | Issue | Impact | Planned Fix |
|---|-------|--------|-------------|
| 1 | Auth uses demo OTP — no real SMS provider | Cannot onboard real users at scale | Before public beta |
| 2 | No real push notifications | Users won't know about connection accepted | Before public beta |
| 3 | Profile screen shows hardcoded data | User cannot edit their own profile yet | Sprint 6.5 (data flows, UI pending) |
| 4 | Mock data in profile screen | Profile is just a static display | Next sprint |
| 5 | No organization profiles | Companies are not visible as entities | Sprint 8 |
| 6 | Connections screen shows "Coming after Sprint 7" | Users cannot view their relationship history | Sprint 10 |
| 7 | No offline support | App requires network connectivity | Future |
| 8 | No error retry UI | Network failures silently return empty | Sprint 6.6 |
| 9 | Debug screen only in debug builds | Not available in release APK | Intentional |

---

## Test Scenarios for Meetup

### Scenario 1: First-time User
```
1. Open app
2. See nearby events
3. Tap an event → see details
4. Tap "I'm Here"
5. See "You're now visible" confirmation
6. See list of professionals
7. Tap a profile → view
8. Tap Connect
9. See "Request sent"
10. Navigate to Connections tab → see placeholder
```

### Scenario 2: Live Discovery
```
1. Check in to an event
2. Scroll through the Live list
3. Observe: does each card answer WHO, WHY, WHY NOW?
4. Tap a card with mutual connections
5. Tap a card with intent match (lookingFor)
6. Send a connection request
7. Check if the flow feels fast (< 2 seconds per action)
```

### Scenario 3: Post-Connection
```
1. Send a connection request
2. Receive/accept a connection
3. See "Say Hello" prompt
4. Send a first message
5. Continue the conversation
6. Leave the event
7. Observe presence expiry
```

---

## Go / No-Go Recommendation

**✅ GO for alpha testing**

The app is stable, has 0 compile errors, all core flows work end-to-end, and data comes from the API (not mock data). Known limitations are documentable and acceptable for a 20-person meetup test.

**Conditions:**
1. Demo data must be pre-seeded (venues, events, users with professional identities)
2. Testers should be told this is alpha software
3. A note-taker should observe and record observations
4. The debug screen (long-press Yugrow logo) should be used if anything fails

---

## Build Output

- **Android APK:** `flutter build apk --debug`
- **iOS (if provisioned):** `flutter build ios --debug --no-codesign`
- **Backend:** `pnpm dev` with seeded test database

---

## Post-Meetup Questions

1. Did everyone understand "I'm Here" without explanation?
2. Did anyone hesitate before sending a connection? Why?
3. Did people understand why someone was recommended (lookingFor, mutual connections)?
4. How many meaningful conversations started?
5. What was the first question people asked?
6. Where did people get stuck or confused?
7. Would they use it again at another event?
