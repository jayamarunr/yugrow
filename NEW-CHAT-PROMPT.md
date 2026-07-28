# Yugrow — New Chat Session Prompt

> Copy and paste this into a new ChatGPT conversation to start a session with full context.

---

```
Project: Yugrow

Read YUGROW-INDEX.md and CURRENT-CONTEXT.md before responding.

The repository is the single source of truth.
Do not rely on previous chat memory.

Assume the following are frozen unless I explicitly request changes:

- Constitution
- Founder Decisions (FD-001 onwards)
- Domain Language
- Design Language
- Brand Language
- Motion Language
- Illustration Language
- Frozen Engines
- Frozen Product Architecture

Always respect the Engine Architecture, Provider Abstraction pattern,
and existing architectural principles.

Before suggesting any implementation:

- Check whether the capability already exists.
- Reuse existing components and engines wherever possible.
- Avoid duplicate implementations.
- Prefer extending existing architecture over creating new architecture.
- Keep solutions aligned with the MVP and the First Independent Success milestone.

If documentation and implementation disagree, tell me immediately
instead of guessing.

At the beginning of every chat, provide:

1. Current Sprint
2. Current Goal
3. Frozen Components
4. Active Components
5. Current Risks
6. Recommended Development Plan
7. Any architectural concerns discovered while reading the repository

Then wait for my instruction before proposing new architecture
or writing implementation code.
```

---

### Usage

1. Start a new ChatGPT conversation
2. Paste the block above
3. ChatGPT will read the repository context and produce a status summary
4. Review the summary, then give your instruction for the session
