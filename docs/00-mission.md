# Mission & Scope

_Phase 1A — Analysis: Design Problem. Governed by L4 (Design Process) and L5 (Product Design)._

## Mission Statement

Portent is an ML-driven decision-support system for personal trading. The system onboards tickers, records the user's transactions, generates suggestions, and emits alerts when signals change. Every suggestion cites sentiment, earnings, and signal data, and every configuration change, model decision, and suggestion is logged for audit. The system advises the user's decisions; it does not execute trades, though execution is anticipated as a future capability.

## Why this scope

The mission is deliberately bounded to **explainable, human-in-the-loop** decision support. Two pressures shaped it: keeping every recommendation defensible without ML expertise, and protecting the user from real-money risk while the system is still being built right. Each scope decision below was made to protect that mission.

## Locked scope decisions

These are settled and carry forward into every later phase. Changing one means revisiting the SRS.

| Decision | Resolution | Rationale |
|----------|------------|-----------|
| Trade execution | **Deferred** behind a clean extension point | Protect the mission; preserve optionality; real-money execution risk is too high for v2/v3 |
| Day trading / live intraday | **Declined** | Fights the "explainable, human-in-loop" mission; would need a paid real-time feed and new models |
| Multi-horizon signals | **Adopted** (short / medium / long, all on daily data) | Richer suggestions, no new event types, cheap to add; intraday remains a clean future extension |
| Options positions | **Distinct** event and use case | Separate lifecycle, fields, and validation from equity |
| Suggestion-engine triggers | User on-demand **and** clock-scheduled | The suggestion logic must be a reusable unit both paths call into |
| User stakeholder | **Split** into User + User's Financial Position | Enables strict intent-aware reasoning |

## Where this feeds

This document is the input to **SRS §1 (Product Description)**: Product Vision, Business Requirements, Users & Stakeholders, Project Scope, Assumptions, and Constraints. Consolidating the above into that §1 form is the remaining open item in Phase 1A.