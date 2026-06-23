# Architecture (Target — v3 Draft)

_Phase 2 produces the SAD; this document is a **forward reference**, not a finalized architecture. It records the architectural intent carried out of v1/v2 plus the runtime conventions that are already settled. Per the process, the actual architecture must come from generating 2–3 candidate styles and scoring them — see [`roadmap.md`](roadmap.md) Phase 2B. Do not treat the layering below as chosen-by-default._

## Why there's an architecture section before Phase 2

v1 and v2 already taught two hard lessons that constrain any v3 architecture, so they're recorded now rather than rediscovered later:

1. **Look-ahead bias** in the v1 data split produced artificially high accuracy. Any v3 data/training boundary must make temporal leakage structurally hard.
2. **High coupling / low cohesion** sank v2. The codebase became unreadable and its results untrustworthy. v3's architecture is judged first on whether components can be understood and tested in isolation.

## Candidate layering (draft, carried from v1's refactor)

The v1→v2 refactor landed on a four-layer separation. It's the **leading candidate** going into Phase 2B, not the locked choice.

| Layer | Responsibility |
|-------|----------------|
| **Presentation** | Flask routes, real-time dashboard updates (WebSocket pushes) |
| **Application** | Onboarding pipeline, suggestion engine, alert evaluation/dispatch |
| **Domain** | Signal generation, feature engineering, model training |
| **Data** | Database access, market cache, config store |

Each layer talks to the next through interfaces, so pieces can be tested in isolation and swapped without breaking callers. In the v2 codebase this maps to an `app/` package with `routes/`, `services/`, `ml/`, and `data/` subpackages under a Flask application-factory pattern.

### Architectural styles to score in Phase 2B

The roadmap's style menu, with the Portent-relevant mappings to evaluate (not yet decided):

- **Layered** — overall structure (the four layers above)
- **Pipe-and-Filter** — the onboarding pipeline (fetch → analyze → train → complete)
- **Event-Driven** — the alert evaluation/dispatch system
- **Shared-Data / Blackboard** — the config-and-audit core
- **MVC** — the web app surface

Expect a **heterogeneous** result: no single style fits the whole system.

---

## Settled runtime conventions (carry forward — these are not up for redesign)

These came out of v1 the hard way and must hold in v3.

### The `config.pkl` loading rule

> **All inference must load `feat_cols`, `fwd_days`, and horizons from the saved `{ticker}_config.pkl`, never regenerate them at inference time.**

This exists because per-ticker training artifacts can differ from what a fresh feature-generation call would produce. The canonical example: **TSLA was trained with 57 features** (earnings columns were included even though TSLA is nominally in the no-earnings set), while regenerating features at inference produces 53. Loading from the saved config is the only thing that keeps training and inference in agreement.

The `has_earnings` check should be derived from the saved columns, not from a static ticker list:

```
has_earnings = any('eps' in c or 'pead' in c or 'earnings' in c for c in feat_cols)
```

Every inference path — backtest, daily predict, the chatbot's explain-signal tool, charting — obeys this same rule.

### Per-ticker model isolation

Each ticker trains and stores its own model, config, and metadata. This is both a **correctness** property (the TSLA case above) and a **reliability** property (one ticker's failure can't corrupt another's). Map this to the reliability non-functional requirement in Phase 2B.

### Derived portfolio state

Position state is **always computed from transaction history**, never stored as an independent mutable value. The portfolio can never be set directly into an invalid state because it isn't set at all — it's derived. Validate transactions *before* recording them.

### Config versioning + immutable audit

Config changes are versioned with a written reason, grouped by category with independent counters. The audit trail is append-only: logs are never deleted. These two together make every operationally significant decision reconstructable.

### Macro data join

Macro indicators are refreshed to the present (`end=None`) and joined to price data with forward-then-back fill (`.ffill().bfill()`), so price data extending beyond the macro cache date doesn't produce gaps.

### Data-source interval parameterization

Data-source interfaces should be **interval-parameterized** so that adding intraday later is a clean extension rather than a rewrite — consistent with the "intraday is a future add" scope decision.

---

## Lifecycle state machines (for Phase 2C)

These entities have non-trivial lifecycles and will get state-transition diagrams:

- **Onboarding status:** `PENDING → FETCHING → ANALYZING → TRAINING → COMPLETE / FAILED`
- **Option position:** `OPEN → CLOSED / EXPIRED`
- **Alert delivery:** `PENDING → DELIVERED / FAILED → ACKNOWLEDGED`

---

## Mapping non-functional requirements to structure (Phase 2B task)

L10 calls this the "very important task" — showing *how* each quality attribute is achieved structurally:

| Quality attribute | Achieved by |
|-------------------|-------------|
| Reliability | Per-ticker model isolation |
| Changeability | Config service + interface seams between layers |
| Reusability | High cohesion / loose coupling; onboarding as a reusable unit callable from web/API/cron/CLI |
| Testability | Mockable data-source interfaces; components testable in isolation |