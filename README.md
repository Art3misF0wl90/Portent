# Portent

> An ML-driven decision-support system for personal trading.

Portent onboards tickers, records the user's transactions, generates suggestions, and emits alerts when signals change. Every suggestion cites the sentiment, earnings, and signal data behind it, and every configuration change, model decision, and suggestion is logged for audit. **The system advises decisions; it does not execute trades** — though execution is anticipated as a future capability behind a clean extension point.

---

## Status

**v3 — Phase 1 (Product Design), ~70% complete.** Currently working through the SRS: actor list → glossary → use case model → requirements. No implementation code is being written yet, by design. The lesson from v1 and v2 was that designing properly up front beats refactoring a mess later.

| Version | What it was | Outcome |
|---------|-------------|---------|
| v1 | XGBoost prototype | Proved the concept was tractable; surfaced a look-ahead bias giving artificially high accuracy |
| v2 | Re-split attempt + early redesign | Code grew bloated, high coupling / low cohesion, results untrustworthy — scrapped |
| **v3** | Formal SWE 3633 design process, then build | **In progress** — product design phase |

This repository follows the two-phase design model taught in **SWE 3633 (Design & Architecture)**, with verification governed by **SWE 3643 (Testing & QA)**. See [`docs/roadmap.md`](docs/roadmap.md) for the full phase tracker.

---

## What it does

Portent predicts the **direction** of stock-price movement (up or down) across multiple horizons, rather than guessing exact prices. It is built around a mix of machine-learning models — primarily XGBoost and an LSTM — fed by market data, news sentiment scored by FinBERT, and a set of engineered features. Suggestions are interpreted in the context of each position's stated **intent** (directional, hedge, income) and **direction** (long, short), so a recommendation that undermines a stated strategy is suppressed or flagged with explicit reasoning.

## What it does *not* do

- It does not execute trades (deferred behind an extension point).
- It does not day-trade or consume live intraday feeds (declined in favor of multi-horizon signals on daily data — see scope decisions).

---

## Documentation

The design documentation is split by deliverable so each piece stays single-purpose and reviewable.

| Document | What's in it |
|----------|--------------|
| [`docs/00-mission.md`](docs/00-mission.md) | Mission statement and the locked scope decisions |
| [`docs/01-stakeholders.md`](docs/01-stakeholders.md) | The six interested parties and what each one needs protected |
| [`docs/02-needs.md`](docs/02-needs.md) | The full needs list (27), organized by stakeholder, each paired with its triggering event |
| [`docs/03-events-and-actors.md`](docs/03-events-and-actors.md) | The 14 external events and the actor list derived from them |
| [`docs/04-glossary.md`](docs/04-glossary.md) | Problem-domain terms (ticker, signal, horizon, intent, onboarding status, …) |
| [`docs/architecture.md`](docs/architecture.md) | The four-layer target architecture and the critical runtime conventions carried from v1 |
| [`docs/roadmap.md`](docs/roadmap.md) | The full five-phase project roadmap and current position |

---

## The design process

Phase 1 produces the **SRS** (the *problem*: what and why). Phase 2 produces the **Design Document / SAD** (the *solution*: how). Then Implementation, then Verification.

The single most repeated principle across the process is **generate → evaluate → select, and iterate**: produce multiple candidates, score them, pick the best, loop back if inadequate. This applies especially to the architecture, where 2–3 candidate styles must be scored rather than jumping to the first structure that seems fine.

---

## Tech (target stack, from the prototypes)

Python · XGBoost · LSTM · FinBERT (sentiment) · yfinance (market data) · Flask + WebSocket (dashboard, real-time pushes) · SQLite · Groq / Llama 3.3 70B (grounded chatbot)

> Framed as *what the prototypes used and what the v3 design targets* — not a claim that a running v3 system has all of this today.

---

## Repository

- **Source & design docs:** https://github.com/Art3misF0wl90/Portent
- **Author:** Rory Weldon — CS, Kennesaw State University

---

