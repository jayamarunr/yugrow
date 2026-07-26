# Yugrow First Meetup Playbook

> **Objective:** Validate that verified professional presence creates meaningful professional relationships.
> 
> **Success signal:** `Event Created → 10 Check-ins → 7 Connection Requests → 5 Accepted → 18 Messages Exchanged`

---

## Before the Meetup

### Infrastructure Checklist

- [ ] Docker containers running (Postgres, Redis, RabbitMQ, MinIO)
- [ ] API server started (`pnpm dev` in `apps/api`)
- [ ] Database migrated (`prisma db push`)
- [ ] Mobile app built and accessible
- [ ] Venue created in Yugrow
- [ ] Event created in Yugrow

### Event Setup

- [ ] Create venue (coworking space, conference hall, etc.)
- [ ] Create event with correct date/time
- [ ] Verify venue geofence radius (default 100m)
- [ ] Generate and test invite link
- [ ] Test QR code if using printed materials
- [ ] Verify event appears in "Live" feed

### User Flow Verification

Run through the complete journey on a test device:

```text
Install → Sign Up → Onboarding → Home → Create Event
          ↓
     Another device → Sign Up → Home → Join Event → Check In
          ↓
     First device → Live → See attendee → Send Connection Request
          ↓
     Second device → Receive Request → Accept
          ↓
     Connected Screen → Start Conversation → Send Message
          ↓
     First device → Receive message → Reply
```

Every step must succeed before the event.

---

## During the Meetup

### Observation Protocol

**Do not explain the app.** Let people discover it naturally. Your job is to observe, not to teach.

| What to watch for | Why it matters |
|---|---|
| Where do people hesitate? | Identifies UX friction |
| Do they find the event? | Tests discovery flow |
| Does check-in work? | Tests presence verification |
| Do they browse other attendees? | Tests discoverability |
| Do they send requests? | Tests connection intent |
| How long until first message? | Tests conversation trigger |
| Do they ask for help? | Reveals missing affordances |

### What to record

Take notes on:

1. **First impression** — What's the first thing they say/do?
2. **Confusion points** — Where do they pause, frown, or ask questions?
3. **Delight moments** — Where do they smile, nod, or show surprise?
4. **Abandonment** — Where do they give up or switch to another app?
5. **Feature requests** — What do they *think* is missing? (vs what's actually missing)

---

## After the Meetup

### User Interviews

Ask every participant these five questions:

1. **What confused you?** — No leading, let them describe.
2. **What surprised you?** — This reveals delight and friction.
3. **What would you remove?** — Identifies unnecessary complexity.
4. **Would you use this again?** — The ultimate validation question.
5. **Would you recommend it to a colleague?** — Tests the referral loop.

### Metrics to Collect

| Metric | Target | Actual |
|---|---|---|
| Events created | 1 | |
| Total check-ins | 10 | |
| Connection requests sent | 7 | |
| Connection requests accepted | 5 | |
| Messages exchanged | 18 | |
| Total unique users | 10 | |
| Users who completed onboarding | N/A | |
| Users who created identity | N/A | |
| Avg time to first connection | — | |
| Venue creation success rate | — | |

### Retrospective

After collecting data, answer:

1. **What worked?** — Keep doing this.
2. **What didn't work?** — Fix before next meetup.
3. **What surprised us?** — Update assumptions.
4. **What should we build next?** — Let evidence, not intuition, decide.

---

## Emergency Procedures

| Problem | Solution |
|---|---|
| API down | `docker compose restart` then `pnpm dev` |
| Auth failing | Check JWT_SECRET in `.env`, restart API |
| Venue not found | Create venue via API or founder console |
| Check-in fails | Verify geofence radius, check GPS permissions |
| Messages not sending | Check `personId` in auth state, verify conversation API |
| App won't load | `flutter clean` then `flutter pub get` then rebuild |

---

## What to Build Next

After the meetup, let evidence decide. Do not plan the next sprint until you've analyzed observations.

**If venue search was the main friction:**
- Improve Nominatim geocoding
- Consider Mapbox evaluation
- Add more popular venues to Yugrow's database

**If onboarding/identity was the main friction:**
- Simplify profile completion
- Add Google Sign-In
- Reduce required fields further

**If conversation was the main friction:**
- Add push notifications
- Improve typing indicator
- Add image sharing

**If everything worked smoothly:**
- You've validated the core loop.
- Expand to the next meetup with more people.
- Add Broadcast (Phase 4).
