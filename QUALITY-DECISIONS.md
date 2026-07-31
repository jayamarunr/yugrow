# Quality Decisions

> **Status:** Active
> **Purpose:** Track every intentionally accepted defect or deferred quality improvement.
> **Format:** Each decision gets a QD-XXX identifier.

---

Every time you knowingly accept a defect, defer a fix, or ship with known limitations, record it here.

Six months from now, this answers "Why is this like this?" with "We intentionally deferred it." instead of "I don't know."

---

## QD-001

| Field | Value |
|-------|-------|
| **Date** | 2026-07-30 |
| **Area** | Profile Screen |
| **Issue** | Six buttons show "Coming Soon" |
| **Reason** | Not required for Alpha. Focus on core check-in and networking flow. |
| **Accepted by** | Founder |
| **Review** | After First Meetup |
| **QA Impact** | No automated journey covers these buttons yet |

---

## How to add a Quality Decision

```markdown
## QD-00X

| Field | Value |
|-------|-------|
| **Date** | YYYY-MM-DD |
| **Area** | [Subsystem/Feature affected] |
| **Issue** | [What was accepted] |
| **Reason** | [Why it was acceptable to defer] |
| **Accepted by** | [Founder / Team decision] |
| **Review** | [When to revisit this decision] |
| **QA Impact** | [Which QA journeys are affected, if any] |
```
