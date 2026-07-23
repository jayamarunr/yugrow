# First Independent Success Checklist

> **A stranger should be able to complete the entire journey without the founder's help.**
>
> Every item is binary. If a step requires founder intervention, the product isn't ready.

---

## Discovery

- ☐ Landing page explains Yugrow in under 60 seconds
- ☐ Public event pages are indexed by search engines
- ☐ Event pages have Open Graph previews (LinkedIn, WhatsApp, Twitter)
- ☐ Event pages are shareable via link
- ☐ Download links are prominently visible

## Authentication

- ☐ User can sign up with phone number (OTP)
- ☐ User can sign up with email + password
- ☐ User can sign in
- ☐ User can sign out
- ☐ Session persists across app restarts
- ☐ Error messages are helpful (not "Something went wrong")

## Onboarding

- ☐ New user understands what Yugrow is within 30 seconds of opening the app
- ☐ First-run experience guides user to complete their profile
- ☐ User understands the "I'm Here" concept without explanation

## Profile

- ☐ User can set their name
- ☐ User can set their headline/role
- ☐ User can set their company/workspace
- ☐ User can write a short bio
- ☐ User can add their website URL
- ☐ User can add their LinkedIn URL
- ☐ User can upload a profile photo
- ☐ User can set "Looking For" (investors, clients, partners, etc.)
- ☐ Profile changes save correctly

## Event Discovery

- ☐ User can see a list of upcoming events
- ☐ User can see event details (title, date, time, venue, description)
- ☐ User can search events by city or topic
- ☐ User can save/bookmark an event

## Event Hosting

- ☐ User can create an event
- ☐ User can set event type (Networking, Workshop, Conference, etc.)
- ☐ User can add topics
- ☐ User can set date, time, timezone
- ☐ User can set venue (search or create)
- ☐ User can set event description
- ☐ User can edit an event they created
- ☐ User can cancel an event they created
- ☐ User can share an invite link to their event
- ☐ Event appears on the public events page

## Check-In

- ☐ User can tap "I'm Here" at an event
- ☐ User selects their active workspace before checking in
- ☐ User becomes visible to other attendees after check-in
- ☐ User sees a confirmation that they're checked in
- ☐ Presence auto-expires after 60 minutes (renewable)
- ☐ User can tap "I'm Leaving" to check out early
- ☐ Presence expires when the event ends

## Live Discovery

- ☐ User sees a list of other checked-in attendees
- ☐ Each card shows: name, role, company, mutual connections
- ☐ User can tap a card to view the person's profile
- ☐ List updates when people check in or leave

## Connections

- ☐ User can send a connection request from a profile
- ☐ Connection request includes event context
- ☐ Recipient receives a notification
- ☐ Recipient can accept a connection request
- ☐ Recipient can ignore a connection request
- ☐ Connection request expires after 24 hours

## Chat

- ☐ A conversation is auto-created when a connection is accepted
- ☐ Conversation displays the event context (event + venue + date)
- ☐ User can send a text message
- ☐ User can receive a text message
- ☐ Messages are delivered in real time
- ☐ User can see their list of conversations
- ☐ User can open a conversation and see history

## Post-Event

- ☐ Relationships persist after the event ends
- ☐ Conversations persist after the event ends
- ☐ User can see their past events
- ☐ User can see who they connected with at each event
- ☐ Missed networking window works (24h after event end)

## Reliability

- ☐ App doesn't crash during normal usage
- ☐ Loading states shown while data fetches
- ☐ Empty states shown when no data exists
- ☐ Error states shown when something fails
- ☐ Offline doesn't crash the app
- ☐ Form validation prevents invalid submissions
- ☐ Network timeout handled gracefully

## Deployment

- ☐ Development environment works (dev.yugrow.app + api-dev.yugrow.app)
- ☐ Staging environment works (staging.yugrow.app + api-staging.yugrow.app)
- ☐ Production environment works (yugrow.app + api.yugrow.app)
- ☐ Flutter Dev flavor works
- ☐ Flutter Staging flavor works
- ☐ Flutter Production flavor works
- ☐ Databases are separate per environment
- ☐ JWT secrets are separate per environment

---

## Definition of Done

**All items checked** = First Independent Success is possible.

Until then, every unchecked item is a risk that the first meetup fails because of the software, not because of the idea.
