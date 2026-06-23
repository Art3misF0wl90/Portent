# Needs List

_Phase 1B work product. 27 needs, intentionally asymmetric by stakeholder. Each need is paired with the event that triggers it — that pairing is what the event list and actor list are derived from._

> Format: `need -> triggering event`

## User Needs

- Add a ticker the system will track and analyze → user asks for a ticker to be added
- Record a transaction the user has made → user makes a transaction
- View current state — signals, positions, suggestions, alerts → user asks for the current state of the portfolio
- Receive alerts when conditions change → a tracked ticker / market condition changes
- Ask questions in natural language and get answers grounded in real system state → user asks a question
- Acknowledge alerts so they stop nagging → user acts on a state change

## User's Financial Needs

- Track each position's intent (directional, hedge, income) so reasoning has context → user asks *why*
- Interpret signals in the context of each position's intent, not in isolation → user needs a suggestion
- Flag or suppress recommendations that conflict with a stated strategy → user asks for multiple game plans
- Express the reason for an intent-aware interpretation when one applies → user asks why the system suggested it

## The Portfolio

- Derive current position state from transaction history → state is requested
- Validate transactions before recording → a transaction happens

## Future Maintainer

- Version every config change with a written reason → configuration is changed
- Version every model training run with full metadata → a model is trained
- Group configuration by category with independent version counters → configuration is updated
- Expose system state through documented interfaces → user asks for documentation

## External Data Providers

- Detect and back off on API errors → API returns a timeout / error
- Throttle API requests → API returns a "too many requests" error
- Schedule data fetches → a data fetch is due
- Cache up-to-date data → data is pulled

## Audit Trail

- Record every configuration change → a config change happens
- Record every training run → a model is trained
- Record all suggestions → a suggestion is generated
- Never delete logs → a log deletion is attempted
- Log every transaction → a transaction is made

---

## Why the asymmetry is correct

Stakeholder need-counts are uneven on purpose. The User and User's Financial Position carry the most needs because they drive the interactive surface; the Audit Trail and Future Maintainer carry fewer but stricter, mostly-invariant needs ("never delete logs"). A flat, balanced list would have hidden that the audit and maintainability concerns are constraints, not features.

## Where this feeds

These 27 needs become the source for:
- **Functional requirements** (the user-facing and system actions)
- **Non-functional requirements** (the throttle / cache / never-delete / documented-interface needs map to availability, reliability, maintainability)
- **Use case stakeholders-and-needs sections** (each use case names the needs it satisfies)