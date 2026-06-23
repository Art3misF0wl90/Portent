# Events & Actors

_Phase 1B work product. The event list is complete; the actor list is the **immediate next step** in the roadmap. This document scaffolds it: events extracted from the needs list, then candidate actors with the L6 actor rules applied._

## External Event List (14)

These are the external stimuli the system must respond to, collected from the `-> triggering event` half of each need. Internal/derived triggers are folded into the external event that causes them.

| # | Event | Source |
|---|-------|--------|
| 1 | User asks for a ticker to be added | User |
| 2 | User makes / records a transaction | User |
| 3 | User asks for the current state of the portfolio | User |
| 4 | A tracked ticker or market condition changes | Market (external data) |
| 5 | User asks a natural-language question | User |
| 6 | User acknowledges / acts on an alert | User |
| 7 | User asks *why* (requests reasoning) | User |
| 8 | User requests a suggestion | User |
| 9 | User requests multiple game plans | User |
| 10 | Configuration is changed | User / Maintainer |
| 11 | A model training run is requested | User / Clock |
| 12 | A data fetch is due | Clock |
| 13 | An external API returns an error / rate-limit response | External Data Provider |
| 14 | A scheduled suggestion sweep is due | Clock |

> Events 1–9 are user-initiated. 12 and 14 are clock-initiated. 4 and 13 originate outside the system at a data provider. This split is exactly what the actor list below falls out of.

---

## Actor List (to derive)

_Per L6, an actor is a role outside the system that interacts with it. Validate every candidate against the five rules:_

1. Actors are **nouns** (roles, not actions).
2. An actor is **never the system itself**.
3. Every actor must appear in **at least one** use case.
4. An actor is a **role**, not a specific person.
5. **Clock** is a valid actor (for time-triggered behavior).

### Candidate actors (from the 14 events)

| Candidate actor | Triggers events | Rule check |
|-----------------|-----------------|------------|
| **User** | 1, 2, 3, 5, 6, 7, 8, 9, 10, 11 | Role, not a person ✓ |
| **Clock** | 12, 14, (11 when scheduled) | Explicitly allowed by rule 5 ✓ |
| **Market Data Provider** | 4 (price/condition data) | External role ✓ — confirm it's distinct from the two below or a generalization of them |
| **Sentiment Data Provider** | feeds suggestions | External role ✓ |
| **Earnings Data Provider** | feeds suggestions / blackout logic | External role ✓ |

> **Open question to resolve:** are the three data providers one actor ("External Data Provider") or three? L6 forbids generalization on the use case *diagram*, but you can still decide at the actor-list level whether they're one role with three sources or three roles. Lean toward whichever makes the use cases cleaner — most likely a single **External Data Provider** actor, since the system treats them uniformly (fetch, cache, throttle, back off).

### Not actors (common traps)

- **The Portfolio / The Audit Trail** — these are *stakeholders* and internal concepts, not external roles that initiate interaction. Keep them out of the actor list.
- **Portent itself** — never an actor (rule 2).

---

## Where this feeds

The validated actor list + the event list drive the **use case diagram** (actors ↔ use cases, system boundary drawn). The roadmap's recommended starting use case is **Onboard Ticker**, because it's the most complex and stress-tests everything upstream.