# Stakeholders

_Phase 1A work product. Six interested parties, including the deliberate User → User + User's Financial Position split._

Each stakeholder is a party whose interests the system must protect. Listing them this way keeps later requirements honest: every functional and non-functional requirement should trace back to a stakeholder need.

## User

Wants to onboard tickers, record transactions, query signals, and receive suggestions and alerts through a clear, low-ceremony interface. Needs every recommendation to come with reasoning that can be understood **without machine-learning expertise**.

## User's Financial Position

Every suggestion, alert, and signal interpretation must respect the **intent** (directional, hedge, income) and **direction** (long, short) of each position. Recommendations that undermine a stated strategy must be suppressed or flagged with explicit reasoning.

> This is split out from the User on purpose. Treating the financial position as its own stakeholder is what makes intent-aware reasoning a hard requirement rather than a nice-to-have.

## The Portfolio

Position state must always be **derivable from transaction history**, internally consistent, and never allowed to enter an invalid state.

## Future Maintainer

Wants every architectural decision documented and recoverable. Needs code and configuration that can be understood and extended without re-deriving the project's context from scratch. _(This is a real stakeholder — the README and design docs exist to serve it.)_

## External Data Providers

Market data, sentiment, and earnings endpoints must be accessed within rate limits, responses cached, and data used in accordance with each provider's terms.

## Audit Trail

Every operationally significant decision — configuration change, model accept/reject, suggestion emitted, alert dispatched — must be recorded with enough context for **full reconstruction**. Logs are never deleted.

---

## Stakeholder → primary concern, at a glance

| Stakeholder | Primary concern it protects |
|-------------|-----------------------------|
| User | Understandable interface and reasoning |
| User's Financial Position | Intent-aware, strategy-respecting recommendations |
| The Portfolio | Valid, transaction-derived state |
| Future Maintainer | Documented, recoverable, extensible design |
| External Data Providers | Rate-limited, cached, terms-compliant access |
| Audit Trail | Complete, immutable record of significant decisions |