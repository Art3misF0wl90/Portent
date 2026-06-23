# Problem-Domain Glossary

_Phase 1B work product (roadmap next step). L5 lists the glossary as a deliverable, and L8 conceptual modeling depends on consistent terms — so these definitions are load-bearing, not decoration. Fill in / refine each as the SRS firms up._

> Convention: define each term as it means **inside Portent's problem domain**, not its general finance meaning, wherever they differ.

## Core entities

**Ticker** — a tradable symbol the system tracks and analyzes (e.g. AAPL). Onboarding a ticker triggers data fetch, feature generation, and per-horizon model training.

**Signal** — a model-produced directional indication (up/down) for a ticker at a given horizon, with an associated confidence. Signals are interpreted *in the context of position intent*, never in isolation.

**Horizon** — the forward time window a signal predicts over. Portent uses multiple horizons (short / medium / long), all computed from **daily** data. Intraday is explicitly out of scope for now.

**Position** — the user's holding in a ticker, derived from transaction history. Has an **intent** and a **direction**.

**Position intent** — the strategic purpose of a position: `DIRECTIONAL`, `HEDGE`, or `INCOME`. Drives whether a given signal supports or conflicts with the user's strategy.

**Position direction** — `long` or `short`.

**Suggestion** — a recommendation emitted to the user, always citing the sentiment, earnings, and signal data behind it. Suppressed or flagged if it conflicts with a position's stated intent.

**Alert** — a notification dispatched when a tracked condition changes. Has a delivery lifecycle (pending → delivered/failed → acknowledged) and must be acknowledgeable so it stops re-notifying.

## Lifecycle / status terms

**Onboarding status** — the state of a ticker moving through the onboarding pipeline: `PENDING → FETCHING → ANALYZING → TRAINING → COMPLETE / FAILED`.

**Macro relevance** — the degree to which macro indicators (e.g. VIX, treasury, dollar) bear on a given ticker's signal interpretation. _(Define the measure precisely before it enters a requirement.)_

## Audit / config terms

**Configuration change** — any modification to a tunable parameter (e.g. VIX ceiling, minimum confidence, AUC margin), versioned with a written reason and grouped by category with an independent version counter.

**Training run** — one model-training execution, versioned with full metadata and recorded in the audit trail.

**Audit record** — an immutable log entry for an operationally significant decision. Never deleted.

---

## Terms still to pin down

- [ ] **Macro relevance** — exact definition and how it's quantified
- [ ] **Confidence** — is it raw model probability, a calibrated score, or a thresholded band?
- [ ] **Multi-horizon meshing** — the rule by which per-horizon signals combine into one suggestion (this is flagged as a *risky part to prototype* in Phase 2A, so its definition matters early)
- [ ] **Data sufficiency** — the one-calendar-year threshold that gates whether a ticker has enough history to train

> Keep this list in sync with the SRS. Any noun that appears in a functional requirement should have an entry here.