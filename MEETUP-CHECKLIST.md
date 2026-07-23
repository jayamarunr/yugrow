# Yugrow Meetup Checklist

> **One goal:** First real relationship created through Yugrow at a live event.
>
> Everything else is secondary. If someone makes a connection they wouldn't have made otherwise, the meetup is a success.

---

## Before Leaving

- [ ] **API running** — `GET /checkin/test/status` returns 200
- [ ] **Database healthy** — No connection errors, schema up to date
- [ ] **Founder Console tested** — Long-press Y logo from Arrival screen
- [ ] **Event created** — Create via Founder Console, verify it appears on Arrival screen
- [ ] **Seed data verified** — Seed 20 attendees, check banner appears
- [ ] **Banner visible** — Amber "Founder Mode" banner shows correct counts
- [ ] **Reset tested** — Reset demo data, banner disappears
- [ ] **Duplicate tested** — Duplicate an event, verify it works
- [ ] **Phone charged** — Bring a power bank
- [ ] **Network verified** — Test on mobile data (not just local Wi-Fi)

---

## Before Attendees Arrive

- [ ] **Create today's event** — Use Founder Console, set visibility to PUBLIC
- [ ] **Verify event is ACTIVE** — Check status in Founder Console
- [ ] **Check in to the event yourself** — Open Yugrow, tap "I'm Here"
- [ ] **Browse Live** — Verify you can see yourself in the attendee list
- [ ] **Seed 20 attendees** (optional — only if you want the room to look busy)
- [ ] **Verify banner appears** — Amber bar confirms seeded data is active
- [ ] **Verify counts** — Founder Console dashboard shows correct real vs seeded
- [ ] **Walk through the demo flow** — Open → Browse → Profile → Connect → Chat
- [ ] **Reset phone cache** if testing on a shared device

---

## During the Meetup

- [ ] **Watch, don't explain** — Let people discover the UI. Note where they hesitate.
- [ ] **Write observations** — Capture in `LEARNINGS.md` or a notebook:
  - Where do users tap first?
  - Where do they pause?
  - What do they ask about?
  - What do they ignore?
- [ ] **Take screenshots** (with permission) — Screen recordings are even better
- [ ] **Note hesitation points** — Every pause is a UX improvement opportunity
- [ ] **Count real check-ins** — How many people actually open Yugrow and check in?
- [ ] **Count connections** — How many connection requests are sent/accepted?
- [ ] **Count conversations** — How many messages are exchanged?
- [ ] **Don't fix bugs during the event** — Just observe. Fixes come after.
- [ ] **Have a backup plan** — If the API goes down, can you demo the flow from screenshots?

---

## After the Meetup

- [ ] **End the event** — In Founder Console: tap [End] on today's event
- [ ] **Export observations** — Write everything down while it's fresh
- [ ] **Reset demo data** — In Founder Console: tap "Reset Demo Data"
- [ ] **Verify banner disappears** — No seeded data remains
- [ ] **Update `LEARNINGS.md`** — Capture every insight, hesitation, and surprise
- [ ] **Review screenshots** — Identify 3 things to improve first
- [ ] **Answer the six questions:**
  1. Could 30 people check in?
  2. Did presence feel alive?
  3. Did Quick Connects happen?
  4. Did people understand "Looking For"?
  5. Did anyone use the first message?
  6. Did anyone return after the event?
- [ ] **Update `MILESTONES.md`** if any milestones were reached

---

## Dress Rehearsal (Run This Before the Real Meetup)

```
1. Create a test event
2. Seed 20 attendees
3. Check in as yourself
4. Browse the Live screen
5. Connect with a seeded attendee
6. Send a message
7. End the event
8. Reset demo data
9. Duplicate the event
10. Repeat until the entire sequence feels fluid
```

---

## Founder Console Reference

| Action | Location | Notes |
|--------|----------|-------|
| Open Founder Console | Long-press Y logo on Arrival screen | — |
| Create event | Founder Console → Create Test Event | Fills today 6-9 PM |
| Edit event | Event tile → [Edit] | Change name, visibility |
| End event | Event tile → [End] | Expires event + all presence |
| Duplicate event | Event tile → [Duplicate] | Clones with today's date |
| Seed attendees | Event tile → [Seed] or Test Data section | Creates 20 professionals |
| Clear presence | Test Data → Clear All Presence | Ends all active presence |
| Reset demo data | Test Data → Reset Demo Data | Removes all seeded persons |
| View dashboard | Founder Console → Current Event section | Shows real vs seeded counts |

---

## Emergency Commands

If the app is misbehaving at the venue:

```bash
# Expire all active presence (remote via API)
curl -X POST http://<server>:4000/api/v1/checkin/test/clear-presence

# Full reset
curl -X POST http://<server>:4000/api/v1/checkin/test/reset

# Check status
curl http://<server>:4000/api/v1/checkin/test/status
```

---

## What Success Looks Like

> Someone at the meetup opens Yugrow, discovers a person they wouldn't have met otherwise, connects, and continues the conversation after the event.

If that happens once, the meetup is a success.

Track it in `MILESTONES.md`:

```
✓ First Event
✓ First Real Check-in
✓ First Connection
✓ First Conversation
✓ First Relationship Continued After Event
```
