---
Title: Founder Decisions
Version: 1.0
Status: Active
Owner: Founder
Last Updated: 2026-07-22
Related Documents:
  - PLATFORM-CONSTITUTION.md
  - DECISIONS.md
  - YUGROW-DESIGN-PRINCIPLES.md
  - THE-FOUNDER-TEST.md
---

# Founder Decisions

> **Irreversible product decisions that define how Yugrow thinks.**
>
> Not architecture. Not implementation. Principles that every engineer, designer, and future teammate must understand before making product decisions.
>
> New engineers should read 20–30 of these and immediately understand how Yugrow thinks.

---

### FD-001 — Presence is earned, not declared.

A user becomes visible only after physically arriving at the venue. "I'm Here" is not a button tap — it's a location-verified signal. This protects the trust model of the entire platform.

### FD-002 — Relationships are permanent. Presence is temporary.

A connection outlasts every event. The relationship graph is immutable — once two people connect, that relationship exists regardless of where they go next. Presence auto-expires when the event ends.

### FD-003 — Every interaction must move a business relationship forward.

If an interaction doesn't help someone discover, connect, or grow a business relationship, it doesn't belong in Yugrow. This is the filter for every feature, screen, and notification.

### FD-004 — Users discover events from anywhere. Users become visible only at the venue.

Discovery has no distance limit. Presence has a physical boundary. These are separate concerns and must never be coupled.

### FD-005 — One tap to connect. No forms, no reasons, no messages.

Connection requests carry zero friction. The context (event, venue, time) is captured automatically. Asking for intent before connecting creates hesitation, and hesitation kills the magic moment.

### FD-006 — Context is automatic, never manual.

The system captures where, when, and how a relationship began. Users never fill in "where did we meet?" — the product already knows. Auto-context is a trust feature, not a convenience feature.

### FD-007 — Every feature must earn its place in the first five minutes.

If a new feature doesn't improve the first five minutes of a first-time user's experience, it doesn't ship in the current release. First impressions compound — getting them right is more important than any advanced feature.

### FD-008 — Never ask the user to invent the first conversation.

The problem isn't empty UI — it's networking anxiety. Every message entry point must surface context (how you met, shared interests, conversation starters) before the user has to think of what to say. The first message helper is not a feature; it's a psychological necessity.

### FD-009 — Every relationship must earn its place in the next five years.

Yugrow optimizes for long-term relationship value, not short-term engagement. Features that boost DAU at the cost of trust are rejected. A user who achieves their goal in 30 seconds and closes the app is a success.

### FD-010 — People before data.

Profiles, conversations, and relationships come before dashboards, analytics, and reports. When a user opens Yugrow, they see people first. Charts are secondary. Always.

### FD-011 — Design around people, not software.

The primary interface is human: "Raj · Founder · Met 2 hours ago · 3 mutual connections · Say Hello." Not "Revenue · Charts · Pipeline · Tasks." Yugrow is a relationship OS, not a CRM with networking features.

### FD-004 — There will never be a "Connect All" button.

Every connection requires intentional human action. One tap per person. No bulk requests, no auto-invites, no spam. This one decision alone makes Yugrow feel different from every networking platform.

### FD-005 — Quality over quantity.

Don't show 846 people. Show the 20 most relevant. A feed of 8 million users is worthless. A list of 5 people worth meeting is invaluable. Ranking is by relevance — mutual connections, shared industry, shared interests, recent arrival — never by popularity.

### FD-006 — Presence expires naturally.

A user's presence lasts 60 minutes. If the app detects they're still at the venue (foreground, location, or a simple "Still here?" prompt), extend automatically. If they leave, presence ends. The user never manages a timer — Yugrow reflects reality.

### FD-007 — The 90-Day Rule.

For the next 90 days, every feature must answer: "Does this help someone discover or grow a valuable business relationship?" If yes, build it. If maybe later, backlog it. This protects the core mission from feature gravity.

### FD-008 — Build memories, not software.

Every screen should answer: "What memory will this create?" Arrival → "I knew exactly where to go." Become Visible → "Now people can discover me." Live → "I found someone I wouldn't have met otherwise." Connect → "That was effortless." Chat → "The conversation didn't end when the event ended."

### FD-010 — Broadcast is relationship maintenance, not discovery.

Before connection: show only name, title, company, mutual connections, relevance reason. No broadcast history, no feed. After connection: broadcast graduates to "Recent Opportunities" — a conversation starter. Exposing broadcasts before connecting lets people decide "I already know enough" without ever connecting. One exception: a subtle "Recently active" badge as a trust signal. No numbers, no feed.

### FD-011 — Every profile must answer "Why should I meet this person?" within five seconds.

Not their life story. Not their résumé. Not their LinkedIn. Just: why should I walk over and introduce myself? This principle influences every profile, every AI summary, every recommendation, every broadcast.

### FD-012 — Every waiting state must reassure the user.

Connection pending, check-in processing, event loading, uploading — the user should never wonder "Did it work?" They should always know "It's happening." Every waiting state must communicate progress, expected duration, or next steps. Silence is the enemy of trust.

### FD-013 — Quality of relationships beats quantity of requests.

There will never be a "Message All" or "Connect All" button. Yugrow optimizes for meaningful connections, not volume. Every interaction requires intentional human action. Daily Introductions cap at 3 — because humans can't meaningfully continue 70 conversations.

### FD-014 — Context must be explicit, never inferred.

Every icon, badge, and status must answer one question without guessing. "Checked in" not a green dot. "Looking for partnerships" not "Fintech leader." "Replied 3 days ago" not a gray indicator. If a user has to wonder what it means, the design failed.

### FD-015 — The event must feel alive even when the user does nothing.

Yugrow is a digital layer on top of a physical event. It reveals what's already happening — people arriving, leaving, moving through the room — without the user refreshing, pulling, or searching. Presence changes. Counts shift. Time ticks. Rankings reorder. Not through animations or noise, but through subtle, meaningful updates that remind the user: *you're at a live event.* If the app is static, the experience is broken.

### FD-016 — (reserved)

### FD-017 — The source of every piece of information must be obvious.

Information can come from only four places: the user, their organization, Yugrow AI, or a live broadcast. Never mix them. A "Looking for" field must clearly show it came from the user. An AI match must say "Recommended because" — never pretend to be user-generated. A broadcast must show a pulse icon and timestamp. If a user has to wonder who is saying something, the design failed.

---

*Decisions are numbered sequentially. New decisions are added as the product evolves. Decisions are never deleted — only superseded by later decisions with clear rationale.*
