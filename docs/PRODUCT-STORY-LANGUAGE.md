---
Title: Yugrow Product Story Language
Version: 1.0
Status: Approved
Owner: Product
Last Updated: 2026-07-28
Dependencies: YUGROW-BRAND-LANGUAGE.md, YUGROW-DESIGN-LANGUAGE.md
Related Documents: YUGROW-FLOW-EXPERIENCE-SYSTEM.md, YUGROW-PRESENCE-MODEL.md
---

# Yugrow Product Story Language

> The story every screen tells. Not what the user does — what the user feels.

---

## Table of Contents

1. [Philosophy](#1-philosophy)
2. [The Yugrow Narrative](#2-the-yugrow-narrative)
3. [Website Story Arc](#3-website-story-arc)
4. [App Story Arc](#4-app-story-arc)
5. [Screen Stories](#5-screen-stories)
6. [Product Ecosystem Stories](#6-product-ecosystem-stories)
7. [Story Governance](#7-story-governance)

---

## 1. Philosophy

### What this document is

The Brand Language tells us *how* we speak. This document tells us *what* we say — and in what order.

Every screen, every flow, every interaction tells a story. If the story isn't clear, the screen will fail even if the UI is beautiful.

### Core principle

> The user should never wonder "why am I here?"

Every screen answers one question. The user should be able to state that question and its answer in under 10 seconds.

### Story arc pattern

Every interaction follows this emotional arc:

```
Curiosity → Understanding → Action → Satisfaction
```

| Stage | What the user feels | What the screen should do |
|-------|--------------------|--------------------------|
| Curiosity | "What is this?" | Hook with a clear visual or question |
| Understanding | "I see what this is for." | Explain in one sentence |
| Action | "I know what to do." | One clear primary action |
| Satisfaction | "That felt good." | Confirm with feedback (animation, copy) |

---

## 2. The Yugrow Narrative

### The founding story

> You attend hundreds of events.
> You collect business cards.
> You forget almost everyone.
>
> Imagine if every professional event became the start of a lasting relationship.
>
> That's Yugrow.

This is the story that drives everything. Every screen, every feature, every product traces back to this narrative.

### The three-act structure

```
ACT 1: The Problem
────────────────────
Professionals meet every day at events,
conferences, meetups, and expos.
But meaningful relationships disappear
after the event ends.
Business cards get lost.
Promising conversations go nowhere.
Opportunities vanish.

ACT 2: The Belief
────────────────────
Yugrow believes that every professional
interaction can become a trusted relationship —
if the right infrastructure exists.

Not a social network.
Not a CRM.
Not a business card scanner.

An operating system for professional presence.

ACT 3: The Solution
────────────────────
Yugrow creates verified professional presence.
CheckIn is the first product —
transforming physical events into
lasting professional relationships.
```

---

## 3. Website Story Arc

The website is the **front door** to the Yugrow ecosystem. A stranger should understand Yugrow in 30 seconds and want to download CheckIn.

### Story flow

```
┌─────────────────────────────────────────────┐
│                                             │
│  1. THE PROBLEM                             │
│  "You attend hundreds of events.            │
│   You remember almost nobody."              │
│                                             │
│  ↓                                          │
│                                             │
│  2. THE BELIEF                              │
│  "Every professional interaction            │
│   can become a lasting relationship."        │
│                                             │
│  ↓                                          │
│                                             │
│  3. PROFESSIONAL PRESENCE                   │
│  "Verified presence. Real connections.      │
│   Relationships that outlive the venue."     │
│                                             │
│  ↓                                          │
│                                             │
│  4. HOW CHECKIN WORKS                       │
│  "Create Event → Check In → Discover        │
│   → Connect → Continue."                    │
│                                             │
│  ↓                                          │
│                                             │
│  5. WHY YUGROW IS DIFFERENT                 │
│  "Verified attendance. Voluntary networking.│
│   Context preserved. Trust built."           │
│                                             │
│  ↓                                          │
│                                             │
│  6. THE ECOSYSTEM                           │
│  "CheckIn is the first product.             │
│   CRM, Broadcast, Builder — coming."         │
│                                             │
│  ↓                                          │
│                                             │
│  7. DOWNLOAD                                │
│  "Download CheckIn.                         │
│   Your next connection is waiting."          │
│                                             │
└─────────────────────────────────────────────┘
```

### What the website is NOT

- Not a feature list
- Not a pricing page (no pricing until Beta)
- Not a blog (separate section, future)
- Not a documentation portal

### One-liner that must be clear in the first 5 seconds

> "Yugrow turns real-world events into lasting professional relationships."

---

## 4. App Story Arc

The app is the experience. Every screen answers one question.

### The CheckIn journey

```
┌─────────────────────────────────────────────┐
│                                             │
│  WHO ARE YOU?                               │
│  → Welcome → Sign Up / Sign In              │
│                                             │
│  ↓                                          │
│                                             │
│  WHERE ARE YOU SHOWING UP?                  │
│  → Home — events near you                   │
│                                             │
│  ↓                                          │
│                                             │
│  WHO IS AROUND YOU?                         │
│  → Check In → Live Discovery                │
│                                             │
│  ↓                                          │
│                                             │
│  WHO DO YOU WANT TO CONTINUE WITH?          │
│  → Connect → Accept → Relationship Created  │
│                                             │
│  ↓                                          │
│                                             │
│  HOW DOES THIS RELATIONSHIP GROW?           │
│  → Conversations → Follow-up → Next Event   │
│                                             │
└─────────────────────────────────────────────┘
```

### The emotional journey

| App Stage | Question | Emotion | Visual |
|-----------|----------|---------|--------|
| Welcome | "Who are you?" | Curious | Minimal logo + tagline |
| Home | "What's happening?" | Anticipating | Event cards, count of professionals |
| Check In | "Where are you?" | Committing | Map pin, venue confirmation |
| Live | "Who is here?" | Discovering | Person cards ranked by relevance |
| Connect | "Who matters?" | Courageous | One tap, no friction |
| Connected | "What now?" | Satisfied | Chat opens, context preserved |

---

## 5. Screen Stories

Every screen tells a story. Here is the story for each primary screen in CheckIn.

### Welcome Screen

```
Question:   "Who are you?"
Story:      "You're a professional. This is where professionals connect."
Primary:    Sign up / Sign in
Emotion:    Inviting, confident
```

### Home Screen

```
Question:   "What's happening around me?"
Story:      "Events are happening near you. Professionals are gathering."
Primary:    Select an event
Emotion:    Anticipation, opportunity
Empty:     "You're early. Events near you will appear here."
```

### Check-in Screen

```
Question:   "Are you here?"
Story:      "You're at the venue. Declare your presence."
Primary:    "I'm Here" button
Emotion:    Commitment, excitement
Note:       This is the most important moment in the app.
```

### Live Discovery Screen

```
Question:   "Who is here right now?"
Story:      "These professionals are at this event. They're here to connect."
Primary:    View profile / Connect
Emotion:    Discovery, curiosity
Empty:     "You're early. Waiting for others to arrive."
```

### Profile Screen (other person)

```
Question:   "Who is this person?"
Story:      "This is a professional you could build a relationship with."
Primary:    Connect
Emotion:    Curiosity, evaluation
```

### Connection Request

```
Question:   "Do you want to connect?"
Story:      "This person met you at [Event]. They want to stay in touch."
Primary:    Accept / Decline
Emotion:    Flattering, intentional
```

### Connected Screen

```
Question:   "What now?"
Story:      "You're connected. The relationship starts here."
Primary:    Send a message
Emotion:    Satisfaction, new beginning
```

### Conversation Screen

```
Question:   "What do you want to say?"
Story:      "This is where relationships grow — one message at a time."
Primary:    Send message
Emotion:    Engagement, continuity
Empty:     "No messages yet. Say hello to start the conversation."
```

### Yugrow Chat (System Conversation)

```
Question:   "How do I reach Yugrow?"
Story:      "This is your direct line to the team behind the product.
             Ask questions. Report bugs. Suggest ideas.
             Every message is read. You'll hear back."
Primary:    Send message (text, screenshot, screen recording, logs)
Emotion:    Trust, partnership
Note:       Created automatically at onboarding completion.
            Not a support chat — a Product Relationship.
            Features: feedback cards, status updates, release notes,
            AI-assisted answers, human escalation.
            See FUTURE-BOUNDED-CONTEXTS.md — System Conversations.
```

### Profile Screen (self)

```
Question:   "Who am I here?"
Story:      "This is your professional identity. It travels with you to every event."
Primary:    Edit profile
Emotion:    Ownership, identity
```

---

## 6. Product Ecosystem Stories

### CheckIn (Phase 1 — current)

```
Story:  "The real-world networking product.
         Attend events. Meet professionals. Build relationships.
         The starting point for every Yugrow relationship."

Tagline: "Turn events into opportunities."
```

### CRM (Phase 5 — future)

```
Story:  "Your professional relationship manager.
         Not a sales CRM. A relationship CRM.
         Every connection, every conversation, every opportunity."

Tagline: "Manage relationships, not pipelines."
```

### Broadcast (Phase 4 — future)

```
Story:  "Share opportunities with your network.
         Not spam. Not noise. Opportunities your connections
         actually care about."

Tagline: "Share what matters with who matters."
```

### Builder (Future)

```
Story:  "Build your professional presence.
         Websites, content, portfolios — all connected
         to your Yugrow identity."

Tagline: "Your presence, everywhere."
```

---

## 7. Story Governance

### Rules

1. **Every screen must have a documented story** before implementation begins
2. The story answers: "Why does this screen exist for the user?"
3. If a screen's story can't be stated in one sentence, the screen doesn't need to exist
4. Stories are reviewed against the Brand Language before implementation
5. Empty states must follow the same story arc as the populated screen

### Review checklist

```
□ What question does this screen answer?
□ What does the user feel when they arrive?
□ What is the primary action?
□ What does the user feel after the action?
□ What does the empty state say?
□ Can the story be told in under 10 seconds?
□ Does this story belong to Yugrow? (Brand Language check)
```

### Story violations

If a screen's story conflicts with this document, the screen must change — not the document.

Examples of story violations:
- Adding a dashboard before the user has connected with anyone
- Showing analytics before the user has attended an event
- Asking for a review before the user has experienced value
